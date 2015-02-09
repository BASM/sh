
UARTDIR="#{TOPDIR}/libs/avr/uart"
class UART_Gen

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
