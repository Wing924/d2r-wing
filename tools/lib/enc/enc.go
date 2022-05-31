package enc

import (
	"bytes"
	"io"
	"os"
)

func ReadFileWithBOM(filename string) []byte {
	var (
		content []byte
		err     error
	)

	if filename == "-" {
		content, err = io.ReadAll(os.Stdin)
	} else {
		content, err = os.ReadFile(filename)
	}
	if err != nil {
		panic(err)
	}
	content = bytes.TrimPrefix(content, []byte("\xef\xbb\xbf"))
	return content
}
