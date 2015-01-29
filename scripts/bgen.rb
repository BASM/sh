#!/usr/bin/env ruby
require 'boards'
require 'erb'

bname = ARGV[0]
brd=Boards.new(bname)
brd.generate()

=begin
erb = ERB.new(File.open("templates/pin.h.erb").read())
@ddr="DDRD"
@port="PORTD"
@bite=4

puts erb.run()
=end
