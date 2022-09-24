package main

import (
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/tailscale/hujson"
)

func main() {
	content := enc.ReadFileWithBOM("-")
	content, err := hujson.Standardize(content)
	if err != nil {
		panic(err)
	}
	fmt.Println(string(content))
}
