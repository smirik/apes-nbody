class Nbody 
  
  # print @pos & @vel for each body in one string
  def cartesian
    @body.each do |b| 
      b.pos.each{|x| printf("%24.16e;", x)} 
      b.vel.each{|x| printf("%24.16e;", x)} 
    end
  end
  
  # print pos for each body
  def positions
    @body.each do |b| 
      b.pos.each{|x| printf("%24.16e;", x)} 
    end
  end  

  # print vel for each body
  def velocities
    @body.each do |b| 
      b.vel.each{|x| printf("%24.16e;", x)} 
    end
  end  
  
  def energies
    @body.each{|b| printf("%24.16e", b.ediff)}
  end
  
  def total_energies
    if (@e_total.empty?)
      @body.each{|b| @e_total.push(b.ediff.abs)}
    else
      @body.each_with_index do |b, key|
        @e_total[key] += b.ediff.abs
      end
    end
    @e_total.each{|e| printf("%24.16e", e)}
  end
  
end