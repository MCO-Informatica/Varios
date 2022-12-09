#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ROMANEIO  ∫Autor  ≥Nelson Junior       ∫ Data ≥  09/12/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Rotina para cadastro de romaneios.                          ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function Romaneio()

Private aRotina := {}
Private aCores  := {}

DbSelectArea("Z13") ; Z13->(DbSetOrder(1))

aAdd(aRotina,{"Pesquisar"	,"AxPesqui()"   ,0,1,0,Nil})
aAdd(aRotina,{"Visualizar"	,"U_AxIncZ13(2)",0,2,0,Nil})
aAdd(aRotina,{"Incluir"		,"U_AxIncZ13(3)",0,3,0,Nil})
aAdd(aRotina,{"Alterar"     ,"U_AxIncZ13(4)",0,4,0,Nil})
//aAdd(aRotina,{"Excluir"    ,"U_AxIncZ13(5)",0,5,0,Nil})
aAdd(aRotina,{"Cancelar"    ,"U_AxCanZ13()" ,0,5,0,Nil})
aAdd(aRotina,{"Imprimir"    ,"U_AxImpZ13()" ,0,6,0,Nil})
aAdd(aRotina,{"Legenda"     ,"U_AxLegZ13()" ,0,7,0,nil})


aAdd(aCores,{"Z13_STATUS=='A'.Or.Empty(Z13_STATUS)"  ,"BR_VERDE"  })
aAdd(aCores,{"Z13_STATUS=='E'"  ,"BR_VERMELHO"})
aAdd(aCores,{"Z13_STATUS=='C'"  ,"PRETO"})

mBrowse(6, 1, 22, 75, "Z13",,,,,,aCores)

Return()

/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: AxLegZ13  | Autor: Celso Ferrone Martins      | Data: 10/12/2014 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: | Legenda                                                       |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       |                                                               |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/
User Function AxLegZ13()

Local cStrx01 := "Romaneio"
Local cStrx02 := "Legenda"
Local aCores  := {}

Aadd(aCores,{"BR_VERDE"   ,"Em Aberto"})
Aadd(aCores,{"BR_VERMELHO","Encerrado"})
Aadd(aCores,{"BR_PRETO"   ,"Cancelado"})

BrwLegenda(cStrx01,cStrx02,aCores)

Return()

/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: AxIncZ13  | Autor: Celso Ferrone Martins      | Data: 10/12/2014 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: |                                                              |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       |                                                               |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/
User Function AxIncZ13(nOpc)

If nOpc != 2 .And. nOpc != 3
	If Z13_STATUS $ 'E|C'
		nOpc := 2
		MsgAlert("Status do Romaneio so permite visualizacao...","Romaneio Finalizado.")
	EndIf
EndIf
AxCadZ13(nOpc)

Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AxCadZ13  ∫Autor  ≥Nelson Junior       ∫ Data ≥  09/12/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Rotina para cadastro de romaneios.                          ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AxCadZ13(nOpc)

//Vari·veis da MsNewGetDados()
Local nStyle        := iIf(nOpc=2,0,GD_UPDATE+GD_DELETE)		   				// OpÁ„o da MsNewGetDados
Local cLinhaOk     	:= "U_AxZ13LOK()"  					   						// Funcao executada para validar o contexto da linha atual do aCols (Localizada no Fonte GS1008)
Local cTudoOk      	:= "AllwaysTrue"					 						// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cTdOkLk      	:= "AllwaysTrue"											// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""														// Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze      	:= 000														// Campos estaticos na GetDados.
Local nMax         	:= 999														// Numero maximo de linhas permitidas.
Local aAlter    	:= {}	   													// Campos a serem alterados pelo usuario
Local cFieldOk     	:= "AllwaysTrue"											// Funcao executada na validacao do campo
Local cSuperDel     := "AllwaysTrue"											// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk        := "U_AxZ13Del()"											// Funcao executada para validar a exclusao de uma linha do aCols
Local cBChange		:= ""

Local aSize         := {}
Local aInfo         := {}
Local aPosObj       := {}
Local aPosGet       := {}
Local aObjects      := {}
Local aNoFields     := {"Z14_NUMERO"}

Local cSeek         := If(nOpc == 3,"",xFilial("Z13")+Z13->Z13_NUMERO)
Local bWhile        := If(nOpc == 3,{||},{|| Z14_FILIAL+Z14_NUMERO })
Local cQueryFil     := ""

Private cMarca    	:= GetMark()

Private cNumRom 	:= If(nOpc <> 3, Space(6), GetSx8Num("Z13", "Z13_NUMERO"))
Private cNumOld     := ""
Private lNumOld     := .F.
Private cTransp		:= Space(6)
Private cTransNome  := Space(30)
Private oTransp
Private lTransp     := iIf(nOpc==3,.T.,.F.)
Private lPlaca      := iIf(nOpc==3.Or.nOpc==4,.T.,.F.)
Private lBotao      := iIf(nOpc==3.Or.nOpc==4,.T.,.F.)
Private cPlaca		:= Space(7)
Private dDataRom	:= dDataBase//CtoD("  /  /    ")
Private nTotPeBr	:= 000000.00
Private nTotPeLi	:= 000000.00
Private nTotNoFi	:= 000000.00
Private oTotPeBr
Private oTotPeLi
Private oTotNoFi
Private oTipoE
Private aTipoE      := {}
Private cTipoE      := "E"

Aadd(aTipoE,"E=Entrega")
Aadd(aTipoE,"R=Reentrega")

Private aNewCols    := {}

