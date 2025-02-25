# frozen_string_literal: true

require_relative 'position'

# Represents the game board
class Board
  attr_reader :size

  def initialize(size = 3)
    @size = size
    @board = Array.new(size) do
      Array.new(size) { '-' }
    end
  end

  def to_s
    rows_str = @board.map do |row|
      row.join(' | ')
    end
    rows_str.join("\n")
  end

  def place(symbol, pos)
    @board[pos.row][pos.col] = symbol
  end

  def win?(symbol)
    (rows + columns + diagonals).any? { |comb| comb.all?(symbol) }
  end

  def full?
    @board.flatten.none?('-')
  end

  def valid?(pos)
    return false if pos.row.negative? || pos.col.negative?

    @board.dig(pos.row, pos.col) == '-'
  end

  def rows
    @board
  end

  def columns
    (0..@size - 1).inject([]) do |cols, col|
      cols + [@board.map { |row| row[col] }]
    end

    Array.new(@size) do |col|
      @board.map { |row| row[col] }
    end
  end

  def diagonals
    diag1 = Array.new(@size) do |i|
      @board[i][i]
    end

    diag2 = Array.new(@size) do |i|
      @board[i][@size - 1 - i]
    end

    [diag1, diag2]
  end
end
