package main

import (
	"fmt"
	"os"

	"github.com/anchore/syft/cmd/syft/cli"
)

// Personal fork of anchore/syft for learning and experimentation.
// Upstream: https://github.com/anchore/syft
func main() {
	app := cli.New()
	if err := app.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(1)
	}
}
