require File.dirname(__FILE__) + "/model.rb"

class Base_Builder
  def create
    courses_def, students_def = create_definitions()

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

class ConcreteBuilder < Base_Builder
  def create_definitions
    courses_def = [
        [:a, 0], [:b, 4], [:c, 4], [:d, 20]
    ]
    students_def = [
        [:A, :a, :b, :c],
        [:B, :d, :b, :a],
        [:C, :a, :c, :d],
        [:E, :c, :d, :a],
        [:F, :d, :c, :b],
        [:G, :b, :d, :a],
        [:H, :a, :b, :c],
        [:I, :d, :b, :a],
        [:J, :a, :c, :d],
        [:K, :c, :d, :a],
        [:L, :d, :c, :b],
        [:M, :b, :d, :a],
        [:N, :b, :d, :a],
        [:O, :a, :b, :c],
        [:P, :d, :b, :a],
        [:Q, :a, :c, :d],
        [:R, :c, :d, :a],
        [:S, :d, :c, :b],
        [:T, :b, :d, :a]
    ]
    return courses_def, students_def
  end
end

class Random_Builder < Base_Builder
  def initialize num_courses, num_students
    @num_courses, @num_students = num_courses, num_students
  end

  def create_definitions()
    course_size = @num_students.div(@num_courses)

    if ((course_size * @num_courses) < @num_students)
      course_size+= 1
    end

    courses_def = []
    @num_courses.times do |i|
      courses_def << [i, course_size]
    end

    students_def = []

    @num_students.times do |i|
      choices = courses_def.sample(3).map { |c| c[0] }
      students_def << [i, choices[0], choices[1], choices[2]]
    end
    return courses_def, students_def
  end
end

class Builder < Base_Builder
  def initialize(course_capacities, num_students_array)
    @course_capacities, @num_students_array = course_capacities, num_students_array
  end

  def create_definitions()

    courses_def = []
    @course_capacities.each_with_index do |capa, i|
      courses_def << [i, capa]
    end

    course_defs_for_students = []
    @num_students_array.each_index do |i|
      @num_students_array[i].times do |j|
        a = other_indices(i)
        course_defs_for_students << [courses_def[i][0], courses_def[a[0]][0], courses_def[a[1]][0]]
      end
    end
    course_defs_for_students.shuffle!

    students_def = []
    course_defs_for_students.each_with_index do |c_d, index|
      students_def << [index, c_d[0], c_d[1], c_d[2]]
    end

    return courses_def, students_def
  end

  def other_indices(i)
    a = Array (0...@course_capacities.size)
    a.delete i
    a.shuffle!
  end
end