If nOpc <> 3
	cNumRom		:= Z13->Z13_NUMERO
	cTransp		:= Z13->Z13_TRANSP
	cTransNome  := Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")
	cPlaca		:= Z13->Z13_PLACA
	dDataRom	:= Z13->Z13_DATA
	nTotPeBr	:= Z13->Z13_TOTPBR
	nTotPeLi	:= Z13->Z13_TOTPLI
	nTotNoFi	:= Z13->Z13_TOTNF
EndIf

aSize := MsAdvSize()

Aadd(aObjects,{100,100,.T.,.T.})
Aadd(aObjects,{100,100,.T.,.T.})
Aadd(aObjects,{100,020,.T.,.T.})

aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}})

FillGetDados(nOpc,"Z14",1,cSeek,bWhile,/*uSeekFor*/,aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQueryFil*/,/*bMontCols*/,If(nOpc==3,.T.,.F.),/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bBeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/,/*bCriaVar*/,/*lUserFields*/,/*lUserFields*/)

DEFINE MSDIALOG oDlg FROM aSize[7],000 TO aSize[6],aSize[5] TITLE "Romaneio" OF oMainWnd PIXEL

oDlg:lMaximized := .T.

@ 006+30,005 SAY "N˙mero:"							  			 								 		OBJECT oLabel
@ 005+30,050 GET cNumRom						PICTURE "@!"				SIZE 035,030 WHEN .F.		OBJECT oLabel

@ 006+30,115 SAY "Data:"						 			 								   			OBJECT oLabel
@ 005+30,155 GET dDataRom													SIZE 045,030 WHEN .F.		OBJECT oLabel

@ 006+30,230 SAY "Tipo:"						 			 								   			OBJECT oLabel
@ 003+30,270 MsComboBox oTipoE       Var cTipoE        Items aTipoE        Size 045,030 When .T.       OF oDlg PIXEL

@ 021+30,005 SAY "Transportadora:"						 									 			OBJECT oLabel
@ 020+30,050 GET cTransp			F3 "SA4"	PICTURE "@!"	   			SIZE 035,030 WHEN lTransp	OBJECT oTransp VALID fValTrans()
@ 020+30,090 GET cTransNome					PICTURE "@!"	   			SIZE 125,030 WHEN .F.		OBJECT oTransp

@ 021+30,230 SAY "Placa:"						 			 								 			OBJECT oLabel
@ 020+30,270 GET cPlaca						PICTURE "@! AAA9999"		SIZE 035,030 WHEN lPlaca	OBJECT oLabel

@ 036+30,005 SAY "Total Peso Liq.:"							  			 							OBJECT oLabel
@ 035+30,050 GET nTotPeLi						PICTURE "@E 999,999.99"		SIZE 045,030 WHEN .F.		OBJECT oTotPeLi

@ 036+30,115 SAY "Total Peso Bru.:"							  			 							OBJECT oLabel
@ 035+30,155 GET nTotPeBr						PICTURE "@E 999,999.99"		SIZE 045,030 WHEN .F.		OBJECT oTotPeBr

@ 036+30,230 SAY "Total Nota Fis.:"							  			 							OBJECT oLabel
@ 035+30,270 GET nTotNoFi						PICTURE "@E 999,999.99"		SIZE 045,030 WHEN .F.		OBJECT oTotNoFi

oGrid:=MsNewGetDados():New(aPosObj[1][1]+90,aPosObj[1][2]+5,aPosObj[3][3],aPosObj[3][4],nStyle,cLinhaOk,cTudoOk,cIniCpos,/*aAlter*/,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDlg,aHeader,aCols,cBChange)

If lBotao
	aNewCols := aClone(oGrid:aCols[1])
	For nX := 1 To len(aNewCols)
		If ValType(aNewCols[nX]) == "C"
			aNewCols[nX] := ""
		ElseIf ValType(aNewCols[nX]) == "N"
			aNewCols[nX] := 0
		ElseIf ValType(aNewCols[nX]) == "D"
			aNewCols[nX] := cTod("")
		ElseIf ValType(aNewCols[nX]) == "L"
			aNewCols[nX] := .F.
		EndIf
	Next Nx
	@ 066+25,005 BUTTON "&Incluir" 				ACTION 	U_CfmSelSf2(cTransp,@oGrid)	SIZE 030,012 			PIXEL OF oDlg
EndIf

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||If(CadTudoOK(nOpc),oDlg:End(),.F.)},{|| If(nOpc == 3, (RollbackSx8(), oDlg:End()), oDlg:End()) },,/*aButtons*/) CENTERED

Return()


User Function AxZ13LOK()

Local lRet 	  := .T.

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: fValTrans  | Autor: Celso Ferrone Martins | Data: 10/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function fValTrans()

Local lRet := .T.

cTransNome := ""

DbSelectArea("SA4") ; DbSetOrder(1)
If SA4->(DbSeek(xFilial("SA4")+cTransp))
	cTransNome := SA4->A4_NOME
Else
	lRet := .F.
	MsgAlert("Transportadora nao encontrada...","Atencao!!!")
EndIf

oTransp:Refresh()

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: AxZ13Del   | Autor: Celso Ferrone Martins | Data: 10/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function AxZ13Del()

Local lRet 	  := .T.
Local nPosTNf := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_TOTNF"})
Local nPosTPL := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_TOTPLI"})
Local nPosTPB := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_TOTPBR"})

nTotPeBr := 0 //"Total Peso Bru.:"
nTotPeLi := 0 //"Total Peso LÌq.:"
nTotNoFi := 0 //"Total Nota Fis.:"

