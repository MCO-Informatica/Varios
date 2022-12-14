#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw?WSDL 
Gerado em        10/13/17 15:53:34
Observa??es      C?digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera??es neste arquivo podem causar funcionamento incorreto
                 e ser?o perdidas caso o c?digo-fonte seja gerado novamente.
=============================================================================== */

User Function _QMPOLNH ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSCSPORTALAPD
------------------------------------------------------------------------------- */

WSCLIENT WSWSCSPORTALAPD

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETCODIGOCC
	WSMETHOD GETCODIGOLIDER
	WSMETHOD GETCODIGOMENTOR
	WSMETHOD GETDESCRICAOLEGENDA
	WSMETHOD GETLISTAAVALIACAOCONSENSO
	WSMETHOD GETMEDIAAVALIACAOCONSENSO
	WSMETHOD GETNOMECC
	WSMETHOD GETNOMELIDER
	WSMETHOD GETNOMEMENTOR

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   c_CCHAVE                  AS string
	WSDATA   cGETCODIGOCCRESULT        AS string
	WSDATA   cGETCODIGOLIDERRESULT     AS string
	WSDATA   cGETCODIGOMENTORRESULT    AS string
	WSDATA   cGETDESCRICAOLEGENDARESULT AS string
	WSDATA   c_IDPARTICIPANT           AS string
	WSDATA   c_IDEVALUETED             AS string
	WSDATA   d_DATE                    AS date
	WSDATA   oWSGETLISTAAVALIACAOCONSENSORESULT AS WSCSPORTALAPD_APDAVACON
	WSDATA   nGETMEDIAAVALIACAOCONSENSORESULT AS float
	WSDATA   cGETNOMECCRESULT          AS string
	WSDATA   cGETNOMELIDERRESULT       AS string
	WSDATA   cGETNOMEMENTORRESULT      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSCSPORTALAPD
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C?digo-Fonte Client atual requer os execut?veis do Protheus Build [7.00.131227A-20151103] ou superior. Atualize o Protheus ou gere o C?digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSCSPORTALAPD
	::oWSGETLISTAAVALIACAOCONSENSORESULT := WSCSPORTALAPD_APDAVACON():New()
Return

WSMETHOD RESET WSCLIENT WSWSCSPORTALAPD
	::c_CCHAVE           := NIL 
	::cGETCODIGOCCRESULT := NIL 
	::cGETCODIGOLIDERRESULT := NIL 
	::cGETCODIGOMENTORRESULT := NIL 
	::cGETDESCRICAOLEGENDARESULT := NIL 
	::c_IDPARTICIPANT    := NIL 
	::c_IDEVALUETED      := NIL 
	::d_DATE             := NIL 
	::oWSGETLISTAAVALIACAOCONSENSORESULT := NIL 
	::nGETMEDIAAVALIACAOCONSENSORESULT := NIL 
	::cGETNOMECCRESULT   := NIL 
	::cGETNOMELIDERRESULT := NIL 
	::cGETNOMEMENTORRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSCSPORTALAPD
Local oClone := WSWSCSPORTALAPD():New()
	oClone:_URL          := ::_URL 
	oClone:c_CCHAVE      := ::c_CCHAVE
	oClone:cGETCODIGOCCRESULT := ::cGETCODIGOCCRESULT
	oClone:cGETCODIGOLIDERRESULT := ::cGETCODIGOLIDERRESULT
	oClone:cGETCODIGOMENTORRESULT := ::cGETCODIGOMENTORRESULT
	oClone:cGETDESCRICAOLEGENDARESULT := ::cGETDESCRICAOLEGENDARESULT
	oClone:c_IDPARTICIPANT := ::c_IDPARTICIPANT
	oClone:c_IDEVALUETED := ::c_IDEVALUETED
	oClone:d_DATE        := ::d_DATE
	oClone:oWSGETLISTAAVALIACAOCONSENSORESULT :=  IIF(::oWSGETLISTAAVALIACAOCONSENSORESULT = NIL , NIL ,::oWSGETLISTAAVALIACAOCONSENSORESULT:Clone() )
	oClone:nGETMEDIAAVALIACAOCONSENSORESULT := ::nGETMEDIAAVALIACAOCONSENSORESULT
	oClone:cGETNOMECCRESULT := ::cGETNOMECCRESULT
	oClone:cGETNOMELIDERRESULT := ::cGETNOMELIDERRESULT
	oClone:cGETNOMEMENTORRESULT := ::cGETNOMEMENTORRESULT
Return oClone

// WSDL Method GETCODIGOCC of Service WSWSCSPORTALAPD

