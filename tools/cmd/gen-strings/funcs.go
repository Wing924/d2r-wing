package main

import (
	"fmt"
	"github.com/Masterminds/sprig/v3"
	"github.com/Wing924/d2r-wing/tools/lib/model"
	"regexp"
	"strconv"
	"strings"
	"text/template"
	"unicode"
)

func CreateFuncs(entries []model.Entry) template.FuncMap {
	funcs := sprig.HermeticTxtFuncMap()
	funcs["mkAbbr"] = mkAbbr
	funcs["lookupString"] = lookupString(entries)
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

var reInline = regexp.MustCompile(`\$\{\d+:[^}]+}`)

func lookupString(entries []model.Entry) func(str string) string {
	table := map[int]string{}
	for _, e := range entries {
		table[e.ID] = e.ZhTW
	}
	return func(str string) string {
		return reInline.ReplaceAllStringFunc(str, func(s string) string {
			idx := strings.IndexRune(s, ':')
			idStr := s[2:idx]
			id, err := strconv.Atoi(idStr)
			if err != nil {
				panic(err)
			}
			if v, ok := table[id]; ok {
				return v
			}
			panic("cannot lookup by id: " + idStr)
		})
	}
}
