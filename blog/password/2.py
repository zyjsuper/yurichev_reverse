import itertools, string

parts=["den", "xenia", "1979", "1985", "!", "$", "^"]

for i in range(1, 6): # 1..5
    for combination in itertools.combinations(parts, i):
        for permutation in itertools.permutations(list(combination)):
            s="".join(permutation)
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
