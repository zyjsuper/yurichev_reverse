m4_include(`commons.m4')

_HEADER_HL1(`7-Jul-2010: About Oracle PL/SQL undocumented "interface" pragma.')

<p>About Oracle PL/SQL undocumented "interface" pragma.</p>

<p>Sometimes, in PL/SQL libraries comes with Oracle RBMS, wrapped or not, we can see such statement (dbmsstdx.sql):</p>

<pre>
  function updating  return boolean;
    pragma interface (C, updating);
</pre>

<p>This is in fact a gateway to internal Oracle functions.
But how can we find what function exactly is called?</p>

<p>Not so much is googleable so far:</p>
<p>_HTML_LINK_AS_IS(`http://www.petefinnigan.com/weblog/archives/00000835.htm')</p>
<p>_HTML_LINK_AS_IS(`http://awads.net/wp/2006/05/24/about-the-builtin-fipsflag-and-interface-pragmas-in-oracle/')</p>

<p>One of the memory blocks function kkxnfy() allocating is marked as "KKX ICD VECTOR".
As of 11.2 win32, this block is 1488 bytes length and is capable to hold information about 93 package records.
Each record contain at least package name, package schema and function array.
For example, there is 3 functions for DBMS_SHARED_POOL package.
This mean, that three functions declared as a statement I mentioned will be tied together.
There probably much more information about data types, function number limits, etc.</p>

<p>So far, I fetched only what name mentioned in pragma statement is corresponding to which oracle function.
11.2 win32 used.</p>

<p>Full list:</p>

_PRE_BEGIN
** package DBMS_APPLICATION_INFO/X$DBMS_APPLICATION_INFO
file prvtapin.plb

pl/sql                        oracle.exe

ICD_SET_MODULE                _kqp3271
ICD_SET_ACTION                _kqp3272
ICD_READ_MODULE               _kqp3273
ICD_READ_ACTION               _kqp3274
ICD_SET_CLIENT_INFO 	      _kqp3275  
ICD_READ_INFO                 _kqp3276
ICD_SET_SESSION_LONGOPS       _kqp3277

** package DBMS_AQ_SYS_IMP_INTERNAL
file prvtaqmi.plb


pl/sql              oracle.exe

KWQAACSET           _kwqaacset

** package DBMS_AQADM_SYS
file prvtaqds.plb

pl/sql                oracle.exe

KWQAUPTR              _kwqauptr 
KWQAACSET             _kwqaacset
?                     _kwqasown 

** package DBMS_ASYNCRPC_PUSH
file prvtarpp.plb

pl/sql                        oracle.exe

KNCDPDC                       _kncdpdc     
KNCDGEP                       _kncdgep       
KNPC_PRICD                    _knpc_pricd      
KNPC_PUICD                    _knpc_puicd    
KNCDGCS                       _kncdgcs      
KNPC_SQBICD                   _knpc_sqbicd     
KNPC_GCTICD                   _knpc_gcticd   
KNCDCCP                       _kncdccp     
KNCDUPS                       _kncdups         

** package DBMS_BACKUP_RESTORE/X$DBMS_BACKUP_RESTORE
file prvtbkrs.plb

pl/sql                      oracle.exe

KRBIDVAC                    _krbidvac                        
KRBIDVCM                    _krbidvcm                        
KRBIDVQ                     _krbidvq                         
KRBIDVDA                    _krbidvda                        
KRBIDSTA                    _krbidsta                        
KRBISL                      _krbisl                          
KRBIRI                      _krbiri                          
KRBIBSDF                    _krbibsdf                        
KRBIBSRL                    _krbibsrl                        
KRBIBDF                     _krbibdf                         
KRBIBDCP                    _krbibdcp                        
KRBIBCF                     _krbibcf                         
KRBIBRL                     _krbibrl                         
KRBIBPC                     _krbibpc                         
KRBIBDS                     _krbibds                         
KRBIBDG                     _krbibdg                         
KRBIBV                      _krbibv                          
KRBIBSTA                    _krbibsta                        
KRBIBCLE                    _krbibcle                        
KRBICBBP                    _krbicbbp                        
KRBICDF                     _krbicdf                         
KRBICDCP                    _krbicdcp                        
KRBICRL                     _krbicrl                         
KRBICCF                     _krbiccf                         
KRBIIF                      _krbiif                          
KRBIRSDF                    _krbirsdf                        
KRBIRCFT                    _krbircft                        
KRBIRDFT                    _krbirdft                        
KRBIADFT                    _krbiadft                        
KRBIRRNG                    _krbirrng                        
KRBIRRL                     _krbirrl                         
KRBIRVD                     _krbirvd                         
KRBIRBP                     _krbirbp                         
KRBIAOR                     _krbiaor                         
KRBIRSTA                    _krbirsta                        
KRBIRCLE                    _krbircle                        
KRBICSSN                    _krbicssn                        
KRBICUS                     _krbicus                         
KRBICUC                     _krbicuc                         
KRBICUP                     _krbicup                         
KRBICRS                     _krbicrs                         
KRBICSL                     _krbicsl                         
KRBIDF                      _krbidf                          
KRBICBS                     _krbicbs                         
KRBIDBP                     _krbidbp                         
KRBIDDF                     _krbiddf                         
KRBIDRL                     _krbidrl                         
KRBIGFNO                    _krbigfno                        
KRBIUFR                     _krbiufr                         
KRBIUFC                     _krbiufc                         
KRBISAL                     _krbisal                         
KRBISTC                     _krbistc                         
KRBINFN                     _krbinfn                         
KRBIVBP                     _krbidbp                         
KRBIVDC                     _krbiddf                         
KRBIVAL                     _krbidrl                         
KRBIPRM                     _krbiprm                         
KRBICKPT                    _krbickpt                        
KRBICMUS                    _krbicmus                        
KRBISLP                     _krbislp                         
KRBISTCS                    _krbistcs                        
KRBIPBB                     _krbipbb                         
KRBIPBR                     _krbipbr                         
KRBIPBDF                    _krbipbdf                        
KRBIPBDC                    _krbipbdc                        
KRBIPBCF                    _krbipbcf                        
KRBIPBA                     _krbipba                         
KRBIPRDF                    _krbiprdf                        
KRBIPRCF                    _krbiprcf                        
KRBIPRA                     _krbipra                         
KRBIPGO                     _krbipgo                         
KRBIPQB                     _krbipqb                         
KRBIPQR                     _krbipqr                         
KRBIPCN                     _krbipcn                         
KRBIPDL                     _krbipdl                         
KRBIPVL                     _krbipdl                         
KRBIMXI                     _krbimxi                         
KRBIZERF                    _krbizerf                        
KRBIVTS                     _krbivts                         
KRBIRAN                     _krbiran                         
KRBIGPN                     _krbigpn                         
KRBISRM                     _krbisrm                         
KRBIDRM                     _krbidrm                         
KRBIRRM                     _krbirrm                         
KRBIAUX                     _krbiaux                         
KRBITSAT                    _krbitsat                        
KRBIBMRS                    _krbibmrs                        
KRBIBAB                     _krbibab                         
KRBIBIS                     _krbibis                         
KRBIBGF                     _krbibgf                         
KRBIBMRC                    _krbibmrc                        
KRBID2RF                    _krbid2rf                        
KRBIBUFC                    _krbibufc                        
KRBIBDMR                    _krbibdmr                        
KRBIIALBAC                  _krbiialbac                      
KRBIOMFN                    _krbiomfn                        
KRBIGALN                    _krbigaln                        
KRBICVRT                    _krbicvrt                        
KRBIBSF                     _krbibsf                         
KRBIRSFT                    _krbirsft                        
KRBIDAB                     _krbidab                         
KRBIABF                     _krbiabf                         
KRBIRCP                     _krbircp                         
KRBIRAGF                    _krbiragf                        
KRBIFBS                     _krbifbs                         
KRBIFBAF                    _krbifbaf                        
KRBIFBF                     _krbifbf                         
KRBIFBC                     _krbifbc                         
KRBIRSP                     _krbirsp                         
KRBIFFR                     _krbiffr                         
KRBIGTSN                    _krbigtsn                        
KRBISF                      _krbisf                          
KRBIPSFT                    _krbipsft                        
KRBIFSFT                    _krbifsft                        
KRBISWITCH                  _krbiswitch                      
KRBICTSET                   _krbictset                       
KRBIRDB                     _krbirdb                         
KRBICRSR                    _krbicrsr                        
KRBIURSR                    _krbiursr                        
KRBIMRSR                    _krbimrsr                        
KRBICROR                    _krbicror                        
KRBISRID                    _krbisrid                        
KRBIRDHD                    _krbirdhd                        
KRBIDEFT                    _krbideft                        
KRBICF                      _krbicf                          
KRBIININS                   _krbiinins                       
KRBIMAUX                    _krbimaux                        
KRBIGCS                     _krbigcs                         
KRBIVALS                    _krbivals                        
KRBIVALA                    _krbivala                        
KRBIVALV                    _krbivalv                        
KRBIVALN                    _krbivaln                        
KRBIVALE                    _krbivale                        
KRBIURT                     _krbiurt                         
KRBINBEG                    _krbinbeg                        
KRBINGNI                    _krbingni                        
KRBINEND                    _krbinend                        
KRBINPCF                    _krbinpcf                        
KRBINPDF                    _krbinpdf                        
KRBIISOMF                   _krbiisomf                       
KRBICLRL                    _krbiclrl                        
KRBITRC                     _krbitrc                         
KRBIWTRC                    _krbiwtrc                        
KRBIRCDF                    _krbircdf                        
KRBIRECFS                   _krbirecfs                       
KRBISWTF                    _krbiswtf                        
KRBIGTSC                    _krbigtsc                        
KRBITDBLK                   _krbitdblk                       
KRBITDBUNLK                 _krbitdbunlk                     
KRBISBTV                    _krbisbtv                        
KRBISPRM                    _krbisprm                        
KRBIGDGN                    _krbigdgn                        
KRBIPCGN                    _krbipcgn                        
KRBINETTRANSFER             _krbinettransfer                 
KRBIOVAC                    _krbiovac                        
KRBIRERR                    _krbirerr                        
KRBIIMSB                    _krbiimsb                        
KRBISMSB                    _krbismsb                        
KRBIIMSR                    _krbiimsr                        
KRBIARCFN                   _krbiarcfn                       
KRBIBRF                     _krbibrf                         
KRBIBLKSTAT                 _krbiblkstat                     
KRBIVALBLK                  _krbivalblk                      
KRBIUPHD                    _krbiuphd                        
KRBI_CLEANUP_BACKUP_RECORDS _krbi_cleanup_backup_records
KRBIRDALHD                  _krbirdalhd                      
KRBIRSQLEXEC                _krbirsqlexec                    
KRBI_SAVE_ACTION            _krbi_save_action                
KRBI_READ_ACTION            _krbi_read_action                
KRBI_CLEANUP_FOREIGN_AL     _krbi_cleanup_foreign_al         
KRBICKEEPF                  _krbickeepf                      
KRBI_SDBUNAME_TSPITR        _krbi_sdbuname_tspitr            
KRBIBRPSBY                  _krbibrpsby                      
KRBI_FLASHBACK_CF           _krbi_flashback_cf               
KRBI_DUPFILEEXISTS          _krbi_DupFileExists              
KRBI_GETDUPDCOPY            _krbi_getDupDcopy                
KRBI_WRTDUPDCOPY            _krbi_wrtDupDcopy                
KRBI_REMDUPFILE             _krbi_RemDupFile                 
KRBI_CHKCOMPALG             _krbi_chkcompalg                 
KRBI_CLEARCONTROLFILE       _krbi_clearControlfile           

** package DBMS_CACHEUTIL
file prvtkcl.plb

pl/sql                         oracle.exe

KCL_GRAB_AFFINITY              _kcl_grab_affinity                
KCL_GRAB_READMOSTLY            _kcl_grab_readmostly              
KCL_DISSOLVE_AFFINITY          _kcl_dissolve_affinity            
KCL_DISSOLVE_READMOSTLY        _kcl_dissolve_readmostly          
KCL_OBJ_DOWNCONVERT            _kcl_obj_downconvert              

** package DBMS_COMPRESSION
file prvtcmpr.plb

pl/sql              oracle.exe

KDZCHECKHI          _kdzcmptype
KDZCMPTYPE          _kdzcheckhi

** package DBMS_DBVERIFY/X$DBMS_DBVERIFY
file prvtdbv.plb

pl/sql             oracle.exe

ICD_DBV2           _kudbvsScan

** package DBMS_DDL
file prvtddl.plb

pl/sql                              oracle.exe

EXECUTE_SQL                         _psdddl       
MAKE_TABLE_REFERENCEABLE            _kkboatr      
MAKE_TABLE_NOT_REFERENCEABLE        _kkboatnr     
PSDSTFP                             _psdstfp      
WRAP_VC2                            _psd_wrap_vc2 
WRAP_COLL                           _psd_wrap_coll
WRAP_COLL                           _psd_wrap_coll

** package DBMS_DDL_INTERNAL
file prvtddl.plb

pl/sql                          oracle.exe

GENERATE_OBJID                  _psd_genoid        
SWAP_BOOTSTRAP_ICD              _psd_swap_bootstrap

** package DBMS_DEBUG_JDWP
file prvtjdwp.plb

pl/sql                 oracle.exe

KQAIVSN                _kqaivsn 
KQAIGCSI               _kqaigcsi
KQAIGCSS               _kqaigcss
KQAICONN               _kqaiconn
KQAIDISC               _kqaidisc
KQAIPCS                _kqaipcs 
KQAIGNP                _kqaignp 
KQAISNP                _kqaisnp 

** package DBMS_DEFER_ENQ_UTL
file prvtdfri.plb

pl/sql                   oracle.exe

KNCEVCA                  _kncevca     
KNCENUA                  _kncenua     
KNCEDTA                  _kncedta     
KNCERWA                  _kncerwa     
KNCERDA                  _kncerda     
KNCECLA                  _kncecla     
KNCEBLA                  _kncebla     
KNCEGCN                  _kncegcn     
KNCERBR                  _kncerbr        
KNCEGUI                  _kncegui     
KNCECHA                  _kncecha     
KNCETMA                  _kncetma     
KNCETSA                  _kncetsa     
KNCETTZ                  _kncettz     
KNCETSTZ                 _kncetstz    
KNCEIYM                  _knceiym     
KNCEIDS                  _knceids     
KNCETSLTZ                _kncetsltz   

** package DBMS_DEFER_QUERY_UTL
file prvtdfri.plb

pl/sql                 oracle.exe

KKXACAR                _kkxacar     
KKXAGAT                _kkxagat     
KKXAGAF                _kkxagaf     
KKXAGAC                _kkxagac     
KKXAGNA                _kkxagav     
KKXAGVA                _kkxagav     
KKXAGCA                _kkxagav     
KKXAGDA                _kkxagav     
KKXAGRW                _kkxagav     
KKXAGRD                _kkxagav     
KKXAGCL                _kkxagav     
KKXAGBL                _kkxagav     
KKXAGNV                _kkxagav     
KKXAGNC                _kkxagav     
KKXAGNL                _kkxagav     
KKXADTL                _kkxadtl      
KKXACTL                _kkxactl        
KKXACST                _kkxacst
KKXAGTM                _kkxagav     
KKXAGTS                _kkxagav     
KKXAGTTZ               _kkxagav      
KKXAGTSTZ              _kkxagav      
KKXAGIYM               _kkxagav      
KKXAGIDS               _kkxagav      
KKXAGONV               _kkxagav      
KKXAGTSLTZ             _kkxagav      

** package DBMS_DRS/X$DBMS_DRS
file prvtdrs.plb

pl/sql                              oracle.exe

RFSREQ                              _rfsreq                     
RFSBRQ                              _rfsbrq                     
RFSCNL                              _rfscnl                     
RFSDEL                              _rfsdel                     
RFSRSP                              _rfsrsp                     
RFSGPRP                             _rfsgprp                    
PSDWAT                              _psdwat                     
RFSC2R                              _rfsc2r                     
RFSR2C                              _rfsr2c                     
RFSINFO                             _rfsinfo                    
RFSPMETA                            _rfspmeta                   
RFSAFPING                           _rfsAfPing                  
RFSAFREADYTOFAILOVER                _rfsAfReadyToFailover       
RFSAFSTATECHANGERECORDED            _rfsAfStateChangeRecorded   
RFS_FS_FAILOVER_FOR_HC_COND         _rfs_fs_failover_for_hc_cond
RFS_INITIATE_FS_FAILOVER            _rfs_initiate_fs_failover   

** package DBMS_EPG
file prvtepg.plb

pl/sql               oracle.exe

WPEZAUTH             _wpezauth  
WPEZDEAUTH           _wpezdeauth

** package DBMS_HM/X$DBMS_HM
file prvthm.plb

pl/sql                              oracle.exe

DBKHICD_ISTRACEENABLED              _dbkhicd_isTraceEnabled              
DBKHICD_WRITETOTRACE                _dbkhicd_writeToTrace                
DBKHICD_RUN_CHECK                   _dbkhicd_run_check                   
DBKHICD_GET_RUN_REPORT              _dbkhicd_get_run_report              
DBKHICD_CREATE_SCHEMA               _dbkhicd_create_schema               
DBKHICD_DROP_SCHEMA                 _dbkhicd_drop_schema                 
DBKHICD_CREATE_OFFL_DICT            _dbkhicd_create_offl_dict            
DBKHICD_RUN_DDE_ACTION              _dbkhicd_run_dde_action              

** package DBMS_IJOB
file prvtjob.plb

pl/sql               oracle.exe

KKJPRU               _kkjpru
KKJSPC               _kkjspc
KKJEXI               _kkjexi
KKJGES               _kkjges
KKJSES               _kkjses

** package DBMS_INTERNAL_TRIGGER
file prvtitrg.plb

pl/sql          oracle.exe

KKXTMIT         _kkxtmit
KKXTILC         _kkxtilc
KKXTUSV         _kkxtusv
KKXTGSV         _kkxtgsv

** package DBMS_IR/X$DBMS_IR
file prvtir.plb

pl/sql                             oracle.exe

DBKIICD_ISTRACEENABLED             _dbkiicd_isTraceEnabled                     
DBKIICD_WRITETOTRACE               _dbkiicd_writeToTrace                       
DBKIICD_REEVAL                     _dbkiicd_reeval                             
DBKIICD_CHANGEPRIORITY             _dbkiicd_changePriority                     
DBKIICD_CLOSEFAILURE               _dbkiicd_closeFailure                       
DBKIICD_BEGINFAILURESET            _dbkiicd_beginFailureSet                    
DBKIICD_ADDTOFAILURESET            _dbkiicd_addToFailureSet                    
DBKIICD_COMPLETEFAILURESET         _dbkiicd_completeFailureSet                 
DBKIICD_CANCELFAILURESET           _dbkiicd_cancelFailureSet                   
DBKIICD_CREATEWORKINGREPAIRSET     _dbkiicd_createWorkingRepairSet             
DBKIICD_UPDATEREPAIROPTION         _dbkiicd_updateRepairOption                 
DBKIICD_ADVISEDONE                 _dbkiicd_adviseDone                         
DBKIICD_GETREPAIRADVICE            _dbkiicd_getRepairAdvice                    
DBKIICD_CLEANUPADVISE              _dbkiicd_cleanupAdvise                      
DBKIICD_GETFEASANDIMPACT           _dbkiicd_getFeasAndImpact                   
DBKIICD_UPDATEFEASANDIMPACT        _dbkiicd_updateFeasAndImpact                
DBKIICD_CONSOLIDATEREPAIR          _dbkiicd_consolidateRepair                  
DBKIICD_STARTREPAIROPTION          _dbkiicd_startRepairOption                  
DBKIICD_COMPLETEREPAIROPTION       _dbkiicd_completeRepairOption               
DBKIICD_CREATESCRIPTFILE           _dbkiicd_createScriptFile                   
DBKIICD_OPENSCRIPTFILE             _dbkiicd_openScriptFile                     
DBKIICD_CLOSESCRIPTFILE            _dbkiicd_closeScriptFile                    
DBKIICD_ADDLINE                    _dbkiicd_addLine                            
DBKIICD_GETLINE                    _dbkiicd_getLine                            
DBKIICD_CONTROLFILECHECK           _dbkiicd_controlfileCheck                   
DBKIICD_GETFILE                    _dbkiicd_getFile                            

** package DBMS_JAVA_DUMP
file prvtjdmp.plb

pl/sql                 oracle.exe

KQAIVSN                _kqaivsn
KQAIRJD                _kqairjd

** package DBMS_JOB
file prvtjob.plb

pl/sql               oracle.exe

KKJENV               _kkjibe
KKJBGD               _kkjbgd

** package DBMS_LOB
file prvtlob.plb

pl/sql                                 oracle.exe

KKXL_APPEND                            _kkxlbap           
KKXL_APPEND                            _kkxlcap           
KKXL_CLOSE                             _kkxlbcl           
KKXL_CLOSE                             _kkxlccl           
KKXL_CLOSE                             _kkxlfcl           
KKXL_COMPARE                           _kkxlbcm           
KKXL_COMPARE                           _kkxlccm           
KKXL_COMPARE                           _kkxfbcm           
KKXL_COPY                              _kkxlbcp           
KKXL_COPY                              _kkxlccp           
KKXL_CREATETEMPORARY                   _kkxlbcr           
KKXL_CREATETEMPORARY                   _kkxlccr           
KKXL_ERASE                             _kkxlber           
KKXL_ERASE                             _kkxlcer           
KKXL_FILECLOSE                         _kkxfbcl           
KKXL_FILECLOSEALL                      _kkxfbco           
KKXL_FILEEXISTS                        _kkxfbex           
KKXL_FILEGETNAME                       _kkxfbgn           
KKXL_FILEISOPEN                        _kkxfbis           
KKXL_FILEOPEN                          _kkxfbop           
KKXL_FREETEMPORARY                     _kkxlbft           
KKXL_FREETEMPORARY                     _kkxlcft           
KKXL_GETCHUNKSIZE                      _kkxlbgch          
KKXL_GETCHUNKSIZE                      _kkxlcgch          
KKXL_GETLENGTH                         _kkxlbln           
KKXL_GETLENGTH                         _kkxlcln           
KKXL_GETLENGTH                         _kkxfbln           
KKXL_GET_STORAGE_LIMIT                 _kkxlbgs           
KKXL_GET_STORAGE_LIMIT                 _kkxlcgs           
KKXL_ISTEMPORARY                       _kkxlbit           
KKXL_ISTEMPORARY                       _kkxlcit           
KKXL_ISOPEN                            _kkxlbis           
KKXL_ISOPEN                            _kkxlcis           
KKXL_ISOPEN                            _kkxlfis           
KKXL_LOADFROMFILE                      _kkxlbff           
KKXL_LOADFROMFILE                      _kkxlcff           
KKXL_LOADBLOBFROMFILE                  _kkxlbff2          
KKXL_LOADCLOBFROMFILE                  _kkxlcff2          
KKXL_CONVERTTOCLOB                     _kkxlc2c           
KKXL_CONVERTTOBLOB                     _kkxlc2b           
KKXL_OPEN                              _kkxlbop           
KKXL_OPEN                              _kkxlcop           
KKXL_OPEN                              _kkxlfop           
KKXL_INSTR                             _kkxlbin           
KKXL_INSTR                             _kkxlcin           
KKXL_INSTR                             _kkxfbin           
KKXL_READ                              _kkxlbrd           
KKXL_READ                              _kkxlcrd           
KKXL_READ                              _kkxfbrd           
KKXL_SUBSTR                            _kkxlbsb           
KKXL_SUBSTR                            _kkxlcsb           
KKXL_SUBSTR                            _kkxfbsb           
KKXL_TRIM                              _kkxlbtr           
KKXL_TRIM                              _kkxlctr           
KKXL_WRITE                             _kkxlbwr           
KKXL_WRITE                             __PGOSF371__kkxlcwr
KKXL_WRITEAPPEND                       _kkxlbwra          
KKXL_WRITEAPPEND                       _kkxlcwra          
KKXL_INSERT                            _kkxlnbins         
KKXL_INSERT                            _kkxlncins         
KKXL_DELETE                            _kkxlnbdel         
KKXL_DELETE                            _kkxlncdel         
KKXL_MOVE                              _kkxlnbmov         
KKXL_MOVE                              _kkxlncmov         
KKXL_REPLACE                           _kkxlnbrpl         
KKXL_REPLACE                           _kkxlncrpl         
KKXL_GETOPTIONS                        _kkxlnbgopt        
KKXL_GETOPTIONS                        _kkxlncgopt        
KKXL_SETOPTIONS                        _kkxlnbsopt        
KKXL_SETOPTIONS                        _kkxlncsopt        
KKXL_GETSHR                            _kkxlnbgsr         
KKXL_GETSHR                            _kkxlncgsr         
KKXL_ISSECUREFILE                      _kkxlnbissf        
KKXL_ISSECUREFILE                      _kkxlncissf        
KKXL_COPY_FROM_DBFS_LINK               _kkxlnbaget        
KKXL_COPY_FROM_DBFS_LINK               _kkxlncaget        
KKXL_MOVE_TO_DBFS_LINK                 _kkxlnbaput        
KKXL_MOVE_TO_DBFS_LINK                 _kkxlncaput        
KKXL_GET_DBFS_LINK                     _kkxlnbagref       
KKXL_GET_DBFS_LINK                     _kkxlncagref       
KKXL_SET_DBFS_LINK                     _kkxlnbapref       
KKXL_SET_DBFS_LINK                     _kkxlncapref       
KKXL_COPY_DBFS_LINK                    _kkxlnbacpref      
KKXL_COPY_DBFS_LINK                    _kkxlncacpref      
KKXL_GET_DBFS_LINK_STATE               _kkxlnbagst        
KKXL_GET_DBFS_LINK_STATE               _kkxlncagst        
KKXL_DBFS_LINK_GENERATE_PATH           _kkxlnbagup        
KKXL_DBFS_LINK_GENERATE_PATH           _kkxlncagup        
KKXL_GETMIMETYPE                       _kkxlnbgct         
KKXL_GETMIMETYPE                       _kkxlncgct         
KKXL_SETMIMETYPE                       _kkxlnbsct         
KKXL_SETMIMETYPE                       _kkxlncsct         

** package DBMS_LOBUTIL
file prvtlobu.plb

pl/sql                    oracle.exe

KKXLNU_GETINODE           _kkxlnubgi
KKXLNU_GETINODE           _kkxlnucgi
KKXLNU_GETLOBMAP          _kkxlnubgl
KKXLNU_GETLOBMAP          _kkxlnucgl

** package DBMS_LOCK
file: prvtlock.plb

pl/sql        oracle.exe

PSDLGT        _psdlgt
PSDLCV        _psdlcv
PSDLRL        _psdlrl
PSDWAT        _psdwat

** package DBMS_LOGMNR/X$DBMS_LOGMNR
file prvtlm.plb

pl/sql                  oracle.exe

KRVSTART                _krvstart
KRVARF                  _krvarf  
KRVEND                  _krvend  
KRVCP                   _krvcp   
KRVMV                   _krvmv   
KRVRRRF                 _krvrrrf 

** package DBMS_LOGMNR_INTERNAL
file prvtlmd.plb 

pl/sql           oracle.exe

KRVGDRM2         _krvgdrm2 
KRVGDRM          _krvgdrm  
KRVRMGB          _krvrmgb  
KRVUGASET        _krvugaset
KRVUGACLR        _krvugaclr
KRVRGSE          _krvrgse  
KRVRRSE          _krvrrse  
KRVSPD           _krvspd   

** package DBMS_NETWORK_ACL_ADMIN
file prvtnacl.plb

pl/sql                                oracle.exe

CHECK_PRIVILEGE_ACLID_I               _psdnopCheckPrivilege       
INVALIDATE_ACL                        _psdnopInvalidateACL        
INVALIDATE_WALLET_ACL                 _psdnopInvalidateWalletACL  
SKIP_ACL_11G_COMPATIBLE_CHECK         _psdnopSkipACL11gCompatCheck
VALID_IP_ADDRESS                      _psdnopValidIPAddress       

** package DBMS_NETWORK_ACL_UTILITY
file dbmsnacl.sql

pl/sql            oracle.exe

equals_host       _psdnopEqualsHost  
contains_host     _psdnopContainsHost

** package DBMS_OUTPUT/X$DBMS_OUTPUT
file prvtotpt.plb

pl/sql            oracle.exe

KKXERAE           _kkxerae

** package DBMS_PIPE/X$DBMS_PIPE
file prvtpipe.plb

SENDPIPE                          _kkxpput
RECEIVEPIPE                       _kkxpget
COPYINTOBUF                       _kkxpciv
COPYINTOBUF                       _kkxpcin
COPYINTOBUF                       _kkxpcid
COPYFROMBUF                       _kkxpcfv
COPYFROMBUF                       _kkxpcfn
COPYFROMBUF                       _kkxpcfd
GETTYPEFROMBUF                    _kkxpgty
COPYINTOBUFBINARY                 _kkxpcib
COPYINTOBUFROWID                  _kkxpcir
COPYFROMBUFBINARY                 _kkxpcfb
COPYFROMBUFROWID                  _kkxpcfr
CREATEPIPE                        _kkxpcre
REMOVEPIPE                        _kkxprem
UNIQUE_SESSION_ID                 _psduis 

** package DBMS_PITR
file prvtpitr.plb

pl/sql           oracle.exe

KRPIBEXP	 _krpibexp
KRPISTS		 _krpists
KRPIBIMP	 _krpibimp
KRPIACP		 _krpiacp
KRPIBTS		 _krpibts
KRPIDFV		 _krpidfv
KRPICPT		 _krpicpt

** package DBMS_PREPROCESSOR
file prvtpp.plb

pl/sql           oracle.exe

KKXCCG1          _kkxccg1
KKXCCG2          _kkxccg2
KKXCCG3          _kkxccg3

** package DBMS_PRVTAQIS
file prvtaqis.plb

pl/sql                 oracle.exe

KWQAACSET              _kwqaacset

** package DBMS_RCVMAN/X$DBMS_RCVMAN
file prvtrmns.plb

pl/sql           oracle.exe

KKXERAE          _kkxerae

** package DBMS_REPCAT_CACHE
file prvtrpch.plb

pl/sql              oracle.exe

KNCCPOG             _knccpog
KNCCLOG             _kncclog
KNCCROG             _knccrog
KNCCPPP             _knccppp
KNCCLPP             _kncclpp
KNCCRPI             _knccrpi
KNCCRPN             _knccrpn

** package DBMS_REPUTIL
file prvtgen.plb

pl/sql             oracle.exe

KKXTIOS            _kkxtios
KKXTGOS            _kkxtgos
KKXTR2V            _kkxtr2v

** package DBMS_RESULT_CACHE_API
file dbmsrcad.sql

pl/sql               oracle.exe

Get                  _qesrcAPI_GetR
GetC                 _qesrcAPI_GetC
Set                  _qesrcAPI_SetR
SetC                 _qesrcAPI_SetC

** package DBMS_ROWID
file prvtrwid.plb

pl/sql            oracle.exe

ROWIDBUILD        _kkxrdcr                
ROWIDINFO         _kkxrdir                
ROWIDAFN          _kkxrdafn              
ROWIDCNVTE        _kkxrdcve              
ROWIDCNVTR        _kkxrdcvr              

** package DBMS_SESSION
file prvtsess.plb

pl/sql                                  oracle.exe

EXECUTE_SQL                             _psdddl                        
PSDDIN                                  _psddin                        
PSDUIS                                  _psduis                        
PSDIRE                                  _psdire                        
PSDFMR                                  _psdfmr                        
PSDISA                                  _psdisa                        
KZCTXESC                                _kzctxesc                      
KZCTXGSI                                _kzctxgsi                      
KZCTXECC                                _kzctxecc                      
KZCTXGCI                                _kzctxgjci                     
KKKISWTCHINVGRP                         _kkkiswtchinvgrp               
PSDRIN                                  _psdrin                        
KZCTXECC1                               _kzctxecc1                     
KEWE_MYSESSION_TRACE_ENABLE             _kewe_mysession_trace_enable   
KEWE_MYSESSION_TRACE_DISABLE            _kewe_mysession_trace_disable  
KKAE_SET_EDITION_ICD                    _kkae_set_edition_icd          
PSD_PACKAGE_MEMORY_UTILIZATION          _psd_package_memory_utilization

** package DBMS_SHARED_POOL
file prvtpool.plb

pl/sql               oracle.exe

PSDKEP               _psdkep
PSDART               _psdart
PSDPUR               _psdpur

** package DBMS_SNAP_INTERNAL
file: prvtsnap.plb

pl/sql                    oracle.exe

KKZIDRO                   _kkzidro  
KKZISRO                   _kkzisro  
KKZICITI                  _kkziciti 
KKZITTI                   _kkzitti  
KKZIENMS                  _kkzienms 
KKZIESS                   _kkziess  
KKZIEOMS                  _kkzieoms 
KKZIBSRD                  _kkzibsrd 
KKZIBCRD                  _kkzibcrd 
KKZIIBTRD                 _kkziibtrd
KKZISBDB                  _kkzisbdb 
KKZIGBDB                  _kkzigbdb 

** package DBMS_SNAPSHOT
file: prvtsnap.plb

pl/sql            oracle.exe
PSDPLG            _kkzipli

** package DBMS_SNAPSHOT_UTL
file prvtsnap.plb

pl/sql                     oracle.exe

KKZIVCMP                   _kkzivcmp
PSDMSU                     _kkzimsi 
PSDMWU                     _kkzimwi 
PSDDSM                     _kkzidsi 
PSDRGS                     _kkzirsi 
PSDURS                     _kkziusi 
PSDCLN                     _kkzicli 

** package DBMS_SPACE
file prvtspcu.plb

pl/sql                               oracle.exe

KTSBUSP                              _ktsapus                       
KTSBFBL                              _ktsapfb                       
KTSAPS_INFO                          _ktsaps_info                   
KTSAPS_NGLOB_INFO                    _ktsaps_nglob_info             
KTSAP_CREATE_TABLE_COST              _ktsaps_create_table_cost      
KTSAP_OBJECT_SPACE_USAGE             _ktsaps_object_space_usage     
KTSAP_VERIFY_SHRINK_CANDIDATE        _ktsaps_verify_shrink_candidate
KTSAPS_DROPDF                        _ktsaps_DropDF                 

** package DBMS_SQL/DBMS_SYS_SQL
file dbmssql.sql, prvtsql.plb

pl/sql                           oracle.exe

bind_variable                    _kkxsbnadt     
bind_variable                    _kkxsbnref     
bind_variable                    _kkxsbntbl     
bind_variable                    _kkxsbnvar     
bind_variable                    _kkxsbnopq     
variable_value                   _kkxsgvadt     
variable_value                   _kkxsgvref     
variable_value                   _kkxsgvtbl     
variable_value                   _kkxsgvvar     
variable_value                   _kkxsgvopq     
define_column                    _kkxsdfadt     
define_column                    _kkxsdfref     
define_column                    _kkxsdftbl     
define_column                    _kkxsdfvar     
define_column                    _kkxsdfopq     
column_value                     _kkxsgcadt     
column_value                     _kkxsgcref     
column_value                     _kkxsgctbl     
column_value                     _kkxsgcvar     
column_value                     _kkxsgcopq     
ICD_OPEN                         _kkxsopn       
ICD_IS_OPEN                      _kkxsiso       
ICD_CLOSE                        _kkxscls       
ICD_PARSE                        _kkxsprs       
ICD_PARSECLB                     _kkxsprsclb    
ICD_BIND                         _kkxsbnn       
ICD_BIND                         _kkxsbnv       
ICD_BIND                         _kkxsbnl       
ICD_BIND                         _kkxsbnd       
ICD_BIND_C                       _kkxsbnc       
ICD_BIND_C                       _kkxsbnh       
ICD_BIND_R                       _kkxsbnr       
ICD_BIND_I                       _kkxsbni       
ICD_DEFINE                       _kkxsdfn       
ICD_DEFINE                       _kkxsdfv       
ICD_DEFINE                       _kkxsdfd       
ICD_DEFINE_C                     _kkxsdfc       
ICD_DEFINE_R                     _kkxsdfr       
ICD_DEFINE_I                     _kkxsdfi       
ICD_EXECUTE                      _kkxsexe       
ICD_FETCH                        _kkxsfcn       
ICD_GET_C                        _kkxsgcn       
ICD_GET_C                        _kkxsgcv       
ICD_GET_C                        _kkxsgcd       
ICD_GET_C_C                      _kkxsgcc       
ICD_GET_C_R                      _kkxsgcr       
ICD_GET_C_I                      _kkxsgci       
ICD_GET_L                        _kkxsgcl       
ICD_GET_E                        _kkxsgce       
ICD_GET_V                        _kkxsgvn       
ICD_GET_V                        _kkxsgvv       
ICD_GET_V                        _kkxsgvd       
ICD_GET_V_C                      _kkxsgvc       
ICD_GET_V_R                      _kkxsgvr       
ICD_GET_V_I                      _kkxsgvi       
ICD_GET_V                        _kkxsgvnt      
ICD_GET_V                        _kkxsgvct      
ICD_GET_V                        _kkxsgvdt      
ICD_GET_V                        _kkxsgvblt     
ICD_GET_V                        _kkxsgvclt     
ICD_GET_V                        _kkxsgvbft     
ICD_LEP                          _kkxslep       
ICD_LCT                          _kkxslct       
ICD_LRC                          _kkxslrc       
ICD_LRI                          _kkxslri       
ICD_DUMP                         _kkxsdmp       
ICD_GET_RPI_CURSOR               _kkxsgrc       
ICD_PARSE_ARRAY_PARSE            _kkxspap       
ICD_PARSE_ARRAY_INIT             _kkxspil       
ICD_PARSE_ARRAY_INIT             _kkxspin       
ICD_PARSE_ARRAY_SEND_LF          _kkxspsl       
ICD_PARSE_ARRAY_SEND             _kkxspsn       
ICD_BIND_M                       _kkxsbnm       
ICD_DEFINE_M                     _kkxsdfm       
ICD_GET_C_M                      _kkxsgcm       
ICD_GET_V_M                      _kkxsgvm       
ICD_GET_C_L                      _kkxscvl       
ICD_DEFINE_L                     _kkxsdfl       
ICD_BIND                         _kkxsbnblob    
ICD_BIND                         _kkxsbnclob    
ICD_BIND                         _kkxsbnbfil    
ICD_DEFINE                       _kkxsdfblob    
ICD_DEFINE                       _kkxsdfclob    
ICD_DEFINE                       _kkxsdfbfil    
ICD_DESCRIBE_INITIAL             _kkxsdescinit  
ICD_DESCRIBE_COLUMN              _kkxsdesccol   
ICD_GET_C                        _kkxsgcblob    
ICD_GET_C                        _kkxsgcclob    
ICD_GET_C                        _kkxsgcbfile   
ICD_GET_V                        _kkxsgvblob    
ICD_GET_V                        _kkxsgvclob    
ICD_GET_V                        _kkxsgvbfile   
ICD_BIND_ARRAY                   _kkxsbarnt     
ICD_BIND_ARRAY                   _kkxsbarct     
ICD_BIND_ARRAY                   _kkxsbardt     
ICD_BIND_ARRAY                   _kkxsbarnti    
ICD_BIND_ARRAY                   _kkxsbarcti    
ICD_BIND_ARRAY                   _kkxsbardti    
ICD_DEFINE_ARRAY                 _kkxsdarnt     
ICD_DEFINE_ARRAY                 _kkxsdarct     
ICD_DEFINE_ARRAY                 _kkxsdardt     
ICD_GET_C                        _kkxscvnt      
ICD_GET_C                        _kkxscvct      
ICD_GET_C                        _kkxscvdt      
ICD_BIND_ARRAY                   _kkxsbarblt    
ICD_BIND_ARRAY                   _kkxsbarclt    
ICD_BIND_ARRAY                   _kkxsbarbft    
ICD_BIND_ARRAY                   _kkxsbarblti   
ICD_BIND_ARRAY                   _kkxsbarclti   
ICD_BIND_ARRAY                   _kkxsbarbfti   
ICD_DEFINE_ARRAY                 _kkxsdarblt    
ICD_DEFINE_ARRAY                 _kkxsdarclt    
ICD_DEFINE_ARRAY                 _kkxsdarbft    
ICD_GET_C                        _kkxscvblt     
ICD_GET_C                        _kkxscvclt     
ICD_GET_C                        _kkxscvbft     
ICD_BIND_U                       _kkxsbnu       
ICD_DEFINE_U                     _kkxsdfu       
ICD_GET_C_U                      _kkxsgcu       
ICD_GET_V_U                      _kkxsgvu       
ICD_BIND_ARRAY                   _kkxsbarut     
ICD_BIND_ARRAY                   _kkxsbaruti    
ICD_DEFINE_ARRAY                 _kkxsdarut     
ICD_GET_C                        _kkxscvurt     
ICD_GET_V                        _kkxsgvurt     
ICD_BIND_DT                      _kkxsbnt       
ICD_DEFINE_DT                    _kkxsdft       
ICD_GET_C_DT                     _kkxsgct       
ICD_GET_V_DT                     _kkxsgvt       
ICD_BIND_ARRAY                   _kkxsbartt     
ICD_BIND_ARRAY                   _kkxsbartti    
ICD_DEFINE_ARRAY                 _kkxsdartt     
ICD_GET_C                        _kkxscvtmt     
ICD_GET_V                        _kkxsgvtmt     
ICD_BIND_DT                      _kkxsbnts      
ICD_DEFINE_DT                    _kkxsdfts      
ICD_GET_C_DT                     _kkxsgcts      
ICD_GET_V_DT                     _kkxsgvts      
ICD_BIND_ARRAY                   _kkxsbartst    
ICD_BIND_ARRAY                   _kkxsbartsti   
ICD_DEFINE_ARRAY                 _kkxsdartst    
ICD_GET_C                        _kkxscvtst     
ICD_GET_V                        _kkxsgvtst     
ICD_BIND_DT                      _kkxsbnttz     
ICD_DEFINE_DT                    _kkxsdfttz     
ICD_GET_C_DT                     _kkxsgcttz     
ICD_GET_V_DT                     _kkxsgvttz     
ICD_BIND_ARRAY                   _kkxsbarttzt   
ICD_BIND_ARRAY                   _kkxsbarttzti  
ICD_DEFINE_ARRAY                 _kkxsdarttzt   
ICD_GET_C                        _kkxscvttzt    
ICD_GET_V                        _kkxsgvttzt    
ICD_BIND_DT                      _kkxsbntstz    
ICD_DEFINE_DT                    _kkxsdftstz    
ICD_GET_C_DT                     _kkxsgctstz    
ICD_GET_V_DT                     _kkxsgvtstz    
ICD_BIND_ARRAY                   _kkxsbartstzt  
ICD_BIND_ARRAY                   _kkxsbartstzti 
ICD_DEFINE_ARRAY                 _kkxsdartstzt  
ICD_GET_C                        _kkxscvtstzt   
ICD_GET_V                        _kkxsgvtstzt   
ICD_BIND_DT                      _kkxsbntsltz   
ICD_DEFINE_DT                    _kkxsdftsltz   
ICD_GET_C_DT                     _kkxsgctsltz   
ICD_GET_V_DT                     _kkxsgvtsltz   
ICD_BIND_ARRAY                   _kkxsbartsltzt 
ICD_BIND_ARRAY                   _kkxsbartsltzti
ICD_DEFINE_ARRAY                 _kkxsdartsltzt 
ICD_GET_C                        _kkxscvtsltzt  
ICD_GET_V                        _kkxsgvtsltzt  
ICD_BIND_INT                     _kkxsbniym     
ICD_DEFINE_INT                   _kkxsdfiym     
ICD_GET_C_INT                    _kkxsgciym     
ICD_GET_V_INT                    _kkxsgviym     
ICD_BIND_ARRAY                   _kkxsbariymt   
ICD_BIND_ARRAY                   _kkxsbariymti  
ICD_DEFINE_ARRAY                 _kkxsdariymt   
ICD_GET_C                        _kkxscviymt    
ICD_GET_V                        _kkxsgviymt    
ICD_BIND_INT                     _kkxsbnids     
ICD_DEFINE_INT                   _kkxsdfids     
ICD_GET_C_INT                    _kkxsgcids     
ICD_GET_V_INT                    _kkxsgvids     
ICD_BIND_ARRAY                   _kkxsbaridst   
ICD_BIND_ARRAY                   _kkxsbaridsti  
ICD_DEFINE_ARRAY                 _kkxsdaridst   
ICD_GET_C                        _kkxscvidst    
ICD_GET_V                        _kkxsgvidst    
ICD_BIND                         _kkxsbnbfl     
ICD_DEFINE                       _kkxsdfbfl     
ICD_GET_C                        _kkxsgcbfl     
ICD_GET_V                        _kkxsgvbfl     
ICD_BIND_ARRAY                   _kkxsbarbflt   
ICD_BIND_ARRAY                   _kkxsbarbflti  
ICD_DEFINE_ARRAY                 _kkxsdarbflt   
ICD_GET_C                        _kkxscvbflt    
ICD_GET_V                        _kkxsgvbflt    
ICD_BIND                         _kkxsbnbdb     
ICD_DEFINE                       _kkxsdfbdb     
ICD_GET_C                        _kkxsgcbdb     
ICD_GET_V                        _kkxsgvbdb     
ICD_BIND_ARRAY                   _kkxsbarbdbt   
ICD_BIND_ARRAY                   _kkxsbarbdbti  
ICD_DEFINE_ARRAY                 _kkxsdarbdbt   
ICD_GET_C                        _kkxscvbdbt    
ICD_GET_V                        _kkxsgvbdbt    
ICD_TO_REFCURSOR                 _kkxstorefc    
ICD_TO_CURSOR_NUMBER             _kkxstocurn    
ICD_INIT_CUR_TAB                 _kkxsinit      

** package DBMS_STANDARD
files: dbmsstdx.sql

pl/sql                            oracle.exe

raise_application_error           _kkxerae
inserting                         _psdins
deleting                          _psddel
updating                          _psdupd
updating                          _psdupc
commit                            _psdtcm
commit_cm                         _psdtcc
rollback_nr                       _psdtrl
rollback_sv                       _psdtrs
savepoint                         _psdtsv
set_transaction_use               _psdttu
sysevent                          _qdesysevent
dictionary_obj_type               _qdeobjtyp
dictionary_obj_owner              _qdeownobj
dictionary_obj_name               _qdenmobj
database_name                     _qdedbnam
instance_num                      _qdeinstnm
login_user                        _qdeuser
is_servererror                    _qdeiserror
server_error                      _qdegeterror
des_encrypted_password            _qdepasswd
is_alter_column                   _qdeisaltcol
is_drop_column                    _qdeisdrpcol
grantee                           _qdegrantee
revokee                           _qderevokee
privilege_list                    _qdeprivilege
with_grant_option                 _qdegntoption
dictionary_obj_owner_list         _qdeowlobj
dictionary_obj_name_list          _qdenmlobj
is_creating_nested_table          _qdeisnested
client_ip_address                 _qdeipaddress
sql_txt                           _qdesqltxt
server_error_msg                  _qdeerrmsg
server_error_depth                _qdeedepth
server_error_num_params           _qdeenparam
server_error_param                _qdeeparam
partition_pos                     _qdeprtpos
Sys_GetTriggerState               _Sys_GetTriggerState
applying_crossedition_trigger     _psdacet

** package DBMS_STATS
file prvtstat.plb

pl/sql                            oracle.exe

NORMALIZE_AND_CONVERT_ICD         _qosncrui
CONVERT_FROM_RAW_ICD              _qoscfrui

** package DBMS_SYS_ERROR/X$DBMS_SYS_ERROR
file prvtsyer.plb 

pl/sql                 oracle.exe

KKXERE1                _kkxerse
KKXERE0                _kkxerse
KKXERE2                _kkxerse
KKXERE3                _kkxerse
KKXERE4                _kkxerse
KKXERE5                _kkxerse
KKXERE6                _kkxerse
KKXERE7                _kkxerse
KKXERE8                _kkxerse

** package DBMS_SYSTEM
file prvtsys.plb

pl/sql                          oracle.exe

SET_EV_ICD                      _psdsev
READ_EV_ICD                     _psdrev
DIST_TXN_SYNC_ICD               _psddts 
KSDWRT_ICD                      _psdwrt  
KSDFLS_ICD                      _psdfls  
KSDDDT_ICD                      _psdddt  
KSDIND_ICD                      _psdind  
KCFRMS_ICD                      _psdrms  
SET_SESSPAR_ICD                 _psdsps  
WAIT_FOR_EVENT_ICD              _psdwte  
GET_ENV_ICD                     _psdgev

** package DBMS_TRANSACTION
file dbmstrns.sql

pl/sql                             oracle.exe

commit                             _psdtcm
savepoint                          _psdtsv
rollback                           _psdtrl
rollback_savepoint                 _psdtrs
begin_discrete_transaction         _psdbot

** package DBMS_TRANSACTION_INTERNAL_SYS
file prvttrns.plb

pl/sql                 oracle.exe

PSDGCSCN               _psdgcscn          

** package DBMS_UTILITY
file dbmsutil.sql, prvtutil.plb

pl/sql                         oracle.exe

format_error_stack             _psdfes                 
format_call_stack              _psdfcs                 
get_endianness                 _psdgend                
format_error_backtrace         _psdfeb                 
IS_PARALLEL                    _psdirm                   
ICD_GET_TIME                   _psdgtm                   
ICD_NAME_RES                   _psdres                   
ICD_NAME_TOKENIZE              _psdnam                   
PSDPOR                         _psdpor                   
ICD_DBA                        _psddba                  
ICD_DBA_FILE                   _psdfil                  
ICD_DBA_BLOCK                  _psdblk                  
PSDDBV                         _psddbv                   
ICD_HASH                       _psdhsh                  
KSPGPNICD                      _kspgpnicd                
PSDANAM                        _psdanam                
PSDCNAM                        _psdcnam                
PSDGTR                         _psdgtr                 
PSDOCS                         _psdocs                 
PSDOCU                         _psdocu                 
KESUTLSQLIDTOHASHICD           _kesutlSqlIdToHashIcd   
PSD_VALIDATE                   _psd_validate            
ICD_GET_CPU_TIME               _psdgcputm              
ICD_GETSQLHASH                 _psdsqlhash             
PSD_INVALIDATE                 _psd_invalidate         
PSD_WAIT_ON_PENDING_DML        _psd_wait_on_pending_dml   

** package DIUTIL
file diutil.sql

pl/sql                             oracle.exe

diugdn                             _diugdn                      
diustx                             _diustx                      
diu_node_use_statistics            _diu_node_use_statistics     
diu_attribute_use_statistics       _diu_attribute_use_statistics

** package MD
file prvtmd.plb

pl/sql                        oracle.exe

MDIGNDM                       _mdigndm   
MDIBYTL                       _mdibytl   
MDIPTOE                       _mdiptoe   
MDILTOE                       _mdiltoe   
MDIDECD                       _mdidecd   
MDIENCD1                      _mdiencd   
MDIENCD2                      _mdiencd   
MDICELL                       _mdicell   
MDISBST                       _mdisbst   
MDICMCD                       _mdicmcd   
MDISBDV                       _mdisbdv   
MDIMTCH                       _mdimtch   
MDIORBY                       _mdiorby   
MDIJTOS                       _mdijtos   
MDISTOJ                       _mdistoj   
MDIHLEN1                      _mdihlen   
MDIHLEN2                      _mdihlen   
MDICMPR                       _mdicmpr   
MDINCMP                       _mdincmp   
MDICOLP                       _mdicolp   
MDICOMP                       _mdicomp   
MDIDIST                       _mdidist   
MDICLSZ                       _mdiclsz   
MDISTPB                       _mdistpb   
MDIGTPB                       _mdigtpb   
MDISTID                       _mdistid   
MDIGTID                       _mdigtid   
MDICBIT                       _mdicbit   
MDISBIT                       _mdisbit   
MDIGBIT                       _mdigbit   
MDIINCL                       _mdiincl   
MDIGCID                       _mdigcid   
MDISCID                       _mdiscid   
MDIHAND                       _mdihand   
MDIHHOR                       _mdihhor   
MDIHXOR                       _mdihxor   
MDIIDPP                       _mdiidpp   
MDIIDPR                       _mdiidpr   
MDIHTOB                       _mdihtob   
MDIIDLR                       _mdiidlr   
MDIIDLP                       _mdiidlp   
MDIRNDM                       _mdirndm   
MDIRNCD                       _mdirncd   
MDICKRF                       _mdickrf   
MDIRMDE                       _mdirmde   
MDISC                         _mdisc     
MDIMBRLL                      _mdimbrll  
MDIMBRUR                      _mdimbrur  
MDIMXCD                       _mdimxcd   
?                             _mdidmmy   

** package MD1
file prvtmd1.plb

pl/sql                  oracle.exe

MDIFCOMPARE             _mdifcompare
MDIFCOMPARE             _mdifcompare
MDIFLL2DIM              _mdifll2dim 
MDIFDAT2DIM             _mdifdat2dim
MDIFBV2DIM              _mdifbv2dim 
MDIFHV2DIM              _mdifhv2dim 
MDIFENCODE              _mdifencode 
MDIFDECODE              _mdifdecode 
MDIFDIM2LAT             _mdifdim2lat
MDIFDIM2LON             _mdifdim2lon
MDIFDIM2DATE            _mdifdim2dat
MDIFDIM2BV              _mdifdim2bv 
MDIFDIM2HV              _mdifdim2hv 
?                       _mdisellil  
?                       _mdiselgil  
?                       _mdiselgigs 
?                       _mdiselgig  

** package MD2
file prvtmd2.plb

pl/sql                 oracle.exe

MDITESS                _mditess 
MDIINT                 _mdiint  
MDIREL                 _mdirel  
MDIPCT0                _mdipcto 
MDIINTF                _mdiintf 
MDIRELF                _mdirelf 
MDICDSZ                _mdicdsz 
MDIVG                  _mdivg   
MDIGLNLN               _mdiglnln
MDICDF0                _mdicdf0 
MDICDF1                _mdicdf1 
MDICDF2                _mdicdf2 
?                      _mdicdf3 
?                      _mdicdf4 
?                      _mdicdf5 
?                      _mdicdf6 
?                      _mdicdf7 
?                      _mdicdf8 
?                      _mdicdf9 

** package PBREAK
file prvtpb.plb

pl/sql                              orapls11.dll

PBBSD                               _pbbsd          
PBBOPT                              _pbbopt          
PBBHS                               _pbbhs          
PBBIOER                             _pbbioer        
PBBBL                               _pbbbl          
PBBRB                               _pbbrb          
PBBEB                               _pbbeb          
PBBDB                               _pbbdb          
PBBEVENT                            _pbbevent       
PBBPBS                              _pbbpbs         
PBBSPF                              _pbbspf         
PBBGPF                              _pbbgpf         
PBBGLN                              _pbbgln         
PBBPSL                              _pbbpsl         
GET_TIDL_FRAME                      _pbbgtf         
DO_PRINT_BACKTRACE                  _pbbpbt         
DEBUG_MESSAGE_AUX                   _pbbwdm         
PBBISET                             _pbbiset        
PBBIGET                             _pbbiget        
PBBIGINDEXES                        _pbbigindexes   
PBBIBACKTRACE                       _pbbibacktrace  
PBBIBREAKPOINTS                     _pbbibreakpoints
PBBICDVCK                           _pbbicdvck      
PBBILSPKGS                          _pbbilspkgs     
PBBICDISEXE                         _pbbicdisexe    
PBBPSLF                             _pbbpslf        
PBBGLM                              _pbbglm         

** package PBSDE
file prvtpb.plb

pl/sql                             oracle.exe

KQAIVSN                            _kqaivsn                 
KQAIPDE                            _kqaipde                 

** package PIDL
file pipidl.sql

pl/sql                 oracle.exe

pig_tx                 _pig_tx
pig_nd                 _pig_nd
pig_u4                 _pig_u4
pig_u2                 _pig_u2
pig_u1                 _pig_u1
pig_s4                 _pig_s4
pig_s2                 _pig_s2
pig_pt                 _pig_pt
pigsnd                 _pigsnd
pip_tx                 _pip_tx
pip_nd                 _pip_nd
pip_u4                 _pip_u4
pip_u2                 _pip_u2
pip_u1                 _pip_u1
pip_s4                 _pip_s4
pip_s2                 _pip_s2
pip_pt                 _pip_pt
pigetx                 _pigetx
pigend                 _pigend
pigeu4                 _pigeu4
pigeu2                 _pigeu2
pigeu1                 _pigeu1
piges4                 _piges4
piges2                 _piges2
pigept                 _pigept
pidkin                 _pidkin
pidtin                 _pidtin
pidnxt                 _pidnxt
pidacn                 _pidacn
pidaty                 _pidaty
pidnnm                 _pidnnm
pidanm                 _pidanm
pidbty                 _pidbty
pidrty                 _pidrty
pigsln                 _pigsln

** package PLITBLM/X$PLITBLM
file plitblm.sql

pl/sql                oracle.exe

count                 _petico 
first                 _petifi 
last                  _petili 
exists                _petiex 
prior                 _petipr 
next                  _petinx 
delete                _petid1 
delete                _petid2 
delete                _petid2 
delete                _petid3 
delete                _petid3 
limit                 _petilm 
trim                  _petitr 
trim                  _petitr 
extend                _petie1 
extend                _petie1 
extend                _petie2 
extend                _petie2 
count                 _peticoa
first                 _petifia
last                  _petilia
exists                _petiexa
prior                 _petipra
next                  _petinxa
delete                _petid1a
delete                _petid2a
delete                _petid3a

** package PRVT_COMPRESSION
file prvtcmpr.plb

pl/sql         oracle.exe

KDZCHECKHI     _kdzcheckhi

** package STANDARD/X$STANDARD
files: stdbody.sql, stdspec.sql

pl/sql            oraplp11.dll

pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pesist            _pesist             
pesupp            _pesupp             
peslow            _peslow             
pesasc            _pesasc             
pesastr           _pesastr            
pesustr           _pesustr            
peschr            _peschr             
peschr            _peschr             
pesicp            _pesicp             
peslpd            _peslpd             
peslpd            _peslpd             
pesrpd            _pesrpd             
pesrpd            _pesrpd             
pesrep            _pesrep             
pesltr            _pesltr             
pesltr            _pesltr             
pesrtr            _pesrtr             
pesrtr            _pesrtr             
peslik            _peslik             
pesli2            _pesli2             
pes_dummy         _pes_dummy          
pesmod            _pesmod             
pesflo            _pesflo             
pescei            _pescei             
pessqt            _pessqt             
pessgn            _pessgn             
pescos            _pescos             
pessin            _pessin             
pestan            _pestan             
pescsh            _pescsh             
pessnh            _pessnh             
pestnh            _pestnh             
pesexp            _pesexp             
pesln             _pesln              
pesbtd            _pesbtd             
pesbtdn           _pesbtdn            
peslog            _peslog             
pestru            _pestru             
pesrnd            _pesrnd             
pespow            _pespow             
pesnwt            _pesnwt             
pesc2d            _pesc2d             
pesc2n            _pesc2n             
pesc2n            _pesc2n             
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
peszle            _peszle             
peszlt            _peszlt             
peszeq            _peszeq             
pes_invert        _pes_dummy          
pesxco            _pesxco             
pesxup            _pesxup             
peslcnup          _peslcnup           
peslcnup          _peslcnup           
pesxlo            _pesxlo             
peslcnlr          _peslcnlr           
peslcnlr          _peslcnlr           
pesxcp            _pesxcp             
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pesxis            _pesxis             
pesxsi            _pesxsi             
pesxmu            _pesxmu             
pesd2c            _pesd2c             
pesn2c            _pesn2c             
pesd2c            _pesd2c             
pesn2c            _pesn2c             
pesxcs            _pesxcs             
pesatan           _pesatan            
peslcem           _peslcem            
peslbem           _peslbem            
pesfnm            _pesfnm             
pes3tm            _pes3tm             
pes3tm            _pes3tm             
pes3ts            _pes3ts             
pes3ts            _pes3ts             
pes3tp            _pes3tp             
pes3tp            _pes3tp             
pes3te            _pes3te             
pes3te            _pes3te             
pes2dsi           _pes2dsi            
pesatz            _pesatz             
pesatz            _pesatz             
pesstz            _pesstz             
pestrim           _pestrim            
pestrim           _pestrim            
pestrim           _pestrim            
pestrim           _pestrim            
pesati            _pesati             
pesati            _pesati             
pesati            _pesati             
pesati            _pesati             
pesati            _pesati             
pesati            _pesati             
pesadi            _pesadi             
pesadi            _pesadi             
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pesaii            _pesaii             
pesaii            _pesaii             
pesati            _pesati             
pesati            _pesati             
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pessti            _pessti             
pessti            _pessti             
pessti            _pessti             
pessti            _pessti             
pessti            _pessti             
pessti            _pessti             
pessdi            _pessdi             
pessdi            _pessdi             
pessii            _pessii             
pessii            _pessii             
pessttds          _pessttds           
pessttds          _pessttds           
pessttds          _pessttds           
pessttds          _pessttds           
pessti            _pessti             
pessti            _pessti             
pessttds          _pessttds           
pessttds          _pessttds           
pessttds          _pessttds           
pessttds          _pessttds           
pessttds          _pessttds           
pessddds          _pessddds           
pessttds          _pessttds           
pessttym          _pessttym           
pessttym          _pessttym           
pessddym          _pessddym           
pessttym          _pessttym           
pesmni            _pesmni             
pesmni            _pesmni             
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pesdvin           _pesdvin            
pesdvin           _pesdvin            
pes_dummy         _pes_dummy          
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pescdt            _pescdt             
pesctm            _pesctm             
pescts            _pescts             
pesc2ymi          _pesc2ymi           
pesc2dsi          _pesc2dsi           
pesc2tim          _pesc2tim           
pesc2tim          _pesc2tim           
pesc2tsp          _pesc2tsp           
pesc2tsp          _pesc2tsp           
pesc2date         _pesc2date          
pesefd            _pesefd             
pesefd            _pesefd             
pesefd            _pesefd             
pesefd            _pesefd             
pesefd            _pesefd             
pesefdt           _pesefdt            
pesefi            _pesefi             
pesefi            _pesefi             
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
peslcln           _peslcln            
peslclb           _peslclb            
peslcst           _peslcst            
peslcsb           _peslcsb            
peslcin           _peslcin            
peslcib           _peslcib            
peslcct           _peslcct            
peslcct           _peslcct            
peslclp           _peslclp            
peslclp           _peslclp            
peslcrp           _peslcrp            
peslcrp           _peslcrp            
peslclr           _peslclr            
peslcup           _peslcup            
peslclm           _peslclm            
peslclm           _peslclm            
peslcrm           _peslcrm            
peslcrm           _peslcrm            
peslctr           _peslctr            
peslctr           _peslctr            
peslctr           _peslctr            
peslctr           _peslctr            
peslclk           _peslclk            
peslcl2           _peslcl2            
peslcnl           _peslcnl            
peslcrl           _peslcrl            
pes_dummy         _pes_dummy          
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pes_flip          _pes_dummy          
pes_dummy         _pes_dummy          
pesleq2           _pesleq2            
pes_invert        _pes_dummy          
pes_flip          _pes_dummy          
pesllt2           _pesllt2            
pes_flip          _pes_dummy          
peslle2           _peslle2            
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pes_flip          _pes_dummy          
pesllt3           _pesllt3            
pes_flip          _pes_dummy          
peslle3           _peslle3            
peslbln           _peslbln            
peslblb           _peslblb            
pestzo            _pestzo             
pesftz            _pesftz             
pesinc            _pesinc             
pescnv            _pescnv             
pescnv            _pescnv             
peslccnv          _peslccnv           
peslccnv          _peslccnv           
pesefdrvc2        _pesefdrvc2         
pesefdrvc2        _pesefdrvc2         
pesefdrvc2        _pesefdrvc2         
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesdtm2c          _pesdtm2c           
pesitv2c          _pesitv2c           
pesitv2c          _pesitv2c           
pesitv2c          _pesitv2c           
pesitv2c          _pesitv2c           
pesist2           _pesist2            
pesist4           _pesist4            
pesistc           _pesistc            
peslen2           _peslen2            
peslen4           _peslen4            
peslenc           _peslenc            
peslik2           _peslik2            
pesli22           _pesli22            
peslik4           _peslik4            
pesli42           _pesli42            
peslikc           _peslikc            
peslic2           _peslic2            
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pessexu           _pessexu            
pescomp           _pescomp            
pesdcmp           _pesdcmp            
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pesnanf           _pesnanf            
pesnand           _pesnand            
pesinf            _pesinf             
pesinff           _pesinff            
pesinfd           _pesinfd            
pesc2flt          _pesc2flt           
pesc2flt          _pesc2flt           
pesc2dbl          _pesc2dbl           
pesc2dbl          _pesc2dbl           
pesflt2c          _pesflt2c           
pesdbl2c          _pesdbl2c           
pesflt2c          _pesflt2c           
pesdbl2c          _pesdbl2c           
pesflt2c          _pesflt2c           
pesdbl2c          _pesdbl2c           
pesflt2c          _pesflt2c           
pesdbl2c          _pesdbl2c           
pesrem            _pesrem             
pesrem            _pesrem             
pesremf           _pesremf            
pesremf           _pesremf            
pesremd           _pesremd            
pesremd           _pesremd            
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pesatand          _pesatand           
pesmodf           _pesmodf            
pesmodd           _pesmodd            
pesflof           _pesflof            
pesflod           _pesflod            
pesceif           _pesceif            
pesceid           _pesceid            
pessqtf           _pessqtf            
pessqtd           _pessqtd            
pessgnf           _pessgnf            
pessgnd           _pessgnd            
pessgni           _pessgni            
pescosd           _pescosd            
pessind           _pessind            
pestand           _pestand            
pescshd           _pescshd            
pessnhd           _pessnhd            
pestnhd           _pestnhd            
pesexpd           _pesexpd            
peslnd            _peslnd             
peslogd           _peslogd            
pestruf           _pestruf            
pestrud           _pestrud            
pestrui           _pestrui            
pesrndf           _pesrndf            
pesrndd           _pesrndd            
pesrndi           _pesrndi            
pespowd           _pespowd            
pesmcnt           _pesmcnt            
pesmie            _pesmie             
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_invert        _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pespow            _pespow             
pespowd           _pespowd            
pesacosd          _pesacosd           
pesasind          _pesasind           
pesatn2d          _pesatn2d           
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pes_dummy         _pes_dummy          
pesxlt            _pesxlt             
pesxco            _pesxco             
pesxup            _pesxup             
pesxlo            _pesxlo             
pesxcp            _pesxcp             
pessdx            _pessdx             
pesuen            _pesuen             
pesacos           _pesacos            
pesasin           _pesasin            
pesatn2           _pesatn2            
plzsql            _plzsql             
pesn2ymi          _pesn2ymi           
pesn2dsi          _pesn2dsi           
pessdt            _pessdt             
pessysctx2        _pessysctx2         
pessts            _pessts             
pesdbtz           _pesdbtz            
pessysctx3        _pessysctx3         

** package USER_LOCK
file: userlock.sql

pl/sql       oracle.exe

psdlgt       _psdlgt
psdlcv       _psdlcv
psdlrl       _psdlrl
psdwat       _psdwat

** package UTL_MATCH
file utlmatch.sql

pl/sql                            oraplp11.dll

edit_distance                     _pi_edit_distance
jaro_winkler                      _pi_jaro_winkler 
edit_distance_similarity          _pi_ed_similarity
jaro_winkler_similarity           _pi_jw_similarity

** package UTL_PG
file prvtpgb.plb

pl/sql               oraplp11.dll

PIRGMRF              _pirgmrf 
PIRGMNF              _pirgmnf 
PIRGR2N              _pirgr2n 
PIRGN2R              _pirgn2r 
PIRGR2F              _pirgr2f 
PIRGN2F              _pirgn2f 
PIRGWCNT             _pirgwcnt
PIRGWMSG             _pirgwmsg

** package UTL_RAW
file prvtrawb.plb

pl/sql              oraplp11.dll

PIRGCON             _pirgcon
PIRG2RW             _pirgcas
PIRG2VC             _pirgcas
PIRGTRN             _pirgtrn
PIRGTRS             _pirgtrs
PIRGOVR             _pirgovr
PIRGCOP             _pirgcop
PIRGXRA             _pirgxra
PIRGREV             _pirgrev
PIRGCMP             _pirgcmp
PIRGOPR             _pirgopr
PIRGCOM             _pirgcom
PIRGCNR             _pirgcnr
PIRGSUB             _pirgsub
PIRG2NVC            _pirgcas
PIRG2NM             _pirg2nm
PIRGFNM             _pirgfnm
PIRG2BI             _pirg2bi
PIRGFBI             _pirgfbi
PIRG2BF             _pirg2bf
PIRGFBF             _pirgfbf
PIRG2BD             _pirg2bd
PIRGFBD             _pirgfbd
PIRGLEN             _pirglen

** package WPIUTL
file wpiutil.sql

pl/sql             oracle.exe

describe           _wpiudsc_describe_subprog

** Packages probably present in Oracle, but I did not find any reference to them in standard installation.

DIO
DBMS_DEFER_PACK/DBMS_DEFER
OID_TEST
TEST_KSI
TEST_KSQ
TEST_TXMGMT
DBMS_LOGMNR_D
TEST_KJXGN
DBMS_DISKGROUP/X$DBMS_DISKGROUP
DBMS_UWDB
_PRE_END

_BLOG_FOOTER_GITHUB(`50')

_BLOG_FOOTER()

