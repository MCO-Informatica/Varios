#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.16.30:90/CERTISIGNERP.apw?WSDL
Gerado em        06/10/10 17:55:09
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.090116
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QNYIFPC ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCERTISIGNERP
------------------------------------------------------------------------------- */

WSCLIENT WSCERTISIGNERP

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GERANOTA
	WSMETHOD INCPEDIDO

	WSDATA   _URL                      AS String
	WSDATA   oWSMOVNOTA                AS CERTISIGNERP_CSMOVNOTAST
	WSDATA   oWSGERANOTARESULT         AS CERTISIGNERP_CSRESPONSEST
	WSDATA   oWSPEDIDO                 AS CERTISIGNERP_CSINCPEDST
	WSDATA   oWSINCPEDIDORESULT        AS CERTISIGNERP_CSRESPONSEST

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSCSMOVNOTAST            AS CERTISIGNERP_CSMOVNOTAST
	WSDATA   oWSCSINCPEDST             AS CERTISIGNERP_CSINCPEDST

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCERTISIGNERP
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.090818P-20091217] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCERTISIGNERP
	::oWSMOVNOTA         := CERTISIGNERP_CSMOVNOTAST():New()
	::oWSGERANOTARESULT  := CERTISIGNERP_CSRESPONSEST():New()
	::oWSPEDIDO          := CERTISIGNERP_CSINCPEDST():New()
	::oWSINCPEDIDORESULT := CERTISIGNERP_CSRESPONSEST():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSCSMOVNOTAST     := ::oWSMOVNOTA
	::oWSCSINCPEDST      := ::oWSPEDIDO
Return

WSMETHOD RESET WSCLIENT WSCERTISIGNERP
	::oWSMOVNOTA         := NIL 
	::oWSGERANOTARESULT  := NIL 
	::oWSPEDIDO          := NIL 
	::oWSINCPEDIDORESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSCSMOVNOTAST     := NIL
	::oWSCSINCPEDST      := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCERTISIGNERP
Local oClone := WSCERTISIGNERP():New()
	oClone:_URL          := ::_URL 
	oClone:oWSMOVNOTA    :=  IIF(::oWSMOVNOTA = NIL , NIL ,::oWSMOVNOTA:Clone() )
	oClone:oWSGERANOTARESULT :=  IIF(::oWSGERANOTARESULT = NIL , NIL ,::oWSGERANOTARESULT:Clone() )
	oClone:oWSPEDIDO     :=  IIF(::oWSPEDIDO = NIL , NIL ,::oWSPEDIDO:Clone() )
	oClone:oWSINCPEDIDORESULT :=  IIF(::oWSINCPEDIDORESULT = NIL , NIL ,::oWSINCPEDIDORESULT:Clone() )

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSCSMOVNOTAST := oClone:oWSMOVNOTA
	oClone:oWSCSINCPEDST := oClone:oWSPEDIDO
Return oClone

// WSDL Method GERANOTA of Service WSCERTISIGNERP

WSMETHOD GERANOTA WSSEND oWSMOVNOTA WSRECEIVE oWSGERANOTARESULT WSCLIENT WSCERTISIGNERP
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GERANOTA xmlns="http://www.certisign.com.br/certisignerp.apw">'
cSoap += WSSoapValue("MOVNOTA", ::oWSMOVNOTA, oWSMOVNOTA , "CSMOVNOTAST", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GERANOTA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.certisign.com.br/certisignerp.apw/GERANOTA",; 
	"DOCUMENT","http://www.certisign.com.br/certisignerp.apw",,"1.031217",; 
	"http://192.168.16.30:90/CERTISIGNERP.apw")

