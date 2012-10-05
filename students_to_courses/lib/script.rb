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

10.times do
  Builder.new(10, 50).create

  info = Info.create

  t = Time.now
  time_as_string = t.strftime("%y_%d_%H_%M_%S_%L")
  template_file_name = "template.mzn.erb"
  rendered_file_name = "students-to-courses_#{time_as_string}.dzn"
  renderer = ERB.new(File.read(template_file_name), nil, "<>") #trim mode '<>' means: newline for lines starting with <% and ending in %>

  File.open("mzn/#{rendered_file_name}", "w") do |f|
    f.write(renderer.result(info.get_binding))
  end

  Dir.chdir "mzn"
  result_file = "results/result_#{time_as_string}.txt"
  watch.start
  system "mzn-g12fd students-to-courses.mzn #{rendered_file_name} > #{result_file}"
  puts time_as_string +" - "+watch.tick
  Dir.chdir ".."
  watch.reset
end