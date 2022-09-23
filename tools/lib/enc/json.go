package enc

import (
	"encoding/json"
	"github.com/Wing924/d2r-wing/tools/lib/model"
	"github.com/tailscale/hujson"
)

func ReadStringsJSON(filename string) []model.Entry {
	content := ReadFileWithBOM(filename)
	var err error
	content, err = hujson.Standardize(content)
	if err != nil {
		panic(err)
	}
	var result []model.Entry
	if err := json.Unmarshal(content, &result); err != nil {
		panic(err)
	}
	return result
}