WSMETHOD GETCODIGOCC WSSEND c_CCHAVE WSRECEIVE cGETCODIGOCCRESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETCODIGOCC xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_CCHAVE", ::c_CCHAVE, c_CCHAVE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETCODIGOCC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETCODIGOCC",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::cGETCODIGOCCRESULT :=  WSAdvValue( oXmlRet,"_GETCODIGOCCRESPONSE:_GETCODIGOCCRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETCODIGOLIDER of Service WSWSCSPORTALAPD

WSMETHOD GETCODIGOLIDER WSSEND c_CCHAVE WSRECEIVE cGETCODIGOLIDERRESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETCODIGOLIDER xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_CCHAVE", ::c_CCHAVE, c_CCHAVE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETCODIGOLIDER>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETCODIGOLIDER",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::cGETCODIGOLIDERRESULT :=  WSAdvValue( oXmlRet,"_GETCODIGOLIDERRESPONSE:_GETCODIGOLIDERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETCODIGOMENTOR of Service WSWSCSPORTALAPD

WSMETHOD GETCODIGOMENTOR WSSEND c_CCHAVE WSRECEIVE cGETCODIGOMENTORRESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETCODIGOMENTOR xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_CCHAVE", ::c_CCHAVE, c_CCHAVE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETCODIGOMENTOR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETCODIGOMENTOR",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::cGETCODIGOMENTORRESULT :=  WSAdvValue( oXmlRet,"_GETCODIGOMENTORRESPONSE:_GETCODIGOMENTORRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETDESCRICAOLEGENDA of Service WSWSCSPORTALAPD

WSMETHOD GETDESCRICAOLEGENDA WSSEND c_CCHAVE WSRECEIVE cGETDESCRICAOLEGENDARESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETDESCRICAOLEGENDA xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_CCHAVE", ::c_CCHAVE, c_CCHAVE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETDESCRICAOLEGENDA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETDESCRICAOLEGENDA",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::cGETDESCRICAOLEGENDARESULT :=  WSAdvValue( oXmlRet,"_GETDESCRICAOLEGENDARESPONSE:_GETDESCRICAOLEGENDARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETLISTAAVALIACAOCONSENSO of Service WSWSCSPORTALAPD

WSMETHOD GETLISTAAVALIACAOCONSENSO WSSEND c_IDPARTICIPANT,c_IDEVALUETED,d_DATE WSRECEIVE oWSGETLISTAAVALIACAOCONSENSORESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETLISTAAVALIACAOCONSENSO xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_IDPARTICIPANT", ::c_IDPARTICIPANT, c_IDPARTICIPANT , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("_IDEVALUETED", ::c_IDEVALUETED, c_IDEVALUETED , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("_DATE", ::d_DATE, d_DATE , "date", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETLISTAAVALIACAOCONSENSO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETLISTAAVALIACAOCONSENSO",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::oWSGETLISTAAVALIACAOCONSENSORESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETLISTAAVALIACAOCONSENSORESPONSE:_GETLISTAAVALIACAOCONSENSORESULT","APDAVACON",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETMEDIAAVALIACAOCONSENSO of Service WSWSCSPORTALAPD

WSMETHOD GETMEDIAAVALIACAOCONSENSO WSSEND c_CCHAVE WSRECEIVE nGETMEDIAAVALIACAOCONSENSORESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETMEDIAAVALIACAOCONSENSO xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_CCHAVE", ::c_CCHAVE, c_CCHAVE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETMEDIAAVALIACAOCONSENSO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETMEDIAAVALIACAOCONSENSO",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::nGETMEDIAAVALIACAOCONSENSORESULT :=  WSAdvValue( oXmlRet,"_GETMEDIAAVALIACAOCONSENSORESPONSE:_GETMEDIAAVALIACAOCONSENSORESULT:TEXT","float",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETNOMECC of Service WSWSCSPORTALAPD

WSMETHOD GETNOMECC WSSEND c_CCHAVE WSRECEIVE cGETNOMECCRESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETNOMECC xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_CCHAVE", ::c_CCHAVE, c_CCHAVE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETNOMECC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETNOMECC",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::cGETNOMECCRESULT   :=  WSAdvValue( oXmlRet,"_GETNOMECCRESPONSE:_GETNOMECCRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETNOMELIDER of Service WSWSCSPORTALAPD

WSMETHOD GETNOMELIDER WSSEND c_CCHAVE WSRECEIVE cGETNOMELIDERRESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETNOMELIDER xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_CCHAVE", ::c_CCHAVE, c_CCHAVE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETNOMELIDER>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETNOMELIDER",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::cGETNOMELIDERRESULT :=  WSAdvValue( oXmlRet,"_GETNOMELIDERRESPONSE:_GETNOMELIDERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETNOMEMENTOR of Service WSWSCSPORTALAPD

WSMETHOD GETNOMEMENTOR WSSEND c_CCHAVE WSRECEIVE cGETNOMEMENTORRESULT WSCLIENT WSWSCSPORTALAPD
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETNOMEMENTOR xmlns="http://192.168.16.129:8021/">'
cSoap += WSSoapValue("_CCHAVE", ::c_CCHAVE, c_CCHAVE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETNOMEMENTOR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.16.129:8021/GETNOMEMENTOR",; 
	"DOCUMENT","http://192.168.16.129:8021/",,"1.031217",; 
	"http://192.168.16.129:8021/ws/WSCSPORTALAPD.apw")

::Init()
::cGETNOMEMENTORRESULT :=  WSAdvValue( oXmlRet,"_GETNOMEMENTORRESPONSE:_GETNOMEMENTORRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure APDAVACON

WSSTRUCT WSCSPORTALAPD_APDAVACON
	WSDATA   c_CDATRET                 AS string
	WSDATA   c_CLIDERHI                AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSCSPORTALAPD_APDAVACON
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSCSPORTALAPD_APDAVACON
Return

WSMETHOD CLONE WSCLIENT WSCSPORTALAPD_APDAVACON
	Local oClone := WSCSPORTALAPD_APDAVACON():NEW()
	oClone:c_CDATRET            := ::c_CDATRET
	oClone:c_CLIDERHI           := ::c_CLIDERHI
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSCSPORTALAPD_APDAVACON
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::c_CDATRET          :=  WSAdvValue( oResponse,"__CDATRET","string",NIL,"Property c_CDATRET as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::c_CLIDERHI         :=  WSAdvValue( oResponse,"__CLIDERHI","string",NIL,"Property c_CLIDERHI as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


