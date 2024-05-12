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

if path == '/'
  client_socket.puts("HTTP/1.1 200 OK\r\n\r\n")
elsif path.start_with?("/echo")
  # status line
  client_socket.puts("HTTP/1.1 200 OK\r\n")

  # header lines
  _, _prefix, *tokens = path.split('/')
  body = tokens.join('/')
  client_socket.puts("Content-Type: text/plain\r\n")
  client_socket.puts("Content-Length: #{body.size}\r\n\r\n")

  # body
  client_socket.puts(body)
  client_socket.puts("\r\n\r\n")
else
  client_socket.puts("HTTP/1.1 404 Not Found\r\n\r\n")
end
client_socket.close
