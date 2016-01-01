#\ -s puma

require "./contest.rb"

$stdout.sync = true

run(Contest.new)
