defmodule Primes do
  #Goal: Enum.take( Stream.map(Primes.primes(), fn(x) -> 2*x end), 5)
  #[4, 6, 10, 14, 22]
  #Take out 5 primes and for each prime map it to 2x its value



  def z(n) do
    fn() -> {n, z(n+1)} end
  end

  def filter(op, f) do
    {n, op} = op.()
    if rem(n, f) != 0 do
      {n, fn() -> filter(op, f) end}
    else
      filter(op, f)
    end
  end

  def sieve(n, p) do

  end



  def foldl([], acc, op) do acc end
  def foldl([h|t], acc, op) do
    foldl(t, op.(h, acc), op)
  end
  def foo(x) do
    y = 3
    fn (v) -> v + y + x end
  end

  def infinity() do
    fn () -> infinity(0) end
  end

  def infinity(n) do
    [n|fn() -> infinity(n+1) end]
  end

  def fib do
    fn() -> fib(1,1) end
  end

  def fib(f1, f2) do
    [f1|fn() -> fib(f2, f1+f2) end]
  end

  def sumr({:range, from, from}) do from end
  def sumr({:range, from, to}) do
    from + sumr({:range, from+1, to})
  end

end
