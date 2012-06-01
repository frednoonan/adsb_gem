require 'adsb/icao_id'

module ADSB
	class Frame
		attr_reader :sbs1_msg_type, :icao_id, :time

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

		# Fill attributes sbs1_msg_type, icao_id and time from params
		def initialize(args)
			@sbs1_msg_type = args[:sbs1_msg_type]
			@icao_id       = IcaoId.new(args[:icao_id])
			@time          = args[:time]
		end

		class IdentificationReport < Frame
			attr_accessor :identification
			def initialize(args)
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
