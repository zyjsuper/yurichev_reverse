﻿import itertools

parts=["den", "xenia", "1979", "1985", "secret", "!", "$", "^"]

for i in range(1, 6): # 1..5
    for combination in itertools.combinations(parts, i):
        print "".join(combination)
