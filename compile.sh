#!/bin/bash

# Compile all programs
echo "Compiling programs..."

# C
gcc -O3 -o prime_c prime_finder.c -lm

# C++
g++ -O3 -o prime_cpp prime_finder.cpp

# Rust
rustc -C opt-level=3 prime_finder.rs

# Go
go build -o prime_go prime_finder.go

# Java
javac PrimeFinder.java

# C#
csc -optimize+ PrimeFinder.cs

echo "Compilation complete!"