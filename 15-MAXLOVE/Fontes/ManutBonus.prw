#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

User Function ManutBonus()

	Local oBrowse

	oBrowse:= FWmBrowse():New()
	oBrowse:SetDescription( "Manutenção de Bonus Vendas" )
	oBrowse:SetAlias( 'SA1' )
	oBrowse:SetOnlyFields( { 'A1_COD', 'A1_LOJA', 'A1_NOME', 'A1_EST', 'A1_CGC'} )
   	oBrowse:SetFixedBrowse(.T.)
	oBrowse:ForceQuitButton()
   	oBrowse:SetAmbiente(.T.) //Habilita a utilizaÃ§Ã£o da funcionalidade Ambiente no Browse

   //Adiciona botoes na janela
   	oBrowse:AddButton("Controle"		, { || U_CONTROLE()},,,, .F., 2 )
   	oBrowse:AddButton("Recalculo"	, { || U_RecalcBonus()},,,, .F., 2 )

	oBrowse:Activate()

  	oBrowse:Setfocus() //Seta o foco na grade


Return(.t.)

User Function Controle()

	Local aTitles2  := {OemToAnsi("Creditos"),OemToAnsi("Debitos")}

	Private aCoors 		:= FWGetDialogSize( oMainWnd )

	Private oDlgPri,oFont02,oFont01
	Private oTela,oCont0,oCont1,oCont2,oCont3,oCont4
	Private oBarSup,oIdentif,oPastas,oPanelSup,oSayLeng,oGroupId,oFoldDC
	Private oTButton1

	Private oSayCli,oSayNom,oSaySld,oSayVct
	Private oGetCli,oGetNom,oGetSld,oGetVct,oGetZAC,oGetZAD

	Private cGetCli		:= SA1->A1_COD
	Private cGetLoj		:= SA1->A1_LOJA
	Private cGetNom		:= Alltrim(SA1->A1_NOME)
	Private cGetSld		:= fVerSaldo(SA1->A1_COD,SA1->A1_LOJA)
	Private cGetVct		:= fVerVcto(SA1->A1_COD,SA1->A1_LOJA)
	
	Private nPBonus		:= SuperGetmv("MV_PBONUS",.F.,3.00) //% do bonus comercial
	Private nDiasVct	:= SuperGetmv("MV_DBONUS",.F.,365) //quantidade de dias para o vcto do bonus

	Private aCpoZAC  	:= {"ZZA_FILORI","ZZA_NFDOC","ZZA_EMISSA","ZZA_VLRLIQ","ZZA_CREDI","ZZA_VALOR","ZZA_VENCT","ZZA_TPLAN","ZZA_DESCLC","ZZA_SALDO","ZZA_OBS"}
	Private aAltZAC  	:= {"ZZA_NFDOC","ZZA_EMISSA","ZZA_VLRLIQ","ZZA_TPLAN","ZZA_OBS"}
	Private aHeadZAC 	:= RetHeader(aCpoZAC)
	Private aColsZAC 	:= RetCols(aHeadZAC)

	Private aCpoZAD  	:= {"ZZA_NFDOC","ZZA_EMISSA","ZZA_TPLAN","ZZA_DESCLC","ZZA_VALOR","ZZA_OBS","ZZA_ATUSLD","ZZA_GERNCC","ZZA_STATUS"}
	Private aAltZAD  	:= {"ZZA_NFDOC","ZZA_EMISSA","ZZA_VALOR","ZZA_TPLAN","ZZA_OBS"}
	Private aHeadZAD 	:= RetHeader(aCpoZAD)
	Private aColsZAD 	:= RetCols(aHeadZAD)

	Private bLinOk 		:= {|| flinOk()} 
	Private bLinDel 	:= {|| fLinDel()} 
	Private bVldCpo 	:= {|| fValidCpo()} 
	Private bChange 	:= {|| fSeqDocto()} 
	Private bSuperDel 	:= {|| Alert("SuperDel")} 


	DEFINE FONT oFont02  NAME "Arial" SIZE 0,15  BOLD
	DEFINE FONT oFont01  NAME "Arial" SIZE 0,42  BOLD
	
	oDlgPri := TDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],"Controle Bonus",,,,,,,,,.T.,,,,,) 


		oTela := FWFormContainer():New( oDlgPri )

		oCont0 := oTela:createVerticalBox( 15 )
		oCont1 := oTela:createVerticalBox( 85 )

		oCont2 := oTela:createHorizontalBox( 25,oCont1 )
		oCont3 := oTela:createHorizontalBox( 70,oCont1 )
		oCont4 := oTela:createHorizontalBox( 05,oCont1 )

		oTela:Activate( oDlgPri, .F. )

		oBarSup 	:= oTela:GetPanel( oCont0 )
		oIdentif 	:= oTela:GetPanel( oCont2 )
		oPastas 	:= oTela:GetPanel( oCont3 )

		oPanelSup 	:= tPanel():New(01,03,"",oBarSup,,,,,RGB(160,183,237),((oBarSup:nRight - oBarSup:nLeft) / 2) - 5,((oBarSup:nBottom - oBarSup:nTop) / 2)-15,.t.,.F.)

		oSayLeng := TSay():New( 010,005 ,{||"LEGENDA"} ,oPanelSup,,oFont02,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,100,050)
		//Legenda()

		oTButton1 	:= TButton():New( ((oBarSup:nBottom - oBarSup:nTop)/2)-040, 03, "Salvar/Sair"   			,oPanelSup,{||GravaZZA(.t.),oDlgPri:End()}		,((oBarSup:nRight - oBarSup:nLeft) / 2) - 15,15,,oFont02,.F.,.T.,.F.,,.F.,,,.F. ) 
	
		oGroupId	:= TGroup():New(01,01,((oIdentif:nBottom - oIdentif:nTop) / 2) ,((oIdentif:nRight - oIdentif:nLeft) / 2) - 5,'',oIdentif,,,.T.)
		IdentId()

		oFoldDC 	:= TFolder():New(oPastas:nTop,oPastas:nLeft,aTitles2,{"HEADER"},oPastas,1,,, .T., .F.,((oPastas:nRight - oPastas:nLeft) / 2) - 7,((oPastas:nBottom - oPastas:nTop) / 2) - 3,)
		fDadosDC()

	oDlgPri:Activate(,,,.T.)



