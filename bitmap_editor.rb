

##
# Class representing a single square in a Bitmap.
##
class Square

  ##
  # Initializes an instance.
  # Params:
  # +x+:: For reference. Represents the x value in the grid.
  # +y+:: For reference. Represents the y value in the grid.
  # +color+:: The color of the square, represented by a capital letter.
  # All of these attributes are accessible.
  ##
  def initialize (x, y, color='O')
    @x = x
    @y = y
    @color = color
  end


  attr_accessor :x, :y, :color

  ##
  # Alias to _color_.
  # Params:
  # +color+:: The color of the square, represented by a capital letter.
  ##
  def fill (color)
    @color = color
  end

end




##
# Class representing a Bitmap as a bidimensional array.
##
class Bitmap

  
  ##
  # Initializes an instance.
  # Params:
  # +height+:: Height of the bitmap in squares.
  # +width+:: Width of the bitmap in squares.
  # +color+:: (optional) The color of all the squares in the bitmap. Defaults to "O".
  ##
  def initialize (height, width, color='O')
    raise "Color not recognized." unless is_valid_color?(color)
    
    @height = height
    @width = width
    @matrix = []
    (1..@height).each do |y|
      row = []
      (1..@width).each do |x|
        row << Square.new(x, y, color)
      end
      @matrix << row
    end
  end


  ##
  # Clears the bitmap, leaving all squares with the same color.
  # Params:
  # +color+:: (optional) The new color of all the squares in the bitmap. Defaults to "O".
  ##
  def clear (color='O')
    raise "Color not recognized." unless is_valid_color?(color)
    
    (0..@height-1).each do |y|
      (0..@width-1).each do |x|
        @matrix[x][y].fill color
      end
    end
  end


  ##
  # Prints a readable representation of the bitmap on the screen.
  ##
  def pretty_print
    (0..@height-1).each do |y|
      (0..@width-1).each do |x|
        print @matrix[y][x].color
      end
      puts
    end
  end


  ##
  # Assigns a single square with a color.
  # Params:
  # +x+:: X coordinate of the square.
  # +y+:: Y coordinate of the square.
  # +color+:: The new color of the square.
  ##
  def fill_point (x, y, color)
    raise "X value is out of range." if x > @width or x <= 0
    raise "Y value is out of range." if y > @height or y <= 0
    raise "Color not recognized." unless is_valid_color?(color)

    @matrix[y-1][x-1].fill color
  end


  ##
  # Draws a vertical segment in the bitmap with a color.
  # Params:
  # +x+:: X coordinate for the segment in the grid.
  # +y1+:: Y coordinate for the start of the segment.
  # +y2+:: Y coordinate for the end of the segment.
  # +color+:: The color of the segment drawn.
  ##
  def fill_vertical_segment (x, y1, y2, color)
    raise "X value is out of range." if x > @width or x <= 0
    raise "Y1 value is out of range." if y1 > @height or y1 <= 0
    raise "Y2 value is out of range." if y2 > @height or y2 <= 0
    raise "Color not recognized." unless is_valid_color?(color)

    y2, y1 = y1, y2 if y1 > y2 # Swap variable order if necessary.

    (y1..y2).each do |y|
      fill_point(x, y, color)
    end
  end


  ##
  # Draws a horizontal segment in the bitmap with a color.
  # Params:
  # +x1+:: X coordinate for the start of the segment.
  # +x2+:: X coordinate for the end of the segment.
  # +y+:: Y coordinate for the segment in the grid.
  # +color+:: The color of the segment drawn.
  ##
  def fill_horizontal_segment (x1, x2, y, color)
    raise "X1 value is out of range." if x1 > @width or x1 <= 0
    raise "X2 value is out of range." if x2 > @width or x2 <= 0
    raise "Y value is out of range." if y > @height or y <= 0
    raise "Color not recognized." unless is_valid_color?(color)

    x2, x1 = x1, x2 if x1 > x2 # Swap variable order if necessary.

    (x1..x2).each do |x|
      fill_point(x, y, color)
    end
  end


  ##
  # Recursive method to fill an area in the bitmap defined by squared of the same color.
  # Params:
  # +x+:: X coordinate for the point where the fill will originate.
  # +y+:: Y coordinate for the point where the fill will originate.
  # +color+:: The color of the area drawn.
  # +original_color+:: *Do not use*. Parameter reserved for the use of recursion.
  ##
  def fill_area (x, y, color, original_color=nil)
    raise "X value is out of range." if x > @width or x <= 0
    raise "Y value is out of range." if y > @height or y <= 0
    raise "Color not recognized." unless is_valid_color?(color)

    original_color = @matrix[y-1][x-1].color unless original_color
    
    adjacents_with_same_color = adjacents(x, y).select {|square| square.color == original_color}
    fill_point(x, y, color)
    adjacents_with_same_color.each {|square| fill_area square.x, square.y, color, original_color}
  end


  ##
  # Draws a square defined with two points.
  # Params:
  # +x1+:: X coordinate for the starting point.
  # +y1+:: Y coordinate for the starting point.
  # +x2+:: X coordinate for the ending point.
  # +y2+:: Y coordinate for the ending point.
  # +color+:: The color of the square.
  ##
  def fill_square (x1, y1, x2, y2, color)
    raise "X1 value is out of range." if x1 > @width or x1 <= 0
    raise "Y1 value is out of range." if y1 > @width or y1 <= 0
    raise "X2 value is out of range." if x2 > @width or x2 <= 0
    raise "Y2 value is out of range." if y2 > @width or y2 <= 0
    raise "Color not recognized." unless is_valid_color?(color)

    #x2, x1 = x1, x2 if x1 > x2 # Swap variable order if necessary.
    #y2, y1 = y1, y2 if y1 > y2 # Swap variable order if necessary.

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        fill_point(x, y, color)
      end
    end
  end




  private

  ##
  # All capital letter are valid colors.
  ##
  def is_valid_color? (color)
    /[[:upper:]]/.match(color)
  end


  ##
  # Method returning the adjacent and existent squares starting in one determined by x and y.
  ##
  def adjacents (x, y)
    result = []
    (-1..1).each do |x_increment|
      (-1..1).each do |y_increment|
        next if y+y_increment > @height or y+y_increment <= 0
        next if x+x_increment > @width or x+x_increment <= 0
        next if x_increment == 0 and y_increment == 0

        result << @matrix[y+y_increment-1][x+x_increment-1]
      end
    end
    result
  end


