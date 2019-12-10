# Intcode parser
class Intcode
    # Binary opcodes (i.e., 'a+b' or 'a*b' where you have two args and a return)
    # Since these are pretty simple (so far), we're just sticking procs directly in the hash.
    OPCODES_BINARYOP = {
        1 => ->(a,b) { a + b },
        2 => ->(a,b) { a * b },
        7 => ->(a,b) { a < b ? 1 : 0 },
        8 => ->(a,b) { a == b ? 1 : 0 }
    }

    OPCODE_INPUT = 3
    OPCODE_OUTPUT = 4
    OPCODE_JUMPIFTRUE = 5
    OPCODE_JUMPIFFALSE = 6
    OPCODE_REBASE = 9
    OPCODE_HALT = 99

    MODE_POSITION = 0
    MODE_IMMEDIATE = 1
    MODE_RELATIVE = 2

    OPCODE_NAMES = {
      1 => 'add ',
      2 => 'mult',
      3 => 'inp ',
      4 => 'out ',
      5 => 'jit ',
      6 => 'jif ',
      7 => 'lt  ',
      8 => 'eq  ',
      9 => 'reb ',
      99 => 'halt',
    }

    STATUS_RUN  = 0
    STATUS_INPUT = 3
    STATUS_HALT  = 99

    # Create the intcode processor with the given memory array
    def initialize(memory = [], debug_mode = false)
        @memory = memory.clone
        @ip = 0
        @modes = []
        @opcode = 0
        @input = []
        @output = []
        @base = 0
        @debug_mode = debug_mode
        @status = STATUS_RUN
    end

    def self.file2mem(file)
      file.read.split(',').map { |value| value.to_i }
    end

    # Debugging output helper
    def dbg
      if @debug_mode then
        opname = (OPCODE_NAMES.key? @opcode) ? OPCODE_NAMES[@opcode] : "HCF(#{@opcode})"
        args = case @opcode
        when 1, 2, 7, 8
          "#{dbga(0)}, #{dbga(1)} => #{dbga(2,true)}"
        when 3
          "#{@input[0]} => #{dbga(0,true)}"
        when 4, 9
          "#{dbga(0)}"
        when 5, 6
          "#{dbga(0)} to #{dbga(1)}"
        else
          ""
        end
        puts "@#{@ip-1}: #{opname} #{args} "
      end
    end

    def dbga(pos, sto=false)
      mode = @modes[-(1+pos)]
      if sto then
        return "@#{peek(MODE_IMMEDIATE, pos)}"
      elsif mode == MODE_POSITION then
        return "*#{peek(MODE_IMMEDIATE, pos)}(#{peek(MODE_POSITION, pos)})"
      elsif mode == MODE_RELATIVE then
        return "*#{peek(MODE_IMMEDIATE, pos)}+#{@base}(#{peek(MODE_RELATIVE, pos)})"
      else
        return "#{peek(MODE_IMMEDIATE, pos)}"
      end
    end

    def decode_step
      value = peek
      # Pad out the code to a five digit string
      padded = ('0' * (5-value.to_s.length)) + value.to_s
      # Set up our argument state
      @modes = padded[0..2].split('').map{|i| i.to_i}
      # Advance the instruction pointer
      @ip += 1
      @opcode = padded[3..4].to_i
    end

    def peek(mode = MODE_IMMEDIATE, pos=0)
      value = case mode
      when MODE_IMMEDIATE
        @memory[@ip+pos]
      when MODE_POSITION
        @memory[peek(MODE_IMMEDIATE, pos)]
      when MODE_RELATIVE
        @memory[peek(MODE_IMMEDIATE, pos) + @base]
      end

      value == nil ? 0 : value
    end

    def argument
      value = peek(@modes.pop)

      @ip += 1
      value
    end

    def sto_argument
      value = peek
      @modes.pop
      @ip += 1
      value
    end

    def step
      opcode = decode_step
      output = nil
      dbg()
      # For binary opcodes
      if OPCODES_BINARYOP.key? opcode then
        # Get the argument values
        a = argument
        b = argument
        sto = sto_argument
        # Set the output address value to the result of the opcode call
        @memory[sto] = OPCODES_BINARYOP[opcode].call(a,b)

      elsif opcode==OPCODE_INPUT then
        sto = sto_argument
        if @input.length > 0 then
          @memory[sto] = @input.shift
        else
          puts 'Supply input:'
          @memory[sto] = STDIN.gets.chomp.to_i
        end
        @status = STATUS_RUN
      elsif opcode==OPCODE_OUTPUT then
        a = argument
        output = a
        @output << a
      elsif opcode==OPCODE_JUMPIFTRUE then
        test = argument
        new_location = argument
        @ip = new_location if test != 0
      elsif opcode==OPCODE_JUMPIFFALSE then
        test = argument
        new_location = argument
        @ip = new_location if test == 0
      elsif opcode=OPCODE_REBASE
        @base = argument
      elsif opcode==OPCODE_HALT
        @status = STATUS_HALT
      # Halt and catch fire
      else
          fail "Unknown opcode #{opcode} at instruction pointer #{@ip}"
          @status = STATUS_HALT
      end

      output
    end

    def continue(input = [])
      @status = STATUS_RUN
      @input += input if input.class == Array
      @input << input if input.class == Fixnum
      output = nil
      while @status == STATUS_RUN do
        if (peek != OPCODE_INPUT) || @input.length >0 then
          output = step
        else
          @status = STATUS_INPUT
        end
      end
      output
    end

    # Run this computer on its input memory starting at location 0
    def run(input=[])
        @output = []
        @input = input.clone
        # Start the instruction pointer at 0
        @ip = 0
        @status = STATUS_RUN
        # Keep going until we crash or hit a halt opcode
        while peek != OPCODE_HALT do
          output = step
          puts "OUT: #{output}" unless output==nil
        end
        @status = STATUS_HALT
        @output
    end

    # Memory accessor
    def memory
        @memory
    end

    # Output lives in memory location zero if not explicitly set
    def output
        @output.clone
    end

    def status
      @status
    end
end
