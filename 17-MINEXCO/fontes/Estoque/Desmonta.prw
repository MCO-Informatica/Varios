#Include "PROTHEUS.CH"


User Function Desmonta()

	Local aTitles2  := {OemToAnsi("Desmontagem Chapas")}

	Private aCoors 		:= FWGetDialogSize( oMainWnd )

	Private oDlgPri
	Private oTela,oCont0,oCont1,oCont2,oCont3,oCont4,oCont5
	Private oBarSup,oIdentif,oItens,oPastas,oPanelSup,oFont02
	Private oTButton1,oTButton2,oTButton3,oTButton4,oTButton5,oTimer1,oSayTime,oTimer2

   	Private oSayNota,oGetNota
 	Private oSayFor,oGetFor
 	Private oSayEmi,oGetEmi
 	Private oSayTot,oGetTot
 	Private oSaySal,oGetSal

 	Private oSayDifT,oGetDifT
 	Private oSayDifI,oGetDifI

 	
   	Private cGetNota 	:= SF1->F1_DOC+"-"+SF1->F1_SERIE
   	Private cGetFor 	:= Alltrim(posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME"))
   	Private cGetEmi 	:= SF1->F1_EMISSAO
   	Private cGetTot 	:= SF1->F1_XTOTM2
   	Private cGetSal 	:= 0
	Private lEdit		:= iif(SF1->F1_XSTATUS <> '3',.F.,.T.)

	Private cGetDifT	:= 0
	Private cGetDifI	:= 0

	Private oGetZZF

	Private aCpoZZF  	:= {"ZZF_SEQ","ZZF_TPMOV","ZZF_ALTURA","ZZF_LARG","ZZF_QTDPLC","ZZF_PLCM2","ZZF_QTDM2","ZZF_CONTAI","ZZF_CHAPA","ZZF_OBS"}
	Private aAltZZF  	:= {"ZZF_TPMOV","ZZF_ALTURA","ZZF_LARG","ZZF_QTDPLC","ZZF_CONTAI","ZZF_CHAPA","ZZF_OBS"}
	Private aHeadZZF 	:= RetHeader(aCpoZZF)
	Private aColsZZF 	:= RetCols(aHeadZZF)
	Private bLinOk 		:= {|| flinOk()} 
	Private bLinDel 	:= {|| fLinDel()} 
	Private bVldCpo 	:= {|| fValidCpo()} 
	Private bChange 	:= {|| fLinhaPlaca()} 
	Private bSuperDel 	:= {|| Alert("SuperDel")} 

	Private cTimeIni	:= ""

	Private oListIt
	Private aListItem	:= {}

	Private cItNfAnt	:= ""
	Private cProdAnt	:= ""
	Private lGrava		:= .t.

	Private aChkLst		:= {}
	Private cLoteNew		:= ""
	

	DEFINE FONT oFont02  NAME "Arial" SIZE 0,15  BOLD
	DEFINE FONT oFont01  NAME "Arial" SIZE 0,42  BOLD
	
	oDlgPri := TDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],"Desmontagem Chapas",,,,,,,,,.T.,,,,,) 


		oTela := FWFormContainer():New( oDlgPri )

		oCont0 := oTela:createVerticalBox( 15 )
		oCont1 := oTela:createVerticalBox( 85 )

		oCont2 := oTela:createHorizontalBox( 20,oCont1 )
		oCont3 := oTela:createHorizontalBox( 27,oCont1 )
		oCont4 := oTela:createHorizontalBox( 48,oCont1 )
		oCont5 := oTela:createHorizontalBox( 05,oCont1 )

		oTela:Activate( oDlgPri, .F. )

		oBarSup 	:= oTela:GetPanel( oCont0 )
		oIdentif 	:= oTela:GetPanel( oCont2 )
		oItens  	:= oTela:GetPanel( oCont3 )
		oPastas 	:= oTela:GetPanel( oCont4 )

		oPanelSup 	:= tPanel():New(01,03,"",oBarSup,,,,,RGB(160,183,237),((oBarSup:nRight - oBarSup:nLeft) / 2) - 5,((oBarSup:nBottom - oBarSup:nTop) / 2)-15,.t.,.F.)

		oSayTime := TSay():New( 010,005 ,{||"LEGENDA"} ,oPanelSup,,oFont02,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,100,050)
		Legenda()

		oTButton1 	:= TButton():New( ((oBarSup:nBottom - oBarSup:nTop)/2)-040, 03, "Sair"   			,oPanelSup,{||GravaZZF(.t.),oDlgPri:End()}		,((oBarSup:nRight - oBarSup:nLeft) / 2) - 15,15,,oFont02,.F.,.T.,.F.,,.F.,,,.F. ) 

		If !lEdit
			oTButton2 	:= TButton():New( ((oBarSup:nBottom - oBarSup:nTop)/2)-060, 03, "Gravar" 			,oPanelSup,{||GravaZZF(.F.)}		,((oBarSup:nRight - oBarSup:nLeft) / 2) - 15,15,,oFont02,.F.,.T.,.F.,,.F.,,,.F. ) 
			oTButton2:Disable()

			oTButton4 	:= TButton():New( ((oBarSup:nBottom - oBarSup:nTop)/2)-100, 03, "Apontamento"	,oPanelSup,{||Apontamento()}		,((oBarSup:nRight - oBarSup:nLeft) / 2) - 15,15,,oFont02,.F.,.T.,.F.,,.F.,,,.F. ) 
			oTButton4:Disable()
		Endif
	
		oGroupId	:= TGroup():New(01,01,((oIdentif:nBottom - oIdentif:nTop) / 2) ,((oIdentif:nRight - oIdentif:nLeft) / 2) - 5,'',oIdentif,,,.T.)
		IdentId()

		oGroupIt	:= TGroup():New(01,01,((oItens:nBottom - oItens:nTop) / 2) ,((oItens:nRight - oItens:nLeft) / 2) - 5,'',oItens,,,.T.)
		fItemNota()
		
		oFoldRod 	:= TFolder():New(oPastas:nTop,oPastas:nLeft,aTitles2,{"HEADER"},oPastas,1,,, .T., .F.,((oPastas:nRight - oPastas:nLeft) / 2) - 7,((oPastas:nBottom - oPastas:nTop) / 2) - 3,)
		fApontar()


	oDlgPri:Activate(,,,.T.)



