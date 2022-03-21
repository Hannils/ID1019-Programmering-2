defmodule Shunt do
  alias Moves
  alias Processing
  def split(xs, y) do
    {Processing.take(xs, Processing.position(xs, y)-1), Processing.drop(xs, Processing.position(xs, y))}
  end

  def find(xs, ys) do
        case ys do
          [] -> []
          [y|s] ->
            {hs, ts} = split(xs, y)
            move = Moves.single({:one, length(ts)+1}, {xs, [], []})
            move = Moves.single({:two, length(hs)}, move)
            move = Moves.single({:one, -(length(ts)+1)}, move)
            {[_|t2], [], []} = Moves.single({:two, -(length(hs))}, move)
            [{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))} | find(t2, s)]
        end
  end

  def few([x|i], [x|o]) do few(i, o) end
  def few(xs, ys) do
    case ys do
      [] -> []
      [y|s] ->
        {hs, ts} = split(xs, y)
        move = Moves.single({:one, length(ts)+1}, {xs, [], []})
        move = Moves.single({:two, length(hs)}, move)
        move = Moves.single({:one, -(length(ts)+1)}, move)
        {[_|t2], [], []} = Moves.single({:two, -(length(hs))}, move)
        compress([{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))} | few(t2, s)])
    end
  end

  def rules([{_, 0}|t]) do rules(t) end
  def rules([{y, x}, {y, z} | t]) do [{y, x+z} | rules(t)] end
  def rules([h|t]) do [h | rules(t)] end
  def rules ([]) do [] end
  def compress(ms) do
    ns = rules(ms)
    if (ns == ms) do
      ms
    else
      compress(ns)
    end
  end
end
