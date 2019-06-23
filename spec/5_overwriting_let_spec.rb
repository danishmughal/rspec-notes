# frozen_string_literal: true

class ProgrammingLanguage
  attr_reader :name

  def initialize(name = 'Ruby')
    @name = name
  end
end

RSpec.describe ProgrammingLanguage do
  # language will be available to all sub-contexts
  let(:language) { ProgrammingLanguage.new('Javascript') }

  it 'should store the name of the language' do
    expect(language.name).to eq('Javascript')
  end

  context 'with no arguments' do
    # Will take priority in this context
    let(:language) { ProgrammingLanguage.new }

    # # Bad:
    # let(:language2) { ... }

    it 'should default to Ruby as the name' do
      expect(language.name).to eq('Ruby')
    end
  end
end
