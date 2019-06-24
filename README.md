# RSpec Notes  <!-- omit in toc -->
A personal compilation of basic RSpec notes on syntax.

All code from `spec/` has been pasted here for quick searching.

- [Basics](#Basics)
  - [1. Intro](#1-Intro)
  - [2. Context](#2-Context)
  - [3. Before/After Hooks](#3-BeforeAfter-Hooks)
  - [4. Nested Hooks](#4-Nested-Hooks)
  - [5. Overwriting `let`](#5-Overwriting-let)
  - [6. Implicit Subject](#6-Implicit-Subject)
  - [7. Explicit Subject](#7-Explicit-Subject)
  - [8. Described Class](#8-Described-Class)
  - [9. One-liner Syntax](#9-One-liner-Syntax)
  - [10. Shared Examples](#10-Shared-Examples)
  - [11. Shared Context](#11-Shared-Context)
  - [12. `not_to` method](#12-notto-method)
- [Matchers](#Matchers)
  - [13. Equality matchers](#13-Equality-matchers)
  - [14. Comparison Matchers](#14-Comparison-Matchers)
  - [15. Predicate Methods](#15-Predicate-Methods)
  - [16. `all` Matchers](#16-all-Matchers)
  - [17. `be` Matchers](#17-be-Matchers)
  - [18. Change Matchers](#18-Change-Matchers)
  - [19, 20. `contain_exactly` and `start/end_with` Matchers](#19-20-containexactly-and-startendwith-Matchers)
  - [21. `have_attributes` Matcher](#21-haveattributes-Matcher)
  - [22. `include` Matcher](#22-include-Matcher)
  - [23. Error Matchers](#23-Error-Matchers)
  - [24. `respond_to` Matchers](#24-respondto-Matchers)
  - [25. Satisfy Matcher](#25-Satisfy-Matcher)
  - [26. Compound Expectations](#26-Compound-Expectations)
- [Mocks and Doubles](#Mocks-and-Doubles)
  - [27, 28. Doubles](#27-28-Doubles)
  - [29, 30. `allow` Methods and Matching Arguments](#29-30-allow-Methods-and-Matching-Arguments)
  - [31. Instance Doubles](#31-Instance-Doubles)
  - [32. Class Doubles](#32-Class-Doubles)
  - [33. Spies](#33-Spies)
   

# Basics

## 1. Intro

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

## 2. Context 

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

## 3. Before/After Hooks
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

## 4. Nested Hooks
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

## 5. Overwriting `let`
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


## 6. Implicit Subject
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

## 7. Explicit Subject
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

## 8. Described Class
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

## 9. One-liner Syntax
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

## 10. Shared Examples
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

## 11. Shared Context
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

## 12. `not_to` method
```ruby
RSpec.describe 'not_to method' do
  it 'checks that two values do not match' do
    expect(5).not_to eq(1)
    expect('Hello').not_to eq('hello')
    expect([1, 2]).not_to eq([1, 2, 3])
  end

  it 'checks for the inverse of a matcher' do
    expect(5).not_to eq(10)
    expect([1, 2, 3]).not_to equal([1, 2, 3])

    expect(10).not_to be_odd
    expect([1, 2, 3]).not_to be_empty
  end
end
```

# Matchers

## 13. Equality matchers
```ruby
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
```

## 14. Comparison Matchers
```ruby
# 'be' and 'equal' can be used with comparison matchers
RSpec.describe 'comparison matchers' do
  it 'allows for comparison with built-in Ruby operators' do
    expect(10).to be > 5
    expect(3).to be < 5

    expect(1).to be >= -1
    expect(1).to be <= 2
  end

  describe 100 do
    it { is_expected.to be > 90 }
    it { is_expected.to be < 110 }

    it { is_expected.not_to be > 100 }
    it { is_expected.not_to be < 100 }
  end
end
```

## 15. Predicate Methods
```ruby
# Predicate methods usually end in '?' and return true/false
# For example: '.zero?'
RSpec.describe 'predicate methods and predicate matchers' do
  it 'can be tested with plain Ruby methods' do
    result = 16 / 2
    expect(result.even?).to eq(true)
  end

  # Format: 'be_#{custom_predicate_method_name}' (without question mark)
  it 'can be tested with predicate matchers' do
    expect(16 / 2).to be_even
    expect(16 / 2).not_to be_odd
    expect(0).to be_zero
    expect([]).to be_empty
  end

  describe 0 do
    it { is_expected.to be_zero }
    it { is_expected.to_not be_odd }
  end
end
```

## 16. `all` Matchers
```ruby
RSpec.describe 'all matcher' do
  it 'allows for aggregate checks' do
    ## Iterating through collection:
    # [5, 7, 9].each do |val|
    #   expect(val).to be_odd
    # end

    # Shorthand for above
    expect([5, 7, 9]).to all(be_odd)
    expect([2, 4, 6]).to all(be_even)
    expect([0, 0]).to all(be_zero)

    # Can be combined with comparison matchers
    expect([5, 7, 9]).to all(be < 10)
  end

  describe [5, 7, 9] do
    it { is_expected.to all(be_odd) }
    it { is_expected.to all(be < 10) }
  end
end
```

## 17. `be` Matchers
```ruby
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
```

## 18. Change Matchers
```ruby
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
```

## 19, 20. `contain_exactly` and `start/end_with` Matchers
```ruby
RSpec.describe 'contain_exactly matcher' do
  subject { [1, 2, 3] }

  describe 'long form syntax' do
    it 'should check for the presence of all elements specified' do
      expect(subject).to contain_exactly(1, 2, 3)
      expect(subject).to contain_exactly(3, 2, 1)
      expect(subject).not_to contain_exactly(1)
    end
  end

  it { is_expected.to contain_exactly(1, 2, 3) }
  it { is_expected.to contain_exactly(3, 2, 1) }
end

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
```

## 21. `have_attributes` Matcher
```ruby
class Car
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end
end

RSpec.describe 'have_attributes matcher' do
  describe Car.new('Honda', 'Civic') do
    it 'checks for object attribute and proper values' do
      expect(subject).to have_attributes(make: 'Honda')
      expect(subject).to have_attributes(make: 'Honda', model: 'Civic')
    end

    it { is_expected.to have_attributes(make: 'Honda', model: 'Civic') }
  end
end
```

## 22. `include` Matcher
```ruby
RSpec.describe 'include matcher' do
  describe 'hot chocolate' do
    it 'checks for substring inclusion' do
      expect(subject).to include('hot')
      expect(subject).to include('choc')
      expect(subject).to include('late')
    end

    it { is_expected.to include('choco') }
  end

  describe [10, 20, 30] do
    it 'checks for inclusion in the array, regardless of order' do
      expect(subject).to include(10)
      expect(subject).to include(10, 20)
      expect(subject).to include(30, 20, 10)
    end

    it { is_expected.to include(20, 30, 10) }
  end

  describe ({ a: 2, b: 4 }) do
    it 'can check for key existence' do
      expect(subject).to include(:a)
      expect(subject).to include(:b, :a)
    end

    it 'can check for a key-value pair' do
      expect(subject).to include(a: 2)
      expect(subject).to_not include(a: 3)
    end

    it { is_expected.to include(:a) }
    it { is_expected.to include(a: 2) }
  end
end
```

## 23. Error Matchers
```ruby
RSpec.describe 'raise_error matcher' do
  def some_method
    x # undefined
  end

  class CustomError < StandardError; end

  it 'can check for any error' do
    # Wrong: expect(some_method).to raise_error(NameError)
    # -> Need to be passed in as a block so error doesn't halt test suite
    # Also Wrong: expect { ... }.to raise_error
    # -> should always specify specific error

    expect { some_method }.to raise_error(NameError)
    expect { 1 / 0 }.to raise_error(ZeroDivisionError)
  end

  it 'can check for a custom error' do
    expect { raise CustomError }.to raise_error(CustomError)
  end
end
```

## 24. `respond_to` Matchers
```ruby
class Vehicle
  def drive
    'Vroom'
  end

  def honk
    'Honk'
  end

  def refuel(gallons)
    "Refueled #{gallons} gallons"
  end
end

RSpec.describe 'respond_to matcher' do
  subject { Vehicle.new }

  it 'confirms that an object can respond to a method' do
    expect(subject).to respond_to(:drive)
    expect(subject).to respond_to(:drive, :honk)
    expect(subject).to respond_to(:drive, :honk, :refuel)
  end

  it 'confirms an object can respond to a method with arguments' do
    expect(subject).to respond_to(:refuel)
    expect(subject).to respond_to(:refuel).with(1).arguments
  end

  it { is_expected.to respond_to(:refuel) }
  it { is_expected.to respond_to(:refuel).with(1).arguments }
end
```

## 25. Satisfy Matcher
```ruby
RSpec.describe 'satisfy matcher' do
  subject { 'racecar' }
  # subject { 'racecars' }

  it 'is a palindrome' do
    expect(subject).to satisfy { |value| value == value.reverse }
  end

  it 'can accept a custom error message' do
    expect(subject + 's').to satisfy('be a palindrome') do |value|
      value == value.reverse
    end
  end
end
```

## 26. Compound Expectations
```ruby
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
```

# Mocks and Doubles

## 27, 28. Doubles
```ruby
# A double is basically a 'stunt double' for the actual object
# These objects closely resemble the original objects
RSpec.describe 'a random double' do
  it 'only allows defined methods to be invoked' do
    # stuntman = double('Stuntman', fall_off_ladder: 'Ouch', light_on_fire: true)
    # expect(stuntman.fall_off_ladder).to eq('Ouch')
    # expect(stuntman.light_on_fire).to eq(true)

    # stuntman = double('Stuntman')
    # allow(stuntman).to receive(:fall_off_ladder).and_return('Ouch')
    # expect(stuntman.fall_off_ladder).to eq('Ouch')

    stuntman = double('Stuntman')
    allow(stuntman).to receive_messages(fall_off_ladder: 'Ouch', light_on_fire: true)
    expect(stuntman.fall_off_ladder).to eq('Ouch')
    expect(stuntman.light_on_fire).to eq(true)
  end
end

class Actor
  def initialize(name)
    @name = name
  end

  def ready?
    sleep(3) # Emulating a complex process that takes some amount of time
    true
  end

  def act
    'You are the one, Neo'
  end

  def dodge_bullets
    true
  end
end

class Movie
  attr_reader :actor

  def initialize(actor)
    @actor = actor
  end

  def start_shooting
    return unless actor.ready?

    actor.act
    actor.dodge_bullets
    actor.act
  end
end

# Since we are testing the Movie class, we do not care about the implementation of Actor
# We can thus create a double to mock an Actor and focus on testing Movie
RSpec.describe Movie do
  let(:stuntman) { double('Stuntman', ready?: true, act: 'Acting', dodge_bullets: true) }
  subject { described_class.new(stuntman) }

  describe '#start_shooting' do
    it 'expects an actor to do 3 actions' do
      # We write our expectations before actually calling the method
      # expect(stuntman).to receive(:ready?).once
      # expect(stuntman).to receive(:ready?).exactly(1).times
      expect(stuntman).to receive(:ready?).at_most(1).times

      # expect(stuntman).to receive(:act).twice
      # expect(stuntman).to receive(:act).exactly(2).times
      expect(stuntman).to receive(:act).at_least(2).times
      expect(stuntman).to receive(:dodge_bullets).once

      subject.start_shooting
    end
  end
end
```

## 29, 30. `allow` Methods and Matching Arguments
```ruby
RSpec.describe 'allow methods' do
  it 'can customize return value for methods on doubles' do
    calculator = double
    allow(calculator).to receive(:add).and_return(15)

    expect(calculator.add).to eq(15)
    expect(calculator.add(3)).to eq(15)
    expect(calculator.add('string')).to eq(15)
  end

  it 'can stub one or more methods on a real object' do
    arr = [1, 2, 3]
    allow(arr).to receive(:sum).and_return(10) # Will intercept default Array `sum` method
    expect(arr.sum).to eq(10)

    arr.push(4)
    expect(arr).to eq([1, 2, 3, 4]) # All other Array methods are still available
  end

  it 'can return multiple values in sequence' do
    mock_array = double
    allow(mock_array).to receive(:pop).and_return(:c, :b, nil)

    expect(mock_array.pop).to eq(:c)
    expect(mock_array.pop).to eq(:b)
    expect(mock_array.pop).to be_nil
    expect(mock_array.pop).to be_nil
  end
end

RSpec.describe 'matching arguments' do
  it 'can return different values depending on the argument' do
    three_element_array = double # [1, 2, 3]

    allow(three_element_array).to receive(:first).with(no_args).and_return(1)
    allow(three_element_array).to receive(:first).with(1).and_return([1])
    allow(three_element_array).to receive(:first).with(2).and_return([1, 2])
    allow(three_element_array).to receive(:first).with(3).and_return([1, 2, 3])
    allow(three_element_array).to receive(:first).with(be >= 3).and_return([1, 2, 3])

    expect(three_element_array.first).to eq(1)
    expect(three_element_array.first(1)).to eq([1])
    expect(three_element_array.first(2)).to eq([1, 2])
    expect(three_element_array.first(100)).to eq([1, 2, 3])
  end
end
```

## 31. Instance Doubles
```ruby
class Person
  def a
    sleep(3) # Emulating a complex process that takes some amount of time
    'Hello'
  end
end

RSpec.describe Person do
  describe 'regular double' do
    it 'can implement any method' do
      person = double(a: 'Hello', b: 20)
      expect(person.a).to eq('Hello')
    end
  end

  # RSpec can verify that the double closely resembles an instance of the actual class
  describe 'instance double' do
    it 'can only implement methods that are defined on the class' do
      # Making a double based off of an instance of the class
      # Below would trigger: `the Person class does not implement the instance method: b`
      # person = instance_double(Person, a: 'Hello', b: 20)

      # Below would trigger: `Wrong number of arguments. Expected 0, got 2.`
      # person = instance_double(Person)
      # allow(person).to receive(:a).with(3, 10).and_return('Hello')

      person = instance_double(Person)
      allow(person).to receive(:a).and_return('Hello')
    end
  end
end
```

## 32. Class Doubles
```ruby
# class Deck
#   def self.build
#     # Business logic
#   end
# end

class CardGame
  attr_reader :cards

  def start
    @cards = Deck.build # Class method call
  end
end

# Similar to instance doubles, but for classes and class methods
RSpec.describe CardGame do
  it 'can only implement class methods that are defined on a class' do
    # Below would trigger: `the Deck class does not implement the class method: shuffle`
    # deck = class_double(Deck, build: %w[Ace Queen])

    # If Deck has not been defined yet, we can pass a string class name:
    # deck = class_double('Deck', build: %w[Ace Queen])

    # Makes sure that subsequent calls to Deck within the code use this stub
    # Instead of searching for the actual Deck class
    deck_klass = class_double('Deck', build: %w[Ace Queen]).as_stubbed_const

    expect(deck_klass).to receive(:build)
    subject.start
    expect(subject.cards).to eq(%w[Ace Queen])
  end
end
```

## 33. Spies
```ruby
# Doubles place expectations before the actual action
# Spies place expectations after the actual action
RSpec.describe 'spies' do
  let(:animal) { spy('animal') }

  it 'confirms that a message has been received' do
    # With a regular double you would do the following:
    # expect(animal).to receive(:eat_food)
    # animal.eat_food

    animal.eat_food
    expect(animal).to have_received(:eat_food)
    expect(animal).not_to have_received(:eat_human)
  end

  it 'resets between examples' do
    expect(animal).not_to have_received(:eat_food)
  end

  it 'retains the same functionality of a regular double' do
    animal.eat_food
    animal.eat_food
    animal.eat_food('Sushi')
    expect(animal).to have_received(:eat_food).exactly(3).times
    expect(animal).to have_received(:eat_food).with('Sushi').once
  end
end

class Automobile
  def initialize(model)
    @model = model
  end
end

class Garage
  attr_reader :storage

  def initialize
    @storage = []
  end

  def add_to_collection(model)
    @storage << Automobile.new(model)
  end
end

RSpec.describe Garage do
  let(:automobile) { instance_double(Automobile) }

  # Make calls to Automobile return our instance double
  # Grants spy-like functionality to our instance double
  before do
    allow(Automobile).to receive(:new).and_return(automobile)
  end

  it 'adds a car to its storage' do
    subject.add_to_collection('Honda Civic')

    expect(Automobile).to have_received(:new).with('Honda Civic')
    expect(subject.storage.length).to eq(1)
    expect(subject.storage.first).to eq(automobile)
  end
end
```