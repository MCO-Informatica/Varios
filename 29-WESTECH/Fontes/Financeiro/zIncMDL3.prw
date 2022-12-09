#Include 'Protheus.ch'
#Include "TOTVS.ch"

User Function zIncMDL3()


Private cCadastro := "Modelo 3"
Private cFornece  := ""
Private cAlias1   := "ZZC"            // Alias da Enchoice. Tabela Pai   CAPA
Private cAlias2   := "ZZD"            // Alias da GetDados. Tabela Filho ITEM
Private cIniCpos  := "+ZZD_ITEM"       // Campo que vai auto incrementar
Private nTotal    := 0

Private aRotina   := {}
Private aSize     := {}
Private aInfo     := {}
Private aObj      := {}
Private aPObj     := {}
Private aPGet     := {}
Private _cRetorno


Private cUsuario := AllTrim(RetCodUsr())
Private cColab	 := AllTrim(UsrFullName(RetCodUsr()))
Private cCargo 	:= "" //PSWRET()[1][14]

Private bCampo    := {|nField| FieldName(nField) }

Private oTotal

	PswOrder(1)
	If PswSeek(RetCodUsr(), .T. )
		cCargo := PSWRET()[1][14]
	endif

	// Retorna a area util das janelas Protheus
	aSize := MsAdvSize()

	// Ser� utilizado tr�s �reas na janela
	// 1� - Enchoice, sendo 80 pontos pixel
	// 2� - MsGetDados, o que sobrar em pontos pixel � para este objeto
	// 3� - Rodap� que � a pr�pria janela, sendo 15 pontos pixel

	AADD( aObj, { 100, 210, .T., .F. })
	AADD( aObj, { 100, 300, .T., .T. })
	AADD( aObj, { 100, 015, .T., .F. })

	// C�lculo autom�tico da dimens�es dos objetos (altura/largura) em pixel

	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPObj := MsObjSize( aInfo, aObj )

	// C�lculo autom�tico de dimens�es dos objetos MSGET

	aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

	AADD( aRotina, {"Pesquisar"  , "AxPesqui" , 0, 1} )
	AADD( aRotina, {"Visualizar" , 'U_zInvMnt', 0, 2} )
	AADD( aRotina, {"Incluir"    , 'U_zInvMnt', 0, 3} )
	AADD( aRotina, {"Alterar"    , 'U_zInvMnt', 0, 4} )
	AADD( aRotina, {"Excluir"    , 'U_zInvMnt', 0, 5} )
	AADD( aRotina, {"Imprimir" 	 , 'U_zInvMnt',0,6})

	dbSelectArea(cAlias1)
	dbSetOrder(1)
	dbGoTop()

	MBrowse(,,,,cAlias1)

Return()

//**********************************************************************************************************
//+--------------------------------------------------------------------+
//| Autor | TOTS CTT                               | Data |            |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para incluir dados.                                |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o.                              |
//+--------------------------------------------------------------------+

User Function zInvInc( cAlias1, nReg, nOpc )

Local oDlg
Local oGet
Local nX    := 0
Local nOpcA := 0

Local cDelOk   := "AllwaysTrue"
Local cFieldOk := "AllwaysTrue"
Local cLinOk   := "U_zInvLOk"    // Fun�ao para valida��o da linha
Local cTudoOk  := "U_zInvTOk"    // Fun�ao para valida��o de todas as linhas

Local lDeleta  := .T.

Private aHeader := {}
Private aCOLS   := {}
Private aGets   := {}
Private aTela   := {}

RegToMemory(cAlias1, (nOpc==3)) // Carregando para memoria campos  memoria M->
RegToMemory(cAlias2, (nOpc==3)) // Carregando para memoria campos  memoria M->

zInvaHeader(cAlias1, cAlias2)      // Chamada da Func�o que monta monta Header

