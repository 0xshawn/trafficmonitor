module Traffic
  module Monitor
    module Iftop
      require 'open3'

      def self.connections(interface)
        interface = 'en0'
        command = 'sudo iftop -BPp -Nn -t -L 100  -s 2 ' + '-i ' + interface

        stdin, stdout, stderr = Open3.popen3(command)
        result = stdout.readlines
        lines = result[3..-10]

        conns = {"connection" => []}

        lines.each_slice(2) do |i|
          download = i[0].split(' ')
          upload = i[1].split(' ')
          remote_ip, download_speed = download[1], download[3]
          local_ip, upload_speed = upload[0], upload[2]

          conns['connection'] << {"local_ip" => local_ip,
                                  "download_speed" => download_speed,
                                  "remote_ip" => remote_ip,
                                  "upload_speed" => upload_speed}
        end

        total_send_rate_2s = result[-8].split(' ')[3]
        total_receive_rate_2s = result[-7].split(' ')[3]

        conns['total_send_rate'] = total_send_rate_2s
        conns['total_receive_rate'] = total_receive_rate_2s

        return conns
      end
    end
  end
end
