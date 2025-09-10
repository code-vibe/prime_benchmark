# prime_finder.exs
defmodule PrimeFinder do
  def sieve_basic(limit) do
    is_prime = :array.new(limit + 1, default: true)
    is_prime = :array.set(0, false, is_prime)
    is_prime = if limit > 0, do: :array.set(1, false, is_prime), else: is_prime
    
    is_prime = sieve_loop(2, limit, is_prime)
    
    2..limit
    |> Enum.filter(fn i -> :array.get(i, is_prime) end)
  end
  
  defp sieve_loop(i, limit, is_prime) when i * i > limit, do: is_prime
  defp sieve_loop(i, limit, is_prime) do
    if :array.get(i, is_prime) do
      is_prime = mark_multiples(i * i, i, limit, is_prime)
      sieve_loop(i + 1, limit, is_prime)
    else
      sieve_loop(i + 1, limit, is_prime)
    end
  end
  
  defp mark_multiples(j, step, limit, is_prime) when j > limit, do: is_prime
  defp mark_multiples(j, step, limit, is_prime) do
    is_prime = :array.set(j, false, is_prime)
    mark_multiples(j + step, step, limit, is_prime)
  end
  
  def segmented_sieve(limit) do
    sqrt_limit = trunc(:math.sqrt(limit)) + 1
    base_primes = sieve_basic(sqrt_limit)
    
    base_count = length(base_primes)
    segment_size = 1_000_000
    
    count = segment_count(sqrt_limit + 1, limit, segment_size, base_primes, base_count)
    count
  end
  
  defp segment_count(low, limit, segment_size, base_primes, acc) when low > limit, do: acc
  defp segment_count(low, limit, segment_size, base_primes, acc) do
    high = min(low + segment_size - 1, limit)
    segment = :array.new(high - low + 1, default: true)
    
    segment = Enum.reduce(base_primes, segment, fn p, seg ->
      start = div(low + p - 1, p) * p
      start = if start < low, do: start + p, else: start
      start = if start == p, do: start + p, else: start
      
      mark_segment(start, p, high, low, seg)
    end)
    
    segment_count = 0..(high - low)
    |> Enum.count(fn i -> :array.get(i, segment) end)
    
    segment_count(low + segment_size, limit, segment_size, base_primes, acc + segment_count)
  end
  
  defp mark_segment(j, step, high, low, segment) when j > high, do: segment
  defp mark_segment(j, step, high, low, segment) do
    segment = :array.set(j - low, false, segment)
    mark_segment(j + step, step, high, low, segment)
  end
end

{time, result} = :timer.tc(fn -> PrimeFinder.segmented_sieve(10_000_000_000) end)

IO.puts("Primes up to 10^10: #{result}")
IO.puts("Time: #{time / 1_000_000} seconds")