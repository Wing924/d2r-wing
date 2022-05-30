package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path"
	"path/filepath"
)

type (
	StringFile struct {
		Name    string
		Entries []Entry
	}
	Entry struct {
		ID   int    `json:"id,omitempty"`
		Key  string `json:"Key,omitempty"`
		ZhTW string `json:"zhTW,omitempty"`
	}
	Diff struct {
		File    string `json:"file"`
		ID      int    `json:"id"`
		Key     string `json:"key"`
		OldZhTW string `json:"old_zhTW"`
		NewZhTW string `json:"new_zhTW"`
	}
)

var (
	baseDir               = topGitRepo()
	stringsFilesDir       = baseDir + "/origin/data/local/lng/strings"
	stringsLegacyFilesDir = baseDir + "/origin/data/local/lng/strings-legacy"
)

func main() {
	stringsFiles := globFiles(stringsFilesDir + "/*.json")
	stringsLegacyFiles := globFiles(stringsLegacyFilesDir + "/*.json")

	commonFiles := findCommonFiles(stringsFiles, stringsLegacyFiles)

	var diffs []Diff

	for _, f := range commonFiles {
		legacy := readJson(path.Join(stringsLegacyFilesDir, f))
		modern := readJson(path.Join(stringsFilesDir, f))
		diff := findDiff(f, legacy, modern)
		diffs = append(diffs, diff...)
	}

	fmt.Println("[")
	for i, d := range diffs {
		out, err := json.Marshal(d)
		if err != nil {
			panic(err)
		}
		eol := ","
		if i == len(diffs)-1 {
			eol = ""
		}
		fmt.Printf("  %s%s\n", string(out), eol)
	}
	fmt.Println("]")
}

func findDiff(filename string, legacy, modern StringFile) []Diff {
	var diff []Diff

	entryMap := map[int]Entry{}
	for _, e := range modern.Entries {
		entryMap[e.ID] = e
	}
	for _, e := range legacy.Entries {
		modernEntry, ok := entryMap[e.ID]
		if !ok {
			continue
		}
		if e.ZhTW != modernEntry.ZhTW {
			diff = append(diff, Diff{
				File:    filename,
				ID:      e.ID,
				Key:     e.Key,
				OldZhTW: e.ZhTW,
				NewZhTW: modernEntry.ZhTW,
			})
		}
	}
	return diff
}

func findCommonFiles(files1 []string, files2 []string) []string {
	var commonFiles []string
	fileMap := map[string]string{}
	for _, f := range files1 {
		fileMap[path.Base(f)] = f
	}
	for _, f := range files2 {
		filename := path.Base(f)
		if _, ok := fileMap[filename]; ok {
			commonFiles = append(commonFiles, filename)
		}
	}
	return commonFiles
}

func readJson(filepath string) StringFile {
	content, err := os.ReadFile(filepath)
	if err != nil {
		panic(err)
	}
	content = bytes.TrimPrefix(content, []byte("\xef\xbb\xbf")) // remove BOM
	result := StringFile{Name: path.Base(filepath)}
	if err := json.Unmarshal(content, &result.Entries); err != nil {
		panic(err)
	}
	return result
}

func topGitRepo() string {
	cmd := exec.Command("git", "rev-parse", "--show-toplevel")
	out, err := cmd.Output()
	if err != nil {
		panic(err)
	}
	return string(bytes.TrimSpace(out))
}

func globFiles(pattern string) []string {
	result, err := filepath.Glob(pattern)
	if err != nil {
		panic(err)
	}
	for i, v := range result {
		result[i] = filepath.ToSlash(v)
	}
	return result
}
