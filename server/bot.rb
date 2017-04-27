require 'em-websocket'

cons = []

puts 'start server'
EM::WebSocket.start(host: ENV['IP'], port: ENV['PORT']) do |con|
  con.onopen do
    puts 'onopen'
    cons << con
  end

  con.onmessage do |msg|
    puts 'onmessage', msg
    cons.each {|con| con.send(msg) }
  end
end
