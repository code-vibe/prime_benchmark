// prime_finder.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <stdint.h>

typedef uint64_t u64;
typedef uint32_t u32;

void sieve_basic(u32 limit, u32 *primes, u32 *count) {
    char *is_prime = calloc(limit + 1, sizeof(char));
    memset(is_prime, 1, limit + 1);
    is_prime[0] = is_prime[1] = 0;
    
    for (u32 i = 2; i * i <= limit; i++) {
        if (is_prime[i]) {
            for (u32 j = i * i; j <= limit; j += i) {
                is_prime[j] = 0;
            }
        }
    }
    
    *count = 0;
    for (u32 i = 2; i <= limit; i++) {
        if (is_prime[i]) {
            primes[(*count)++] = i;
        }
    }
    free(is_prime);
}

u64 segmented_sieve(u64 limit) {
    u32 sqrt_limit = (u32)sqrt(limit) + 1;
    u32 *base_primes = malloc(sqrt_limit * sizeof(u32));
    u32 base_count;
    
    sieve_basic(sqrt_limit, base_primes, &base_count);
    
    u64 count = base_count;
    u64 segment_size = 1000000; // 1M segment
    char *segment = malloc(segment_size);
    
    for (u64 low = sqrt_limit + 1; low <= limit; low += segment_size) {
        u64 high = (low + segment_size - 1 < limit) ? low + segment_size - 1 : limit;
        memset(segment, 1, high - low + 1);
        
        for (u32 i = 0; i < base_count; i++) {
            u32 p = base_primes[i];
            u64 start = ((low + p - 1) / p) * p;
            if (start < low) start += p;
            if (start == p) start += p; // Skip the prime itself
            
            for (u64 j = start; j <= high; j += p) {
                segment[j - low] = 0;
            }
        }
        
        for (u64 i = 0; i <= high - low; i++) {
            if (segment[i]) count++;
        }
    }
    
    free(base_primes);
    free(segment);
    return count;
}

int main() {
    clock_t start = clock();
    u64 result = segmented_sieve(10000000000ULL); // 10^10
    clock_t end = clock();
    
    printf("Primes up to 10^10: %llu\n", result);
    printf("Time: %.2f seconds\n", ((double)(end - start)) / CLOCKS_PER_SEC);
    return 0;
}