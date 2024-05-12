require "socket"

# You can use print statements as follows for debugging, they'll be visible when running tests.
print("Logs from your program will appear here!")

# Uncomment this to pass the first stage
#
port = ENV.fetch('PORT', 4221).to_i

server = TCPServer.new(port)

client_socket = server.accept

buf = client_socket.read
lines = buf.lines
status_line, header_lines = *lines
_, path, http_version, *__ = status_line.split

if path == '/'
  client_socket.puts("#{http_version} 200 OK\r\n\r\n")
elsif path == '/user_agent'
  user_agent_line = ""
  header_lines.each do |header_line|
    if header_line.start_with? 'User-Agent'
      user_agent_line = header_line.chomp
      break
    end
  end 

  _key, value = user_agent_line.split(':')
  body = v.strip

  # status line
  client_socket.puts("#{http_version} 200 OK\r\n")
  
  # header lines
  client_socket.puts("Content-Type: text/plain\r\n")
  client_socket.puts("Content-Length: #{body.size}\r\n\r\n")

  # body
  client_socket.puts(body)
  client_socket.puts("\r\n\r\n")
elsif path.start_with?("/echo")
  # status line
  client_socket.puts("#{http_version} 200 OK\r\n")

  # header lines
  _, _prefix, *tokens = path.split('/')
  body = tokens.join('/')
  client_socket.puts("Content-Type: text/plain\r\n")
  client_socket.puts("Content-Length: #{body.size}\r\n\r\n")

  # body
  client_socket.puts(body)
  client_socket.puts("\r\n\r\n")
else
  client_socket.puts("#{http_version} 404 Not Found\r\n\r\n")
end
client_socket.close
