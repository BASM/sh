#!/usr/bin/env ruby
# encoding: utf-8
#
#XXX FIXME set dynamic this
TOPDIR="/home/asm/Projects/sh"
require 'boards'
require 'erb'


bname = ARGV[0]
brd=Boards.new(bname)

if ARGV[1] == "-h"
  puts "Usage: bgen.rb <board.yml> [-h] [iccname]"
  puts "  <no opts> -- list icces from file"
  puts "  -h        -- current help"
  puts "  iccname   -- generate source for icname"
  exit
end

if ARGV[1] == nil
  puts brd.iclist()
else
  brd.generate(ARGV[1])
end
