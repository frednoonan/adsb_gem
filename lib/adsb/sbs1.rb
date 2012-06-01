require 'time'
require 'adsb/frame'
require 'pp'

module ADSB
	# The ADSB::SBS1 class can be used to parse SBS-1 compatible (TCP port
	# 30003) CSV lines and create ADSB::Frame objects from them.
	#
	# It is still work in progress and currently only supports message
	# types 1 (identification report), 3 (position report),  4 (track
	# report) and 8 (all call reply)
	class SBS1
		# parses one line of SBS-1 compatible data and returns a corresponding
		# ADSB::Frame object
		def self.parse(line)
			data = line.chomp.split(',', -1)
			raise ArgumentError, "incorrect data format (#{data.size} entries)" if data.size != 22
			msg_type = data[1].to_i
			icao_id  = data[4]
			time     = Time.parse(data[6] + " " + data[7])
			frame    = ADSB::Frame.from_sbs1(:sbs1_msg_type => msg_type,
			                                 :icao_id       => icao_id,
			                                 :time          => time)
			if frame.is_a? ADSB::Frame::IdentificationReport then
				frame.identification = data[10]
			elsif frame.is_a? ADSB::Frame::PositionReport then
				frame.altitude = data[11].to_i
				frame.lat      = data[14].to_f
				frame.lon      = data[15].to_f
			elsif frame.is_a? ADSB::Frame::TrackReport then
				frame.velocity = data[12].to_f
				frame.heading  = data[13].to_f
				frame.vs       = data[16].to_i
			end
			# ADSB::Frame::AllCallReply has no additional fields so nothing
			# to add there
			frame
		end
	end
end
