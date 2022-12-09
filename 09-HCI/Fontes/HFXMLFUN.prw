#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "mata140.ch"


#DEFINE VALMERC	 01	// Valor total do mercadoria
#DEFINE VALDESC	 02	// Valor total do desconto
#DEFINE TOTPED	 03	// Total do Pedido
#DEFINE FRETE    04	// Valor total do Frete
#DEFINE VALDESP  05	// Valor total da despesa
#DEFINE SEGURO	 07	// Valor total do seguro

Static aPedC := {}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MyAviso   ºAutor  ³Roberto Souza       º Data ³  01/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Interface/Dialog de Aviso.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MyAviso(cCaption,cMensagem,aBotoes,nSize,cCaption2, nRotAutDefault,cBitmap,lEdit,nTimer,nOpcPadrao,lAuto)
Local ny        := 0
Local nx        := 0
Local aSize  := {  {134,304,35,155,35,113,51},;  // Tamanho 1
				{134,450,35,155,35,185,51},; // Tamanho 2
				{227,450,35,210,65,185,99} } // Tamanho 3
Local nLinha    := 0
Local cMsgButton:= ""
Local oGet 
Local nPass := 0
Private oDlgAviso
Private nOpcAviso := 0

DEFAULT lEdit := .F.
If lEdit
	nSize := 3
EndIf

lMsHelpAuto := .F.

