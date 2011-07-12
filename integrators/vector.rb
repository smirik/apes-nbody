class Vector < Array
  def +(a)
    sum = Vector.new
    self.each_index{|k| sum[k] = self[k]+a[k]}
    sum
  end
  def -(a)
    diff = Vector.new
    self.each_index{|k| diff[k] = self[k]-a[k]}
    diff
  end
  def -@
    self.map{|x| -x}.to_v
  end
  def +@
    self
  end
  def *(a)
    if a.class == Vector              # в случае векторного произведения
      product = 0
      self.each_index{|k| product += self[k]*a[k]}
    else
      product = Vector.new           # скалярное произведение
      self.each_index{|k| product[k] = self[k]*a}
    end
    product
  end
  def /(a)
    if a.class == Vector
      raise
    else
      quotient = Vector.new           # скалярное
      self.each_index{|k| quotient[k] = self[k]/a}
    end
    quotient
  end

  def module
     tmp = self.inject(0){|result, elem| result + elem*elem}
     tmp**0.5
  end
  
  def pp
    self.each_index{|k| puts "#{k} = #{self[k]}"}
  end
  
end

class Array
  def to_v
    Vector[*self]
  end
end
