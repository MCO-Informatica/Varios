#Include 'Protheus.ch'


/**
* Autor    	: Rodrigo Sanches
* Descricao	: Ponto de entrada para adicionar mensagens na DANFE.
* Data    	: 20/12/12
*/
User Function PE01NFESEFAZ()
Local aProd 		:= 	Paramixb[1]
Local cMensCli  	:= 	Paramixb[2]
Local cMensFis 		:= 	Paramixb[3]
Local aDest 		:= 	Paramixb[4]
Local aNota 		:= 	Paramixb[5]
Local aInfoItem 	:= 	Paramixb[6]
Local aDupl 		:=	Paramixb[7]
Local aTransp 		:=	Paramixb[8]
Local aEntrega 		:=	Paramixb[9]
Local aRetirada 	:= 	Paramixb[10]
Local aVeiculo  	:= 	Paramixb[11]
Local aReboque 		:= 	Paramixb[12]
Local aNfVincRur	:= 	Paramixb[13]
Local aEspVol       :=  Paramixb[14]
Local aNfVinc		:=  Paramixb[15]
Local aDetPag		:=  Paramixb[16]
Local aObsCont      :=  Paramixb[17]
Local cTipoNf		:= ""
Local cQuery		:= ""
Local nValIcmZF		:= 0
Local cAliasSD2		:= "qTmp"
Local nValPisZF		:= 0
Local nValCofZF		:= 0
Local cMailTransp	:= ""
Local lContinua		:= .T.
Local nX			:= 0

Private cEmailTra := ""
Private cEmailCli := ""

cTipoNf := aNota[4]

