package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path"
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
	itemColor    = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-color.csv"))
	itemGrade    = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-grade.csv"))
	itemMax      = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-max.csv"))
	itemRare     = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-rare.csv"))
	itemSocket   = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-socket.csv"))
	itemWeight   = enc.ReadCSVAsMap(path.Join(resourcesDir, "item-weight.csv"))
	propsAbbrv   = enc.ReadCSVAsMap(path.Join(resourcesDir, "props-abbrv.csv"))
	textRename   = enc.ReadCSVAsMap(path.Join(resourcesDir, "text-rename.csv"))
	textSuffixes = enc.ReadCSVAsMap(path.Join(resourcesDir, "text-suffixes.csv"))
	levels       = enc.ReadCSVAsMap(path.Join(resourcesDir, "levels.csv"))
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
	content := enc.ReadFileWithBOM(filename)
	entries := enc.ParseStringsJson(content)
	for i, e := range entries {
		oldZhTW := e.ZhTW
		e = processText(e)
		e = processItem(e)
		e = processLevels(e)
		if oldZhTW != e.ZhTW {
			log.Printf("Replace string: %d %q -> %q", e.ID, oldZhTW, e.ZhTW)
		}
		entries[i] = e
	}
	return entries
}

func processItem(e model.Entry) model.Entry {
	var extraTxt1 string
	var extraTxt2 string

	// add grade
	if g, ok := itemGrade[e.ID]; ok {
		extraTxt1 += g["grade"]
	}

	// add armor weight
	if w, ok := itemWeight[e.ID]; ok {
		extraTxt1 += w["weight"]
	}

	// add rare
	if r, ok := itemRare[e.ID]; ok {
		switch r["rarity"] {
		case "1":
			extraTxt1 += "☆"
		case "2":
			extraTxt1 += "★"
		case "3":
			extraTxt2 += "★" + r["type"] + "★"
		default:
			panic("unsupported rarity:" + r["rarity"])
		}
	}

	// add socket if #socket >= 3
	if grade, ok := itemGrade[e.ID]; ok && grade["grade"] == "精" {
		if s, ok := itemSocket[e.ID]; ok {
			switch s["socket"] {
			case "3":
				extraTxt1 += " ③"
			case "4":
				extraTxt1 += " ④"
			case "5":
				extraTxt1 += " ⑤"
			case "6":
				extraTxt1 += " ⑥"
			}
		}
	}

	// add max
	if m, ok := itemMax[e.ID]; ok {
		extraTxt2 += "[" + m["max"] + "]"
	}

	if extraTxt1 != "" {
		e.ZhTW += "|" + extraTxt1
	}
	if extraTxt2 != "" {
		e.ZhTW += "\n" + extraTxt2
	}

	// change color
	if item, ok := itemColor[e.ID]; ok {
		newColor, ok := colorPalette[item["new_color"]]
		if !ok {
			panic("unknown color: " + item["new_color"])
		}
		e.ZhTW = fmt.Sprint(newColor, e.ZhTW, colorWhite)
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
	if item, ok := textRename[e.ID]; ok {
		e.ZhTW = item["new_name"]
	}

	// add suffixes
	if item, ok := textSuffixes[e.ID]; ok {
		e.ZhTW += item["suffix"]
	}
	return e
}

func processLevels(e model.Entry) model.Entry {
	if item, ok := levels[e.ID]; ok {
		e.ZhTW += fmt.Sprintf(" [%s|%s|%s]", item["normal"], item["nightmare"], item["hell"])
	}
	return e
}
