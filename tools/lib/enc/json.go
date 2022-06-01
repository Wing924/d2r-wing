package enc

import (
	"encoding/json"
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
	var result []model.Entry
	if err := json.Unmarshal(content, &result); err != nil {
		panic(err)
	}
	return result
}
