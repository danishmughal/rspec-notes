# frozen_string_literal: true

RSpec.describe 'all matcher' do
  it 'allows for aggregate checks' do
    ## Iterating through collection:
    # [5, 7, 9].each do |val|
    #   expect(val).to be_odd
    # end

    # Shorthand for above
    expect([5, 7, 9]).to all(be_odd)
    expect([2, 4, 6]).to all(be_even)
    expect([0, 0]).to all(be_zero)

    # Can be combined with comparison matchers
    expect([5, 7, 9]).to all(be < 10)
  end

  describe [5, 7, 9] do
    it { is_expected.to all(be_odd) }
    it { is_expected.to all(be < 10) }
  end
end
