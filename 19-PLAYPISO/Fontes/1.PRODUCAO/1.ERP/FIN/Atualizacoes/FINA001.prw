#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?FINA001   ?Autor  ?Alexandre Sousa     ? Data ?  02/11/11   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Replicacao de rateio para todos as parcelas do mesmo titulo ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?Especifico LISONDA.                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function FINA001()

Private aColsSev := {}
Private cAlias := 'SE2'
Private	lIRPFBaixa := .F.
Private lCalcIssBx := .F.
Private lPccBaixa  := .F.
Private nHdlPrv := nil
Private nTotal := 0
Private cArquivo
Private aRegs := {}

RegToMemory("SE2")
                               
    //incluido o bloco abaixo [Mauro Nagata, Actual Trend, 21/07/2011]
    //como para debugar levaria muito tempo foi acordado com o sr.Fabio, diretor, que seria feito esta customiza??o alternativa para que pudessem ratear 
	DbSelectArea("SEV")
	aAreaSEV := GetArea("SEV")
	DbSetOrder(2)
    If DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"1")
       If MsgBox("Existe(m) rateio(s) para ese t?tulo. Para continuar o(s) rateio(s) ser?(?o) exclu?do(s) o(s) rateio(s) deste t?tulo e parcelas pertencentes a este t?tulo. Deseja continuar ?","Rateio","YESNO")
          DbSelectArea("SE2")
          RecLock("SE2",.F.)
          SE2->E2_MULTNAT := " "
          SE2->(MsUnLock())  
           
          DbSelectArea("SEV")
          Do While !Eof().And.xFilial("SEV")=SEV->EV_FILIAL.And.SEV->EV_PREFIXO=SE2->E2_PREFIXO.And.;
                   SEV->EV_NUM=SE2->E2_NUM.And.SEV->EV_TIPO=SE2->E2_TIPO.And.;
                   SEV->EV_CLIFOR=SE2->E2_FORNECE.And.SEV->EV_LOJA=SE2->E2_LOJA.And.SEV->EV_IDENT = '1'
             RecLock("SEV",.F.)  
             DbDelete()        
             SEV->(MsUnLock())
             DbSkip()
          EndDo                  
          RestArea(aAreaSEV)
          DbSelectArea("SEZ")
          aAreaSEZ := GetArea("SEZ")
          DbSetOrder(4)
          If DbSeek(xFilial("SEZ")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
             Do While !Eof().And.xFilial("SEZ")=SEZ->EZ_FILIAL.And.SEZ->EZ_PREFIXO=SE2->E2_PREFIXO.And.;
                      SEZ->EZ_NUM=SE2->E2_NUM.And.SEZ->EZ_TIPO=SE2->E2_TIPO.And.;
                      SEZ->EZ_CLIFOR=SE2->E2_FORNECE.And.SEZ->EZ_LOJA=SE2->E2_LOJA  //.And.SEZ->EZ_IDENT = '1'
                RecLock("SEZ",.F.)  
                DbDelete()        
                SEZ->(MsUnLock())
                DbSkip()
             EndDo          
          EndIf   
          RestArea(aAreaSEZ)
       Else
          Return   
       EndIf   
	EndIf	   
	//fim bloco [Mauro Nagata, Actual Trend, 21/07/2011]
	
MultNat2("SE2",4,0,.F.,.T.)

//	M->E2_MULTNAT := aCampos[Ascan(aCampos,{|e| e[1] == "E2_MULTNAT"})][2]

If MsgYesNo("Deseja Gravar o rateio para todas as parcelas desse t?tulo?", "ATEN??O")
	a_area := SE2->(GetArea())
	c_chv := SE2->(E2_FILIAL+E2_NATUREZ+E2_NOMFOR+E2_PREFIXO+E2_NUM)    
	
	//excluida linha abaixo [Mauro Nagata, Actual Trend, 17/05/2011]
	//if !EMPTY(SE2->E2_BAIXA)
	
	DbSelectArea('SE2')
	DbSetOrder(2) //E2_FILIAL, E2_NATUREZ, E2_NOMFOR, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, R_E_C_N_O_, D_E_L_E_T_
	DbSeek(c_chv)
	
//	Do While SE2->(!EOF()) .and. SE2->(E2_FILIAL+E2_NATUREZ+E2_NOMFOR+E2_PREFIXO+E2_NUM) == c_chv .and. !EMPTY(SE2->E2_BAIXA)   
//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 17/05/2011]
	Do While SE2->(!EOF()) .and. SE2->(E2_FILIAL+E2_NATUREZ+E2_NOMFOR+E2_PREFIXO+E2_NUM) == c_chv
		If len(aColsSev) > 0
			
			RecLock('SE2', .F.)
			SE2->E2_MULTNAT := '1'
			MsUnLock()
			
			nSomaRateio := 0
			aEval(aColsSev, { |e| nSomaRateio += Round(e[2],2) } ) // Soma o valor das multiplas naturezas
			// Coloca a diferenca entre o valor do titulo e a soma dos rateios na ultima parcela do rateio
			aColsSev[Len(aColsSev)][2] += (SE2->E2_VALOR - nSomaRateio)
			For nX := 1 To Len(aColsSev)
				If aColsSev[nX][4] == "1"
					nSomaRateio := 0
					If SEZTMP->(DbSeek(aColsSev[nX][1]))
						While SEZTMP->(!Eof()) .And. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
							nSomaRateio +=	Round(SEZTMP->EZ_VALOR,2)
							SEZTMP->(DbSkip())
						End
						SEZTMP->(DbSkip(-1))
						RecLock("SEZTMP")
						SEZTMP->EZ_VALOR += (Round(aColsSev[nX][2],2) - nSomaRateio)
						MsUnlock()
					Endif
				Endif
			Next
			DbSelectArea("SE2")
			GrvSevSez(cAlias,aColsSev,aHeaderSev,,If(mv_par06 == 1,If(lIRPFBaixa,0,M->E2_IRRF)+If(!lCalcIssBx,M->E2_ISS,0)+M->E2_INSS+IIF(lPccBaixa,0,M->E2_PIS+M->E2_COFINS+M->E2_CSLL)+;
			M->E2_RETENC+M->E2_SEST,0),.F.,"FINA050",mv_par04==1,@nHdlPrv,@nTotal,@cArquivo, .T.)
		EndIf
		SE2->(DbSkip())
	EndDo
	//excluido bloco abaixo [Mauro Nagata, Actual Trend, 17/05/2011]
	/*
	else
	MsgInfo("N?o Pode")
	EndIf
	*/
	//fim bloco [Mauro Nagata, Actual Trend, 17/05/2011]
Else
    //excluida linha abaixo [Mauro Nagata, Actual Trend, 17/05/2011]
	//If !EMPTY(SE2->E2_BAIXA)
		If len(aColsSev) > 0
			
			RecLock('SE2', .F.)
			SE2->E2_MULTNAT := '1'
			MsUnLock()
			
			nSomaRateio := 0
			aEval(aColsSev, { |e| nSomaRateio += Round(e[2],2) } ) // Soma o valor das multiplas naturezas
			// Coloca a diferenca entre o valor do titulo e a soma dos rateios na ultima parcela do rateio
			aColsSev[Len(aColsSev)][2] += (SE2->E2_VALOR - nSomaRateio)
			For nX := 1 To Len(aColsSev)
				If aColsSev[nX][4] == "1"
					nSomaRateio := 0
					If SEZTMP->(DbSeek(aColsSev[nX][1]))
						While SEZTMP->(!Eof()) .And. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
							nSomaRateio +=	Round(SEZTMP->EZ_VALOR,2)
							SEZTMP->(DbSkip())
						End
						SEZTMP->(DbSkip(-1))
						RecLock("SEZTMP")
						SEZTMP->EZ_VALOR += (Round(aColsSev[nX][2],2) - nSomaRateio)
						MsUnlock()
					Endif
				Endif
			Next
			DbSelectArea("SE2")
			GrvSevSez(cAlias,aColsSev,aHeaderSev,,If(mv_par06 == 1,If(lIRPFBaixa,0,M->E2_IRRF)+If(!lCalcIssBx,M->E2_ISS,0)+M->E2_INSS+IIF(lPccBaixa,0,M->E2_PIS+M->E2_COFINS+M->E2_CSLL)+;
			M->E2_RETENC+M->E2_SEST,0),.F.,"FINA050",mv_par04==1,@nHdlPrv,@nTotal,@cArquivo, .T.)
		EndIf
		//excluida bloco abaixo [Mauro Nagata, Actual Trend, 17/05/2011]
		/*
		else
		MsgInfo("N?o Pode")
		EndIf
		*/
		//fim bloco [Mauro Nagata, Actual Trend, 17/05/2011]
	EndIf
	
	Return
	/*/
	?????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????Ŀ??
	???Fun??o	 ?MultNat2	? Autor ? Claudio Donizete Souza? Data ? 22/05/01 ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	???Descri??o ?Distribui o valor do titulo em varias naturezas     		  ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	???Sintaxe	 ?MultNat(cAlias)                 							  ???
	???       	 ?cAlias -> Alias do Arquivo (SE1 ou SE2)					  ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	??? Uso		 ? FINA040,FINA050											  ???
	??????????????????????????????????????????????????????????????????????????ٱ?
	?????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????????
	/*/
	Static Function MultNat2(cAlias,nOpc,nImpostos,lRatImpostos,aColsParam, aHeaderParam,  lMostraTela)
	
	LOCAL aCampos	:= { 	"EV_NATUREZ",;
	"EV_VALOR"  ,;
	"EV_PERC" ,;
	"EV_RATEICC" } 	// Indica quais campos serao
	// exbididos na GetDados
	// e na ordem que devem aparecer
	LOCAL cCampo    := Right(cAlias,2)
	LOCAL nX
	LOCAL bTit      := { |cChave| SX3->(DbSetOrder(2)), SX3->(DbSeek(cChave)), X3Titulo() }
	LOCAL oDlg
	LOCAL oGet
	LOCAL aArea  	:= GetArea()
	LOCAL aArea1 	:= (cAlias)->(GetArea())
	LOCAL cPic  	:= PesqPict("SE2","E2_VALOR",19)
	Local nTotSev	:= nTotSez := nPerSev := nPerSez := 0
	Local lRtNattel := Existblock("RTNATTEL")
	Local aButton := {}
	Local aCpoUsado := {"EZ_PREFIXO", "EZ_NUM", "EZ_PARCELA", "EZ_TIPO", "EZ_CLIFOR", "EZ_LOJA"}
	Local lValF050	:= .T.
	Local lF050VCMN := ExistBlock("F050VCMN")
	Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
	
	PRIVATE aCols		:= {}
	PRIVATE aHeader	:= {}
	PRIVATE oValDist
	PRIVATE nValDist  := 0
	PRIVATE nVlTit
	PRIVATE aTit      := {}
	PRIVATE nOpcA 	   := 0
	PRIVATE oValFal
	PRIVATE oPerFal
	PRIVATE nValFal	:= 0
	PRIVATE nPerFal	:= 100
	
	DEFAULT nOpc	 	:= 3
	DEFAULT nImpostos	:= 0
	DEFAULT lRatImpostos	:= .F.
	DEFAULT aColsParam	:= {}
	DEFAULT aHeaderParam := {}
	DEFAULT lMostraTela	:= .T.
	
	If nOpc # 3
		Aadd(aButton, {'S4WB013N',{||MulNatCC(nOpc) },"Rateio Centro de Custo","Rateio Centro de Custo"} )
		nVlTit	:= M->&(cCampo + "_VALOR") + nImpostos // Valor do titulo
	Else
		nVlTit	:= M->&(cCampo + "_VALOR") + nImpostos // Valor do titulo
	Endif
	nValFal 	:= M->&(cCampo + "_VALOR") + nImpostos // Valor do titulo
	
	__OPC 	:= nOpc
	
	//??????????????????????????????????????????????????????????????Ŀ
	//? Montagem da matriz aHeader e aCampos						 ?
	//????????????????????????????????????????????????????????????????
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("EV_PREFIXO")
	cUsado := X3_USADO
	// Atualiza os campos do SEZ que estavam como usado e nao deveriam
	For nX := 1 To Len(aCpoUsado)
		dbSeek(aCpoUsado[nX])
		If ! X3USO(SX3->X3_Usado)
			RecLock("SX3",.F.)
			SX3->X3_USADO := cUsado
			msUnlock()
		Endif
	Next
	
	SEV->(dbSetOrder(2))
	If (nOpc # 3 .and. ;
		SEV->(MsSeek(	xFilial("SEV")+;
		(cAlias)->&(cCampo + "_PREFIXO")+;
		(cAlias)->&(cCampo + "_NUM")+;
		(cAlias)->&(cCampo + "_PARCELA")+;
		(cAlias)->&(cCampo + "_TIPO")+;
		(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
		(cAlias)->&(cCampo + "_LOJA")+;
		"1")))		//1=Inclusao
		
		While SEV->EV_FILIAL + SEV->EV_PREFIXO + SEV->EV_NUM +;
			SEV->EV_PARCELA + SEV->EV_TIPO + SEV->EV_CLIFOR +;
			SEV->EV_LOJA+SEV->EV_IDENT == xFilial("SEV")+;
			(cAlias)->&(cCampo + "_PREFIXO")+;
			(cAlias)->&(cCampo + "_NUM")+;
			(cAlias)->&(cCampo + "_PARCELA")+;
			(cAlias)->&(cCampo + "_TIPO")+;
			(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
			(cAlias)->&(cCampo + "_LOJA")+;
			"1" //.And. !EMPTY((cAlias)->&(cCampo + "_BAIXA"))	//1 = Inclusao    // Bruno
			
			Aadd(aCols,Array(Len(aCampos)+1))
			If Len(aCols) = 1
				For nX := 1 To Len(aCampos)
					SX3->(dbSeek(Pad(aCampos[nX],10)))
					Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
					If Alltrim(aHeader[nX][2]) == "EV_PERC" // Percentual
						aHeader[nX][6] := "MNatCalcV()"
						// Inclui em aCols como caracter para ser possivel a visualizacao na
						// tela, por ser a ultima coluna da getdados
						aHeader[nX][8] := "C"
						aHeader[nX][5] := 2
					ElseIf Alltrim(aHeader[nX][2]) == "EV_VALOR"
						aHeader[nX][6] := "MNatCalcP()"
					ElseIf Alltrim(aHeader[nX][2]) == "EV_NATUREZ"
						aHeader[nX][6] := 'ExistCpo("SED") .And. MNatAltN()'
					Endif
				Next
			Endif
			
			aCols[Len(aCols)][1] := SEV->EV_NATUREZ
			aCols[Len(aCols)][2] := Round(NoRound(nVlTit * SEV->EV_PERC, 3), 2)
			aCols[Len(aCols)][3] := Trans(SEV->EV_PERC * 100, PesqPict("SEV","EV_PERC"))
			aCols[Len(aCols)][4] := SEV->EV_RATEICC
			aCols[Len(aCols)][Len(aCampos)+1] := .F.
			
			nTotSev += aCols[Len(aCols)][2]
			nPerSev += SEV->EV_PERC * 100
			
			Aadd(aRegs, SEV->(Recno()))
			nValDist := nVlTit
			nValFal	:= 0
			nPerFal	:= 0
			
			SEV->(DbSkip())
		EndDo
		
		If nTotSev # nVlTit .Or. nPerSev # 100
			aCols[Len(aCols)][2] += nVlTit - nTotSev
			aCols[Len(aCols)][3] := Trans(Val(aCols[Len(aCols)][3]) +;
			100 - nPerSev, PesqPict("SEV","EV_PERC"))
		Endif
		
		If Select("SEZTMP") = 0
			aCposDb := {}
			aadd(aCposDB,{"EZ_NATUREZ","C",10,0})
			aadd(aCposDB,{"EZ_CCUSTO","C",TamSx3("CTT_CUSTO")[1],0})
			aadd(aCposDB,{"EZ_ITEMCTA","C",TamSx3("CTD_ITEM")[1],0})
			aadd(aCposDB,{"EZ_CLVL","C",TamSx3("CTH_CLVL")[1],0})
			aadd(aCposDB,{"EZ_VALOR","N",17,2})
			aadd(aCposDB,{"EZ_PERC","N",11,7})
			aadd(aCposDB,{"EZ_FLAG","L",1,0})
			aadd(aCposDB,{"EZ_RECNO","N",6,0})
			cArqSez := CriaTrab(aCposDB,.T.) // Nome do arquivo temporario do SEZ
			dbUseArea(.T.,__LocalDriver,cArqSez,"SEZTMP",.F.)
			
			cIndice := "EZ_NATUREZ+EZ_CCUSTO"
			dbSelectArea("SEZTMP")
			IndRegua ("SEZTMP",cArqSez,cIndice,,,"Selecionando Registros...") //
			#IFNDEF TOP
				dbSetIndex(cArqSez+OrdBagExt())
			#ENDIF
			dbSetOrder(1)
			SEZ->(dbSetOrder(1))
			SEZ->(MsSeek(xFilial("SEZ")+;
			(cAlias)->&(cCampo + "_PREFIXO")+;
			(cAlias)->&(cCampo + "_NUM")+;
			(cAlias)->&(cCampo + "_PARCELA")+;
			(cAlias)->&(cCampo + "_TIPO")+;
			(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
			(cAlias)->&(cCampo + "_LOJA")))
			
			While 	SEZ->EZ_FILIAL + SEZ->EZ_PREFIXO + SEZ->EZ_NUM +;
				SEZ->EZ_PARCELA + SEZ->EZ_TIPO + SEZ->EZ_CLIFOR +;
				SEZ->EZ_LOJA == xFilial("SEZ")+;
				(cAlias)->&(cCampo + "_PREFIXO")+;
				(cAlias)->&(cCampo + "_NUM")+;
				(cAlias)->&(cCampo + "_PARCELA")+;
				(cAlias)->&(cCampo + "_TIPO")+;
				(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
				(cAlias)->&(cCampo + "_LOJA")// .And. !EMPTY((cAlias)->&(cCampo + "_BAIXA"))  //Bruno
				
				//Descarto rateios que nao sao de inclusao
				If SEZ->EZ_IDENT != "1"
					SEZ->(dbskip())
					Loop
				Endif
				
				RecLock("SEZTMP", .T.)
				nPos := Ascan(aCols, { |x| x[1] = SEZ->EZ_NATUREZ })
				SEZTMP->EZ_NATUREZ	:= SEZ->EZ_NATUREZ
				SEZTMP->EZ_CCUSTO		:= SEZ->EZ_CCUSTO
				SEZTMP->EZ_ITEMCTA	:= SEZ->EZ_ITEMCTA
				SEZTMP->EZ_CLVL   	:= SEZ->EZ_CLVL
				SEZTMP->EZ_VALOR		:= Round(NoRound(aCols[nPos][2] * SEZ->EZ_PERC, 3), 2)
				SEZTMP->EZ_PERC		:= SEZ->EZ_PERC
				SEZTMP->EZ_RECNO		:= SEZ->(Recno())
				nTotSez += SEZTMP->EZ_VALOR
				nPerSez += SEZTMP->EZ_PERC
				MsUnLock()
				SEZ->(DbSkip())
			Enddo
		Endif
		
	ElseIf nOpc # 3
		aCols 	:= {}
		aHeader := AClone(aHeaderParam)
	Endif
	
	If nOpc = 3 .Or. Len(aCols) = 0
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek("SEV")
		nX := 1
		While ! SX3->(EOF()) .And. (SX3->X3_Arquivo == "SEV")
			If X3USO(SX3->X3_Usado) .And. cNivel >= SX3->X3_NIVEL
				If nX == 1
					nRecnoSx3 := SX3->(Recno())
					Aadd(aCols,Array(Len(aCampos)))
					// Adiciona os campos na ordem em que devem aparecer
					For nX := 1 To Len(aCampos)
						SX3->(DbSetOrder(2))
						SX3->(MsSeek(Pad(aCampos[nX],10)))
						Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
						If SX3->X3_TIPO == "C"
							aCols[1][nX] := CriaVar(SX3->X3_CAMPO)
						Else
							If Alltrim(SX3->X3_CAMPO) == "EV_PERC" // Percentual
								aHeader[nX][6] := "MNatCalcV()"
								// Inclui em aCols como caracter para ser possivel a visualizacao na
								// tela, por ser a ultima coluna da getdados
								aHeader[nX][8]	:= "C"
								aHeader[nX][5]	:= 2
								aCols[1][nX]	:=  Trans(CriaVar("EV_PERC"), PesPict("EV_PERC"))
							ElseIf Alltrim(SX3->X3_CAMPO) == "EV_VALOR"
								aCols[1][nX] := CriaVar("EV_VALOR")
								aHeader[nX][6] := "MNatCalcP()"
							Else
								aCols[1][nX] := CriaVar(SX3->X3_CAMPO)
							Endif
						EndIf
					Next
					SX3->(DbSetOrder(1))
					SX3->(DbGoto(nRecnoSx3))
					// Adiciona os demais campos
					If Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim(SX3->X3_CAMPO) } )  == 0
						Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
						Aadd(aCols[1], CriaVar(SX3->X3_CAMPO))
					Endif
				Else
					// Adiciona os demais campos
					If Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim(SX3->X3_CAMPO) } )  == 0
						Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
						Aadd(aCols[1], CriaVar(SX3->X3_CAMPO))
					Endif
				Endif
			Endif
			SX3->(DbSkip())
		End
		//??????????????????????????????????????????????????????Ŀ
		//? Adiciona mais um elemento em aCOLS, indicando se a   ?
		//? a linha esta ou nao deletada						 ?
		//????????????????????????????????????????????????????????
		Aadd(aCols[1], .F.)
	Endif
	
	IF lRtNattel
		Execblock("RTNATTEL",.f.,.f.)
	Endif
	
	//????????????????????????????????????????????????????Ŀ
	//? Mostra o corpo da rateio 									 ?
	//??????????????????????????????????????????????????????
	nOpca := 0
	// Cria os titulos do dialogo
	Aadd( aTit, Eval(bTit, cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE")))
	Aadd( aTit, Eval(bTit, cCampo + "_LOJA"))
	Aadd( aTit, Eval(bTit, cCampo + "_PREFIXO"))
	Aadd( aTit, Eval(bTit, cCampo + "_NUM"))
	Aadd( aTit, Eval(bTit, cCampo + "_PARCELA"))
	Aadd( aTit, Eval(bTit, cCampo + "_VALOR" ))
	Aadd( aTit, cAlias)
	
	If lMostraTela
		
		While .T.
			aSize := MSADVSIZE()
			DEFINE MSDIALOG oDlg TITLE OemToAnsi("Naturezas do titulo") From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL //
			oDlg:lMaximized := .T.
			
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20,.T.,.T. )
			oPanel:Align := CONTROL_ALIGN_TOP
			
			@  001, 005 To  018,247 OF oPanel PIXEL
			@  001, 250 To  018,495 OF oPanel PIXEL
			
			@  005 , 010	Say aTit[1] + M->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))	FONT oDlg:oFont OF oPanel Pixel
			@  005 , 100	Say aTit[2] + M->&(cCampo + "_LOJA")    	FONT oDlg:oFont	OF oPanel  Pixel
			@  005 , 257	Say aTit[3] + M->&(cCampo + "_PREFIXO") 	FONT oDlg:oFont	OF oPanel  Pixel
			@  005 , 297	Say aTit[4] + M->&(cCampo + "_NUM")	 	FONT oDlg:oFont	OF oPanel  Pixel
			@  005 , 367	Say aTit[5] + M->&(cCampo + "_PARCELA") 	FONT oDlg:oFont	OF oPanel  Pixel
			
			oPanel2 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,40,40,.T.,.T. )
			
			If !lPanelFin
				oPanel2:Align := CONTROL_ALIGN_BOTTOM
			Endif
			
			@ 001, 005 To 035,247 OF oPanel2 PIXEL
			@ 001, 250 To 035,495 OF oPanel2 PIXEL
			
			@ 005, 010  Say aTit[6] FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
			@ 005, 076  Say nVlTit	PICTURE cPic FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
			
			@ 005, 257  Say "Valor a Distribuir"	FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10  //
			@ 005, 357  Say oValFal VAR nValFal PICTURE cPic	FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
			
			@ 018, 010  Say OemToAnsi("Total Distribuido: ") FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10 //
			@ 018, 076  Say oValDist VAR nValDist PICTURE cPic	FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
			
			@ 018, 257  Say "Percentual a Distribuir"	FONT oDlg:oFont OF oPanel2 PIXEL SIZE 90,10  //
			@ 018, 357  Say oPerFal VAR nPerFal PICTURE PesPict("EV_PERC") SIZE 50,10 FONT oDlg:oFont OF oPanel2 PIXEL //"@E 999.9999999"
			
			oGet := MSGetDados():New(34,5,128,315,nOpc,"MNatLinOk", "AllwaysTrue",,nOpc # 2)
			oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			
			If lPanelFin
				ACTIVATE MSDIALOG oDlg ON INIT (FaMyBar(oDlg,{||nOpca:=1,If(oGet:TudoOk() .And. FaMNatOk() .And. IIF(lF050VCMN,lValF050 := ExecBlock("F050VCMN"),.T.),oDlg:End(),nOpca := 0)},;
				{|| nOpcA:=0,IIF(!lF050VCMN,oDlg:End(),IIF(lValF050 := ExecBlock("F050VCMN"),oDlg:End(),.T.))},aButton),	oPanel2:Align := CONTROL_ALIGN_BOTTOM)
				
			Else
				ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,If(oGet:TudoOk() .And. FaMNatOk() .And. IIF(lF050VCMN,lValF050 := ExecBlock("F050VCMN"),.T.),oDlg:End(),nOpca := 0)},;
				{|| nOpcA:=0,IIF(!lF050VCMN,oDlg:End(),IIF(lValF050 := ExecBlock("F050VCMN"),oDlg:End(),.T.))},,aButton),	oPanel2:Align := CONTROL_ALIGN_BOTTOM)
				
			Endif
			
			If lValF050
				Exit
			Else
				Loop
			EndIf
			
		EndDo
		
	Else
		nOpcA := 1
	Endif
	
	SX3->(DbSetOrder(1))
	RestArea(aArea)
	(cAlias)->(RestArea(aArea1))
	If nOpcA == 1
		aColsParam		:= AClone(aCols)
		aColsSev			:= AClone(aCols)
		aHeaderParam	:= AClone(aHeader)
		aHeaderSev		:= AClone(aHeader)
	Else
		aColsParam		:= {}
		aColsSev			:= {}
		aHeaderParam	:= {}
		aHeaderSev		:= {}
		M->E2_MULTNAT  := "2"	//Volta o campo Multipla Natureza para o status "2-Nao"
	Endif
	// Zera as variaveis de contabilizacao para nao ocorrer duplicidade em outra chamada a DetProva
	VALOR	 := 0
	VALOR2 := 0
	VALOR3 := 0
	VALOR4 := 0
	VALOR5 := 0					// Pis
	VALOR6 := 0					// Cofins
	VALOR7 := 0					// Csll
	
	Return .T.
	
	/*/
	?????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????Ŀ??
	???Fun??o	 ?GrvSevSez ? Autor ? Claudio Donizete Souza? Data ? 08/03/06 ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	???Descri??o ?Grava os arquivos referentes a multiplas naturezas  		  ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	???Sintaxe	 ?GrvSevSez(cAlias,aColsSev,aHeaderSev,lRatImpostos			  ???
	???       	 ?cAlias -> Alias do Arquivo (SE1 ou SE2)							  ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	??? Uso		 ? FINA040,FINA050														  ???
	??????????????????????????????????????????????????????????????????????????ٱ?
	?????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????????
	/*/
	Static Function GrvSevSez(	cAlias, aColsSev, aHeaderSev, nVlTit, nImpostos, lRatImpostos,;
	cOrigem, lContabiliza, nHdlPrv, nTotal, cArquivo, lDesdobr)
	
	Local cCampo    	:= Right(cAlias,2)
	Local cPadrao		:= If(cAlias=="SE1","500","510")
	Local lPadrao		:= VerPadrao(cPadrao)
	Local cPadraoCC	:= If(cAlias=="SE1","506","508")
	Local lPadraoCC	:= VerPadrao(cPadraoCC)
	Local lCtbRatCC	:= .F.  // Controle de contabilizacao por Rateio C.Custo
	LOCAL aArea 		:= GetArea()
	LOCAL aArea1 		:= (cAlias)->(GetArea())
	Local lGrvSev		:= ExistBlock("MULTSEV")
	Local lGrvSez		:= ExistBlock("MULTSEZ")
	Local cChaveIrf	:= If(cAlias = "SE2" .And. M->E2_IRRF > 0, SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCIR + Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA), "")
	Local cChavePis	:= If(cAlias = "SE2" .And. M->E2_PIS > 0, SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCPIS + Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA), "")
	Local cChaveCof	:= If(cAlias = "SE2" .And. M->E2_COFINS > 0, SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCCOF + Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA), "")
	Local cChaveCsl	:= If(cAlias = "SE2" .And. M->E2_CSLL > 0, SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCSLL + Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA), "")
	Local cChaveIns	:= If(cAlias = "SE2" .And. M->E2_INSS > 0, SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCINS + MVINSS, "")
	Local cChaveIss	:= If(cAlias = "SE2" .And. M->E2_ISS > 0 , SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCISS + MVISS, "")
	Local cChave		:= If(lGrvSez .Or. lGrvSev,	(cAlias)->&(cCampo + "_PREFIXO") + ;
	(cAlias)->&(cCampo + "_NUM") + ;
	(cAlias)->&(cCampo + "_PARCELA") +;
	(cAlias)->&(cCampo + "_TIPO") +;
	(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE")) +;
	(cAlias)->&(cCampo + "_LOJA"), "")
	Local nRecno	:= (cAlias)->(Recno())
	Local nX
	Local aDiff 	:= {0,0,0,0,0,0}
	Local aPosDiff := {0,0,0,0,0,0}
	
	Local aRatPis	:= {}, aRatCof := {}, aRatCsl := {}
	Local aRatIrf	:= {}, aRatIns := {}, aRatIss := {}
	
	Local nRatIrf1	:= nRatIns1 := nRatIss1 := 0
	Local nRatPis1	:= nRatCof1 := nRatCsl1 := 0
	Local nRatIrf2	:= nRatIns2 := nRatIss2 := 0
	Local nRatPis2	:= nRatCof2 := nRatCsl2 := 0
	Local nCont := nCont1 := nCont2 := nCont3 := nCont4 := nCont5 := nCont6 := 0
	Local aDadosTit := {}
	
	DEFAULT lRatImpostos	:= .F.
	DEFAULT lContabiliza	:= .F.
	DEFAULT nHdlPrv		:= 0
	DEFAULT nTotal			:= 0
	DEFAULT cArquivo		:= ""
	DEFAULT cOrigem 		:= If(cAlias=="SE1","FINA040","FINA050")
	DEFAULT nImpostos		:= 0
	DEFAULT nVlTit			:= (cAlias)->&(cCampo + "_VALOR") + nImpostos // Valor do titulo
	DEFAULT lDesdobr 		:= .F.
	
	If ! Empty(cChaveIrf)
		cChaveIrf += Pad(GetMV("MV_UNIAO"), Len(SE2->E2_FORNECE)) + "00"
	Endif
	
	If ! Empty(cChaveIns)
		cChaveIns += Pad(GetMV("MV_FORINSS"), Len(SE2->E2_FORNECE)) + "00"
	Endif
	
	If ! Empty(cChaveIss)
		cChaveIss += Pad(GetMV("MV_MUNIC"), Len(SE2->E2_FORNECE)) + "00"
	Endif
	
	If ! Empty(cChavePis)
		cChavePis += Pad(GetMV("MV_UNIAO"), Len(SE2->E2_FORNECE)) + "00"
	Endif
	
	If ! Empty(cChaveCof)
		cChaveCof += Pad(GetMV("MV_UNIAO"), Len(SE2->E2_FORNECE)) + "00"
	Endif
	
	If ! Empty(cChaveCsl)
		cChaveCsl += Pad(GetMV("MV_UNIAO"), Len(SE2->E2_FORNECE)) + "00"
	Endif
	
	If cAlias == "SE2"
		// Armazeno o valor do rateio para os impostos ja arredondado no ultimo
		
		aDiff := {0,0,0,0,0,0}
		aPosDiff := {0,0,0,0,0,0}
		DbSelectArea(cAlias)
		SE2->(DbSetOrder(1))
		
		//IRRF
		If ! Empty(cChaveIrf) .And. SE2->(DbSeek(xFilial("SE2") + cChaveIrf))
			Reclock(cAlias)
			Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
			MsUnlock()
		Endif
		//Pis
		If ! Empty(cChavePis) .And. SE2->(DbSeek(xFilial("SE2") + cChavePis))
			Reclock(cAlias)
			Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
			MsUnlock()
		Endif
		//COFINS
		If ! Empty(cChaveCof) .And. SE2->(DbSeek(xFilial("SE2") + cChaveCof))
			Reclock(cAlias)
			Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
			MsUnlock()
		Endif
		//Csll
		If ! Empty(cChaveCsl) .And. SE2->(DbSeek(xFilial("SE2") + cChaveCsl))
			Reclock(cAlias)
			Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
			MsUnlock()
		Endif
		// INSS
		If ! Empty(cChaveIns) .And. SE2->(DbSeek(xFilial("SE2") + cChaveIns))
			// Armazeno o valor do rateio para os impostos ja arredondado no ultimo
			Reclock(cAlias)
			Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
			MsUnlock()
		Endif
		//ISS
		If ! Empty(cChaveIss) .And. SE2->(DbSeek(xFilial("SE2") + cChaveIss))
			Reclock(cAlias)
			Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
			MsUnlock()
		Endif
		
		If lRatImpostos
			For nX := 1 To Len(aColsSev)
				// Se a linha de aCols nao estiver deletada e o registro nao for
				// encontrado no SEV
				If !aColsSev[nX][Len(aColsSev[nX])]
					If M->E2_IRRF > 0
						Aadd(aRatIrf, { M->E2_IRRF * (Val(aColsSev[nX][3]) / 100), {} })	// Grava o valor informado
						nRatIrf1 += aRatIrf[Len(aRatIrf)][1]
						nCont := 0
						
						If Select("SEZTMP") > 0 .And. aColsSev[nX][4] == "1"
							
							dbSelectArea("SEZTMP")
							// busca natureza no arquivo TMP de Mult Nat C.Custo
							If dbSeek(aColsSev[nX][1])
								While !Eof() .and. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
									Aadd(aRatIrf[Len(aRatIrf)][2], Round(NoRound((M->E2_IRRF * (Val(aColsSev[nX][3]) / 100)) * SEZTMP->EZ_PERC, 2), 3)) // Grava o valor informado
									nCont ++
									nRatIrf2 += aRatIrf[Len(aRatIrf)][2][nCont]
									DbSkip()
								EndDo
								aDiff[1] 	:= nCont
								aPosDiff[1] := Len(aRatIrf)
							Endif
						Endif
					Endif
					If M->E2_PIS > 0
						Aadd(aRatPis, { M->E2_PIS * (Val(aColsSev[nX][3]) / 100), {} })	// Grava o valor informado
						nRatPis1 += aRatPis[Len(aRatPis)][1]
						nCont := 0
						
						If Select("SEZTMP") > 0 .And. aColsSev[nX][4] == "1"
							
							dbSelectArea("SEZTMP")
							// busca natureza no arquivo TMP de Mult Nat C.Custo
							If dbSeek(aColsSev[nX][1])
								While !Eof() .and. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
									Aadd(aRatPis[Len(aRatPis)][2], Round(NoRound((M->E2_PIS * (Val(aColsSev[nX][3]) / 100)) * SEZTMP->EZ_PERC, 2), 3)) // Grava o valor informado
									nCont ++
									nRatPis2 += aRatPis[Len(aRatPis)][2][nCont]
									DbSkip()
								EndDo
								aDiff[2]		:= nCont
								aPosDiff[2] := Len(aRatPis)
							Endif
						Endif
					Endif
					If M->E2_COFINS > 0
						Aadd(aRatCof, { M->E2_COFINS * (Val(aColsSev[nX][3]) / 100), {} })	// Grava o valor informado
						nRatCof1 += aRatCof[Len(aRatCof)][1]
						nCont := 0
						
						If Select("SEZTMP") > 0 .And. aColsSev[nX][4] == "1"
							
							dbSelectArea("SEZTMP")
							// busca natureza no arquivo TMP de Mult Nat C.Custo
							If dbSeek(aColsSev[nX][1])
								While !Eof() .and. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
									Aadd(aRatCof[Len(aRatCof)][2], Round(NoRound((M->E2_COFINS * (Val(aColsSev[nX][3]) / 100)) * SEZTMP->EZ_PERC, 2), 3)) // Grava o valor informado
									nCont ++
									nRatCof2 += aRatCof[Len(aRatCof)][2][nCont]
									DbSkip()
								EndDo
								aDiff[3]		:= nCont
								aPosDiff[3] := Len(aRatCof)
							Endif
						Endif
					Endif
					If M->E2_CSLL > 0
						Aadd(aRatCsl, { M->E2_CSLL * (Val(aColsSev[nX][3]) / 100), {} })	// Grava o valor informado
						nRatCsl1 += aRatCsl[Len(aRatCsl)][1]
						nCont := 0
						
						If Select("SEZTMP") > 0 .And. aColsSev[nX][4] == "1"
							
							dbSelectArea("SEZTMP")
							// busca natureza no arquivo TMP de Mult Nat C.Custo
							If dbSeek(aColsSev[nX][1])
								While !Eof() .and. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
									Aadd(aRatCsl[Len(aRatCsl)][2], Round(NoRound((M->E2_CSLL * (Val(aColsSev[nX][3]) / 100)) * SEZTMP->EZ_PERC, 2), 3)) // Grava o valor informado
									nCont ++
									nRatCsl2 += aRatCsl[Len(aRatCsl)][2][nCont]
									DbSkip()
								EndDo
								aDiff[4]		:= nCont
								aPosDiff[4] := Len(aRatCsl)
							Endif
						Endif
					Endif
					If M->E2_INSS > 0
						Aadd(aRatIns, { M->E2_INSS * (Val(aColsSev[nX][3]) / 100), {} })	// Grava o valor informado
						nRatIns1 += aRatIns[Len(aRatIns)][1]
						
						If Select("SEZTMP") > 0 .And. aColsSev[nX][4] == "1"
							
							dbSelectArea("SEZTMP")
							
							nCont := 0
							// busca natureza no arquivo TMP de Mult Nat C.Custo
							If dbSeek(aColsSev[nX][1])
								While !Eof() .and. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
									Aadd(aRatIns[Len(aRatIns)][2], Round(NoRound((M->E2_INSS * (Val(aColsSev[nX][3]) / 100)) * SEZTMP->EZ_PERC, 3), 2)) // Grava o valor informado
									nCont ++
									nRatIns2 += aRatIns[Len(aRatIns)][2][nCont]
									DbSkip()
								EndDo
								aDiff[5]		:= nCont
								aPosDiff[5] := Len(aRatIns)
							Endif
						Endif
					Endif
					If M->E2_ISS > 0
						Aadd(aRatIss, { M->E2_ISS * (Val(aColsSev[nX][3]) / 100), {} })	// Grava o valor informado
						nRatIss1 += aRatIss[Len(aRatIss)][1]
						
						If 	Select("SEZTMP") > 0 .And. aColsSev[nX][4] == "1"
							
							dbSelectArea("SEZTMP")
							nCont := 0
							// busca natureza no arquivo TMP de Mult Nat C.Custo
							If dbSeek(aColsSev[nX][1])
								While !Eof() .and. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
									Aadd(aRatIss[Len(aRatIss)][2], Round(NoRound((M->E2_ISS * (Val(aColsSev[nX][3]) / 100)) * SEZTMP->EZ_PERC, 3), 2)) // Grava o valor informado
									nCont ++
									nRatIss2 += aRatIss[Len(aRatIss)][2][nCont]
									DbSkip()
								EndDo
								aDiff[6] 		:= nCont
								aPosDiff[6]    := Len(aRatIss)
							Endif
						Endif
					Endif
				Endif
			Next
			
			If Len(aRatIrf) > 0 .And. nRatIrf1 <> M->E2_IRRF
				If nRatIrf1 > M->E2_IRRF
					aRatIrf[Len(aRatIrf)][1] -= nRatIrf1 - M->E2_IRRF
				Else
					aRatIrf[Len(aRatIrf)][1] += M->E2_IRRF - nRatIrf1
				Endif
			Endif
			
			If aDiff[1] > 0 .And. Len(aRatIrf) > 0 .And. nRatIrf2 <> M->E2_IRRF .And. nRatIrf2 > 0
				If nRatIrf2 > M->E2_IRRF
					aRatIrf[aPosDiff[1]][2][aDiff[1]] -= nRatIrf2 - M->E2_IRRF
				Else
					aRatIrf[aPosDiff[1]][2][aDiff[1]] += M->E2_IRRF - nRatIrf2
				Endif
			Endif
			
			If Len(aRatPis) > 0 .And. nRatPis1 <> M->E2_PIS
				If nRatPis1 > M->E2_PIS
					aRatPis[Len(aRatPis)][1] -= nRatPis1 - M->E2_PIS
				Else
					aRatPis[Len(aRatPis)][1] += M->E2_PIS - nRatPis1
				Endif
			Endif
			
			If aDiff[2] > 0 .And. Len(aRatPis) > 0 .And. nRatPis2 <> M->E2_PIS .And. nRatPis2 > 0
				If nRatPis2 > M->E2_PIS
					aRatPis[aPosDiff[2]][2][aDiff[2]] -= nRatPis2 - M->E2_PIS
				Else
					aRatPis[aPosDiff[2]][2][aDiff[2]] += M->E2_PIS - nRatPis2
				Endif
			Endif
			
			If Len(aRatCof) > 0 .And. nRatCof1 <> M->E2_COFINS
				If nRatCof1 > M->E2_COFINS
					aRatCof[Len(aRatCof)][1] -= nRatCof1 - M->E2_COFINS
				Else
					aRatCof[Len(aRatCof)][1] += M->E2_COFINS - nRatCof1
				Endif
			Endif
			
			If aDiff[3] > 0 .And. Len(aRatCof) > 0 .And. nRatCof2 <> M->E2_COFINS .And. nRatCof2 > 0
				If nRatCof2 > M->E2_COFINS
					aRatCof[aPosDiff[3]][2][aDiff[3]] -= nRatCof2 - M->E2_COFINS
				Else
					aRatCof[aPosDiff[3]][2][aDiff[3]] += M->E2_COFINS - nRatCof2
				Endif
			Endif
			
			If Len(aRatCsl) > 0 .And. nRatCsl1 <> M->E2_CSLL
				If nRatCsl1 > M->E2_CSLL
					aRatCsl[Len(aRatCsl)][1] -= nRatCsl1 - M->E2_CSLL
				Else
					aRatCsl[Len(aRatCsl)][1] += M->E2_CSLL - nRatCsl1
				Endif
			Endif
			
			If aDiff[4] > 0 .And. Len(aRatCsl) > 0 .And. nRatCsl2 <> M->E2_CSLL .And. nRatCSL2 > 0
				If nRatCsl2 > M->E2_CSLL
					aRatCsl[aPosDiff[4]][2][aDiff[4]] -= nRatCsl2 - M->E2_CSLL
				Else
					aRatCsl[aPosDiff[4]][2][aDiff[4]] += M->E2_CSLL - nRatCsl2
				Endif
			Endif
			If Len(aRatIns) > 0 .And. nRatIns1 <> M->E2_INSS
				If nRatIns1 > M->E2_INSS
					aRatIns[Len(aRatIns)][1] -= nRatIns1 - M->E2_INSS
				Else
					aRatIns[Len(aRatIns)][1] += M->E2_INSS - nRatIns1
				Endif
			Endif
			
			If aDiff[5] > 0 .And. Len(aRatIns) > 0 .And. nRatIns2 <> M->E2_INSS .And. nRatIns2 > 0
				If nRatIns2 > M->E2_INSS
					aRatIns[aPosDiff[5]][2][aDiff[5]] -= nRatIns2 - M->E2_INSS
				Else
					aRatIns[aPosDiff[5]][2][aDiff[5]] += M->E2_INSS - nRatIns2
				Endif
			Endif
			
			If Len(aRatIss) > 0 .And. nRatIss1 <> M->E2_ISS
				If nRatIss1 > M->E2_ISS
					aRatIss[Len(aRatIss)][1] -= nRatIss1 - M->E2_ISS
				Else
					aRatIss[Len(aRatIss)][1] += M->E2_ISS - nRatIss1
				Endif
			Endif
			
			If aDiff[6] > 0 .And. Len(aRatIss) > 0 .And. nRatIss2 <> M->E2_ISS .And. nRatIss2 > 0
				If nRatIss2 > M->E2_ISS
					aRatIss[aPosDiff[6]][2][aDiff[6]] -= nRatIss2 - M->E2_ISS
				Else
					aRatIss[aPosDiff[6]][2][aDiff[6]] += M->E2_ISS - nRatIss2
				Endif
			Endif
		Endif
	Endif
	
	// Inicia processo de gravacao das multiplas naturezas. O titulo deve estar gravado
	(cAlias)->(DbGoto(nRecno))
	nCont := 0
	
	For nX := 1 To Len(aColsSev)
		// Se a linha de aColsSev nao estiver deletada e o registro nao for
		// encontrado no SEV
		lCtbRatCC := .F.
		If	!aColsSev[nX][Len(aColsSev[nX])]
			If lGrvSev
				ExecBlock("MULTSEV", .F., .F., { 	nX, cChave, aColsSev[nX][2],;
				(aColsSev[nX][2] / nVlTit),;
				aColsSev[nX][1]  })
				DbSelectArea("SEV")
			Endif
			
			
			RecLock("SEV", .T. )
			
			// Grava todos os campos da tela
			aEval(aHeaderSev, {|e,ni| If(e[8] <> "M" .And. e[10] <> "V" .And. Alltrim(e[2]) != "EV_PERC", FieldPut(FieldPos(e[2]),aColsSev[nX][ni]),Nil) } )
			
			SEV->EV_FILIAL   := xFilial("SEV")
			SEV->EV_PREFIXO  := (cAlias)->&(cCampo + "_PREFIXO")
			SEV->EV_NUM      := (cAlias)->&(cCampo + "_NUM")
			SEV->EV_PARCELA  := (cAlias)->&(cCampo + "_PARCELA")
			SEV->EV_CLIFOR   := (cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))
			SEV->EV_LOJA     := (cAlias)->&(cCampo + "_LOJA")
			SEV->EV_TIPO     := (cAlias)->&(cCampo + "_TIPO")
			SEV->EV_NATUREZ  := aColsSev[nX][1] // Grava a natureza
			SEV->EV_VALOR    := aColsSev[nX][2] // Grava o valor informado
			// Grava o percentual (Como indice multiplicador, por esta razao nao
			// multiplica por 100 na gravacao, apenas na exibicao)
			SEV->EV_PERC     := (aColsSev[nX][2] / nVlTit)
			SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
			SEV->EV_RATEICC  := aColsSev[nX][4]  // Identificador de Rateio C Custo
			SEV->EV_IDENT	:= "1"   //rateio de inclusao
			MsUnLock()
			
			//????????????????????????????????????????????????????????????????????????????Ŀ
			//? Gera o lancamento no PCO com os dados do lancamento de multi-natureza (05) ?
			//??????????????????????????????????????????????????????????????????????????????
			If (cAlias)->&(cCampo + "_MULTNAT") == "1"	// Campo multi-natureza igual a "Sim"
				If cAlias == "SE1"
					PCODetLan( "000001", "04", "FINA040" )	// Contas a Receber
				Else
					PCODetLan( "000002", "04", "FINA050" )	// Contas a Pagar
				EndIf
			EndIf
			
			SEZ->(dbSetOrder(4))
			If Select("SEZTMP") > 0 .And. aColsSev[nX][4] == "1" .and.;   // Possui rateio c.Custo
				(!SEZ->(MsSeek(xFilial("SEZ")+;
				(cAlias)->&(cCampo + "_PREFIXO")+;
				(cAlias)->&(cCampo + "_NUM")+;
				(cAlias)->&(cCampo + "_PARCELA")+;
				(cAlias)->&(cCampo + "_TIPO")+;
				(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
				(cAlias)->&(cCampo + "_LOJA")+;
				aColsSev[nX][1]+"1")))
				
				//Gravacao dos dados do rateio C.custo
				dbSelectArea("SEZTMP")
				
				// busca natureza no arquivo TMP de Mult Nat C.Custo
				If dbSeek(aColsSev[nX][1])
					nCont ++
					nCont1 := nCont2 := nCont3 := nCont4 := nCont5 := nCont6 := 0
					While !Eof() .and. SEZTMP->EZ_NATUREZ == aColsSev[nX][1]
						VALOR 	:= SEZ->EZ_VALOR		// Valor Principal
						VALOR2	:= 0		// Irf
						VALOR3	:= 0		// Inss
						VALOR4	:= 0		// Iss
						VALOR5	:= 0		// Pis
						VALOR6	:= 0		// Cofins
						VALOR7	:= 0		// Csll
						
						// Verifica se n?o foi um movimento deletado no aColsSev Mult Nat C.Custo e
						If !(SEZTMP->EZ_FLAG)
							If lGrvSez
								If SEZTMP->EZ_RECNO = 0
									SEZ->(DbGoBottom())
									SEZ->(DbSkip())
								Else
									SEZ->(DbGoto(SEZTMP->EZ_RECNO))
								Endif
								ExecBlock("MULTSEZ", .F., .F., { 3, cChave })
								DbSelectArea("SEZ")
							Endif
							If SEZTMP->EZ_RECNO = 0
								SEZ->(RecLock("SEZ",.T.))
							Else
								SEZ->(DbGoto(SEZTMP->EZ_RECNO))
								If SEZ->(Deleted())			// Alteracao de natureza
									SEZ->(RecLock("SEZ",.T.))
								Else
									SEZ->(RecLock("SEZ",.F.))
								Endif
							Endif
							// Grava todos os campos do temporario no arquivo principal
							aEval(SEZTMP->(DbStruct()), { |e| If(  Alltrim(e[2]) != "EV_PERC", SEZ->(FieldPut(FieldPos(e[1]),SEZTMP->(FieldGet(FieldPos(e[1]))))), Nil) } )
							
							SEZ->EZ_FILIAL		:= xFilial("SEZ")
							SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
							SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
							SEZ->EZ_PARCELA	:= (cAlias)->&(cCampo + "_PARCELA")
							SEZ->EZ_CLIFOR		:= (cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))
							SEZ->EZ_LOJA		:= (cAlias)->&(cCampo + "_LOJA")
							SEZ->EZ_TIPO		:= (cAlias)->&(cCampo + "_TIPO")
							SEZ->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
							SEZ->EZ_VALOR		:= SEZTMP->EZ_VALOR // Grava o valor informado
							SEZ->EZ_PERC		:= SEZTMP->EZ_PERC
							SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
							SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
							SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
							SEZ->EZ_CLVL   	:= SEZTMP->EZ_CLVL     // Classe de Valor
							SEZ->EZ_IDENT	:= "1"   //rateio de inclusao
							MsUnlock()
							
							//???????????????????????????????????????????????????????????????????????????????Ŀ
							//? Gera o lancamento no PCO com os dados do lancamento de C.C. por natureza (06) ?
							//?????????????????????????????????????????????????????????????????????????????????
							If cAlias == "SE1"
								PCODetLan( "000001", "05", "FINA040" )
							Else
								PCODetLan( "000002", "05", "FINA050" )
							EndIf
							
							// Contabilizacao das MultiNat com Rateio C.Custo
							// Somente sera contabilizado se existir o LP 500/510 e o 506/508 ou
							// LP 520/530 e 536/537 se for baixa
							If lContabiliza .And. lPadrao .and. lPadraoCC .And. aColsSev[nX][4] == "1"
								VALOR 	:= SEZ->EZ_VALOR		// Valor Principal
								VALOR2	:= 0					// Irf
								VALOR3	:= 0					// Inss
								VALOR4	:= 0					// Iss
								VALOR5	:= 0					// Pis
								VALOR6	:= 0					// Cofins
								VALOR7	:= 0					// Csll
								
								// Contabiliza pelo SEZ
								If nHdlPrv <= 0
									nHdlPrv:=HeadProva(cLote,cOrigem,Substr(cUsuario,7,6),@cArquivo)
								Endif
								dbSelectArea( "SED" )
								MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
								dbSelectArea("SEZ")
								If nHdlPrv > 0
									nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
								Endif
								SEZ->(RecLock("SEZ"))
								SEZ->EZ_LA    := "S"
								MsUnlock()
								lCtbRatCC := .T.
							Endif
							
							If cAlias = "SE2" .And. lRatImpostos
								//Irrf
								If M->E2_IRRF > 0
									nCont1 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ		:= aColsSev[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatIrf[nCont][2][nCont1] // Grava o valor informado
										SEZTMP->EZ_PERC			:= SEZTMP->EZ_PERC
										ExecBlock("MULTSEZ", .F., .F., { 3, cChaveIrf })
										DbSelectArea("SEZ")
									Endif
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCIR
									SEZ->EZ_CLIFOR		:= GetMV("MV_UNIAO")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
									SEZ->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatIrf[nCont][2][nCont1] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL   	:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lContabiliza .And. lPadraoCC .And. aColsSev[nX][4] == "1"
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR		:= 0					// Valor Principal
											VALOR2	:= SEZ->EZ_VALOR		// Irf
											VALOR3	:= 0					// Inss
											VALOR4	:= 0					// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif
								
								//Pis
								If M->E2_PIS > 0
									nCont4 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ		:= aColsSev[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatPis[nCont][2][nCont4] // Grava o valor informado
										SEZTMP->EZ_PERC			:= SEZTMP->EZ_PERC
										ExecBlock("MULTSEZ", .F., .F., { 3, cChavePis })
										DbSelectArea("SEZ")
									Endif
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCPIS
									SEZ->EZ_CLIFOR		:= GetMV("MV_UNIAO")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
									SEZ->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatPis[nCont][2][nCont4] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lContabiliza .And. lPadraoCC .And. aColsSev[nX][4] == "1"
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR		:= 0					// Valor Principal
											VALOR2	:= 0					// Irf
											VALOR3	:= 0					// Inss
											VALOR4	:= 0					// Iss
											VALOR5	:= SEZ->EZ_VALOR	// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif
								
								//Cofins
								If M->E2_COFINS > 0
									nCont5 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatCof[nCont][2][nCont5] // Grava o valor informado
										SEZTMP->EZ_PERC		:= SEZTMP->EZ_PERC
										ExecBlock("MULTSEZ", .F., .F., { 3, cChaveCof })
										DbSelectArea("SEZ")
									Endif
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCCOF
									SEZ->EZ_CLIFOR		:= GetMV("MV_UNIAO")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
									SEZ->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatCof[nCont][2][nCont5] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lContabiliza .And. lPadraoCC .And. aColsSev[nX][4] == "1"
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR		:= 0					// Valor Principal
											VALOR2	:= 0					// Irf
											VALOR3	:= 0					// Inss
											VALOR4	:= 0					// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= SEZ->EZ_VALOR // Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif
								
								//CSLL
								If M->E2_CSLL > 0
									nCont6 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatIrf[nCont][2][nCont6] // Grava o valor informado
										SEZTMP->EZ_PERC		:= SEZTMP->EZ_PERC
										ExecBlock("MULTSEZ", .F., .F., { 3, cChaveCsl })
										DbSelectArea("SEZ")
									Endif
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCSLL
									SEZ->EZ_CLIFOR		:= GetMV("MV_UNIAO")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
									SEZ->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatCsl[nCont][2][nCont6] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lContabiliza .And. lPadraoCC .And. aColsSev[nX][4] == "1"
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR		:= 0					// Valor Principal
											VALOR2	:= 0					// Irf
											VALOR3	:= 0					// Inss
											VALOR4	:= 0					// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= SEZ->EZ_VALOR	// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif
								
								If M->E2_INSS > 0
									nCont2 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ		:= aColsSev[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatIns[nCont][2][nCont2] // Grava o valor informado
										SEZTMP->EZ_PERC		:= SEZTMP->EZ_PERC
										ExecBlock("MULTSEZ", .F., .F., { 3, cChaveIns })
										DbSelectArea("SEZ")
									Endif
									
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCINS
									SEZ->EZ_CLIFOR		:= GetMv("MV_FORINSS")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= MVINSS
									SEZ->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatIns[nCont][2][nCont2] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL   	:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lContabiliza .And. lPadraoCC .And. aColsSev[nX][4] == "1"
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR 	:= 0					// Valor Principal
											VALOR2  := 0					// Irf
											VALOR3  := SEZ->EZ_VALOR		// Inss
											VALOR4  := 0					// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif
								If M->E2_ISS > 0
									nCont3 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ		:= aColsSev[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatIss[nCont][2][nCont3] // Grava o valor informado
										SEZTMP->EZ_PERC		:= SEZTMP->EZ_PERC
										ExecBlock("MULTSEZ", .F., .F., { 3, cChaveIss })
										DbSelectArea("SEZ")
									Endif
									
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCISS
									SEZ->EZ_CLIFOR		:= GetMV("MV_MUNIC")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= MVISS
									SEZ->EZ_NATUREZ	:= aColsSev[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatIss[nCont][2][nCont3] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL   	:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lContabiliza .And. lPadraoCC .And. aColsSev[nX][4] == "1"
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR 	:= 0					// Valor Principal
											VALOR2  := 0					// Irf
											VALOR3  := 0					// Inss
											VALOR4  := SEZ->EZ_VALOR		// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif
							Endif
						ElseIf SEZTMP->EZ_RECNO > 0
							
							SEZ->(DbGoto(SEZTMP->EZ_RECNO))
							
							//?????????????????????????????????????????????????????????????????????????????????Ŀ
							//? Apaga o lancamento no PCO com os dados de multi-natureza x centro de custo (05) ?
							//???????????????????????????????????????????????????????????????????????????????????
							If cAlias == "SE1"
								PCODetLan( "000001", "05", "FINA040", .T. )
							Else
								PCODetLan( "000002", "05", "FINA050", .T. )
							EndIf
							
							SEZ->(RecLock("SEZ",.F.))
							SEZ->(DbDelete())
							SEZ->(MsUnlock())
							
							If lGrvSez
								ExecBlock("MULTSEZ", .F., .F., { 3, SEZ->EZ_PREFIXO +;
								SEZ->EZ_NUM + SEZ->EZ_PARCELA + SEZ->EZ_TIPO + SEZ->EZ_CLIFOR +;
								SEZ->EZ_LOJA })
								DbSelectArea("SEZ")
							Endif
						Endif
						
						dbSelectArea("SEZTMP")
						DbSkip()
					Enddo
				Endif
				//Informo contabilizacao para SEV - Multi Naturezas
				dbSelectArea("SEV")
				If nTotal > 0
					RecLock("SEV")
					SEV->EV_LA    := "S"
					MsUnlock()
				Endif
				(cAlias)->(RestArea(aArea1))
			Endif
			If cAlias == "SE2"
				aDadosTit := {	(cAlias)->&(cCampo + "_PREFIXO"),;
				(cAlias)->&(cCampo + "_NUM"),;
				SE2->E2_PARCIR,;
				SE2->E2_PARCPIS,;
				SE2->E2_PARCCOF,;
				SE2->E2_PARCSLL,;
				SE2->E2_PARCINS,;
				SE2->E2_PARCISS,;
				SE2->E2_TIPO }
			Endif
			// Contabilizacao das MultiNat sem Rateio C.Custo
			If lContabiliza .And. lPadrao .And. !lCtbRatCC
				// Antes de desposicionar o SE2, copia o Historico para a vari?vel StrLctPad, de
				// forma que o hist?rico do SE2 possa ser utilizado na contabilizacao de
				// multiplas naturezas.
				StrLctPad := If(cAlias=="SE2",SE2->E2_HIST,"")
				// Desposiciona para nao contabilizar pelo SE1/SE2, para nao duplicar o
				// LP caso utilize SE1/SE2->Valor
				// A sintaxe do LP deve ser:
				// If(Se1/Se2->E2/E2_Multnat#"2",SEV->EV_VALOR,Se1/S22->_E1/E2_Valor)
				// ou SE1/SE2->E1/E2_Valor.
				DbSelectArea(cAlias)
				DbGoBottom()
				DbSkip()
				// Contabiliza pelo SEV
				If nHdlPrv <= 0
					nHdlPrv:=HeadProva(cLote,cOrigem,Substr(cUsuario,7,6),@cArquivo)
				Endif
				dbSelectArea( "SED" )
				MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
				dbSelectArea("SEV")
				If nHdlPrv > 0
					VALOR 	:= SEV->EV_VALOR		// Valor Principal
					VALOR2	:= 0					// Irf
					VALOR3	:= 0					// Inss
					VALOR4	:= 0					// Iss
					VALOR5	:= 0					// Pis
					VALOR6	:= 0					// Cofins
					VALOR7	:= 0					// Csll
					
					nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
				Endif
				If nTotal > 0
					RecLock("SEV")
					SEV->EV_LA    := "S"
					MsUnlock()
				Endif
			Endif
			If cAlias = "SE2" .And. lRatImpostos
				//Irrf
				If M->E2_IRRF > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveIrf,;
						aRatIrf[nX][1],;
						Val(aColsSev[nX][3]) / 100,;
						aColsSev[nX][1] })
						DbSelectArea("SEV")
					Endif
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := aDadosTit[1]
					SEV->EV_NUM      := aDadosTit[2]
					SEV->EV_PARCELA  := aDadosTit[3]
					SEV->EV_CLIFOR   := GetMV("MV_UNIAO")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := Iif(aDadosTit[9] $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
					SEV->EV_NATUREZ  := aColsSev[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatIrf[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aColsSev[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aColsSev[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao
					
					If lContabiliza .And. lPadrao .And. !lCtbRatCC .And. aColsSev[nX][4] != "1"
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2	:= SEV->EV_VALOR	// Irf
							VALOR3	:= 0					// Inss
							VALOR4	:= 0					// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif
						If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
					Endif
					SEV->(MsUnlock())
				Endif
				
				//Pis
				If M->E2_PIS > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChavePis,;
						aRatIrf[nX][1],;
						Val(aColsSev[nX][3]) / 100,;
						aColsSev[nX][1] })
						DbSelectArea("SEV")
					Endif
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := aDadosTit[1]
					SEV->EV_NUM      := aDadosTit[2]
					SEV->EV_PARCELA  := aDadosTit[4]
					SEV->EV_CLIFOR   := GetMV("MV_UNIAO")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := Iif(aDadosTit[9] $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
					SEV->EV_NATUREZ  := aColsSev[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatPIS[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aColsSev[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aColsSev[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao
					
					If lContabiliza .And. lPadrao .And. !lCtbRatCC .And. aColsSev[nX][4] != "1"
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2	:= 0					// Irf
							VALOR3	:= 0					// Inss
							VALOR4	:= 0					// Iss
							VALOR5	:= SEV->EV_VALOR	// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif
						If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
					Endif
					SEV->(MsUnlock())
				Endif
				
				//Cofins
				If M->E2_COFINS > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveCof,;
						aRatIrf[nX][1],;
						Val(aColsSev[nX][3]) / 100,;
						aColsSev[nX][1] })
						DbSelectArea("SEV")
					Endif
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := aDadosTit[1]
					SEV->EV_NUM      := aDadosTit[2]
					SEV->EV_PARCELA  := aDadosTit[5]
					SEV->EV_CLIFOR   := GetMV("MV_UNIAO")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := Iif(aDadosTit[9] $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
					SEV->EV_NATUREZ  := aColsSev[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatCOF[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aColsSev[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aColsSev[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao
					
					If lContabiliza .And. lPadrao .And. !lCtbRatCC .And. aColsSev[nX][4] != "1"
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR		:= 0					// Valor Principal
							VALOR2	:= 0					// Irf
							VALOR3	:= 0					// Inss
							VALOR4	:= 0					// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= SEV->EV_VALOR	// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif
						If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
					Endif
					SEV->(MsUnlock())
				Endif
				
				//CSLL
				If M->E2_CSLL > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveCSL,;
						aRatIrf[nX][1],;
						Val(aColsSev[nX][3]) / 100,;
						aColsSev[nX][1] })
						DbSelectArea("SEV")
					Endif
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := aDadosTit[1]
					SEV->EV_NUM      := aDadosTit[2]
					SEV->EV_PARCELA  := aDadosTit[6]
					SEV->EV_CLIFOR   := GetMV("MV_UNIAO")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := Iif(aDadosTit[9] $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
					SEV->EV_NATUREZ  := aColsSev[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatCSL[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aColsSev[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aColsSev[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao
					
					If lContabiliza .And. lPadrao .And. !lCtbRatCC .And. aColsSev[nX][4] != "1"
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2	:= 0					// Irf
							VALOR3	:= 0					// Inss
							VALOR4	:= 0					// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= SEV->EV_VALOR	// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif
						If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
					Endif
					SEV->(MsUnlock())
				Endif
				
				If M->E2_INSS > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveIns,;
						aRatIns[nX][1],;
						Val(aColsSev[nX][3]) / 100,;
						aColsSev[nX][1] })
						DbSelectArea("SEV")
					Endif
					
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := aDadosTit[1]
					SEV->EV_NUM      := aDadosTit[2]
					SEV->EV_PARCELA  := aDadosTit[7]
					SEV->EV_CLIFOR   := GetMv("MV_FORINSS")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := MVINSS
					SEV->EV_NATUREZ  := aColsSev[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatIns[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aColsSev[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aColsSev[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao
					
					If lContabiliza .And. lPadrao .And. !lCtbRatCC .And. aColsSev[nX][4] != "1"
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2  := 0					// Irf
							VALOR3  := SEV->EV_VALOR		// Inss
							VALOR4  := 0					// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif
						If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
					Endif
					SEV->(MsUnlock())
				Endif
				If M->E2_ISS > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveIss,;
						aRatIss[nX][1],;
						Val(aColsSev[nX][3]) / 100,;
						aColsSev[nX][1] })
						DbSelectArea("SEV")
					Endif
					
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := aDadosTit[1]
					SEV->EV_NUM      := aDadosTit[2]
					SEV->EV_PARCELA  := aDadosTit[8]
					SEV->EV_CLIFOR   := GetMV("MV_MUNIC")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := MVISS
					SEV->EV_NATUREZ  := aColsSev[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatIss[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aColsSev[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aColsSev[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao
					
					If lContabiliza .And. lPadrao .And. !lCtbRatCC .And. aColsSev[nX][4] != "1"
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2  := 0					// Irf
							VALOR3  := 0					// Inss
							VALOR4  := SEV->EV_VALOR		// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif
						If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
					Endif
					SEV->(MsUnlock())
				Endif
			Endif
			If lContabiliza .And. lPadrao .And. !lCtbRatCC
				(cAlias)->(RestArea(aArea1))
			Endif
		Endif
	Next
	
	//Se existir temporario para rateio c. custo, deleta
	If Select("SEZTMP") > 0 .And. !lDesdobr
		dbSelectArea("SEZTMP")
		dbCloseArea()
		Ferase(cArqSez+GetDBExtension())
		Ferase(cArqSez+OrdBagExt())
	Endif
	
	RestArea(aArea)
	(cAlias)->(RestArea(aArea1))
	
	Return .T.
	/*/
	?????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????Ŀ??
	???Fun??o	 ?PesPict   ? Autor ? Marcel Borges Ferreira? Data ? 19/07/07 ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	???Descri??o ?Pesquisa picture no SX3												  ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	???Sintaxe	 ?PesPict(campo)														     ???
	?????????????????????????????????????????????????????????????????????????Ĵ??
	??? Uso		 ?FINXFUN()      															  ???
	??????????????????????????????????????????????????????????????????????????ٱ?
	?????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????????
	/*/
	Static Function PesPict(cCampo)
	Local aArea := GetArea()
	Local cPic := ""
	
	SX3->(DbSetOrder(2))
	If SX3->(DbSeek(cCampo)) .and. !Empty(SX3->X3_PICTURE)
		cPic := Trim(SX3->X3_PICTURE)
	Else
		cPic := "@E 999.99"
	EndIf
	
	RestArea(aArea)
	Return cPic
	