zInvaCOLS(cAlias1, cAlias2, nOpc )// Chamada da Func�o que monta o Cols


	// Montando a estrutura da tela \\
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7], aSize[1] TO aSize[6], aSize[5] OF oMainWnd PIXEL

		EnChoice( cAlias1, nReg, nOpc, , , , , aPObj[1]) // Montando a estrutura da tabela SC5

	// Estrutura do campo Valor na tela
		@ aPObj[3,1], aPGet[1,3] SAY "Valor Total: " SIZE 70,7 OF oDlg                                 PIXEL
		@ aPObj[3,1], aPGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 999,999,999.99" SIZE 70,7 OF oDlg PIXEL

		// Fun��o que monta MODELO03 GRID
		oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4], nOpc,cLinOk,cTudoOk,cIniCpos,lDeleta,,,,,cFieldOk,,,cDelOk,,,)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF( Obrigatorio( aGets, aTela ), ( nOpcA := 1, oDlg:End() ), NIL) },{|| oDlg:End() })

	If nOpcA == 1 .And. nOpc == 3
		zInvGrv( cAlias1, cAlias2, nOpc )
	   ConfirmSX8()
	Endif

Return( NIL )

//+--------------------------------------------------------------------+
//| Rotina | Mod3Mnt | Autor |                      | Data |           |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. 									  |
//+--------------------------------------------------------------------+

User Function zInvMnt( cAlias, nReg, nOpc )

Local nX       := 0
Local nOpcA    := 0
Local cDelOk   := "AllwaysTrue"
Local cFieldOk := "AllwaysTrue"

Local cLinOk   := "U_zInvLOk"    // Fun�ao para valida��o da linha
Local cTudoOk  := "U_zInvTOk"  // Fun�ao para valida��o de todas as linhas
Local lDeleta  := .T.
Local oDlg, oGet

Private aHeader := {}
Private aCOLS   := {}
Private aGets   := {}
Private aTela   := {}
Private aREG    := {}

	//Cria variaveis de memoria dos campos da tabela Pai Capa.
	RegToMemory(cAlias1, (nOpc==3))

	//Cria variaveis de memoria dos campos da tabela Filho Item.
	RegToMemory(cAlias2, (nOpc==3))

	zInvaHeader(cAlias1, cAlias2)

	zInvaCOLS(cAlias1, cAlias2, nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	EnChoice( cAlias, nReg, nOpc, , , , , aPObj[1])
// Atualiza��o do nome do Fornecedor
	//@ aPObj[3,1],aPGet[1,1] SAY "Total Invoice: " SIZE 70,7 OF oDlg PIXEL
	//@ aPObj[3,1],aPGet[1,2] SAY oFornece VAR cFornece SIZE 98,7 OF oDlg PIXEL
// Atualiza��o do total
	//@ aPObj[3,1],aPGet[1,3] SAY "Valor Total: " SIZE 70,7 OF oDlg PIXEL
	//@ aPObj[3,1],aPGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 999,999,999.99" SIZE 70,7 OF oDlg PIXEL

	//U_Mod3Cli() // Dados do Fornecedor
	//U_zInvLOk() // Somas do Produto

	oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4], nOpc,cLinOk,cTudoOk,cIniCpos,lDeleta,,,,,cFieldOk,,,cDelOk,,,)

 ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF( Obrigatorio( aGets, aTela ), ( nOpcA := 1, oDlg:End() ), NIL ) },{|| oDlg:End() })

If ! Empty( nOpc) .And. nOpcA <> 0
	zInvGrv( cAlias1, cAlias2, nOpc, aREG ) // Grava dados
Else
	RollBackSX8()
EndIf

Return( NIL )
//************************************************************************************************************************

//+--------------------------------------------------------------------+
//| Rotina | Mod3aHeader | Autor |                         |Data|      |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+

Static Function zInvaHeader(cAlias1, cAlias2)
Local aArea := GetArea()

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias2)

	While !SX3->(EOF()) .And. SX3->X3_ARQUIVO == cAlias2
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL

	      AADD( aHeader, { Trim( X3Titulo() ) ,;
										X3_CAMPO     ,;
							            X3_PICTURE   ,;
										X3_TAMANHO   ,;
								        X3_DECIMAL   ,;
										X3_VALID     ,;
								        X3_USADO	 ,;
								        X3_TIPO		 ,;
								        X3_ARQUIVO	 ,;
								        X3_CONTEXT     })
		Endif
		SX3->(dbSkip())
	EndDo

