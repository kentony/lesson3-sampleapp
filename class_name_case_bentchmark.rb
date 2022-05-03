require 'benchmark/ips'

class A
  def compare_as_class
    100000.times do
      case self
      when B
      when A
      end
    end
  end

  def compare_as_string
    100000.times do
      case self.class.name
      when "B"
      when "A"
      end
    end
  end

  def compare_as_variable_string
    ckassName = self.class.name
    100000.times do
      case ckassName
      when "B"
      when "A"
      end
    end
  end
end

class B
end

Benchmark.ips do |x|
  x.config(:time => 5, :warmup => 2)

  x.report("self") { A.new.compare_as_class }
  x.report("self.class.name") { A.new.compare_as_string }
  x.report("string") { A.new.compare_as_variable_string }

  x.compare!
end
