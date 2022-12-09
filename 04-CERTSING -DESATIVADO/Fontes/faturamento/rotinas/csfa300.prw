//-----------------------------------------------------------------------
// Rotina | CSFA300      | Autor | Robson Luiz - Rleg | Data | 26.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de manutenção em lote nos registros da tabela de 
//        | movimentos de comissão (SZ6).
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSFA300()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro := 'Movimentos de Comissão - Manutenção em Lote'
	
	AAdd( aSay, 'Este programa permite que seja efetuado manutenção em lote nos registros da tabela' )
	AAdd( aSay, 'de movimentos de comissão.' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		A300Def()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A300Def      | Autor | Robson Luiz - Rleg | Data | 26.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de definição de campos.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A300Def()
	Local aPar := {}
	Local aRet := {}
	Local aAux := {}
	Local bValid := {|| .T. }
	
	Private aCOLS := {}
	Private aHeader := {}

	AAdd( aPar,{ 1, 'Periodo   ' , Space(6) , '', ''                     , '', '', 50, .T. } )
	AAdd( aPar,{ 1, 'Código Ent. De' , Space(6) , '', ' '				     , '', '', 50, .F. } )
	AAdd( aPar,{ 1, 'Código Ent. Ate', Space(6) , '', '(mv_par03>=mv_par02)' , '', '', 50, .F. } ) 
	AAdd( aPar,{ 1, 'Ped.Gar De', Space(7) , '', ' '				     , '', '', 50, .F. } )
	AAdd( aPar,{ 1, 'Ped.Gar Ate', Space(7), '', '(mv_par05>=mv_par04)' , '', '', 50, .F. } )
	AAdd( aPar,{ 1, 'Grupo De'   , Space(20), '', ' '				     , '', '', 50, .F. } )
	AAdd( aPar,{ 1, 'Grupo Ate'  , Space(20), '', '(mv_par07>=mv_par06)', '', '', 50, .F. } )
	AAdd( aPar,{ 1, 'Produto De' , Space(30), '', ' '				     , '' , '', 50, .F. } )
	AAdd( aPar,{ 1, 'Produto Ate', Space(30), '', '(mv_par09>=mv_par08)', '', '', 50, .F. } )
	AAdd( aPar,{ 1, 'CCR De' 	 , Space(6) , '', ' '				     , 'SZ3CCR' , '', 50, .F. } )
	AAdd( aPar,{ 1, 'CRR Ate'    , Space(6) , '', '(mv_par11>=mv_par10)', 'SZ3CCR', '', 50, .F. } )
	aAdd( aPar,{ 2  ,"Tipo"      ,2         , {" ","Hardware", "Software"}      , 50,'.T.',.T.})
    aAdd( aPar,{ 1, 'Valor Prod.',0,"@E 9,999.99",,"","",20,.F.})
    aAdd( aPar,{ 1  ,"Dt. Pedido",Ctod(Space(8)),"","","","",50,.F.})
    AAdd( aPar,{ 1, 'Ped.Site De', Space(7) , '', ' '				     , '', '', 50, .F. } )
	AAdd( aPar,{ 1, 'Ped.Site Ate', Space(7), '', '(mv_par16>=mv_par15)' , '', '', 50, .F. } )
	aAdd( aPar,{ 2  ,"Tipo Entidade",2         , {" ","Canal", "AC","Posto","Federacao","Campanha Contador","Clube Revendedor"}      , 50,'.T.',.T.})

	If ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CSF300" , .T., .F. )
		
		AAdd( aHeader, { 'Item', 'GD_ITEM'  , '@!', 04, 0, 'AllWaysTrue', '', 'C', '', 'V'} )
		
		aAux := APBuildHeader('SZ6')
		
		ADel(aAux,AScan( aAux, {|e| RTrim(e[2])=='Z6_LOG300'}))
		ASize(aAux,Len(aAux)-1)
		
		AEval(aAux,{|e| AAdd(aHeader,AClone(e))})
		
		AAdd( aHeader, { 'RecNo','GD_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
		AAdd( aHeader, { 'Mark' ,'GD_MARK'  , '@!',  1, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
		
		FWMsgRun(,{|| A300Data(aRet)},,'Aguarde, buscando dados...')
		
		If Len(aCOLS)>0
			A300Show()
		Else
			MsgInfo('Não foi possível encontrar dados com os parâmetros informados.',cCadastro)
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A300Data     | Autor | Robson Luiz - Rleg | Data | 26.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para buscar os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A300Data(aRet)
	Local nI 		:= 0
	Local nElem 	:= 0
	Local cCodEnt 	:= ""
	
	Local cSQL 		:= ''
	Local cTRB 		:= ''
	
	cSQL := " SELECT "
	
	For nI := 1 To Len(aHeader)
		If .NOT.(aHeader[nI,2] $ 'GD_ITEM|GD_RECNO|GD_MARK')
			cSQL += RTrim(aHeader[nI,2])+", "
		Endif
	Next nI 
	
	//Retorna o Tipo de entidade alterada.
	If !Empty(aRet[17]) .And. ValType(aRet[17]) <> "N"
	
		If aRet[17] = "Canal"
			cCodEnt := "1" //Canal
		ElseIf aRet[17] == "AC"
			cCodEnt := "2" //AC
		ElseIf aRet[17] == "Posto"
			cCodEnt := "4" //Posto
		ElseIf aRet[17] == "Campanha Contador"
			cCodEnt := "7" //Campanha Contador
		ElseIf aRet[17] == "Federação"
			cCodEnt := "8" //Federação
		ElseIf aRet[17] == "Clube do Revendedor"
			cCodEnt := "10" //Clube do Revendedor
		EndIf
	
	Else
		cCodEnt := "1" 
	EndIf
	
	cSQL := cSQL + "SZ6.R_E_C_N_O_ AS Z6_RECNO"
	cSQL += " FROM   "+RetSqlName('SZ6')+" SZ6 "
	cSQL += " LEFT JOIN  " + RetSQLName("SZ3") + "  SZ3 ON SZ3.Z3_FILIAL = ' ' AND SZ6.Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' ' "
	cSQL += " WHERE  Z6_FILIAL = "+ValToSql(xFilial('SZ6'))+" "
	cSQL += "       AND SZ6.Z6_PERIODO = "+ValToSql(aRet[1])
	If !Empty(aRet[2])
		cSQL += "       AND SZ6.Z6_CODENT BETWEEN "+ValToSql(aRet[2])+" AND "+ValToSql(aRet[3])
	EndIf
	If !Empty(aRet[4])
		cSQL += "       AND SZ6.Z6_PEDGAR BETWEEN "+ValToSql(aRet[4])+" AND "+ValToSql(aRet[5])
	EndIf
	If !Empty(aRet[6])
		cSQL += "       AND SZ6.Z6_GRUPO  BETWEEN "+ValToSql(aRet[6])+" AND "+ValToSql(aRet[7])
	EndIf
	If !Empty(aRet[9])
	cSQL += "       AND SubStr(SZ6.Z6_PRODUTO,1,"+Str(Len(AllTrim(aRet[9])))+") BETWEEN "+ValToSql(AllTrim(aRet[8]))+" AND "+ValToSql(AllTrim(aRet[9]))
	EndIf
	If !Empty(aRet[10])
		cSQL += "       AND SZ3.Z3_CODCCR BETWEEN "+ValToSql(aRet[10])+" AND "+ValToSql(aRet[11])
	EndIf
	If !Empty(aRet[12])
		cSQL += "       AND SZ6.Z6_CATPROD = "+ValToSql(Iif(aRet[12] == 2,"1","2"))
	EndIf 
	If aRet[13] > 0
		cSQL += "       AND SZ6.Z6_VLRPROD = "+Str(aRet[13])
	EndIf 
	If !Empty(aRet[14])
		cSQL += "       AND SZ6.Z6_DTPEDI = " +ValToSql(DtoS(aRet[14]))
	EndIf
	If !Empty(aRet[15])
		cSQL += "       AND SZ6.Z6_PEDSITE BETWEEN "+ValToSql(aRet[15])+" AND "+ValToSql(aRet[16])
	EndIf 
	If !Empty(aRet[17])
		cSQL += "       AND SZ6.Z6_TPENTID = '"+ cCodEnt + "' "
	EndIf 	
	cSQL += "       AND SZ6.D_E_L_E_T_ = ' ' "
	       
	cTRB := GetNextAlias()
	PLSQuery(cSQL,cTRB)
	
	While (cTRB)->(.NOT. EOF())
	   AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
	   nElem := Len( aCOLS )
	   For nI := 1 To Len( aHeader )
	   	If aHeader[nI,2]=='GD_ITEM'
	   		aCOLS[ nElem, nI ] := RTrim(StrZero(nElem,4,0))
	   	Elseif aHeader[nI,2]=='GD_RECNO'
	   		aCOLS[ nElem, nI ] := (cTRB)->(Z6_RECNO)
	   	Elseif aHeader[nI,2]=='GD_MARK'
	   		aCOLS[ nElem, nI ] := 0
	   	Else
		   	If aHeader[nI,10] <> 'V'
		   		aCOLS[ nElem, nI ] := (cTRB)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
		   	Endif
	   	Endif
		Next nI
		aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
		(cTRB)->(dbSkip())
	End
	(cTRB)->(dbCloseArea())
Return
   
//-----------------------------------------------------------------------
// Rotina | A300Show     | Autor | Robson Luiz - Rleg | Data | 26.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A300Show()
	Local nI := 0
	Local nL := 2
	Local nCol := 0
	Local nRow := 0
	Local oDlg
	Local oPanel
	Local aButton := {}
	Local cOK := 'AllWaysTrue'
	
	Private oGride 
	Private aField := {}
	Private aTitle := {}
	
	For nI := 1 To Len( aHeader )
		If (AllTrim(aHeader[nI,2]) $ 'Z6_VLRPROD|Z6_BASECOM|Z6_VALCOM|Z6_CODENT|Z6_DESENT|Z6_GRUPO|Z6_DESGRU|Z6_CODAC|Z6_CODCCR|Z6_CODCAN|Z6_DESGRU')
			AAdd(aTitle,aHeader[nI,1])
			AAdd(aField,aHeader[nI,2])                             
			
		Endif
	Next nI

	AAdd( aButton, { '&Pesquisar <F5>', '{|| GdSeek(oGride,,aHeader,aCOLS,.F.) }' , 116 } )
	AAdd( aButton, { '&Manusear <F6>' , '{|| A300Manusear() }' , 117 } )	
	AAdd( aButton, { '&Gravar <F7>'   , '{|| Iif(A300Grava(),(oDlg:End()),NIL) }' , 118 } )	
	AAdd( aButton, { '&Sair <F11>'    , '{|| Iif( MsgYesNo("Deseja realmente sair da rotina?", cCadastro ), oDlg:End(), NIL ) }' , 122 } )
	
	oMainWnd:ReadClientCoors()
	nCol := oMainWnd:nClientWidth
	nRow := oMainWnd:nClientHeight
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 00,00 TO nRow-34,nCol-8 PIXEL
		oDlg:lMaximized := .T.
		
		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,18,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_TOP
		
		For nI := 1 To Len( aButton )			
			SetKey( aButton[nI, 3], &(aButton[nI,2]) )
			TButton():New(3,nL,aButton[nI,1],oPanel,&(aButton[nI,2]),56,12,,,.F.,.T.,.F.,,.F.,,,.F.)
			nL += 60
		Next nI
		
		oGride := MsNewGetDados():New( 012, 002, 120, 265, 0, cOK, cOK, '', {}, 0, Len(aCOLS), '', '', '', oDlg, aHeader, aCOLS )
		oGride:oBrowse:nFreeze := 1
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	ACTIVATE MSDIALOG oDlg
	
	AEval( aButton, {|p| SetKey( p[ 3 ], NIL ) } )
Return

//-----------------------------------------------------------------------
// Rotina | A300Manusear | Autor | Robson Luiz - Rleg | Data | 26.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para manipular os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A300Manusear()	
	Local bValid := {|| MsgYesNo('Confirma a substituição dos dados confome informado nos parâmetros?',cCadastro)}
	
	Local aPar := {}
	Local aRet := {}
	
	Local cNOME_CPO := ''
	Local nP_CAMPO := 0
	Local nGD_ITEM := 0
	Local nGD_MARK := 0
		
	AAdd(aPar,{2,'Campo',1,aTitle,120,'',.T.})
	AAdd(aPar,{1,'Substituir por',Space(20),'','','','',120,.F.})
	AAdd(aPar,{1,'A partir do item',Space(4),'','','','',30,.T.})
	AAdd(aPar,{1,'Até o item',Space(4),'','(mv_par04>=mv_par03)','','',30,.T.})
	
	If ParamBox( aPar, 'Substituição', @aRet, bValid, , , , , , , .F., .F. )
		If ValType(aRet[1])=='N'
			cNOME_CPO := aField[aRet[1]]
		Else
			cNOME_CPO := aHeader[AScan(aHeader,{|e| e[2]==aField[AScan(aTitle,{|e| e==aRet[1]})]}),2]
		Endif 
		
		nP_CAMPO := AScan(aHeader,{|e| e[2]==cNOME_CPO})
		cTIPO := aHeader[nP_CAMPO,8]
		nGD_ITEM := AScan(aHeader,{|e| e[2]=='GD_ITEM'})
		nGD_MARK := AScan(aHeader,{|e| e[2]=='GD_MARK'})
		
		FWMsgRun(,{|| A300Update(aRet,nGD_ITEM,nGD_MARK,nP_CAMPO,cTIPO)},,'Atualizando...')		
	Endif	
Return

//-----------------------------------------------------------------------
// Rotina | A300Update   | Autor | Robson Luiz - Rleg | Data | 26.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para atualizar o dado no aCOLS.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A300Update(aRet,nGD_ITEM,nGD_MARK,nP_CAMPO,cTIPO)
	Local nI := 0
	Local nProd   := AScan(aHeader,{|e| e[2]=="Z6_PRODUTO"})
	Local nPosto  := AScan(aHeader,{|e| e[2]=="Z6_CODENT "})
	Local nCatPro := AScan(aHeader,{|e| e[2]=="Z6_CATPROD"})
	Local nValProd:= AScan(aHeader,{|e| e[2]=="Z6_VLRPROD"})
	Local nCodAc  := AScan(aHeader,{|e| e[2]=="Z6_REDE   "})
	Local nCodCCR := AScan(aHeader,{|e| e[2]=="Z6_CODCCR "})
	Local nDesCCR := AScan(aHeader,{|e| e[2]=="Z6_CCRCOM "})
	Local cCodPos := ""
	Local cCateg:= ""
	Local nPorce  := 0
	Local nValBas := AScan(aHeader,{|e| e[2]=="Z6_BASECOM"})
	Local nValCom := AScan(aHeader,{|e| e[2]=="Z6_VALCOM "})
	For nI := 1 To Len(oGride:aCOLS)
		If oGride:aCOLS[nI,nGD_ITEM] >= aRet[3] .And. oGride:aCOLS[nI,nGD_ITEM] <= aRet[4]
		
				If AllTrim(oGride:aHeader[nP_CAMPO,2]) == "Z6_CODCCR"
					DbSelectArea("SZ3")
					DbSetOrder(1)
					If DbSeek( xFilial("SZ3") + oGride:aCOLS[nI,nCodCCR])
						oGride:aCOLS[nI,nDesCCR] := SZ3->Z3_DESENT
					EndIf
						
				EndIf
		
				If AllTrim(oGride:aHeader[nP_CAMPO,2]) == "Z6_VLRPROD" .Or. AllTrim(oGride:aHeader[nP_CAMPO,2]) =="Z6_CODCCR"
					
					DbSelectArea("PA8")
					DbSetOrder(1)		// PA8_FILIAL + PA8_CODBPG
					If DbSeek( xFilial("PA8") + oGride:aCOLS[nI,nProd] ) 
						cCateg := PA8->PA8_CATPRO
					Else
						cCateg := "01"
					EndIf
					
					DbSelectArea("SZ3")
					DbSetOrder(1)
					DbSeek( xFilial("SZ3") + oGride:aCOLS[nI,nPosto])
					
					If !Empty(SZ3->Z3_CODCCR)
						cCodPos := SZ3->Z3_CODCCR
					ElseIf !Empty(SZ3->Z3_CODAC)
						cCodPos := SZ3->Z3_CODAC
					Else
						cCodPos := oGride:aCOLS[nI,nPosto]
					EndIf
					
					DbSelectArea("SZ4")
					DbSetOrder(1)	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
					If DbSeek( xFilial("SZ4") + cCodPos + cCateg ) 	
					
						If oGride:aCOLS[nI,nCatPro] == "2"
							
							oGride:aCOLS[nI,nValBas] := oGride:aCOLS[nI,nValProd] - (oGride:aCOLS[nI,nValProd] * SZ4->Z4_IMPSOFT / 100)
							nPorce := SZ4->Z4_PORSOFT / 100
							
						Else
						
							oGride:aCOLS[nI,nValBas] := oGride:aCOLS[nI,nValProd] - (oGride:aCOLS[nI,nValProd] * SZ4->Z4_IMPHARD / 100)
							nPorce := SZ4->Z4_PORHARD / 100
							
						EndIf
						oGride:aCOLS[nI,nValBas] := oGride:aCOLS[nI,nValProd] - (oGride:aCOLS[nI,nValProd] * SZ4->Z4_PORIR / 100)
						oGride:aCOLS[nI,nValCom] := oGride:aCOLS[nI,nValBas] * nPorce
						
						
					Else
					
						oGride:aCOLS[nI,nValBas] := oGride:aCOLS[nI,nP_CAMPO]
						oGride:aCOLS[nI,nValCom] := 0
					
					EndIf
								
						
				EndIf
			If cTIPO=='N'
				oGride:aCOLS[nI,nP_CAMPO] := Val(aRet[2])
			Elseif cTIPO=='D'
				oGride:aCOLS[nI,nP_CAMPO] := Ctod(aRet[2])
			Else
				oGride:aCOLS[nI,nP_CAMPO] := RTrim(aRet[2])
				If AllTrim(oGride:aHeader[nP_CAMPO,2]) == "Z6_CODAC"
				
					DbSelectArea("SZ3")
					DbSetOrder(1)
					DbSeek( xFilial("SZ3") + oGride:aCOLS[nI,nP_CAMPO])
					oGride:aCOLS[nI,nCodAc] := SZ3->Z3_DESENT
					
				EndIf
			Endif
			oGride:aCOLS[nI,nGD_MARK] := 1
		Endif
	Next nI
	oGride:Refresh()
	MsgInfo('Dados substituídos.',cCadastro)
Return

//-----------------------------------------------------------------------
// Rotina | A300Grava    | Autor | Robson Luiz - Rleg | Data | 26.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se pode gravar os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A300Grava()
	Local nP := 0
	Local lRet := .F.
	Local nGD_MARK := AScan(aHeader,{|e| e[2]=='GD_MARK'})
	nP := AScan(oGride:aCOLS,{|e| e[nGD_MARK]==1})
	If nP > 0
		lRet := MsgYesNo('Confirma o processamento da gravação nos dados manuseados?',cCadastro)
		If lRet
			FWMsgRun(,{|| A300Record()},,'Gravando dados, aguarde...')		
		Endif
	Else
		MsgAlert('Nenhuma alteração foi efetuada, logo não é preciso gravar.',cCadastro)
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A300Record   | Autor | Robson Luiz - Rleg | Data | 26.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gravar os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A300Record()
	Local nI := 0
	Local nJ := 0
	
	Local cLog := ''
	Local cUser := ''
	Local cAntes := ''
	Local cDepois := ''
	
	Local nGD_MARK := 0
	Local nGD_RECNO := 0
	
	cUser := RetCodUsr()
	
	nGD_MARK  := AScan(aHeader,{|e| e[2]=='GD_MARK'})
	nGD_RECNO := AScan(aHeader,{|e| e[2]=='GD_RECNO'})
	
	For nI := 1 To Len(oGride:aCOLS)
		If oGride:aCOLS[nI,nGD_MARK]==1
			SZ6->(dbGoTo(oGride:aCOLS[nI,nGD_RECNO]))
			For nJ := 1 To Len(aHeader)
				If .NOT.(aHeader[nJ,2] $ 'GD_ITEM|GD_MARK|GD_RECNO|')
					If oGride:aCOLS[nI,nJ] <> SZ6->&(aHeader[nJ,2])
						
						If aHeader[nJ,8]=='N'
							cAntes  := LTrim(Str(SZ6->&(aHeader[nJ,2])))
							cDepois := LTrim(Str(oGride:aCOLS[nI,nJ]))
						Elseif aHeader[nJ,8]=='D'
							cAntes  := Dtoc(SZ6->&(aHeader[nJ,2]))
							cDepois := Dtoc(oGride:aCOLS[nI,nJ])
						Else
							cAntes  := RTrim(SZ6->&(aHeader[nJ,2]))
							cDepois := RTrim(oGride:aCOLS[nI,nJ])
						Endif
						
						cLog := 'DT:'     + Dtoc(MsDate()) + ;
						        '-HR:'    + Time() + ;
						        '-USER:'  + cUser  + ;
						        '-FIELD:' + RTrim(aHeader[nJ,1])+'/'+aHeader[nJ,2] + CRLF + ;
						        'ANTES:'  + cAntes  + CRLF + ;
						        'DEPOIS:' + cDepois + CRLF + ;
						        '*******************************************************************************' + CRLF
						
						SZ6->(RecLock('SZ6',.F.))
						SZ6->&(aHeader[nJ,2]) := oGride:aCOLS[nI,nJ]
						SZ6->Z6_LOG300 := SZ6->Z6_LOG300 + cLog
						SZ6->(MsUnLock())
					Endif
				Endif
			Next nJ
		Endif
   Next nI
Return