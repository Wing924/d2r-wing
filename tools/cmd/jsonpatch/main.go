package main

import (
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"os"

	jsonpatch "github.com/evanphx/json-patch/v5"
)

func main() {
	if len(os.Args) <= 2 {
		_, _ = fmt.Fprintln(os.Stderr, "usage:", os.Args[0], "<json-file> <json-patch-file>")
		os.Exit(1)
	}
	jsonFile := os.Args[1]
	jsonPatchFile := os.Args[2]

	jsonContent := enc.ReadFileWithBOM(jsonFile)
	jsonPatchContent := enc.ReadFileWithBOM(jsonPatchFile)

	patch, err := jsonpatch.DecodePatch(jsonPatchContent)
	if err != nil {
		panic(err)
	}

	merged, err := patch.Apply(jsonContent)
	if err != nil {
		panic(err)
	}
	fmt.Println(string(merged))
}
