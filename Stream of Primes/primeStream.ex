defmodule Primes do
  defstruct [:next]

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

  def sieve(op, p) do
    {n, op} = filter(op, p)
    {n, fn() -> sieve(op, n) end}
  end

  def primes() do
    %Primes{next: fn () ->  {2, fn () -> sieve(z(3), 2)  end} end}
  end


  defimpl Enumerable do
    def count(_) do {:error, __MODULE__} end
    def member?(_, _) do {:error, __MODULE__} end
    def slice(_) do {:error, __MODULE__} end
    def reduce(_, {:halt, acc}, _fun) do
      {:halted, acc}
    end
    def reduce(primes, {:suspend, acc}, fun) do
      {:suspended, acc, fn(cmd) -> reduce(primes, cmd, fun) end}
    end
    def reduce(primes, {:cont, acc}, fun) do
      {p, next} = Primes.next(primes)
      reduce(next, fun.(p,acc), fun)
    end
  end

  def next(%Primes{next: n}) do
    {p, n} = n.()
    {p, %Primes{next: n}}
  end

end
