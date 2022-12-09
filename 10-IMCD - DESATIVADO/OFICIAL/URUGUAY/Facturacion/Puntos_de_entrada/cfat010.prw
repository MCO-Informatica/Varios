#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ITENSSC6 300

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFAT010  º Autor ³ Eneo/Molina        º Data ³ 12/02/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Generica de Grupo / Produto                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento / Telemarketing                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CFAT010( cProduto )

Local nRegSA1 := SA1->(Recno())
	
	FWMsgRun(, {|oSay|  CFAT010R( cProduto ) }, "Processando", "Processando a rotina...")	

SA1->(DbGoto(nRegSA1))

Return()

Static Function CFAT010R( cProduto )
Local aArea:= GetArea()
Local lRet		:= .F.							// Retorno da funcao
Local cObs 		:= ""							// Observacao do Produto
Local oDlg            							// Tela
Local nTamObs	:= TamSx3("B1_OBS")[1]			// Recebe o tamanho do campo cadastrado no SX3 (Dicionário de dados)

Local cBitPro 	:= ""							// Bitmap do produto
Local cPictSB2  := SPACE(12)					// Picture do SB2
Local cNomeAlter:= ""							// Produto Alternativo
Local cGrupo    := ""							// Grupo

Local nAtu   	:= 0
Local nVenc 	:= 0
Local nEmp    	:= 0
Local nEmTerc   := 0
Local nDeTerc   := 0
Local nSalPedi	:= 0
Local nSalPedi2	:= 0
Local nReserva	:= 0
Local nSaldo  	:= 0
Local nPosAnt   := 0

Local oLstBox
Local _aAux     := {}
Local aHeader2  := {}
Local aCols     := {}
Local aPicture  := {}

Local cQuery	:= ""
Local i := 0 

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "CFAT010" , __cUserID )

	If Empty(cProduto)
	Help(" ",1,"SEM PRODUT" )
	Return(lRet)
	Endif

DbSelectArea("SB1")
DbSetOrder(1)
	If DbSeek(xFilial("SB1") + cProduto)
	cObs   := MSMM(SB1->B1_CODOBS, nTamObs)
	cGrupo := SB1->B1_GRUPO
	nPosAnt:= Recno()
	
		If DbSeek(xFilial("SB1")+SB1->B1_ALTER)
		cNomeAlter := AllTrim(B1_COD + " - "+ AllTrim(B1_DESC))
		Endif
	Endif

cTipox := substr(cProduto,1,2)

cQuery := 	"SELECT B1_COD, B1_DESC, B1_MSBLQL, B2_LOCAL, B2_QATU, B2_QEMP, B2_SALPEDI "
cQuery += 	" FROM " + RetSqlName("SB1") + " SB1 "
cQuery += 	" LEFT JOIN "+RetSqlName("SB2") + " SB2 ON "
cQuery += 	" (SB1.B1_COD = SB2.B2_COD AND SB2.B2_FILIAL = '" + xFilial("SB2") + "' AND SB2.D_E_L_E_T_ <> '*' AND B2_LOCAL <> ' ' ) "
cQuery += 	" LEFT JOIN " +RetSqlName("SBM") + " SBM ON "
cQuery += 	" (SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.D_E_L_E_T_ <> '*' )   "
cQuery += 	" WHERE B1_GRUPO = '" + cGrupo + "' AND SB1.D_E_L_E_T_ <> '*' AND B1_TIPO =  '" + cTipox + "'  "
//	cQuery += 	" AND B1_DESC NOT LIKE '%AMOSTRA%' "
cQuery += 	" ORDER BY B1_COD "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"Itens",.F.,.T.)
MEMOWRITE("C:\QUERY.SQL",cQuery)
dbSelectArea("Itens")
DbGotop()

