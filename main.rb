# frozen_string_literal: true

require 'pry'

module TicTacToe
  WINNING_LINES = [
    [[0, 0], [0, 1], [0, 2]], # horizontal
    [[1, 0], [1, 1], [1, 2]], # horizontal
    [[2, 0], [2, 1], [2, 2]], # horizontal
    [[0, 0], [1, 0], [2, 0]], # vertical
    [[0, 1], [1, 1], [2, 1]], # vertical
    [[0, 2], [1, 2], [2, 2]], # vertical
    [[0, 0], [1, 1], [2, 2]], # diagonal
    [[0, 2], [1, 1], [2, 0]]  # diagonal
  ].freeze

  def self.play_again?
    puts 'Wanna play again? (Y/N)'
    play_again = gets.chomp
    until play_again.downcase.match?(/y|n|yes|no/)
      puts 'Please select a valid choice (y, n, yes, no):'
      play_again = gets.chomp
    end

    play_again.match?(/y|yes/)
  end

  class Game
    def initialize(player1, player2)
      @player1 = player1
      @player2 = player2

      @spaces = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]
      @moves_remaining = 9
    end

    attr_accessor :spaces, :player1, :player2, :moves_remaining

    def game_over?(player)
      return unless game_has_winner?(player) || game_is_tie?

      show_board
      true
    end

    def game_has_winner?(player)
      return unless WINNING_LINES.any? { |winner| (winner - player.moves).empty? }

      puts "Congrats, #{player.name}! You've won!"
      true
    end

    def add_player_turn(player)
      show_board
      loop do
        puts "<< #{player.name} (#{player.marker}) >> Please select one of the available moves:"
        place = gets.chomp

        break if (place.to_i.to_s == place) && add_move(player, place)

        puts 'Try again...' # if attempted move was taken/invalid
      end
    end

    def add_move(player, place)
      move_added = false
      coords = find_coords(place)
      if coords
        spaces[coords[0]][coords[1]] = player.marker
        player.moves << coords

        move_added = true
        self.moves_remaining -= 1
      end

      move_added
    end

    private

    attr_accessor :winner

    def game_is_tie?
      return unless moves_remaining.zero?

      puts "It's a tie!"
      true
    end

    def find_coords(place)
      spaces.each_index do |row|
        col = spaces[row].index place.to_i
        return row, col if col
      end

      false
    end

    def show_board
      spaces.each_with_index do |row, idx|
        puts row.map { |space| " #{space} " }.join('|')
        break if idx == 2

        puts '-' * 11
      end
    end
  end

  class Player
    def initialize(name, marker)
      @name = name
      @marker = marker
      @moves = []
    end

    attr_accessor :moves

    attr_reader :name, :marker
  end
end

play_again = true

while play_again
  markers = %w[X O]
  puts "Time for some good ol' fashion Tic Tac Toe! \nEnter Player 1's name:"
  p1_name = gets.chomp
  p1_marker = markers.delete(markers.sample)

  puts "Player 2's name:"
  p2_name = gets.chomp

  player1 = TicTacToe::Player.new(p1_name, p1_marker)
  player2 = TicTacToe::Player.new(p2_name, markers.last)
  players = [player1, player2]

  game = TicTacToe::Game.new(player1, player2)
  players.cycle do |player|
    game.add_player_turn(player)

    break if game.game_over?(player)
  end

  play_again = TicTacToe.play_again?
end
