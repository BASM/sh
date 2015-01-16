import yaml
#import ./pios

class PIO:
    def __init__(self,pio,type):
        self.pio=pio
        self.name=pio["TYPE"]
        self.type=type

    def print(s):
        print("Name: %s, type: %s"%(s.name,s.type))
        print("PIOS: %s\n"%s.pio["PINS"])

class IC:
    def __init__(s,ic):
        s.type=ic["TYPE"]
        s.pios=[]
        icpio=ic["PIO"]
        for pio in icpio:
            cp = PIO(icpio[pio],pio)
            s.pios+=[cp]

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

    def print(s):
        print("Board name '%s'"%(s.name))
        for i in s.ic:
            i.print()

brd=BOARD("board.yml")
brd.print()
