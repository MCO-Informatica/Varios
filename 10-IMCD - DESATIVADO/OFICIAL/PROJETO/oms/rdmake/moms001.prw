#include "COLORS.CH"
#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "TCBROWSE.CH"
//#include "MTMK001.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MOMS001   ºAutor  ³  Daniel   Gondran  º Data ³  03/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para consulta de pedidos no OMS                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MAKENI                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User function MOMS001
	Local D1 := MV_PAR15
	Local D2 := MV_PAR16

	U_MTMK001B(1, D1, D2 )

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTMK001B  ºAutor  ³Marcos J.           º Data ³  06/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para consulta de Poder Terceiros e Pedidos de Venda º±±
±±º          ³ nopcao 1 = Poder Terceiro                                  º±±
±±º          ³ nopcao 2 = Itens do Pedido de Venda                        º±±
±±º          ³ nopcao 3 = Incluir um Pedido de Venda                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MTMK001B( nOpcao, dData1, dData2 )
	Local aArea   	:= GetArea()
	Local cAlias  	:= Alias()
	Local cQuery  	:= ""
	Local aStru   	:= {}
	Local aCampos 	:= {}
	Local bCampo	:= {|x| FieldName(x) }
	Local nUsado  	:= 0
	Local cArqTmp := "I_"+Criatrab(,.F.)

	Private aCols	:= {}
	Private aHeader := {}
	Private aTela[0][0]
	Private aCabec	:= {}
	Private aDados	:= {}
	Private oGetDados
	

	If nOpcao == 1
		//                         123456  1234567890123456789012345 123456789  X         X       123456789012345 123456789012345678901234567890 X   12345678901234567890 123456789012345 XX 99999999.99999 XX X        XX/XX/XX 12345-123 99999999.999 123456789012345
		aAdd( aCampos, { "LINHA", "Pedido  Grupo de Vendas           Nota     Status      Crd.Apro? Lib.Fat? Cod. Prd.	            Descricao                                                               TC  Cliente              Bairro          Cidade          UF CEP       Quantidade     UM  TP Frete Entrega  Peso Liquido Peso Bruto       Obs Cliente", "@!" } )

		aadd(aCabec, "Pedido")
		aadd(aCabec, "Grupo de Vendas")
		aadd(aCabec, "Nota")
		aadd(aCabec, "Status")
		aadd(aCabec, "Crd. Apro")
		aadd(aCabec, "Lib. Fat")
		aadd(aCabec, "Cod. Prd")
		aadd(aCabec, "Descricao")
		aadd(aCabec, "Cod. Onu")        //Coluna inserida por Gerson 29/07/16
		aadd(aCabec, "Clasf. Risco")    //Coluna inserida por Gerson 29/07/16
		aadd(aCabec, "Num. Risco")      //Coluna inserida por Gerson 29/07/16
		aadd(aCabec, "Tipo Carga")
		aadd(aCabec, "Cliente")
		aadd(aCabec, "Endereço")
		aadd(aCabec, "Bairro")
		aadd(aCabec, "Cidade")
		aadd(aCabec, "UF")
		aadd(aCabec, "CEP")
		aadd(aCabec, "Quantidade")
		aadd(aCabec, "UM")
		aadd(aCabec, "Tipo Frete")
		aadd(aCabec, "Entrega")
		aadd(aCabec, "Peso Liquido")
		aadd(aCabec, "Peso Bruto")
		aadd(aCabec, "Obs. Cliente")
		aadd(aCabec, "Valor Total")

		Ofont:=CreatFontw( "Courier New", 0, -12 )

		aAdd( aStru, { "LINHA", "C", 300, 0 }	)

		oTmpTable := FWTemporaryTable():New("TRB")  
		oTmpTable:SetFields(aStru) 
		oTmpTable:AddIndex("1", {"LINHA"})
		oTmpTable:Create()
	
		cQuery := " SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_NOTA, C6_PRODUTO, B1_DESC, B1_TIPCAR, "
		cQuery += " C6_ENTREG, C6_QTDVEN, C6_QTDENT, C6_DATFAT, C6_UM, C6_VALOR,"
		cQuery += " C5_CLIENTE, C5_LOJACLI, C5_CENT, C5_LENT, C5_LIBEROK, C5_NOTA, C5_BLQ, "
		cQuery += " C5_X_CANC, C5_X_REP, C5_LIBCRED, C5_TPFRETE, C5_GRPVEN, "
		cQuery += " A1_NREDUZ, A1_END, A1_MUN, A1_EST, A1_CEP, A1_BAIRRO,A1_XOBSMTG, A1_GRPVEN, "
		cQuery += " B1_PESBRU, B1_PESO , B1__CODONU, B1_CLARIS, B1_NUMRIS "
		cQuery += " FROM " + RetSqlName("SC6") + " SC6, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SA1") + " SA1, "
		cQuery +=  	RetSqlName("SC5") + " SC5, " + RetSqlName("SF4") + " SF4 "
		cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "'"
		cQuery += "   AND C6_ENTREG >= '" + Dtos(dData1) + "'"
		cQuery += "   AND C6_ENTREG <= '" + Dtos(dData2) + "'"
		cQuery += "   AND SC6.D_E_L_E_T_ <> '*'"
		cQuery += "   AND B1_FILIAL = '" + xFilial("SB1") + "'"
		cQuery += "   AND B1_COD = C6_PRODUTO"
		cQuery += "   AND SB1.D_E_L_E_T_ <> '*'"
		cQuery += "   AND A1_FILIAL = '" + xFilial("SA1") + "'"
		cQuery += "   AND A1_COD = C6_CLI"
		cQuery += "   AND A1_LOJA = C6_LOJA"
		cQuery += "   AND SA1.D_E_L_E_T_ <> '*'"
		cQuery += "	  AND C5_FILIAL = C6_FILIAL"
		cQuery += "   AND C5_NUM = C6_NUM"
		cQuery += "   AND C5_X_CANC <> 'C'"
		cQuery += "   AND C5_X_REP  <> 'R'"
		cQuery += "   AND C5_NOTA = '         '"
		cQuery += "	  AND SC5.D_E_L_E_T_ <> '*'"
		cQuery += "	  AND F4_FILIAL = C6_FILIAL"
		cQuery += "   AND F4_CODIGO = C6_TES"
		cQuery += "   AND F4_ESTOQUE = 'S'"
		cQuery += "	  AND SF4.D_E_L_E_T_ <> '*'"
		cQuery += " ORDER BY C6_NUM "

		cQuery := ChangeQuery( cQuery )
		DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "TMP" , .T., .T. )

		TcSetField("TMP", "C6_ENTREG", "D", 08, 0)
		TcSetField("TMP", "C6_DATFAT", "D", 08, 0)
		TcSetField("TMP", "C6_QTDVEN", "N", 12, 3)
		TcSetField("TMP", "C6_QTDENT", "N", 12, 3)

		DbSelectArea("TMP")
		DbGoTop()
		While !Eof()

			dbSelectArea("SC9")
			dbSetOrder(1)
			dbSeek(TMP->C6_FILIAL + TMP->C6_NUM + TMP->C6_ITEM)

			If !EMPTY(SC9->C9_NFISCAL) .OR. !Empty(TMP->C6_NOTA)
				dbSelectArea("TMP")
				dbSkip()
				Loop
			Endif

			cMune := ''
			cEste := ''
			cCepe := ''
			cBaire := ''
			cLibPed := ''
			cEnd := ''
			cVal := 0
			cCodonu := ''
			cClaris := ''
			cNumris := ''

			If TMP->C5_CLIENTE+TMP->C5_LOJACLI <> TMP->C5_CENT+TMP->C5_LENT
				dbSelectarea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial("SA1")+TMP->C5_CENT+TMP->C5_LENT)
				cMune := SA1->A1_MUN
				cEste := SA1->A1_EST
				cCepe := SA1->A1_CEP
				cBaire := SA1->A1_BAIRRO
				cEnd := SA1->A1_END
			Endif

			Do Case
				Case Empty(TMP->C5_LIBEROK) .And. Empty(TMP->C5_NOTA) .And. Empty(TMP->C5_BLQ)
				cLibPed := "Pedido em Aberto"
				Case !Empty(TMP->C5_NOTA) .Or. TMP->C5_LIBEROK == "E" .And. Empty(TMP->C5_BLQ)
				cLibPed :=  "Pedido Encerrado"
				/*
				Case TMP->C5_LIBCRED == 'X' .AND. Empty(TMP->C5_NOTA)
				cLibPed :=  "Pedido de Venda Liberado no Crédito"
				*/
				Case !Empty(TMP->C5_LIBEROK) .And. Empty(TMP->C5_NOTA) .And. Empty(TMP->C5_BLQ)
				cLibPed :=  "Pedido de Venda Liberado Adm. Vendas"
				Case TMP->C5_X_REP == 'R'
				cLibPed := "Reprovado"
				Case TMP->C5_X_CANC == 'C'
				cLibPed :=  "Cancelado"
			EndCase

			cGrpVen := iif( EMPTY(TMP->C5_GRPVEN), TMP->A1_GRPVEN, TMP->C5_GRPVEN )
			DbSelectArea("ACY")
			DbSetOrder(1)
			If DbSeek(xFilial("ACY")+ cGrpVen )
				cGrpVen    := SUBSTR(ACY->ACY_DESCRI,1,25)
			EndIf

			DbSelectArea("TRB")

			cNum 	:= TMP->C6_NUM		// Pedido
			cNota 	:= TMP->C6_NOTA	// Nota
			cLibPed	:= cLibPed
			cCredAp	:= IIF((SC9->C9_LIBFST == "OK" .AND. SC9->C9_LIBSND == "OK" ),"S        ","N        ") 		// Lib Cred
			cLibFat	:= IIF((EMPTY(SC9->C9_BLEST).AND.EMPTY(SC9->C9_BLCRED)) ,"S        ","N        ")		// Lib Fat
			cDescr	:= TMP->B1_DESC // Descricao
			cTC		:= IIF(TMP->B1_TIPCAR=="000001"," G   "," S   ") // TC
			cNome	:= TMP->A1_NREDUZ	// Cliente
			cBaire	:= IIF( EMPTY(cBaire), TMP->A1_BAIRRO ,cBaire)	// Cidade
			cMune	:= IIF( EMPTY(cMune), TMP->A1_MUN,cMune)  //Municipio
			cEste	:= IIF( EMPTY(cEste), TMP->A1_EST,cEste) // Estado
			cCepe	:= Transform( IIF( EMPTY(cCepe), TMP->A1_CEP, cCepe),"@R 99999-999" ) //CEP
			cQuant	:= Transform( TMP->C6_QTDVEN, "@E 99,999,999.9999" ) + " "						// Quantidade
			cUnid	:= TMP->C6_UM		// UM
			cTPFrt	:= TMP->C5_TPFRETE 	// Tp Frete
			cEntr	:= TransForm( TMP->C6_ENTREG, "@!" ) // Data Entrega
			cPesl	:= TransForm( TMP->B1_PESO * TMP->C6_QTDVEN, "@E 99,999,999.9999"  ) // Peso Liquido
			cPesB	:= TransForm( TMP->B1_PESBRU * TMP->C6_QTDVEN, "@E 99,999,999.9999"  ) // Peso Bruto
			cCodPrd	:= TMP->C6_PRODUTO
			cObsMntG := ALLTRIM(TMP->A1_XOBSMTG)
			cEnd := ALLTRIM(TMP->A1_END)
			cVal :=    TransForm(TMP->C6_VALOR, "@E 99,999,999.9999"  )
			cCodonu := TMP->B1__CODONU
			cClaris := TMP->B1_CLARIS
			cNumris := TMP->B1_NUMRIS

			cDetalhe := cNum	+ " "
			cDetalhe += cGrpVen	+ " "
			cDetalhe += cNota 	+ " "
			cDetalhe += cLibPed	+ " "
			cDetalhe += cCredAp	+ " "
			cDetalhe += cLibFat + " "
			cDetalhe += cCodPrd	+ " "
			cDetalhe += cDescr	+ " "
			cDetalhe += cCodonu + " "
			cDetalhe += cClaris + " "
			cDetalhe += cNumris + " "
			cDetalhe += cTC		+ " "
			cDetalhe += cNome	+ " "
			cDetalhe += cBaire	+ " "
			cDetalhe += cMune	+ " "
			cDetalhe += cEste	+ " "
			cDetalhe += cCepe	+ " "
			cDetalhe += cQuant	+ " "
			cDetalhe += cUnid	+ " "
			cDetalhe += cTPFrt	+ " "
			cDetalhe += cEntr	+ " "
			cDetalhe += cPesL	+ " "
			cDetalhe += cPesB	+ " "
			cDetalhe += cObsMntG + " "
			cDetalhe += cEnd    + " "
			cDetalhe += cVal    + " "


			Aadd(aDados,{cNum ,;
			cGrpVen	,;
			cNota 	,;
			cLibPed	,;
			cCredAp	,;
			cLibFat ,;
			cCodPrd	,;
			cDescr	,;
			cCodonu ,;
			cClaris ,;
			cNumris ,;
			cTC	    ,;
			cNome	,;
			cEnd    ,;
			cBaire	,;
			cMune	,;
			cEste	,;
			cCepe	,;
			cQuant	,;
			cUnid	,;
			cTPFrt	,;
			cEntr	,;
			cPesL	,;
			cPesB	,;
			cObsMntG,;
			cval    } )
			DbAppend()
			TRB->LINHA := cDetalhe
			DbSelectArea("TMP")
			DbSkip()
		EndDo

		TMP->( DbCloseArea() )
		aAlterFields := {}
		DbSelectArea("TRB")
		DbGoTop()

		@ 0,0 To IIF(oMainWnd:nRight==798,375,500),IIF(oMainWnd:nRight==798,780,1000) Dialog Tela1 Title "Pedidos"

		@ 005,005 To IIF(oMainWnd:nRight==798,160,230),IIF(oMainWnd:nRight==798,377,497) Browse "TRB" Fields aCampos Object oBrw
		oBrw:oBrowse:Ofont:=Ofont
		@ IIF(oMainWnd:nRight==798,165,235),IIF(oMainWnd:nRight==798,340,460-35) BmpButton Type 13 Action (Close( Tela1 ), U_GERAXLS())
		@ IIF(oMainWnd:nRight==798,165,235),IIF(oMainWnd:nRight==798,340,460) BmpButton Type 01 Action Close( Tela1 )
		Activate Dialog Tela1 Center

		TRB->( DbCloseArea() )
		//Ferase( cArqTmp + ".*" )

		RestArea( aArea )
		DbSelectArea( cAlias )
		Return( Nil )

	EndIf

	RestArea( aArea )
	DbSelectArea( cAlias )
	DbGoTop()
Return( .T. )


User Function GeraXLS

	DlgToExcel({ {"ARRAY", "Pedidos", aCabec , aDados} })

Return()
