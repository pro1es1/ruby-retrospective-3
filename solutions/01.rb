#!/usr/bin/ruby

# Add a new methods (function) to class Integer.

class Integer
  def is_prime? number
    if self / number == 1 then return true end
    if self % number == 0 then return false else is_prime? number + 1 end
  end
  def prime?
    is_prime? 2
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