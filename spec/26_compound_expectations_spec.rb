# frozen_string_literal: true

# .and
RSpec.describe 'multiple matchers - and' do
  context do
    subject { 25 }

    it 'can test for multiple matchers' do
      # expect(subject).to be_odd
      # expect(subject).to be > 20

      # Shorthand for above, allows chaining:
      expect(subject).to be_odd.and be > 20
    end

    it { is_expected.to be_odd.and be > 20 }
  end

  context do
    subject { 'caterpillar' }

    it 'supports multiple matchers on a single line' do
      expect(subject).to start_with('cat').and end_with('pillar')
    end

    it { is_expected.to start_with('cat').and end_with('pillar') }
  end
end

# .or
RSpec.describe 'multiple matchers - or' do
  subject { %i[usa canada mexico] }

  it 'can check for multiple possibilities' do
    expect(subject.sample).to eq(:usa).or eq(:canada).or eq(:mexico)
  end
end
