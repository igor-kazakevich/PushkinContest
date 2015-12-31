require 'net/http'
require 'cgi'

class Contest

  def run(env)
    puts CGI::parse(env["QUERY_STRING"])
    return ["Answer send!"]
  end

  def sendAnswer
    uri = URI("http://requestb.in/1clqg6j1")
    parameters = {
      answer: "answer",
      token: 'f833352191dabd2141f05ac14eb82073',
      task_id: "task_id"
    }

    Net::HTTP.post_form(uri, parameters)
  end
end