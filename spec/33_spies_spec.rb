# frozen_string_literal: true

# Doubles place expectations before the actual action
# Spies place expectations after the actual action
RSpec.describe 'spies' do
  let(:animal) { spy('animal') }

  it 'confirms that a message has been received' do
    # With a regular double you would do the following:
    # expect(animal).to receive(:eat_food)
    # animal.eat_food

    animal.eat_food
    expect(animal).to have_received(:eat_food)
    expect(animal).not_to have_received(:eat_human)
  end

  it 'resets between examples' do
    expect(animal).not_to have_received(:eat_food)
  end

  it 'retains the same functionality of a regular double' do
    animal.eat_food
    animal.eat_food
    animal.eat_food('Sushi')
    expect(animal).to have_received(:eat_food).exactly(3).times
    expect(animal).to have_received(:eat_food).with('Sushi').once
  end
end

class Automobile
  def initialize(model)
    @model = model
  end
end

class Garage
  attr_reader :storage

  def initialize
    @storage = []
  end

  def add_to_collection(model)
    @storage << Automobile.new(model)
  end
end

RSpec.describe Garage do
  let(:automobile) { instance_double(Automobile) }

  # Make calls to Automobile return our instance double
  # Grants spy-like functionality to our instance double
  before do
    allow(Automobile).to receive(:new).and_return(automobile)
  end

  it 'adds a car to its storage' do
    subject.add_to_collection('Honda Civic')

    expect(Automobile).to have_received(:new).with('Honda Civic')
    expect(subject.storage.length).to eq(1)
    expect(subject.storage.first).to eq(automobile)
  end
end
