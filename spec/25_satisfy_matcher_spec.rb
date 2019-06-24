# frozen_string_literal: true

RSpec.describe 'satisfy matcher' do
  subject { 'racecar' }
  # subject { 'racecars' }

  it 'is a palindrome' do
    expect(subject).to satisfy { |value| value == value.reverse }
  end

  it 'can accept a custom error message' do
    expect(subject + 's').to satisfy('be a palindrome') do |value|
      value == value.reverse
    end
  end
end
