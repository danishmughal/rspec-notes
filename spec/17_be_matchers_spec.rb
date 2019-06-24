# frozen_string_literal: true

RSpec.describe 'be matchers' do
  it 'can test for truthiness' do
    expect(true).to be_truthy
    expect('Hello').to be_truthy
    expect(0).to be_truthy
    expect(1).to be_truthy
    expect([]).to be_truthy
    expect(:symbol).to be_truthy
  end

  it 'can test for falsiness' do
    expect(nil).not_to be_truthy
    expect(false).not_to be_truthy
  end

  it 'can test for nil' do
    expect(nil).to be_nil

    my_hash = { a: 5 }
    expect(my_hash[:a]).not_to be_nil
    expect(my_hash[:b]).to be_nil
  end
end
