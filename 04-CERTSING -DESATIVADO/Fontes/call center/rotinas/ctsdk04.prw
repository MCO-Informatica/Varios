#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSDK04   บAutor  ณOpvs (David)        บ Data ณ  20/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina Customizada para Registro de Status dos Operadores   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTSDK04(_cGrupo,cCodPausa)
Local cOper			:= TkOperador()
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjCoords	:= {}
Local aObjSize		:= {}
Local nOpcRad		:= 3
Local nOpcRadOld	:= 3
Local oFont			:= NIL
Local oFont2		:= NIL
Local oDlg			:= NIL
Local oGroup		:= NIL
Local oRadio		:= NIL
Local oMemo1		:= NIL
Local oCrono		:= NIL
Local cCrono		:= "00:00:00"
Local cTpPausa		:= "      "
Local oTpPausa		:= nil
Local nTimeSeg		:= 0
Local nTimeMin		:= 0
Local nTimeHor		:= 0
Local cMemo			:= ""
Local nOpcx			:= 0
Local cSql			:= ""
Local oFila			:= NIL
Local cFIla			:= "00:00:00"
Local oTimerPausa	:= nil
Local oBtOk			:= nil

Private nRecSZK		:= 0

Default _cGrupo		:= ""
Default cCodPausa	:= ""

cTpPausa := cCodPausa

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Monta as Dimensoes dos Objetos         					   ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
aAdvSize := MsAdvSize( .T. , .T. )
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Redimensiona                           					   ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
aAdvSize[3]	-= 25
aAdvSize[4]	-= 50
aAdvSize[5]	-= 50
aAdvSize[6] -= 50
aAdvSize[7] += 50

aInfoAdvSize:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )

aObjSize := MsObjSize( aInfoAdvSize , aObjCoords )

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณMonta Dialogo para a selecao do Periodo 					  ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
If GetRemoteType() <> 5
	DEFINE FONT oFont NAME "Arial" SIZE 0,-14 BOLD
	DEFINE FONT oFont2 NAME "Arial" SIZE 0,-20 BOLD
Else
	DEFINE FONT oFont NAME "Arial" SIZE 0,12 BOLD
	DEFINE FONT oFont2 NAME "Arial" SIZE 0,14 BOLD