cCaption2 := Iif(cCaption2 == Nil, cCaption, cCaption2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando for rotina automatica, envia o aviso ao Log.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('lMsHelpAuto') == 'U'
	lMsHelpAuto := .F.
EndIf

If !lMsHelpAuto
	If nSize == Nil
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o numero de botoes Max. 5 e o tamanho da Msg.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  Len(aBotoes) > 3
			If Len(cMensagem) > 286
				nSize := 3
			Else
				nSize := 2
			EndIf
		Else
			Do Case
				Case Len(cMensagem) > 170 .And. Len(cMensagem) < 250
					nSize := 2
				Case Len(cMensagem) >= 250
					nSize := 3
				OtherWise
					nSize := 1
			EndCase
		EndIf
	EndIf
	If nSize <= 3
		nLinha := nSize
	Else
		nLinha := 3
	EndIf
	DEFINE MSDIALOG oDlgAviso FROM 0,0 TO aSize[nLinha][1],aSize[nLinha][2] TITLE cCaption OF oDlgAviso PIXEL
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	@ 0, 0 BITMAP RESNAME "LOGIN" oF oDlgAviso SIZE aSize[nSize][3],aSize[nSize][4] NOBORDER WHEN .F. PIXEL ADJUST
	@ 11 ,35  TO 13 ,400 LABEL '' OF oDlgAviso PIXEL
	If cBitmap <> Nil
		@ 2, 37 BITMAP RESNAME cBitmap oF oDlgAviso SIZE 18,18 NOBORDER WHEN .F. PIXEL
		@ 3  ,50  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	Else
		@ 3  ,37  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	EndIf
	If nSize < 3
		@ 16 ,38  SAY cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5]
	Else
		If !lEdit
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] READONLY MEMO
		Else
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] MEMO
		EndIf
		
	EndIf
	If Len(aBotoes) > 1 .Or. nTimer <> Nil
		TButton():New(1000,1000," ",oDlgAviso,{||Nil},32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	EndIf
	ny := (aSize[nLinha][2]/2)-36
	For nx:=1 to Len(aBotoes)
		cAction:="{||nOpcAviso:="+Str(Len(aBotoes)-nx+1)+",oDlgAviso:End()}"
		bAction:=&(cAction)
		cMsgButton:= OemToAnsi(AllTrim(aBotoes[Len(aBotoes)-nx+1]))
		cMsgButton:= IF(  "&" $ Alltrim(cMsgButton), cMsgButton ,  "&"+cMsgButton )
		TButton():New(aSize[nLinha][7],ny,cMsgButton, oDlgAviso,bAction,32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
		ny -= 35
	Next nx
	If nTimer <> Nil
		oTimer := TTimer():New(nTimer,{|| nOpcAviso := nOpcPadrao,IIf(nPass==0,nPass++,oDlgAviso:End()) },oDlgAviso)
		oTimer:Activate()       
		bAction:= {|| oTimer:DeActivate() }
		TButton():New(aSize[nLinha][7],ny,"Timer off", oDlgAviso,bAction,32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	Endif
	ACTIVATE MSDIALOG oDlgAviso CENTERED
Else
	If ValType(nRotAutDefault) == "N" .And. nRotAutDefault <= Len(aBotoes)
		cMensagem += " " + aBotoes[nRotAutDefault]
		nOpcAviso := nRotAutDefault
	Endif
	ConOut(Repl("*",40))
	ConOut(cCaption)
	ConOut(cMensagem)
	ConOut(Repl("*",40))
	AutoGrLog(cCaption)
	AutoGrLog(cMensagem)
EndIf

Return (nOpcAviso)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetIdEnt  ºAutor  ³Roberto Souza       º Data ³  01/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a ID da entidade do TSS correspondente a filial    º±±
±±º          ³ corrente.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := ""
Local oWs

cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	cIdEnt  := "000001"
EndIf

RestArea(aArea)
Return(cIdEnt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HFSTATSEF ºAutor  ³Roberto Souza       º Data ³  01/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o Status da Sefaz referente a Entidade informada. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HFSTATSEF(lAuto,cIdEnt,cInfo,lMostra)
Local lRet := .F., antRet := .F., lPri := .T.           
Local oWS
Local oDlg
Local oGet
Local cURL       := ""
Local cStatus    := ""
Local cAuditoria := ""
Local aSize      := {}
Local aXML       := {}
Local nX         := 0
Local lUSANFE    := AllTrim(GetNewPar("XM_USANFE","S")) $ "S "
Local lUSACTE    := AllTrim(GetNewPar("XM_USACTE","S")) $ "S "
Default	lAuto  := .F.

cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nao informe o ID da entidade e utilizada a da filial corrente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cIdEnt == Nil .Or. Empty(cIdEnt)
	cIdEnt := U_GetIdEnt()
EndIf

	If !Empty(cIdEnt)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Instancia a classe                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cIdEnt)
			oWS:= WSNFeSBRA():New()
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
			If oWS:MONITORSEFAZMODELO()
				aSize := MsAdvSize()
				aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
				lRet := .F.
				lPri := .T.
				For nX := 1 To Len(aXML)
					Do Case
						Case aXML[nX]:cModelo == "55"
							cStatus += "- NFe"+CRLF
						Case aXML[nX]:cModelo == "57"
							cStatus += "- CTe"+CRLF
					EndCase
					cStatus += Space(6)+"Versão da mensagem: "+aXML[nX]:cVersaoMensagem+CRLF
					cStatus += Space(6)+"Código do Status: "+aXML[nX]:cStatusCodigo+"-"+aXML[nX]:cStatusMensagem+CRLF
	                cStatus += Space(6)+"UF Origem: "+aXML[nX]:cUFOrigem+CRLF
	                If !Empty(aXML[nX]:cUFResposta)
		                cStatus += Space(6)+"UF Resposta: "+aXML[nX]:cUFResposta+CRLF
		   			EndIf
	                If aXML[nX]:nTempoMedioSEF <> Nil
						cStatus += Space(6)+"Tempo de espera: "+Str(aXML[nX]:nTempoMedioSEF,6)+CRLF+CRLF
					EndIf
					If !Empty(aXML[nX]:cMotivo)
						cStatus += Space(6)+"Motivo"+": "+aXML[nX]:cMotivo+CRLF+CRLF
					EndIf
					If !Empty(aXML[nX]:cObservacao)
						cStatus += Space(6)+"Observação"+": "+aXML[nX]:cObservacao+CRLF+CRLF
					EndIf
					If !Empty(aXML[nX]:cSugestao)
						cStatus += Space(6)+"Sugestão"+": "+aXML[nX]:cSugestao+CRLF+CRLF
					EndIf
					If !Empty(aXML[nX]:cLogAuditoria)
						cAuditoria += aXML[nX]:cLogAuditoria
					EndIf
				
					cInfo := cStatus
					if (aXML[nX]:cModelo == "55" .and. lUSANFE) .or. (aXML[nX]:cModelo == "57" .and. lUSACTE)
						antRet := AllTrim(aXML[nX]:cStatusCodigo)=="107"
						if lPri .or. !antRet
							lRet := antRet
							lPri := .F.
						endif
					endif
				Next nX
				If !lAuto .And. lMostra						
					DEFINE MSDIALOG oDlg TITLE "SPED - NFe" From 017,000 to (aSize[6]/3),(aSize[5]/2) OF oMainWnd PIXEL
					@ 005,005 GET oGet VAR cStatus OF oDlg SIZE (aSize[3]/2)-005,(aSize[4]/3)-032 PIXEL MULTILINE
					oGet:lReadOnly := .T.
					@ (aSize[4]/3)-022,(aSize[3]/2)-040 BUTTON oBtn1 PROMPT "OK"   	  			ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011
					@ (aSize[4]/3)-022,(aSize[3]/2)-080 BUTTON oBtn2 PROMPT "Detalhes"   		ACTION (Aviso("Detalhes",cAuditoria,{"OK"},3)) OF oDlg PIXEL SIZE 035,011 WHEN !Empty(cAuditoria)
					ACTIVATE MSDIALOG oDlg	CENTERED
			    EndIf
			Else
				lRet := .F.
				cInfo := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
				If !lAuto						
					U_MyAviso("SPED",cInfo,{"OK"},3)
				EndIf		
			EndIf	
		EndIf
	Else
		lRet := .F.
		cInfo := "Execute o módulo de configuração do TSS, antes de utilizar a consulta de Status da Sefaz!!!"
		If !lAuto						
			U_MyAviso("SPED",cInfo,{"OK"},3)
		EndIf		
		
	EndIf
Conout(cInfo)
Return(lRet)

            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IsShared  ºAutor  ³Roberto Souza       º Data ³  24/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se a tabela é compartilhada ou exclusiva.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IsShared(cTable)
Local lRet := .F.           

DbSelectArea("SX2")
DbSetOrder(1)

If DbSeek(cTable)
	lRet := SX2->X2_MODO == "C"
EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XCfgMail  ºAutor  ³Roberto Souza       º Data ³  01/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtem os dados de configuração POP / IMAP.                 º±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ XCfgMail(nTipo,nOpc,aInfo)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Array com os dados de configuração de e-mail.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nTipo: Tipo de Configuração                                 ³±±
±±³          ³       1-SMTP                                               ³±±
±±³          ³       2-POP                                                ³±±
±±³          ³nOpc : Operação                                             ³±±
±±³          ³       1-Visualização                                       ³±±
±±³          ³       2-Edição                                             ³±±
±±³          ³aInfo: Array contendo dados para Edição                     ³±±
±±³          ³                                                            ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XCfgMail(nTipo,nOpc,aInfo)

Local aRet   := {}           
Local cServer  := ""
Local cLogin   := ""
Local cConta   := ""
Local cPass    := ""
Local lAuth    := .F.
Local lSSL     := .F.
Local lTLS     := .F. //aquuiiii
Local cProtocol:= ""   
Local cPort    := ""

Default nOpc := 1
Default aInfo:= {}
Default nTipo:= 0

If nTipo == 1  // SMTP            

    If nOpc == 1 // Visualizar
		cServer  := Padr(GetNewPar("XM_SMTP",Space(40)),40)
		cLogin   := Padr(GetNewPar("XM_LOGIN",Space(40)),40)
		cConta   := Padr(GetNewPar("XM_ACCOUNT",Space(40)),40)
		cPass    := Padr(Decode64(GetNewPar("XM_PASS",Space(25))),25)
		lAuth    := GetNewPar("XM_AUT",Space(1))=="S"
		lSSL     := GetNewPar("XM_SSL",Space(1))=="S"
		lTLS     := GetNewPar("XM_TLS",Space(1))=="S"   //aquuiiii
		cProtocol:= GetNewPar("XM_PROTENV","1") 
		cPort    := Padr(GetNewPar("XM_ENVPORT",Space(6)),6)                                   

	ElseIf nOpc == 2 // Atualizar
         
		cServer  := aInfo[1]
		cLogin   := aInfo[2]
		cConta   := aInfo[3]
		cPass    := aInfo[4]
		lAuth    := aInfo[5]
		lSSL     := aInfo[6]
		cProtocol:= aInfo[7]
   		cPort    := aInfo[8]
		lTLS     := aInfo[9]  //aquuiiii
   		
		If !PutMv("XM_SMTP", cServer ) 
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_SMTP"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "SMTP de Envio de XML Fornecedor."
			MsUnLock()
			PutMv("XM_SMTP", cServer )
		EndIf
		/********************************/
		If !PutMv("XM_LOGIN", cLogin      )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_LOGIN"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Login de Email de Envio de XML Fornecedor."
			MsUnLock()
			PutMv("XM_LOGIN", cLogin      )
		EndIf
		/********************************/
		If !PutMv("XM_ACCOUNT", cConta  )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_ACCOUNT"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Conta de Email de Envio de XML Fornecedor."
			MsUnLock()
			PutMv("XM_ACCOUNT", cConta  )
		EndIf	
		/********************************/
		If !PutMv("XM_PASS", Encode64(AllTrim(cPass))  )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_PASS"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Senha da Conta de Envio de XML Fornecedor."
			MsUnLock()
			PutMv("XM_PASS", Encode64(AllTrim(cPass))  )
		EndIf
		/********************************/
		If !PutMv("XM_AUT", Iif(lAuth,"S","N")   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_AUT"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Informa se e-mail utiliza autenticação."
			MsUnLock()
			PutMv("XM_AUT", Iif(lAuth,"S","N")   )
		EndIf
		/********************************/
		If !PutMv("XM_SSL", Iif(lSSL     ,"S","N")   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_SSL"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Informa se e-mail utiliza conexao segura SSL."
			MsUnLock()
			PutMv("XM_SSL", Iif(lSSL     ,"S","N")   )
		EndIf
		/*******************************Aquuiiii*/
		If !PutMv("XM_TLS", Iif(lTLS     ,"S","N")   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_TLS"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Informa se e-mail utiliza conexao segura TLS."
			MsUnLock()
			PutMv("XM_TLS", Iif(lTLS     ,"S","N")   )
		EndIf
		/********************************/
		If !PutMv("XM_PROTENV", cProtocol   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_PROTENV"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Protocolo de envio de notificação de xml."
			MsUnLock()
			PutMv("XM_PROTENV", cProtocol   )
		EndIf
		/********************************/
		If !PutMv("XM_ENVPORT", cPort   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_ENVPORT"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Porta de Envio."
			MsUnLock()
			PutMv("XM_ENVPORT", cPort   )
		EndIf
	EndIf


ElseIf nTipo == 2              


    If nOpc == 1 // Visualizar
		cServer  := Padr(GetNewPar("XM_POPIMAP",Space(40)),40)
		cLogin   := "" //Padr(GetNewPar("XM_LOGIN",Space(40)),40)
		cConta   := Padr(GetNewPar("XM_POPACC",Space(40)),40)
		cPass    := Padr(Decode64(GetNewPar("XM_POPPASS",Space(25))),25)
		lAuth    := GetNewPar("XM_POPAUT",Space(1))=="S"
		lSSL     := GetNewPar("XM_POPSSL",Space(1))=="S"                                                      
		cProtocol:= GetNewPar("XM_PROTREC","1") 
		cPort    := Padr(GetNewPar("XM_RECPORT",Space(6)),6) 		
	ElseIf nOpc == 2 // Atualizar
         
		cServer  := aInfo[1]
		cLogin 	 := aInfo[2]
		cConta   := aInfo[3]
		cPass    := aInfo[4]
		lAuth    := aInfo[5]
		lSSL     := aInfo[6]
		cProtocol:= aInfo[7]
   		cPort    := aInfo[8]

		If !PutMv("XM_POPIMAP", cServer ) 
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_POPIMAP"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Endereço POP/IMAP de Recebimento de XML Fornecedor"
			MsUnLock()
			PutMv("XM_POPIMAP", cServer )
		EndIf
		/********************************
		If !PutMv("XM_LOGIN", cLogin      )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_LOGIN"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Conta de Email de Recebimento de XML Fornecedor."	
			MsUnLock()
			PutMv("XM_LOGIN", cLogin      )
		EndIf
		/********************************/
		If !PutMv("XM_POPACC", cConta  )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_POPACC"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Conta de Email de Recebimento de XML Fornecedor."	
			MsUnLock()
			PutMv("XM_POPACC", cConta  )
		EndIf	
		/********************************/
		If !PutMv("XM_POPPASS", Encode64(AllTrim(cPass))  )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_POPPASS"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Senha da Conta de Recebimento de XML Fornecedor."
			MsUnLock()
			PutMv("XM_POPPASS", Encode64(AllTrim(cPass))  )
		EndIf
		/********************************/
		If !PutMv("XM_POPAUT", Iif(lAuth,"S","N")   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_POPAUT"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Informa se e-mail utiliza autenticação."
			MsUnLock()
			PutMv("XM_POPAUT", Iif(lAuth,"S","N")   )
		EndIf
		/********************************/
		If !PutMv("XM_POPSSL", Iif(lSSL     ,"S","N")   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_POPSSL"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Informa se e-mail utiliza conexao segura."
			MsUnLock()
			PutMv("XM_POPSSL", Iif(lSSL     ,"S","N")   )
		EndIf
		/********************************/
		If !PutMv("XM_PROTREC", cProtocol   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_PROTREC"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Protocolo de recebimento de xml.."
			MsUnLock()
			PutMv("XM_PROTREC", cProtocol   )
		EndIf 
		/********************************/
		If !PutMv("XM_RECPORT", cPort   )
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "XM_RECPORT"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Porta de Recebimento."
			MsUnLock()
			PutMv("XM_RECPORT", cPort   )
		EndIf		
	EndIf

EndIf

Aadd(aRet,cServer  ) // 01
Aadd(aRet,cLogin   ) // 02
Aadd(aRet,cConta   ) // 03
Aadd(aRet,cPass    ) // 04
Aadd(aRet,lAuth    ) // 05
Aadd(aRet,lSSL     ) // 06
Aadd(aRet,cProtocol) // 07
Aadd(aRet,cPort    ) // 08
Aadd(aRet,lTLS     ) // 09

Return(aRet)

     
User Function TTT()


	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
	RpcSetType(3)
	U_XmlInfoX("XML",.T.,"1")
Return()

User Function XmlInfoX(cAliasXML,lEmpty,cTpret)
Local cPerg   := "HFXMLR00" 
Local lperg   := Pergunte(cPerg,.F.)
Local Nx      := 0
Local nOrdem
Local cWhere  := ""
Local cOrder  := ""
Local cLinCab := ""     
Local cFilDe  := MV_PAR01
Local cFilAte := MV_PAR02
Local cDtIni  := DTos(MV_PAR03)
Local cDtFim  := DTos(MV_PAR04)
Local cSerIni := MV_PAR05
Local cSerFim := MV_PAR06
Local cNFIni  := MV_PAR07
Local cNFFim  := MV_PAR08   
Local cEspecP := MV_PAR09//"('SPED','CTE')" 
Local cForIni := MV_PAR10
Local cForFim := MV_PAR11
Local cLojaIni:= MV_PAR12
Local cLojaFim:= MV_PAR13
Local nBaseNf := MV_PAR14
Local aEspecP := Separa(cEspecP,",",.F.)
Local cEmIni  := DTos(MV_PAR16)
Local cEmFim  := DTos(MV_PAR17)
Local aRet    := {}
Local nLimArray := 1000
Private cSF1   := GetNextAlias() 
Private lSharedA1:= U_IsShared("SA1")
Private lSharedA2:= U_IsShared("SA2") 
Private nFormNfe  := Val(GetNewPar("XM_FORMNFE","6"))
Private nFormCTe  := Val(GetNewPar("XM_FORMCTE","6"))
Default cTpret    := "1"
If Len(aEspecP)>0
	nTamesp := Len(aEspecP)
	cEspecP := "("
	For Nx := 1 To nTamesp
    	cEspecP += "'"+AllTrim(aEspecP[Nx])+"'"	
		If Nx < nTamesp
			cEspecP += ","
		EndIf
	Next
	cEspecP += ")"
Else
	cEspecP := "('SPED','CTE')"
EndIf

If cTpret == "1" // Tabela Temporária

	aCampos := {}
	AADD(aCampos,{"F1_FILIAL"	,"C" ,	002	,0 })
	AADD(aCampos,{"F1_TIPO"		,"C" ,	001	,0 })	
	AADD(aCampos,{"F1_FORNECE"	,"C" ,	006	,0 })
	AADD(aCampos,{"F1_LOJA"		,"C" ,	002	,0 })
	AADD(aCampos,{"F1_ESPECIE"	,"C" ,	005	,0 })
	AADD(aCampos,{"F1_SERIE"	,"C" ,	003	,0 })
	AADD(aCampos,{"F1_DOC"      ,"C" ,	009	,0 })
	AADD(aCampos,{"F1_EMISSAO"	,"D" ,	008	,0 })
	AADD(aCampos,{"F1_DTDIGIT"	,"D" ,	008	,0 })
	AADD(aCampos,{"F1_VALBRUT"	,"N" ,	017	,2 })
	AADD(aCampos,{"F1_CGC"		,"C" ,	014	,0 })
	AADD(aCampos,{"F1_NOME"		,"C" ,	030	,0 })
	AADD(aCampos,{"F1_FONE"		,"C" ,	020	,0 })
	AADD(aCampos,{"F1_EMAIL"	,"C" ,	030	,0 })
	AADD(aCampos,{"F1_STXML"	,"C" ,	001	,0 })

	cArqEmp	:=	CriaTrab(aCampos)
	
	dbUseArea(.T.,__LocalDrive,cArqEmp,cAliasXML,.T.,.F.)
	       
	DbSelectArea(cAliasXML)
	cIndEmp		:=CriaTrab (NIL, .F.)
	cChave      := "F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC+F1_SERIE+F1_TIPO"
	cFiltroTmp	:= ""
  
	IndRegua(cAliasXML, cIndEmp, cChave,, cFiltroTmp)
	DbSetIndex(cIndEmp+OrdBagExt ())
	DbSetOrder(1)	
	DbGoTop()   
	
EndIf


if nBaseNf == 1

	cWhere := "% AND  SF1.F1_DTDIGIT>='"+cDtIni+"' AND  SF1.F1_DTDIGIT<='"+cDtFim+"' AND SF1.F1_ESPECIE IN "+cEspecP 
	// Ignorar Devolução e Beneficiamento - Excluir quando implementar tratamento para devolução
	cWhere += " AND SF1.F1_TIPO NOT IN ('D','B') "	
	//------------------
	cWhere += " AND  SF1.F1_EMISSAO>='"+cEmIni+"' AND SF1.F1_EMISSAO<='"+cEmFim+"'"
	cWhere += " AND  SF1.F1_FORMUL <> 'S'"	
	cWhere += " AND  SF1.F1_FILIAL>='"+cFilDe+"' AND  SF1.F1_FILIAL<='"+cFilAte+"'"	
	cWhere += " AND  SF1.F1_DOC>='"+cNFIni+"' AND  SF1.F1_DOC<='"+cNFFim+"'"
	cWhere += " AND  SF1.F1_SERIE>='"+cSerIni+"' AND  SF1.F1_SERIE<='"+cSerFim+"'"						               
	cWhere += " AND  SF1.F1_FORNECE>='"+cForIni+"' AND  SF1.F1_FORNECE<='"+cForFim+"' "						               
	cWhere += " AND  SF1.F1_LOJA>='"+cLojaIni+"' AND  SF1.F1_LOJA<='"+cLojaFim+"' %"						               
    cOrder := "%( F1_FILIAL,F1_DTDIGIT,F1_DOC,F1_SERIE )%"

	BeginSql Alias cSF1
	
		SELECT	F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO,F1_ESPECIE, ' ' as F1_STXML,
			F1_EMISSAO,	F1_DTDIGIT,F1_CHVNFE,F1_VALBRUT,R_E_C_N_O_ 
			FROM %Table:SF1% SF1
			WHERE SF1.%notdel%
			%Exp:cWhere%
    		ORDER BY F1_FILIAL,F1_FORNECE,F1_LOJA,F1_DOC,F1_SERIE ,F1_DTDIGIT
	EndSql      

Else

	cWhere := "% AND  ZBZ.ZBZ_DTRECB>='"+cDtIni+"' AND  ZBZ.ZBZ_DTRECB<='"+cDtFim+"'"
	// Ignorar Devolução e Beneficiamento - Excluir quando implementar tratamento para devolução
	cWhere += " AND ZBZ.ZBZ_TPDOC NOT IN ('D','B') "	
	//------------------
	cWhere += " AND  ZBZ.ZBZ_DTNFE>='"+cEmIni+"' AND ZBZ.ZBZ_DTNFE<='"+cEmFim+"'"
	cWhere += " AND  ZBZ.ZBZ_FILIAL>='"+cFilDe+"' AND  ZBZ.ZBZ_FILIAL<='"+cFilAte+"'"	
	cWhere += " AND  ZBZ.ZBZ_NOTA>='"+cNFIni+"' AND  ZBZ.ZBZ_NOTA<='"+cNFFim+"'"
	cWhere += " AND  ZBZ.ZBZ_SERIE>='"+cSerIni+"' AND  ZBZ.ZBZ_SERIE<='"+cSerFim+"'"						               
	cWhere += " AND  ZBZ.ZBZ_CODFOR>='"+cForIni+"' AND  ZBZ.ZBZ_CODFOR<='"+cForFim+"' "						               
	cWhere += " AND  ZBZ.ZBZ_LOJFOR>='"+cLojaIni+"' AND  ZBZ.ZBZ_LOJFOR<='"+cLojaFim+"' %"						               
    cOrder := "%( F1_FILIAL,F1_DTDIGIT,F1_DOC,F1_SERIE )%"

	BeginSql Alias cSF1
	
		SELECT	ZBZ_FILIAL as F1_FILIAL, ZBZ_NOTA as F1_DOC, ZBZ_SERIE as F1_SERIE, ZBZ_CODFOR as F1_FORNECE,
		    ZBZ_LOJFOR as F1_LOJA, ZBZ_TPDOC as F1_TIPO, ZBZ_MODELO as F1_ESPECIE, ZBZ_PRENF as F1_STXML, ZBZ_PROTC,
			ZBZ_DTNFE as F1_EMISSAO, ZBZ_DTRECB as F1_DTDIGIT, ZBZ_CHAVE as F1_CHVNFE, 0 as F1_VALBRUT, R_E_C_N_O_ 
			FROM %Table:ZBZ% ZBZ
			WHERE ZBZ.%notdel%
			%Exp:cWhere%
    		ORDER BY F1_FILIAL,F1_FORNECE,F1_LOJA,F1_DOC,F1_SERIE,F1_DTDIGIT
	EndSql

Endif

DbSelectArea("ZBZ")
DbSetOrder(6) 

DbSelectArea(cSF1)

DbGoTop()

While (cSF1)->(!EOF())
	cFilProc := (cSF1)->F1_FILIAL
	While (cSF1)->F1_FILIAL == cFilProc .And. (cSF1)->(!EOF())
		
		lFirst := .F.
		If (cSF1)->F1_TIPO $ "D|B"
			DbSelectArea("SA1")
			dbsetorder(1)
			cFilSeek := Iif(lSharedA1,xFilial("SA1"),cFilProc)
			DbSeek(cFilSeek+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA)
			cCnPjF   := SA1->A1_CGC
			cNome    := SA1->A1_NOME
			cTel     := SA1->A1_DDD + " " + SA1->A1_TEL
			cMail    := SA1->A1_EMAIL
		Else            
			DbSelectArea("SA2")
			dbsetorder(1)
			cFilSeek := Iif(lSharedA2,xFilial("SA2"),cFilProc)
			DbSeek(cFilSeek+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA)
			cCnPjF   := SA2->A2_CGC 
			cNome    := SA2->A2_NOME
			cTel     := SA2->A2_DDD + " " + SA2->A2_TEL
			cMail    := SA2->A2_EMAIL
			
		EndIf        
		       		
		
		cCodFor := (cSF1)->F1_FORNECE+(cSF1)->F1_LOJA       
	    While (cSF1)->F1_FORNECE+(cSF1)->F1_LOJA == cCodFor .And. (cSF1)->(!EOF())

			cStatXml:= " " 
			if nBaseNf == 1
				lSeekNf := BuscaXMl(cFilProc,@cStatXml,cCnPjF,1)
			else
				lSeekNf := BuscaNFE(cFilProc,@cStatXml,cCnPjF,1)
				if .not. Empty( (cSF1)->ZBZ_PROTC )
					cStatXml:= "X"
				else
					cStatXml:= (cSF1)->F1_STXML   //ZBZ_PRENF
				endif
			endif
			
			If !lSeekNf	//.or. ( lSeekNf .and. cStatXml $ "B" )
			    If cTpret == "1" // Retorna em tabela Temporária
					RecLock(cAliasXML,.T.)
					(cAliasXML)->F1_FILIAL	:= (cSF1)->F1_FILIAL
					(cAliasXML)->F1_FORNECE	:= (cSF1)->F1_FORNECE
					(cAliasXML)->F1_LOJA	:= (cSF1)->F1_LOJA
					(cAliasXML)->F1_ESPECIE	:= iif(alltrim((cSF1)->F1_ESPECIE) == "55", "SPED" ,;
					                           iif(alltrim((cSF1)->F1_ESPECIE) == "57", "CTE", (cSF1)->F1_ESPECIE ))
					(cAliasXML)->F1_SERIE	:= (cSF1)->F1_SERIE
					(cAliasXML)->F1_DOC		:= (cSF1)->F1_DOC
					(cAliasXML)->F1_EMISSAO := Stod((cSF1)->F1_EMISSAO)
					(cAliasXML)->F1_DTDIGIT := Stod((cSF1)->F1_DTDIGIT)
					(cAliasXML)->F1_VALBRUT := (cSF1)->F1_VALBRUT
				 	(cAliasXML)->F1_CGC     := cCnPjF
					(cAliasXML)->F1_NOME    := cNome 
					(cAliasXML)->F1_FONE    := AllTrim(cTel)
					(cAliasXML)->F1_EMAIL   := AllTrim(cMail)
					(cAliasXML)->F1_STXML   := cStatXml
				    MsUnlock()
													    
			    ElseIf cTpret == "2" // Retorna em Array
			    
				    AADD(aRet,{ (cSF1)->F1_FILIAL   ,;
				    			(cSF1)->F1_FORNECE  ,;
				    			(cSF1)->F1_LOJA     ,;
				    			cNome				,;
				    			cCnPjF				,;
				    			cTel				,;
				    			cMail				,;
				    			(cSF1)->F1_ESPECIE	,;
								(cSF1)->F1_SERIE	,;
				    			(cSF1)->F1_DOC		,;
				    			ConvDate(1 , (cSF1)->F1_EMISSAO),;
				    			ConvDate(1 , (cSF1)->F1_DTDIGIT),;
				    			Transform((cSF1)->F1_VALBRUT,"@E 99,999,999.99"),;
			                    }) 
		 			If Len(aRet) >= nLimArray		 
						Return(aRet)	
					EndIf
				EndIf			                    
			EndIf
				
		   (cSF1)->(DbSkip())
		EndDo       
	EndDo 

EndDo  
            
Return(aRet)
             

Static Function BuscaXml(cFilProc,cStatXml,cCnPjF,nModo)
Local lRet     := .F.
Local aArea    := GetArea()
Local lSeek    := .F. 
Local cModelo  := ""
Local cNFSeek  := ""
Local cKeySeek := "" 
Local cNotaSeek:= ""
Local cSrSem0  := ""
Local cEspec55 := AllTrim(MV_PAR15) //"('SPED','NFE')" 
Private nFormXML  := 6 
Private cModelo   := Iif( AllTrim((cSF1)->F1_ESPECIE) $ iif( empty(cEspec55), "SPED", cEspec55) ,"55", Iif( AllTrim((cSF1)->F1_ESPECIE) == "CTE","57","" ))
Default nModo     := 1     

If cModelo == "55"
 	cPref    := "NF-e"                             
	cTAG     := "NFE"
	nFormXML := nFormNfe
ElseIf cModelo == "57"
 	cPref    := "CT-e"                             
	cTAG     := "CTE"
	nFormXML := nFormCte
EndIf

/*
If (cSF1)->F1_TIPO $ "D|B"
	cFilSeek := Iif(lSharedA1,"  ",cFilProc)
	cCnPjF   := Posicione("SA1",1,cFilSeek+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA,"A1_CGC")
Else
	cFilSeek := Iif(lSharedA2,"  ",cFilProc)
	cCnPjF   := Posicione("SA2",1,cFilSeek+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA,"A2_CGC")
EndIf        
*/       


If nModo == 1
	DbSelectArea("ZBZ") 
	DbSetorder(6) // "ZBZ_FILIAL+ZBZ_MODELO+ZBZ_NOTA+ZBZ_SERIE+ZBZ_CNPJ"
	
    lSeek := .F.
   	cNotaSeek := Iif(nFormXML > 0,StrZero(Val((cSF1)->F1_DOC),nFormXML),AllTrim(Str(Val((cSF1)->F1_DOC))))
	cKeySeek  := (cSF1)->F1_FILIAL+cModelo+cNotaSeek+(cSF1)->F1_SERIE+cCnPjF
	cSrSem0   := Substr( ALLTRIM( Str( Val( (cSF1)->F1_SERIE ) ) ) + space( 50 ), 1, len(ZBZ->ZBZ_SERIE) )
 
	lSeek := ZBZ->(DbSeek(cKeySeek))
       
    If !lSeek
		cNotaSeek := Padr(AllTrim(Str(Val((cSF1)->F1_DOC))),9)
		cKeySeek  := (cSF1)->F1_FILIAL+cModelo+cNotaSeek+(cSF1)->F1_SERIE+cCnPjF
        lSeek := ZBZ->(DbSeek(cKeySeek))
    EndIf

    If !lSeek
   		cNotaSeek :=  Padr(StrZero(Val((cSF1)->F1_DOC),6),9)
    	cKeySeek  := (cSF1)->F1_FILIAL+cModelo+cNotaSeek+(cSF1)->F1_SERIE+cCnPjF
        lSeek := ZBZ->(DbSeek(cKeySeek))
    EndIf
 
    If !lSeek
   		cNotaSeek :=  Padr(StrZero(Val((cSF1)->F1_DOC),9),9)
       	cKeySeek  := (cSF1)->F1_FILIAL+cModelo+cNotaSeek+(cSF1)->F1_SERIE+cCnPjF
        lSeek := ZBZ->(DbSeek(cKeySeek))
 	EndIf

    IF !lSeek
   		cNotaSeek := Iif(nFormXML > 0,StrZero(Val((cSF1)->F1_DOC),nFormXML),AllTrim(Str(Val((cSF1)->F1_DOC))))
		cKeySeek  := (cSF1)->F1_FILIAL+cModelo+cNotaSeek+cSrSem0+cCnPjF
		lSeek := ZBZ->(DbSeek(cKeySeek))
	ENDIF
       
    IF !lSeek
		cNotaSeek := Padr(AllTrim(Str(Val((cSF1)->F1_DOC))),9)
		cKeySeek  := (cSF1)->F1_FILIAL+cModelo+cNotaSeek+cSrSem0+cCnPjF
        lSeek := ZBZ->(DbSeek(cKeySeek))
    ENDIF

    IF !lSeek
   		cNotaSeek :=  Padr(StrZero(Val((cSF1)->F1_DOC),6),9)
    	cKeySeek  := (cSF1)->F1_FILIAL+cModelo+cNotaSeek+cSrSem0+cCnPjF
        lSeek := ZBZ->(DbSeek(cKeySeek))
    ENDIF
 
    IF !lSeek
   		cNotaSeek :=  Padr(StrZero(Val((cSF1)->F1_DOC),9),9)
       	cKeySeek  := (cSF1)->F1_FILIAL+cModelo+cNotaSeek+cSrSem0+cCnPjF
        lSeek := ZBZ->(DbSeek(cKeySeek))
 	ENDIF

	If lSeek 
		cStatXml := ZBZ->ZBZ_PRENF
		lRet := .T.
	EndIf		                                  	
ElseIf nModo == 2
	lContinua := .T.
	cKeySeek  := (cSF1)->F1_FILIAL+cCnPjF
	DbSelectArea("ZBZ") 
	DbSetorder(1) // ZBZ_FILIAL+ZBZ_CNPJ+ZBZ_CHAVE+ZBZ_DTRECB
    If DbSeek(cKeySeek)
		While ZBZ->ZBZ_FILIAL + ZBZ->ZBZ_CNPJ == cKeySeek .And. lContinua .And. ZBZ->(!Eof())
		    If Val((cSF1)->F1_DOC) == Val(ZBZ->ZBZ_NOTA) .And. Val((cSF1)->F1_SERIE) == Val(ZBZ->ZBZ_SERIE) .And. ZBZ->ZBZ_SERIE <> "F"                            
				lRet := .T.
				lContinua := .F.
			EndIf	
			ZBZ->(DbSkip())
		EndDo
		    
    Else
    
    EndIf


EndIf
                       
RestArea(aArea)
Return(lRet)


Static Function BuscaNFE(cFilProc,cStatXml,cCnPjF,nModo)
Local lRet     := .F.
Local aArea    := GetArea()
Local lSeek    := .F. 
Local cModelo  := ""
Local cNFSeek  := ""
Local cKeySeek := "" 
Local cNotaSeek:= ""
Private nFormXML  := 6 
Private cModelo   := AllTrim((cSF1)->F1_ESPECIE)
Default nModo     := 1     

If cModelo == "55"
 	cPref    := "NF-e"                             
	cTAG     := "NFE"
	nFormXML := nFormNfe
ElseIf cModelo == "57"
 	cPref    := "CT-e"                             
	cTAG     := "CTE"
	nFormXML := nFormCte
EndIf

If nModo == 1
	DbSelectArea("SF1") 
	DbSetorder(1) // "F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO"
	
    lSeek := .F.
   	cNotaSeek := Iif(nFormXML > 0,StrZero(Val((cSF1)->F1_DOC),nFormXML),AllTrim(Str(Val((cSF1)->F1_DOC))))
	cKeySeek  := (cSF1)->F1_FILIAL+cNotaSeek+(cSF1)->F1_SERIE+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA+(cSF1)->F1_TIPO
 
	lSeek := SF1->(DbSeek(cKeySeek))
       
    If !lSeek
		cNotaSeek := Padr(AllTrim(Str(Val((cSF1)->F1_DOC))),9)
		cKeySeek  := (cSF1)->F1_FILIAL+cNotaSeek+(cSF1)->F1_SERIE+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA+(cSF1)->F1_TIPO
        lSeek := SF1->(DbSeek(cKeySeek))
    EndIf

    If !lSeek
   		cNotaSeek :=  Padr(StrZero(Val((cSF1)->F1_DOC),6),9)
    	cKeySeek  := (cSF1)->F1_FILIAL+cNotaSeek+(cSF1)->F1_SERIE+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA+(cSF1)->F1_TIPO
        lSeek := SF1->(DbSeek(cKeySeek))
    EndIf
 
    If !lSeek
   		cNotaSeek :=  Padr(StrZero(Val((cSF1)->F1_DOC),9),9)
       	cKeySeek  := (cSF1)->F1_FILIAL+cNotaSeek+(cSF1)->F1_SERIE+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA+(cSF1)->F1_TIPO
        lSeek := SF1->(DbSeek(cKeySeek))
 	EndIf

    IF !lSeek
   		cNotaSeek := Iif(nFormXML > 0,StrZero(Val((cSF1)->F1_DOC),nFormXML),AllTrim(Str(Val((cSF1)->F1_DOC))))
		cKeySeek  := (cSF1)->F1_FILIAL+cNotaSeek+ Str( Val( (cSF1)->F1_SERIE ), len( (cSF1)->F1_SERIE ) ) +(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA+(cSF1)->F1_TIPO
		lSeek := SF1->(DbSeek(cKeySeek))
	ENDIF
       
    If !lSeek
		cNotaSeek := Padr(AllTrim(Str(Val((cSF1)->F1_DOC))),9)
		cKeySeek  := (cSF1)->F1_FILIAL+cNotaSeek+Str( Val( (cSF1)->F1_SERIE ), len( (cSF1)->F1_SERIE ) )+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA+(cSF1)->F1_TIPO
        lSeek := SF1->(DbSeek(cKeySeek))
    EndIf

    If !lSeek
   		cNotaSeek :=  Padr(StrZero(Val((cSF1)->F1_DOC),6),9)
    	cKeySeek  := (cSF1)->F1_FILIAL+cNotaSeek+Str( Val( (cSF1)->F1_SERIE ), len( (cSF1)->F1_SERIE ) )+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA+(cSF1)->F1_TIPO
        lSeek := SF1->(DbSeek(cKeySeek))
    EndIf
 
    If !lSeek
   		cNotaSeek :=  Padr(StrZero(Val((cSF1)->F1_DOC),9),9)
       	cKeySeek  := (cSF1)->F1_FILIAL+cNotaSeek+Str( Val( (cSF1)->F1_SERIE ), len( (cSF1)->F1_SERIE ) )+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA+(cSF1)->F1_TIPO
        lSeek := SF1->(DbSeek(cKeySeek))
 	EndIf

 
	If lSeek 
		lRet := .T.
	EndIf		                                  	
ElseIf nModo == 2
	lContinua := .T.
	cKeySeek  := (cSF1)->F1_FILIAL+(cSF1)->F1_FORNECE+(cSF1)->F1_LOJA
	DbSelectArea("SF1") 
	DbSetorder(2) // F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
    If DbSeek(cKeySeek)
		While SF1->F1_FILIAL + SF1->F1_FORNECE + SF1->F1_LOJA == cKeySeek .And. lContinua .And. SF1->(!Eof())
		    If Val((cSF1)->F1_DOC) == Val(SF1->F1_DOC) .And. Val((cSF1)->F1_SERIE) == Val(SF1->F1_SERIE) //.And. ZBZ->ZBZ_SERIE <> "F"
				lRet := .T.
				lContinua := .F.
			EndIf	
			SF1->(DbSkip())
		EndDo
		    
    Else
    
    EndIf


EndIf
                       
RestArea(aArea)
Return(lRet)
 
 
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XConsXml  ºAutor  ³Roberto Souza       º Data ³  19/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta o XML junto a sefaz.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           
User Function XConsXml(cURL,cChaveXml,cModelo,cProtocolo,cMensagem,cCodRet,lShowMsg,xCnpj,xIdEnt,xManif) 

Local lRet      := .F.
Local lProt     := .T.
Local lConModal := ( AllTrim(GetNewPar("XM_GRBMOD","N")) == "S" )
Local cConLoc   := AllTrim(GetNewPar("XM_ROT_CON","1"))              //1=WS Importa, 2=TSS
Local cMsgSm0   := ""
Default xManif     := "0" //GETESB2
Default lShowMsg   := .T.
Default cProtocolo := Space(15)
Default cCodRet    := ""
Default cURL       := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf 

If cModelo == "55"
 	cPref   := "NF-e" 
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"
	cTAG    := "CTE"
EndIf
/*/DEBUG
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
	RpcSetType(3)
	cURL       := AllTrim(SuperGetMv("XM_URL"))
	cChaveXml  :="41121076881093000172550010000361941000361940" 
	cChaveXml  :="35121188317847003403570010000736791065736793"    // CT-e Cancelado
    cModelo    := "55"
	cPref      := "NF-e" 
	cProtocolo := "999999999999999"	                  
*/
//DEBUG
if cConLoc == "1" .or. ( Empty( xManif ) .And. cModelo == "55" )  //GETESB2
	oWs:= WSHFXMLCONSULTACHV():New()
	oWs:Init()
	oWs:cCCURL   := AllTrim(cURL)
	oWs:cCIDENT  := U_GetIdEnt()
	oWs:cCCHAVE  := AllTrim(cChaveXml)
	oWs:nNAMBIENTE   := 1
	oWs:nNMODALIDADE := 1

	if oWs:HFCONSULTACHV()
		cCodRet := oWs:oWSHFCONSULTACHVRESULT:cCCODSTA
		cMensagem := ""
		cMensagem += "Chave : "+cChaveXml+CRLF
		If !Empty(oWs:oWSHFCONSULTACHVRESULT:cCVERSAO)
			cMensagem += "Versão da mensagem : "+oWs:oWSHFCONSULTACHVRESULT:cCVERSAO+CRLF
		EndIf
		cMensagem += "Ambiente: "+IIf(oWs:oWSHFCONSULTACHVRESULT:cCAMBIENTE=="1","Produção","Homologação")+CRLF 
		cMensagem += "Cod.Ret."+cPref+": "+oWs:oWSHFCONSULTACHVRESULT:cCCODSTA+CRLF
		cMensagem += "Msg.Ret."+cPref+": "+oWs:oWSHFCONSULTACHVRESULT:cCMSGSTA+CRLF 
		If !Empty(oWs:oWSHFCONSULTACHVRESULT:cCPROTOCOLO)
			cMensagem += "Protocolo: "+oWs:oWSHFCONSULTACHVRESULT:cCPROTOCOLO+CRLF
			If !Empty(cProtocolo)
				If cProtocolo <> AllTrim(oWs:oWSHFCONSULTACHVRESULT:cCPROTOCOLO)
					cMensagem += "## Protocolo Difere do XML: "+cProtocolo+CRLF
					cMensagem += "             "
					lProt := .F.
				Else
					lProt := .T.
				EndIf      
			EndIf	
		EndIf                                            
		cXml := oWs:oWSHFCONSULTACHVRESULT:cCRETXML
		nAt1:= At('<RETCONSSITNFE ',Upper(cXml))
		nAt2:= At('</RETCONSSITNFE>',Upper(cXml))+ 16
		//Corpo do XML
		If nAt1 <=0
			nAt1:= At('<RETCONSSITNFE>',Upper(cXml))
		EndIf 	
		If nAt1 > 0 .And. nAt2 > 16
			cNfe := Substr(cXml,nAt1,nAt2-nAt1)

			cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
			cXml+= cNfe
			cXml := NoAcento(cXml)
			cXml := EncodeUTF8(cXml)
			cErro:= ""
			cWarning:= ""
			oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
			If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			elseIf oWSrNfe:_RETCONSSITNFE:_CSTAT:TEXT <> "100"
			Else
				If !Empty(oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_DIGVAL:TEXT)
					cMensagem += "Dígito"+": "+oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_DIGVAL:TEXT+CRLF  
				EndIf
				xManif := verManifes(xManif,oWSrNfe)  //GETESB2
			Endif
        EndIf
		If lShowMsg .And. cCodRet $ "100,101"
			U_MyAviso("IMPXML - Consulta "+cPref+" ",cMensagem,{"OK"},3)
		EndIf
	EndIf
	If cCodRet == "100"
		xCnpj  := SM0->M0_CGC
		xIdEnt := oWs:cCIDENT
		If lProt
			lRet := .T.	
		EndIf
	endif
endif
	    
if (cConLoc <> "1" .and. Empty(cCodRet) ) .or. .NOT. cCodRet $ "100,101"
	oWs:= WsNFeSBra():New()
	oWs:cUserToken   := "TOTVS"
	oWs:cID_ENT      := U_GetIdEnt()
	ows:cCHVNFE		 := AllTrim(cChaveXml)
	oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

	If oWs:ConsultaChaveNFE()
		cMensagem := ""
		cMensagem += "Chave : "+cChaveXml+CRLF
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
			cMensagem += "Versão da mensagem : "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
		EndIf
		cMensagem += "Ambiente: "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF 
		cMensagem += "Cod.Ret."+cPref+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
		cMensagem += "Msg.Ret."+cPref+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF 
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
			cMensagem += "Protocolo: "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF
			If !Empty(cProtocolo)
				If cProtocolo <> AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
					cMensagem += "## Protocolo Difere do XML: "+cProtocolo+CRLF
					cMensagem += "             "
					lProt := .F.
				Else
					lProt := .T.
				EndIf      
			EndIf	
		EndIf                                            
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cDIGVAL)
			cMensagem += "Dígito"+": "+oWs:oWSCONSULTACHAVENFERESULT:cDIGVAL+CRLF  
		EndIf
		cCodRet := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
		If lShowMsg
			If cCodRet $ "100,101"
				U_MyAviso("TSS Consulta "+cPref+" ",cMensagem,{"OK"},3)
			endif
		EndIf
	Else
		cMensagem := ""
		cMensagem += "Erro de Webservice : "+CRLF
		cMensagem += IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
		If lShowMsg .and. .NOT. lConModal
			U_MyAviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
        EndIf
	EndIf
	If cCodRet == "100"
		xCnpj  := SM0->M0_CGC
		xIdEnt := oWs:cID_ENT
		If lProt
	   		lRet := .T.	
		EndIf		
	EndIf
	oWs := Nil
EndIf

If .NOT. cCodRet $ "100,101" .AND. lConModal  //Antes da Modalidade vamos verificar nas outras entidades
	If lShowMsg .or. ProcName( 7 ) == "HFXML06CHV"
		oProcess := MsNewProcess():New({| lEnd | VerSM0(@lEnd,oProcess,cURL,AllTrim(cChaveXml),cModelo,@cMensagem,@cCodRet,@lProt,cProtocolo,@cMsgSm0,iif(ProcName( 7 ) == "HFXML06CHV",.T.,lShowMsg),@xCnpj,@xIdEnt)},"Consultando","Consultando Por Outras Entidades...",.T.)
		oProcess:Activate()
	else
		VerSM0(.F.,,cURL,AllTrim(cChaveXml),cModelo,@cMensagem,@cCodRet,@lProt,cProtocolo,@cMsgSm0,lShowMsg,@xCnpj,@xIdEnt)
	endif
	If cCodRet == "100"
		If lProt
			lRet := .T.	
		EndIf
	endif
	If lShowMsg .and. cCodRet $ "100,101"
		U_MyAviso(cMsgSm0+" "+cPref+" ",cMensagem,{"OK"},3)
   	EndIf
EndIf

if .NOT. cCodRet $ "100,101" .AND. lConModal
	If lShowMsg
		oProcess := MsNewProcess():New({| lEnd | VerModal(@lEnd,oProcess,cURL,AllTrim(cChaveXml),cModelo,@cMensagem,@cCodRet,@lProt,cProtocolo,lShowMsg,@xCnpj,@xIdEnt)},"Consultando","Consultando por Modalidade...",.T.)
		oProcess:Activate()
	elseif ProcName( 7 ) <> "HFXML06CHV"
		VerModal(.F.,,cURL,AllTrim(cChaveXml),cModelo,@cMensagem,@cCodRet,@lProt,cProtocolo,lShowMsg,@xCnpj,@xIdEnt)
	endif
	If cCodRet == "100"
		If lProt
			lRet := .T.	
		EndIf
	endif
	If lShowMsg
		U_MyAviso("MODTSS Consulta "+cPref+" ",cMensagem,{"OK"},3)
   	EndIf
Endif

Return(lRet)


Static Function VerSM0(lEnd,oRegua,cURL,cChaveXml,cModelo,cMensagem,cCodRet,lProt,cProtocolo,cMsgSm0,lShowMsg,xCnpj,xIdEnt)
Local aArea  := GetArea()
Local nReg   := SM0->( Recno() )
Local lRet   := .F.
Local cConLoc:= AllTrim(GetNewPar("XM_ROT_CON","1"))              //1=WS Importa, 2=TSS
Local oWs

if lShowMsg
	oRegua:SetRegua1( SM0->(LastRec()) )
	oRegua:SetRegua2(0)

	oRegua:IncRegua1("Outras Entidades: " )
	oRegua:IncRegua2(cChaveXml)
endif

SM0->( dbGoTop() )
Do While .NOT. SM0->( Eof() )
	if lShowMsg
		oRegua:IncRegua1("Outras Entidades: " + SM0->M0_FILIAL )
		oRegua:IncRegua2(cChaveXml)
		If lEnd
			MsgStop("*** Cancelado pelo Operador ***","Fim")
			Exit
		EndIf
	endif
	if SM0->M0_CODIGO <> cEmpAnt
		SM0->( dbSkip() )
		Loop
	endif

	oWs := NIL
	if cConLoc == "1"
		oWs:= WSHFXMLCONSULTACHV():New()
		oWs:Init()
		oWs:cCCURL   := AllTrim(cURL)
		oWs:cCIDENT  := U_GetIdEnt()
		oWs:cCCHAVE  := AllTrim(cChaveXml)
		oWs:nNAMBIENTE   := 1
		oWs:nNMODALIDADE := 1
	
		if oWs:HFCONSULTACHV()
			cCodRet := oWs:oWSHFCONSULTACHVRESULT:cCCODSTA
			cMensagem := ""
			cMensagem += "Chave : "+cChaveXml+CRLF
			If !Empty(oWs:oWSHFCONSULTACHVRESULT:cCVERSAO)
				cMensagem += "Versão da mensagem : "+oWs:oWSHFCONSULTACHVRESULT:cCVERSAO+CRLF
			EndIf
			cMensagem += "Ambiente: "+IIf(oWs:oWSHFCONSULTACHVRESULT:cCAMBIENTE=="1","Produção","Homologação")+CRLF 
			cMensagem += "Cod.Ret."+cPref+": "+oWs:oWSHFCONSULTACHVRESULT:cCCODSTA+CRLF
			cMensagem += "Msg.Ret."+cPref+": "+oWs:oWSHFCONSULTACHVRESULT:cCMSGSTA+CRLF 
			If !Empty(oWs:oWSHFCONSULTACHVRESULT:cCPROTOCOLO)
				cMensagem += "Protocolo: "+oWs:oWSHFCONSULTACHVRESULT:cCPROTOCOLO+CRLF
				If !Empty(cProtocolo)
					If cProtocolo <> AllTrim(oWs:oWSHFCONSULTACHVRESULT:cCPROTOCOLO)
						cMensagem += "## Protocolo Difere do XML: "+cProtocolo+CRLF
						cMensagem += "             "
						lProt := .F.
					Else
						lProt := .T.
					EndIf      
				EndIf	
			EndIf                                            
			cXml := oWs:oWSHFCONSULTACHVRESULT:cCRETXML
			nAt1:= At('<RETCONSSITNFE ',Upper(cXml))
			nAt2:= At('</RETCONSSITNFE>',Upper(cXml))+ 16
			//Corpo do XML
			If nAt1 <=0
				nAt1:= At('<RETCONSSITNFE>',Upper(cXml))
			EndIf 	
			If nAt1 > 0 .And. nAt2 > 16
				cNfe := Substr(cXml,nAt1,nAt2-nAt1)
	
				cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
				cXml+= cNfe
				cXml := NoAcento(cXml)
				cXml := EncodeUTF8(cXml)
				cErro:= ""
				cWarning:= ""
				oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
				If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
				elseIf oWSrNfe:_RETCONSSITNFE:_CSTAT:TEXT <> "100"
				Else
					If !Empty(oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_DIGVAL:TEXT)
						cMensagem += "Dígito"+": "+oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_DIGVAL:TEXT+CRLF  
					EndIf
				Endif
	        EndIf
		EndIf
		If cCodRet == "100"
			If lProt
		   		lRet := .T.	
			EndIf		
		EndIf
		If cCodRet $ "100,101"
			xCnpj   := SM0->M0_CGC
			xIdEnt  := oWs:cCIDENT
			cMsgSm0 := "IMPXML - Consulta - "+Alltrim(SM0->M0_FILIAL)
			Exit
		Endif
	endif
		    
	if cConLoc <> "1" .or. .NOT. cCodRet $ "100,101"
		oWs:= NIL
		oWs:= WsNFeSBra():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cID_ENT      := U_GetIdEnt()
		ows:cCHVNFE		 := AllTrim(cChaveXml)
		oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"
	
		If oWs:ConsultaChaveNFE()
			cMensagem := ""
			cMensagem += "Chave : "+cChaveXml+CRLF
			If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
				cMensagem += "Versão da mensagem : "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
			EndIf
			cMensagem += "Ambiente: "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF 
			cMensagem += "Cod.Ret."+cPref+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
			cMensagem += "Msg.Ret."+cPref+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF 
			If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
				cMensagem += "Protocolo: "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF
				If !Empty(cProtocolo)
					If cProtocolo <> AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
						cMensagem += "## Protocolo Difere do XML: "+cProtocolo+CRLF
						cMensagem += "             "
						lProt := .F.
					Else
						lProt := .T.
					EndIf      
				EndIf	
			EndIf                                            
			If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cDIGVAL)
				cMensagem += "Dígito"+": "+oWs:oWSCONSULTACHAVENFERESULT:cDIGVAL+CRLF  
			EndIf
			cCodRet := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
		Else
			cMensagem := ""
			cMensagem += "Erro de Webservice : "+CRLF
			cMensagem += IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
		EndIf
		If cCodRet == "100"
			If lProt
		   		lRet := .T.	
			EndIf		
		EndIf
		If cCodRet $ "100,101"
			xCnpj   := SM0->M0_CGC
			xIdEnt  := oWs:cID_ENT
			cMsgSm0 := "TSS Consulta "+Alltrim(SM0->M0_FILIAL)
			Exit
		Endif
	EndIf

	SM0->( dbSkip() )
EndDo

SM0->( dbGoTo( nReg ) )
RestArea(aArea)
Return( lRet )


Static Function VerModal(lEnd,oRegua,cURL,cChaveXml,cModelo,cMensagem,cCodRet,lProt,cProtocolo,lShowMsg,xCnpj,xIdEnt)
Local lRet   := .F.
Local nModal := 0
Local oWs

if lShowMsg
	oRegua:SetRegua1(10)
	oRegua:SetRegua2(0)

	oRegua:IncRegua1("Modalidade: " + StrZero(0,1,0) )
	oRegua:IncRegua2(cChaveXml)
endif

oWs:= WSHFXMLCONSULTACHV():New()
oWs:Init()
oWs:cCCURL   := AllTrim(cURL)
oWs:cCIDENT  := U_GetIdEnt()
oWs:cCCHAVE  := AllTrim(cChaveXml)
oWs:cCMODELO := cModelo

For nModal := 1 To 9

	if lShowMsg
		oRegua:IncRegua1("Modalidade: " + StrZero(nModal,1,0) )
		oRegua:IncRegua2(cChaveXml)
		If lEnd
			MsgStop("*** Cancelado pelo Operador ***","Fim")
			Exit
		EndIf
	endif
	
	oWs:nNMODALIDADE := nModal

	if oWs:HFCONSCHVMODAL()
		cXml := oWs:cHFCONSCHVMODALRESULT
		if cModelo == "57"
			nAt1:= At('<RETCONSSITCTE ',Upper(cXml))
			nAt2:= At('</RETCONSSITCTE>',Upper(cXml))+ 16
			//Corpo do XML
			If nAt1 <=0
				nAt1:= At('<RETCONSSITCTE>',Upper(cXml))
			EndIf
			If nAt1 > 0 .And. nAt2 > 16
				cNfe := Substr(cXml,nAt1,nAt2-nAt1)

				cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
				cXml+= cNfe
				cXml := NoAcento(cXml)
				cXml := EncodeUTF8(cXml)
				cErro:= ""
				cWarning:= ""
				oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
				If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
				elseIf oWSrNfe:_RETCONSSITCTE:_CSTAT:TEXT == "100"
					cMensagem := ""
					cMensagem += "Chave : "+cChaveXml+CRLF
					If !Empty(oWSrNfe:_RETCONSSITCTE:_VERSAO:TEXT)
						cMensagem += "Versão da mensagem : "+oWSrNfe:_RETCONSSITCTE:_VERSAO:TEXT+CRLF
					EndIf
					cMensagem += "Ambiente: "+IIf(oWSrNfe:_RETCONSSITCTE:_TPAMB:TEXT=="1","Produção","Homologação")+CRLF 
					cMensagem += "Cod.Ret."+cPref+": "+oWSrNfe:_RETCONSSITCTE:_CSTAT:TEXT+CRLF
					cMensagem += "Msg.Ret."+cPref+": "+oWSrNfe:_RETCONSSITCTE:_XMOTIVO:TEXT+CRLF 
					If !Empty(oWSrNfe:_RETCONSSITCTE:_PROTCTE:_INFPROT:_NPROT:TEXT)
						cMensagem += "Protocolo: "+oWSrNfe:_RETCONSSITCTE:_PROTCTE:_INFPROT:_NPROT:TEXT+CRLF
						If !Empty(cProtocolo)
							If cProtocolo <> AllTrim(oWSrNfe:_RETCONSSITCTE:_PROTCTE:_INFPROT:_NPROT:TEXT)
								cMensagem += "## Protocolo Difere do XML: "+cProtocolo+CRLF
								cMensagem += "             "
								lProt := .F.
							Else
								lProt := .T.
							EndIf      
						EndIf	
					EndIf                                            
					If !Empty(oWSrNfe:_RETCONSSITCTE:_PROTCTE:_INFPROT:_DIGVAL:TEXT)
						cMensagem += "Dígito"+": "+oWSrNfe:_RETCONSSITCTE:_PROTCTE:_INFPROT:_DIGVAL:TEXT+CRLF  
					EndIf
					cCodRet := oWSrNfe:_RETCONSSITCTE:_CSTAT:TEXT
					lRet := .T.
					Exit
				Endif
   	    	EndIf
		Else
			nAt1:= At('<RETCONSSITNFE ',Upper(cXml))
			nAt2:= At('</RETCONSSITNFE>',Upper(cXml))+ 16
			//Corpo do XML
			If nAt1 <=0
				nAt1:= At('<RETCONSSITNFE>',Upper(cXml))
			EndIf 	
			If nAt1 > 0 .And. nAt2 > 16
				cNfe := Substr(cXml,nAt1,nAt2-nAt1)

				cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
				cXml+= cNfe
				cXml := NoAcento(cXml)
				cXml := EncodeUTF8(cXml)
				cErro:= ""
				cWarning:= ""
				oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
				If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
				elseIf oWSrNfe:_RETCONSSITNFE:_CSTAT:TEXT == "100"
					cMensagem := ""
					cMensagem += "Chave : "+cChaveXml+CRLF
					If !Empty(oWSrNfe:_RETCONSSITNFE:_VERSAO:TEXT)
						cMensagem += "Versão da mensagem : "+oWSrNfe:_RETCONSSITNFE:_VERSAO:TEXT+CRLF
					EndIf
					cMensagem += "Ambiente: "+IIf(oWSrNfe:_RETCONSSITNFE:_TPAMB:TEXT=="1","Produção","Homologação")+CRLF 
					cMensagem += "Cod.Ret."+cPref+": "+oWSrNfe:_RETCONSSITNFE:_CSTAT:TEXT+CRLF
					cMensagem += "Msg.Ret."+cPref+": "+oWSrNfe:_RETCONSSITNFE:_XMOTIVO:TEXT+CRLF 
					If !Empty(oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_NPROT:TEXT)
						cMensagem += "Protocolo: "+oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_NPROT:TEXT+CRLF
						If !Empty(cProtocolo)
							If cProtocolo <> AllTrim(oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_NPROT:TEXT)
								cMensagem += "## Protocolo Difere do XML: "+cProtocolo+CRLF
								cMensagem += "             "
								lProt := .F.
							Else
								lProt := .T.
							EndIf      
						EndIf	
					EndIf                                            
					If !Empty(oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_DIGVAL:TEXT)
						cMensagem += "Dígito"+": "+oWSrNfe:_RETCONSSITNFE:_PROTNFE:_INFPROT:_DIGVAL:TEXT+CRLF  
					EndIf
					cCodRet := oWSrNfe:_RETCONSSITNFE:_CSTAT:TEXT
					lRet := .T.
					Exit
				Endif
   	    	EndIf
		EndIf
	EndIf

Next nModal

if cCodRet == "100"
	xCnpj  := SM0->M0_CGC
	xIdEnt := oWs:cCIDENT
endif

Return( lRet )


Static Function verManifes(xManif,oWSrNfe)  //GETESB2
Local cRet := xManif
Local cUlt := ""
Local cDth := ""
Local nI   := 0
Private oRet := oWSrNfe
Private oEve

if Type( "oWSrNfe:_RETCONSSITNFE:_PROCEVENTONFE" ) <> "U"
	oEve := oWSrNfe:_RETCONSSITNFE:_PROCEVENTONFE
	oEve := iif( ValType(oEve) == "O", {oEve}, oEve )
	For nI := 1 To Len( oEve )
		if Type( "oEve["+Alltrim(str(nI))+"]:_RETEVENTO:_INFEVENTO:_TPEVENTO" ) <> "U" .And. Type( "oEve["+Alltrim(str(nI))+"]:_RETEVENTO:_INFEVENTO:_DHREGEVENTO" ) <> "U"
			if oEve[nI]:_RETEVENTO:_INFEVENTO:_TPEVENTO:TEXT $ "210200,210210,210220,210240"
				if oEve[nI]:_RETEVENTO:_INFEVENTO:_DHREGEVENTO:TEXT > cDth
					cDth := oEve[nI]:_RETEVENTO:_INFEVENTO:_DHREGEVENTO:TEXT
					cUlt := oEve[nI]:_RETEVENTO:_INFEVENTO:_TPEVENTO:TEXT
				endif
			EndIF
		endif
	Next nI
	if cUlt $ "210200,210210,210220,210240"
		if cUlt $ "210200"
			cRet := "1"
		elseif cUlt $ "210210"
			cRet := "4"
		elseif cUlt $ "210220"
			cRet := "2"
		elseif cUlt $ "210240"
			cRet := "3"
		endif
	endif 
EndIf

Return( cRet )



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MAILSEND ³ Autor ³ Roberto Souza           ³ Data ³13/11/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina que envia e-mail utilizando classe tMailManager       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MAILSEND(aTo,cSubject,cMsg,cError,cAnexo,cAnexo2,cEmailDest) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³ ExpA1 = aTo                                                  ³±±
±±³          ³ ExpC2 = Subject                                              ³±±
±±³          ³ ExpC3 = Mensagem a ser enviada                               ³±±
±±³          ³ ExpC4 = Mensagem de erro retornada                    (OPC)  ³±±
±±³          ³ ExpC5 = Arquivo para anexar a mensagem                (OPC)  ³±±
±±³          ³ ExpC6 = Arquivo para anexar a mensagem                (OPC)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MAILSEND(aTo,cSubject,cMensagem,cError,cAnexo,cAnexo2,cEmailDest,cCCdest,cBCCdest)
Local aServer     := U_XCfgMail(1,1,{})
Local cMailServer := AllTrim(aServer[1])
Local cLogin      := AllTrim(aServer[2])
Local cMailConta  := AllTrim(aServer[3])
Local cMailSenha  := AllTrim(aServer[4])
Local lSMTPAuth   := aServer[5] 
Local lSSL        := aServer[6] 
Local cProtocolE  := aServer[7] 
Local cPort       := aServer[8]
Local lTLS        := aServer[9] 
Local lImap       := AllTrim(cProtocolE) == "2" .And. AllTrim(GetProfString ("MAIL", "PROTOCOL", "" )) ==  "IMAP"
Local nX          := 0 
Local oServer
Local oMessage
Local nRet        := 0
Local nNumMsg 	  := 0
Local nTam   	  := 0
Local nI     	  := 0
Local nModel      := Val(GetSrvProfString("HF_MODOMAIL","1"))

Default cSubject  := "Mensagem de Teste"
//Default cMensagem := "Este é um email enviado automaticamente pelo Gerenciador de Contas do Protheus durante o teste das configurações da sua conta SMTP/IMAP."
Default aTo       := {cMailConta}
Default cError    := ""
Default cEmailDest:= ""
Default cCCdest   := ""
Default cBCCdest  := ""  

cMsgCfg := ""
cMsgCfg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
cMsgCfg += '<html xmlns="http://www.w3.org/1999/xhtml">
cMsgCfg += '<head>
cMsgCfg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
cMsgCfg += '<title>Importa XML</title>
cMsgCfg += '  <style type="text/css"> 
cMsgCfg += '	<!-- 
cMsgCfg += '	body {background-color: rgb(37, 64, 97);} 
cMsgCfg += '	.style1 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;} 
cMsgCfg += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} 
cMsgCfg += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} 
cMsgCfg += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} 
cMsgCfg += '	.style5 {font-size: 10pt} 
cMsgCfg += '	--> 
cMsgCfg += '  </style>
cMsgCfg += '</head>
cMsgCfg += '<body>
cMsgCfg += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">
cMsgCfg += '  <tbody>
cMsgCfg += '    <tr>
cMsgCfg += '      <td colspan="2">
cMsgCfg += '    <Center>
cMsgCfg += '      <img src="http://extranet.helpfacil.com.br/images/cabecalho.jpg">
cMsgCfg += '      </Center><hr>
cMsgCfg += '      <p class="style1">Este é um email enviado automaticamente pelo Gerenciador de Contas do Protheus durante o teste das configurações da sua conta  de envio de notificações do Importa XML.</p>
cMsgCfg += '      <hr></td>
cMsgCfg += '    </tr>
cMsgCfg += '  </tbody>
cMsgCfg += '</table>
cMsgCfg += '<p class="style1">&nbsp;</p>
cMsgCfg += '</body>
cMsgCfg += '</html>

Default cMensagem := cMsgCfg

If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha) .And. !Empty(cLogin)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Cria o objeto d e e-mail                                                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oServer := TMailManager():New()  
	
	If !lImap
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Inicia o objeto d e e-mail                                                       |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSSL
			oServer:SetUseSSL(lSSL) 
		EndIf
		If lTLS                      //aquuiiiiii
			oServer:SetUseTLS(lTLS) 
		EndIf
	    nRet := oServer:Init( "" ,;
	    			 AllTrim(cMailServer), ;
	    			 AllTrim(cMailConta), ;
	    			 AllTrim(cMailSenha),;
	    			 Nil ,;
	    			 Iif(!Empty(cPort),Val(cPort),Nil) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Timeout de espera                                                                |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRet := oServer:SetSmtpTimeOut( 30 )
		If nRet <> 0
			Return(nRet)
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Conecta ao servidor de SMTP                                                      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRet := oServer:SmtpConnect()
		If nRet <> 0
			Return(nRet)
		EndIf

		If lSMTPAuth
	   		nRet := oServer:SMTPAuth(cLogin,cMailSenha )
			If nRet <> 0
				Return(nRet)
			EndIf
	    EndIf

    Else 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Inicia o objeto d e e-mail                                                       |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSSL
			oServer:SetUseSSL(lSSL) 
		EndIf
		If lTLS                      //aquuiiiiii
			oServer:SetUseTLS(lTLS) 
		EndIf
	    nRet := oServer:Init( cMailServer ,;
	    			 "", ;
	    			 AllTrim(cMailConta), ;
	    			 AllTrim(cMailSenha),;
	    			 Iif(!Empty(cPort),Val(cPort),) ,;
	    			 Nil )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Conecta ao servidor de IMAP                                                      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRet := oServer:IMAPConnect()
		If nRet != 0
			Return(nRet)
		EndIf	    
    
    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Cria o Objeto da mensagem                                                        |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMessage := TMailMessage():New()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Limpa o Objeto da mensagem                                                       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMessage:Clear()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Atribui o Objeto da mensagem                                                     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMessage:cFrom 		:= cMailConta
	oMessage:cTo 		:= cEmailDest
	oMessage:cCc 		:= cCCdest
	oMessage:cBcc 		:= cBCCdest
	oMessage:cSubject 	:= cSubject
	oMessage:cBody 		:= cMensagem

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Processa os anexos                                                               |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cAnexo)
		nRet := oMessage:AttachFile(cAnexo)
		If nRet <> 0
			Return(nRet)
		Else
			oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cAnexo)
		EndIf
	EndIf
	If !Empty(cAnexo2)
		nRet := oMessage:AttachFile(cAnexo2)
		If nRet <> 0
			Return(nRet)
		Else
			oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cAnexo2)				
		EndIf
	EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Envia o E-mail                                                                   |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRet := oMessage:Send( oServer )
//	ALert(oServer:GetErrorString(nRet))
	If nRet <> 0
		Return(nRet)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Envia o E-mail                                                                   |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lImap
		nRet := oServer:SmtpDisconnect()
	Else     
		nRet := oServer:IMAPDisconnect()					    
    EndIf
	
	If nRet != 0
		Return(nRet)
	EndIf

EndIf	

Return(nRet) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerTSS    ºAutor  ³Roberto Souza       º Data ³  14/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a versão do TSS da empresa corrente.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VerTSS(cUrl,cVerTSS,lHelp)
Local oWs
Local lRetorno   := .F.     
Default cVerTss  := "0.00" 
Default cURL     := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

oWs := WsSpedCfgNFe():New()
oWs:cUserToken := "TOTVS"
oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
If oWs:CFGTSSVERSAO()
	lRetorno := .T. 
	cVerTSS := oWs:CCFGTSSVERSAORESULT
Else
	If lHelp
		U_MyAviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
	EndIf
EndIf
                    
Return(lRetorno) 


  




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA140  ³ Autor ³ Edson Maricate        ³ Data ³ 24.01.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Digitacao das Notas Fiscais de Entrada sem os dados Fiscais  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa     MATA140.PRW  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³ Marcos V. Ferreira       ³ 11/04/2006 - Bops: 00000096840    ³±±
±±³      02  ³ Marcos V. Ferreira       ³ 19/12/2005					    ³±±
±±³      03  ³ Marcos V. Ferreira       ³ 11/04/2006 - Bops: 00000096840    ³±±
±±³      04  ³ Flavio Luiz Vicco        ³ 04/01/2006                        ³±±
±±³      05  ³ Nereu Humberto Junior    ³ 16/03/2006                        ³±±
±±³      06  ³ Nereu Humberto Junior    ³ 16/03/2006                        ³±±
±±³      07  ³ Flavio Luiz Vicco        ³ 04/01/2006                        ³±±
±±³      08  ³ Ricardo Berti            ³ 07/02/2006                        ³±±
±±³      09  ³ Ricardo Berti            ³ 07/02/2006                        ³±±
±±³      10  ³ Marcos V. Ferreira       ³ 19/12/2005					    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/	

User Function XMATA140(xAutoCab,xAutoItens,nOpcAuto,lSimulaca,nTelaAuto)

Local aRotADic  := {}
Local aCores    := {	{ 'Empty(F1_STATUS)','ENABLE' 		},;// NF Nao Classificada
						{ 'F1_STATUS=="B"'	,'BR_LARANJA'	},;// NF Bloqueada
						{ 'F1_TIPO=="N"'	,'DISABLE'		},;// NF Normal
						{ 'F1_TIPO=="P"'	,'BR_AZUL'		},;// NF de Compl. IPI
						{ 'F1_TIPO=="I"'	,'BR_MARROM'	},;// NF de Compl. ICMS
						{ 'F1_TIPO=="C"'	,'BR_PINK'		},;// NF de Compl. Preco/Frete
						{ 'F1_TIPO=="B"'	,'BR_CINZA'		},;// NF de Beneficiamento
						{ 'F1_TIPO=="D"'	,'BR_AMARELO'	} }// NF de Devolucao
						
Local cFiltraSf1    := ""
Local nX,nAutoPC	:= 0

PRIVATE aRotina 	:= MenuDef()
PRIVATE cCadastro	:= OemToAnsi("Pre-Documento de Entrada") //"Pre-Documento de Entrada"
PRIVATE l140Auto	:= ( ValType(xAutoCab) == "A"  .And. ValType(xAutoItens) == "A" )
PRIVATE aAutoCab	:= xAutoCab
PRIVATE aAutoItens	:= xAutoItens
PRIVATE aHeadSD1    := {}
PRIVATE l103Auto	:= .F.//l140Auto
PRIVATE lOnUpdate	:= .T.
PRIVATE nMostraTela := 1 // 0 - Nao mostra tela 1 - Mostra tela e valida tudo 2 - Mostra tela e valida so cabecalho
PRIVATE a140Total := {0,0,0}
PRIVATE a140Desp  := {0,0,0,0,0,0,0,0}

DEFAULT nOpcAuto	:= 3
DEFAULT lSimulaca	:= .F.
DEFAULT nTelaAuto   := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajusta Help para criar novo help da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaHelp()

If l140Auto   
	For nX:= 1 To Len(xAutoItens)
		If (nAutoPC := Ascan(xAutoItens[nx],{|x| x[1]== "D1_PEDIDO"})) > 0
		     If Empty(xAutoItens[nX][nAutoPC][3])
		     	xAutoItens[nX][nAutoPC][3]:= "vazio().or. A103PC()"
			 EndIf
		EndIf
	Next
EndIf    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se estiver usando conferencia fisica muda opcoes do mbrowse³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (SuperGetMV("MV_CONFFIS",.F.,"N") == "S")
	aCores    := {	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. Empty(F1_STATUS)'	, 'ENABLE' 		},;	// NF Nao Classificada
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="N"'	 	, 'DISABLE'		},;	// NF Normal
					{ 'F1_STATUS=="B"'													, 'BR_LARANJA'	},;	// NF Bloqueada
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="P"'	 	, 'BR_AZUL'		},;	// NF de Compl. IPI
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="I"'	 	, 'BR_MARROM'	},;	// NF de Compl. ICMS
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="C"'	 	, 'BR_PINK'		},;	// NF de Compl. Preco/Frete
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="B"'	 	, 'BR_CINZA'	},;	// NF de Beneficiamento
					{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="D"'    	, 'BR_AMARELO'	},;	// NF de Devolucao
					{ 'F1_STATCON<>"1" .AND. !EMPTY(F1_STATCON) .AND. Empty(F1_STATUS)'	, 'BR_PRETO'	}} 	// NF Bloq. para Conferencia
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Adiciona rotinas ao aRotina                                  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MT140ROT" )
	aRotAdic := ExecBlock( "MT140ROT",.F.,.F.)
	If ValType( aRotAdic ) == "A"
		AEval( aRotAdic, { |x| aadd( aRotina, x ) } )
	EndIf
EndIf      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Adiciona rotinas ao aRotina                                  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MT140FIL" )
    cFiltraSF1 := ExecBlock("MT140FIL",.F.,.F.)
	If ( ValType(cFiltraSF1) <> "C" )
		cFiltraSF1 := ""
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a permissao do programa em relacao aos modulos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AMIIn(2,4,11,12,14,17,39,41,42,97,17,44,67,69,72) 
	Pergunte("MTA140",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativa tecla F12 para ativar parametros de lancamentos contab.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l140Auto
		lOnUpdate  := !lSimulaca
		nMostraTela:= nTelaAuto
		aAutoCab   := xAutoCab
		aAutoItens := xAutoItens

		If nOpcAuto == 7
			aRotBack 	  := aClone(aRotina)
			aRotina[5][2] := aRotBack[7][2]
			nOpcAuto	  := 5
		EndIf
//		MBrowseAuto( nOpcAuto, AClone( aAutoCab ), "SF1" )

        xRet := U_A140NFis("SF1",Recno(),nOpcAuto)                  

		If nOpcAuto == 5 .And. aRotina[5][2] == "A140EstCla" 
			aRotina:= aClone(aRotBack)
		EndIf

		xAutoCab   := aAutoCab
		xAutoItens := aAutoItens
	Else
		SetKey(VK_F12,{||Pergunte("MTA140",.T.)})
		
		#IFDEF TOP
    	    mBrowse(6,1,22,75,"SF1",,,,,,aCores,,,,,,,,cFiltraSF1) 
    	#Else
  			mBrowse(6,1,22,75,"SF1",,,,,,aCores)
	   	#ENDIF
	   	
		SetKey(VK_F12,Nil)
	EndIf
EndIf
Return(xRet)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A140NFisca³ Autor ³ Eduardo Riera         ³ Data ³02.10.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Interface do pre-documento de entrada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL1: Alias do arquivo                                      ³±±
±±³          ³ExpN2: Numero do Registro                                    ³±±
±±³          ³ExpN3: Opcao selecionada no arotina                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo controlar a interface de um    ³±±
±±³          ³pre-documento de entrada                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A140NFis(cAlias,nReg,nOpcX)
Local nAcho     := 0
Local aRecSD1   := {}
Local aObjects  := {}
Local aInfo 	:= {}
Local aPosGet	:= {}
Local aPosObj	:= {}
Local aStruSD1  := {}
Local aListBox  := {}
Local aCamposPE := {}
Local aNoFields := {}
Local aRecOrdSD1:= {}
Local aTitles   := {"Totais", OemToAnsi("Fornecedor/Cliente"), "Descontos/Frete/Despesas"} //"Fornecedor/Cliente" ### "Descontos/Frete/Despesas" //"Totais"
Local aFldCBAtu := Array(Len(aTitles))
Local aInfForn	:= {"","",CTOD("  /  /  "),CTOD("  /  /  "),"","","",""}
Local aSizeAut  := {}
Local aButtons	:= {}
Local aListCpo 	:= {	"D1_COD"	,;
						"D1_UM"		,;
						"D1_QUANT"	,;
						"D1_VUNIT"	,;
						"D1_TOTAL"	,;
						"D1_LOCAL"	,;
						"D1_PEDIDO"	,;
						"D1_ITEMPC"	,;
						"D1_SEGUM"	,;
						"D1_QTSEGUM",;
						"D1_CC"		,;
						"D1_CONTA"	,;
						"D1_ITEMCTA",;
						"D1_CLVL"	,;
						"D1_ITEM"	,;
						"D1_LOTECTL",;
						"D1_NUMLOTE",;
						"D1_DTVALID",;
						"D1_LOTEFOR",;
						"D1_DESC"	,;
						"D1_VALDESC",;
						"D1_OP"		,;
						"D1_CODGRP"	,;
						"D1_CODITE"	,;
						"D1_VALIPI"	,;
						"D1_VALICM"	,;
						"D1_CF"		,;
						"D1_IPI"	,;
						"D1_PICM"	,;
						"D1_PESO"	,;
						"D1_TP"		,;
						"D1_BASEICM",;
						"D1_BASEIPI",;
						"D1_TEC"	,;
						"D1_CONHEC"	,;
						"D1_TIPO_NF",;
						"D1_NFORI"	,;
						"D1_SERIORI",;
						"D1_ITEMORI",;
						"D1_VALIMP1",;
						"D1_VALIMP2",;
						"D1_VALIMP3",;
						"D1_VALIMP4",;
						"D1_VALIMP5",;
						"D1_VALIMP6",;
						"D1_BASIMP1",;
						"D1_BASIMP2",;
						"D1_BASIMP3",;
						"D1_BASIMP4",;
						"D1_BASIMP5",;
						"D1_BASIMP6",;
						"D1_ALQIMP1",;
						"D1_ALQIMP2",;
						"D1_ALQIMP3",;
						"D1_ALQIMP4",;
						"D1_ALQIMP5",;
						"D1_ALQIMP6",;
						"D1_VALFRE"	,;
						"D1_SEGURO"	,;
						"D1_DESPESA",;
						"D1_FORMUL"	,;
						"D1_CLASFIS",;
						"D1_II"		,;
						"D1_ICMSDIF",;
						"D1_FCICOD" ,;
						"D1_ITEMMED" } 
					
Local l140Inclui := .F.
Local l140Altera := .F.
Local l140Exclui := .F.
Local l140Visual := .F.
Local lContinua  := .T.
Local lQuery     := .F.
Local lItSD1Ord  := IIF(mv_par03==2,.T.,.F.)
Local lConsMedic := .F.
Local lExistMemo := .F. 
Local lIntACD	 := SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local lShowTela  := .T.
Local cAliasSD1  := "SD1"
Local nX         := 0
Local nY         := 0
Local nPosPC	 := 0
Local nPosGetLoja:= IIF(TamSX3("A2_COD")[1]< 10,(2.5*TamSX3("A2_COD")[1])+(110),(2.8*TamSX3("A2_COD")[1])+(100))
Local nOpcA		 := 0
Local nQtdConf   := 0
Local bWhileSD1  := {||.T.}
Local bCabOk     := {||.T.}
Local oDlg
Local oFolder
Local oEnable    := LoadBitmap( GetResources(), "ENABLE" )
Local oDisable   := LoadBitmap( GetResources(), "DISABLE" )
Local oStatCon
Local oConf
Local oTimer
Local aPosDel    := {}
Local dDataFec   := If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES"))
Local nPosCC     := 0      //HF
Local nPosPRD	 := 0      //HF

Private bSavKeyF5	:= SetKey(VK_F5,Nil)
Private bSavKeyF6	:= SetKey(VK_F6,Nil)
Private bSavKeyF7	:= SetKey(VK_F7,Nil)
Private bSavKeyF10	:= SetKey(VK_F10,Nil)

Private oGetDados
Private bGDRefresh	:= {|| IIf(oGetDados<>Nil,(oGetDados:oBrowse:Refresh()),.F.) }		// Efetua o Refresh da GetDados
Private	bRefresh    := {|nX,nY,nTotal,nValDesc| Ma140Total(a140Total,a140Desp,nTotal,nValDesc),NfeFldChg(,,oFolder,aFldCBAtu),IIf(oGetDados<>Nil,(oGetDados:oBrowse:Refresh()),.F.)}
Private l103Visual  := .T. //-- Nao permite alterar os campos de despesas/frete.
Private lNfMedic    := .F. 

DEFAULT aPedC	:= {}    

l140Auto := !(Type("l140Auto")=="U" .Or. !l140Auto)

// Zera os totais para que a chamada de inclusao apos uma gravacao nao traga os valores preenchidos 
a140Total := {0,0,0}
a140Desp  := {0,0,0,0,0,0,0,0}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os campos referentes ao WMS na Pre-Nota               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IntDL()
	aAdd(aListCpo, 'D1_SERVIC')
	aAdd(aListCpo, 'D1_STSERV')
	aAdd(aListCpo, 'D1_TPESTR')
	aAdd(aListCpo, 'D1_DESEST')
	aAdd(aListCpo, 'D1_REGWMS')
	aAdd(aListCpo, 'D1_ENDER' )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os campos referentes ao EIC na Pre-Nota               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l140Auto .And. SuperGetMV("MV_EASY",,"N") == "S"
	aAdd(aListCpo, 'D1_DATORI' )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada do ponto de entrada MT140CPO                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistTemplate("MT140CPO")
	aCamposPE := If(ValType(aCamposPE:=ExecTemplate('MT140CPO',.F.,.F.))=='A',aCamposPE,{})
	If Len(aCamposPE) > 0
		For nX := 1 to Len(aCamposPE)
			If (aScan(aListCpo, aCamposPE[nX])) == 0
				aadd(aListCpo, aCamposPE[nX])
			EndIf
		Next nX
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada do ponto de entrada MT140CPO                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MT140CPO")
	aCamposPE := If(ValType(aCamposPE:=ExecBlock('MT140CPO',.F.,.F.))=='A',aCamposPE,{})
	If Len(aCamposPE) > 0
		For nX := 1 to Len(aCamposPE)
			If (aScan(aListCpo, aCamposPE[nX])) == 0
				aadd(aListCpo, aCamposPE[nX])
			EndIf
		Next nX
	EndIf
EndIf                                                           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada do ponto de entrada MT140DCP 					   ³                                                |
//| Para não exibir os campos customizados no Acols, é necessário incluir o mesmo no aListBox e posteriormente  |
//| carregar o mesmo no array aNolFields para ser descconsiderado na FillGetDados 								|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aNoFields:= {}
If ExistBlock("MT140DCP")
	aNoFields := If(ValType(aNoFields:=ExecBlock('MT140DCP',.F.,.F.))=='A',aNoFields,{})
	If Len(aNoFields) > 0
		For nX := 1 to Len(aNoFields)
			If (aScan(aListCpo, aNoFields[nX])) == 0
				aadd(aListCpo, aNoFields[nX])
			EndIf
		Next nX
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a operacao a ser realizada                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case aRotina[nOpcX][4] == 2
		l140Visual := .T.
	Case aRotina[nOpcX][4] == 3
		l140Inclui	:= .T.
	Case aRotina[nOpcX][4] == 4
		l140Altera	:= .T.
	Case aRotina[nOpcX][4] == 5
		l140Exclui	:= .T.
		l140Visual	:= .T.
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa data de fechamento somente quando o parametro MV_DATAHOM  |
//| estiver configurado com o conteudo igual a "2"                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l140Inclui .And. SuperGetMv("MV_DATAHOM",.F.,"1")=="2"
	If dDataFec >= dDataBase
		Help( " ", 1, "FECHTO" )
		lContinua := .F.
    EndIf
EndIf

// Evita reacumulo do saldo em aPedc (ao cancelar alt./realterar/F6) BOPS 90013 07/02/06
If !l140Visual
	aPedC	:= {}	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa as variaveis da Modelo 2                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private bPMSDlgNF	:= {||PmsDlgNF(nOpcX,cNFiscal,cSerie,cA100For,cLoja,cTipo)} // Chamada da Dialog de Gerenc. Projetos
Private aRatAFN     := {}
Private	cTipo		:= If(l140Inclui,CriaVar("F1_TIPO")		,SF1->F1_TIPO)
Private cFormul		:= If(l140Inclui,CriaVar("F1_FORMUL")	,SF1->F1_FORMUL)
Private cNFiscal 	:= If(l140Inclui,CriaVar("F1_DOC")		,SF1->F1_DOC)
Private cSerie		:= If(l140Inclui,CriaVar("F1_SERIE")	,SF1->F1_SERIE)
Private dDEmissao	:= If(l140Inclui,CriaVar("F1_EMISSAO")	,SF1->F1_EMISSAO)
Private cA100For	:= If(l140Inclui,CriaVar("F1_FORNECE")	,SF1->F1_FORNECE)
Private cLoja		:= If(l140Inclui,CriaVar("F1_LOJA")		,SF1->F1_LOJA)
Private cEspecie	:= If(l140Inclui,CriaVar("F1_ESPECIE")	,SF1->F1_ESPECIE)
Private cUfOrigP	:= If(l140Inclui,CriaVar("F1_EST")		,SF1->F1_EST)
Private nPedagioCt  := If(l140Inclui,CriaVar("F1_VALPEDG")	,SF1->F1_VALPEDG)
Private cModFreCt   := If(l140Inclui,CriaVar("F1_TPFRETE")	,SF1->F1_TPFRETE)
Private n           := 1
Private aCols		:= {}
Private aHeader 	:= {}
Private lReajuste   := IIF(mv_par01==1,.T.,.F.)
Private lConsLoja   := IIF(mv_par02==1,.T.,.F.)
Private cForAntNFE  := ""
Private lMudouNum   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Habilita as HotKeys e botoes da barra de ferramentas         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (!l140Auto .Or. (nMostraTela <> 0)) .And. (l140Inclui .Or. l140Altera)
    If !l140Altera
		aButtons	:= {{'PEDIDO',{||U_XMLPCF5(.F.,a140Desp, lNfMedic, lConsMedic),Eval(bRefresh)},"Pedidos de Compras","Pedido"},; //"Pedidos de Compras"
						{'SDUPROP',{||U_XMLPCF6(.F.,aPedC,oGetDados, lNfMedic, lConsMedic,,,a140Desp ),Eval(bRefresh)},"Pedidos de Compras(por item)","Item.Ped"} } //"PEDIDO"###"Pedidos de Compras(por item)"
		If lDetCte //HfFGVTN
			aAdd(aButtons, {'RECALC',{||U_XMLNFOF7()},OemToAnsi("Selecionar Documento Original - <F7> "),"Selecionar Documento Original ( CTE )"} )
		endif

		SetKey( VK_F5, { || U_XMLPCF5(.F.,a140Desp, lNfMedic, lConsMedic ),Eval(bRefresh) } )
		SetKey( VK_F6, { || U_XMLPCF6(.F.,aPedC,oGetDados, lNfMedic, lConsMedic,,,a140Desp ),Eval(bRefresh) } )
		If lDetCte //HfFGVTN
			SetKey( VK_F7, { || U_XMLNFOF7(),Eval(bRefresh) } )
		endif

    Else
    	aButtons	:= {{'SDUPROP',{||U_XMLPCF6(.F.,aPedC,oGetDados, lNfMedic, lConsMedic,,,a140Desp ),Eval(bRefresh)},"Pedidos de Compras(por item)","Item.Ped"}} //"PEDIDO"###"Pedidos de Compras(por item)"
		SetKey( VK_F6, { || U_XMLPCF6(.F.,aPedC,oGetDados, lNfMedic, lConsMedic,,,a140Desp ),Eval(bRefresh) } )
		If lDetCte //HfFGVTN
			aAdd(aButtons, {'RECALC',{||U_XMLNFOF7()},OemToAnsi("Selecionar Documento Original - <F7> "),"Selecionar Documento Original ( CTE )"} )
			SetKey( VK_F7, { || U_XMLNFOF7(),Eval(bRefresh) } )
		endif
    EndIf
EndIf

If (!l140Auto .Or. (nMostraTela <> 0)) .And. IntePms()
	aadd(aButtons, {'PROJETPMS',bPmsDlgNF,"Gerenciamento de Projetos","Projetos"}) //"Gerenciamento de Projetos"
	SetKey( VK_F10, { || Eval(bPmsDlgNF)} )
EndIf

lConsMedic := A103GCDisp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Habilita o folder de conferencia fisica se necessario        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l140Visual .And. (SuperGetMv("MV_CONFFIS",.F.,"N") == "S")
	aadd(aTitles,"Conferencia Fisica") //"Conferencia Fisica"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a NF possui NF de Conhec. e Desp. de Import.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l140Exclui
	SF8->(dbSetOrder(2))
	If SF8->(MsSeek(xFilial("SF8")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		Help(" ", 1, "A103CAGREG")
		lContinua := .F.
	EndIf	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validar a alteracao de um pre-documento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l140Altera .And. ExistBlock("A140ALT")
	lContinua := If(ValType(lContinua:=ExecBlock("A140ALT",.F.,.F.))=='L',lContinua,.T.)
EndIf	

If !l140Inclui
	//-- Atualiza dados do folder de despesas
	a140Desp[VALDESP]:= SF1->F1_DESPESA
	a140Desp[FRETE]  := SF1->F1_FRETE
	a140Desp[SEGURO] := SF1->F1_SEGURO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aCols                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !l140Visual
		If !SoftLock("SF1")
			lContinua := .F.
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alteracao - Verifica Status da conferencia                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContinua .And. !l140Visual
		If (SuperGetMV("MV_CONFFIS",.F.,"N") == "S") .And. SF1->F1_STATCON == "1"
			If Aviso(OemToAnsi("Atencao"),OemToAnsi("Documento já conferido. Deseja estornar a conferência?"),{"Sim","Nao"})==1 //Atencao##"Documento já conferido. Deseja estornar a conferência?"
				A140AtuCon(,,,,,,,,.T.)
			EndIf
		EndIf
	EndIf
	If lContinua
		dbSelectArea("SD1")
		dbSetOrder(1)
		#IFDEF TOP

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica a existencia de campo MEMO no SD1 para nao executar a Query.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SX3->(dbSetOrder(1))
			SX3->(MsSeek("SD1"))
			While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SD1"
				If (IIf((!l140Auto .Or. (nMostraTela <> 0)),X3USO(SX3->X3_USADO),.T.) .And.;
				 Ascan(aListCpo,Trim(SX3->X3_CAMPO)) != 0 .And. cNivel >= SX3->X3_NIVEL) .Or.;
				(SX3->X3_PROPRI == "U" .And. cNivel >= SX3->X3_NIVEL)
					If SX3->X3_TIPO == "M"
                        lExistMemo := .T. 
						Exit
					EndIf
				EndIf
				SX3->(dbSkip())
			EndDo

			If !InTransact() .And. !lExistMemo
				aStruSD1 := SD1->(dbStruct())
				lQuery   := .T.

				cQuery := "SELECT SD1.R_E_C_N_O_ SD1RECNO,SD1.* "
				cQuery += "FROM "+RetSqlName("SD1")+" SD1 "
				cQuery += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' AND "
				cQuery += "SD1.D1_DOC = '"+SF1->F1_DOC+"' AND "
				cQuery += "SD1.D1_SERIE = '"+SF1->F1_SERIE+"' AND "
				cQuery += "SD1.D1_FORNECE = '"+SF1->F1_FORNECE+"' AND "
				cQuery += "SD1.D1_LOJA = '"+SF1->F1_LOJA+"' AND "
				cQuery += "SD1.D_E_L_E_T_=' ' "

				If lItSD1Ord .Or. ALTERA
					cQuery += "ORDER BY "+SqlOrder( "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD" )
				Else
					cQuery += "ORDER BY "+SqlOrder(SD1->(IndexKey()))
				EndIf

				cQuery := ChangeQuery(cQuery)

				SD1->(dbCloseArea())

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SD1")
				For nX := 1 To Len(aStruSD1)
					If aStruSD1[nX][2]<>"C"
						TcSetField("SD1",aStruSD1[nX][1],aStruSD1[nX][2],aStruSD1[nX][3],aStruSD1[nX][4])
					EndIf
				Next nX
			Else
		#ENDIF
			MsSeek(xFilial("SD1")+cNFiscal+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		#IFDEF TOP
			EndIf
		#ENDIF

		bWhileSD1 := { || ( !Eof().And. lContinua .And. ;
				(cAliasSD1)->D1_FILIAL== xFilial("SD1") .And. ;
				(cAliasSD1)->D1_DOC == cNFiscal .And. ;
				(cAliasSD1)->D1_SERIE == SF1->F1_SERIE .And. ;
				(cAliasSD1)->D1_FORNECE == SF1->F1_FORNECE .And. ;
				(cAliasSD1)->D1_LOJA == SF1->F1_LOJA ) }

	EndIf
Else //HF alimentar esta matriz para valer os valores.
	//-- Atualiza dados do folder de despesas
	If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_DESPESA" } ) ) > 0
		a140Desp[VALDESP] := aAutoCab[nPos][2]
	Endif
	If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_FRETE" } ) ) > 0
		a140Desp[FRETE] := aAutoCab[nPos][2]
	Endif
	If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_SEGURO" } ) ) > 0
		a140Desp[SEGURO] := aAutoCab[nPos][2]
	Endif
EndIf 

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sintaxe da FillGetDados(nOpcx,cAlias,nOrder,cSeekKey,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry,bCriaVar,lUserFields) |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FillGetDados(nOpcX,"SD1",1,/*cSeek*/,/*{|| &cWhile }*/,{||.T.},aNoFields,aListCpo,/*lOnlyYes*/,/*cQuery*/,{|| MaCols140 (cAliasSD1,bWhileSD1,aRecOrdSD1,@aRecSD1,@aPedC,lItSD1Ord,lQuery,l140Inclui,l140Visual,@lContinua,l140Exclui) },l140Inclui,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bbeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/,/*bCriaVar*/,.T.,IIF(!l140Auto .Or. nMostraTela <> 0,{},aListCpo))
	
	If lQuery
		dbSelectArea("SD1")
		dbCloseArea()
		ChkFile("SD1")
	EndIf

	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo do total do pre-documento de entrada                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Ma140Total(a140Total,a140Desp)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Rotina automatica                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l140Auto
			nOpcA := 1
			If !l140Exclui
				aValidGet := {}
				If l140Inclui
					PRIVATE aBlock := {	{|| NfeTipo(cTipo,@cA100For,@cLoja)},;
						{|| NfeFormul(cFormul,@cNFiscal,@cSerie)},;
						{|| NfeFornece(cTipo,@cA100For,@cLoja).And.CheckSX3("F1_DOC")},;
						{|| NfeFornece(cTipo,@cA100For,@cLoja).And.CheckSX3("F1_SERIE")},;
						{|| CheckSX3("F1_EMISSAO") .And. NfeEmissao(dDEmissao)},;
						{|| NfeFornece(cTipo,@cA100For,@cLoja).And.CheckSX3('F1_FORNECE',cA100For)},;
						{|| NfeFornece(cTipo,@cA100For,@cLoja).And.CheckSX3('F1_LOJA',cLoja)},;
						{|| CheckSX3("F1_ESPECIE",cEspecie)},;
						{|| CheckSX3("F1_EST",cUfOrigP) .And. CheckSX3("F1_EST",cUfOrigP)}}
					If (nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_TIPO"}))<>0
						aadd(aValidGet,{"cTipo",aAutoCab[(nX),2],"Eval(aBlock[1])",.T.})
					Else
						cTipo := "N"
					EndIf
					If (nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_FORMUL"}))<>0
						aadd(aValidGet,{"cFormul",aAutoCab[(nX),2],"Eval(aBlock[2])",.T.})
					Else
						cFormul := "N"
					EndIf
					nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_DOC"})
					aadd(aValidGet,{"cNFiscal" ,aAutoCab[(nX),2],"Eval(aBlock[3])",.T.})
					nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_SERIE"})
					aadd(aValidGet,{"cSerie",aAutoCab[(nX),2],"Eval(aBlock[4])",.T.})
					nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_EMISSAO"})
					aadd(aValidGet,{"dDEmissao",aAutoCab[(nX),2],"Eval(aBlock[5])",.T.})
					nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_FORNECE"})
					aadd(aValidGet,{"cA100For",aAutoCab[(nX),2],"Eval(aBlock[6])",.T.})
					nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_LOJA"})
					aadd(aValidGet,{"cLoja",aAutoCab[(nX),2],"Eval(aBlock[7])",.T.})
					If (nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_ESPECIE"}))<>0
						aadd(aValidGet,{"cEspecie",aAutoCab[(nX),2],"Eval(aBlock[8])",.T.})
					Else
						cEspecie := ""
					EndIf
					If (nX := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_EST"}))<>0
						aadd(aValidGet,{"cUfOrigP",aAutoCab[(nX),2],"Eval(aBlock[9])",.T.})
					Else
						cUfOrigP := ""
					EndIf
					If ! SF1->(MsVldGAuto(aValidGet))
						nOpcA := 0
					EndIf
				EndIf
				If GetMV("MV_INTPMS",,"N") == "S" .And. GetMV("MV_PMSIPC",,2) == 1 //Se utiliza amarracao automatica dos itens da NFE com o Projeto
					l103Auto	:= .T.    //HF -> para solucionar o problema do acols.
					For nX := 1 To Len(aAutoItens)
						If nX == 1
							aAdd(aAutoItens[nX],{"D1_ITEM","000"+AllTrim(Str(nX)),NIL})
						Else
							aAdd(aAutoItens[nX],{"D1_ITEM",Soma1(aAutoItens[nX-1][Len(aAutoItens[nX-1])][2]),Nil})
						EndIf
						PMS140IPC(Val(aAutoItens[nX][aScan(aAutoItens[nX],{|x| AllTrim(x[1])=="D1_ITEM"})][2]))					
					Next nX
					l103Auto	:= .F.    //HF -> volta como estava
				EndIf
				If nOpcA <> 0 
					If !NfeCabOk(l140Visual,Nil,Nil,Nil,Nil,Nil,.F.)
						nOpcA := 0
					Else
						If nMostraTela <> 2
					  		//If !SD1->(U_XMsGet(aAutoItens,"U_Ma140LOk(.T.,2)",{|| U_MA140Tok()},aAutoCab,aRotina[nOpcX][4]))
					  	   If !SD1->(MsGetDAuto(aAutoItens,"U_Ma140LOk(.T.,2)",{|| U_MA140Tok()},aAutoCab,aRotina[nOpcX][4]))
					  			nOpcA := 0
					  		EndIf
		        		EndIf
					EndIf
				EndIf
				If nMostraTela <> 0 .And. nOpca <> 0
					l140Auto := .F.
					nOpca    := 0
					HelpInDark(.F.)
				Endif
				If lMsErroAuto   //AQUIIIIII ERRROOO
					MOSTRAERRO()
					lShowTela := .F.
				EndIf
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Interface com o Usuario                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !l140Auto .or. lShowTela 
			if nAmarris == 2
				U_AMAPC(a140Desp,lNfMedic,lConsMedic) //,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV
				if cPCSol == "N" .And. Empty(_cCCusto)   //HF Pega Pelo Produto e não do Pedido de Compra
					nPosCC   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CC"})         //HF
					nPosPRD	 := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })     //HF
					SB1->( dbSetOrder(1) )
					if nPosCC > 0 .and. nPosPRD
	   					For nIa := 1 To len( aCols )
	   						if SB1->( dbSeek( xFilial("SB1") + aCols[nIa][nPosPRD] ) )  //posiciona o bixo
								aCols[nIa][nPosCC] := SB1->B1_CC
							endif
						Next nIa
					endif
				endif
				nAmarris++
			endif
			
			aSizeAut := MsAdvSize(,.F.,400)
			aObjects := {}
			aadd( aObjects, { 0,    41, .T., .F. } )
			aadd( aObjects, { 100, 100, .T., .T. } )
			aadd( aObjects, { 0,    75, .T., .F. } )
			aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
			aPosObj := MsObjSize( aInfo, aObjects )
			aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
				{{8,35,75,100,194,220,260,280},;
				If( l140Visual .Or. !lConsMedic,{8,35,75,100,nPosGetLoja,194,220,260,280},{8,35,75,108,145,160,190,220,244,265} ),;
				{5,70,160,205,295},;
				{6,34,200,215},;
				{6,34,75,103,148,164,230,253},;
				{6,34,200,218,280},;
				{11,50,150,190},;
				{273,130,190,293,205}})

			DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro Of oMainWnd PIXEL

			NfeCabDoc(oDlg,{aPosGet[1],aPosGet[2],aPosObj[1]},@bCabOk,l140Visual .Or. l140Altera,.F.,@cUfOrigP,,iif(cModelo == "57",.F.,.T.),nil,nil,nil,nil,@lNfMedic)

			oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcX,"U_Ma140LOk(.F.,1)","U_MA140Tok","+D1_ITEM",!l140Visual,,,,999,,,,"Ma140DelIt")
			oGetDados:oBrowse:bGotFocus	:= bCabOk

			oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,{"HEADER"},oDlg,,,, .T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder dos Totalizadores                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFolder:aDialogs[1]:oFont := oDlg:oFont
			NfeFldTot(oFolder:aDialogs[1],a140Total,aPosGet[3],@aFldCBAtu[1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder dos Fornecedores                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFolder:aDialogs[2]:oFont := oDlg:oFont
			oFolder:bSetOption := {|nDst| NfeFldChg(nDst,oFolder:nOption,oFolder,aFldCBAtu)}
			NfeFldFor(oFolder:aDialogs[2],aInfForn,{aPosGet[4],aPosGet[5],aPosGet[6]},@aFldCBAtu[2])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder das Despesas acessorias e descontos                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFolder:aDialogs[3]:oFont := oDlg:oFont
			NfeFldDsp(oFolder:aDialogs[3],a140Desp,{aPosGet[7],aPosGet[8]},@aFldCBAtu[3])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder de conferencia para os coletores                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l140Visual .And. (SuperGetMV("MV_CONFFIS",.F.,"N") == "S")
				oFolder:aDialogs[4]:oFont := oDlg:oFont
				Do Case
				Case SF1->F1_STATCON $ "1 "
					cStatCon := "NF conferida"
				Case SF1->F1_STATCON == "0"
					cStatCon := "NF nao conferida"
				Case SF1->F1_STATCON == "2"
					cStatCon := "NF com divergencia"
				Case SF1->F1_STATCON == "3"
					cStatCon := "NF em conferencia"
				EndCase
				nQtdConf := SF1->F1_QTDCONF
				@ 06 ,aPosGet[6,1] SAY "Status"      OF oFolder:aDialogs[4] PIXEL SIZE 49,09 //"Status"
				@ 05 ,aPosGet[6,2] MSGET oStatCon VAR Upper(cStatCon) COLOR CLR_RED OF oFolder:aDialogs[4] PIXEL SIZE 70,9 When .F.
				@ 25 ,aPosGet[6,1] SAY "Conferentes" OF oFolder:aDialogs[4] PIXEL SIZE 49,09 //"Conferentes"
				@ 24 ,aPosGet[6,2] MSGET oConf Var nQtdConf OF oFolder:aDialogs[4] PIXEL SIZE 70,09 When .F.
				@ 05 ,aPosGet[5,3] LISTBOX oList Fields HEADER "  ","Codigo","Quantidade Conferida" SIZE 170, 48 OF oFolder:aDialogs[4] PIXEL //"Codigo"###"Quantidade Conferida"
				oList:BLDblclick := {||A140DetCon(oList,aListBox)}

				DEFINE TIMER oTimer INTERVAL 3000 ACTION (A140AtuCon(oList,aListBox,oEnable,oDisable,oConf,@nQtdConf,oStatCon,@cStatCon,,oTimer)) OF oDlg
				oTimer:Activate()

				@ 30 ,aPosGet[5,3]+180 BUTTON "Recontagem" SIZE 40 ,11  FONT oDlg:oFont ACTION (A140AtuCon(oList,aListBox,oEnable,oDisable,oConf,@nQtdConf,oStatCon,@cStatCon,.T.,oTimer)) OF oFolder:aDialogs[4] PIXEL When SF1->F1_STATCON == '2' //"Recontagem"
				@ 42 ,aPosGet[5,3]+180 BUTTON "Detalhes" SIZE 40 ,11  FONT oDlg:oFont ACTION (A140DetCon(oList,aListBox)) OF oFolder:aDialogs[4] PIXEL //"Detalhes"

				A140AtuCon(oList,aListBox,oEnable,oDisable)
			EndIf
			Eval(bRefresh)
			ACTIVATE MSDIALOG oDlg ON INIT Ma140Bar(oDlg,{||If(oGetDados:TudoOk().And.NfeNextDoc(@cNFiscal,@cSerie,l140Inclui),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{||oDlg:End()},aButtons)
		EndIf
		If nOpcA==0
			SetKey(VK_F5,bSavKeyF5)
			SetKey(VK_F6,bSavKeyF6)
			SetKey(VK_F7,bSavKeyF7)
			SetKey(VK_F10,bSavKeyF10)
			Return(.F.) 	
		EndIf
		lMsErroAuto := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Integracao com o ACD			  				  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l140Exclui .And. lIntACD .And. FindFunction("CBA140EXC") 
			nOpcA := IIF(CBA140EXC(),nOpcA,0)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Template acionando Ponto de Entrada                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf l140Exclui .And. nOpcA == 1 .And. ExistTemplate("A140EXC")
			nOpcA := IIF(ExecTemplate("A140EXC",.F.,.F.),nOpcA,0)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para validar a exclusao de um pre-documento ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l140Exclui .And. nOpcA == 1 .And. ExistBlock("A140EXC")
			nOpcA := IIF(ExecBlock("A140EXC",.F.,.F.),nOpcA,0)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizacao do pre-documento de entrada                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpcA == 1 .AND. ( l140Inclui .OR. l140Altera .OR. l140Exclui ) .AND. ( Type( "lOnUpDate" ) == "U" .OR. lOnUpdate )
			U_Ma140Grv( l140Exclui, aRecSD1, a140Desp )
		ElseIf l140Auto
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_FILIAL" } ) ) > 0
				aAutoCab[nPos][2] := xFilial( "SF1" )
			Else
				AAdd( aAutoCab, { "F1_FILIAL", xFilial( "SF1" ), NIL } )
			Endif

			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_DOC" } ) ) > 0
				aAutoCab[nPos][2] := cNFiscal
			Else
				AAdd( aAutoCab, { "F1_DOC", cNFiscal, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_SERIE" } ) ) > 0
				aAutoCab[nPos][2] := cSerie
			Else
				AAdd( aAutoCab, { "F1_SERIE", cSerie, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_FORNECE" } ) ) > 0
				aAutoCab[nPos][2] := cA100For
			Else
				AAdd( aAutoCab, { "F1_FORNECE", cA100For, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_LOJA" } ) ) > 0
				aAutoCab[nPos][2] := cLoja
			Else
				AAdd( aAutoCab, { "F1_LOJA", cLoja, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_EMISSAO" } ) ) > 0
				aAutoCab[nPos][2] := dDEmissao
			Else
				AAdd( aAutoCab, { "F1_EMISSAO", dDEmissao, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_EST" } ) ) > 0
				aAutoCab[nPos][2] := IIF( cTipo $ "DB", SA1->A1_EST, SA2->A2_EST )
			Else
				AAdd( aAutoCab, { "F1_EST", IIF( cTipo $ "DB", SA1->A1_EST, SA2->A2_EST ), NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_TIPO" } ) ) > 0
				aAutoCab[nPos][2] := cTipo
			Else
				AAdd( aAutoCab, { "F1_TIPO", cTipo, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_DTDIGIT" } ) ) > 0
				aAutoCab[nPos][2] := dDataBase
			Else
				AAdd( aAutoCab, { "F1_DTDIGIT", dDataBase, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_RECBMTO" } ) ) > 0
				aAutoCab[nPos][2] := SF1->F1_DTDIGIT
			Else
				AAdd( aAutoCab, { "F1_RECBMTO", SF1->F1_DTDIGIT	, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_FORMUL" } ) ) > 0
				aAutoCab[nPos][2] := IIF( cFormul == "S", "S", " " )
			Else
				AAdd( aAutoCab, { "F1_FORMUL", IIF( cFormul == "S", "S", " " ), NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_ESPECIE" } ) ) > 0
				aAutoCab[nPos][2] := cEspecie
			Else
				AAdd( aAutoCab, { "F1_ESPECIE", cEspecie, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_DESPESA" } ) ) > 0
				aAutoCab[nPos][2] := a140Desp[VALDESP]
			Else
				AAdd( aAutoCab, { "F1_DESPESA", a140Desp[VALDESP], NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_FRETE" } ) ) > 0
				aAutoCab[nPos][2] := a140Desp[FRETE]
			Else
				AAdd( aAutoCab, { "F1_FRETE", a140Desp[FRETE], NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_SEGURO" } ) ) > 0
				aAutoCab[nPos][2] := a140Desp[SEGURO]
			Else
				AAdd( aAutoCab, { "F1_SEGURO", a140Desp[SEGURO]	, NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_VALMERC" } ) ) > 0
				aAutoCab[nPos][2] := a140Total[VALMERC]
			Else
				AAdd( aAutoCab, { "F1_VALMERC", a140Total[VALMERC], NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_DESCONT" } ) ) > 0
				aAutoCab[nPos][2] := a140Total[VALDESC]
			Else
				AAdd( aAutoCab, { "F1_DESCONT", a140Total[VALDESC], NIL } )
			Endif
	
			If ( nPos := AScan( aAutoCab, { |x| x[1] == "F1_VALBRUT" } ) ) > 0
				aAutoCab[nPos][2] := a140Total[TOTPED]
			Else
				AAdd( aAutoCab, { "F1_VALBRUT", a140Total[TOTPED], NIL } )
			Endif
	
			aAutoItens := MsAuto2Gd( aHeader, aCols )
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Destrava os registros na alteracao e exclusao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnlockAll()
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F10,bSavKeyF10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O ponto de entrada e disparado apos o RestArea pois pode ser utilizado para posicionar o Browse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MT140SAI" )
	ExecBlock( "MT140SAI", .F., .F., { aRotina[ nOpcx, 4 ], cNFiscal, cSerie, cA100For, cLoja, cTipo, nOpcA } )
EndIf

Return((nOpcA<>0))
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³U_Ma140LOk³ Autor ³ Eduardo Riera         ³ Data ³02.10.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Validacao da Getdados - LinhaOk                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto da getdados                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se a linha digitada eh valida                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo validar um item do pre-documen-³±±
±±³          ³to de entrada                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ma140LOk(lInit,nModo) //User

Local aArea			:= GetArea()
Local lRetorno		:= .F.
Local nPosCod		:= aScan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local nPosLocal		:= aScan(aHeader,{|x|Alltrim(x[2])=="D1_LOCAL"})
Local nPosQuant		:= aScan(aHeader,{|x|Alltrim(x[2])=="D1_QUANT"})
Local nPosVUnit		:= aScan(aHeader,{|x|Alltrim(x[2])=="D1_VUNIT"})
Local nPosTotal		:= aScan(aHeader,{|x|Alltrim(x[2])=="D1_TOTAL"})
Local nPosPC		:= aScan(aHeader,{|x|Alltrim(x[2])=="D1_PEDIDO"})
Local nPosItemPC	:= aScan(aHeader,{|x|Alltrim(x[2])=="D1_ITEMPC"})
Local lPCNFE		:= GetNewPar( "MV_PCNFE", .F. ) //-- Nota Fiscal tem que ser amarrada a um Pedido de Compra ?
Local nPosServic	:= aScan(aHeader, {|x|Upper(Alltrim(x[2]))=='D1_SERVIC'})  
Local lMT140PC


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para o tratamento do parâmetro MV_PCNFE (Nota Fiscal tem que ser amarrada a um Pedido de Compra ?)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("MT140PC"))  
	lMT140PC  := ExecBlock("MT140PC",.F.,.F.,{lPCNFE})    
	If ( ValType(lMT140PC ) == 'L' )
		lPCNFE := lMT140PC 
	EndIf
EndIf      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica preenchimento dos campos da linha do acols      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CheckCols(n,aCols)
	If !aCols[n][Len(aCols[n])]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando Informado Armazem em branco considerar o B1_LOCPAD   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(aCols[n][nPosLocal])
			SB1->(dbSetOrder(1))
				If SB1->(MsSeek(xFilial("SB1")+aCols[n][nPosCod]))
				aCols[n][nPosLocal] := SB1->B1_LOCPAD
				If Type("l140Auto") <> "U" .And. !l140Auto
					If !lInit
						U_MyAviso(OemToAnsi("Atencao"),OemToAnsi("O Armazem informado e Invalido, o campo sera ajustando com o armazem padrão do cadastro de produtos"),{"Ok"}) //Atencao##O Armazem informado e Invalido, o campo sera ajustando com o armazem padrão do cadastro de produtos
					EndIf
				EndIf	
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o produto est  sendo inventariado.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
		Case Empty(aCols[n][nPosCod]) .Or. ;
				(Empty(aCols[n][nPosQuant]).And.cTipo$"NDB").Or. ;
				Empty(aCols[n][nPosVUnit]) .Or. ;
				Empty(aCols[n][nPosTotal])
			Help("  ",1,"A140VZ")
			lRetorno := .F.			
		Case nPosPC > 0 .And. !Empty(aCols[n][nPosPc]) .And. Empty(aCols[n][nPosItemPC])
			Help("  ",1,"A140PC")
			lRetorno := .F.			
		Case cPaisLoc <> "BRA".AND.cTipo <> "C" .And.;
				Round(aCols[n][nPosVUnit]*aCols[n][nPosQuant],SuperGetMV("MV_RNDLOC",.F.,2)) <> Round(aCols[n][nPosTotal],SuperGetMV("MV_RNDLOC",.F.,2))
			HELP(" ",1,"A100Valor")
			lRetorno := .F.			
		Case cTipo$'NDB' .And. (aCols[n][nPosTotal]>(aCols[n][nPosVUnit]*aCols[n][nPosQuant]+0.49);
		                   .Or. aCols[n][nPosTotal]<(aCols[n][nPosVUnit]*aCols[n][nPosQuant]-0.49))
			Help("  ",1,'TOTAL')
			lRetorno := .F.			
		Case !A103Alert(Acols[n][nPosCod],aCols[n][nPosLocal],l140Auto)
			lRetorno := .F.
		Case cTipo = 'N' .And. lPCNFE	 .And. Empty(aCols[n,nPosPC])
  		    If l140Auto .And. (IsInCallStack("MATA310") .Or. nModo ==2)   // Quando for Rotina Automatica e Transf.Filiais, ignora parametro pedido de compras 
  		       lRetorno := .T.
  		    else 
	   		   If !lInit
	   		      U_MyAviso(OemToAnsi("Atencao"),OemToAnsi("Informe o No. do Pedido de Compras ou verifique o conteudo do parametro MV_PCNFE"),{OemToAnsi("Ok")}, 2 ) //-- "Atencao"###"Informe o No. do Pedido de Compras ou verifique o conteudo do parametro MV_PCNFE"###"Ok"
			   EndIf
			   lRetorno := .F.
		    EndIf
		OtherWise
			lRetorno := .T.
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida o preenchimento dos campos referentes ao WMS             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	lRetorno .And. nPosServic > 0 .And. !Empty(aCols[n, nPosServic])
			lRetorno := A103WMSOk()
			//- Valida o Servico digitado na pre-nota, que deve ser de Conferencia.
			If	lRetorno
				//-- Valida o Servico digitado na pre-nota, que deve ser de Conferencia.
				If	!WmsVldSrv('5',aCols[n,nPosServic])
					Aviso(OemToAnsi("Atencao"), 'Somente Servicos WMS de Conferencia podem ser utilizados.', {'Ok'}) //'Somente Servicos WMS de Conferencia podem ser utilizados.'
					lRetorno := .F.
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se Produto x Fornecedor foi Bloquedo pela Qualidade.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRetorno
			lRetorno := QieSitFornec(cA100For,cLoja,aCols[n][nPosCod],.T.)
		EndIf

	Else
		lRetorno := .T.
	EndIf
Else
	lRetorno := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Refresh do rodape do pre-documento de entrada            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Eval(bRefresh)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa os pontos de entrada da Linha Ok                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno .And. ExistTemplate("MT140LOK")
	lRetorno := ExecTemplate("MT140LOK",.F.,.F.,{lRetorno,a140Total,a140Desp})
EndIf

If lRetorno .And. ExistBlock("MT140LOK")
	lRetorno := ExecBlock("MT140LOK",.F.,.F.,{lRetorno,a140Total,a140Desp})
EndIf

RestArea(aArea)
Return lRetorno
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma140TudOk³ Autor ³ Eduardo Riera         ³ Data ³02.10.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Validacao da Getdados - TudoOk                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto da getdados                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se todos os itens sao validos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo validar todos os itens do pre- ³±±
±±³          ³-documento de entrada                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA140Tok() //User

Local lRetorno     := .T.
Local lTudoDel     := .T.
Local nX           := 0   
Local nPosMed      := GDFieldPos( "D1_ITEMMED" ) 
Local lItensMed    := .F. 
Local lItensNaoMed := .F.   
Local aMT140GCT    := {}
Local aAreaSA1     := SA1->( getArea() )	//Hf - Control
Local aAreaSA2     := SA2->( getArea() )	//Hf - Control
Local cCnpj        := ""					//Hf - Control
Local aAreaSF2     := SF2->( getArea() )	//Hf - FGVTN
Local aAreaSA4     := SA4->( getArea() )	//Hf - FGVTN
Local aDetCte      := {}					//Hf - FGVTN
Local cCnpjTransp  := ""					//Hf - FGVTN
Local nPosNfo      := GDFieldPos( "D1_NFORI" ) //Hf - FGVTN
Local nPosSro      := GDFieldPos( "D1_SERIORI" ) //Hf - FGVTN
Local nPosTeste    := 0							//Hf - FGVTN
Local cFilSeek     := Iif(U_IsShared("SA2"),xFilial("SA2"),ZBZ->ZBZ_FILIAL) //Hf - Cimento Itambé
Local bSavKeyF3  := SetKey(VK_F5,Nil)
Local bSavKeyF5  := SetKey(VK_F5,Nil)
Local bSavKeyF6  := SetKey(VK_F6,Nil)
Local bSavKeyF7  := SetKey(VK_F7,Nil)
Local bSavKeyF10 := SetKey(VK_F10,Nil)

Private cCnpjXML   := &(cTagDocEmit)         	//Hf - Control

SF3->( dbSetOrder(4) ) //Hf - FGVTN
SF2->( dbSetOrder(1) ) //Hf - FGVTN
SA4->( dbSetOrder(1) ) //Hf - FGVTN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica preenchimento dos campos do cabecalho           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(ca100For) .Or. Empty(dDEmissao) .Or. Empty(cTipo) .Or. (Empty(cNFiscal).And.cFormul!="S")
	Help(" ",1,"A100FALTA")
	lRetorno := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem itens a serem gravados               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX :=1 to Len(aCols)
	If !aCols[nX][Len(aCols[nX])]
		lTudoDel := .F.
		If !Empty( nPosMed )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica a existencia de itens de medicao junto com itens sem medicao               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lItensMed    := lItensMed .Or. aCols[ nX, nPosMed ] == "1" 
			lItensNaoMed := lItensNaoMed .Or. aCols[ nX, nPosMed ] $ " |2"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de entrada permite incluir itens não-pertinentes ao gct ou não.               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (ExistBlock("MT140GCT"))
				aMT140GCT := ExecBlock("MT140GCT",.F.,.F.,{aCols,nX,nPosMed})

				If ValType(aMT140GCT) == "A"
					If Len(aMT140GCT) >= 1 .And. ValType(aMT140GCT[1]) == "L"
						lItensMed    := aMT140GCT[1]
					EndIf
					If Len(aMT140GCT) >= 2 .And. ValType(aMT140GCT[2]) == "L" 
						lItensNaoMed := aMT140GCT[2]
					EndIf	 
				EndIf  
			EndIf	           
			
			If lItensMed .And. lItensNaoMed
				Help( " ", 1, "A103MEDIC" ) 
				lRetorno := .F. 		
				Exit
			EndIf 
		EndIf

		//Hf - FGVTN
		if lDetCte .and. lNfOri  //HF Cimentos Itambé
			SA2->( dbSetOrder(3) ) //Hf - Itambé
			SA2->( DbSeek( cFilSeek + iif( len(aCnpRem)>=nX, aCnpRem[nX], cCnpRem ) ) )
			If .Not. SF3->( DbSeek( ZBZ->ZBZ_FILIAL + SA2->A2_COD + SA2->A2_LOJA + aCols[nX][nPosNfo] + aCols[nX][nPosSro] ) )
				If aCols[nX][nPosNfo] = "N/E" .And. Empty(aCols[nX][nPosSro])
					aadd(aDetCte,{aCols[nX][nPosNfo] + " / " + aCols[nX][nPosSro],"Chave XML não encontrou NF na Base de Dados (SF3)"} )
					aCols[nX][nPosNfo] := space( len(SF3->F3_NFISCAL ) )
				Else
					if lTagOri .Or. .Not. Empty(aCols[nX][nPosNfo]) .or. .Not. Empty(aCols[nX][nPosSro])
						aadd(aDetCte,{aCols[nX][nPosNfo] + " / " + aCols[nX][nPosSro],"NF/Série Não Encontrada (SF3)"} )
					endif
				Endif
			EndIf
			SA2->( dbSetOrder(1) ) //Hf - Itambé
		ElseIf lDetCte
			If .Not. SF2->( DbSeek( xFilial("SF2") + aCols[nX][nPosNfo] + aCols[nX][nPosSro] ) )
				If aCols[nX][nPosNfo] = "N/E" .And. Empty(aCols[nX][nPosSro])
					aadd(aDetCte,{aCols[nX][nPosNfo] + " / " + aCols[nX][nPosSro],"Chave XML não encontrou NF na Base de Dados"} )
					aCols[nX][nPosNfo] := space( len(SF2->F2_DOC ) )
				Else
					if lTagOri .Or. .Not. Empty(aCols[nX][nPosNfo]) .or. .Not. Empty(aCols[nX][nPosSro])
						aadd(aDetCte,{aCols[nX][nPosNfo] + " / " + aCols[nX][nPosSro],"NF/Série Não Encontrada"} )
					endif
				Endif
			Else
				cCnpjTransp := Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP, "A4_CGC")
				If cCnpjXML <> cCnpjTransp
					aadd(aDetCte,{aCols[nX][nPosNfo] + " / " + aCols[nX][nPosSro],"Cnpj Transportadora Difere. XML: "+Transform(cCnpjXML,"@R 99.999.999/9999-99")+" / NF: "+Transform(cCnpjTransp,"@R 99.999.999/9999-99")} )
				EndIf
				nPosTeste := aScan( aCols, {|x| x[nPosNfo] == aCols[nX][nPosNfo] .And. x[nPosSro] == aCols[nX][nPosSro] } )
				If nPosTeste > 0 .And. nPosTeste <> nX
					If !aCols[nPosTeste][Len(aCols[nPosTeste])]
						aadd(aDetCte,{aCols[nX][nPosNfo] + " / " + aCols[nX][nPosSro],"Existe Outro Item com esta NF/Série." } )
					EndIf
				EndIf
			EndIf
		EndIf
		//Hf - FGVTN

	Endif
Next nX
If lTudoDel
	Help(" ",1,"A140TUDDEL")
	lRetorno := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aqui a pedido da Control Service, checar Fornecedor com o XML. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno
	If .Not. cTipo $ "DB"
		cCnpj := Posicione("SA2",1,xFilial("SA2")+ ca100For + cLoja, "A2_CGC")
	Else
		cCnpj := Posicione("SA1",1,xFilial("SA1")+ ca100For + cLoja, "A1_CGC")
	EndIf
	If cCnpj <> cCnpjXML
		Alert( "CNPJ do cadastro Difere do CNPJ do XML" )
		lRetorno := .F.
	EndIf
EndIf
If lRetorno
	if Val( cNFiscal ) <> Val( cDocXMl )
		Alert( "Numero do Documento Difere do XML" )
		lRetorno := .F.
	EndIf
EndIf
If lRetorno
	if nAmarris == 3 .or. nAmarris == 0
		if nTotXml <> a140Total[TOTPED]
			lGraberPed := ( GetNewPar("XM_PED_GBR","N") == "S" )
			if lGraberPed
				if a140Total[TOTPED] > nTotXml
					U_MYAVISO("Atenção","Valor Total do XML, difere do valor Lançado."+CRLF+;
			   			"Valor do XML:  "+AllTrim(Transform(nTotXml,"@E 999,999,999,999.99"))+CRLF+;
			   			"Valor Lançado: "+AllTrim(Transform(a140Total[TOTPED],"@E 999,999,999,999.99"))+CRLF+;
			   			"",{"VOLTAR"},3)
			   			lRetorno := .F.
				endif
			else
				if U_MYAVISO("Atenção","Valor Total do XML, difere do valor Lançado."+CRLF+;
			   		"Valor do XML:  "+AllTrim(Transform(nTotXml,"@E 999,999,999,999.99"))+CRLF+;
			   		"Valor Lançado: "+AllTrim(Transform(a140Total[TOTPED],"@E 999,999,999,999.99"))+CRLF+;
			   		"Deseja Continuar Assim Mesmo?",{"SIM","NÃO"},3) == 2
			   		lRetorno := .F.
				endif
			endif
		EndIf
	endif
EndIf
If lRetorno
	if Val( cSerXml ) > 0
    	if Val( cSerXml ) <> Val( cSerie )
			Alert( "Serie do Documento Difere do XML" )
			lRetorno := .F.
    	EndIf
    Endif
EndIf
if lDetCte  //Hf FGVTN
	If lRetorno
		lRetorno := ErNfOri( aDetCte )
	EndIf
EndIf  //Hf FGVTN
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada do Ponto de entrada para validacao da TudoOk     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno .And. ExistBlock("MT140TOK")
	lRetorno := ExecBlock("MT140TOK",.F.,.F.,{lRetorno})
EndIf

SA4->( RestArea(aAreaSA4) )  //Hf - FGVTN
SF2->( RestArea(aAreaSF2) )  //Hf - FGVTN
SA1->( RestArea(aAreaSA1) )  //Hf - Control
SA2->( RestArea(aAreaSA2) )  //Hf - Control
SetKey(VK_F5,bSavKeyF3)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F10,bSavKeyF10)
Return lRetorno

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma140Bar  ³ Prog. ³ Sergio Silveira       ³Data  ³ 23/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Construcao da EnchoiceBar do pre-documento de entrada       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto dialog                                       ³±±
±±³          ³ ExpB2 = Code block de confirma                              ³±±
±±³          ³ ExpB3 = Code block de cancela                               ³±±
±±³          ³ ExpA4 = Array com botoes ja incluidos.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Devolve o retorno da enchoicebar                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo criar a barra de botoes denomi-³±±
±±³          ³nada EnchoiceBar                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma140Bar(oDlg,bOk,bCancel,aButtonsAtu)

Local aUsButtons := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MA140BUT" )
	If ValType( aUsButtons := ExecBlock( "MA140BUT", .F., .F. ) ) == "A"
		AEval( aUsButtons, { |x| aadd( aButtonsAtu, x ) } )
	EndIf
EndIf

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtonsAtu))

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma140Total³ Prog. ³ Sergio Silveira       ³Data  ³ 23/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Calculo do total do pre-documento de entrada                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1: Array com os totais do pre-documento de entrada      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo calcular os totais do pre-docum³±±
±±³          ³ento de entrada                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma140Total(aTotal,aDespesa, nTotal, nValDesc)

Local nUsado   := Len(aHeader)
Local nMaxFor  := Len(aCols)
Local lDeleted := .F.
Local nPTotal  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TOTAL"})
Local nPValDesc:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_VALDESC"})
Local nPValIpi := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VALIPI"})
Local nX       := 0
Local nIpi     := 0

Default nTotal 		:= 0
Default nValDesc 	:= 0

If Len(aCols)> 0
	For nX := 1 To Len(aCols)
		If aCols[nX][Len(aCols[1])]
			lDeleted := .T.
			Exit
		EndIf
	Next nX
EndIf

aTotal := aFill(aTotal,0)
aDespesa[VALDESC] := 0
For nX := 1 To nMaxFor
	If !lDeleted .Or. !aCols[nX][nUsado+1]
		If (n==nX)
			aTotal[VALMERC] 	+= 	Iif (nTotal<>0, nTotal, aCols[nX][nPTotal])
			aTotal[VALDESC] 	+= 	Iif (nValDesc<>0, nValDesc, aCols[nX][nPValDesc])
			aTotal[TOTPED ] 	+= 	Iif (nTotal<>0, nTotal, aCols[nX][nPTotal]) - Iif (nValDesc<>0, nValDesc, aCols[nX][nPValDesc])
			aDespesa[VALDESC]	+=	Iif (nValDesc<>0, nValDesc, aCols[nX][nPValDesc])
			nIpi                +=  Iif (nPValIpi<>0, aCols[nX][nPValIpi], 0 )
						
		ElseIf ((nTotal==0) .Or. (n<>nX))
			aTotal[VALMERC] 	+= 	aCols[nX][nPTotal]			
			aTotal[VALDESC] 	+= 	aCols[nX][nPValDesc]
			aTotal[TOTPED ] 	+= 	aCols[nX][nPTotal] - aCols[nX][nPValDesc]
			aDespesa[VALDESC]	+=	aCols[nX][nPValDesc]
			nIpi                +=  Iif (nPValIpi<>0, aCols[nX][nPValIpi], 0 )
		EndIf
	EndIf
Next nX
aTotal[TOTPED ] += aDespesa[FRETE] + aDespesa[VALDESP] + aDespesa[SEGURO] + nIpi
Return(.T.)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma140Grava³ Autor ³ Eduardo Riera         ³ Data ³03.10.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de atualizacao do pre-documento de entrada            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL1: Indica se a operacao eh de exclusao                   ³±±
±±³          ³ExpA1: Array com os recnos do SD1                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se houve atualizacao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo atualizar um pre-documento de  ³±±
±±³          ³entrada e seus anexos                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ma140Grv(lExclui,aRecSD1,aDespesa)

Local aArea     := GetArea("SF1")
Local aPCMail   := {}
Local nX        := 0
Local nY        := 0
Local nMaxFor   := Len(aCols)
Local nUsado    := Len(aHeader)
Local nSaveSX8  := GetSX8Len()
Local lTravou   := .F.
Local lGrava    := .F.
Local cItem     := StrZero(0,Len(SD1->D1_ITEM))
Local cGrupo    := SuperGetMv("MV_NFAPROV")
Local lGeraBlq  := .F.
Local nI        := 0
Local nJ        := 0
Local nPosServic:= aScan(aHeader, {|x|Upper(Alltrim(x[2]))=='D1_SERVIC'})
Local nDecimalPC:= TamSX3("C7_PRECO")[2]
Local cCpoJaGrv := ""
//-- Variaveis utilizadas pela funcao wmsexedcf
Local nPosDCF	:= 0
Local cTipoNf   := SuperGetMv("MV_TPNRNFS")
Private aLibSDB	:= {}
Private aWmsAviso:= {}
//--

l140Auto := !(Type("l140Auto")=="U" .Or. !l140Auto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o grupo de aprovacao do Comprador.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SAL")
dbSetOrder(3)
If MsSeek(xFilial("SAL")+RetCodUsr())
	cGrupo := If(!Empty(SY1->Y1_GRAPROV),SY1->Y1_GRAPROV,cGrupo)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para alterar o Grupo de Aprovacao.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MT140APV")
	cGrupo := ExecBlock("MT140APV",.F.,.F.,{cGrupo})
EndIf
//cGrupo:= If(Empty(SD1->D1_APROV),cGrupo,SD1->D1_APROV)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a operacao e de exclusao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lExclui
	aEval(aCols,{|x| x[nUsado+1] := .T.})
Else
	aEval(aCols,{|x| lGrava := !x[nUsado+1] .Or. lGrava })
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o arquivo de Cliente/Fornecedor                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo$"DB"
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial("SA1")+cA100For+cLoja)
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+cA100For+cLoja)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao do pre-documento de entrada                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To nMaxFor
	lTravou := .F.
	Begin Transaction
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizacao do cabecalho do pre-documento de entrada         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nX == 1 .And. lGrava
			dbSelectArea("SF1")
			dbSetOrder(1)
			If MsSeek(xFilial("SF1")+cNFiscal+cSerie+cA100For+cLoja+cTipo)
				RecLock("SF1",.F.)
				MaAvalSF1(2)
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Obtem numero do documento quando utilizar ³
				//³ numeracao pelo SD9 (MV_TPNRNFS = 3)       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				If cTipoNf == "3" .AND. cFormul == "S" .AND. cModulo <> "EIC"
					SX3->(DbSetOrder(1))
					If (SX3->(dbSeek("SD9")))
						// Se cNFiscal estiver vazio, busca numeracao no SD9, senao, respeita o novo numero
						// digitado pelo usuario.
						cNFiscal := MA461NumNf(.T.,cSerie,cNFiscal)
					EndIf			
				Endif 
				
				RecLock("SF1",.T.)
				//--Atualiza status da nota para em conferencia
				If (SuperGetMV("MV_CONFFIS",.F.,"N") == "S")
					SF1->F1_STATCON := "0"
				EndIf
			EndIf
			nPos := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_VALPEDG"})
			if nPos > 0
				nPedagioCt := aAutoCab[nPos][2]
			Else
				nPedagioCt := 0
			EndIf
			nPos := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_TPFRETE"})
			if nPos > 0
				cModFreCt := aAutoCab[nPos][2]
			Else
				cModFreCt := " "
			EndIf

			SF1->F1_FILIAL := xFilial("SF1")
			SF1->F1_DOC    := cNFiscal
			SF1->F1_SERIE  := cSerie
			SF1->F1_FORNECE:= cA100For
			SF1->F1_LOJA   := cLoja
			SF1->F1_EMISSAO:= dDEmissao
			SF1->F1_EST    := IIF(!Empty(cUfOrigP),cUfOrigP,IIf(cTipo$"DB",SA1->A1_EST,SA2->A2_EST))
			SF1->F1_TIPO   := cTipo
			SF1->F1_DTDIGIT:= IIf(GetMv("MV_DATAHOM",NIL,"1") == "1".Or.Empty(SF1->F1_RECBMTO),dDataBase,SF1->F1_RECBMTO)
			//SF1->F1_RECBMTO:= SF1->F1_DTDIGIT
			SF1->F1_FORMUL := IIf(cFormul=="S","S"," ")
			SF1->F1_ESPECIE:= cEspecie
			SF1->F1_TPFRETE:= cModFreCt
			SF1->F1_DESPESA:= aDespesa[VALDESP]
			SF1->F1_FRETE  := aDespesa[FRETE]
			SF1->F1_SEGURO := aDespesa[SEGURO]
			SF1->F1_CHVNFE := ZBZ->ZBZ_CHAVE
			SF1->F1_VALPEDG:= nPedagioCt
//			nPos := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_VOLUME1"})
//			if nPos > 0
//				SF1->F1_VOLUME1 := aAutoCab[nPos][2]
//			EndIf

			// INCLUIR TRATAMENTO PARA DADOS DO XML


			MaAvalSF1(1)
			If cPaisLoc != "BRA" .And. l140Auto
				For nI := 1 To Len(aAutoCab)
					SF1->(FieldPut(FieldPos(aAutoCab[nI][1]),aAutoCab[nI][2]))
				Next nI
			Else
				cCpoJaGrv := "F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_EMISSAO,F1_EST,F1_TIPO,F1_DTDIGIT,F1_FORMUL,F1_ESPECIE,F1_TPFRETE,F1_DESPESA,F1_FRETE,F1_SEGURO,F1_CHVNFE,F1_VALPEDG"  //,F1_VOLUME1
				For nI := 1 To Len(aAutoCab)
					If .NOT. AllTrim( aAutoCab[nI][1] ) $ cCpoJaGrv .And. FieldPos( aAutoCab[nI][1] ) > 0 
						SF1->(FieldPut(FieldPos(aAutoCab[nI][1]),aAutoCab[nI][2]))
					EndIf
				Next nI
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizacao da conferencia fisica                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (SuperGetMV("MV_CONFFIS",.F.,"N") == "S")
				If ExistBlock("MT140ACD")
					ExecBlock("MT140ACD",.F.,.F.)
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tratamento da gravacao do SF1 na Integridade Referencial            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF1->(FkCommit())
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizacao dos itens do pre-documento de entrada            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nX <= Len(aRecSD1)
			dbSelectArea("SD1")
			MsGoto(aRecSD1[nX])
			RecLock("SD1")
			If cPaisLoc=="BRA"
				MaAvalSD1(2,"SD1")
			ElseIf cPaisLoc == "ARG"
				If SD1->D1_TIPO_NF == "5"	//Factura Fob
					MaAvalSD1(2,"SD1")
				EndIf
			ElseIf cPaisLoc == "CHI"
				If SD1->D1_TIPO_NF == "9"	//Factura Aduana
					MaAvalSD1(2,"SD1")
				EndIf
			Endif
			lTravou := .T.
		Else
			If !aCols[nX][nUsado+1]	
				RecLock("SD1",.T.)
				lTravou := .T.
			EndIf
		EndIf
		If lTravou
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
			//³ Pontos de Entrada 											 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
			If lExclui
				If (ExistTemplate("SD1140E"))
					ExecTemplate("SD1140E",.F.,.F.)
				EndIf
				If (ExistBlock("SD1140E"))
					ExecBlock("SD1140E",.F.,.F.)
				Endif
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna o Servico do WMS (DCF)                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if Findfunction("A103EstDCF")  //aquiiii
				A103EstDCF(.T.)
			else
				U_HFEstDCF(.T.)
			endif
			If aCols[nX][nUsado+1]
				If cPaisLoc=="BRA"
					MaAvalSD1(3,"SD1")
				ElseIf cPaisLoc == "ARG"
					If SD1->D1_TIPO_NF == "5"	//Factura Fob
						MaAvalSD1(3,"SD1")
					EndIf
				ElseIf cPaisLoc == "CHI"
					If SD1->D1_TIPO_NF == "9"	//Factura Aduana
						MaAvalSD1(3,"SD1")
					EndIf
				Endif
				SD1->(dbDelete())
			Else
				cItem := Soma1(cItem,Len(cItem))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza os dados do acols                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nY := 1 To nUsado
					If aHeader[nY][10] <> "V"
						SD1->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
					EndIf
				Next nY
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona registros                                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial("SB1")+SD1->D1_COD)

				dbSelectArea("SD1")
				SD1->D1_FILIAL	:= xFilial("SD1")
				SD1->D1_FORNECE	:= cA100For
				SD1->D1_LOJA	:= cLoja
				SD1->D1_DOC		:= cNFiscal
				SD1->D1_SERIE	:= cSerie
				SD1->D1_EMISSAO	:= dDEmissao
				SD1->D1_DTDIGIT	:= dDataBase
				SD1->D1_GRUPO	:= SB1->B1_GRUPO
				SD1->D1_TIPO	:= cTipo
				If IntDL() .And. Empty(SD1->D1_NUMSEQ)
					SD1->D1_NUMSEQ := ProxNum()
				EndIf
				SD1->D1_TP		:= SB1->B1_TIPO
				SD1->D1_FORMUL	:= IIf(cFormul=="S","S"," ")
				If Empty(SD1->D1_ITEM)
					SD1->D1_ITEM    := cItem
				EndIf
				SD1->D1_TIPODOC := SF1->F1_TIPODOC
				// Caso o campo exista, significa que tem ACDSTD implantado, sendo necessario iniciar a CONFERENCIA
				If SD1->(FieldPos("D1_QTDCONF")) > 0
					SD1->D1_QTDCONF := 0
				EndIf

				If cPaisLoc != "BRA"
					SD1->D1_ESPECIE	:= cEspecie
					SD1->D1_FORMUL  := SF1->F1_FORMUL
					If l140Auto
						For nJ := 1 To Len(aAutoItens[nX])
							If Subs(aAutoItens[nX][nJ][1],4,6) $ "BASIMP|VALIMP|ALQIMP|TESDES"
								SD1->(FieldPut(FieldPos(aAutoItens[nX][nJ][1]),aAutoItens[nX][nJ][2]))
							EndIf
						Next nJ
					EndIf
					SD1->D1_TES	:= "   "
				EndIf

				//so eh necessario q. um item tenha bloqueio, pois o bloqueio eh da NF inteira
				If Empty(SD1->D1_TEC) .And. !lGeraBlq .And. !Empty(SD1->D1_PEDIDO+SD1->D1_ITEMPC) .And. !Empty(cGrupo)
					SC7->(DbSetOrder(1))
					SC7->(MsSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC))
					lGeraBlq := MaAvalToler(SD1->D1_FORNECE, SD1->D1_LOJA,SD1->D1_COD,SD1->D1_QUANT+SC7->C7_QUJE+SC7->C7_QTDACLA,SC7->C7_QUANT,SD1->D1_VUNIT,xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,,M->dDEmissao,nDecimalPC,SC7->C7_TXMOEDA,))[1]
				EndIf

				If cPaisLoc=="BRA"
					MaAvalSD1(1,"SD1")
				ElseIf cPaisLoc == "ARG"
					If SD1->D1_TIPO_NF == "5"	//Factura Fob
						MaAvalSD1(1,"SD1")
					EndIf
				ElseIf cPaisLoc == "CHI"
					If SD1->D1_TIPO_NF == "9"	//Factura Aduana
						MaAvalSD1(1,"SD1")
					EndIf
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada na Inclusao.                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (ExistBlock("SD1140I"))
					ExecBlock("SD1140I",.F.,.F.,{nx})
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza array com Pedidos utilizados                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(SD1->D1_PEDIDO)
					If aScan(aPCMail,SD1->D1_PEDIDO+" - "+SD1->D1_ITEMPC) == 0
						Aadd(aPCMail,SD1->D1_PEDIDO+" - "+SD1->D1_ITEMPC)
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gera os servicos de WMS na inclusao da Pre-Nota              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nPosServic > 0 .And. !Empty(aCols[nX, nPosServic])
					CriaDCF('SD1',,,,,@nPosDCF)
					If	!Empty(nPosDCF) .And. WmsVldSrv('4',aCols[nX, nPosServic])
						DCF->(MsGoTo(nPosDCF))
						WmsExeDCF('1',.F.)
					EndIf
				EndIf
				
			EndIf
			If lGeraBlq .And. nX == nMaxFor
				cGrupo:= If(Empty(SF1->F1_APROV),cGrupo,SF1->F1_APROV)
				If ALTERA .Or. lExclui // Estorna as liberacoes
					MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",SF1->F1_VALBRUT,,,cGrupo,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3)
				EndIf
				If !lExclui
					MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",0,,,cGrupo,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,1)
				EndIf
				dbSelectArea("SF1")
				Reclock("SF1",.F.)
				SF1->F1_STATUS := "B"
				SF1->F1_APROV  := cGrupo
				MsUnlock()
			EndIf
		EndIf

		If nX == nMaxFor .And. !lGrava
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tratamento da gravacao do SD1 na Integridade Referencial            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SD1->(FkCommit())

			dbSelectArea("SF1")
			dbSetOrder(1)
			If MsSeek(xFilial("SF1")+cNFiscal+cSerie+cA100For+cLoja+cTipo)
				RecLock("SF1",.F.)
				MaAvalSF1(2)
				MaAvalSF1(3)
				MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",SF1->F1_VALBRUT,,,cGrupo,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3)
				SF1->(dbDelete())
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa os gatilhos e a confirmacao do semaforo              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nX == nMaxFor
			EvalTrigger()
			While ( GetSX8Len() > nSaveSX8 )
				ConfirmSx8()
			EndDo
		EndIf
	End Transaction
Next nX

If !lExclui .And. lGrava
	//-- Integrado ao wms devera avaliar as regras para convocacao do servico e disponibilizar os 
	//-- registros do SDB para convocacao
	If	IntDL() .And. !Empty(aLibSDB)
		WmsExeDCF('2')
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existencia de e-mails para o evento 005       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MEnviaMail("005",{SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,If(cTipo$"DB",SA1->A1_NOME,SA2->A2_NOME),aPCMail})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a necessidade da impressao de etiquetas         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SA2->(FieldPos("A2_IMPIP")) <> 0 .And. SuperGetMV("MV_INTACD",.F.,"0") == "1"
		If (SA2->A2_IMPIP == "2") .Or. (SA2->A2_IMPIP $ "03 " .And. SuperGetMv("MV_IMPIP",.F.,"3") == "2" ) // MV_IMPIP: ACD
			If (!l140Auto .Or. GetAutoPar("AUTIMPIP",aAutoCab,0) == 1) .And. SF1->F1_STATCON <> "1"
				If (FindFunction("ACDI010"))
					ACDI10NF(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.T.,l140Auto)
				Else	
					T_ACDI10NF(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.T.,l140Auto)
				EndIf
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Template Function apos atualizacao de todos os dados inclusao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (ExistTemplate("SF1140I"))
		ExecTemplate("SF1140I",.F.,.F.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada apos atualizacao de todos os dados inclusao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (ExistBlock("SF1140I"))
		ExecBlock("SF1140I",.F.,.F.)
	EndIf

EndIf    

dbSelectArea("SC7")  
dbSetOrder(1)

RestArea(aArea)
Return(lGrava)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A140AtuCon³ Prog. ³ Fernando Alves        ³Data  ³15/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza folder de conferencia fisica                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A140ConfPr( ExpO1, ExpA1)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto do list box                                 ³±±
±±³          ³ ExpA2 = Array com o contudo da list box                    ³±±
±±³          ³ ExpO3 = Objeto para flag do list box                       ³±±
±±³          ³ ExpO4 = Objeto para flag do list box                       ³±±
±±³          ³ ExpO5 = Objeto com total de conferentes na nota            ³±±
±±³          ³ ExpN6 = Variavel de quantidade de conferentes              ³±±
±±³          ³ ExpN7 = Objeto com o status da nota                        ³±±
±±³          ³ ExpN8 = Variavel com a descricao do status da nota         ³±±
±±³          ³ ExpL9 = Habilita recontagem na conferencia (limpa o que foi³±±
±±³          ³         gravado)                                           ³±±
±±³          ³ ExpO10= Objeto timer                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA140                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A140AtuCon(oList,aListBox,oEnable,oDisable,oConf,nQtdConf,oStatCon,cStatCon,lReconta,oTimer)

Local aArea     := {}
Local cAliasOld := Alias()

If ValType(oTimer) == "O"
	oTimer:Deactivate()
EndIf
lReconta := If (lReconta == nil,.F.,lReconta)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Habilita recontagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lReconta .And. (Aviso("AVISO","Voce realmente quer fazer a recontagem?",{"Sim","Nao"}) == 1) //"AVISO"###"Voce realmente quer fazer a recontagem?"###"Sim"###"Nao"
	If Reclock("SF1",.F.)
		SF1->F1_STATCON := "0"
		SF1->(msUnlock())
	EndIf
	dbSelectArea("CBE")
	dbsetOrder(2)
	MsSeek(xFilial("CBE")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	While !eof() .and. CBE->CBE_NOTA+CBE->CBE_SERIE == SF1->F1_DOC+SF1->F1_SERIE .and.;
			CBE->CBE_FORNEC+CBE->CBE_LOJA == SF1->F1_FORNECE+SF1->F1_LOJA
		If reclock("CBE",.F.)
			CBE->(dbDelete())
			CBE->(msUnlock())
		EndIf
		dbSelectArea("CBE")
		dbSkip()
	EndDo
Else
	lReconta := .F.
EndIf

aListBox := {}
dbSelectArea("SD1")
aArea := GetArea()

MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE)

While !EOF() .and. SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for a opcao RECONTAGEM, zera tudo o que foi conferido³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lReconta
		Reclock("SD1",.F.)
		SD1->D1_QTDCONF := 0
		SD1->(msUnlock())
	EndIf
	aAdd(aListBox,{SD1->D1_COD,SD1->D1_QTDCONF,SD1->D1_QUANT})
	dbSkip()
End
If ValType(oList) == "O"
	oList:SetArray(aListBox)
	oList:bLine := { || {If (aListBox[oList:nAT,2] == aListBox[oList:nAT,3],oEnable,oDisable), aListBox[oList:nAT,1], aListBox[oList:nAT,2]} }
	oList:Refresh()
EndIf
RestArea(aArea)
dbSelectArea(cAliasOld)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza os Gets³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType(oConf) == "O"
	SF1->(dbSkip(-1))
	If !SF1->(BOF())
		SF1->(dbSkip())
	EndIf
	nQtdConf := SF1->F1_QTDCONF
	oConf:Refresh()
EndIf

If ValType(oStatCon) == "O"
	Do Case
	Case SF1->F1_STATCON == '1'
		cStatCon := "NF conferida"
	Case SF1->F1_STATCON == '0'
		cStatCon := "NF nao conferida"
	Case SF1->F1_STATCON == '2'
		cStatCon := "NF com divergencia"
	Case SF1->F1_STATCON == '3'
		cStatCon := "NF em conferencia"
	EndCase
	nQtdConf := SF1->F1_QTDCONF
	oStatCon:Refresh()
EndIf
If ValType(oTimer) == "O"
	oTimer:Activate()
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A140DetCon³ Prog. ³ Eduardo Motta         ³Data  ³19/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta listbox com dados da conferencia do produto          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A140DetCon(oList,aListBox)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto do list box                                 ³±±
±±³          ³ ExpA2 = Array com o contudo da list box                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA140                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A140DetCon(oList,aListBox)
Local cCodPro := aListBox[oList:nAt,1]
Local aListDet := {}
Local oListDet
Local oDlgDet
Local aArea := sGetArea()
Local oTimer
Local bBlock := {|cCampo|(SX3->(MsSeek(cCampo)),X3TITULO())}
Local oIndice
Local aIndice := {}
Local cIndice
Local aIndOrd := {}
Local cKeyCBE  := "CBE_FILIAL+CBE_NOTA+CBE_SERIE+CBE_FORNEC+CBE_LOJA+CBE_CODPRO"
Local aColunas := {}
Local aCpoCBE  := {}
Local nI


sGetArea(aArea,"CBE")
sGetArea(aArea,"SB1")
sGetArea(aArea,"SX3")
sGetArea(aArea,"SIX")

SIX->(DbSetOrder(1))
SIX->(MsSeek("CBE"))
While !SIX->(Eof()) .and. SIX->INDICE == "CBE"
	If SubStr(SIX->CHAVE,1,Len(cKeyCBE)) == cKeyCBE
		aadd(aIndice,SIX->(SixDescricao()))
		If IsDigit(SIX->ORDEM)     // se for numerico o conteudo do ORDEM assume ele mesmo, senao calcula o numero do indice (ex: "A" => 10, "B" => 11, "C" => 12, etc)
			aadd(aIndOrd,Val(SIX->ORDEM))
		Else
			aadd(aIndOrd,Asc(SIX->ORDEM)-55)
		EndIf
	EndIf
	SIX->(DbSkip())
EndDo

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("CBE")
While !EOF() .And. (x3_arquivo == "CBE")
	If ( x3uso(X3_USADO) .And. cNivel >= X3_NIVEL .and. !(AllTrim(X3_CAMPO) $ cKeyCBE))
		aadd(aCpoCBE,{X3_CAMPO,X3_CONTEXT})
	Endif
	dbSkip()
EndDo

SX3->(DbSetOrder(2))
SB1->(DbSetOrder(1))
SB1->(MsSeek(xFilial("SB1")+cCodPro))

cIndice := aIndice[1]

For nI := 1 to Len(aCpoCBE)
	aadd(aColunas,Eval(bBlock,aCpoCBE[nI,1]))
Next

CBE->(dbsetOrder(2))

DEFINE MSDIALOG oDlgDet TITLE OemToAnsi("Detalhes de Conferencia do Produto "+cCodPro+" "+SB1->B1_DESC) From 0, 0 To 25, 67 OF oMainWnd //"Detalhes de Conferencia do Produto "
oListDet := TWBrowse():New( 02, 2, (oDlgDet:nRight/2)-5, (oDlgDet:nBottom/2)-30,,aColunas,, oDlgDet,,,,,,,,,,,, .F.,, .T.,, .F.,,, )

A140AtuDet(cCodPro,oListDet,aListDet,,aCpoCBE)

@ (oDlgDet:nBottom/2)-25, 005 Say "Ordem " PIXEL OF oDlgDet //"Ordem "
@ (oDlgDet:nBottom/2)-25, 025 MSCOMBOBOX oIndice    VAR cIndice    ITEMS aIndice    SIZE 180,09 PIXEL OF oDlgDet
oIndice:bChange := {||CBE->(DbSetOrder(aIndOrd[oIndice:nAt])),A140AtuDet(cCodPro,oListDet,aListDet,oTimer,aCpoCBE)}
@  (oDlgDet:nBottom/2)-25, (oDlgDet:nRight/2)-50 BUTTON "&Retorna" SIZE 40,10 ACTION ( oDlgDet:End() ) Of oDlgDet PIXEL // //"&Retorna"

DEFINE TIMER oTimer INTERVAL 1000 ACTION (A140AtuDet(cCodPro,oListDet,aListDet,oTimer,aCpoCBE)) OF oDlgDet
oTimer:Activate()

ACTIVATE MSDIALOG oDlgDet CENTERED

sRestArea(aArea)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A140AtuDet³ Prog. ³ Eduardo Motta         ³Data  ³19/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza array para listbox dos detalhes de conferencia    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A140AtuDet(cCodPro,oListDet,aListDet,oTimer)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCodPro  - Codigo do produto a procurar no CBE             ³±±
±±³          ³ oListDet - Objeto listbox a atualizar                      ³±±
±±³          ³ aListDet - Array do listbox                                ³±±
±±³          ³ oTimer   - Objeto timer a desativar para o processo        ³±±
±±³          ³ aCpoCBE  - Campos do LISTBOX                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA140                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A140AtuDet(cCodPro,oListDet,aListDet,oTimer,aCpoCBE)
Local aLine := {},nI
Local uConteudo

If ValType(oTimer) == "O"
	oTimer:Deactivate()
EndIf

aListDet := {}

CBE->(MsSeek(xFilial("CBE")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+cCodPro))

While !CBE->(eof()) .and. CBE->CBE_NOTA+CBE->CBE_SERIE == SF1->F1_DOC+SF1->F1_SERIE .and.;
		CBE->CBE_FORNEC+CBE->CBE_LOJA == SF1->F1_FORNECE+SF1->F1_LOJA .and. CBE->CBE_CODPRO == cCodPro

	aLine := {}
	For nI := 1 to Len(aCpoCBE)
		If Empty(aCpoCBE[nI,2])
			uConteudo := CBE->&(aCpoCBE[nI,1])
		Else
			uConteudo := CriaVar(aCpoCBE[nI,1])
		EndIf
		aadd(aLine,uConteudo)
	Next
	aadd(aListDet,aLine)

	CBE->(DbSkip())
EndDo
If Empty(aListDet)
	aLine := {}
	For nI := 1 To Len(aCpoCBE)
		aadd(aLine,CriaVar(aCpoCBE[nI,1],.f.))
	Next
	aadd(aListDet,aLine)
EndIf

oListDet:SetArray( aListDet )
oListDet:bLine := { || RetDetLine(aListDet,oListDet:nAT)  }

oListDet:Refresh()

If ValType(oTimer) == "O"
	oTimer:Activate()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RetDetLine³ Prog. ³ Eduardo Motta         ³Data  ³20/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para retornar campos para o bLine do listbox        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RetDetLine(aListDet,nAt)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aListDet - Array com dados do listbox                      ³±±
±±³          ³ nAt      - Linha do listbox                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ A140AtuDet                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetDetLine( aListDet,nAt)
Local aRet := {}
Local nX:= 0
For nX:= 1 to len(aListDet[nAt])
	aadd(aRet,aListDet[nAt,nx])
Next nX
Return aRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A140Impri ³ Autor ³Alexandre Inacio Lemes³ Data ³22/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a chamada do relatorio padrao ou do usuario         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpX1 := A140Impri( ExpC1, ExpN1, ExpN2 )                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Alias do arquivo                                  ³±±
±±³          ³ ExpN1 -> Recno do registro                                 ³±±
±±³          ³ ExpN2 -> Opcao do Menu                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpX1 -> Retorno do relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A140Impri( cAlias, nRecno, nOpc ) //User

Local xRet := a103Impri( cAlias, nRecno, nOpc )

Pergunte("MTA140",.F.)

Return( xRet )
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A140EstCla ³ Autor ³Patricia A. Salomao   ³ Data ³01/08/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Estorno da Classificacao da Nota Fiscal.                    ³±±
±±³          ³Executa a funcao de exclusao do MATA103;Porem, nao exclui o ³±±
±±³          ³SD1/SF1;Apenas limpa o conteudo os campos D1_TES e F1_STATUS³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpX1 := A140ExcCla( ExpC1, ExpN1, ExpN2 )                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Alias do arquivo                                  ³±±
±±³          ³ ExpN1 -> Recno do registro                                 ³±±
±±³          ³ ExpN2 -> Opcao Selecionada                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA140                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A140EstCla( cAlias, nRecno, nOpc ) //User

If SF1->F1_STATUS != "A"
    Help("",1,"A140ESTORN")
ElseIf SF1->F1_TIPO $ "NDB"
	A103NFiscal(cAlias,nRecno,5,,.T.)
Else
	Help("",1,"A140NCLASS")
EndIF

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a140Desc   ³ Autor ³Gustavo G. Rueda      ³ Data ³30/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para atualizar o valor do DESCONTO no rodapeh quando ³±±
±±³          ³ digitamos o campo D1_DESC ou D1_VALDESC.                   ³±±
±±³          ³Para atualizar de acordo com o campo:                       ³±±
±±³          ³ - D1_DESC eh necessario criar o seguinte gatilho junto com ³±±
±±³          ³   padroes do sistema.                                      ³±±
±±³          ³   X7_CAMPO = D1_DESC                                       ³±±
±±³          ³   X7_REGRA = M->D1_VALDESC := IIF(A140DESC(M->D1_VALDESC), ³±±
±±³          ³              M->D1_VALDESC, M-D1_VALDESC)				  ³±±
±±³          ³   X7_CDOMIN = D1_VALDESC                                   ³±±
±±³          ³ - D1_VALDESC eh necessario inserir a seguinte validacao no ³±±
±±³          ³   SX3: A140DESC(M->D1_VALDESC)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A140DESC(nValDesc)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nValDesc -> Valor do desconto do item                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA140                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function a140Desc (nValDesc) //User
	Eval (bRefresh,,,,nValDesc)
Return (.T.)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ma140DelIt ³ Autor ³Gustavo G. Rueda      ³ Data ³30/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para atualizar o valor do DESCONTO e do TOTAL no     ³±±
±±³          ³ rodapeh quando marcamos como deletado determinado item.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ma140DelIt ()                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA140                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ma140DelIt () //User
	Local	aTotal		:=	{0,0,0}
	Local	aDespesa	:=	{0,0,0,0,0,0,0,0}
	//
	Ma140Total(aTotal,aDespesa)
	Eval (bRefresh)
Return (.T.) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³01/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³    1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()     
PRIVATE aRotina	:= {	{ "Pesquisar" 				,"AxPesqui"		, 0 , 1, 0, .F.},; //"Pesquisar"
						{ "Visualizar"				,"U_A140NFis"	, 0 , 2, 0, nil},; //"Visualizar"
						{ "Incluir"					,"U_A140NFis"	, 0 , 3, 0, nil},; //"Incluir"
						{ "Alterar"					,"U_A140NFis"	, 0 , 4, 0, nil},; //"Alterar"
						{ "Excluir"					,"U_A140NFis"	, 0 , 5, 0, nil},; //"Excluir"
						{ "Imprimir" 				,"A140Impri"  	, 0 , 4, 0, nil},; //"Imprimir"
						{ "Estorna Classificacao"	,"A140EstCla" 	, 0 , 5, 0, nil},; //"Estorna Classificacao"	
						{ "Legenda"					,"A103Legenda"	, 0 , 2, 0, .F.}} 	//"Legenda"	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MTA140MNU")
	ExecBlock("MTA140MNU",.F.,.F.)
EndIf
Return(aRotina) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MaCols140 ³ Autor ³ Liber De Esteban      ³ Data ³ 10/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Montagem do aCols para GetDados.                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MaCols140()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|-cAliasSD1 ->Alias do SD1.                                  ³±±
±±³          ³-aRecSD1 -> Array com registros do SD1.                     ³±±
±±³          ³-bWhileSD1 -> Bloco com condicao para While.                ³±±
±±³          ³-nCounterSD1 -> Contador de registros do SD1, para o caso de³±±
±±³          ³nao estar usando query.                                     ³±±
±±³          ³-lQuery -> Flag de identificacao se esta usando query.      ³±±
±±³          ³-l140Inclui -> Flag que identifica se operacao e inclusao.  ³±±
±±³          ³-l140Visual -> Flag que identifica se operacao e inclusao.  ³±±
±±³          ³-lContinua -> Flag que identifica se deve continuar proc.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA140                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MaCols140(cAliasSD1,bWhileSD1,aRecOrdSD1,aRecSD1,aPedC,lItSD1Ord,lQuery,l140Inclui,l140Visual,lContinua,l140Exclui)
Local nPos		:= 0
Local nPosPc	:= 0
Local nX		:= 0
Local nY 		:= 0
Local nCountSD1	:= 1
Local lAntAlt   := ALTERA
Local lAntInc   := INCLUI

If !Empty(aHeadSD1)
	aHeader := aClone(aHeadSD1)
EndIf

If l140Inclui
	ALTERA := .F.
	INCLUI := .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem de uma linha em branco no aCols.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCols,Array(Len(aHeader)+1))
	For nY := 1 To Len(aHeader)
		If Trim(aHeader[nY][2]) == "D1_ITEM"
			aCols[1][nY] 	:= StrZero(1,Len((cAliasSD1)->D1_ITEM))
		Else
			If AllTrim(aHeader[nY,2]) == "D1_ALI_WT"
				aCOLS[Len(aCols)][nY] := "SD1"
			ElseIf AllTrim(aHeader[nY,2]) == "D1_REC_WT"
				aCOLS[Len(aCols)][nY] := 0
			Else
				aCols[1][nY] := CriaVar(aHeader[nY][2])
			EndIf
		EndIf
		aCols[1][Len(aHeader)+1] := .F.
	Next nY
    ALTERA := lAntAlt
    INCLUI := lAntInc
Else

	While Eval( bWhileSD1 )
	
		If !lQuery .And. (lItSD1Ord .Or. ALTERA)
		
			If nCountSD1 == 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Este procedimento eh necessario para fazer a montagem        ³
				//³ do acols na ordem ITEM + COD quando classificacao em CDX     ³
				//³ e o parametro MV_PAR03 estiver para ITEM                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aRecOrdSD1 := {}
				While ( !Eof().And. lContinua .And. ;
						(cAliasSD1)->D1_FILIAL== xFilial("SD1") .And. ;
						(cAliasSD1)->D1_DOC == cNFiscal .And. ;
						(cAliasSD1)->D1_SERIE == SF1->F1_SERIE .And. ;
						(cAliasSD1)->D1_FORNECE == SF1->F1_FORNECE .And. ;
						(cAliasSD1)->D1_LOJA == SF1->F1_LOJA )
	
					AAdd( aRecOrdSD1, { ( cAliasSD1 )->D1_ITEM + ( cAliasSD1 )->D1_COD, ( cAliasSD1 )->( Recno() ) } )
	
					( cAliasSD1 )->( dbSkip() )
	
				EndDo
	
				ASort( aRecOrdSD1, , , { |x,y| y[1] > x[1] } )
	
				bWhileSD1 := { || nCountSD1 <= Len( aRecOrdSD1 ) .And. lContinua  }
			EndIf
			
			If !lQuery .And. (lItSD1Ord .Or. ALTERA)
				SD1->( dbGoto( aRecOrdSD1[ nCountSD1, 2 ] ) )
			EndIf

		EndIf

		If (cAliasSD1)->D1_TIPO == SF1->F1_TIPO
			If Empty((cAliasSD1)->D1_TES)
				//-- Impede a alteracao/exclusao da PreNota com Servico de WMS jah executado
				If	IntDL() .And. (l140Exclui .Or. !l140Visual) .And. FindFunction("WmsChkDCF")
					If	WmsChkDCF("SD1",,,SD1->D1_SERVIC,'3',,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_LOCAL,SD1->D1_COD,SD1->D1_LOTECTL,SD1->D1_NUMLOTE,SD1->D1_NUMSEQ,SD1->D1_ITEM)
						Aviso("SIGAWMS","Documento nao pode ser alterado/excluido porque possui servicos de WMS pendentes. Antes estorne estes servicos.",{'Ok'}) //"Documento nao pode ser alterado/excluido porque possui servicos de WMS pendentes. Antes estorne estes servicos."
						lContinua := .F.
						Loop
					EndIf
				EndIf
					If lQuery
					aadd(aRecSD1,(cAliasSD1)->SD1RECNO)
				Else
					aadd(aRecSD1,RecNo())
				EndIf

				If !l140Visual
					If !Empty((cAliasSD1)->D1_PEDIDO)
						nPosPC := aScan(aPedC,{|y| y[1] == (cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC})
						If nPosPc > 0
							aPedC[nPosPc,2] += (cAliasSD1)->D1_QUANT
						Else
							aadd(aPedC,{(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC,(cAliasSD1)->D1_QUANT})
						EndIf
					EndIf
				EndIf
				aadd(aCols,Array(Len(aHeader)+1))
				For nY := 1 to Len(aHeader)
					If ( aHeader[nY][10] != "V")
						aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
					Else
						If AllTrim(aHeader[nY,2]) == "D1_ALI_WT"
							aCOLS[Len(aCols)][nY] := "SD1"
						ElseIf AllTrim(aHeader[nY,2]) == "D1_REC_WT"
							aCOLS[Len(aCols)][nY] := If(lQuery,(cAliasSD1)->SD1RECNO,(cAliasSD1)->(RecNo()))
						Else
							aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
						EndIf
					EndIf
					aCols[Len(aCols)][Len(aHeader)+1] := .F.
				Next nY
			Else
				Help(" ",1,"A140CLASSI")
				lContinua := .F.
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua skip na area SD1 ( regra geral ) ou incrementa o contador ³
		//³ quando ordem por ITEM + CODIGO DE PRODUTO                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lQuery .And. (lItSD1Ord .Or. ALTERA)
			nCountSD1++
		Else
			dbSelectArea(cAliasSD1)
			dbSkip()
		EndIf
	EndDo
EndIf

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AjustaHelp    ³ Autor ³Turibio Miranda       ³ Data ³23.02.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ajusta os helps                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AjustaHelp()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function AjustaHelp()
Local aArea 	:= GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aHelpPor :=	{"Não é possível realizar o estorno de","classificação para esta nota."}
aHelpSpa :=	{"No es posible realizar la reversion de","clasificacion para esta factura."}
aHelpEng :=	{"Classification reversal is not","possible for this invoice."}
PutHelp("PA140ESTORN",aHelpPor,aHelpEng,aHelpSpa,.F.)    
 
aHelpPor :=	{"O estorno é possível somente para","notas fiscais já classificadas."}
aHelpSpa :=	{"Solo es posible la reversion para","facturas ya clasificadas."}
aHelpEng :=	{"Classification reversal is possible","only for already classified invoices."}
PutHelp("SA140ESTORN",aHelpPor,aHelpEng,aHelpSpa,.F.) 

Restarea(aArea)
Return    





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³XMLPCF5   ³ Autor ³ Edson Maricate        ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de importacao de Pedidos de Compra.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103Pedido()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function XMLPCF5(lUsaFiscal,aGets,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV)

Local nSldPed    := 0
Local nOpc       := 0
Local nx         := 0
Local cQuery     := ""
Local cAliasSC7  := "SC7"
Local lQuery     := .F.
Local bSavSetKey := SetKey(VK_F4,Nil)
Local bSavKeyF5  := SetKey(VK_F5,Nil)
Local bSavKeyF6  := SetKey(VK_F6,Nil)
Local bSavKeyF7  := SetKey(VK_F7,Nil)
Local bSavKeyF8  := SetKey(VK_F8,Nil)
Local bSavKeyF9  := SetKey(VK_F9,Nil)
Local bSavKeyF10 := SetKey(VK_F10,Nil)
Local bSavKeyF11 := SetKey(VK_F11,Nil)
Local cChave     := ""
Local cCadastro  := ""
Local aArea      := GetArea()
Local aAreaSA2   := SA2->(GetArea())
Local aAreaSC7   := SC7->(GetArea())
Local nF4For     := 0
Local oOk        := LoadBitMap(GetResources(), "LBOK")
Local oNo        := LoadBitMap(GetResources(), "LBNO")
Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons   := { {'PESQUISA',{||A103VisuPC(aRecSC7[oListBox:nAt])},OemToAnsi("Visualiza Pedido"),OemToAnsi("Pedido")} } //"Visualiza Pedido"
Local oDlg,oListBox
Local cNomeFor   := ''
Local aTitCampos := {}
Local aConteudos := {}
Local aUsCont    := {}
Local aUsTitu    := {}
Local bLine      := { || .T. }
Local cLine      := ""
Local lMa103F4I  := ExistBlock( "MA103F4I" )
Local nLoop      := 0
Local lMt103Vpc  := ExistBlock("MT103VPC")
Local lRet103Vpc := .T.
Local lContinua  := .T.
Local oPanel
Local nNumCampos := 0
Local nPosCC     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CC"})         //HF
Local nPosPRD	 := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })     //HF

PRIVATE aF4For     := {}
PRIVATE aRecSC7    := {}

DEFAULT lUsaFiscal := .T.
DEFAULT aGets      := {}
DEFAULT lNfMedic   := .F.
DEFAULT lConsMedic := .F.
DEFAULT aHeadSDE   := {}
DEFAULT aColsSDE   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lContinua

	If MaFisFound("NF") .Or. !lUsaFiscal
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o aCols esta vazio, se o Tipo da Nota e'     ³
		//³ normal e se a rotina foi disparada pelo campo correto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipo == "N"
			DbSelectArea("SA2")
			DbSetOrder(1)
			MsSeek(xFilial("SA2")+cA100For+cLoja)
			cNomeFor	:= SA2->A2_NOME

			#IFDEF TOP
				DbSelectArea("SC7")
				If TcSrvType() <> "AS/400"
					SC7->( DbSetOrder( 9 ) ) 				
					lQuery    := .T.
					cAliasSC7 := "QRYSC7"

					cQuery := "SELECT R_E_C_N_O_ RECSC7 FROM "
					cQuery += RetSqlName("SC7") + " SC7 "
					cQuery += "WHERE "
					cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "
					If HasTemplate( "DRO" ) .AND. FunName() == "MATA103" .AND. MV_PAR15 == 1
						cQuery += "C7_FORNECE IN ( " + T_DrogForn( cA100For ) + " ) AND "
					Else
					cQuery += "C7_FORNECE = '"+cA100For+"' AND "		    		
					EndIf
					cQuery += "(C7_QUANT-C7_QUJE-C7_QTDACLA)>0 AND "
					cQuery += "C7_RESIDUO=' ' AND "
					cQuery += "C7_TPOP<>'P' AND "

					If SuperGetMV("MV_RESTNFE")=="S"
						cQuery += "C7_CONAPRO<>'B' AND "
					EndIf 										

					If ( lConsLoja )		    		
						cQuery += "C7_LOJA = '"+cLoja+"' AND "		    							
					Endif		

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os pedidos de compras de acordo com os contratos             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If lConsMedic

						If lNfMedic

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Traz apenas os pedidos oriundos de medicoes                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery += "C7_CONTRA<>'"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO<>'" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		

						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Traz apenas os pedidos que nao possuem medicoes                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery += "C7_CONTRA='"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO='" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		

						EndIf

					EndIf 					

					cQuery += "SC7.D_E_L_E_T_ = ' '"
					cQuery += "ORDER BY " + SqlOrder( SC7->( IndexKey() ) )

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
				Else
			#ENDIF
				DbSelectArea("SC7")
				DbSetOrder(9)
				If ( lConsLoja )
					cChave := cA100For+CLOJA
				Else
					cChave := cA100For
				EndIf
				MsSeek(xFilEnt(xFilial("SC7"))+cChave,.T.)
				#IFDEF TOP
				Endif
				#ENDIF
			Do While If(lQuery, ;
					(cAliasSC7)->(!Eof()), ;
					(cAliasSC7)->(!Eof()) .And. xFilEnt(xFilial('SC7'))+cA100For==(cAliasSC7)->C7_FILENT+(cAliasSC7)->C7_FORNECE .And. If(lConsLoja, CLOJA==(cAliasSC7)->C7_LOJA, .T.))

				If lQuery
					('SC7')->(dbGoto((cAliasSC7)->RECSC7))
				EndIf

				lRet103Vpc := .T.

				If lMt103Vpc
					lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
				Endif

				If lRet103Vpc
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o Saldo do Pedido de Compra                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSldPed := ('SC7')->C7_QUANT-('SC7')->C7_QUJE-('SC7')->C7_QTDACLA
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se nao h  residuos, se possui saldo em abto e   ³
					//³ se esta liberado por alcadas se houver controle.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( Empty(('SC7')->C7_RESIDUO) .And. nSldPed > 0 .And.;
							If(SuperGetMV("MV_RESTNFE")=="S",('SC7')->C7_CONAPRO <> "B",.T.).And.;
							('SC7')->C7_TPOP <> "P" )

						If lConsMedic .And. lNfMedic
							nF4For := aScan(aF4For,{|x|x[5]==('SC7')->C7_LOJA .And. x[6]==('SC7')->C7_NUM})							
						Else							
							nF4For := aScan(aF4For,{|x|x[2]==('SC7')->C7_LOJA .And. x[3]==('SC7')->C7_NUM})
						EndIf 							

						If ( nF4For == 0 )

							If lConsMedic .And. lNfMedic
								aConteudos := {.F.,('SC7')->C7_MEDICAO,('SC7')->C7_CONTRA,('SC7')->C7_PLANILHA,('SC7')->C7_LOJA,('SC7')->C7_NUM,DTOC(('SC7')->C7_EMISSAO),If(('SC7')->C7_TIPO==2,'AE', 'PC') }
							Else
								aConteudos := {.F.,('SC7')->C7_LOJA,('SC7')->C7_NUM,DTOC(('SC7')->C7_EMISSAO),If(('SC7')->C7_TIPO==2,'AE', 'PC') }
							EndIf 															

							If lMa103F4I
								If ValType( aUsCont := ExecBlock( "MA103F4I", .F., .F. ) ) == "A"
									AEval( aUsCont, { |x| AAdd( aConteudos, x ) } )
								EndIf
							EndIf

							aAdd(aF4For , aConteudos )
							aAdd(aRecSC7, ('SC7')->(Recno()))
						EndIf
					EndIf
				Endif
				(cAliasSC7)->(dbSkip())
			EndDo

			If ExistBlock("MA103F4L")
				ExecBlock("MA103F4L", .F., .F., { aF4For, aRecSC7 } )
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os dados na Tela                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( !Empty(aF4For) )

				If lConsMedic .And. lNfMedic
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Exibe os campos de medicao do contrato                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					aTitCampos := {" ",RetTitle("C7_MEDICAO"),RetTitle("C7_CONTRA"),RetTitle("C7_PLANILH"),OemToAnsi("Loja"),OemToAnsi("Pedido"),OemToAnsi("Emissao"),OemToAnsi("Origem")} //"Medicao"###"Contrato"###"Planilha"###"Loja"###"Pedido"###"Emissao"###"Origem"
					cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8]"
				Else

					aTitCampos := {" ",OemToAnsi("Loja"),OemToAnsi("Pedido"),OemToAnsi("Emissao"),OemToAnsi("Origem")} //"Loja"###"Pedido"###"Emissao"###"Origem"

					cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5]"

				EndIf 					



				If ExistBlock( "MA103F4H" )
					If ValType( aUsTitu := ExecBlock( "MA103F4H", .F., .F. ) ) == "A"
						nNumCampos := Len(aTitCampos)
						For nLoop := 1 To Len( aUsTitu )
							AAdd( aTitCampos, aUsTitu[ nLoop ] )
							cLine += ",aF4For[oListBox:nAT][" + AllTrim( Str( nLoop + nNumCampos ) ) + "]"
						Next nLoop
					EndIf
				EndIf

				cLine += " } "

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta dinamicamente o bline do CodeBlock                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				bLine := &( "{ || " + cLine + " }" )


				DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi("Selecionar Pedido de Compra - <F5> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra"

				@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
				oPanel:Align := CONTROL_ALIGN_TOP

				oListBox := TWBrowse():New( 27,4,243,86,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
				oListBox:SetArray(aF4For)
				oListBox:bLDblClick := { || aF4For[oListBox:nAt,1] := !aF4For[oListBox:nAt,1] }
				oListBox:bLine := bLine

				oListBox:Align := CONTROL_ALIGN_ALLCLIENT

				@ 6  ,4   SAY OemToAnsi("Fornecedor") Of oPanel PIXEL SIZE 47 ,9 //"Fornecedor"
				@ 4  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oPanel PIXEL SIZE 120,9

				ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)

				Processa({|| a103procPC(aF4For,nOpc,cA100For,cLoja,@lRet103Vpc,@lMt103Vpc,@nSldPed,lUsaFiscal,aGets,( lConsMedic .And. lNfMedic ),aHeadSDE,@aColsSDE,aHeadSEV, aColsSEV)})
                //HF aquiiiiii ver se pega do pedido
				if cPCSol == "N" .and. nPosCC > 0 //HF Pega Pelo Produto e não do Pedido de Compra
					SB1->( dbSetOrder(1) )
	   				For nIa := 1 To len( aCols )
	   					if SB1->( dbSeek( xFilial("SB1") + aCols[nIa][nPosPRD] ) )  //posiciona o bixo
							aCols[nIa][nPosCC] := SB1->B1_CC
						endif
					Next nIa
				endif
			Else
				Help(" ",1,"A103F4")
				//U_MYAVISO("A103F4","Não existem registros relacionados com este item",{"Ok"},2)
			EndIf
		Else
			Help('   ',1,'A103TIPON')
		EndIf
	Else
		Help('   ',1,'A103CAB')
	EndIf

Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integrida dos dados de Entrada                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	DbSelectArea(cAliasSC7)
	dbCloseArea()
	DbSelectArea("SC7")
Endif
SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)

RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aArea)
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³XMLPCF6   ³ Autor ³ Edson Maricate        ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tela de importacao de Pedidos de Compra por Item.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103ItemPC()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XMLPCF6(lUsaFiscal,aPedido,oGetDAtu,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aGets)

Local cSeek			:= ""
Local nOpca			:= 0
Local aArea			:= GetArea()
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSC7		:= SC7->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local aRateio       := {0,0,0}
Local aNew			:= {}
Local aTamCab		:= {}
Local lGspInUseM	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons		:= { {'PESQUISA',{||A103VisuPC(aArrSldo[oQual:nAt][2])},OemToAnsi("Visualiza Pedido"),OemToAnsi("Pedido")},; //"Visualiza Pedido"
	{'pesquisa',{||A103PesqP(aCab,aCampos,aArrayF4,oQual)},OemToAnsi("Pesquisar")} } //"Pesquisar"
Local aEstruSC7		:= SC7->( dbStruct() )
Local bSavSetKey	:= SetKey(VK_F4,Nil)
Local bSavKeyF5		:= SetKey(VK_F5,Nil)
Local bSavKeyF6		:= SetKey(VK_F6,Nil)
Local bSavKeyF7		:= SetKey(VK_F7,Nil)
Local bSavKeyF8		:= SetKey(VK_F8,Nil)
Local bSavKeyF9		:= SetKey(VK_F9,Nil)
Local bSavKeyF10	:= SetKey(VK_F10,Nil)
Local bSavKeyF11	:= SetKey(VK_F11,Nil)
Local nFreeQt		:= 0 
Local nPosPRD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
Local nPosPDD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PEDIDO" })
Local nPosITM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMPC" })
Local nPosQTD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
Local nPosTes       := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nPosQtd2    := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QTSEGUM"})  //HF
Local nPosValor   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})      //HF
Local nPosTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TOTAL"})      //HF
Local nPosCC      := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CC"})         //HF
Local lDivValor   := .F., nValQTD := 0, nValQtd2 := 0, nValValor := 0, nValTotal := 0   //HF
Local nLinACols     := N
Local cVar			:= aCols[n][nPosPrd]
Local cQuery		:= ""
Local cAliasSC7		:= "SC7"
Local cCpoObri		:= ""
Local nSavQual
Local nPed			:= 0
Local nX			:= 0
Local nAuxCNT		:= 0
Local lMt103Vpc		:= ExistBlock("MT103VPC")
Local lMt100C7D		:= ExistBlock("MT100C7D")
Local lMt100C7C		:= ExistBlock("MT100C7C")
Local lMt103Sel		:= ExistBlock("MT103SEL")
Local nMT103Sel     := 0
Local nSelOk        := 1
Local lRet103Vpc	:= .T.
Local lContinua		:= .T.
Local lQuery		:= .F.
Local oQual
Local oDlg
Local oPanel
Local aUsButtons  := {}

PRIVATE aCab	   := {}
PRIVATE aCampos	   := {}
PRIVATE aArrSldo   := {}
PRIVATE aArrayF4   := {}

DEFAULT lUsaFiscal := .T.
DEFAULT aPedido	   := {}
DEFAULT lNfMedic   := .F.
DEFAULT lConsMedic := .F.
DEFAULT aHeadSDE   := {}
DEFAULT aColsSDE   := {}
DEFAULT aGets      := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MTIPCBUT" )
	If ValType( aUsButtons := ExecBlock( "MTIPCBUT", .F., .F. ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
	EndIf
EndIf

If lContinua

	If MaFisFound('NF') .Or. !lUsaFiscal
		If cTipo == 'N'
			#IFDEF TOP
				DbSelectArea("SC7")
				If TcSrvType() <> "AS/400"

					If Empty(cVar)
						DbSetOrder(9)
					Else
						DbSetOrder(6)
					EndIf

					lQuery    := .T.
					cAliasSC7 := "QRYSC7"

					cQuery	  := "SELECT "
					For nAuxCNT := 1 To Len( aEstruSC7 )
						If nAuxCNT > 1
							cQuery += ", "
						EndIf
						cQuery += aEstruSC7[ nAuxCNT, 1 ]
					Next
					cQuery += ", R_E_C_N_O_ RECSC7 FROM"
					cQuery += RetSqlName("SC7") + " SC7 "
					cQuery += "WHERE "
					cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "

					If HasTemplate( "DRO" ) .AND. FunName() == "MATA103" .AND. MV_PAR15 == 1
						cQuery += "C7_FORNECE IN ( " + T_DrogForn( cA100For ) + " ) AND "
					Else
					If Empty(cVar)
						If lConsLoja
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_LOJA = '"+cLoja+"' AND "
						Else
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
						Endif	
					Else
						If lConsLoja
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_LOJA = '"+cLoja+"' AND "
							cQuery += "C7_PRODUTO = '"+cVar+"' AND "
						Else
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_PRODUTO = '"+cVar+"' AND "
						Endif
					Endif
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os pedidos de compras de acordo com os contratos             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If lConsMedic
						If lNfMedic
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Traz apenas os pedidos oriundos de medicoes                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery += "C7_CONTRA<>'"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO<>'" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Traz apenas os pedidos que nao possuem medicoes                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery += "C7_CONTRA='"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO='" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		
						EndIf
					EndIf 					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os Pedidos Bloqueados e Previstos.                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery += "C7_TPOP <> 'P' AND "
					If SuperGetMV("MV_RESTNFE") == "S"
						cQuery += "C7_CONAPRO <> 'B' AND "
					EndIf					
					cQuery += "SC7.C7_ENCER='"+Space(Len(SC7->C7_ENCER))+"' AND "					
					cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "					

					cQuery += "SC7.D_E_L_E_T_ = ' '"
					cQuery += "ORDER BY "+SqlOrder(SC7->(IndexKey()))	

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
					For nX := 1 To Len(aEstruSC7)
						If aEstruSC7[nX,2]<>"C"
							TcSetField(cAliasSC7,aEstruSC7[nX,1],aEstruSC7[nX,2],aEstruSC7[nX,3],aEstruSC7[nX,4])
						EndIf
					Next nX										
				Else
			#ENDIF			
				If Empty(cVar)
					DbSelectArea("SC7")
					DbSetOrder(9)
					If lConsLoja
						cCond := "C7_FILENT+C7_FORNECE+C7_LOJA"
						cSeek := cA100For+cLoja
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					Else
						cCond := "C7_FILENT+C7_FORNECE"
						cSeek := cA100For
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					EndIf
				Else
					DbSelectArea("SC7")
					DbSetOrder(6)
					If lConsLoja
						cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA"
						cSeek := cVar+cA100For+cLoja
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					Else
						cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE"
						cSeek := cVar+cA100For
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					EndIf
				EndIf
				#IFDEF TOP
				EndIf
				#ENDIF

			If Empty(cVar)
				cCpoObri := "C7_LOJA|C7_PRODUTO|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
			Else
				cCpoObri := "C7_LOJA|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
			Endif				

			If (cAliasSC7)->(!Eof())

				DbSelectArea("SX3")
				DbSetOrder(2)

				If lNfMedic .And. lConsMedic

					MsSeek("C7_MEDICAO")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					MsSeek("C7_CONTRA")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					MsSeek("C7_PLANILH")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

				EndIf 			

				MsSeek("C7_NUM")

				AAdd(aCab,x3Titulo())
				Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
				aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

				DbSelectArea("SX3")
				DbSetOrder(1)
				MsSeek("SC7")
				While !Eof() .And. SX3->X3_ARQUIVO == "SC7"
					IF ( SX3->X3_BROWSE=="S".And.X3Uso(SX3->X3_USADO).And. AllTrim(SX3->X3_CAMPO)<>"C7_PRODUTO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_NUM" .And.;
							If( lConsMedic .And. lNfMedic, AllTrim(SX3->X3_CAMPO)<>"C7_MEDICAO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_CONTRA" .And. AllTrim(SX3->X3_CAMPO)<>"C7_PLANILH", .T. )).Or.;
							(AllTrim(SX3->X3_CAMPO) $ cCpoObri)
						AAdd(aCab,x3Titulo())
						Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
						aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
					EndIf
					dbSkip()		
				Enddo					

				DbSelectArea(cAliasSC7)
				Do While If(lQuery, ;
						(cAliasSC7)->(!Eof()), ;
						(cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial)+cSeek == &(cCond))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os Pedidos Bloqueados, Previstos e Eliminados por residuo   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lQuery
						If (SuperGetMV("MV_RESTNFE") == "S" .And. (cAliasSC7)->C7_CONAPRO == "B") .Or. ;
								(cAliasSC7)->C7_TPOP == "P" .Or. !Empty((cAliasSC7)->C7_RESIDUO)
							dbSkip()
							Loop
						EndIf
					Endif

					nFreeQT := 0

					nPed    := aScan(aPedido,{|x| x[1] = (cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM})

					nFreeQT -= If(nPed>0,aPedido[nPed,2],0)

					For nAuxCNT := 1 To Len( aCols )
						If (nAuxCNT # n) .And. ;
							(aCols[ nAuxCNT,nPosPRD ] == (cAliasSC7)->C7_PRODUTO) .And. ;
							(aCols[ nAuxCNT,nPosPDD ] == (cAliasSC7)->C7_NUM) .And. ;
							(aCols[ nAuxCNT,nPosITM ] == (cAliasSC7)->C7_ITEM) .And. ;
							!ATail( aCols[ nAuxCNT ] )
							nFreeQT += aCols[ nAuxCNT,nPosQTD ]
						EndIf
					Next
					
					lRet103Vpc := .T.

					If lMt103Vpc
						If lQuery
							('SC7')->(dbGoto((cAliasSC7)->RECSC7))
						EndIf															
						lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
					Endif

					If lRet103Vpc
						If ((nFreeQT := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA-nFreeQT)) > 0)
							Aadd(aArrayF4,Array(Len(aCampos)))							

							SB1->(DbSetOrder(1))
							SB1->(MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO))							
							For nX := 1 to Len(aCampos)

								If aCampos[nX][3] != "V"
									If aCampos[nX][2] == "N"
										If Alltrim(aCampos[nX][1]) == "C7_QUANT"
											aArrayF4[Len(aArrayF4)][nX] :=Transform(nFreeQt,PesqPict("SC7",aCampos[nX][1]))
										ElseIf Alltrim(aCampos[nX][1]) == "C7_QTSEGUM"
											aArrayF4[Len(aArrayF4)][nX] :=Transform(ConvUm(SB1->B1_COD,nFreeQt,nFreeQt,2),PesqPict("SC7",aCampos[nX][1]))
										Else
											aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
										Endif											
									Else
										aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))								
									Endif	
								Else
									aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
									If Alltrim(aCampos[nX][1]) == "C7_CODGRP"
										aArrayF4[Len(aArrayF4)][nX] := SB1->B1_GRUPO                            									
									EndIf
									If Alltrim(aCampos[nX][1]) == "C7_CODITE"
										aArrayF4[Len(aArrayF4)][nX] := SB1->B1_CODITE
									EndIf
								Endif

							Next

							aAdd(aArrSldo, {nFreeQT, IIF(lQuery,(cAliasSC7)->RECSC7,(cAliasSC7)->(RecNo()))})

							If lMT100C7D
								If lQuery
									('SC7')->(dbGoto((cAliasSC7)->RECSC7))
								EndIf									
								aNew := ExecBlock("MT100C7D", .f., .f., aArrayF4[Len(aArrayF4)])
								If ValType(aNew) = "A"
									aArrayF4[Len(aArrayF4)] := aNew
								EndIf
							EndIf
						EndIf
					Endif
					(cAliasSC7)->(dbSkip())
				EndDo

				If ExistBlock("MT100C7L")
					ExecBlock("MT100C7L", .F., .F., { aArrayF4, aArrSldo })
				EndIf

				If !Empty(aArrayF4)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Monta dinamicamente o bline do CodeBlock                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DEFINE MSDIALOG oDlg FROM 30,20  TO 265,521 TITLE OemToAnsi("Selecionar Pedido de Compra ( por item ) - <F6> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra ( por item )"

					If lMT100C7C
						aNew := ExecBlock("MT100C7C", .f., .f., aCab)
						If ValType(aNew) == "A"
							aCab := aNew      
							    
							DbSelectArea("SX3")
			 				DbSetOrder(2)								
							
							For nX := 1 to Len(aCab)
						    	If aScan(aCampos,{|x| x[1]= aCab[nX]})==0
        						 If SX3->(MsSeek(aCab[nX]))				
        						 		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
        						 EndIf
   								EndIf
							Next nX
							
							
						EndIf
					EndIf

					@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
					oPanel:Align := CONTROL_ALIGN_TOP

					oQual := TWBrowse():New( 29,4,243,85,,aCab,aTamCab,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oQual:SetArray(aArrayF4)
					oQual:bLine := { || aArrayF4[oQual:nAT] }
					OQual:nFreeze := 1 

					oQual:Align := CONTROL_ALIGN_ALLCLIENT

					If !Empty(cVar)
						@ 6  ,4   SAY OemToAnsi("Produto") Of oPanel PIXEL SIZE 47 ,9 //"Produto"
						@ 4  ,30  MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oPanel PIXEL SIZE 80,9
					Else
						@ 6  ,4   SAY OemToAnsi("Selecione o Pedido de Compra") Of oPanel PIXEL SIZE 120 ,9 //"Selecione o Pedido de Compra"
					EndIf

					ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nSavQual:=oQual:nAT,nOpca:=1,oDlg:End()},{||oDlg:End()},,aButtons)
					
				  	If lMt103Sel .And. !Empty(nSavQual)		
				   		nOpca := If(ValType(nMT103Sel:=ExecBlock("MT103SEL",.F.,.F.,{aArrSldo[nSavQual][2]}))=='N',nMT103Sel,nOpca)
				   	Endif     
					If nOpca == 1
						DbSelectArea("SC7")
						MsGoto(aArrSldo[nSavQual][2])
						
   				        // Verifica se o Produto existe Cadastrado na Filial de Entrada
					    DbSelectArea("SB1")
						DbSetOrder(1)
						MsSeek(xFilial("SB1")+SC7->C7_PRODUTO)
						If !Eof()
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Qdo digitado o produto no aCols para buscar o PC via F6 e carregado uma TES vinda do  ³
							//³ SB1 se esta for igual a TES digitada no PC o recalculo dos impostos nao e acionado    ³
							//³ na matxfis,para forcar o recalculo o TES do aCols e limpa neste ponto.                ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lUsaFiscal
								aCols[nLinACols][nPosTes] := CriaVar(aHeader[nPosTes][2]) 
								MaFisAlt("IT_TES",aCols[nLinACols][nPosTes],nLinACols)
                            EndIf
                            
							If	!ATail( aCols[ n ] )
								nValQTD := aCols[nLinACols][nPosQTD]     //HF
								nValQtd2 := aCols[nLinACols][nPosQtd2]   //HF
								nValValor := aCols[nLinACols][nPosValor] //HF
								nValTotal := aCols[nLinACols][nPosTotal] //HF

								NfePC2Acol(aArrSldo[nSavQual][2],n,aArrSldo[nSavQual][1],,,@aRateio,aHeadSDE,@aColsSDE)

								if cPCSol == "N"  //HF Pega Pelo Produto e não do Pedido de Compra
									aCols[nLinACols][nPosCC] := SB1->B1_CC  //HF já esta posicionado.
								endif
								if AllTrim(GetNewPar("XM_PED_PRE","N")) == "N" 
									if nValQTD <> aCols[nLinACols][nPosQTD] .And. nValQTD > 0 //HF
										aCols[nLinACols][nPosQTD] := nValQTD
									EndIf
									If nValQtd2 <> aCols[nLinACols][nPosQtd2] .And. nValQtd2 > 0 //HF
										aCols[nLinACols][nPosQtd2] := nValQtd2
									Endif
									if nValValor <> aCols[nLinACols][nPosValor] //HF
										lDivValor := .T.
											U_MYAVISO("Atenção","Valor Unitário não bate "+CRLF+;
										          "XML   "+Transform( nValValor, "99,999,999,999.99" )+CRLF+;
										          "Pedido"+Transform( aCols[nLinACols][nPosValor], "99,999,999,999.99" ), { "OK" },3)
										aCols[nLinACols][nPosValor] := nValValor
									EndIf
									if nValTotal <> aCols[nLinACols][nPosTotal] //HF
										aCols[nLinACols][nPosTotal] := nValTotal
									endif
								endif

	        				Else
								NfePC2Acol(aArrSldo[nSavQual][2],n+1,aArrSldo[nSavQual][1],,,@aRateio,aHeadSDE,@aColsSDE)
	        				EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Impede que o item do PC seja deletado pela getdados da NFE na movimentacao das setas. ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If ValType( oGetDAtu ) == "O"
								oGetDAtu:lNewLine := .F.
							Else
								If Type( "oGetDados" ) == "O"
									oGetDados:lNewLine:=.F.
								EndIf
							EndIf
						Else
  						   Aviso("XMLPCF6","O Produto selecionado do Pedido de compra, não possui cadastro na Filial de Entrada da Nota Fiscal. Favor efetuar cadastro !",{"Ok"})
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Rateio do valores de Frete/Seguro/Despesa do PC            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaFiscal
						Eval(bRefresh)
					Else
						if .Not. lTemSegXml
							aGets[SEGURO] += aRateio[1]
						endif
						if .Not. lTemDesXml
							aGets[VALDESP]+= aRateio[2]
						endif
						if .Not. lTemFreXml
							aGets[FRETE]  += aRateio[3]
						endif
					EndIf
				Else
					Help(" ",1,"A103F4")
				EndIf
			Else
				Help(" ",1,"A103F4")
			EndIf
		Else
			Help('   ',1,'A103TIPON')
		EndIf
	Else
		Help('   ',1,'A103CAB')
	EndIf

Endif

If lQuery
	DbSelectArea(cAliasSC7)
	dbCloseArea()
	DbSelectArea("SC7")
Endif	

SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aAreaSB1)
RestArea(aArea)   
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetVerIX  ºAutor  ³Roberto Souza       º Data ³  01/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a versão e compilação.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GetverIX()
Local aRet := {}
Local oWs
Local cVerImpTss := "" 
Local cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf
If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWs := WSHFXMLMANIFESTO():New()
oWs:cCCURL := cURL
if oWs:HFTSSVERSAO()
	cVerImpTss := oWs:cHFTSSVERSAORESULT
endif

Aadd(aRet,{"Versão"     ,"2.32"       })
Aadd(aRet,{"Compilação" ,"20150619_A" })
Aadd(aRet,{"Data"       ,"19/06/2015" })
Aadd(aRet,{"FTP"        ,"ftp://"     })
Aadd(aRet,{"TSSIMPXML"  ,cVerImpTss   })

Return(aRet)



User FUnction XMLDEBUG()

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "COM" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"

Private lRet     := .F.                     
Private ny       := 0                     
Private aFiles   := {}
Private cDir     := AllTrim(GetNewPar("MV_X_PATHX"," "))                     
Private lDirCnpj := AllTrim(GetNewPar("XM_DIRCNPJ","N")) == "S"                     
Private lDirFil  := AllTrim(GetNewPar("XM_DIRFIL" ,"N")) == "S" 
Private lDirMod  := AllTrim(GetNewPar("XM_DIRMOD" ,"N")) == "S"                     
Private cDirDest := AllTrim(cDir+"\Importados\")                     
Private cDirRej  := AllTrim(cDir+"\Rejeitados\")                     
Private cDrive   := "" 
Private cPath    := ""  
Private cNewFile := ""
Private cExt     := ""                        
Private lCopy    := .F.
Private nErase   := 0 
Private cFilXml  := ""
Private cKeyXml  := ""
Private lOnline  := .F.
Private cInfo    := ""
Private cErroR   := ""
Private cErroProc:= ""
Private cMsg     := ""
Private cOcorr   := ""
Private cPref    := ""  
Private aPref    := {"CTE","NFE"} 
Private oXml     := Nil  


	cXml := MemoRead("X:\TOTVS\P10\Protheus_data\xmlsource\42130460333267000122550010000275141002249733.xml")
	
	nTamFile := Len(cXml)
	
	If nTamFile > 65535
		Conout(nTamFile)
oXml:=XmlParserFile("\Protheus_data\xmlsource\42130460333267000122550010000275141002249733.xml","_", @cError, @cWarning )		
	Else
		Conout(nTamFile)
			
	EndIf

Return()


Static Function ErNfOri( aDetCte )
Local lRet := .T.
Local cTit1 := ""

Private cInfo := ""

cTit1 := "Avisos - NF e Série de Origem do CTE"

if lRet
	//Produto com probela de valores, devido modificação pelo ponto de Entrada
	If !Empty(aDetCte)

		DEFINE MSDIALOG oDlg TITLE cTit1 FROM 000,000 TO 550,650 PIXEL

		if lNfOri
			@ 010,010 Say "Itens com NF e SERIE de Origem divergentes (Volte e Utilize F7 para consultar Notas do Fornecedor):" PIXEL OF oDlg COLOR CLR_RED FONT oFont01
		else
			@ 010,010 Say "Itens com NF e SERIE de Origem divergentes (Volte e Utilize F7 para consultar Notas da Transportadora):" PIXEL OF oDlg COLOR CLR_RED FONT oFont01
		endif
		@ 020,010 LISTBOX oLbx2 FIELDS HEADER ;
		   "NF/Serie", "Divergencia" ;
		   SIZE 310,230 OF oDlg PIXEL

		oLbx2:SetArray( aDetCte )
		oLbx2:bLine := {|| {aDetCte[oLbx2:nAt,1],;
		     	            aDetCte[oLbx2:nAt,2] }}

		@ 025.2,040 BUTTON "VOLTAR E ALTERAR" SIZE 75,15 OF oDlg Action ( lRet := .F., oDlg:End() )
		@ 025.2,059 BUTTON "CONTINUAR ASSIM MESMO" SIZE 85,15 OF oDlg Action ( lRet := .T., oDlg:End() )

		ACTIVATE MSDIALOG oDlg CENTER
	EndIf
Endif

Return lRet



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Sf3NfOri  ³ Autor ³ Orelha Seca           ³ Data ³07.02.2141 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Interface de visualizacao dos documentos de entrada/saida    ³±±
±±³          ³para devolucao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome da rotina chamadora                              ³±±
±±³          ³ExpN2: Numero da linha da rotina chamadora              (OPC)³±±
±±³          ³ExpC4: Nome do campo GET em foco no momento             (OPC)³±±
±±³          ³ExpC5: Codigo do Cliente/Fornecedor                          ³±±
±±³          ³ExpC6: Loja do Cliente/Fornecedor                            ³±±
±±³          ³ExpC7: Codigo do Produto                                     ³±±
±±³          ³ExpC8: Local a ser considerado                               ³±±
±±³          ³ExpN9: Numero do recno do SD1/SD2                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo atualizar os eventos vinculados³±±
±±³          ³a uma solicitacao de compra:                                 ³±±
±±³          ³A) Atualizacao das tabelas complementares.                   ³±±
±±³          ³B) Atualizacao das informacoes complementares a SC           ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Sf3NfOri(cReadVar,cFornec)

Local aArea     := GetArea()
Local aAreaSF3  := SF3->(GetArea())
Local aStruTRB  := {}
Local aStruSF3  := {}
Local aOrdem    := {AllTrim(RetTitle("F3_NFISCAL"))+"+"+AllTrim(RetTitle("F3_SERIE")),AllTrim(RetTitle("F3_EMISSAO"))}
Local aChave    := {}
Local aPesq     := {}
Local aNomInd   := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aSize     := MsAdvSize( .F. )
Local aHeadTRB  := {}
Local aSavHead  := aClone(aHeader)
Local cAliasSF3 := "SF3"
Local cAliasTRB := "CTENFORI"
Local cNomeTrb  := ""
Local cQuery    := ""
Local cCombo    := ""
Local cTexto1   := ""
Local cTexto2   := ""
Local lQuery    := .F.
Local lRetorno  := .F.
Local lSkip     := .F.
Local nX        := 0
Local nY        := 0
Local nSldQtd   := 0
Local nSldQtd2  := 0
Local nSldLiq   := 0
Local nSldBru   := 0
Local nHdl      := GetFocus()
Local nOpcA     := 0
Local nPNfOri   := 0
Local nPSerOri  := 0
Local nPItemOri := 0
Local nPLocal   := 0
Local nPPrUnit  := 0
Local nPPrcVen  := 0
Local nPQuant   := 0
Local nPQuant2UM:= 0
Local nPLoteCtl := 0
Local nPNumLote := 0
Local nPDtValid := 0
Local nPPotenc  := 0
Local nPValor   := 0
Local nPValDesc := 0
Local nPDesc    := 0
Local nPOrigem  := 0
Local nPDespacho:= 0
Local nPTES     := 0
Local nPProvEnt := 0
Local xPesq     := ""
Local oDlg
Local oCombo
Local oGet
Local oGetDb
Local oPanel
Local cFiltraQry:=""
Local lFiltraQry:=.F.

DEFAULT cReadVar := ReadVar()

PRIVATE aRotina  := {}

For nX := 1 To 11	// Walk_Thru
	aAdd(aRotina,{"","",0,0})
Next

If "_NFORI"$cReadVar
			aChave    := {"F3_NFISCAL+F3_SERIE","F3_EMISSAO"}
			aPesq     := {{Space(Len(SF3->F3_NFISCAL+SF3->F3_SERIE)),"@!"},{Ctod(""),"@!"}}
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Montagem do arquivo temporario                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SX3")
			dbSetOrder(1)
			MsSeek("SF3")
			While !Eof() .And. SX3->X3_ARQUIVO == "SF3"
				If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And.;
					SX3->X3_CONTEXT <> "V"  .And.;
					SX3->X3_TIPO<>"M" ) .Or.;
					Trim(SX3->X3_CAMPO) == "F3_NFISCAL" .Or.;
					Trim(SX3->X3_CAMPO) == "F3_SERIE"  .Or.;
					Trim(SX3->X3_CAMPO) == "F3_EMISSAO" .Or.;
					Trim(SX3->X3_CAMPO) == "F3_TIPO" .Or.;
					Trim(SX3->X3_CAMPO) == "F3_CLIEFOR" .Or. ;
					Trim(SX3->X3_CAMPO) == "F3_LOJA"
					Aadd(aHeadTrb,{ TRIM(X3Titulo()),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT,;
						IIf(AllTrim(SX3->X3_CAMPO)$"F3_NFISCAL#F3_SERIE#F3_TIPO","00",SX3->X3_ORDEM) })
					aadd(aStruTRB,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,IIf(AllTrim(SX3->X3_CAMPO)$"F3_NFISCAL#F3_SERIE","00",SX3->X3_ORDEM)})
				EndIf
				dbSelectArea("SX3")
				dbSkip()
			EndDo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Walk-Thru                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			ADHeadRec("SF3",aHeadTrb)
			aSize(aHeadTrb[Len(aHeadTrb)-1],11)
			aSize(aHeadTrb[Len(aHeadTrb)],11)
			aHeadTrb[Len(aHeadTrb)-1,11] := "ZX"
			aHeadTrb[Len(aHeadTrb),11]	 := "ZY"
			aadd(aStruTRB,{"F3_ALI_WT","C",3,0,"ZX"})
			aadd(aStruTRB,{"F3_REC_WT","N",18,0,"ZY"})

			aadd(aStruTRB,{"F3_TOTAL2","N",18,2,"ZZ"})
			aHeadTrb := aSort(aHeadTrb,,,{|x,y| x[11] < y[11]})
			aStruTrb := aSort(aStruTrb,,,{|x,y| x[05] < y[05]})
			cNomeTrb := CriaTrab(aStruTRB,.T.)
			dbUseArea(.T.,__LocalDrive,cNomeTrb,cAliasTRB,.F.,.F.)
			dbSelectArea(cAliasTRB)
			For nX := 1 To Len(aChave)
				aadd(aNomInd,SubStr(cNomeTrb,1,7)+chr(64+nX))
				IndRegua(cAliasTRB,aNomInd[nX],aChave[nX])
			Next nX
			dbClearIndex()
			For nX := 1 To Len(aNomInd)
				dbSetIndex(aNomInd[nX])
			Next nX
			dbSelectArea("SF3")
			dbSetOrder(2)
			#IFDEF TOP
				lQuery    := .T.
			    cAliasSF3 := "CTENFORI_SQL"
			    aStruSF3 := SF3->(dbStruct())
				cQuery := "SELECT SF3.F3_FILIAL"
				For nX := 1 To Len(aStruTRB)
					If !"F3_REC_WT"$aStruTRB[nX][1] .And. !"F3_ALI_WT"$aStruTRB[nX][1] .And. !"F3_TOTAL2"$aStruTRB[nX][1]
						cQuery += ","+aStruTRB[nX][1]
					EndIf
				Next nX
				cQuery += " FROM "+RetSqlName("SF3")+" SF3 "
				cQuery += "WHERE "
				cQuery += "SF3.F3_FILIAL = '"+xFilial("SF3")+"' AND "
				If .Not. Empty(cFornec)
					cQuery += "SF3.F3_CLIEFOR||SF3.F3_LOJA in ("+cFornec+") AND "   //AQUI ORACLE, VER o SQL
				Else
					//cQuery += "SF3.F3_CLIEFOR+SF3.F3_LOJA = '"+cFornec+"' AND "
				EndIF
				cQuery += "SF3.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY F3_NFISCAL,F3_SERIE "//+SqlOrder(SF3->(IndexKey())) //Para não dar pobrema no rrefrexe

				cQuery := ChangeQuery(cQuery)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)

				For nX := 1 To Len(aStruSF3)
					If aStruSF3[nX][2] <> "C" .And. FieldPos(aStruSF3[nX][1])<>0
						TcSetField(cAliasSF3,aStruSF3[nX][1],aStruSF3[nX][2],aStruSF3[nX][3],aStruSF3[nX][4])
					EndIf
				Next nX
				(cAliasSF3)->(dbGoTop())
			#ELSE
				MsSeek(xFilial("SF3"),.F.)
			#ENDIF
			While !Eof() .And. (cAliasSF3)->F3_FILIAL = xFilial("SF3")
					RecLock(cAliasTRB,.T.)
					For nX := 1 To Len(aStruTRB)
						If (cAliasSF3)->(FieldPos(aStruTRB[nX][1]))<>0
							(cAliasTRB)->(FieldPut(nX,(cAliasSF3)->(FieldGet(FieldPos(aStruTRB[nX][1])))))
						EndIf
					Next nX
					(cAliasTRB)->F3_ALI_WT := "SF3"
					MsUnLock()
				dbSelectArea(cAliasSF3)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cAliasSF3)
				dbCloseArea()
				dbSelectArea("SF3")
			EndIf

	If (cAliasTRB)->(LastRec())<>0
		PRIVATE aHeader := aHeadTRB
		xPesq := aPesq[(cAliasTRB)->(IndexOrd())][1]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona registros                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+Substr(cFornec,2,8))

		dbSelectArea(cAliasTRB)
		dbGotop()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula as coordenadas da interface                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize[1] /= 1.5
		aSize[2] /= 1.5
		aSize[3] /= 1.5
		aSize[4] /= 1.3
		aSize[5] /= 1.5
		aSize[6] /= 1.3
		aSize[7] /= 1.5
		
		AAdd( aObjects, { 100, 020,.T.,.F.,.T.} )
		AAdd( aObjects, { 100, 060,.T.,.T.} )
		AAdd( aObjects, { 100, 020,.T.,.F.} )
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
		aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Interface com o usuario                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Notas Fiscais Entrada de Origem") FROM aSize[7],000 TO aSize[6],aSize[5] OF oMainWnd PIXEL
		@ aPosObj[1,1],aPosObj[1,2] MSPANEL oPanel PROMPT "" SIZE aPosObj[1,3],aPosObj[1,4] OF oDlg CENTERED LOWERED
		cTexto1 := AllTrim(RetTitle("F3_CLIEFOR"))+": "+SA2->A2_COD+"-"+SA2->A2_LOJA+"  -  "+RetTitle("A2_NOME")+": "+SA2->A2_NOME
		@ 002,005 SAY cTexto1 SIZE aPosObj[1,3],008 OF oPanel PIXEL
		cTexto2 := ""
		@ 012,005 SAY cTexto2 SIZE aPosObj[1,3],008 OF oPanel PIXEL	

		@ aPosObj[3,1]+00,aPosObj[3,2]+00 SAY OemToAnsi("Pesquisar por:") PIXEL //Pesquisar por:
		@ aPosObj[3,1]+12,aPosObj[3,2]+00 SAY OemToAnsi("Localizar") PIXEL //Localizar
		@ aPosObj[3,1]+00,aPosObj[3,2]+40 MSCOMBOBOX oCombo VAR cCombo ITEMS aOrdem SIZE 100,044 OF oDlg PIXEL ;
		VALID ((cAliasTRB)->(dbSetOrder(oCombo:nAt)),(cAliasTRB)->(dbGotop()),xPesq := aPesq[(cAliasTRB)->(IndexOrd())][1],.T.)
	  	@ aPosObj[3,1]+12,aPosObj[3,2]+40 MSGET oGet VAR xPesq Of oDlg PICTURE aPesq[(cAliasTRB)->(IndexOrd())][2] PIXEL ;
	  	VALID ((cAliasTRB)->(MsSeek(Iif(ValType(xPesq)=="C",AllTrim(xPesq),xPesq),.T.)),.T.).And.IIf(oGetDb:oBrowse:Refresh()==Nil,.T.,.T.)

	  	oGetDb := MsGetDB():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],1,"Allwaystrue","allwaystrue","",.F., , ,.F., ,cAliasTRB)

		DEFINE SBUTTON FROM aPosObj[3,1]+000,aPosObj[3,4]-030 TYPE 1 ACTION (nOpcA := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM aPosObj[3,1]+012,aPosObj[3,4]-030 TYPE 2 ACTION (nOpcA := 0,oDlg:End()) ENABLE OF oDlg
		oGetDb:oBrowse:Refresh()
		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpcA == 1
			lRetorno := .T.
			aHeader   := aClone(aSavHead)
 			nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"})
 			nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_SERIORI"})

 			If nPNfOri <> 0
 				aCols[N][nPNfOri] := (cAliasTRB)->F3_NFISCAL
 			EndIf
 			If nPSerOri <> 0
 				aCols[N][nPSerOri] := (cAliasTRB)->F3_SERIE
 			EndIf
 			if len(aCnpRem) >= N
 				aCnpRem[N] := SA2->A2_CGC
 			endif
			&(cReadVar) := (cAliasTRB)->F3_NFISCAL
		EndIf
	Else
		U_MyAviso("Atenção","Não existem Notas Emitidas com este Fornecedor!"+CRLF +"Fornecedor :"+cFornec,{"OK"},3)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a integridade da rotina                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasTRB)
	dbCloseArea()
EndIf
dbSelectArea("SA2")

RestArea(aAreaSF3)
RestArea(aArea)
SetFocus(nHdl)
Return(lRetorno)




/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CteNfOri  ³ Autor ³ Orelha Seca           ³ Data ³07.02.2141 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Interface de visualizacao dos documentos de entrada/saida    ³±±
±±³          ³para devolucao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome da rotina chamadora                              ³±±
±±³          ³ExpN2: Numero da linha da rotina chamadora              (OPC)³±±
±±³          ³ExpC4: Nome do campo GET em foco no momento             (OPC)³±±
±±³          ³ExpC5: Codigo do Cliente/Fornecedor                          ³±±
±±³          ³ExpC6: Loja do Cliente/Fornecedor                            ³±±
±±³          ³ExpC7: Codigo do Produto                                     ³±±
±±³          ³ExpC8: Local a ser considerado                               ³±±
±±³          ³ExpN9: Numero do recno do SD1/SD2                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo atualizar os eventos vinculados³±±
±±³          ³a uma solicitacao de compra:                                 ³±±
±±³          ³A) Atualizacao das tabelas complementares.                   ³±±
±±³          ³B) Atualizacao das informacoes complementares a SC           ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CteNfOri(cReadVar,cTransp)

Local aArea     := GetArea()
Local aAreaSF1  := SF1->(GetArea())
Local aAreaSF2  := SF2->(GetArea())
Local aStruTRB  := {}
Local aStruSF2  := {}
Local aOrdem    := {AllTrim(RetTitle("F2_DOC"))+"+"+AllTrim(RetTitle("F2_SERIE")),AllTrim(RetTitle("F2_EMISSAO"))}
Local aChave    := {}
Local aPesq     := {}
Local aNomInd   := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aSize     := MsAdvSize( .F. )
Local aHeadTRB  := {}
Local aSavHead  := aClone(aHeader)
Local cAliasSF1 := "SF1"
Local cAliasSF2 := "SF2"
Local cAliasTRB := "CTENFORI"
Local cNomeTrb  := ""
Local cQuery    := ""
Local cCombo    := ""
Local cTexto1   := ""
Local cTexto2   := ""
Local lQuery    := .F.
Local lRetorno  := .F.
Local lSkip     := .F.
Local nX        := 0
Local nY        := 0
Local nSldQtd   := 0
Local nSldQtd2  := 0
Local nSldLiq   := 0
Local nSldBru   := 0
Local nHdl      := GetFocus()
Local nOpcA     := 0
Local nPNfOri   := 0
Local nPSerOri  := 0
Local nPItemOri := 0
Local nPLocal   := 0
Local nPPrUnit  := 0
Local nPPrcVen  := 0
Local nPQuant   := 0
Local nPQuant2UM:= 0
Local nPLoteCtl := 0
Local nPNumLote := 0
Local nPDtValid := 0
Local nPPotenc  := 0
Local nPValor   := 0
Local nPValDesc := 0
Local nPDesc    := 0
Local nPOrigem  := 0
Local nPDespacho:= 0
Local nPTES     := 0
Local nPProvEnt := 0
Local xPesq     := ""
Local oDlg
Local oCombo
Local oGet
Local oGetDb
Local oPanel
Local cFiltraQry:=""
Local lFiltraQry:=.F.

DEFAULT cReadVar := ReadVar()

PRIVATE aRotina  := {}

For nX := 1 To 11	// Walk_Thru
	aAdd(aRotina,{"","",0,0})
Next

If "_NFORI"$cReadVar
			aChave    := {"F2_DOC+F2_SERIE","F2_EMISSAO"}
			aPesq     := {{Space(Len(SF2->F2_DOC+SF2->F2_SERIE)),"@!"},{Ctod(""),"@!"}}
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Montagem do arquivo temporario                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SX3")
			dbSetOrder(1)
			MsSeek("SF2")
			While !Eof() .And. SX3->X3_ARQUIVO == "SF2"
				If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And.;
					SX3->X3_CONTEXT <> "V"  .And.;
					SX3->X3_TIPO<>"M" ) .Or.;
					Trim(SX3->X3_CAMPO) == "F2_DOC" .Or.;
					Trim(SX3->X3_CAMPO) == "F2_SERIE"  .Or.;
					Trim(SX3->X3_CAMPO) == "F2_EMISSAO" .Or.;
					Trim(SX3->X3_CAMPO) == "F2_TIPO" .Or.;
					Trim(SX3->X3_CAMPO) == "F2_TRANSP" .Or. ;
					Trim(SX3->X3_CAMPO) == "F2_CLIENTE" .Or. ;
					Trim(SX3->X3_CAMPO) == "F2_LOJA"
					Aadd(aHeadTrb,{ TRIM(X3Titulo()),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT,;
						IIf(AllTrim(SX3->X3_CAMPO)$"F2_DOC#F2_SERIE#F2_TIPO","00",SX3->X3_ORDEM) })
					aadd(aStruTRB,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,IIf(AllTrim(SX3->X3_CAMPO)$"F2_DOC#F2_SERIE","00",SX3->X3_ORDEM)})
				EndIf
				dbSelectArea("SX3")
				dbSkip()
			EndDo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Walk-Thru                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			ADHeadRec("SF2",aHeadTrb)
			aSize(aHeadTrb[Len(aHeadTrb)-1],11)
			aSize(aHeadTrb[Len(aHeadTrb)],11)
			aHeadTrb[Len(aHeadTrb)-1,11] := "ZX"
			aHeadTrb[Len(aHeadTrb),11]	 := "ZY"
			aadd(aStruTRB,{"F2_ALI_WT","C",3,0,"ZX"})
			aadd(aStruTRB,{"F2_REC_WT","N",18,0,"ZY"})

			aadd(aStruTRB,{"F2_TOTAL2","N",18,2,"ZZ"})
			aHeadTrb := aSort(aHeadTrb,,,{|x,y| x[11] < y[11]})
			aStruTrb := aSort(aStruTrb,,,{|x,y| x[05] < y[05]})
			cNomeTrb := CriaTrab(aStruTRB,.T.)
			dbUseArea(.T.,__LocalDrive,cNomeTrb,cAliasTRB,.F.,.F.)
			dbSelectArea(cAliasTRB)
			For nX := 1 To Len(aChave)
				aadd(aNomInd,SubStr(cNomeTrb,1,7)+chr(64+nX))
				IndRegua(cAliasTRB,aNomInd[nX],aChave[nX])
			Next nX
			dbClearIndex()
			For nX := 1 To Len(aNomInd)
				dbSetIndex(aNomInd[nX])
			Next nX
			dbSelectArea("SF2")
			dbSetOrder(2)
			#IFDEF TOP
				lQuery    := .T.
			    cAliasSF2 := "CTENFORI_SQL"
			    aStruSF2 := SF2->(dbStruct())
				cQuery := "SELECT SF2.F2_FILIAL"
				For nX := 1 To Len(aStruTRB)
					If !"F2_REC_WT"$aStruTRB[nX][1] .And. !"F2_ALI_WT"$aStruTRB[nX][1] .And. !"F2_TOTAL2"$aStruTRB[nX][1]
						cQuery += ","+aStruTRB[nX][1]
					EndIf
				Next nX
				cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
				cQuery += "WHERE "
				cQuery += "SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND "
				If .Not. Empty(cTransp)
					cQuery += "SF2.F2_TRANSP in ("+cTransp+") AND "
				Else
					//cQuery += "SF2.F2_TRANSP = '"+cTransp+"' AND "
				EndIF
				cQuery += "SF2.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SF2->(IndexKey()))

				cQuery := ChangeQuery(cQuery)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2,.T.,.T.)

				For nX := 1 To Len(aStruSF2)
					If aStruSF2[nX][2] <> "C" .And. FieldPos(aStruSF2[nX][1])<>0
						TcSetField(cAliasSF2,aStruSF2[nX][1],aStruSF2[nX][2],aStruSF2[nX][3],aStruSF2[nX][4])
					EndIf
				Next nX
			#ELSE
				MsSeek(xFilial("SF2")+cTransp,.F.)
			#ENDIF
			While !Eof() .And. (cAliasSF2)->F2_FILIAL = xFilial("SF2")
					RecLock(cAliasTRB,.T.)
					For nX := 1 To Len(aStruTRB)
						If (cAliasSF2)->(FieldPos(aStruTRB[nX][1]))<>0
							(cAliasTRB)->(FieldPut(nX,(cAliasSF2)->(FieldGet(FieldPos(aStruTRB[nX][1])))))
						EndIf
					Next nX
					(cAliasTRB)->F2_ALI_WT := "SF2"
					MsUnLock()
				dbSelectArea(cAliasSF2)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cAliasSF2)
				dbCloseArea()
				dbSelectArea("SF2")
			EndIf

	If (cAliasTRB)->(LastRec())<>0
		PRIVATE aHeader := aHeadTRB
		xPesq := aPesq[(cAliasTRB)->(IndexOrd())][1]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona registros                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA4")
		dbSetOrder(1)
		MsSeek(xFilial("SA4")+Substr(cTransp,2,6))

		dbSelectArea(cAliasTRB)
		dbGotop()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula as coordenadas da interface                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize[1] /= 1.5
		aSize[2] /= 1.5
		aSize[3] /= 1.5
		aSize[4] /= 1.3
		aSize[5] /= 1.5
		aSize[6] /= 1.3
		aSize[7] /= 1.5
		
		AAdd( aObjects, { 100, 020,.T.,.F.,.T.} )
		AAdd( aObjects, { 100, 060,.T.,.T.} )
		AAdd( aObjects, { 100, 020,.T.,.F.} )
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
		aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Interface com o usuario                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Notas Fiscais de Origem") FROM aSize[7],000 TO aSize[6],aSize[5] OF oMainWnd PIXEL
		@ aPosObj[1,1],aPosObj[1,2] MSPANEL oPanel PROMPT "" SIZE aPosObj[1,3],aPosObj[1,4] OF oDlg CENTERED LOWERED
		cTexto1 := AllTrim(RetTitle("F2_TRANSP"))+": "+SA4->A4_COD+"  -  "+RetTitle("A4_NOME")+": "+SA4->A4_NOME
		@ 002,005 SAY cTexto1 SIZE aPosObj[1,3],008 OF oPanel PIXEL
		cTexto2 := ""
		@ 012,005 SAY cTexto2 SIZE aPosObj[1,3],008 OF oPanel PIXEL	
		
		@ aPosObj[3,1]+00,aPosObj[3,2]+00 SAY OemToAnsi("Pesquisar por:") PIXEL //Pesquisar por:
		@ aPosObj[3,1]+12,aPosObj[3,2]+00 SAY OemToAnsi("Localizar") PIXEL //Localizar
		@ aPosObj[3,1]+00,aPosObj[3,2]+40 MSCOMBOBOX oCombo VAR cCombo ITEMS aOrdem SIZE 100,044 OF oDlg PIXEL ;
		VALID ((cAliasTRB)->(dbSetOrder(oCombo:nAt)),(cAliasTRB)->(dbGotop()),xPesq := aPesq[(cAliasTRB)->(IndexOrd())][1],.T.)
	  	@ aPosObj[3,1]+12,aPosObj[3,2]+40 MSGET oGet VAR xPesq Of oDlg PICTURE aPesq[(cAliasTRB)->(IndexOrd())][2] PIXEL ;
	  	VALID ((cAliasTRB)->(MsSeek(Iif(ValType(xPesq)=="C",AllTrim(xPesq),xPesq),.T.)),.T.).And.IIf(oGetDb:oBrowse:Refresh()==Nil,.T.,.T.)

	  	oGetDb := MsGetDB():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],1,"Allwaystrue","allwaystrue","",.F., , ,.F., ,cAliasTRB)

		DEFINE SBUTTON FROM aPosObj[3,1]+000,aPosObj[3,4]-030 TYPE 1 ACTION (nOpcA := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM aPosObj[3,1]+012,aPosObj[3,4]-030 TYPE 2 ACTION (nOpcA := 0,oDlg:End()) ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpcA == 1
			lRetorno := .T.
			aHeader   := aClone(aSavHead)
 			nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"})
 			nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_SERIORI"})

 			If nPNfOri <> 0
 				aCols[N][nPNfOri] := (cAliasTRB)->F2_DOC
 			EndIf
 			If nPSerOri <> 0
 				aCols[N][nPSerOri] := (cAliasTRB)->F2_SERIE
 			EndIf
			&(cReadVar) := (cAliasTRB)->F2_DOC
		EndIf
	Else
		U_MyAviso("Atenção","Não existes Notas Emitidas com esta Transportadora!"+CRLF +"Transportadora :"+cTransp,{"OK"},3)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a integridade da rotina                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasTRB)
	dbCloseArea()
EndIf
dbSelectArea("SA1")

RestArea(aAreaSF2)
RestArea(aAreaSF1)
RestArea(aArea)
SetFocus(nHdl)
Return(lRetorno)



//F7 para CTE Notas Fiscais de Origem - Hf - FGVTN
//lNfOri -> vindo como private, se .T. pesquisar SF3, como .F. pesquisar na SF2.
User Function XMLNFOF7()
Local bSavKeyF4 := SetKey(VK_F4,Nil)
Local bSavKeyF5 := SetKey(VK_F5,Nil)
Local bSavKeyF6 := SetKey(VK_F6,Nil)
Local bSavKeyF7 := SetKey(VK_F7,Nil)
Local bSavKeyF8 := SetKey(VK_F8,Nil)
Local bSavKeyF9 := SetKey(VK_F9,Nil)
Local bSavKeyF10:= SetKey(VK_F10,Nil)
Local bSavKeyF11:= SetKey(VK_F11,Nil)
Local lContinua := .T.
Local cTransp   := ""  //para SQL in ('','')
Local aAreaSA4  := SA4->( GetArea() )
Local aAreaSA2  := SA2->( GetArea() )
Local cFilSeek  := Iif(U_IsShared("SA2"),xFilial("SA2"),ZBZ->ZBZ_FILIAL) //para lNfOri
Local cFilSa4   := Iif(U_IsShared("SA4"),xFilial("SA4"),ZBZ->ZBZ_FILIAL) //para .NOT. lNfOri
Local cCnpj     := Space(14)	//para lNfOri
Local oDlgKey					//para lNfOri
Private cCnpjTr := &(cTagDocEmit)         //Hf - FGVTN

if .Not. Empty( cCnpRem )
	cCnpj := cCnpRem
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lNfOri
	//Pede CNPJ do SA2
	DEFINE MSDIALOG oDlgKey TITLE "Consulta CNPJ" FROM 0,0 TO 150,305 PIXEL OF GetWndDefault()

	@ 12,008 SAY "CNPJ para Consultar [F3]-Pesquisa" PIXEL OF oDlgKey
	@ 20,008 MSGET cCnpj PICTURE PesqPict("SA2","A2_CGC") SIZE 140,10 F3 "SA2XCG" PIXEL OF oDlgKey

	@ 46,035 BUTTON oBtnCon PROMPT "&Ok" SIZE 38,11 PIXEL ACTION if(ChkCnpjSa2(cCnpj), (lContinua:=.T.,oDlgKey:End()), lContinua:=.F. )
	@ 46,077 BUTTON oBtnOut PROMPT "&Sair" SIZE 38,11 PIXEL ACTION (lContinua:=.F.,oDlgKey:End())

	ACTIVATE DIALOG oDlgKey CENTERED

	If lContinua
		dbSelectArea( "SA2" )
		dbsetorder( 3 )
		if SA2->( DbSeek( cFilSeek + cCnpj ) )
			Do While .Not. SA2->( Eof() ) .and. cFilSeek == SA2->A2_FILIAL .and. SA2->A2_CGC == cCnpj
				If .Not. Empty( cTransp )
					cTransp += ","
				endIf
				cTransp += "'"+SA2->A2_COD+SA2->A2_LOJA+"'"
				SA2->( dbSkip() )
			EndDo
			cCnpRem := cCnpj   //vindo como private, para fazer pesquisa despois. Itambé
		else
			lContinua := .F.
		endif
	EndIf
Else
	dbSelectArea( "SA4" )
	dbsetorder( 3 )
	If dbSeek( cFilSa4 + cCnpjTr )
		Do While .Not. SA4->( Eof() ) .and. cFilSa4 == SA4->A4_FILIAL .and. SA4->A4_CGC == cCnpjTr
			If .Not. Empty( cTransp )
				cTransp += ","
			endIf
			cTransp += "'"+SA4->A4_COD+"'"
			SA4->( dbSkip() )
		EndDo
	Else
		U_MyAviso("Atenção","Não Existem Transportadoras Cadastradas para o CNPJ "+Transform(cCnpjTr, "@R 99.999.999/9999-99"),{"OK"},3)
		lContinua := .F.
	EndIF
EndIf

If lContinua

	If lNfOri
		U_Sf3NfOri("M->D1_NFORI",cTransp)
	Else
		U_CteNfOri("M->D1_NFORI",cTransp)
	EndIf

Endif

SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
// Atualiza valores na tela
Eval(bRefresh)
RestArea(aAreaSA4)
RestArea(aAreaSA2)
Return .T.



Static Function ChkCnpjSa2(cCnpj)
Local lRet      := .T.
Local aArea     := GetArea()
Local cFilSeek  := Iif(U_IsShared("SA2"),xFilial("SA2"),ZBZ->ZBZ_FILIAL)

SA2->( dbSetOrder( 3 ) )
If Empty(cCnpj) .Or. .Not. SA2->( DbSeek( cFilSeek + cCnpj ) )
	U_MyAviso("Atenção","CNPJ "+Transform(cCnpj, "@R 99.999.999/9999-99")+" não cadastrado.",{"OK"},3)
	lRet := .F.
EndIf

RestArea(aArea)
Return( lRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A103EstDCF³ Prog. ³Fernando Joly Siquini  ³Data  ³06.09.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Efetua o estorno dos registros do DCF (Servico WMS).        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103EstDCF()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HFEstDCF(lEstorna)
Local aAreaAnt   := GetArea()
Local cSeekDCF   := ''
Local lRet       := .T.

Default lEstorna := .F.

If !Empty(SD1->D1_SERVIC) .And. (SuperGetMV('MV_INTDL')=='S')
	DbSelectArea('DCF')
	DbSetOrder(2) //-- FILIAL+SERVIC+DOCTO+SERIE+CLIFOR+LOJA+CODPRO
	If MsSeek(cSeekDCF:=xFilial('DCF')+SD1->D1_SERVIC+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD, .F.)
		Do While !Eof() .And. cSeekDCF==DCF_FILIAL+DCF_SERVIC+DCF_DOCTO+DCF_SERIE+DCF_CLIFOR+DCF_LOJA+DCF_CODPRO
			If DCF->DCF_NUMSEQ==SD1->D1_NUMSEQ
				If DCF_STSERV<>'1' .And. lEstorna
					DLA220Esto(.F.)
				EndIf
				If DCF_STSERV=='1'
					RecLock('DCF',.F.,.T.)
					dbDelete()
					MsUnlock()
				EndIf
			EndIf
			DCF->(dbSkip())
		EndDo
	EndIf
	RestArea(aAreaAnt)
EndIf

Return lRet



Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_ISSHARED()
        U_GETIDENT()
        U_XMLINFOX()
        U_XMLPCF5()
        U_HFSTATSEF()
        U_XMLDEBUG()
        U_XCONSXML()
        U_XCFGMAIL()
        U_TTT()
        U_SF3NFORI()
        U_MYAVISO()
        U_VERTSS()
        U_GETVERIX()
        U_MAILSEND()
        U_HFESTDCF()
        U_MA140LOK()
        U_MA140GRV()
        U_MA140TOK()
        U_XMATA140()
        U_XMLNFOF7()
        U_XMLPCF6()
        U_A140NFIS()
        U_CTENFORI()
	EndIF
Return(lRecursa)
