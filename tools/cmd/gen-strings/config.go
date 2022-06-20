package main

import (
	"gopkg.in/yaml.v3"
	"os"
)

type (
	KV map[string]string

	Config struct {
		Data      map[string]KV `yaml:"data"`
		Patches   []string      `yaml:"patches"`
		Pipelines []Pipeline    `yaml:"pipelines"`
	}

	Pipeline struct {
		Name              string   `yaml:"name"`
		Resource          string   `yaml:"resource"`
		LookupStringFiles []string `yaml:"lookup_string_files"`
		Template          string   `yaml:"template"`
	}
)

func LoadConfig(filename string) *Config {
	f, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	decoder := yaml.NewDecoder(f)
	decoder.KnownFields(true)

	var cfg Config
	if err := decoder.Decode(&cfg); err != nil {
		panic(err)
	}
	return &cfg
}
