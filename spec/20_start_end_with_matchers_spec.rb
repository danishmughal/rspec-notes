# frozen_string_literal: true

RSpec.describe 'start_with and end_with matchers' do
  describe 'caterpillar' do
    it 'should check for substring at the beginning or end' do
      expect(subject).to start_with 'cat'
      expect(subject).to end_with 'pillar'
    end

    it 'is case sensitive' do
      expect(subject).not_to start_with 'Cat'
      expect(subject).not_to end_with 'Pillar'
    end

    it { is_expected.to start_with('cat') }
    it { is_expected.to end_with('pillar') }
  end

  describe [:a, :b, :c, :d] do
    it 'should check for elements at the beginning or end of array' do
      expect(subject).to start_with(:a)
      expect(subject).to start_with(:a, :b)

      expect(subject).to end_with(:d)
      expect(subject).to end_with(:c, :d)
    end

    it { is_expected.to start_with(:a) }
    it { is_expected.to end_with(:d) }
  end
end
