# frozen_string_literal: true

class King
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

RSpec.describe King do
  # described_class dynamically uses the subject of the describe block
  subject { described_class.new('George') }
  let(:louis) { described_class.new('Louis') }

  it 'represents kings' do
    expect(subject.name).to eq('George')
    expect(louis.name).to eq('Louis')
  end
end
