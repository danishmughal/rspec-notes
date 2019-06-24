# frozen_string_literal: true

RSpec.describe 'equality matchers' do
  let(:a) { 3.0 }
  let(:b) { 3 }

  # 'eq' -> Type-insensitive compare
  describe 'eq matcher' do
    it 'tests for value and ignores type' do
      expect(a).to eq(b)
      expect(a).to eq(3)
      expect(b).to eq(3.0)
    end
  end

  # 'eql' -> Type-sensitive compare
  describe 'eql matcher' do
    it 'tests for value equality including type' do
      expect(a).to eql(3.0)
      expect(b).to eql(3)

      expect(a).not_to eql(b)
      expect(a).not_to eql(3)
      expect(b).not_to eql(3.0)
    end
  end

  describe 'equal and be matcher' do
    let(:c) { [1, 2, 3] }
    let(:d) { [1, 2, 3] }
    let(:e) { c }

    # 'equal' -> Object identity comparison
    # 'be' is simply an alias for 'equal'
    it 'cares about object identity' do
      expect(c).to_not equal(d)
      expect(c).to_not be(d)
      expect(c).to_not be([1, 2, 3])

      expect(c).to equal(e)
      expect(c).to be(e)
    end
  end
end
