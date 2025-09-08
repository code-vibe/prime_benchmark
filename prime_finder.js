// prime_finder.js
function sieveBasic(limit) {
    const isPrime = new Array(limit + 1).fill(true);
    isPrime[0] = isPrime[1] = false;
    
    for (let i = 2; i * i <= limit; i++) {
        if (isPrime[i]) {
            for (let j = i * i; j <= limit; j += i) {
                isPrime[j] = false;
            }
        }
    }
    
    const primes = [];
    for (let i = 2; i <= limit; i++) {
        if (isPrime[i]) {
            primes.push(i);
        }
    }
    return primes;
}

function segmentedSieve(limit) {
    const sqrtLimit = Math.floor(Math.sqrt(limit)) + 1;
    const basePrimes = sieveBasic(sqrtLimit);
    
    let count = basePrimes.length;
    const segmentSize = 1000000;
    
    for (let low = sqrtLimit + 1; low <= limit; low += segmentSize) {
        const high = Math.min(low + segmentSize - 1, limit);
        const segment = new Array(high - low + 1).fill(true);
        
        for (const p of basePrimes) {
            let start = Math.floor((low + p - 1) / p) * p;
            if (start < low) start += p;
            if (start === p) start += p;
            
            for (let j = start; j <= high; j += p) {
                segment[j - low] = false;
            }
        }
        
        count += segment.reduce((sum, val) => sum + (val ? 1 : 0), 0);
    }
    
    return count;
}

const start = process.hrtime.bigint();
const result = segmentedSieve(10000000000);
const end = process.hrtime.bigint();

console.log(`Primes up to 10^10: ${result}`);
console.log(`Time: ${Number(end - start) / 1000000000} seconds`);