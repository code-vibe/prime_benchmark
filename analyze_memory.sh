#!/bin/bash
set -e

echo "=== Memory Usage Analysis for Prime Benchmark ==="
echo "This script analyzes memory consumption patterns across different languages and optimizations"
echo

# Function to benchmark with memory monitoring
benchmark_with_memory() {
    local name=$1
    local binary=$2
    
    if [ -f "$binary" ]; then
        echo "Analyzing: $name"
        echo "----------------------------------------"
        
        # Use /usr/bin/time (not shell builtin) for detailed memory stats
        /usr/bin/time -v $binary 2>&1 | grep -E "(Maximum resident|Average resident|Page size|Major page faults|Minor page faults|Voluntary context|Involuntary context)" || true
        echo
    else
        echo "$name: Binary not found"
        echo
    fi
}

# Function to run with memory profiling using valgrind (if available)
profile_memory() {
    local name=$1
    local binary=$2
    
    if [ -f "$binary" ] && command -v valgrind >/dev/null 2>&1; then
        echo "Memory profiling: $name"
        echo "----------------------------------------"
        timeout 120s valgrind --tool=massif --massif-out-file=massif.$name.out $binary >/dev/null 2>&1 || true
        if [ -f "massif.$name.out" ]; then
            echo "Massif profile created: massif.$name.out"
        fi
        echo
    fi
}

echo "1. MEMORY USAGE COMPARISON"
echo "=========================="

echo "C Optimization Levels:"
benchmark_with_memory "C -O0" "./builds/debug/prime_c_O0"
benchmark_with_memory "C -O2" "./builds/release/prime_c_O2"
benchmark_with_memory "C -O3" "./builds/aggressive/prime_c_O3"
benchmark_with_memory "C -Ofast" "./builds/aggressive/prime_c_Ofast"

echo "Rust Optimization Levels:"
benchmark_with_memory "Rust opt-level=0" "./builds/debug/prime_rust_O0"
benchmark_with_memory "Rust opt-level=2" "./builds/release/prime_rust_O2"
benchmark_with_memory "Rust opt-level=3" "./builds/aggressive/prime_rust_O3"
benchmark_with_memory "Rust native" "./builds/aggressive/prime_rust_native"

echo "Original Compiled Versions:"
benchmark_with_memory "C (original)" "./prime_c"
benchmark_with_memory "C++ (original)" "./prime_cpp"
benchmark_with_memory "Rust (original)" "./prime_finder"

echo "2. DETAILED MEMORY PROFILING"
echo "============================"
echo "Note: This section requires valgrind (install with: sudo apt install valgrind)"

# Only profile a few key binaries to save time
profile_memory "c_o3" "./builds/aggressive/prime_c_O3"
profile_memory "rust_o3" "./builds/aggressive/prime_rust_O3"
profile_memory "c_original" "./prime_c"

echo "3. MEMORY USAGE ANALYSIS"
echo "========================"
echo "Key metrics to understand:"
echo "• Maximum resident set size: Peak memory usage"
echo "• Page faults: How often the program accessed disk instead of RAM"
echo "• Context switches: How often the OS interrupted the program"
echo "• Major page faults: Expensive disk reads"
echo "• Minor page faults: Less expensive memory allocations"
echo
echo "Lower numbers generally indicate better memory efficiency."
echo "High page faults suggest the program uses more memory than available RAM."