EndIf
DEFINE MSDIALOG oDlg TITLE OemToAnsi("***Pausa de Operador***") From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL

	@ ( aObjSize[1,1] + 010 ) , ( aObjSize[1,2]+005 ) SAY "Tipo Parada" PIXEL SIZE 55,9 OF oDlg PIXEL FONT oFont //
	@ ( aObjSize[1,1] + 010 ) , ( aObjSize[1,2]+065 ) MSGET oTpPausa Var cTpPausa SIZE 60,9 PICTURE "@!" OF oDlg Pixel F3 "Z0" WHEN Empty(cCodPausa)
	oTpPausa:oFont:= oFont
	
	@ ( aObjSize[1,1] + 010 ) , ( aObjSize[1,2]+135 )	SAY OemToAnsi(Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z0"+cTpPausa,"X5_DESCRI")))	SIZE 300,10 OF oDlg PIXEL FONT oFont COLOR CLR_BLUE		//
	
	@ ( aObjSize[1,1] + 030 ) , ( aObjSize[1,2]+005 )	SAY OemToAnsi("Observa็๕es")	SIZE 300,10 OF oDlg PIXEL FONT oFont		//
	@ ( aObjSize[1,1] + 030 ) , ( aObjSize[1,2]+065 ) Get oMemo1 var cMemo Of oDlg MEMO Pixel Size 120,030
	oMemo1:oFont:= oFont

	@ ( aObjSize[1,1] + 010 ) , ( aObjSize[1,2]+240)	SAY oCrono var cCrono SIZE 300,10 OF oDlg PIXEL FONT oFont2 COLOR CLR_BLUE PICTURE "99:99:99"
	oCrono:lVisible := .F.

	@ ( aObjSize[1,1] + 080 ) , ( aObjSize[1,2]+005)	SAY oFila var cFila SIZE 300,10 OF oDlg PIXEL FONT oFont COLOR CLR_RED
	oFila:lVisible := .F.

	DEFINE TIMER oTimerPausa INTERVAL 1000 ACTION AtuPausa(	@nTimeSeg	,@nTimeMin, @nTimeHor	,@cCrono ,	@oCrono, @oFila, _cGrupo	) OF oDlg
	oTimerPausa:lActive	:= .F.
	oTimerPausa:lLiveAny := .T.

	@ ( aObjSize[1,1] + 030 ) , ( aObjSize[1,2]+240) BUTTON oBtOk PROMPT "Finalizar" SIZE 40,30 ACTION iif(!Empty(cTpPausa),SDK04OK(oDlg,2,@oCrono,2,nRecSZK,cMemo,cTpPausa,oFila,_cGrupo,@nTimeSeg	,@nTimeMin, @nTimeHor, @cCrono,@oTimerPausa ),MsgAlert("Informe Tipo de Pausa"))  OF oDlg pIXEL

ACTIVATE MSDIALOG oDlg CENTERED ON INIT SDK04OK(oDlg,@nOpcRad,@oCrono,@nOpcRadOld,@nRecSZK,cMemo,cTpPausa,oFila,_cGrupo,@nTimeSeg,@nTimeMin, @nTimeHor, @cCrono, @oTimerPausa )

If Type("_nStaPau") <> "U"
	_nStaPau := 2
EndIf

oFont		:= nil
oFont2		:= nil
oDlg		:= nil
oGroup		:= nil
oRadio		:= nil
oCrono		:= nil
oTpPausa	:= nil
oFila		:= nil
oTimerPausa	:= nil
oBtOk		:= nil

DelClassInf()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSDK04OK   บAutor  ณOpvs (David)        บ Data ณ  20/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SDK04OK(oDlg,nOpcRad,oCrono,nOpcRadOld,nRecSZK,cMemo,cTpPausa,oFila,_cGrupo,nTimeSeg,nTimeMin, nTimeHor,cCrono,oTimerPausa )
Local aSZK		:= {}
Local lPosSZK   := .f.
Local aInfo 	:= {}
Local nCount 	:= 0
Local lChat 	:= .F.

If nRecSZK > 0 .and. nOpcRad == 2
	aSZK := {}
	
	AaDd(aSZK,{"ZK_STATUS"	,StrZero(nOpcRad,1)})
	AaDd(aSZK,{"ZK_DTFIM",Ddatabase})
	AaDd(aSZK,{"ZK_HRFIM",SubStr(Time(),1,5)})
	AaDd(aSZK,{"ZK_DESC"	,cMemo})
	AaDd(aSZK,{"ZK_TPPSA"	,cTpPausa})

	SZK->(DbGoTo(nRecSZK))
	GRVSZK(aSZK,.F.)
ElseIf nOpcRad == 3 .and. nRecSZK == 0
	aSZK := {}

	AaDd(aSZK,{"ZK_FILIAL"	,xFilial("SZK")})
	AaDd(aSZK,{"ZK_STATUS"	,StrZero(nOpcRad,1)})
	AaDd(aSZK,{"ZK_OPERADO"	,TkOperador()})
	AaDd(aSZK,{"ZK_DTINI"	,Ddatabase})
	AaDd(aSZK,{"ZK_HRINI"	,SubStr(Time(),1,5)})
	AaDd(aSZK,{"ZK_TPPSA"	,cTpPausa})
	
	GRVSZK(aSZK,.T.)
EndIf

Do Case
	Case nOpcRad = 1
		oDlg:End()


		//verificacao para ver se vem te tela de chat
		aInfo := Getuserinfoarray()

		For nCount := 1 to len (aInfo)

			IF aInfo[nCount][3] == ThreadID() .AND. AT("CHAT ", aInfo[nCount][11]) > 0

				lChat := .T.
				Exit

			Endif
		Next
		IIF (!lChat,oTk510Tela:oDlg:End(),)

	Case nOpcRad = 2
		oTimerPausa:DeActivate()
		oDlg:End()
	Case nOpcRad = 3
		nTimeSeg	:= 0
		nTimeMin	:= 0
		nTimeHor	:= 0
		cCrono := "00:00:00"
		oCrono:lVisible := .T.
		oCrono:Refresh()
		If !Empty(_cGrupo)
			oFila:lVisible := .T.
		EndIf
		oTimerPausa:Activate()
Endcase

nOpcRadOld 	:= nOpcRad
nRecSZK		:= SZK->(Recno())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRVSZK    บAutor  ณOpvs (David)        บ Data ณ  20/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina Estanque para Gravacao do SZK                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GRVSZK(aDadSZK,lRec)
Local nI	:= 0

If Len(aDadSZK) > 0
	Reclock("SZK",lRec)
	For nI:=1 to Len(aDadSZK)
		&("SZK->"+aDadSZK[nI,1]) := aDadSZK[nI,2]
	Next
	SZK->(MsUnlock())
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuCro    บAutor  ณOpvs (David)        บ Data ณ  20/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณrotina de atualizacao do tempo de pausa do operador         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuPausa(	nTimeSeg	,nTimeMin , nTimeHor	,cCrono	,oCrono, oFila, _cGrupo	)

Local cTimeAtu 	:= ""
Local cFila		:= ""
Local oSvcPausa	:= nil

DelClassIntf()

nTimeSeg ++

If nTimeSeg > 59
	nTimeMin ++
	nTimeSeg := 0
	If nTimeMin > 60
		nTimeHor ++
		nTimeMin := 0
	Endif
Endif

cTimeAtu := STRZERO(nTimeHor,2,0)+":"+STRZERO(nTimeMin,2,0)+":"+STRZERO(nTimeSeg,2,0)

cCrono := cTimeAtu
oCrono:Refresh()

If !Empty(_cGrupo)
	oSvcPausa	:= WSChatProviderService():New() // ChatProvider
	oSvcPausa:cGrupo := _cGrupo
	lOk		:= oSvcPausa:tamanhoFila(_cGrupo) // Verifica se a mensagem foi enviada

	If lOk
		cFila := Alltrim(oSvcPausa:cReturn)
	Else
		cFila := "0"
	EndIf

	If Alltrim(oFila:cCaption) <> Alltrim(cFila+" Clientes na Fila")
		oFila:cCaption := 	cFila+" Clientes na Fila"
		oFila:Refresh()
	EndIf

	FreeObj(oSvcPausa)
EndIf

DelClassIntf()

Return(.T.)