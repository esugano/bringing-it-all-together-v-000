require 'pry'

class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE IF EXISTS dogs')
  end

  def save
    if self.id
      self.update
    else
      DB[:conn].execute('INSERT INTO dogs (name, breed) VALUES (?,?)', self.name, self.breed)
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM dogs')[0][0]
    end
    self
  end

  def update
    sql = <<-SQL
    UPDATE dogs
    SET name = ?, breed = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

  describe "::create" do
    it 'takes in a hash of attributes and uses metaprogramming to create a new dog object. Then it uses the #save method to save that dog to the database'do
      Dog.create(name: "Ralph", breed: "lab")
      expect(DB[:conn].execute("SELECT * FROM dogs")).to eq([[1, "Ralph", "lab"]])
    end
    it 'returns a new dog object' do
      dog = Dog.create(name: "Dave", breed: "podle")

      expect(teddy).to be_an_instance_of(Dog)
      expect(dog.name).to eq("Dave")
    end
  end

  def self.create(name, breed)
    self.new(name: name, breed:breed).save
  end
end
