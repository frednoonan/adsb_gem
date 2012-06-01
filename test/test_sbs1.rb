require 'test/unit'
require 'lib/adsb/sbs1'

class TestSBS1 < Test::Unit::TestCase
	def test_identifaction_report
		frame = ADSB::SBS1.parse('MSG,1,0,4,3C664E,104,2012/05/25,20:22:16.601,2012/05/25,20:22:16.601,DLH1KA  ,,,,,,,,,,,')
		assert_equal(ADSB::Frame::IdentificationReport, frame.class)
		assert_equal('3C664E', frame.icao_id.to_s)
		assert_equal(Time.parse('2012/05/25 20:22:16.601'), frame.time)
		assert_equal('DLH1KA', frame.identification.strip)
	end

	def test_track_report
		frame = ADSB::SBS1.parse('MSG,4,0,4,3C664E,104,2012/05/25,20:22:27.752,2012/05/25,20:22:27.752,,,348.1,286.4,,,-128,,,,,')
		assert_equal(ADSB::Frame::TrackReport, frame.class)
		assert_equal('3C664E', frame.icao_id.to_s)
		assert_equal(Time.parse('2012/05/25 20:22:27.752'), frame.time)
		assert_equal(348.1, frame.velocity)
		assert_equal(286.4, frame.heading)
		assert_equal(-128, frame.vs)
	end

	def test_position_report
		frame = ADSB::SBS1.parse('MSG,3,0,3,49D0A3,103,2012/05/25,20:22:40.604,2012/05/25,20:22:40.604,,37000,,,49.91451,8.68520,,,,0,0,0')
		assert_equal(ADSB::Frame::PositionReport, frame.class)
		assert_equal('49D0A3', frame.icao_id.to_s)
		assert_equal(37000, frame.altitude)
		assert_equal(49.91451, frame.lat)
		assert_equal(8.68520, frame.lon)
	end

	def test_all_call_reply
		frame = ADSB::SBS1.parse('MSG,8,0,4,3C664E,104,2012/05/25,20:24:20.549,2012/05/25,20:24:20.549,,,,,,,,,,,')
		assert_equal(ADSB::Frame::AllCallReply, frame.class)
		assert_equal('3C664E', frame.icao_id.to_s)
	end
end
