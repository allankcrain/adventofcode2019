require 'pp'

class AsteroidField
    def initialize(file)
        @field = file.readlines.map { |line| line.chomp }

        # Get a list of asteroids
        @asteroids = []
        @field.each_with_index do |row, y|
            row.split('').each_with_index do |char, x|
                @asteroids << [x,y] if char=='#'
            end
        end
    end

    def asteroids
        @asteroids
    end

    # Return the list of other asteroids that ast can see
    def can_see(ast)
        # Get the polar coordinates of each asteroid relative to the base asteroid
        transteroids = @asteroids.select { |tgt| tgt != ast}.map do |tgt| 
            # Translated X and Y
            tx = tgt[0] - ast[0]
            ty = tgt[1] - ast[1]
            {
                real: tgt,
                r: Math.sqrt(tx*tx + ty*ty),
                phi: Math.atan2(ty, tx)
            }
        end

        # Now we filter the asteroids list to only have the
        # asteroid with the lowest 'r' value for a given phi.
        # (i.e., the closest asteroid at a given angle)
        filteroids = transteroids.select do |tgt|
            !transteroids.any? { |tgt2| tgt2[:phi] == tgt[:phi] && tgt2[:r] < tgt[:r] }
        end

        filteroids.map { |trn| trn[:real]}
    end

    def highest_visibility
        @asteroids.map {|ast| can_see(ast).count}.sort.last
    end
end
