# frozen_string_literal: true

RSpec.describe 'shorthand syntax' do
  subject { 5 }

  context 'with classic syntax' do
    it 'should equal 5' do
      expect(subject).to eq(5)
    end
  end

  context 'with one-liner syntax' do
    # Automatically refers to subject
    it { is_expected.to eq(5) }
  end
end
