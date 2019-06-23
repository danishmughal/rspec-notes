# frozen_string_literal: true

# Shared context can be useful for consolidating common blocks/setup/variables/methods
# Can be imported via include_context
RSpec.shared_context 'common' do
  before do
    @some_array = []
  end

  def some_helper_method
    5
  end

  let(:some_variable) { [1, 2, 3] }
end

RSpec.describe 'first example group' do
  include_context 'common'

  it 'can use outside instance variables' do
    expect(@some_array.length).to eq(0)
    @some_array << 'Item'
    expect(@some_array.length).to eq(1)
  end

  it 'can reuse instance variables across examples' do
    expect(@some_array.length).to eq(0)
  end

  it 'can use shared helper methods' do
    expect(some_helper_method).to eq(5)
  end
end

RSpec.describe 'second example group' do
  include_context 'common'

  it 'can use shared let variables' do
    expect(some_variable).to eq([1, 2, 3])
  end
end
