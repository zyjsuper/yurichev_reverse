# -*- coding: utf-8 -*-

# python 3! due to random.choices()

import operator, random
from collections import defaultdict

with open ("all.txt", "r") as myfile:
    data=myfile.read()

tmp=data.lower().replace('\r',' ').replace('\n',' ').replace('?','.').replace('!','.').replace('“','.')
tmp=tmp.replace('”','.').replace("\"",".").replace('‘',' ').replace('-',' ').replace('’',' ').replace('\'',' ')
sentences=tmp.split(".")

def remove_empty_words(l):
    return list(filter(lambda a: a != '', l))

# key=list of words, as a string, delimited by space
#     (I would use list of strings here as key, but list in not hashable)
# val=dict, k: next word; v: occurrences
first={}
second={}

def update_occ(d, seq, w):
    if seq not in d:
        d[seq]=defaultdict(int)

    d[seq][w]=d[seq][w]+1

for s in sentences:
    words=s.replace(',',' ').split(" ")
    words=remove_empty_words(words)
    if len(words)==0:
        continue
    for i in range(len(words)):
        if i>=1:
            update_occ(first, words[i-1], words[i])
        if i>=2:
            update_occ(second, words[i-2]+" "+words[i-1], words[i])

"""
print ("first table:")
for k in first:
    print (k)
    # https://stackoverflow.com/questions/613183/how-do-i-sort-a-dictionary-by-value
    s=sorted(first[k].items(), key=operator.itemgetter(1), reverse=True)
    print (s[:20])
    print ("")
"""
"""
print ("second table:")
for k in second:
    print (k)
    # https://stackoverflow.com/questions/613183/how-do-i-sort-a-dictionary-by-value
    s=sorted(second[k].items(), key=operator.itemgetter(1), reverse=True)
    print (s[:20])
    print ("")
"""

text=["it", "is"]

# https://docs.python.org/3/library/random.html#random.choice
def gen_random_from_tbl(t):
    return random.choices(list(t.keys()), weights=list(t.values()))[0]

text_len=len(text)

# generate at most 100 words:
for i in range(200):

    last_idx=text_len-1

    tmp=text[last_idx-1]+" "+text[last_idx]
    if tmp in second:
        new_word=gen_random_from_tbl(second[tmp])
    else:
        # fall-back to 1st order
        tmp2=text[last_idx]
        if tmp2 not in first:
            # dead-end
            break
        new_word=gen_random_from_tbl(first[tmp2])

    text.append(new_word)
    text_len=text_len+1

print (" ".join(text))

