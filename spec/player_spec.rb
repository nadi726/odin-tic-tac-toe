# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/input'
require_relative '../lib/position'

# I probably wouldn't add tests here if it were a real-world project - this is just for practice.
describe Player do
  describe '#choose_pos' do
    subject(:player) { described_class.new('Lucy', 'X') }
    let(:board) { double }

    before do
      allow(board).to receive(:size).and_return(3)
      allow(Input).to receive(:input).and_return('xyz', '0', '12t', '12t', '2', '1')
    end

    it 'retries when input is invalid' do
      expect(player).to receive(:choose_pos).with(board).exactly(3).and_call_original
      player.choose_pos(board)
    end

    it 'returns on valid input' do
      pos = player.choose_pos(board)
      expect(pos).to eq(Position.new(2, 1))
    end
  end
end
