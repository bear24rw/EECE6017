miss = 0
hit = 0

for line in open("parsed","r"):
    line = line.replace(" ", "")
    line = line.replace("#", "")
    line = line.replace("\n", "")

    #try:
    (nums, answer) = line.split("=")
    (one, two) = nums.split("-")
    if (int(one)-int(two) != int(answer)):
        miss += 1
        print "[FAIL][%.2f] %s = %s (%s)(%s)" % ((float(miss)/(miss+hit)*100),nums, answer, int(one)-int(two), (int(answer)-(int(one)-int(two))))
    else:
        hit += 1

    #except:
    #    print "[ERROR] %s | %s | '%s'" % (nums, answer, line)
