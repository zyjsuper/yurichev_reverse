m4_include(`commons.m4')

_HEADER_HL1(`7-Feb-2017: SAP cluster table unpacker')

<p>SAP has a special <i>cluster tables</i> located in SAPSR3.RFBLG table (as of Oracle RDBMS), which contains compressed blob data
for tables like BSEG, BSET, BSEC, BSED, etc.</p>

<p>There is a rumour that at some distant point of history, Oracle didn't have support for >256 columns, but SAP needed more (>300), so they packed all columns
into compressed blob.</p>

<p>I've just written an utility to unpack these tables, here are first ~60 columns (empty columns are suppressed) for demo IDES database:</p>

_PRE_BEGIN
unpack_chunk() name=BSEG       MANDT=800 BUKRS=0001 BELNR=0100000000 GJAHR=1995 BUZEI=001
BUZEI: [001]
BSCHL: [40]
DMBTR: [6,14]
WRBTR: [12,00]
PSWBT: [6,14]
PSWSL: [EUR  ]
VALUT: [19950606]
ZUONR: [19950606          ]
SGTXT: [(text)                                            ]
VORGN: [RFBU]
HKONT: [0000100000]
unpack_chunk() name=BSEG       MANDT=800 BUKRS=0001 BELNR=0100000000 GJAHR=1995 BUZEI=002
BUZEI: [002]
BSCHL: [50]
DMBTR: [6,14]
WRBTR: [12,00]
PSWBT: [6,14]
PSWSL: [EUR  ]
ZUONR: [19950606          ]
VORGN: [RFBU]
KOKRS: [0001]
HKONT: [0000399999]
unpack_chunk() name=BSEG       MANDT=800 BUKRS=0005 BELNR=0100000000 GJAHR=2005 BUZEI=001
BUZEI: [001]
BSCHL: [40]
DMBTR: [60000,00]
WRBTR: [60000,00]
PSWBT: [60000,00]
PSWSL: [EUR  ]
VALUT: [20051231]
ZUONR: [20051231          ]
SGTXT: [Test for Allocation FI                            ]
ALTKT: [0000110100]
VORGN: [RFBU]
FDLEV: [F0]
FDWBT: [60000,00]
FDTAG: [20051231]
KOKRS: [1000]
HKONT: [0000113100]
_PRE_END

<p>Full IDES dump: _HTML_LINK_AS_IS(`https://yurichev.com/tmp/results.rar').</p>

<p>Anyone interesting in buying such utility? Please contact me then: <b>dennis(a)yurichev.com</b>.</p>

_BLOG_FOOTER_GITHUB(`SAP')

_BLOG_FOOTER()

