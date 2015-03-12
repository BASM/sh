#!/usr/bin/env ruby
# encoding: utf-8
#
TOPDIR="#{File.dirname(__FILE__)}/.."
require 'boards'
require 'erb'
require 'getoptlong'

conf={
  :host    => false,
  :cclist  => false,
  :mklist  => false,
  :hlist   => false,
  :icname  => nil,
  :board   => nil,
}

opts = GetoptLong.new(
  [ '--board'     , '-b', GetoptLong::REQUIRED_ARGUMENT],
  [ '--cclist'    , '-c', GetoptLong::NO_ARGUMENT],
  [ '--hlist'     , '-j', GetoptLong::NO_ARGUMENT],
  [ '--iclist'    , '-l', GetoptLong::NO_ARGUMENT],
  [ '--mklist'    , '-m', GetoptLong::NO_ARGUMENT],
  [ '--icname'    , '-i', GetoptLong::REQUIRED_ARGUMENT],
  [ '--help'      , '-h', GetoptLong::NO_ARGUMENT],
  [ '--host'      , '-t', GetoptLong::NO_ARGUMENT],
)


opts.each{ |opt, arg|
  case opt
  when '--help'
    puts "SmartHouse class generator"
    puts "Usage: <-b BOARDNAME> [-i]"
    puts "     --board,-b   -- board name"
    puts "     --icname,-i  -- set IC name from board"
    puts "     --iclist,-l  -- list for ICes in the board file and exit"
    puts "     --cclist,-c  -- list *.cc sources files"
    puts "     --hlist,-j   -- list *.h header files"
    puts "     --mklist,-m  -- list of mk (Makefile) files"
    puts "     --host,-t    -- host mode (generate host building, for debug)"
  when '--board'
    conf[:board] = arg
  when '--iclist'
    conf[:iclist] = true
  when '--icname'
    conf[:icname] = arg
  when '--host'
    conf[:host] = true
  else
    puts "UNPARCED ARGUMENT: #{opt} -- #{arg}"
    exit 1

  end
}

if conf[:board] == nil
  puts "Please set board name (-b)"
  exit 1
end

brd=Boards.new(conf)
if conf[:iclist] != nil
  puts "ISLIST: #{brd.iclist()}"
  exit 0
end

if conf[:icname] == nil
  puts "Please set icname from board (-i), you can get IC list with '-l' option"
  exit 1
end



#FIXME REMOVE IT!!
# only for migrate to the new generator
# Only generate() must be called.
if conf[:host] != nil
  brd.generate(conf[:icname])
else
  brd.generate_host(conf[:icname])
end

