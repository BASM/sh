GENDIR="#{TOPDIR}/libs/generic"

class Generic
  def initialize(main)
    @cc   = main.cc
    @h    = main.h
    @mode = main.mode

    if @mode == :host
      @h.write ("\t void sleep_ms(int i);\n");
      @h.write ("\t void connect();\n");
      main.addtoinit("\tconnect();")
    else
      @h.write ("\t void sleep_ms(int i) { _delay_ms(i); }\n");
    end
      
  end

end

$GENLIB+=[Generic]
