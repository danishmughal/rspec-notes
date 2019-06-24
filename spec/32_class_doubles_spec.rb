# frozen_string_literal: true

# class Deck
#   def self.build
#     # Business logic
#   end
# end

class CardGame
  attr_reader :cards

  def start
    @cards = Deck.build # Class method call
  end
end

# Similar to instance doubles, but for classes and class methods
RSpec.describe CardGame do
  it 'can only implement class methods that are defined on a class' do
    # Below would trigger: `the Deck class does not implement the class method: shuffle`
    # deck = class_double(Deck, build: %w[Ace Queen])

    # If Deck has not been defined yet, we can pass a string class name:
    # deck = class_double('Deck', build: %w[Ace Queen])

    # Makes sure that subsequent calls to Deck within the code use this stub
    # Instead of searching for the actual Deck class
    deck_klass = class_double('Deck', build: %w[Ace Queen]).as_stubbed_const

    expect(deck_klass).to receive(:build)
    subject.start
    expect(subject.cards).to eq(%w[Ace Queen])
  end
end
