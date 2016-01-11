require 'curb'
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
      sent_answer(@finder.findLineWithError(@question))
    end

    return [200, {"Content-Type" => "application/json"}, [""]]
  end

  def self.sent_answer(answer)
    # http = Curl::Easy.http_post("http://pushkin.rubyroid.by/quiz",
    #   "answer=#{answer}&token=9b22af0964399fba3c840ae210e3009a&task_id=#{@params['id']}")
    # puts "Response: #{http.body_str}"

    # send_data = "answer=#{answer}&token=9b22af0964399fba3c840ae210e3009a&task_id=#{@params['id']}\r\n"

    # connection = TCPSocket.open "pushkin.rubyroid.by", 80

    # connection.puts "POST /quiz HTTP/1.1\r\n"
    # connection.puts "Host: pushkin.rubyroid.by\r\n"
    # connection.puts "Connection: close\r\n"
    # connection.puts "Content-Type: application/x-www-form-urlencoded\r\n"
    # connection.puts "Content-Length: #{send_data.bytesize}\r\n\r\n"

    # connection.puts "\r\n"
    # connection.puts send_data
    # puts connection.read
    # connection.close

    send_data = {'answer' => answer, 'token' => '9b22af0964399fba3c840ae210e3009a', 'task_id' => @params['id']}.to_json

    connection = TCPSocket.open "pushkin.rubyroid.by", 80

    connection.puts "POST /quiz HTTP/1.1\r\n"
    connection.puts "Host: pushkin.rubyroid.by\r\n"
    connection.puts "Accept: application/json\r\n"
    connection.puts "Connection: close\r\n"
    connection.puts "Content-Type: application/json\r\n"
    connection.puts "Content-Length: #{send_data.bytesize + 2}\r\n\r\n"

    connection.puts "\r\n"
    connection.puts send_data
    
    puts connection.read

    connection.close

    puts "Request sent! Answer: #{answer}"
    puts "ID: #{@params["id"]}"
  end
end
