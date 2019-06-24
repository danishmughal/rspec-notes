# frozen_string_literal: true

# 'be' and 'equal' can be used with comparison matchers
RSpec.describe 'comparison matchers' do
  it 'allows for comparison with built-in Ruby operators' do
    expect(10).to be > 5
    expect(3).to be < 5

    expect(1).to be >= -1
    expect(1).to be <= 2
  end

  describe 100 do
    it { is_expected.to be > 90 }
    it { is_expected.to be < 110 }

    it { is_expected.not_to be > 100 }
    it { is_expected.not_to be < 100 }
  end
end
