#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"

User Function xModelo3()

Local cGrup := ""

Private cCadastro := "Relatorio de Despesas de Viagem"
Private cFornece  := ""
Private cAlias1   := "SZ2"            // Alias da Enchoice. Tabela Pai   CAPA
Private cAlias2   := "SZ3"            // Alias da GetDados. Tabela Filho ITEM
Private cIniCpos  := "+Z3_ITEM"       // Campo que vai auto incrementar
Private nTotal    := 0

Private aRotina   := {}
Private aSize     := {}
Private aInfo     := {}
Private aObj      := {}
Private aPObj     := {}
Private aPGet     := {}

Private bCampo    := {|nField| FieldName(nField) }

Private oFornece
Private oTotal
Private cIdUser  := AllTrim(RetCodUsr())
Private cUsuario := AllTrim(UsrFullName(RetCodUsr()))

Private cCargo 	 := ""

PswOrder(1)
If PswSeek(RetCodUsr(), .T. )
	cCargo := alltrim(substr(PSWRET()[1][13],1,4))
endif

PswOrder(1)
If PswSeek(RetCodUsr(), .T. )
	cGrup := alltrim(PSWRET()[1][12])
endif
			

	// Retorna a area util das janelas Protheus
	aSize := MsAdvSize()

	// Ser� utilizado tr�s �reas na janela
	// 1� - Enchoice, sendo 80 pontos pixel
	// 2� - MsGetDados, o que sobrar em pontos pixel � para este objeto
	// 3� - Rodap� que � a pr�pria janela, sendo 15 pontos pixel

	AADD( aObj, { 100, 100, .T., .F. })
	AADD( aObj, { 100, 300, .T., .T. })
	AADD( aObj, { 100, 015, .T., .F. })

	// C�lculo autom�tico da dimens�es dos objetos (altura/largura) em pixel

	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPObj := MsObjSize( aInfo, aObj )

	// C�lculo autom�tico de dimens�es dos objetos MSGET

	aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

	AADD( aRotina, {"Pesquisar"  , "AxPesqui" 	, 0, 1} )
	AADD( aRotina, {"Visualizar" , 'U_Mod3Mnt'	, 0, 2} )
	AADD( aRotina, {"Incluir"    , 'U_Mod3Mnt'	, 0, 3} )
	AADD( aRotina, {"Alterar"    , 'U_Mod3Mnt'	, 0, 4} )
	AADD( aRotina, {"Excluir"    , 'U_Mod3Mnt'	, 0, 5} )
	AADD( aRotina, {"Conferir"   , 'U_Mod3Mnt'	, 0, 6} )
	AADD( aRotina, {"Aprovacao Coordenador"		, 'U_Mod3Mnt',0,7})
	AADD( aRotina, {"Aprovacao Diretoria"		, 'U_Mod3Mnt', 0, 8} )
	AADD( aRotina, {"Imprimir" 	 , 'U_Mod3Mnt'	,0,9})
	AADD( aRotina, {"Fechar RDV" , 'U_Mod3Mnt'	,0,10})
	AADD( aRotina, {"Legenda" 	 , 'U_ConferSZ2',0,11})
	

	aCores:={{"Z2_CONFER=='1'","BR_VERDE"},;
			 {"Z2_CONFER=='2'","BR_VERMELHO"},;
			 {"Z2_CONFER=='3'","BR_AMARELO"},;
			 {"Z2_CONFER=='4'","BR_AZUL"},;
			 {"Z2_CONFER=='5'","BR_PRETO"}}

	dbSelectArea(cAlias1)
	dbSetOrder(1)
	dbGoTop()

	if cIdUser == "000000" .or. cIdUser == "000001" .or. cIdUser == "000027"  .or. cIdUser == "000046" .or. cIdUser == "000073" .or. cIdUser == "000028" .or. cIdUser == "000011" .or. cIdUser == "000077" .or. cIdUser == "000007" .or. cIdUser == "000083" .or. cGrup == "Contratos" .OR. cGrup == "Contratos(E)" .OR. cGrup == "Controladoria"
		SET FILTER TO SZ2->Z2_FILIAL = "01"
	Else
		SET FILTER TO SZ2->Z2_IDCOLAB = cIdUser
	end if


	//MBrowse(,,,,cAlias1)
	MBrowse(,,,,cAlias1,,"Z2_CONFER",,,8,aCores)

Return()

//**********************************************************************************************************

User Function Mod3Inc( cAlias1, nReg, nOpc )

Local oDlg
Local oGet
Local nX    := 0
Local nOpcA := 0

Local cDelOk   := "AllwaysTrue"
Local cFieldOk := "AllwaysTrue"
Local cLinOk   := "U_Mod3LOk"    // Fun�ao para valida��o da linha
Local cTudoOk  := "U_Mod3TOk"    // Fun�ao para valida��o de todas as linhas

Local lDeleta  := .T.

Private aHeader := {}
Private aCOLS   := {}
Private aGets   := {}
Private aTela   := {}

RegToMemory(cAlias1, (nOpc==3)) // Carregando para memoria campos  memoria M->

RegToMemory(cAlias2, (nOpc==3)) // Carregando para memoria campos  memoria M->

Mod3aHeader(cAlias1, cAlias2)      // Chamada da Func�o que monta monta Header

Mod3aCOLS(cAlias1, cAlias2, nOpc )// Chamada da Func�o que monta o Cols

	// Montando a estrutura da tela \\
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7], aSize[1] TO aSize[6], aSize[5] OF oMainWnd PIXEL

		EnChoice( cAlias1, nReg, nOpc, , , , , aPObj[1]) // Montando a estrutura da tabela SC5

	// Estrutura do campo Valor na tela
		@ aPObj[3,1], aPGet[1,3] SAY "Valor Total: " SIZE 60,7 OF oDlg                                 PIXEL
		@ aPObj[3,1], aPGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 60,7 OF oDlg PIXEL

		// Fun��o que monta MODELO03 GRID
		oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4], nOpc,cLinOk,cTudoOk,cIniCpos,lDeleta,,,,,cFieldOk,,,cDelOk,,,)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF( Obrigatorio( aGets, aTela ), ( nOpcA := 1, oDlg:End() ), NIL) },{|| oDlg:End() })

	If nOpcA == 1 .And. nOpc == 3
		Mod3Grv( cAlias1, cAlias2, nOpc )
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

User Function Mod3Mnt( cAlias, nReg, nOpc )

Local nX       := 0
Local nOpcA    := 0
Local cDelOk   := "AllwaysTrue"
Local cFieldOk := "AllwaysTrue"

Local cLinOk   := "U_Mod3LOk"    // Fun�ao para valida��o da linha
Local cTudoOk  := "U_Mod3TOk"  // Fun�ao para valida��o de todas as linhas
Local lDeleta  := .T.
Local oDlg, oGet

Private aHeader := {}
Private aCOLS   := {}
Private aGets   := {}
Private aTela   := {}
Private aREG    := {}

cConfer := 	M->Z2_CONFER
if cConfer = "5"
	msginfo("RDV Fechado")
	return .F.
