#\ -s puma

require "./contest.rb"

$stdout.sync = true

Contest.prepare
run(Contest)
