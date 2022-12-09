#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SCHXMLCTE  บAutor  ณFrancisco Godinho   บ Data ณ  29/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Shedule leitura xml CT-e entradas diretorio                  บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SCHXMLCTE()
Local aStru    := {}
Local cCodEmp  := ""
Local cCodFil  := ""
Local cGrupoIni:= ""
Local cGrupoFim:= ""
Local cProdIni := ""
Local cProdFim := ""
Local cFamDev  := ""
Local cCatDev  := ""
Local cCNPJ    := ""
Local cQuery   := ""
Local cCursor  := "SZX"
Local cLocal	:= ""
Local lQuery   := .F.
Local nX       := 0
Private a_Xml := {}
Private cDirErro  := ""
Private xEmp, xFil
xEmp := "01"
xFil := "01"
xx := "1"
xEmp := If(Empty(xEmp),"01",xEmp)
xFil := If(Empty(xFil),"01",xFil)
//RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.
	RPCSetType( 3 )						// Nใo consome licensa de uso
	wfPrepENV(xEmp, xFil)
Else
	lAuto := .T.
	RPCSetType( 3 )						// Nใo consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil
Endif

_cFilial := xFil
nMesAte := Month(dDatabase) - 1
_lTudo :=  .T.  // MsgYesNo("Processa apenas o mes corrente ?","Confirma.")///#
cPathXml := SuperGetMv("AG_PCTXML",,"\xml_cte\")

//conout("Path <GO_PCTXML> : "+cPathXml)

cDirXml :=cPathXml
aXML := Directory(cDirXml+"*.XML")
For nX := 1 to Len(aXML)
	// IncProc("Processando Filial: "+_cFilial+" - Mes: "+cMes)
	lProcessou := .F.                                                 
	cXMLFile := cDirXml+aXML[nX][1]
	xGrvZZS(cXMLFile,_cFilial,cDirXml)
Next
// Envia Mensagens de notificacao
If Len(a_Xml) > 0
	AIMSGENV(a_Xml)
EndIf

Return()

/**************************************/
Static FuncTion xGrvZZS(cXMLFile,_cFil,cDirXml)
/**************************************/
Local lRetorno := .T.
Local nX       := 0
Local oRetorno
Local oXML
Local cError := ""
Local cWarning := ""
Local errStr := ""
Local warnStr := ""

//conout("Parametros  <cXMLFile>: "+cXMLFile)

aGlobalStack := {}

cXML := MEMOREAD( cXMLFile )

oXml := XmlParser ( cXML, "_", @errStr, @warnStr )

cNewArq   :=  Substr(cXMLFile,Rat("\",cXMLFile)+1,Len(Alltrim(cXMLFile)))
cChaveNfe := Substr(cNewArq,4,45)
cDirErro  := cDirXml+"invalidos\"
cDirOk    := cDirXml+"processados\"

MakeDir(cDirErro)
MakeDir(cDirOk)

//conout("Dir OK : "+cDirOk)
//conout("Dir Erro: "+cDirErro)
//conout("Arquivo: "+cXMLFile)

// Checa Integridade do xml ctrc e a existencia das tags a serem lidas
cTag1 := "<cteProc"
cTag2 := "<CTe"
cTag3 := "<infCte"
cTag5 := "<infNF"
nPosTag1 := At(cTag1,cXML)
nPosTag2 := At(cTag2,cXML)
nPosTag3 := At(cTag3,cXML)
nPosTag5 := At(cTag5,cXML)
lCteproc := .F.
If nPosTag1 > 0
	lCteproc := .T.
EndIf
l_Ok := .T.
xx := "XX"           // Ponto de parada debug
If (nPosTag1 = 0 .And. nPosTag3 = 0 ) .Or. nPosTag2 = 0  // .Or. nPosTag5 = 0 // .Or. nPosTag6 = 0
	l_Ok := .F.
	DbSelectArea("ZZT")
	RecLock("ZZT",.T.)
	ZZT->ZZT_FILIAL := xFilial("ZZT")
	ZZT->ZZT_CHAVE  := cChaveNfe
	ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
	ZZT->ZZT_CLIFOR := ""
	ZZT->ZZT_LOJA   := ""
	ZZT->ZZT_OCORRE := "Erro de estrutura. XML nao e < CTE > "
	MsUnlock()
	aadd(a_Xml,cChaveNfe+ " - " + ZZT->ZZT_OCORRE )
	
	__CopyFile(cXMLFile,cDirErro+cNewArq)
	Ferase(cXMLFile)
EndIf

If oXml == NIL .or. !Empty(errStr) .or. !Empty(warnStr)
	l_Ok := .F.
	DbSelectArea("ZZT")
	RecLock("ZZT",.T.)
	ZZT->ZZT_FILIAL := xFilial("ZZT")
	ZZT->ZZT_CHAVE  := cChaveNfe
	ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
	ZZT->ZZT_CLIFOR := ""
	ZZT->ZZT_LOJA   := ""
	ZZT->ZZT_OCORRE := "Nใo foi possivel ler XML. Erro: "+errStr
	MsUnlock()
	aadd(a_Xml,cChaveNfe+ " - " + ZZT->ZZT_OCORRE )
	__CopyFile(cXMLFile,cDirErro+cNewArq)
	
	Ferase(cXMLFile)
EndIf
If ! l_Ok
	Return .F.
EndIf

// CREATE oXML XMLFILE cXMLFile

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLe as Tags necessarias para a tabela SZX  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
xx:= "1"
If lCteproc
	cChave  := oXML:_CTEPROC:_CTE:_INFCTE:_ID:TEXT
	cChave  := Substr(cChave,4,45)
	oDest   :=oXML:_CTEPROC:_CTE:_INFCTE:_DEST
	c_RemCNPJ  := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	If Type("oDest:_CPF") <> "U"
		c_DestCNPJ := oDest:_CPF:TEXT
	Else
		c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
	EndIf
	dEmissao   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	//	nMes    := Substr(dEmissao,RAt("-",dEmissao)+1,RAt("-",dEmissao) - At("-",dEmissao) -1)
	nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
	nDia    := Substr(dEmissao,RAt("-",dEmissao)+1,2)
	nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
	
Else
	cChave  := oXml:_CTE:_INFCTE:_ID:TEXT
	cChave  := Substr(cChave,4,45)
	oDest   := oXML:_CTE:_INFCTE:_DEST
	If Type("oDest:_CPF") <> "U"
		c_DestCNPJ := oDest:_CPF:TEXT
	Else
		c_DestCNPJ := oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
	EndIf
	c_RemCNPJ  := oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	dEmissao   := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
	nDia    := Substr(dEmissao,RAt("-",dEmissao)+1,2)
	nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
EndIf
cChave  := StrTran(cChave,'-','')
cChave  := StrTran(cChave,'.','')
cChave  := StrTran(cChave,'/','')+Space(10)
cChave  := Substr(cChave,1,45)

dEmissao:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))

If lCteproc
	cCnpj := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
Else
	cCnpj := oXml:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
EndIf

cCnpj    := StrTran(cCnpj,'.','')
cCnpj    := StrTran(cCnpj,'/','')
cCnpj    := StrTran(cCnpj,'-','')
cCliFor  := "S"
cCodCF   := ""
cLoj     := ""
a_Cnpj    := {}
l_Agro    := .F.
l_Entrada := .F.
l_Saida   := .F.
dbSelectArea("SM0")
nRegSM0 := SM0->(Recno())
dbSetOrder(1)
SM0->(DbGoTop())
While SM0->(!Eof())
	If c_RemCNPJ == SM0->M0_CGC
		l_Agro  := .T.
		aadd(a_Cnpj,{SM0->M0_CODFIL,"R"})
	EndIf
	If c_DestCNPJ == SM0->M0_CGC
		l_Agro  := .T.
		aadd(a_Cnpj,{SM0->M0_CODFIL,"D"})
	EndIf
	
	SM0->(dbSkip())
Enddo
SM0->(DbGoTo(nRegSM0))
If Len(a_Cnpj) > 1
	for i = 1 to len(a_Cnpj)
		// Pega filial do remetente
		if a_Cnpj[i][2] == "R"
			_cFil := a_Cnpj[i][1]
		endif
	next
EndIf

If  ! l_Agro //  ! l_Entrada .And. !l_Saida
	aadd(a_Xml,cChaveNfe+ " - CNPJ Remetente/Destinatario nao e da Agrozootec" )
	
	__CopyFile(cXMLFile,cDirErro+cNewArq)
	
	Ferase(cXMLFile)
	Return .F.
EndIf
cStatus := "0"
DbSelectArea("SA2")
DbSetOrder(3)
If DbSeek(xFilial("SA2") + cCnpj )
	cCliFor := "F"
	cCodCF  := SA2->A2_COD
	cLoj    := SA2->A2_LOJA
	If SA2->A2_MSBLQL == "1"
		cStatus := "5"
		aadd(a_Xml,cChaveNfe+ " - Transportadora CNPJ: " + cCnpj + " Bloqueado no Cadastro de Fornecedor." )
	EndIf
Else
	aadd(a_Xml,cChaveNfe+ " - Transportadora CNPJ: " + cCnpj + " nao encontrado no Cadastro de Fornecedor." )
	cStatus := "5"
EndIf
CSERIE   := Alltrim(Str(Val(Substr(cChave,23,3)),3,0))
cDoc     := Substr(cChave,26,9)
// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota  8= Regra ZZQ/ZZP nao localizada
DbSelectArea("ZZS")
DbSetOrder(1)
IF  DbSeek(_cFil + cChave )
	Reclock("ZZS",.F.)
	ZZS->ZZS_CGC     := cCnpj
	ZZS->ZZS_EMISSA  := dEmissao
	ZZS->ZZS_DOC     := StrZero(Val(cDoc),9)
	ZZS->ZZS_SERIE   := CSERIE
	ZZS->ZZS_CLIFOR  := cCodCF
	ZZS->ZZS_LOJA    := cLoj
	ZZS->ZZS_XML     := cXML
	ZZS->ZZS_STATUS  := cStatus
	ZZS->ZZS_ESPECI  := "CTE"
	MsUnlock()
Else
	Reclock("ZZS",.T.)
	ZZS->ZZS_FILIAL := _cFil
	ZZS->ZZS_CHAVE  := cChave
	ZZS->ZZS_CGC    := cCnpj
	ZZS->ZZS_EMISSA := dEmissao
	ZZS->ZZS_DOC    := StrZero(Val(cDoc),9)
	ZZS->ZZS_SERIE  := CSERIE
	ZZS->ZZS_XML     := cXML
	ZZS->ZZS_STATUS := cStatus
	ZZS->ZZS_ESPECI := "CTE"
	MsUnlock()
	
	DbSelectArea("ZZT")
	RecLock("ZZT",.T.)
	ZZT->ZZT_FILIAL := _cFil
	ZZT->ZZT_CHAVE  := cChave
	ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
	ZZT->ZZT_CLIFOR := cCodCF
	ZZT->ZZT_LOJA   := cLoj
	ZZT->ZZT_OCORRE := "Carga Inicial. "
	MsUnlock()
	
EndIf
_nPosIniICM	:=At("<pICMS",cXML)
_nPosFimICM :=At("</pICMS",cXML)
_nPosIniICM += 7
nAliqICM := val(Substr(cXML, _nPosIniICM, _nPosFimICM - _nPosIniICM))
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCopia o arquivo para a pasta processados e apaga arquivo lido      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
__CopyFile(cXMLFile,cDirOk+cNewArq)
Ferase(cXMLFile)
//conout("Retorno do Erase: "+Str(Ferror(),10))
oXml := Nil
DelClassIntf()
Return

//////////////////////////////////////////////////////////////////////////////////////
//Rotina que envia email para usuarios pre-determinados, sobre os desenhos enviados //
//////////////////////////////////////////////////////////////////////////////////////
Static Function AIMSGENV(a_Xml)
Local cSubject		:= ""
Local cxDes			:= ""
Local cxNomDes		:= ""
Local cEmailXml		:= AllTrim(SuperGetMv("AG_MAILXML",,"administrativo@agrozootec.com.br")) //
Local cMail			:= ""
Local cSMTP			:= ""
Local cOBS			:= 'e-Mail Enviado automaticamente atrav้s do Schedule de importacao XML - Protheus'
LOCAL xArea			:= GetArea() //Area atual utilizada
Local nRegistro		:= ""
nRegistro:=Recno()

_cFrom   :=GetMv("MV_RELFROM")

// Autentica Servidor
_cServer :=GetMv("MV_RELSERV")
_cUser   :=GetMv("MV_RELACNT")
_cPass   :=GetMv("MV_RELAPSW")
                                                                                   
mMensagem := "<BODY>"
mMensagem := mMensagem + "<DIV><FONT face=Arial size=2>Os seguintes xml nao foram importados pelo sistema e foram removidos para pasta: "+cDirErro+"<BR></FONT></DIV>"
mMensagem+= "<BR>"  //</STRONG>

For nP:= 1 To Len(a_Xml)
	_cXml 	 := a_Xml[nP]
	if !Empty(_cXml)
		mMensagem:= mMensagem+"<BR><STRONG><DIV><FONT face=Arial size=2>"
		mMensagem+= "&nbsp;&nbsp;&nbsp;"
		mMensagem+= "Chave :&nbsp;"+ALLTRIM(_cXml)
		mMensagem+= "<BR>"  //</STRONG>
	Endif
Next
mMensagem := mMensagem + "<BR><STRONG>OBS: </STRONG>"+cOBS+"<BR>&nbsp; </DIV>"
mMensagem := mMensagem + "<DIV>&nbsp;</DIV></BODY>"

cSubject := "Aviso Xml removidos para a pasta:  " + cDirErro + "."

CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cPass RESULT _lResult

If _lResult
	
	lAutentica    := GetMV("MV_RELAUTH")
	
	If lAutentica	
			MailAuth(GetMV("MV_RELAUSR"),GetMV("MV_RELPSW"))	
	Endif
	
	nroTenta := 3
	For nTenta := 1 To nroTenta

		SEND MAIL FROM _cFrom to cEmailXml SUBJECT cSubject  BODY mMensagem RESULT _lFoi

	 	If _lFoi
			ConOut("E-mail enviado com sucesso.")
			Exit
		Else
			GET MAIL ERROR cErrorMsg
			ConOut("E-mail nao enviado. Erro: "+cErrorMsg+". Tentativa no: "+StrZero(nTenta,2))
		Endif
	Next

	DISCONNECT SMTP SERVER

EndIf

RestArea(xArea)
Return