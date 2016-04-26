m4_include(`commons.m4')

_HEADER_HL1(`6-Feb-2010: Oracle RDBMS internal self-testing features')

<p>I never tried any of these events, but these sounds really great.</p>

<p>Got this list from 11g (Linux)...</p>

<pre>
cat oraus.msg | grep simulate

10059, 00000, "simulate error in logfile create/clear"
10066, 00000, "simulate failure to verify file"
10209, 00000, "enable simulated error on control file"
10214, 00000, "simulate write errors on control file"
/  A level of 1-9 simulates write errors on physical blocks 1-9.
10215, 00000, "simulate read errors on control file"
/  No error 10214 will be simulated unless event 10209 is also set to enable
10229, 00000, "simulate I/O error against datafiles"
//          event is set, clients corresponding to the level simulate block
10237, 00000, "simulate ^C (for testing purposes)"
10243, 00000, "simulated error for test %s of K2GTAB latch cleanup"
// *Action: level specifies number of IOs after which an error will be
simulated
10284, 00000, "simulate zero/infinite asynch I/O buffering"
10327, 00000, "simulate ORA-00235 error for testing"
10329, 00000, "simulate out-of-memory error during first pass of recovery"
10331, 00000, "simulate resilvering during recovery"
// *Action: Set this to trigger obj hash table reorg to simulate large
number
10362, 00000, "simulate a write error to take a file offline"
10410, 00000, "trigger simulated communications errors in KSXP"
// *Action:  set this event to simulate communications errors to clients
10413, 00000, "force simulated error for testing purposes"
10414, 00000, "simulated error from event %s level %s"
//               simulates the bitmap index DML of previous releases).
//          simulate a reverse index with columns marked DESC.
14528, 00000, "simulated crash during drop table optimization"
// *Action: The level controls which ASM errors are simulated.
// *Action: The level controls which ASM errors are simulated.
// *Action: The level controls which ASM errors are simulated.
16048, 00000, "enable simulated error on archive log write"
16049, 00000, "simulated error on archive log write"
// *Cause:  I/O error returned for a simulated archival failure during
16077, 00000, "simulate network transmission error"
16141, 00000, "enable simulated archive log error"
16142, 00000, "simulated archive log error"
// *Cause:  Error returned for a simulated archival failure during
16144, 00000, "simulate RFS error while terminal recovery in progress"
16149, 00000, "enable simulated ARCH RAC archival testing"
16158, 00000, "simulated failure during terminal recovery"
16410, 00000, "enable simulated LGWR netslave infinite wait"
// *Cause:  Causes the LGWR to wait indefinitely to simulate network
16418, 0000, "Event to simulate idle RFS process in Physical Standby"
//          to simulate idle RFS process in Physical Standby
19737, 00000, "simulate read-only database connection to execute sql query"
// *Action: event used to simulate site failure for parallel push testing.
26532, 00000, "replication parallel push simulated site failure"
27051, 00000, "I/O error (simulated, not real)"
// *Cause:  this is just a simulated error (not a real one), additional
30011, 00000, "Error simulated: psite=%s, ptype=%s"
33271, 00000, "simulated paging error"
//            and testing phase, to simulate memory pressure conditions.
</pre>

_BLOG_FOOTER_GITHUB(`43')

_BLOG_FOOTER()

