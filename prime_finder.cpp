// prime_finder.cpp
#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>
#include <cstring>

using namespace std;
using u64 = uint64_t;
using u32 = uint32_t;

vector<u32> sieve_basic(u32 limit) {
    vector<bool> is_prime(limit + 1, true);
    is_prime[0] = is_prime[1] = false;
    
    for (u32 i = 2; i * i <= limit; i++) {
        if (is_prime[i]) {
            for (u32 j = i * i; j <= limit; j += i) {
                is_prime[j] = false;
            }
        }
    }
    
    vector<u32> primes;
    for (u32 i = 2; i <= limit; i++) {
        if (is_prime[i]) {
            primes.push_back(i);
        }
    }
    return primes;
}

u64 segmented_sieve(u64 limit) {
    u32 sqrt_limit = static_cast<u32>(sqrt(limit)) + 1;
    auto base_primes = sieve_basic(sqrt_limit);
    
    u64 count = base_primes.size();
    u64 segment_size = 1000000;
    vector<bool> segment(segment_size);
    
    for (u64 low = sqrt_limit + 1; low <= limit; low += segment_size) {
        u64 high = min(low + segment_size - 1, limit);
        fill(segment.begin(), segment.begin() + (high - low + 1), true);
        
        for (u32 p : base_primes) {
            u64 start = ((low + p - 1) / p) * p;
            if (start < low) start += p;
            if (start == p) start += p;
            
            for (u64 j = start; j <= high; j += p) {
                segment[j - low] = false;
            }
        }
        
        for (u64 i = 0; i <= high - low; i++) {
            if (segment[i]) count++;
        }
    }
    
    return count;
}

int main() {
    auto start = chrono::high_resolution_clock::now();
    u64 result = segmented_sieve(10000000000ULL);
    auto end = chrono::high_resolution_clock::now();
    
    auto duration = chrono::duration_cast<chrono::milliseconds>(end - start);
    cout << "Primes up to 10^10: " << result << endl;
    cout << "Time: " << duration.count() / 1000.0 << " seconds" << endl;
    return 0;
}