<?php
// prime_finder.php

function sieveBasic($limit) {
    $isPrime = array_fill(0, $limit + 1, true);
    $isPrime[0] = $isPrime[1] = false;
    
    for ($i = 2; $i * $i <= $limit; $i++) {
        if ($isPrime[$i]) {
            for ($j = $i * $i; $j <= $limit; $j += $i) {
                $isPrime[$j] = false;
            }
        }
    }
    
    $primes = [];
    for ($i = 2; $i <= $limit; $i++) {
        if ($isPrime[$i]) {
            $primes[] = $i;
        }
    }
    return $primes;
}

function segmentedSieve($limit) {
    $sqrtLimit = intval(sqrt($limit)) + 1;
    $basePrimes = sieveBasic($sqrtLimit);
    
    $count = count($basePrimes);
    $segmentSize = 1000000;
    
    for ($low = $sqrtLimit + 1; $low <= $limit; $low += $segmentSize) {
        $high = min($low + $segmentSize - 1, $limit);
        $segment = array_fill(0, $high - $low + 1, true);
        
        foreach ($basePrimes as $p) {
            $start = intval(($low + $p - 1) / $p) * $p;
            if ($start < $low) $start += $p;
            if ($start == $p) $start += $p;
            
            for ($j = $start; $j <= $high; $j += $p) {
                $segment[$j - $low] = false;
            }
        }
        
        $count += array_sum($segment);
    }
    
    return $count;
}

$start = microtime(true);
$result = segmentedSieve(10000000000);
$end = microtime(true);

echo "Primes up to 10^10: $result\n";
echo "Time: " . number_format($end - $start, 2) . " seconds\n";
?>