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
        List.delete_at(registry, register)
        List.insert_at(registry, register, value)
    end
end


defmodule Program do
    def read_instruction(code, pc) do
        Enum.at(code, div(pc, 4))
    end

    def load({:prgm, code, data}) do
        {code, data}
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
        IO.inspect(out)
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
        case next do
            :halt ->
            Out.close(out)
            
            {:add, rd, rs, rt} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                reg = Register.write(reg, rd, s + t) # well, almost
                run(pc, code, reg, mem, out)
            
            {:addi, rd, rs, im} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                reg = Register.write(reg, rd, s + im)
                run(pc, code, reg, mem, out)

            {:sub, rd, rs, rt} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                reg = Register.write(reg, rd, s - t)
                run(pc, code, reg, mem, out)

            {:bne, rs, rt, label} ->
                s = Register.read(reg, rs)
                t = Register.read(reg, rt)
                if (s != t) do
                    pc = pc + 4 + 
                end

            {:label, pc, }

            {:out, rs} ->
                pc = pc + 4
                s = Register.read(reg, rs)
                out = Out.put(out, s)
                IO.inspect reg, label: "This is reg"
                run(pc, code, reg, mem, out)
        end
    end
end


defmodule Test do
        

    def test1() do

        data = []

        code = [{:addi, 1, 0, 5},
        ##{:lw, 2, 0, :arg},
        {:add, 4, 2, 1},
        #{:addi, 5, 0, 1},
        #{:label, :loop},
        #{:sub, 4, 4, 5},
        {:out, 4},
        ##{:bne, 4, 0, :loop},
        :halt]

        Emulator.run({:prgm, code, data})
     end

end