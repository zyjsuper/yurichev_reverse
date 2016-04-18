.SUFFIXES: .m4 .html
.m4.html:
	m4 -P $*.m4 >$*.html
default: index.html pgp.html C-book.html ops_FPGA.html openwatcom.html vuln.html ddff.html \
	cordbg.html wget.html \
	dongles.html copyfile.html retrocomputing.html oracle_tables.html \
	tracer-en.html tracer-ru.html PE_add_imports.html \
	PE_patcher.html PE_search_str_refs.html \
	mailing_lists.html contacts.html cvt2sparse.html services.html \
	blog/posts.html \
	blog/index.html \
	blog/fortune/index.html \
	blog/entropy/index.html \
	blog/modulo/index.html \
	blog/llvm/index.html \
	blog/clique/index.html \
	blog/fuzzy_string/index.html \
	blog/2015-aug-13/index.html \
	blog/2015-aug-20/index.html \
	blog/de_bruijn/index.html \
	blog/CAS/index.html \
	blog/git/index.html \
	blog/encrypted_DB_case_1/index.html \
	blog/FAT12/index.html \
	blog/typeless/index.html \
	blog/RSA/index.html \
	blog/lzhuf/index.html \
	blog/challenges.re/index.html

all: default 
#I've too many HTMLs!
#clean: 
#	rm *.html
#	rm blog/*.html
#	rm blog/entropy/*.html
#	rm blog/fortune/*.html
#	rm blog/llvm/*.html
#	rm blog/RSA/*.html
#	rm blog/modulo/*.html
#	rm blog/clique/*.html
#	rm blog/fuzzy_string/*.html
#	rm blog/2015-aug-13/*.html
#	rm blog/2015-aug-15/*.html

