import yaml

f = open("board.yml")
yml = yaml.safe_load(f)
f.close()

name = yml["NAME"]

print("Board name '%s'"%(name))

for i in yml["IC"]:
    print (i)

print("=============\n")
print(yml)
