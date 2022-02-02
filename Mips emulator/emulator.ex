defmodule Register do
    def new() do
        [0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        ]
    end

    def read(registry, register) do
        Enum.at(registry, register)
    end

    def write(registry, register, value) do
        List.replace_at(registry, register, value)
    end
end


defmodule Program do
    def read_instruction(code, pc) do
        Enum.at(code, div(pc, 4))
    end

    def load({:prgm, code, data}) do
        {code, data}
    end

    def read_word({:data, data}, i) do
        0 = rem(i,4)    ## addr must be amultiple of 4
        Map.get(data, i)
    end

    def write_word({:data, data}, i, val) do
        0 = rem(i, 4)   ## addr must be amultiple of 4
        {:data, Map.put(data, i, val)}
    end 

end


defmodule Out do

    def new() do
        []
    end

    def put(out, s) do
        [s|out]
    end

    def close(out) do
      Enum.reverse(out)
    end
end

defmodule Emulator do
    #gdata = [{:label, :arg}, {:word, 12}]



    def run(prgm) do
        {code, data} = Program.load(prgm)
        out = Out.new()
        reg = Register.new()
        run(0, code, reg, data, out)
    end


    def run(pc, code, reg, mem, out) do
        next = Program.read_instruction(code, pc)
        IO.inspect next, label: "This is next at pc: #{pc}: "
        case next do
            :halt ->
            IO.inspect reg, label: "This is reg\n"
            Out.close(out)
            
            {:add, rd, rs, rt} ->
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                reg = Register.write(reg, rd, s + t) # well, almost
                run(pc+4, code, reg, mem, out)
            
            {:addi, rd, rs, im} ->
                s = Register.read(reg, rs)
                reg = Register.write(reg, rd, s + im)
                run(pc+4, code, reg, mem, out)

            {:label, name} ->
                mem = [{name, pc} | mem]
                run(pc+4, code, reg, mem, out)


            {:sub, rd, rs, rt} ->
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                reg = Register.write(reg, rd, s - t)
                run(pc+4, code, reg, mem, out)

            {:beq, rs, rt, label} ->
                labelPC = Keyword.fetch!(mem, label)
                a = Register.read(reg, rs)
                b = Register.read(reg, rt)
                pc = if a == b do  labelPC else pc end
                run(pc+4, code, reg, mem, out)

            {:bne, rs, rt, label} ->
                labelPC = Keyword.fetch!(mem, label)
                a = Register.read(reg, rs)
                b = Register.read(reg, rt)
                pc = if a != b do labelPC else pc end
                run(pc+4, code, reg, mem, out)

            {:lw, rd, rs, imm} ->
	            val = Keyword.fetch!(mem, imm)
	            reg = Register.write(reg, rd, val)
                IO.inspect reg, label: "This is reg "
	            run(pc+4, code, reg, mem, out)

            {:sw, rs, rt, imm} ->
                s = Register.read(reg, rs) 
                IO.write("Finns på $#{rs}: #{s}")
                mem = [{imm, s} | mem]
                IO.inspect mem, label: "This is mem "
                run(pc+4, code, reg, mem, out)


            {:out, rs} ->
                s = Register.read(reg, rs)
                out = Out.put(out, s)
                run(pc+4, code, reg, mem, out)
        end
    end
end


defmodule Test do
        

    def test1() do

        #[ {:label, :arg}, {:word, 12} ]
        data = Keyword.new()
        #code = [{:addi, 1, 0, 2}, # $1 <- 5
        #        {:add, 4, 2, 1}, # $4 <- $2 + $1
        #        {:addi, 5, 0, 1}, # $5 <- 1
        #        {:label, :loop},
        #        {:sub, 4, 4, 5}, # $4 <- $4 - $5
        #        {:out, 4}, # out $4
        #        {:bne, 4, 0, :loop}, # branch if not equal
        #        :halt]

           code = [
                {:addi, 1, 0, 1},
                {:addi, 10, 0, 10},
                {:addi, 9, 0, 9},
                {:addi, 2, 0, 5},
                {:sw, 10, 0, :arg},
                {:lw, 2, 0, :arg},
                {:label, :loop}, 
                {:sub, 2, 2, 1}, 
                {:out, 2},
                {:bne, 1, 2, :loop}, 
                :halt]

        Emulator.run({:prgm, code, data})
     end

end