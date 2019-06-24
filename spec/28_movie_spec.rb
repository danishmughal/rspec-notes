# frozen_string_literal: true

class Actor
  def initialize(name)
    @name = name
  end

  def ready?
    sleep(3) # Emulating a complex process that takes some amount of time
    true
  end

  def act
    'You are the one, Neo'
  end

  def dodge_bullets
    'Whizz'
  end

  def climb_wall
    true
  end
end

class Movie
  attr_reader :actor

  def initialize(actor)
    @actor = actor
  end

  def start_shooting
    return unless actor.ready?

    actor.act
    actor.dodge_bullets
    actor.climb_wall
    actor.act
  end
end

# actor = Actor.new('Keanu Reeves')
# movie = Movie.new(actor)
# movie.start_shooting

# Since we are testing the Movie class, we do not care about the implementation of Actor
# We can thus create a double to mock an Actor and focus on testing Movie
RSpec.describe Movie do
  let(:stuntman) { double('Stuntman', ready?: true, act: 'Acting', dodge_bullets: 'Dodging', climb_wall: true) }
  subject { described_class.new(stuntman) }

  describe '#start_shooting' do
    it 'expects an actor to do 3 actions' do
      # We write our expectations before actually calling the method
      # expect(stuntman).to receive(:ready?).once
      # expect(stuntman).to receive(:ready?).exactly(1).times
      expect(stuntman).to receive(:ready?).at_most(1).times

      # expect(stuntman).to receive(:act).twice
      # expect(stuntman).to receive(:act).exactly(2).times
      expect(stuntman).to receive(:act).at_least(2).times

      expect(stuntman).to receive(:dodge_bullets).once
      expect(stuntman).to receive(:climb_wall).once

      subject.start_shooting
    end
  end
end
