package main

import (
	"fmt"
	"github.com/Masterminds/sprig/v3"
	"strings"
	"text/template"
	"unicode"
)

func CreateFuncs() template.FuncMap {
	funcs := sprig.HermeticTxtFuncMap()
	funcs["mkAbbr"] = mkAbbr
	return funcs
}

func mkAbbr(text string, abbr string) string {
	if idx := strings.IndexAny(text, "：，"); idx >= 0 {
		return fmt.Sprint(text[0:idx], "(", abbr+")", text[idx:])
	} else {
		runes := []rune(text)
		for i := len(runes) - 1; i >= 0; i-- {
			if unicode.In(runes[i], unicode.Han) {
				return fmt.Sprint(string(runes[0:i+1]), "(", abbr+")", string(runes[i+1:]))
			}
		}
	}
	return text
}
