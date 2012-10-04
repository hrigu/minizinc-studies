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




