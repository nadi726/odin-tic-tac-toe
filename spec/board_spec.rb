require_relative '../lib/board'
require_relative '../lib/position'

def make_moves(board, moves)
  moves.each do |move|
    board.place(move[0], move[1])
  end
end

describe Board do # rubocop:disable Metrics/BlockLength
  subject(:board) { described_class.new }

  let(:symbol1) { 'O' }
  let(:symbol2) { 'X' }

  describe '#win?' do # rubocop:disable Metrics/BlockLength
    context 'when the game is not over' do # rubocop:disable Metrics/BlockLength
      context 'at board start' do
        it 'returns false for symbol 1' do
          expect(board.win?(symbol1)).to be false
        end

        it 'returns false for symbol 2' do
          expect(board.win?(symbol2)).to be false
        end
      end

      context 'after making a few moves' do
        before do
          moves = [[symbol1, Position.new(0, 0)], [symbol2, Position.new(1, 2)], [symbol1, Position.new(0, 2)]]
          make_moves(board, moves)
        end

        it 'returns false for symbol 1' do
          expect(board.win?(symbol1)).to be false
        end

        it 'returns false for symbol 2' do
          expect(board.win?(symbol2)).to be false
        end
      end

      context 'when board is full but it\'s a tie' do
        before do
          moves = [[symbol1, Position.new(0, 0)], [symbol2, Position.new(1, 0)], [symbol2, Position.new(2, 0)],
                   [symbol2, Position.new(0, 1)], [symbol2, Position.new(1, 1)], [symbol1, Position.new(2, 1)],
                   [symbol1, Position.new(0, 2)], [symbol1, Position.new(1, 2)], [symbol2, Position.new(2, 2)]]
          make_moves(board, moves)
        end

        it 'returns false for symbol 1' do
          expect(board.win?(symbol1)).to be false
        end

        it 'returns false for symbol 2' do
          expect(board.win?(symbol2)).to be false
        end
      end
    end

    context 'when the game is over' do # rubocop:disable Metrics/BlockLength
      context 'with a full row' do
        before do
          moves = [[symbol1, Position.new(0, 0)], [symbol1, Position.new(0, 1)], [symbol1, Position.new(0, 2)]]
          make_moves(board, moves)
        end

        it 'returns true' do
          expect(board.win?(symbol1)).to be true
        end
      end

      context 'with a full column' do
        before do
          moves = [[symbol2, Position.new(2, 0)], [symbol2, Position.new(2, 1)], [symbol2, Position.new(2, 2)]]
          make_moves(board, moves)
        end

        it 'returns true' do
          expect(board.win?(symbol2)).to be true
        end
      end

      context 'with a full diagonal' do
        before do
          moves = [[symbol1, Position.new(0, 0)], [symbol1, Position.new(1, 1)], [symbol1, Position.new(2, 2)]]
          make_moves(board, moves)
        end

        it 'returns true' do
          expect(board.win?(symbol1)).to be true
        end
      end

      context 'when another symbol is also on the board' do
        let(:other_symbol) { 'O' }

        before do
          moves = [[symbol1, Position.new(1, 1)], [symbol2, Position.new(1, 0)],
                   [symbol1, Position.new(0, 0)], [symbol2, Position.new(2, 2)],
                   [symbol1, Position.new(0, 1)], [symbol2, Position.new(2, 1)],
                   [symbol1, Position.new(0, 2)]]
          make_moves(board, moves)
        end

        it 'returns true for the winning symbol' do
          expect(board.win?(symbol1)).to be true
        end

        it 'returns false for the losing symbol' do
          expect(board.win?(symbol2)).to be false
        end
      end
    end
  end

  describe '#full?' do # rubocop:disable Metrics/BlockLength
    context 'when board starts' do
      it 'returns false' do
        expect(board).not_to be_full
      end
    end

    context 'when board has a few pieces' do
      before do
        moves = [[symbol1, Position.new(0, 0)], [symbol2, Position.new(1, 2)], [symbol1, Position.new(0, 2)]]
        make_moves(board, moves)
      end

      it 'returns false' do
        expect(board).not_to be_full
      end
    end

    context 'when a symbol wins, but board is not full' do
      before do
        moves = [[symbol1, Position.new(1, 1)], [symbol2, Position.new(1, 0)],
                 [symbol1, Position.new(0, 0)], [symbol2, Position.new(2, 2)],
                 [symbol1, Position.new(0, 1)], [symbol2, Position.new(2, 1)],
                 [symbol1, Position.new(0, 2)]]
        make_moves(board, moves)
      end

      it 'returns false' do
        expect(board).not_to be_full
      end
    end

    context 'when board is almost full' do
      before do
        moves = [[symbol1, Position.new(0, 0)], [symbol2, Position.new(1, 0)], [symbol2, Position.new(2, 0)],
                 [symbol2, Position.new(0, 1)], [symbol2, Position.new(1, 1)], [symbol1, Position.new(2, 1)],
                 [symbol1, Position.new(0, 2)], [symbol1, Position.new(1, 2)]]
        make_moves(board, moves)
      end

      it 'returns false' do
        expect(board).not_to be_full
      end
    end

    context 'when the board is one move away from being full and a move wins' do
      before do
        moves = [[symbol1, Position.new(0, 0)], [symbol2, Position.new(1, 0)], [symbol2, Position.new(2, 0)],
                 [symbol2, Position.new(0, 1)], [symbol2, Position.new(1, 1)], [symbol1, Position.new(2, 1)],
                 [symbol1, Position.new(0, 2)], [symbol1, Position.new(1, 2)]]
        make_moves(board, moves)
      end

      it 'returns false before the final move' do
        expect(board).not_to be_full
      end

      it 'returns true after the final move that wins the game' do
        board.place(symbol2, Position.new(2, 2))
        expect(board).to be_full
      end
    end

    context 'when board is full' do
      before do
        moves = [[symbol1, Position.new(0, 0)], [symbol2, Position.new(1, 0)], [symbol2, Position.new(2, 0)],
                 [symbol2, Position.new(0, 1)], [symbol2, Position.new(1, 1)], [symbol1, Position.new(2, 1)],
                 [symbol1, Position.new(0, 2)], [symbol1, Position.new(1, 2)], [symbol2, Position.new(2, 2)]]
        make_moves(board, moves)
      end

      it 'returns true' do
        expect(board).to be_full
      end
    end
  end

  describe '#valid?' do # rubocop:disable Metrics/BlockLength
    context 'when the position is out of range' do
      it 'returns false for negative x' do
        pos = Position.new(-2, 2)
        expect(board.valid?(pos)).to be false
      end

      it 'returns false for negative y' do
        pos = Position.new(2, -1)
        expect(board.valid?(pos)).to be false
      end

      it 'returns false for x > 2' do
        pos = Position.new(3, 0)
        expect(board.valid?(pos)).to be false
      end

      it 'returns false for y > 2' do
        pos = Position.new(2, 3)
        expect(board.valid?(pos)).to be false
      end
    end

    context 'when some positions are already occupied' do
      before do
        moves = [[symbol1, Position.new(0, 0)], [symbol2, Position.new(1, 1)], [symbol1, Position.new(0, 2)]]
        make_moves(board, moves)
      end

      it 'returns true for unoccupied position' do
        pos = Position.new(2, 2)
        expect(board.valid?(pos)).to be true
      end

      it 'returns false for occupied symbol 1 position' do
        pos = Position.new(0, 0)
        expect(board.valid?(pos)).to be false
      end

      it 'returns false for occupied symbol 2 position' do
        pos = Position.new(1, 1)
        expect(board.valid?(pos)).to be false
      end
    end
  end
end
