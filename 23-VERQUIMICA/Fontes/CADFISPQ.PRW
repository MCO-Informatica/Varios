#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADFISPQ  ºAutor  ³Nelson Junior       º Data ³  07/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de cadastro da FISPQ (Ficha de Informações de Segurançaº±±
±±º          ³de Produto Químico)                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CadFispq()

Private aRotina := {}

DbSelectArea("Z09")
Z09->(DbSetOrder(1))

aAdd(aRotina,{"Pesquisar"	,"AxPesqui()"   ,0,1,0,Nil})
aAdd(aRotina,{"Visualizar"	,"U_AxIncZ09(2)",0,2,0,Nil})
aAdd(aRotina,{"Incluir"		,"U_AxIncZ09(3)",0,3,0,Nil})
aAdd(aRotina,{"Alterar"     ,"U_AxIncZ09(4)",0,4,0,Nil})
aAdd(aRotina,{"Excluir"     ,"U_AxIncZ09(5)",0,5,0,Nil})

mBrowse(6, 1, 22, 75, "Z09",,,,,,)

Return()

User Function AxIncZ09(nOpc)

//Variáveis da MsNewGetDados()
Local nStyle        := If(nOpc==3 .Or. nOpc==4,GD_INSERT+GD_UPDATE+GD_DELETE,0) // Opção da MsNewGetDados
Local cLinhaOk     	:= "U_AxZ10LOK()"					  						// Funcao executada para validar o contexto da linha atual do aCols (Localizada no Fonte GS1008)
Local cTudoOk      	:= "AllwaysTrue"					 						// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cTdOkLk      	:= "AllwaysTrue"											// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""														// Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze      	:= 000														// Campos estaticos na GetDados.
Local nMax         	:= 999														// Numero maximo de linhas permitidas.
Local aAlter    	:= {}	   													// Campos a serem alterados pelo usuario
Local cFieldOk     	:= "AllwaysTrue"											// Funcao executada na validacao do campo
Local cSuperDel     := "AllwaysTrue"											// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk        := "AllwaysTrue"											// Funcao executada para validar a exclusao de uma linha do aCols
Local cBChange		:= ""

Local aSize         := {}
Local aInfo         := {}
Local aPosObj       := {}
Local aPosGet       := {}
Local aObjects      := {}
Local aNoFields     := {"Z10_NCM","Z10_PRODUT"}

Local cSeek         := If(nOpc == 3,"",xFilial("Z09")+Z09->(Z09_NCM+Z09_PRODUT))
Local bWhile        := If(nOpc == 3,{||},{|| Z10_FILIAL+Z10_NCM+Z10_PRODUT })
Local cQueryFil     := ""

Local aPalavra		:= {"", "1=Perigo", "2=Atenção"}

Private cPalavra	:= ""

Private cNcm		:= Space(8)
Private cDesNcm		:= Space(40)
Private cProd		:= Space(15)
Private cDesProd	:= Space(30)
Private cImg1		:= Space(100)
Private cImg2		:= Space(100)
Private cImg3		:= Space(100)
Private cImg4		:= Space(100)

If nOpc <> 3
	cNcm 	 := Z09->Z09_NCM
	cDesNcm  := Posicione("SYD",1,xFilial("SYD")+cNcm,"YD_DESC_P")
	cProd    := Z09->Z09_PRODUT
	cDesProd := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")
	cPalavra := Z09->Z09_PALAVR
	cImg1	 := Z09->Z09_IMG1
	cImg2	 := Z09->Z09_IMG2
	cImg3	 := Z09->Z09_IMG3
	cImg4	 := Z09->Z09_IMG4
EndIf

aSize   := MsAdvSize()

Aadd(aObjects,{100,100,.T.,.T.})
Aadd(aObjects,{100,100,.T.,.T.})
Aadd(aObjects,{100,020,.T.,.T.})

aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}})

FillGetDados(nOpc,"Z10",1,cSeek,bWhile,/*uSeekFor*/,aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQueryFil*/,/*bMontCols*/,If(nOpc==3,.T.,.F.),/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bBeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/,/*bCriaVar*/,/*lUserFields*/,/*lUserFields*/)

DEFINE MSDIALOG oDlg FROM aSize[7],000 TO aSize[6],aSize[5] TITLE "FISPQ (Ficha de Informações de Segurança de Produto Químico)" OF oMainWnd PIXEL

oDlg:lMaximized := .T.

@ 006+30,005 SAY "NCM:"	 		  								 	 														 						OBJECT oLabel
@ 005+30,040 GET cNcm	F3 "SYD1" PICTURE "@R 9999.99.99"	SIZE 055,030 WHEN If(nOpc==3,.T.,.F.) VALID If(Vazio(), cDesNcm := "", BuscaNcm())	   		OBJECT oLabel
@ 005+30,100 GET cDesNcm		  PICTURE "@!"  		 	SIZE 200,030 WHEN	.F.												   				  		OBJECT oDesNcm

