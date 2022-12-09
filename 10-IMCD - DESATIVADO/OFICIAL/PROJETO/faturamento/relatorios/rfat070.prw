#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT070   º Autor ³ Giane              º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Estoque                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT070

	Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2     := "de acordo com os parametros informados pelo usuario."
	Local cDesc3     := "Relatório de Estoque Finalizado"
	Local cPict      := ""
	Local nLin       := 80     
	Local cPerg      := 'RFAT070A'   
	Local cQuery     := ""
	Local Cabec1     := "Tipo                      Produto         Descrição                                                               Local                    Divisão                                Qtd.Atual   Custo Médio    Custo Total Mês"
	//      012345678901234567890123  123456789012345 1234567890123456789012345678901234567890123456789012345678901234567890  99 12345678901234567890  123456789012345678901234567890  9,999,999,999.99  999,999.9999  99,999,999,999.99
	//      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//               1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        2         21        220
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd := {}
	Local dDataIni := ctod('')
	Local dDatafin := ctod('')    

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT070" , __cUserID )

	Private titulo     := "Relatório de Estoque Finalizado"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RFAT070" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFAT070" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias := "XSB9"

	If !Pergunte(cPerg)
		Return
	Endif   

	//como saber que data o protheus grava no B9? sempre o ultimo dia do mês? ou o dia que o usuario rodou o fechamento?
	dDataIni := FirstDay(MV_PAR08)
	dDataFin := lastday(MV_PAR08)    

	titulo += "  - Referente  " + substr(dtos(MV_PAR08),5,2) + '/' + left(dtos(MV_PAR08),4)

	cQuery := "SELECT B9_COD, B9_LOCAL, B9_FILIAL, B9_DATA, B9_QINI, B9_CM1, B1_DESC, B1_SEGMENT, B1_TIPO, 'B9' TIPO, ' ' B6_IDENT, ' ' B6_TES "
	cQuery += "  FROM " + RetSQLName( "SB9" ) + " SB9 "
	cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = B9_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE B9_FILIAL  = '" + xFilial( "SB9" ) + "' "
	cQuery += "   AND B9_COD     BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += "   AND B9_LOCAL   BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	cQuery += "   AND B9_DATA    BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFin ) + "' "
	If !Empty( MV_PAR07 )
		cQuery += "   AND B1_TIPO    IN " + FormatIN( AllTrim( mv_par07 ), "," )
	Endif
	cQuery += "   AND B1_SEGMENT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += "   AND B1_CONTA BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "' "
	cQuery += "   AND B9_QINI > 0 "
	cQuery += "   AND SB9.D_E_L_E_T_ = ' ' "

	cQuery += " UNION "

	cQuery += "SELECT B6_PRODUTO B9_COD, 'TERCEIROS' B9_LOCAL, B6_FILIAL B9_FILIAL, B6_EMISSAO B9_DATA, SUM( B6_SALDO ) B9_QINI, ROUND( AVG( B6_CUSTO1 / B6_QUANT ), 2 ) B9_CM1 , B1_DESC, B1_SEGMENT, B1_TIPO, 'B6' TIPO, B6_IDENT, B6_TES "
	cQuery += "  FROM " + RetSQLName( "SB6" ) + " SB6 "
	cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = B6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE B6_FILIAL  = '" + xFilial( "SB6" ) + "' "
	cQuery += "   AND B6_PODER3  = 'R' "
	cQuery += "   AND B6_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += "   AND B6_LOCAL   BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	cQuery += "   AND B6_DTDIGIT <= '" + DtoS( dDataFin ) + "' "
	If !Empty( MV_PAR07 )
		cQuery += "   AND B1_TIPO    IN " + FormatIN( AllTrim( mv_par07 ), "," )
	Endif
	cQuery += "   AND B1_SEGMENT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += "   AND B1_CONTA BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "' "
	cQuery += "   AND SB6.D_E_L_E_T_ = ' ' AND B6_QUANT > 0"
	cQuery += "GROUP BY B6_PRODUTO, B6_FILIAL, B6_EMISSAO, B1_DESC, B1_SEGMENT, B1_TIPO, B6_IDENT, B6_TES "
	cQuery += "ORDER BY B9_DATA DESC, B1_DESC "

	/*
	cQuery := "SELECT SB9.B9_COD, SB9.B9_LOCAL, SB9.B9_FILIAL, SB9.B9_DATA, SB9.B9_QINI, SB9.B9_CM1, " 
	cQuery += " SB1.B1_DESC, SB1.B1_SEGMENT, SB1.B1_TIPO " 
	cQuery += "FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1 " 
	cQuery += "WHERE SB9.B9_COD >= '"  + MV_PAR01 + "' AND SB9.B9_COD <= '" + MV_PAR02 + "' "
	cQuery += "AND SB9.B9_LOCAL >= '" + MV_PAR05 + "' AND SB9.B9_LOCAL <= '" + MV_PAR06 + "' "
	cQuery += "AND SB9.B9_COD = SB1.B1_COD "
	cQuery += "AND SB1.B1_SEGMENT >= '" + MV_PAR03 + "' AND SB1.B1_SEGMENT  <= '" + MV_PAR04 + "' "     
	cQuery += "AND SB9.B9_DATA >= '" + dtos(dDataIni) + "' AND SB9.B9_DATA <=  '" + dtos(dDataFin) + "' "
	If !empty(MV_PAR07)
	cQuery += "AND SB1.B1_TIPO IN " + FormatIn( MV_PAR07, "," )
	Endif   
	cQuery += " AND SB9.D_E_L_E_T_ = ' ' "    
	cQuery += "ORDER BY SB9.B9_DATA DESC, SB1.B1_DESC "    
	*/

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	dbSelectArea(cAlias)  
	DbGotop()

	if MV_PAR09 == 2 //em excel

		MsgRun("Processando Relatório de Estoque em excel, aguarde...","",{|| R070Excel() })

	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta a interface padrao com o usuario...                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		wnrel := SetPrint(cAlias,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)    

		If nLastKey == 27
			(cAlias)->(DbCloseArea())
			Return
		Endif

		SetDefault(aReturn,cAlias)

		If nLastKey == 27        
			(cAlias)->(DbCloseArea())
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)    

	Endif

	(cAlias)->(DbCloseArea())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local nOrdem
	Local dDataRef 

	dbSelectArea(cAlias)

	SetRegua(RecCount())

	dbGoTop() 
	dDataRef := (cAlias)->B9_DATA
	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//o arquivo esta em ordem descendente de data, pois se houve mais um "fechamento" no mesmo mês,
		//deve-se considerar sempre a ultima data, então o que for diferente desta data, não listar
		If (cAlias)->TIPO = "B9" .AND. (cAlias)->B9_DATA <> dDataRef 
			DbSkip()
			loop
		Endif

		If (cAlias)->TIPO = "B6"
			aSaldo	:= CalcTerc( (cAlias)->B9_COD, Nil, Nil, (cAlias)->B6_IDENT, (cAlias)->B6_TES, , , lastday(MV_PAR08) )
			nSaldo  := aSaldo[1]
			nPrUnit := (cAlias)->B9_CM1

			If nSaldo <= 0
				(cAlias)->( dbSkip() )
				Loop
			Endif
		Endif

		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		cTipo := ""   
		cArmazem := ""
		DbSelectArea("SX5")
		DbSetOrder(1)
		If DbSeek(xFilial("SX5")+'02' +(cAlias)->B1_TIPO)
			cTipo := X5DESCRI()
		Endif

		If DbSeek(xFilial("SX5")+'ZH' +(cAlias)->B9_lOCAL)
			cArmazem := X5DESCRI()
		Endif                                

		If (cAlias)->B9_LOCAL = '01'
			cArmazem := 'MAKENI'
		Endif

		dbSelectArea(cAlias)

		@ nLin,000   PSAY cTipo 
		@ nLin,027   PSAY (cAlias)->B9_COD  
		@ nLin,043   PSAY (cAlias)->B1_DESC
		@ nLin,115   PSAY (cAlias)->B9_LOCAL
		@ nLin,118   PSAY cArmazem 
		@ nLin,140   PSAY Posicione("ACY",1,xFilial("ACY") + (cAlias)->B1_SEGMENT, "ACY_DESCRI" )
		@ nLin,170   PSAY If( (cAlias)->TIPO = "B9", Transform((cAlias)->B9_QINI, "@E 99,999,999,999.99" ), Transform( nSaldo, "@E 99,999,999,999.99" ) )
		@ nLin,185   PSAY If( (cAlias)->TIPO = "B9", Transform((cAlias)->B9_CM1, "@E 999,999,999.9999" ), Transform( nPrUnit, "@E 999,999,999.9999" ) )
		@ nLin,203   PSAY If( (cAlias)->TIPO = "B9", Transform( (cAlias)->B9_CM1 * (cAlias)->B9_QINI , "@E 999,999,999,999.99" ), Transform( nSaldo * nPrUnit , "@E 999,999,999,999.99" ) )

		nLin := nLin + 1 

		dbSkip() 
	EndDo

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R070EXCEL Autor ³                       ³ Data ³04.02.2010³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime relatorio na versao excel                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R070EXCEL()
	Local aCabec := {}
	Local aItens := {}                      
	Local nTotReg := 0  
	Local dDataRef

	aadd(aCabec, "Tipo"  )
	aadd(aCabec, "Produto")
	aadd(aCabec, "Descrição" )
	aadd(aCabec, "Local"  )
	aadd(aCabec, "Divisão" )  
	aadd(aCabec, "Qtde Atual"  )
	aadd(aCabec, "Custo Médio"  )
	aadd(aCabec, "Custo Total Mês"  )

	dbSelectArea(cAlias) 
	//(cAlias)->( dbEval( { || nTotReg++ } ) )  
	//ProcRegua( nTotReg )
	(cAlias)->(DbGotop())
	dDataRef := (cAlias)->B9_DATA  

	While !EOF()     
		//IncProc('Processando relatorio, aguarde...')     

		//caso haja mais de um "fechamento" no mesmo mês, listar somente a ultima data
		If (cAlias)->B9_DATA <> dDataRef .and. (cAlias)->TIPO == "B9"
			DbSkip()
			loop
		Endif

		If (cAlias)->TIPO = "B6"
			aSaldo:=CalcTerc( (cAlias)->B9_COD, Nil, Nil, (cAlias)->B6_IDENT, (cAlias)->B6_TES, , , lastday(MV_PAR08) )
			nSaldo  := aSaldo[1]
			nPrUnit := (cAlias)->B9_CM1

			If nSaldo <= 0
				(cAlias)->( dbSkip() )
				Loop
			Endif
		Endif

		cTipo := ""   
		cArmazem := ""
		DbSelectArea("SX5")
		DbSetOrder(1)
		If DbSeek(xFilial("SX5")+'02' +(cAlias)->B1_TIPO)
			cTipo := X5DESCRI()
		Endif

		If DbSeek(xFilial("SX5")+'ZH' +(cAlias)->B9_lOCAL)
			cArmazem := X5DESCRI()
		Endif                                

		If (cAlias)->B9_LOCAL = '01'
			cArmazem := 'MAKENI'
		Endif

		dbSelectArea(cAlias)

		aadd(aItens, { cTipo,  (cAlias)->B9_COD ,;
		(cAlias)->B1_DESC,  (cAlias)->B9_LOCAL + " " + cArmazem ,;
		Posicione("ACY",1,xFilial("ACY") + (cAlias)->B1_SEGMENT, "ACY_DESCRI" ) ,;
		If( (cAlias)->TIPO = "B9", Transform((cAlias)->B9_QINI, "@E 99,999,999,999.99" ), Transform( nSaldo, "@E 99,999,999,999.99" ) ) ,;
		If( (cAlias)->TIPO = "B9", Transform((cAlias)->B9_CM1, "@E 999,999,999.9999" ), Transform( nPrUnit, "@E 999,999,999.9999" ) ) ,;
		If( (cAlias)->TIPO = "B9", Transform( (cAlias)->B9_CM1 * (cAlias)->B9_QINI , "@E 999,999,999,999.99" ), Transform( nSaldo * nPrUnit , "@E 999,999,999,999.99" ) ) } )
		Dbskip()
	Enddo

	If len(aItens) == 0            
		MsgInfo("Não existem dados a serem impressas, de acordo com os parâmetros informados!","Atenção")
	Else  
		DlgToExcel({ {"ARRAY", titulo, aCabec, aItens} }) 
	Endif       

	//(cAlias)->(DbCloseArea())
Return