Return()


Static Function IdentId()

    	    	
    	@ 010, 015 SAY 		oSayNota 		PROMPT "Nota Fiscal :" 		SIZE 025, 007 OF oGroupId COLORS CLR_BLUE, 16777215 PIXEL
    	@ 020, 015 MSGET 	oGetNota 		VAR cGetNota 					SIZE 060, 010 PICTURE "@!" OF oGroupId COLORS 0, 16777215 PIXEL  when .f.  //Valid ValidPed()                                                                                              

    	@ 010, 085 SAY 		oSayFor 		PROMPT "Fornecedore :" 		SIZE 025, 007 OF oGroupId COLORS CLR_BLUE, 16777215 PIXEL
    	@ 020, 085 MSGET 	oGetFor 		VAR cGetFor 						SIZE 200, 010 PICTURE "@!" OF oGroupId COLORS 0, 16777215 PIXEL when .f.                                                                                              

    	@ 035, 015 SAY 		oSayEmi 		PROMPT "Emissão :"				SIZE 050, 007 OF oGroupId COLORS CLR_BLUE, 16777215 PIXEL
    	@ 045, 015 MSGET 	oGetEmi 		VAR cGetEmi 						SIZE 060, 010 PICTURE "@!" OF oGroupId COLORS 0, 16777215 PIXEL when .f.                                                                                              

    	@ 035, 085 SAY 		oSayTot 		PROMPT "Total NF M2 :"			SIZE 035, 007 OF oGroupId COLORS CLR_BLUE, 16777215 PIXEL
    	@ 045, 085 MSGET 	oGetTot 		VAR cGetTot 						SIZE 060, 010 PICTURE "@e 99,999.999999" OF oGroupId COLORS 0, 16777215 PIXEL when .f.                                                                                              

    	@ 035, 165 SAY 		oSaySal 		PROMPT "Total Placas M2 :"	SIZE 060, 007 OF oGroupId COLORS CLR_RED, 16777215 PIXEL
    	@ 045, 165 MSGET 	oGetSal 		VAR cGetSal 						SIZE 060, 010 PICTURE "@e 99,999.999999" OF oGroupId COLORS 0, 16777215 PIXEL when .f.                                                                                              



Return()


Static Function fApontar()

	Local nModo := GD_UPDATE+GD_INSERT+GD_DELETE
	Local nMaxLin := 999

	oGetZZF := MsNewGetDados():New( 2, 3,((oPastas:nBottom - oPastas:nTop) / 2)-15, ((oPastas:nRight - oPastas:nLeft) / 2) - 8 ,nModo,'Eval(bLinOk)',/*ctudoOk*/ ,"+ZZF_SEQ"/*cIniCpos*/ ,aAltZZF,0,nMaxLin,'Eval(bVldCpo)','Eval(bSuperDel)' ,'Eval(bLinDel)', oFoldRod:aDialogs[1], aHeadZZF, aColsZZF,bChange)

Return()


