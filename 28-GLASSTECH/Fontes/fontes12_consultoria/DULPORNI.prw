#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "FWADAPTEREAI.CH"

/*/{Protheus.doc} User Function MA415BUT
	(long_description)
	@type  Function
	@author Douglas Rodrigues da Silva
	@since 27/09/2021
	@version 1.0
	@example
	Rotina tem como objetivo calular os valores financeiros de acordo com o nível do orçamento
	@see (links_or_references)
	/*/

User Function DULPORNI()

	Local aArea		:= GetArea()
	Local aAreaCJ	:= SCJ->(GetArea())
	Local aAreaTMP1	:= TMP1->(GetArea())
	Local aRentab	:= {}

	Local cParc		:= ""
	Local cFilSB1	:= xFilial("SB1")
	Local cFilSB2	:= xFilial("SB2")
	Local cFilSF4	:= xFilial("SF4")

	Local nNumParc	:= 0
	Local nX		:= 0
	Local nAcresFin	:= 0
	Local nItem		:= 0
	Local nTributos	:= 0

	Local lProspect	:= .F.

	Local dDataCnd	:= M->CJ_EMISSAO

	Private aDuplN2	:= {}
	Private aDupl	:= {}
	Private aVencto	:= {}
		
	MaFisSave()
	MaFisEnd()
	MaFisIni(Iif(Empty(M->CJ_CLIENT),M->CJ_CLIENTE,M->CJ_CLIENT),;// 1-Codigo Cliente/Fornecedor
		M->CJ_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
		"C",;				// 3-C:Cliente , F:Fornecedor
		"N",;				// 4-Tipo da NF
		Iif(lProspect,cTipo,Iif(SCJ->(ColumnPos("CJ_TIPOCLI")) > 0,M->CJ_TIPOCLI,SA1->A1_TIPO)),;		// 5-Tipo do Cliente/Fornecedor
		Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461",;
		Nil,;
		Nil,;
		IiF(lProspect,M->CJ_PROSPE+M->CJ_LOJPRO,""))
	// Agrega os itens para a funcao fiscal
	dbSelectArea("TMP1")
	dbGotop()
	While ( !Eof() )
		// Verifica se a linha foi deletada
		If ( !TMP1->CK_FLAG .And. !Empty(TMP1->CK_PRODUTO) )
			// Posiciona Registros
			SB1->(dbSetOrder(1))
			If SB1->(MsSeek(cFilSB1 + TMP1->CK_PRODUTO))
				nQtdPeso := TMP1->CK_QTDVEN*SB1->B1_PESO
			EndIf
			SB2->(dbSetOrder(1))
			SB2->(MsSeek(cFilSB2 + TMP1->CK_PRODUTO + TMP1->CK_LOCAL))
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(cFilSF4 + TMP1->CK_TES))
			// Calcula o preco de lista
			nValMerc  := TMP1->CK_VALOR
			nPrcLista := TMP1->CK_PRUNIT
			nQtdPeso  := 0
			nItem++
			If ( nPrcLista == 0 )
				nPrcLista := A410Arred(nValMerc/TMP1->CK_QTDVEN,"CK_PRCVEN")
			EndIf
			nAcresFin := A410Arred(TMP1->CK_PRCVEN*SE4->E4_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred(nAcresFin*TMP1->CK_QTDVEN,"D2_TOTAL")
			nDesconto := A410Arred(nPrcLista*TMP1->CK_QTDVEN,"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto==0,TMP1->CK_VALDESC,nDesconto)
			nDesconto := Max(0,nDesconto)
			nPrcLista += nAcresFin

			//Para os outros paises, este tratamento e feito no programas que calculam os impostos.
			If cPaisLoc=="BRA" .or. lDescSai
				nValMerc  += nDesconto
			Endif

			// Verifica a data de entrega para as duplicatas?
			If ( dDataCnd > TMP1->CK_ENTREG .And. !Empty(TMP1->CK_ENTREG) )
				dDataCnd := TMP1->CK_ENTREG
			EndIf
			// Agrega os itens para a funcao fiscal
			MaFisAdd(TMP1->CK_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
				TMP1->CK_TES,;	   	// 2-Codigo do TES ( Opcional )
				TMP1->CK_QTDVEN,;  	// 3-Quantidade ( Obrigatorio )
				nPrcLista,;		  	// 4-Preco Unitario ( Obrigatorio )
				nDesconto,; 	// 5-Valor do Desconto ( Opcional )
				"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
				"",;				// 7-Serie da NF Original ( Devolucao/Benef )
				0,;					// 8-RecNo da NF Original no arq SD1/SD2
				0,;					// 9-Valor do Frete do Item ( Opcional )
				0,;					// 10-Valor da Despesa do item ( Opcional )
				0,;					// 11-Valor do Seguro do item ( Opcional )
				0,;					// 12-Valor do Frete Autonomo ( Opcional )
				nValMerc,;			// 13-Valor da Mercadoria ( Obrigatorio )
				0,;					// 14-Valor da Embalagem ( Opiconal )
				, , , , , , , , , , , , ,;
				TMP1->CK_CLASFIS) // 28-Classificacao fiscal)

			SB1->(dbSetOrder(1))
			If SB1->(MsSeek(cFilSB1 + TMP1->CK_PRODUTO))
				nQtdPeso := TMP1->CK_QTDVEN*SB1->B1_PESO
			Endif

			// Calculo do ISS
			If SA1->A1_INCISS == "N"
				If ( SF4->F4_ISS=="S" )
					nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
					nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
					MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
					MaFisAlt("IT_VALMERC",nValMerc,nItem)
				EndIf
			EndIf

			// Altera peso para calcular frete
			MaFisAlt("IT_PESO",nQtdPeso,nItem)
			MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
			MaFisAlt("IT_VALMERC",nValMerc,nItem)

			// Apuracao de tibutos - IPI e ICMS Solidario para niveis maiores que 1
			If M->CK_XNIVEL > "1"
				nTributos += (MaFisRet(nItem, "IT_VALIPI")+MaFisRet(nItem, "IT_VALSOL" )) /2
			EndIf

			// Analise da Rentabilidade
			If SF4->F4_DUPLIC=="S"
				nY := aScan(aRentab,{|x| x[1] == TMP1->CK_PRODUTO})
				If nY == 0
					aAdd(aRenTab,{TMP1->CK_PRODUTO,0,0,0,0,0})
					nY := Len(aRenTab)
				EndIf

				If cPaisLoc=="BRA"
					aRentab[nY][2] += (nValMerc - nDesconto)
				Else
					aRentab[nY][2] += nValMerc
				Endif
				aRentab[nY][3] += TMP1->CK_QTDVEN*SB2->B2_CM1
			EndIf
		
		EndIf
		dbSelectArea("TMP1")
		dbSkip()
	EndDo

	MaFisAlt("NF_FRETE",M->CJ_FRETE)
	MaFisAlt("NF_SEGURO",M->CJ_SEGURO)
	MaFisAlt("NF_AUTONOMO",M->CJ_FRETAUT)
	MaFisAlt("NF_DESPESA",M->CJ_DESPESA)
	MaFisAlt("NF_DESCONTO",MaFisRet(,"NF_DESCONTO")+MaFisRet(,"NF_VALMERC")*M->CJ_PDESCAB/100)
	MaFisAlt("NF_DESCONTO",MaFisRet(,"NF_DESCONTO")+SCJ->CJ_DESCONT)

	// Se nivel for maior que um, redefino base das duplicatas
	If M->CJ_XNIVEL > "1"
		MaFisAlt("NF_BASEDUP", nTributos + MaFisRet(,"NF_VALMERC") )
	EndIf
	MaFisWrite(1)

	// Verifica se o campo código do cliente e nível está em branco
	If Empty(M->CJ_XNIVEL) .Or. Empty(M->CJ_CLIENTE)
		Alert('ATENÇÃO: Selecione o cliente, não é possível calcular os valores financeiros!')
	EndIf 

	// Monta Valores planilha Financeira
	dbSelectarea("SE4")
	dbSetOrder(1)

	MsSeek(xFilial("SE4")+M->CJ_CONDPAG)

	If ((SE4->E4_TIPO=="9".AND.!(INCLUI.OR.ALTERA)).OR.SE4->E4_TIPO<>"9")
		If SE4->E4_TIPO=="9"
			cParc := "1"
			For nX := 1 To nNumParc
				If SCJ->(FieldPos("CJ_DATA"+cParc))<> 0 .And. SCJ->(FieldPos("CJ_PARC"+cParc))<> 0 .And. !Empty(SCJ->(FieldGet(FieldPos("CJ_PARC"+cParc))))
					aAdd(aDupl,{SCJ->(FieldGet(FieldPos("CJ_DATA"+cParc))),SCJ->(FieldGet(FieldPos("CJ_PARC"+cParc)))})
				EndIf
				cParc := Soma1(cParc)
			Next nX
		Else
			aDupl := Condicao(MaFisRet(,"NF_BASEDUP"),M->CJ_CONDPAG,MaFisRet(,"NF_VALIPI"),dDataCnd,MaFisRet(,"NF_VALSOL"),,,nAcresFin) 

			//Nivel 2 Se houver no pedido de venda
			If M->CJ_XNIVEL == "2"
				aDuplN2 := Condicao(MaFisRet(,"NF_VALMERC"),M->CJ_CONDPAG,0,dDataCnd,0,,,nAcresFin) 
			EndIf

		EndIf
				
		If Empty(aDupl)
			aDupl := {{Ctod(""),0}}
		EndIf

		aVencto := aClone(aDupl)
		For nX := 1 To Len(aDupl)
			aDupl[nX][2] := (aDupl[nX][2])
		Next nX
	else
		aDupl   := {{Ctod(""),MaFisRet(,"NF_BASEDUP") }}
		aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
	EndIf

	//Se orçamento for do tipo nível 2 os tabela de preço será 50% a menor e pagamentos os 50%
	If M->CJ_XNIVEL == "2"

		// Ajusto valor bruto de acordo com o nivel 2 atribuido
		MaFisAlt("NF_BASEDUP",(MaFisRet(01,"IT_VALIPI")+MaFisRet(01	,"IT_VALSOL" )) /2 + MaFisRet(,"NF_VALMERC") )

		aVencto := aClone(aDuplN2)
		For nX := 1 To Len(aDuplN2)
			Aadd( aDupl, { aDuplN2[nX][1], aDuplN2[Len(aDuplN2)][2] } )
		Next nX

	EndIf

	RestArea(aAreaCJ)
	RestArea(aArea)


	MaFisEnd()
	MaFisRestore()

	//Monta tela para exibir para usuário
	U_DULPORTEL(aDupl)

	RestArea(aAreaTMP1)
	RestArea(aArea)

	aRefRentab := aRentab

Return(.T.)
