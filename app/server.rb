require "socket"

# You can use print statements as follows for debugging, they'll be visible when running tests.
print("Logs from your program will appear here!")

# Uncomment this to pass the first stage
#
port = ENV.fetch('PORT', 4221).to_i

server = TCPServer.new(port)

loop do
  client_socket = server.accept
  client_socket.puts("HTTP/1.1 200 OK\r\n\r\n")&.chomp         # it should be 'write' method, not usual 'puts'
  client_socket.puts("Content-Type: text/html\r\n\r\n")&.chomp # same - 'write' method
  client_socket.close
end
