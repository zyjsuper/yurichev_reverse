m4_include(`commons.m4')

_HEADER_HL1(`My new blog')

<p>Main topics are reverse engineering, programming, math...</p>

<p>I stepped aside from Drupal since it requires a lot of maintenance. 
On the other hand, web1.0 + m4 + git + rsync requires much less maintenance, if at all.
My old blog is still accessible at its old address: _HTML_LINK_AS_IS(`http://blog.yurichev.com')</p>

_HL2(`The posts:')

m4_include(`blog/posts.html')

<p>Some of older posts: _HTML_LINK_AS_IS(`http://blog.yurichev.com/')</p>

<p>Feel free to translate them to other languages, except Russian, please!
Just ask me, I will prepare Russian version by myself.</p>

m4_include(`google.html')

_HL2(`Subscribe to the blog:')

<p><a href="http://yurichev.com/blog/rss.xml"><img src="rss_button.gif"></a></p>

<p>Here is usual _HTML_LINK(`http://yurichev.com/blog/rss.xml',`RSS') link.
Popular RSS reader choices include _HTML_LINK(`https://feedly.com/',`feedly') (web reader) and 
_HTML_LINK(`https://www.mozilla.org/en-US/thunderbird/',`Thunderbird') (local reader).</p>

<p>Someone may be interesting in subscribing my twitter: _HTML_LINK(`https://twitter.com/yurichev',`@yurichev') or _HTML_LINK(`https://www.facebook.com/dennis.yurichev.5',`facebook').

_HL3(`Mailing list')

<p>There is also my low-traffic mailing list at google groups.
_HTML_LINK(`https://groups.google.com/forum/#!forum/yurichev/join', `Click here to join').
Or send an empty email to: _HTML_LINK(`mailto:yurichev+subscribe@googlegroups.com',`yurichev+subscribe@googlegroups.com')</p>

<form METHOD=POST action="send_email.php">
<p>Enter email for subscription:  <input type="text" name="email"><input type="submit" value="Submit"></p>
</form> 

_FOOTER()

