package main

import (
	"fmt"
	"os"

	"github.com/anchore/syft/cmd/syft/cli"
)

func main() {
	app := cli.New()
	if err := app.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(1)
	}
}
