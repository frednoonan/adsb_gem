require 'test/unit'
require 'lib/adsb/frame'

class TestRawFrames < Test::Unit::TestCase
	def test_identification_frame
		frame = ADSB::Frame.from_hex('8D3C67492010C231E508200D193B')
		assert_equal(ADSB::Frame::IdentificationReport, frame.class)
		assert_equal('DLH19P  ', frame.identification)
	end
end