end


##
# Show available commands on screen.
##
def show_help
  puts "Supported commands are:"
  puts "I M N to create a new M x N image with all pixels coloured white."
  puts "C to clear the table."
  puts "L X Y C to colour the pixel in position (X,Y) with colour C."
  puts "V X Y1 Y2 C to draw a vertical line of colour C in column X between rows Y1 and Y2."
  puts "H X1 X2 Y C to draw a horizontal segment of colour C in row Y between columns X1 and X2."
  puts "F X Y C to fill the region R with the colour C."
  puts "S to show the current image."
  puts "X to terminate the session."
end



##
# Method to read user input and interpret it as a commant with parameters.
##
def read_input (input)
  params = input.split
  command = params.shift
  
  case command
    when 'I'
      @bitmap = Bitmap.new params[0].to_i, params[1].to_i
    when 'C'
      raise "Bitmap hasn't been initialized yet." unless @bitmap
      @bitmap.clear
    when 'L'
      raise "Bitmap hasn't been initialized yet." unless @bitmap
      @bitmap.fill_point params[0].to_i, params[1].to_i, params[2]
    when 'V'
      raise "Bitmap hasn't been initialized yet." unless @bitmap
      @bitmap.fill_vertical_segment params[0].to_i, params[1].to_i, params[2].to_i, params[3]
    when 'H'
      raise "Bitmap hasn't been initialized yet." unless @bitmap
      @bitmap.fill_horizontal_segment params[0].to_i, params[1].to_i, params[2].to_i, params[3]
    when 'F'
      raise "Bitmap hasn't been initialized yet." unless @bitmap
      @bitmap.fill_area params[0].to_i, params[1].to_i, params[2]
    when 'Q'
      raise "Bitmap hasn't been initialized yet." unless @bitmap
      @bitmap.fill_square params[0].to_i, params[1].to_i, params[2].to_i, params[3].to_i, params[4]
    when 'S'
      @bitmap.pretty_print
    when 'H'
      show_help
    when 'X'
      exit
    else
      raise "Command not recognized."
    end
end



##
# MAIN
##

while true
  begin
    print "> "
    read_input gets
  rescue => error
    puts
    puts error.message
    puts
    show_help
  ensure
    puts
  end
end