require './intcode'
require 'pp'

class Paintbot
    DIRS = [
        [ 0,  1], # North
        [ 1,  0], # East
        [ 0, -1], # South
        [-1,  0]  # West
    ]

    def initialize(memcore, starting_grid=[])
        @vm = Intcode.new(memcore)
        @direction = 0
        @grid = starting_grid
        @visited = []
        @pos = [0,0]
    end

    def turn(dir)
        @direction = (dir==1 ? @direction + 1 : @direction - 1) % 4
    end

    def move(dir)
        turn(dir)
        @pos = [@pos[0]+DIRS[@direction][0],
                @pos[1]+DIRS[@direction][1]]
    end

    def paint(color)
        @grid.delete(@pos) 
        @grid << @pos if color==1

        @visited.delete(@pos)
        @visited << @pos
    end

    def camera
        @grid.include?(@pos) ? 1 : 0
    end

    def to_s
        # We don't want to draw to negative coordinates, so find the min/max x and y so we can adjust.
        exes = @grid.map{ |dot| dot[0] }.sort
        whys = @grid.map{ |dot| dot[1] }.sort
        dx = -exes[0]
        dy = -whys[0]
        
        gridjust = @grid.map{ |dot| [dot[0]+dx, dot[1]+dy] }

        # Now go through and build a picture
        output = ''
        for y in (whys.last+dy).downto(0) do # 
            for x in 0..(exes.last+dx) do
                output += gridjust.include?([x,y]) ? '#' : ' '
            end
            output += "\n"
        end
        output
    end

    def run
        # What to do with the output of the vm when it comes in
        painting = true
        step = ->(value) do
            painting ? paint(value) : move(value)
            painting = !painting
        end

        # Until the intcode VM halts,
        # 1. Provide the color of the current pos as input
        # 2. Get the value of the color to paint
        # 3. Get the new direction
        # 4. Move forward one panel
        until @vm.status == Intcode::STATUS_HALT do
            @vm.continue(camera, step)
        end
    end

    def visited
        return @visited.count
    end
end
