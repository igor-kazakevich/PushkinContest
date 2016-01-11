require 'rack'

require "./contest.rb"

$stdout.sync = true

puts ENV['PORT']

Contest.prepare
run(Contest)
