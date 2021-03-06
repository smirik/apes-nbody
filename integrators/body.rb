class Body

  attr_accessor :mass, :pos, :vel, :time, :name, :e0

  def initialize(mass = 0, pos = Vector[0,0,0], vel = Vector[0,0,0], name = false)
    @mass, @pos, @vel, @name = mass, pos, vel, name
    @e0 = 0
  end 
  
  def set_time(time)
    @time = time
  end

  def calc(body_array, time_step, s)
    ba  = body_array
    dt = time_step  
    eval(s)
  end

  def acc(body_array)
    u = CONFIG['constants']['u'].to_f
    a = -@pos*(1.0+@mass)/(@pos.module**3)*u
    body_array.each do |b|
      unless b == self
        r   = b.pos - @pos
        a += r*(b.mass*u/r.module**3)-b.pos*(b.mass*u/b.pos.module**3)
      end
    end
    a
  end    

  def jerk(body_array)
    j = @pos*0                             
    body_array.each do |b|
      unless b == self
        r = b.pos - @pos
        r2 = r*r 
        r3 = r2*sqrt(r2)
        v = b.vel - @vel
        j += (v-r*(3*(r*v)/r2))*(b.mass*CONFIG['constants']['u']/r3)
      end
    end
    j
  end    

  def to_s
    #"  mass = " + @mass.to_s + "\n" +
    #"   pos = " + @pos.join(", ") + "\n" 
    "" + @pos.join(", ") + "\n" 
    #"   vel = " + @vel.join(", ") + "\n"
  end

  def pp                           
    printf("%10s", @name)
    @pos.each{|x| printf("%24.16e", x)};
    @vel.each{|x| printf("%24.16e", x)}; print "\n"
  end
  
  def gp
    @pos.each{|x| printf("%24.16e;", x)};
    @vel.each{|x| printf("%24.16e;", x)};
  end
  
  def ppx(body_array)         
    STDERR.print to_s + "   acc = " + acc(body_array).join(", ") + "\n"
  end

  def simple_print
    printf("%s %24.16e\n", @name, @mass)
    @pos.each{|x| printf("%24.16e", x)}; print "\n"
    @vel.each{|x| printf("%24.16e", x)}; print "\n"
  end

  def simple_read
    @name = gets.to_s.strip
    @mass = gets.to_f
    @pos = gets.split.map{|x| x.to_f}.to_v
    @vel = gets.split.map{|x| x.to_f}.to_v
    e_init
  end
  
  def to_a
    [@mass, @pos, @vel]
  end
  
  def from_a(a)
    @mass = a[0]
    @pos  = a[1]
    @vel  = a[2]
  end
  
  def ekin                        # kinetic energy
    0.5*(@vel*@vel)               # per unit of reduced mass
  end

  def epot                        # potential energy
    -@mass/@pos.module
  end

  def e_init                      # initial total energy
    @e0 = ekin + epot             # per unit of reduced mass
  end

  def ediff
    etot = ekin + epot
    diff = (etot - @e0)
  end

end