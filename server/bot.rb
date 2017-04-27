require 'em-websocket'
require 'json'

cons = []

def response
  data = {type: 'message', text: msg['text'], success: true}
  data.to_json
end

EM::WebSocket.start(host: ENV['IP'], port: ENV['PORT']) do |con|
  con.onopen do
    cons << con
  end

  con.onmessage do |msg|
    msg = JSON.parse(msg)
    cons.each {|con| con.send(response(msg)) }
  end
end
