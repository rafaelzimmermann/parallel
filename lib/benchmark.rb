# frozen_string_literal: true
require 'benchmark'
require 'parallel'
require 'open-uri'
require 'net/http'



TIMES = 1000

t1 = 0


def reset
  uri = URI.open('http://192.168.50.211:9090/reset')
end
rand =
reset
Benchmark.bm do |b| 
  20.times do |i| 
    b.report("thread-#{i}") {
      rand = Random.new(42)
      input = (1..TIMES).to_a.map { |x| rand.rand.to_i * 100}
      
      Parallel.map(input, in_threads: 75) { |x| 
        uri = URI.parse("http://192.168.50.211:9090/api/#{x}")
        uri.open { |f| 
          t1 = f
        }
      }
      
    }
    reset
    b.report("fiber-#{i}") {
        rand = Random.new(42)
        input = (1..TIMES).to_a.map { |x| rand.rand.to_i * 100}
        Parallel.map(input, in_fibers: 75) { |x| 
            uri = URI.parse("http://192.168.50.211:9090/api/#{x}")
            uri.open { |f| 
              t1 = f
            }
        }
    }
  end
end
reset