module Trafficmonitor
  module Iftop
    require 'open3'

    def connections(interface, s = 2)
      command = 'sudo iftop -BPp -Nn -t -L 100  -s ' + s.to_s + ' -i ' + interface

      stdin, stdout, stderr = Open3.popen3(command)
      result = stdout.readlines
      lines = result[3..-10]

      conns = {"connection" => []}

      lines.each_slice(2) do |i|
        download = i[0].split(' ')
        upload = i[1].split(' ')
        remote_ip, download_speed = download[1], remove_speed_unit(download[3])
        local_ip, upload_speed = upload[0], remove_speed_unit(upload[2])

        conns['connection'] << {"local_ip" => local_ip,
                                "download_speed" => download_speed,
                                "remote_ip" => remote_ip,
                                "upload_speed" => upload_speed}
      end

      total_send_rate_2s = result[-8].split(' ')[3]
      total_receive_rate_2s = result[-7].split(' ')[3]

      conns['total_send_rate'] = remove_speed_unit(total_send_rate_2s)
      conns['total_receive_rate'] = remove_speed_unit(total_receive_rate_2s)

      return conns
    end

    private
    def remove_speed_unit(string = "")
      return "" if string.empty?
      speed = string.delete 'a-zA-Z'
      unit = string.delete speed
      case unit
      when "B"
        multiple = 1
      when "KB"
        multiple = 1024
      when "MB"
        multiple = 1048576
      when "GB"
        multiple = 1073741824
      end
      return speed.to_f * multiple
    end
  end
end
