// prime_finder_iter.rs
use std::time::Instant;

fn sieve_basic(limit: u32) -> Vec<u32> {
    let mut is_prime = vec![true; (limit + 1) as usize];
    is_prime[0] = false;
    if limit > 0 { is_prime[1] = false; }
    
    let mut i = 2;
    while i * i <= limit {
        if is_prime[i as usize] {
            let mut j = i * i;
            while j <= limit {
                is_prime[j as usize] = false;
                j += i;
            }
        }
        i += 1;
    }
    
    (2..=limit).filter(|&i| is_prime[i as usize]).collect()
}

fn segmented_sieve(limit: u64) -> u64 {
    let sqrt_limit = (limit as f64).sqrt() as u32 + 1;
    let base_primes = sieve_basic(sqrt_limit);
    
    let mut count = base_primes.len() as u64;
    let segment_size = 1_000_000usize;  // Use usize directly
    let mut segment = vec![true; segment_size];
    
    let mut low = sqrt_limit as u64 + 1;
    while low <= limit {
        let high = std::cmp::min(low + segment_size as u64 - 1, limit);
        let len = (high - low + 1) as usize;  // Calculate length once
        
        // Reset segment using slice - no casting in loop
        segment[..len].fill(true);
        
        for &p in &base_primes {
            let p = p as u64;
            let mut start = ((low + p - 1) / p) * p;
            if start < low { start += p; }
            if start == p { start += p; }
            
            // Pre-calculate the offset to avoid repeated subtraction
            let mut j = start;
            while j <= high {
                let idx = (j - low) as usize;  // Single cast per iteration
                segment[idx] = false;
                j += p;
            }
        }
        
        // Use iterator to count - much more efficient
        count += segment[..len].iter().filter(|&&is_prime| is_prime).count() as u64;
        
        low += segment_size as u64;
    }
    
    count
}

fn main() {
    let start = Instant::now();
    let result = segmented_sieve(10_000_000_000);
    let duration = start.elapsed();
    
    println!("Primes up to 10^10: {}", result);
    println!("Time: {:.2} seconds", duration.as_secs_f64());
}
