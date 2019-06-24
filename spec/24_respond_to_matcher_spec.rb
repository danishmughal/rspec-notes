# frozen_string_literal: true

class Vehicle
  def drive
    'Vroom'
  end

  def honk
    'Honk'
  end

  def refuel(gallons)
    "Refueled #{gallons} gallons"
  end
end

RSpec.describe 'respond_to matcher' do
  subject { Vehicle.new }

  it 'confirms that an object can respond to a method' do
    expect(subject).to respond_to(:drive)
    expect(subject).to respond_to(:drive, :honk)
    expect(subject).to respond_to(:drive, :honk, :refuel)
  end

  it 'confirms an object can respond to a method with arguments' do
    expect(subject).to respond_to(:refuel)
    expect(subject).to respond_to(:refuel).with(1).arguments
  end

  it { is_expected.to respond_to(:refuel) }
  it { is_expected.to respond_to(:refuel).with(1).arguments }
end
