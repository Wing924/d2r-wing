package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/Wing924/d2r-wing/tools/lib/enc"
	"github.com/Wing924/d2r-wing/tools/lib/model"
	"go.uber.org/zap"
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
	processPipeline(entries, cfg)
	writeJSON(entries)
}

func writeJSON(entries []model.Entry) {
	out, err := json.MarshalIndent(entries, "", "  ")
	if err != nil {
		panic(err)
	}
	fmt.Println(string(out))
}

func processPipeline(entries []model.Entry, cfg *Config) {
	var resources []enc.CSVMap
	var templates []*template.Template

	for _, pip := range cfg.Pipelines {
		logger.Debugw("prepare pipeline", "pipeline", pip.Name)
		res := enc.ReadCSVAsMap(pip.Resource)
		var lookupEntries []model.Entry
		for _, file := range pip.LookupStringFiles {
			lookupEntries = append(lookupEntries, enc.ReadStringsJSON(file)...)
		}
		funcs := CreateFuncs(lookupEntries)
		tmpl := template.Must(template.New("").Funcs(funcs).Parse(pip.Template))
		resources = append(resources, res)
		templates = append(templates, tmpl)
	}

	for i, entry := range entries {
		oldText := entry.ZhTW
		for j, pip := range cfg.Pipelines {
			res := resources[j]
			row, ok := res[entry.ID]
			if !ok {
				continue
			}
			logger.Debugw("process pipeline", "pipeline", pip.Name)
			data := generateTemplateData(cfg, row, entry)

			out := bytes.NewBuffer(nil)

			if err := templates[j].Execute(out, data); err != nil {
				panic(err)
			}
			entry.ZhTW = out.String()
		}
		if oldText != entry.ZhTW {
			logger.Infof("Replace %q\t->\t%q", oldText, entry.ZhTW)
			entries[i] = entry
		}
	}
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