For nX := 1 To Len(oGrid:aCols)
	lSoma := .T.
	If nX == n
		If !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			lSoma := .F.
		EndIf
	Else
		If GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			lSoma := .F.
		EndIf
	EndIf
	If lSoma
		nTotPeBr += oGrid:aCols[nX][nPosTPB]
		nTotPeLi += oGrid:aCols[nX][nPosTPL]
		nTotNoFi += oGrid:aCols[nX][nPosTNf]
	EndIf
Next nX

oTotPeBr:Refresh()
oTotPeLi:Refresh()
oTotNoFi:Refresh()

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: AxZ13Del   | Autor: Celso Ferrone Martins | Data: 10/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function AxCanZ13()

Local aAreaSf2 := SF2->(GetArea())

DbSelectArea("SF2");DbSetOrder(1)

If Z13->Z13_STATUS == "C"
	MsgInfo("Documento ja cancelado","Atencao...")
	Return()
EndIf

If Z13->Z13_STATUS == "E"
	MsgInfo("Documento Encerrado!!!","Atencao...")
EndIf

If MsgYesNo("Deseja Cancelar Documento ?","Cancela Romaneio.")
	RecLock("Z13",.F.)
	Z13->Z13_STATUS := "C"
	MsUnLock()
EndIf

cQuery := " SELECT * FROM " + RetSqlName("SF2")
cQuery += " WHERE "
cQuery += "    D_E_L_E_T_ <> '*' "
cQuery += "    AND F2_FILIAL  = '"+xFilial("SF2")+"' "
cQuery += "    AND F2_VQ_ROMA = '"+Z13->Z13_NUMERO+"' "

cQuery := ChangeQuery(cQuery)

If Select("TRBSF2") > 0
	TRBSF2->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBSF2"

While !TRBSF2->(Eof())
	If SF2->(DbSeek(xFilial("SF2")+TRBSF2->(F2_DOC+F2_SERIE)))
		RecLock("SF2",.F.)
		SF2->F2_VQ_ROMA := ""
		MsUnLock()
	EndIf
	TRBSF2->(DbSkip())
EndDo

If Select("TRBSF2") > 0
	TRBSF2->(DbCloseArea())
EndIf

SF2->(RestArea(aAreaSf2))

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CadTudoOK  | Autor:                       | Data: 15/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CadTudoOK(nOpc)

Local lRet 		:= .T.
Local nPosRec	:= aScan(oGrid:aHeader,{|x| AllTrim(x[2])=="Z14_REC_WT"})
Local nPosNota  := aScan(oGrid:aHeader,{|x| Alltrim(x[2])=="Z14_NOTA"})  // Nota
Local nPosSerie := aScan(oGrid:aHeader,{|x| Alltrim(x[2])=="Z14_SERIE"}) // Serie
Local aAreaSf2  := SF2->(GetArea())

//DbSelectArea("SF2");DBOrderNickName("ROMANEIO")
//DbSelectArea("SF2");DbSetOrder(1)

If nTotNoFi == 0
	MsgAlert("Nao e possivel gravar romaneio sem dados","Atencao!!!")
	Return(.F.)
EndIf

If nOpc == 3 .Or. nOpc == 4
	//
	Z13->(DbSetOrder(1))
	//
	If nOpc == 3 .And. Z13->(DbSeek(xFilial("Z13")+cNumRom))
		//
		MsgInfo("N˙mero de romaneio j· cadastrado.")
		Return(.F.)
		//
	EndIf
EndIf

If nOpc != 5 // Diferente de Exclus„o
	
	If nOpc == 3
		RecLock("Z13",.T.)
		Z13->Z13_FILIAL	:= xFilial("Z13")
		Z13->Z13_NUMERO := cNumRom
		Z13->Z13_TRANSP := cTransp
		Z13->Z13_DATA   := dDataRom
		Z13->Z13_STATUS := "A"
		//
		ConfirmSx8()
	ElseIf nOpc == 4
		RecLock("Z13",.F.)
	EndIf
	Z13->Z13_PLACA  := cPlaca
	Z13->Z13_TOTPBR := nTotPeBr
	Z13->Z13_TOTPLI := nTotPeLi
	Z13->Z13_TOTNF  := nTotNoFi
	//
	DbSelectArea("SF2");DbSetOrder(1)
	For nX := 1 To Len(oGrid:aCols)
		lNumOld := .F.
		If SF2->(DbSeek(xFilial("SF2")+oGrid:aCols[nX][nPosNota]+oGrid:aCols[nX][nPosSerie]))
			If !Empty(SF2->F2_VQ_ROMA)
				lNumOld := .T.
				cNumOld := SF2->F2_VQ_ROMA
			EndIf
			RecLock("SF2",.F.)
			SF2->F2_VQ_ROMA := cNumRom
			If lNumOld
				SF2->F2_VQ_REEN := "S"
				SF2->F2_VQ_ROLD := cNumOld
			EndIf
			MsUnLock()
		EndIf
		//
		cTipoGrv := ""
		//
		If oGrid:aCols[nX][nPosRec] == 0 .And. !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			cTipoGrv := "I" //Inclus„o
		ElseIf oGrid:aCols[nX][nPosRec] > 0 .And. !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			cTipoGrv := "A" //AlteraÁ„o
		ElseIf oGrid:aCols[nX][nPosRec] > 0 .And. GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
			cTipoGrv := "E" //Exclus„o
		EndIf
		//
		If !Empty(cTipoGrv)
			//
			If cTipoGrv $ "A/E"
				Z14->(DbGoTo(oGrid:aCols[nX][nPosRec]))
				RecLock("Z14",.F.)
			Else
				//
				RecLock("Z14",.T.)
				Z14->Z14_FILIAL	:= xFilial("Z14")
				Z14->Z14_NUMERO	:= cNumRom
				//
			EndIf
			//
			If cTipoGrv $ "A/I"
				For nY := 1 To Len(oGrid:aHeader)
					If oGrid:aHeader[nY][10] == "R"
						&("Z14->"+oGrid:aHeader[nY][2]) := oGrid:aCols[nX][nY]
					EndIf
				Next nY
			EndIf
			
			If cTipoGrv == "A" .And. lNumOld
				Z14->Z14_REENTR := "S"
				Z14->Z14_NUMANT := cNumOld
			EndIf
			//
			If cTipoGrv == "E"
				Z14->(DbDelete())
			EndIf
			//
			Z14->(MsUnLock())
			//
		EndIf
		//
	Next nX
	//
