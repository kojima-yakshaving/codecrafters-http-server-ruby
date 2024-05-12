require "socket"

# You can use print statements as follows for debugging, they'll be visible when running tests.

port = ENV.fetch('PORT', 4221).to_i

server = TCPServer.new(port)

client_socket = server.accept

rbuf = "" 
until client_socket.eof?
  rbuf += client_socket.read
end
lines = rbuf.lines
status_line, *header_lines = lines

_, path, http_version, *__ = status_line.chomp.split

if path == '/'
  client_socket.puts("HTTP/1.1 200 OK\r\n\r\n")
elsif path == '/user-agent'
  user_agent_line = ""
  header_lines.each do |header_line|
    if header_line.start_with? 'User-Agent'
      user_agent_line = header_line.chomp.chomp
      break
    end
  end

  _key, value = user_agent_line.split(':')
  body = value.strip

  puts body

  # status line

  wbuf = ""
  wbuf += "HTTP/1.1 200 OK\r\n"
  
  # header lines
  wbuf += "Content-Type: text/plain\r\n"
  wbuf += "Content-Length: #{body.size}\r\n\r\n"

  # body
  wbuf += body

  client_socket.write(wbuf)
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
else
  client_socket.puts("HTTP/1.1 404 Not Found\r\n\r\n")
end
client_socket.close
