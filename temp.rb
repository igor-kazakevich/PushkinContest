require 'socket'

server = TCPServer.new ENV['PORT'] # Server bound to port 2000

loop do
  client = server.accept    # Wait for a client to connect
  client.puts "Hello !"
  client.close
end