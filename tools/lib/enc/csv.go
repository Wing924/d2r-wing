package enc

import (
	"encoding/csv"
	"errors"
	"golang.org/x/exp/slices"
	"io"
	"os"
	"strconv"
)

func ReadCSV(filename, valueColName string) map[int]string {
	f, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	r := csv.NewReader(f)
	r.ReuseRecord = true

	header, err := r.Read()
	if err != nil {
		panic(err)
	}
	idIdx := slices.Index(header, "id")
	if idIdx < 0 {
		panic("cannot find column id in CSV")
	}
	valueIdx := slices.Index(header, valueColName)
	if valueIdx < 0 {
		panic("cannot find column " + valueColName + " in CSV")
	}

	result := map[int]string{}
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
		result[id] = row[valueIdx]
	}
	return result
}
