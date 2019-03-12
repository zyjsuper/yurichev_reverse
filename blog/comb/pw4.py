import itertools, string

part1_list=["jake", "melissa", "oliver", "emily"]
part2_list=["1987", "1954", "1963"]
part3_list=["!","@","#","$","%","&","*","-","=","_","+",".",","]

for l in itertools.product(part1_list, part2_list, part3_list):
    for i in list(itertools.permutations(l)):
        s="".join(i)
        t=[]
        for char in s:
            if char.isalpha():
                to_be_appended=[string.lower(char), string.upper(char)]
                if char.lower()=='e':
                    to_be_appended.append('3')
                elif char.lower()=='i':
                    to_be_appended.append('1')
                elif char.lower()=='o':
                    to_be_appended.append('0')
                t.append(to_be_appended)
            else:
                t.append([char])
        for q in itertools.product(*t):
            print "".join(q)

