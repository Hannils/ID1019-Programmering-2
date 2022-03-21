defmodule Moves do
  alias Processing

    def single({:one, x}, {list, one, two}=start) do
      cond do
        x == 0 -> start
        x < 0 ->
          {Processing.append(list, Processing.take(one, x*-1)),Processing.drop(one, x*-1), two}
        x > 0 ->
          {Processing.take(list, length(list)-x), Processing.append(one, Processing.drop(list, length(list)-x)), two}
      end
    end
    def single({:two, x}, {list, one, two}=start) do
      cond do
        x == 0 -> start
        x < 0 ->
          {Processing.append(list, Processing.take(two, x*-1)), one, Processing.drop(two, x*-1)}
        x > 0 ->
          {Processing.take(list, length(list)-x), one, Processing.append(two, Processing.drop(list, length(list)-x))}
      end
    end

    def move([], start) do [start] end
    def move([h|t]=moves, {list, one, two}=start) do
      [start | move(t, single(h, start))]
    end
end