Static Function fItemNota()

	aListItem := {}

	oListIt := TCBrowse():New( 02,03,((oItens:nRight - oItens:nLeft) / 2) - 10,((oItens:nBottom - oPastas:nTop) / 2) - 5,,{},{},oGroupIt,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	VerItens()
	
	oListIt:SetArray(aListItem)
	oListIt:AddColumn( TCColumn():New("" 					,{ || aListItem[oListIt:nAt,10]},""		,,,"LEFT"  	,10 ,.T.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("Item NF" 			,{ || aListItem[oListIt:nAt,1]},"@!"	,,,"LEFT"  	,25 ,.F.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("Cod.Prod." 		,{ || aListItem[oListIt:nAt,2]},"@!"	,,,"LEFT"  	,60 ,.F.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("Produto" 			,{ || aListItem[oListIt:nAt,3]},"@!"	,,,"LEFT"  	,150,.F.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("Qtd. M2"			,{ || aListItem[oListIt:nAt,4]},"@E 99,999.999999"	,,,"CENTER"  ,50 ,.F.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("Saldo. M2"		,{ || aListItem[oListIt:nAt,9]},"@E 99,999.999999"	,,,"CENTER"  ,50 ,.F.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("Lote"				,{ || aListItem[oListIt:nAt,5]},"@!"	,,,"CENTER"  ,50 ,.F.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("Armazem"			,{ || aListItem[oListIt:nAt,6]},"@!"	,,,"LEFT"    ,50 ,.F.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("	Lote Fornec"		,{ || aListItem[oListIt:nAt,7]},"@!"	,,,"LEFT"    ,60 ,.F.,.T.,,,,.F.,) )
	oListIt:AddColumn( TCColumn():New("Dt.Validade"		,{ || aListItem[oListIt:nAt,8]},"@!"	,,,"LEFT"    ,50 ,.F.,.T.,,,,.F.,) )

	oListIt:bChange := {|x,y| GravaZZF(.T.) , AtuPlacas() }

	oListIt:Refresh()


Return()

Static Function Legenda()

	//legenda
	@ 20,05 BITMAP aBmp1 RESNAME "BR_AZUL" of oPanelSup SIZE 20,20 NOBORDER WHEN .F. PIXEL
	@ 20,15 SAY "A Desmontar "	SIZE 60,7 PIXEL OF oPanelSup 

	@ 30,05 BITMAP aBmp1 RESNAME "BR_AMARELO" of oPanelSup SIZE 20,20 NOBORDER WHEN .F. PIXEL
	@ 30,15 SAY "Desmontagem Parcial"	SIZE 60,7 PIXEL OF oPanelSup 

	@ 40,05 BITMAP aBmp1 RESNAME "BR_VERDE" of oPanelSup SIZE 20,20 NOBORDER WHEN .F. PIXEL
	@ 40,15 SAY "Desmontagem OK "	SIZE 60,7 PIXEL OF oPanelSup 

	@ 50,05 BITMAP aBmp1 RESNAME "BR_PRETO" of oPanelSup SIZE 20,20 NOBORDER WHEN .F. PIXEL
	@ 50,15 SAY "Desmontagem Apontada"		SIZE 60,7 PIXEL OF oPanelSup 



	@ 70,05 BITMAP aBmp1 RESNAME "BR_LARANJA" of oPanelSup SIZE 20,20 NOBORDER WHEN .F. PIXEL
	@ 70,15 SAY "Chapas"		SIZE 40,7 PIXEL OF oPanelSup 

	@ 80,05 BITMAP aBmp1 RESNAME "BR_BRANCO" of oPanelSup SIZE 20,20 NOBORDER WHEN .F. PIXEL
	@ 80,15 SAY "Perdas"		SIZE 40,7 PIXEL OF oPanelSup 

	@ 90,05 BITMAP aBmp1 RESNAME "BR_CINZA" of oPanelSup SIZE 20,20 NOBORDER WHEN .F. PIXEL
	@ 90,15 SAY "Ganho"		SIZE 40,7 PIXEL OF oPanelSup 

	@ 100,05 BITMAP aBmp1 RESNAME "BR_VERMELHO" of oPanelSup SIZE 20,20 NOBORDER WHEN .F. PIXEL
	@ 100,15 SAY "Cacos"		SIZE 40,7 PIXEL OF oPanelSup 


   	@ 120, 005 SAY 		oSayDifT 		PROMPT "Dif. Nota Fiscal M2:" 	SIZE 080, 007 OF oPanelSup COLORS CLR_RED, 16777215 PIXEL
   	@ 130, 005 MSGET 	oGetDifT 		VAR cGetDifT 					SIZE 060, 010 PICTURE "@E 99,999.999999" OF oPanelSup COLORS 0, 16777215 PIXEL  when .f.  //Valid ValidPed()                                                                                              

   	@ 150, 005 SAY 		oSayDifI 		PROMPT "Dif. Item M2:" 			SIZE 080, 007 OF oPanelSup COLORS CLR_RED, 16777215 PIXEL
   	@ 160, 005 MSGET 	oGetDifI 		VAR cGetDifI 					SIZE 060, 010 PICTURE "@E 99,999.999999" OF oPanelSup COLORS 0, 16777215 PIXEL when .f.                                                                                              



Return()




Static Function IncSt(nStatus)
	
	Local oVerde    := LoadBitmap( GetResources(), "BR_VERDE" 	)
	Local oAmarelo 	:= LoadBitmap( GetResources(), "BR_AMARELO"	)
	Local oAzul    	:= LoadBitmap( GetResources(), "BR_AZUL" 		)
	Local oCinza    := LoadBitmap( GetResources(), "BR_CINZA" 	)
	Local oBranco  	:= LoadBitmap( GetResources(), "BR_BRANCO" 	)
	Local oPreto	  	:= LoadBitmap( GetResources(), "BR_PRETO" 	)
	Local oLaranja 	:= LoadBitmap( GetResources(), "BR_LARANJA" 	)
	Local oVermelho := LoadBitmap( GetResources(), "BR_VERMELHO"	)
	Local oBmp

	If nStatus = 0	
		oBmp := oVerde
	ElseIf nStatus = 1	
		oBmp := oAzul
	ElseIf nStatus = 2	
		oBmp := oVermelho
	ElseIf nStatus = 3	
		oBmp := oLaranja
	ElseIf nStatus = 4	
		oBmp := oPreto
	ElseIf nStatus = 5	
		oBmp := oAmarelo
	ElseIf nStatus = 6	
		oBmp := oBranco
	ElseIf nStatus = 7	
		oBmp := oCinza
	Endif	

	
Return(oBmp)



Static Function fValidCpo()

	Local lOk 		:= .t.
	Local cCampo 	:= Alltrim(Substr(Readvar(),4))
	Local xCampo		:= &(Readvar())
	Local nPos		:= 0

	If oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_TPMOV",aHeadZZF)] = "C"
		oGetZZF:aCols[oGetZZF:oBrowse:nAt,1] := IncSt(3)
	ElseIf oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_TPMOV",aHeadZZF)] = "P"
		oGetZZF:aCols[oGetZZF:oBrowse:nAt,1] := IncSt(6)
	ElseIf oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_TPMOV",aHeadZZF)] = "G"
		oGetZZF:aCols[oGetZZF:oBrowse:nAt,1] := IncSt(7)
	ElseIf oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_TPMOV",aHeadZZF)] = "K"
		oGetZZF:aCols[oGetZZF:oBrowse:nAt,1] := IncSt(2)
	EndIf

	IF oGetZZF:oBrowse:nAt > 1 .and. Empty(oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_CONTAI",aHeadZZF)]) 
		oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_CONTAI",aHeadZZF)] := oGetZZF:aCols[oGetZZF:oBrowse:nAt-1,GDFieldPos("ZZF_CONTAI",aHeadZZF)] 
	EndIf	
	
	If cCampo = "ZZF_LARG"
		If xCampo <> 0 .and. oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_ALTURA",aHeadZZF)]  <> 0
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_PLCM2",aHeadZZF)] := NoRound((xCampo * oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_ALTURA",aHeadZZF)] ) / 10000 ,6)
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_QTDM2",aHeadZZF)] := NoRound((oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_QTDPLC",aHeadZZF)] * oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_PLCM2",aHeadZZF)] ) ,6)
		EndIf
	EndIf

	If cCampo = "ZZF_ALTURA"
		If xCampo <> 0 .and. oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_LARG",aHeadZZF)]  <> 0
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_PLCM2",aHeadZZF)] := NoRound((xCampo * oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_LARG",aHeadZZF)] ) / 10000 ,6)
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_QTDM2",aHeadZZF)] := NoRound((oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_QTDPLC",aHeadZZF)] * oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_PLCM2",aHeadZZF)] ) ,6)
		EndIf
	EndIf


	If cCampo = "ZZF_QTDPLC"
		If xCampo <> 0 .and. oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_PLCM2",aHeadZZF)]  <> 0
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_QTDM2",aHeadZZF)] := NoRound((xCampo * oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_PLCM2",aHeadZZF)] ) ,6)
		EndIf
	EndIf

	If cCampo = "ZZF_TPMOV"
		If xCampo = "C"
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,1] := IncSt(3)
		ElseIf xCampo = "P"
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,1] := IncSt(6)
		ElseIf xCampo = "G"
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,1] := IncSt(7)
		ElseIf xCampo = "K"
			oGetZZF:aCols[oGetZZF:oBrowse:nAt,1] := IncSt(2)
		EndIf
		oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_TPMOV",aHeadZZF)] := xCampo
	EndIf

	lOk := AtuSaldo() //Atualiza os saldos

