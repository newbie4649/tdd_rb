# frozen_string_literal: true

class FizzBuzzType
  TYPE_01 = 1
  TYPE_02 = 2
  TYPE_03 = 3

  def self.create(type)
    case type
    when FizzBuzzType::TYPE_01
      FizzBuzzType01.new
    when FizzBuzzType::TYPE_02
      FizzBuzzType02.new
    when FizzBuzzType::TYPE_03
      FizzBuzzType03.new
    else
      raise '該当するタイプは存在しません'
    end
  end

  def fizz?(number)
    number.modulo(3).zero?
  end

  def buzz?(number)
    number.modulo(5).zero?
  end
end

class FizzBuzzType01 < FizzBuzzType
  def generate(number)
    return FizzBuzzValue.new(number, 'FizzBuzz') if fizz?(number) && buzz?(number)
    return FizzBuzzValue.new(number, 'Fizz') if fizz?(number)
    return FizzBuzzValue.new(number, 'Buzz') if buzz?(number)

    FizzBuzzValue.new(number, number.to_s)
  end
end

class FizzBuzzType02 < FizzBuzzType
  def generate(number)
    FizzBuzzValue.new(number, number.to_s)
  end
end

class FizzBuzzType03 < FizzBuzzType
  def generate(number)
    return FizzBuzzValue.new(number, 'FizzBuzz') if fizz?(number) && buzz?(number)

    FizzBuzzValue.new(number, number.to_s)
  end
end

module Assertions
  class AssertionFailedError < StandardError; end

  def assert(&condition)
    raise AssertionFailedError, 'Assertion Failed' unless condition.call
  end
end
class FizzBuzzValue
  include Assertions
  attr_reader :number, :value

  def initialize(number, value)
    assert { number >= 0 }
    @number = number
    @value = value
  end

  def to_s
    "#{@number}:#{@value}"
  end

  def ==(other)
    @number == other.number && @value == other.value
  end

  alias eql? ==
end

class FizzBuzzList
  attr_reader :value

  def initialize(list)
    @value = list
  end

  def to_s
    @value.to_s
  end

  def add(value)
    FizzBuzzList.new(@value + value)
  end
end

class FizzBuzzCommand; end

class FizzBuzzValueCommand < FizzBuzzCommand
  def initialize(type)
    @type = type
  end

  def execute(number)
    @type.generate(number)
  end
end

class FizzBuzzListCommand < FizzBuzzCommand
  def initialize(type)
    @type = type
  end

  def execute(number)
    FizzBuzzList.new((1..number).map { |i| @type.generate(i) })
  end
end
