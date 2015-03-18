UARTDIR="#{TOPDIR}/libs/avr/uart"

# UART TYPES
# * 

class UART_Gen

  def write_host
    @main.h.write <<-EOF
    #include <uart_host.h>
class #{cname} : public UART {
};
EOF
  
  end

  def write
    @main.h.write <<-EOF
    #include <uart_avr.h>
class #{cname} : public UART {
      public:
        #{cname} ();
        void init(void);
        //void putch(char c);
};
      
EOF

    @main.cc.write <<-EOF
  #ifndef F_CPU
  #error Please set F_CPU!
  #endif
#{cname}::#{cname}() {

}

void #{cname}::init(void) {
  UCSR0A = 0;
  UCSR0B = 0x18;
  UCSR0B |= RXEN0;
  UCSR0C = 0x06;
#define BAUD #{@baud}
#include <util/setbaud.h>
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;
#if USE_2X
    UCSR0A |= (1 << U2X0);
#else
    UCSR0A &= ~(1 << U2X0);
#endif
#undef BAUD
}
EOF
  end

  def initialize(main,pio)
    @type  = :hw
    @mode  = main.mode
    @reset = true
    @main  = main
    @pio   = pio
    @baud  = pio.obj["BAUD"]

    # TODO FIXME analizate obj and change
    #  type and reset.


    if @mode == :host
      write_host
    else
      main.addtoinit(initstr(@pio))
      write
    end
  end

  def initstr(obj)
    "\t#{obj.name}.init();\n"
  end

  def cname
    hwpref="_SW"
    hwpref="_HW" if @type == :hw
    resetpref="_RST" if @reset == true

    return "UART#{hwpref}#{resetpref}_#{@baud}"
  end
end


$piosdb["UART"]=UART_Gen
