// prime_finder.go
package main

import (
    "fmt"
    "math"
    "time"
)

func sieveBasic(limit uint32) []uint32 {
    isPrime := make([]bool, limit+1)
    for i := range isPrime {
        isPrime[i] = true
    }
    isPrime[0], isPrime[1] = false, false
    
    for i := uint32(2); i*i <= limit; i++ {
        if isPrime[i] {
            for j := i * i; j <= limit; j += i {
                isPrime[j] = false
            }
        }
    }
    
    var primes []uint32
    for i := uint32(2); i <= limit; i++ {
        if isPrime[i] {
            primes = append(primes, i)
        }
    }
    return primes
}

func segmentedSieve(limit uint64) uint64 {
    sqrtLimit := uint32(math.Sqrt(float64(limit))) + 1
    basePrimes := sieveBasic(sqrtLimit)
    
    count := uint64(len(basePrimes))
    segmentSize := uint64(1000000)
    segment := make([]bool, segmentSize)
    
    for low := uint64(sqrtLimit) + 1; low <= limit; low += segmentSize {
        high := low + segmentSize - 1
        if high > limit {
            high = limit
        }
        
        for i := uint64(0); i <= high-low; i++ {
            segment[i] = true
        }
        
        for _, p := range basePrimes {
            p64 := uint64(p)
            start := ((low + p64 - 1) / p64) * p64
            if start < low {
                start += p64
            }
            if start == p64 {
                start += p64
            }
            
            for j := start; j <= high; j += p64 {
                segment[j-low] = false
            }
        }
        
        for i := uint64(0); i <= high-low; i++ {
            if segment[i] {
                count++
            }
        }
    }
    
    return count
}

func main() {
    start := time.Now()
    result := segmentedSieve(10000000000)
    duration := time.Since(start)
    
    fmt.Printf("Primes up to 10^10: %d\n", result)
    fmt.Printf("Time: %.2f seconds\n", duration.Seconds())
}