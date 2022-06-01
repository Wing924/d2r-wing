package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/longbridgeapp/opencc"
	"log"
	"os"
)

var inFile = flag.String("in", "-", "input string JOSN file")

func main() {
	log.SetFlags(0)
	flag.Parse()
	if *inFile == "" {
		fmt.Println("-in is missing")
		flag.Usage()
		os.Exit(1)
	}

	entries := enc.ReadStringsJSON(*inFile)

	t2s, err := opencc.New("t2s")
	if err != nil {
		panic(err)
	}

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
}
