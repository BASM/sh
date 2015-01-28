require 'yaml'

TMLDIR="templates"

class PINOUT_Gen
  def erbrun(fname,name,port,outf)
        fd=File.open(fname)
        @erb = ERB.new(fd.read)
        fd.close()
        num,bit=port.scan(/P(.)(.)/)[0]
        @ddr="DDR#{num}"
        @port="PORT#{num}"
        @pin="PIN#{num}"
        @bit=bit
        @name=name
        outf.write(@erb.result(binding))
  end
  def initialize(obj,cc,h)
    @obj=obj
    @cc=cc
    @h=h
    objname=obj.name

    @obj.pins.each{ |name,port|
      cclist.each{ |fname|  erbrun("#{TMLDIR}/#{fname}.erb",name,port,cc) }
      hlist.each { |fname|  erbrun("#{TMLDIR}/#{fname}.erb",name,port,h)  }
    }
    classgen(obj,h)

  end

  def name()
    @name
  end
  def classgen(obj,h)
    h.write <<-EOF
class #{cname}_#{obj.name} {
  public:
EOF
    @obj.pins.each{ |name,port| 
      h.write "\t#{cname()}_#{name} #{name};\n"
    }
    h.write("};\n")
  end
end


class PIN_Gen < PINOUT_Gen
  def cclist
    []
  end
  def hlist
   ["pin.h"]
  end
  def cname
    return "PIN"
  end
end

class POUT_Gen < PINOUT_Gen
  def cclist
    return ["pout.cc"]
  end
  def hlist
    return ["pout.h"]
  end
  def cname
    return "POUT"
  end
end



$piosdb={}
$piosdb["PIN"]=PIN_Gen
$piosdb["POUT"]=POUT_Gen

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
  def initialize(pio,name)
    @pins=pio["PINS"]
    @type=pio["TYPE"]
    @name=name
  end
  def generate(cc,h)
    puts ">> Generate #{@name} type #{@type}:"

    obj=nil
    begin
      obj = $piosdb[@type]
    rescue
      puts "Unknown type '#{@type}'"
    end
    return if obj == nil
    cname ="#{@type}_#{@name}"

    obj.new(self,cc,h).cname

    #h.
    
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
  def initialize(ic)
    @type=ic["TYPE"]
    @name=ic["NAME"]
    @pios=[]
    icpio=ic["PIOS"]
    icpio.each{ |name,pio| 
      cp = PIO.new(pio,name)
      @pios+=[cp]
    }
  end
  def writeheaders(cc,h,hfname)
    cc.write <<-EOF
#include "#{hfname}"
EOF
    h.write <<-EOF
#include <inttypes.h>
#include <avr/io.h>
#include "shclass.h"
#include "shtype.h"
EOF
  end

  def generate()
    ccfname="#{@name}clases.cc"
    hfname ="#{@name}clases.h"
    genfile_cc=File.open(ccfname,"w")
    genfile_h =File.open(hfname ,"w")

    writeheaders(genfile_cc, genfile_h, hfname)
    @PIOS=[]
    
    puts "> IC name #{@name}, type #{@type}:" 
    @pios.each{|i|
      res=i.generate(genfile_cc,genfile_h)
      @PIOS += [res] if res != nil
    }

    fd = genfile_h
    fd.write <<-EOF
class MCU_#{@name} {
    public:

EOF
    @PIOS.each{ |cname,name|
      fd.write("\t #{cname} #{name};\n");
    }
    fd.write("};\n")
    
    return [@name,@type]
  end
end

class Boards
  def initialize(filename)
    f = open(filename)
    @yml = YAML.load(f)
    f.close()

    @name = @yml["NAME"]
    @ic=[]
    @yml["IC"].each{ |i| 
      @ic+=[IC.new(i)]
    }
  end

  def makeheader(fd, fname)
    fd.write <<-EOF
class Board_#{@name} {

}
EOF
  end

  def generate()
    bfname="#{@name}_board.h"
    puts "Write file #{bfname}"
    #bfd=File.open(bfname,"w")
    puts "Board name '#{@name}'"
    #makeheader(bfd, bfname)
    @ic.each{ |i|
      #puts "XXXX #{i}"
      i.generate()
      #puts "Class #{cname} -- #{name}"
    }
  end
end