Return(lOk)

Static Function fLinOk()

	Local lOk := .t.

	//Alert("flinok")	

Return(lOk)

Static Function VerItens()

	Local cQuery 	:= ""
	Local nSaldo		:= 0
	Local nStatus	:= 1

	aListItem := {}
	cGetSal	:= 0

	cQuery := " SELECT D1_ITEM,D1_COD,D1_PRODUTO,D1_QUANT,D1_LOTECTL,D1_LOCAL,D1_LOTEFOR,D1_DTVALID "
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = D1_COD AND B1_XTPGRP = 'C' AND SB1.D_E_L_E_T_ = '' "			
	cQuery += " WHERE D1_FILIAL = '"+xfilial("SD1")+"' "
	cQuery += "  AND D1_DOC = '"+SF1->F1_DOC+"' "
	cQuery += "  AND D1_SERIE = '"+SF1->F1_SERIE+"' "
	cQuery += "  AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "
	cQuery += "  AND D1_LOJA = '"+SF1->F1_LOJA+"' "
  	cQuery += "  AND SD1.D_E_L_E_T_ = '' " 
  	cQuery += "  ORDER BY D1_ITEM "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBSD1',.T.,.T.)

	If !TRBSD1->(EOF())
		While !eof() 
	
				nSaldo 	:= VerSaldo(TRBSD1->D1_ITEM,TRBSD1->D1_COD)
				cGetSal 	+= nSaldo
				nStatus 	:= 1
				
				If nSaldo <> 0
					If nSaldo < TRBSD1->D1_QUANT
		   				nStatus := 5 //Parcial
		 			Else
		  				nStatus := 0 //Total
					EndIf	
				EndIf
	
				If lEdit
		  			nStatus := 4 //Ja Apontado
				EndIf	
	
				aadd(aListItem,{TRBSD1->D1_ITEM,;    				//1
					             TRBSD1->D1_COD,;     				//2
					             alltrim(TRBSD1->D1_PRODUTO),;   //3
					             TRBSD1->D1_QUANT,;      			//4
									TRBSD1->D1_LOTECTL,;				//5
									TRBSD1->D1_LOCAL,;					//6
									TRBSD1->D1_LOTEFOR,;				//7
									STOD(TRBSD1->D1_DTVALID),;		//8	
									nSaldo,;								//9
									IncSt(nStatus)})					//10


			dbSelectArea("TRBSD1")
			dbskip()		

		End

	 Else
		MsgInfo("Nota Fiscal não tem Itens para desmontagem de Placas !!!")	
	EndIf	

	TRBSD1->(dbCloseArea())

	If Empty(aListItem)
		AADD( aListItem , {space(4),space(15),space(40),0,space(10),space(02),space(18),ctod(""),0,IncSt(1)} )
		If !lEdit
			oTButton2:Disable()
		Endif
    Else
		If !lEdit
			oTButton2:Enable()
		EndIf
	EndIf

   	oListIt:SetArray(aListItem)
	oListIt:bLine := {|| aEval( aListItem[oListIt:nAt],{|z,w| aListItem[oListIt:nAt,w]})} 
	oListIt:Refresh()

	cGetDifI := aListItem[1,4] - aListItem[1,9] 

	cGetDifT := cGetTot - cGetSal

	oGetDifT:Refresh()
	oGetDifI:Refresh()
	oGetSal:Refresh()


	If !lEdit
		If NoRound(cGetSal,6) = NoRound(cGetTot,6)	//----> ALTERADO POR RICARDO SOUZA 08/02/2018
			oTButton4:Enable()
   		Else
			oTButton4:Disable()
		EndIf
	EndIf

Return


