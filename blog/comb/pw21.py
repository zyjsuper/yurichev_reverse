import itertools

part1_list=["jake", "melissa", "oliver", "emily"] # 4 elements
part2_list=["1987", "1954", "1963"] # 3 elements
part3_list=["!","@","#","$","%","&","*","-","=","_","+",".",","] # 13 elements

for l in itertools.product(part1_list, part2_list, part3_list):
    print l
