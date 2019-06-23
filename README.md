# RSpec Notes
A personal compilation of basic RSpec notes.

# 1. Basics

```ruby
class Card
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end

# [ RSpec Example Group ] for Card
RSpec.describe Card do
  # [ RSpec Hook ]
  # Runs once every time before each example
  # # before(:example) do
  # before do
  #   @card = Card.new('Ace', 'Spades')
  # end

  # def card
  #   Card.new('Ace', 'Spades')
  # end

  # Memoizes card and instantiates a new object for each example if needed
  # let! would force this to run for each example even when not called
  let(:card) { Card.new('Ace', 'Spades') }

  # [ RSpec Example ] for 'has a type'
  # 'specify' can also be used as an alias for 'it'
  it 'has a rank' do
    # [ RSpec Assertion ]
    # expect(expression).to(eq(value))
    expect(card.rank).to eq('Ace')
  end

  it 'has a suit' do
    expect(card.suit).to eq('Spades')
  end

  it 'has a custom error message' do
    comparison = 'Spade'

    # A custom error message can be provided
    # as a second argument to the 'to' method
    expect(card.suit).to eq(comparison),
                         "Card expected #{comparison}, got #{card.suit} instead"
  end
end

```

# 2. Context 

```ruby
# '.method' for class methods
# '#method' for instance methods

RSpec.describe '#even? method' do
  # # Bad:
  # it 'should return true if number is even'
  # it 'should return false if number is false'

  # Use nested describes for conditional examples
  describe 'with even number' do
    it 'should return true' do
      expect(2.even?).to eq(true)
    end
  end

  # 'context' is just an alias for 'describe', work identically
  context 'with odd number' do
    it 'should return false' do
      expect(1.even?).to eq(false)
    end
  end
end
```

# 3. Before/After Hooks
```ruby
RSpec.describe 'before and after hooks' do
  # Runs before the current context (1 level up)
  # Context is entire 'before and after hooks' describe block
  before(:context) do
    puts 'Before context'
  end

  # Runs after the current context
  after(:context) do
    puts 'After context'
  end

  # Runs before each example
  before(:example) do
    puts 'Before hook'
  end

  # Runs after each example
  # Could be used to clean up shared data/variables after each example
  after(:example) do
    puts 'After hook'
  end

  it 'is just a random example' do
    expect(5 * 4).to eq(20)
  end

  it 'is just another random example' do
    expect(3 - 2).to eq(1)
  end
end
```

# 4. Nested Hooks
```ruby
RSpec.describe 'nested hooks' do
  # Runs once before this entire context
  before(:context) do
    puts 'OUTER Before context'
  end

  # Runs once per example, including examples within nested contexts
  # Runs before other before blocks in nested contexts
  before(:example) do
    puts 'OUTER Before example'
  end

  it 'does basic math' do
    expect(1 + 1).to eq(2)
  end

  context 'with condition A' do
    # Runs once before this nested context
    before(:context) do
      puts 'INNER Before context'
    end

    # Runs once per example within this context
    # Runs after before(:example) above
    before(:example) do
      puts 'INNER Before example'
    end

    it 'does some more basic math' do
      expect(2 + 2).to eq(4)
    end

    it 'does subtraction as well' do
      expect(2 - 2).to eq(0)
    end
  end
end
```

# 5. Overwriting `let`
```ruby
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
```


# 6. Implicit Subject
```ruby
RSpec.describe Hash do
  # 'subject' automatically refers to the argument of the describe block
  # Calls '.new' on subject without parameters
  # let(:subject) { Hash.new }

  it 'should start off empty' do
    expect(subject.length).to eq(0)
    subject[:some_key] = 'Some Value'
    expect(subject.length).to eq(1)
  end

  it 'is isolated between examples' do
    expect(subject.length).to eq(0)
  end
end
```

# 7. Explicit Subject
```ruby
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
```

# 8. Described Class
```ruby
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
```

# 9. One-liner Syntax
```ruby
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
```

# 10. Shared Examples
```ruby
# Shared example subject hooks onto subject where included
RSpec.shared_examples 'a Ruby object with a length of 3' do
  it 'returns the number of items' do
    expect(subject.length).to eq(3)
  end
end

RSpec.describe Array do
  subject { [1, 2, 3] }
  include_examples 'a Ruby object with a length of 3'
end

RSpec.describe String do
  subject { 'abc' }
  include_examples 'a Ruby object with a length of 3'
end

RSpec.describe Hash do
  subject { { a: 1, b: 2, c: 3 } }
  include_examples 'a Ruby object with a length of 3'
end

class SausageLink
  def length
    3
  end
end

RSpec.describe SausageLink do
  subject { described_class.new }
  include_examples 'a Ruby object with a length of 3'
end
```

# 11. Shared Context
```ruby
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
```