@ 026+30,005 SAY "Produto:"	 		  											  								   		   							OBJECT oLabel
@ 025+30,040 GET cProd	F3 "SB1"  PICTURE "@!" 				SIZE 055,030 WHEN If(nOpc==3,.T.,.F.)  VALID If(Vazio(), cDesProd := "", BuscaProduto())	OBJECT oLabel
@ 025+30,100 GET cDesProd		  PICTURE "@!" 				SIZE 200,030 WHEN	.F.									   		 							OBJECT oDesProd

@ 046+30,005 SAY "Palavra Adv.:" 		  											  								   		   							OBJECT oLabel
@ 045+30,040 COMBOBOX cPalavra ITEMS aPalavra				SIZE 055,030 WHEN If(nOpc==3.Or.nOpc==4,.T.,.F.)  														PIXEL OF oDlg

@ 006+30,325 SAY "Imagem 1:"	 		  			 						  											  								OBJECT oLabel
@ 005+30,355 GET cImg1	F3 "DIR"  PICTURE "@!" 		 		SIZE 150,030 WHEN If(nOpc==3.Or.nOpc==4,.T.,.F.)							 							OBJECT oLabel

@ 026+30,325 SAY "Imagem 2:"	 		  									  										  									OBJECT oLabel
@ 025+30,355 GET cImg2	F3 "DIR"  PICTURE "@!" 				SIZE 150,030 WHEN If(nOpc==3.Or.nOpc==4,.T.,.F.)					 									OBJECT oLabel

@ 046+30,325 SAY "Imagem 3:"	 		  									  																			OBJECT oLabel
@ 045+30,355 GET cImg3	F3 "DIR"  PICTURE "@!" 				SIZE 150,030 WHEN If(nOpc==3.Or.nOpc==4,.T.,.F.)							   							OBJECT oLabel

@ 066+30,325 SAY "Imagem 4:"	 		  									  												   							OBJECT oLabel
@ 065+30,355 GET cImg4	F3 "DIR"  PICTURE "@!" 				SIZE 150,030 WHEN If(nOpc==3.Or.nOpc==4,.T.,.F.)														OBJECT oLabel

oGrid:=MsNewGetDados():New(aPosObj[1][1]+90,aPosObj[1][2],aPosObj[3][3],aPosObj[3][4],nStyle,cLinhaOk,cTudoOk,cIniCpos,/*aAlter*/,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDlg,aHeader,aCols,cBChange)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||If(CadTudoOK(nOpc),oDlg:End(),.F.)},{||oDlg:End()},,/*aButtons*/) CENTERED

Return()


Static Function BuscaNcm()

Local lRet := .F.

SYD->(DbSetOrder(1))

If SYD->(DbSeek(xFilial("SYD")+cNcm))
	cDesNcm := SYD->YD_DESC_P
	lRet 	:= .T.
Else
	cDesNcm := ""
EndIf

oDesNcm:Refresh()

Return(lRet)


Static Function BuscaProduto()

Local lRet := .F.

SB1->(DbSetOrder(1))

If SB1->(DbSeek(xFilial("SB1")+cProd))
	cDesProd := SB1->B1_DESC
	cNcm	 := SB1->B1_POSIPI
	BuscaNcm()
	//
	lRet 	 := .T.
Else
	cDesProd := ""
EndIf

oDesProd:Refresh()

Return(lRet)


User Function AxZ10LOK()

Local lRet 	  := .T.
Local nPosCod := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z10_CODIGO"})

For nX := 1 To Len(oGrid:aCols)
	//
	If oGrid:aCols[nX][nPosCod] == oGrid:aCols[oGrid:NAT][nPosCod] .And. nX != oGrid:NAT .And. !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
		MsgInfo("Código já incluído na linha "+AllTrim(Str(nX))+".")
		lRet := .F.
		Exit
	EndIf
	//
Next nX

Return(lRet)


Static Function CadTudoOK(nOpc)

Local lRet 		:= .T.
Local nPosCod 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z10_CODIGO"})
Local nPosItm 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z10_ITEMCO"})
Local nPosDes 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z10_DESCRI"})
Local nPosRec	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z10_REC_WT"})

If Empty(cNcm)
	MsgInfo("A NCM do produto é obrigatória.")
	Return(.F.)
ElseIf !U_AxZ10LOK()
	Return(.F.)
EndIf

