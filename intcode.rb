# Intcode parser
class Intcode
    # Binary opcodes (i.e., 'a+b' or 'a*b' where you have two args and a return)
    # Since these are pretty simple (so far), we're just sticking procs directly in the hash.
    OPCODES_BINARYOP = {
        1 => ->(a,b) { a + b },
        2 => ->(a,b) { a * b }
    }

    # The HALT opcode
    OPCODE_HALT = 99

    # Create the intcode processor with the given memory array
    def initialize(memory = [])
        @memory = memory
        @ip = 0
    end

    # Run this computer on its input memory starting at location 0
    def run
        # Start the instruction pointer at 0
        @ip = 0
        # Keep going until we crash or hit a halt opcode
        while (opcode = @memory[@ip]) != OPCODE_HALT do
            # For binary opcodes
            if OPCODES_BINARYOP.key? opcode then
                # Get memory at locations pointed to by the next two ints and the output address
                a = @memory[@memory[@ip+1]]
                b = @memory[@memory[@ip+2]]
                sto = @memory[@ip+3]

                # Set the output address value to the result of the opcode call
                @memory[sto] = OPCODES_BINARYOP[opcode].call(a,b)
                @ip += 4
            # Halt and catch fire
            else
                fail "Unknown opcode #{opcode}"
            end
        end
    end

    # Memory accessor
    def memory
        @memory
    end

    # Output lives in memory location zero
    def output
        @memory[0]
    end
end
