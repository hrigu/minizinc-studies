require 'erb'
require File.dirname(__FILE__) + "/model.rb"
require File.dirname(__FILE__) + "/builder.rb"
require File.dirname(__FILE__) + "/stopwatch.rb"

class Info
  attr_accessor :n_courses, :capacity, :c_name
  attr_accessor :n_students, :s_name
  attr_accessor :wish_of_students


  def info
    self
  end

  def get_binding
    binding()
  end

  def self.create
    info = Info.new
    info.n_courses = Course.courses.size
    info.capacity = Course.courses.map { |c| c.capacity }
    info.c_name = Course.courses.map { |c| c.id.to_s }

    info.n_students = Student.students.size
    info.s_name = Student.students.map { |s| s.id.to_s }

    info.wish_of_students = Student.students.map { |s| s.wish.map { |w| w+1 } }
    info
  end

end

watch = Stopwatch.new

1.times do
  Builder.new(5, 25).create

  info = Info.create

  t = Time.now
  time_as_string = "#{t.month}_#{t.day}_#{t.min}_#{t.sec}"

  template_file_name = "template.mzn.erb"
  rendered_file_name = "students-to-courses_#{time_as_string}.dzn"
  renderer = ERB.new(File.read(template_file_name), nil, "<>") #trim mode '<>' means: newline for lines starting with <% and ending in %>

  File.open("mzn/#{rendered_file_name}", "w") do |f|
    f.write(renderer.result(info.get_binding))
  end

  Dir.chdir "mzn"
  result_file = "results/result_#{time_as_string}.txt"
  watch.start
  system "mzn-g12fd students-to-courses2.mzn #{rendered_file_name} > #{result_file}"
  puts watch.tick
  Dir.chdir ".."
  watch.reset
end