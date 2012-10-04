#http://stackoverflow.com/questions/858970/how-to-get-a-stopwatch-program-running
class Stopwatch
  def start
    @accumulated = 0 unless @accumulated
    @elapsed = 0
    @start = Time.now
  end

  def stop
    @accumulated += @elapsed
  end

  def reset
    stop
    @accumulated, @elapsed = 0, 0
  end


  def tick
    @elapsed = Time.now - @start
    time = @accumulated + @elapsed
    h  = sprintf('%02i', (time.to_i / 3600))
    m  = sprintf('%02i', ((time.to_i % 3600) / 60))
    s  = sprintf('%02i', (time.to_i % 60))
    ms = sprintf('%03i', ((time - time.to_i)*1000).to_i)
    #ms = sprintf('%04i', ((time - time.to_i)*10000).to_i)
    #ms[0..0]=''
    "#{h}:#{m}:#{s}.#{ms}"
  end
end