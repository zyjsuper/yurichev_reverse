m4_include(`commons.m4')

_HEADER(`OpenWatcom patches')

<p>Patching OpenWatcom 1.9 for __RAND__ macro support.</p>

_PRE_BEGIN
--- macro.h~	2010-03-08 14:41:04.000000000 +0200
+++ macro.h	2011-09-30 03:25:45.371384000 +0300
@@ -34,6 +34,7 @@ enum    special_macros {
     MACRO_DATE,
     MACRO_FILE,
     MACRO_LINE,
+    MACRO_RAND,
     MACRO_STDC,
     MACRO_STDC_HOSTED,
     MACRO_STDC_LIB_EXT1,
_PRE_END

_PRE_BEGIN
--- cmac1.c~	2010-03-08 14:46:18.000000000 +0200
+++ cmac1.c	2011-09-30 03:18:25.859962200 +0300
@@ -32,6 +32,9 @@
 #include "cvars.h"
 #include "scan.h"
 
+// for rand()
+#include <stdlib.h>
+#include <time.h>
 
 #define T_UNEXPANDABLE_ID       T_LAST_TOKEN
 
@@ -81,6 +84,7 @@ static struct special_macro_names  SpcMa
     { "__DATE__",           MACRO_DATE          },
     { "__FILE__",           MACRO_FILE          },
     { "__LINE__",           MACRO_LINE          },
+    { "__RAND__",           MACRO_RAND          },
     { "__STDC__",           MACRO_STDC          },
     { "__STDC_HOSTED__",    MACRO_STDC_HOSTED   },
     { "__STDC_LIB_EXT1__",  MACRO_STDC_LIB_EXT1 },
@@ -129,6 +133,7 @@ void MacroInit( void )
         MacroAdd( mentry, NULL, 0, MFLAG_NONE );
     }
     TimeInit(); /* grab time and date for __TIME__ and __DATE__ */
+    srand(time(NULL));
 }
 
 static struct special_macro_names  SpcMacroCompOnly[] = {
@@ -348,6 +353,7 @@ int SpecialMacro( MEPTR mentry )
 {
     char        *p;
     char        *bufp;
+    int         tmp;
 
     CompFlags.wide_char_string = 0;                     /* 16-dec-91 */
     switch( mentry->parm_count ) {
@@ -356,6 +362,12 @@ int SpecialMacro( MEPTR mentry )
         Constant = TokenLoc.line;
         ConstType = TYPE_INT;
         return( T_CONSTANT );
+    case MACRO_RAND:
+        tmp=rand();
+        utoa( tmp, Buffer, 10 );
+        Constant = tmp;
+        ConstType = TYPE_INT;
+        return( T_CONSTANT );
     case MACRO_FILE:
         p = FileIndexToFName( TokenLoc.fno )->name;
         bufp = Buffer;
_PRE_END

_FOOTER()

