package enc

import (
	"bytes"
	"encoding/csv"
	"errors"
	"io"
	"strconv"
)

func ReadCSVAsMap(filename string) map[int]map[string]string {
	rows := ReadCSVAsTable(filename)

	result := map[int]map[string]string{}
	for _, row := range rows {
		id, err := strconv.Atoi(row["id"])
		if err != nil {
			panic(err)
		}
		result[id] = row
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
