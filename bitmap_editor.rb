

=begin

I M N - Create a new M x N image with all pixels coloured white (O).
C - Clears the table, setting all pixels to white (O).
L X Y C - Colours the pixel (X,Y) with colour C.
V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
F X Y C - Fill the region R with the colour C. R is defined as: Pixel (X,Y) belongs to R. Any other pixel which is the same colour as (X,Y) and shares a common side with any pixel in R also belongs to this region.
S - Show the contents of the current image
X - Terminate the session

=end


class Bitmap

  def initialize (height, width, color='O')
    raise "Color not recognized." unless is_valid_color?(color)
    
    @height = height
    @width = width
    @matrix = Array.new(@height) {Array.new(@width, color)}
  end


  def clear (color='O')
    raise "Color not recognized." unless is_valid_color?(color)
    
    (0..@height-1).each do |y|
      (0..@width-1).each do |x|
        @matrix[x][y] = color
      end
    end
  end


  def pretty_print
    (0..@height-1).each do |y|
      (0..@width-1).each do |x|
        print @matrix[y][x]
      end
      puts
    end
  end


  def fill_point (x, y, color)
    raise "X value is out of range." if x > @width or x < 0
    raise "Y value is out of range." if y > @height or y < 0
    raise "Color not recognized." unless is_valid_color?(color)

    @matrix[y][x] = color
  end


  def fill_vertical_segment (x, y1, y2, color)
    raise "X value is out of range." if x > @width or x < 0
    raise "Y1 value is out of range." if y1 > @height or y1 < 0
    raise "Y2 value is out of range." if y2 > @height or y2 < 0
    raise "Color not recognized." unless is_valid_color?(color)

    y2, y1 = y1, y2 if y1 > y2 # Swap variable order if necessary.

    (y1..y2-1).each do |y|
    #(y1..y2).each do |y|
      fill_point(x, y, color)
    end
  end


  def fill_horizontal_segment (x1, x2, y, color)
    raise "X1 value is out of range." if x1 > @width or x1 < 0
    raise "X2 value is out of range." if x2 > @width or x2 < 0
    raise "Y value is out of range." if y > @height or y < 0
    raise "Color not recognized." unless is_valid_color?(color)

    x2, x1 = x1, x2 if x1 > x2 # Swap variable order if necessary.

    (x1..x2-1).each do |x|
    #(x1..x2).each do |x|
      fill_point(x, y, color)
    end
  end




  private

  def is_valid_color? (color)
    /[[:upper:]]/.match(color)
  end

end



###
# MAIN
###

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
    when 'S'
      @bitmap.pretty_print
    when 'X'
      exit
    else
      raise "Command not recognized."
    end
end


while true
  print "> "
  read_input gets
  puts
end