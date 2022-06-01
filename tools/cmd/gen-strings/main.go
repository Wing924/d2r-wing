package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path"
	"strconv"
	"strings"
	"unicode"

	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/Wing924/d2r-wing/tools/lib/model"
	"github.com/Wing924/d2r-wing/tools/lib/utils"
)

const (
	colorWhite = "ÿc0"
	colorRed   = "ÿc1"
	colorGray  = "ÿc5"
	colorPink  = "ÿc;"
)

var colorPalette = map[string]string{
	"white": colorWhite,
	"red":   colorRed,
	"gray":  colorGray,
	"pink":  colorPink,
}

var (
	baseDir      = utils.TopGitRepo()
	resourcesDir = path.Join(baseDir, "resources")
)
var inFile = flag.String("in", "-", "input string JOSN file")

var (
	itemArmor    = enc.ReadCSVAsMap(path.Join(resourcesDir, "generated", "armor.tsv"))
	itemWeapons  = enc.ReadCSVAsMap(path.Join(resourcesDir, "generated", "weapons.tsv"))
	levels       = enc.ReadCSVAsMap(path.Join(resourcesDir, "generated", "levels.tsv"))
	itemMax      = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-max.csv"))
	itemRareBase = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-rare-base.csv"))
	itemRareUniq = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-rare-uniq.csv"))
	itemRunes    = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-runes.csv"))
	itemModify   = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-modify.csv"))
	propsAbbrv   = enc.ReadCSVAsMap(path.Join(resourcesDir, "props-abbrv.csv"))
	textModify   = enc.ReadCSVAsMap(path.Join(resourcesDir, "text-modify.csv"))
)

func main() {
	log.SetFlags(0)
	flag.Parse()
	if *inFile == "" {
		fmt.Println("-in is missing")
		flag.Usage()
		os.Exit(1)
	}

	entries := processFile(*inFile)
	out, err := json.MarshalIndent(entries, "", "  ")
	if err != nil {
		panic(err)
	}
	fmt.Println(string(out))
}

func processFile(filename string) []model.Entry {
	entries := enc.ReadStringsJSON(filename)
	for i, e := range entries {
		oldZhTW := e.ZhTW
		e = processText(e)
		e = processItem(e)
		e = processRunes(e)
		e = processLevels(e)
		if oldZhTW != e.ZhTW {
			log.Printf("Replace string: %d %q -> %q", e.ID, oldZhTW, e.ZhTW)
		}
		entries[i] = e
	}
	return entries
}

func processItem(e model.Entry) model.Entry {
	var (
		txtDesc        string
		txtGradeWeight string
		txtRarity      string
		txtSocket      string
		txtMax         string
	)

	if armor, ok := itemArmor[e.ID]; ok {
		txtGradeWeight = armor["grade"] + armor["weight"]
		txtSocket = socketString(armor["socket"], 3)
	}

	if weapon, ok := itemWeapons[e.ID]; ok {
		txtGradeWeight = weapon["grade"]
		txtSocket = socketString(weapon["socket"], 4)
	}

	// add rare
	if r, ok := itemRareBase[e.ID]; ok {
		switch r["rarity"] {
		case "1":
			txtRarity = "☆"
		case "2":
			txtRarity = "★"
		default:
			panic("unsupported rarity:" + r["rarity"])
		}
	}
	if r, ok := itemRareUniq[e.ID]; ok {
		txtDesc = "★" + r["desc"] + "★"
	}

	// add max
	if m, ok := itemMax[e.ID]; ok {
		txtMax = "[" + m["max"] + "]"
	}

	if item, ok := itemModify[e.ID]; ok {
		e.ZhTW = modifyText(e.ZhTW, item["prefix"], item["new_name"], item["suffix"])
	}

	if txtMax != "" {
		e.ZhTW = txtMax + "\n" + e.ZhTW
	}
	if txtGradeWeight != "" || txtRarity != "" {
		e.ZhTW += "|" + txtGradeWeight + txtRarity
		if txtSocket != "" {
			e.ZhTW += " " + txtSocket
		}
	}
	if txtDesc != "" {
		e.ZhTW += "\n" + txtDesc
	}

	// change color
	if item, ok := itemModify[e.ID]; ok && item["color"] != "" {
		newColor, ok := colorPalette[item["color"]]
		if !ok {
			panic("unknown color: " + item["color"])
		}
		e.ZhTW = fmt.Sprint(newColor, e.ZhTW, colorWhite)
	}

	return e
}

func processRunes(e model.Entry) model.Entry {
	if item, ok := itemRunes[e.ID]; ok {
		var txt string
		if strings.HasSuffix(e.Key, "L") {
			txt = fmt.Sprintf("%s#%s", e.ZhTW, item["number"])
		} else {
			txt = fmt.Sprintf("%sÿc2#%sÿc8", e.ZhTW, item["number"])
			if recipe := item["recipe"]; recipe != "" {
				txt = fmt.Sprintf("ÿc5[%sÿc5]\nÿc8%s", recipe, txt)
			}
		}
		e.ZhTW = txt
	}
	return e
}

func processText(e model.Entry) model.Entry {
	// abbrv
	if item, ok := propsAbbrv[e.ID]; ok {
		if idx := strings.IndexAny(e.ZhTW, "：，"); idx >= 0 {
			e.ZhTW = fmt.Sprint(e.ZhTW[0:idx], "(", item["abbrv"]+")", e.ZhTW[idx:])
		} else {
			runes := []rune(e.ZhTW)
			for i := len(runes) - 1; i >= 0; i-- {
				if unicode.In(runes[i], unicode.Han) {
					e.ZhTW = fmt.Sprint(string(runes[0:i+1]), "(", item["abbrv"]+")", string(runes[i+1:]))
					break
				}
			}
		}
	}

	// rename
	if item, ok := textModify[e.ID]; ok {
		e.ZhTW = modifyText(e.ZhTW, item["prefix"], item["new_name"], item["suffix"])
	}
	return e
}

func processLevels(e model.Entry) model.Entry {
	if item, ok := levels[e.ID]; ok {
		e.ZhTW += fmt.Sprintf(" [%s|%s|%s]", item["normal"], item["nightmare"], item["hell"])
	}
	return e
}

func modifyText(original, prefix, newName, suffix string) string {
	switch newName {
	case "":
		newName = original
	case "(null)":
		newName = ""
	}
	return prefix + newName + suffix
}

func socketString(socket string, min int) string {
	if socket == "" {
		return ""
	}
	n, err := strconv.Atoi(socket)
	if err != nil {
		panic(err)
	}
	if n < min {
		return ""
	}
	switch n {
	case 3:
		return "③"
	case 4:
		return "④"
	case 5:
		return "⑤"
	case 6:
		return "⑥"
	default:
		panic("unsupported socket: " + socket)
	}
}
