#!/bin/bash
set -e

RESULTS_FILE="results.csv"
rm -f "$RESULTS_FILE"

# CSV header
echo "Language,Time(s)" >> "$RESULTS_FILE"

# Function to run and capture execution time
run_and_capture() {
    local name=$1
    shift
    local cmd="$@"

    echo "Running $name..."
    local start=$(date +%s.%N)
    $cmd > /dev/null
    local end=$(date +%s.%N)

    # Calculate elapsed time
    local elapsed=$(echo "$end - $start" | bc)

    # Save to CSV
    echo "$name,$elapsed" >> "$RESULTS_FILE"
}

# Run all implementations
run_and_capture "C" ./prime_c
run_and_capture "C++" ./prime_cpp
run_and_capture "Rust" ./prime_finder
run_and_capture "Go" ./prime_go
run_and_capture "Java" java PrimeFinder
run_and_capture "C#" mono PrimeFinder.exe
run_and_capture "Python" python3 prime_finder.py
run_and_capture "Node.js" node prime_finder.js
run_and_capture "PHP" php prime_finder.php
run_and_capture "Elixir" elixir prime_finder.exs

# Print results as a table
echo
echo "===== Benchmark Results ====="
printf "%-12s %s\n" "Language" "Time(s)"
printf "%-12s %s\n" "--------" "-------"
while IFS=, read -r lang time; do
    if [ "$lang" != "Language" ]; then
        printf "%-12s %s\n" "$lang" "$time"
    fi
done < "$RESULTS_FILE"
echo "============================="
