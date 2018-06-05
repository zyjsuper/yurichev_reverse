.SUFFIXES: .m4 .html
.m4.html:
	m4 -P $*.m4 >$*.html
HTML_FILES=index.html pgp.html C-book.html ops_FPGA.html openwatcom.html vuln.html ddff.html \
	cordbg.html wget.html \
	dongles.html copyfile.html retrocomputing.html oracle_tables.html \
	tracer-en.html tracer-ru.html PE_add_imports.html \
	PE_patcher.html PE_search_str_refs.html \
	cvt2sparse.html services.html donate.html \
	404.html \
	blog/posts.html \
	blog/index.html \
	blog/2017-jun-5/index.html \
	blog/minesweeper_PIN/index.html \
	blog/8queens/index.html \
	blog/weird_sort/index.html \
	blog/PIN_XOR/index.html \
	blog/cyclomatic/index.html \
	blog/SAP/index.html \
	blog/modulo/index.html \
	blog/llvm/index.html \
	blog/clique/index.html \
	blog/fuzzy_string/index.html \
	blog/2015-aug-13/index.html \
	blog/2015-aug-20/index.html \
	blog/CAS/index.html \
	blog/git/index.html \
	blog/typeless/index.html \
	blog/RSA/index.html \
	blog/lzhuf/index.html \
	blog/signed_division_using_shifts/index.html \
	blog/1/index.html \
	blog/2/index.html \
	blog/3/index.html \
	blog/4/index.html \
	blog/5/index.html \
	blog/6/index.html \
	blog/7/index.html \
	blog/8/index.html \
	blog/9/index.html \
	blog/10/index.html \
	blog/11/index.html \
	blog/12/index.html \
	blog/13/index.html \
	blog/14/index.html \
	blog/15/index.html \
	blog/17/index.html \
	blog/18/index.html \
	blog/22/index.html \
	blog/23/index.html \
	blog/24/index.html \
	blog/25/index.html \
	blog/26/index.html \
	blog/27/index.html \
	blog/28/index.html \
	blog/29/index.html \
	blog/30/index.html \
	blog/31/index.html \
	blog/32/index.html \
	blog/33/index.html \
	blog/35/index.html \
	blog/36/index.html \
	blog/37/index.html \
	blog/38/index.html \
	blog/39/index.html \
	blog/41/index.html \
	blog/42/index.html \
	blog/43/index.html \
	blog/44/index.html \
	blog/45/index.html \
	blog/46/index.html \
	blog/47/index.html \
	blog/48/index.html \
	blog/50/index.html \
	blog/52/index.html \
	blog/54/index.html \
	blog/55/index.html \
	blog/56/index.html \
	blog/57/index.html \
	blog/58/index.html \
	blog/59/index.html \
	blog/60/index.html \
	blog/61/index.html \
	blog/64/index.html \
	blog/65/index.html \
	blog/66/index.html \
	blog/68/index.html \
	blog/69/index.html \
	blog/70/index.html \
	blog/71/index.html \
	blog/74/index.html \
	blog/75/index.html \
	blog/76/index.html \
	blog/77/index.html \
	blog/79/index.html \
	blog/82/index.html \
	blog/85/index.html \
	blog/challenges.re/index.html

all: $(HTML_FILES)

blog/posts.html: blog/generate_posts_list.py
	cd blog; python generate_posts_list.py; cd ..

blog/index.html: blog/posts.html

clean: 
	rm $(HTML_FILES)
	rm blog/rss.xml

