class Moon
  attr_reader :x, :y, :z, :v

  def initialize(text)
    matches = text.match(/x=(?<x>-?[0-9]+), y=(?<y>-?[0-9]+), z=(?<z>-?[0-9]+)/)
    @x = matches[:x].to_i
    @y = matches[:y].to_i
    @z = matches[:z].to_i
    @v = [0,0,0]
  end

  # Adjust the velocity of this moon based on the given other moon
  def gravitate(moon)
    @v[0] += moon.x <=> @x
    @v[1] += moon.y <=> @y
    @v[2] += moon.z <=> @z
  end

  # Adjust the position of this moon based on its velocity
  def orbit
    @x += @v[0]
    @y += @v[1]
    @z += @v[2]
  end

  def potential
    @x.abs + @y.abs + @z.abs
  end

  def kinetic
    @v[0].abs + @v[1].abs + @v[2].abs
  end

  def totalenergy
    potential * kinetic
  end

  def to_s
    "pos=<x=#{@x}, y=#{@y}, z=#{@z}>, vel=<x=#{@v[0]}, y=#{@v[1]}, z=#{@v[2]},>"
  end
end
