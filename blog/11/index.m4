m4_include(`commons.m4')

_HEADER_HL1(`25-Sep-2008: "Basics of C within the Oracle kernel."')

<p>Very interesting text of unknown origin appeared on <a href="http://www.oraclefans.cn/forum/showtopic.jsp?rootid=3530&CPages=1">some forum</a>, named "Basics of C within the Oracle kernel."</p>
<p>It contains also code snippets from ksl.h and ksl.c. </p>

<pre>Basics of C within the Oracle kernel.
          

C is a function based language and as with most languages is composed of
declarations and statement blocks.

Below is a very simple example and even this example uses 5 functions:

        strcat(),strcpy(),write(),strlen() and print_string().

                ***************

char text_string[100];

print_string()
{
char output_string[100];

strcpy(output_string,"C is a wonderful language"); /* Copy string */

strcat(output_string,text_string);                 /* Concatentate string */

if (write(1,output_string,strlen(output_string))<0)/* Write output */
    return false;
else
    return true;
}

main()
{
  strcpy(text_string," but C++ is better still");

  if (!print_string())
     /* error handling */
     ;
}

An equivalent in pl/sql would be :

declare

text_string     varchar(100);

function print_string return boolean
as
     output_string varchar(100);
   begin
     output_string := 'C is a wonderful language';

     output_string := output_string || text_string;

     dbms_output.put_line(output_string);

     return true;
   end;

begin

   text_string := ' but C++ is better still';

   if (not print_string)
   then
        /* Error handling */
        null;
   end if;

end;

                ***************

Rather than just document the basic C commands , I have taken one
particular kernel module (ksl) and highlighted the most
significant C commands and Oracle coding techniques.

I have avoided adding my own comments to the source files as these would
get lost among the numerous coding comments. Instead I have added markers
against which detailed notes are provided below.

        Header file marker : !!*** H xx ***!!!
        Source file marker : !!*** C xx ***!!!

        Notes to the extract from ksl.h
        ===============================

ksl.h           - Kernel Service Locking.
=====

In general header files are used for the main declarations.

Comments                                !!!*** H 01 ***!!!
--------

As in pl/sql, comments begin with /* and end with */ .

Compile time directives                 !!!*** H 02 ***!!!
-----------------------

Commands which are pre-processed by the compiler start with #.

Conditional compilation                 !!!*** H 02 ***!!!
-----------------------

To conditionally compile code you use the #ifdef / #ifndef directive.

In kernel header files there will be a list of other header files to be
included. The #ifndef is used to prevent a header file being included twice.

Including other source/header files     !!!*** H 02 ***!!!
-----------------------------------

To include header and/or source files you use the compile time
directive #include. Include files can be nested to many levels.

PUBLIC TYPES AND CONSTANTS              !!!*** H 03 ***!!!
--------------------------

All declarations between
        /* PUBLIC TYPES AND CONSTANTS */
    and
        /* PRIVATE TYPES AND CONSTANTS */

are available to other layers within the kernel.

The 'define' preprocessor command       !!!*** H 04 ***!!!
---------------------------------

The define command is used to create macros which are then expanded by the
preprocessor.

This command is used extensively throughout the kernel and its use ranges
from defining maximum values through to complete code segments.

In general if an identifier is in uppercase then it represents a macro.

Function declarations                   !!!*** H 05 ***!!!
---------------------

For ANSI compliance , public functions are declared within the header files.

word     kslget(/*_ struct ksllt *id, word wait _*/);

  where   word  - the datatype of the return value from the function.

          kslget- function name, max 6 characters.

          (/*_ xxx,yyy, _*/)

                - xxx,yyy - arguments for function.

                /*_ _*/   - used by olint to check that this function is
                            being called with the correct number of arguments.

Using defines to represent functions    !!!*** H 06 ***!!!
------------------------------------

It is often the case that functions are replaced by macros , mainly
for performance - inline code is faster than function calls.

Using defines to represent code segments !!!*** H 07 ***!!!
----------------------------------------

Datatypes                                !!!*** H 08 ***!!!
---------

C variables can be simple or complex (records) and either a scalar or an array.

The typedef command is crucial to the understanding of variable declarations.
Throughout the kernel, no reference is ever made to the basic C types such
as int or char. Instead all the C types are 'aliased' via the typedef command.

   e.g.    typedef unsigned int ub4

           ub4 my_integer;

        is equivalent to

           unsigned int my_integer;

The importance of typedef for the C datatypes cannot be overstated - any
developer who used the C datatypes directly would have a very short career.
The cornerstone of portability is the correct use of datatypes.

See oratypes.h for a complete list of the 'aliases' for the C datatypes.

Records                                 !!!*** H 08 ***!!!
-------

In C, records are called structures and are declared with the 'struct'
command.

Refering to struct ksllt:

        ub4           kslltwgt;            Simple variable.
   ...
        struct ksllt *kslltchn;            Pointer to record.
   ...
        ub4           ksllthst[KSLHSTMAX]; Simple variable array.

Pointers and pointers to functions      !!!*** H 09 ***!!!
----------------------------------

For those unfamiliar to C , one of the hardest concepts to grasp is
the notion of pointers.

Instead of declaring a variable and its storage area, you can declare
a variable which points to the memory area where the data is actually
stored. This data could be an integer number, a text string and most
importantly of all a function.

A variable is declared a pointer by prefixing '*' to the identifier name.

The use of pointers and pointers to functions is fundamental not only to
the Oracle kernel but to most software written in C.

Refering to struct   kslld :

        text   *kslldnam;       Pointer to a text string which contains
                                the latch name ( v$latchname ).
     ...
        void  (*kslldcln)(/*_ word action, ksllt *lp _*/);
                                Pointer to a function for latch cleanup.


Notifiers                               !!!*** H 10 ***!!!
---------

Each layer within the kernel has a notifier function used during
instance startup.

Registration defines                    !!!*** H 11 - H 15 ***!!!
--------------------

There are numerous registration defines which are processed by other
kernel modules in order to build a single data structure to represent
information registered by different kernel layers - e.g. init.ora parameters.

  SGA variables                         !!!*** H 11 ***!!!

  PGA variables                         !!!*** H 12 ***!!!

  Events                                !!!*** H 13 ***!!!

  X$ tables                             !!!*** H 14 ***!!!

  init.ora parameters                   !!!*** H 15 ***!!!

Apart from X$ tables, the #define which preceeds the KSP registration is the
one used within the source and not the _ identifier.


        Notes to the extract from ksl.c
        ===============================

ksl.c           - Kernel Service Locking.
=====

Function Definition                             !!!*** C 01 ***!!!
-------------------

A function starts with its name and argument list, followed by a
declaration of the argument types.

Local Variable declarations                     !!!*** C 02 ***!!!
---------------------------

Variables only available within this function.

Variables are in fact declared at the start of a statement block, so
it is possible to have nested declarations.

i.e.  func(a)
      int a;
      {
        int b;


        b=1;
        { int b;
          b=1;
          { int b;
            b=1;
          }
        }
      }

The normal rules of scope apply - inner declarations have precedence
over outer.

Assignments                                     !!!*** C 03 ***!!!
-----------

In C, the assignment operator is =, which is one of the main
causes of coding error as you would normally expect this operator
to represent equality.

Raising internal (600) errors                   !!!*** C 04 ***!!!
-----------------------------

Within the kernel, ora-600 errors are identified by the wrapper
OERI() and are raised by either the ksesic() or ASSERT() functions.

Raising Oracle Errors.
---------------------

Oracle error numbers are identified by the wrapper OER() and are
raised by the ksesec() functions.

The use of the OER() wrapper is not guaranteed within pl/sql.

Checking for Events
-------------------

The ksepec() function is passed one argument, an OER() number, and
returns the current level number. If level number is zero then this
event has not been set.

Bit manipulation                                !!!*** C 05 ***!!!
----------------

Bit functions are used to test,set and clear bits.

        bit()   - test
        bis()   - set
        bic()   - clear.

These functions are in fact macros.

Conditional Evaluation                          !!!*** C 06 ***!!!
----------------------

The control statements such as 'if', 'for' and 'while' have no
equivalent end statement such as 'endif'. They control the execution
of the next statement block.

Pointer referencing                             !!!*** C 07 ***!!!
-------------------

Pointer referencing of structure ( record ) variables is done
with the '->' operator.

Address parameters                              !!!*** C 08 ***!!!
------------------

The '&' operator before a variable passes the address of the
variable to sclgtf() .

Operating System Dependent (OSD) routines       !!!*** C 08 ***!!!
-----------------------------------------

In general osd routines begin with the letter s.

Calling a function via a pointer                !!!*** C 09 ***!!!
--------------------------------

The function call (*kglger)() is an example of calling a
function indirectly. The function actually being called is kslges().

'for' control loop                              !!!*** C 10 ***!!!
------------------

One of the most common control structures used in C.

The 'for' control statement contains an initial expresion,
an evaluation expression and a next iteration expression.

If the evaluation is true then the enclosing statement block
is executed.

i.e. for (i=0;i<10;i++)
       { printf("The value of i is %d\n",i); }


To terminate the loop, you can use the break statement .

To branch back to the control expression, you can use the continue
statement.

Equality operator                               !!!*** C 11 ***!!!
-----------------

The equality operator is '==' and NOT '='.

And / Or operators                              !!!*** C 12 ***!!!
------------------

The 'and' operator is '&&', the 'or' operator '||'.

e.g. pl/sql :  if ( test_value = 10 or ( a = 5 and b = 6 ) )

     becomes in C :

               if ( test_value == 10 || ( a ==5 && b == 6 ))

Output to trace and alert files                 !!!*** C 13 ***!!!
-------------------------------

ksdwrf() function : write to trace file.

ksdwra() function : write to alert file.


                Extract from ksl.h
                ==================

        !!!*** H 01 ***!!!
/*
* $Header: ksl.h,v 1.44.710.5 94/07/07 11:58:37 ksriniva: Exp $ ksl.h
*/


        !!!*** H 02 ***!!!

#ifndef  SE
#include <se.h>
#endif
#ifndef  SC
#include <sc.h>
#endif
#ifndef  SM
#include <sm.h>
#endif
#ifndef  SP
#include <sp.h>
#endif
#ifndef  SLO
#include <slo.h>
#endif
#ifndef  KSM
#include <ksm.h>
#endif
#ifndef  KGSL
#include <kgsl.h>
#endif
#ifndef  KQF
#include <kqf.h>
#endif
#ifndef KSP
#include <ksp.h>
#endif
#ifndef  KSD
#include <ksd.h>
#endif
#ifndef  KSE
#include <kse.h>
#endif
#ifndef KVI
#include <kvi.h>
#endif

#ifndef  KSL


#define  KSL

/***********/
/* LATCHES */
/***********/

/* Set KSLDEBUG to debug systems that hang waiting for latches that no one
* is holding.  This can happen if someone does a fast latch get and then
* exits the block and gets another latch.
*/
/* #define KSLDEBUG 1 */

#ifdef KSLDEBUG
#  define KSLDBG(exp) exp
#else
#  define KSLDBG(exp)
#endif



/* A latch is a type  of  lock that can be  very quickly acquired and freed.
* Latches are  typically used to    prevent  more   than one process   from
* executing the same  piece of  code at  a given time.  Contrast  this with
* enqueues  which  are usually  used to prevent  more than one process from
* accessing the same data structure at a given  time.  Associated with each
* latch is a cleanup procedure that will be called if a process  dies while
* holding  the latch.  Latches  have an  associated level  that  is used to
* prevent deadlocks.  Once a process acquires a latch at a certain level it
* cannot subsequently acquire a latch at a  level that is equal to  or less
* than that level (unless it acquires it nowait).
*/


        !!!*** H 03 ***!!!

/* PUBLIC TYPES AND CONSTANTS */

        !!!*** H 04 ***!!!

#define KSLMXLATCH 60 K_MLSIF(+6)
  /** maximum number of latches.  To increase, just                         **
   ** change, recompile ksmp.c and ksl.c.  This could be eliminated, but it **
   ** doesn't seem worth the extra code.                                    */

/* the pointer to the latch object (ksllt) is public */

/* PUBLIC PROCEDURES */

        !!!*** H 05 ***!!!

word     kslget(/*_ struct ksllt *id, word wait _*/);
   /*
   ** Get the latch specified by "id",  on  behalf  of  the  current
   ** session.  If "wait" is FALSE, return immediately if the  latch
   ** is in use; if TRUE, keep trying and return when the latch  has
   ** been granted.  Return TRUE  if  and  only  if  the  latch  was
   ** granted. 
   **
   ** In order to   prevent deadlocks,   this procedure checks   for
   ** errors in latch   sequence based on  level.   Once  a  process
   ** acquires a latch at a certain level it  cannot acquire another
   ** latch at  a level less  than or equal to  that level.  There are
   ** two exceptions to this rule.  One, a process may acquire a latch
   ** at any level if it has not acquired a latch at that level and
   ** it acquires the latch nowait.   Two, a process may acquire
   ** exactly one duplicate latch (latch at the same level as another
   ** latch) if it acquires it nowait.
   **
   ** This routine will  raise an error if  called  during  cleanup,
   ** with "wait" equal to TRUE, and the latch is busy.  This is so
   ** PMON does not get stuck acquiring a latch.
   */

        !!!*** H 06 ***!!!

/* word kslgetd(struct ksllt *lt, word wait, CONST char *comment); */
#define kslgetd(lt, wait, comment) ((kslcmt = (comment)), kslget((lt), (wait)))
   /*
   ** NEW: kslgetd() is the new debugging version of kslget().  It takes
   ** an additional comment string as an argument.  If the latch trace
   ** event (currently event # 10005) is turned on, this comment is
   ** associated with the latch.  If a latch hierarchy error occurs later
   ** on while this latch is still held, the latch dump routines will also
   ** print the relevant comment strings.
   ** Warning: the comment string must persist for the lifetime of the PGA;
   ** ideally, it should be a literal constant.
   */


void     kslfre(/*_ struct ksllt *id _*/);
   /*
   ** Free the latch specified by "id", on  behalf  of  the  current
   ** session.
   */

/* void kslfred(struct ksllt *lt, CONST char *comment); */
#define kslfred(lt, comment) ((kslcmt = (comment)), kslfre((lt)))
   /*
   ** NEW: kslfred() is the new debugging version of kslfre().  It takes
   ** an additional comment string as an argument.  If the latch trace
   ** event (currently event # 10005) is turned on, this comment is
   ** associated with the latch.  If a later attempt is made to free this
   ** latch before it is gotten again, the latch dump routines will also
   ** print the relevant comment strings.
   ** Warning: the comment string must persist for the lifetime of the PGA;
   ** ideally, it should be a literal constant.
   */


/* Fast latching macros.  These macros can be used to very quickly get and
* free a latch. The KSLBEGIN macro gets the latch (in wait mode) and the
* KSLEND macro frees the latch.  The code in between the two macros executes
* with the latch held.
*
* The code between the KSLBEGIN and KSLFREE may not non-locally exit (return,
* break, continue). However, it may signal an error.  Between the KSLBEGIN and
* the KSLEND you may not get or free another latch. (however, see KSLUPGRD).
*
* WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
* If you need to use an ONERROR block in the protected code, don't use the
* fast latching macros!  Just use the regular kslget/kslfre mechanism.
*
* Example usage:
*
*   void foo()
*   {
*     KSLBEGIN(foolatch)                 /0 get the latch 0/
*       protected_code;
*       more_protected_code;
*     KSLEND                             /0 free the latch 0/
*   }
*/

        !!!*** H 07 ***!!!

#define KSLBEGIN(atmlatch)\
if (1)\
{\
  reg ksllt *atmlat = (atmlatch);\
  reg kslla *atmsta = ksuglk(ksugcp());\
  serc atmse;\
  if (bit(atmsta->ksllalow, ksllvl.ksllvbits[atmlat->kslltlvl]) \
      KSLDBG(|| atmsta->ksllalaq))\
    DISCARD kslget(atmlat, 1);\
  atmsta->ksllalaq = atmlat;\
  if (sclgtf(&atmlat->kslltlat))\
  { \
    atmlat->kslltwgt++;\
    kslprrc(atmlat, TRUE);\
  } \
  else DISCARD kslges(atmlat, 1);

#define KSLEND \
  if (!sclfr(&atmse, &atmlat->kslltlat)) kslferr(&atmse);\
  kslprrc(atmlat, FALSE); \
  atmsta->ksllalaq = (ksllt *)0;\
} else DISCARD(0);



/* KSLUPGRD upgrades the state of a latch gotten using KSLBEGIN to be
* the same as the state of a latch gotten using kslget.  This allows the
* latch to be freed using kslfre and it allows another latch to be gotten.
* If a latch is upgraded it cannot be freed using KSLEND unless the latch is
* first downgraded using KSLDNGRD.  KSLUPGRD and KSLDNGRD can only be
* invoked in the code that is textually between the KSLBEGIN and KSLEND.
* N.B. KSLUPGRD cannot be used on latches gotten using KSLNBEGIN.
*/

#define KSLUPGRD \
if (1)\
{\
   if (0 KSLDBG(|| atmsta->ksllalaq != atmlat))\
     ksesic0(OERI(501));\
   bis(atmsta->ksllalow, 1 << atmlat->kslltlvl);\
   atmsta->ksllalat[atmlat->kslltlvl] = atmlat;\
   atmlat->kslltefd = kgetfd(ksmgpga);\
   KSLDBG(atmsta->ksllalaq = (ksllt *)0;)\
} else DISCARD(0)\

#define KSLDNGRD \
if (1)\
{\
   if (0 KSLDBG(|| atmsta->ksllalat[atmlat->kslltlvl] != atmlat))\
     ksesic0(OERI(502));\
   atmsta->ksllalaq = atmlat;\
   bic(atmsta->ksllalow, 1 << atmlat->kslltlvl);\
   atmsta->ksllalat[atmlat->kslltlvl] = (ksllt *)0;\
} else DISCARD(0)\


        _______________   CODE removed __________________

/* PRIVATE TYPES AND CONSTANTS */


/* Maximum  latch level.  Note that   the  level immediately above this is
* reserved for getting a duplicate latch (in nowait mode).
*/
#define  KSLLMXLV 8                   /* maximum value for kslldlev in kslld */
                /* NOTE: ksllalow and ksl.c need to change if KSLLMXLV >= 14 */
                      /* also the levelbits in kslget need to change as well */

struct ksllvlt                             /* level bits, used by get macros */
{
  BITS16 ksllvbits[KSLLMXLV+2];
};
typedef struct ksllvlt ksllvlt;


/* get latch slow, called by latch get macros */
word kslges(/*_ struct ksllt *l, eword from_macro _*/);

/* latch free error, called by latch get macros */
void kslferr(/*_ serc *se _*/);


/* Latch instance.  The  latch instance is  the actual  unit of locking  (it
* contains the OSD latch structure). 
*
* There can be more than one latch with the same name (if they are allocated
* dynamically).  In this case there is one master latch allocated statically
* called the parent latch and a number of dynamically allocated latches
* called the child latches.  The latches are chained together to
* facilitate statistics gathering.
*/

        !!!*** H 08 ***!!!

struct ksllt
{

   sclt          kslltlat;                            /* OSD latch structure */

   eword         kslltefd; /* error frame depth when gotten, this is used to */
          /* free the latch if an error is signalled while the latch is held */

   ub4           kslltngt;                  /* count  of times gotten nowait */
   ub4           kslltnfa;               /* count of times failed nowait get */

   ub4           kslltwgt;                     /* count of times gotten wait */
   ub4           kslltwff;       /* count of wait gets that failed first try */
   ub4           kslltwsl;  /* count of times slept when failed to get latch */

   struct ksllt *kslltchn;          /* ptr to next child latch of this chain */
   eword         kslltlvl;              /* latch level, to enforce hierarchy */
   b1            kslltnum;             /* latch number, to index descriptors */

   struct kslla *kslltwkp;   /* process that is sleeping and should be woken */
   /* this is a hint, the system will work though slower if this is not done */

   ub4           kslltwkc;           /* count of wakeups that have been done */

   ub4           kslltwth;/* count of sleeps that were holding another latch */

#define KSLHSTMAX 12             /* if you change this, must change x$ table */
   ub4           ksllthst[KSLHSTMAX];
   /* Histogram of max exponential backoff per miss. The actual sleep time
    * corresponding to each bucket in the histogram is about
    * 2**((bucket+1)/2)-1 plus the sleep time of all the lower buckets.
    * All max exponential backoffs greater than the highest bucket are
    * added to the highest bucket.
    */
   dvoid        *kslltrec;                   /* recovery info for this latch */
};
typedef struct ksllt ksllt;


        !!!*** H 09 ***!!!

/* Latch descriptor.  An array of these is allocated in the  PGA.  The array
* contains  a latch  descriptor for  every  latch.  The  latch   descriptor
* contains    static information about that    latch (such  as  the cleanup
* procedure for the latch) that cannot be pointed at from the SGA  (because
* it is allocated in each process).  It is found using the latch number.
*/
struct   kslld
{
   text   *kslldnam;                            /* human-readable latch name */
   void  (*kslldcln)(/*_ word action, ksllt *lp _*/);        /* cleanup proc */
   void  (*kslldgcl)(/*_ kgsmp *gp, word action, struct kgslt *lp _*/);
                        /* cleanup procedure for a generic component's latch */
   size_t  kslldrsz;                              /* recovery structure size */
   b1      kslldlvl;                                          /* latch level */
   b1      kslldpnt;                 /* TRUE if parent of a class of latches */
   ub1     kslldlng;           /* TRUE if latch can be held for long periods */
};
typedef  struct  kslld kslld;

#define KSLLDMNAM 50                           /* max size of the name field */

typedef  ksllt  *kslltb[KSLMXLATCH];      /* for pga latch table declaration */
externref        CONST_W_PTR kslld kslldt[];   /* table of latch descriptors */
void     kslenl(/*_ void (*enumpr)(ksllt *l, ptr_t ctx), ptr_t ctx _*/);
                                                            /* enumerate all */

typedef bitvec ksllbv[BITVEC(KSLMXLATCH)];            /* latch number bitvec */

/* initialize recovery structures for latches */
void kslirs(/*_ void _*/);

void     ksldlt(/*_ word level _*/ );                         /* latch trace */

/* latch debugging: various bit values for the PGA variable ksldbg */
#define KSLDBGTRC 0x1                           /* trace latching operations */
#define KSLDBGPRT 0x2                    /* protect/unprotect recovery areas */

/*******************/
/* WAIT/POST/EVENT */
/*******************/

/* PUBLIC PROCEDURES */

word    kslaer(/*_ word nevent _*/);
  /*
  ** KSLAER: Allocate event range.  Allocate (permanently)
  ** nevent events, return base.
  ** Callable during or after KSCNISGA,  NOT latched.
  */


        _______________   CODE removed __________________

/*********************/
/* misc. definitions */
/*********************/

        !!!*** H 10 ***!!!

void kslnfy(/*_ word nfytype, ptr_t ctx _*/);                    /* notifier */

/* fixed table callback routine */
dvoid *ksltbl(/*_ CONST struct kqfco *cd, COLID ncols, ptr_t ctx, kghds *heap,
                  bitvec *whichcols, word msg, word (*rf)(ptr_t row) _*/);

/* fixed table callback for latch name */
size_t kslgnm(/*_ uword index, ptr_t space _*/);

#endif                                                                /* KSL */

/* register notifier proc */
KSCNTBDV(FADDR(kslnfy), (1<<KSCNISGA)|(1<<KSCNASGA))

/* number of latches as SGA variable */
#define kslltl KVIISDN(kslltl_)
KVIISDV(kslltl_, "kslltl", "number of latches")

/* latch table for display program */
#define kslltt KSMSGADN(kslltb, kslltt_)
KSMSGADV(kslltb, kslltt_)

#define kslerb KVIISDN(kslerb_)                          /* event range base */
KVIISDV(kslerb_, "kslerb", "event range base")

#define kslnbe KVIISDN(kslnbe_)                          /* # of base events */
KVIISDV(kslnbe_, "kslnbe", "# of base events")

        !!!*** H 11 ***!!!

/* event statistics array: 1 for the system + 1 per session */
#define kslesa KSMSGADN(ksles *, kslesa_)
KSMSGADV(ksles *, kslesa_)

/* level bits for macros to use */
#define ksllvl KSMSGADN(ksllvlt, ksllvl_)
KSMSGADV(ksllvlt, ksllvl_)

/* number of CPUs in the system */
#define kslcpu KVIISDN(kslcpu_)
KVIISDV(kslcpu_, "kslcpu", "number of CPUs in the system")


#ifndef SYS_SNGL
#define kslrov KSMPGADN(kslrov_)                     /* pga rover for kslpse */
KSMPGADV(struct ksupr *, kslrov_)
#endif                                                           /* SYS_SNGL */

        !!!*** H 12 ***!!!

#define kslbwt KSMPGADN(kslbwt_)     /* beginning time of current wait event */
KSMPGADV(ub4, kslbwt_)

#define ksllsp KSMPGADN(ksllsp_)             /* last wait resulted in post ? */
KSMPGADV(word, ksllsp_)

#define ksltri KSMPGADN(ksltri_)                   /* trace info for latches */
KSMPGADV(struct ksltr *, ksltri_)

#define ksldbg KSMPGADN(ksldbg_)                /* latch debugging enabled ? */
KSMPGADV(ub1, ksldbg_)

#define kslcmt KSMPGADN(kslcmt_)                          /* tracing comment */
KSMPGADV(CONST char *, kslcmt_)

        !!!*** H 13 ***!!!

/* latch activity event */
#define ksllae KSLEVTDN(ksllae_)
KSLEVTDV3(ksllae_, "latch activity", "address", "number", "process#")

/* latch free event */
#define ksllfe KSLEVTDN(ksllfe_)
KSLEVTDV3(ksllfe_, "latch free", "address", "number", "tries")

/* TRACES */
KSDTRADV("LATCHES", FADDR(ksldlt))                             /* latch dump */

KSDEVCBF(OER(10005), FADDR(kslcbf))                      /* latch op tracing */

KSDEVCBF(OER(10072), FADDR(kslrpc))      /* latch recovery memory protection */

/* session initialization */
KSMUGIFR(FADDR(kslies))

        !!!*** H 14 ***!!!

/* fixed tables */
/* latch objects */
KQFTABC(ksllt, ksllt_c,  "X$KSLLT", ksltbl, sizeof(ksllt ***), KQFOB081, 5)
KQFCINT(ksllt, kslltnum,  "KSLLTNUM")
KQFCINT(ksllt, kslltlvl,  "KSLLTLVL")
KQFCFST(ksllt, "KSLLTNAM", KSLLDMNAM, kslgnm, kslgnm_n)
KQFCINT(ksllt, kslltngt,  "KSLLTNGT")
KQFCINT(ksllt, kslltnfa,  "KSLLTNFA")
KQFCINT(ksllt, kslltwgt,  "KSLLTWGT")
KQFCINT(ksllt, kslltwff,  "KSLLTWFF")
KQFCINT(ksllt, kslltwkc,  "KSLLTWKC")
KQFCINT(ksllt, kslltwsl,  "KSLLTWSL")
KQFCINT(ksllt, kslltwth,  "KSLLTWTH")
KQFCINT(ksllt, ksllthst[0], "KSLLTHST0")
KQFCINT(ksllt, ksllthst[1], "KSLLTHST1")
KQFCINT(ksllt, ksllthst[2], "KSLLTHST2")
KQFCINT(ksllt, ksllthst[3], "KSLLTHST3")
KQFCINT(ksllt, ksllthst[4], "KSLLTHST4")
KQFCINT(ksllt, ksllthst[5], "KSLLTHST5")
KQFCINT(ksllt, ksllthst[6], "KSLLTHST6")
KQFCINT(ksllt, ksllthst[7], "KSLLTHST7")
KQFCINT(ksllt, ksllthst[8], "KSLLTHST8")
KQFCINT(ksllt, ksllthst[9], "KSLLTHST9")
KQFCINT(ksllt, ksllthst[10], "KSLLTHST10")
KQFCINT(ksllt, ksllthst[11], "KSLLTHST11")
KQFENDT(ksllt)

/* latch descriptor */
KQFTABL(kslld, kslld_c, "X$KSLLD", kslldt, kslltl, KQFOB082, 1)
KQFCSTP(kslld, kslldnam, "KSLLDNAM")
KQFENDT(kslld)

/* event descriptors */
KQFTABL(ksled, ksled_c, "X$KSLED", ksledt, kslnbe + 1, KQFOB182, 1)
KQFCSTP(ksled, kslednam, "KSLEDNAM")
KQFCSTP(ksled, ksledp1, "KSLEDP1")
KQFCSTP(ksled, ksledp2, "KSLEDP2")
KQFCSTP(ksled, ksledp3, "KSLEDP3")
KQFENDT(ksled)

/* event statistics for all sessions */
KQFTABL(ksles, ksles_c, "X$KSLES", &kslesa[kslnbe + 1],
        ((kslnbe + 1) * ksusga.ksusgsel), KQFOB183, 2)
KQFCFIN(ksles, "KSLESSID", FADDR(kslgse), kslgse_n)
KQFCFIN(ksles, "KSLESENM", FADDR(kslgne), kslgne_n)
KQFCUIN(ksles, ksleswts, "KSLESWTS")
KQFCUIN(ksles, kslestmo, "KSLESTMO")
KQFCUIN(ksles, kslestim, "KSLESTIM")
KQFENDT(ksles)

/* instance-wide event statistics */
KQFTABL(ksles, kslei_c, "X$KSLEI", kslesa, (kslnbe + 1), KQFOB190, 2)
KQFCFIN(ksles, "KSLESWTS", FADDR(kslgwe), kslgwe_n)
KQFCFIN(ksles, "KSLESTMO", FADDR(kslgto), kslgto_n)
KQFCFIN(ksles, "KSLESTIM", FADDR(kslgte), kslgte_n)
KQFENDT(ksles)


        !!!*** H 15 ****!!!

/* spin count when fail to get latch */
#define kslspc KSPPARDN(kslspc_)
KSPPARDV("_latch_spin_count", kslspc_, kslspc_s, kslspc_l, kslspc_p,
         LCCMDINT, 0, NULLP(text), 100, KSPLS1(NULLP(text)),
         KSPLS2(1, EWORDMAXVAL), 0, KSPLS1(NULLP(word)),
         "amount to spin waiting for a latch")

/* holds value of kslspc */
#define kslspi KSMSGADN(eword, kslspi_)
KSMSGADV(eword, kslspi_)


/* max amount to sleep when waiting for a latch and holding another */
#define kslmxs KSPPARDN(kslmxs_)
KSPPARDV("_max_sleep_holding_latch", kslmxs_, kslmxs_s, kslmxs_l, kslmxs_p,
         LCCMDINT, 0, NULLP(text), 4, KSPLS1(NULLP(text)),
         KSPLS2(0, EWORDMAXVAL), 0, KSPLS1(NULLP(word)),
         "max time to sleep while holding a latch")

/* holds value of kslmxs */
#define kslmsl KSMSGADN(eword, kslmsl_)
KSMSGADV(eword, kslmsl_)


/* maximum sleep during any exponential backoff in hundreths of seconds */
#define kslmes KSPPARDN(kslmes_)
KSPPARDV("_max_exponential_sleep", kslmes_, kslmes_s, kslmes_l, kslmes_p,
         LCCMDINT, 0, NULLP(text), 0, KSPLS1(NULLP(text)),
         KSPLS2(0, EWORDMAXVAL), 0, KSPLS1(NULLP(word)),
         "max sleep during exponential backoff")

/* holds value of kslmes */
#define kslmex KSMSGADN(eword, kslmex_)
KSMSGADV(eword, kslmex_)


/* if this is 1 then we use the post waiters protocol for latches that
* are declared KSLLALNG, if it is greater than one we use it for all
* latches.
*/
#define kslpsw KSPPARDN(kslpsw_)
KSPPARDV("_latch_wait_posting", kslpsw_, kslpsw_s, kslpsw_l, kslpsw_p,
         LCCMDINT, 0, NULLP(text), 1, KSPLS1(NULLP(text)),
         KSPLS2(0, EWORDMAXVAL), 0, KSPLS1(NULLP(word)),
         "post sleeping processes when free latch")

/* holds value of kslpsw */
#define kslpwt KSMSGADN(eword, kslpwt_)
KSMSGADV(eword, kslpwt_)

/* latch recovery alignment parameter:
* specifies a list of latch numbers for which recovery alignment is enabled.
* valid numbers are [0...max_latches); if any number in the list is outside
* the range, then it is ignored (note that the default value is KSLMXLATCH
* - not 0 -, which causes no alignment to be enabled).  If any number in the
* list is "999", then recovery alignment is enabled for ALL latches which are
* defined through one of the new compile-time service macros KSLLTDV2 or
* KGSLLDV2.  Use the "LATCH#" column in V$LATCH to get latch numbers.
*/
#define kslrpp KSPPARDN(kslrpp_)
KSPPARDV("_latch_recovery_alignment", kslrpp_, kslrpp_s, kslrpp_l, kslrpp_p,
         LCCMDINT, 0, NULLP(text), KSLMXLATCH, KSPLS1(NULLP(text)),
         KSPLS2(0, EWORDMAXVAL), 0, KSPLS1(NULLP(word)),
         "align latch recovery structures")

/* holds value of kslrpp converted to a bitvec */
#define kslrpv KSMSGADN(ksllbv, kslrpv_)
KSMSGADV(ksllbv, kslrpv_)

/* latch that synchronizes latch wait list */
#define kslwlst KSLLATDN(kslwlst_)            
KSLLATDV(kslwlst_, "latch wait list", FADDR(ksllcu), KSLLMXLV+1)


                Extract from ksl.c
                ==================

/*
** Get the latch specified by "id", on behalf  of  the  current
** session.  If "wait" is  FALSE,  return  immediately  if  the
** latch is in use; if TRUE, keep trying and  return  when  the
** latch has been granted.  Return TRUE  if  and  only  if  the
** latch was granted.  Raise an error if this is cleanup,  wait
** is TRUE, and the latch is busy.  This procedure  checks  for
** errors in latch sequence (based on level), and records  what
** latches are held so they can be freed if needed.
*/
                !!!*** C 01 ***!!!

word         kslget(l, wait)                                  /* get a latch */
reg0 ksllt  *l;                                     /* latch we are latching */
     word    wait;                          /* wait for latch or just return */
{
                !!!*** C 02 ***!!!

  reg1 kslla   *state;                                        /* latch state */
  reg2 word     level;                                     /* latching level */

  /* initialize */
                !!!*** C 03 ***!!!

  state = ksuglk(ksugcp());                    /* get process latching state */
  level = l->kslltlvl;                                 /* get level of latch */

#ifdef KSLDEBUG
  /* if currently hold a fast latch, cannot get another latch */
                !!!*** C 04 ***!!!

  if (state->ksllalaq)
    ksesic2(OERI(503), ksenrg(state->ksllalaq),
            ksesrgl((text *)kslldt[state->ksllalaq->kslltnum].kslldnam));
#endif

  /* Enforce latch hirearchy to prevent deadlocks.
   * Check if a latch is already held at this level or any higher level.
   */
                !!!*** C 05 ***!!!

  if (bit(state->ksllalow, levelbits[level]))
  {
                !!!*** C 06 ***!!!

    if (!wait)
    {
                !!!*** C 07 ***!!!

      if (!state->ksllalat[level])          /* no latch gotten at this level */
        ;                                    /* allow nowait get to proceded */
      /* allow one duplicate get at a level if it is gotten nowait */
      else if (state->ksllalat[level] != l && !state->ksllalat[KSLLMXLV+1])
        level = KSLLMXLV+1;     /* use the slot that is one past the highest */
      else                            /* never signal conflict on nowait get */
        return FALSE;
    }
    else
      ksesic4(
        OERI(504),               /* kslget: failure to follow lock hierarchy */
        ksenrg(l), ksenrg(state->ksllalow),
        ksenrg(level), ksesrgl((text *)kslldt[l->kslltnum].kslldnam));
  }

  /* set "we are waiting for the latch" and go try to get it */
  state->ksllalaq = l;

  /* Do a fast try to get the latch */

                !!!*** C 08 ***!!!

  if (sclgtf(&l->kslltlat))           /* do the test and set (or equivalent) */
  {
    /* Got the latch on first try */
    bis(state->ksllalow, 1 << level);    /* set level bit for level checking */
    state->ksllalat[level] = l;       /* indicate latch gotten at this level */
    l->kslltefd = kgetfd(ksmgpga);   /* error frame depth for error recovery */

    /* Note that the number of latch gets is used during cleanup (it is not
     *  just for statistics).  So don't delete this code.
     */
    if (wait)
      l->kslltwgt++;                                       /* bump wait gets */
    else
      l->kslltngt++;                                     /* bump nowait gets */

    KSLDBG(state->ksllalaq = (ksllt *)0;)

    /* check if latch debugging is turned on */
    if (ksldbg)
    {
      /* set trace info if appropriate */
      kslsgtr(l, kslcmt);

      /* unprotect the latch's recovery structure if necessary */
      kslprrc(l, TRUE);
    }

    return TRUE;                                           /* return success */
  }
  else if (!wait)     /* if failed to get the latch and not supposed to wait */
  {
    /* Bump nowait attempts. This increment is not protected by the latch,
     * so it may be lost or garbled if several processes do this at the same
     * time.
     */
    l->kslltnfa++;                                        /* nowait failures */
    state->ksllalaq = (ksllt *)0;            /* not trying to get it anymore */
    return FALSE;
  }

  /* Someone else has the latch, we must wait for it.  Call kslges indirectly
   * so the compiler will not inline the routine (this causes many registers
   * to be saved unnecessarily).
   */  
                !!!*** C 09 ***!!!

  return (*kslger)(l, FALSE);
}


/* remove myself from list of waiter processes on a latch. */
STATICF void kslwrmv(state)
reg0 kslla *state;
{
  reg1 kslla  *wait_proc;
  reg2 kslla **proc_link;

  /* walk list of processes waiting for this latch */

                !!!*** C 10 ***!!!

  for (wait_proc = state->ksllawtr->kslltwkp,
       proc_link = &state->ksllawtr->kslltwkp;
       wait_proc;
       proc_link = &wait_proc->ksllanxw, wait_proc = *proc_link)

                !!!*** C 11 ***!!!

    if (wait_proc == state)                 /* if waiter is me */
    {
      *proc_link = state->ksllanxw;                  /* pop myself from list */
      break;
    }

  /* Note that if I was previously killed while linking or unlinking myself
   * from a wait list, I might never have made it on the list, but I would
   * still have my state set as if I did.  We always link on the the waiter
   * list last when adding to the wait list, and unlink first when removing
   * from the wait list.  Therefore I need to clear my state whether I am on
   * the list or not to cleanup from process death.
   */
  state->ksllanxw = (kslla *)0;                            /* no next waiter */
  state->ksllawtr = (ksllt *)0;           /* not on wait list for this latch */
}


/* Second part of kslget.   We failed to get  the latch on the  first try so
* now we have to wait for it.
*/
word  kslges(l, from_macro)
reg0 ksllt   *l;                                    /* latch we are latching */
eword from_macro;                        /* true if called from kslatm macro */
{
  ub4    i;                                                  /* miss counter */

  reg1 kslla   *state;                                        /* latch state */
  reg2 word     level;                                     /* latching level */
  reg3 eword    max_backoff = kslmex;        /* Let's initialize this, okay? */
       eword    other_latch = FALSE;

  /* initialize */
  state = ksuglk(ksugcp());                    /* get process latching state */
  level = l->kslltlvl;                                 /* get level of latch */

  /* Don't sleep too long if currently holding a latch since this will tend to
   * backup the people waiting for me.  This does not apply if the latch is
   * an allocated child latch since there are lots of those.
   */
  if (state->ksllalow)                       /* if currently holding a latch */
  {
    for (i = 0; i <= level; i++)             /* for all latches I am holding */
      if (state->ksllalat[i] &&
          !state->ksllalat[i]->kslltchn)       /* if holding non-child latch */
      {
        max_backoff = kslmsl;            /* set max backoff to smaller value */
        other_latch = TRUE;          /* remember we're holding another latch */
        break;
      }
  }

  /* keep trying to get the latch until we succeed */
  for (i = 0; ; i++)
  {
    serc   se;

    /* set "we are waiting for the latch" and go get it */
    state->ksllalaq = l;

    /* try to get the latch again */
    if (sclgts(&se, &l->kslltlat,                        /* the latch to get */
               ksugpi(ksugcp()),                /* the OSD process structure */
               &state->ksllalaq,       /* pointer to latch trying to acquire */
               ksuicl()))                        /* am I the cleanup process */
    {
      l->kslltwgt++;                             /* bump wait gets statistic */
      l->kslltwff++;                  /* bump failed first attempt statistic */
      l->kslltwsl += i;                        /* increment sleeps statistic */
      if (state->ksllalow) l->kslltwth++;  /* increment sleeps holding latch */

      /* increment histogram of wait times */
      if (i >= KSLHSTMAX)
        l->ksllthst[KSLHSTMAX-1]++;
      else l->ksllthst[i]++;     

      if (!from_macro)       /* don't set these if called by fast path macro */
      {
        bis(state->ksllalow, 1 << level);/* set level bit for level checking */
        state->ksllalat[level] = l;   /* indicate latch gotten at this level */

        KSLDBG(state->ksllalaq = (ksllt *)0;)
      }

      l->kslltefd = kgetfd(ksmgpga); /* error frame depth for error recovery */

      /* check if latch debugging is turned on */
      if (ksldbg)
      {
        /* set trace info if appropriate */
        kslsgtr(l, kslcmt);

        /* unprotect the latch's recovery structure if necessary */
        kslprrc(l, TRUE);
      }

      return TRUE;
    }
    else
    {
      /* We did not get the latch, someone else must have it.  We must wait */
      state->ksllalaq = (ksllt *)0;       /* we are not trying to get it now */

      if (SERC_ERROR(se))           /* if something went wrong, signal error */
      {
        (*ksloet)();                                     /* Dump useful info */
        DISCARD ksecrs(&se);                            /* record error code */
        ksesic0(OERI(506));
      }

      if (i == 5 && !ksuicl()) /* if waited for a few hundreth's of a second */
        ksupsx();           /* post cleanup in case dead process holds latch */

      /* if should use post waiters option to latching */

                !!!*** C 12 ***!!!

      if (   kslpwt                                    /* waiting is enabled */
          && l != kslwlst           /* not waiting for the waiter list latch */
          && !from_macro         /* not from macro, macros don't call kslfre */
          && (i == 0 ||                           /* first time through loop */
              !state->ksllawtr)    /* someone woke me but I didn't get latch */
          && !state->ksllalat[kslwlst->kslltlvl]    /* no out of order latch */
          && (kslpwt > 1 ||               /* waiting enabled for all latches */
              kslldt[l->kslltnum].kslldlng))       /* this is a 'long' latch */
      {
        /* Add myself to the head of the waiter list. */
        KSLBEGIN(kslwlst)                     /* get latch waiter list latch */
          /* If I am still on waiter list of a latch that I am holding I need
           * to get off that list before going on another waiter list.  Note
           * that I don't normally take myself off a waiter list until I free
           * the latch to avoid adding extra code path under the latch that
           * people are waiting for.  This is why I could be on a waiter list
           * while I am holding the latch.
           */
          if (state->ksllawtr)              /* if on waiter list for a latch */
            kslwrmv(state);                      /* take myself off the list */

          state->ksllawtr = l;      /* latch whose waiter list I am going on */

          /* give preference to waiters that are holding another latch */
          if (l->kslltwkp                 /* if someone already on wait list */
              && !other_latch)               /* and I am not holding a latch */
          {
            /* put myself in second slot of wait list in case the person in
             * the first slot is holding a latch.  This gives him precedence.
             */

            /* people after first guy are now after me */
            state->ksllanxw = l->kslltwkp->ksllanxw;
            l->kslltwkp->ksllanxw = state;           /* I am after first guy */
          }
          else
          {
            /* put myself at the head of the waiter list */
            state->ksllanxw = l->kslltwkp;     /* head of list goes after me */
            l->kslltwkp = state;                     /* I go at head of list */
          }
        KSLEND                                  /* remember I am on the list */
      }

      state->ksllawat = l;                   /* set latch we are waiting for */

      /* do exponential backoff */
      kslewt3(i, max_backoff, (state->ksllawtr ? TRUE : FALSE),
              ksllfe, l, l->kslltnum, i);

      state->ksllawat = (ksllt *)0;        /* clear latch we are waiting for */

      ksucfi();  /* Check for any interrupts which are fatal to the instance */

      ksecss(&se);                                        /* check for error */

      if (i > 7 && ksuicl())               /* if PMON and waited long enough */
      {
        /* PMON has not been able to get the latch.  The latch might be held
         * by a dead process so search for dead processes, and free their
         * latches.  When freeing dead processes latches, PMON must only free
         * latches that have a higher level than the highest level latch he
         * is currently holding since freeing a latch can cause another
         * latch to be gotten which could lead to a conflict with the latches
         * PMON already holds.
         */
        DISCARD ksuxfl();                      /* free dead process' latches */

                !!!*** C 13 ***!!!

        if (i == 200)                           /* if waited for a long time */
        {
          ksupr *pr = kslown(l);             /* process that holds the latch */
          ksdwrf("PMON unable to acquire latch %lx %s\n", (unsigned long)l,
                 (char *)kslldt[l->kslltnum].kslldnam);
          if (pr)
            ksdwrf("  possible holder pid = %d ospid=%.*s\n", (int)ksuprp(pr),
                   (int)ksugpri(pr)->ksuospdl, (char *)ksugpri(pr)->ksuospid);
          ksdddt();                                      /* write time stamp */
          ksdfls();                                       /* flush dump file */
          ksdwra("PMON failed to acquire latch, see PMON dump");
        }
      }
    }
  }
}


                oratypes.h
                ==========

/* /v71/d2/713/oracore/public/sx.h */


/*
ORACLE, Copyright (c) 1982, 1983, 1986, 1990 ORACLE Corporation
ORACLE Utilities, Copyright (c) 1981, 1982, 1983, 1986, 1990, 1991 ORACLE Corp

Restricted Rights
This program is an unpublished work under the Copyright Act of the
United States and is subject to the terms and conditions stated in
your  license  agreement  with  ORACORP  including  retrictions on
use, duplication, and disclosure.

Certain uncopyrighted ideas and concepts are also contained herein.
These are trade secrets of ORACORP and cannot be  used  except  in
accordance with the written permission of ORACLE Corporation.
*/


/* $Header: sx.h 7.18 94/04/05 18:34:34 tswang Osd<unix> $ */








#ifndef ORASTDDEF
# include <stddef.h>
# define ORASTDDEF
#endif

#ifndef ORALIMITS
# include <limits.h>
# define ORALIMITS
#endif

#ifndef  SX_ORACLE
#define  SX_ORACLE
#define  SX
#define  ORATYPES


#ifndef TRUE
# define TRUE  1
# define FALSE 0
#endif



#ifdef lint
# ifndef mips
#  define signed
# endif
#endif

#ifdef ENCORE_88K
# ifndef signed
#  define signed
# endif
#endif

#ifdef SYSV_386
# ifndef signed
#  define signed
# endif
#endif





#ifndef lint
typedef          int eword;                 
typedef unsigned int uword;                 
typedef   signed int sword;                 
#else
#define eword int
#define uword unsigned int
#define sword signed int
#endif

#define  EWORDMAXVAL  ((eword) INT_MAX)
#define  EWORDMINVAL  ((eword)       0)
#define  UWORDMAXVAL  ((uword)UINT_MAX)
#define  UWORDMINVAL  ((uword)       0)
#define  SWORDMAXVAL  ((sword) INT_MAX)
#define  SWORDMINVAL  ((sword) INT_MIN)
#define  MINEWORDMAXVAL  ((eword)  32767)
#define  MAXEWORDMINVAL  ((eword)      0)
#define  MINUWORDMAXVAL  ((uword)  65535)
#define  MAXUWORDMINVAL  ((uword)      0)
#define  MINSWORDMAXVAL  ((sword)  32767)
#define  MAXSWORDMINVAL  ((sword) -32767)


#ifndef lint
# ifdef mips
typedef   signed char  eb1;
# else
typedef          char  eb1;                 
# endif
typedef unsigned char  ub1;                 
typedef   signed char  sb1;                 
#else
#define eb1 char
#define ub1 unsigned char
#define sb1 signed char
#endif

#define EB1MAXVAL ((eb1)SCHAR_MAX)
#define EB1MINVAL ((eb1)        0)
#if defined(mips)                    
# ifndef lint
#  define UB1MAXVAL (UCHAR_MAX)
# endif
#endif
#ifndef UB1MAXVAL
# ifdef SCO_UNIX
# define UB1MAXVAL (UCHAR_MAX)
# else
# define UB1MAXVAL ((ub1)UCHAR_MAX)
# endif
#endif
#define UB1MINVAL ((ub1)        0)
#define SB1MAXVAL ((sb1)SCHAR_MAX)
#define SB1MINVAL ((sb1)SCHAR_MIN)
#define MINEB1MAXVAL ((eb1)  127)
#define MAXEB1MINVAL ((eb1)    0)
#define MINUB1MAXVAL ((ub1)  255)
#define MAXUB1MINVAL ((ub1)    0)
#define MINSB1MAXVAL ((sb1)  127)
#define MAXSB1MINVAL ((sb1) -127)

#define UB1BITS          CHAR_BIT
#define UB1MASK              0xff


typedef  unsigned char text;


#ifndef lint
typedef          short    eb2;              
typedef unsigned short    ub2;              
typedef   signed short    sb2;              
#else
#define eb2  short
#define ub2  unsigned short
#define sb2  signed short
#endif

#define EB2MAXVAL ((eb2) SHRT_MAX)
#define EB2MINVAL ((eb2)        0)
#define UB2MAXVAL ((ub2)USHRT_MAX)
#define UB2MINVAL ((ub2)        0)
#define SB2MAXVAL ((sb2) SHRT_MAX)
#define SB2MINVAL ((sb2) SHRT_MIN)
#define MINEB2MAXVAL ((eb2) 32767)
#define MAXEB2MINVAL ((eb2)     0)
#define MINUB2MAXVAL ((ub2) 65535)
#define MAXUB2MINVAL ((ub2)     0)
#define MINSB2MAXVAL ((sb2) 32767)
#define MAXSB2MINVAL ((sb2)-32767)


#ifndef lint
typedef          long  eb4;                 
typedef unsigned long  ub4;                 
typedef   signed long  sb4;                 
#else
#define eb4 long
#define ub4 unsigned long
#define sb4 signed long
#endif

#define EB4MAXVAL ((eb4) LONG_MAX)
#define EB4MINVAL ((eb4)        0)
#define UB4MAXVAL ((ub4)ULONG_MAX)
#define UB4MINVAL ((ub4)        0)
#define SB4MAXVAL ((sb4) LONG_MAX)
#define SB4MINVAL ((sb4) LONG_MIN)
#define MINEB4MAXVAL ((eb4) 2147483647)
#define MAXEB4MINVAL ((eb4)          0)
#define MINUB4MAXVAL ((ub4) 4294967295)
#define MAXUB4MINVAL ((ub4)          0)
#define MINSB4MAXVAL ((sb4) 2147483647)
#define MAXSB4MINVAL ((sb4)-2147483647)


#ifndef lint
typedef unsigned long  ubig_ora;            
typedef   signed long  sbig_ora;            
#else
#define ubig_ora unsigned long
#define sbig_ora signed long
#endif

#define UBIG_ORAMAXVAL ((ubig_ora)ULONG_MAX)
#define UBIG_ORAMINVAL ((ubig_ora)        0)
#define SBIG_ORAMAXVAL ((sbig_ora) LONG_MAX)
#define SBIG_ORAMINVAL ((sbig_ora) LONG_MIN)
#define MINUBIG_ORAMAXVAL ((ubig_ora) 4294967295)
#define MAXUBIG_ORAMINVAL ((ubig_ora)          0)
#define MINSBIG_ORAMAXVAL ((sbig_ora) 2147483647)
#define MAXSBIG_ORAMINVAL ((sbig_ora)-2147483647)




#undef CONST

#ifdef _olint
# define CONST const
#else
#if defined(PMAX) && defined(__STDC__)
#   define CONST const
#else
# ifdef M88OPEN
#  define CONST const
# else
#  ifdef SEQ_PSX_ANSI
#   ifdef __STDC__
#    define CONST const
#   else
#    define CONST
#   endif
#  else
#   define CONST
#  endif
# endif
#endif
#endif



#ifdef lint
# define dvoid void
#else

# ifdef UTS2
#  define dvoid char
# else
#  define dvoid void
# endif

#endif



typedef void (*lgenfp_t)(/*_ void _*/);



#include <sys/types.h>
#define boolean int




#ifdef sparc
# define SIZE_TMAXVAL SB4MAXVAL               
#else
# define SIZE_TMAXVAL UB4MAXVAL             
#endif

#define MINSIZE_TMAXVAL (size_t)65535


#endif
</pre>

_BLOG_FOOTER_GITHUB(`11')

_BLOG_FOOTER()

