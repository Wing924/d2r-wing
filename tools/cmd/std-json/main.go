package main

import (
	"fmt"
	"io"
	"os"

	"github.com/tailscale/hujson"
)

func main() {
	content, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}
	content, err = hujson.Standardize(content)
	if err != nil {
		panic(err)
	}
	fmt.Println(string(content))
}
