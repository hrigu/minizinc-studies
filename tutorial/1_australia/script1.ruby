require 'erb'

class Info
  attr_accessor :parameters, :decision_variables, :constraints, :solver_strategy, :output

  def initialize(solver_strategy = "satisfy")
    @parameters = []
    @decision_variables = []
    @constraints = []
    @solver_strategy = solver_strategy
  end

  def decision_variables
    @decision_variables.map do |dv|
      "var 1..nc: #{dv}"
    end
  end

  def output
    out = "["
    @decision_variables.each do |dv|
      out += "\"#{dv}=\", show(#{dv}), \"\\n\", "
    end
    out += "]"
    out
  end
end



info = Info.new
info.parameters << "int: nc = 3"
info.decision_variables = ["wa", "nt", "sa", "q", "nsw", "v", "t"]

info.constraints = ["constraint wa != nt",
                    "constraint wa != sa",
                    "constraint nt != sa",
                    "constraint nt != q",
                    "constraint sa != q",
                    "constraint sa != nsw",
                    "constraint sa != v",
                    "constraint q != nsw",
                    "constraint nsw != v"
]

template_file_name = "template.mzn.erb"
rendered_file_name = "rendered_minizinc_file.mzn"
result_file_name = "result.txt"
renderer = ERB.new(File.read(template_file_name), nil, "<>")  #trim mode '<>' means: newline for lines starting with <% and ending in %>


File.open(rendered_file_name,"w") do |f|
  f.write(renderer.result(binding))
#  f.write info.parameters[0]
end

#p ENV["PATH"]

#system "echo $PATH"
system "mzn-g12fd #{rendered_file_name} > #{result_file_name}"