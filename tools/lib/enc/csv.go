package enc

import (
	"bytes"
	"encoding/csv"
	"errors"
	"golang.org/x/exp/slices"
	"io"
	"os"
	"strconv"
)

func ReadCSVAsMap(filename string) map[int]map[string]string {
	f, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	r := csv.NewReader(f)

	header, err := r.Read()
	if err != nil {
		panic(err)
	}
	idIdx := slices.Index(header, "id")
	if idIdx < 0 {
		panic("cannot find column id in CSV")
	}

	result := map[int]map[string]string{}
	for {
		row, err := r.Read()
		if err != nil {
			if errors.Is(err, io.EOF) {
				break
			}
			panic(err)
		}
		id, err := strconv.Atoi(row[idIdx])
		if err != nil {
			panic(err)
		}
		result[id] = rowToMap(header, row)
	}
	return result
}

func ReadCSVAsTable(filename string) []map[string]string {
	content := ReadFileWithBOM(filename)

	lfIdx := bytes.IndexByte(content, '\n')
	if lfIdx < 0 {
		panic("invalid CSV file: no header")
	}

	reader := csv.NewReader(bytes.NewBuffer(content))
	if bytes.IndexByte(content[0:lfIdx], '\t') >= 0 {
		reader.Comma = '\t'
	}

	header, err := reader.Read()
	if err != nil {
		panic(err)
	}

	var result []map[string]string
	for {
		row, err := reader.Read()
		if err != nil {
			if errors.Is(err, io.EOF) {
				break
			}
			panic(err)
		}
		result = append(result, rowToMap(header, row))
	}
	return result
}

func rowToMap(header, row []string) map[string]string {
	data := make(map[string]string, len(header))
	for i, v := range header {
		data[v] = row[i]
	}
	return data
}
