m4_define(`_HTML_LINK', `<a href="$1">$2</a>')
m4_define(`_HTML_LINK_AS_IS', `<a href="$1">$1</a>')
m4_define(`_HTML_IMG', `<img src="$1" alt="$2">')
m4_define(`_HTML_EMAIL_LINK', `_HTML_LINK(mailto:_EMAIL_ADDRESS,_EMAIL_ADDRESS)')
m4_define(`_MAKE_TITLE', `<title>Dennis Yurichev: $1</title>')

m4_define(`_HEADER',`<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="author" content="Dennis Yurichev">
_MAKE_TITLE(`$1')
<link rel="stylesheet" href="https://yurichev.com/style.css">
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {inlineMath: [["$","$"],["\\(","\\)"]]}
  });
</script>
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML-full"></script>
</head>
<body>')

m4_define(`_FOOTER',`<p>&rarr; [_HTML_LINK(`//yurichev.com',`back to the main page')]</p>
</body>
</html>')

m4_define(`_EXERCISE_FOOTER',`<p>Other exercises like this are available in my _HTML_LINK(`//yurichev.com/blog/',`blog') and _HTML_LINK(`https://beginners.re/',`my book').</p>')
m4_define(`_EXERCISE_SPOILER_WARNING',`<p>Spoiler warning! The text below has white color, select it using mouse to read the text (or press Ctrl-A).</p>')

m4_define(`_BLOG_FOOTER',`<hr>
<p>&rarr; [_HTML_LINK(`//yurichev.com/blog/index.html',`list of blog posts'), my _HTML_LINK(`https://twitter.com/yurichev',`twitter')/_HTML_LINK(`https://www.facebook.com/dennis.yurichev.5',`facebook')]</p>
Please drop me email about any bug(s) and suggestion(s): <i>dennis(@)yurichev.com</i>.</p>
m4_include(`disqus.inc')
</body>
</html>')

m4_define(`_BLOG_FOOTER_GITHUB', `<hr><p>This open sourced site and this page in particular is <a href="https://github.com/dennis714/yurichev.com/blob/master/blog/$1/index.m4">hosted on GitHub</a>. Patches, suggestions and comments are welcome.</p>')

m4_define(`_HL1', `<h2>$1</h2>')
m4_define(`_HL2', `<a class="hl_link" name="$1" href="#$1"><h3>$1</h3></a>')
m4_define(`_HL3', `<a class="hl_link" name="$1" href="#$1"><h4>$1</h4></a>')
m4_define(`_HL4', `<a class="hl_link" name="$1" href="#$1"><h5>$1</h4></a>')
m4_define(`_GREY', `<font color="#808080">$1</font>')
m4_define(`_BOOK_NOT_FINISHED', `$1')
m4_define(`_HEADER_HL1', `_HEADER(`$1')_HL1(`$1')')

m4_define(`_PRE_BEGIN',`<pre class="normal">')
m4_define(`_PRE_END',`</pre>')

m4_define(`_COPYPASTED1',`<p>The note below has been copypasted to the _HTML_LINK(`http://beginners.re/',`Reverse Engineering for Beginners book')</p>')


