require 'erb'
require File.dirname(__FILE__) + "/model.rb"
require File.dirname(__FILE__) + "/builder.rb"

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
end


Builder.create


info = Info.new
info.n_courses = Course.courses.size
info.capacity = Course.courses.map{|c| c.capacity}
info.c_name = Course.courses.map{|c| c.id.to_s}

info.n_students = Student.students.size
info.s_name = Student.students.map{|s| s.id.to_s}

info.wish_of_students = Student.students.map{ |s| s.wish.map{|w| w+1}}


template_file_name = "template.mzn.erb"
rendered_file_name = "mzn/students-to-courses.dzn"
renderer = ERB.new(File.read(template_file_name), nil, "<>") #trim mode '<>' means: newline for lines starting with <% and ending in %>

File.open(rendered_file_name, "w") do |f|
  f.write(renderer.result(info.get_binding))
end

Dir.chdir "mzn"
system "mzn-g12fd students-to-courses.mzn students-to-courses.dzn > result.txt"