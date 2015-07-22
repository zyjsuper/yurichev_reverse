#-*- coding: utf-8 -*-

# Python 2.7

from lxml import etree
from sets import Set
import sys, time, re, os, frobenoid, Levenshtein

def process_file (fname):
    current_tags=[]
    tmp="{http://www.mediawiki.org/xml/export-0.10/}"
    namespaces = []
    cur_title=""
    words_stat={}

    context = etree.iterparse(fname, events=("start", "end", "start-ns", "end-ns"))
    for event, elem in context:
        if event=="start-ns":
            namespaces.insert(0, elem)
        
        if event=="end-ns":
            namespaces.pop(0)

        if event=="start":
            current_tags.append (elem.tag)
         
        if event=="end":
            if current_tags[-1]!=elem.tag:
                raise AssertionError
            current_tags.pop()

            if elem.tag==tmp+"title":
		cur_title=elem.text

            if elem.tag==tmp+"text":
                if elem.text!=None: # FIXME
		    # this is text
		    for x in re.split('\s+', elem.text):
			l=unicode(x.lower())
			if len(l)>5 and frobenoid.str_is_latin(l):
			    frobenoid.inc_value_in_dict(words_stat, l)

            if elem.tag==tmp+"page":
                pass
            elem.clear()
    return words_stat

words_stat=process_file(sys.argv[1])
sys.stderr.write (sys.argv[1]+" parsed\n")

words_stat_len=len(words_stat)
dictionary_word_threshold=words_stat_len/500
typo_threshold=dictionary_word_threshold/100 # 1%

print "words_stat_len=", words_stat_len
print "dictionary_word_threshold=", dictionary_word_threshold
print "typo_threshold=", typo_threshold

probably_correct_words=filter(lambda x: words_stat[x]>dictionary_word_threshold, words_stat)
print "len(probably_correct_words)=", len(probably_correct_words)

words_to_check_unsorted=filter(lambda x: words_stat[x]<typo_threshold, words_stat)
words_to_check=sorted(words_to_check_unsorted, key=lambda x: words_stat[x], reverse=False)
print "len(words_to_check)=", len(words_to_check)

for w in words_to_check:
    suggestions=[]
    for wd in probably_correct_words:
        dist=Levenshtein.distance(w, wd)
        if dist==1:
	#if 1 <= dist <= 2:
	    suggestions.append(wd)
    if len(suggestions)>0:
        print "typo?",w,"("+str(words_stat[w])+") suggestions=", suggestions

