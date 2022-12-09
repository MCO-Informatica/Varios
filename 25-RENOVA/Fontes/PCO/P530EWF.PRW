#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "protheus.ch"
#INCLUDE "Ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณP530EWF   บAutor  ณStarfield           บ Data ณ  28/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E. no momento do envio para aprovacao (Geracao bloqueio) บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function P530EWF()
Local _lRet := .T.
Local lWF :=.T.
Local _aDados := ParamIXB[1]
Local aEmail:= ParamIXB[2]
Local cOBS :=ParamIXB[3]
Local cMensagem := ParamIXB[4]

If (LEN(_aDados)>0)
	For nX := 1 To Len(_aDados)
		BMWFCT(_aDados[nX])
	Next nX
Else
	
	For nX := 1 To Len(aEmail)
		
		Conout("aEmail[nX]	: ["+aEmail[nX]+"]" )
		Conout("cOBS		: ["+"cOBS"+"]" )
		Conout("cMensagem 	: ["+cMensagem +"]" )
		
		oProcess := TWFProcess():New( "ALTBLQ", "ALERTA DE BLOQUEIO - RESPOSTA" )
		oProcess:NewTask("100010", "\WORKFLOW\HTML\PCORESP.HTM")
		oProcess:cSubject := iif(Empty(cSbjResp),cObs,cSbjResp)//_cSubject
		oProcess:cBody := iif(Empty(cMsgResp),cMensagem,cMsgResp)
        
		oHtml := oProcess:oHtml
		oHtml:ValByName("MSG"		, iif(Empty(cMsgResp),cMensagem,cMsgResp) )
		
