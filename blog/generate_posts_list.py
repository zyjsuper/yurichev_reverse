#!/usr/bin/env python
import datetime, time, email.utils

def post(f_rss, f_html, TS, URL, title):

    full_URL="http://yurichev.com/blog/"+URL+"/"
    
    f_rss.write("    <item>\n")
    f_rss.write("      <title>"+title+"</title> \n")
    f_rss.write("      <link>"+full_URL+"</link> \n")
    f_rss.write("      <description>"+title+"</description> \n")
    f_rss.write("      <pubDate>"+email.utils.formatdate(time.mktime(TS.timetuple()), True)+"</pubDate>\n")
    f_rss.write("    </item>\n")

    f_html.write("<tr><td>"+TS.strftime("%d-%b-%Y") + "</td><td><a href=\""+ full_URL +"\">"+title+"</a></td></tr>\n")

def main():
    f1=open("rss.xml","w")
    f2=open("posts.html","w")

    f1.write ("<rss version=\"2.0\">\n")
    f1.write ("  <channel> \n")
    f1.write ("    <title>Dennis Yurichev</title> \n")
    f1.write ("    <link>http://yurichev.com/blog/</link> \n")
    f1.write ("    <description>by Dennis Yurichev</description>\n")

    f2.write ("<table>\n")

    post(f1,f2,datetime.datetime(2015,8,20,0,0,0), "2015-aug-20", "Yet another crackme (or rather keygenme).")
    post(f1,f2,datetime.datetime(2015,8,20,0,0,0), "2015-aug-20", "Some parts of my Reverse Engineering book translated to Chinese.")

    post(f1,f2,datetime.datetime(2015,8,18,0,0,0), "2015-aug-18", "Solution for the exercise posted at 15 August; the next reverse engineering exercise (for x86, ARM, ARM64, MIPS)")
    post(f1,f2,datetime.datetime(2015,8,15,0,0,0), "2015-aug-15", "Solution for the exercise posted at 13 August; the next reverse engineering exercise (for x86, ARM, ARM64, MIPS)")
    post(f1,f2,datetime.datetime(2015,8,13,0,0,0), "2015-aug-13", "Introduction to logarithms; yet another x86 reverse engineering exercise")
    post(f1,f2,datetime.datetime(2015,7,23,0,0,0), "fuzzy_string", "Fuzzy string matching + simplest possible spellchecking + hunting for typos and misspellings in Wikipedia")
    post(f1,f2,datetime.datetime(2015,7,22,0,0,0), "clique", "Clique in graph theory")
    post(f1,f2,datetime.datetime(2015,7,9,0,0,0), "RSA", "How RSA works")
    post(f1,f2,datetime.datetime(2015,6,13,0,0,0), "modulo", "Modular arithmetic + division by multiplication + reversible LCG (PRNG) + cracking LCG with Z3")
    post(f1,f2,datetime.datetime(2015,5,16,0,0,0), "llvm", "Tweaking LLVM Obfuscator + quick look into some of LLVM internals")
    post(f1,f2,datetime.datetime(2015,5,13,0,0,0), "entropy", "(Beginners level) Analyzing unknown binary files using information entropy")
    post(f1,f2,datetime.datetime(2015,4,25,0,0,0), "fortune", "(Beginners level) reverse engineering of simple fortune program indexing file")
    
    f2.write ("</table>\n")
 
    f1.write ("  </channel>\n")
    f1.write ("</rss>\n")
  
    f1.close()
    f2.close()

main()