endif

	//Cria variaveis de memoria dos campos da tabela Pai Capa.
	RegToMemory(cAlias1, (nOpc==3))

	//Cria variaveis de memoria dos campos da tabela Filho Item.
	RegToMemory(cAlias2, (nOpc==3))

	Mod3aHeader(cAlias1, cAlias2)

	Mod3aCOLS(cAlias1, cAlias2, nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	EnChoice( cAlias, nReg, nOpc, , , , , aPObj[1])
// Atualiza��o do nome do Fornecedor
	//@ aPObj[3,1],aPGet[1,1] SAY "ID RDV: " SIZE 70,7 OF oDlg PIXEL
	//@ aPObj[3,1],aPGet[1,2] SAY oFornece VAR cFornece SIZE 98,7 OF oDlg PIXEL
// Atualiza��o do total
	@ aPObj[3,1],aPGet[1,3] SAY "Total Despesas " SIZE 50,7 OF oDlg PIXEL
	@ aPObj[3,1],aPGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 70,7 OF oDlg PIXEL

	//U_Mod3Cli() // Dados do Fornecedor
	U_Mod3LOk() // Somas do Produto

	oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4], nOpc,cLinOk,cTudoOk,cIniCpos,lDeleta,,,,,cFieldOk,,,cDelOk,,,)

 ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF( Obrigatorio( aGets, aTela ), ( nOpcA := 1, oDlg:End() ), NIL ) },{|| oDlg:End() })

If ! Empty( nOpc) .And. nOpcA <> 0
	Mod3Grv( cAlias1, cAlias2, nOpc, aREG ) // Grava dados
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

Static Function Mod3aHeader(cAlias1, cAlias2)
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

Static Function Mod3aCOLS(cAlias1, cAlias2, nOpc )

Local cChave := ""

Local nI := 0
Local nTotReg
	Local nSequencia	:= 0
	Local nAno			:= substr(dtos(dDatabase),4,1)

If nOpc <> 3 // diferente de incluir

	if cConfer = "5"
		msginfo("RDV Fechado")
		return .F.
	endif
	//M->Z2_NOMEFOR := Posicione( "SA2", 1, xFilial("SA2") + M->Z2_CODFOR + M->Z2_LOJAFOR, "A2_NREDUZ" )

	cChave := (cAlias1)->Z2_CODRDV
	cConfer := 	M->Z2_CONFER

	dbSelectArea( cAlias2 )
	dbSetOrder(1)
	dbSeek( xFilial(cAlias2) + cChave )

	While ! (cAlias2)->( EOF() ) .AND. ( (cAlias2)->Z3_FILIAL == xFilial(cAlias2) .AND. (cAlias2)->Z3_IDRDV == cChave )
		AADD( aREG, SZ3->( RecNo() ) )
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
	//M->Z2_CODRDV := GETSXENUM("SZ2","Z2_CODRDV")
	BEGINSQL ALIAS "TR1"
	     SELECT * FROM SZ2010 WHERE D_E_L_E_T_ <> '*'
	ENDSQL

	nTotReg := Contar("TR1","!Eof()") + 510
 	nSequencia := 'RDV' +  cValToChar(STRZERO(nTotReg,4)) + '-' + nAno

 	M->Z2_CODRDV := nSequencia


	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )

	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI

	aCOLS[1, AScan(aHeader,{|x| Trim(x[2])=="Z3_ITEM"})] := "01" // Atribui no valor := 01 na array na possi��o do Z3_ITEM
	aCOLS[1, Len( aHeader ) + 1 ] := .F.                         // Criar o elemento para deletar a linha

Endif

TR1->(DbCloseArea())

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

User Function Mod3LOk()

Local lRet := .T.
Local nI :=0
Local nTDespes := 0
Local dData := cTPDesp := nKM := nValor := cPGEmp := ""

	//nPrcven :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_QTD"})
	nTDespes :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
	cTPDesp := AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

	nTotal := 0

	For nI := 1 To Len( aCOLS )

		If aCOLS[nI,Len(aHeader)+1]
			Loop
		Endif

		nTotal += Round( aCOLS[ nI, nTDespes ] , 2 )

	Next nI

	oTotal:Refresh()

Return(lRet)

//+--------------------------------------------------------------------+
//| Rotina | Mod3TOk | Autor | TOTVS CTT             |Data |           |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar os itens se foram preenchidos. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+

User Function Mod3TOk()

Local nI := 0
Local lRet := .T.
Local dData := cTPDesp := nKM := nValor := cPGEmp := ""

    dData	:= AScan(aHeader,{|x| Trim(x[2])=="Z3_DATA"})
    cTPDesp := AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})
    nKM		:= AScan(aHeader,{|x| Trim(x[2])=="Z3_KM"})
    nValor	:= AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
    cPGEmp	:= AScan(aHeader,{|x| Trim(x[2])=="Z3_PGEMPRE"})

	For nI := 1 To Len(aCOLS)

		If aCOLS[nI, Len(aHeader)+1] // Se for Deletado
			Loop
		Endif

		If Empty(aCOLS[nI,nData]) .And. lRet
			MsgAlert("Campo DATA com preenchimento obrigatorio",cCadastro)
			lRet := .F.
		Endif

		If Empty(aCOLS[nI,cTPDesp]) .And. lRet
			MsgAlert("Campo TIPO DE DESPESA preenchimento obrigatorio",cCadastro)
			lRet := .F.
		Endif

		If aCOLS[nI,cTPDesp] <> "LCV" .And. aCOLS[nI,nKM] > 0 .And. lRet
			MsgAlert("Campo KM somente preenchido quando TIPO DE DESPESA for LOCACAO DE VEICULO.",cCadastro)
			M->Z3_KM := 0
			lRet := .F.
		Endif
		
		If Empty(aCOLS[nI,cTPDesp]) .And. lRet
			MsgAlert("Campo Tipo de Despesa com preenchimento obrigatorio",cCadastro)
			lRet := .F.
		Endif

		If aCOLS[nI,nValor] = 0  .And. lRet
			MsgAlert("Campo VALOR nao pode ser 0 (zero).",Cadastro)
			lRet := .F.
		Endif

		If !lRet
			Exit
		Endif

	Next i

Return( lRet )

//+--------------------------------------------------------------------+
//| Rotina | Mod3Grv | Autor | TOTVSCTT             |Data |            |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para efetuar a grava��o nas tabelas. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+

Static Function Mod3Grv( cAlias1, cAlias2, nOpc, aREG )
Local nX := 0
Local nX2 := 0
Local nI := 0

