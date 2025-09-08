// PrimeFinder.cs
using System;
using System.Collections.Generic;
using System.Diagnostics;

class PrimeFinder {
    
    static List<int> SieveBasic(int limit) {
        bool[] isPrime = new bool[limit + 1];
        for (int i = 0; i <= limit; i++) isPrime[i] = true;
        isPrime[0] = isPrime[1] = false;
        
        for (int i = 2; i * i <= limit; i++) {
            if (isPrime[i]) {
                for (int j = i * i; j <= limit; j += i) {
                    isPrime[j] = false;
                }
            }
        }
        
        List<int> primes = new List<int>();
        for (int i = 2; i <= limit; i++) {
            if (isPrime[i]) {
                primes.Add(i);
            }
        }
        return primes;
    }
    
    static long SegmentedSieve(long limit) {
        int sqrtLimit = (int) Math.Sqrt(limit) + 1;
        List<int> basePrimes = SieveBasic(sqrtLimit);
        
        long count = basePrimes.Count;
        long segmentSize = 1000000;
        bool[] segment = new bool[segmentSize];
        
        for (long low = sqrtLimit + 1; low <= limit; low += segmentSize) {
            long high = Math.Min(low + segmentSize - 1, limit);
            
            for (int i = 0; i <= high - low; i++) {
                segment[i] = true;
            }
            
            foreach (int p in basePrimes) {
                long start = ((low + p - 1) / p) * p;
                if (start < low) start += p;
                if (start == p) start += p;
                
                for (long j = start; j <= high; j += p) {
                    segment[j - low] = false;
                }
            }
            
            for (int i = 0; i <= high - low; i++) {
                if (segment[i]) count++;
            }
        }
        
        return count;
    }
    
    static void Main() {
        Stopwatch sw = Stopwatch.StartNew();
        long result = SegmentedSieve(10000000000L);
        sw.Stop();
        
        Console.WriteLine($"Primes up to 10^10: {result}");
        Console.WriteLine($"Time: {sw.ElapsedMilliseconds / 1000.0:F2} seconds");
    }
}