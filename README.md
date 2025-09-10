#  Multi-Language Prime Number Benchmark

A comprehensive performance comparison of prime number algorithms across 9 programming languages, exploring compilation optimization, memory usage patterns, and real-world performance characteristics.

##  Quick Results

| Language | Time (seconds) | Memory (KB) | Optimization | Performance Rank |
|----------|----------------|-------------|--------------|------------------|
| **C** | 14.92 | 2,652 | `-O3` | 1st |
| **Go** | 28.51 | ~3,000 | Default | 2nd |
| **Java** | 29.11 | ~4,000 | JIT | 3rd |
| **Rust** | 38.68 | 2,976 | `opt-level=3` | 4th |
| **C++** | 51.39 | ~3,500 | `-O3` | 5th |
| **Node.js** | 114.35 | ~6,000 | V8 JIT | 6th |
| **PHP** | 1,020.72 | ~4,000 | Interpreted | 7th |
| **Python** | 1,612.73 | ~5,000 | Interpreted | 8th |

*Task: Find all prime numbers up to 10^10 using segmented sieve algorithm*

##  Key Discoveries

- **Optimization flags provide 4-10x performance gains**
- **Go's defaults explain why it beats highly optimized Rust**
- **Memory efficiency ≠ execution speed**
- **Context switches reveal compiler optimization quality**
- **Understood RUntime and Compile-time tradeoffs (Go and Rust)**

##  Quick Start

### Using Docker (Recommended)
```bash
# Clone the repository
git clone <your-repo-url>
cd prime_benchmark

# Run the complete benchmark
docker build -t prime-benchmark .
docker run --rm prime-benchmark

# Run specific optimization analysis
docker run --rm prime-benchmark ./benchmark_optimizations.sh
```

### Manual Setup
```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get update && sudo apt-get install -y \
    build-essential gcc g++ default-jdk \
    golang-go rustc python3 nodejs php-cli \
    erlang elixir mono-mcs bc util-linux

# Compile all programs
./compile.sh

# Run benchmarks
./benchmark.sh

# Analyze memory usage
./analyze_memory.sh
```

##  Project Structure

```
prime_benchmark/
├──  README.md                  # This file
├──  BLOG_POST.md              # Detailed learning journey
├──  SUMMARY.md                # Quick reference guide
├──  Dockerfile               # Multi-language container
├──  compile.sh               # Standard compilation
├──   compile_optimized.sh     # Multi-optimization builds
├──  benchmark.sh             # Performance testing
├──  analyze_memory.sh        # Memory usage analysis
├──  Source Code/
│   ├── prime_finder.c          # C implementation
│   ├── prime_finder.cpp        # C++ implementation  
│   ├── prime_finder.rs         # Rust implementation
│   ├── prime_finder.go         # Go implementation
│   ├── PrimeFinder.java        # Java implementation
│   ├── prime_finder.py         # Python implementation
│   ├── prime_finder.js         # Node.js implementation
│   ├── prime_finder.php        # PHP implementation
│   └── prime_finder.exs        # Elixir implementation
└──  results.csv              # Benchmark output
```

## Algorithm Details

All implementations use the **segmented sieve of Eratosthenes** algorithm:
- **Input**: Find primes up to 10^10 (10 billion)
- **Method**: Memory-efficient segmented approach
- **Segments**: 1 million number chunks
- **Output**: Count of prime numbers found

### Why This Algorithm?
- **Memory efficient**: Processes large ranges without excessive RAM
- **CPU intensive**: Good test of computational performance
- **Comparable**: Same algorithmic complexity across languages

##  Optimization Analysis

### C Compiler Flags Impact
| Flag | Time (s) | Speedup | Use Case |
|------|----------|---------|----------|
| `-O0` | 60+ | Baseline | Debug only |
| `-O2` | 17.27 | **3.5x** | Production standard |
| `-O3` | 14.92 | **4x+** | Performance critical |
| `-Ofast` | 18.06 | 3.3x | Use with caution |

### Rust Optimization Levels
| Level | Time (s) | Speedup | Use Case |
|-------|----------|---------|----------|
| `opt-level=0` | 60+ | Baseline | Debug only |
| `opt-level=2` | 40.34 | **1.5x+** | Production |
| `opt-level=3` | 38.68 | **1.6x+** | Maximum performance |

##  Key Learnings

### Performance Insights
1. **Go's excellent defaults** explain competitive performance
2. **Rust's safety guarantees** have measurable overhead  
3. **JIT compilation** (Java, Node.js) is surprisingly effective
4. **Memory patterns** don't always correlate with speed

### Development Insights
1. **Always benchmark with optimizations enabled**
2. **Profile memory usage alongside execution time**
3. **Language ergonomics matter for maintainability**
4. **Compilation model affects real-world performance**

##  Detailed Analysis

For a complete deep-dive into the methodology, discoveries, and technical details, see:
- **[ BLOG_POST.md](BLOG_POST.md)** - Full learning journey tutorial
- **[ SUMMARY.md](SUMMARY.md)** - Quick reference tables

##  Blog Post

This project is documented in detail on my blog: [**"Benchmarking 9 Programming Languages: A Journey Through Performance Optimization"**](//Add url later here)

##  Contributing

Found an optimization or want to add another language? Contributions welcome!

1. Fork the repository
2. Add your implementation following existing patterns
3. Update compilation and benchmark scripts
4. Submit a pull request with performance results

##  License

MIT License - Feel free to use this for your own learning and benchmarking needs.

## 🔗 Connect

- **Blog**: [https://code-vibe.github.io/code-vibe/]
- **GitHub**: [https://github.com/code-vibe]
- **Twitter**: [https://x.com/agentx_01]

---

*"The best way to learn about performance is to measure it."*