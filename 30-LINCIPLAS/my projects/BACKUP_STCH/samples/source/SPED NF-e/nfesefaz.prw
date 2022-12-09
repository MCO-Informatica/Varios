#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³XmlNFeSef ³ Autor ³ Eduardo Riera         ³ Data ³13.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rdmake de exemplo para geracao da Nota Fiscal Eletronica do ³±±
±±³          ³SEFAZ - Versao T01.00                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³String da Nota Fiscal Eletronica                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tipo da NF                                           ³±±
±±³          ³       [0] Entrada                                          ³±±
±±³          ³       [1] Saida                                            ³±±
±±³          ³ExpC2: Serie da NF                                          ³±±
±±³          ³ExpC3: Numero da nota fiscal                                ³±±
±±³          ³ExpC4: Codigo do cliente ou fornecedor                      ³±±
±±³          ³ExpC5: Loja do cliente ou fornecedor                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function XmlNfeSef(cTipo,cSerie,cNota,cClieFor,cLoja)

Local nX        := 0

Local oWSNfe   

Local cString    := ""
Local cAliasSE1  := "SE1"
Local cAliasSD1  := "SD1"
Local cAliasSD2  := "SD2"
Local cNatOper   := ""
Local cModFrete  := ""
Local cScan      := ""
Local cEspecie   := ""
Local cMensCli   := ""
Local cMensFis   := ""
Local cNFe       := ""
Local cMV_LJTPNFE:= SuperGetMV("MV_LJTPNFE", ," ")

Local lQuery    := .F.

Local aNota     := {}
Local aDupl     := {}
Local aDest     := {}
Local aEntrega  := {}
Local aProd     := {}
Local aICMS     := {}
Local aICMSST   := {}
Local aIPI      := {}
Local aPIS      := {}
Local aCOFINS   := {}
Local aPISST    := {}
Local aCOFINSST := {}
Local aISSQN    := {}
Local aISS      := {}
Local aCST      := {}
Local aRetido   := {}
Local aTransp   := {}
Local aImp      := {}
Local aVeiculo  := {}
Local aReboque  := {}
Local aEspVol   := {}
Local aNfVinc   := {}
Local aPedido   := {}
Local aTotal    := {0,0}
Local aOldReg   := {}
Local aOldReg2  := {}

Private aUF     := {}

DEFAULT cTipo   := PARAMIXB[1]
DEFAULT cSerie  := PARAMIXB[3]
DEFAULT cNota   := PARAMIXB[4]
DEFAULT cClieFor:= PARAMIXB[5]
DEFAULT cLoja   := PARAMIXB[6]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})