Else
	//
	DbSelectArea("Z13")
	Z13->(DbSetOrder(1))
	Z13->(DbSeek(xFilial("Z13")+cNumRom))
	//
	While !Z13->(EoF()) .And. Z13->(Z13_FILIAL+Z13_NUMERO) == xFilial("Z13")+cNumRom
		//
		RecLock("Z13",.F.)
		Z13->(DbDelete())
		Z13->(MsUnLock())
		//
		Z13->(DbSkip())
		//
	EndDo
	//
	DbSelectArea("Z14")
	Z14->(DbSetOrder(1))
	Z14->(DbSeek(xFilial("Z14")+cNumRom))
	//
	While !Z14->(EoF()) .And. Z14->(Z14_FILIAL+Z14_NUMERO) == xFilial("Z14")+cNumRom
		//
		RecLock("Z14",.F.)
		Z14->(DbDelete())
		Z14->(MsUnLock())
		//
		Z14->(DbSkip())
		//
	EndDo
	
	cQuery := " SELECT * FROM " + RetSqlName("SF2")
	cQuery += " WHERE "
	cQuery += "    D_E_L_E_T_ <> '*' "
	cQuery += "    AND F2_FILIAL  = '"+xFilial("SF2")+"' "
	cQuery += "    AND F2_VQ_ROMA = '"+Z13->Z13_NUMERO+"' "
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TRBSF2") > 0
		TRBSF2->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TRBSF2"
	
	While !TRBSF2->(Eof())
		If SF2->(DbSeek(xFilial("SF2")+TRBSF2->(F2_DOC+F2_SERIE)))
			RecLock("SF2",.F.)
			SF2->F2_VQ_ROMA := ""
			MsUnLock()
		EndIf
		TRBSF2->(DbSkip())
	EndDo
	
	If Select("TRBSF2") > 0
		TRBSF2->(DbCloseArea())
	EndIf
	
	//
EndIf

SF2->(RestArea(aAreaSf2))

Return(lRet)


/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmSelSf2  | Autor: Celso Ferrone Martins | Data: 04/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmSelSf2(cTransp,oGrid)

Private _cTransp := cTransp

If Empty(_cTransp)
	MsgAlert("Selecione a transportadora","Atencao")
	Return()
EndIf

Processa({|| fCfmTela()},"Carregando dados...")

Return()

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: fCfmTela | Autor: Celso Ferrone Martins  | Data: 28/04/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | Tela de selecao dos itens para reprocessamento de preco   |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fCfmTela()

Local aStruct   := {}
Local aCampos   := {}
Local cArqTrab1 := ""
Local cKey1     := ""
Local cKey2     := ""
Local cKey3     := ""
Local cIndTab1  := ""
Local cIndTab2  := ""
Local cIndTab3  := ""
//Private cMarca    := GetMark()
Private cAliasSEL := "TMPSEL"
Private lInverte  := .F.							// Flag de invers?o de sele°?o

Private dDataIni := dDataBase//cTod("")
Private dDataFim := dDataBase//cTod("")
Private lDataPrc := .T.

DbSelectArea("SB1") ; DbSetOrder(1) // Cadastro de Produtos
DbSelectArea("SG1") ; DbSetOrder(1) // Estrutura de produto
DbSelectArea("Z02") ; DbSetOrder(1) // Tabela de Precos - Cabecalho
DbSelectArea("Z03") ; DbSetOrder(2) // Tabela de Precos - Itens

aAdd(aStruct,{"F2_OK"     ,"C" ,02,0 })
aAdd(aStruct,{"F2_DOC"    ,"C" ,09,0 })
aAdd(aStruct,{"F2_SERIE"  ,"C" ,03,0 })
aAdd(aStruct,{"F2_EMISSAO","D" ,08,0 })
aAdd(aStruct,{"F2_CLIENTE","C" ,30,0 })
aAdd(aStruct,{"F2_LOJA"   ,"C" ,30,0 })
aAdd(aStruct,{"A1_NOME"   ,"C" ,30,0 })
aAdd(aStruct,{"F2_TRANSP" ,"C" ,30,0 })
aAdd(aStruct,{"A4_NOME"   ,"C" ,30,0 })
aAdd(aStruct,{"F2_TOTAL"  ,"N" ,18,2 })
aAdd(aStruct,{"F2_PESOL"  ,"N" ,18,2 })
aAdd(aStruct,{"F2_PESOB"  ,"N" ,18,2 })
aAdd(aStruct,{"F2_VQ_FRET","C" ,01,0 })
aAdd(aStruct,{"F2_VQ_FCLI","C" ,01,0 })
aAdd(aStruct,{"F2_VQ_FVER","C" ,01,0 })