ProcRegua(RecCount())

	Do While !Itens->(EOF())
		If !(Substr(Itens->B1_COD,1,2) $ "MR/PA/MA")
		Itens->(dbSkip())
		Loop
		Endif
	
		If Itens->B1_MSBLQL == "1"
		Itens->(dbSkip())
		Loop
		Endif
	
	IncProc("Analisando Produto "+Itens->B1_COD)
	
	//////////////////////////////////////////// Pega a quantidade em pedido de compras direto no SC7 e não no SB2
	nSalPedi := 0
	cArqQry := "QUERYSC7"
	lQuery  := .T.
	cQuery  := "SELECT QUERYSC7.C7_FORNECE, QUERYSC7.C7_DATPRF, QUERYSC7.C7_QUANT, QUERYSC7.C7_QUJE, "
	cQuery += " QUERYSC7.C7_NUM, QUERYSC7.C7_RESIDUO, QUERYSC7.C7_CONAPRO  "
	cQuery += " FROM "+RetSqlName("SC7")+" QUERYSC7 "
	cQuery += " WHERE QUERYSC7.C7_FILIAL='"+xFilial("SC7")+"' AND "
	cQuery += " QUERYSC7.C7_PRODUTO='"+Itens->B1_COD+"' AND "
	cQuery += " QUERYSC7.C7_LOCAL='"+Itens->B2_LOCAL+"' AND "
	cQuery += " (QUERYSC7.C7_QUANT-QUERYSC7.C7_QUJE)>0 AND "
	cQuery += " QUERYSC7.C7_RESIDUO = ' ' AND "
	cQuery += " QUERYSC7.C7_CONAPRO = 'L' AND "
	cQuery += " QUERYSC7.D_E_L_E_T_=' ' "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)
	dbSelectArea(cArqQry)
	
	DbGotop()
		Do While !eof()
		nSalPedi +=(cArqQry)->C7_QUANT-(cArqQry)->C7_QUJE
		DbSkip()
		Enddo
	
	dbCloseArea()
	////////////////////////////////////////////
	
	nSalPedi2+= nSalPedi
	
	nAtu   	 += Itens->B2_QATU
	nEmp     += Itens->B2_QEMP
	
	_aAux := {}
	aadd(_aAux, Itens->B1_COD )
	aadd(_aAux, SubString(Itens->B1_DESC, 1, 50) )
	aadd(_aAux, Itens->B2_LOCAL )
	aadd(_aAux, Itens->B2_QATU )
	aadd(_aAux, QtdEmPedidos(Itens->B1_COD, Itens->B2_LOCAL ) )
	aadd(_aAux, nSalPedi )
	
	aadd(aCols, _aAux)
	
	Itens->(dbSkip())
	EndDo

Itens->( DbCloseArea() )

	if (len(acols) == 0)
	aadd(aCols,{Space(15), Space(50), Space(07), 0.00, 0.00, 0.00})
	endif

	For i := 1 to Len(aCols)
	nReserva := nReserva + QtdEmPedidos( aCols[i, 1], aCols[i, 3] )
	nVenc	 := nVenc + QtdVencidas( aCols[i, 1], aCols[i, 3] )
	nEmTerc	 := nEmTerc + QtdEmTerc( aCols[i, 1], aCols[i, 3] )
	nDeTerc	 := nDeTerc +  QtdDeTerc( aCols[i, 1], aCols[i, 3] )

	Next

	nSaldo += (nAtu - nEmp - nReserva)

	For i := 1 To Len( aCols )
		If Empty( aCols[ i, 3 ] )
		aCols[ i, 3 ] := "ZZ"
		Endif
	Next

aSort( aCols,,, { |x,y| x[3] < y[3] } )

	For i := 1 To Len( aCols )
		If aCols[ i, 3 ] == "ZZ"
		aCols[ i, 3 ] := "  "
		Endif
	Next

	DbSelectArea("SB5")
	DbSeek(xFilial("SB5") + cProduto)

	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("B2_QATU")
		cPictSB2 := SX3->(X3_PICTURE)
	Endif

	DbSelectArea("SX5")
	DbSetOrder(1)
	If DbSeek(xFilial("SX5")+"03"+cGrupo)
		cGrupo := X5DESCRI()
	Endif

// Mostra dados do Produto.					                 ³
	DEFINE MSDIALOG oDlg FROM 23,181 TO 520,923 TITLE ("Caracteristicas do produto") PIXEL //"Caracteristicas do produto" 370/410
	DbSelectArea("SB1")
	DbGoto(nPosAnt)

