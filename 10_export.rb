#!/usr/bin/env ruby
gem 'opsviewconfig', '>= 0.0.9'
require 'opsviewconfig'

config = Opsviewconfig.new({'opsviewhost' => 'some-nice-host.org', 'opsviewuser' => 'username', 'opsviewpassword' => 'secret'})
puts 'Exporting all hosts configurations...'
config.export('host', './export')
puts 'Done'