Local nT :=0
Local nT2 :=0
Local nT3 :=0
Local nT4 :=0
Local nT5 :=0
Local nT6 :=0
Local nT7 :=0
Local nT8 :=0
Local nT9 :=0
Local nT10 :=0
Local nT11 :=0
Local nT12 :=0
Local nT13 :=0
Local nT14 :=0
Local nT15 :=0
Local nT16 :=0
Local nT17 :=0
Local nT18 :=0
Local nTDespes := 0
//Private cCodRDV := M->Z2_CODRDV

	Local nTotReg
	Local nSequencia	:= 0
	Local nAno			:= substr(dtos(dDatabase),4,1)

	BEGINSQL ALIAS "TR1"
	     SELECT * FROM SZ2010 WHERE D_E_L_E_T_ <> '*'
	ENDSQL

	nTotReg := Contar("TR1","!Eof()") + 510
 	nSequencia := 'RDV' + cValToChar(STRZERO(nTotReg,4)) + '-' + nAno

	If nOpc == 3 //INCLUS�O
	// Grava o Cabe�alho

		dbSelectArea( cAlias1 )
		RecLock( cAlias1, .T. )

			For nX := 1 To (cAlias1)->( FCount() )
				If "FILIAL" $ FieldName( nX )
					FieldPut( nX, xFilial( cAlias1 ) )
				Else
					FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
				Endif
			Next nX
		MsUnLock()

	// Grava os itens

		dbSelectArea(cAlias2)
		dbSetOrder(1)

		RecLock( cAlias1, .F. )

		For nX2 := 1 To Len( aCOLS )
			If ! aCols[nX2][Len(aHeader)+1]       // Valida se a linha esta deletada

				RecLock( cAlias2, .T. )

					For nI := 1 To Len( aHeader )
						FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCOLS[nX2,nI] )
					Next nI

					SZ3->Z3_FILIAL := xFilial("SZ3")
					SZ3->Z3_IDRDV    := nSequencia
				MsUnLock()
			Endif
		Next nX2

			//****** TOTAL DE DESPESAS *******

			nTDespes :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})


			nTotal := 0

			For nT := 1 To Len( aCOLS )

				If aCOLS[nT,Len(aHeader)+1]
					Loop
				Endif
				//msginfo ( aCOLS[ nT, cPGEMP ] )
				nTotal += Round( aCOLS[ nT, nTDespes ] , 2 )

			Next nT
			SZ2->Z2_TDESPES := nTotal
			//********************************

			//****** TOTAL DE PAGO FUNCIONARIO *******
			nTPGFunc :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cPGEMP 	:=   AScan(aHeader,{|x| Trim(x[2])=="Z3_PGEMPRE"})

			nTotalPF := 0

			For nT2 := 1 To Len( aCOLS )

				If aCOLS[nT2,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT2, cPGEMP ] = "2"
					nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )
				else
					nTotalPF += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT2
			SZ2->Z2_PGFUNC := nTotalPF
			//********************************
			//****** TOTAL DE PAGO EMPRESA *******
			nTPGEMP :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cPGEMP 	:=   AScan(aHeader,{|x| Trim(x[2])=="Z3_PGEMPRE"})

			nTotalPE := 0

			For nT2 := 1 To Len( aCOLS )

				If aCOLS[nT2,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT2, cPGEMP ] = "1"
					nTotalPE += Round( aCOLS[ nT2, nTPGEMP ] , 2 )
				else
					nTotalPE += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT2
			SZ2->Z2_PGEMPRE := nTotalPE

			//****** TOTAL BILHETE AEREO *******
			nTotalDESP1  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP1   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP1 := 0

			For nT3 := 1 To Len( aCOLS )

				If aCOLS[nT3,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT3, cTipoDESP1 ] = "BLA"
					nTotalDP1 += Round( aCOLS[ nT3, nTotalDESP1 ] , 2 )
				else
					nTotalDP1 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT3
			SZ2->Z2_RBILHET := nTotalDP1
			//****** TOTAL HOSPEDAGEM *******
			nTotalDESP2  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP2   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP2 := 0

			For nT4 := 1 To Len( aCOLS )

				If aCOLS[nT4,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT4, cTipoDESP2 ] = "HPG"
					nTotalDP2 += Round( aCOLS[ nT4, nTotalDESP2 ] , 2 )
				else
					nTotalDP2 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT4
			SZ2->Z2_RHOSP := nTotalDP2

			//****** TOTAL ALIMENTACAO *******
			nTotalDESP3  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP3   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP3 := 0

			For nT5 := 1 To Len( aCOLS )

				If aCOLS[nT5,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT5, cTipoDESP3 ] = "LCH" .OR. aCOLS[ nT5, cTipoDESP3 ] = "RFC"
					nTotalDP3 += Round( aCOLS[ nT5, nTotalDESP3 ] , 2 )
				else
					nTotalDP3 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT5
			SZ2->Z2_RALIM := nTotalDP3
			//****** TOTAL TAXI *******
			nTotalDESP4  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP4   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP4 := 0

			For nT6 := 1 To Len( aCOLS )

				If aCOLS[nT6,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT6, cTipoDESP4 ] = "TAX"
					nTotalDP4 += Round( aCOLS[ nT6, nTotalDESP4 ] , 2 )
				else
					nTotalDP4 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT6
			SZ2->Z2_RTAXI := nTotalDP4
			//****** TOTAL CONDUCAO *******
			nTotalDESP5  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP5   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP5 := 0

			For nT7 := 1 To Len( aCOLS )

				If aCOLS[nT7,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT7, cTipoDESP5 ] = "CDC"
					nTotalDP5 += Round( aCOLS[ nT7, nTotalDESP5 ] , 2 )
				else
					nTotalDP5 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT7
			SZ2->Z2_RCOND := nTotalDP5

			//****** TOTAL DIVERSOS *******
			nTotalDESP6  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP6   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP6 := 0

			For nT8 := 1 To Len( aCOLS )

				If aCOLS[nT8,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT8, cTipoDESP6 ] = "DVS"
					nTotalDP6 += Round( aCOLS[ nT8, nTotalDESP6 ] , 2 )
				else
					nTotalDP6 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT8
			SZ2->Z2_RDIVERS := nTotalDP6
			//****** TOTAL REPRESENTACAO *******
			nTotalDESP7  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP7   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP7 := 0

			For nT9 := 1 To Len( aCOLS )

				If aCOLS[nT9,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT9, cTipoDESP7 ] = "RPT"
					nTotalDP7 += Round( aCOLS[ nT9, nTotalDESP7 ] , 2 )
				else
					nTotalDP7 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT9
			SZ2->Z2_RREPRE := nTotalDP7
			//****** TOTAL TELEFONE *******
			nTotalDESP8  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP8   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP8 := 0

			For nT10 := 1 To Len( aCOLS )

				If aCOLS[nT10,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT10, cTipoDESP8 ] = "TEL"
					nTotalDP8 += Round( aCOLS[ nT10, nTotalDESP8 ] , 2 )
				else
					nTotalDP8 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT10
			SZ2->Z2_RTEL := nTotalDP8
			//****** TOTAL VEICULO PROPRIO *******
			nTotalDESP9  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP9   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP9 := 0

			For nT11 := 1 To Len( aCOLS )

				If aCOLS[nT11,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT11, cTipoDESP9 ] = "VCP"
					nTotalDP9 += Round( aCOLS[ nT11, nTotalDESP9 ] , 2 )
				else
					nTotalDP9 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT11
			SZ2->Z2_RVPROP := nTotalDP9
			//****** TOTAL PEDAGIO *******
			nTotalDESP10  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP10   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP10 := 0

			For nT12 := 1 To Len( aCOLS )

				If aCOLS[nT12,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT12, cTipoDESP10 ] = "PDG"
					nTotalDP10 += Round( aCOLS[ nT12, nTotalDESP10 ] , 2 )
				else
					nTotalDP10 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT12
			SZ2->Z2_RPEDAG := nTotalDP10
			//****** TOTAL ESTACIONAMENTO *******
			nTotalDESP11  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP11   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP11 := 0

			For nT13 := 1 To Len( aCOLS )

				If aCOLS[nT13,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT13, cTipoDESP11 ] = "EST"
					nTotalDP11 += Round( aCOLS[ nT13, nTotalDESP11 ] , 2 )
				else
					nTotalDP11 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT13
			SZ2->Z2_RESTAC := nTotalDP11
			//****** TOTAL COMBUSTIVEL *******
			nTotalDESP12  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP12   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP12 := 0

			For nT14 := 1 To Len( aCOLS )

				If aCOLS[nT14,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT14, cTipoDESP12 ] = "CBT"
					nTotalDP12 += Round( aCOLS[ nT14, nTotalDESP12 ] , 2 )
				else
					nTotalDP12 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT14
			SZ2->Z2_RCOMBUS := nTotalDP12
			//****** TOTAL LOCACAO VEICULO *******
			nTotalDESP12  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP12   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP12 := 0

			For nT14 := 1 To Len( aCOLS )

				If aCOLS[nT14,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT14, cTipoDESP12 ] = "LCV"
					nTotalDP12 += Round( aCOLS[ nT14, nTotalDESP12 ] , 2 )
				else
					nTotalDP12 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT14
			SZ2->Z2_RLOCVEI := nTotalDP12
			//****** TOTAL MULTA *******
			nTotalDESP13  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP13   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP13 := 0

			For nT15 := 1 To Len( aCOLS )

				If aCOLS[nT15,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT15, cTipoDESP13 ] = "MLT"
					nTotalDP13 += Round( aCOLS[ nT15, nTotalDESP13 ] , 2 )
				else
					nTotalDP13 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT15
			SZ2->Z2_RMULTA := nTotalDP13
			//*****************************
			//********** DEVOLVER / RECEBER ***************
			nTAdiant := SZ2->Z2_TADIANT

			If nTotalPF >= nTAdiant
				nReceber := (nTotalPF - nTAdiant) + nTotalDP13
				nDevolver:= 0

				SZ2->Z2_TRECEB := nReceber
				SZ2->Z2_TDEVOL := 0
			Else
				nDevolver := (nTAdiant - nTotalPF) + nTotalDP13
				nReceber  := 0

				SZ2->Z2_TRECEB := 0
				SZ2->Z2_TDEVOL := nDevolver
			End if
			//**********************************************
			//********** RATEIO CONTRATO *********************

			IF !EMPTY(Z2_ITEMIC1)
				nContJob1 := 1
			ELSE
				nContJob1 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC2)
				nContJob2 := 1
			ELSE
				nContJob2 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC3)
				nContJob3 := 1
			ELSE
				nContJob3 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC4)
				nContJob4 := 1
			ELSE
				nContJob4 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC5)
				nContJob5 := 1
			ELSE
				nContJob5 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC6)
				nContJob6 := 1
			ELSE
				nContJob6 := 0
			END IF
			nTotalJob := (nTotal/(nContJob1 + nContJob2 + nContJob3 + nContJob4 + nContJob5 + nContJob6))
			IF !EMPTY(Z2_ITEMIC1)
				SZ2->Z2_VALIC1 := nTotalJob
			ELSE
				SZ2->Z2_VALIC1 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC2)
				SZ2->Z2_VALIC2 := nTotalJob
			ELSE
				SZ2->Z2_VALIC2 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC3)
				SZ2->Z2_VALIC3 := nTotalJob
			ELSE
				SZ2->Z2_VALIC3 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC4)
				SZ2->Z2_VALIC4 := nTotalJob
			ELSE
				SZ2->Z2_VALIC4 := 0
			END IF

			IF !EMPTY(Z2_ITEMIC5)
				SZ2->Z2_VALIC5 := nTotalJob
			ELSE
				SZ2->Z2_VALIC5 := 0
			END IF

			IF !EMPTY(Z2_ITEMIC6)
				SZ2->Z2_VALIC6 := nTotalJob
			ELSE
				SZ2->Z2_VALIC6 := 0
			END IF
			//**********************************************

		MsUnLock()

	Endif

	cConfer := 	M->Z2_CONFER

	If nOpc == 4 .AND. cConfer == "5" //.OR. nOpc == 4 .AND. cConfer == "3" //***********

   		msgInfo ( "Registro nao pode ser modificado." )
   		Return .F.

   	endif

	If nOpc == 4 .AND. cConfer <> "1"  .OR.  nOpc == 4 .AND. cConfer <> "2"   .OR. nOpc == 4 .AND. cConfer <> "3"  .OR.  nOpc == 4 .AND. cConfer <> "4" //ALTERA��O

		// Grava os itens conforme as altera��es
		dbSelectArea(cAlias1)
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
					//msginfo( "3." + nTotal )
					RecLock( cAlias2, .T. )
				Endif
			Endif

			If !aCOLS[ nX, Len(aHeader)+1 ]

				For nI := 1 To Len( aHeader )
					FieldPut( FieldPos( Trim( aHeader[ nI, 2] ) ),;
					aCOLS[ nX, nI ] )
				Next nI

				SZ3->Z3_FILIAL 	:= xFilial("SZ3")
				SZ3->Z3_IDRDV   := SZ2->Z2_CODRDV
				

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

			//****** TOTAL DE DESPESAS *******
			nTDespes :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})

			nTotal := 0

			For nT := 1 To Len( aCOLS )

				If aCOLS[nT,Len(aHeader)+1]
					Loop
				Endif
				//msginfo ( aCOLS[ nT, cPGEMP ] )
				nTotal += Round( aCOLS[ nT, nTDespes ] , 2 )

			Next nT
			SZ2->Z2_TDESPES := nTotal
			//********************************

			//****** TOTAL DE PAGO FUNCIONARIO *******
			nTPGFunc :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cPGEMP 	:=   AScan(aHeader,{|x| Trim(x[2])=="Z3_PGEMPRE"})

			nTotalPF := 0

			For nT2 := 1 To Len( aCOLS )

				If aCOLS[nT2,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT2, cPGEMP ] = "2"
					nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )
				else
					nTotalPF += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT2
			SZ2->Z2_PGFUNC := nTotalPF
			//********************************
			//****** TOTAL DE PAGO EMPRESA *******
			nTPGEMP :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cPGEMP 	:=   AScan(aHeader,{|x| Trim(x[2])=="Z3_PGEMPRE"})

			nTotalPE := 0

			For nT2 := 1 To Len( aCOLS )

				If aCOLS[nT2,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT2, cPGEMP ] = "1"
					nTotalPE += Round( aCOLS[ nT2, nTPGEMP ] , 2 )
				else
					nTotalPE += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT2
			SZ2->Z2_PGEMPRE := nTotalPE

			//****** TOTAL BILHETE AEREO *******
			nTotalDESP1  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP1   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP1 := 0

			For nT3 := 1 To Len( aCOLS )

				If aCOLS[nT3,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT3, cTipoDESP1 ] = "BLA"
					nTotalDP1 += Round( aCOLS[ nT3, nTotalDESP1 ] , 2 )
				else
					nTotalDP1 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT3
			SZ2->Z2_RBILHET := nTotalDP1
			//****** TOTAL HOSPEDAGEM *******
			nTotalDESP2  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP2   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP2 := 0

			For nT4 := 1 To Len( aCOLS )

				If aCOLS[nT4,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT4, cTipoDESP2 ] = "HPG"
					nTotalDP2 += Round( aCOLS[ nT4, nTotalDESP2 ] , 2 )
				else
					nTotalDP2 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT4
			SZ2->Z2_RHOSP := nTotalDP2

			//****** TOTAL ALIMENTACAO *******
			nTotalDESP3  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP3   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP3 := 0

			For nT5 := 1 To Len( aCOLS )

				If aCOLS[nT5,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT5, cTipoDESP3 ] = "LCH" .OR. aCOLS[ nT5, cTipoDESP3 ] = "RFC"
					nTotalDP3 += Round( aCOLS[ nT5, nTotalDESP3 ] , 2 )
				else
					nTotalDP3 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT5
			SZ2->Z2_RALIM := nTotalDP3
			//****** TOTAL TAXI *******
			nTotalDESP4  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP4   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP4 := 0

			For nT6 := 1 To Len( aCOLS )

				If aCOLS[nT6,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT6, cTipoDESP4 ] = "TAX"
					nTotalDP4 += Round( aCOLS[ nT6, nTotalDESP4 ] , 2 )
				else
					nTotalDP4 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT6
			SZ2->Z2_RTAXI := nTotalDP4
			//****** TOTAL CONDUCAO *******
			nTotalDESP5  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP5   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP5 := 0

			For nT7 := 1 To Len( aCOLS )

				If aCOLS[nT7,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT7, cTipoDESP5 ] = "CDC"
					nTotalDP5 += Round( aCOLS[ nT7, nTotalDESP5 ] , 2 )
				else
					nTotalDP5 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT7
			SZ2->Z2_RCOND := nTotalDP5
			//****** TOTAL DIVERSOS *******
			nTotalDESP6  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP6   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP6 := 0

			For nT8 := 1 To Len( aCOLS )

				If aCOLS[nT8,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT8, cTipoDESP6 ] = "DVS"
					nTotalDP6 += Round( aCOLS[ nT8, nTotalDESP6 ] , 2 )
				else
					nTotalDP6 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT8
			SZ2->Z2_RDIVERS := nTotalDP6
			//****** TOTAL REPRESENTACAO *******
			nTotalDESP7  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP7   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP7 := 0

			For nT9 := 1 To Len( aCOLS )

				If aCOLS[nT9,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT9, cTipoDESP7 ] = "RPT"
					nTotalDP7 += Round( aCOLS[ nT9, nTotalDESP7 ] , 2 )
				else
					nTotalDP7 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT9
			SZ2->Z2_RREPRE := nTotalDP7
			//****** TOTAL TELEFONE *******
			nTotalDESP8  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP8   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP8 := 0

			For nT10 := 1 To Len( aCOLS )

				If aCOLS[nT10,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT10, cTipoDESP8 ] = "TEL"
					nTotalDP8 += Round( aCOLS[ nT10, nTotalDESP8 ] , 2 )
				else
					nTotalDP8 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT10
			SZ2->Z2_RTEL := nTotalDP8
			//****** TOTAL VEICULO PROPRIO *******
			nTotalDESP9  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP9   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP9 := 0

			For nT11 := 1 To Len( aCOLS )

				If aCOLS[nT11,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT11, cTipoDESP9 ] = "VCP"
					nTotalDP9 += Round( aCOLS[ nT11, nTotalDESP9 ] , 2 )
				else
					nTotalDP9 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT11
			SZ2->Z2_RVPROP := nTotalDP9
			//****** TOTAL PEDAGIO *******
			nTotalDESP10  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP10   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP10 := 0

			For nT12 := 1 To Len( aCOLS )

				If aCOLS[nT12,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT12, cTipoDESP10 ] = "PDG"
					nTotalDP10 += Round( aCOLS[ nT12, nTotalDESP10 ] , 2 )
				else
					nTotalDP10 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT12
			SZ2->Z2_RPEDAG := nTotalDP10
			//****** TOTAL ESTACIONAMENTO *******
			nTotalDESP11  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP11   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP11 := 0

			For nT13 := 1 To Len( aCOLS )

				If aCOLS[nT13,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT13, cTipoDESP11 ] = "EST"
					nTotalDP11 += Round( aCOLS[ nT13, nTotalDESP11 ] , 2 )
				else
					nTotalDP11 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT13
			SZ2->Z2_RESTAC := nTotalDP11
			//****** TOTAL COMBUSTIVEL *******
			nTotalDESP12  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP12   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP12 := 0

			For nT14 := 1 To Len( aCOLS )

				If aCOLS[nT14,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT14, cTipoDESP12 ] = "CBT"
					nTotalDP12 += Round( aCOLS[ nT14, nTotalDESP12 ] , 2 )
				else
					nTotalDP12 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT14
			SZ2->Z2_RCOMBUS := nTotalDP12
			//****** TOTAL LOCACAO VEICULO *******
			nTotalDESP12  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP12   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP12 := 0

			For nT14 := 1 To Len( aCOLS )

				If aCOLS[nT14,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT14, cTipoDESP12 ] = "LCV"
					nTotalDP12 += Round( aCOLS[ nT14, nTotalDESP12 ] , 2 )
				else
					nTotalDP12 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT14
			SZ2->Z2_RLOCVEI := nTotalDP12
			//****** TOTAL MULTA *******
			nTotalDESP13  :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})
			cTipoDESP13   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_TPDESP"})

			nTotalDP13 := 0

			For nT15 := 1 To Len( aCOLS )

				If aCOLS[nT15,Len(aHeader)+1]
					Loop
				Endif

				if aCOLS[ nT15, cTipoDESP13 ] = "MLT"
					nTotalDP13 += Round( aCOLS[ nT15, nTotalDESP13 ] , 2 )
				else
					nTotalDP13 += 0
				end if

				//nTotalPF += Round( aCOLS[ nT2, nTPGFunc ] , 2 )

			Next nT15
			SZ2->Z2_RMULTA := nTotalDP13
			//*****************************
			//********** DEVOLVER / RECEBER ***************
			nTAdiant := SZ2->Z2_TADIANT

			If nTotalPF >= nTAdiant
				nReceber := (nTotalPF - nTAdiant)
				nDevolver:= 0

				SZ2->Z2_TRECEB := nReceber
				SZ2->Z2_TDEVOL := 0
			Else
				nDevolver := (nTAdiant - nTotalPF)
				nReceber  := 0

				SZ2->Z2_TRECEB := 0
				SZ2->Z2_TDEVOL := nDevolver
			End if
			//**********************************************
			//********** RATEIO CONTRATO *********************

			IF !EMPTY(Z2_ITEMIC1)
				nContJob1 := 1
			ELSE
				nContJob1 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC2)
				nContJob2 := 1
			ELSE
				nContJob2 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC3)
				nContJob3 := 1
			ELSE
				nContJob3 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC4)
				nContJob4 := 1
			ELSE
				nContJob4 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC5)
				nContJob5 := 1
			ELSE
				nContJob5 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC6)
				nContJob6 := 1
			ELSE
				nContJob6 := 0
			END IF
			nTotalJob := (nTotal/(nContJob1 + nContJob2 + nContJob3 + nContJob4))
			IF !EMPTY(Z2_ITEMIC1)
				SZ2->Z2_VALIC1 := nTotalJob
			ELSE
				SZ2->Z2_VALIC1 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC2)
				SZ2->Z2_VALIC2 := nTotalJob
			ELSE
				SZ2->Z2_VALIC2 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC3)
				SZ2->Z2_VALIC3 := nTotalJob
			ELSE
				SZ2->Z2_VALIC3 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC4)
				SZ2->Z2_VALIC4 := nTotalJob
			ELSE
				SZ2->Z2_VALIC4 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC5)
				SZ2->Z2_VALIC5 := nTotalJob
			ELSE
				SZ2->Z2_VALIC5 := 0
			END IF
			IF !EMPTY(Z2_ITEMIC6)
				SZ2->Z2_VALIC6 := nTotalJob
			ELSE
				SZ2->Z2_VALIC6 := 0
			END IF
			//**********************************************
			SZ2->Z2_CONFER := "1"
			SZ2->Z2_IDAPRCO := ""
			SZ2->Z2_UAPRCO := ""
			SZ2->Z2_IDCONF := ""
			SZ2->Z2_UCONF := ""
			SZ2->Z2_IDAPROV := ""
			SZ2->Z2_UAPROV := ""
		MsUnLock()

	Endif

	If nOpc == 5 .AND. cConfer == "2" //***********

   		msgInfo ( "Registro nao pode ser excluido." )
   		Return .F.

   	endif

	If nOpc == 5 .AND. cConfer == "3"  //***********

   		msgInfo ( "Registro nao pode ser excluido." )
   		Return .F.

   	endif

	If nOpc == 5 .AND. cConfer == "4"  //***********

   		msgInfo ( "Registro nao pode ser excluido." )
   		Return .F.

   	endif

	If nOpc == 5 .AND. cConfer == "5"  //***********

   		msgInfo ( "Registro nao pode ser excluido." )
   		Return .F.

   	endif

	If nOpc == 5 .AND. cConfer <> "2"  // EXCLUS�O

		// Deleta os Itens
		dbSelectArea("SZ3")
		dbSetOrder(1)

		dbSeek(xFilial("SZ3") + M->Z2_CODRDV)

		While ! (cAlias2)->(EOF()) .AND. ( (cAlias2)->Z3_FILIAL+(cAlias2)->(Z3_IDRDV) == xFilial(cAlias1)+M->Z2_CODRDV)
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

	If nOpc == 5 .AND. cConfer <> "3"  // EXCLUS�O

		// Deleta os Itens
		dbSelectArea("SZ3")
		dbSetOrder(1)

		dbSeek(xFilial("SZ3") + M->Z2_CODRDV)

		While ! (cAlias2)->(EOF()) .AND. ( (cAlias2)->Z3_FILIAL+(cAlias2)->(Z3_IDRDV) == xFilial(cAlias1)+M->Z2_CODRDV)
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

	If nOpc == 6 // Conferido
		if cUsuario <> "ADMINISTRADOR" .or. cCargo = "2301" .or. cCargo = "4101"  .or. cCargo = "4201" .or. cCargo = "4103" .or. cUsuario $ ("000046")
			RecLock(cAlias1,.F.)
				//if !SZ2->Z2_CONFER $ ("3/4") .or. EMPTY(SZ2->Z2_CONFER) 
					SZ2->Z2_CONFER := "2"
				//endif
				SZ2->Z2_IDCONF := cIdUser
				SZ2->Z2_UCONF := cUsuario
			MsUnLock()
			msginfo( "Relatorio de Viagem Conferido." )
		else
			msginfo ( "Recurso nao disponivel." )
			return .F.
		end if
	End if

	If nOpc == 7// Aprovacao Coordenador
		if alltrim(SZ2->Z2_CONFER) == "3"
			msginfo ( "Relatorio ja aprovado pelo coordenador." )
			return .F.
		elseif alltrim(SZ2->Z2_CONFER) == "5"
			msginfo ( "Relatorio fechado." )
			return .F.
		else
			PswOrder(1)
			If PswSeek(RetCodUsr(), .T. )
				cGrup := alltrim(PSWRET()[1][12])
			endif
			if  cGrup == "Contratos" .OR. cGrup == "Contratos(E)" .OR. cGrup == "Controladoria" //cIdUser == "000000" .or. cIdUser == "000001" .or. cIdUser == "000027"  .or. cIdUser == "000046" .or. cIdUser == "000073" .or. cIdUser == "000028" .or. cIdUser == "000011" .or. cIdUser == "000077" .or. cIdUser == "000007" .or. cIdUser == "000083" //cUsuario <> "ADMINISTRADOR" .or. cCargo <> "1101" .or. cCargo <> "4101"  .or. cCargo <> "2101" .or.
				RecLock(cAlias1,.F.)
					//if SZ2->Z2_CONFER = "2" .or. EMPTY(SZ2->Z2_CONFER) 
						SZ2->Z2_CONFER:= "3"
					//ENDIF
					SZ2->Z2_IDAPRCO := cIdUser
					SZ2->Z2_UAPRCO := cUsuario
				MsUnLock()
				msginfo( "Relatorio de Viagem Aprovado pelo coordenador." )
			else
				msginfo ( "Recurso nao disponivel." )
				return .F.
			end if
		end if

	endif

	If nOpc == 8 // Aprovção diretoria
		if SZ2->Z2_CONFER == "4"
			msginfo ( "Relatorio ja aprovado." )
			return .F.
		elseif alltrim(SZ2->Z2_CONFER) == "5"
			msginfo ( "Relatorio fechado." )
			return .F.
		else
			PswOrder(1)
			If PswSeek(RetCodUsr(), .T. )
				cGrup := alltrim(PSWRET()[1][12])
			endif
			if  cGrup == "Diretoria" //cIdUser == "000000" .or. cIdUser == "000001" .or. cIdUser == "000027"  .or. cIdUser == "000046" .or. cIdUser == "000073" .or. cIdUser == "000028" .or. cIdUser == "000011" .or. cIdUser == "000077" .or. cIdUser == "000007" .or. cIdUser == "000083" //cUsuario <> "ADMINISTRADOR" .or. cCargo <> "1101" .or. cCargo <> "4101"  .or. cCargo <> "2101" .or.
				RecLock(cAlias1,.F.)
					SZ2->Z2_CONFER := "4"
					SZ2->Z2_IDAPROV := cIdUser
					SZ2->Z2_UAPROV := cUsuario
				MsUnLock()
				msginfo( "Relatorio de Viagem Aprovado" )
			else
				msginfo ( "Recurso nao disponivel." )
				return .F.
			end if
		end if
	End if

	If nOpc == 9 // Imprimir
		u_relat024()
	end if

	If nOpc == 10 // fechar relatorio
		if cIdUser == "000000" .or. cIdUser == "000001" .or. cIdUser == "000027"  .or. cIdUser == "000046" .or. cIdUser == "000073" .or. cIdUser == "000007" 
			RecLock(cAlias1,.F.)
				SZ2->Z2_CONFER := "5"
			MsUnLock()
		else
			msginfo ( "Recurso nao disponivel." )
			return .F.
		endif
	end if

	//ConfirmSX8()

