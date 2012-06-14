class Maze

  attr_reader :data
  def initialize(input_string, player)
    @data = []
    input_string.each_line do |line|
      @data << line.chomp.split('')
    end
    @player = player
  end

end