aAdd(aCampos,{"F2_OK"     ,"" ," "                , " " })
aAdd(aCampos,{"F2_DOC"    ,"" ,"Nota"             , "@!" })
aAdd(aCampos,{"F2_SERIE"  ,"" ,"Serie"            , "@!" })
aAdd(aCampos,{"F2_EMISSAO","" ,"Emissao"          , "@D" })
aAdd(aCampos,{"A1_NOME"   ,"" ,"Cliente"          , "@!" })
aAdd(aCampos,{"A4_NOME"   ,"" ,"Transportadora"   , "@!" })
aAdd(aCampos,{"F2_TOTAL"  ,"" ,"Total"            , "@E 999,999,999,999.99" })
aAdd(aCampos,{"F2_PESOL"  ,"" ,"Peso.Liq."        , "@E 999,999,999,999.9999" })
aAdd(aCampos,{"F2_PESOB"  ,"" ,"Peso.Bruto"       , "@E 999,999,999,999.9999" })
aAdd(aCampos,{"F2_VQ_FRET","" ,"Tipo.Frete"       , "@!" })
aAdd(aCampos,{"F2_VQ_FCLI","" ,"Frete.Cliente"    , "@!" })
aAdd(aCampos,{"F2_VQ_FVER","" ,"Frete.Verquimica" , "@!" })

cKey1 := "F2_DOC+F2_SERIE+DTOS(F2_EMISSAO)"
cKey2 := "F2_CLIENTE+F2_DOC+F2_SERIE+DTOS(F2_EMISSAO)"
cKey3 := "DTOS(F2_EMISSAO)+F2_DOC+F2_SERIE"

If Select(cAliasSEL) > 0
	(cAliasSEL)->(dbCloseArea())
EndIf

cArqTrab1 := CriaTrab(aStruct, .T.)
dbUseArea(.T.,, cArqTrab1 ,cAliasSEL, .F.,.F. )
dbSelectArea(cAliasSEL)

cIndTab1 := cArqTrab1+"A"
cIndTab2 := cArqTrab1+"B"
cIndTab3 := cArqTrab1+"C"

IndRegua(cAliasSEL,cIndTab1,cKey1,,,"Ordenando Arquivo de trabalho !!!")
IndRegua(cAliasSEL,cIndTab2,cKey2,,,"Ordenando Arquivo de trabalho !!!")
IndRegua(cAliasSEL,cIndTab3,cKey3,,,"Ordenando Arquivo de trabalho !!!")

(cAliasSEL)->(dbClearIndex())
(cAliasSEL)->(dbSetIndex(cIndTab1+OrdBagExt()))
(cAliasSEL)->(dbSetIndex(cIndTab2+OrdBagExt()))
(cAliasSEL)->(dbSetIndex(cIndTab3+OrdBagExt()))

//CfmCarrega() // Carrega temporario

Define MsDialog oDlgFil Title "Selecao de Notas Fiscais - Romaneio" From 1,1 To 505,900 OF oMainWnd PIXEL

oDlgFil:lEscClose := .F. // Desabilita fechar apertando a tecla escape ESC.

@ 005,005 Say "Emissao:" Of oDlgFil Pixel //SIZE 050,006
@ 013,005 Say "De" Of oDlgFil Pixel //SIZE 050,006
@ 013,069 Say "Ate" Of oDlgFil Pixel //SIZE 050,006
@ 012,015 Get dDataIni Picture "@D" Size 050,006 Valid CfmValData(1) When lDataPrc Object oDlgDat// HASBUTTON
@ 012,080 Get dDataFim Picture "@D" Size 050,006 Valid CfmValData(2) When lDataPrc Object oDlgDat// HASBUTTON

oMark  := MsSelect():New(cAliasSEL,"F2_OK",,aCampos,@lInverte,cMarca,{070,001,250,450})

oButFiltr := tButton():New(010,160,"Filtrar" ,oDlgFil,{|| CfmCarrega() },030,010,,,,.T.)
oButOk    := tButton():New(010,418,"OK"      ,oDlgFil,{|| fOkDlg(.T.)     },030,010,,,,.T.)
oButSair  := tButton():New(023,418,"Sair"    ,oDlgFil,{|| fCloseODlg() },030,010,,,,.T.)

ObjectMethod(oMark:oBrowse,"Refresh()")
oMark:bMark := {|| fRegSel()}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := {|| fMarkAll()}
oMark:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}

Activate MsDialog oDlgFil Centered

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+-------------------------------+------------------+||
||| Programa: CfmCarrega | Autor: Celso Ferrone Martins  | Data: 23/09/2014 |||
||+-----------+----------+-------------------------------+------------------+||
||| Descricao | Carrega TMP                                                 |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function CfmCarrega()

Local lRet      := CfmValData(2)
Local nPosNota  := aScan(oGrid:aHeader,{|x| Alltrim(x[2])=="Z14_NOTA"})  // Nota
Local nPosSerie := aScan(oGrid:aHeader,{|x| Alltrim(x[2])=="Z14_SERIE"}) // Serie
Local cA4VqVerq := Posicione("SA4",1,xFilial("SA4")+_cTransp,"A4_VQ_VERQ")//SA4->A4_VQ_VERQ

If !lRet
	Return()
EndIf

