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

    post(f1,f2,datetime.datetime(2015,9, 6,0,0,0), "exercise10","Reverse engineering exercise #10 (for x86, ARM, ARM64, MIPS); solution for exercise #9")
    post(f1,f2,datetime.datetime(2015,9, 4,0,0,0), "exercise9", "Reverse engineering exercise #9 (for x86, ARM, ARM64, MIPS); solution for exercise #8")
    post(f1,f2,datetime.datetime(2015,9, 4,0,0,0), "FAT12", "(Beginners level) packing 12-bit values into array using bit operations (x64, ARM/ARM64, MIPS)")
    post(f1,f2,datetime.datetime(2015,9, 1,0,0,0), "exercise8", "Reverse engineering exercise #8 (for x86, ARM, ARM64, MIPS); solution for exercise #7")
    post(f1,f2,datetime.datetime(2015,8,29,0,0,0), "exercise7", "Reverse engineering exercise #7 (for x86, ARM, ARM64, MIPS); solution for exercise #6")
    post(f1,f2,datetime.datetime(2015,8,26,0,0,0), "exercise6", "Reverse engineering exercise #6 (for x86, ARM, ARM64, MIPS)")
    post(f1,f2,datetime.datetime(2015,8,26,0,0,0), "2015-aug-26", "Yet another compiler anomaly; two solutions for exercises posted these days")
    post(f1,f2,datetime.datetime(2015,8,26,0,0,0), "encrypted_DB_case_1", "Encrypted database case #1")
    post(f1,f2,datetime.datetime(2015,8,23,0,0,0), "exercise5", "Reverse engineering exercise #5 (for x86, ARM, ARM64, MIPS)")
    post(f1,f2,datetime.datetime(2015,8,22,0,0,0), "2015-aug-22", "The next reverse engineering exercise (for x86, ARM, ARM64, MIPS)")
    post(f1,f2,datetime.datetime(2015,8,22,0,0,0), "de_bruijn", "De Bruijn sequences (solution for the exercise posted at 18-Aug-2015); leading/trailing zero bits counting.")
    post(f1,f2,datetime.datetime(2015,8,20,0,0,0), "crackme4", "Yet another crackme (or rather keygenme).")
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

