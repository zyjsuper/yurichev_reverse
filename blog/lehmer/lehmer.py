# python 3.x

import math

def iter_perm(base, *rargs):
    """
    :type base: list
    :param rargs: range args [start,] stop[, step]
    :rtype: generator
    """
    if not rargs:
        rargs = [math.factorial(len(base))]
    for i in range(*rargs):
        yield perm_from_int(base, i)

def int_from_code(code):
    """
    :type code: list
    :rtype: int
    """
    num = 0
    for i, v in enumerate(reversed(code), 1):
        num *= i
        num += v

    return num

def code_from_int(size, num):
    """
    :type size: int
    :type num: int
    :rtype: list
    """
    code = []
    for i in range(size):
        num, j = divmod(num, size - i)
        code.append(j)

    return code

def perm_from_code(base, code):
    """
    :type base: list
    :type code: list
    :rtype: list
    """

    perm = base.copy()
    for i in range(len(base) - 1):
        j = code[i]
        if i != i+j:
            print ("swapping %d, %d" % (i, i+j))
        perm[i], perm[i+j] = perm[i+j], perm[i]

    return perm

def perm_from_int(base, num):
    """
    :type base: list
    :type num: int
    :rtype: list
    """
    code = code_from_int(len(base), num)
    print ("Lehmer code=", code)
    return perm_from_code(base, code)

def code_from_perm(base, perm):
    """
    :type base: list
    :type perm: list
    :rtype: list
    """

    p = base.copy()
    n = len(base)
    pos_map = {v: i for i, v in enumerate(base)}

    w = []
    for i in range(n):
        d = pos_map[perm[i]] - i
        w.append(d)

        if not d:
            continue
        t = pos_map[perm[i]]
        pos_map[p[i]], pos_map[p[t]] = pos_map[p[t]], pos_map[p[i]]
        p[i], p[t] = p[t], p[i]

    return w

def int_from_perm(base, perm):
    """
    :type base: list
    :type perm: list
    :rtype: int
    """
    code = code_from_perm(base, perm)
    return int_from_code(code)

def bin_string_to_number(s):
    rt=0
    for i, c in enumerate(s):
        rt=rt<<8
        rt=rt+ord(c)
    return rt

def number_to_bin_string(n):
    rt=""
    while True:
        r=n & 0xff
        rt=rt+chr(r)
        n=n>>8
        if n==0:
            break
    return rt[::-1]

s="HelloWorld"
print ("s=", s)
num=bin_string_to_number (s)
print ("num=", num)
perm=perm_from_int(list(range(26)), num)
print ("permutation/order=", perm)

num2=int_from_perm(list(range(26)), [14, 17, 9, 19, 11, 16, 23, 0, 2, 13, 20, 18, 21, 24, 10, 1, 22, 4, 7, 6, 15, 12, 5, 3, 8, 25])
print ("recovered num=", num2)
s2=number_to_bin_string(num2)
print ("recovered s=", s2)

