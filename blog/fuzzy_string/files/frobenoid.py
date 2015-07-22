# -*- coding: utf-8 -*-

# my own Python utility library
# dennis(a)yurichev.com

def char_is_latin(c):
    return (c>='a' and c<='z') or (c>='A' and c<='Z') 

def str_is_latin(s):
    return all(char_is_latin(c) for c in s)

def list_remove_if_present(l, item):
    if item in l:
        l.remove(item)

def remove_item_in_all_lists(list_of_lists, item):
    [list_remove_if_present(l, item) for l in list_of_lists]

def find_sets_in_lists_differ_by_1_element(set1, list_of_sets):
    rt=Set()
    i=0
    n=len(list_of_sets)
    while i<n:
	diff=set(list_of_sets[i])-set1
        if len(diff)==1:
	    #for tmp in diff:
            #    rt.add(tmp)
            [rt.add(x) for x in diff]
	    del list_of_sets[i]
	    n=n-1
        else:
	    i=i+1
    return rt

def inc_value_in_dict (d, key):
    if key not in d:
        d[key]=1
    else:
        d[key]=d[key]+1

# TODO there should be a function like "append line to the text file"
def L (fname, s):
    f=open (fname, "a")
    dt=datetime.now()
    f.write (dt.strftime("[%Y-%m-%d %H:%M:%S] "))
    f.write (s)
    print s.rstrip ("\n")
    f.close()

def get_size_in_nice_form(sz):
    if sz>1000000000:
        return "%dG" % (sz/1000000000)
    if sz>1000000:
        return "%dM" % (sz/1000000)
    if sz>1000:
        return "%dk" % (sz/1000)
    return "%d" % sz

def list_partition(lst, n):
    division = len(lst) / float(n)
    return [ lst[int(round(division * i)): int(round(division * (i + 1)))] for i in xrange(n) ]

