require 'net/http'

class Contest
  def run
    uri = URI("http://requestb.in/1clqg6j1")
    parameters = {
      answer: "answer",
      token: 'f833352191dabd2141f05ac14eb82073',
      task_id: "task_id"
    }

    Net::HTTP.post_form(uri, parameters)
    return [""]
  end
end