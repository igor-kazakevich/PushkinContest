#require 'net/http'
require 'unirest'
require 'json'

require "./finder.rb"

class Contest
  def self.prepare
    @finder = Finder.new    
  end

  def self.call(env)
    @input = env["rack.input"].read

    puts @input

    @params = JSON.parse(@input)

    @level = @params["level"]
    @question = @params["question"]

    puts "Request get! Begin find..."

    if @level == 1
      sent_answer(@finder.findTitle(@question))
    end

    if @level == 2
      sent_answer(@finder.findWord(@question))
    end

    if @level == 3 || @level == 4
      answer = []
      
      @question.split("\n").each do |q|
        answer << @finder.findWord(q)
      end

      sent_answer(answer.join(","))
    end

    if @level == 5
      sent_answer(@finder.find_change_word(@question))
    end

    if @level == 6 || @level == 7
      sent_answer(@finder.findLine(@question))
    end

    if @level == 8
      #sent_answer(@finder.findLineWithError(@question))
      sent_answer('test request')
    end

    return [200, {"Content-Type" => "application/json"}, [""]]
  end

  def self.sent_answer(answer)
    # uri = URI("http://pushkin.rubyroid.by/quiz")
    # parameters = {
    #   answer: answer,
    #   token: '9b22af0964399fba3c840ae210e3009a',
    #   task_id: @params["id"]
    # }

    # Net::HTTP.post_form(uri, parameters)

    response = Unirest.post "http://pushkin.rubyroid.by/quiz", 
                        headers:{ "Accept" => "application/json" }, 
                        parameters:{ answer: answer,
      token: '9b22af0964399fba3c840ae210e3009a',
      task_id: @params["id"]}


    puts "Request sent! Answer: #{answer}"
    puts "ID: #{@params["id"]}"
  end
end