(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(Eof())
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->(DbDelete())
	MsUnLock()
	(cAliasSEL)->(DbSkip())
EndDo

cQuery := " SELECT * FROM ( "

cQuery += " SELECT F2_FILIAL, F2_DOC, F2_SERIE, F4_DUPLIC,  F2_EMISSAO, F2_CLIENTE, F2_LOJA, A1_NOME, F2_TRANSP, A4_NOME, F2_VALBRUT, F2_PLIQUI, F2_PBRUTO, F2_VQ_FRET, F2_VQ_FCLI, F2_VQ_FVER  FROM " + RetSqlName("SF2") + " SF2 "
cQuery += "    INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "       SA1.D_E_L_E_T_ <> '*' "
cQuery += "       AND A1_FILIAL = '"+xFilial("SA1")+"' "
cQuery += "       AND A1_COD    = F2_CLIENTE "
cQuery += "       AND A1_LOJA   = F2_LOJA "
cQuery += "    INNER JOIN " + RetSqlName("SA4") + " SA4 ON "
cQuery += "       SA4.D_E_L_E_T_ <> '*' "
cQuery += "       AND A4_FILIAL = '"+xFilial("SA4")+"' "
cQuery += "       AND A4_COD    = F2_TRANSP "   
cQuery += "    INNER JOIN " + RetSqlName("SD2") + " SD2 ON    "		
cQuery += "       SD2.D_E_L_E_T_ <> '*'	   "	 
cQuery += "       AND D2_FILIAL = '"+xFilial("SD2")+"'	   "	 
cQuery += "       AND D2_DOC 	= F2_DOC   "
cQuery += "    INNER JOIN " + RetSqlName("SF4") + "  SF4 ON    "	
cQuery += "       SF4.D_E_L_E_T_ <> '*'	   "
cQuery += "       AND F4_FILIAL = '"+xFilial("SF4")+"' 	   "
cQuery += "       AND F4_CODIGO  = D2_TES  "
cQuery += " WHERE "
cQuery += "    SF2.D_E_L_E_T_ <> '*' "
cQuery += "    AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += "    AND F2_TIPO NOT IN ('D','B') "
cQuery += "    AND F2_EMISSAO BETWEEN '"+dTos(dDataIni)+"' AND '"+dTos(dDataFim)+"' "
cQuery += "    AND F2_TRANSP  = '"+_cTransp+"' "      
cQuery += "    AND F4_DUPLIC = 'S' "
If cTipoE == "E"
	cQuery += "    AND F2_VQ_ROMA = '      ' "
EndIf
/*
cQuery += "    AND CONCAT(F2_DOC,F2_SERIE) NOT IN ( "
cQuery += "      SELECT CONCAT(Z14_NOTA,Z14_SERIE) FROM " + RetSqlName("Z13") + " Z13 "
cQuery += "        INNER JOIN " + RetSqlName("Z14") + " Z14 ON "
cQuery += "          Z14.D_E_L_E_T_ <> '*' "
cQuery += "          AND Z14_FILIAL = Z13_FILIAL "
cQuery += "          AND Z14_NUMERO = Z13_NUMERO "
cQuery += "      WHERE "
cQuery += "        Z13.D_E_L_E_T_ <> '*' "
cQuery += "        AND Z13_FILIAL = '"+xFilial("Z13")+"' "
cQuery += "        AND Z13_TRANSP = '"+_cTransp+"' "
cQuery += "        AND Z13_STATUS IN ('A','E') "
cQuery += "    ) "
*/

If cA4VqVerq == "S"
	cQuery += " UNION ALL "
	cQuery += " SELECT F2_FILIAL, F2_DOC, F2_SERIE, F4_DUPLIC,  F2_EMISSAO, F2_CLIENTE, F2_LOJA, A1_NOME, F2_TRANSP, A4_NOME, F2_VALBRUT, F2_PLIQUI, F2_PBRUTO, F2_VQ_FRET, F2_VQ_FCLI, F2_VQ_FVER  FROM " + RetSqlName("SF2") + " SF2 "
	cQuery += "    INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "       SA1.D_E_L_E_T_ <> '*' "
	cQuery += "       AND A1_FILIAL = '"+xFilial("SA1")+"' "
	cQuery += "       AND A1_COD    = F2_CLIENTE "
	cQuery += "       AND A1_LOJA   = F2_LOJA "   
	cQuery += "    INNER JOIN " + RetSqlName("SA4") + " SA4 ON "
	cQuery += "       SA4.D_E_L_E_T_ <> '*' "
	cQuery += "       AND A4_FILIAL = '"+xFilial("SA4")+"' "
	cQuery += "       AND A4_COD    = F2_TRANSP "     
	cQuery += "    INNER JOIN " + RetSqlName("SD2") + " SD2 ON    "		
	cQuery += "       SD2.D_E_L_E_T_ <> '*'	   "	 
	cQuery += "       AND D2_FILIAL = '"+xFilial("SD2")+"'	   "	 
	cQuery += "       AND D2_DOC 	= F2_DOC   "
	cQuery += "    INNER JOIN " + RetSqlName("SF4") + "  SF4 ON    "	
	cQuery += "       SF4.D_E_L_E_T_ <> '*'	   "
	cQuery += "       AND F4_FILIAL = '"+xFilial("SF4")+"' 	   "
	cQuery += "       AND F4_CODIGO  = D2_TES  "
	cQuery += " WHERE "
	cQuery += "    SF2.D_E_L_E_T_ <> '*' "
	cQuery += "    AND F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += "    AND F2_TIPO NOT IN ('D','B') "
	cQuery += "    AND F2_EMISSAO BETWEEN '"+dTos(dDataIni)+"' AND '"+dTos(dDataFim)+"' "
	cQuery += "    AND F2_TRANSP  <> '"+_cTransp+"' "
	cQuery += "    AND (F2_VQ_FCLI = 'D' OR F2_VQ_FVER = 'D') "   
	cQuery += "    AND F4_DUPLIC = 'S' "
	If cTipoE == "E"
		cQuery += "    AND F2_VQ_ROMA = '      ' "
	EndIf
EndIf

cQuery += " ) QRY GROUP BY F2_FILIAL, F2_DOC, F2_SERIE, F4_DUPLIC,  F2_EMISSAO, F2_CLIENTE, F2_LOJA, A1_NOME, F2_TRANSP, A4_NOME, F2_VALBRUT, F2_PLIQUI, F2_PBRUTO, F2_VQ_FRET, F2_VQ_FCLI, F2_VQ_FVER"
cQuery += " ORDER BY F2_FILIAL, F2_DOC, F2_SERIE "

If Select("TMPZ02") > 0
	TMPZ02->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)

