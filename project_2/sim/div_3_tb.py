import math

miss = 0
hit = 0
diff_total = 0.0

for line in open("div_3_tb.log","r"):

    try:
        (inp, out) = line.split("|")
        inp = float(inp)
        out = float(out)
        diff = math.fabs(inp*0.328125 - out)
        diff_total += diff

        if (diff > 1.0/(2**6)):
            miss += 1
            print "[FAIL][%.2f] %f * 0.328125 = %f [Expected: %f] [Diff: %f]" % ((float(miss)/(miss+hit)*100), inp, out, inp/3.0, diff)
        else:
            hit += 1
    except:
        print "[ERROR!] %s" % line

print "Average precision loss: %f" % (diff_total / (hit+miss))
