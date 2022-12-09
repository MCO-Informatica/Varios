#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �RECEPCAOEVENTO �Autor  �Felipi Marques       Data �  05/04/15 ���
����������������������������������������������������������������������������͹��
���Desc.     � WSDL Service WSRecepcaoEvento                                 ���
���          � www.nfe.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx?wsdl���
����������������������������������������������������������������������������͹��
���Uso       � AP                                                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

User Function RECEPCAOEVENTO ; Return   

WSCLIENT WSRecepcaoEvento

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeRecepcaoEvento

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWS                       AS SCHEMA
	WSDATA   cversaoDados              AS string
	WSDATA   ccUF                      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSRecepcaoEvento
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.131227A-20141125] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSRecepcaoEvento
	::oWS                := NIL 
Return

WSMETHOD RESET WSCLIENT WSRecepcaoEvento
	::oWS                := NIL 
	::cversaoDados       := NIL 
	::ccUF               := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSRecepcaoEvento
Local oClone := WSRecepcaoEvento():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cversaoDados  := ::cversaoDados
	oClone:ccUF          := ::ccUF
Return oClone

WSMETHOD nfeRecepcaoEvento WSSEND BYREF oWS,cversaoDados,ccUF,oWS WSRECEIVE NULLPARAM WSCLIENT WSRecepcaoEvento

Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento">'
cSoapHead += WSSoapValue("versaoDados", ::cversaoDados, cversaoDados , "string", .F. , .F., 0 , NIL, .F.) 
cSoapHead += WSSoapValue("cUF", ::ccUF, ccUF , "string", .F. , .F., 0 , NIL, .F.) 
//cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoapHead +=  "</nfeCabecMsg>"

cSoap += '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento">'
cSoap += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</nfeDadosMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento/nfeRecepcaoEvento",; 
	"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento",cSoapHead,,; 
	"https://www.nfe.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx")

::Init()
::oWS                :=  WSAdvValue( oXmlRet,"_NFERECEPCAOEVENTORESULT","SCHEMA",NIL,NIL,NIL,"O",@oWS,NIL) 

END WSMETHOD

oXmlRet := NIL

Return .T.