TcQuery cQuery New Alias "TMPZ02"

DbSelectArea("TMPZ02")
While !TMPZ02->(Eof())
	If aScan(oGrid:aCols,{|x| x[nPosNota]+x[nPosSerie]==TMPZ02->(F2_DOC+F2_SERIE)}) == 0
		
		RecLock(cAliasSEL,.T.)
		(cAliasSEL)->F2_DOC     := TMPZ02->F2_DOC
		(cAliasSEL)->F2_SERIE   := TMPZ02->F2_SERIE
		(cAliasSEL)->F2_EMISSAO := sTod(TMPZ02->F2_EMISSAO)
		(cAliasSEL)->F2_CLIENTE := TMPZ02->F2_CLIENTE
		(cAliasSEL)->F2_LOJA    := TMPZ02->F2_LOJA
		(cAliasSEL)->A1_NOME    := TMPZ02->A1_NOME
		(cAliasSEL)->F2_TRANSP  := TMPZ02->F2_TRANSP
		(cAliasSEL)->A4_NOME    := TMPZ02->A4_NOME
		(cAliasSEL)->F2_TOTAL   := TMPZ02->F2_VALBRUT
		(cAliasSEL)->F2_PESOL   := TMPZ02->F2_PLIQUI
		(cAliasSEL)->F2_PESOB   := TMPZ02->F2_PBRUTO
		(cAliasSEL)->F2_VQ_FRET := TMPZ02->F2_VQ_FRET //V=Verquimica;C=Cliente
		(cAliasSEL)->F2_VQ_FCLI := TMPZ02->F2_VQ_FCLI //R=Retira;D=Redespacho
		(cAliasSEL)->F2_VQ_FVER := TMPZ02->F2_VQ_FVER //N=Normal;R=Negociado/Retira;D=Negociado/Redespacho
		MsUnLock()
	EndIf
	TMPZ02->(DbSkip())
EndDo

(cAliasSEL)->(DbGoTop())

If Select("TMPZ02") > 0
	TMPZ02->(DbCloseArea())
EndIf

Return()

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+------------------------------+------------------+||
||| Programa: fOrdTemp  | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+---------+------------------------------+------------------+||
||| Descricao | Organiza MsSelect. Altera o indice de selecao             |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fOrdTemp(obj, col)

If col != 1
	
	Do Case
		Case col == 2
			DbSelectArea(cAliasSEL) ; DbSetOrder(1)
		Case col == 5
			DbSelectArea(cAliasSEL) ; DbSetOrder(2)
		Case col == 4
			DbSelectArea(cAliasSEL) ; DbSetOrder(3)
	EndCase
	
	(cAliasSEL)->(DbGoTop())
	
	oMark:oBrowse:Refresh(.T.)
	oDlgFil:Refresh()
	
EndIf

Return()

/*
============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+------------------------------+------------------+||
||| Programa: fRegSel  | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+--------+------------------------------+------------------+||
||| Descricao | Seleciona itens do MsSelect                              |||
||+-----------+----------------------------------------------------------+||
||| Alteracao |                                                          |||
||+-----------+----------------------------------------------------------+||
||| Uso       |                                                          |||
||+-----------+----------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
============================================================================
*/
Static Function fRegSel()

Local lRet := .T.

If Marked("F2_OK")
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->F2_OK := cMarca
	(cAliasSEL)->(MsUnlock())
Else
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->F2_OK := "  "
	(cAliasSEL)->(MsUnlock())
Endif

oMark:oBrowse:Refresh(.t.)
oDlgFil:Refresh()

Return(lRet)

/*
============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+------------------------------+------------------+||
||| Programa: fMarkAll | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+--------+------------------------------+------------------+||
||| Descricao | Marca todos os registros do MsSelect                     |||
||+-----------+----------------------------------------------------------+||
||| Alteracao |                                                          |||
||+-----------+----------------------------------------------------------+||
||| Uso       |                                                          |||
||+-----------+----------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
============================================================================
*/
Static Function fMarkAll()

Local nREC  := (cAliasSEL)->(Recno())
Local lRet  := .T.
Local lMack := .T.

