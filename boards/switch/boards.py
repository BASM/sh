import yaml
import os



class PIO:
    def PIN_Gen(s):
      print("PIN Name: %s"%s.name)
      print("PIOS: %s\n"%s.pio["PINS"])


    def __init__(s,pio,name):
        s.pio=pio
        s.type=pio["TYPE"]
        s.name=name

    def generate(s):
      print("Name: %s, type: %s"%(s.name,s.type))
      if s.type=="PIN":
        s.PIN_Gen()

    def print(s):
        print("Name: %s, type: %s"%(s.name,s.type))
        print("PIOS: %s\n"%s.pio["PINS"])

class IC:
    def __init__(s,ic):
        s.type=ic["TYPE"]
        s.name=ic["NAME"]
        s.pios=[]
        icpio=ic["PIO"]
        for pio in icpio:
            cp = PIO(icpio[pio],pio)
            s.pios+=[cp]

    def generate(s):
      print("Generate IC '%s', type '%s'"%(s.name,s.type))
      os.mkdir(s.type)
      os.chdir(s.type)
      for i in s.pios:
        i.generate()

    def print(s):
        print ("IC type: %s"%s.type)
        for p in s.pios:
            p.print()

class BOARD:
    def __init__(s,fname):
        f = open("board.yml")
        s.yml = yaml.safe_load(f)
        f.close()
        s.name = s.yml["NAME"]
        s.ic=[]

        for i in s.yml["IC"]:
            s.ic+=[IC(i)]

    def generate(s):
      print("Generate board: '%s'"%s.name)
      os.mkdir(s.name)
      os.chdir(s.name)
      for i in s.ic:
        i.generate()

    def print(s):
        print("Board name '%s'"%(s.name))
        for i in s.ic:
            i.print()
