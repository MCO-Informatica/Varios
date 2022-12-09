#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REST008  บ Autor ณ Robson Sanchez Dias  Data ณ  12/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Produtos em Estoque por Qtde de Dias          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function REST008()

	Local cPerg := 'REST008'
	Local cAlias:=alias()
	Local cAlias2:=alias()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "REST008" , __cUserID )

	/*
	PRIVATE cGrpAcesso:=""

	cGrpAcesso:=U_GrpsAcesso(__cUserId)

	If Empty(cGrpAcesso)
	MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Aten็ใo")
	Return
	Endif
	*/

	dbselectarea(cAlias)
	dbselectarea(cAlias2)

	If .not. Pergunte( cPerg, .T.)
		return
	endif

	Processa( { || U_ImpR008() }, "Processando Relat๓rio de Estoque em excel, aguarde..." )

	dbselectarea("SX6")


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
บPrograma  ณ IMPR008  บ Autor ณ Robson Sanchez     บ Data ณ  12/05/2010   บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IMPR008()
	Local aAreaAtu 	:= GetArea()
	Local cQuery	:=""
	Local aCabec 	:= {}
	Local aDados 	:= {}
	Local cOrigem
	Local dData  	:= Ctod('')
	Local lVai		:= .F.

	Local cAlias   := GetNextAlias()
	Local cAlias2   := GetNextAlias()

	cQuery := "select "
	cQuery += "sb1.b1_tipo,sb1.b1_segment, acy.acy_descri,sb8.b8_produto,sb1.b1_desc,sb8.b8_lotectl,sb8.b8_dtvalid, sb8.b8_doc,sb8.b8_serie,sb8.b8_clifor,sb8.b8_loja, "
	cQuery += "sb1.b1_import,sb1.b1_um,sb8.b8_saldo,sb8.b8_data,sb8.b8_local,sb8.b8_lotefor,sb8.b8_qtdori "
	cQuery += "from "+ RetSqlName("SB8")+" sb8 "

	cQuery += "JOIN "+ RetSqlName("SB1")+" sb1 ON "
	cQuery += " sb1.b1_cod = sb8.b8_produto and "
	cQuery += " sb1.d_e_l_e_t_ <> '*' "
	cQuery += "LEFT JOIN "+RetSqlName("ACY")+" acy ON "
	cQuery += "     acy.acy_grpven = sb1.b1_segment and
	cQuery += "     acy.acy_filial = '"+xFilial('ACY')+"' and "
	cQuery += "     acy.d_e_l_e_t_ <>'*' "

	cQuery += " where sb8.b8_filial = '"+xFilial('SB8')+"' and sb1.b1_filial = '"+xFilial('SB1')+"'  and sb8.d_e_l_e_t_ <> '*' AND SB8.B8_SALDO >0 "

	cQuery += Iif(!Empty(MV_PAR01)," and sb8.b8_produto >='"+MV_PAR01+"' ","")
	cQuery += Iif(!Empty(MV_PAR02)," and sb8.b8_produto <='"+MV_PAR02+"' ","")

	cQuery += Iif(!Empty(MV_PAR03)," and sb1.b1_segment >='"+MV_PAR03+"' ","")
	cQuery += Iif(!Empty(MV_PAR04)," and sb1.b1_segment <='"+MV_PAR04+"' ","")

	cQuery += Iif(!Empty(MV_PAR05)," and sb1.b1_tipo >='"+MV_PAR05+"' ","")
	cQuery += Iif(!Empty(MV_PAR06)," and sb1.b1_tipo <='"+MV_PAR06+"' ","")

	cQuery += " and SB8.B8_LOCAL NOT IN ('98','RP')  "

	//If ! ("TODOS" $ cGrpAcesso)  // Nao ้ Usuario Master / Adv Vendas???        // RETIRADO EM 020218 NAO EXISTE MAIS REGRA DE CONFIDENCIALIDADE
	//	cQuery += "and sb1.b1_segment in " + FormatIn(Alltrim(cGrpAcesso),'/')
	//Endif

	cQuery += " OR ( "
	cQuery += "sb8.b8_data <= '20100228' and "
	cQuery += "sb8.b8_filial = '"+xFilial('SB8')+"' and sb1.b1_filial = '"+xFilial('SB1')+"'  and sb8.d_e_l_e_t_ <> '*' "

	cQuery += Iif(!Empty(MV_PAR01)," and sb8.b8_produto >='"+MV_PAR01+"' ","")
	cQuery += Iif(!Empty(MV_PAR02)," and sb8.b8_produto <='"+MV_PAR02+"' ","")

	cQuery += Iif(!Empty(MV_PAR03)," and sb1.b1_segment >='"+MV_PAR03+"' ","")
	cQuery += Iif(!Empty(MV_PAR04)," and sb1.b1_segment <='"+MV_PAR04+"' ","")

	cQuery += Iif(!Empty(MV_PAR05)," and sb1.b1_tipo >='"+MV_PAR05+"' ","")
	cQuery += Iif(!Empty(MV_PAR06)," and sb1.b1_tipo <='"+MV_PAR06+"' ","")

	cQuery += " and SB8.B8_LOCAL NOT IN ('98','RP')  AND SB8.B8_SALDO >0 "

	//If ! ("TODOS" $ cGrpAcesso)  // Nao ้ Usuario Master / Adv Vendas???          // ALTERADO EM 020218 POR SANDRA NAO EXISTE MAIS REGRA DE CONFIDENCIALIDADE
	//	cQuery += "and sb1.b1_segment in " + FormatIn(Alltrim(cGrpAcesso),'/')
	//Endif

	cQuery+=" ) "

	cQuery += " order by sb1.b1_segment,sb8.b8_produto,sb8.b8_lotectl "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)
	TCSetField(cAlias,"B8_DATA","D",8,0)
	TCSetField(cAlias,"B8_DTVALID","D",8,0)

	COUNT TO nQtdReg
	ProcRegua(nQtdReg)

	(cAlias)->(dbgotop())

	//IncProc("Processando Registros Saldos..."))

	aadd(aCabec, "Segmento"  )
	aadd(aCabec, "Descricao" )
	aadd(aCabec, "Codigo do Produto" )
	aadd(aCabec, "Descricao" )
	aadd(aCabec, "Armazem"  )
	aadd(aCabec, "Tipo"  )
	aadd(aCabec, "Origem" ) 
	aadd(aCabec, "Documento" ) 
	aadd(aCabec, "Unidade" )
	aadd(aCabec, "Numero Lote" ) 
	aadd(aCabec, "Lote Fabricante" )
	aadd(aCabec, "Validade Lote" )
	aadd(aCabec, "Qtde Estoque" )
	aadd(aCabec, "Dias Estoque" )
	aadd(aCabec, "Custo Unitario" )
	aadd(aCabec, "Custo Total" )
	aadd(aCabec, "Qtd Entrada" )

	While (cAlias)->(!EOF())

		IncProc()

		cQuery := "SELECT 'SD1' TIPO, D1_NUMSEQ NUMSEQ, D1_COD COD, D1_LOCAL LOCAL, D1_DOC DOC, D1_LOTECTL LOTECTL, D1_LOTEFOR LOTEFOR, D1_DTDIGIT EMISSAO, D1_QUANT QUANT, CASE WHEN D1_QUANT = 0 THEN 0 ELSE D1_CUSTO / D1_QUANT END  CUSTO "
		cQuery += "  FROM " + RetSQLName( "SD1" )
		cQuery += " WHERE D1_FILIAL  = '" + xFilial( "SD1" ) + "' "
		cQuery += "   AND D1_COD     = '" + (cAlias)->(B8_PRODUTO) + "' "
		cQuery += "   AND D1_LOTECTL = '" + (cAlias)->(B8_LOTECTL) + "' "  
		cQuery += "   AND D1_QUANT > 0 "
		cQuery += "   AND D_E_L_E_T_ = ' ' AND D1_LOCAL NOT IN ('98','RP')  "
		cQuery += " UNION "
		cQuery += "SELECT D3_CF TIPO, D3_NUMSEQ NUMSEQ, D3_COD COD, D3_LOCAL LOCAL, D3_DOC DOC, D3_LOTECTL LOTECTL, '-' LOTEFOR, D3_EMISSAO EMISSAO, D3_QUANT QUANT, CASE WHEN D3_QUANT = 0 THEN 0 ELSE D3_CUSTO1 / D3_QUANT END CUSTO "
		cQuery += "  FROM " + RetSQLName( "SD3" )
		cQuery += " WHERE D3_FILIAL   = '" + xFilial( "SD3" ) + "' "
		cQuery += "   AND D3_COD      = '" + (cAlias)->(B8_PRODUTO) + "' "
		cQuery += "   AND D3_LOTECTL  = '" + (cAlias)->(B8_LOTECTL) + "' "
		cQuery += "   AND SUBSTR( D3_CF, 1, 3 ) = 'DE0' "
		cQuery += "	  AND D3_DOC != 'INVENT   ' "
		cQuery += "   AND D3_ESTORNO != 'S' "
		cQuery += "	  AND D3_QUANT > 0 "
		cQuery += "   AND D_E_L_E_T_  = ' ' AND SUBSTR( D3_CF, 1, 3 ) <> 'DE4' " 
		cQuery += " ORDER BY NUMSEQ "
		If Select( "TMP_DT" ) > 0
			TMP_DT->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DT", .T., .F. )
		lVai := .F.
		If TMP_DT->( !Eof() )
			lVai := .T.
			dData      := StoD( TMP_DT->EMISSAO )
			nCustoUnit := TMP_DT->CUSTO
		Else
			dData := (cAlias)->(B8_DATA)
			nCustoUnit := 0
			nDias := dDataBase-dData

			If nDias < mv_par07
				(cAlias)->(dbskip())
				Loop
			Endif

			If sb2->(dbseek(xFilial('SB2')+(cAlias)->b8_produto+(cAlias)->b8_local)) .and. !Empty(sb2->b2_cm1)
				nCustoUnit := sb2->b2_cm1
			Else
				If sb1->(dbseek(xFilial('SB1')+(cAlias)->b8_produto)) .and. ! Empty(sb1->b1_custd)
					nCustoUnit := sb1->b1_custd
				Endif
			Endif

			nTotEstoque:= (cAlias)->b8_saldo * nCustoUnit

			cOrigem:=""

			cOrigem := "PRODUTO LOCAL"

			cLote := Padr((cAlias)->b8_lotectl,Len((cAlias)->b8_lotectl))

			sb1->(dbseek(xFilial('SB1')+(cAlias)->b8_produto))

			aadd(aDados, {  (cAlias)->b1_segment,;
			(cAlias)->acy_descri,;
			(cAlias)->b8_produto,;
			(cAlias)->b1_desc,;
			(cAlias)->b8_local,;
			sb1->b1_tipo,;
			cOrigem,;      
			(cAlias)->b8_doc,;
			(cAlias)->b1_um,;
			cLote,;
			(cAlias)->b8_lotefor,;
			(cAlias)->b8_dtvalid ,;
			transform((cAlias)->b8_saldo,"@E 999,999,999.9999"),;
			(cAlias)->(str(nDias,4)),;
			transform(nCustoUnit,"@E 999,999,999,999.99"),;
			transform(nTotEstoque,"@E 999,999,999,999.99"),;
			transform((cAlias)->b8_qtdori,"@E 999,999,999,999.99") })


		Endif

		If lVai                   
			nSaldo := (cAlias)->b8_saldo
			dbSelectArea("TMP_DT")
			do While !Eof()
				dData := STOD(TMP_DT->EMISSAO)
				nDias := dDataBase-dData

				//			If nDias < mv_par07 
				//				TMP_DT->(dbskip())
				//				Loop
				//			Endif

				If nSaldo == 0 .and. MV_PAR08 == 2
					TMP_DT->(dbskip())
					Loop
				Endif


				If sb2->(dbseek(xFilial('SB2')+(cAlias)->b8_produto+(cAlias)->b8_local)) .and. !Empty(sb2->b2_cm1)
					nCustoUnit := sb2->b2_cm1
				Else
					If sb1->(dbseek(xFilial('SB1')+(cAlias)->b8_produto)) .and. ! Empty(sb1->b1_custd)
						nCustoUnit := sb1->b1_custd
					Endif
				Endif

				nTotEstoque:= IIF(nSaldo >= TMP_DT->QUANT, TMP_DT->QUANT, nSaldo) * nCustoUnit

				cOrigem:=""


				cOrigem:="PRODUTO LOCAL"

				cLote := Padr((cAlias)->b8_lotectl,Len((cAlias)->b8_lotectl))

				sb1->(dbseek(xFilial('SB1')+(cAlias)->b8_produto))

				If nDias >= mv_par07
					aadd(aDados, {  (cAlias)->b1_segment,;
					(cAlias)->acy_descri,;
					(cAlias)->b8_produto,;
					(cAlias)->b1_desc,;
					(cAlias)->b8_local,;
					sb1->b1_tipo,;
					cOrigem,;      
					TMP_DT->DOC,;                              
					(cAlias)->b1_um,;
					cLote,;           
					TMP_DT->LOTEFOR,;
					(cAlias)->b8_dtvalid ,;
					transform(IIF(nSaldo >= TMP_DT->QUANT, TMP_DT->QUANT, nSaldo),"@E 999,999,999.9999"),;
					(cAlias)->(str(nDias,4)),;
					transform(nCustoUnit,"@E 999,999,999,999.99"),;
					transform(nTotEstoque,"@E 999,999,999,999.99"),;
					transform(TMP_DT->QUANT,"@E 999,999,999,999.99") })
				Endif

				nSaldo -= TMP_DT->QUANT
				If nSaldo < 0
					nSaldo := 0
				Endif 
				TMP_DT->(dbSkip())
			Enddo
		Endif
		TMP_DT->( dbCloseArea() )
		(cAlias)->(dbSkip())
	EndDo 

	if MV_PAR09 == 1 

		//novo select 
		cQuery := "    SELECT "
		cQuery += "		sb1.b1_tipo,sb1.b1_segment, acy.acy_descri,sb8.b8_produto,sb1.b1_desc,sb8.b8_lotectl,sb8.b8_dtvalid,sb8.b8_serie,sb8.b8_clifor,sb8.b8_loja, "
		cQuery += "		sb1.b1_import,sb1.b1_um,sb8.b8_data,sb8.b8_local,sb8.b8_lotefor,sb8.b8_qtdori "
		cQuery += "    FROM " + RetSQLName( "SB6" ) + " SB6 " 
		cQuery += "    INNER JOIN " + RetSQLName( "SD2" ) + " SD2 ON B6_PRODUTO = D2_COD AND D2_DOC =  B6_DOC AND SD2.D2_NUMSEQ = SB6.B6_IDENT AND D2_CLIENTE = B6_CLIFOR AND D2_FILIAL = B6_FILIAL "
		cQuery += "    AND SB6.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' " 
		cQuery += "    INNER JOIN " + RetSQLName( "SB1" ) + "  SB1 ON B1_COD = B6_PRODUTO AND SB1.D_E_L_E_T_ <> '*'   
		cQuery += "	   LEFT JOIN "+RetSqlName("ACY")+" acy ON acy.acy_grpven = sb1.b1_segment and acy.acy_filial = '"+xFilial('ACY')+"' and acy.d_e_l_e_t_ <>'*' "   
		cQuery += "    INNER JOIN " + RetSQLName( "SB8" ) + " SB8 ON B8_PRODUTO = B6_PRODUTO AND B8_LOTECTL = SD2.D2_LOTECTL AND B8_LOCAL = SB6.B6_LOCAL  "
		cQuery += "    INNER JOIN "
		cQuery += "     ( SELECT MIN(D1_DTDIGIT) DTDIGIT, D1_COD, D1_LOTECTL FROM " + RetSQLName( "SD1" ) + " SD1 WHERE SD1.D_E_L_E_T_ <> '*' AND SD1.D1_LOTECTL <> '          ' GROUP BY D1_COD, D1_LOTECTL ) "
		cQuery += "     VALIDADE ON VALIDADE.D1_COD = SB6.B6_PRODUTO AND VALIDADE.D1_LOTECTL = SD2.D2_LOTECTL "
		cQuery += "    WHERE B6_TIPO = 'E'  AND B6_ESTOQUE = 'S' AND B6_SALDO > 0 "
		cQuery += "    AND B6_FILIAL  = '" + xFilial( "SB6" ) + "' "

		If MV_PAR10  <> "   "            
			cQuery += "    AND B6_TES  = '"+MV_PAR10+"' "
		Endif  

		cQuery += "    AND D2_FILIAL  = '" + xFilial( "SD2" ) + "' "
		cQuery += Iif(!Empty(MV_PAR01)," and sb8.b8_produto >='"+MV_PAR01+"' ","")
		cQuery += Iif(!Empty(MV_PAR02)," and sb8.b8_produto <='"+MV_PAR02+"' ","")

		cQuery += Iif(!Empty(MV_PAR03)," and sb1.b1_segment >='"+MV_PAR03+"' ","")
		cQuery += Iif(!Empty(MV_PAR04)," and sb1.b1_segment <='"+MV_PAR04+"' ","")

		cQuery += Iif(!Empty(MV_PAR05)," and sb1.b1_tipo >='"+MV_PAR05+"' ","")
		cQuery += Iif(!Empty(MV_PAR06)," and sb1.b1_tipo <='"+MV_PAR06+"' ","") 

		//	If ! ("TODOS" $ cGrpAcesso)  // Nao ้ Usuario Master / Adv Vendas???          // RETIRADO POR SANDRA EM 020218 NAO EXISTE MAIS REGRA DE CONFIDENCIALIDADE
		//		cQuery += "and sb1.b1_segment in " + FormatIn(Alltrim(cGrpAcesso),'/')
		//	Endif

		cQuery += " and SB8.B8_LOCAL NOT IN ('98','RP')  " 
		cQuery += " GROUP BY sb1.b1_tipo,sb1.b1_segment, acy.acy_descri,sb8.b8_produto,sb1.b1_desc,sb8.b8_lotectl,sb8.b8_dtvalid,sb8.b8_serie,"
		cQuery += " sb8.b8_clifor,sb8.b8_loja, 		sb1.b1_import,sb1.b1_um,sb8.b8_data,sb8.b8_local,sb8.b8_lotefor,sb8.b8_qtdori "
		cQuery += " order by sb1.b1_segment,sb8.b8_produto,sb8.b8_lotectl "


		TCQUERY cQuery NEW ALIAS "TRB"  

		TCSetField("TRB" ,"B8_DATA","D",8,0)
		TCSetField("TRB" ,"B8_DTVALID","D",8,0)

		COUNT TO nQtdReg
		ProcRegua(nQtdReg)

		DbSelectArea("TRB")
		DbGotop()

		While !Eof()

			cQuery := "    SELECT b8_lotefor, DTDIGIT, b8_dtvalid, B1_UM, acy_descri, B1_DESC, b1_segment, 'SB8' TIPO, SD2.D2_NUMSEQ NUMSEQ, SB6.B6_PRODUTO COD, SB6.B6_LOCAL LOCAL, SD2.D2_DOC DOC, SD2.D2_LOTECTL LOTECTL, SD2.D2_LOTECTL LOTEFOR, SD2.D2_EMISSAO EMISSAO, "
			cQuery += "    SB6.B6_SALDO QUANT, CASE WHEN D2_QUANT = 0 THEN 0 ELSE D2_TOTAL / D2_QUANT END  CUSTO "
			cQuery += "    FROM " + RetSQLName( "SB6" ) + " SB6 " 
			cQuery += "    INNER JOIN " + RetSQLName( "SD2" ) + " SD2 ON B6_PRODUTO = D2_COD AND D2_DOC =  B6_DOC AND SD2.D2_NUMSEQ = SB6.B6_IDENT AND D2_CLIENTE = B6_CLIFOR AND D2_FILIAL = B6_FILIAL "
			cQuery += "    AND SB6.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' " 
			cQuery += "    INNER JOIN " + RetSQLName( "SB1" ) + "  SB1 ON B1_COD = B6_PRODUTO AND SB1.D_E_L_E_T_ <> '*'   
			cQuery += "	   JOIN "+RetSqlName("ACY")+" acy ON "
			cQuery += "     acy.acy_grpven = sb1.b1_segment and "
			cQuery += "     acy.acy_filial = '"+xFilial('ACY')+"' and "
			cQuery += "     acy.d_e_l_e_t_ <>'*' "   
			cQuery += "     INNER JOIN " + RetSQLName( "SB8" ) + " SB8 ON B8_PRODUTO = '" + TRB->B8_PRODUTO + "' AND B8_LOTECTL = SD2.D2_LOTECTL AND B8_LOCAL = SB6.B6_LOCAL  "
			cQuery += "     INNER JOIN "
			cQuery += "     ( SELECT MIN(D1_DTDIGIT) DTDIGIT, D1_COD, D1_LOTECTL FROM " + RetSQLName( "SD1" ) + " SD1 WHERE SD1.D_E_L_E_T_ <> '*' AND SD1.D1_LOTECTL <> '          ' AND D1_COD = '" + TRB->B8_PRODUTO + "' GROUP BY D1_COD, D1_LOTECTL ) "
			cQuery += "     VALIDADE ON VALIDADE.D1_COD = SB6.B6_PRODUTO AND VALIDADE.D1_LOTECTL = SD2.D2_LOTECTL "
			cQuery += "    WHERE B6_TIPO = 'E'  AND B6_ESTOQUE = 'S' AND B6_SALDO > 0 "
			cQuery += "    AND B6_FILIAL  = '" + xFilial( "SB6" ) + "' "
			cQuery += "    AND D2_FILIAL  = '" + xFilial( "SB6" ) + "' " 

			If MV_PAR10  <> "   "            
				cQuery += "    AND B6_TES  = '"+MV_PAR10+"' "
			Endif

			cQuery += "    AND B6_PRODUTO = '" + TRB->B8_PRODUTO + "' "
			cQuery += "    AND D2_LOTECTL = '" + TRB->B8_LOTECTL + "' " 
			cQuery += "    GROUP BY d2_tes,b8_lotefor, DTDIGIT, b8_dtvalid, B1_UM, acy_descri, B1_DESC, b1_segment, "
			cQuery += "    SD2.D2_NUMSEQ, SB6.B6_PRODUTO, SB6.B6_LOCAL, SD2.D2_DOC, SD2.D2_LOTECTL, "
			cQuery += "    SD2.D2_LOTECTL, SD2.D2_EMISSAO,SB6.B6_SALDO,D2_TOTAL,D2_QUANT"	
			cQuery += " ORDER BY NUMSEQ "
			If Select( "TMP_DT2" ) > 0
				TMP_DT2->( dbCloseArea() )
			Endif

			dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DT2", .T., .F. ) 

			dbSelectArea("TMP_DT2")
			do While !Eof()
				dDataVld := STOD(TMP_DT2->b8_dtvalid)
				dData := STOD(TMP_DT2->DTDIGIT)
				nDias := dDataBase-dData

				If sb2->(dbseek(xFilial('SB2')+TMP_DT2->COD+TMP_DT2->LOCAL)) .and. !Empty(sb2->b2_cm1)
					nCustoUnit := sb2->b2_cm1
				Else
					If sb1->(dbseek(xFilial('SB1')+TMP_DT2->COD)) .and. ! Empty(sb1->b1_custd)
						nCustoUnit := sb1->b1_custd
					Endif
				Endif

				nTotEstoque:= TMP_DT2->QUANT * nCustoUnit

				cOrigem:=""

				cOrigem := "PRODUTO EM TERCEIRO"

				cLote := TMP_DT2->LOTECTL

				sb1->(dbseek(xFilial('SB1')+TMP_DT2->COD))

				If nDias >= mv_par07
					aadd(aDados, {  TMP_DT2->b1_segment,;
					TMP_DT2->acy_descri,;
					TMP_DT2->COD,;
					TMP_DT2->B1_DESC,;
					TMP_DT2->LOCAL,;
					sb1->b1_tipo,;
					cOrigem,;      
					TMP_DT2->DOC,;                              
					TMP_DT2->B1_UM,;
					cLote,;           
					TMP_DT2->b8_lotefor,;
					dDataVld ,;
					transform(TMP_DT2->QUANT,"@E 999,999,999.9999"),;
					nDias,;
					transform(nCustoUnit,"@E 999,999,999,999.99"),;
					transform(nTotEstoque,"@E 999,999,999,999.99"),;
					transform(TMP_DT2->QUANT,"@E 999,999,999,999.99") })
				Endif

				TMP_DT2->(dbSkip())

			Enddo                  

			DbSelectArea("TRB")
			dbSkip()

		Enddo

	Endif                  

	If len(aDados) == 0
		MsgInfo("Nใo existem Registros a serem impressos, de acordo com os parโmetros informados!","Aten็ใo")
	Else
		DlgToExcel({ {"ARRAY", "Relatorio de Produtos em Estoque por Qtde Dias", aCabec, aDados} })
	Endif

	(cAlias)->(DbCloseArea())
	dbCloseArea("TRB") 

Return