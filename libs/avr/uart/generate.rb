
UARTDIR="#{TOPDIR}/libs/avr/uart"
class UART_Gen
  def initialize(obj,cc,h)
    h.write <<-EOF
class #{cname}_#{obj.name} {
  public:
  #{cname}_#{obj.name} ();
};
EOF
  fd = File.open("#{UARTDIR}/tmpl/uart.cc.erb");
  erb = ERB.new(fd.read);
  fd.close()

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
