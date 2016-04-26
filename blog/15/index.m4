m4_include(`commons.m4')

_HEADER_HL1(`7-Jan-2009: "CHANGE USER" OPI call')

<p>Regarding "BECOME USER" privilege and upicui() function (UPI Change User Id):</p>
<p>There's a barely known OPI call "CHANGE USER", which is similar in a way to *NIX <a href="http://en.wikipedia.org/wiki/Su_(Unix)">su</a>. It is known to be used at least by IMP utility.</p>
<p>A caller should be logged in as a user with "BECOME USER" privilege and call upicui() to change it.</p>
<p>Here is <a href="http://idevelopment.info/data/Oracle/DBA_tips/Database_Administration/DBA_19.shtml">sample code</a> that illustrates it, it uses some ancient OCI API (OCI7, if I'm correct).</p>
<p>Here is my sample code which calls upicui() function in current OCI API.</p>
<p>All we need is to convert service handle to "hst" value needed by upicui() - using internal function kpusvc2hst() - and then call upicui().</p>
<p>This code snippet was successfully tried under win32 10.2 and 11. Change SID, USERNAME, PASSWORD and USERNAME2 before compiling.</p>

<pre>
#include &lt;stdio.h&gt;
#include &lt;assert.h&gt;
#include &lt;string.h&gt;
#include &lt;windows.h&gt;

#include "oci.h"

typedef int (__cdecl *UPICUI)(int, int, const char *, int); 
typedef int (__cdecl *KPUSVC2HST)(OCISvcCtx *, OCIError *, int *, int); 

void main(int argc, char * argv[])
{

  OCIEnv *myenvhp;       /* the environment handle */
  OCIServer *mysrvhp;    /* the server handle */
  OCIError *myerrhp;     /* the error handle */
  OCISession *myusrhp;   /* user session handle */
  OCISvcCtx *mysvchp;    /* the  service handle */
  OCIStmt *stmt;
  OCIDefine *dfn;
  char	buf[10240];
  HMODULE oraclient;
  UPICUI upicui;
  KPUSVC2HST kpusvc2hst;
  int hst;

#define SID "orcl"

  assert (OCIEnvCreate (&myenvhp, OCI_THREADED|OCI_OBJECT, 0, 0, 0, 0, 0, 0)==0);

  assert (OCIHandleAlloc (myenvhp, (dvoid**)&mysrvhp, OCI_HTYPE_SERVER, 0, 0)==0);

  assert (OCIHandleAlloc (myenvhp, (dvoid**)&myerrhp, OCI_HTYPE_ERROR, 0, 0)==0);

  assert (OCIServerAttach (mysrvhp, myerrhp, (const OraText *)SID, strlen (SID), OCI_DEFAULT)==0);

  assert (OCIHandleAlloc (myenvhp, (dvoid**)&mysvchp, OCI_HTYPE_SVCCTX, 0, 0)==0);

  assert (OCIAttrSet (mysvchp, OCI_HTYPE_SVCCTX, mysrvhp, 0, OCI_ATTR_SERVER, myerrhp)==0);

  assert (OCIHandleAlloc (myenvhp, (dvoid**)&myusrhp, OCI_HTYPE_SESSION, 0, 0)==0);

  assert (OCIHandleAlloc (myenvhp, (dvoid**)&stmt, OCI_HTYPE_STMT, 0, 0)==0);

#define USERNAME "sys"
#define PASSWORD "qq"

  assert (OCIAttrSet (myusrhp, OCI_HTYPE_SESSION, USERNAME, strlen(USERNAME), OCI_ATTR_USERNAME, myerrhp)==0);

  assert (OCIAttrSet (myusrhp, OCI_HTYPE_SESSION, PASSWORD, strlen(PASSWORD), OCI_ATTR_PASSWORD, myerrhp)==0);

  assert (OCISessionBegin (mysvchp, myerrhp, myusrhp, OCI_CRED_RDBMS, OCI_SYSDBA)==0);

  oraclient=LoadLibrary ("oraclient11.dll");
  assert (oraclient!=NULL);
  upicui=(UPICUI)GetProcAddress (oraclient, "upicui"); assert (upicui!=NULL);
  kpusvc2hst=(KPUSVC2HST)GetProcAddress (oraclient, "kpusvc2hst"); assert (kpusvc2hst!=NULL);

  printf ("kpusvc2hst -> %d\n", (kpusvc2hst) (mysvchp, myerrhp, &hst, 1));

#define USERNAME2 "SCOTT"

  printf ("upicui -> %d\n", (upicui)( hst, 0, USERNAME2, strlen (USERNAME2) ));

  assert (OCIAttrSet (mysvchp, OCI_HTYPE_SVCCTX, myusrhp, 0, OCI_ATTR_SESSION, myerrhp)==0);

#define STMT "select user from dual"

  assert (OCIStmtPrepare (stmt, myerrhp, (const OraText *)STMT, strlen (STMT), OCI_NTV_SYNTAX, OCI_DEFAULT)==0);

  assert (OCIDefineByPos (stmt, &dfn, myerrhp, 1, buf, 10240, SQLT_STR, 0, 0, 0, OCI_DEFAULT)==0);

  assert (OCIStmtExecute (mysvchp, stmt, myerrhp, 1,  0, NULL, NULL, OCI_DEFAULT)==0);

  printf ("%s\n", buf);
};
</pre>

<p>Update:
How to do the same in Linux:
_HTML_LINK_AS_IS(`http://arkzoyd.blogspot.com/2009/02/become-user-sous-linux.html')
</p>

_BLOG_FOOTER_GITHUB(`15')

_BLOG_FOOTER()