// Dados das caracteristicas do produto                 ³
	@06,02 TO 43,370 LABEL "Dados do Produto" OF oDlg PIXEL COLOR CLR_BLUE //Dados do Produto

	@13,04  SAY "Código" SIZE  21,7 OF oDlg PIXEL //"C¢digo"
	@13,29  SAY SB1->B1_COD SIZE  49,8 OF oDlg PIXEL COLOR CLR_BLUE

	@13,80  SAY "Unidade" SIZE  20,7 OF oDlg PIXEL //"Unidade"
	@13,102 SAY SB1->B1_UM SIZE  10,8 OF oDlg PIXEL COLOR CLR_BLUE

	@13,115 SAY "Grupo" SIZE  18,7 OF oDlg PIXEL //"Grupo"
	@13,135 SAY cGrupo SIZE 40,8 OF oDlg PIXEL COLOR CLR_BLUE

	@13,250 SAY "Qtd. Embalagem" SIZE  70,7 OF oDlg PIXEL //"Qtd. Embalagem"
	@13,275 SAY Transform(RetFldProd(SB1->B1_COD,"B1_QE"),PesqPict("SB1","B1_QE")) SIZE  35,7 OF oDlg PIXEL COLOR CLR_BLUE

	@23, 4  SAY "Descrição" SIZE  32, 7 OF oDlg PIXEL //"Descrição"
	@23,33  SAY SB1->B1_DESC SIZE 140, 8 OF oDlg PIXEL COLOR CLR_BLUE

	@23,250 SAY "Peso Liquido" SIZE  60,7 OF oDlg PIXEL //"Peso Liquido"
	@23,275 SAY Transform(SB1->B1_PESO,PesqPict("SB1","B1_PESO")) SIZE  35,7 OF oDlg PIXEL COLOR CLR_BLUE

	@33, 4  SAY "Produto Alternativo" SIZE  80,7 OF oDlg PIXEL //"Produto Alternativo"
	@33,90  SAY cNomeAlter SIZE 138, 8 OF oDlg PIXEL COLOR CLR_BLUE

	cBitPro := SB1->B1_BITMAP

	@45,02 TO 090,155 LABEL "Estoque" OF oDlg PIXEL  // Estoque

	@050, 04 SAY "Atual" SIZE  33, 7 OF oDlg PIXEL //"Qtd Estoque Atual"
	@050, 42 SAY Transform(nAtu,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

	@060, 04 SAY "Vencido" SIZE  33, 7 OF oDlg PIXEL //"Qtd. Vencidas"
	@060, 42 SAY Transform(nVenc,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

	@070, 04 SAY "EM Terceiros" SIZE  33, 7 OF oDlg PIXEL
	@070, 42 SAY Transform(nEmTerc,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

	@080, 04 SAY "Ped.Compra" SIZE  33, 7 OF oDlg PIXEL //"Pedido de Compra"
	@080, 42 SAY Transform(nSalPedi2,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

	@050, 83 SAY "Qtd. Alocada" SIZE  33, 7 OF oDlg PIXEL //"Empenho"
	@050,110 SAY Transform(nEmp,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

	@060, 83 SAY "Reservado" SIZE  33, 7 OF oDlg PIXEL //"Reservado"
	@060,110 SAY Transform(nReserva,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

	@070, 83 SAY "DE Terceiros" SIZE  33, 7 OF oDlg PIXEL //"De Terceiros"
	@070,110 SAY Transform(nDeTerc,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

	@080, 83 SAY "Disponível" SIZE  33, 7 OF oDlg PIXEL //"Disponível"
	@080,110 SAY Transform(nSaldo,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

	@048,160 BUTTON "Pedido de Compra" SIZE 50,10 OF oDlg PIXEL ACTION C010PedCom(ACOLS[oLstBox:nAt, 1],nSalPedi, ACOLS[oLstBox:nAt, 3] )
	@048,220 BUTTON "Reservas" SIZE 50,10 OF oDlg PIXEL ACTION C010PedVen(ACOLS[oLstBox:nAt, 1], ACOLS[oLstBox:nAt, 3] )
//	@065,160 BUTTON "Em Terceiros" SIZE 50,10 OF oDlg PIXEL ACTION C010Terc(ACOLS[oLstBox:nAt, 1], "E", ACOLS[oLstBox:nAt, 3] )
//	@065,220 BUTTON "De Terceiros" SIZE 50,10 OF oDlg PIXEL ACTION C010Terc(ACOLS[oLstBox:nAt, 1], "D", ACOLS[oLstBox:nAt, 3] )

	@065,160 BUTTON "Lotes" SIZE 50,10 OF oDlg PIXEL ACTION C010Lotes(ACOLS[oLstBox:nAt, 1],ACOLS[oLstBox:nAt, 3])

	@065,220 BUTTON "Fechar" SIZE 50,10 OF oDlg PIXEL ACTION (lRet := .T.,oDlg:End())

	aHeader2 := {"Produto", "Descricao", "Local","Atual"              ,"Qtd.Reservada"       ,"Ped.Compra"          }
	aPicture := {"@!",      "@!",        "@!",   "@E 999,999,999.9999","@E 999,999,999.9999","@E 999,999,999.9999" }
//Parametros RDListBox(lin,   col,  compr, alt,      ,         , tamanho das colunas no grid)
	oLstBox := RDListBox(6.80, 0.40, 366,   152, aCols, aHeader2,{40,80,25,50,50,50}, aPicture)

	ACTIVATE MSDIALOG oDlg CENTER

	RestArea(aArea)
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retornar a Quantidade Reservada em Pedidos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function QtdEmPedidos( cProduto, cLocal )
	Local aArea		:= GetArea()
	Local nRet 		:= 0
	Local nQtd 		:= 0
	Local _nReg6   	:= SC6->( recno() )
	Local _nReg5   	:= SC5->( recno() )

	Default cLocal := ""

	dbSelectArea( "SC5" )
	SC5->( dbSetOrder(1) )

	dbSelectArea( "SC6" )
	SC6->( dbSetOrder(2) )
	SC6->( dbSeek( xFilial("SC6") + cProduto ) )
	DO While .not. SC6->( Eof() ) .And. SC6->C6_FILIAL == xFilial( "SC6" ) .And. SC6->C6_PRODUTO == cProduto

		If SC6->C6_BLQ == "R "
			SC6->( dbSkip() )
			Loop
		Endif

		If !Empty( cLocal )
			If SC6->C6_LOCAL != cLocal
				SC6->( dbSkip() )
				Loop
			Endif
		Endif

		nQtd := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
		if nQtd < 0
			nQtd := 0
		endif

		nRet := nRet + nQtd

		SC6->( dbSkip() )

	ENDDO

	SC5->( dbgoto( _nReg5 ) )
	SC6->( dbgoto( _nReg6 ) )
	RestArea(aArea)
Return( nRet )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retornar a Quantidade Vencida                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function QtdVencidas( cProduto, cLocal )
	Local aArea:= GetArea()
	Local nRet := 0

	Default cLocal := ""

	DbSelectArea("SB8")
	SB8->( dbsetorder(1) )
	SB8->( dbseek( xFilial( "SB8" ) + cProduto ) )
	Do While .not. SB8->( Eof() ) .and. xFilial( "SB8" ) == SB8->B8_FILIAL .and. SB8->B8_PRODUTO == cProduto

		If SB8->B8_LOCAL != cLocal
			SB8->( dbSkip() )
			Loop
		Endif

		if SB8->B8_DTVALID < dDataBase .and. SB8->B8_SALDO > 0
			nRet := nRet + SB8->B8_SALDO
		endif

		SB8->( dbskip() )
	EndDo

	RestArea(aArea)
Return( nRet )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retornar a Quantidade do nosso produto em terceiros  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function QtdEmTerc( cProduto, cLocal )
	Local aArea:= GetArea()
	Local nRet := 0

//	Default cLocal := ""

	DbSelectArea("SB6")
	SB6->( dbsetorder(2) )
	SB6->( dbseek( xFilial( "SB6" ) + cProduto ) )
	Do While .not. SB6->( Eof() ) .and. xFilial( "SB6" ) == SB6->B6_FILIAL .and. SB6->B6_PRODUTO == cProduto

		If !Empty( cLocal )
			If SB6->B6_LOCAL != cLocal
				SB6->( dbSkip() )
				Loop
			Endif
			if SB6->B6_TIPO == "E" .and. SB6->B6_PODER3 == "R" .and. SB6->B6_SALDO > 0 .and. SB6->B6_TES != '641'
				nRet := nRet + SB6->B6_SALDO
			endif

		ENDIF

		SB6->( dbskip() )

	EndDo

	RestArea(aArea)
Return( nRet )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retornar a Quantidade do produto de terceiros em nosso poder ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function QtdDeTerc( cProduto, cLocal )
	Local aArea:= GetArea()
	Local nRet := 0

	Default cLocal := ""

	DbSelectArea("SB6")
	SB6->( dbsetorder(2) )
	SB6->( dbseek( xFilial( "SB6" ) + cProduto ) )
	Do While .not. SB6->( Eof() ) .and. xFilial( "SB6" ) == SB6->B6_FILIAL .and. SB6->B6_PRODUTO == cProduto

		If !Empty( cLocal )
			If SB6->B6_LOCAL != cLocal
				SB6->( dbSkip() )
				Loop
			Endif
		Endif

		if SB6->B6_TIPO == "D" .and. SB6->B6_PODER3 == "R" .and. SB6->B6_SALDO > 0
			nRet := nRet + SB6->B6_SALDO
		endif

		SB6->( dbskip() )
	EndDo

	RestArea(aArea)
Return( nRet )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retornar a Quantidade em Pedidos de Compra  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function C010PedCom(cProduto,nSalPedi, cLocal)
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local aHeader2 := {}
	Local oLstBoxPC, oDlg
	Local aArea := GetArea()

//Local cPro := ACOLS

	Private aCols     := {}
	Private aPicture  := {}

	cArqQry := "QUERYSC7"
	lQuery  := .T.
	cQuery  := "SELECT C7_FILIAL , QUERYSC7.C7_FORNECE, QUERYSC7.C7_DATPRF, QUERYSC7.C7_QUANT, QUERYSC7.C7_QUJE, QUERYSC7.C7_NUM, "
	cQuery += " QUERYSC7.C7_RESIDUO, QUERYSC7.C7_CONAPRO,  C7_NUMIMP "
	cQuery += " FROM "+RetSqlName("SC7")+" QUERYSC7 "
	cQuery += " WHERE QUERYSC7.C7_FILIAL='"+xFilial("SC7")+"' AND "
	cQuery += " QUERYSC7.C7_PRODUTO='"+cProduto+"' AND "
	cQuery += " QUERYSC7.C7_LOCAL='"+cLocal+"' AND "
	cQuery += " (QUERYSC7.C7_QUANT-QUERYSC7.C7_QUJE)>0 AND "
	cQuery += " QUERYSC7.C7_RESIDUO = ' ' AND "
	cQuery += " QUERYSC7.C7_CONAPRO = 'L' AND "
	cQuery += " QUERYSC7.D_E_L_E_T_=' ' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)
	dbSelectArea(cArqQry)

	DbGotop()
	Do While !eof()
		_aAux := {}
		SA2->( dbSeek( xFilial("SA2") + (cArqQry)->C7_FORNECE ) )

		aadd(_aAux, SA2->A2_NREDUZ )
		aadd(_aAux, dtoc(stod((cArqQry)->C7_DATPRF)) )
		aadd(_aAux, ctod(" ") )   // Data de Chegada
		aadd(_aAux, (cArqQry)->C7_QUANT-(cArqQry)->C7_QUJE )
		aadd(_aAux, (cArqQry)->C7_NUM )
		nSalPedi +=(cArqQry)->C7_QUANT-(cArqQry)->C7_QUJE
		aadd(aCols,_aAux)

		DbSkip()
	Enddo

//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(acols) == 0
		aadd(aCols,{space(07),ctod( " " ),ctod( " " ), 0.00,space(06),space(06)})
	endif

	DEFINE MSDIALOG oDlg FROM  0,0 TO 400,730 TITLE ('Pedidos de Compra' ) PIXEL

	@ 033,005 TO 065,360  LABEL '' OF oDlg 	PIXEL

	@ 035,010 SAY "Código"            SIZE  21,7 OF oDlg PIXEL
	@ 035,060 SAY cProduto            SIZE  49,8 OF oDlg PIXEL COLOR CLR_BLUE
	@ 045,010 SAY "Descrição"         SIZE  32,7 OF oDlg PIXEL
	@ 045,050 SAY Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC")        SIZE 140,8 OF oDlg PIXEL COLOR CLR_BLUE
	@ 055,010 SAY "Pedido de Compra"  SIZE  49,7 OF oDlg PIXEL
	@ 055,060 SAY Alltrim( Transform( nSalPedi, "@E 999,999,999,999.9999" ) ) SIZE 49,8 OF oDlg PIXEL COLOR CLR_BLUE


	aHeader2 := {"Fornecedor","Entrega","Chegada","Quantidade"         ,"Nr Pedido"}
	aPicture := {"@!"        ,"@D"     ,"@D"     ,"@E 999,999,999.9999","@!"       }

	EnchoiceBar(oDlg,{||oDlg:End(),Nil},{||oDlg:End()},,)

//Parametros RDListBox(lin,col,compr,alt, ,  , tamanho das colunas no grid)
	oLstBoxPC := RDListBox(5,.80,360,130, aCols, aHeader2,{60,30,30,30,40,30,40},aPicture)

	ACTIVATE MSDIALOG oDlg CENTERED

	dbSelectArea(cArqQry)
	dbCloseArea()
	dbSelectArea("SC7")
	RestArea(aArea)
Return( .T. )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retornar a Quantidade em Pedidos de Vendas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function C010PedVen(cProduto, cLocal)
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local aHeader2 := {}
	Local oLstBox, oDlg
	Local aArea    := GetArea()
	Local nRegSC5  := SC5->(Recno())


	Private aCols     := {}
	Private aPicture  := {}

	SC5->( dbsetorder(1) )

	cArqQry := "QUERYSC6"
	lQuery  := .T.
	cQuery  := "SELECT QUERYSC6.C6_CLI, QUERYSC6.C6_LOJA, QUERYSC6.C6_ENTREG, QUERYSC6.C6_QTDVEN, QUERYSC6.C6_QTDENT, QUERYSC6.C6_NUM "
	cQuery += "FROM "+RetSqlName("SC6")+" QUERYSC6, " + RetSqlName("SC5") + " SC5 "
	cQuery += "WHERE QUERYSC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
	cQuery += "QUERYSC6.C6_FILIAL = SC5.C5_FILIAL AND "
	cQuery += "QUERYSC6.C6_NUM = SC5.C5_NUM AND "
	cQuery += "SC5.D_E_L_E_T_=' ' AND "
	cQuery += "QUERYSC6.C6_PRODUTO='"+cProduto+"' AND "
	cQuery += "QUERYSC6.C6_LOCAL='"+cLocal+"' AND "
	cQuery += "(QUERYSC6.C6_QTDVEN-QUERYSC6.C6_QTDENT)>0 AND "
	cQuery += "QUERYSC6.C6_BLQ <> 'R ' AND "
	cQuery += "SC5.C5_EMISSAO >= '20100301' AND "
	cQuery += "QUERYSC6.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY QUERYSC6.C6_ENTREG "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)
	dbSelectArea(cArqQry)

	DbGotop()
	Do While !eof()
		_aAux := {}

		SA1->( dbSeek( xFilial("SA1") + (cArqQry)->C6_CLI + (cArqQry)->C6_LOJA ) )

		aadd(_aAux, SA1->A1_NREDUZ )
		aadd(_aAux, dtoc(stod((cArqQry)->C6_ENTREG)) )
		aadd(_aAux, (cArqQry)->C6_QTDVEN - (cArqQry)->C6_QTDENT )
		aadd(_aAux, (cArqQry)->C6_NUM )

		aadd(aCols,_aAux)

		DbSkip()
	Enddo

//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(acols) == 0
		aadd(aCols,{space(07),ctod( " " ), 0.00,space(06)})
	endif

	DEFINE MSDIALOG oDlg FROM  15,6 TO 400,430 TITLE ('Reservas' ) PIXEL
	@ 014,005 TO 051,210  LABEL '' OF oDlg 	PIXEL

	@ 020,007 SAY "Código"     SIZE  21,7 OF oDlg PIXEL
	@ 020,037 SAY cProduto     SIZE  49,8 OF oDlg PIXEL COLOR CLR_BLUE
	@ 030,007 SAY "Descrição"  SIZE  32,7 OF oDlg PIXEL
	@ 030,036 SAY Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC") SIZE 140,8 OF oDlg PIXEL COLOR CLR_BLUE
	@ 040,007 SAY "Reservado"  SIZE  32,7 OF oDlg PIXEL
	@ 040,036 SAY Alltrim( Transform( QtdEmPedidos( cProduto ), "@E 999,999,999,999.9999" ) ) SIZE 49,8 OF oDlg PIXEL COLOR CLR_BLUE

	aHeader2 := {"Cliente","Prazo Entrega","Quantidade"         ,"Nr Pedido"}
	aPicture := {"@!"     ,"@D"           ,"@E 999,999,999.9999","@!"       }

	EnchoiceBar(oDlg,{||oDlg:End(),Nil},{||oDlg:End()},,)

//Parametros RDListBox(lin,col,compr,alt, ,  , tamanho das colunas no grid)
	oLstBox := RDListBox(4,.80,205,120, aCols, aHeader2,{80,40,30,10},aPicture)
	ACTIVATE MSDIALOG oDlg CENTERED

	dbSelectArea(cArqQry)
	dbCloseArea()
	dbSelectArea("SC6")
	RestArea(aArea)
	SC5->(DbGoto(nRegSC5 ))
Return( .T. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retornar a Quantidade De/Em Terceiros       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function C010Terc(cProduto, cTipo, cLocal )
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local aHeader2 := {}
	Local oLstBox, oDlg
	Local _cTit    := "Saldo "+iif( cTipo == "E", "EM", "DE" )+" Terceiros"
	Local aArea    := GetArea()

	Private aCols     := {}
	Private aPicture  := {}

	cArqQry := "QUERYSB6"
	lQuery  := .T.
	cQuery  := "SELECT QUERYSB6.B6_CLIFOR, QUERYSB6.B6_LOJA, QUERYSB6.B6_SALDO, QUERYSB6.B6_TPCF,QUERYSB6.B6_DOC, QUERYSB6.B6_SERIE "

	if cTipo== 'E'
		cQuery += " , SB8.B8_LOTECTL, SB8.B8_DFABRIC, SB8.B8_DTVALID "
		cQuery += " FROM "+RetSqlName("SB6")+" QUERYSB6 "
		cQuery += " INNER JOIN "+retSqlName("SD2")+" SD2 ON ("
		cQuery += " SD2.D2_FILIAL = QUERYSB6.B6_FILIAL AND "
		cQuery += " SD2.D2_DOC = QUERYSB6.B6_DOC AND "
		cQuery += " SD2.D2_SERIE = QUERYSB6.B6_SERIE AND "
		cQuery += " SD2.D2_CLIENTE = QUERYSB6.B6_CLIFOR AND "
		cQuery += " SD2.D2_LOJA = QUERYSB6.B6_LOJA AND "
		cQuery += " SD2.D2_IDENTB6 = QUERYSB6.B6_IDENT AND "
		cQuery += " SD2.D_E_L_E_T_ = ' ')"

		cQuery += " INNER JOIN "+retSqlName("SB8")+" SB8 ON ("
		cQuery += " SB8.B8_FILIAL = SD2.D2_FILIAL     AND "
		cQuery += " SB8.B8_PRODUTO = SD2.D2_COD       AND "
		cQuery += " SB8.B8_LOCAL = SD2.D2_LOCAL       AND "
		cQuery += " SB8.B8_LOTECTL = SD2.D2_LOTECTL   AND "
		cQuery += " SB8.D_E_L_E_T_ = ' ')"
	else
		cQuery += " FROM "+RetSqlName("SB6")+" QUERYSB6 "
	endif
	cQuery  += "WHERE QUERYSB6.B6_FILIAL='"+xFilial("SB6")+"' AND "
	cQuery  += "QUERYSB6.B6_PRODUTO='"+cProduto+"' AND "
	cQuery  += "QUERYSB6.B6_LOCAL='"+cLocal+"' AND "
	cQuery  += "QUERYSB6.B6_TIPO = '"+cTipo+"' AND "
	cQuery  += "QUERYSB6.B6_PODER3 = 'R' AND "
	cQuery  += "QUERYSB6.B6_SALDO > 0 AND "

	cQuery  += "QUERYSB6.D_E_L_E_T_=' ' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)
	dbSelectArea(cArqQry)

	DbGotop()
	Do While !eof()
		_aAux := {}
		if (cArqQry)->B6_TPCF == "C"
			SA1->( dbSeek( xFilial("SA1") + (cArqQry)->B6_CLIFOR + (cArqQry)->B6_LOJA ) )
			aadd(_aAux, SA1->A1_NREDUZ )
		else
			SA2->( dbSeek( xFilial("SA2") + (cArqQry)->B6_CLIFOR + (cArqQry)->B6_LOJA ) )
			aadd(_aAux, SA2->A2_NREDUZ )
		endif

		aadd(_aAux, (cArqQry)->B6_SALDO )
		aadd(_aAux, (cArqQry)->B6_DOC )
		if cTipo == 'E'
			aadd(_aAux, (cArqQry)->B8_LOTECTL       )
			aadd(_aAux, stod((cArqQry)->B8_DFABRIC) )
			aadd(_aAux, stod((cArqQry)->B8_DTVALID) )
		endif
		aadd(aCols,_aAux)

		DbSkip()
	Enddo

//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(acols) == 0
		if cTipo == "E"
			aadd(aCols,{space(07),0.00,space(06), space(tamSx3("B8_LOTECTL")[1]), stod(""), stod("")})
		else
			aadd(aCols,{space(07),0.00,space(06)})

		endif
	endif

	nAltura := 400
	nLargura := 720

	nOffset := 160
	DEFINE MSDIALOG oDlg FROM  15,6 TO nAltura,nLargura TITLE ( _cTit ) PIXEL
	@ 014,005 TO 051,210+nOffset  LABEL '' OF oDlg 	PIXEL

	@ 020,007 SAY "Código"     SIZE  21,7 OF oDlg PIXEL
	@ 020,037 SAY cProduto     SIZE  49,8 OF oDlg PIXEL COLOR CLR_BLUE
	@ 030,007 SAY "Descrição"  SIZE  32,7 OF oDlg PIXEL
	@ 030,036 SAY Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC") SIZE 140,8 OF oDlg PIXEL COLOR CLR_BLUE
	@ 040,007 SAY "Saldo"      SIZE  32,7 OF oDlg PIXEL
	if cTipo == "E"
		@ 040,036 SAY Alltrim( Transform( QtdEmTerc( cProduto ), "@E 999,999,999,999.9999" ) ) SIZE 49,8 OF oDlg PIXEL COLOR CLR_BLUE
	else
		@ 040,036 SAY Alltrim( Transform( QtdDeTerc( cProduto ), "@E 999,999,999,999.9999" ) ) SIZE 49,8 OF oDlg PIXEL COLOR CLR_BLUE
	Endif

	aHeader2 := {"Terceiro","Quantidade","Documento"}
	aPicture := {"@!","@E 999,999,999.9999","@!"}

	if cTipo == 'E'
		aadd(aHeader2, "Lote")
		aadd(aHeader2, "Data Fabricação")
		aadd(aHeader2, "Data Validade")

		aadd(aPicture, "")
		aadd(aPicture, "")
		aadd(aPicture, "")
	endif

	EnchoiceBar(oDlg,{||oDlg:End(),Nil},{||oDlg:End()},,)

//Parametros RDListBox(lin,col,compr,alt, ,  , tamanho das colunas no grid)
	oLstBox := RDListBox(4,.80,205+nOffset ,120, aCols, aHeader2,{80,50,40},aPicture)
	ACTIVATE MSDIALOG oDlg CENTERED

	dbSelectArea(cArqQry)
	dbCloseArea()
	dbSelectArea("SB6")
	RestArea(aArea)
Return( .T. )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retornar Ordens Producao                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function C010Lotes(cProduto, cLocal)
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local aHeader2 := {}
	Local oLstBox, oDlgSB8
	Local aArea    := GetArea()

	Private aCols     := {}
	Private aPicture  := {}

	cArqQry := GETNEXTALIAS()
	lQuery  := .T.
	cQuery  := "SELECT B8_FILIAL, B8_PRODUTO, B8_LOCAL, B8_DATA, B8_DTVALID, B8_SALDO, B8_LOTECTL, B8_DFABRIC "
	cQuery  += " FROM "+RetSqlName("SB8")
	cQuery  += " WHERE B8_PRODUTO='"+cProduto+"' AND "
	cQuery  += " B8_LOCAL='"+cLocal+"' AND "
	cQuery  += " B8_SALDO > 0 AND "
	cQuery  += " D_E_L_E_T_<> '*' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)

	dbSelectArea(cArqQry)
	DbGotop()
	Do While !eof()
		_aAux := {}
		aadd(_aAux, (cArqQry)->B8_FILIAL )
		aadd(_aAux, (cArqQry)->B8_SALDO )
		aadd(_aAux, (cArqQry)->B8_LOTECTL )
		aadd(_aAux, stod((cArqQry)->B8_DATA) )
		aadd(_aAux, stod((cArqQry)->B8_DFABRIC ) )
		aadd(_aAux, stod((cArqQry)->B8_DTVALID) )

		aadd(aCols,_aAux)

		DbSkip()
	Enddo

//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(acols) == 0
		aadd(aCols,{space(02),0.00,space(20),ctod( " " ),ctod( " " ), ctod( " " ),space(250) })
	endif

	nTam1 := 500
	nTam2 := 610

	DEFINE MSDIALOG oDlgSB8 TITLE ( "Lotes em Estoque" ) FROM  000, 000  TO nTam1,nTam2  PIXEL
	nLin := 35
	nCol := 05
	nTam1 := 065
	nTam2 := 300

	@ nLin,nCol TO nTam1,nTam2  LABEL '' OF oDlgSB8 	PIXEL
	@ nLin,007 SAY "Código"     SIZE  21,7 OF oDlgSB8 PIXEL
	@ nLin,037 SAY cProduto     SIZE  49,8 OF oDlgSB8 PIXEL COLOR CLR_BLUE
	nLin +=10
	@ nLin,007 SAY "Descrição"  SIZE  32,7 OF oDlgSB8 PIXEL
	@ nLin,036 SAY Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC") SIZE 140,8 OF oDlgSB8 PIXEL COLOR CLR_BLUE
	nLin +=10
	@ nLin,007 SAY "Local"  	SIZE  32,7 OF oDlgSB8 PIXEL
	@ nLin,036 SAY cLocal 	SIZE 140,8 OF oDlgSB8 PIXEL COLOR CLR_BLUE

	aHeader2 := {"Filial","Saldo","Lote","Data Entrada","Data Fabricação","Data Validade" }
	aPicture := {"@!", "@E 999,999,999.9999" ,"@!","@D","@D","@D" }

	EnchoiceBar(oDlgSB8,{||oDlgSB8:End(),Nil},{||oDlgSB8:End()},,)

//Parametros RDListBox(lin,col,compr,alt, ,  , tamanho das colunas no grid)
	nLin := 5
	nCol := .80
	nTam1 := 300
	nTam2 := 180

	oLstBox := RDListBox(nLin,nCol,nTam1,nTam2, aCols, aHeader2,{20,50,60,50,50,50, 250},aPicture)

	ACTIVATE MSDIALOG oDlgSB8 CENTERED

	FreeObj(oDlgSB8)
	oDlgSB8 := Nil

	dbSelectArea(cArqQry)
	dbCloseArea()
	dbSelectArea("SB8")
	RestArea(aArea)

Return( .T. )
