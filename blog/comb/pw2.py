import itertools

part1_list=["jake", "melissa", "oliver", "emily"]
part2_list=["1987", "1954", "1963"]
part3_list=["!","@","#","$","%","&","*","-","=","_","+",".",","]

for l in itertools.product(part1_list, part2_list, part3_list):
    for i in list(itertools.permutations(l)):
        print "".join(i)

