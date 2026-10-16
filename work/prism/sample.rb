module Greeting
  DEFAULT = "world"

  class Formal
    def initialize(title)
      @title = title
    end

    def greet(name = DEFAULT)
      "Good evening, #{@title} #{name}."
    end

    def self.build(title)
      new(title)
    end
  end

  class Casual
    def greet(name = DEFAULT) = "hi #{name}"
  end
end

def shout(text)
  text.upcase
end
