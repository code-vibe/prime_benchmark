#!/bin/bash
set -e

echo "=== Optimization Flags Benchmark ==="
echo "This will test different optimization levels to understand performance impacts"
echo

# Function to benchmark a binary
benchmark_binary() {
    local name=$1
    local binary=$2
    
    if [ -f "$binary" ]; then
        echo "Testing: $name"
        local start=$(date +%s.%N)
        timeout 120s $binary > /dev/null 2>&1 || true
        local end=$(date +%s.%N)
        local elapsed=$(echo "$end - $start" | bc -l)
        printf "%-25s %8.3f seconds\n" "$name" "$elapsed"
    else
        printf "%-25s %8s\n" "$name" "MISSING"
    fi
}

echo "C Optimization Levels:"
benchmark_binary "C -O0 (debug)" "builds/debug/prime_c_O0"
benchmark_binary "C -O2 (release)" "builds/release/prime_c_O2" 
benchmark_binary "C -O3 (aggressive)" "builds/aggressive/prime_c_O3"
benchmark_binary "C -Ofast (fastest)" "builds/aggressive/prime_c_Ofast"

echo
echo "Rust Optimization Levels:"
benchmark_binary "Rust opt-level=0" "builds/debug/prime_rust_O0"
benchmark_binary "Rust opt-level=2" "builds/release/prime_rust_O2"
benchmark_binary "Rust opt-level=3" "builds/aggressive/prime_rust_O3"
benchmark_binary "Rust native CPU" "builds/aggressive/prime_rust_native"

echo
echo "Go Build Modes:"
benchmark_binary "Go debug" "builds/debug/prime_go_debug"
benchmark_binary "Go release" "builds/release/prime_go_release"
benchmark_binary "Go aggressive" "builds/aggressive/prime_go_aggressive"

echo
echo "C++ Optimization Levels:"
benchmark_binary "C++ -O0 (debug)" "builds/debug/prime_cpp_O0"
benchmark_binary "C++ -O2 (release)" "builds/release/prime_cpp_O2"
benchmark_binary "C++ -O3 (aggressive)" "builds/aggressive/prime_cpp_O3"
benchmark_binary "C++ native CPU" "builds/aggressive/prime_cpp_native"

echo
echo "=== Analysis ==="
echo "Key optimization flags explained:"
echo "• -O0: No optimization (debug builds)"
echo "• -O2: Standard optimization (good balance)"
echo "• -O3: Aggressive optimization (maximum performance)"
echo "• -Ofast: Break standards for speed (use carefully)"
echo "• -march=native: Optimize for your specific CPU"
echo "• target-cpu=native: Rust's CPU-specific optimization"
