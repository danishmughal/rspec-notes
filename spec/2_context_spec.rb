# frozen_string_literal: true

# '.method' for class methods
# '#method' for instance methods
RSpec.describe '#even? method' do
  # # Bad:
  # it 'should return true if number is even'
  # it 'should return false if number is false'

  # Use nested describes for conditional examples
  describe 'with even number' do
    it 'should return true' do
      expect(2.even?).to eq(true)
    end
  end

  # 'context' is just an alias for 'describe', work identically
  context 'with odd number' do
    it 'should return false' do
      expect(1.even?).to eq(false)
    end
  end
end