If nOpc == 3 .Or. nOpc == 4
	//
	Z09->(DbSetOrder(1))
	//
	If nOpc == 3 .And. Z09->(DbSeek(xFilial("Z09")+ALLTRIM(cNcm)+ALLTRIM(cProd)))    //DANILO BUSSO 28/10/2015 - ALLTRIM ADICIONADO
		//
		MsgInfo("Este NCM/Produto já foi incluído.")
		Return(.F.)
		//
	ElseIf nOpc == 3 .And. Empty(cPalavra)
		//
		MsgInfo("A palavra de advertência é obrigatória.")
		Return(.F.)
		//
	Else
		//
		For nX := 1 To Len(oGrid:aCols)
			If !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
				If Empty(oGrid:aCols[nX][nPosCod])
					MsgInfo("A linha "+AllTrim(Str(nX))+" está sem o código da frase.")
					Return(.F.)
				ElseIf Empty(oGrid:aCols[nX][nPosItm])
					MsgInfo("A linha "+AllTrim(Str(nX))+" está sem o item da frase.")
					Return(.F.)
				ElseIf Empty(oGrid:aCols[nX][nPosDes])
					MsgInfo("A linha "+AllTrim(Str(nX))+" está sem a descrição da frase.")
					Return(.F.)
				EndIf
			EndIf
		Next
		//
	EndIf
EndIf

If nOpc != 5 // Diferente de Exclusão

	If nOpc == 3
		RecLock("Z09",.T.)
		Z09->Z09_FILIAL	:= xFilial("Z09")
		Z09->Z09_NCM	:= cNcm
		Z09->Z09_PRODUT	:= cProd
	ElseIf nOpc == 4
		RecLock("Z09",.F.)
	EndIf
	If nOpc == 3 .Or. nOpc == 4
		Z09->Z09_PALAVR	:= cPalavra
		Z09->Z09_IMG1	:= cImg1
		Z09->Z09_IMG2	:= cImg2
		Z09->Z09_IMG3	:= cImg3
		Z09->Z09_IMG4	:= cImg4
		Z09->(MsUnLock())		
	EndIf

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
				Z10->(DbGoTo(oGrid:aCols[nX][nPosRec]))
				RecLock("Z10",.F.)
			Else
				//
				RecLock("Z10",.T.)
				Z10->Z10_FILIAL	:= xFilial("Z10")
				Z10->Z10_NCM	:= cNcm
				Z10->Z10_PRODUT	:= cProd
				//
			EndIf
			//
			If cTipoGrv $ "A/I"
				For nY := 1 To Len(oGrid:aHeader)
					If oGrid:aHeader[nY][10] == "R"
						&("Z10->"+oGrid:aHeader[nY][2]) := oGrid:aCols[nX][nY]
					EndIf
				Next nY
			EndIf
			//
			If cTipoGrv == "E"
				Z10->(DbDelete())
			EndIf
			//
			Z10->(MsUnLock())			
			//
		EndIf
		//
	Next nX
	//
	//Mensagem solicitada pelo Danilo em 14/11/2014
	If !Empty(cProd)
		MsgInfo("Esta etiqueta foi incluída somente para o produto "+AllTrim(cProd)+" do NCM "+AllTrim(cNcm)+".")
	Else
		MsgInfo("Esta etiqueta foi incluída para todos os produtos do NCM "+AllTrim(cNcm)+".")
	EndIf
	//
Else
	//
	DbSelectArea("Z09")
	Z09->(DbSetOrder(1))
	Z09->(DbSeek(xFilial("Z09")+cNcm+cProd))
	//
	While !Z09->(Eof()) .And. Z09->(Z09_FILIAL+Z09_NCM+Z09_PRODUT) == xFilial("Z09")+cNcm+cProd
		//
		RecLock("Z09",.F.)
		Z09->(DbDelete())
		Z09->(MsUnLock())
		//
		Z09->(DbSkip())
		//
	EndDo
	//
	DbSelectArea("Z10")
	Z10->(DbSetOrder(1))
	Z10->(DbSeek(xFilial("Z10")+cNcm+cProd))
	//
	While !Z10->(Eof()) .And. Z10->(Z10_FILIAL+Z10_NCM+Z10_PRODUT) == xFilial("Z10")+cNcm+cProd
		//
		RecLock("Z10",.F.)
		Z10->(DbDelete())
		Z10->(MsUnLock())
		//
		Z10->(DbSkip())
		//
	EndDo
	//
EndIf

Return(lRet)
//
//
User Function ValFrase(cFrase, cItem)

Local cDescri := ""

If !Z08->(DbSeek(xFilial("Z08")+cFrase+cItem))
	MsgInfo("Código/item não encontrado.")
Else
	cDescri := Z08->Z08_DESCRI
EndIf

Return(cDescri)