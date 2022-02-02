defmodule First do
    def primeList(p) do
        removePrime(Enum.to_list(2..p))
    end
    def removePrime([h|t]) do
        removePrime([h|t], h)
    end

    def removePrime([], first) do [] end
    def removePrime([h|t], first) do
        cond do
            rem(h, first) == 0 -> removePrime(t, first)
            rem(h, first) != 0 -> [h|removePrime(t, first)]
        end
    end
end

defmodule Second do
    def primeList(p) do remover(Enum.to_list(2..p), new()) end
    def remover(list, primtal) do remover(list, Enum.at(list, 0), 0, primtal) end
    def remover(list, divValue, acc, primtal) do
        [h|t] = list
        valueInList = Enum.at(list, acc)
        cond do
            valueInList == nil -> primtal
            rem(valueInList, divValue) == 0 -> remover(list, divValue, acc+1, primtal)
            rem(valueInList, divValue) != 0 ->
                case checkPrimtal(primtal, valueInList, 0) do
                    0 -> remover(list, divValue, acc+1, primtal)
                    1 -> 
                        primtal = add(primtal, valueInList)
                        remover(list, divValue, acc+1, primtal)
                end
        end
    end

    def new() do [] end
    def add(primtal, s) do
        primtal = primtal ++ [s]
    end
    def checkPrimtal(primtal, s, tracker) do
        valueAtTracker = Enum.at(primtal, tracker)
        cond do 
            valueAtTracker == nil -> 1
            rem(s, valueAtTracker) == 0 -> 0
            rem(s, valueAtTracker) != 0 -> checkPrimtal(primtal, s, tracker+1)
        end
    end
end

defmodule Third do 
    def primeList(p) do remover(Enum.to_list(2..p), new()) end
    def remover(list, primtal) do remover(list, Enum.at(list, 0), 0, primtal) end
    def remover(list, divValue, acc, primtal) do
        [h|t] = list
        valueInList = Enum.at(list, acc)
        cond do
            valueInList == nil -> Enum.reverse(primtal)
            rem(valueInList, divValue) == 0 -> remover(list, divValue, acc+1, primtal)
            rem(valueInList, divValue) != 0 ->
                case checkPrimtal(primtal, valueInList, 0) do
                    0 -> remover(list, divValue, acc+1, primtal)
                    1 -> 
                        primtal = add(primtal, valueInList)
                        remover(list, divValue, acc+1, primtal)
                end
        end
    end

    def new() do [] end
    def add(primtal, s) do
        [s|primtal]
    end
    def checkPrimtal(primtal, s, tracker) do
        valueAtTracker = Enum.at(primtal, tracker)
        cond do 
            valueAtTracker == nil -> 1
            rem(s, valueAtTracker) == 0 -> 0
            rem(s, valueAtTracker) != 0 -> checkPrimtal(primtal, s, tracker+1)
        end
    end
end