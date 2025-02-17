defmodule Bench do

  def bench() do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    time = fn (i, f) ->
      seq = Enum.map(1..i, fn(_) -> :rand.uniform(100000) end)
      elem(:timer.tc(fn () -> f.(seq) end),0)
    end

    bench = fn (i) ->

      list = fn (seq) ->
        List.foldr(seq, list_new(), fn (e, acc) -> list_insert(e, acc) end)
      end

      tree = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert(e, acc) end)
      end      

      tl = time.(i, list) 
      tt = time.(i, tree)     

      IO.write("  #{tl}\t\t\t#{tt}\n")
    end

    IO.write("# benchmark of lists and tree \n")
    Enum.map(ls, bench)

    :ok
  end
  
  def list_new() do [] end
  
  def list_insert(e, []) do [e] end
  def list_insert(e, [h|t]) do
    cond do
        e < h -> [e,h|t]
        true -> [h|list_insert(e,t)]
    end
  end
  
  def tree_new() do :nil end
  def tree_insert(val, :nil) do {:leaf, val} end
  def tree_insert(val, {:leaf, l}) do
    cond do
        val < l -> {:node, val, :nil, {:leaf, l}}
        true -> {:node, val, {:leaf, l}, :nil}
    end
  end

  def tree_insert(val, {:node, l, left, right}) do
    cond do
        val < l -> {:node, l, left, tree_insert(val, right)}
        true -> {:node, l, tree_insert(val, left), right}
    end
  end




end