class Course
  attr_accessor :id, :capacity

  def initialize(id, cap)
    @id, @capacity = id, cap
  end

  def self.courses=(courses)
    @@courses = courses
  end

  def self.courses
    @@courses
  end

  def to_s
    @id
  end
  def self.index(id)
     @@courses.index{|c| c.id == id}
#    @@courses.each do |c|
#      if (c.id == id)
#        return c
#      end
#    end
  end
end


class Student
  attr_accessor :id, :wish

  def initialize id, wish
    @id, @wish = id, wish
  end

  def self.students=(students)
    @@students = students
  end

  def self.students
    @@students
  end

  def wish_as_id
    @wish.map {|i| Course.courses[i].id}
  end


end


class Builder

  def self.create
    courses_def = [
        [:a, 1], [:b, 2], [:y, 1], [:x, 2]
    ]
    students_def = [
        [:A, :a, :b, :y],
        [:B, :x, :b, :a],
        [:C, :a, :y, :x],
        [:E, :y, :x, :a],
        [:E, :x, :y, :b],
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




