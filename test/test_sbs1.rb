require 'test/unit'
require 'lib/adsb/sbs1'

class TestSBS1 < Test::Unit::TestCase
	def test_identifaction_report
		frame = ADSB::SBS1.parse('MSG,1,0,4,3C664E,104,2012/05/25,20:22:16.601,2012/05/25,20:22:16.601,DLH1KA  ,,,,,,,,,,,')
		assert_equal(ADSB::Frame::IdentificationReport, frame.class)
		assert_equal('3C664E', frame.icao_id)
		assert_equal(Time.parse('2012/05/25 20:22:16.601'), frame.time)
		assert_equal('DLH1KA', frame.identification.strip)
	end
end
