#!/bin/bash
set -e

echo "Compiling programs with different optimization levels..."

# Create directories for different optimization levels
mkdir -p builds/{debug,release,aggressive}

echo "=== C Optimizations ==="
# C - Different optimization levels
gcc -O0 -o builds/debug/prime_c_O0 prime_finder.c -lm           # No optimization
gcc -O2 -o builds/release/prime_c_O2 prime_finder.c -lm         # Standard optimization
gcc -O3 -o builds/aggressive/prime_c_O3 prime_finder.c -lm      # Aggressive optimization
gcc -Ofast -o builds/aggressive/prime_c_Ofast prime_finder.c -lm # Fastest (may break standards)

echo "=== Rust Optimizations ==="
# Rust - Different optimization levels
rustc -C opt-level=0 prime_finder.rs -o builds/debug/prime_rust_O0       # No optimization
rustc -C opt-level=2 prime_finder.rs -o builds/release/prime_rust_O2     # Standard optimization  
rustc -C opt-level=3 prime_finder.rs -o builds/aggressive/prime_rust_O3  # Aggressive optimization
rustc -C opt-level=3 -C target-cpu=native prime_finder.rs -o builds/aggressive/prime_rust_native # CPU-specific

echo "=== Go Optimizations ==="
# Go - Different build modes
go build -o builds/debug/prime_go_debug prime_finder.go                    # Debug build
go build -ldflags="-s -w" -o builds/release/prime_go_release prime_finder.go # Release build
go build -ldflags="-s -w" -gcflags="-N -l" -o builds/aggressive/prime_go_aggressive prime_finder.go

echo "=== C++ Optimizations ==="
# C++ - Different optimization levels
g++ -O0 -o builds/debug/prime_cpp_O0 prime_finder.cpp                     # No optimization
g++ -O2 -o builds/release/prime_cpp_O2 prime_finder.cpp                   # Standard optimization
g++ -O3 -o builds/aggressive/prime_cpp_O3 prime_finder.cpp                # Aggressive optimization
g++ -O3 -march=native -o builds/aggressive/prime_cpp_native prime_finder.cpp # CPU-specific

echo "Compilation complete!"
echo "Available binaries:"
find builds -type f -executable | sort
