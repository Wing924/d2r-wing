package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/Wing924/d2r-wing/tools/lib/model"
	"github.com/Wing924/d2r-wing/tools/lib/utils"
	"os"
	"path"
)

var (
	baseDir      = utils.TopGitRepo()
	resourcesDir = path.Join(baseDir, "resources")
	stringsDir   = path.Join(baseDir, "origin/data/local/lng/strings")
	files        = []string{
		//"item-gems.json",
		//"item-modifiers.json",
		//"item-nameaffixes.json",
		"item-names.json",
		//"levels.json",
		//"ui.json",
	}
)
var outDir = flag.String("out", "", "output directory")

var (
	grade  map[int]string
	weight map[int]string
	rare   map[int]string
	max    map[int]string
)

func main() {
	flag.Parse()
	if *outDir == "" {
		fmt.Println("out is missing")
		flag.Usage()
		os.Exit(1)
	}

	loadResources()

	for _, filename := range files {
		entries := processFile(filename)
		out, err := json.MarshalIndent(entries, "", "  ")
		if err != nil {
			panic(err)
		}
		fmt.Println(string(out))
	}
}

func loadResources() {
	grade = enc.ReadCSV(path.Join(resourcesDir, "grade.csv"), "grade")
	weight = enc.ReadCSV(path.Join(resourcesDir, "weight.csv"), "weight")
	rare = enc.ReadCSV(path.Join(resourcesDir, "rare.csv"), "type")
	max = enc.ReadCSV(path.Join(resourcesDir, "max.csv"), "max")
}

func processFile(filename string) []model.Entry {
	content := enc.ReadFileWithBOM(path.Join(stringsDir, filename))
	entries := enc.ParseStringsJson(content)
	for i, e := range entries {
		e = processBaseItem(e)
		entries[i] = e
	}
	return entries
}

func processBaseItem(e model.Entry) model.Entry {
	var extraTxt1 string
	var extraTxt2 string
	if g, ok := grade[e.ID]; ok {
		extraTxt1 += g
	}
	if w, ok := weight[e.ID]; ok {
		extraTxt1 += w
	}
	if r, ok := rare[e.ID]; ok {
		switch r {
		case "tc87":
			extraTxt1 += "★"
		case "tc84":
			extraTxt1 += "☆"
		default:
			extraTxt2 += "★" + r + "★"
		}
	}
	if m, ok := max[e.ID]; ok {
		extraTxt2 += "[MAX:" + m + "]"
	}

	if extraTxt1 != "" {
		e.ZhTW += "|" + extraTxt1
	}
	if extraTxt2 != "" {
		e.ZhTW += "\n" + extraTxt2
	}

	return e
}
