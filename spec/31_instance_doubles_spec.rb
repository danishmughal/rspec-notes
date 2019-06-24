# frozen_string_literal: true

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
