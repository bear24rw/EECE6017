import math
import sys

rand_val = [0 for i in range(3)]
div_val = [0 for i in range(3)]
sum_val = [0 for i in range(3)]
sum_val0 = [0 for i in range(3)]
sum_val1 = [0 for i in range(3)]
sum_val2 = [0 for i in range(3)]
base = [0 for i in range(3)]
exp = [0 for i in range(3)]
bcd_tens = [0 for i in range(3)]
bcd_ones = [0 for i in range(3)]
bcd_exp = [0 for i in range(3)]

count = 0

for line in open("top_tb.log","r"):

    # shift over all the old values
    rand_val[2] = rand_val[1]
    div_val[2] = div_val[1]
    sum_val[2] = sum_val[1]
    sum_val0[2] = sum_val0[1]
    sum_val1[2] = sum_val1[1]
    sum_val1[2] = sum_val1[1]
    base[2] = base[1]
    exp[2] = exp[1]
    bcd_tens[2] = bcd_tens[1]
    bcd_ones[2] = bcd_ones[1]
    bcd_exp[2] = bcd_exp[1]

    rand_val[1] = rand_val[0]
    div_val[1] = div_val[0]
    sum_val[1] = sum_val[0]
    sum_val0[1] = sum_val0[0]
    sum_val0[1] = sum_val0[0]
    sum_val1[1] = sum_val1[0]
    base[1] = base[0]
    exp[1] = exp[0]
    bcd_tens[1] = bcd_tens[0]
    bcd_ones[1] = bcd_ones[0]
    bcd_exp[1] = bcd_exp[0]

    # read in the new ones
    (rand_val[0], div_val[0], sum_val[0], sum_val0[0], sum_val1[0], sum_val2[0], base[0], exp[0], bcd_tens[0], bcd_ones[0], bcd_exp[0]) = line.split("|")

    # convert them to proper data types
    rand_val[0] = float(rand_val[0])
    div_val[0] = float(div_val[0])
    sum_val[0] = float(sum_val[0])
    sum_val0[0] = float(sum_val0[0])
    sum_val1[0] = float(sum_val1[0])
    sum_val2[0] = float(sum_val2[0])

    base[0] = base[0].strip().zfill(2)
    bcd_tens[0] = bcd_tens[0].strip()
    bcd_ones[0] = bcd_ones[0].strip()

    # we just got new values so increase the count
    count = count + 1

    #
    # DIVIDER
    #
    # need at least two clocks to check the divider
    if (count > 2):

        # calculate the difference between the theoretical and actual
        diff = math.fabs(rand_val[1]*0.328125 - div_val[0])

        # if its off by more than out bit resolution it's wrong
        if (diff > 1.0/(2**6)):
            print "[FAIL][DIVIDER] divided value is wrong"
            print line

    #
    # SUM
    #
    # need at least three clocks to check the sum
    if (count > 3):

        # add up all the internal sum values
        added = sum_val0[0] + sum_val1[0] + sum_val2[0]

        # if they do not equal the output of the module it's wrong
        if (sum_val[0] != added):
            print "[FAIL][SUM] Sums do not add up to %f [Added to: %f]" % (sum_val[0], added)
            print line

    #
    # BCD
    #
    if (base[0][0] != bcd_tens[0]): print "[FAIL][BCD] Bcd tens digit [%s] does not match input digit [%s]" % (base[0][0], bcd_tens[0])
    if (base[0][1] != bcd_ones[0]): print "[FAIL][BCD] Bcd ones digit [%s] does not match input digit [%s]" % (base[0][1], bcd_ones[0])

