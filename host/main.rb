#!/usr/bin/env ruby
require 'Qt4'
require 'yaml'


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


class Cmodel < Qt::Dialog
  slots :ButtonPressed

  def ButtonPressed() 
    puts "Button pressed #{self}"
  end

  def Button(name, parent)
    puts "Button: #{name}"
    hello = Qt::PushButton.new(name, parent)
    connect(hello,SIGNAL('clicked()'), self, SLOT('ButtonPressed()'))

    hello.show
  end

  def initialize(parent=nil)
    super(parent)
    f = File.open("../boards/switch/boards/at328.yml")
    @yml = YAML.load(f)
    f.close()

    sw=@yml["IC"]["sw"]

    puts "RESULT #{sw["PIOS"]}"

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

app = Qt::Application.new(ARGV)
wgt=Cmodel.new()
#wgt.show
puts "Result: #{app}"
#exit 0
app.exec

