m4_define(`_HTML_LINK', `<a href="$1">$2</a>')
m4_define(`_HTML_IMG', `<img src="$1" alt="$2">')
m4_define(`_HTML_EMAIL_LINK', `_HTML_LINK(mailto:_EMAIL_ADDRESS,_EMAIL_ADDRESS)')
m4_define(`_MAKE_TITLE', `<title>Dennis Yurichev: $1</title>')

m4_define(`_HEADER',`<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="author" content="Dennis Yurichev">
_MAKE_TITLE(`$1')
<link rel="stylesheet" href="style.css">
<script src="multilang.js" type="text/javascript"></script>
</head>
<body>')

m4_define(`_MULTILANG_SWITCH',`<h5>
<p class="right">
<a href="javascript:set_english();">English</a>&nbsp;
<a href="javascript:set_russian();">Русский</a></p>
</h5>')


m4_define(`_FOOTER',`<p>&rarr; [_HTML_LINK(`index.html',`index page')]</p>

<h5>File last updated on m4_esyscmd(c:/cygwin/bin/date -r m4___file__ +"%d-%B-%Y")</h5>

</body>
</html>')

m4_define(`_HL1', `<h2>$1</h2>')
m4_define(`_HL2', `<h3>$1</h3>')
m4_define(`_HL3', `<h4>$1</h4>')
m4_define(`_HL4', `<h5>$1</h5>')
m4_define(`_GREY', `<font color="#808080">$1</font>')
m4_define(`_BOOK_NOT_FINISHED', `$1')
