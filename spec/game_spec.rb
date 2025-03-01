# frozen_string_literal: true

require_relative '../lib/game'

describe Game do # rubocop:disable Metrics/BlockLength
  subject(:game) { described_class.new('A', 'B') }
  let(:player1) { game.instance_variable_get(:@player1) }
  let(:player2) { game.instance_variable_get(:@player2) }
  let(:board) { game.instance_variable_get(:@board) }

  describe '#initialize' do # rubocop:disable Metrics/BlockLength
    context 'when both player names are given' do
      subject(:game) { described_class.new('Julia', 'Juno') }
      let(:player1) { game.instance_variable_get(:@player1) }
      let(:player2) { game.instance_variable_get(:@player2) }

      it 'creates player 1 with the given name' do
        expect(player1.name).to eq('Julia')
      end

      it 'creates player 2 with the given name' do
        expect(player2.name).to eq('Juno')
      end

      it 'assigns X to player 1' do
        expect(player1.symbol).to eq('X')
      end

      it 'assigns O to player 2' do
        expect(player2.symbol).to eq('O')
      end
    end

    context 'when 1 name is given' do
      subject(:game) { described_class.new('', 'Juno') }

      before do
        allow(Game).to receive(:get_player_name).and_return('Lavender')
      end

      let(:player1) { game.instance_variable_get(:@player1) }

      it 'gets the other name from ::get_player_name' do
        expect(player1.name).to eq('Lavender')
      end
    end

    context 'when no name is given' do
      subject(:game) { described_class.new }

      before do
        allow(Game).to receive(:get_player_name).and_return('Julia', 'Juno')
      end

      let(:player1) { game.instance_variable_get(:@player1) }
      let(:player2) { game.instance_variable_get(:@player2) }

      it 'gets player 1\'s name from ::get_player_name' do
        expect(player1.name).to eq('Julia')
      end

      it 'gets player 2\'s name from ::get_player_name' do
        expect(player2.name).to eq('Juno')
      end
    end
  end

  describe '#check_game_end' do # rubocop:disable Metrics/BlockLength
    context 'when no one won' do
      before { allow(board).to receive(:win?).and_return(false) }

      context 'when the board is not full' do
        before do
          allow(board).to receive(:full?).and_return(false)
        end

        it 'returns nil for player 1' do
          expect(game.check_game_end(player1)).to be_nil
        end

        it 'returns nil for player 2' do
          expect(game.check_game_end(player2)).to be_nil
        end
      end

      context 'when board is full' do
        before do
          allow(board).to receive(:full?).and_return(true)
        end

        it 'returns a tie for player 1' do
          expect(game.check_game_end(player1)).to eq(:tie)
        end

        it 'returns a tie for player 2' do
          expect(game.check_game_end(player2)).to eq(:tie)
        end
      end
    end

    context 'when a player won' do
      before { allow(board).to receive(:win?).with(player1.symbol).and_return(true) }

      context 'when the board is not full' do
        before do
          allow(board).to receive(:full?).and_return(false)
        end

        it 'returns player for the given player' do
          expect(game.check_game_end(player1)).to eq(player1)
        end
      end

      context 'when the board is full' do
        before do
          allow(board).to receive(:full?).and_return(true)
        end

        it 'returns player for the given player' do
          expect(game.check_game_end(player1)).to eq(player1)
        end
      end
    end
  end

  describe '#choose_valid_pos' do # rubocop:disable Metrics/BlockLength
    before do
      allow(game).to receive(:puts) # Suppress output globally for this test
    end

    context 'when a valid position is given immediatly' do
      before do
        allow(player1).to receive(:choose_pos).and_return(Position.new(1, 1))
        allow(board).to receive(:valid?).and_return(true)
      end

      it 'returns the position' do
        expect(game.choose_valid_pos(player1)).to eq(Position.new(1, 1))
      end
    end

    context 'when a valid position is given after 2 tries' do
      before do
        allow(player1).to receive(:choose_pos).and_return(Position.new(-1, 1), Position.new(4, 7), Position.new(2, 1))
        allow(board).to receive(:valid?).and_return(false, false, true)
      end

      it 'returns the valid position' do
        expect(game.choose_valid_pos(player1)).to eq(Position.new(2, 1))
      end

      it 'is run exactly 3 times' do
        expect(player1).to receive(:choose_pos).exactly(3).times
        expect(board).to receive(:valid?).exactly(3).times

        game.choose_valid_pos(player1)
      end
    end
  end

  describe '#on_game_end' do # rubocop:disable Metrics/BlockLength
    before do
      allow(game).to receive(:play_again?).and_return(false)
      @original_stdout = $stdout
      $stdout = StringIO.new
    end

    after do
      $stdout = @original_stdout
    end

    context 'when its a tie' do
      before { game.instance_variable_set(:@winner, :tie) }

      it 'prints that its a tie' do
        expect { game.on_game_end }.to output(a_string_including('tie')).to_stdout
      end
    end

    context 'when there\'s a winner' do
      before { game.instance_variable_set(:@winner, player2) }

      it 'prints the winner\'s name' do
        expect { game.on_game_end }.to output(a_string_including(player2.name)).to_stdout
      end
    end

    context 'when players decide not to play again' do
      before do
        game.instance_variable_set(:@winner, player2)
      end

      it 'is not played again' do
        expect(game).not_to receive(:play)
        game.on_game_end
      end
    end

    context 'when players decide to play again' do
      before do
        game.instance_variable_set(:@winner, player1)
        allow(game).to receive(:play_again?).and_return(true)
        allow(game).to receive(:play)
      end

      it 'is played again' do
        expect(game).to receive(:play)
        game.on_game_end
      end
    end
  end
end
