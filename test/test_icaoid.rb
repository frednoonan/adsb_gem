require 'test/unit'
require 'lib/adsb/icao_id'

class TestIcaoId < Test::Unit::TestCase
	def test_icao_id
		icao_id = ADSB::IcaoId.new('3C664E')
		assert_equal('DE', icao_id.country_code)
		assert_equal('Germany', icao_id.country)
	end
end
