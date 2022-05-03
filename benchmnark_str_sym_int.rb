require 'benchmark/ips'

STR = { "name" => "tone" }
SYM = { :name => "tone" }
INT = { 1 => "tone" } 

Benchmark.ips do |x|

  x.config(:time => 5, :warmup => 2)

  x.time = 5
  x.warmup = 2
  
  x.report("String") { STR["name"] }
  x.report("Symbol") { SYM[:name] }
  x.report("Integer") { INT[1] }

  x.compare!

end