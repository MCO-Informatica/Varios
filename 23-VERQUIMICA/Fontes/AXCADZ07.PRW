#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXCADZ07  ºAutor  ³Nelson Junior       º Data ³  06/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de cadastro Vendedor x Divisão x Região (Z07)          º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AxCadZ07()

Private aRotina   := {}

DbSelectArea("Z07")
Z07->(DbSetOrder(1))

aAdd(aRotina,{"Pesquisar"	,"AxPesqui()"   ,0,1,0,Nil})
aAdd(aRotina,{"Visualizar"	,"U_AxIncZ07(2)",0,2,0,Nil})
aAdd(aRotina,{"Incluir"		,"U_AxIncZ07(3)",0,3,0,Nil})
aAdd(aRotina,{"Alterar"     ,"U_AxIncZ07(4)",0,4,0,Nil})
aAdd(aRotina,{"Excluir"     ,"U_AxIncZ07(5)",0,5,0,Nil})

mBrowse(6, 1, 22, 75, "Z07",,,,,,)

Return()

User Function AxIncZ07(nOpc)

//Variáveis da MsNewGetDados()
Local nStyle        := If(nOpc==3 .Or. nOpc==4,GD_INSERT+GD_UPDATE+GD_DELETE,0) // Opção da MsNewGetDados
Local cLinhaOk     	:= "U_AxZ07LOK()"					  						// Funcao executada para validar o contexto da linha atual do aCols (Localizada no Fonte GS1008)
Local cTudoOk      	:= "AllwaysTrue"					 						// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cTdOkLk      	:= "AllwaysTrue"											// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= "001"													// Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze      	:= 000														// Campos estaticos na GetDados.
Local nMax         	:= 999														// Numero maximo de linhas permitidas.
Local aAlter    	:= {}	   													// Campos a serem alterados pelo usuario
Local cFieldOk     	:= "AllwaysTrue"											// Funcao executada na validacao do campo
Local cSuperDel     := "AllwaysTrue"											// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk        := "AllwaysTrue"											// Funcao executada para validar a exclusao de uma linha do aCols
Local cBChange		:= "U_AxZ07Change("+AllTrim(Str(nOpc))+")"

Local aSize         := {}
Local aInfo         := {}
Local aPosObj       := {}
Local aPosGet       := {}
Local aObjects      := {}
Local aNoFields     := {"Z07_VEND"}

Local cSeek         := If(nOpc == 3,"",xFilial("Z07")+Z07->Z07_VEND)
Local bWhile        := If(nOpc == 3,{||},{|| Z07_FILIAL+Z07_VEND })
Local cQueryFil     := ""

Private cCodVend	:= Space(6)
Private cNomeVend	:= ""

If nOpc <> 3
	cCodVend	:= Z07->Z07_VEND
	cNomeVend	:= Posicione("SA3",1,xFilial("SA3")+Z07->Z07_VEND,"A3_NOME")
EndIf

DbSelectArea("SA3")
SA3->(DbSetOrder(1))

aSize   := MsAdvSize()

Aadd(aObjects,{100,100,.T.,.T.})
Aadd(aObjects,{100,100,.T.,.T.})
Aadd(aObjects,{100,020,.T.,.T.})

aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}})

FillGetDados(nOpc,"Z07",1,cSeek,bWhile,/*uSeekFor*/,aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQueryFil*/,/*bMontCols*/,If(nOpc==3,.T.,.F.),/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bBeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/,/*bCriaVar*/,/*lUserFields*/,/*lUserFields*/)

DEFINE MSDIALOG oDlg FROM aSize[7],000 TO aSize[6],aSize[5] TITLE "Vendedor x Divisão x Região" OF oMainWnd PIXEL

@ 006,005 SAY "Vendedor:"	 		  								  										OBJECT oLabel
@ 005,035 GET cCodVend	F3 "SA3" PICTURE "@!" SIZE 035,030 WHEN If(nOpc==3,.T.,.F.) VALID BuscaNomeVend()	OBJECT oLabel
@ 005,080 GET cNomeVend			 PICTURE "@!" SIZE 100,030 WHEN	.F.											OBJECT oNomeVend

oGrid:=MsNewGetDados():New(aPosObj[1][1]+40,aPosObj[1][2],aPosObj[3][3],aPosObj[3][4],nStyle,cLinhaOk,cTudoOk,cIniCpos,/*aAlter*/,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDlg,aHeader,aCols,cBChange)

//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(CfmTudoOk(nOpcDef,cOpc),(nOpc:=1,oDlg:End()),.F.)  },{||nOpc:=0,oDlg:End()},,/*aButtons*/) CENTERED

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||If(CadTudoOK(cCodVend,nOpc),oDlg:End(),.F.)},{||oDlg:End()},,/*aButtons*/) CENTERED