Static Function VerSaldo(xItem,xProduto)

	Local nSaldo := 0
	Local cQuery 	:= ""

   	cQuery := " SELECT 	SUM(CASE WHEN ZZF_TPMOV <> 'G' THEN ZZF_QTDM2 "   
	cQuery += "                 WHEN ZZF_TPMOV = 'G' THEN (ZZF_QTDM2*-1) "  
	cQuery += "             END) ZZF_QTDM2 "
	cQuery += " FROM "+RetSqlName("ZZF")+" ZZF "
	cQuery += " WHERE ZZF_FILIAL = '"+xfilial("ZZF")+"' "
	cQuery += "  AND ZZF_NOTA = '"+SF1->F1_DOC+"' "
	cQuery += "  AND ZZF_SERIE = '"+SF1->F1_SERIE+"' "
	cQuery += "  AND ZZF_CODFOR = '"+SF1->F1_FORNECE+"' "
	cQuery += "  AND ZZF_LOJFOR = '"+SF1->F1_LOJA+"' "
	cQuery += "  AND ZZF_ITEMNF  = '"+xItem+"' "
	cQuery += "  AND ZZF_PRODUT = '"+xProduto+"' "
	cQuery += "  AND ZZF.D_E_L_E_T_ ='' "
	cQuery += " ORDER BY 1 "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZZF',.T.,.T.)

	If !TRBZZF->(EOF())
      nSaldo := TRBZZF->ZZF_QTDM2
	EndIf

	TRBZZF->(dbCloseArea())

Return(nSaldo)


Static Function AtuPlacas()

	Local cQuery 	:= ""

	cQuery := " SELECT 	ZZF_SEQ,ZZF_ALTURA,ZZF_LARG,ZZF_QTDPLC,ZZF_PLCM2, ZZF_QTDM2, ZZF_TPMOV, ZZF_CONTAI , "
	//cQuery += "  ISNULL(CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), ZZF_OBS)),'') ZZF_OBS " 
	cQuery += " ZZF_OBS "
	cQuery += " FROM "+RetSqlName("ZZF")+" ZZF "
	cQuery += " WHERE ZZF_FILIAL = '"+xfilial("ZZF")+"' "
	cQuery += "  AND ZZF_NOTA = '"+SF1->F1_DOC+"' "
	cQuery += "  AND ZZF_SERIE = '"+SF1->F1_SERIE+"' "
	cQuery += "  AND ZZF_CODFOR = '"+SF1->F1_FORNECE+"' "
	cQuery += "  AND ZZF_LOJFOR = '"+SF1->F1_LOJA+"' "
	cQuery += "  AND ZZF_ITEMNF  = '"+aListItem[oListIt:nAt,1]+"' "
	cQuery += "  AND ZZF_PRODUT = '"+aListItem[oListIt:nAt,2]+"' "
	cQuery += "  AND ZZF.D_E_L_E_T_ ='' "
	cQuery += " ORDER BY 1 "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZZF',.T.,.T.)

	If !TRBZZF->(EOF())
		aColsZZF := RetCols(aHeadZZF,"TRBZZF",.t.)
	Else
		aColsZZF := RetCols(aHeadZZF,"")
	EndIF

	oGetZZF:aCols := aColsZZF
	oGetZZF:oBrowse:nAt := 1 
	oGetZZF:oBrowse:lReadOnly := lEdit  
	oGetZZF:oBrowse:Refresh()

	cItNfAnt	:= aListItem[oListIt:nAt,1]
	cProdAnt	:= aListItem[oListIt:nAt,2]
	lGrava		:= .t.  

	cGetDifI := aListItem[oListIt:nAt,4] - aListItem[oListIt:nAt,9] 
	oGetDifI:Refresh()


	TRBZZF->(dbCloseArea())


Return


Static Function GravaZZF(lAuto)

	Local nX			:= 0
	Local aAreaAtu	:= getarea()
	Local nColDel 	:= Len(aHeadZZF)+1
	Local xItNota	:= cItNfAnt 	
	Local xProduto  := cProdAnt 	
	Local xSeq		:= ""

	If lGrava .and. !lEdit

		For nX := 1 to Len(oGetZZF:aCols)

			xSeq	:= oGetZZF:aCols[nX,GDFieldPos("ZZF_SEQ",aHeadZZF)]			

			If oGetZZF:aCols[nX,GDFieldPos("ZZF_QTDM2",aHeadZZF)] <> 0
				If !oGetZZF:aCols[nX][nColDel] //Não Deletado
         			dbselectArea("ZZF")
					dbSetorder(1)			
					If dbseek(xFilial("ZZF")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+xItNota+xSeq)
						Reclock("ZZF",.F.) //alteracao
			  		Else	
						Reclock("ZZF",.T.) 	//Inclusao
					EndIf
						ZZF->ZZF_FILIAL 	:= xFilial("ZZF")
						ZZF->ZZF_NOTA 		:= SF1->F1_DOC
						ZZF->ZZF_SERIE 		:= SF1->F1_SERIE
						ZZF->ZZF_CODFOR		:= SF1->F1_FORNECE
						ZZF->ZZF_LOJFOR		:= SF1->F1_LOJA
						ZZF->ZZF_SEQ		:= xSeq
						ZZF->ZZF_ITEMNF		:= xItNota
						ZZF->ZZF_PRODUT		:= xProduto
						ZZF->ZZF_ALTURA		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_ALTURA",aHeadZZF)]	
						ZZF->ZZF_LARG		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_LARG",aHeadZZF)]	
						ZZF->ZZF_QTDPLC		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_QTDPLC",aHeadZZF)]	
						ZZF->ZZF_PLCM2		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_PLCM2",aHeadZZF)]	
						ZZF->ZZF_QTDM2		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_QTDM2",aHeadZZF)]	
						ZZF->ZZF_TPMOV		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_TPMOV",aHeadZZF)]	
						ZZF->ZZF_OBS		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_OBS",aHeadZZF)]	
						ZZF->ZZF_CONTAI		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_CONTAI",aHeadZZF)]	
						ZZF->ZZF_CHAPA		:= oGetZZF:aCols[nX,GDFieldPos("ZZF_CHAPA",aHeadZZF)]	
						ZZF->ZZF_EMISSA		:= ddataBase
						ZZF->ZZF_USER		:= cUserName
						ZZF->ZZF_HORA		:= time()
						MsUnlock()
      	  		Else
         			dbselectArea("ZZF")
					dbSetorder(1)			
					If dbseek(xFilial("ZZF")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+xItNota+xSeq)
						Reclock("ZZF",.F.) 	//Exclusao
							dbdelete()	
						MsUnlock()
					EndIf
				EndIf
			EndIf

		Next nX	

		If !lAuto
			MsgInfo("Apontamentos de Placas gravados com sucesso !!!")
		EndIf

	EndIf

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


