package enc

import (
	"bytes"
	"encoding/csv"
	"golang.org/x/exp/slices"
	"log"
	"strconv"
	"strings"
)

type CSVMap = map[int]map[string]string
type TableRow map[string]string
type CSVTable map[int][]TableRow

func ReadCSVAsTable(filename string) CSVTable {
	header, rows := ReadCSV(filename)

	idIdx := slices.Index(header, "id")
	if idIdx == -1 {
		panic("id field not exist in " + filename)
	}

	result := CSVTable{}
	for _, row := range rows {
		id, err := strconv.Atoi(row[idIdx])
		if err != nil {
			log.Println(row)
			panic(err)
		}
		data := TableRow{}
		for i := range header {
			if i == idIdx {
				continue
			}
			if i < len(row) {
				data[header[i]] = normalizeCell(row[i])
			} else {
				data[header[i]] = ""
			}
		}
		result[id] = append(result[id], data)
	}
	return result
}

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
				data[header[i]] = normalizeCell(row[i])
			} else {
				data[header[i]] = ""
			}
		}
		result[id] = data
	}
	return result
}

func normalizeCell(s string) string {
	if !strings.Contains(s, `\n`) {
		return s
	}
	hasSlashSlashN := false
	if !strings.Contains(s, `\\n`) {
		hasSlashSlashN = true
		s = strings.ReplaceAll(s, `\\n`, `{slash_slash_n}`)
	}
	s = strings.ReplaceAll(s, `\n`, "\n")
	if hasSlashSlashN {
		s = strings.ReplaceAll(s, `{slash_slash_n}`, `\\n`)
	}
	return s
}

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
