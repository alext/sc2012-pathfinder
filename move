#! /usr/bin/env ruby

$: << './lib'
require 'maze'

player_info, maze = ARGV[0].split("\n", 2)

puts STDERR, "player_info: #{player_info}"
puts STDERR, "maze: #{maze}"

player_info =~ /You are player (\d)/
maze = Maze.new(maze, $1)

puts maze.next_move
