require "./contest.rb"
contest = Contest.new
run lambda { |env| [200, {'Content-Type'=>'text/plain'}, contest.run(env)] }