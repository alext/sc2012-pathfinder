require 'spec_helper'

require 'maze'

describe Maze do
  describe "parsing a maze" do
    it "should parse a simple maze" do
      string = "****\n*1.*\n*.F*\n*2.*\n****"
      m = Maze.new(string, 1)

      m.data.should == [
        %w(* * * *),
        %w(* 1 . *),
        %w(* . F *),
        %w(* 2 . *),
        %w(* * * *),
      ]

      m.player.should == 1
    end
  end
end
