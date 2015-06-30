#!/usr/bin/env ruby
require 'Qt4'
require 'yaml'
require 'socket'

def Flag(name, value, parent)
  puts "Flag: #{name} -- #{value}"
  if value==0
    hello = Qt::Label.new("#{name} -- OFF", parent)
  else
    hello = Qt::Label.new("#{name} -- ON", parent)
  end
  hello.setFrameStyle(Qt::Frame::Box | Qt::Frame::Raised)
  hello.show
end

def UART(name, parent)
  Qt::TextEdit.new(name,parent);

end


def MakeSlider(parent)
  slider = Qt::Splitter.new(Qt::Vertical, parent)
  slider.setFrameStyle(Qt::Frame::Panel | Qt::Frame::Sunken)
  slider.midLineWidth=4
  slider.lineWidth=4
  slider.show
  slider
end

# Gate for Cmodel communication
class CmodelGate
  def initialize
    

  end

end


class Cmodel < Qt::Dialog
  slots :ButtonPressed, "bclick(int)"

  def Button(name, parent)
    widget = Qt::PushButton.new(name, parent)
    connect(widget, SIGNAL('clicked()'), @bmapper, SLOT("map()"))
    #widget = Qt::Widget.new()
    #widget = Qt::Object.new()
    #widget = Qt::PushButton.new()
    @bmapper.setMapping(widget, widget.object_id)
    @buttonidlist[widget.object_id]=name
    widget.show
    widget
  end

  def bclick(res)
    ##FIXME нужно получать указалель на кнопку а не object_id
    puts "Button was clicked #{res}"
    puts "Button name is '#{@buttonidlist[res]}'"
    
    @gate.sendsignal(name)

  end

  def initialize(parent=nil)
    @buttonidlist={}
    super(parent)
    f = File.open("../boards/switch/boards/at328.yml")
    @yml = YAML.load(f)
    f.close()

    sw=@yml["IC"]["sw"]

    puts "RESULT #{sw["PIOS"]}"

    @bmapper = Qt::SignalMapper.new(self)
    connect(@bmapper, SIGNAL('mapped(int)'), self, SLOT('bclick(int)'))


    mainslider      = Qt::Splitter.new(Qt::Vertical)
    mainslider.show
    topslider = Qt::Splitter.new(Qt::Horizontal, mainslider)
    topslider.show
    bottomslider = Qt::Splitter.new(Qt::Horizontal, mainslider)
    bottomslider.show

    sw["PIOS"].each{|name,a| 

      case a["TYPE"]
      when "PIN"
        slider= MakeSlider(topslider)
        a["PINS"].each{ |a,b|
          Button("#{name}:#{a}-#{b}", slider)
        }
      when "POUT"
        slider= MakeSlider(topslider)
        puts a.inspect
        if a["PIN"] != nil
          Flag("#{name}:#{a["PIN"]}",0, slider)
        else
          a["PINS"].each{ |a,b|
            Flag("#{name}:#{a}-#{b}",0, slider)
          }
        end
      when "UART"
        slider= MakeSlider(bottomslider)
        puts "New UART wname: #{name}"
        UART("#{name}",slider) 
      else
        puts "UNKNOWN  TYPE #{a["TYPE"]}"
      end
    }
    self
  end

end

#app = Qt::Application.new(ARGV)
#wgt=Cmodel.new()
#wgt.show
#puts "Result: #{app}"
#exit 0
#app.exec


class ModeGate
  def initialize(hash)
    @clients=[]
    @port = 3000
    @port = hash[:port] if hash[:port] != nil
    @cmdbody=""

    @server = Socket.new(Socket::PF_INET, Socket::SOCK_STREAM)
    sockaddr = Socket.sockaddr_in( @port, 'localhost' )
    @server.bind(sockaddr)
    @server.listen(5)
    puts hash.inspect
  end

  def check_connecting
    cli=nil
    begin
      cli = @server.accept_nonblock
    rescue  IO::WaitReadable, Errno::EINTR
      return
    end
    @clients += [cli]
    puts "on loop #{cli.inspect}"
    puts "socket  : #{cli[0].inspect}"
    puts "addrinfo: #{cli[1].inspect}"
    #puts "on loop #{cli.inspect}"
  end

  def command_parce(cmd)
          puts "COMMAND: #{cmd}"
  end

  def bufferparser
    while @cmdbody.scan("\n") != []
          i=@cmdbody.index("\n")
          cmd=@cmdbody[0..i]
          @cmdbody=@cmdbody[i+1..-1]
          #puts "LIST: #{list.inspect}"
          command_parce(cmd)
    end
  end

  def check_parsedata
    @clients.each{ |cli,addr| 
      #puts "Check data for #{addr}"
      begin
        readres = cli.recvfrom_nonblock(20)
        @cmdbody+=readres[0]
        bufferparser
      #puts "Client #{cli} body: '#{@cmdbody}'"
      rescue Errno::EAGAIN
        #puts "No data"
      end
    }
  end

  def exec
    loop do
      check_connecting
      check_parsedata
      sleep 0.1
    end
    #  client = @server.accept
    #  puts "xxx"
    #  client.puts "GUI for sh model."
    #  client.puts "And time server ;-) (time is #{Time.new})"
    #end
  end
  def close
    puts "Close socket..."
    @server.close
  end
end
gate=nil
  (3000..3010).each{ |i|
begin
    gate = ModeGate.new(:port=>i)
    break
rescue Exception => e
  puts "EX: #{e}"
  next
end
  }


begin
  gate.exec
rescue SignalException => e
  puts "SIGNAL"
rescue Exception => e
  puts "EXCEPT #{e}"
else
  puts "Close gate..."
  gate.close
end
