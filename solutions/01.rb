#!/usr/bin/ruby

# Add a new methods (function) to class Integer.

class Integer
  def remainder (quotient, divisor)
    if quotient % divisor == 0
      return false
    else
      return true
    end
  end
  def has_divisor_except_itself_and_one (number)
    divisor = number - 1
    while divisor > 1 do
      return false if not remainder number, divisor
      divisor -= 1
    end
    return true
  end
  def finds_first_prime_divisor list
    num = 2
    while num <= list[-1].abs
      pr_div = list[-1].abs / num
      return list+[num,pr_div] if num.prime? and not remainder list[-1].abs,num
      num += 1
    end
  end
  def prime?
    if self <= 1
      return false
    elsif self > 1
      has_divisor_except_itself_and_one self
    end
  end
  def prime_factors
    list_of_prime_factors = [self]
    while not list_of_prime_factors[-1].abs.prime?
      list_of_prime_factors = finds_first_prime_divisor list_of_prime_factors
      list_of_prime_factors.delete_at(-3)
    end
    puts list_of_prime_factors.sort
  end
  def digits
    list = []
    number = self
    while number != 0
      list.push number % 10
      number /= 10
    end
    puts list.reverse
  end
end

class Array
  def average
    sum = 0
    self.each { |n| sum += n }
    puts sum / self.length
  end
end