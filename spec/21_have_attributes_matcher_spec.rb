# frozen_string_literal: true

class Car
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end
end

RSpec.describe 'have_attributes matcher' do
  describe Car.new('Honda', 'Civic') do
    it 'checks for object attribute and proper values' do
      expect(subject).to have_attributes(make: 'Honda')
      expect(subject).to have_attributes(make: 'Honda', model: 'Civic')
    end

    it { is_expected.to have_attributes(make: 'Honda', model: 'Civic') }
  end
end
