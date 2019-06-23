# frozen_string_literal: true

class Card
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end

# [ RSpec Example Group ] for Card
RSpec.describe Card do
  # [ RSpec Hook ]
  # Runs once every time before each example
  # # before(:example) do
  # before do
  #   @card = Card.new('Ace', 'Spades')
  # end

  # def card
  #   Card.new('Ace', 'Spades')
  # end

  # Memoizes card and instantiates a new object for each example if needed
  # let! would force this to run for each example even when not called
  let(:card) { Card.new('Ace', 'Spades') }

  # [ RSpec Example ] for 'has a type'
  # 'specify' can also be used as an alias for 'it'
  it 'has a rank' do
    # [ RSpec Assertion ]
    # expect(expression).to(eq(value))
    expect(card.rank).to eq('Ace')
  end

  it 'has a suit' do
    expect(card.suit).to eq('Spades')
  end

  it 'has a custom error message' do
    comparison = 'Spade'

    # A custom error message can be provided
    # as a second argument to the 'to' method
    expect(card.suit).to eq(comparison),
                         "Card expected #{comparison}, got #{card.suit} instead"
  end
end
