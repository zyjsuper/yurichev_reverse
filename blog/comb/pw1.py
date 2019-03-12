import itertools

part1_list=["jake", "melissa", "oliver", "emily"]
part2_list=["1987", "1954", "1963"]
part3_list=["!","@","#","$","%","&","*","-","=","_","+",".",","]

for part1 in part1_list:
    for part2 in part2_list:
        for part3 in part3_list:
            l=[part1, part2, part3]
            for i in list(itertools.permutations(l)):
                print "".join(i)

