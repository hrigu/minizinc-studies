class Builder

  def self.create
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