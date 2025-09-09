# prime_finder.py
import sys
import time
import math

def sieve_basic(limit):
    is_prime = [True] * (limit + 1)
    is_prime[0] = is_prime[1] = False
    
    for i in range(2, int(math.sqrt(limit)) + 1):
        if is_prime[i]:
            for j in range(i * i, limit + 1, i):
                is_prime[j] = False
    
    return [i for i in range(2, limit + 1) if is_prime[i]]

def segmented_sieve(limit):
    sqrt_limit = int(math.sqrt(limit)) + 1
    base_primes = sieve_basic(sqrt_limit)
    
    count = len(base_primes)
    segment_size = 1000000
    
    for low in range(sqrt_limit + 1, limit + 1, segment_size):
        high = min(low + segment_size - 1, limit)
        segment = [True] * (high - low + 1)
        
        for p in base_primes:
            start = ((low + p - 1) // p) * p
            if start < low:
                start += p
            if start == p:
                start += p
            
            for j in range(start, high + 1, p):
                segment[j - low] = False
        
        count += sum(segment)
    
    return count

if __name__ == "__main__":
    start = time.time()
    result = segmented_sieve(10**10)
    end = time.time()
    
    print(f"Primes up to 10^10: {result}")
    print(f"Time: {end - start:.2f} seconds")
    sys.exit(0) 