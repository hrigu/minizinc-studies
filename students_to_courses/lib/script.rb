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


def solve_with_minizinc(rendered_file_name, time_as_string, watch)
  Dir.chdir "mzn"
  result_file = "results/result_#{time_as_string}.txt"
  watch.start
  system "mzn-g12fd students-to-courses.mzn #{rendered_file_name} > #{result_file}"
  puts time_as_string +" - "+watch.tick
  Dir.chdir ".."
  watch.reset
end
def solve_with_yices(rendered_file_name, time_as_string, watch)
#  Dir.chdir "mzn"
  result_file = "mzn/results/result_#{time_as_string}.txt"
  watch.start
  system "./yices.sh mzn/students-to-courses.mzn mzn/#{rendered_file_name} > #{result_file}"
  puts time_as_string +" - "+watch.tick
  Dir.chdir ".."
  watch.reset
end

watch = Stopwatch.new


1.times do
  #Builder.new([50,0,0], [50, 0, 0]).create
  #Builder.new([0,50,0], [0, 50, 0]).create
  #Builder.new([0,0,50], [0, 0, 50]).create

  #Builder.new([0,0,50], [50, 0, 0]).create         #00:00:00.804
  Builder.new([50,0,50], [50, 0, 0]).create         #00:00:01.029
  Builder.new([50,50,50], [50, 0, 0]).create         #00:00:0.990
  Builder.new([20,20,20], [50, 0, 0]).create         #geht eeewig
  Builder.new([20,20,20], [10, 10, 10]).create       # < 1 s
  Builder.new([20,20,20], [20, 20, 20]).create       # < eewig
  Builder.new([20,20,60], [20, 20, 20]).create       # < 2 s





  #Builder.new([20,20,20], [20, 20, 20]).create
  #Builder.new([10,10,10], [10, 10, 10]).create     #plitzschnell
  #Builder.new([10,10,20], [10, 10, 20]).create     #geht lange!! 1 min 45 sekunden
  #Builder.new([20,10,10], [20, 10, 10]).create     #geht schnell
  #Builder.new([10,20,10], [10, 20, 10]).create     #geht schnell

  info = Info.create

  t = Time.now
  time_as_string = t.strftime("%y_%m_%d_%H_%M_%S_%L")
  template_file_name = "template.mzn.erb"
  rendered_file_name = "students-to-courses_#{time_as_string}.dzn"
  renderer = ERB.new(File.read(template_file_name), nil, "<>") #trim mode '<>' means: newline for lines starting with <% and ending in %>

  File.open("mzn/#{rendered_file_name}", "w") do |f|
    f.write(renderer.result(info.get_binding))
  end

  solve_with_yices(rendered_file_name, time_as_string, watch)


end