RestArea(aArea)

Return()


//--------------------------------------------------------------------------------------------------------------------

Static Function zInvaCOLS(cAlias1, cAlias2, nOpc )

Local cChave := ""


Local nI := 0

Private cUsuario := AllTrim(RetCodUsr())
Private cColab	 := AllTrim(UsrFullName(RetCodUsr()))
Private cEmail 	:= "" //PSWRET()[1][14]

	PswOrder(1)
	If PswSeek(RetCodUsr(), .T. )
		cEmail := PSWRET()[1][14]
	endif


If nOpc <> 3 // diferente de incluir


	cChave := (cAlias1)->ZZC_INVOIC
	_cRetorno := (cAlias1)->ZZC_PEDIDO

	dbSelectArea( cAlias2 )
	dbSetOrder(1)
	dbSeek( xFilial(cAlias2) + cChave )

	While ! (cAlias2)->( EOF() ) .AND. ( (cAlias2)->ZZD_FILIAL == xFilial(cAlias2) .AND. (cAlias2)->ZZD_INVOIC == cChave )
		AADD( aREG, ZZD->( RecNo() ) )
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )

		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif

		
		Next nI

		aCOLS[ Len( aCOLS ), Len( aHeader ) + 1 ] := .F. //Adicionando o campo do Delete

		(cAlias2)->(dbSkip())

	EndDo

Else
	

	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )

	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	//M->ZZC_IDEMIS := cUsuario
	//M->ZZC_NOMEMI := cColab
	//M->ZZC_EMAILE := cEmail

	aCOLS[1, AScan(aHeader,{|x| Trim(x[2])=="ZZD_ITEM"})] := "01" // Atribui no valor := 01 na array na possi��o do Z3_ITEM
	aCOLS[1, Len( aHeader ) + 1 ] := .F.                         // Criar o elemento para deletar a linha

Endif


Return()
//--------------------------------------------------------------------------------------------------------------------

//+--------------------------------------------------------------------+
//| Rotina | Mod3Cli | Autor | TOTVS CTT |           Data |            |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para atualizar a vari�vel com o nome do cliente.   |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o.                              |
//+--------------------------------------------------------------------+
/*
User Function Mod3Cli()
Local lRet := .T.

	cFornece := Posicione( "SA2", 1, xFilial("SA2") + M->Z2_CODFOR + M->Z2_LOJAFOR, "A2_NREDUZ" )
	oFornece:Refresh()

Return(lRet)
*/
//--------------------------------------------------------------------------------------------------------------------


//+--------------------------------------------------------------------+
//| Rotina | Mod3LOk | Autor | TOTVSCTT                     |Data |    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para atualizar a varadmini�vel com o total dos itens. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+
User Function zInvLOk()

Local lRet := .T.
Local nI :=0
Local nQtdVen := nPrcven := 0

	nPrcven :=  AScan(aHeader,{|x| Trim(x[2])=="ZZD_QUANT"})
	nQtdVen :=  AScan(aHeader,{|x| Trim(x[2])=="ZZD_VLRUNI"})

	nTotal := 0

	For nI := 1 To Len( aCOLS )

		If aCOLS[nI,Len(aHeader)+1]
			Loop
		Endif

		nTotal += Round( aCOLS[ nI, nQtdVen ] * aCOLS[ nI, nPrcven ], 2 )

	Next nI

	//oTotal:Refresh()

Return(lRet)


//+--------------------------------------------------------------------+
//| Rotina | Mod3Grv | Autor | TOTVSCTT             |Data |            |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para efetuar a grava��o nas tabelas. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+

Static Function zInvGrv( cAlias1, cAlias2, nOpc, aREG )
Local nX := 0
Local nI := 0