Return()


Static Function IdentId()

   	    	
    	@ 010, 015 SAY 		oSayCli  		PROMPT "Cliente :" 				SIZE 025, 007 OF oGroupId COLORS CLR_BLUE, 16777215 PIXEL
    	@ 020, 015 MSGET 	oGetCli  		VAR cGetCli  					SIZE 060, 010 PICTURE "@!" OF oGroupId COLORS 0, 16777215 PIXEL  when .f.                                                                                            

    	@ 010, 085 SAY 		oSayNom 		PROMPT "Nome :" 				SIZE 025, 007 OF oGroupId COLORS CLR_BLUE, 16777215 PIXEL
    	@ 020, 085 MSGET 	oGetNom 		VAR cGetNom 						SIZE 200, 010 PICTURE "@!" OF oGroupId COLORS 0, 16777215 PIXEL when .f.                                                                                              


    	@ 035, 015 SAY 		oSaySld 		PROMPT "Saldo R$ :"				SIZE 035, 007 OF oGroupId COLORS CLR_BLUE, 16777215 PIXEL
    	@ 045, 015 MSGET 	oGetSld 		VAR cGetSld 						SIZE 060, 010 PICTURE "@e 999,999,999.99" OF oGroupId COLORS 0, 16777215 PIXEL when .f.                                                                                              

    	@ 035, 085 SAY 		oSayVct 		PROMPT "A Vencer 30 Dias :"	SIZE 080, 007 OF oGroupId COLORS CLR_RED, 16777215 PIXEL
    	@ 045, 085 MSGET 	oGetVct 		VAR cGetVct 						SIZE 060, 010 PICTURE "@e 999,999,999.99" OF oGroupId COLORS 0, 16777215 PIXEL when .f.                                                                                              



Return()


Static Function fDadosDC()

	Local nModo := GD_UPDATE+GD_INSERT+GD_DELETE
	Local nMaxLin := 999

	oGetZAC := MsNewGetDados():New( 2, 3,((oPastas:nBottom - oPastas:nTop) / 2)-15, ((oPastas:nRight - oPastas:nLeft) / 2) - 8 ,nModo,'Eval(bLinOk)',/*ctudoOk*/ ,/*cIniCpos*/ ,aAltZAC,0,nMaxLin,'Eval(bVldCpo)','Eval(bSuperDel)' ,'Eval(bLinDel)', oFoldDC:aDialogs[1], aHeadZAC, aColsZAC,bChange)
	oGetZAD := MsNewGetDados():New( 2, 3,((oPastas:nBottom - oPastas:nTop) / 2)-15, ((oPastas:nRight - oPastas:nLeft) / 2) - 8 ,nModo,'Eval(bLinOk)',/*ctudoOk*/ ,/*cIniCpos*/ ,aAltZAD,0,nMaxLin,'Eval(bVldCpo)','Eval(bSuperDel)' ,'Eval(bLinDel)', oFoldDC:aDialogs[2], aHeadZAD, aColsZAD,bChange)

	VerVencidos(SA1->A1_COD,SA1->A1_LOJA)
	AtuDados(SA1->A1_COD,SA1->A1_LOJA)

Return()

	
	
Static Function fVerSaldo(cCodCli,cLoja)

	Local nSaldo	:= 0


Return(nSaldo)


Static Function fVerVcto(cCodCli,cLoja)

	Local nSaldo	:= 0


Return(nSaldo)

