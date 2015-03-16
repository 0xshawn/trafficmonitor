require '../lib/trafficmonitor/iftop.rb'

class Test
  include Trafficmonitor::Iftop

  def show_connections
    connections 'en0', 3
  end
end

me = Test.new

result = me.connections 'en0', 3
result['connection'].each do |i|
  puts i['local_ip'] + "\t\t\t" + i['download_speed'].to_s
end