(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(EOF())
	RecLock(cAliasSEL,.F.)
	If Empty((cAliasSEL)->F2_OK)
		(cAliasSEL)->F2_OK := cMarca
		lMack := .T.
	Else
		(cAliasSEL)->F2_OK := "  "
		lMack := .F.
	Endif
	(cAliasSEL)->(MsUnlock())
	
	(cAliasSEL)->(DbSkip())
EndDo

(cAliasSEL)->(DbGoTo(nREC))
oMark:oBrowse:Refresh(.t.)
oDlgFil:Refresh()

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fOkDlg    | Autor: Celso Ferrone Martins  | Data: 17/04/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Define selecao. Encerra ou atualiza                        |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fOkDlg(lRet)

Local lEncerra := .F.
Default lRet   := .F.

If lRet
	If MsgYesNo("Deseja incluir os itens selecionados ?","Atencao!")
		If lRet
			fAtualiza()
		EndIf
		lEncerra := .T.
	EndIf
Else
	lEncerra := .T.
EndIf

If lEncerra
	fCloseODlg()
EndIf

Return(.F.)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fAtualiza | Autor: Celso Ferrone Martins  | Data: 17/04/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Atualiza tabela de preco                                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fAtualiza()

Processa({|| fCfmNFis() },"Processando Notas...")

//MsgAlert("Processamento executado com sucesso.","Fim do processamento.")

Return()


/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fLimpSc6  | Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fCloseODlg()


If Select(cAliasSEL) > 0
	(cAliasSEL)->(DbCloseArea())
EndIf

Close(oDlgFil)

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmValData | Autor: Celso Ferrone Martins | Data: 21/11/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmValData(nOpc)

Local lRet := .T.

If nOpc == 1
	If Empty(dDataIni)
		//		lRet := .F.
		//		MsgAlert("Data nao pode ser branco.","Atencao!!!")
	ElseIf !Empty(dDataFim)
		If dDataIni > dDataFim
			lRet := .F.
			MsgAlert("Datas com Divergencia","Atencao!!!")
		EndIf
	EndIf
Else
	If Empty(dDataFim)
		//		lRet := .F.
		//		MsgAlert("Data nao pode ser branco.","Atencao!!!")
	ElseIf !Empty(dDataIni)
		If dDataIni > dDataFim
			lRet := .F.
			MsgAlert("Datas com Divergencia","Atencao!!!")
		EndIf
	EndIf
EndIf

oDlgDat:Refresh()

Return(lRet)


/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmNFis  | Autor: Celso Ferrone Martins   | Data: 23/09/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Materiais com a mesma materia prima para ajuste de tabela   |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function fCfmNFis()

Local aAreaSel := (cAliasSEL)->(GetArea())

Local nPosNf	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_NOTA"})
Local nPosSer	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_SERIE"})
Local nPosEmi	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_EMISSA"})
Local nPosCli	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_CLIENT"})
Local nPosLoj	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_LOJA"})
Local nPosDesc	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_DESCLI"})
Local nPosTNf	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_TOTNF"})
Local nPosTPL	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_TOTPLI"})
Local nPosTPB	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_TOTPBR"})

Local nPosFRE	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_VQ_FRE"})
Local nPosFVE	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_VQ_FVE"})
Local nPosFCL	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_VQ_FCL"})

Local nPosTran	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_TRANSP"})
Local nPosNTra	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z14_DESTRA"})

(cAliasSEL)->(DbSetOrder(1))
(cAliasSEL)->(DbGoTop())

While !(cAliasSEL)->(Eof())
	
	IncProc()
	
	If !Empty((cAliasSEL)->F2_OK)
		
		If Empty(oGrid:aCols[1][nPosNf])
			nPosCols := 1
		Else
			AAdd(oGrid:aCols,0)
			nPosCols := Len(oGrid:aCols)
			oGrid:aCols[nPosCols] := aClone(aNewCols)
		EndIf
		
		oGrid:aCols[nPosCols][nPosNf]   := (cAliasSEL)->F2_DOC
		oGrid:aCols[nPosCols][nPosSer]  := (cAliasSEL)->F2_SERIE
		oGrid:aCols[nPosCols][nPosCli]  := (cAliasSEL)->F2_CLIENTE
		oGrid:aCols[nPosCols][nPosLoj]  := (cAliasSEL)->F2_LOJA
		oGrid:aCols[nPosCols][nPosDesc] := (cAliasSEL)->A1_NOME
		oGrid:aCols[nPosCols][nPosEmi]  := (cAliasSEL)->F2_EMISSAO
		oGrid:aCols[nPosCols][nPosTNf]  := (cAliasSEL)->F2_TOTAL
		oGrid:aCols[nPosCols][nPosTPL]  := (cAliasSEL)->F2_PESOL
		oGrid:aCols[nPosCols][nPosTPB]  := (cAliasSEL)->F2_PESOB
		oGrid:aCols[nPosCols][nPosFRE]  := (cAliasSEL)->F2_VQ_FRET
		oGrid:aCols[nPosCols][nPosFVE]  := (cAliasSEL)->F2_VQ_FVER
		oGrid:aCols[nPosCols][nPosFCL]  := (cAliasSEL)->F2_VQ_FCLI
		oGrid:aCols[nPosCols][nPosTran] := (cAliasSEL)->F2_TRANSP
		oGrid:aCols[nPosCols][nPosNTra] := (cAliasSEL)->A4_NOME
	EndIf
	
	(cAliasSEL)->(DbSkip())
EndDo

(cAliasSEL)->(RestArea(aAreaSel))

nTotPeBr := 0 //"Total Peso Bru.:"
nTotPeLi := 0 //"Total Peso LÌq.:"
nTotNoFi := 0 //"Total Nota Fis.:"

For nX := 1 To Len(oGrid:aCols)
	If !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
		nTotPeBr += oGrid:aCols[nX][nPosTPB]
		nTotPeLi += oGrid:aCols[nX][nPosTPL]
		nTotNoFi += oGrid:aCols[nX][nPosTNf]
	EndIf
Next nX

lTransp := .F.
oTransp:Refresh()

oTotPeBr:Refresh()
oTotPeLi:Refresh()
oTotNoFi:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: AxImpZ13   | Autor: Celso Ferrone Martins | Data: 15/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function AxImpZ13()

Local lPrtRel := .T.

If Z13->Z13_STATUS == "C"
	MsgAlert("Nae e possivel fazer impressao de item cancelado.","Atencao!!!")
	lPrtRel := .F.
ElseIf Z13->Z13_STATUS == "A"
	If MsgYesNo("A impressao do romaneio ira encerrar o documento. Deseja prosseguir ?","Atencao!!!")
		RecLock("Z13",.F.)
		Z13->Z13_STATUS := "E"
		MsUnLock()
	Else
		lPrtRel := .F.
	EndIf
EndIf

If lPrtRel
	//	U_RelEntr(.T.)
	U_CfmRRoma(.T.)
EndIf

Return()
