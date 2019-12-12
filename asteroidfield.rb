require 'pp'

class AsteroidField
    def initialize(file)
        @field = file.readlines.map { |line| line.chomp }

        # Get a list of asteroids
        @asteroids = []
        @field.each_with_index do |row, y|
            row.split('').each_with_index do |char, x|
                @asteroids << [x,y] if char=='#' || char=='X'
            end
        end
    end

    def asteroids
        @asteroids
    end

    # Get the list of asteroids relative to the given asteroid.
    # Does a little bit of trig so we have angles and distances to
    # the other asteroids relative to the given asteroid as if it were
    # the polar origin
    def get_relative_asteroids(ast)
      # Get the polar coordinates of each asteroid relative to the base asteroid
      transteroids = @asteroids.select { |tgt| tgt != ast}.map do |tgt|
          # Translated X and Y
          tx = tgt[0] - ast[0]
          ty = tgt[1] - ast[1]
          # Calculate the angle, then change phi so anything left of -pi/2 (up)
          # comes after pi.
          phi = Math.atan2(ty, tx)
          phi = Math::PI + Math::PI + phi if phi < -Math::PI/2
          {
              real: tgt,
              r: Math.sqrt(tx*tx + ty*ty),
              phi: phi
          }
      end
      transteroids
    end

    # Return the list of other asteroids that ast can see
    def can_see(ast)
        transteroids = get_relative_asteroids(ast)

        # Now we filter the asteroids list to only have the
        # asteroid with the lowest 'r' value for a given phi.
        # (i.e., the closest asteroid at a given angle)
        transteroids.select do |tgt|
            !transteroids.any? { |tgt2| tgt2[:phi] == tgt[:phi] && tgt2[:r] < tgt[:r] }
        end
    end

    # List of potential targets for zapping, ordered rotationally starting from north
    def targets(ast)
      can_see(ast).sort{ |a,b| a[:phi] <=> b[:phi] }
    end

    # Get the asteroid that has the highest visibility of other asteroids
    def highest_visibility
        @asteroids.map {|ast| [ast, can_see(ast).count]}.sort{ |a,b| a[1]<=>b[1] }.last
    end

    # Blow the given asteroid out of the sky. Removes it from the asteroids list
    # so it will no longer come back in can_see or relative_asteroids returns.
    def zap(asteroid)
      @asteroids.delete(asteroid)
    end
end
