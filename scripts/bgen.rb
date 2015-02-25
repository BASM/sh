#!/usr/bin/env ruby
# encoding: utf-8
#
#XXX FIXME set dynamic this
TOPDIR="/home/asm/Projects/sh"
require 'boards'
require 'erb'

argnum=1

bname = ARGV[0]
brd=Boards.new(bname)

if ARGV[1] == "-h"
  puts "Usage: bgen.rb <board.yml> [-h] [--host] [iccname] "
  puts "  <no opts> -- list icces from file"
  puts "  -h        -- current help"
  puts "  [iccname] -- generate source for icname"
  pust "  --host    -- build test library for host"
  exit
end

if ARGV[argnum] == nil
  puts brd.iclist()
else
  if ARGV[argnum] == "--host"
    argnum+=1
    type="host"
  end
  if type == "host"
    brd.generate_host(ARGV[argnum])
  else
    brd.generate(ARGV[argnum])
  end
end
