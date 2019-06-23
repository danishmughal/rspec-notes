# frozen_string_literal: true

RSpec.describe 'nested hooks' do
  # Runs once before this entire context
  before(:context) do
    puts 'OUTER Before context'
  end

  # Runs once per example, including examples within nested contexts
  # Runs before other before blocks in nested contexts
  before(:example) do
    puts 'OUTER Before example'
  end

  it 'does basic math' do
    expect(1 + 1).to eq(2)
  end

  context 'with condition A' do
    # Runs once before this nested context
    before(:context) do
      puts 'INNER Before context'
    end

    # Runs once per example within this context
    # Runs after before(:example) above
    before(:example) do
      puts 'INNER Before example'
    end

    it 'does some more basic math' do
      expect(2 + 2).to eq(4)
    end

    it 'does subtraction as well' do
      expect(2 - 2).to eq(0)
    end
  end
end
