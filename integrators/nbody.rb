include Math
require "integrators/vector.rb"
require 'integrators/body.rb'

class Nbody

  attr_accessor :time, :stop_time, :body 

  def initialize
    @body = []
  end      
  
  def evolve(integration_method, dt)
    @dt = dt                                                                 #1
    @nsteps = 0
    t_end = @stop_time - 0.5*dt
    while @time < t_end
      send(integration_method)
      self.gp
      @time += dt
      @nsteps += 1
    end
  end

  def calc(s)
    @body.each{|b| b.set_time(@time)}
    @body.each{|b| b.calc(@body, @dt, s)}
  end

  def forward
    calc(" @old_acc = acc(ba) ")
    calc(" @pos += @vel*dt ")
    calc(" @vel += @old_acc*dt ")
  end

  def leapfrog
    calc(" @vel += acc(ba)*0.5*dt ")
    calc(" @pos += @vel*dt ")
    calc(" @vel += acc(ba)*0.5*dt ")
  end

  def rk2
    calc(" @old_pos = @pos ")
    calc(" @half_vel = @vel + acc(ba)*0.5*dt ")
    calc(" @pos += @vel*0.5*dt ")
    calc(" @vel += acc(ba)*dt ")
    calc(" @pos = @old_pos + @half_vel*dt ")
  end

  def rk4
    calc(" @old_pos = @pos ")
    calc(" @a0 = acc(ba) ")
    calc(" @pos = @old_pos + @vel*0.5*dt + @a0*0.125*dt*dt ")
    calc(" @a1 = acc(ba) ")
    calc(" @pos = @old_pos + @vel*dt + @a1*0.5*dt*dt ")
    calc(" @a2 = acc(ba) ")
    calc(" @pos = @old_pos + @vel*dt + (@a0+@a1*2)*(1/6.0)*dt*dt ")
    calc(" @vel += (@a0+@a1*4+@a2)*(1/6.0)*dt ")
  end

  def yo6
    d = [0.784513610477560e0, 0.235573213359357e0, -1.17767998417887e0,
         1.31518632068391e0]
    old_dt = @dt
    for i in 0..2
      @dt = old_dt * d[i]
      leapfrog
    end
    @dt = old_dt * d[3]
    leapfrog
    for i in 0..2
      @dt = old_dt * d[2-i]
      leapfrog
    end
    @dt = old_dt
  end

  def yo8
    d = [0.104242620869991e1, 0.182020630970714e1, 0.157739928123617e0, 
         0.244002732616735e1, -0.716989419708120e-2, -0.244699182370524e1, 
         -0.161582374150097e1, -0.17808286265894516e1]
    old_dt = @dt
    for i in 0..6
      @dt = old_dt * d[i]
      leapfrog
    end
    @dt = old_dt * d[7]
    leapfrog
    for i in 0..6
      @dt = old_dt * d[6-i]
      leapfrog
    end
    @dt = old_dt
  end

  def hermite
    calc(" @old_pos = @pos ")
    calc(" @old_vel = @vel ")
    calc(" @old_acc = acc(ba) ")
    calc(" @old_jerk = jerk(ba) ")
    calc(" @pos += @vel*dt + @old_acc*(dt*dt/2.0) + @old_jerk*(dt*dt*dt/6.0) ")
    calc(" @vel += @old_acc*dt + @old_jerk*(dt*dt/2.0) ")
    calc(" @vel = @old_vel + (@old_acc + acc(ba))*(dt/2.0) +
                      (@old_jerk - jerk(ba))*(dt*dt/12.0) ")
    calc(" @pos = @old_pos + (@old_vel + vel)*(dt/2.0) +
                      (@old_acc - acc(ba))*(dt*dt/12.0) ")
  end

  def ms8
    if @nsteps == 0
      calc(" @a7 = acc(ba) ")
      yo8
    elsif @nsteps == 1
      calc(" @a6 = acc(ba) ")
      yo8
    elsif @nsteps == 2
      calc(" @a5 = acc(ba) ")
      yo8
    elsif @nsteps == 3
      calc(" @a4 = acc(ba) ")
      yo8
    elsif @nsteps == 4
      calc(" @a3 = acc(ba) ")
      yo8
    elsif @nsteps == 5
      calc(" @a2 = acc(ba) ")
      yo8
    elsif @nsteps == 6
      calc(" @a1 = acc(ba) ")
      yo8
    else
      calc(" @a0 = acc(ba) ")
      calc(" @j = (@a0*1089 - @a1*2940 + @a2*4410 - @a3*4900 + @a4*3675 - @a5*1764 + 
           @a6*490 - @a7*60)/420 ")
      calc(" @s = (@a0*938 - @a1*4014 + @a2*7911 - @a3*9490 + @a4*7380 - @a5*3618 +
           @a6*1019 - @a7*126)/180 ")
      calc(" @c = (@a0*967 - @a1*5104 + @a2*11787 - @a3*15560 + 
          @a4*12725 - @a5*6432 + @a6*1849 - @a7*232)/120 ")
      calc(" @p = (@a0*56 - @a1*333 + @a2*852 - @a3*1219 + @a4*1056 - @a5*555 +
           @a6*164 - @a7*21)/6 ")
      calc(" @x = (@a0*46 - @a1*295 + @a2*810 - @a3*1235 +
           @a4*1130 - @a5*621 + @a6*190 - @a7*25)/6 ")
      calc(" @y = @a0*4 - @a1*27 + @a2*78 - @a3*125 + @a4*120 - @a5*69 + @a6*22 - @a7*3 ")
      calc(" @z = @a0 - @a1*7 + @a2*21 - @a3*35 + @a4*35 - @a5*21 + @a6*7 - @a7 ")
      calc(" @pos += (vel+(@a0+(@j+(@s+(@c+(@p+(@x+@y/8)/7)/6)/5)/4)/3)*dt/2)*dt ")
      calc(" @vel += (@a0 +(@j +(@s+(@c+(@p+(@x+(@y+@z/8)/7)/6)/5)/4)/3)/2)*dt ")
      calc(" @a7 = @a6 ")
      calc(" @a6 = @a5 ")
      calc(" @a5 = @a4 ")
      calc(" @a4 = @a3 ")
      calc(" @a3 = @a2 ")
      calc(" @a2 = @a1 ")
      calc(" @a1 = @a0 ")
    end
  end

  def gp                           
    print @time.to_s+";"
    if (CONFIG['integration']['debug'] == 1)
      sum = 0;
      @body.each{|b| sum += b.ediff}
      print "#{sum};"
      @body.each{|b| b.gp}
    else
      @body.each{|b| b.gp}
    end
    print "\n"
  end

  def pp
    printf("%24.16e ", @time)
    @body.each{|b| b.simple_print}
  end

  def simple_read
    n = gets.to_i
    @time      = gets.to_f
    @time      = CONFIG['integration']['start_time'] if (@time == 0)
    @stop_time = gets.to_f
    @stop_time = CONFIG['integration']['stop_time']  if (@stop_time == 0)
    for i in 0...n
      @body[i] = Body.new
      @body[i].simple_read
    end
  end

end
