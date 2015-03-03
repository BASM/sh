
PIODIR="#{TOPDIR}/libs/pio"

class PINOUT_Gen
  def erbrun(fname,name,port,outf)
        @erb = erb_read(fname)
        num,bit=port.scan(/P(.)(.)/)[0]
        @ddr="DDR#{num}"
        @port="PORT#{num}"
        @pin="PIN#{num}"
        @bit=bit
        @name=name
        outf.write(@erb.result(binding))
  end
  def initialize(obj,cc,h,mode)
    @obj=obj
    @cc=cc
    @h=h
    objname=obj.name

    fpref = "host_" if mode == :host
    @obj.pins.each{ |name,port|
      #cclist.each{ |fname|  erbrun("#{PIODIR}/tmpl/#{fpref}#{fname}.erb",name,port,cc) }
      #hlist.each { |fname|  erbrun("#{PIODIR}/tmpl/#{fpref}#{fname}.erb",name,port,h ) }
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
      h.write "\t#{cname()} #{name};\n"
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
    return []
  end
  def hlist
    return ["pout.h"]
  end
  def cname
    return "POUT"
  end
end

#$piosdb["PIN"]=PIN_Gen
#$piosdb["POUT"]=POUT_Gen


=begin
class UART_Gen
  def erb_read(fname)
  fd = File.open(fname);
  erb = ERB.new(fd.read);
  fd.close()
  erb
  end

  def initialize(obj,cc,h)
  erb = erb_read("#{UARTDIR}/tmpl/uart.h.erb");
  @name=obj.name
  h.write(erb.result(binding))

  erb = erb_read("#{UARTDIR}/tmpl/uart.cc.erb");
  @baud=obj.bd["BAUD"]
  @name=obj.name
  cc.write(erb.result(binding))
  end

  def cname
    return "UART"
  end
end


$piosdb["UART"]=UART_Gen
puts "HI "
=end