//Monta Acols 

Static Function RetCols(aHead,cXAlias)

	Local aRet 	   		:= {}
	Local nX	      		:= 0
	Local nCntFor     	:= 0

	Default cXAlias   	:= ""
	
	If !Empty(cXAlias)

		dbSelectArea(cXAlias)
		While (cXAlias)->(!Eof())
					
			aAdd(aRet,Array(Len(aHead)+1))

			aRet[Len(aRet)][1]	:= IncSt(3)
	
			For nCntFor	:= 2 To Len(aHead)
				dbSelectArea(cXAlias)
				aRet[Len(aRet)][nCntFor] := FieldGet(FieldPos(aHead[nCntFor][2]))
				If Alltrim(aHead[nCntFor][2]) = "ZZF_TPMOV"
					If aRet[Len(aRet)][nCntFor] = "C"
						aRet[Len(aRet)][1]	:= IncSt(3)
					ElseIf aRet[Len(aRet)][nCntFor] = "P"
						aRet[Len(aRet)][1]	:= IncSt(6)
					ElseIf aRet[Len(aRet)][nCntFor] = "G"
						aRet[Len(aRet)][1]	:= IncSt(7)
					ElseIf aRet[Len(aRet)][nCntFor] = "K"
						aRet[Len(aRet)][1]	:= IncSt(2)
					EndIf
				EndIf
			Next nCntFor
			
			aRet[Len(aRet), Len(aHead)+1] := .F.
			(cXAlias)->(dbSkip())
	
		EndDo
	EndIf
	
	If Empty(aRet)
		
		aAdd(aRet,Array(Len(aHead)+1))

		aRet[Len(aRet)][1]	:= IncSt(3)
	
		For nX := 2 To Len(aHead)
			If AllTrim(aHead[nX][2]) = "ZZF_SEQ"
				aRet[1, nX] := "001"
			Else
				aRet[1, nX] := CriaVar(aHead[nX][2], (aHead[nX][10] <> "V") )
			EndIf
		Next nX
		
		aRet[Len(aRet), Len(aHead)+1] := .F.
	
	EndIf


Return aRet





Static Function fLinhaPlaca()

	
Return(.t.)


Static Function fLinDel()

	Local nColDel 	:= Len(aHeadZZF)+1
	Local wQtd		:= oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_QTDM2",aHeadZZF)]
	Local cTpMov		:= oGetZZF:aCols[oGetZZF:oBrowse:nAt,GDFieldPos("ZZF_TPMOV",aHeadZZF)]
	Local nPos		:= 0
	Local nStatus	:= 1

	nPos := aScan(aListItem,{|x| AllTrim(x[1]+x[2]) == Alltrim(cItNfAnt+cProdAnt)})

	If oGetZZF:aCols[oGetZZF:oBrowse:nAt,nColDel]
		If cTpMov <> "G"
			aListItem[nPos][9] += wQtd
			cGetSal += wQtd
	    Else
			aListItem[nPos][9] -= wQtd
			cGetSal -= wQtd
		EndIf	 
	 Else	
		If cTpMov <> "G"
			aListItem[nPos][9] -= wQtd
			cGetSal -= wQtd
		Else
			aListItem[nPos][9] += wQtd
			cGetSal += wQtd
		EndIf
	EndIf	
	
	If aListItem[nPos][9] <> 0
		If aListItem[nPos][9] < aListItem[nPos][4]
		   nStatus := 5 //Parcial
		 Else
		  	nStatus := 0 //Total
		EndIf	
	EndIf
				
	aListItem[nPos][10] := IncSt(nStatus)
	cGetDifI	:= aListItem[nPos][4] - aListItem[nPos][9]

   	oListIt:SetArray(aListItem)
	oListIt:bLine := {|| aEval( aListItem[oListIt:nAt],{|z,w| aListItem[oListIt:nAt,w]})} 
	oListIt:Refresh()

	cGetDifT := cGetTot - cGetSal
	
	oGetDift:Refresh()
	oGetDifI:Refresh()
	oGetSal:Refresh()
	
	If !lEdit
		If NoRound(cGetSal,3) = NoRound(cGetTot,6)
			oTButton4:Enable()
   		Else
			oTButton4:Disable()
		EndIf
	EndIf

Return(.t.)


Static Function AtuSaldo()

	Local nColDel 	:= Len(aHeadZZF)+1
	Local wQtd		:= 0
	Local nPos		:= 0
	Local nStatus	:= 1
	Local nX			:= 0
	Local lSaldo		:= .T.

	For nX := 1 to Len(oGetZZF:aCols)
		If !oGetZZF:aCols[nX][nColDel]  //nao deletado
			If oGetZZF:aCols[nX,GDFieldPos("ZZF_TPMOV",aHeadZZF)] <> "G"
				wQtd += oGetZZF:aCols[nX,GDFieldPos("ZZF_QTDM2",aHeadZZF)]
			Else
				wQtd -= oGetZZF:aCols[nX,GDFieldPos("ZZF_QTDM2",aHeadZZF)]
			EndIf	
		EndIf
	Next nX

	nPos := aScan(aListItem,{|x| AllTrim(x[1]+x[2]) == Alltrim(cItNfAnt+cProdAnt)})

	If NoRound(wQtd,3) > NoRound(aListItem[nPos][4],6)
		cGetDifI	:= aListItem[nPos][4] - wQtd
		oGetDifI:Refresh()
		MsgInfo("Saldo em M2 desse item já esta maior que a Quantidade M2 !!!")
		lSaldo := .f.
	EndIf
	
	If lSaldo

		aListItem[nPos][9] := wQtd

		If aListItem[nPos][9] <> 0
			If aListItem[nPos][9] < aListItem[nPos][4]
		   		nStatus := 5 //Parcial
		 	Else
		  		nStatus := 0 //Total
			EndIf	
		EndIf
				
		aListItem[nPos][10] := IncSt(nStatus)
		cGetDifI	:= aListItem[nPos][4] - aListItem[nPos][9]

   		oListIt:SetArray(aListItem)
		oListIt:bLine := {|| aEval( aListItem[oListIt:nAt],{|z,w| aListItem[oListIt:nAt,w]})} 
		oListIt:Refresh()

		wQtd := 0

		For nX := 1 to Len(aListItem)
			wQtd += aListItem[nX][9]
		Next nX

		cGetSal 	:= wQtd
		cGetDifT := cGetTot - cGetSal
	
		oGetDift:Refresh()
		oGetDifI:Refresh()
		oGetSal:Refresh()

		If !lEdit
			If NoRound(cGetSal,3) = NoRound(cGetTot,6)
				oTButton4:Enable()
    		Else
				oTButton4:Disable()
			EndIf
		EndIf

	EndIf
		
