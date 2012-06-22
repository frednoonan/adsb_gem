require 'rubygems'

Gem::Specification.new do |gem|
	gem.name         = 'adsb'
	gem.version      = '0.2'
	gem.author       = 'Fred Noonan'
	gem.email        = 'frednoonan@hushmail.com'
	gem.platform     = Gem::Platform::RUBY
	gem.summary      = 'A library to deal with ADS-B (secondary flight radar) data'
	gem.description  = gem.summary # TODO
	# FIXME gem.test_file
	gem.require_path = 'lib'
	gem.extra_rdoc_files = [ 'README' ]

	gem.files = Dir['lib/adsb.rb'] + Dir['lib/adsb/*'] + Dir['test/*']

	if gem.respond_to? :specification_version then
		gem.specification_version = 2
	end
end
