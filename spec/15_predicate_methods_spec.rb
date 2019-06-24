# frozen_string_literal: true

# Predicate methods usually end in '?' and return true/false
# For example: '.zero?'
RSpec.describe 'predicate methods and predicate matchers' do
  it 'can be tested with plain Ruby methods' do
    result = 16 / 2
    expect(result.even?).to eq(true)
  end

  # Format: 'be_#{custom_predicate_method_name}' (without question mark)
  it 'can be tested with predicate matchers' do
    expect(16 / 2).to be_even
    expect(16 / 2).not_to be_odd
    expect(0).to be_zero
    expect([]).to be_empty
  end

  describe 0 do
    it { is_expected.to be_zero }
    it { is_expected.to_not be_odd }
  end
end
