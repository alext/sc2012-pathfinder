require 'ostruct'

class Maze
  DIRS = [:north, :south, :east, :west]

  attr_reader :data
  def initialize(input_string, player)
    @data = []
    @graph = []
    input_string.each_line do |line|
      @data << line.chomp.split('')
    end
    @player = player.to_i
  end

  def graph
    nodes = []
    player = nil
    @data.each_with_index do |line, y|
      line.each_with_index do |square, x|
        next unless %w{. _ F}.include?(square) or square =~ /\d/
        next if square =~ /\d/ and square.to_i != @player
        type = case square
               when /\d/ then :player
               when 'F' then :finish
               when '.' then :space
               when '_' then :ice
               else raise "Unexpected square #{square}"
               end
        

        node = OpenStruct.new({ :type => type, :x => x, :y => y})
        player = node if node.type == :player
        nodes << node
      end
    end
    nodes.each do |node|
      node.north = nodes.find {|n| n.y == node.y - 1 and n.x == node.x }
      node.south = nodes.find {|n| n.y == node.y + 1 and n.x == node.x }
      node.east  = nodes.find {|n| n.y == node.y and n.x == node.x + 1 }
      node.west  = nodes.find {|n| n.y == node.y and n.x == node.x - 1 }
    end
    player
  end


  def next_move
    player = graph
    current_node = player
    current_node.cost = 0
    open_node_list = [current_node]

    while true
      debug "Visiting node #{current_node.x},#{current_node.y} #{current_node.type}"
      current_node.visited = true
      break if current_node.type == :finish
      DIRS.each do |dir|
        if node = current_node.send(dir)
          debug "Found node #{node.x},#{node.y} #{dir.upcase}"
          if open_node_list.find {|n| n == node } # node.in_list?
            new_cost = current_node.cost + 1
            if node.cost > new_cost
              node.cost = new_cost
              node.from = current_node
            end
          else
            node.from = current_node
            node.cost = current_node.cost + 1
            open_node_list << node
          end
        end
      end
      open_node_list.sort {|a,b| a.cost <=> b.cost }
      current_node = open_node_list.find {|n| ! n.visited }
      raise "No next node found, something's gone wrong..." unless current_node
    end
    parent_node = nil
    while true
      parent_node = current_node.from
      debug "parent #{parent_node.x},#{parent_node.y} current #{current_node.x},#{current_node.y}"
      break if parent_node.type == :player
      current_node = parent_node
    end
    DIRS.each do |dir|
      if parent_node.send(dir) == current_node
        return dir.to_s.upcase[0]
      end
    end
    raise "Something strange happened"
  end

  def debug(string)
    if ENV['DEBUG']
      puts string
    end
  end
end