Return(lSaldo)



Static Function Apontamento()

	Local oProcess
	Local lProcOK	:= .t.

	If MsgYesNo("Deseja fazer os apontamentos das Chapas e suas respectivos movimentos de estoque ?")
		oProcess:= MsNewProcess():New( { |lEnd| OkProces( oProcess, @lProcOK ) }, "", "", .F. )
		oProcess:Activate()
		If lProcOk 
	      	MsgInfo("Apontamentos feito com sucesso !!")
			Reclock("SF1",.F.)	
				SF1->F1_XSTATUS := "3"
			Msunlock()
			lEdit := .t.
			oTButton2:Disable()
			oTButton4:Disable()
			oTButton2:lVisibleControl := .f.
			oTButton4:lVisibleControl := .f.
			VerItens()
			AtuPlacas()
		 Else	
	      	MsgInfo("Houve algum erro nos apontamentos verifique !!")
		EndIf
	EndIf

Return()


Static Function OkProces( oObj,lProcOk )

	Local nY				:= 0
	Local cQuery   		:= ""
	Local nReg			:= 0
	Local aAutoItens 	:= {}
	Local nP				:= 0
 	Local cDocumento 	:= ""
	Local cLoteF			:= ""
	Local nRateio		:= 0
	Local aAtuSB8		:= {}
	Local nSobra			:= 0
	Local xLocal			:= ""
	Local nSeq			:= 0
	Local cContai		:= ""

	oObj:SetRegua1(Len(aListItem))

   	Begin Transaction      


	For nY := 1 to Len(aListItem)

		oObj:IncRegua1("Chapas do Produto : "+Alltrim(aListItem[nY,2])+" Lote : "+Alltrim(aListItem[nY,5]))

		If SELECT("TRB") > 0
			TRB->(dbClosearea())
		Endif

		aAutoItens 	:= {}
		aAtuSB8		:= {}
		nSeq			:= 0

		cQuery := " SELECT ZZF.*, ZZF.R_E_C_N_O_ RECZZF "
		cQuery += " FROM " + RetSqlName("ZZF") + "  ZZF "
		cQuery += " WHERE ZZF_FILIAL = '"+xfilial("ZZF")+"' "
		cQuery += "  AND ZZF_NOTA = '"+SF1->F1_DOC+"' "
		cQuery += "  AND ZZF_SERIE = '"+SF1->F1_SERIE+"' "
		cQuery += "  AND ZZF_CODFOR = '"+SF1->F1_FORNECE+"' "
		cQuery += "  AND ZZF_LOJFOR = '"+SF1->F1_LOJA+"' "
		cQuery += "  AND ZZF_ITEMNF  = '"+aListItem[nY,1]+"' "
		cQuery += "  AND ZZF_PRODUT = '"+aListItem[nY,2]+"' "
		cQuery += "  AND ZZF.D_E_L_E_T_ ='' "
		cQuery += "  ORDER BY ZZF_CONTAI,ZZF_SEQ "

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)
		dbSelectArea( "TRB" )
		DbGoTop()
		bAcao:= {|| nReg ++ }
		dbEval(bAcao,,{||!Eof()},,,.T.)
		dbSelectArea("TRB")
		dbGotop()

		oObj:SetRegua2(nReg)

		nSobra := 0
		While !eof()
			If TRB->ZZF_TPMOV = "G"
				nSobra += TRB->ZZF_PLCM2
			EndIf
			dbSelectArea("TRB")
			dbSkip()
		End

		dbSelectArea("TRB")
		dbGotop()
		While !eof()

			oObj:IncRegua2("Container: "+TRB->ZZF_CONTAI +" Operação : "+TRB->ZZF_TPMOV)
			cContai := TRB->ZZF_CONTAI
			nSeq	:= 0
			
			While !eof() .and. cContai = TRB->ZZF_CONTAI 

				If TRB->ZZF_TPMOV $ "C/K" //chapa ou caco

					If TRB->ZZF_TPMOV = "C"
						xLocal := aListItem[nY,6]
				 	Else
						xLocal := "10"
					EndIf

					For nP := 1 to TRB->ZZF_QTDPLC

						nSeq ++
 						cLoteNew 	:= fNextLote()
 						PutMv("MV_X_LOTE",Soma1(cLoteNew))
 						
						nRateio	:= NoRound(((TRB->ZZF_PLCM2 / (aListItem[nY,4]+nSobra)) * 100),2)
	    				
	    				If !Empty(TRB->ZZF_CHAPA)
    	    				cLotef	 	:= Alltrim(TRB->ZZF_CONTAI) + TRB->ZZF_CHAPA+ ' ' + alltrim(trans(TRB->ZZF_ALTURA/100,"@E 9.99")) +"X" + alltrim(trans(TRB->ZZF_LARG/100,"@E 9.99"))                     
				
	    				Else
		    				cLotef	 	:= Alltrim(TRB->ZZF_CONTAI) + STRZERO(nSeq,3)+ ' ' + alltrim(trans(TRB->ZZF_ALTURA/100,"@E 9.99")) +"X" + alltrim(trans(TRB->ZZF_LARG/100,"@E 9.99"))                     
	    				EndIf
	    				//cLotef	 	:= Alltrim(TRB->ZZF_CONTAI) + Alltrim(TRB->ZZF_SEQ)+ ' ' + alltrim(trans(TRB->ZZF_ALTURA/100,"@E 9.99")) +"X" + alltrim(trans(TRB->ZZF_LARG/100,"@E 9.99"))                     


						aadd(aAutoItens,{	{"D3_COD"   	, TRB->ZZF_PRODUT			, Nil}, ;
												{"D3_LOCAL"  , xLocal			 			, Nil}, ;
												{"D3_QUANT"  , TRB->ZZF_PLCM2			, Nil}, ;
												{"D3_QTSEGUM", CriaVar("D3_QTSEGUM")	, Nil}, ;
												{"D3_LOTECTL", cLoteNew					, Nil}, ;
												{"D3_DTVALID", aListItem[nY,8]			, Nil}, ;
												{"D3_X_LOTEF", cLoteF						, Nil}, ;
												{"D3_RATEIO" , nRateio						, Nil}})

						aadd(aAtuSB8,{TRB->ZZF_PRODUT,xLocal,aListItem[nY,8],cLoteNew,cLoteF})


					Next nP

				EndIf

				dbSelectArea("TRB")
				dbSkip()

			End

		End

		cDocumento := ProxNum() //NextNumero("SD3",2,"D3_DOC",.T.)
		//cDocumento := A261RetINV(cDocumento)

		If !DesmontChapa(	aListItem[nY,2],;    	//PRODUTO
				            	aListItem[nY,5],; 		//LOTE ORIGINAL
				             aListItem[nY,6],; 		//LOCAL
				             aListItem[nY,8],; 		//VALIDADE
				             aListItem[nY,4],; 		//TOTAL M2
								aAutoItens,cDocumento)	//Rateio e Documento
			lProcOk := .f.
		EndIf

		If lProcOK

			dbSelectArea("TRB")
			dbGotop()
			While !eof()

				dbSelectArea("ZZF")
				dbGoto(TRB->RECZZF)
				Reclock("ZZF",.F.)	
					ZZF->ZZF_EMISD3 := dDataBase
					ZZF->ZZF_DOCSD3 := cDocumento
				MsUnlock()	

				dbSelectArea("TRB")
				dbSkip()

			End

			AtualSB8(aAtuSB8) //atualiza o SB8 LOTEFOR
			
			
		EndIf

		If SELECT("TRB") > 0
			TRB->(dbClosearea())
		Endif


	Next nY

	End Transaction


