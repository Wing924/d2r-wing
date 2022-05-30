package main

import (
	"bytes"
	"encoding/csv"
	"errors"
	"flag"
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/Wing924/d2r-wing/tools/lib/model"
	"io"
	"os"
)

var (
	input  = flag.String("in", "", "input string file")
	filter = flag.String("filter", "", "filter file")
	col    = flag.String("col", "", "filter column")
	field  = flag.String("field", "", "match field")
)

func main() {
	flag.Parse()
	validateFlags()

	keys := readFilterCSV(*filter, *col)
	entries := readInput(*input)

	var matched []model.Entry

	for _, e := range entries {
		var value string
		switch *field {
		case "enUS":
			value = e.EnUS
		case "zhTW":
			value = e.ZhTW
		case "Key":
			value = e.Key
		default:
			panic("unknown field")
		}
		for _, key := range keys {
			if key == value {
				matched = append(matched, e)
				break
			}
		}
	}
	enc.PrintJsonArray(matched)
}

func validateFlags() {
	hasError := false
	if *input == "" {
		fmt.Println("input is missing")
		hasError = true
	}
	if *filter == "" {
		fmt.Println("filter is missing")
		hasError = true
	}
	if *col == "" {
		fmt.Println("col is missing")
		hasError = true
	}
	if *field == "" {
		fmt.Println("field is missing")
		hasError = true
	}

	if hasError {
		flag.Usage()
		os.Exit(1)
	}
}

func readInput(in string) []model.Entry {
	return enc.ParseStringsJson(enc.ReadFileWithBOM(in))
}

func readFilterCSV(filterFile, colName string) []string {
	content := enc.ReadFileWithBOM(filterFile)
	r := csv.NewReader(bytes.NewBuffer(content))
	r.ReuseRecord = true
	header, err := r.Read()
	if err != nil {
		panic(err)
	}
	colIdx := -1
	for i, v := range header {
		if v == colName {
			colIdx = i
		}
	}
	if colIdx < 0 {
		panic("cannot find column in CSV")
	}
	var result []string
	for {
		row, err := r.Read()
		if err != nil {
			if errors.Is(err, io.EOF) {
				break
			}
			panic(err)
		}
		result = append(result, row[colIdx])
	}
	return result
}
