#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REST005  บ Autor ณ Robson Sanchez Dias  Data ณ  12/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Produtos em Estoque por Qtde de Dias          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/       


User Function REST005()

	Local cPerg := 'REST005'    
	Local cAlias:=alias()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "REST005" , __cUserID )

	PRIVATE cGrpAcesso:=""

	cGrpAcesso:=U_GrpsAcesso(__cUserId)

	If Empty(cGrpAcesso)
		MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Aten็ใo")
		Return 
	Endif
 
	dbselectarea(cAlias)
	If .not. Pergunte( cPerg, .T.)  
		return
	endif          

	Processa( { || U_ImpR005() }, "Processando Relat๓rio de Estoque em excel, aguarde..." )

	dbselectarea("SX6")


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
บPrograma  ณ IMPR005  บ Autor ณ Robson Sanchez     บ Data ณ  12/05/2010   บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IMPR005()
	Local aAreaAtu := GetArea()
	Local cQuery:=""
	Local aCabec := {}
	Local aDados := {}     
	Local cOrigem
	Local dData  := Ctod('')

	Local cAlias   := GetNextAlias()

	cQuery := "select "
	cQuery += "sb1.b1_tipo,sb1.b1_segment, acy.acy_descri,sb8.b8_produto,sb1.b1_desc,sb8.b8_lotectl,sb8.b8_dtvalid, sb8.b8_doc,sb8.b8_serie,sb8.b8_clifor,sb8.b8_loja, "
	cQuery += "sb1.b1_import,sb1.b1_um,sb8.b8_saldo,sb8.b8_data,sb8.b8_local "        
	cQuery += "from "+ RetSqlName("SB8")+" sb8 "

	cQuery += "JOIN "+ RetSqlName("SB1")+" sb1 ON "
	cQuery += " sb1.b1_cod = sb8.b8_produto AND  "
	cQuery += " sb1.d_e_l_e_t_ <> '*' "
	cQuery += "JOIN "+RetSqlName("ACY")+" acy ON "
	cQuery += "     acy.acy_grpven = sb1.b1_segment and
	cQuery += "     acy.acy_filial = '"+xFilial('ACY')+"' and "
	cQuery += "     acy.d_e_l_e_t_ <>'*' "

	cQuery += " where sb8.b8_filial = '"+xFilial('SB8')+"' and sb1.b1_filial = '"+xFilial('SB1')+"' and sb8.b8_saldo>0 and sb8.d_e_l_e_t_ <> '*' "

	cQuery += Iif(!Empty(MV_PAR01)," and sb8.b8_produto >='"+MV_PAR01+"' ","")
	cQuery += Iif(!Empty(MV_PAR02)," and sb8.b8_produto <='"+MV_PAR02+"' ","")

	cQuery += Iif(!Empty(MV_PAR03)," and sb1.b1_segment >='"+MV_PAR03+"' ","")
	cQuery += Iif(!Empty(MV_PAR04)," and sb1.b1_segment <='"+MV_PAR04+"' ","")

	cQuery += Iif(!Empty(MV_PAR05)," and sb1.b1_tipo >='"+MV_PAR05+"' ","")
	cQuery += Iif(!Empty(MV_PAR06)," and sb1.b1_tipo <='"+MV_PAR06+"' ","")

	cQuery += " and SB8.B8_LOCAL <> '98' "

	If ! ("TODOS" $ cGrpAcesso)  // Nao ้ Usuario Master / Adv Vendas???    
		cQuery += "and sb1.b1_segment in " + FormatIn(Alltrim(cGrpAcesso),'/')
	Endif

	cQuery += " OR ( "
	cQuery += "sb8.b8_data <= '20100228' and "
	cQuery += "sb8.b8_filial = '"+xFilial('SB8')+"' and sb1.b1_filial = '"+xFilial('SB1')+"' and sb8.b8_saldo>0 and sb8.d_e_l_e_t_ <> '*' "

	cQuery += Iif(!Empty(MV_PAR01)," and sb8.b8_produto >='"+MV_PAR01+"' ","")
	cQuery += Iif(!Empty(MV_PAR02)," and sb8.b8_produto <='"+MV_PAR02+"' ","")

	cQuery += Iif(!Empty(MV_PAR03)," and sb1.b1_segment >='"+MV_PAR03+"' ","")
	cQuery += Iif(!Empty(MV_PAR04)," and sb1.b1_segment <='"+MV_PAR04+"' ","")

	cQuery += Iif(!Empty(MV_PAR05)," and sb1.b1_tipo >='"+MV_PAR05+"' ","")
	cQuery += Iif(!Empty(MV_PAR06)," and sb1.b1_tipo <='"+MV_PAR06+"' ","")

	cQuery += " and SB8.B8_LOCAL <> '98' "

	If ! ("TODOS" $ cGrpAcesso)  // Nao ้ Usuario Master / Adv Vendas???    
		cQuery += "and sb1.b1_segment in " + FormatIn(Alltrim(cGrpAcesso),'/')
	Endif

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
	aadd(aCabec, "Tipo"  )
	aadd(aCabec, "Origem" )
	aadd(aCabec, "Unidade" )
	aadd(aCabec, "Numero Lote" )
	aadd(aCabec, "Validade Lote" )
	aadd(aCabec, "Qtde Estoque" )
	aadd(aCabec, "Dias Estoque" )
	aadd(aCabec, "Custo Unitario" )
	aadd(aCabec, "Custo Total" )

	While (cAlias)->(!EOF())

		IncProc()

		cQuery := "SELECT 'SD1' TIPO, D1_NUMSEQ NUMSEQ, D1_COD COD, D1_LOCAL LOCAL, D1_LOTECTL LOTECTL, D1_EMISSAO EMISSAO, CASE WHEN D1_QUANT = 0 THEN 0 ELSE D1_CUSTO / D1_QUANT END  CUSTO "
		cQuery += "  FROM " + RetSQLName( "SD1" )
		cQuery += " WHERE D1_FILIAL  = '" + xFilial( "SD1" ) + "' "
		cQuery += "   AND D1_COD     = '" + (cAlias)->(B8_PRODUTO) + "' "
		cQuery += "   AND D1_LOCAL   = '" + (cAlias)->(B8_LOCAL) + "' "
		cQuery += "   AND D1_LOTECTL = '" + (cAlias)->(B8_LOTECTL) + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		cQuery += " UNION "
		cQuery += "SELECT D3_CF TIPO, D3_NUMSEQ NUMSEQ, D3_COD COD, D3_LOCAL LOCAL, D3_LOTECTL LOTECTL, D3_EMISSAO EMISSAO, CASE WHEN D3_QUANT = 0 THEN 0 ELSE D3_CUSTO1 / D3_QUANT END CUSTO "
		cQuery += "  FROM " + RetSQLName( "SD3" ) 
		cQuery += " WHERE D3_FILIAL   = '" + xFilial( "SD3" ) + "' "
		cQuery += "   AND D3_COD      = '" + (cAlias)->(B8_PRODUTO) + "' "
		cQuery += "   AND D3_LOCAL    = '" + (cAlias)->(B8_LOCAL) + "' "
		cQuery += "   AND D3_LOTECTL  = '" + (cAlias)->(B8_LOTECTL) + "' "
		cQuery += "   AND SUBSTR( D3_CF, 1, 3 ) = 'DE0' "
		cQuery += "   AND D3_ESTORNO != 'S' "
		cQuery += "   AND D_E_L_E_T_  = ' ' "
		cQuery += " ORDER BY NUMSEQ DESC "
		If Select( "TMP_DT" ) > 0
			TMP_DT->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DT", .T., .F. )
		If TMP_DT->( !Eof() )
			dData      := StoD( TMP_DT->EMISSAO )
			nCustoUnit := TMP_DT->CUSTO
		Else
			dData := (cAlias)->(B8_DATA)
			nCustoUnit := 0
		Endif
		TMP_DT->( dbCloseArea() )

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

		If (cAlias)->b1_import == "S"
			cOrigem:="Importado"
		Endif

		If (cAlias)->b1_import == "N"
			cOrigem:="Nacional"
		Endif

		cLote := Padr((cAlias)->b8_lotectl,Len((cAlias)->b8_lotectl))

		sb1->(dbseek(xFilial('SB1')+(cAlias)->b8_produto))

		aadd(aDados, {  (cAlias)->b1_segment,;
		(cAlias)->acy_descri,;
		(cAlias)->b8_produto,;
		(cAlias)->b1_desc,;
		sb1->b1_tipo,;
		cOrigem,;
		(cAlias)->b1_um,;
		cLote,;
		(cAlias)->b8_dtvalid ,;
		transform((cAlias)->b8_saldo,"@E 999,999,999.9999"),;
		(cAlias)->(str(nDias,4)),;
		transform(nCustoUnit,"@E 999,999,999,999.99"),;
		transform(nTotEstoque,"@E 999,999,999,999.99") })

		(cAlias)->(dbSkip())
	EndDo   

	If len(aDados) == 0            
		MsgInfo("Nใo existem Registros a serem impressos, de acordo com os parโmetros informados!","Aten็ใo")
	Else  
		DlgToExcel({ {"ARRAY", "Relatorio de Produtos em Estoque por Qtde Dias", aCabec, aDados} }) 
	Endif

	(cAlias)->(DbCloseArea())

Return