Static Function VerVencidos(cCodCli,cLoja)

	Local cQuery 	:= ""
	Local dVencto	:= dtos(dDatabase-1)
	
	cQuery := "SELECT ZZA_FILORI,ZZA_NFDOC,ZZA_EMISSA,ZZA_VENCT,ZZA_SALDO, ZZA.R_E_C_N_O_ RECZZA "
	cQuery += " FROM "+RetSqlName("ZZA")+" ZZA "
	cQuery += " WHERE ZZA_TPDC = 'C' "
 	cQuery += "   AND ZZA_CODCLI = '"+cCodCli+"' "
 	cQuery += "   AND ZZA_LOJA = '"+cLoja+"' "
 	cQuery += "   AND ZZA_SALDO <> 0 "
 	cQuery += "   AND ZZA_VENCT <= '"+dVencto+"' "
 	cQuery += "   AND ZZA.D_E_L_E_T_ = '' "
 	cQuery += " ORDER BY ZZA_EMISSA,ZZA_NFDOC"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZZA',.T.,.T.)
	dbSelectArea( "TRBZZA" )
	DbGoTop()

	If !TRBZZA->(EOF())
		While !Eof() 

			dbSelectArea("ZZA")
			dbSetOrder(1)
			Reclock("ZZA",.T.)
				ZZA->ZZA_FILIAL := xFilial("ZZA")
				ZZA->ZZA_CODCLI	:= cCodCli
				ZZA->ZZA_LOJA	:= cLoja
				ZZA->ZZA_NFDOC	:= TRBZZA->ZZA_NFDOC
				ZZA->ZZA_TPDC	:= "D"
				ZZA->ZZA_EMISSA	:= dDataBase
				ZZA->ZZA_VLRLIQ	:= TRBZZA->ZZA_SALDO
				ZZA->ZZA_CREDI	:= 0
				ZZA->ZZA_VALOR	:= TRBZZA->ZZA_SALDO
				ZZA->ZZA_VENCT	:= dDataBase
				ZZA->ZZA_SALDO 	:= TRBZZA->ZZA_SALDO
				ZZA->ZZA_TPLAN	:= "DB0001"
				ZZA->ZZA_FILORI := TRBZZA->ZZA_FILORI
				ZZA->ZZA_STATUS := "9"
				ZZA->ZZA_ATUSLD	:= "S"
				ZZA->ZZA_GERNCC	:= "N"
				ZZA->ZZA_DESCLC := "VENCTO DE BONUS"
				ZZA->ZZA_USINC	:= upper(Alltrim(cUserName))
				ZZA->ZZA_DTINC	:= dDataBase
				ZZA->ZZA_HRINC	:= TIME()
				ZZA->ZZA_OBS	:= "Lancamento de Debito por vencto do bonus da Nota : "+TRBZZA->ZZA_NFDOC+" Emitida em : "+dtoc(stod(TRBZZA->ZZA_EMISSA))+" "
			Msunlock()

			AtuSaldo(TRBZZA->RECZZA,0,"9")

			dbSelectArea("TRBZZA")
			dbskip()		

		End
	EndIf

	TRBZZA->(dbCloseArea())


Return()

Static Function AtuDados(cCodCli,cLoja)

	Local cQuery 	:= ""
	Local nSaldo		:= 0
	
	cQuery := "SELECT ZZA_FILORI,ZZA_NFDOC,ZZA_EMISSA,ZZA_VLRLIQ,ZZA_CREDI,ZZA_VALOR,ZZA_VENCT,ZZA_TPLAN,ZZA_DESCLC,ZZA_SALDO,ZZA_ATUSLD, ZZA_STATUS, "
	cQuery += "  ISNULL(CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), ZZA_OBS)),'') ZZA_OBS " 
	cQuery += " FROM "+RetSqlName("ZZA")+" ZZA "
	cQuery += " WHERE ZZA_TPDC = 'C' "
 	cQuery += "   AND ZZA_CODCLI = '"+cCodCli+"' "
 	cQuery += "   AND ZZA_LOJA = '"+cLoja+"' "
 	cQuery += "   AND ZZA.D_E_L_E_T_ = '' "
 	cQuery += " ORDER BY ZZA_EMISSA,ZZA_NFDOC"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZZA',.T.,.T.)
	TCSetField("TRBZZA", "ZZA_EMISSA" ,"D", 8, 0 )
	TCSetField("TRBZZA", "ZZA_VENCT" ,"D", 8, 0 )
	
	dbSelectArea( "TRBZZA" )
	DbGoTop()
	bAcao:= {|| nSaldo += TRBZZA->ZZA_SALDO }
	dbEval(bAcao,,{||!Eof()},,,.T.)
	dbSelectArea("TRBZZA")
	dbGotop()
	

	If !TRBZZA->(EOF())
		aColsZAC := RetCols(aHeadZAC,"TRBZZA",.f.)
	Else
		aColsZAC := RetCols(aHeadZAC,"",.f.)
	EndIF

	oGetZAC:aCols := aColsZAC
	oGetZAC:oBrowse:nAt := 1 
	oGetZAC:oBrowse:lReadOnly := .T. //lEdit  
	oGetZAC:oBrowse:Refresh()

	cGetSld := nSaldo
	oGetSld:Refresh() 

	TRBZZA->(dbCloseArea())


	cQuery := "SELECT ZZA_FILORI,ZZA_NFDOC,ZZA_EMISSA,ZZA_VLRLIQ,ZZA_CREDI,ZZA_VALOR,ZZA_VENCT,ZZA_TPLAN,ZZA_DESCLC,ZZA_SALDO,ZZA_ATUSLD, ZZA_STATUS, ZZA_GERNCC, "
	cQuery += "  ISNULL(CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), ZZA_OBS)),'') ZZA_OBS " 
	cQuery += " FROM "+RetSqlName("ZZA")+" ZZA "
	cQuery += " WHERE ZZA_TPDC = 'D' "
 	cQuery += "   AND ZZA_CODCLI = '"+cCodCli+"' "
 	cQuery += "   AND ZZA_LOJA = '"+cLoja+"' "
 	cQuery += "   AND ZZA.D_E_L_E_T_ = '' "
 	cQuery += " ORDER BY ZZA_EMISSA,ZZA_NFDOC"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZZA',.T.,.T.)
	TCSetField("TRBZZA", "ZZA_EMISSA" ,"D", 8, 0 )
	TCSetField("TRBZZA", "ZZA_VENCT" ,"D", 8, 0 )

	If !TRBZZA->(EOF())
		aColsZAD := RetCols(aHeadZAD,"TRBZZA",.f.)
	Else
		aColsZAD := RetCols(aHeadZAD,"",.t.)
	EndIF

	oGetZAD:aCols := aColsZAD
	oGetZAD:oBrowse:nAt := 1 
	//oGetZAD:oBrowse:lReadOnly := .T. //lEdit  
	oGetZAD:oBrowse:Refresh()

	TRBZZA->(dbCloseArea())