//		oProcess:cTo:= cPara
//		oProcess:cTo:= iif(Empty(cPara),aEmail[nX],cPara) //cpara ้ o aprovador quando estiver vazio, volta para o solicitante resposta.
		oProcess:cTo:= iif(TYPE("cPara")== "A",cPara,aEmail[nX]) //cpara ้ o aprovador, quando a variavel nใo existir, volta para o solicitante resposta.
		oProcess:Start("\workflow\temp\")
		

	Next
EndIf

Return _lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณBMWFCT   บAutor  ณStarfield           บ Data ณ  28/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prepara workflow para envio a aprovadores de Contingencia  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BMWFCT(_aWFDados)
Local aArea    := GetArea()
Local oHtml	   := NIL                  //Objeto utilizado para montar o E-Mail
Local oProcess := NIL				  //Objeto utilizado para a rotina de Workflow
Local _cHttp   := GetNewPAr("MV_WFDHTTP","http://187.94.63.67:96")
Local cModHtm  := ""
Local cPara    := AllTrim(_aWFDados[1])
Local lRet	   := .T.
Local _cSubject := "Alerta de Bloqueio: " + _aWFDados[3] + " - Empresa " + cEmpAnt + " / Filial: " + cFilAnt //"Alerta de Bloqueio: "###" - Empresa "###" / Filial: "
Local _cMyMsg := STRTRAN(_aWFDados[7], CHR(13)+CHR(10), "<br>")

If IsInCallStack("BM530RET") .or. IsInCallStack("U_BM530RET")
	_cMyMsg := cMsgNextAprv
Else
	_cMyMsg := Justifica(_cMyMsg,_aWFDados[4])
EndIF

CONOUT("-------------------- Iniciando Envio de WorkFlow --------------------")  //

If cPara == ""
	Alert("Usuแrio aprovador nใo possui conta de email cadastrada.")
	lRet := .F.
Else
	
	oProcess := TWFProcess():New( "ALTBLQ", "ALERTA DE BLOQUEIO" )
	oProcess:NewTask("100010", "\WORKFLOW\HTML\PCOBLQ.HTM")
	oProcess:cSubject := _cSubject
	oProcess:bReturn  := "U_BM530RET()"
	oProcess:bTimeout := {{"PCOA530OUT()",0,4,0}}
	oProcess:cTo := "HTML"
	
	oHtml := oProcess:oHtml
	oHtml:ValByName("CEMPANT"	, cEmpAnt)
	oHtml:ValByName("CFILANT"	, cFilAnt )
	oHtml:ValByName("CODCONT"	, _aWFDados[3] )
	oHtml:ValByName("CODBLQ"	, _aWFDados[4] )
	oHtml:ValByName("SOLIC"		, _aWFDados[13] )
	oHtml:ValByName("DTSOLIC"	, DTOC(_aWFDados[10]) )
	oHtml:ValByName("DTVALID"	, DTOC(_aWFDados[9]) )
	oHtml:ValByName("CODCONT"	, _aWFDados[3] )
	oHtml:ValByName("CODBLQ"	, _aWFDados[4] )
	oHtml:ValByName("PROCESSO"	, _aWFDados[5] )
	oHtml:ValByName("LOTEID"	, _aWFDados[6] )
	oHtml:ValByName("USUARIO"	, _aWFDados[8] )
	//	oHtml:ValByName("COBS"		,STRTRAN(_aWFDados[7], CHR(13)+CHR(10), "<br>"))
	oHtml:ValByName("COBS"		, _cMyMsg )
	
	aAdd( oProcess:aParams,_aWFDados[8] )
	aAdd( oProcess:aParams,_aWFDados[4] )
	
	
	cProcess := oProcess:Start("\workflow\temp\")                // start workflow
	
	_cMsg := "<html>"
	_cMsg += "<head>"
	_cMsg += "<title>Alerta de bloqueio</title>"
	_cMsg += "</head> "
	_cMsg += "<body> "
	_cMsg += "  <p>&nbsp;</p>"
	_cMsg += "  <p>&nbsp;</p>"
	_cMsg += 'Sr. Aprovador,'
	_cMsg += '<br></br>'
	_cMsg += 'O Alerta de bloqueio Or็amentแrio No.: ' + _aWFDados[4] + ' aguarda sua aprova็ใo. Clique no link abaixo para acessแ-lo:'
	_cMsg += '<br></br>'
	_cMsg += '<a href="' + _cHttp + '/workflow/temp/'  + alltrim(cProcess) + '.htm"> Alerta de bloqueio ' + _aWFDados[4] + '</a>.'
	_cMsg += '<br></br>'
	_cMsg += '<br></br>'
	_cMsg += "</body>"
	_cMsg += "</html>"
	
	oProcess := TWFProcess():New( "ALTBLQ", "ALERTA DE BLOQUEIO - Link" )
	oProcess:NewTask("PCOLINK", "\WORKFLOW\HTML\PCOLINK.HTM")
	oProcess:cSubject := _cSubject
	oProcess:cBody := _cMsg
	oProcess:cTo:= cPara
	
	oHtml := oProcess:oHtml
	oHtml:ValByName("NumBLQ"	, _aWFDados[4])
	oHtml:ValByName("Link"	, _cHttp + '/workflow/temp/'  + alltrim(cProcess) + '.htm' )
	oHtml:ValByName("BLOQUEIO"	, _aWFDados[4] )
	
	oProcess:Start("\workflow\temp\")
	//WFNotifyAdmin( cPara , _cSubject, _cMsg )
	
	
EndIf

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณBM530RET  บAutor  ณStarfield           บ Data ณ  28/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de processamento de Resposta do WorkFlow             บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BM530RET(__oProc)
Local oHtml		:= __oProc:oHtml
Local _cFile	:= AllTrim(oHtml:RetByName("ID"))
Local _cEmpresa	:= AllTrim(oHtml:RetByName("CEMPANT"))
Local _cFilial	:= AllTrim(oHtml:RetByName("CFILANT"))
Local _cCODCONT	:= AllTrim(oHtml:RetByName("CODCONT"))
Local _cCODBLQ	:= __oProc:aParams[2]//AllTrim(oHtml:RetByName("CODBLQ"	))
Local _cUsrAprov:= __oProc:aParams[1]//AllTrim(oHtml:RetByName("USUARIO"))
Local _cLibera  := AllTrim(oHtml:RetByName("APROVA"))          // Obtem a resposta do Aprovador.
Local _lLibera  := IIF(_cLibera == 'Sim',.T.,.F.)

Private cSbjResp := ""
Private cMsgResp := ""
Private cMsgNextAprv := ""
/*
oProcess:aParams
*/

CONOUT("Iniciando recebimento ...")  //
RPCClearEnv()
RpcSetType( 3 )
RpcSetEnv( _cEmpresa, _cFilial,,,,, )
WFPREPENV(_cEmpresa, _cFilial)
CONOUT("Iniciando resposta de WF para o c๓digo "+AllTrim(_cCODCONT))  //"Iniciando resposta de WF para o c๓digo "

Conout("_cFilial : ["+_cFilial +"]" )
Conout("_cCodCont: ["+_cCodCont+"]" )
Conout("_cUsuario: ["+_cUsrAprov+"]" )
Conout("_cLibera : ["+_cLibera +"]" )

ALI->(DbSetorder(1))

IF ALI->(DbSeek(xFilial("ALI")+_cCODCONT+_cUsrAprov))
	
	If ALI->ALI_STATUS $ "03/05"
		CONOUT("Solicita็ใo de contingencia ja liberada!")
	ElseIf ALI->ALI_STATUS == "01"
		CONOUT("Solicita็ใo de contingencia aguardando liberacao de nivel anterior!")
	ElseIf ALI->ALI_STATUS == "04/06"
		CONOUT("Solicita็ใo de contingencia ja cancelada!")
	Else
		If _lLibera
			cMsgNextAprv := AllTrim(oHtml:RetByName("COBS"))
			CONOUT("Liberando contingencia "+_cCODCONT) //"Liberando contingencia "
			PCOA500GER(.T., _cCODBLQ, _cUsrAprov)
		Else
			cSbjResp := "Rejei็ใo da contig๊ncia "+_cCODCONT
			cMsgResp := "A contig๊ncia "+_cCODCONT+" foi rejeitada e serแ excluida."
			CONOUT("Cancelando contingencia "+_cCODCONT) //"Cancelando contingencia "
			PCOA530ALC(6, _cCodBlq,,.T., _cUsrAprov) //Rejeitando libera็ใo se resposta negativa
		EndIf
	EndIF
	
Else
	
	CONOUT("RETORNO - Contingencia "+ _cCODCONT+" nใo encontrada")  //"RETORNO - Contingencia "###" nใo encontrada"
Endif
CONOUT("Recebimento Concluํdo.") //

//Apaga o arquivo HTML gerado
If File(_cFile)
	FErase(_cFile)
EndIf

// Finaliza o processo.
__oProc:Finish()

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJustificativa     ณRenato Lucena Neves บ Data ณ  04/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para preenchimento da justificativa                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Justifica(cTxt,_cBlq)

Local oDlg
local oGetObs
Local oRadio
Local _nRecorrente := 0
Local _lRadio := fShowRadio()
local nOpca := 0
Local __cJust:= ""
Local _cNome := "Nome: "+AllTrim(UsrFullName ( __cUserId ) )
Local _cEMail:= "Email: "+AllTrim(UsrRetMail ( __cUserId ) )
Local _cEmpresa := "Empresa: "+AllTrim(SM0->M0_CODFIL)+" - "+AllTrim(SM0->M0_NOMECOM)
Local _cTipoCusto := "Tipo de Custos: "+AllTrim(AKD->AKD_ENT07)+" - "+AllTrim(GetAdvFVal("CV0","CV0_DESC",xFilial("CV0")+'07'+AKD->AKD_ENT07,1,""))
Local _cValCont := "Valor da contig๊ncia: "+AllTrim(Transform(AKD->AKD_VALOR1,"@E 999,999,999,999.99"))
Local _cProjeto := "Projeto: "+AllTrim(AKD->AKD_ITCTB)+" - "+AllTrim(GetAdvFVal("CTD","CTD_DESC01",xFilial("CTD")+AKD->AKD_ITCTB,1,""))
Local _cClasse := "Classe Or็amentแria: "+AllTrim(AKD->AKD_ENT05)+" - "+AllTrim(GetAdvFVal("CV0","CV0_DESC",xFilial("CV0")+'05'+AKD->AKD_ENT05,1,""))
Local _cCCusto := "Centro de Custo: "+AllTrim(AKD->AKD_CC)+" - "+AllTrim(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+AKD->AKD_CC,1,""))
Local _cValor  := "Valor do lan็amento : "+AllTrim(Transform(nValReal,"@E 999,999,999,999.99"))
Local _cTpContigencia := "Tipo de Contig๊ncia : "+_cBlq+" - "+AllTrim(GetAdvFVal("AKJ","AKJ_DESCRI",xFilial("AKJ")+_cBlq,1,""))
Local _nTamLinha := 150
Local _nLinMemo:= 0

While .T.
	
	DEFINE MSDIALOG oDlgObs TITLE "Estouro de Or็amento, justifique a contig๊ncia ao aprovador"  FROM 0,50 TO 17,100 //"Observacao do Cliente"
	
	@ 0.5,0.7  GET oGetObs VAR __cJust OF oDlgObs MEMO size 180,40
	oGetObs:bRClicked := {||AllwaysTrue()}
	oDlgObs:nBOTTOM := 200
	
	If _lRadio
		oRadio := TRADMENU():Create(oDlgObs)
		oRadio:cName := "oRadio"
		oRadio:cCaption := "oRadio1
		oRadio:nLeft := 10
		oRadio:nTop := 100
		oRadio:nWidth := 278
		oRadio:nHeight := 49
		oRadio:lShowHint := .F.
		oRadio:lReadOnly := .F.
		oRadio:Align := 0
		oRadio:cVariable := "_nRecorrente"
		oRadio:bSetGet := {|u| If(PCount()>0,_nRecorrente:=u,_nRecorrente) }
		oRadio:lVisibleControl := _lRadio
		oRadio:nOption := 2
		oRadio:aItems := { "Recorrente (Poderแ ocorrer mais de uma vez no ano)","Pontual (Caso isolado, nใo ocorrerแ mais)"}
	EndIf
	
	DEFINE SBUTTON FROM 70, 150 TYPE 1  ENABLE OF oDlgObs ACTION oDlgObs:End()
	
	ACTIVATE MSDIALOG oDlgObs CENTERED
	
	If PodeFechar(_lRadio,_nRecorrente,__cJust)
		Exit
	EndIf
EndDo



cTxt := "Formulแrio para Solicita็ใo de Contig๊ncia Or็amentแria"
cTxt += "<BR>"
cTxt += "<BR>"
cTxt += "<BR>"
cTxt += "Informa็๕es Pessoais"
cTxt += "<BR>"
cTxt += _cNome
cTxt += "<BR>"
cTxt += _cEmail
cTxt += "<BR>"
cTxt += "<BR>"
cTxt += "Informa็๕es da Contig๊ncia"
cTxt += "<BR>"
cTxt += _cEmpresa
cTxt += "<BR>"
cTxt += _cTipoCusto
cTxt += "<BR>"
cTxt += _cProjeto
cTxt += "<BR>"
cTxt += _cClasse
cTxt += "<BR>"
cTxt += _cCCusto
cTxt += "<BR>"
cTxt += _cValor+"                "+_cValCont
cTxt += "<BR>"
cTxt += "<BR>"
cTxt += _cTpContigencia
cTxt += "<BR>"
If _lRadio
	If _nRecorrente = 1
		cTxt += "*** Solicita็ใo Recorrente ***" +"<BR>"
	ElseIF _nRecorrente = 2
		cTxt += "*** Solicita็ใo Pontual ***"+"<BR>"
	EndIf
	cTxt += "<BR>"
EndIf
cTxt += "<BR>"
cTxt += "Justificativa"
cTxt += "<BR>"

_nLinMemo:= MLCount(__cJust, _nTamLinha )
For _nI:=1 to _nLinMemo
	cTxt +=MemoLine(__cJust,_nTamLinha,_nI)
	cTxt += "<BR>"
Next _nI

/*

cTxt += CRLF// Enter para pular uma linha
cTxt += "Justificativa da contig๊ncia:"+CRLF
cTxt += __cJust+CRLF
If _lRadio
If _nRecorrente = 1
cTxt += "*** Solicita็ใo Recorrente ***" +CRLF
ElseIF _nRecorrente = 2
cTxt += "*** Solicita็ใo Pontual ***"+CRLF
EndIf
EndIF
*/
Return(cTxt)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfShowRadioบAutor  ณRenato Lucena Neves บ Data ณ  12/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fShowRadio(_cCubo)

Local _cCuboShowRadio := AllTrim(GetNewPar("MV_XCUBRAD",""))
Local _lRet	:= .T.

If !Empty(_cCuboShowRadio)
	_lRet := ( _cCubo $ _cCuboShowRadio )
EndIf

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณP530EWF   บAutor  ณMicrosiga           บ Data ณ  04/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PodeFechar(_lRadio,_nRecorrente,__cJust)

Local _lRet := .T.

If Empty(__cJust)
	_lRet := .F.
	MsgAlert("O preenchimento da justificativa ้ obrigat๓rio.")
EndIf

If _lRadio .and. _nRecorrente = 0
	_lRet := .F.
	MsgAlert("Indique se a contigencia ้ recorrente ou nใo.")
EndIF

Return _lRet
                                                                              	