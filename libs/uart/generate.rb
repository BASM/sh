
UARTDIR="#{TOPDIR}/libs/avr/uart"
class UART_Gen

  def initialize(obj,cc,h,mode)
  fpref = "_host" if mode == :host
  erb = erb_read("#{UARTDIR}/tmpl/uart#{fpref}.h.erb");
  @name=obj.name
  h.write(erb.result(binding))

  erb = erb_read("#{UARTDIR}/tmpl/uart#{fpref}.cc.erb");
  @baud=obj.bd["BAUD"]
  @name=obj.name
  cc.write(erb.result(binding))
  end

  def cname
    return "UART"
  end
end


#$piosdb["UART"]=UART_Gen
