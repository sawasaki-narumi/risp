class Env < Hash
  attr_accessor :outer

  def initialize(outer = nil)
    @outer = outer
  end

  def search(key)
    if self[key]
      self
    else
      @outer ? @outer.search(key) : nil
    end
  end

  def self.globals
    env = new
    env.merge({
                "+" => Env::Operator.method(:+), "-" => Env::Operator.method(:-),
                "/" => Env::Operator.method(:/), "*" => Env::Operator.method(:*),
                "==" => Env::Operator.method(:==), "!=" => Env::Operator.method(:!=),
                ">" => Env::Operator.method(:>), "<" => Env::Operator.method(:<),
                ">=" => Env::Operator.method(:>=), "<=" => Env::Operator.method(:<=), })
  end

  module Operator
    def self.+(x, y)
      x + y
    end

    def self.-(x, y)
      x - y
    end

    def self./(x, y)
      x / y
    end

    def self.*(x, y)
      x * y
    end

    def self.!=(x, y)
      x != y
    end

    def self.>(x, y)
      x > y
    end

    def self.<(x, y)
      x < y
    end

    def self.>=(x, y)
      x >= y
    end

    def self.<=(x, y)
      x <= y
    end

    def self.==(x, y)
      x == y
    end

  end

end
