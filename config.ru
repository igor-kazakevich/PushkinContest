require 'rack'

require "./contest.rb"

$stdout.sync = true

Contest.prepare
run(Contest)
