class Country
  attr_reader :name
  attr_accessor :neighbours
  def initialize name = "undefined"
    @name = name
    @neighbours = []
  end
end


class World
  attr_accessor :countries, :num_colors
  attr_reader :neighbours



  def initialize
    @countries = []
    @neighbours = []
    @num_colors = 3
  end

  def make_neighbours a, b
    a.neighbours << b
    b.neighbours << a
    @neighbours << [a, b]
  end

end


class Info
  attr_reader :parameters, :solver_strategy

  def initialize(world, solver_strategy = "satisfy")
    @world = world
    @parameters = ["int: num_colors = #{@world.num_colors}"]
    @solver_strategy = solver_strategy
  end

  def decision_variables
    @world.countries.map do |c|
      "var 1..num_colors: #{c.name}"
    end
  end

  def constraints
    @world.neighbours.map do |pair|
      "constraint #{pair[0].name} != #{pair[1].name}"
    end

  end

  def output
    out = "["
    @world.countries.each do |c|
      out += "\"#{c.name}=\", show(#{c.name}), \"\\n\", "
    end
    out += "]"
    out
  end

  def info
    self
  end

  def get_binding
    binding()
  end
end