require './intcode'

class Arcade
  def initialize(memcore)
    @screen = []
    @cpu = Intcode.new(memcore)
  end

  def play
    state = []

    output_handler = ->value do
      state << value if state.length < 3
      if state.length == 3 then
        @screen << state.clone
        state = []
      end
    end

    while @cpu.status != Intcode::STATUS_HALT do
      @cpu.continue(nil, output_handler)
    end
    @screen
  end
end
