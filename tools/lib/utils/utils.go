package utils

import (
	"bytes"
	"os/exec"
)

func TopGitRepo() string {
	cmd := exec.Command("git", "rev-parse", "--show-toplevel")
	out, err := cmd.Output()
	if err != nil {
		panic(err)
	}
	return string(bytes.TrimSpace(out))
}
