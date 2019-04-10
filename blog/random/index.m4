m4_include(`commons.m4')

_HEADER_HL1(`[Math][Python] random.choices() from Python 3')

<p>In my _HTML_LINK(`https://yurichev.com/blog/markov/',`"Autocomplete using Markov chains"') post
I used a quite useful _HTML_LINK(`https://docs.python.org/3/library/random.html#random.choices',`random.choices()') function.</p>

<p>Here is another use of it.</p>

<p>You know, when you send an email, the final destination is a server somewhere.
But it may be irresponsible.
So network engineers add additional servers, "relays", which can hold your email for some time.</p>

<p>For example, what is about gmail.com?</p>

_PRE_BEGIN
% dig gmail.com MX

...

;; ANSWER SECTION:
gmail.com.              3600    IN      MX      5 gmail-smtp-in.l.google.com.
gmail.com.              3600    IN      MX      10 alt1.gmail-smtp-in.l.google.com.
gmail.com.              3600    IN      MX      20 alt2.gmail-smtp-in.l.google.com.
gmail.com.              3600    IN      MX      30 alt3.gmail-smtp-in.l.google.com.
gmail.com.              3600    IN      MX      40 alt4.gmail-smtp-in.l.google.com.
...

_PRE_END

<p>The first server is primary (marked with 5).
Other 4 (alt...) are relays.
They can hold emails for user@gmail.com if the main server is down.
Of course, relays also can be down.
So an MTA (Message transfer agent) tries to send an email via the first server in list, then via the second, etc.
If all are down, MTA is waiting for some time (not infinitely).</p>

<p>See also: _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/MX_record').</p>

<p>A number (5/10/20/30/40) is priority:</p>

_PRE_BEGIN
   MX records contain a preference indication that MUST be used in
   sorting if more than one such record appears (see below).  Lower
   numbers are more preferred than higher ones.  If there are multiple
   destinations with the same preference and there is no clear reason to
   favor one (e.g., by recognition of an easily reached address), then
   the sender-SMTP MUST randomize them to spread the load across
   multiple mail exchangers for a specific organization.
_PRE_END
<p>( _HTML_LINK_AS_IS(`https://tools.ietf.org/html/rfc5321') )</p>

<p>Now if you want your MTA be polite, you can make it poke relays with some probability, unloading the main mail server.
In any case, the internal network withing Google is way better than a link between you and any of these mail servers.
And it would be OK to drop an email to any of these mail servers listed in MX records.</p>

<p>This is how a destination server can be chosen:</p>

_PRE_BEGIN
random.choices(range(4), weights=[1/5, 1/10, 1/20, 1/40])
_PRE_END

<p>I'm using reciprocal weights (1/x) because the lower priority, the higher probability it is to be chosen.</p>

<p>What if I want to send 100 emails to someone@gmail.com?</p>

_PRE_BEGIN
>>> [random.choices(range(4), weights=[1/5, 1/10, 1/20, 1/40])[0] for x in range(100)]

[1, 1, 2, 1, 0, 2, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 2, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 3, 0, 0, 2, 1, 0, 0, 0, 0, 1, 2, 2, 1, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 1, 0, 2, 1, 0, 0, 2, 0, 0, 0, 3, 2, 0, 1, 2, 0, 1, 1, 3, 1, 1, 1, 1]
_PRE_END

<p>1000? (I'm using _HTML_LINK(`https://docs.python.org/3/library/collections.html#collections.Counter',`collections.Counter') here for gathering statistics).</p>

_PRE_BEGIN
>>> Counter([random.choices(range(4), weights=[1/5, 1/10, 1/20, 1/40])[0] for x in range(1000)])

Counter({0: 535, 1: 268, 2: 129, 3: 68})
_PRE_END

<p>535 emails will be sent via the first (primary) mail server, 268/129/68 -- via corresponding relays.</p>

</p>This is probably not how MTAs usually operates, but this is how it could be done.</p>

_BLOG_FOOTER()

