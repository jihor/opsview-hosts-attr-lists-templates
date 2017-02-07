#!/usr/bin/env ruby
require 'opsviewconfig'

config = Opsviewconfig.new({'opsviewhost' => 'some-nice-host.org', 'opsviewuser' => 'username', 'opsviewpassword' => 'secret'})
(1..3).each { |i|
  puts "Importing modified config for prodhost-0#{i}..."
  config.import('host', "./modified/prodhost-0#{i}.json")
}
puts 'Reloading OpsView configuration...'
config.reload()
puts 'Done'