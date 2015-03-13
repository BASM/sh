PIODIR="#{TOPDIR}/libs/pio"

class PINOUT_Gen
  def initialize(main,obj)
    @obj=obj
    @cc=main.cc()
    #puts main.inspect
    @h=main.h()
    @objname=obj.name
    @single=false
    @single=true if @obj.pins == nil

    fpref = "host_" if main.mode == :host

    if @single == false
      @h.write <<-EOF
class #{cname} {
  public:
  #{cname}();

EOF
      @cc.write <<-EOF
#{cname}::#{cname}() {

EOF
      @obj.pins.each{ |name,port| 
        @h.write "\t#{cclass} #{name};\n"
        @cc.write(initstr(name,port))
      }
      @h.write("};\n")
      @cc.write("};\n")
    else
      puts @obj.pin
      puts "SINGLE MODE"
      main.addtoinit(initstr(obj.name,@obj.pin))
    end


  end

  def name()
    @name
  end
end


class PIN_Gen < PINOUT_Gen
  def cclass
    return "PIN"
  end
  def initstr(name,port)
      b,bit=port.scan(/P(.)(.)/)[0]
      "\t#{name}.init(&DDR#{b},&PORT#{b},&PIN#{b},#{bit});\n"
  end
  def cname
    return cclass if @single == true
    return "PIN_#{@objname}"
  end
end

class POUT_Gen < PINOUT_Gen
  def initstr(name,port)
      b,bit=port.scan(/P(.)(.)/)[0]
      "\t#{name}.init(&DDR#{b},&PORT#{b},#{bit});\n"
  end
  def cclass
    return "POUT"
  end
  def cname
    return cclass if @single == true
    return "POUT_#{@objname}"
  end
end

$piosdb["PIN"]=PIN_Gen
$piosdb["POUT"]=POUT_Gen
