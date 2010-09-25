require 'rubygems'
require 'pcap'

# just testing the parsing of src/dst in a packet and verifying logic

capfile='http.cap'
capture = Pcap::Capture.open_offline(capfile)

capture.each_packet do |packet|
  src = packet.src.to_s
  dst = packet.dst.to_s
  srcrev = src.split('.').reverse.join('.')
  dstrev = dst.split('.').reverse.join('.')

  print "#{src} - #{dst} | #{srcrev} - #{dstrev}\n"
end
# vim: set ts=2 et sw=2 sts=2 sta filetype=ruby :
