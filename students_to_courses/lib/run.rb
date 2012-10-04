require File.dirname(__FILE__) + "/stopwatch.rb"

t = Time.now
time_as_string = "#{t.month}_#{t.day}_#{t.min}_#{t.sec}"
result_file = "results/result_#{time_as_string}.txt"

watch = Stopwatch.new

Dir.chdir "mzn"
result_file = "results/result_#{time_as_string}.txt"
watch.start
system "mzn-g12fd students-to-courses.mzn students-to-courses_10_5_16_1.dzn > #{result_file}"
puts watch.tick
Dir.chdir ".."
watch.reset