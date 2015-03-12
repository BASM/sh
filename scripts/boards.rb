require 'yaml'

$piosdb={}

## FIXME dynamic create
require "#{TOPDIR}/libs/rs485/generate"
require "#{TOPDIR}/libs/uart/generate"
require "#{TOPDIR}/libs/pio/generate" 

#FIXME
TMLDIR="#{$:[0]}/templates"

def erb_read(fname)
  fd = File.open(fname);
  erb = ERB.new(fd.read);
  fd.close()
  return erb
end

$FGEN=[]

##################


# PIO class, one PIO class, PIN,POUT,UART....
#  @name -- BUTTONS for example
#  @type -- TYPE of class
#  PINS -- one port IO
class PIO
  def name
    @name
  end
  def pins
    @pins
  end
  def bd
    @obj
  end
  def initialize(pio,name)
    @pins=pio["PINS"]
    @type=pio["TYPE"]
    @name=name
    @obj=pio
  end
  def generate(cc,h,mode)
    puts ">> Generate #{@name} type #{@type}:"

    obj=nil
    begin
      obj = $piosdb[@type]
    rescue
      puts "Unknown type '#{@type}'"
    end
    return if obj == nil
    cname = obj.new(self,cc,h,mode).cname

    [cname,@name]
  end
end

## Class IC:
# name -- name of ic
# parms:
#  TYPE -- AT..., LPC...
#  FREQ
#  PIDS -- list of IO
class IC
  def initialize(name, ic)
    @name=name
    @type=ic["TYPE"]
    @pios=[]
    #puts ic.inspect
    @FREQ=ic["FREQ"].split.join + "L"
    icpio=ic["PIOS"]
    icpio.each{ |name,pio| 
      cp = PIO.new(pio,name)
      @pios+=[cp]
    }
  end
  def writeheaders(cc,h,hfname,mode)
    hostpref="_avr"

    if mode == :host
      hostpref="_host" if mode == :host
    else
      cc.write "#include <avr/io.h>\n"
    end
    cc.write <<-EOF
#include "#{hfname}"
EOF
    h.write <<-EOF
#ifndef __AUTOGEN_HEADER_H__
#define __AUTOGEN_HEADER_H__
#include <inttypes.h>
#include "shclass.h"
#include "shtype.h"
#include <pout.h> //XXX FIXME autogen from pio
EOF
  end

  def name()
    @name
  end

  def generate(mode)
    if mode == :host
      ccfname="gensrc/#{@name}clases_host.cc"
      hfname ="gensrc/#{@name}clases_host.h"
      hfname_inc ="#{@name}clases_host.h"
    else
      ccfname="gensrc/#{@name}clases_avr.cc"
      hfname ="gensrc/#{@name}clases_avr.h"
      hfname_inc ="#{@name}clases_avr.h"
    end

    $FGEN += [ccfname]
    genfile_cc=File.open(ccfname,"w")
    genfile_h =File.open(hfname ,"w")

    genfile_h.write <<-EOF
#define F_CPU #{@FREQ}
EOF

    writeheaders(genfile_cc, genfile_h, hfname_inc, mode)
    @PIOS=[]
    
    puts "> IC name #{@name}, type #{@type}:" 
    @pios.each{|i|
      res=i.generate(genfile_cc,genfile_h,mode)
      @PIOS += [res] if res != nil
    }

    fd = genfile_h
    fd.write <<-EOF
class MCU_#{@name} : public MCU {
    public:

    STDIO  stdio;
EOF
    
    @PIOS.each{ |cname,name| fd.write("\t #{cname} #{name};\n");}
    fd.write("};\n")
    fd.write("#endif \n")

    return [@name,@type]
  end
end

class Boards
  def lsdir(filename)
    list=`ls #{filename}`.split(" ")
    list.map{|i| "#{filename}/#{i}" }
  end

  def findopenymlfile(filename)
    searchlist=[]
    sdir=[]
    sdir+=["."]
    sdir+=lsdir("#{TOPDIR}/boards/")
    sdir.map{ |dir|
      fname="#{dir}/boards/#{filename}"
      searchlist+=[fname]
      begin
        fd = File.open(fname)
        return fd
      rescue 
      end
    }
    puts "Try search files on:"
    puts searchlist.map{|i| "\t* #{i}"}
    raise "Board file #{filename} don't find"
    exit 0
  end

  def initialize(conf)
    f = findopenymlfile(conf[:board])
    @yml = YAML.load(f)
    f.close()

    @name = @yml["NAME"]
    @ic={}
    @yml["IC"].each{ |name,obj| 
      #puts "==========IC: #{name} -- OBJ #{obj}====="
      @ic[name]=IC.new(name,obj)
    }
  end

  def generate(icname)
    @ic[icname].generate(nil)
    STDERR.puts $FGEN
  end

  def generate_host(icname)
    @ic[icname].generate(:host)
  end

  def iclist()
    @ic.map{ |name,obj| name }.join(" ")
  end
end