Return()


Static Function fValidCpo()

	Local lOk 		:= .t.
	Local cCampo 	:= Alltrim(Substr(Readvar(),4))
	Local xCampo	:= &(Readvar())
	Local nPos		:= 0
	Local xBkpSld	:= cGetSld
	Local xOldVlr	:= 0
	Local xOldSld	:= ""

	//Private aCpoZAD  	:= {"ZZA_NFDOC","ZZA_EMISSA","ZZA_VALOR","ZZA_TPLAN","ZZA_DESCLC","ZZA_OBS","ZZA_ATUSLD","ZZA_GERNCC","ZZA_STATUS"}
	//Private aAltZAD  	:= {"ZZA_NFDOC","ZZA_EMISSA","ZZA_VALOR","ZZA_TPLAN","ZZA_OBS"}
	If oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_STATUS",aHeadZAD)] = "9"
		MsgInfo("Lançamento não pode ser mais alterado !!!","Atenção")
		lOk := .f.
	EndIf	
	
	If lOk
	
		If cCampo = "ZZA_TPLAN"
			If Left(xCampo,2) = "CR"
				MsgInfo("Tipo de Lançamento Invalido, Somente de Debitos !!!","Atenção")
				lOk := .f.
			EndIf
			If xCampo = "DB0001"
				MsgInfo("Tipo de Lançamento Invalido, Exclusivo Sistema !!!","Atenção")
				lOk := .f.
			EndIf
			If lOk
				dbSelectArea("ZZB")
				dbsetOrder(1)
				If dbseek(xFilial("ZZB")+xCampo)

					xOldVlr	:= oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_VALOR",aHeadZAD)]
					xOldSld	:= oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_ATUSLD",aHeadZAD)]

					If xOldVlr <> 0
						If !Empty(xOldSld)
						   	If xOldSld <> ZZB->ZZB_ATUSLD 
						   		If ZZB->ZZB_ATUSLD = "S"
						   			cGetSld -= xOldVlr
						   			oGetSld:Refresh()
                                  Else
						   			cGetSld += xOldVlr
						   			oGetSld:Refresh()
						   		EndIf
						   	EndIf
					   	EndIf
					EndIf

					oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_DESCLC",aHeadZAD)] := ZZB->ZZB_DESCRI
					oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_ATUSLD",aHeadZAD)] := ZZB->ZZB_ATUSLD
					oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_GERNCC",aHeadZAD)] := ZZB->ZZB_GERNCC
				Else
					oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_DESCLC",aHeadZAD)] := criavar("ZZA_DESCLC")
					oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_ATUSLD",aHeadZAD)] := criavar("ZZA_ATUSLD")
					oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_GERNCC",aHeadZAD)] := criavar("ZZA_GERNCC")
					lOk := .f.
				EndIf
			EndIf
		EndIf

		If cCampo = "ZZA_VALOR"
			If xCampo <> 0
				If oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_ATUSLD",aHeadZAD)] = "S"
					If xCampo > cGetSld
						MsgInfo("Saldo Insuficiente !!!","Atenção")
					    cGetSld := xBkpSld
					    oGetSld:Refresh()
						lOk := .f.
					  Else		
					    cGetSld -= (xCampo - oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_VALOR",aHeadZAD)])
					    oGetSld:Refresh()
					EndIf
				EndIf
			 Else
				//cGetSld -= (xCampo - oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_VALOR",aHeadZAD)])
				//oGetSld:Refresh()
				MsgInfo("Informe um Valor !!!","Atenção")
				lOk := .f.	
			EndIf
		EndIf

	EndIf
	

Return(lOk)

Static Function fSeqDocto()

	If oGetZAD:oBrowse:nAt > 1 .and. Empty(oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_NFDOC",aHeadZAD)])
		oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_NFDOC",aHeadZAD)] := NextDocto()
		oGetZAD:aCols[oGetZAD:oBrowse:nAt,1] := IncSt("1")
		oGetZAD:Refresh()
	EndIf

Return(.t.)

Static Function NextDocto()

	LocaL xDoctoNew := ""

	xDoctoNew := Soma1(Alltrim(GetMV("MV_BSEQDOC")),09)
	dbSelectArea("SX6")
	PutMv("MV_BSEQDOC",xDoctoNew)

Return(xDoctoNew)

Static Function fLinDel()

	Local nColDel 	:= Len(aHeadZAD)+1
	Local nVlr		:= oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_VALOR",aHeadZAD)]
	Local cAtuSld	:= oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_ATUSLD",aHeadZAD)]

	If oGetZAD:aCols[oGetZAD:oBrowse:nAt,nColDel]
		If cAtuSld = "S"
		   cGetSld -= nVlr	
		EndIf	 
	 Else	
		If cAtuSld = "S"
		   cGetSld += nVlr	
		EndIf	 
	EndIf	
	
	oGetSld:Refresh()

Return(.t.)

Static Function fLinOk()

	Local lOk := .t.

	//If oGetZAD:aCols[oGetZAD:oBrowse:nAt,GDFieldPos("ZZA_VALOR",aHeadZAD)] = 0
	//	MsgInfo("Informe um Valor !!!","Atenção")
	//	lOk := .f.
	//EndIf

Return(lOk)



Static Function GravaZZA()	

	Local nX		:= 0
	Local aAreaAtu	:= getarea()
	Local nColDel 	:= Len(aHeadZAD)+1
	Local lExec		:= .t.

	//ZZA_FILIAL+ZZA_CODCLI+ZZA_LOJA+ZZA_NFDOC+ZZA_TPDC
	//cGetCli		
	//cGetLoj
	//oGetZAD:aCols[nX,GDFieldPos("ZZA_NFDOC",aHeadZAD)]
	//oGetZAD:aCols[nX,GDFieldPos("ZZA_TPDC",aHeadZAD)]

	For nX := 1 to Len(oGetZAD:aCols)

		If !oGetZAD:aCols[nX,GDFieldPos("ZZA_STATUS",aHeadZAD)] $ "9"
			If !oGetZAD:aCols[nX][nColDel] //Não Deletado
         		dbselectArea("ZZA")
				dbSetorder(1)			
				If dbseek(xFilial("ZZA")+cGetCli+cGetLoj+oGetZAD:aCols[nX,GDFieldPos("ZZA_NFDOC",aHeadZAD)]+"D")
					Reclock("ZZA",.F.) //alteracao
			  	Else	
					Reclock("ZZA",.T.) 	//Inclusao
				EndIf
				ZZA->ZZA_FILIAL := xFilial("ZZA")
				ZZA->ZZA_CODCLI	:= cGetCli
				ZZA->ZZA_LOJA	:= cGetLoj
				ZZA->ZZA_NFDOC	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_NFDOC",aHeadZAD)]
				ZZA->ZZA_TPDC	:= "D"
				ZZA->ZZA_EMISSA	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_EMISSA",aHeadZAD)]
				ZZA->ZZA_VLRLIQ	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_VALOR",aHeadZAD)]
				ZZA->ZZA_CREDI	:= 0
				ZZA->ZZA_VALOR	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_VALOR",aHeadZAD)]
				ZZA->ZZA_VENCT	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_EMISSA",aHeadZAD)]
				ZZA->ZZA_SALDO 	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_VALOR",aHeadZAD)]
				ZZA->ZZA_TPLAN	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_TPLAN",aHeadZAD)]
				ZZA->ZZA_FILORI := cFilAnt
				ZZA->ZZA_STATUS := "1"
				ZZA->ZZA_ATUSLD	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_ATUSLD",aHeadZAD)]
				ZZA->ZZA_GERNCC	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_GERNCC",aHeadZAD)]
				ZZA->ZZA_DESCLC := oGetZAD:aCols[nX,GDFieldPos("ZZA_DESCLC",aHeadZAD)]
				ZZA->ZZA_USINC	:= upper(Alltrim(cUserName))
				ZZA->ZZA_DTINC	:= dDataBase
				ZZA->ZZA_HRINC	:= TIME()
				ZZA->ZZA_OBS	:= oGetZAD:aCols[nX,GDFieldPos("ZZA_OBS",aHeadZAD)]
				MsUnlock()
      	  	Else
         		dbselectArea("ZZF")
				dbSetorder(1)			
				If dbseek(xFilial("ZZA")+cGetCli+cGetLoj+oGetZAD:aCols[nX,GDFieldPos("ZZA_NFDOC",aHeadZAD)]+"D")
					Reclock("ZZA",.F.) 	//Exclusao
						dbdelete()	
					MsUnlock()
				EndIf
			EndIf
		EndIf

	Next nX	

	Pergunte(Padr( "RECALBONUS", LEN( SX1->X1_GRUPO ) ),.f.)
	MV_PAR01 := cGetCli
	MV_PAR02 := cGetCli
	U_RecalProc( nil ,@lExec)

	MsgInfo("Lancamentos gravados com sucesso !!!")

	RestArea(aAreaAtu)


Return()	
	
Static Function RetHeader(aCpo)

	Local aRet 	:= {}
	Local nX	:= 0


	Aadd(aRet,{	"",;
					"COR",;
					"@BMP",;
					1,;
            		0,;
            		.T.,;
            		"",;
            		"",;
            		"",;
            		"R",;
            		"",;
            		""}) //,;


	dbSelectArea("SX3")
	dbSetOrder(2)

	For nX := 1 To Len(aCpo)
		If dbSeek(aCpo[nx])
			Aadd(aRet,{	AllTrim(X3Titulo()),;
							AllTrim(SX3->X3_CAMPO),;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT,;
							SX3->X3_CBOX,;
							SX3->X3_RELACAO}) //,;
		EndIf
	Next

Return aRet



Static Function RetCols(aHead,cXAlias,lDoc)

	Local aRet 	   		:= {}
	Local nX	      	:= 0
	Local nCntFor     	:= 0
	Local dDtIni		:= ctod("18/10/2018") //ddatabase+1
	Local dDtFim		:= ctod("18/10/2018") //ddatabase+31

	Default cXAlias   	:= ""
	Default lDoc   		:= .f.

	cGetVct := 0
	
	If !Empty(cXAlias)

		dbSelectArea(cXAlias)
		While (cXAlias)->(!Eof())
			
			If (cXAlias)->ZZA_VENCT >= dDtIni .and. (cXAlias)->ZZA_VENCT <= dDtFim 
				cGetVct += (cXAlias)->ZZA_SALDO 
			EndIf		

			aAdd(aRet,Array(Len(aHead)+1))

			aRet[Len(aRet)][1]	:= IncSt((cXAlias)->ZZA_STATUS)
	
			For nCntFor	:= 2 To Len(aHead)
				dbSelectArea(cXAlias)
				aRet[Len(aRet)][nCntFor] := FieldGet(FieldPos(aHead[nCntFor][2]))
				If Alltrim(aHead[nCntFor][2]) = "ZZA_SALDO"
					If aRet[Len(aRet)][nCntFor] = 0
						aRet[Len(aRet)][1]	:= IncSt("2")
					EndIf
				EndIf
			Next nCntFor
			
			aRet[Len(aRet), Len(aHead)+1] := .F.
			(cXAlias)->(dbSkip())
	
		EndDo

		oGetVct:Refresh()

	EndIf
	
	If Empty(aRet)
		
		aAdd(aRet,Array(Len(aHead)+1))

		aRet[Len(aRet)][1]	:= IncSt("1")
	
		For nX := 2 To Len(aHead)
			If AllTrim(aHead[nX][2]) = "ZZA_NFDOC" .AND. lDoc
			 	aRet[1, nX] := NextDocto()
			 Else
				aRet[1, nX] := CriaVar(aHead[nX][2], (aHead[nX][10] <> "V") )
			EndIf
		Next nX
		
		aRet[Len(aRet), Len(aHead)+1] := .F.
	
	EndIf

Return aRet


Static Function IncSt(nStatus)
	
	Local oVerde    := LoadBitmap( GetResources(), "BR_VERDE" 	)
	Local oAmarelo 	:= LoadBitmap( GetResources(), "BR_AMARELO"	)
	Local oAzul    	:= LoadBitmap( GetResources(), "BR_AZUL" 	)
	Local oCinza    := LoadBitmap( GetResources(), "BR_CINZA" 	)
	Local oBranco  	:= LoadBitmap( GetResources(), "BR_BRANCO" 	)
	Local oPreto	:= LoadBitmap( GetResources(), "BR_PRETO" 	)
	Local oLaranja 	:= LoadBitmap( GetResources(), "BR_LARANJA" 	)
	Local oVermelho := LoadBitmap( GetResources(), "BR_VERMELHO"	)
	Local oBmp

	If nStatus = "1"	
		oBmp := oVerde
	ElseIf nStatus = "0"	
		oBmp := oAzul
	ElseIf nStatus = "2"	
		oBmp := oVermelho
	ElseIf nStatus = "3"	
		oBmp := oLaranja
	ElseIf nStatus = "9"	
		oBmp := oPreto
	ElseIf nStatus = "5"	
		oBmp := oAmarelo
	ElseIf nStatus = "6"	
		oBmp := oBranco
	ElseIf nStatus = "7"	
		oBmp := oCinza
	Endif	

	
Return(oBmp)




User Function CADZZB()


	Private cCadastro := "Tipos Lancamentos Bonus"

	Private aRotina := { 	{"Pesquisar"	,"AxPesqui",0,1},;
                     		{"Visualizar"	,"AxVisual",0,2},;
                     		{"Incluir"		,"AxInclui",0,3},;
                     		{"Alterar"		,"AxAltera",0,4},;
                     		{"Excluir"		,"AxDeleta",0,5}}

	Private cString := "ZZB"

	dbSelectArea(cString)
	dbSetOrder(1)

	mBrowse(6,1,22,75,cString)


Return
	
	
//Usado no PE M460FIM	
//Inclusão do Bonus
User Function GeraBonus(xFilial,xNota,xSerie,xCliente,xLoja)

	Local aAreaAtu 	:= GetArea()
	Local nPBonus	:= SuperGetmv("MV_PBONUS",.F.,3.00) //% do bonus comercial
	Local nDiasVct	:= SuperGetmv("MV_DBONUS",.F.,365) //quantidade de dias para o vcto do bonus
	Local nVlrLiq	:= 0
	Local cQuery 	:= ""

	cQuery := "SELECT SUM((D2_QUANT*C6_PRCTAB) - D2_DESCON) VLRLIQ "
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND SC6.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON F4_CODIGO = D2_TES AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = '' "
	cQuery += " WHERE D2_DOC = '"+xNota+"' "
	cQuery += "   AND D2_SERIE = '"+xSerie+"' "
	cQuery += "   AND D2_CLIENTE = '"+xCliente+"' "
	cQuery += "   AND D2_LOJA = '"+xLoja+"' "
 	cQuery += " AND SD2.D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBSD2',.T.,.T.)

	If !TRBSD2->(EOF())
		While !eof() 
			nVlrLiq := TRBSD2->VLRLIQ 
			dbSelectArea("TRBSD2")
			dbskip()		
		End
	EndIf

	TRBSD2->(dbCloseArea())

	If nVlrLiq <> 0
		dbSelectArea("ZZA")
		dbSetOrder(1)
		Reclock("ZZA",.T.)
			ZZA->ZZA_FILIAL := xFilial("ZZA")
			ZZA->ZZA_CODCLI	:= xCliente
			ZZA->ZZA_LOJA	:= xLoja
			ZZA->ZZA_NFDOC	:= xNota
			ZZA->ZZA_TPDC	:= "C"
			ZZA->ZZA_EMISSA	:= dDataBase
			ZZA->ZZA_VLRLIQ	:= nVlrLiq
			ZZA->ZZA_CREDI	:= nPBonus
			ZZA->ZZA_VALOR	:= Round((nVlrLiq * nPBonus) / 100,2)
			ZZA->ZZA_VENCT	:= dDataBase + nDiasVct
			ZZA->ZZA_SALDO 	:= ZZA->ZZA_VALOR
			ZZA->ZZA_TPLAN	:= "CR0001"
			ZZA->ZZA_FILORI := xFilial
			ZZA->ZZA_STATUS := "1"
			ZZA->ZZA_ATUSLD	:= "S"
			ZZA->ZZA_DESCLC := "BONUS DE VENDA"
			ZZA->ZZA_USINC	:= upper(Alltrim(cUserName))
			ZZA->ZZA_DTINC	:= dDataBase
			ZZA->ZZA_HRINC	:= TIME()
		Msunlock()
	EndIf

	RestArea(aAreaAtu)

Return()	


//Usado no PE SF2520E	
//Exlusao do Bonus
User Function DelBonus(xFilial,xNota,xSerie,xCliente,xLoja)

	Local aAreaAtu 	:= GetArea()

	DbSelectArea("ZZA")
	DbSetOrder(1)
	If dbSeek(xFilial("ZZA")+xCliente+xLoja+xNota+"C")
		Reclock("ZZA",.f.)
			dbdelete()	
		Msunlock()
	EndIf

	RestArea(aAreaAtu)

Return()	



User Function RecalcBonus()

	//--< VariÃ¡veis >-----------------------------------------------------------------------
	Local 	cFunction	:= "RECALBONUS"
	Local	cTitle		:= "Recalculo dos Saldos de Bonus"
	Local	cObs		:= ""
	Local	oProcess	:= Nil
	Local 	cPerg		:= Padr( "RECALBONUS", LEN( SX1->X1_GRUPO ) )
	Local 	lExec		:= .f.

	//--< Procedimentos >-------------------------------------------------------------------
	cObs := "Essa rotina tem a finalidade de realizar o recalculo dos saldos de Bonus" + CRLF + CRLF
	cObs += "Conforme parametros definidos pelo usuario "
	
	ValidPerg(cPerg)
	
	oProcess := TNewProcess():New(cFunction, cTitle, {|oSelf| U_RecalProc(oSelf,@lExec)}, cObs,cPerg)
	
	If lExec
		Aviso("Recalculo de Bonus", "Fim do processamento! ", {"OK"})
	EndIf

Return Nil


User Function RecalProc(oSelf,lExec)


	Local aArea  	:= GetArea()
	Local cQuery	:= ""
	Local nRegTot	:= 0
	Local nReg		:= 0
	Local nVlrDeb	:= 0
	Local xCliente	:= ""
	Local xLoja		:= ""
	Local nRegTMP	:= 0
	Local nValor 	:= 0
	Local nSaldo 	:= 0
	Local lObj	   	:= ValType(oSelf) == "O"


	//grava na tabela SXU	
	If lObj
		oSelf:SaveLog(" * * * Inicio do Processamento * * * ")
		oSelf:SaveLog("Usuario : "+Alltrim(cUserName))
		oSelf:SaveLog("Cliente de "+MV_PAR01+" ate "+MV_PAR02)
	EndIf	

	cQuery := "SELECT ZZA_CODCLI, ZZA_LOJA , SUM(ZZA_VALOR) VLRDEB "
	cQuery += " FROM "+RetSqlName("ZZA")+" ZZA "
	cQuery += " WHERE ZZA_ATUSLD = 'S' "
	cQuery += "   AND ZZA_TPDC = 'D' "
	cQuery += "   AND ZZA_CODCLI BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
 	cQuery += "   AND ZZA.D_E_L_E_T_ = '' "
 	cQuery += " GROUP BY ZZA_CODCLI, ZZA_LOJA "
 	cQuery += " ORDER BY ZZA_CODCLI, ZZA_LOJA "
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBZZA", .F., .T.)
	dbSelectArea( "TRBZZA" )
	DbGoTop()
	bAcao:= {|| nRegTot ++ }
	dbEval(bAcao,,{||!Eof()},,,.T.)
	dbSelectArea("TRBZZA")
	dbGotop()


	If lObj
		oSelf:SetRegua1(nRegTot)
	EndIf
		
	While TRBZZA->(!Eof())

		nVlrDeb		:= TRBZZA->VLRDEB		
		xCliente	:= 	TRBZZA->ZZA_CODCLI
		xLoja		:= 	TRBZZA->ZZA_LOJA
		nRegTMP		:= 0		
		nReg		:= 0		
		lExec		:= .t.
		
		If lObj
			oSelf:IncRegua1("Cliente : " + xCliente)
		EndIf
			
		IF Select("TRBTMP") <> 0
			DbSelectArea("TRBTMP")
			DbCloseArea()
		ENDIF

		cQuery := "SELECT ZZA_SALDO, ZZA_VALOR, ZZA.R_E_C_N_O_ ZZAREC "
		cQuery += " FROM "+RetSqlName("ZZA")+" ZZA "
		cQuery += " WHERE ZZA_ATUSLD = 'S' "
		cQuery += "   AND ZZA_TPDC = 'C' "
 		cQuery += "   AND ZZA.D_E_L_E_T_ = '' "
		cQuery += "   AND ZZA_CODCLI = '"+xCliente+"' "
		cQuery += "   AND ZZA_LOJA = '"+xLoja+"' "
 		cQuery += " ORDER BY ZZA_VENCT,ZZA_NFDOC"
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBTMP", .F., .T.)
		dbSelectArea( "TRBTMP" )
		DbGoTop()
		bAcao:= {|| nRegTMP ++ }
		dbEval(bAcao,,{||!Eof()},,,.T.)
		dbSelectArea("TRBTMP")
		dbGotop()
	   
		If lObj
			oSelf:SetRegua2(nRegTMP)
		EndIf	

		While TRBTMP->(!Eof())

			nReg ++
			If lObj
				oSelf:IncRegua2("Processando Registro: " + CValToChar(nReg) + " de " + CValToChar(nRegTMP))
			EndIf
			nValor := TRBTMP->ZZA_VALOR
			nSaldo := TRBTMP->ZZA_SALDO

			If nVlrDeb <= 0
				If nValor <> nSaldo
					AtuSaldo(TRBTMP->ZZAREC,nValor,"1")
				EndIf
			Else	
				If nVlrDeb > nValor
					If nSaldo <> 0
						AtuSaldo(TRBTMP->ZZAREC,0,"9")
					EndIf
				Else
					AtuSaldo(TRBTMP->ZZAREC,nValor - nVlrDeb,"1")
				EndIf
			EndIf	
			
			nVlrDeb -= nValor

			dbSelectArea("TRBTMP")
			TRBTMP->(dbSkip())

		End

		IF Select("TRBTMP") <> 0
			DbSelectArea("TRBTMP")
			DbCloseArea()
		ENDIF

		dbSelectArea("TRBZZA")
		TRBZZA->(dbSkip())

	End

	IF Select("TRBZZA") <> 0
		DbSelectArea("TRBZZA")
		DbCloseArea()
	ENDIF

	RestArea(aArea)


Return()


Static Function ValidPerg(cPerg)

	Local aArea  	:= GetArea()
	Local aRegs := {}
	Local i := j := 0

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

				  //GRUPO,ORDEM,PERGUNTA              ,PERGUNTA,PERGUNTA,VARIAVEL,TIPO,TAMANHO,DECIMAL,PRESEL,GSC,VALID,VAR01,DEF01,DEFSPA01,DEFING01,CNT01,VAR02,DEF02,DEFSPA02,DEFING02,CNT02,VAR03,DEF03,DEFSPA03,DEFING03,CNT03,VAR04,DEF04,DEFSPA04,DEFING04,CNT04,VAR05,DEF05,DEFSPA05,DEFING05,CNT05,F3,GRPSXG
	AADD(aRegs,{cPerg,"01","Cliente de   ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
	AADD(aRegs,{cPerg,"02","Cliente Ate  ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	RestArea(aArea)

Return


Static Function AtuSaldo(nRecZZA,nSaldo,cSts)

	Local aArea  	:= GetArea()

	DbSelectArea("ZZA")
	dbgoto(nRecZZA)
	Reclock("ZZA",.f.)
		ZZA->ZZA_SALDO 	:= nSaldo	
		ZZA->ZZA_STATUS := cSts
	Msunlock()

	RestArea(aArea)

Return()	