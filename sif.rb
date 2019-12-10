class Sif
    PX_BLK = 0
    PX_WHT = 1
    PX_CLR = 2

    def initialize(width,height)
        @width = width
        @height = height
        @layers = []
    end

    # Load the input into layers.
    # Input is assumed to be an array of ints
    def load(input)
        layer = 0
        input = input.clone
        while input.length > 0 do
            @layers[layer] = []
            for row in 1..@height do
                @layers[layer] << input.shift(@width)
            end
            layer += 1
        end
        puts "Loaded #{@layers.count} layers"
    end

    def numzInLayer(layer, num)
        count = 0
        layer.each do |row|
            row.each do |pixel| 
                count += 1 if pixel==num
            end
        end
        count
    end

    def checksum
        # Find the layer with the fewest zeros
        sorted_layers = @layers.clone.sort { |a, b| numzInLayer(a, 0) <=> numzInLayer(b, 0) }
        least_zeros = sorted_layers[0]
        numzInLayer(least_zeros, 1) * numzInLayer(least_zeros, 2)
    end

    def to_s
        output = ''
        @layers.each do |layer|
            layer.each do |row|
                output += row.join + "\n"
            end
            output += "\n"
        end
        output
    end

    def get_pixel_at(x,y)
        layer = -1
        pixel = PX_CLR
        while pixel == PX_CLR && (layer+=1) <= @layers.size do
            pixel = @layers[layer][y][x]
        end
        # puts "The pixel at (#{x},#{y}) is #{pixel} because layer #{layer}"
        pixel
    end

    def render
        dot = ' #'
        rendered_layer = "\n " + ('_' * (@width+2)) + "\n"
        for y in 0..@height-1 do
            rendered_layer += '| '
            for x in 0..@width-1 do
                rendered_layer += dot[get_pixel_at(x, y)]
            end
            rendered_layer += " |\n"
        end

        rendered_layer += ' ' + ('-' * (@width+2)) + "\n"
        rendered_layer
    end
end
