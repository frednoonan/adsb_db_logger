#!/usr/bin/env ruby

require 'rubygems'
require 'socket'
require 'sqlite3'

receiver_id = ARGV[0] || "0"
DECODED_VERSION = 0

# create table raw_frames (frame varchar(28), received_time varchar(30), receiver_id int, decoded_version int);
db = SQLite3::Database.new('airtraffic.db')

s = TCPSocket.new 'localhost', 9988

while packet = s.recvfrom(64) do
	packet = packet[0]
	puts packet.inspect
	now = Time.now.utc
	now_str = now.strftime("%Y-%m-%d %H:%M:%S")
	now_str += ("%.3f" % [ (now.to_f - now.to_i) ])[1..-1]
	frame = packet.split(' ')[1..3].join('').upcase
	db.execute("INSERT INTO raw_frames (frame, received_time, receiver_id, decoded_version) VALUES (?, ?, ?, ?)", frame, now_str, receiver_id, DECODED_VERSION)
end
