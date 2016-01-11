require 'rack'

require "./contest.rb"

$stdout.sync = true

run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
