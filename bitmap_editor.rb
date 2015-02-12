

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
    @height = height.to_i
    @width = width.to_i
    @matrix = Array.new(@height) {Array.new(@width, color)}
  end


  def clear (color='O')
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

end





def read_input (input)
  input = input.split
  command = input.first
  case command
    when 'I'
      puts @bitmap
      @bitmap = Bitmap.new input[1], input[2]
      puts @bitmap
    when 'C'
      @bitmap.clear
    when 'L'
    when 'V'
    when 'H'
    when 'F'
    when 'S'
      puts @bitmap
      @bitmap.pretty_print
      puts @bitmap
    when 'X'
      exit
    end
end


while true
  print "> "
  read_input gets
  puts
end