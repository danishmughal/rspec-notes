# frozen_string_literal: true

RSpec.describe 'not_to method' do
  it 'checks that two values do not match' do
    expect(5).not_to eq(1)
    expect('Hello').not_to eq('hello')
    expect([1, 2]).not_to eq([1, 2, 3])
  end

  it 'checks for the inverse of a matcher' do
    expect(5).not_to eq(10)
    expect([1, 2, 3]).not_to equal([1, 2, 3])

    expect(10).not_to be_odd
    expect([1, 2, 3]).not_to be_empty
  end
end
