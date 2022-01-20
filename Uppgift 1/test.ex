defmodule Test do
    # Compute the double of a number
    def double(n) do
        n*2
    end

    def f_to_c(f) do
        (f-32)/1.8
    end

    def rectangle(b, h) do
        b*h    
    end

    def square(n) do
        rectangle(n,n)
    end

    def circle(r) do
        :math.pi()*r*r
    end
end


defmodule Recursive do 

    def product(m,n) do
        if m == 0 do
            0
        else
            n + product(m-1,n)
        end
    end


    def product_case(m,n) do
        case m do
            0 -> 0
            _ -> n + product_case(m-1,n)
        end
    end

    def product_cond(m,n) do
        cond do
            m == 0 -> 0
            true -> n + product_cond(m-1,n)
        end
    end

    def product_clauses(0,_) do 0 end
    def product_clauses(m,n) do
        product_clauses(m-1,n) + n
    end

    def exp(x,n) do
        case n do
            0 -> 1
            1 -> x
            _ -> product(x, exp(x,n-1))
        end
    end

    def exp2(x,n) do
        cond do
            n == 0 -> 1
            n == 1 -> x
            rem(x,2) == 0 -> exp2(x,div(n,2)) * exp2(x,div(n,2))
            rem(x,2) == 1 -> exp2(x,n-1) * x
        end
    end
end


defmodule Lists do 

    def nth([]) do 0 end
    def nth(n,[h|t]) do
        case n do
            0 -> h
            _ -> nth(n-1, t)
        end
    end

    def len([]) do 0 end
    def len([h|t]) do
        1 + len(t)
    end

    def sum([]) do 0 end
    def sum([h|t]) do
        h + sum(t)
    end

    def duplicate([]) do 0 end
    def duplicate([h|t]) do
        case t do
            [] -> [h, h]
            _ -> [h|[h|duplicate(t)]]
        end
    end

    def add(x, []) do [x] end 
    def add(x,[h|t]) do
        cond do
            x == h -> [h|t]
            t == [] -> [h, x]
            true -> [h | add(x,t)]
        end
    end

    def remove(x, []) do [] end
    def remove(x, [h|t]) do
        cond do
            h == x -> remove(x,t)
            true -> [h | remove(x,t)]
        end
    end

    def unique([]) do [] end
    def unique([h|t]) do
        [h | unique(remove(h, t))]
    end


    def pack([]) do [] end
    def pack([h|t]) do
        [[h | pack(h,t)] | pack(remove(h,t))]
    end
    def pack(_, []) do [] end
    def pack(h,[h|t]) do
      [h|pack(h,t)]  
    end
    def pack(h,[_|t]) do
      pack(h,t) 
    end


    def reverse([]) do [] end
    def reverse([h|t]) do reverse(t) ++ [h] end
end

defmodule Sorting do

    def insert(element, []) do [element] end
    def insert(element, [h|t]) do
        cond do
            element <= h -> [element|[h|t]]
            true -> [h | insert(element, t)]
        end
    end

    def isort([h|t]) do
        isort([h|t], [])
    end
    def isort(l, sorted) do
        case l do
            [] -> sorted
            [h|t] -> isort(t, insert(h, sorted))
        end
    end

    def isort2(l) do
        isort2(l, [])
    end

    def isort2([], sorted) do sorted end
    def isort2([h|t], sorted) do
        isort2(t, insert(h, sorted))
    end


        
    def msort(l) do
        case l do
            [] -> []
            [h] -> [h]
            [_|_] -> {low, high} = msplit(l, [], [])
            merge(msort(low), msort(high))
        end
    end

    def msplit(l, low, high) do 
        case l do 
            [] -> {low, high}
            [h|t]-> msplit(t, [h | high], low)
        end
    end

    def merge(low, []) do low end
    def merge([], high) do high end
    def merge(low = [h1|t1], high = [h2|t2]) do
        if h1 <= h2 do
            [h1 | merge(t1, high)]
        else
            [h2 | merge(low, t2)]
        end
    end
end



