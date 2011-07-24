require "integrators/nbody.rb"

class NbodyStepControl < Nbody
  
  attr_accessor :le
  
  def initialize
    @le   = CONFIG['integration']['error']
    super
  end
  
  def evolve(integration_method, dt)
    @dt = dt                                                                 #1
    @nsteps = 0
    t_end = @stop_time - 0.5*dt
    while @time < t_end
      # Calculate with step dt
      bcopy = Array.new # save old value
      @body.each {|b| bcopy.push(b.to_a) }
      send(integration_method)
      # Save calculated value to find local error
      res = Array.new
      @body.each {|b| res.push([b.pos, b.vel])}
      
      # Calculate with step dt/2
      @body.each_with_index {|b, key| b.from_a(bcopy[key]) }
      @dt = @dt/2
      send(integration_method)
      send(integration_method)
      le = self.local_error(res)
      if (le[0] < @le)
        @dt = @dt*2
        @time += @dt
        if ((@nsteps % @interval) == 0)
          puts le[0]
          self.gp
        end
        @nsteps += 1
      else
        @interval = @interval*2
        # nothing
      end
    end
  end  
  
end