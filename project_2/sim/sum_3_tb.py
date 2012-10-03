miss = 0
hit = 0

for line in open("sum_3_tb.log","r"):

    (left, right) = line.split("=")
    (one, two, three) = left.split("+")
    if (int(one)+int(two)+int(three) != int(right)):
        miss += 1
        print "[FAIL][%.2f] %d + %d + %d = %d [%d]" % ((float(miss)/(miss+hit)*100), int(one), int(two), int(three), int(right), int(one)+int(two)+int(three))
    else:
        hit += 1

