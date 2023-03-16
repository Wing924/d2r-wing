package main

import (
	"encoding/json"
	"flag"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/Wing924/d2r-wing/tools/lib/model"
	"golang.org/x/exp/slices"
	"log"
	"os"
	"path/filepath"
	"sort"
)

var (
	dir = flag.String("dir", "", "strings json directory")
)

func main() {
	flag.Parse()

	jsonFiles, err := filepath.Glob(filepath.Join(*dir, "*.json"))
	if err != nil {
		panic(err)
	}
	sort.Strings(jsonFiles)
	maxID := 0

	entriesMap := map[string][]model.Entry{}
	for _, filename := range jsonFiles {
		log.Println("scan", filename)
		entries := enc.ReadStringsJSON(filename)
		entriesMap[filename] = entries

		for _, entry := range entries {
			if entry.ID > maxID {
				maxID = entry.ID
			}
		}
	}

	nextID := calcNextID(maxID)
	log.Println("max ID =", maxID, "next ID =", nextID)

	//for filename, entries := range entriesMap {
	for _, filename := range jsonFiles {
		entries := entriesMap[filename]
		changed := false
		for i, entry := range entries {
			if entry.ID < 0 {
				entries[i].ID = nextID
				nextID++
				changed = true
			}
		}
		if changed {
			slices.SortFunc(entries, func(a, b model.Entry) bool {
				return a.ID < b.ID
			})
			log.Println("update file:", filename)
			writeJson(filename, entries)
		}
	}
}

func writeJson(filename string, entries []model.Entry) {
	f, err := os.OpenFile(filename, os.O_WRONLY, 0x644)
	if err != nil {
		panic(err)
	}
	defer func() {
		if err := f.Close(); err != nil {
			panic(err)
		}
	}()
	encoder := json.NewEncoder(f)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(entries); err != nil {
		panic(err)
	}
}

func calcNextID(id int) int {
	return (id/1000 + 1) * 1000
}
