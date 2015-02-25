
RS485DIR="#{TOPDIR}/libs/avr/rs485"
class RS485_Gen

  def initialize(obj,cc,h,mode)
  fpref = "_host" if mode == :host

  erb = erb_read("#{RS485DIR}/tmpl/rs485#{fpref}.h.erb");
  @name=obj.name
  h.write(erb.result(binding))

  erb = erb_read("#{RS485DIR}/tmpl/rs485#{fpref}.cc.erb");
  @baud=obj.bd["BAUD"]
  @name=obj.name
  cc.write(erb.result(binding))

  #$FGEN+=
  end

  def cname
    return "RS485"
  end
end


#$piosdb["RS485"]=RS485_Gen
