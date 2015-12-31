require 'net/http'
require 'cgi'

require "./finder.rb"

class Contest
  def self.prepare
    @finder = Finder.new    
  end

  def self.call(env)
    @params = CGI::parse(env["QUERY_STRING"])

    puts @params["token"]

    @level = @params["level"].first
    @question = @params["question"].first

    puts "Request get! Begin find..."

    if @level == '1'
      sent_answer(@finder.findTitle(@question))
    end

    if @level == '2'
      sent_answer(@finder.findWord(@question))
    end

    if @level == '3' || @level == '4'
      answer = []
      
      @question.split("\\n").each do |q|
        answer << @finder.findWord(q)
      end

      sent_answer(answer.join(","))
    end

    if @level == '5'
      sent_answer(@finder.find_change_word(@question))
    end

    if @level == '6' || @level == '7'
      sent_answer(@finder.findLine(@question))
    end

    if @level == '8'
      sent_answer(@finder.findLineWithError(@question))
    end

    return [200, {"Content-Type" => "application/json"}, ["мглою"]]
  end

  def self.sent_answer(answer)
    uri = URI("http://pushkin.rubyroid.by/quiz")
    parameters = {
      answer: answer,
      token: 'token',
      task_id: @params["id"].first
    }

    Net::HTTP.post_form(uri, parameters)

    puts "Request sent! Answer: #{answer}"
    puts "ID: #{@params["id"].first}"
  end
end