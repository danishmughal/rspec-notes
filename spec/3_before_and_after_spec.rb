# frozen_string_literal: true

RSpec.describe 'before and after hooks' do
  # Runs before the current context (1 level up)
  # Context is entire 'before and after hooks' describe block
  before(:context) do
    puts 'Before context'
  end

  # Runs after the current context
  after(:context) do
    puts 'After context'
  end

  # Runs before each example
  before(:example) do
    puts 'Before hook'
  end

  # Runs after each example
  # Could be used to clean up shared data/variables after each example
  after(:example) do
    puts 'After hook'
  end

  it 'is just a random example' do
    expect(5 * 4).to eq(20)
  end

  it 'is just another random example' do
    expect(3 - 2).to eq(1)
  end
end
