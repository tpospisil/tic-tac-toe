require 'pry'

module TicTacToe
  WINNING_LINES = [
    [[0,0], [0,1], [0,2]], # horizontal
    [[1,0], [1,1], [1,2]], # horizontal
    [[2,0], [2,1], [2,2]], # horizontal
    [[0,0], [1,0], [2,0]], # vertical
    [[0,1], [1,1], [2,1]], # vertical
    [[0,2], [1,2], [2,2]], # vertical
    [[0,0], [1,1], [2,2]], # diagonal
    [[0,2], [1,1], [2,0]], # diagonal
  ]

  class Game
    include GridHelper

    def initialize(player_1, player_2)
      @player_1 = player_1
      @player_2 = player_2
      
      @spaces = [
        [1,2,3],
        [4,5,6],
        [7,8,9]
      ]
      @winner = nil
      @moves_remaining = 9
    end
    
    attr_accessor :spaces

    def add_move(player, place)
      puts 'Please select a move'
      show_board
      place = gets.chomp
      coords = find_coords(place)
      space[coords[0]][coords[1]] = player.symbol
      player.moves << coords
    end

    def find_coords(value)
      spaces.each_index do |row|
        col = spaces[row].index value
        return row, col if col
      end

      return false
    end

    def show_board
      spaces.each_with_index do |row, idx|
        puts row.map { |space| " #{space} " }.join('|')
        break if idx == 2

        puts '-' * 11
      end
    end   

    private

    attr_accessor :winner, :moves_remaining, :players

  end

  class Player
    def initialize(name, marker)
      @name = name
      @marker = marker
    end

    attr_reader :name, :marker
  end
end

game = Game.new('Tyler', 'Kristen')
binding.pry