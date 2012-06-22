require 'adsb/icao_id'

module ADSB
	class Frame
		attr_reader :sbs1_msg_type, :icao_id, :time, :capability

		# Create a new frame object from :sbs1_msg_type, :icao_id and :time.
		# Corresponding objects based on the message type are then created
		# for which the missing information can be added using attribute setters.
		def self.from_sbs1(args)
			if args[:sbs1_msg_type] then
				frame = case args[:sbs1_msg_type]
				when 1
					ADSB::Frame::IdentificationReport.new(args)
				when 3
					ADSB::Frame::PositionReport.new(args)
				when 4
					ADSB::Frame::TrackReport.new(args)
				when 8
					ADSB::Frame::AllCallReply.new(args)
				end
			else
				ArgumentError ":sbs1_msg_type parameter required"
			end
			frame
		end

		def self.from_hex(hex, lat = nil, lon = nil)
			frame = nil
			time = Time.now
			if hex.size != 28 then
				ArgumentError "weird hex frame size, 28 characters expected"
			end
			first_byte = hex[0,2].to_i(16)
			downlink_format          = first_byte >> 3 # upper 5 bits
			capability               = first_byte &  7 # lower 3 bits
			icao_id                  = hex[2,6]
			message                  = hex[8,14]
			parity                   = hex[22,6]
			puts "downlink format: #{downlink_format}"
			if downlink_format == 11 then
				# all call reply
				frame = ADSB::Frame::AllCallReply.new(:icao_id => icao_id, :time => time, :capability => capability)
			elsif downlink_format == 17 then
				# subtype is upper 5 bits of first message byte
				subtype = ("%08b" % [ message[0,2].to_i(16) ])[0,5].to_i(2)
				if subtype == 4 then
					frame = ADSB::Frame::IdentificationReport.new(:icao_id => icao_id, :time => time, :capability => capability, :message => message)
					# identification report
				end
			end
			frame
		end

		# Fill attributes sbs1_msg_type, icao_id and time from params
		def initialize(args)
			@sbs1_msg_type = args[:sbs1_msg_type]
			@icao_id       = IcaoId.new(args[:icao_id])
			@time          = args[:time]
			@capability    = args[:capability]
		end

		class IdentificationReport < Frame
			attr_accessor :identification
			def decode_identification(message)
				bitstring = "%048b" % [ message[2,12].to_i(16) ]
				result    = ""
				# split into 6 bit parts
				(0..7).each do |i|
					result += decode_char(bitstring[i*6, 6].to_i(2))
				end
				result
			end

			def decode_char(ch)
				result = ""
				if ch <= 26 then # A-Z, cf. table on page 75/3-62
					result = (64+ch).chr
				else # SPC and 0-9
					result = ch.chr
				end
				result
			end

			def initialize(args)
				if args[:message] then
					@identification = decode_identification(args[:message])
				end
				super(args)
			end
		end

		class PositionReport < Frame
			attr_accessor :altitude, :lat, :lon
			def initialize(args)
				super(args)
			end
		end

		class TrackReport < Frame
			attr_accessor :velocity, :heading, :vs
			def initialize(args)
				super(args)
			end
		end

		class AllCallReply < Frame
			def initialize(args)
				super(args)
			end
		end
	end
end
