package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type Record struct {
	Category string `json:"category"`
	ID       int    `json:"id"`
	Keyword  string `json:"keyword"`
	URL      string `json:"url"`
}

func main() {
	// Read input file
	inputFile := "output.json"
	inputData, err := os.ReadFile(inputFile)
	if err != nil {
		fmt.Println("Error reading input file:", err)
		os.Exit(1)
	}

	// Parse input data
	var records []Record
	err = json.Unmarshal(inputData, &records)
	if err != nil {
		fmt.Println("Error parsing input data:", err)
		os.Exit(1)
	}

	// Filter records
	filtered := make([]Record, 0, len(records))
	seen := make(map[string]bool)
	for _, r := range records {
		key := r.Category + ":" + r.Keyword
		if !seen[key] {
			filtered = append(filtered, r)
			seen[key] = true
		}
	}

	// Write output file
	outputFile := "output-no-dups.json"
	outputData, err := json.MarshalIndent(filtered, "", "  ")
	if err != nil {
		fmt.Println("Error marshaling output data:", err)
		os.Exit(1)
	}
	err = os.WriteFile(outputFile, outputData, 0644)
	if err != nil {
		fmt.Println("Error writing output file:", err)
		os.Exit(1)
	}

	fmt.Println("Done.")
}
