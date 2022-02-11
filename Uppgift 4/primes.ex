  defmodule Bench do
    def bench(n) do
      IO.inspect (:timer.tc(fn -> First.first_fun(n) end))
      IO.inspect (:timer.tc(fn -> Second.second_fun(n) end))
      IO.inspect (:timer.tc(fn -> Third.third_fun(n) end))
      :ok
    end
  end

defmodule First do


    def first_fun([], primtal) do primtal end
    def first_fun([h|t], primtal) do
        acc = List.foldr(t, [], fn x, acc ->
                cond do
                    rem(x, h) == 0 -> acc
                    rem(x, h) != 0 -> [x] ++ acc
                end
            end)
        [h|first_fun(acc, primtal)]
    end
    def first_fun(p) do
      first_fun(Enum.to_list(2..p), [])
    end


end

defmodule Second do


    def second_fun(n) do
    list = Enum.to_list(2..n)
    second_fun(list, [])
    end

    def second_fun(list, primes) do
      case list do
        [] -> primes
        [h|t] ->
            var = checkP(list, primes)
            primes = insertP(var, h, primes)
            second_fun(t, primes)
      end
    end

    def checkP(_, []) do true end
    def checkP([h|t], primes=[h2|t2]) do
      cond do
        rem(h, h2) == 0 -> false
        true -> checkP([h|t], t2)
      end
    end

    def insertP(var, x, primes) do
      case var do
        true -> primes ++ [x]
        false -> primes
      end
    end
end

defmodule Third do
    def third_fun(n) do
    list = Enum.to_list(2..n)
    third_fun(list, [])
    end

    def insertPrime(bool, x, primes) do
      case bool do
        true -> [x] ++ primes
        false -> primes
      end
    end

    def checkPrime(_, []) do true end
    def checkPrime([h|t], primes=[h2|t2]) do
      cond do
        rem(h, h2) == 0 -> false
        true -> checkPrime([h|t], t2)
      end
    end

    def third_fun(list, primes) do
      case list do
        [] -> Enum.reverse(primes)
        [h|t] ->
            bool = checkPrime(list, primes)
            primes = insertPrime(bool, h, primes)
            third_fun(t, primes)
      end
    end
end