Return()


Static Function BuscaNomeVend()

Local lRet := .F.

cNomeVend := ""

If Z07->(DbSeek(xFilial("Z07")+cCodVend))
	MsgInfo("Este vendedor já foi incluído.")
ElseIf SA3->(DbSeek(xFilial("SA3")+cCodVend))
	cNomeVend	:= SA3->A3_NOME
	lRet 		:= .T.
EndIf

oNomeVend:Refresh()

Return(lRet)


User Function AxZ07LOK()

Local lRet := .T.
Local nPosDiv 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_DIVISA"})
Local nPosReg 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_REGIAO"})

For nX := 1 To Len(oGrid:aCols)
	//
	If oGrid:aCols[nX][nPosDiv] == oGrid:aCols[oGrid:NAT][nPosDiv] .And. oGrid:aCols[nX][nPosReg] == oGrid:aCols[oGrid:NAT][nPosReg] .And.nX != oGrid:NAT
		MsgInfo("Divisão x Região já incluída na linha "+AllTrim(Str(nX))+".")
		lRet := .F.
		Exit
	EndIf
	//
Next nX

Return(lRet)

User Function AxZ07Change(nOpc)

Local lRet := .T.
Local nPosCodDiv 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_DIVISA"})
Local nPosCodReg 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_REGIAO"})
Local nPosNomeDiv 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_NOMDIV"})
Local nPosNomeReg 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_NOMREG"})

If nOpc == 4
	If Empty(oGrid:aCols[n][nPosCodDiv])
		oGrid:aCols[n][nPosNomeDiv] := ""
		oGrid:Refresh()
	EndIf
	//
	If Empty(oGrid:aCols[n][nPosCodReg])
		oGrid:aCols[n][nPosNomeReg] := ""
		oGrid:Refresh()
	EndIf	
EndIf

Return(lRet)                                               


Static Function CadTudoOK(cCodVend,nOpc)

Local lRet 		:= .T.
Local nPosDiv 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_DIVISA"})
Local nPosReg 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_REGIAO"})
Local nPosRec	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z07_REC_WT"})

lRet := U_AxZ07LOK()

If !lRet
	Return(lRet)
EndIf

If nOpc == 3 .Or. nOpc == 4
	For nX := 1 To Len(oGrid:aCols)
		If !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			If Empty(oGrid:aCols[nX][nPosDiv]) .Or. Empty(oGrid:aCols[nX][nPosReg])
				MsgInfo("A linha "+AllTrim(Str(nX))+" está sem divisão e/ou região.")
				Return(.F.)
			EndIf
		EndIf
	Next
EndIf

If nOpc != 5 // Diferente de Exclusão
	//
	For nX := 1 To Len(oGrid:aCols)
		//
		cTipoGrv := ""
		//
		If oGrid:aCols[nX][nPosRec] == 0 .And. !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			cTipoGrv := "I" //Inclusão
		ElseIf oGrid:aCols[nX][nPosRec] > 0 .And. !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			cTipoGrv := "A" //Alteração
		ElseIf oGrid:aCols[nX][nPosRec] > 0 .And. GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			cTipoGrv := "E" //Exclusão
		EndIf
		//
		If !Empty(cTipoGrv)
			//
			If cTipoGrv $ "A/E"
				Z07->(DbGoTo(oGrid:aCols[nX][nPosRec]))
				RecLock("Z07",.F.)
			Else
				RecLock("Z07",.T.)
			EndIf
			//
			If cTipoGrv == "I"
				Z07->Z07_FILIAL	:= xFilial("Z07")
				Z07->Z07_VEND	:= cCodVend
			EndIf
			//
			If cTipoGrv $ "A/I"
				For nY := 1 To Len(oGrid:aHeader)
					If oGrid:aHeader[nY][10] == "R"
						&("Z07->"+oGrid:aHeader[nY][2]) := oGrid:aCols[nX][nY]
					EndIf
				Next nY
			EndIf
			//
			If cTipoGrv == "E"
				Z07->(DbDelete())
			EndIf
			//
			Z07->(MsUnLock())
			//
		EndIf
		//
	Next nX
	//
Else
	//
	DbSelectArea("Z07")
	Z07->(DbSetOrder(1))
	Z07->(DbSeek(xFilial("Z07")+Z07->Z07_VEND))
	//
	While !Z07->(Eof()) .And. Z07->(Z07_FILIAL+Z07_VEND) == xFilial("Z07")+cCodVend
		//
		RecLock("Z07",.F.)
			Z07->(DbDelete())
		Z07->(MsUnLock())
		//
		Z07->(DbSkip())
		//
	EndDo
EndIf

Return(lRet)