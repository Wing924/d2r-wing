package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/Wing924/d2r-wing/tools/lib/model"
	"go.uber.org/zap"
	"golang.org/x/exp/slices"
	"os"
	"text/template"
)

var (
	config = flag.String("config", "", "config file")
	debug  = flag.Bool("debug", false, "debug mode")
)

var logger *zap.SugaredLogger

func main() {
	flag.Parse()
	if *config == "" {
		_, _ = fmt.Fprintf(os.Stderr, "The flag -config is missing.")
		flag.Usage()
		os.Exit(1)
	}
	logger = newLogger()
	defer func() { _ = logger.Sync() }()

	entries := enc.ReadStringsJSON("-")
	cfg := LoadConfig(*config)
	entries = processPipeline(entries, cfg)
	slices.SortFunc(entries, func(a, b model.Entry) bool {
		return a.ID < b.ID
	})
	writeJSON(entries)
}

func writeJSON(entries []model.Entry) {
	out, err := json.MarshalIndent(entries, "", "  ")
	if err != nil {
		panic(err)
	}
	fmt.Println(string(out))
}

func processPipeline(entries []model.Entry, cfg *Config) []model.Entry {
	var resources []enc.CSVTable
	var keyTemplates []*template.Template
	var textTemplates []*template.Template

	for _, pip := range cfg.Pipelines {
		logger.Debugw("prepare pipeline", "pipeline", pip.Name)
		res := enc.CSVTable{}
		for _, resource := range pip.Resources {
			tbl := enc.ReadCSVAsTable(resource)
			for key, val := range tbl {
				res[key] = val
			}
		}
		var lookupEntries []model.Entry
		for _, file := range pip.LookupStringFiles {
			lookupEntries = append(lookupEntries, enc.ReadStringsJSON(file)...)
		}
		funcs := CreateFuncs(lookupEntries)

		keyTmpl := template.Must(template.New("").Funcs(funcs).Parse(pip.KeyTemplate))
		textTmpl := template.Must(template.New("").Funcs(funcs).Parse(pip.Template))

		resources = append(resources, res)
		keyTemplates = append(keyTemplates, keyTmpl)
		textTemplates = append(textTemplates, textTmpl)
	}

	for i := 0; i < len(entries); i++ {
		entry := entries[i]
		oldText := entry.ZhTW
	PIP:
		for j, pip := range cfg.Pipelines {
			res := resources[j]

			row, ok := res[entry.Key]
			if !ok {
				continue
			}
			if len(pip.IgnoreIDs) > 0 {
				for _, ignoreID := range pip.IgnoreIDs {
					if entry.ID == ignoreID {
						continue PIP
					}
				}
			}
			logger.Debugw("process pipeline", "pipeline", pip.Name)
			data := generateTemplateData(cfg, row, entry)

			out := bytes.NewBuffer(nil)

			if err := textTemplates[j].Execute(out, data); err != nil {
				panic(err)
			}
			newText := out.String()
			if newText == "(ignore)" {
				continue
			}

			newKey := entry.Key
			if pip.KeyTemplate != "" {
				keyOut := bytes.NewBuffer(nil)
				if err := keyTemplates[j].Execute(keyOut, data); err != nil {
					panic(err)
				}
				newKey = keyOut.String()
			}

			if newKey == entry.Key {
				if oldText != newText {
					logger.Infof("Replace %q\t->\t%q", oldText, newText)
					entry.ZhTW = newText
					entries[i] = entry
				}
			} else {
				newEntry := entry
				newEntry.Key = newKey
				newEntry.ID = -1
				newEntry.ZhTW = newText
				entries = append(entries, newEntry)
				logger.Infof("New entry %q\t->\t%q", newEntry.Key, newText)
			}
		}
	}

	return entries
}

func generateTemplateData(cfg *Config, row map[string]string, entry model.Entry) map[string]any {
	data := map[string]any{
		"data": cfg.Data,
	}
	for k, v := range row {
		data[k] = v
	}
	data["Key"] = entry.Key
	data["zhTW"] = entry.ZhTW
	data["enUS"] = entry.EnUS
	return data
}

func newLogger() *zap.SugaredLogger {
	cfg := zap.NewDevelopmentConfig()
	cfg.EncoderConfig.TimeKey = ""
	cfg.EncoderConfig.NameKey = ""
	cfg.EncoderConfig.CallerKey = ""
	if !*debug {
		cfg.Level = zap.NewAtomicLevelAt(zap.InfoLevel)
	}

	lg, _ := cfg.Build()
	return lg.Sugar()
}
