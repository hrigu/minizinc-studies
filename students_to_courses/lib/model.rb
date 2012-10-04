class Course
  attr_accessor :name, :capacity

  def initialize(name, cap)
    @name, @capacity = name, cap
  end

  def self.courses=(courses)
    @@courses = courses
  end

  def self.courses
    @@courses
  end

  def to_s
    @name
  end
  def self.index(name)
     @@courses.index{|c| c.name == name}
#    @@courses.each do |c|
#      if (c.name == name)
#        return c
#      end
#    end
  end
end


class Student
  attr_accessor :name, :wish

  def initialize name, wish
    @name, @wish = name, wish
  end

  def self.students=(students)
    @@students = students
  end

  def self.students
    @@students
  end

  def wish_as_name
    @wish.map {|i| Course.courses[i].name}
  end


end


class Builder

  def self.create
    courses_def = [
        [:a, 1], [:b, 2], [:c, 1], [:x, 2]
    ]
    students_def = [
        [:A, :a, :b, :c],
        [:B, :x, :b, :a],
        [:C, :a, :c, :x],
        [:E, :c, :x, :a],
        [:E, :x, :c, :b],
        [:F, :b, :x, :a]
    ]

    courses = []
    courses_def.each do |c|
      courses << Course.new(c[0], c[1])
    end
    Course.courses= courses

    students = []
    students_def.each do |s|
      students << Student.new(s[0], [Course.index(s[1]), Course.index(s[2]), Course.index(s[3])])
    end

    Student.students = students
  end

end




