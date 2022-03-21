defmodule Processing do
  def take(_, 0) do [] end
  def take([h|t], n) do
    [h|take(t, n-1)]
  end

  def drop(xs, 0) do xs end
  def drop([h|t], s) do
    drop(t, s-1)
  end

  def append(xs, ys) do
    xs ++ ys
  end

  def member([], _) do false end
  def member([h|t], y) do
    case h == y do
      true -> true
      false -> member(t, y)
    end
  end

  def position([y|rest], y) do 1 end
  def position([h|t], y) do
     1 + position(t, y)
  end
end
