import random

f = open("random.txt","w")

for i in range(1000):
    num = random.randrange(0,256)
    f.write(str(hex(num)).split("x")[1])
    f.write("\n")

f.close()
