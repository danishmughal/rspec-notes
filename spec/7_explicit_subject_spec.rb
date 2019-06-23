# frozen_string_literal: true

RSpec.describe Hash do
  # Subject refers to whatever returned from this block
  # subject(:alias) allows to use an alias for the subject
  subject(:bob) do
    { a: 1, b: 2 }
  end

  it 'has two key-value pairs' do
    expect(subject.length).to eq(2)
    expect(bob.length).to eq(2)
  end

  describe 'a nested example' do
    it 'has two key-value pairs' do
      expect(subject.length).to eq(2)
      expect(bob.length).to eq(2)
    end
  end
end
