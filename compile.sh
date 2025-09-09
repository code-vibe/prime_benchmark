#!/bin/bash
set -e

echo "Compiling programs..."

# C
gcc -O3 -o prime_c prime_finder.c -lm

# C++
g++ -O3 -o prime_cpp prime_finder.cpp

# Rust
rustc -C opt-level=3 prime_finder.rs -o prime_finder

# Go
go build -o prime_go prime_finder.go

# Java
javac PrimeFinder.java

# C#
mcs -optimize+ -out:PrimeFinder.exe PrimeFinder.cs

# Python deps (non-interactive, quiet)
if [ -f requirements.txt ]; then
  pip install -r requirements.txt --no-input -q
fi

# Node deps (non-interactive, quiet)
if [ -f package.json ]; then
  npm install --no-fund --no-audit --silent
fi

echo "Compilation complete!"
