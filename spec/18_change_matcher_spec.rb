# frozen_string_literal: true

RSpec.describe 'change matcher' do
  subject { [1, 2, 3] }

  it 'checks that a method changes object state' do
    # From/to - might be too specific
    expect { subject.push(4) }.to change { subject.length }.from(3).to(4)

    # By
    expect { subject.push(4) }.to change { subject.length }.by(1)
  end

  it 'accepts negative arguments' do
    expect { subject.pop }.to change { subject.length }.from(3).to(2)

    expect { subject.pop }.to change { subject.length }.by(-1)
  end
end