Return()


Static Function DesmontChapa(wProduto,wLote,wLocal,dDtValid,nTotM2,aAutoItens,cDocumento) 

	Local aAutoCab 		:= {}	
	Local nX				:= 0
 	Local aAreaAtu		:= getarea()
 	
 	Private lMsErroAuto := .F.

	dbSelectArea("SB8")
	dbSetOrder(3)
	If dbseek(xFilial("SB8")+wProduto+wLocal+wLote)
		If SB8->B8_SALDO <> nTotM2
			MsgInfo("Saldo do Lote não e o mesmo do Item da Nota !!!")
			RestArea(aAreaAtu)
			Return(.f.)
		EndIf	
	EndIf	
 	
 	aAutoCab := {{"cProduto"   , wProduto					, Nil},;
   					{"cLocOrig"   , wLocal			 		 	, Nil},;
   					{"nQtdOrig"   , nTotM2			 		 	, Nil},;
   					{"nQtdOrigSe" , CriaVar("D3_QTSEGUM")	, Nil},;
   					{"cDocumento" , cDocumento			   	, Nil},;
   					{"cNumLote"   , CriaVar("D3_NUMLOTE")	, Nil},;
   					{"cLoteDigi"  , wLote						, Nil},;
   					{"dDtValid"   , dDtValid					, Nil},;
   					{"nPotencia"  , CriaVar("D3_POTENCI")	, Nil},;
   					{"cLocaliza"  , CriaVar("D3_LOCALIZ")	, Nil},;
   					{"cNumSerie"  , CriaVar("D3_NUMSERI")	, Nil}}

	MSExecAuto({|v,x,y,z| Mata242(v,x,y,z)},aAutoCab,aAutoItens,3,.T.) //inclusaõ

	If lMsErroAuto
		Mostraerro()
		RestArea(aAreaAtu)
		Return(.f.)
	  Else	

	EndIf

	//MsgInfo("Desmontagem feita com sucesso !!")

	RestArea(aAreaAtu)

Return(.t.)


Static Function fNextLote()    

	Local cLote:= GETMV("MV_X_LOTE")      
                                                                                                          
return(cLote)


Static Function	AtualSB8(aAtuSB8) //atualiza o SB8 LOTEFOR

	Local nX				:= 0
 	Local aAreaAtu		:= getarea()


	For nX := 1 to len(aAtuSB8)
		dbSelectArea("SB8")
		dbSetOrder(1)
		If dbseek(xFilial("SB8")+aAtuSB8[nX,1]+aAtuSB8[nX,2]+dtos(aAtuSB8[nX,3])+aAtuSB8[nX,4])
			Reclock("SB8")
				SB8->B8_LOTEFOR	:= aAtuSB8[nX,5]
			Msunlock()
		EndIf		
	Next nX

	RestArea(aAreaAtu)

Return()
		