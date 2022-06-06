package enc

import (
	"bytes"
	"encoding/csv"
	"golang.org/x/exp/slices"
	"log"
	"strconv"
)

type CSVMap = map[int]map[string]string

func ReadCSVAsMap(filename string) CSVMap {
	header, rows := ReadCSV(filename)

	idIdx := slices.Index(header, "id")
	if idIdx == -1 {
		panic("id field not exist in " + filename)
	}

	result := map[int]map[string]string{}
	for _, row := range rows {
		id, err := strconv.Atoi(row[idIdx])
		if err != nil {
			log.Println(row)
			panic(err)
		}
		data := map[string]string{}
		for i := range header {
			if i == idIdx {
				continue
			}
			if i < len(row) {
				data[header[i]] = row[i]
			} else {
				data[header[i]] = ""
			}
		}
		result[id] = data
	}
	return result
}

//func ReadCSVAsTable(filename string) []map[string]string {
//	content := ReadFileWithBOM(filename)
//
//	lfIdx := bytes.IndexByte(content, '\n')
//	if lfIdx < 0 {
//		panic("invalid CSV file: no header")
//	}
//
//	reader := csv.NewReader(bytes.NewBuffer(content))
//	reader.FieldsPerRecord = -1
//	if bytes.IndexByte(content[0:lfIdx], '\t') >= 0 {
//		reader.Comma = '\t'
//	}
//
//	header, err := reader.Read()
//	if err != nil {
//		panic(err)
//	}
//
//	var result []map[string]string
//	for {
//		row, err := reader.Read()
//		if err != nil {
//			if errors.Is(err, io.EOF) {
//				break
//			}
//			panic(err)
//		}
//		result = append(result, rowToMap(header, row))
//	}
//	return result
//}

func ReadCSV(filename string) (header []string, body [][]string) {
	content := ReadFileWithBOM(filename)

	lfIdx := bytes.IndexByte(content, '\n')
	if lfIdx < 0 {
		panic("invalid CSV file: no header")
	}

	reader := csv.NewReader(bytes.NewBuffer(content))
	reader.FieldsPerRecord = -1
	if bytes.IndexByte(content[0:lfIdx], '\t') >= 0 {
		reader.Comma = '\t'
	}

	header, err := reader.Read()
	if err != nil {
		panic(err)
	}
	body, err = reader.ReadAll()
	if err != nil {
		panic(err)
	}
	return header, body
}

func rowToMap(header, row []string) map[string]string {
	data := make(map[string]string, len(header))
	for i, v := range header {
		if i < len(row) {
			data[v] = row[i]
		} else {
			data[v] = ""
		}
	}
	return data
}
