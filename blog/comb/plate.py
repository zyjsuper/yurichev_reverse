import itertools

part1_list=["13"]
part2_list=["6", "8", "9"]
part3_list=["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

for i in itertools.product(part1_list, part2_list, part3_list):
    for j in itertools.permutations(i):
        print "".join(j)