::Init()
::oWSGERANOTARESULT:SoapRecv( WSAdvValue( oXmlRet,"_GERANOTARESPONSE:_GERANOTARESULT","CSRESPONSEST",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method INCPEDIDO of Service WSCERTISIGNERP

WSMETHOD INCPEDIDO WSSEND oWSPEDIDO WSRECEIVE oWSINCPEDIDORESULT WSCLIENT WSCERTISIGNERP
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<INCPEDIDO xmlns="http://www.certisign.com.br/certisignerp.apw">'
cSoap += WSSoapValue("PEDIDO", ::oWSPEDIDO, oWSPEDIDO , "CSINCPEDST", .T. , .F., 0 , NIL, .F.) 
cSoap += "</INCPEDIDO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.certisign.com.br/certisignerp.apw/INCPEDIDO",; 
	"DOCUMENT","http://www.certisign.com.br/certisignerp.apw",,"1.031217",; 
	"http://192.168.16.30:90/CERTISIGNERP.apw")

::Init()
::oWSINCPEDIDORESULT:SoapRecv( WSAdvValue( oXmlRet,"_INCPEDIDORESPONSE:_INCPEDIDORESULT","CSRESPONSEST",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure CSMOVNOTAST

WSSTRUCT CERTISIGNERP_CSMOVNOTAST
	WSDATA   cZ5CERTIF                 AS string OPTIONAL
	WSDATA   cZ5CNPJ                   AS string
	WSDATA   cZ5CNPJCER                AS string
	WSDATA   cZ5CODAGE                 AS string
	WSDATA   cZ5CODAR                  AS string
	WSDATA   cZ5CODPOS                 AS string
	WSDATA   cZ5CODVOU                 AS string OPTIONAL
	WSDATA   cZ5CPFAGE                 AS string
	WSDATA   dZ5DATPAG                 AS date
	WSDATA   dZ5DATPED                 AS date
	WSDATA   dZ5DATVAL                 AS date
	WSDATA   cZ5DESCAR                 AS string
	WSDATA   cZ5DESGRU                 AS string OPTIONAL
	WSDATA   cZ5DESPOS                 AS string
	WSDATA   cZ5DESPRO                 AS string
	WSDATA   dZ5EMISSAO                AS date OPTIONAL
	WSDATA   cZ5GARANT                 AS string OPTIONAL
	WSDATA   cZ5GRUPO                  AS string OPTIONAL
	WSDATA   cZ5HORVAL                 AS string
	WSDATA   cZ5NOMAGE                 AS string
	WSDATA   cZ5NOMREC                 AS string
	WSDATA   cZ5PEDGAR                 AS string
	WSDATA   cZ5PRODUTO                AS string
	WSDATA   dZ5RENOVA                 AS date OPTIONAL
	WSDATA   dZ5REVOGA                 AS date OPTIONAL
	WSDATA   cZ5STATUS                 AS string OPTIONAL
	WSDATA   cZ5TIPMOV                 AS string
	WSDATA   cZ5TIPVOU                 AS string OPTIONAL
	WSDATA   nZ5VALOR                  AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CERTISIGNERP_CSMOVNOTAST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CERTISIGNERP_CSMOVNOTAST
Return

WSMETHOD CLONE WSCLIENT CERTISIGNERP_CSMOVNOTAST
	Local oClone := CERTISIGNERP_CSMOVNOTAST():NEW()
	oClone:cZ5CERTIF            := ::cZ5CERTIF
	oClone:cZ5CNPJ              := ::cZ5CNPJ
	oClone:cZ5CNPJCER           := ::cZ5CNPJCER
	oClone:cZ5CODAGE            := ::cZ5CODAGE
	oClone:cZ5CODAR             := ::cZ5CODAR
	oClone:cZ5CODPOS            := ::cZ5CODPOS
	oClone:cZ5CODVOU            := ::cZ5CODVOU
	oClone:cZ5CPFAGE            := ::cZ5CPFAGE
	oClone:dZ5DATPAG            := ::dZ5DATPAG
	oClone:dZ5DATPED            := ::dZ5DATPED
	oClone:dZ5DATVAL            := ::dZ5DATVAL
	oClone:cZ5DESCAR            := ::cZ5DESCAR
	oClone:cZ5DESGRU            := ::cZ5DESGRU
	oClone:cZ5DESPOS            := ::cZ5DESPOS
	oClone:cZ5DESPRO            := ::cZ5DESPRO
	oClone:dZ5EMISSAO           := ::dZ5EMISSAO
	oClone:cZ5GARANT            := ::cZ5GARANT
	oClone:cZ5GRUPO             := ::cZ5GRUPO
	oClone:cZ5HORVAL            := ::cZ5HORVAL
	oClone:cZ5NOMAGE            := ::cZ5NOMAGE
	oClone:cZ5NOMREC            := ::cZ5NOMREC
	oClone:cZ5PEDGAR            := ::cZ5PEDGAR
	oClone:cZ5PRODUTO           := ::cZ5PRODUTO
	oClone:dZ5RENOVA            := ::dZ5RENOVA
	oClone:dZ5REVOGA            := ::dZ5REVOGA
	oClone:cZ5STATUS            := ::cZ5STATUS
	oClone:cZ5TIPMOV            := ::cZ5TIPMOV
	oClone:cZ5TIPVOU            := ::cZ5TIPVOU
	oClone:nZ5VALOR             := ::nZ5VALOR
Return oClone

WSMETHOD SOAPSEND WSCLIENT CERTISIGNERP_CSMOVNOTAST
	Local cSoap := ""
	cSoap += WSSoapValue("Z5CERTIF", ::cZ5CERTIF, ::cZ5CERTIF , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5CNPJ", ::cZ5CNPJ, ::cZ5CNPJ , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5CNPJCER", ::cZ5CNPJCER, ::cZ5CNPJCER , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5CODAGE", ::cZ5CODAGE, ::cZ5CODAGE , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5CODAR", ::cZ5CODAR, ::cZ5CODAR , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5CODPOS", ::cZ5CODPOS, ::cZ5CODPOS , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5CODVOU", ::cZ5CODVOU, ::cZ5CODVOU , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5CPFAGE", ::cZ5CPFAGE, ::cZ5CPFAGE , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5DATPAG", ::dZ5DATPAG, ::dZ5DATPAG , "date", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5DATPED", ::dZ5DATPED, ::dZ5DATPED , "date", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5DATVAL", ::dZ5DATVAL, ::dZ5DATVAL , "date", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5DESCAR", ::cZ5DESCAR, ::cZ5DESCAR , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5DESGRU", ::cZ5DESGRU, ::cZ5DESGRU , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5DESPOS", ::cZ5DESPOS, ::cZ5DESPOS , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5DESPRO", ::cZ5DESPRO, ::cZ5DESPRO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5EMISSAO", ::dZ5EMISSAO, ::dZ5EMISSAO , "date", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5GARANT", ::cZ5GARANT, ::cZ5GARANT , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5GRUPO", ::cZ5GRUPO, ::cZ5GRUPO , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5HORVAL", ::cZ5HORVAL, ::cZ5HORVAL , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5NOMAGE", ::cZ5NOMAGE, ::cZ5NOMAGE , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5NOMREC", ::cZ5NOMREC, ::cZ5NOMREC , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5PEDGAR", ::cZ5PEDGAR, ::cZ5PEDGAR , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5PRODUTO", ::cZ5PRODUTO, ::cZ5PRODUTO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5RENOVA", ::dZ5RENOVA, ::dZ5RENOVA , "date", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5REVOGA", ::dZ5REVOGA, ::dZ5REVOGA , "date", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5STATUS", ::cZ5STATUS, ::cZ5STATUS , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5TIPMOV", ::cZ5TIPMOV, ::cZ5TIPMOV , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5TIPVOU", ::cZ5TIPVOU, ::cZ5TIPVOU , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Z5VALOR", ::nZ5VALOR, ::nZ5VALOR , "float", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure CSRESPONSEST

WSSTRUCT CERTISIGNERP_CSRESPONSEST
	WSDATA   cDETAILSTR                AS string OPTIONAL
	WSDATA   lOK                       AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CERTISIGNERP_CSRESPONSEST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CERTISIGNERP_CSRESPONSEST
Return

WSMETHOD CLONE WSCLIENT CERTISIGNERP_CSRESPONSEST
	Local oClone := CERTISIGNERP_CSRESPONSEST():NEW()
	oClone:cDETAILSTR           := ::cDETAILSTR
	oClone:lOK                  := ::lOK
Return oClone

//WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CERTISIGNERP_CSRESPONSEST
//	::Init()
//	If oResponse = NIL ; Return ; Endif 
//	::cDETAILSTR         :=  WSAdvValue( oResponse,"_DETAILSTR","string",NIL,NIL,NIL,"S",NIL,NIL) 
//	::lOK                :=  WSAdvValue( oResponse,"_OK","boolean",NIL,"Property lOK as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
//Return

// WSDL Data Structure CSINCPEDST

WSSTRUCT CERTISIGNERP_CSINCPEDST
	WSDATA   oWSCLIENTE                AS CERTISIGNERP_CSCLIENTEST
	WSDATA   oWSHEADER                 AS CERTISIGNERP_CSPEDCABECST
	WSDATA   oWSITENS                  AS CERTISIGNERP_ARRAYOFCSITEMST
	WSDATA   oWSTITULO                 AS CERTISIGNERP_CSFINANCST
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CERTISIGNERP_CSINCPEDST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CERTISIGNERP_CSINCPEDST
Return

WSMETHOD CLONE WSCLIENT CERTISIGNERP_CSINCPEDST
	Local oClone := CERTISIGNERP_CSINCPEDST():NEW()
	oClone:oWSCLIENTE           := IIF(::oWSCLIENTE = NIL , NIL , ::oWSCLIENTE:Clone() )
	oClone:oWSHEADER            := IIF(::oWSHEADER = NIL , NIL , ::oWSHEADER:Clone() )
	oClone:oWSITENS             := IIF(::oWSITENS = NIL , NIL , ::oWSITENS:Clone() )
	oClone:oWSTITULO            := IIF(::oWSTITULO = NIL , NIL , ::oWSTITULO:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT CERTISIGNERP_CSINCPEDST
	Local cSoap := ""
	cSoap += WSSoapValue("CLIENTE", ::oWSCLIENTE, ::oWSCLIENTE , "CSCLIENTEST", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("HEADER", ::oWSHEADER, ::oWSHEADER , "CSPEDCABECST", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ITENS", ::oWSITENS, ::oWSITENS , "ARRAYOFCSITEMST", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("TITULO", ::oWSTITULO, ::oWSTITULO , "CSFINANCST", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure CSCLIENTEST

WSSTRUCT CERTISIGNERP_CSCLIENTEST
	WSDATA   nA1ALIQIR                 AS float OPTIONAL
	WSDATA   cA1BAIRRO                 AS string
	WSDATA   cA1BAIRROC                AS string OPTIONAL
	WSDATA   cA1BAIRROE                AS string OPTIONAL
	WSDATA   cA1CEP                    AS string
	WSDATA   cA1CEPC                   AS string OPTIONAL
	WSDATA   cA1CEPE                   AS string OPTIONAL
	WSDATA   cA1CGC                    AS string
	WSDATA   cA1CNAE                   AS string OPTIONAL
	WSDATA   cA1COD_MUN                AS string
	WSDATA   cA1CODMUNZF               AS string OPTIONAL
	WSDATA   cA1COMPLEM                AS string OPTIONAL
	WSDATA   cA1CONTATO                AS string OPTIONAL
	WSDATA   cA1DDD                    AS string OPTIONAL
	WSDATA   cA1DDI                    AS string OPTIONAL
	WSDATA   cA1EMAIL                  AS string
	WSDATA   cA1END                    AS string
	WSDATA   cA1ENDCOB                 AS string OPTIONAL
	WSDATA   cA1ENDENT                 AS string OPTIONAL
	WSDATA   cA1ENDREC                 AS string OPTIONAL
	WSDATA   cA1EST                    AS string
	WSDATA   cA1ESTADO                 AS string
	WSDATA   cA1ESTC                   AS string OPTIONAL
	WSDATA   cA1ESTE                   AS string OPTIONAL
	WSDATA   cA1FAX                    AS string OPTIONAL
	WSDATA   cA1INCISS                 AS string OPTIONAL
	WSDATA   cA1INSCR                  AS string
	WSDATA   cA1INSCRM                 AS string OPTIONAL
	WSDATA   cA1MUN                    AS string
	WSDATA   cA1MUNC                   AS string OPTIONAL
	WSDATA   cA1MUNE                   AS string OPTIONAL
	WSDATA   cA1NATUREZ                AS string OPTIONAL
	WSDATA   cA1NOME                   AS string
	WSDATA   cA1NREDUZ                 AS string
	WSDATA   cA1NUMERO                 AS string
	WSDATA   cA1OBSERV                 AS string OPTIONAL
	WSDATA   cA1PAIS                   AS string
	WSDATA   cA1PESSOA                 AS string
	WSDATA   cA1PFISICA                AS string OPTIONAL
	WSDATA   cA1RECCOFI                AS string OPTIONAL
	WSDATA   cA1RECCSLL                AS string OPTIONAL
	WSDATA   cA1RECINSS                AS string OPTIONAL
	WSDATA   cA1RECISS                 AS string OPTIONAL
	WSDATA   cA1RECPIS                 AS string OPTIONAL
	WSDATA   cA1RG                     AS string OPTIONAL
	WSDATA   cA1SUFRAMA                AS string OPTIONAL
	WSDATA   cA1TEL                    AS string OPTIONAL
	WSDATA   cA1TELEX                  AS string OPTIONAL
	WSDATA   cA1TIPO                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CERTISIGNERP_CSCLIENTEST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CERTISIGNERP_CSCLIENTEST
Return

WSMETHOD CLONE WSCLIENT CERTISIGNERP_CSCLIENTEST
	Local oClone := CERTISIGNERP_CSCLIENTEST():NEW()
	oClone:nA1ALIQIR            := ::nA1ALIQIR
	oClone:cA1BAIRRO            := ::cA1BAIRRO
	oClone:cA1BAIRROC           := ::cA1BAIRROC
	oClone:cA1BAIRROE           := ::cA1BAIRROE
	oClone:cA1CEP               := ::cA1CEP
	oClone:cA1CEPC              := ::cA1CEPC
	oClone:cA1CEPE              := ::cA1CEPE
	oClone:cA1CGC               := ::cA1CGC
	oClone:cA1CNAE              := ::cA1CNAE
	oClone:cA1COD_MUN           := ::cA1COD_MUN
	oClone:cA1CODMUNZF          := ::cA1CODMUNZF
	oClone:cA1COMPLEM           := ::cA1COMPLEM
	oClone:cA1CONTATO           := ::cA1CONTATO
	oClone:cA1DDD               := ::cA1DDD
	oClone:cA1DDI               := ::cA1DDI
	oClone:cA1EMAIL             := ::cA1EMAIL
	oClone:cA1END               := ::cA1END
	oClone:cA1ENDCOB            := ::cA1ENDCOB
	oClone:cA1ENDENT            := ::cA1ENDENT
	oClone:cA1ENDREC            := ::cA1ENDREC
	oClone:cA1EST               := ::cA1EST
	oClone:cA1ESTADO            := ::cA1ESTADO
	oClone:cA1ESTC              := ::cA1ESTC
	oClone:cA1ESTE              := ::cA1ESTE
	oClone:cA1FAX               := ::cA1FAX
	oClone:cA1INCISS            := ::cA1INCISS
	oClone:cA1INSCR             := ::cA1INSCR
	oClone:cA1INSCRM            := ::cA1INSCRM
	oClone:cA1MUN               := ::cA1MUN
	oClone:cA1MUNC              := ::cA1MUNC
	oClone:cA1MUNE              := ::cA1MUNE
	oClone:cA1NATUREZ           := ::cA1NATUREZ
	oClone:cA1NOME              := ::cA1NOME
	oClone:cA1NREDUZ            := ::cA1NREDUZ
	oClone:cA1NUMERO            := ::cA1NUMERO
	oClone:cA1OBSERV            := ::cA1OBSERV
	oClone:cA1PAIS              := ::cA1PAIS
	oClone:cA1PESSOA            := ::cA1PESSOA
	oClone:cA1PFISICA           := ::cA1PFISICA
	oClone:cA1RECCOFI           := ::cA1RECCOFI
	oClone:cA1RECCSLL           := ::cA1RECCSLL
	oClone:cA1RECINSS           := ::cA1RECINSS
	oClone:cA1RECISS            := ::cA1RECISS
	oClone:cA1RECPIS            := ::cA1RECPIS
	oClone:cA1RG                := ::cA1RG
	oClone:cA1SUFRAMA           := ::cA1SUFRAMA
	oClone:cA1TEL               := ::cA1TEL
	oClone:cA1TELEX             := ::cA1TELEX
	oClone:cA1TIPO              := ::cA1TIPO
Return oClone

WSMETHOD SOAPSEND WSCLIENT CERTISIGNERP_CSCLIENTEST
	Local cSoap := ""
	cSoap += WSSoapValue("A1ALIQIR", ::nA1ALIQIR, ::nA1ALIQIR , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1BAIRRO", ::cA1BAIRRO, ::cA1BAIRRO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1BAIRROC", ::cA1BAIRROC, ::cA1BAIRROC , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1BAIRROE", ::cA1BAIRROE, ::cA1BAIRROE , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1CEP", ::cA1CEP, ::cA1CEP , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1CEPC", ::cA1CEPC, ::cA1CEPC , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1CEPE", ::cA1CEPE, ::cA1CEPE , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1CGC", ::cA1CGC, ::cA1CGC , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1CNAE", ::cA1CNAE, ::cA1CNAE , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1COD_MUN", ::cA1COD_MUN, ::cA1COD_MUN , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1CODMUNZF", ::cA1CODMUNZF, ::cA1CODMUNZF , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1COMPLEM", ::cA1COMPLEM, ::cA1COMPLEM , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1CONTATO", ::cA1CONTATO, ::cA1CONTATO , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1DDD", ::cA1DDD, ::cA1DDD , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1DDI", ::cA1DDI, ::cA1DDI , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1EMAIL", ::cA1EMAIL, ::cA1EMAIL , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1END", ::cA1END, ::cA1END , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1ENDCOB", ::cA1ENDCOB, ::cA1ENDCOB , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1ENDENT", ::cA1ENDENT, ::cA1ENDENT , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1ENDREC", ::cA1ENDREC, ::cA1ENDREC , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1EST", ::cA1EST, ::cA1EST , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1ESTADO", ::cA1ESTADO, ::cA1ESTADO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1ESTC", ::cA1ESTC, ::cA1ESTC , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1ESTE", ::cA1ESTE, ::cA1ESTE , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1FAX", ::cA1FAX, ::cA1FAX , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1INCISS", ::cA1INCISS, ::cA1INCISS , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1INSCR", ::cA1INSCR, ::cA1INSCR , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1INSCRM", ::cA1INSCRM, ::cA1INSCRM , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1MUN", ::cA1MUN, ::cA1MUN , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1MUNC", ::cA1MUNC, ::cA1MUNC , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1MUNE", ::cA1MUNE, ::cA1MUNE , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1NATUREZ", ::cA1NATUREZ, ::cA1NATUREZ , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1NOME", ::cA1NOME, ::cA1NOME , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1NREDUZ", ::cA1NREDUZ, ::cA1NREDUZ , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1NUMERO", ::cA1NUMERO, ::cA1NUMERO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1OBSERV", ::cA1OBSERV, ::cA1OBSERV , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1PAIS", ::cA1PAIS, ::cA1PAIS , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1PESSOA", ::cA1PESSOA, ::cA1PESSOA , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1PFISICA", ::cA1PFISICA, ::cA1PFISICA , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1RECCOFI", ::cA1RECCOFI, ::cA1RECCOFI , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1RECCSLL", ::cA1RECCSLL, ::cA1RECCSLL , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1RECINSS", ::cA1RECINSS, ::cA1RECINSS , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1RECISS", ::cA1RECISS, ::cA1RECISS , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1RECPIS", ::cA1RECPIS, ::cA1RECPIS , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1RG", ::cA1RG, ::cA1RG , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1SUFRAMA", ::cA1SUFRAMA, ::cA1SUFRAMA , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1TEL", ::cA1TEL, ::cA1TEL , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1TELEX", ::cA1TELEX, ::cA1TELEX , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("A1TIPO", ::cA1TIPO, ::cA1TIPO , "string", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure CSPEDCABECST

WSSTRUCT CERTISIGNERP_CSPEDCABECST
	WSDATA   cC5CHVBPAG                AS string
	WSDATA   cC5CNPJ                   AS string
	WSDATA   cC5CODVOU                 AS string OPTIONAL
	WSDATA   cC5CONDPAG                AS string
	WSDATA   dC5EMISSAO                AS date
	WSDATA   cC5GARANT                 AS string OPTIONAL
	WSDATA   cC5MENNOTA                AS string OPTIONAL
	WSDATA   cC5MOTVOU                 AS string OPTIONAL
	WSDATA   cC5STATUS                 AS string
	WSDATA   cC5TIPMOV                 AS string
	WSDATA   cC5TIPMOV2                AS string OPTIONAL
	WSDATA   cC5TIPVOU                 AS string OPTIONAL
	WSDATA   nC5TOTPED                 AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CERTISIGNERP_CSPEDCABECST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CERTISIGNERP_CSPEDCABECST
Return

WSMETHOD CLONE WSCLIENT CERTISIGNERP_CSPEDCABECST
	Local oClone := CERTISIGNERP_CSPEDCABECST():NEW()
	oClone:cC5CHVBPAG           := ::cC5CHVBPAG
	oClone:cC5CNPJ              := ::cC5CNPJ
	oClone:cC5CODVOU            := ::cC5CODVOU
	oClone:cC5CONDPAG           := ::cC5CONDPAG
	oClone:dC5EMISSAO           := ::dC5EMISSAO
	oClone:cC5GARANT            := ::cC5GARANT
	oClone:cC5MENNOTA           := ::cC5MENNOTA
	oClone:cC5MOTVOU            := ::cC5MOTVOU
	oClone:cC5STATUS            := ::cC5STATUS
	oClone:cC5TIPMOV            := ::cC5TIPMOV
	oClone:cC5TIPMOV2           := ::cC5TIPMOV2
	oClone:cC5TIPVOU            := ::cC5TIPVOU
	oClone:nC5TOTPED            := ::nC5TOTPED
Return oClone

WSMETHOD SOAPSEND WSCLIENT CERTISIGNERP_CSPEDCABECST
	Local cSoap := ""
	cSoap += WSSoapValue("C5CHVBPAG", ::cC5CHVBPAG, ::cC5CHVBPAG , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5CNPJ", ::cC5CNPJ, ::cC5CNPJ , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5CODVOU", ::cC5CODVOU, ::cC5CODVOU , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5CONDPAG", ::cC5CONDPAG, ::cC5CONDPAG , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5EMISSAO", ::dC5EMISSAO, ::dC5EMISSAO , "date", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5GARANT", ::cC5GARANT, ::cC5GARANT , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5MENNOTA", ::cC5MENNOTA, ::cC5MENNOTA , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5MOTVOU", ::cC5MOTVOU, ::cC5MOTVOU , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5STATUS", ::cC5STATUS, ::cC5STATUS , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5TIPMOV", ::cC5TIPMOV, ::cC5TIPMOV , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5TIPMOV2", ::cC5TIPMOV2, ::cC5TIPMOV2 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5TIPVOU", ::cC5TIPVOU, ::cC5TIPVOU , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C5TOTPED", ::nC5TOTPED, ::nC5TOTPED , "float", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ARRAYOFCSITEMST

WSSTRUCT CERTISIGNERP_ARRAYOFCSITEMST
	WSDATA   oWSCSITEMST               AS CERTISIGNERP_CSITEMST OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CERTISIGNERP_ARRAYOFCSITEMST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CERTISIGNERP_ARRAYOFCSITEMST
	::oWSCSITEMST          := {} // Array Of  CERTISIGNERP_CSITEMST():New()
Return

WSMETHOD CLONE WSCLIENT CERTISIGNERP_ARRAYOFCSITEMST
	Local oClone := CERTISIGNERP_ARRAYOFCSITEMST():NEW()
	oClone:oWSCSITEMST := NIL
	If ::oWSCSITEMST <> NIL 
		oClone:oWSCSITEMST := {}
		aEval( ::oWSCSITEMST , { |x| aadd( oClone:oWSCSITEMST , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT CERTISIGNERP_ARRAYOFCSITEMST
	Local cSoap := ""
	aEval( ::oWSCSITEMST , {|x| cSoap := cSoap  +  WSSoapValue("CSITEMST", x , x , "CSITEMST", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

// WSDL Data Structure CSFINANCST

WSSTRUCT CERTISIGNERP_CSFINANCST
	WSDATA   cE1ADM                    AS string OPTIONAL
	WSDATA   cE1AGEDEP                 AS string
	WSDATA   cE1CNPJ                   AS string
	WSDATA   cE1CONTA                  AS string
	WSDATA   dE1EMISSAO                AS date
	WSDATA   cE1HIST                   AS string OPTIONAL
	WSDATA   cE1PEDGAR                 AS string
	WSDATA   cE1PORTADO                AS string
	WSDATA   cE1TIPMOV                 AS string
	WSDATA   nE1VALOR                  AS float
	WSDATA   dE1VENCTO                 AS date
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CERTISIGNERP_CSFINANCST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CERTISIGNERP_CSFINANCST
Return

WSMETHOD CLONE WSCLIENT CERTISIGNERP_CSFINANCST
	Local oClone := CERTISIGNERP_CSFINANCST():NEW()
	oClone:cE1ADM               := ::cE1ADM
	oClone:cE1AGEDEP            := ::cE1AGEDEP
	oClone:cE1CNPJ              := ::cE1CNPJ
	oClone:cE1CONTA             := ::cE1CONTA
	oClone:dE1EMISSAO           := ::dE1EMISSAO
	oClone:cE1HIST              := ::cE1HIST
	oClone:cE1PEDGAR            := ::cE1PEDGAR
	oClone:cE1PORTADO           := ::cE1PORTADO
	oClone:cE1TIPMOV            := ::cE1TIPMOV
	oClone:nE1VALOR             := ::nE1VALOR
	oClone:dE1VENCTO            := ::dE1VENCTO
Return oClone

WSMETHOD SOAPSEND WSCLIENT CERTISIGNERP_CSFINANCST
	Local cSoap := ""
	cSoap += WSSoapValue("E1ADM", ::cE1ADM, ::cE1ADM , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1AGEDEP", ::cE1AGEDEP, ::cE1AGEDEP , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1CNPJ", ::cE1CNPJ, ::cE1CNPJ , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1CONTA", ::cE1CONTA, ::cE1CONTA , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1EMISSAO", ::dE1EMISSAO, ::dE1EMISSAO , "date", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1HIST", ::cE1HIST, ::cE1HIST , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1PEDGAR", ::cE1PEDGAR, ::cE1PEDGAR , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1PORTADO", ::cE1PORTADO, ::cE1PORTADO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1TIPMOV", ::cE1TIPMOV, ::cE1TIPMOV , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1VALOR", ::nE1VALOR, ::nE1VALOR , "float", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("E1VENCTO", ::dE1VENCTO, ::dE1VENCTO , "date", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure CSITEMST

WSSTRUCT CERTISIGNERP_CSITEMST
	WSDATA   cC6PEDGAR                 AS string
	WSDATA   nC6PRCVEN                 AS float
	WSDATA   cC6PROGAR                 AS string
	WSDATA   nC6QTDVEN                 AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CERTISIGNERP_CSITEMST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CERTISIGNERP_CSITEMST
Return

WSMETHOD CLONE WSCLIENT CERTISIGNERP_CSITEMST
	Local oClone := CERTISIGNERP_CSITEMST():NEW()
	oClone:cC6PEDGAR            := ::cC6PEDGAR
	oClone:nC6PRCVEN            := ::nC6PRCVEN
	oClone:cC6PROGAR            := ::cC6PROGAR
	oClone:nC6QTDVEN            := ::nC6QTDVEN
Return oClone

WSMETHOD SOAPSEND WSCLIENT CERTISIGNERP_CSITEMST
	Local cSoap := ""
	cSoap += WSSoapValue("C6PEDGAR", ::cC6PEDGAR, ::cC6PEDGAR , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C6PRCVEN", ::nC6PRCVEN, ::nC6PRCVEN , "float", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C6PROGAR", ::cC6PROGAR, ::cC6PROGAR , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("C6QTDVEN", ::nC6QTDVEN, ::nC6QTDVEN , "float", .T. , .F., 0 , NIL, .F.) 
Return cSoap


