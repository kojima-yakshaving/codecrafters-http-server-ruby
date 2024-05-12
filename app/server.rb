require "socket"

# You can use print statements as follows for debugging, they'll be visible when running tests.
print("Logs from your program will appear here!")

# Uncomment this to pass the first stage
#
port = ENV.fetch('PORT', 4221).to_i

server = TCPServer.new(port)

client_socket = server.accept

status_line = client_socket.readline.chomp
_, path, http_version, *__ = status_line.split

if path != '/'
  client_socket.puts("HTTP/1.1 404 Not Found\r\n\r\n")
else 
  client_socket.puts("HTTP/1.1 200 OK\r\n\r\n")
end
client_socket.close
