package main

import (
	"encoding/json"
	"flag"
	"log"
	"os"
	"path/filepath"

	"github.com/Wing924/d2r-wing/tools/lib/enc"
)

var (
	jsonFile = flag.String("json", "", "string JSON file")
	csvFile  = flag.String("csv", "", "csv file to join")
	onCSV    = flag.String("on-csv", "", "join field in CSV")
	onJSON   = flag.String("on-json", "", "join field in JSON")
)

func main() {
	log.SetFlags(0)
	flag.Parse()
	validateFlags()

	log.Println("will run like: SELECT * FROM", filepath.Base(*jsonFile), "j JOIN", filepath.Base(*csvFile), "c ON j."+*onJSON, "= c."+*onCSV)

	csvContent := enc.ReadCSVAsTable(*csvFile)
	csvMap := make(map[string]map[string]string, len(csvContent))
	for _, data := range csvContent {
		csvMap[data[*onCSV]] = data
	}

	jsonContent := enc.ReadStringsJSON(*jsonFile)

	var result []map[string]any
	for _, jsonData := range jsonContent {
		jsonField := jsonData.Get(*onJSON)
		csvData, ok := csvMap[jsonField]
		//log.Println("join", ok, jsonData.Key, jsonData.ZhTW)
		if !ok {
			continue
		}
		m := jsonData.AsMap()
		for k, v := range csvData {
			m[k] = v
		}
		result = append(result, m)
	}

	if err := json.NewEncoder(os.Stdout).Encode(result); err != nil {
		panic(err)
	}
}

func validateFlags() {
	hasError := false
	if *jsonFile == "" {
		log.Println("-json is missing")
		hasError = true
	}
	if *csvFile == "" {
		log.Println("-csv is missing")
		hasError = true
	}
	if *onCSV == "" {
		log.Println("-on-csv is missing")
		hasError = true
	}
	if *onJSON == "" {
		log.Println("-on-json is missing")
		hasError = true
	}

	if hasError {
		flag.Usage()
		os.Exit(1)
	}
}
