# frozen_string_literal: true

require_relative 'position'

# Represents a playaer in the game
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def choose_pos(board)
    row = Input.input "Enter row [0-#{board.size}]:"
    col = Input.input "Enter column [0-#{board.size}]:"

    begin
      pos = Position.new(Integer(row), Integer(col))
    rescue ArgumentError
      puts 'Invalid integer.'
      return choose_pos(board)
    end

    pos
  end
end
