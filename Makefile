.SUFFIXES: .m4 .html
.m4.html:
	m4 -P $*.m4 >$*.html
default: index.html pgp.html C-book.html ops_FPGA.html openwatcom.html vuln.html ddff.html \
	cordbg.html wget.html \
	dongles.html copyfile.html retrocomputing.html oracle_tables.html \
	tracer-en.html tracer-ru.html PE_add_imports.html \
	PE_patcher.html PE_search_str_refs.html \
	mailing_lists.html contacts.html cvt2sparse.html \
	donate.html donors.html \
	blog/index.html \
	blog/fortune/index.html \
	blog/entropy/index.html \
	blog/modulo/index.html \
	blog/llvm/index.html \
	blog/RSA/index.html
all: default 
clean: 
	rm *.html
	rm blog/*.html
	rm blog/entropy/*.html
	rm blog/fortune/*.html
	rm blog/llvm/*.html
	rm blog/RSA/*.html

