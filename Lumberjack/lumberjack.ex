defmodule Lumber do

  def bench(n) do
    for i <- 1..n do
      {t,_} = :timer.tc(fn() -> cost(Enum.to_list(1..i)) end)
      IO.puts(" n = #{i}\t t = #{t} us")
    end
  end

  def split(seq) do split(seq, 0, [], []) end

  def split([], length, left, right) do
    {left, right, length}
  end

  def split([h|rest], length, left, right) do
    split(rest, length+h, [h|left], right) ++
    split(rest, length+h, left, [h|right])
  end


  #ONLY RETURNS COST
  #def cost([]) do 0 end
  #def cost([_]) do 0 end
  #def cost(seq) do cost(seq, 0, [], []) end
  #def cost([], l, left, right) do
  #  cost(left) + cost(right) + l
  #end
  #def cost([s], l, [], right) do
  #  cost(right) + l + s
  #end
  #def cost([s], l, left, right) do
  #  cost(left) + l + s
  #end
#
  #def cost([s|rest], l, left, right) do
  #  cl = cost(rest, l+s, [s|left], right)
  #  cr = cost(rest, l+s, left, [s|right])
  #  if cl < cr do
  #    cl
  #  else
  #    cr
  #  end
  #end


  #COST AND TREE
  #def cost([]) do 0 end
  #def cost([s]) do {0, s} end
  #def cost(seq) do cost(seq, 0, [], []) end
#
  #def cost([], l, left, right)  do
  #  {cl, sl} = cost(left)
  #  {cr, sr} = cost(right)
  #  {cl + cr + l, {sl,sr}}
  #end
  #def cost([s], l, [], right)  do
  #  {cr, sr} = cost(right)
  #  {cr + l + s, {s, sr}}
  #end
  #def cost([s], l, left, [])  do
  #  {cl, sl} = cost(left)
  #  {cl + l + s, {sl, s}}
  #end
  #def cost([s|rest], l, left, right) do
  #  {cl, sl} = cost(rest, l+s, [s|left], right)
  #  {cr, sr} = cost(rest, l+s, left, [s|right])
  #  if cl < cr do
  #    {cl, sl}
  #  else
  #    {cr, sr}
  #  end
  #end


  def cost([]) do {0, :na} end
  def cost(seq) do
    {cost, tree, _} = cost(Enum.sort(seq), Mem.new())
    {cost, tree}
  end
  def cost([s], mem) do {0, s, mem} end
  def cost([s|rest]=seq, mem) do
    {c, t, mem} = cost(rest, s, [s], [], mem)
    {c, t, Mem.add(mem, seq, {c, t})}
  end

  def check(seq, mem) do
    case Mem.lookup(mem, seq) do
      nil -> cost(seq, mem)
      {c, t} -> {c, t, mem}
    end
  end

  def cost([], l, left, right, mem) do
    {cl, sl, mem} = check(Enum.reverse(left), mem)
    {cr, sr, mem} = check(Enum.reverse(right), mem)
    {cl + cr + l, {sl, sr}, mem}
  end

  def cost([s], l, left, [], mem) do
    {cl, sl, mem} = check(Enum.reverse(left), mem)
    {cl + l + s, {sl, s}, mem}
  end

  def cost([s], l, [], right, mem) do
    {cr, sr, mem} = check(Enum.reverse(right), mem)
    {cr + l + s, {sr, s}, mem}
  end

  def cost([s|rest], l, left, right, mem) do
    {cl, sl, mem} = cost(rest, l + s, [s|left], right, mem)
    {cr, sr, mem} = cost(rest, l + s, left, [s|right], mem)
    if cl < cr do
      {cl, sl, mem}
    else
      {cr, sr, mem}
    end
  end



end


defmodule Memo do
  def new() do %{} end

  def add(mem, key, val) do
    Map.put(mem, :binary.list_to_bin(key), val)
  end
  def lookup(mem, key) do
    Map.get(mem, :binary.list_to_bin(key))
  end

end

defmodule Mem do
    def new() do [] end

    def add(mem, [n], val) do
      insert(mem, n, val)
    end
    def add(mem, [n|ns], val) do add(mem, n, ns, val) end

    def add([], n, rest, value) do [{n, nil, add([], rest, value)}] end
    def add([{n, val, sub}|mem], n, rest, value) do [{n, val, add(sub, rest, value)}|mem] end
    def add([first|mem], n, rest, value) do [first| add(mem, n, rest, value)] end

    def insert([], n, val) do [{n, val, []}] end
    def insert([{n, nil, sub}|mem], n, val) do [{n, val, sub}|mem] end
    def insert([first|mem], n, val) do [first| insert(mem, n, val)] end

    def lookup([], _) do nil end
    def lookup(mem, [n]) do val(mem, n) end
    def lookup(mem, [n|ns]) do lookup(mem, n, ns) end

    def lookup([], _, _) do nil end
    def lookup([{n, _, sub}|_], n, ns) do lookup(sub, ns) end
    def lookup([_|mem], n, ns) do lookup(mem, n, ns) end

    def val([], _) do nil end
    def val([{n, val, _}|_], n) do val end
    def val([_|rest], n) do val(rest, n) end


    def to_list(mem) do to_list(mem,[]) end

    def to_list([], _) do [] end
    def to_list([{n,nil,sub}|rest], seq) do
      to_list(sub, [n|seq]) ++ to_list(rest, seq)
    end
    def to_list([{n,val,sub}|rest], seq) do
        [{Enum.reverse([n|seq]), val} | to_list(sub, [n|seq])] ++  to_list(rest, seq)
    end
end
