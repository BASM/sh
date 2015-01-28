require './boards'
require 'erb'


brd=Boards.new("board.yml")
brd.generate()

=begin
erb = ERB.new(File.open("templates/pin.h.erb").read())
@ddr="DDRD"
@port="PORTD"
@bite=4

puts erb.run()
=end
