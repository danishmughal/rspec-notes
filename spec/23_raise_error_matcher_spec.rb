# frozen_string_literal: true

RSpec.describe 'raise_error matcher' do
  def some_method
    x # undefined
  end

  class CustomError < StandardError; end

  it 'can check for any error' do
    # Wrong: expect(some_method).to raise_error(NameError)
    # -> Need to be passed in as a block so error doesn't halt test suite
    # Also Wrong: expect { ... }.to raise_error
    # -> should always specify specific error

    expect { some_method }.to raise_error(NameError)
    expect { 1 / 0 }.to raise_error(ZeroDivisionError)
  end

  it 'can check for a custom error' do
    expect { raise CustomError }.to raise_error(CustomError)
  end
end