TR1->(DbCloseArea())

Return( NIL )

/*
//**************************
Static Function relat024I()

Local oDlg       := NIL
Local cString	  := "SZ2"

Private titulo   := ""
Private nLastKey := 0
Private nomeProg := FunName()

wnrel := FunName()            //Nome Default do relatorio em Disco

Private cTitulo  := "Impress�o do Relat�rio de Despesas"
Private oPrn     := NIL
Private oFont1   := NIL
Private oFont2   := NIL
Private oFont3   := NIL
Private oFont4   := NIL
Private oFont5   := NIL
Private oFont6   := NIL
Private nLastKey := 0
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais

DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" BOLD

oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6		:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';

oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)

nLastKey  := IIf(LastKey() == 27,27,nLastKey)

If nLastKey == 27

	Return( NIL )

Endif


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

Imprimir()

oPrn:EndPage()

oPrn:End()

Return( NIL )
//***********************
Static Function Imprimir()

Despesas()
Ms_Flush()

Return( NIL )
//***********************
Static Function Despesas()

	cDia := SubStr(DtoS(dDataBase),7,2)
	cMes := SubStr(DtoS(dDataBase),5,2)
	cAno := SubStr(DtoS(dDataBase),1,4)

	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()

	nCont	:= 0

	//**********
	If Cont > Cont1
		nCont1 := nCont1 + 1
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1

  	If lCrtPag
		nCont := nCont + 1
	Endif

	SZ2->( dbSetOrder(1) )
	SZ2->( dbSeek( xFilial("SZ2")+M->Z2_CODRDV ) ) //+cIDRDVimp

	//oPrn:Say(0040,1890, SZ2->Z2_IDRDV,oFont14)

	SZ3->( dbSetOrder(1) )
	SZ3->( dbSeek(xFilial("SZ3")+M->Z2_CODRDV) )

	nLinha    := 0780

	While ! SZ3->(Eof() ) .And. SZ3->Z3_IDRDV == M->Z2_CODRDV

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  	( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n)


		// Dados da Colaborador
		oPrn:Box	(0190,0050,0280,0350) //
		oPrn:Say  (0220,0070,"ID RDV: " + SZ2->Z2_CODRDV,oFont8n)
		oPrn:Box	(0190,0350,0280,0700) //
		oPrn:Say  (0220,0370,"ID Colaborador: " + SZ2->Z2_IDCOLAB,oFont8n)
		oPrn:Box	(0190,0700,0280,2200) //
		oPrn:Say  (0220,0700,"Colaborador: " + SZ2->Z2_COLAB,oFont8n)

		oPrn:FillRect({0280,0050,0360,2200},oBrush)
		oPrn:Box	(0280,0050,0360,2200)
		oPrn:Say  (0300,0900,"Resumo por tipo de Despesa"  ,oFont8n)

		oPrn:Box	(0360,0050,0440,2200)
		oPrn:Say  (0380,0070,"Bilhete A�reo: " + Alltrim(transform(SZ2->Z2_RBILHET,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0380,0470,"Hospedagem: " + Alltrim(transform(SZ2->Z2_RHOSP,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0380,0870,"Alimenta��o: " + Alltrim(transform(SZ2->Z2_RALIM,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0380,1270,"Taxi: " + Alltrim(transform(SZ2->Z2_RTAXI,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0380,1670,"Condu��o: " + Alltrim(transform(SZ2->Z2_RCOND,"@E 999,999,999.99")) ,oFont8n)


		oPrn:Box	(0440,0050,0520,2200)
		oPrn:Say  (0460,0070,"Representa��o: " + Alltrim(transform(SZ2->Z2_RCOND,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0460,0470,"Diversos: " + Alltrim(transform(SZ2->Z2_RDIVERS,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0460,0870,"Ve�culo Proprio: " + Alltrim(transform(SZ2->Z2_RVPROP,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0460,1270,"Ped�gio: " + Alltrim(transform(SZ2->Z2_RPEDAG,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0460,1670,"Estacionamento: " + Alltrim(transform(SZ2->Z2_RESTAC,"@E 999,999,999.99")) ,oFont8n)


		oPrn:Box	(0520,0050,0600,2200)
		oPrn:Say  (0540,0070,"Combust�vel: " + Alltrim(transform(SZ2->Z2_RCOMBUS,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0540,0470,"Multa: " + Alltrim(transform(SZ2->Z2_RMULTA,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0540,0870,"Loca��o Ve�culo: " + Alltrim(transform(SZ2->Z2_RLOCVEI,"@E 999,999,999.99")) ,oFont8n)
		oPrn:Say  (0540,1270,"Telefone: " + Alltrim(transform(SZ2->Z2_RTEL,"@E 999,999,999.99")) ,oFont8n)

		oPrn:FillRect({0600,0050,0680,2200},oBrush)
		oPrn:Box	(0600,0050,0680,2200)
		oPrn:Say  (0620,0900,"Detalhamento Despesas ",oFont8n)

		// Resumo despesas
		oPrn:Box	(0050,0740,0190,1850) // Titulo Pedido
		oPrn:Say  (0100,0900,"Relat�rio de Viagem - " +  SZ2->Z2_CODRDV ,oFont14)

		oPrn:Box	(0050,1850,0190,2200) // Data Registro
		oPrn:Say  (0070,1920,"Data Registro " ,oFont9n)
		oPrn:Say  (0120,1920,DTOC(SZ2->Z2_DTREG) ,oFont9n)

		oPrn:FillRect({0050,2750,0100,3300},oBrush)
		oPrn:FillRect({0050,2200,0100,2750},oBrush)
		oPrn:FillRect({0600,2750,0680,3300},oBrush)

		oPrn:Box	(0050,2750,0600,3300) // Totais
		oPrn:Box	(0050,2750,0100,3300)
		oPrn:Say  (0060,2970,"RESUMO ",oFont8n)

		oPrn:Box	(0100,2750,0200,3300)
		oPrn:Say  (0120,2770,"Adiantamento: ",oFont9n)
		oPrn:Say  (0120,3250, Alltrim(transform(SZ2->Z2_TADIANT,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0200,2750,0300,3300)
		oPrn:Say  (0220,2770,"Pago Empresa: ",oFont9n)
		oPrn:Say  (0220,3250, Alltrim(transform(SZ2->Z2_PGEMPRE,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0300,2750,0400,3300)
		oPrn:Say  (0320,2770,"Pago Funcion�rio: ",oFont9n)
		oPrn:Say  (0320,3250, Alltrim(transform(SZ2->Z2_PGFUNC,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0400,2750,0500,3300)
		oPrn:Say  (0420,2770,"Total a Receber: ",oFont9n)
		oPrn:Say  (0420,3250, Alltrim(transform(SZ2->Z2_TRECEB,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0500,2750,0600,3300)
		oPrn:Say  (0520,2770,"Total a Devolver: ",oFont9n)
		oPrn:Say  (0520,3250, Alltrim(transform(SZ2->Z2_TDEVOL,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0600,2750,0680,3300)
		oPrn:Say  (0620,2770,"Total Despesas: ",oFont9n)
		oPrn:Say  (0620,3250, Alltrim(transform(SZ2->Z2_TDESPES,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0050,2200,0680,2750) // Totais
		oPrn:Box	(0050,2200,0100,2750)
		oPrn:Say  (0060,2400,"RATEIO ",oFont8n)

		oPrn:Box	(0100,2200,0250,2750)
		oPrn:Say  (0120,2220,"Contrato: " + SZ2->Z2_ITEMIC1,oFont9n)
		oPrn:Say  (0160,2220,"Valor: "  ,oFont9n)
		oPrn:Say  (0160,2550, Alltrim(transform(SZ2->Z2_VALIC1,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0250,2200,0400,2750)
		oPrn:Say  (0270,2220,"Contrato: " + SZ2->Z2_ITEMIC2,oFont9n)
		oPrn:Say  (0310,2220,"Valor: ",oFont9n)
		oPrn:Say  (0310,2550,Alltrim(transform(SZ2->Z2_VALIC2,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0400,2200,0550,2750)
		oPrn:Say  (0420,2220,"Contrato: "  + SZ2->Z2_ITEMIC3,oFont9n)
		oPrn:Say  (0460,2220,"Valor: ",oFont9n)
		oPrn:Say  (0460,2550,Alltrim(transform(SZ2->Z2_VALIC3,"@E 999,999,999.99")),oFont9n,20,,,1)

		oPrn:Box	(0550,2200,0680,2750)
		oPrn:Say  (0570,2220,"Contrato: "  + SZ2->Z2_ITEMIC4,oFont9n)
		oPrn:Say  (0610,2220,"Valor: ",oFont9n)
		oPrn:Say  (0610,2550,Alltrim(transform(SZ2->Z2_VALIC4,"@E 999,999,999.99")),oFont9n,20,,,1)


		// ********************** Rodap� ****************
		oPrn:Box	(2120,0050,2170,1010)
		oPrn:Say  (2130,0070,"Revisado",oFont9n)
		oPrn:Box	(2120,1010,2170,1970)
		oPrn:Say  (2130,1030,"Colaborador",oFont9n)
		oPrn:Box	(2120,1970,2170,2900)
		oPrn:Say  (2130,1990,"Aprova��o",oFont9n)

		oPrn:Box	(2170,0050,2350,1010) // Assinatura Comprador
		oPrn:Say  (2190,0060,SZ2->Z2_UCONF,oFont9n)

		oPrn:Box	(2170,1010,2350,1970) // Coordenador
		oPrn:Say  (2190,1030,SZ2->Z2_COLAB,oFont9n)

		oPrn:Box	(2170,1970,2350,2900) // Ger�ncia
		oPrn:Say  (2190,1990,SZ2->Z2_UAPROV,oFont9n)

		oPrn:Box	(2170,2900,2350,3300) //
		oPrn:Say  (2180,3040,"P�gina" + Transform(StrZero(ncont,3),"") + " de " + Transform(StrZero(ncont1,3),""),oFont9n)

		oPrn:Box	(0680,0050,0760,3300) // cabeca�alhos detalhamento
		oPrn:Box	(0680,0050,2030,0180) // Item
		oPrn:Box	(0680,0180,2030,0380) // Data
		oPrn:Box	(0680,0380,2030,0580) // Cod. forn.
		oPrn:Box	(0680,0580,2030,1380) // fornecedor
		oPrn:Box	(0680,1380,2030,1540) // tipo desp
		oPrn:Box	(0680,1540,2030,2900) // descricao despesas
		oPrn:Box	(0680,2900,2030,3160) // valor
		oPrn:Box	(0680,3160,2030,3300) // Pg. empresa

		oPrn:Say  (0700,0070,"Item",oFont8n)
		oPrn:Say  (0700,0200,"Data",oFont8n)
		oPrn:Say  (0700,0400,"Cod.Forn.",oFont8n)
		oPrn:Say  (0700,0600,"Fornecedor",oFont8n)
		oPrn:Say  (0700,1400,"Tipo Desp.",oFont8n)
		oPrn:Say  (0700,1560,"Descri��o",oFont8n)
		oPrn:Say  (0700,3070,"Valor",oFont8n)
		oPrn:Say  (0700,3180,"Pg.Emp.",oFont8n)
		//***********************************************
		if nLinha > 2000 .OR. nLinha == 0
			if nLinha <> 0
			  	If lCrtPag
					nCont := nCont + 1
				Endif
				msginfo (nLinha)
				nLinha  := 0780
				oPrn:EndPage()
			endif
		End if

		oPrn:Say(nLinha,0070, SZ3->Z3_ITEM, oFont8)
		oPrn:Say(nLinha,0200, Substr(DTOS(SZ3->Z3_DATA),7,2) + "/" + Substr(DTOS(SZ3->Z3_DATA),5,2) + "/" + Substr(DTOS(SZ3->Z3_DATA),1,4), oFont8)
		oPrn:Say(nLinha,0400, SZ3->Z3_CODFORN, oFont8)
		oPrn:Say(nLinha,0600, SZ3->Z3_FORNECE, oFont8)
		oPrn:Say(nLinha,1400, SZ3->Z3_TPDESP, oFont8)
		oPrn:Say(nLinha,1640, SZ3->Z3_DESCDES, oFont8)
		oPrn:Say(nLinha,3140,Alltrim(transform(SZ3->Z3_VALOR,"@E 999,999,999.99")),oFont8,20,,,1)

		if SZ3->Z3_PGEMPRE = "1"
			oPrn:Say(nLinha,3200, "Sim", oFont8)
		else
			oPrn:Say(nLinha,3200, "N�o", oFont8)
		end if
		nLinha+=0050

		SZ3->(dbSkip())

		EndDo


		SZ2->( dbSkip() )

oPrn:EndPage()

Return( NIL )
//*************************
*/
User Function ConferSZ2()

	BrwLegenda(cCadastro,"Valores",{{"BR_VERDE","Aberto"},;
									{"BR_VERMELHO","Conferido"},;
									{"BR_AMARELO","Aprovado Coordenador"},;
									{"BR_AZUL","Aprovado Diretoria"},;
									{"BR_PRETO","Fechado"}})

return

