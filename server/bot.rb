require 'em-websocket'
require 'json'

cons = []
closed = []

def response(msg)
  data = {type: 'message', text: msg['text'], success: true}

  if msg['text'] === '@bot ping'
    data[:type] = 'bot'
    data[:text] = 'pong'
  end

  puts data.to_json
  data.to_json
end

EM::WebSocket.start(host: ENV['IP'], port: ENV['PORT']) do |con|
  con.onopen do
    cons << con
  end

  con.onmessage do |jsonmsg|
    msg = JSON.parse(jsonmsg)
    cons.each {|con| con.send(response(msg)) unless closed.include?(con) }
  end

  con.onclose do
    puts 'onclose'
    closed << con
  end
end
