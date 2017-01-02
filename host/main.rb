#!/usr/bin/env ruby
require 'Qt4'
require 'yaml'
require 'socket'


# client type: 
# * cli[:gui] -- GUI object
# * cli[:net] -- network object

class Flag
	def initialize(name, value, parent)
		@xname=name
		@stat=value
		#@parent=parent

		#@wgt = Qt::Label.new("#{@xname} -- XX", parent)
		#setval(@stat)

	  #@wgt.setFrameStyle(Qt::Frame::Box | Qt::Frame::Raised)
		#@wgt.show
	end

	def setval(value)
		if value==0 then clr
		else             set
		end
	end

	def set
		@wgt.label="#{@xname} -- ON"
	end

	def clr
		#puts @wgt.methods
		@wgt.text="#{@xname} -- OFF"
	end

	def check
	end
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
    @net=0
    @buttonidlist={}

		@objects={}
		@objects["POUT"]={}
    super(parent)

  end

	def getobject(args)
		puts "START====="
		#puts @objects
		obj=@objects
		#puts "YYYYYYYYY #{@objects}"
		#puts "XXXXXXXXX #{obj}"
		item=nil
		drop=2
		args.each{ |i|
			puts "================================"
      if drop!=0
				drop-=1
			else
				#puts "OBJ #{obj}"
 			end

			next if i == "--"
			item=i
			begin
				obj=obj[i]
			rescue
			 	#puts "OBJS #{obj} is bad" 
			end
			if obj==nil
				#puts "Bad object '#{obj}'"
				break
			end
		}
		#puts "#{@objects}"
		#puts "EXIT+======="
		obj
	end

	def netaction(cli, args)
		puts "Action for: #{cli} args '#{args}'"
		#act=args[-1]
         
		obj=getobject(args[0...-1])
		puts "#{@objects}"
		#obj

	end

  def loadyml(path)
    puts "Try to load #{path}"
    f = File.open(path)#"../boards/switch/boards/at328.yml")
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
				puts "POUTTTT= name: #{name}"
        slider= MakeSlider(topslider)
        puts a.inspect
        if a["PIN"] != nil
 					@objects["POUT"][name]={}
					@objects["POUT"][name][a["PIN"]]=Flag.new("#{name}:#{a["PIN"]}",0, slider)
        else
 					@objects["POUT"][name]={}
					a["PINS"].map{ |a,b| @objects["POUT"][name][a]=Flag.new("#{name}:#{a}-#{b}",0, slider)   }
        end
				puts "POUT RESULT:"
				#puts @poutlist.inspect
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

  def setnet(netobj)
	@net=netobj
  end

end

#wgt=Cmodel.new()
#wgt.show
#puts "Result: #{app}"
#exit 0

# Connect NETWORK and GUI
# clients-> [ {network, gui}, ....]
class Clients
	def initialize()
		@clients={}
		@app = Qt::Application.new(ARGV)
		network
	end	
	def network()
	@gate = nil
	(3000..3010).each{ |i|
		begin
			@gate = ModeGate.new(self, :port=>i)
		break
		rescue Exception => e
			puts "EX: #{e}"
		next
		end
	}
	puts "Gate is #{@gate}"
	if @gate == nil
 		puts "Can't open socket!\n"
                puts "Fatal"
        end 
	end
	def newcli(net, args)
		gui=Cmodel.new()
		gui.setnet(net)
		gui.loadyml(args[0])
		gui.show()
		return gui
	end
	def exec()
	# XXX FIXME
	loop do
		@gate.iterate
	end
	@app.exec #nonblock?
	end
	def close()
	@gate.close
	end
end


class ModeGate
  def initialize(parent, hash)
    @parent=parent
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
    cli={}
    begin
      cli[:net] = @server.accept_nonblock
    rescue  IO::WaitReadable, Errno::EINTR
      return
    end
    @clients += [cli]
    puts "on loop #{cli[:net].inspect}"
    puts "socket  : #{cli[:net][0].inspect}"
    puts "addrinfo: #{cli[:net][1].inspect}"
    #puts "on loop #{cli.inspect}"
  end

  def command_parce(cli,cmd)
	command=cmd.split[0]
	args=cmd.split[1..-1]
        #puts "COMMAND: '#{command}', args: '#{args}'"
	case command
		when "ymlfile" 
		   cli[:gui]=@parent.newcli(cli[:net], args)
		when "action"
			puts "#{@objects}"
		   cli[:gui].netaction(cli[:net], args)
			puts "#{@objects}"
		else
		#puts "CMD #{command} unsuported!"
        end
  end
  def guiaction(cli, args)
	puts "Guid action net: '#{cli.inspect}', args: '#{args}'"
  end
  def bufferparser(cli)
    while @cmdbody.scan("\n") != []
          i=@cmdbody.index("\n")
          cmd=@cmdbody[0..i]
          @cmdbody=@cmdbody[i+1..-1]
          #puts "LIST: #{list.inspect}"
          command_parce(cli,cmd)
    end
  end

  def check_parsedata
    @clients.each{ |obj|
      cli,addr=obj[:net]
      #puts "Check data for #{addr}"
      begin
        readres = cli.recvfrom_nonblock(20)
        @cmdbody+=readres[0]
        bufferparser(obj)
      #puts "Client #{cli} body: '#{@cmdbody}'"
      rescue Errno::EAGAIN
        #puts "No data"
      end
    }
  end

  def iterate
      check_connecting
      check_parsedata
  end

  def exec
    loop do
      iterate
      sleep 0.1
    end
  end
  def close
    puts "Close socket..."
    @server.close
  end
end
##########################################

#app.exec
cli = Clients.new
begin
  cli.exec
rescue SignalException => e
  puts "SIGNAL"
rescue Exception => e
  puts "EXCEPT #{e}"
	raise
else
  puts "Close gate..."
  cli.close
end
