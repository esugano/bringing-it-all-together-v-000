class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:nil, breed:nil)
    @name = name
    @breed = breed
    @id = id
  end
end
