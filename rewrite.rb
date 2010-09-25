require 'rubygems'
require 'pcap'

# I pretty much cheated by seeing the example time rewrite on github.
# The only other thing I had to do was check in the source for how the src/dst are cast and do that
# I only tested with a sample http dump from online. I'm not sure how it would handle non-http dumps
# The resulting file can be opened in wireshark for viewing
#
# Honestly I spent out 30 minutes or so on the whole script. I spent more time trying to find a working pcap library
capfile = 'http.cap'
capture_in = Pcap::Capture.open_offline(capfile)
capture_out = Pcap::Capture.open_dead(capture_in.datalink, capture_in.snaplen)
dump_out = Pcap::Dumper.open(capture_out, 'http-rewrite.cap')

capture_in.loop(-1) do |packet|
  packet.src = Pcap::IPAddress.new(packet.src.to_s.split('.').reverse.join('.'))
  packet.dst = Pcap::IPAddress.new(packet.dst.to_s.split('.').reverse.join('.'))
  dump_out.dump(packet)
end
