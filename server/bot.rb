require 'em-websocket'
require 'json'

cons = []

def message(msg)
  {type: 'message', text: msg, success: true}.to_json
end

def bot_message(msg)
  {type: 'bot', text: msg, success: true}.to_json
end

EM::WebSocket.start(host: ENV['IP'], port: ENV['PORT']) do |con|
  con.onopen do
    cons << con
    puts "onopen: cons = #{cons.size}"
  end

  con.onmessage do |jsonmsg|
    msg = JSON.parse(jsonmsg)

    if msg['text'] === '@bot ping'
      con.send(bot_message('pong'))
    else
      cons.each {|con| con.send(message(msg['text'])) }
    end
  end

  con.onclose do
    cons.delete(con)
    puts "onclose: cons = #{cons.size}"
  end
end
