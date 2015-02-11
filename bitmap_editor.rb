
class Bitmap

  def initialize (height, width)
    puts "bitmap-initialize"

  end

  def print
  end

end


def read_input (input)
  puts "read_input"
  puts "input #{input}"
  input = input.split
  command = input.first
  
end


while true
  print "> "
  read_input gets
  puts
end