&& Nf de Saida
If cTipoNf == "1"
	cSerie := aNota[1]
	cDoc   := aNota[2]
	cQuery := "SELECT * "
	cQuery += " FROM "+RetSqlTab("SD2")
	cQuery += " WHERE SD2.D_E_L_E_T_ 	= ''"
	cQuery += " AND   SD2.D2_FILIAL 	= '"+xFilial("SD2")+"'"
	cQuery += " AND   SD2.D2_SERIE  	= '"+SF2->F2_SERIE+"'"
	cQuery += " AND   SD2.D2_DOC    	= '"+SF2->F2_DOC+"'"
	cQuery += " AND   SD2.D2_CLIENTE 	= '"+SF2->F2_CLIENTE+"'"
	cQuery += " AND   SD2.D2_LOJA   	= '"+SF2->F2_LOJA+"'"
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSD2,.T.,.T.)
	DbSelectArea(cAliasSD2)
	
	if lContinua
		While !(cAliasSD2)->(Eof())
			
			//-----------------Tratamento da mensagem da zona franca de manaus----------------------------
			If (cAliasSD2)->D2_DESCZFR > 0
				nValIcmZF += ((cAliasSD2)->D2_DESCZFR - (cAliasSD2)->D2_DESCZFC - (cAliasSD2)->D2_DESCZFP)
			EndIf
			
			If (cAliasSD2)->D2_DESCZFP > 0
				nValPisZF += (cAliasSD2)->D2_DESCZFP
			EndIf
			
			If (cAliasSD2)->D2_DESCZFC > 0
				nValCofZF += (cAliasSD2)->D2_DESCZFC
			EndIf
			//-----------------Tratamento da mensagem da zona franca de manaus----------------------------
			
			//-----------------Mensagens adicionais do pedido de venda------------------------------------
			
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO))
				If !Empty(SC5->C5_MENPAD2) .And. !AllTrim(FORMULA(SC5->C5_MENPAD2)) $ cMensCli
					If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
						cMensCli += " "
					EndIf
					cMensCli += AllTrim(FORMULA(SC5->C5_MENPAD2))
				EndIf
				
				If !Empty(SC5->C5_MENPAD3) .And. !AllTrim(FORMULA(SC5->C5_MENPAD3)) $ cMensCli
					If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
						cMensCli += " "
					EndIf
					cMensCli += AllTrim(FORMULA(SC5->C5_MENPAD3))
				EndIf
				
				If !Empty(SC5->C5_MENPAD4) .And. !AllTrim(FORMULA(SC5->C5_MENPAD4)) $ cMensCli
					If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
						cMensCli += " "
					EndIf
					cMensCli += AllTrim(FORMULA(SC5->C5_MENPAD4))
				EndIf
				If SC5->C5_TIPO == "N" .AND. !Empty(Subs(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_SUFRAMA"),1,12)) .And. !"CODIGO SUFRAMA: " +Subs(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_SUFRAMA"   ),1,12) $ cMensCli
					If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
						cMensCli += " - "
					EndIf
					cMensCli += "CODIGO SUFRAMA: " + Subs(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_SUFRAMA"   ),1,12) +chr(13)+chr(10) //+Space(80-Len("CODIGO SUFRAMA: " + Subs(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_SUFRAMA"   ),1,12)))
				EndIf
				
				If !Empty(SC5->C5_NUM) .And. !AllTrim(SC5->C5_NUM) $ cMensCli
					If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
						cMensCli += " - "
					EndIf
					cMensCli += chr(13)+chr(10)+ Alltrim("NOSSO PEDIDO: ") +SC5->C5_NUM + "" +chr(13)+chr(10)
				EndIf
				
				
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV))
					If !Empty(SC6->C6_PEDCLI)
						If !"PEDIDO CLIENTE: " + Alltrim(SC6->C6_PEDCLI) $ cMensCli
							If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
								cMensCli += " - "
							EndIf
							cMensCli += "PEDIDO CLIENTE: " + Alltrim(SC6->C6_PEDCLI) + "" +chr(13)+chr(10)
						EndIf
					EndIf

					If !Empty(SC6->C6_NUMPCOM)
						If !"PEDIDO CLIENTE: " + Alltrim(SC6->C6_NUMPCOM) $ cMensCli
							If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
								cMensCli += " - "
							EndIf
							cMensCli += "PEDIDO CLIENTE: " + Alltrim(SC6->C6_NUMPCOM) + "" +chr(13)+chr(10)
						EndIf
					EndIf

				EndIf
				
			EndIf
			//-----------------Mensagens adicionais do pedido de venda------------------------------------
				
			//---------Mensagem de Sufrade-----------------------------------------
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD))
			
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA))
			
			_cGrpTrib1 := SB1->B1_GRTRIB
			_cGrpTrib2 := SA1->A1_GRPTRIB
			
			SF7->(dbSetOrder(1))
			If SF7->(dbSeek(xFilial("SF7")+_cGrpTrib1+_cGrpTrib2,.F.))
				
				While Eof() == .f. .And. SF7->F7_GRTRIB+SF7->F7_GRPCLI == _cGrpTrib1+_cGrpTrib2
					
					//----> COMPARA O ESTADO
					If SF7->F7_EST == SA1->A1_EST
						
						//----> VERIFICA SE O CAMPO FORMULA ESTA PREENCHIDO E SE A FORMULA JA NAO EXISTE NOS DADOS ADICIONAIS
						If !Empty(SF7->F7_X_FORMU) .And. !AllTrim(FORMULA(SF7->F7_X_FORMU)) $ cMensCli
								cMensCli += AllTrim(FORMULA(SF7->F7_X_FORMU))
						EndIf
					EndIf
					
					SF7->(dbSkip())
				EndDo
				
			EndIf
			
			If !" TROCAS, QUEBRAS, FALTAS, AVARIAS OU RECLAMACOES SOMENTE SERAO ACEITAS NO ATO DO RECEBIMENTO." $ cMensCli
				cMensCli += " TROCAS, QUEBRAS, FALTAS, AVARIAS OU RECLAMACOES SOMENTE SERAO ACEITAS NO ATO DO RECEBIMENTO."+chr(13)+chr(10)
			EndIf
			//---------Mensagem de Sufrade-----------------------------------------
			
			//---------------Local de entraga-----------------------------------------------------
			
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA))
			
			If !Empty(SA1->A1_ENDENT) .And. !AllTrim(SA1->A1_ENDENT) $ cMensCli
				If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
					cMensCli += " "
				EndIf
				cMensCli += "/ LOCAL ENTR: " + AllTrim(SA1->A1_ENDENT) + " - "
				If !Empty(SA1->A1_MUNE)
					cMensCli += AllTrim(SA1->A1_MUNE) + " - "
				EndIf
				If !Empty(SA1->A1_ESTE)
					cMensCli += AllTrim(SA1->A1_ESTE) + " - "
				Endif
				If !Empty(SA1->A1_CEPE)
					cMensCli += AllTrim(SA1->A1_CEPE) + " - "
				EndIf
				If !Empty(SA1->A1_BAIRROE)
					cMensCli += AllTrim(SA1->A1_BAIRROE)
				EndIf
			EndIf
			//---------------Local de entraga-----------------------------------------------------
			
			//---------------Redespacho-----------------------------------------------------------
			If !Empty(SF2->F2_REDESP) .And. !"/ LOCAL REDESPACHO: "$cMensCli
				If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
					cMensCli += " "
				EndIf
				
				cMensCli += chr(13)+chr(10)+ "/ LOCAL REDESPACHO: " + AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_NOME")) + " - "
				
				If !Empty(AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_END")))
					cMensCli += AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_END")) + " - "
				EndIf
				If !Empty(AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_COMPLEM")))
					cMensCli += AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_COMPLEM")) + " - "
				EndIf
				If !Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_BAIRRO"))
					cMensCli += AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_BAIRRO")) + " - "
				EndIf
				If !Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_MUN"))
					cMensCli += AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_MUN")) + " - "
				EndIf
				If !Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_EST"))
					cMensCli += AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_EST")) + " - "
				Endif
				If !Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_CEP"))
					cMensCli += AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_CEP")) + " - "
				EndIf
				If !Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_DDD"))
					cMensCli += AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_DDD")) + " - "
				EndIf
				If !Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_TEL"))
					cMensCli += AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_TEL")) + " - "
				EndIf
				If !Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_CGC"))
					cMensCli += "CNPJ: "+AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_CGC")) + " - "
				EndIf   
				If !Empty(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_INSEST")) .And. !"I.E: "$cMensCli
					cMensCli += "I.E: "+AllTrim(Posicione("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_INSEST"))
				EndIf

				cMensCli += " - FRETE REDESPACHO POR CONTA DO "+IIF(SC5->C5_TPFREDE$"R","EMITENTE "+ALLTRIM(SM0->M0_NOMECOM),"DESTINATARIO "+ALLTRIM(SA1->A1_NOME))


			EndIf
			//---------------Redespacho-----------------------------------------------------------
			
			(cAliasSD2)->(dbskip())
		End
	end
	(cAliasSD2)->(DbCloseArea())
	
	// Mensagem da Zona franca de manaus.
	If nValIcmZF > 0 .Or. nValPisZF > 0 .Or. nValCofZF > 0
		If !"Desconto Referente a Zona Franca de Manaus - ICMS 7,00% - R$ "+str(nValIcmZF,13,2)+", PIS 1,65% - R$ "+ str(nValPisZF,13,2) +"e COFINS 7,60% - R$ " +str(nValCofZF,13,2) $ cMensFis
			cMensFis += "Desconto Referente a Zona Franca de Manaus - ICMS 7,00% - R$ "+str(nValIcmZF,13,2)+", PIS 1,65% - R$ "+ str(nValPisZF,13,2) +"e COFINS 7,60% - R$ " +str(nValCofZF,13,2)
		EndIf
	EndIf

	/* Mensagem fiscal da operação vemda remessa a ordem */
	_aAreaSD2 := sd2->(GetArea())
    _aAreaSC5 := sc5->(GetArea())

	cQuery := "SELECT DISTINCT D2_PEDIDO"
	cQuery += " FROM "+RetSqlTab("SD2")
	cQuery += " WHERE SD2.D_E_L_E_T_ 	= ''"
	cQuery += " AND   SD2.D2_FILIAL 	= '"+xFilial("SD2")+"'"
	cQuery += " AND   SD2.D2_SERIE  	= '"+SF2->F2_SERIE+"'"
	cQuery += " AND   SD2.D2_DOC    	= '"+SF2->F2_DOC+"'"
	cQuery += " AND   SD2.D2_CLIENTE 	= '"+SF2->F2_CLIENTE+"'"
	cQuery += " AND   SD2.D2_LOJA   	= '"+SF2->F2_LOJA+"'"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSD2,.T.,.T.)

    SD2->(DbSetOrder(8))
	SC5->(DbSetOrder(1))
	While !(cAliasSD2)->( eof() )
	   If SC5->(DbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO))
	      if !empty(SC5->C5_XPEDORD) .and. SD2->(DbSeek(xFilial("SD2")+SC5->C5_XPEDORD))
		     if substr(sd2->d2_cf,2,3) == '923'
			    cMensFis += "/ NF Venda a Ordem referente à NF remessa a Ordem: "+sd2->d2_doc+" Série: "+sd2->d2_serie
			 else
			    cMensFis += "/ NF Remessa a Ordem referente à NF venda a Ordem: "+sd2->d2_doc+" Série: "+sd2->d2_serie
			 endif
		  endif
	   endif
	   (cAliasSD2)->(dbskip())
	End
	(cAliasSD2)->(DbCloseArea())
	Restarea(_aAreaSD2)
	Restarea(_aAreaSC5)
	/* Mensagem fiscal da operação vemda remessa a ordem */
	
	// Adicionando o email da transportadora.
	SA4->(DbSetOrder(1))
	If SA4->(DbSeek(xFilial("SA4")+SF2->F2_TRANSP))
		cEmailTra := SA4->A4_EMAIL
	Endif
	
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		cEmailCli := SA1->A1_EMAILNF
	EndIf
	
	If Len(aDest) >= 16
		aDest[16] := Alltrim(cEmailCli)+";"+Alltrim(cEmailTra)
	EndIf
	
	// INICIO CUSTOMIZACAO POR FELIPE VALENCA - MVG CONSULTORIA 20120210
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,SF2->F2_X_BOX)
	// FIM CUSTOMIZACAO POR FELIPE VALENCA - MVG CONSULTORIA 20120210
	
	// Alterado dia 27/11/13
	//Alterado a descricao do produto para quanto tiver grade de produto.
	nX := 0
	For nX := 1 to Len(aInfoItem)
		
		SC6->(DbSetOrder(1))
		IF SC6->(DbSeek(xFilial("SC6")+aInfoItem[nX][1]+aInfoItem[nX][2]+aProd[nX][2]))
			
			IF SC6->C6_GRADE == "S" // verifica se é produto de grade.
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+aProd[nX][2]))
					aProd[nX][4] := AllTrim(SB1->B1_DESC)
				Endif
			EndIf
		EndIf
	Next nX
	//Fim alteracao
	
Else
	// Nf de Entrada
	
	If !Empty(SF1->F1_FORMULA) .And. !AllTrim(Formula(SF1->F1_FORMULA)) $ cMensCli
		If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
			cMensCli += " "
		EndIf
		cMensCli += AllTrim(Formula(SF1->F1_FORMULA))
	EndIf
	
	If !Empty(SF1->F1_MENSAGE) .And. !AllTrim(SF1->F1_MENSAGE) $ cMensCli
		If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
			cMensCli += " "
		EndIf
		cMensCli += AllTrim(SF1->F1_MENSAGE)
	EndIf
	
	If !Empty(SF1->F1_MENSAG2) .And. !AllTrim(SF1->F1_MENSAG2) $ cMensCli
		If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
			cMensCli += " "
		EndIf
		cMensCli += AllTrim(SF1->F1_MENSAG2)
	EndIf
	
	// INICIO CUSTOMIZACAO POR FELIPE VALENCA - MVG CONSULTORIA 20120210
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,""	)
	aadd(aTransp,"" )
	// FIM CUSTOMIZACAO POR FELIPE VALENCA - MVG CONSULTORIA 20120210
	
EndIf

Return({aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aNfVincRur,aEspVol,aNfVinc,aDetPag,aObsCont})


