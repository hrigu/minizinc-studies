require 'erb'
require File.expand_path("../world.rb", __FILE__)


world = World.new


a = Country.new "a"
b = Country.new "b"
c = Country.new "c"
d = Country.new "d"
e = Country.new "e"

countries = [a, b, c, d, e]

world.countries = countries

world.make_neighbours(a, b)
world.make_neighbours(a, c)
world.make_neighbours(b, d)
world.make_neighbours(c, d)
world.make_neighbours(b, e)
world.make_neighbours(c, e)
world.make_neighbours(d, e)

info = Info.new world

template_file_name = "template.mzn.erb"
rendered_file_name = "rendered_minizinc_file.mzn"
result_file_name = "result.txt"
renderer = ERB.new(File.read(template_file_name), nil, "<>")  #trim mode '<>' means: newline for lines starting with <% and ending in %>


File.open(rendered_file_name,"w") do |f|
  f.write(renderer.result(info.get_binding))
end


system "mzn-g12fd #{rendered_file_name} > #{result_file_name}"