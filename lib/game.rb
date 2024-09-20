# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'input'

# Manages game handling
class Game
  attr_reader :board

  def initialize(player1_name = '', player2_name = '')
    @board = Board.new
    player1_name = self.class.get_player_name('Player 1 name: ') if player1_name.empty?
    player2_name = self.class.get_player_name('Player 2 name: ') if player2_name.empty?
    @player1 = Player.new(player1_name, 'X')
    @player2 = Player.new(player2_name, 'O')
    @winner = nil
  end

  def self.get_player_name(text)
    name = Input.input text
    if name == ''
      puts 'Invalid name.'
      return get_player_name text
    end
    name
  end

  def play
    puts 'Game start'
    while @winner.nil?
      [@player1, @player2].each do |player|
        play_turn player
        puts
        @winner = check_game_end(player)
        break unless @winner.nil?
      end
    end

    on_game_end
  end

  def play_turn(player)
    puts board
    puts "#{player.name}'s turn"
    pos = choose_valid_pos(player)
    board.place(player.symbol, pos)
  end

  def check_game_end(player)
    if @board.full?
      :tie
    elsif @board.win?(player.symbol)
      player
    end
  end

  def choose_valid_pos(player)
    valid = false
    until valid
      pos = player.choose_pos(@board)
      valid = board.valid? pos
      puts 'Invalid position. Try again.' unless valid
    end
    pos
  end

  def on_game_end
    puts board
    if @winner == :tie
      puts 'Its a tie!'
    else
      puts "#{@winner.name} won!"
    end

    return unless play_again?

    reset
    play
  end

  def reset
    @board = Board.new
    @winner = nil
  end

  def play_again?
    again = Input.input 'Play again [Y/n]? '
    puts
    ['y', ''].include?(again.downcase)
  end
end