If cTipo == "1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona NF                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(1)
	If MsSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)	
		aadd(aNota,SF2->F2_SERIE)
		aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+SF2->F2_DOC)
		aadd(aNota,SF2->F2_EMISSAO)
		aadd(aNota,cTipo)
		aadd(aNota,SF2->F2_TIPO)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona cliente ou fornecedor                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		If !SF2->F2_TIPO $ "DB" 
		    dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			
			aadd(aDest,AllTrim(SA1->A1_CGC))
			aadd(aDest,SA1->A1_NOME)
			aadd(aDest,FisGetEnd(SA1->A1_END)[1])
			aadd(aDest,ConvType(IIF(FisGetEnd(SA1->A1_END)[2]<>0,FisGetEnd(SA1->A1_END)[2],"SN")))
			aadd(aDest,FisGetEnd(SA1->A1_END)[4])
			aadd(aDest,SA1->A1_BAIRRO)
			If !Upper(SA1->A1_EST) == "EX"
				aadd(aDest,SA1->A1_COD_MUN)
				aadd(aDest,SA1->A1_MUN)				
			Else
				aadd(aDest,"99999")			
				aadd(aDest,"EXTERIOR")
			EndIf
			aadd(aDest,Upper(SA1->A1_EST))
			aadd(aDest,SA1->A1_CEP)
			aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
			aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
			aadd(aDest,SA1->A1_TEL)
			aadd(aDest,VldIE(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
			aadd(aDest,SA1->A1_SUFRAMA)
			aadd(aDest,SA1->A1_EMAIL)
			
			If SF2->(FieldPos("F2_CLIENT"))<>0 .And. !Empty(SF2->F2_CLIENT+SF2->F2_LOJENT) .And. SF2->F2_CLIENT+SF2->F2_LOJENT<>SF2->F2_CLIENTE+SF2->F2_LOJA
			    dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJENT)
				
				aadd(aEntrega,SA1->A1_CGC)
				aadd(aEntrega,FisGetEnd(SA1->A1_END)[1])
				aadd(aEntrega,ConvType(IIF(FisGetEnd(SA1->A1_END)[2]<>0,FisGetEnd(SA1->A1_END)[2],"SN")))
				aadd(aEntrega,FisGetEnd(SA1->A1_END)[4])
				aadd(aEntrega,SA1->A1_BAIRRO)
				aadd(aEntrega,SA1->A1_COD_MUN)
				aadd(aEntrega,SA1->A1_MUN)
				aadd(aEntrega,Upper(SA1->A1_EST))
				
			EndIf
					
		Else
		    dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)	
	
			aadd(aDest,AllTrim(SA2->A2_CGC))
			aadd(aDest,SA2->A2_NOME)
			aadd(aDest,FisGetEnd(SA2->A2_END)[1])
			aadd(aDest,ConvType(IIF(FisGetEnd(SA2->A2_END)[2]<>0,FisGetEnd(SA2->A2_END)[2],"SN")))
			aadd(aDest,FisGetEnd(SA2->A2_END)[4])
			aadd(aDest,SA2->A2_BAIRRO)
			aadd(aDest,SA2->A2_COD_MUN)
			aadd(aDest,SA2->A2_MUN)
			aadd(aDest,Upper(SA2->A2_EST))
			aadd(aDest,SA2->A2_CEP)
			aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
			aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
			aadd(aDest,SA2->A2_TEL)
			aadd(aDest,VldIE(SA2->A2_INSCR))
			aadd(aDest,"")//SA2->A2_SUFRAMA
			aadd(aDest,SA2->A2_EMAIL)
	
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona transportador                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SF2->F2_TRANSP)
			dbSelectArea("SA4")
			dbSetOrder(1)
			MsSeek(xFilial("SA4")+SF2->F2_TRANSP)
			
			aadd(aTransp,AllTrim(SA4->A4_CGC))
			aadd(aTransp,SA4->A4_NOME)
			aadd(aTransp,SA4->A4_INSEST)
			aadd(aTransp,SA4->A4_END)
			aadd(aTransp,SA4->A4_MUN)
			aadd(aTransp,Upper(SA4->A4_EST)	)
	
			If !Empty(SF2->F2_VEICUL1)
				dbSelectArea("DA3")
				dbSetOrder(1)
				MsSeek(xFilial("DA3")+SF2->F2_VEICUL1)
				
				aadd(aVeiculo,DA3->DA3_PLACA)
				aadd(aVeiculo,DA3->DA3_ESTPLA)
				aadd(aVeiculo,"")//RNTC
				
				If !Empty(SF2->F2_VEICUL2)
				
					dbSelectArea("DA3")
					dbSetOrder(1)
					MsSeek(xFilial("DA3")+SF2->F2_VEICUL2)
				
					aadd(aReboque,DA3->DA3_PLACA)
					aadd(aReboque,DA3->DA3_ESTPLA)
					aadd(aReboque,"") //RNTC
					
				EndIf					
			EndIf
		EndIf
		dbSelectArea("SF2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Volumes                                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cScan := "1"
		While ( !Empty(cScan) )
			cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
			If !Empty(cEspecie)
				nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
				If ( nScan==0 )
					aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
				Else
					aEspVol[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
				EndIf
			EndIf
			cScan := Soma1(cScan,1)
			If ( FieldPos("F2_ESPECI"+cScan) == 0 )
				cScan := ""
			EndIf
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Procura duplicatas                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SF2->F2_DUPL)	
			dbSelectArea("SE1")
			dbSetOrder(1)	
			#IFDEF TOP
				lQuery  := .T.
				cAliasSE1 := GetNextAlias()
				BeginSql Alias cAliasSE1
					COLUMN E1_VENCORI AS DATE
					SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCORI,E1_VALOR,E1_ORIGEM
					FROM %Table:SE1% SE1
					WHERE
					SE1.E1_FILIAL = %xFilial:SE1% AND
					SE1.E1_PREFIXO = %Exp:SF2->F2_PREFIXO% AND 
					SE1.E1_NUM = %Exp:SF2->F2_DUPL% AND 
					(SE1.E1_TIPO = %Exp:MVNOTAFIS% OR
					 SE1.E1_ORIGEM = 'LOJA701' AND SE1.E1_TIPO LIKE %Exp:cMV_LJTPNFE%) AND					
					SE1.%NotDel%
					ORDER BY %Order:SE1%
				EndSql
				
			#ELSE
				MsSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC)
			#ENDIF
			While !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
				SF2->F2_PREFIXO == (cAliasSE1)->E1_PREFIXO .And.;
				SF2->F2_DOC == (cAliasSE1)->E1_NUM
				If 	(cAliasSE1)->E1_TIPO = MVNOTAFIS .OR. ((cAliasSE1)->E1_ORIGEM = 'LOJA701' .AND. (cAliasSE1)->E1_TIPO $ cMV_LJTPNFE)
				
					aadd(aDupl,{(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_VENCORI,(cAliasSE1)->E1_VALOR})
				
				EndIf
				dbSelectArea(cAliasSE1)
				dbSkip()
		    EndDo
		    If lQuery
		    	dbSelectArea(cAliasSE1)
		    	dbCloseArea()
		    	dbSelectArea("SE1")
		    EndIf
		Else
			aDupl := {}
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisa os impostos de retencao                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF2->(FieldPos("F2_VALPIS"))<>0 .and. SF2->F2_VALPIS>0
		aadd(aRetido,{"PIS",0,SF2->F2_VALPIS})
	EndIf
	If SF2->(FieldPos("F2_VALCOFI"))<>0 .and. SF2->F2_VALCOFI>0
		aadd(aRetido,{"COFINS",0,SF2->F2_VALCOFI})
	EndIf
	If SF2->(FieldPos("F2_VALCSLL"))<>0 .and. SF2->F2_VALCSLL>0
		aadd(aRetido,{"CSLL",0,SF2->F2_VALCSLL})
	EndIf
	If SF2->(FieldPos("F2_VALIRRF"))<>0 .and. SF2->F2_VALIRRF>0
		aadd(aRetido,{"IRRF",0,SF2->F2_VALIRRF})
	EndIf	
	If SF2->(FieldPos("F2_BASEINS"))<>0 .and. SF2->F2_BASEINS>0
		aadd(aRetido,{"INSS",SF2->F2_BASEINS,SF2->F2_VALINSS})
	EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa itens de nota                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		dbSelectArea("SD2")
		dbSetOrder(3)	
		#IFDEF TOP
			lQuery  := .T.
			cAliasSD2 := GetNextAlias()
			BeginSql Alias cAliasSD2
				SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
					D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_DESCON,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT,D2_VALISS,D2_PRUNIT,D2_CLASFIS,D2_PRCVEN
				FROM %Table:SD2% SD2
				WHERE
				SD2.D2_FILIAL = %xFilial:SD2% AND
				SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND 
				SD2.D2_DOC = %Exp:SF2->F2_DOC% AND 
				SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND 
				SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND 
				SD2.%NotDel%
				ORDER BY %Order:SD2%
			EndSql
				
		#ELSE
			MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		#ENDIF
		While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
			SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
			SF2->F2_DOC == (cAliasSD2)->D2_DOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a natureza da operacao                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SF4")
			dbSetOrder(1)
			MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)				
			If Empty(cNatOper)
				cNatOper := SF4->F4_TEXTO
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica as notas vinculadas                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty((cAliasSD2)->D2_NFORI) 
				If (cAliasSD2)->D2_TIPO $ "DB"
					dbSelectArea("SD1")
					dbSetOrder(1)
					If MsSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF1")
						dbSetOrder(1)
						MsSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
						If SD1->D1_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
						EndIf
						
						aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SF1->F1_EST,SF1->F1_ESPECIE})
					EndIf
				Else
					aOldReg  := SD2->(GetArea())
					aOldReg2 := SF2->(GetArea())
					dbSelectArea("SD2")
					dbSetOrder(3)
					If MsSeek(xFilial("SD2")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF2")
						dbSetOrder(1)
						MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						If !SD2->D2_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							MsSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						EndIf
						
						aadd(aNfVinc,{SF2->F2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
					EndIf
					RestArea(aOldReg)
					RestArea(aOldReg2)
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Obtem os dados do produto                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
			
			dbSelectArea("SB5")
			dbSetOrder(1)
			MsSeek(xFilial("SB5")+(cAliasSD2)->D2_COD)
			
			dbSelectArea("SC5")
			dbSetOrder(1)
			MsSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV+(cAliasSD2)->D2_COD)
			
			If !AllTrim(SC5->C5_MENNOTA) $ cMensCli
				cMensCli += AllTrim(SC5->C5_MENNOTA)
			EndIf
			If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
				cMensFis += AllTrim(FORMULA(SC5->C5_MENPAD))
			EndIf
						
			cModFrete := IIF(SC5->C5_TPFRETE=="C","0","1")
			
			If Empty(aPedido)
				aPedido := {"",AllTrim(SC6->C6_PEDCLI),""}
			EndIf
						
			aadd(aProd,	{Len(aProd)+1,;
							(cAliasSD2)->D2_COD,;
							IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
							IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),;
							SB1->B1_POSIPI,;
							SB1->B1_EX_NCM,;
							(cAliasSD2)->D2_CF,;
							SB1->B1_UM,;
							(cAliasSD2)->D2_QUANT,;
							IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON,0),;
							IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
							IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD2)->D2_QUANT,SB5->B5_CONVDIPI*(cAliasSD2)->D2_QUANT),;
							(cAliasSD2)->D2_VALFRE,;
							(cAliasSD2)->D2_SEGURO,;
							(cAliasSD2)->D2_DESCON,;
							IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN+(cAliasSD2)->D2_DESCON,0),;
							IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; //codigo ANP do combustivel
							IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,"")}) //CODIF
			aadd(aCST,{IIF(!Empty((cAliasSD2)->D2_CLASFIS),SubStr((cAliasSD2)->D2_CLASFIS,2,2),'50')})
			aadd(aICMS,{})
			aadd(aIPI,{})
			aadd(aICMSST,{})
			aadd(aPIS,{})
			aadd(aPISST,{})
			aadd(aCOFINS,{})
			aadd(aCOFINSST,{})
			aadd(aISSQN,{})
						
			dbSelectArea("CD2")
			If !(cAliasSD2)->D2_TIPO $ "DB"
				dbSetOrder(1)
			Else
				dbSetOrder(2)
			EndIf
			If !MsSeek(xFilial("CD2")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+PadR((cAliasSD2)->D2_ITEM,4)+(cAliasSD2)->D2_COD)

			EndIf
			While !Eof() .And. xFilial("CD2") == CD2->CD2_FILIAL .And.;
				"S" == CD2->CD2_TPMOV .And.;
				SF2->F2_SERIE == CD2->CD2_SERIE .And.;
				SF2->F2_DOC == CD2->CD2_DOC .And.;
				SF2->F2_CLIENTE == IIF(!(cAliasSD2)->D2_TIPO $ "DB",CD2->CD2_CODCLI,CD2->CD2_CODFOR) .And.;
				SF2->F2_LOJA == IIF(!(cAliasSD2)->D2_TIPO $ "DB",CD2->CD2_LOJCLI,CD2->CD2_LOJFOR) .And.;
				(cAliasSD2)->D2_ITEM == SubStr(CD2->CD2_ITEM,1,Len((cAliasSD2)->D2_ITEM)) .And.;
				(cAliasSD2)->D2_COD == CD2->CD2_CODPRO
				
				Do Case
					Case AllTrim(CD2->CD2_IMP) == "ICM"
						aTail(aICMS) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,0,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "SOL"
						aTail(aICMSST) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MVA,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "IPI"
						aTail(aIPI) := {"","",0,"999",CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_QTRIB,CD2->CD2_PAUTA,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MODBC,CD2->CD2_PREDBC}
					Case AllTrim(CD2->CD2_IMP) == "PS2"
						If (cAliasSD2)->D2_VALISS==0
							aTail(aPIS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Else
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[04]          += CD2->CD2_VLTRIB	
						EndIf
					Case AllTrim(CD2->CD2_IMP) == "CF2"
						If (cAliasSD2)->D2_VALISS==0
							aTail(aCOFINS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Else
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[05] += CD2->CD2_VLTRIB	
						EndIf
					Case AllTrim(CD2->CD2_IMP) == "PS3" .And. (cAliasSD2)->D2_VALISS==0
						aTail(aPISST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "CF3" .And. (cAliasSD2)->D2_VALISS==0
						aTail(aCOFINSST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case CD2->CD2_IMP == "ISS"
						If Empty(aISS)
							aISS := {0,0,0,0,0}
						EndIf
						aISS[01] += (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON
						aISS[02] += CD2->CD2_BC
						aISS[03] += CD2->CD2_VLTRIB	
						aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,"",SD2->D2_CODISS}
				EndCase
				
				dbSelectArea("CD2")
				dbSkip()
			EndDo
			aTotal[01] += (cAliasSD2)->D2_DESPESA
			aTotal[02] += (cAliasSD2)->D2_VALBRUT	
									
			dbSelectArea(cAliasSD2)
			dbSkip()
	    EndDo	
	    If lQuery
	    	dbSelectArea(cAliasSD2)
	    	dbCloseArea()
	    	dbSelectArea("SD2")
	    EndIf
	EndIf
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
	
		aadd(aNota,SF1->F1_SERIE)
		aadd(aNota,IIF(Len(SF1->F1_DOC)==6,"000","")+SF1->F1_DOC)
		aadd(aNota,SF1->F1_EMISSAO)
		aadd(aNota,cTipo)
		aadd(aNota,SF1->F1_TIPO)
		
		If SF1->F1_TIPO $ "DB" 
		    dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+cClieFor+cLoja)
			
			aadd(aDest,AllTrim(SA1->A1_CGC))
			aadd(aDest,SA1->A1_NOME)
			aadd(aDest,FisGetEnd(SA1->A1_END)[1])
			aadd(aDest,ConvType(IIF(FisGetEnd(SA1->A1_END)[2]<>0,FisGetEnd(SA1->A1_END)[2],FisGetEnd(SA1->A1_END)[3])))
			aadd(aDest,FisGetEnd(SA1->A1_END)[4])
			aadd(aDest,SA1->A1_BAIRRO)
			aadd(aDest,SA1->A1_COD_MUN)
			aadd(aDest,SA1->A1_MUN)
			aadd(aDest,Upper(SA1->A1_EST))
			aadd(aDest,SA1->A1_CEP)
			aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
			aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
			aadd(aDest,SA1->A1_TEL)
			aadd(aDest,VldIE(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
			aadd(aDest,SA1->A1_SUFRAMA)
			aadd(aDest,SA1->A1_EMAIL)
								
		Else
		    dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+cClieFor+cLoja)
	
			aadd(aDest,AllTrim(SA2->A2_CGC))
			aadd(aDest,SA2->A2_NOME)
			aadd(aDest,FisGetEnd(SA2->A2_END)[1])
			aadd(aDest,ConvType(IIF(FisGetEnd(SA2->A2_END)[2]<>0,FisGetEnd(SA2->A2_END)[2],FisGetEnd(SA2->A2_END)[3])))
			aadd(aDest,FisGetEnd(SA2->A2_END)[4])
			aadd(aDest,SA2->A2_BAIRRO)
			aadd(aDest,SA2->A2_COD_MUN)
			aadd(aDest,SA2->A2_MUN)
			aadd(aDest,Upper(SA2->A2_EST))
			aadd(aDest,SA2->A2_CEP)
			aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
			aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
			aadd(aDest,SA2->A2_TEL)
			aadd(aDest,VldIE(SA2->A2_INSCR))
			aadd(aDest,"")//SA2->A2_SUFRAMA
			aadd(aDest,SA2->A2_EMAIL)
	
		EndIf
				
		If SF1->F1_TIPO $ "DB" 
		    dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)	
		Else
		    dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)	
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisa os impostos de retencao                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF1->(FieldPos("F1_VALPIS"))<>0 .And. SF1->F1_VALPIS>0
			aadd(aRetido,{"PIS",0,SF1->F1_VALPIS})
		EndIf
		If SF1->(FieldPos("F1_VALCOFI"))<>0 .And. SF1->F1_VALCOFI>0
			aadd(aRetido,{"COFINS",0,SF1->F1_VALCOFI})
		EndIf
		If SF1->(FieldPos("F1_VALCSLL"))<>0 .And. SF1->F1_VALCSLL>0
			aadd(aRetido,{"CSLL",0,SF1->F1_VALCSLL})
		EndIf
		If SF1->(FieldPos("F1_IRRF"))<>0 .And. SF1->F1_IRRF>0
			aadd(aRetido,{"IRRF",0,SF1->F1_IRRF})
		EndIf	
	If SF1->(FieldPos("F1_INSS"))<>0 .and. SF1->F1_INSS>0
			aadd(aRetido,{"INSS",SF1->F1_BASEINS,SF1->F1_INSS})
		EndIf
		dbSelectArea("SD1")
		dbSetOrder(1)	
		#IFDEF TOP
			lQuery  := .T.
			cAliasSD1 := GetNextAlias()
			BeginSql Alias cAliasSD1
				SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM,D1_TES,D1_TIPO,
						D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_CF,D1_QUANT,D1_TOTAL,D1_VALDESC,D1_VALFRE,
						D1_SEGURO,D1_DESPESA,D1_CODISS,D1_VALISS,D1_VALIPI,D1_ICMSRET,D1_VUNIT,D1_CLASFIS,
						D1_VALICM
				FROM %Table:SD1% SD1
				WHERE
				SD1.D1_FILIAL = %xFilial:SD1% AND
				SD1.D1_SERIE = %Exp:SF1->F1_SERIE% AND 
				SD1.D1_DOC = %Exp:SF1->F1_DOC% AND 
				SD1.D1_FORNECE = %Exp:SF1->F1_FORNECE% AND 
				SD1.D1_LOJA = %Exp:SF1->F1_LOJA% AND 
				SD1.D1_FORMUL = 'S' AND 
				SD1.%NotDel%
				ORDER BY %Order:SD1%
			EndSql
				
		#ELSE
			MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		#ENDIF
		While !Eof() .And. xFilial("SD1") == (cAliasSD1)->D1_FILIAL .And.;
			SF1->F1_SERIE == (cAliasSD1)->D1_SERIE .And.;
			SF1->F1_DOC == (cAliasSD1)->D1_DOC .And.;
			SF1->F1_FORNECE == (cAliasSD1)->D1_FORNECE .And.;
			SF1->F1_LOJA ==  (cAliasSD1)->D1_LOJA
			

			dbSelectArea("SF4")
			dbSetOrder(1)
			MsSeek(xFilial("SF4")+(cAliasSD1)->D1_TES)
			If Empty(cNatOper)
				cNatOper := SF4->F4_TEXTO					
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica as notas vinculadas                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If !Empty((cAliasSD1)->D1_NFORI) 
				If !(cAliasSD1)->D1_TIPO $ "DB"
					aOldReg  := SD1->(GetArea())
					aOldReg2 := SF1->(GetArea())
					dbSelectArea("SD1")
					dbSetOrder(1)
					If MsSeek(xFilial("SD1")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
						dbSelectArea("SF1")
						dbSetOrder(1)
						MsSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
						If SD1->D1_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
						EndIf
						
						aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SF1->F1_EST,SF1->F1_ESPECIE})
					EndIf
					RestArea(aOldReg)
					RestArea(aOldReg2)
				Else					
					dbSelectArea("SD2")
					dbSetOrder(3)
					If MsSeek(xFilial("SD2")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
						dbSelectArea("SF2")
						dbSetOrder(1)
						MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						If !SD2->D2_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							MsSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						EndIf
						
						aadd(aNfVinc,{SD2->D2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
						
					EndIf
				EndIf
			
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Obtem os dados do produto                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+(cAliasSD1)->D1_COD)
			
			dbSelectArea("SB5")
			dbSetOrder(1)
			MsSeek(xFilial("SB5")+(cAliasSD1)->D1_COD)
								
			cModFrete := IIF(SF1->F1_FRETE>0,"0","1")
						
			aadd(aProd,	{Len(aProd)+1,;
							(cAliasSD1)->D1_COD,;
							IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
							SB1->B1_DESC,;
							SB1->B1_POSIPI,;
							SB1->B1_EX_NCM,;
							(cAliasSD1)->D1_CF,;
							SB1->B1_UM,;
							(cAliasSD1)->D1_QUANT,;
							IIF(!(cAliasSD1)->D1_TIPO$"IP",(cAliasSD1)->D1_TOTAL+(cAliasSD1)->D1_VALDESC,0),;
							IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
							IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD1)->D1_QUANT,SB5->B5_CONVDIPI*(cAliasSD1)->D1_QUANT),;
							(cAliasSD1)->D1_VALFRE,;
							(cAliasSD1)->D1_SEGURO,;
							(cAliasSD1)->D1_VALDESC,;
							IIF(!(cAliasSD1)->D1_TIPO$"IP",(cAliasSD1)->D1_VUNIT,0),;
							IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; //codigo ANP do combustivel
							IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,"")}) //CODIF
			aadd(aCST,{IIF(!Empty((cAliasSD1)->D1_CLASFIS),SubStr((cAliasSD1)->D1_CLASFIS,2,2),'50')})
			aadd(aICMS,{})
			aadd(aIPI,{})
			aadd(aICMSST,{})
			aadd(aPIS,{})
			aadd(aPISST,{})
			aadd(aCOFINS,{})
			aadd(aCOFINSST,{})
			aadd(aISSQN,{})
			
			dbSelectArea("CD2")
			If !(cAliasSD1)->D1_TIPO $ "DB"			
				dbSetOrder(2)
			Else
				dbSetOrder(1)
			EndIf
			MsSeek(xFilial("CD2")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+PadR((cAliasSD1)->D1_ITEM,4)+(cAliasSD1)->D1_COD)
			While !Eof() .And. xFilial("CD2") == CD2->CD2_FILIAL .And.;
				"E" == CD2->CD2_TPMOV .And.;
				SF1->F1_SERIE == CD2->CD2_SERIE .And.;
				SF1->F1_DOC == CD2->CD2_DOC .And.;
				SF1->F1_FORNECE == IIF(!(cAliasSD1)->D1_TIPO $ "DB",CD2->CD2_CODFOR,CD2->CD2_CODCLI) .And.;
				SF1->F1_LOJA == IIF(!(cAliasSD1)->D1_TIPO $ "DB",CD2->CD2_LOJFOR,CD2->CD2_LOJCLI) .And.;				
				(cAliasSD1)->D1_ITEM == SubStr(CD2->CD2_ITEM,1,Len((cAliasSD1)->D1_ITEM)) .And.;
				(cAliasSD1)->D1_COD == CD2->CD2_CODPRO
				
				Do Case
					Case AllTrim(CD2->CD2_IMP) == "ICM"
						aTail(aICMS) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,0,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "SOL"
						aTail(aICMSST) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MVA,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "IPI"
						aTail(aIPI) := {"","",0,"999",CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_QTRIB,CD2->CD2_PAUTA,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MODBC,CD2->CD2_PREDBC}
					Case CD2->CD2_IMP == "ISS"
						If Empty(aISS)
							aISS := {0,0,0,0,0}
						EndIf
						aISS[01] += (cAliasSD1)->D1_TOTAL
						aISS[02] += CD2->CD2_BC
						aISS[03] += CD2->CD2_VLTRIB					
					Case AllTrim(CD2->CD2_IMP) == "PS2"
						If (cAliasSD1)->D1_VALISS==0
							aTail(aPIS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Else
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[04]          += CD2->CD2_VLTRIB	
						EndIf
					Case AllTrim(CD2->CD2_IMP) == "CF2"
						If (cAliasSD1)->D1_VALISS==0
							aTail(aCOFINS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Else
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[05] += CD2->CD2_VLTRIB	
						EndIf
					Case AllTrim(CD2->CD2_IMP) == "PS3" .And. (cAliasSD1)->D1_VALISS==0
						aTail(aPISST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "CF3" .And. (cAliasSD1)->D1_VALISS==0
						aTail(aCOFINSST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case CD2->CD2_IMP == "ISS"
						If Empty(aISS)
							aISS := {0,0,0,0,0}
						EndIf
						aISS[01] += (cAliasSD1)->D1_TOTAL
						aISS[02] += CD2->CD2_BC
						aISS[03] += CD2->CD2_VLTRIB	
						aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,"",SD1->D1_CODISS}
				EndCase
				
				dbSelectArea("CD2")
				dbSkip()
			EndDo
			aTotal[01] += (cAliasSD1)->D1_DESPESA
			aTotal[02] += (cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC+(cAliasSD1)->D1_VALFRE+(cAliasSD1)->D1_SEGURO+(cAliasSD1)->D1_DESPESA+(cAliasSD1)->D1_VALIPI+(cAliasSD1)->D1_ICMSRET;
						   +IIF(SF4->F4_AGREG$"I",(cAliasSD1)->D1_VALICM,0)			
			dbSelectArea(cAliasSD1)
			dbSkip()
	    EndDo	
	    If lQuery
	    	dbSelectArea(cAliasSD1)
	    	dbCloseArea()
	    	dbSelectArea("SD1")
	    EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Geracao do arquivo XML                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aNota)
	cString := ""
	cString += NfeIde(@cNFe,aNota,cNatOper,aDupl,aNfVinc)
	cString += NfeEmit()
	cString += NfeDest(aDest)
	cString += NfeLocalEntrega(aEntrega)
	For nX := 1 To Len(aProd)
		cString += NfeItem(aProd[nX],aICMS[nX],aICMSST[nX],aIPI[nX],aPIS[nX],aPISST[nX],aCOFINS[nX],aCOFINSST[nX],aISSQN[nX],aCST[nX])
	Next nX
	cString += NfeTotal(aTotal,aRetido)
	cString += NfeTransp(cModFrete,aTransp,aImp,aVeiculo,aReboque,aEspVol)
	cString += NfeCob(aDupl)
	cString += NfeInfAd(cMensCli,cMensFis,aPedido)
	cString += "</infNFe>"
EndIf	
Return({cNfe,EncodeUTF8(cString)})


Static Function NfeIde(cChave,aNota,cNatOper,aDupl,aNfVinc)

Local cString:= ""
Local cNFVinc:= ""
Local lAvista:= Len(aDupl)==1 .And. aDupl[01][02]<=DataValida(aNota[03]+1,.T.)
Local nX     := 0

cChave := aUF[aScan(aUF,{|x| x[1] == SM0->M0_ESTCOB})][02]+FsDateConv(aNota[03],"YYMM")+SM0->M0_CGC+"55"+StrZero(Val(aNota[01]),3)+StrZero(Val(aNota[02]),9)+Inverte(StrZero(Val(aNota[02]),9))

cString += '<infNFe versao="T01.00">'
cString += '<ide>'
cString += '<cUF>'+ConvType(aUF[aScan(aUF,{|x| x[1] == SM0->M0_ESTCOB})][02],02)+'</cUF>'
cString += '<cNF>'+ConvType(Inverte(StrZero(Val(aNota[02]),Len(aNota[02]))),09)+'</cNF>'
cString += '<natOp>'+ConvType(cNatOper)+'</natOp>'
cString += '<indPag>'+IIF(lAVista,"0",IIf(Len(aDupl)==0,"2","1"))+'</indPag>'
cString += '<serie>'+ConvType(Val(aNota[01]),3)+'</serie>'
cString += '<nNF>'+ConvType(Val(aNota[02]),9)+'</nNF>'
cString += '<dEmi>'+ConvType(aNota[03])+'</dEmi>
cString += NfeTag('<dSaiEnt>',ConvType(aNota[03]))
cString += '<tpNF>'+aNota[04]+'</tpNF>'
If !Empty(aNfVinc)
	cString += '<NFRef>'
	For nX := 1 To Len(aNfVinc)
		If !(ConvType(aUF[aScan(aUF,{|x| x[1] == aNfVinc[nX][05]})][02],02)+;
				FsDateConv(aNfVinc[nX][01],"YYMM")+;
				aNfVinc[nX][04]+;
				AModNot(aNfVinc[nX][06])+;
				ConvType(Val(aNfVinc[nX][02]),3)+;
				ConvType(Val(aNfVinc[nX][03]),9) $ cNFVinc )
			cString += '<RefNF>'
			cString += '<cUF>'+ConvType(aUF[aScan(aUF,{|x| x[1] == aNfVinc[nX][05]})][02],02)+'</cUF>'
			cString += '<AAMM>'+FsDateConv(aNfVinc[nX][01],"YYMM")+'</AAMM>'
			cString += '<CNPJ>'+aNfVinc[nX][04]+'</CNPJ>'
			cString += '<mod>'+AModNot(aNfVinc[nX][06])+'</mod>'
			cString += '<serie>'+ConvType(Val(aNfVinc[nX][02]),3)+'</serie>'
			cString += '<nNF>'+ConvType(Val(aNfVinc[nX][03]),9)+'</nNF>'
			cString += '<cNF>'+Inverte(StrZero(Val(aNfVinc[nX][03]),9))+'</cNF>'
			cString += '</RefNF>'
	
			cNFVinc += ConvType(aUF[aScan(aUF,{|x| x[1] == aNfVinc[nX][05]})][02],02)+;
				FsDateConv(aNfVinc[nX][01],"YYMM")+;
				aNfVinc[nX][04]+;
				AModNot(aNfVinc[nX][06])+;
				ConvType(Val(aNfVinc[nX][02]),3)+;
				ConvType(Val(aNfVinc[nX][03]),9)
		EndIf						
	Next nX
	cString += '</NFRef>'
EndIf
cString += '<tpNFe>'+IIF(aNota[05]$"CPI","2","1")+'</tpNFe>'
cString += '</ide>'

Return( cString )

Static Function NfeEmit()

Local cString:= ""

cString := '<emit>'
cString += '<CNPJ>'+SM0->M0_CGC+'</CNPJ>
cString += '<Nome>'+ConvType(SM0->M0_NOMECOM)+'</Nome>'
cString += NfeTag('<Fant>',ConvType(SM0->M0_NOME))
cString += '<enderEmit>'
cString += '<Lgr>'+ConvType(FisGetEnd(SM0->M0_ENDCOB)[1])+'</Lgr>'
cString += '<nro>'+ConvType(IIF(FisGetEnd(SM0->M0_ENDCOB)[2]<>0,FisGetEnd(SM0->M0_ENDCOB)[2],"SN"))+'</nro>'
cString += NfeTag('<Cpl>',ConvType(FisGetEnd(SM0->M0_ENDCOB)[4]))
cString += '<Bairro>'+ConvType(SM0->M0_BAIRCOB)+'</Bairro>'
cString += '<cMun>'+ConvType(SM0->M0_CODMUN)+'</cMun>'
cString += '<Mun>'+ConvType(SM0->M0_CIDCOB)+'</Mun>'
cString += '<UF>'+ConvType(SM0->M0_ESTCOB)+'</UF>'
cString += NfeTag('<CEP>',ConvType(SM0->M0_CEPCOB))
cString += NfeTag('<cPais>',"1058")
cString += NfeTag('<Pais>',"BRASIL")
cString += NfeTag('<fone>',ConvType(FisGetTel(SM0->M0_TEL)[3],18))
cString += '</enderEmit>'
cString += '<IE>'+ConvType(VldIE(SM0->M0_INSC))+'</IE>'
cString += NfeTag('<IEST>',"")
cString += NfeTag('<IM>',SM0->M0_INSCM)
cString += NfeTag('<CNAE>',ConvType(SM0->M0_CNAE))
cString += '</emit>'
Return(cString)

Static Function NfeDest(aDest)

Local cString:= ""

cString := '<dest>'
If Len(AllTrim(aDest[01]))==14
	cString += '<CNPJ>'+AllTrim(aDest[01])+'</CNPJ>'
ElseIf Len(AllTrim(aDest[01]))<>0
	cString += '<CPF>' +AllTrim(aDest[01])+'</CPF>'
Else
	cString += '<CNPJ></CNPJ>'
EndIf
cString += '<Nome>'+ConvType(aDest[02])+'</Nome>'
cString += '<enderDest>'
cString += '<Lgr>'+ConvType(aDest[03])+'</Lgr>'
cString += '<nro>'+ConvType(aDest[04])+'</nro>'
cString += NfeTag('<Cpl>',ConvType(aDest[05]))
cString += '<Bairro>'+ConvType(aDest[06])+'</Bairro>'
cString += '<cMun>'+ConvType(aUF[aScan(aUF,{|x| x[1] == aDest[09]})][02]+aDest[07])+'</cMun>'
cString += '<Mun>'+ConvType(aDest[08])+'</Mun>'
cString += '<UF>'+ConvType(aDest[09])+'</UF>'
cString += NfeTag('<CEP>',aDest[10])
cString += NfeTag('<cPais>',aDest[11])
cString += NfeTag('<Pais>',aDest[12])
cString += NfeTag('<fone>',ConvType(FisGetTel(aDest[13])[3],18))
cString += '</enderDest>'
cString += '<IE>'+ConvType(aDest[14])+'</IE>'
cString += NfeTag('<ISUF>',aDest[15])
cString += NfeTag('<EMAIL>',aDest[16])
cString += '</dest>'
Return(cString)

Static Function NfeLocalEntrega(aEntrega)

Local cString:= ""

If !Empty(aEntrega) .And. Len(AllTrim(aEntrega[01]))==14
	cString := '<entrega>'
	cString += '<CNPJ>'+AllTrim(aEntrega[01])+'</CNPJ>'
	cString += '<Lgr>'+ConvType(aEntrega[02])+'</Lgr>'
	cString += '<nro>'+ConvType(aEntrega[03])+'</nro>'
	cString += NfeTag('<Cpl>',ConvType(aEntrega[04]))
	cString += '<Bairro>'+ConvType(aEntrega[05])+'</Bairro>'
	cString += '<cMun>'+ConvType(aUF[aScan(aUF,{|x| x[1] == aEntrega[08]})][02]+aEntrega[06])+'</cMun>'
	cString += '<Mun>'+ConvType(aEntrega[07])+'</Mun>'
	cString += '<UF>'+ConvType(aEntrega[08])+'</UF>'
	cString += '</entrega>'
EndIf
Return(cString)

Static Function NfeItem(aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aCST)

Local cString    := ""
DEFAULT aICMS    := {}
DEFAULT aICMSST  := {}
DEFAULT aIPI     := {}
DEFAULT aPIS     := {}
DEFAULT aPISST   := {}
DEFAULT aCOFINS  := {}
DEFAULT aCOFINSST:= {}
DEFAULT aISSQN   := {}

cString += '<det nItem="'+ConvType(aProd[01])+'">'
cString += '<prod>'
cString += '<cProd>'+ConvType(aProd[02])+'</cProd>'
cString += '<ean>'+ConvType(aProd[03])+'</ean>'
cString += '<Prod>'+ConvType(aProd[04],120)+'</Prod>'
cString += NfeTag('<NCM>',ConvType(aProd[05]))
cString += NfeTag('<EXTIPI>',ConvType(aProd[06]))
cString += '<CFOP>'+ConvType(aProd[07])+'</CFOP>'
cString += '<uCom>'+ConvType(aProd[08])+'</uCom>'
cString += '<qCom>'+ConvType(aProd[09],12,4)+'</qCom>'
cString += '<vUnCom>'+ConvType(aProd[16],16,4)+'</vUnCom>'
cString += '<vProd>' +ConvType(aProd[10],15,2)+'</vProd>'
cString += '<eantrib>'+ConvType(aProd[03])+'</eantrib>'
cString += '<uTrib>'+ConvType(aProd[11])+'</uTrib>'
cString += '<qTrib>'+ConvType(aProd[12],12,4)+'</qTrib>'
cString += '<vUnTrib>'+ConvType(aProd[10]/aProd[12],16,4)+'</vUnTrib>'
cString += NfeTag('<vFrete>',ConvType(aProd[13],15,2))
cString += NfeTag('<vSeg>'  ,ConvType(aProd[14],15,2))
cString += NfeTag('<vDesc>' ,ConvType(aProd[15],15,2))
//Ver II - Average
If !Empty(aProd[17])
	cString += '<comb>'	
	cString += NfeTag('<cprodanp>',ConvType(aProd[17]))
	cString += NfeTag('<codif>',ConvType(aProd[18]))
	cString += '</comb>'                            
	//Tratamento da CIDE - Ver com a Average
	//Tratamento de ICMS-ST - Ver com fisco
EndIf
cString += '</prod>'
cString += '<imposto>'
cString += '<codigo>ICMS</codigo>'
If Len(aIcms)>0	
	cString += '<cpl>'
	cString += '<orig>'+ConvType(aICMS[01])+'</orig>'
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(aICMS[02])+'</CST>'	
	cString += '<modBC>'+ConvType(aICMS[03])+'</modBC>'
	cString += '<pRedBC>'+ConvType(aICMS[04],5,2)+'</pRedBC>'
	cString += '<vBC>'+ConvType(aICMS[05],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aICMS[06],5,2)+'</aliquota>'
	cString += '<valor>'+ConvType(aICMS[07],15,2)+'</valor>'
	cString += '<qtrib>'+ConvType(aICMS[09],16,4)+'</qtrib>'
	cString += '<vltrib>'+ConvType(aICMS[10],15,4)+'</vltrib>'
	cString += '</Tributo>'
Else
	cString += '<cpl>'
	cString += '<orig>0</orig>'
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(aCST[01])+'</CST>'	
	cString += '<modBC>'+ConvType(3)+'</modBC>'
	cString += '<pRedBC>'+ConvType(0,5,2)+'</pRedBC>'
	cString += '<vBC>'+ConvType(0,15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(0,5,2)+'</aliquota>'
	cString += '<valor>'+ConvType(0,15,2)+'</valor>'
	cString += '<qtrib>'+ConvType(0,16,4)+'</qtrib>'
	cString += '<vltrib>'+ConvType(0,15,4)+'</vltrib>'
	cString += '</Tributo>'
EndIf
cString += '</imposto>'
If Len(aIcmsST)>0	
	Do Case
		Case aICMSST[03] == "0"
			aICMSST[03] := "4"
		Case aICMSST[03] == "1"
			aICMSST[03] := "5"
		OtherWise
			aICMSST[03] := "0"
	EndCase
	cString += '<imposto>'
	cString += '<codigo>ICMSST</codigo>'
	cString += '<cpl>'
	cString += '<pmvast>'+ConvType(aICMSST[08],5,2)+'</pmvast>'
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(aICMSST[02])+'</CST>'	
	cString += '<modBC>'+ConvType(aICMSST[03])+'</modBC>'
	cString += '<pRedBC>'+ConvType(aICMSST[04],5,2)+'</pRedBC>'
	cString += '<vBC>'+ConvType(aICMSST[05],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aICMSST[06],5,2)+'</aliquota>'
	cString += '<valor>'+ConvType(aICMSST[07],15,2)+'</valor>'
	cString += '<qtrib>'+ConvType(aICMSST[09],16,4)+'</qtrib>'
	cString += '<vltrib>'+ConvType(aICMSST[10],15,4)+'</vltrib>'
	cString += '</Tributo>'
	cString += '</imposto>'
ELse
	cString += '<imposto>'
	cString += '<codigo>ICMSST</codigo>'
	cString += '<cpl>'
	cString += '<pmvast>0</pmvast>'
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(aCST[01])+'</CST>'          
	cString += '<modBC>0</modBC>'
	cString += '<pRedBC>'+ConvType(0,5,2)+'</pRedBC>'
	cString += '<vBC>'+ConvType(0,15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(0,5,2)+'</aliquota>'
	cString += '<valor>'+ConvType(0,15,2)+'</valor>'
	cString += '<qtrib>'+ConvType(0,16,4)+'</qtrib>'
	cString += '<vltrib>'+ConvType(0,15,4)+'</vltrib>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf
If Len(aIPI)>0 
	cString += '<imposto>'
	cString += '<codigo>IPI</codigo>'
	cString += '<cpl>'
	cString += NfeTag('<clEnq>',ConvType(AIPI[01]))
	cString += NfeTag('<cSelo>',ConvType(AIPI[02]))
	cString += NfeTag('<qSelo>',ConvType(AIPI[03]))
	cString += NfeTag('<cEnq>' ,ConvType(AIPI[04]))
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(AIPI[05])+'</CST>'
	cString += '<modBC>'+ConvType(AIPI[11])+'</modBC>'
	cString += '<pRedBC>'+ConvType(AIPI[12],5,2)+'</pRedBC>'
	cString += '<vBC>'  +ConvType(AIPI[06],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(AIPI[09],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(AIPI[08],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(AIPI[07],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(AIPI[10],15,2)+'</valor>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf
cString += '<imposto>'
cString += '<codigo>PIS</codigo>'
If Len(aPIS)>0
	cString += '<Tributo>'
	cString += '<CST>'+aPIS[01]+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aPIS[02],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aPIS[03],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(aPIS[06],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(aPIS[05],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aPIS[04],15,2)+'</valor>'
	cString += '</Tributo>'
Else
	cString += '<Tributo>'
	cString += '<CST>08</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(0,15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(0,5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(0,15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(0,16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(0,15,2)+'</valor>'
	cString += '</Tributo>'
EndIf
cString += '</imposto>'
If Len(aPISST)>0
	cString += '<imposto>'
	cString += '<codigo>PISST</codigo>'
	cString += '<Tributo>'
	cString += '<CST>'+aPISST[01]+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aPISST[02],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aPISST[03],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(aPISST[06],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(aPISST[05],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aPISST[04],15,2)+'</valor>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf
cString += '<imposto>'
cString += '<codigo>COFINS</codigo>'
If Len(aCOFINS)>0
	cString += '<Tributo>'
	cString += '<CST>'+aCOFINS[01]+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aCOFINS[02],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aCOFINS[03],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(aCOFINS[06],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(aCOFINS[05],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aCOFINS[04],15,2)+'</valor>'
	cString += '</Tributo>'
Else
	cString += '<Tributo>'
	cString += '<CST>08</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(0,15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(0,5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(0,15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(0,16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(0,15,2)+'</valor>'
	cString += '</Tributo>'
EndIf
cString += '</imposto>'
If Len(aCOFINSST)>0
	cString += '<imposto>'
	cString += '<codigo>COFINSST</codigo>'	
	cString += '<Tributo>'
	cString += '<CST>'+aCOFINSST[01]+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aCOFINSST[02],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aCOFINSST[03],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(aCOFINSST[06],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(aCOFINSST[05],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aCOFINSST[04],15,2)+'</valor>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf
If Len(aISSQN)>0
	cString += '<cpl>'
	cString += '<cmunfg>'+aISSQN[04]+'</cmunfg>'
	cString += '<clistserv>'+aISSQN[05]+'</clistserv>'
	cString += '</cpl>'
	cString += '<imposto>'
	cString += '<codigo>ISS</codigo>'	
	cString += '<Tributo>'
	cString += '<CST></CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aISSQN[01],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aISSQN[02],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(0,15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(0,16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aISSQN[03],15,2)+'</valor>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf
cString += NfeTag('<infadprod>',ConvType(""))
cString += '</det>'

Static Function NfeTotal(aTotal,aRet)

Local cString:=""
Local nX     := 0

cString += '<total>'
cString += '<despesa>'+ConvType(aTotal[01],15,2)+'</despesa>'
cString += '<vNF>'+ConvType(aTotal[02],15,2)+'</vNF>'
If Len(aRet)>0
	For nX := 1 To Len(aRet)
		cString += '<TributoRetido>'
		cString += NfeTag('<codigo>' ,ConvType(aRet[nX,01],15,2))
		cString += NfeTag('<BC>'     ,ConvType(aRet[nX,02],15,2))
		cString += NfeTag('<valor>',ConvType(aRet[nX,03],15,2))
		cString += '</TributoRetido>'
	Next nX
EndIf
cString += '</total>'
Return(cString)

Static Function NfeTransp(cModFrete,aTransp,aImp,aVeiculo,aReboque,aVol)
           
Local nX := 0
Local cString := ""

DEFAULT aTransp := {}
DEFAULT aImp    := {}
DEFAULT aVeiculo:= {}
DEFAULT aReboque:= {}
DEFAULT aVol    := {}

cString += '<transp>'
cString += '<modFrete>'+cModFrete+'</modFrete>'
If Len(aTransp)>0
	cString += '<transporta>'
		If Len(aTransp[01])==14
			cString += NfeTag('<CNPJ>',aTransp[01])
		ElseIf Len(aTransp[01])<>0
			cString += NfeTag('<CPF>',aTransp[01])
		EndIf
		cString += NfeTag('<Nome>' ,ConvType(aTransp[02]))
		cString += NfeTag('<IE>'    ,aTransp[03])
		cString += NfeTag('<Ender>',ConvType(aTransp[04]))
		cString += NfeTag('<Mun>'  ,ConvType(aTransp[05]))
		cString += NfeTag('<UF>'    ,ConvType(aTransp[06]))
	cString += '</transporta>'
	If Len(aImp)>0 //Ver Fisco
		cString += '<retTransp>'
		cString += '<codigo>ICMS<codigo>'
		cString += '<Cpl>'
		cString += '<vServ>'+ConvType(aImp[01],15,2)+'</vServ>'
		cString += '<CFOP>'+ConvType(aImp[02])+'</CFOP>'
		cString += '<cMunFG>'+aImp[03]+'</cMunFG>'		
		cString += '</Cpl>'
		cString += '<CST>'+aImp[04]+'</CST>'
		cString += '<MODBC>'+aImp[05]+'</MODBC>'
		cString += '<PREDBC>'+ConvType(aImp[06],5,2)+'</PREDBC>'
		cString += '<VBC>'+ConvType(aImp[07],15,2)+'</VBC>'
		cString += '<aliquota>'+ConvType(aImp[08],5,2)+'</aliquota>'
		cString += '<vltrib>'+ConvType(aImp[09],15,4)+'</vltrib>'
		cString += '<qtrib>'+ConvType(aImp[10],16,4)+'</qtrib>'
		cString += '<valor>'+ConvType(aImp[11],15,2)+'</valor>'
		cString += '</retTransp>'
	EndIf
	If Len(aVeiculo)>0
		cString += '<veicTransp>'
			cString += '<placa>'+ConvType(aVeiculo[01])+'</placa>'
			cString += '<UF>'   +ConvType(aVeiculo[02])+'</UF>'
			cString += NfeTag('<RNTC>',ConvType(aVeiculo[03]))
		cString += '</veicTransp>'
	EndIf
	If Len(aReboque)>0
		cString += '<reboque>'
			cString += '<placa>'+ConvType(aReboque[01])+'</placa>'
			cString += '<UF>'   +ConvType(aReboque[02])+'</UF>'
			cString += NfeTag('<RNTC>',ConvType(aReboque[03]))
		cString += '</reboque>'
	EndIf	
	For nX := 1 To Len(aVol)		
		cString += '<vol>'
			cString += NfeTag('<qVol>',ConvType(aVol[nX][02]))
			cString += NfeTag('<esp>' ,ConvType(aVol[nX][01],15,0))
			//cString += '<marca>' +aVol[03]+'</marca>'
			//cString += '<nVol>'  +aVol[04]+'</nVol>'
			cString += NfeTag('<pesoL>' ,ConvType(aVol[nX][03],15,3))
			cString += NfeTag('<pesoB>' ,ConvType(aVol[nX][04],15,3))
			//cString += '<nLacre>'+aVol[07]+'</nLacre>'
		cString += '</vol>
	Next nX
EndIf
cString += '</transp>'
Return(cString)

Static Function NfeCob(aDupl)

Local cString := ""

Local nX := 0                  
If Len(aDupl)>0
	cString += '<cobr>'
	For nX := 1 To Len(aDupl)
		cString += '<dup>'
		cString += '<Dup>'+ConvType(aDupl[nX][01])+'</Dup>'
		cString += '<dtVenc>'+ConvType(aDupl[nX][02])+'</dtVenc>'
		cString += '<vDup>'+ConvType(aDupl[nX][03],15,2)+'</vDup>'
		cString += '</dup>'
	Next nX	
	cString += '</cobr>'
EndIf

Return(cString)

Static Function NfeInfAd(cMsgCli,cMsgFis,aPedido)

Local cString   := ""
DEFAULT aPedido := {}

If Len(cMsgFis)>0 .Or. Len(cMsgCli)>0
	cString += '<infAdic>'
	If Len(cMsgFis)>0
		cString += '<Fisco>'+ConvType(cMsgFis,Len(cMsgFis))+'</Fisco>'
	EndIf
	If Len(cMsgCli)>0
		cString += '<Cpl>'+ConvType(cMsgCli,Len(cMsgCli))+'</Cpl>'
	EndIf
	cString += '</infAdic>'
EndIf
If Len(aPedido)>0
	cString += '<compra>'
	cString += '<nEmp>'+aPedido[01]+'</nEmp>'
	cString += '<Pedido>'+aPedido[02]+'</Pedido>'
	cString += '<Contrato>'+aPedido[03]+'</Contrato>'
	cString += '</compra>'
EndIf	

Return(cString)

Static Function ConvType(xValor,nTam,nDec)

Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
EndCase
Return(cNovo)

Static Function Inverte(uCpo)

Local cCpo	:= uCpo
Local cRet	:= ""
Local cByte	:= ""
Local nAsc	:= 0
Local nI		:= 0
Local aChar	:= {}
Local nDiv	:= 0


Aadd(aChar,	{"0", "9"})
Aadd(aChar,	{"1", "8"})
Aadd(aChar,	{"2", "7"})
Aadd(aChar,	{"3", "6"})
Aadd(aChar,	{"4", "5"})
Aadd(aChar,	{"5", "4"})
Aadd(aChar,	{"6", "3"})
Aadd(aChar,	{"7", "2"})
Aadd(aChar,	{"8", "1"})
Aadd(aChar,	{"9", "0"})

For nI:= 1 to Len(cCpo)
   cByte := Upper(Subs(cCpo,nI,1))
   If (Asc(cByte) >= 48 .And. Asc(cByte) <= 57) .Or. ;	// 0 a 9
   		(Asc(cByte) >= 65 .And. Asc(cByte) <= 90) .Or. ;	// A a Z
   		Empty(cByte)	// " "
	   nAsc	:= Ascan(aChar,{|x| x[1] == cByte})
   	If nAsc > 0
   		cRet := cRet + aChar[nAsc,2]	// Funcao Inverte e chamada pelo rdmake de conversao
	   EndIf
	Else
		// Caracteres <> letras e numeros: mantem o caracter
		cRet := cRet + cByte
	EndIf
Next
Return(cRet)

Static Function NfeTag(cTag,cConteudo)

Local cRetorno := ""
If (!Empty(AllTrim(cConteudo)) .And. IsAlpha(AllTrim(cConteudo))) .Or. Val(AllTrim(cConteudo))<>0
	cRetorno := cTag+AllTrim(cConteudo)+SubStr(cTag,1,1)+"/"+SubStr(cTag,2)
EndIf
Return(cRetorno)

Static Function VldIE(cInsc,lContr)

Local cRet	:=	""
Local nI	:=	1
DEFAULT lContr  :=      .T.
For nI:=1 To Len(cInsc)
	If Isdigit(Subs(cInsc,nI,1)) .Or. IsAlpha(Subs(cInsc,nI,1))
		cRet+=Subs(cInsc,nI,1)
	Endif
Next
cRet := AllTrim(cRet)
If "ISENT"$Upper(cRet)
	cRet := ""
EndIf
If !(lContr) .And. !Empty(cRet)
	cRet := "ISENTA"
EndIf
Return(cRet)


static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõ"
Local cCecid := "çÇ"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
cString := _NoTags(cString)
Return cString