Local nTotReg		:= 0
	Local nSequencia	:= 0
	Local nAno			:= substr(dtos(dDatabase),4,1)

	BEGINSQL ALIAS "TR1"
	     SELECT * FROM ZZC010 WHERE substring(ZZC_INVOIC,9,1) = substring(CONVERT(VARCHAR, GetDate(), 120), 4,1)  AND  D_E_L_E_T_ <> '*'
	ENDSQL

	nTotReg := Contar("TR1","!Eof()") + 1
 	nSequencia := '80' + '-' + cValToChar(STRZERO(nTotReg,4)) + '-' + nAno


	If nOpc == 3 //INCLUS�O

	// Grava os itens

		dbSelectArea(cAlias2)
		dbSetOrder(1)

		For nX := 1 To Len( aCOLS )
			If ! aCols[nX][Len(aHeader)+1]       // Valida se a linha esta deletada

				RecLock( cAlias2, .T. )

					For nI := 1 To Len( aHeader )
						FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCOLS[nX,nI] )
					Next nI

					ZZD->ZZD_FILIAL := xFilial("ZZD")
					ZZD->ZZD_INVOIC    := nSequencia
					ZZD->ZZD_CLIENT    := M->ZZC_CLIENT
					ZZD->ZZD_PEDIDO    := M->ZZC_PEDIDO

					//// SZ3->Z3_COD    := SZ2->Z2_COD

				MsUnLock()
			Endif
		Next nX

	// Grava o Cabe�alho

		dbSelectArea( cAlias1 )
		RecLock( cAlias1, .T. )

			For nX := 1 To (cAlias1)->( FCount() )
				If "FILIAL" $ FieldName( nX )
					FieldPut( nX, xFilial( cAlias1 ) )
				Else
					FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
				Endif
				ZZC->ZZC_INVOIC := nSequencia


			Next nX
		MsUnLock()


	Endif


	If nOpc == 4 //ALTERA��O

	// Grava os itens conforme as altera��es
		dbSelectArea(cAlias2)
		dbSetOrder(1)

		For nX := 1 To Len( aCOLS )
			If nX <= Len( aREG )
				dbGoto( aREG[nX] )

				RecLock(cAlias2,.F.)
					If aCOLS[ nX, Len( aHeader ) + 1 ]
						dbDelete()
					Endif
			Else
				If !aCOLS[ nX, Len( aHeader ) + 1 ]
					RecLock( cAlias2, .T. )
				Endif
			Endif

			If !aCOLS[ nX, Len(aHeader)+1 ]

				For nI := 1 To Len( aHeader )
					FieldPut( FieldPos( Trim( aHeader[ nI, 2] ) ),;
					aCOLS[ nX, nI ] )
				Next nI

				ZZD->ZZD_FILIAL := xFilial("ZZD")
				ZZD->ZZD_INVOIC    := M->ZZC_INVOIC

			Endif

			MsUnLock()

		Next nX

	// Grava o Cabe�alho

		dbSelectArea(cAlias1)

		RecLock( cAlias1, .F. )

			For nx := 1 To (cAlias1)->(FCount())
				If "FILIAL" $ FieldName( nX )
					FieldPut( nX, xFilial(cAlias1))
				Else
					FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
				Endif
			Next nx

		MsUnLock()

	Endif


	If nOpc == 5 // EXCLUS�O



		// Deleta os Itens
		dbSelectArea("ZZD")
		dbSetOrder(1)

		dbSeek(xFilial("ZZD") + M->ZZC_INVOIC)

		While ! (cAlias2)->(EOF()) .AND. ( (cAlias2)->ZZD_FILIAL+(cAlias2)->(ZZD_INVOIC) == xFilial(cAlias1)+M->ZZC_INVOIC)
			RecLock(cAlias2, .F.)
				dbDelete()
			MsUnLock()
			(cAlias2)->(dbSkip())
		EndDo

		// Deleta o Cabe�alho
		dbSelectArea(cAlias1)

		RecLock(cAlias1,.F.)
			dbDelete()
		MsUnLock()


	Endif

	If nOpc == 6 // Imprimir
		u_zInvPrint()
	end if

	
	(cAlias1)->(DbCloseArea())
	(cAlias2)->(DbCloseArea())
	

	ConfirmSX8()
	TR1->(dbclosearea())

Return( NIL )
