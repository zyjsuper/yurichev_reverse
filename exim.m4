m4_include(`commons.m4')

_HEADER(`Exim MTA (mail transfer agent)')

_HL1(`Exim MTA (mail transfer agent)')

<p>I was really tired of receiving email SPAM, various notifications, etc, right to my mobile
phone on the go. I read my emails on phone via IMAP and I find this idea useful: leave
only emails from your address book in inbox and move all the rest to another folder for
reading it later.</p>

<p><b>~/address_book</b> file is plain text file
containing all your correspondent's email addresses you wish to read post from them in the first place.</p>

<p>All other emails are moved to <b>not-in-my-address-book</b> IMAP folder. It should be present.</p>

<p>And this piece should be placed in <b>~/.forward</b> file</p>

<pre>
# Exim filter
if "${lookup{$sender_address}lsearch{/home/dennis/address_book}{true}{false}}" is "false"
then
    save Maildir/.not-in-my-address-book/
    finish
endif

if "${lookup{${address:$h_From:}}lsearch{/home/dennis/address_book}{true}{false}}" is "false"
then
    save Maildir/.not-in-my-address-book/
    finish
endif
</pre>

<p><b>allow_filter = true</b> options is also should be set in Exim configuration files 
(<b>/etc/exim4/conf.d/router/600_exim4-config_userforward</b>).</p>

_FOOTER()
