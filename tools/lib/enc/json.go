package enc

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/model"
)

func ReadStringsJSON(filename string) []model.Entry {
	content := ReadFileWithBOM(filename)
	var result []model.Entry
	if err := json.Unmarshal(content, &result); err != nil {
		panic(err)
	}
	return result
}

func ParseStringsJson(content []byte) []model.Entry {
	content = bytes.TrimPrefix(content, []byte("\xef\xbb\xbf")) // remove BOM
	var result []model.Entry
	if err := json.Unmarshal(content, &result); err != nil {
		panic(err)
	}
	return result
}

func PrintJsonArray[T any](list []T) {
	fmt.Println("[")
	for i, d := range list {
		out, err := json.Marshal(d)
		if err != nil {
			panic(err)
		}
		eol := ","
		if i == len(list)-1 {
			eol = ""
		}
		fmt.Printf("  %s%s\n", string(out), eol)
	}
	fmt.Println("]")
}
