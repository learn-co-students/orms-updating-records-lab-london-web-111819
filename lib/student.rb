require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = "CREATE TABLE students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade INTEGER);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(db_array)
    student = self.new(db_array[0], db_array[1], db_array[2])
    student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    student = DB[:conn].execute(sql, name)
    new_student = self.new(student[0][0], student[0][1], student[0][2])
    new_student
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else
      sql = "INSERT INTO students
            VALUES (?, ?, ?)"
      DB[:conn].execute(sql, @id, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
end

# binding.pry
# 'Done.'