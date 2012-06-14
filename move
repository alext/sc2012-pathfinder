#! /usr/bin/env ruby

$: << './lib'
require 'maze'

player_info, maze = ARGV[0].split("\n", 2)

player_info =~ /You are player (\d)/
puts "player: #{$1}"
puts "maze: #{maze}"

maze = Maze.new(maze, $1)

#puts maze.graph.inspect
puts maze.next_move
