package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/Wing924/d2r-wing/tools/lib/opencc"
	"log"
	"os"
)

var format = flag.String("fmt", "json", "input format (json|plain)")
var inFile = flag.String("in", "-", "input file")

func main() {
	log.SetFlags(0)
	flag.Parse()
	if *inFile == "" {
		fmt.Println("-in is missing")
		flag.Usage()
		os.Exit(1)
	}

	t2s, err := opencc.New("t2s")
	if err != nil {
		panic(err)
	}

	switch *format {
	case "json":
		entries := enc.ReadStringsJSON(*inFile)

		for i, e := range entries {
			txt, err := t2s.Convert(e.ZhTW)
			if err != nil {
				panic(err)
			}
			e.ZhTW = txt
			entries[i] = e
		}

		out, err := json.MarshalIndent(entries, "", "  ")
		if err != nil {
			panic(err)
		}
		fmt.Println(string(out))
	case "plain":
		content := enc.ReadFileWithBOM(*inFile)
		sc, err := t2s.Convert(string(content))
		if err != nil {
			panic(err)
		}
		fmt.Println(sc)
	}
}
