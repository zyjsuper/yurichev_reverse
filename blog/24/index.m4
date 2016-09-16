m4_include(`commons.m4')

_HEADER_HL1(`24-Jul-2009: CVE-2009-1019 PoC (CPUjul2009)')

<p><a href="http://blogs.oracle.com/security/2009/07/july_2009_critical_patch_update_released.html">- CVE-2009-1019 receives a CVSS Base Score of 7.5 denoting that a successful exploit of this vulnerability can lead to a full compromise of the targeted database. This vulnerability affects Oracle Database Server 9.2.0.8, 9.2.0.8DV, 10.1.0.5, 10.2.0.4, and 11.1.0.7. It is remotely exploitable without authentication. </a></p>

<p>Here is explanation of vulnerability I did found.</p>

<p>This exploit cause Oracle instance DoS.</p>

<p>Tested with 11.1.0.6.0 win32.</p>

<p>What this exploit does is just sending NSPTCN packet with attempt to establish connection.</p>
<p>After that, Listener sending NSPTRS packet, offering to send the same NSPTCN packet, but to Oracle RDBMS instance.</p>
<p>Exploit send the same NSPTCN packet to Oracle instance and awaits for NSPTAC (accept) packet.</p>
<p>After, exploit send broken NA packet.</p>
<p>(Which is started with DEADBEEF signature).</p>
<p>Actually, exploit sending correct NA packet, but it also contain zero at random byte in it, so it is broken.</p>
<p>Usually, Oracle server raises this error:</p>
<p><i>"TNS-12699: Native service internal error"</i></p>
<p>... and it drops connection.</p>
<p>That's OK.</p>

<p>Exploit establish connection and sending broken NA packet one time per second, eternally.
Note also, 'zero' position is different each time.</p>

<p>For testing, please start Oracle instance and make sure no one made connection to it.
Because, actually, vulnerability is not stable. Or, in other words, I didn't find a away to exploit it stably.</p>

<p>Now run exploit and use victim's hostname as argument.
And wait up to for one hour.</p>

<p>If I'm correct, this is a heap corruption problems.
We can see this in traces:</p>

_PRE_BEGIN
"***** Internal heap ERROR kghfrh:ds addr=07AD0004 ds=0C2973E8 *****"
Heap corruption detected while KGH memory freeing.
_PRE_END

<p>After, as in any software with a lot of allocated memory chunks and broken memory allocating structures, Oracle instance is becoming insance. It may write in "incident" folder reports about very strange things.</p>

<p>If I'm correct (I may not) this problem is related to nsdisc() function in network layer. Oracle instance closes connection uses this function. It frees some memory, but the same chunk of memory is used again for another connection.</p>

<p><a href="//yurichev.com/non-wiki-files/blog/exploits/oracle/CVE-2009-1019.zip">Download PoC and source code.</a></p>

_BLOG_FOOTER_GITHUB(`24')

_BLOG_FOOTER()

