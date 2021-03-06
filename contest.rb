require 'json'
require 'socket'

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
      sent_answer(@finder.findLineWithError(@question))
    end

    return [200, {"Content-Type" => "application/json"}, [""]]
  end

  def self.sent_answer(answer)
    @connection = TCPSocket.new "pushkin.rubyroid.by", 80

    send_data = {'answer' => answer, 'token' => '9b22af0964399fba3c840ae210e3009a', 'task_id' => @params['id']}.to_json

    @connection.puts "POST /quiz HTTP/1.1\r\nHost: pushkin.rubyroid.by\r\nAccept: application/json\r\nConnection: close\r\nContent-Type: application/json\r\nContent-Length: #{send_data.bytesize + 2}\r\n\r\n\r\n"

    @connection.puts send_data
    
    @connection.close
  end
end
