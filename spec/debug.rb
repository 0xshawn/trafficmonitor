require '../lib/trafficmonitor/iftop.rb'

class Test
  include Trafficmonitor::Iftop

  def show_connections
    connections 'en0', 3
  end
end

me = Test.new

puts me.connections 'en0', 3
