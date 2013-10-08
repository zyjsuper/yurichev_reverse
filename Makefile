.SUFFIXES: .m4 .html
.m4.html:
	m4 -P $*.m4 >$*.html
default: index.html pgp.html RE-book.html ops_FPGA.html openwatcom.html vuln.html ddff.html \
	cordbg.html wget.html exim.html \
	dongles.html copyfile.html retrocomputing.html oracle_tables.html donate.html \
	tracer-en.html tracer-ru.html kiev_city_train.html PE_add_import.html
all: default 
clean: 
	rm *.html
