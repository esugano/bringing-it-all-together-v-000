require 'pry'

class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, breed:, id:nil)
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
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM dogs').flatten
      binding.pry
  end
end
