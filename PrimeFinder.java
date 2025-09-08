// PrimeFinder.java
import java.util.*;

public class PrimeFinder {
    
    public static List<Integer> sieveBasic(int limit) {
        boolean[] isPrime = new boolean[limit + 1];
        Arrays.fill(isPrime, true);
        isPrime[0] = isPrime[1] = false;
        
        for (int i = 2; i * i <= limit; i++) {
            if (isPrime[i]) {
                for (int j = i * i; j <= limit; j += i) {
                    isPrime[j] = false;
                }
            }
        }
        
        List<Integer> primes = new ArrayList<>();
        for (int i = 2; i <= limit; i++) {
            if (isPrime[i]) {
                primes.add(i);
            }
        }
        return primes;
    }
    
    public static long segmentedSieve(long limit) {
        int sqrtLimit = (int) Math.sqrt(limit) + 1;
        List<Integer> basePrimes = sieveBasic(sqrtLimit);
        
        long count = basePrimes.size();
        long segmentSize = 1000000;
        boolean[] segment = new boolean[(int) segmentSize];
        
        for (long low = sqrtLimit + 1; low <= limit; low += segmentSize) {
            long high = Math.min(low + segmentSize - 1, limit);
            
            Arrays.fill(segment, 0, (int)(high - low + 1), true);
            
            for (int p : basePrimes) {
                long start = ((low + p - 1) / p) * p;
                if (start < low) start += p;
                if (start == p) start += p;
                
                for (long j = start; j <= high; j += p) {
                    segment[(int)(j - low)] = false;
                }
            }
            
            for (int i = 0; i <= high - low; i++) {
                if (segment[i]) count++;
            }
        }
        
        return count;
    }
    
    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        long result = segmentedSieve(10000000000L);
        long end = System.currentTimeMillis();
        
        System.out.println("Primes up to 10^10: " + result);
        System.out.println("Time: " + (end - start) / 1000.0 + " seconds");
    }
}