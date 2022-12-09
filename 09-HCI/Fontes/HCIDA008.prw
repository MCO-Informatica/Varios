#INCLUDE "MATA160.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE CAB_ARQTMP  01
#DEFINE CAB_POSATU  02
#DEFINE CAB_SAYGET  03
#DEFINE CAB_HFLD1   04
#DEFINE CAB_HFLD2   05
#DEFINE CAB_HFLD3   06
#DEFINE CAB_MARK    07 
#DEFINE CAB_GETDAD  08                     
#DEFINE CAB_COTACAO 09
#DEFINE CAB_MSMGET  10
#DEFINE CAB_ULTFORN 11
#DEFINE CAB_HISTORI 12

User Function HCIDA008()

	Local aFixe 	:= {	{ "Dt Validade ","C8_VALIDA " },;		//"Dt Validade "
							{ "Numero      ","C8_NUM    " },;		//"Numero      "
							{ "Fornecedor  ","C8_FORNECE" },;		//"Fornecedor  "
							{ "Loja Fornec.","C8_LOJA   " } }		//"Loja Fornec."
							
	Local aCores	:= {{"(SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. !Empty(SC8->C8_NUMPED))"	,"BR_AZUL"},; 		//Cotação em compra através do portal marketplace
						{"Empty(C8_NUMPED).And.C8_PRECO<>0.And.!Empty(C8_COND)"											,"ENABLE" },;		//Cotacao em aberto
						{"!Empty(C8_NUMPED)"																			,"DISABLE" },;		//Cotacao Baixada
						{"C8_PRECO==0.And.Empty(C8_NUMPED)"																,"BR_AMARELO"} }	//Cotacao nao digitada
					 
	Local aGrupo	:= UsrGrComp(RetCodUsr())
	Local aIndexSC8 := {}
	Local bBlock
	Local cFiltraSC8  := ""
	Local cFilSC8QRY  := ""
	Local cFilUser	  := ""
	Local cFilUserQry := ""
	Local lSolic	  := GetMv("MV_RESTCOM")=="S"
	Local lFiltra     := .F.
	Local lFilUser	  := ExistBlock("MT160FIL")
	Local lFilUserQry := ExistBlock("MT160QRY")
	Local nPos
	Local nCntFor	:= 0
	Local cAliasSC8 :="SC8"
	
	PRIVATE aLegenda  := {	{"ENABLE",STR0024},{"DISABLE",STR0025},{"BR_AMARELO",STR0026}, {"BR_AZUL","Cotação do portal marketplace"} } //"Legenda"
	PRIVATE aRotina   := MenuDef()
	PRIVATE bFiltraBrw:= {|| Nil }
	PRIVATE cCadastro := STR0008	//"Analise das Cota‡”es"
	PRIVATE lOnUpdate := .T.
	PRIVATE aAutoCab	:= {}
	PRIVATE aAutoItens:= {}
	PRIVATE aSelManual:= {}
	PRIVATE l160Auto	:= .F.
	
	If ( ExistBlock("MT160LEG") )
		aCoresUsr := ExecBlock("MT160LEG",.F.,.F.,{aCores})
		If ( ValType(aCoresUsr) == "A" )
			aCores := aClone(aCoresUsr)
		EndIf
	EndIf 
	
	If ExistBlock("MT160FIX")
		aFixe := ExecBlock("MT160FIX",.F.,.F.,aFixe)
	Endif
	
	AjustaSX1()
	AjustaSX3()
	Pergunte("MTA160",.F.)
	
	SetKey( VK_F12 ,{|| Pergunte("MTA160",.T.)})
	lSolic  := If(MV_PAR06==1,lSolic,.F.)
	lFiltra := MV_PAR07==1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realiza a Filtragem                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( lFiltra .Or. lSolic .Or. lFilUser .Or. lFilUserQry )
		If lFilUser
			cFilUser := ExecBlock("MT160FIL",.F.,.F.,{cAliasSC8})
			If ( ValType(cFilUser) <> "C" )
				cFilUser := ""
			EndIf
		EndIf
		#IFDEF TOP	
			If lFilUserQry
				cFilUserQry := ExecBlock("MT160QRY",.F.,.F.,{cAliasSC8})
				If ( ValType(cFilUserQry) <> "C" )
					cFilUserQry := ""
				EndIf
			EndIf
		#ENDIF		
		If lFiltra .Or. lSolic
			#IFDEF TOP
				IF TcSrvType() != "AS/400"
				    If lFiltra .Or. lSolic
						cFilSC8QRY := "C8_FILIAL='"+xFilial("SC8")+"' And "
						cFilSC8QRY += "C8_NUMPED='"+Space(Len(SC8->C8_NUMPED))+"'"
					EndIf
					If ( lSolic )
						If ( Ascan(aGrupo,"*") == 0 )
							cFilSC8QRY  += If(Empty(cFilSC8QRY),cFilSC8QRY," And ")
							cFilSC8QRY  += "(C8_GRUPCOM='"+Space(Len(SC8->C8_GRUPCOM))+"'"
							For nCntFor := 1 To Len(aGrupo)
								If nCntFor == 1 
									cFilSC8QRY += " Or C8_GRUPCOM IN ('"+aGrupo[nCntFor]+"'"
								Else
									cFilSC8QRY += ",'"+aGrupo[nCntFor]+"'"
								Endif	
							Next nCntFor
							If Len(aGrupo) > 0
								cFilSC8QRY  += ")"
							Endif
							cFilSC8QRY  += ")"
						EndIf
					EndIf
				Else
			#ENDIF
			If lFiltra .Or. lSolic
				cFiltraSC8 := "C8_FILIAL=='"+xFilial("SC8")+"' .And. "
				cFiltraSC8 += "C8_NUMPED=='"+Space(Len(SC8->C8_NUMPED))+"'"
			EndIf
			If ( lSolic )
				If ( Ascan(aGrupo,"*") == 0 )
					cFiltraSC8  += If(Empty(cFiltraSC8),cFiltraSC8," .And. ")
					cFiltraSC8  += "(C8_GRUPCOM=='"+Space(Len(SC8->C8_GRUPCOM))+"'"
					For nCntFor := 1 To Len(aGrupo)
						If nCntFor == 1 
							cFiltraSC8 += ".Or.C8_GRUPCOM $ '"+aGrupo[nCntFor]+""
						Else
							cFiltraSC8 += ","+aGrupo[nCntFor]
						Endif	
					Next nCntFor
					If Len(aGrupo) > 0
						cFiltraSC8  += "'"
					Endif
					cFiltraSC8  += ")"
				EndIf
			EndIf
		   #IFDEF TOP
		      Endif
	       #ENDIF
		EndIf
		#IFDEF TOP
			If !Empty(cFilUserQry)
				cFilSC8QRY += If(Empty(cFilSC8QRY),AllTrim(cFilUserQry)," And "+AllTrim(cFilUserQry))
			EndIf
		#ELSE   
			If !Empty(cFilUser)
				cFiltraSC8 += If(Empty(cFiltraSC8),AllTrim(cFilUser)," .And. "+AllTrim(cFilUser))
			EndIf
			bFiltraBrw := {|| FilBrowse("SC8",@aIndexSC8,@cFiltraSC8) }
			Eval(bFiltraBrw)
		#ENDIF
	EndIf

	#IFDEF TOP
		MBrowse( 6, 1,22,75,"SC8",aFixe,,,,,aCores,,,,,,,,cFilSC8QRY)
	#ELSE
		MBrowse( 6, 1,22,75,"SC8",aFixe,,,,,aCores)
	#ENDIF

		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a integridade da rotina             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC8")
	RetIndex("SC8")
	dbClearFilter()
	aEval(aIndexSc8,{|x| Ferase(x[1]+OrdBagExt())})
	SetKey( VK_F12, Nil )

Return()

Static Function MenuDef()     

	PRIVATE aRotina	:= {{STR0005,"Pesqbrw"    , 0 , 1, 0, .F.},;	//"Pesquisar"
						{STR0006,"u_HDA08A" , 0 , 2, 0, nil},;	//"Visual"
						{STR0007,"u_HDA08A" , 0 , 6, 8, nil},;	//"Analisar"
						{STR0023,"A160Legenda", 0 , 5, 0, .F.}}		//"Legenda"
						
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("MTA160MNU")
		ExecBlock("MTA160MNU",.F.,.F.)
	EndIf
	
Return(aRotina) 

User Function HDA08A(cAlias,nReg,nOpcX)

	Local aArea		:= GetArea()
	Local aTitles   := {    OemToAnsi(STR0009),;	//"Planilha"
							OemToAnsi(STR0010),;	//"Auditoria"
							OemToAnsi(STR0011),;	//"Fornecedor"
							OemToAnsi(STR0012)}		//"Historico"
							
	Local oSize
	Local oSize2
	Local aSizeAut	:= {}
	Local aObjects	:= {}
	Local aInfo 	:= {}
	Local aInfo2 	:= {}
	Local aPosGet	:= {}
	Local aPosObj	:= {}
	Local aPosObj3	:= {}
	Local aPosObj4	:= {}
	Local aRet160PLN:= {}
	
	Local aPlanilha := {}
	Local aAuditoria:= {}
	Local aCotacao  := {}
	Local aListBox  := {}
	Local aHeadUltF := {}
	Local aRefImpos := {}
	Local aCabec	:= {"",0,Array(31,2),Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil}
	Local aSC8      := {} 
	Local aCT5      := {}
	Local bCtbOnLine:= {||.T.}
	Local lProceCot := MV_PAR17==1
	Local bPage	    := {}
	Local bOk		:= {||IIF(MA160TOK(nOpcX,nReg,aPlanilha,aAuditoria,aCotacao,aCabec,aSC8,aCpoSC8),Eval({|| Eval(bPage,0),nOpcA:=1,IIf(A160FeOdlg(lProceCot,@nOpcA,l160Visual,aCabec,aCotacao,aAuditoria),oDlg:End(),.F.)}),.F.)}
	Local bCancel	:= {||oDlg:End()}
	Local cLoteCtb  := ""
	Local cArqCtb   := ""
	Local c652      := ""
	Local lSugere	:= MV_PAR01==1 
	Local lTes		:= MV_PAR02==1
	Local lEntrega	:= MV_PAR03==1
	Local lDtNeces  := MV_PAR04==1
	Local lSelFor   := (MV_PAR05==1 .Or. !lSugere)
	Local lBestFor  := MV_PAR09==1
	Local lNota     := MV_PAR10==1
	Local lCtbOnLine:= MV_PAR11==1 .And. SC7->(FieldPos("C7_DTLANC"))<>0 .And. VerPadrao("652")
	Local lAglutina := MV_PAR12==1
	Local lDigita   := MV_PAR13==1
	Local l160Visual:= aRotina[nOpcX,4] <> 3 .And. aRotina[nOpcX,4] <> 4 .And. aRotina[nOpcX,4] <> 6
	Local lMT160ok  := .T.
	Local lSigaCus  := .T.
	Local nOpcA		:= 0
	Local nToler    := MV_PAR08
	Local nX		:= 0
	Local nY		:= 0
	Local nOpcGetd  := nOpcX
	Local nHdlPrv   := 0
	Local nTotalCtb := 0
	Local nScanCot  := 0
	Local nPosNumCot:= 0
	Local nSaveSX8  := GetSX8Len()
	Local nResHor   := GetScreenRes()[1] //Tamanho resolucao de video horizontal
	Local nResVer   := GetScreenRes()[2] //Tamanho resolucao de video horizontal
	Local oDlg
	Local oFont
	Local oScroll
	Local cNumCot  := SC8->C8_NUM
	Local cProdCot := ""
	Local cItemCotID  := ""
	Local cMoeda   := SubStr(GetMv("MV_SIMB"+GetMv("MV_MCUSTO"))+Space(4),1,4)
	Local lProd1   := .T.
	Local aAreaSC8 := SC8->(GetArea())
	Local aSaveSC8 := {}
	Local aPedidos := {}
	Local aHeadSC8 := {}
	Local aColsSC8 := {}
	
	Local nScanGrd := 0
	Local nScanIte := 0
	Local nScanFor := 0
	Local nScanLoj := 0
	Local nScanNum := 0
	
	Local nPos     := 0
	Local nLoop    := 0
	Local nLoop1   := 0
	Local aCpoSC8  := {}
	Local aCtbDia  := {}
	Local lContinua:= .T.
	
	Local nPFornSCE := 0
	Local nPLojaSCE := 0
	Local nPPropSCE := 0
	Local nPItemSCE := 0
	Local nPQtdeSCE := 0
	Local nPUsrQtd  := 0
	Local nPUsrItem := 0
	Local nPUsrForn := 0
	Local nPUsrLoja := 0
	Local nPUsrProp := 0
	Local nPACCNUM  := 0
	Local nPACCITEM := 0
	Local aAutItems := {}
	Local nItmAuto  := 0
	Local nForAuto  := 0
	LOcal nForVenc  := 0
	Local cCotACC	:= "(SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. Empty(SC8->C8_NUMPED))"
	Local cCompACC  := ""
	Local aDadosACC := {}
	Local lIntegDef :=  FindFunction("GETROTINTEG") .And. FindFunction("FWHASEAI") .And. FWHasEAI("MATA120",.T.,,.T.)
	Local cAliasSC7 := "SC7"
	// Projeto - botoes F5 e F6 para movimentacao
	// guarda as teclas atuais
	Local bOldF5 := SetKey(VK_F5)
	Local bOldF6 := SetKey(VK_F6)  
	
	Local lVencFor	:= .F.
	Local nVencFor
	Local lPrjCni := FindFunction("ValidaCNI") .And. ValidaCNI()
	
	#IFDEF TOP
		Local cQuery    := ""
		Local cAliasCot := ""
	#ENDIF	
	
	PRIVATE aHeader     := {}
	PRIVATE aCols       := {}
	PRIVATE nMoedaAval  := 1
	PRIVATE oFolder
	If !lProceCot
		PRIVATE aProds  := {}
	Endif	
	
	bPage := {|n| Eval(oFolder:bSetOption,1),oFolder:nOption:=1,Ma160Page(n,@aCabec,@aPlanilha,@aAuditoria,@aCotacao,oScroll,lProceCot,aCpoSC8,@oDlg,aPosGet)}
	
	PRIVATE aLinGrade := {}
	PRIVATE aCotaGrade:= {}
	PRIVATE lGrade    := MaGrade()
	PRIVATE oGrade	  := MsMatGrade():New('oGrade',,"CE_QUANT",,"A160GValid()",,;
	  						{ 	{"CE_QUANT"  ,NIL,NIL},;
								{"CE_ENTREGA",NIL,NIL}, ;
								{"CE_ITEMGRD",NIL,NIL} })
	PRIVATE ALTERA    := .T.   // Necessario para o objeto grade
	Private _OGUM		:= Nil
	Private _cUM		:= SC8->C8_UM
	
	oGrade:lShowButtonRepl := .F.

	IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
		Aviso(STR0027,STR0029,{STR0028}) //"Atualizar patch do programa SIGACUS.PRW !!!"
		lSigaCus := .F.
	EndIf
	IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
		Aviso(STR0027,STR0030,{STR0028}) //"Atualizar patch do programa SIGACUSA.PRW !!!"
		lSigaCus := .F.
	EndIf
	IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
		Aviso(STR0027,STR0031,{STR0028}) //"Atualizar patch do programa SIGACUS.PRW !!!"
		lSigaCus := .F.
	EndIf
	If !(FindFunction("UPDCOM01_V") .And. UPDCOM01_V() >= 20070615)
		Final(STR0072) // "Atualizar UPDCOM01_V.PRW ou checar o processamento deste UPDATE !!!"
	EndIf
	
	If SC8->(FieldPos('C8_ACCNUM')) > 0 
		If FunName() # "RPC" .And. !Empty(SC8->C8_ACCNUM)
			If !l160Visual
				Aviso( "Portal MarketPlace" , "Esta cotação poderá ser manipulada somente via Portal MarketPlace" ,{ STR0028 })  //"Portal MarketPlace"#"Esta cotação poderá ser manipulada somente via Portal MarketPlace"
				lContinua := .F.
			EndIf
		EndIf
	EndIf
	
	If lContinua .And. lSigaCus
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA)
		RegToMemory("SA2",.F.,.T.)
		PcoIniLan("000052")
	    
	    If !lProceCot
			#IFDEF TOP
				dbSelectArea("SC8")
				cAliasCot:= GetNextAlias()
				cQuery := "SELECT DISTINCT C8_PRODUTO, C8_IDENT "
				cQuery += "FROM "+RetSqlName("SC8")+" SC8 "
				cQuery += "WHERE SC8.C8_FILIAL='"+xFilial("SC8")+"' AND "
				cQuery += "SC8.C8_NUM='"+cNumCot+"' AND "
				cQuery += "SC8.D_E_L_E_T_=' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCot,.T.,.T.)
				While (cAliasCot)->(!Eof())
				    AADD(aProds,{(cAliasCot)->C8_PRODUTO,(cAliasCot)->C8_IDENT,IIF(lProd1,"X"," "),cNumCot})
				    If lProd1
					    cProdCot := (cAliasCot)->C8_PRODUTO
					    cItemCotID := (cAliasCot)->C8_IDENT
					    lProd1 := .F.
					Endif    
					(cAliasCot)->(dbSkip())
				EndDo
				dbSelectArea(cAliasCot)
				dbCloseArea()
	   		#ELSE
	   			dbSelectArea("SC8")
	   			dbSetOrder(4)
	   			dbSeek(xFilial("SC8")+cNumCot)
	   			While !Eof() .And. SC8->C8_FILIAL+SC8->C8_NUM == xFilial("SC8")+cNumCot
				    nPos := Ascan(aProds,{|x| x[1]==SC8->C8_PRODUTO .And. x[2]==SC8->C8_IDENT})
				    If nPos == 0
					    AADD(aProds,{SC8->C8_PRODUTO,SC8->C8_IDENT,IIF(lProd1,"X"," "),cNumCot})
					    If lProd1
						    cProdCot := SC8->C8_PRODUTO
						    cItemCotID := SC8->C8_IDENT
						    lProd1 := .F.
						Endif    
					Endif	
		   			dbSkip()
	   			EndDo
			#ENDIF
			RestArea(aAreaSC8)
		Endif	
		
		If MultLock("SC8",{cNumCot},1)
	
			If FMntCot(@aCabec,@aPlanilha,@aAuditoria,@aCotacao,@aListBox,@aRefImpos,lTes,nOpcX==2,lProceCot,cProdCot,cItemCotID,.T.,aSC8,aCpoSC8, @aHeadSC8, @aColsSC8)

				If ( nOpcX == 3 .And. (lSugere .Or. !lSelFor) )
					MaAvCotVen(@aPlanilha,@aCotacao,@aAuditoria,aCABEC[CAB_HFLD2],lEntrega,nToler,lNota,lBestFor,,aCpoSC8,lSelFor)
				EndIf
				
				dbSelectArea(aCabec[CAB_ARQTMP])      
				
					aSizeAut := MsAdvSize()
			
					aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],315,{{001,013,070,195,230,295,195,230},;
						{007,038,101,140,204,245,007,038,101,140}, {210,255}, {003,043,096,139,191,218} })
		
					aObjects := {}
					AAdd( aObjects, { 000, 025, .T., .F. } )
					AAdd( aObjects, { 100, 100, .T., .T., .T. } )
					aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
					aPosObj := MsObjSize( aInfo, aObjects )
		
					aObjects := {}
					AAdd( aObjects, { 000, 100, .T., .T. } )
					AAdd( aObjects, { 100, 084, .T., .T.} )			
					aInfo2 := { 0, 0, aPosObj[2,3] - 3, aPosObj[2,4] - 13, 2, 2 }	
					aPosObj3 := MsObjSize( aInfo2, aObjects, .T. ) 	
			
					aObjects := {}
					AAdd( aObjects, { 000,100, .T., .T., .T. } )
					AAdd( aObjects, { 000,100, .T., .T., .T. } )	
					aInfo2 := { 129, 0, aPosObj[2,3] - 3, aPosObj[2,4] - 13, 2, 2 }	
					aPosObj4 := MsObjSize( aInfo2, aObjects ) 	
					
					oSize := FwDefSize():New()             
					oSize:AddObject( "CABECALHO",  100, 15, .T., .T. ) // Totalmente dimensionavel
					oSize:AddObject( "FOLDER"   ,  100, 85, .T., .T. ) // Totalmente dimensionavel 
					
					oSize:lProp 	:= .T. // Proporcional             
					oSize:aMargins 	:= { 0, 0, 0, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
					
					oSize:Process() 	   // Dispara os calculos      
					
					oSize2 := FwDefSize():New()
					
					oSize2:aWorkArea := oSize:GetNewCallArea( "FOLDER" ) 
					
					oSize2:AddObject( "SELECT" ,  100, 100, .T., .T.) // Totalmente dimensionavel 
					  
					oSize2:lProp := .T.               // Proporcional             
					oSize:aMargins 	:= { 0, 0, 0, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
					
					oSize2:Process() // Dispara os calculos  
					
					DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
					DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0013) ;	//"An lise de Cota‡”es"
											FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL	
											
					oScrollBox := TScrollBox():new(oDlg,oSize:GetDimension("CABECALHO","LININI")+3, oSize:GetDimension("CABECALHO","COLINI")+3,;
														 oSize:GetDimension("CABECALHO","LINEND"), oSize:GetDimension("CABECALHO","COLEND")-4,;
														 .T.,.T.,.T.)

					DEFINE FONT oFont SIZE 8,0 BOLD
					
			   		@ oSize:GetDimension("CABECALHO","LININI")+3, oSize:GetDimension("CABECALHO","COLINI")+3  SAY aCabec[CAB_SAYGET,1,1] PROMPT RetTitle("C8_PRODUTO") SIZE 22,09 PIXEL OF oScrollBox
					@ oSize:GetDimension("CABECALHO","LININI")  , oSize:GetDimension("CABECALHO","COLINI")+35 MSGET aCabec[CAB_SAYGET,2,1] VAR aCabec[CAB_SAYGET,2,2] PICTURE PesqPict("SC8","C8_PRODUTO",30) SIZE 105,09 WHEN .F. PIXEL OF oScrollBox
					@ oSize:GetDimension("CABECALHO","LININI")+15,oSize:GetDimension("CABECALHO","COLINI")+3  SAY _oSUM PROMPT OemToAnsi("UM") SIZE 30,09 PIXEL OF oScrollBox //"Saldo"
					_cUM	:= SB1->(GetAdvFVal("SB1","B1_UM",xFilial("SB1") + aCabec[CAB_SAYGET,2,2],1))
					@ oSize:GetDimension("CABECALHO","LININI")+15,oSize:GetDimension("CABECALHO","COLINI")+35 MSGET _OGUM VAR _cUM PICTURE "@!" SIZE 30,09 WHEN .F. PIXEL OF oScrollBox
			
					oScroll := TScrollBox():New( oScrollBox, oSize:GetDimension("CABECALHO","LININI"), oSize:GetDimension("CABECALHO","COLINI")+150, 25,180)
					@ 02, 02 SAY aCabec[CAB_SAYGET,3,1] PROMPT aCabec[CAB_SAYGET,3,2] SIZE 120,80 PIXEL Of oScroll
					aCabec[CAB_SAYGET,3,1]:Disable()
			
					@ oSize:GetDimension("CABECALHO","LININI")+3 ,oSize:GetDimension("CABECALHO","COLINI")+356 SAY   aCabec[CAB_SAYGET,4,1] PROMPT RetTitle("C8_QUANT") SIZE 30,09 PIXEL OF oScrollBox
					@ oSize:GetDimension("CABECALHO","LININI")   ,oSize:GetDimension("CABECALHO","COLINI")+410 MSGET aCabec[CAB_SAYGET,5,1] VAR aCabec[CAB_SAYGET,5,2] PICTURE PesqPict("SC8","C8_QUANT",30) SIZE 60,09 WHEN .F. PIXEL OF oScrollBox
					@ oSize:GetDimension("CABECALHO","LININI")+3 ,oSize:GetDimension("CABECALHO","COLINI")+570 SAY   aCabec[CAB_SAYGET,6,1] PROMPT aCabec[CAB_SAYGET,6,2] SIZE 30,09 COLOR CLR_BLUE PIXEL OF oScrollBox FONT oFont
					@ oSize:GetDimension("CABECALHO","LININI")+15,oSize:GetDimension("CABECALHO","COLINI")+356 SAY   aCabec[CAB_SAYGET,7,1] PROMPT OemToAnsi(STR0014) SIZE 30,09 PIXEL OF oScrollBox //"Saldo"
					@ oSize:GetDimension("CABECALHO","LININI")+15,oSize:GetDimension("CABECALHO","COLINI")+410 MSGET aCabec[CAB_SAYGET,8,1] VAR aCabec[CAB_SAYGET,8,2] PICTURE PesqPict("SC8","C8_QUANT",30) SIZE 60,09 WHEN .F. PIXEL OF oScrollBox
					@ oSize:GetDimension("CABECALHO","LININI")+3,oSize:GetDimension("CABECALHO","COLINI")+531 SAY   _oSItem PROMPT "Item/It.Total" SIZE 30,09 PIXEL OF oScrollBox FONT oFont
//					_cItem	:= SubStr(aCabec[CAB_SAYGET,6,1]:cCaption,1,TamSX3("C8_ITEM")[1])
//					@ oSize:GetDimension("CABECALHO","LININI")+15,oSize:GetDimension("CABECALHO","COLINI")+570 MSGET _oGItem VAR _cItem PICTURE PesqPict("SC8","C8_ITEM") SIZE 40,09 WHEN .F. PIXEL OF oScrollBox
					
					oFolder := TFolder():New(oSize:GetDimension("FOLDER","LININI")+10, oSize:GetDimension("FOLDER","COLINI"),aTitles,{"HEADER"},oDlg,,,,.T.,.F.,;
											oSize:GetDimension("FOLDER","XSIZE"), oSize:GetDimension("FOLDER","YSIZE")-13)
					oFolder:bSetOption:={|x| Ma160Fld(x,oFolder:nOption,oFolder,@aCabec,@aListBox,aPosObj3, @aColsSC8)}
		

					//Folder 1 - Planilha
					aCabec[CAB_MARK]:=MsSelect():New(aCabec[CAB_ARQTMP],"PLN_OK",,aCabec[CAB_HFLD1],.F.,"XX",;
																{oSize2:GetDimension("SELECT","LININI"), oSize2:GetDimension("SELECT","COLINI"),oSize2:GetDimension("SELECT","LINEND")-25, oSize2:GetDimension("SELECT","COLEND")},,,oFolder:aDialogs[1])
					aCabec[CAB_MARK]:oBrowse:lCanAllMark := .F.
					If ( nOpcX == 3 )
						If ( lSelFor )
							aCabec[CAB_MARK]:bMark := {|| Ma160Marca(@aCabec,@aPlanilha,@aCotacao,oScroll,@aListBox,aCpoSC8) }
						Else
							aCabec[CAB_MARK]:bAval := {|| .T. }
							nOpcGetd := 2
						Endif
					Else
						aCabec[CAB_MARK]:bAval := {|| .T. }
						nOpcGetd := 2
					EndIf	
		
					
					//Folder 2 - Auditoria
					aHeader := aCabec[CAB_HFLD2]
					aCols   := aAuditoria[1]
					aCabec[CAB_GETDAD]:=MSGetDados():New(oSize2:GetDimension("SELECT","LININI"),oSize2:GetDimension("SELECT","COLINI"),; 
						/*08*/							  oSize2:GetDimension("SELECT","LINEND")-25,oSize2:GetDimension("SELECT","COLEND"),;
														  		nOpcGetd,"Ma160LinOk","","",.T.,,,,300,,,,,oFolder:aDialogs[2])
					aCabec[CAB_GETDAD]:oBrowse:bValid := {|lGrava| Ma160VldGd(@aCabec,@aPlanilha,@aCotacao,lGrava,aCpoSC8) }
		
					
					//Folder 3 - Fornecedor - Informaoes Cadastrais       
					aCabec[CAB_MSMGET]:=MsMGet():New("SA2",SA2->(RecNo()),1,,,,,{aPosObj3[1,1],aPosObj3[1,2],aPosObj3[1,3]+17,aPosObj3[1,4]-155},,2,,,,oFolder:aDialogs[3],,.T.,,,.F.)
		
					SA2->(dbSetOrder(1))
					SA2->(MsSeek(xFilial("SA2")+(aCabec[CAB_ARQTMP])->PLN_FORNECE+(aCabec[CAB_ARQTMP])->PLN_LOJA))
					@ 013,aPosObj3[1,4]-130 SAY STR0051             SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Saldo Historico"
					@ 027,aPosObj3[1,4]-130 SAY STR0052+" "+cMoeda  SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Maior Compra"
					@ 041,aPosObj3[1,4]-130 SAY STR0053+" "+cMoeda  SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Maior Nota"
					@ 055,aPosObj3[1,4]-130 SAY STR0054+" "+cMoeda  SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Maior Saldo"
					@ 069,aPosObj3[1,4]-130 SAY STR0055+" "+cMoeda  SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Saldo Historico em"
					@ 083,aPosObj3[1,4]-130 SAY STR0056             SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Maior Atraso"
					@ 013,aPosObj3[1,4]-070 MSGET aCabec[CAB_SAYGET,14,1] VAR aCabec[CAB_SAYGET,14,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_SALDUP",19)
					@ 027,aPosObj3[1,4]-070 MSGET aCabec[CAB_SAYGET,15,1] VAR aCabec[CAB_SAYGET,15,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_MCOMPRA",19)
					@ 041,aPosObj3[1,4]-070 MSGET aCabec[CAB_SAYGET,16,1] VAR aCabec[CAB_SAYGET,16,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_MNOTA",19)
					@ 055,aPosObj3[1,4]-070 MSGET aCabec[CAB_SAYGET,17,1] VAR aCabec[CAB_SAYGET,17,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_MSALDO",19)
					@ 069,aPosObj3[1,4]-070 MSGET aCabec[CAB_SAYGET,18,1] VAR aCabec[CAB_SAYGET,18,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_SALDUPM",19)
					@ 083,aPosObj3[1,4]-070 MSGET aCabec[CAB_SAYGET,19,1] VAR aCabec[CAB_SAYGET,19,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesqPictQt("A2_MATR")
					                                                                                                
					@ 103,aPosObj3[1,4]-117 BUTTON STR0057 SIZE 100,012 ACTION A160ToFC030(aCabec) OF oFolder:aDialogs[3] PIXEL //"Consulta Posicao do Fornecedor"
					aCabec[CAB_COTACAO] := MsNewGetDados():New((aPosObj3[2,1]+17),(aPosObj3[2,2]),(aPosObj3[2,3]-45),(aPosObj3[2,4]+5),0,,,,,,,,,,oFolder:aDialogs[3],aHeadSC8,(aColsSC8[1][(aCabec[CAB_ARQTMP])->(RecNo())]))
		
					//Folder 4 - Historico Produto - Gets Estoque Consolidado
					If !SetMDIChild()
						If nResHor < 1600
						    aPosGet[4,02]:= CalcRes(8,nResHor,,.T.)
						    aPosObj4[1,2]:= CalcRes(8,nResHor,,.T.)+60
						    aPosObj4[2,2]:= CalcRes(8,nResHor,,.T.)+60
						Else
						    aPosGet[4,02]:= CalcRes(6,nResHor,,.T.)
						    aPosObj4[1,2]:= CalcRes(6,nResHor,,.T.)+60
						    aPosObj4[2,2]:= CalcRes(6,nResHor,,.T.)+60			    
						EndIf
					Else
						If nResHor < 1600
						    aPosGet[4,02]:= CalcRes(7,nResHor,,.T.)
						    aPosObj4[1,2]:= CalcRes(7,nResHor,,.T.)+60
						    aPosObj4[2,2]:= CalcRes(7,nResHor,,.T.)+60
						Else
						    aPosGet[4,02]:= CalcRes(5,nResHor,,.T.)
						    aPosObj4[1,2]:= CalcRes(5,nResHor,,.T.)+60
						    aPosObj4[2,2]:= CalcRes(5,nResHor,,.T.)+60
						EndIf
					Endif

					If  ( nResHor/nResVer < 1.4 )
						aPosObj4[1,3]:= aPosObj4[1,3]-CalcRes(1,nResHor,,.T.)
						aPosObj4[2,3]:= aPosObj4[2,3]-CalcRes(1,nResHor,,.T.)
					ElseIf ( nResHor/nResVer > 1.7 )
						aPosObj4[1,3]:= aPosObj4[1,3]-CalcRes(2,nResHor,,.T.)-10
						aPosObj4[2,3]:= aPosObj4[2,3]-CalcRes(2,nResHor,,.T.)-10
					Else
						aPosObj4[1,3]:= aPosObj4[1,3]-CalcRes(2.5,nResHor,,.T.)-10
						aPosObj4[2,3]:= aPosObj4[2,3]-CalcRes(2.5,nResHor,,.T.)-10
					EndIf
					
					@ aPosObj4[1,1]+03,003 SAY STR0068 OF oFolder:aDialogs[4] PIXEL FONT oBold COLOR CLR_RED //"Estoque Consolidado"
					@ aPosObj4[1,1]+13,003 TO aPosObj4[1,1]+14,120 OF oFolder:aDialogs[4] PIXEL 
					@ 019,aPosGet[4,01] SAY STR0060 OF oFolder:aDialogs[4] PIXEL //"Quantidade Disponivel    "
					@ 019,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,20,1] VAR aCabec[CAB_SAYGET,20,2] Picture PesqPict("SB2","B2_QATU") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 033,aPosGet[4,01] SAY STR0063 OF oFolder:aDialogs[4] PIXEL //"Quantidade Empenhada "
					@ 033,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,21,1] VAR aCabec[CAB_SAYGET,21,2] Picture PesqPict("SB2","B2_QEMP") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 047,aPosGet[4,01] SAY STR0061 OF oFolder:aDialogs[4] PIXEL //"Saldo Atual   "
					@ 047,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,22,1] VAR aCabec[CAB_SAYGET,22,2] Picture PesqPict("SB2","B2_QATU") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 061,aPosGet[4,01] SAY STR0064 OF oFolder:aDialogs[4] PIXEL //"Qtd. Entrada Prevista"
					@ 061,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,23,1] VAR aCabec[CAB_SAYGET,23,2] Picture PesqPict("SB2","B2_SALPEDI") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 075,aPosGet[4,01] SAY STR0062 OF oFolder:aDialogs[4] PIXEL //"Qtd. Pedido de Vendas  "
					@ 075,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,24,1] VAR aCabec[CAB_SAYGET,24,2] Picture PesqPict("SB2","B2_QPEDVEN") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 089,aPosGet[4,01] SAY STR0066 OF oFolder:aDialogs[4] PIXEL //"Qtd. Reservada  "
					@ 089,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,25,1] VAR aCabec[CAB_SAYGET,25,2] Picture PesqPict("SB2","B2_RESERVA") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 103,aPosGet[4,01] SAY STR0065 OF oFolder:aDialogs[4] PIXEL //"Qtd. Empenhada S.A."
					@ 103,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,26,1] VAR aCabec[CAB_SAYGET,26,2] Picture PesqPict("SB2","B2_QEMPSA") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 117,aPosGet[4,01] SAY RetTitle("B2_QTNP")    OF oFolder:aDialogs[4] PIXEL
					@ 117,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,27,1] VAR aCabec[CAB_SAYGET,27,2] Picture PesqPict("SB2","B2_QTNP") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 131,aPosGet[4,01] SAY RetTitle("B2_QNPT")    OF oFolder:aDialogs[4] PIXEL
					@ 131,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,28,1] VAR aCabec[CAB_SAYGET,28,2] Picture PesqPict("SB2","B2_QNPT") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 145,aPosGet[4,01] SAY RetTitle("B2_QTER")    OF oFolder:aDialogs[4] PIXEL 
					@ 145,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,29,1] VAR aCabec[CAB_SAYGET,29,2] Picture PesqPict("SB2","B2_QTER") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 159,aPosGet[4,01] SAY RetTitle("B2_QEMPN")   OF oFolder:aDialogs[4] PIXEL 
					@ 159,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,30,1] VAR aCabec[CAB_SAYGET,30,2] Picture PesqPict("SB2","B2_QEMPN") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
					@ 173,aPosGet[4,01] SAY RetTitle("B2_QACLASS") OF oFolder:aDialogs[4] PIXEL 
					@ 173,aPosGet[4,02] MsGet aCabec[CAB_SAYGET,31,1] VAR aCabec[CAB_SAYGET,31,2] Picture PesqPict("SB2","B2_QACLASS") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
			
					@ aPosObj4[1,1]+03,aPosObj4[1,2] SAY STR0069 OF oFolder:aDialogs[4] PIXEL FONT oBold COLOR CLR_RED //"POSIÇÃO ANALITICA"
					@ aPosObj4[1,1]+13,aPosObj4[1,2] TO aPosObj4[1,1]+14,aPosObj4[1,2]+aPosObj4[1,3] OF oFolder:aDialogs[4] PIXEL 
					@ aPosObj4[1,1]+17,aPosObj4[1,2] LISTBOX aCabec[CAB_HISTORI] FIELDS TITLE "" SIZE aPosObj4[1,3],aPosObj4[1,4]-17 OF oFolder:aDialogs[4] PIXEL
					aCabec[CAB_HISTORI]:aHeaders := {STR0058,STR0059,STR0060,STR0061,STR0062,STR0063,STR0064,STR0065,STR0066,RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER"),RetTitle("B2_QEMPN"),RetTitle("B2_QACLASS")}	
					aCabec[CAB_HISTORI]:SetArray({Array(14)})
					aCabec[CAB_HISTORI]:bLine := {|| aCabec[CAB_HISTORI]:aArray[aCabec[CAB_HISTORI]:nAt] }
					aCabec[CAB_HISTORI]:bChange := {|| A160UltFor(aCabec[CAB_HISTORI]:aArray[aCabec[CAB_HISTORI]:nAt,2],aCabec) }
					@ 190,aPosGet[4,01] BUTTON STR0070 SIZE 100,012 ACTION A160ComView(aCabec[CAB_HISTORI]:aArray[aCabec[CAB_HISTORI]:nAt,2]) OF oFolder:aDialogs[4] PIXEL //"Mais Informacoes do Produto"
					MaUltForn("",@aHeadUltF)
					@ aPosObj4[2,1]+03,aPosObj4[2,2] SAY STR0071 OF oFolder:aDialogs[4] PIXEL FONT oBold COLOR CLR_RED //"Ultimos Fornecimentos"
					@ aPosObj4[2,1]+13,aPosObj4[2,2] TO aPosObj4[2,1]+14,aPosObj4[2,2]+aPosObj4[2,3] OF oFolder:aDialogs[4] PIXEL 
					@ aPosObj4[2,1]+17,aPosObj4[2,2] LISTBOX aCabec[CAB_ULTFORN] FIELDS TITLE "" SIZE aPosObj4[2,3],aPosObj4[2,4]-45 OF oFolder:aDialogs[4] PIXEL
					aCabec[CAB_ULTFORN]:aHeaders := aHeadUltF
					aCabec[CAB_ULTFORN]:SetArray({aHeadUltF})
					aCabec[CAB_ULTFORN]:bLine := {|| aCabec[CAB_ULTFORN]:aArray[aCabec[CAB_ULTFORN]:nAt] }
					
					For nX := 1 to Len(oFolder:aDialogs)
						DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nX]
					Next nX
					
					ACTIVATE MSDIALOG oDlg ON INIT Ma160Bar(oDlg,bOk,bCancel,nOpcX,bPage,nReg,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,lProceCot,aSC8,aCpoSC8, aHeadSC8, aColsSC8)
					
				If ( Select(aCabec[CAB_ARQTMP])<> 0 )
					dbSelectArea(aCabec[CAB_ARQTMP])
					dbCloseArea()
					dbSelectArea("SC8")
				EndIf
	
			Else
				nOpcA := 0
			EndIf  
		    SC8->(MsUnlockAll())
		Endif
	   
	
		// Projeto - botoes F5 e F6 para movimentacao
		// restaura as teclas
		SetKey(VK_F5,bOldF5)
		SetKey(VK_F6,bOldF6)
	
		If nOpcA == 1 .And. !l160Visual
			aAuditoria := A160Audit(aCabec,aAuditoria,aSC8,aCotagrade)
	    EndIf
	
		If nOpcA == 1 
	
			If Len(aCotacao) >= 1
				nPosNumCot  := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_NUM"})
				Private cA160num:= aCotacao[1,1,nPosNumCot,2]
			Endif
		
		EndIf
	
		If nOpcA == 1 .And. !l160Visual
		
			If lPrjCni
				For nVencFor := 1 To Len(aPlanilha)				
					aEval(aPlanilha[nVencFor], {|x| IIF (Alltrim(x[1])=='XX', lVencFor := .T. , .F. )})			
				Next nVencFor	                    	
			EndIf
			
			If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
				GSPF200(aCotacao)
			EndIf
	
			If lCtbOnLine
				dbSelectArea("SX5")
				dbSetOrder(1)
				If MsSeek(xFilial("SX5")+"09COM")
					cLoteCtb := AllTrim(X5Descri())
				Else
					cLoteCtb := "COM "
				EndIf		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa um execblock                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If At(UPPER("EXEC"),X5Descri()) > 0
					cLoteCtb := &(X5Descri())
				EndIf				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa o arquivo de contabilizacao                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nHdlPrv:=HeadProva(cLoteCtb,"MATA160",Subs(cUsuario,7,6),@cArqCtb)
				IF nHdlPrv <= 0
					HELP(" ",1,"SEM_LANC")
					lCtbOnLine := .F.
				EndIf
				If lCtbOnLine
					bCtbOnLine := {|| nTotalCtb += DetProva(nHdlPrv,"652","MATA120",cLoteCtb,,,,,@c652,@aCT5),;
					SC7->C7_DTLANC := dDataBase}
				EndIf
				
			EndIf
			
			//-- Tratamentos para o ACC gerar os pedidos de compra
			//-- com o grupo de aprovacao correto e gravando o numero ACC
			If (nPos := aScan(aAutoCab,{|x| x[1] == "COMPACC"})) > 0
				cCompACC := aAutoCab[nPos,2]
			EndIf
			
			If !Empty(aDadosACC)
				aEval(aDadosACC, {|x| aAdd(aAuditoria[x[1]][x[2]],aAutoItens[x[3]][x[4]][nPACCNUM][2]),aAdd(aAuditoria[x[1]][x[2]],aAutoItens[x[3]][x[4]][nPACCITEM][2])})
			EndIf
			
			Begin Transaction
				If ( MaAvalCOT("SC8",4,aSC8,aCABEC[CAB_HFLD2],aAuditoria,lDtNeces,Nil,bCtbOnLine,cCompACC) )
					EvalTrigger()
					While ( GetSX8Len() > nSaveSX8 )
						ConfirmSx8()		
					EndDo
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Conforme situacao do parametro abaixo, integra com SIGAGSP ³
					//³ MV_SIGAGSP - 0-Nao / 1-Integra                             ³
					//³ Para gerar os contratos no GSp                             ³
					//³ Solicitado por Roberto Mazzarolo em 25/10/2004 por e-mail  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If GetNewPar("MV_SIGAGSP","0") == "1"
						GSPF370(aCotacao,aCABEC[CAB_HFLD2],aAuditoria)
					EndIf
				Else
					While ( GetSX8Len() > nSaveSX8 )
						RollBackSx8()
					EndDo
				EndIf          		
	
			End Transaction 
			
			If lPrjCni
				//Caio.Santos - 11/01/13 - Req.72
				RSTSCLOG("ANL",1,/*cUser*/)
			EndIf
	
			aSaveSC8 := SC8->(GetArea())
			cNumCot  := SC8->C8_NUM
			SC8->(DbSeek( xFilial("SC8")+ SC8->C8_NUM ))
			// -- Verifica todos os pedidos gerados para a cotação.
			While !SC8->(Eof()) .And. cNumCot == SC8->C8_NUM
				If aScan(aPedidos,{|x| xFilial("SC8",x[1])+x[2] == SC8->(C8_FILIAL+C8_NUMPED)}) == 0
					aAdd(aPedidos,{cFilAnt,SC8->C8_NUMPED})
				End
				SC8->(DbSkip())
			End
			//-- Envia todos os pedidos para Marketplace
			For nX := 1 To Len(aPedidos)
				SC7->(DbSeek(xFilial("SC7")+aPedidos[nX][2]))
				If SuperGetMV("MV_MKPLACE",.F.,.F.) .And. lIntegDef  .And. SC7->(FieldPos("C7_ACCNUM")) > 0 .And. SC7->C7_CONAPRO $ " L" ;
					.And. SC7->C7_TPOP $ " F" .And. !Empty(AllTrim(SC7->C7_ACCNUM))
					cA120Num := SC7->C7_NUM
					Inclui:=.T.
					StartJob("MaEnvPed",GetEnvServer(),.F.,cEmpAnt,cFilAnt,cA120Num)
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envia os dados para o modulo contabil     ?                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCtbOnLine
					RodaProva(nHdlPrv,nTotalCtb)
					If nTotalCtb > 0
						If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
							cCodDia := CTBAVerDia() 
							aCtbDia := {{"SC7",SC7->(RECNO()),cCodDia,"C7_NODIA","C7_DIACTB"}}
						Else
						    aCtbDia := {}
						EndIF
		
						cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina,,,,,,aCtbDia)
					EndIf
				EndIf
			Next nX
			RestArea(aSaveSC8)
			
		Else
			While ( GetSX8Len() > nSaveSX8 )
				RollBackSx8()
			EndDo
			MsUnLockAll()
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza processo de lancamento do PCO                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoFinLan("000052")
		PcoFreeBlq("000052")
		
		If ( Select(aCabec[CAB_ARQTMP])<> 0 )
			dbSelectArea(aCabec[CAB_ARQTMP])
			dbCloseArea()
			dbSelectArea("SC8")
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui arquivo de trabalho gerado por MontaCot na Comxfun ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If File(aCabec[CAB_ARQTMP]+GetDBExtension())
			Ferase(aCabec[CAB_ARQTMP]+GetDBExtension()) 
		Endif
		
	EndIf
	
	//Descarta o array com informacoes sobre a selecao manual do fornecedor da cotacao 
	aSelManual := {}
	
	RestArea(aArea)

Return()

Static Function Ma160Marca(aCabec,aPlanilha,aCotacao,oScroll,aListBox,aCpoSC8)

Local aArea    	 := GetArea()
Local cCodPro  	 := ""
Local cDescPro 	 := ""
Local cAlias   	 := aCabec[CAB_ARQTMP]
Local nPosAtu  	 := aCabec[CAB_POSATU]
Local nPCodPro 	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_PRODUTO"})
Local nPQtdSC8 	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_QUANT"  })
Local nPNumSC  	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_NUMSC"  })
Local nPItemSC 	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_ITEMSC" })
Local nPItemGrd	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_ITEMGRD"})
Local nSC8Recno	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="SC8RECNO"  })
Local nPQtdSCE 	 := aScan(aCabec[CAB_HFLD2],{|x| Trim(x[2])=="CE_QUANT"  })
Local nPFornSCE	 := aScan(aCabec[CAB_HFLD2],{|x| Trim(x[2])=="CE_FORNECE"})
Local nPLojaSCE	 := aScan(aCabec[CAB_HFLD2],{|x| Trim(x[2])=="CE_LOJA"   })
Local nPPropSCE	 := aScan(aCabec[CAB_HFLD2],{|x| Trim(x[2])=="CE_NUMPRO" })
Local nPItemSCE	 := aScan(aCabec[CAB_HFLD2],{|x| Trim(x[2])=="CE_ITEMCOT"})
Local nPDataSCE	 := aScan(aCabec[CAB_HFLD2],{|x| Trim(x[2])=="CE_ENTREGA"})
Local nLinha   	 := (cAlias)->(RecNo())
Local nSaldo   	 := 0
Local nX       	 := 0
Local nY       	 := 0
Local nG       	 := 0
Local nScan    	 := 0
Local lRet	   	 := .T.
Local aRet160Mar := {}    
Local aRet160Mrk := {}
Local nPlanOK    := aScan(aCpoSC8,"PLN_OK")
Local nPlanTotal := aScan(aCpoSC8,"PLN_TOTAL")
Local nPlanFlag  := aScan(aCpoSC8,"PLN_FLAG")
Local lMarca     := .T.
Local lMt160P    := .T.
Local lTrocaFor	 := ( MV_PAR01 == 1 .And. MV_PAR05 == 1 .And. MV_PAR09 == 1 )	// Traz marcado = Sim / Seleciona Fornec = Sim / Prioriza = Fornec
Local cItemPE	 := ""

// Inicializa a seleção Manual por Item
If Len(aSelManual) < Len(aPlanilha)
	For nX:=Len(aSelManual) To Len(aPlanilha)
		Aadd(aSelManual,.F.)
	Next nX
Endif

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a quantidade selecionada ate o momento                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aCols)
		nSaldo += aCols[nX][nPQtdSCE]
	Next nX

	nSaldo := aCotacao[nPosAtu][1][nPQtdSC8][2] - nSaldo

	If ( nPlanFlag > 0 .And. aPlanilha[nPosAtu][nLinha][nPlanFlag] == 1 .And. !lTrocaFor )
		nSaldo := 0
	EndIf	
	
	If ( nPlanTotal > 0 .And. aPlanilha[nPosAtu][nLinha][nPlanTotal] == 0 )
		Help(" ",1,"A160ATU")
		nSaldo := 0
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a SC esta vinculada a um Edital              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	If (SC1->C1_QUJE>0 .And. !Empty(SC1->C1_CODED) )
		Aviso(STR0027,STR0080+SC1->C1_NUM+STR0081+Alltrim(SC1->C1_CODED)+STR0082,{"Ok"})
		nSaldo := 0
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se um novo fornecedor pode ser escolhido e atualiza os dados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cAlias)->(IsMark("PLN_OK",ThisMark(),ThisInv()))
		If lTrocaFor
			aSelManual[nPosAtu] := .T.
			aPlanilha[nPosAtu][nLinha][nPlanFlag] := 0
		EndIf
		If ( nSaldo == 0 )
			RecLock(cAlias)
			(cAlias)->PLN_OK := ""
			MsUnLock()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe algum fornecedor marcado  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aPlanilha[nPosAtu],{|x| x[nPlanOK] == ThisMark()}) == 0
				lMarca:=.F.
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se vencedor e o Produto for de Grade alimenta a Quantidade do item de Grade com a quantidade do SC8.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
			aCols[nLinha][nPFornSCE] + aCols[nLinha][nPLojaSCE] + aCols[nLinha][nPPropSCE] + aCols[nLinha][nPItemSCE] })
			
			If Len(aCotaGrade[nScan][6]) > 0

				For nG := 1 To Len(aCotaGrade[nScan][6])
					aCotaGrade[nScan][6][nG][2] := aCotaGrade[nScan][6][nG][6]
					aCotaGrade[nScan][6][nG][3] := aCols[nLinha][nPDataSCE]
				Next nG

				aCols[nLinha][nPQtdSCE] := aCotacao[nPosAtu][1][nPQtdSC8][2]

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Apos marcar um Vencedor e preencher os itens da grade com a quantidade original do SC8, esta rotina  ³
				//³zera as quantidades da grade das propostas dos demais fornecedores da cotacao deste produto.         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nX := 1 To Len(aCotaGrade)
					If Len(aCotaGrade[nX][6]) > 0 .And. nX <> nScan .And. aCotaGrade[nX][4] == aCotaGrade[nScan][4]
						For nY:= 1 to Len(aCotaGrade[nX][6])
							aCotaGrade[nX, 6, nY, 2] := 0
						Next nY
					EndIf
				Next nX
	
				For nX := 1 To Len(aCols)
					If nX <> nLinha
						aCols[nX][nPQtdSCE]:= 0
               		EndIf 
				Next nX
			
   			Else
            	aCols[nLinha][nPQtdSCE] += nSaldo
			EndIf
			
			nSaldo := 0

		EndIf

	Else

		nSaldo += aCols[nLinha][nPQtdSCE]
		aCols[nLinha][nPQtdSCE] := 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao for o vencedor e o Produto for de Grade zera a Quantidade do item de Grade.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
		aCols[nLinha][nPFornSCE] + aCols[nLinha][nPLojaSCE] + aCols[nLinha][nPPropSCE] + aCols[nLinha][nPItemSCE] })
		
		If Len(aCotaGrade[nScan][6]) > 0
			For nG := 1 To Len(aCotaGrade[nScan][6])
				aCotaGrade[nScan][6][nG][2] := 0
			Next nG
		EndIf
		
	EndIf

	If (nPlanOK > 0)
		aPlanilha[nPosAtu][nLinha][nPlanOK] := (cAlias)->PLN_OK
	EndIf
	
	If ExistBlock("M160MARK")
		aRet160Mar := ExecBlock("M160MARK",.F.,.F.,{cAlias,aPlanilha[nPosAtu][nLinha],aCotacao[nPosAtu][nLinha],aListBox,aCabec[CAB_HFLD3]})
		If ValType( aRet160Mar ) == "A" 
			aPlanilha[nPosAtu][nLinha] := aRet160Mar[1]
			aCotacao[nPosAtu][nLinha]  := aRet160Mar[2]
			aListBox := aRet160Mar[3]
        EndIf
        aCabec[CAB_MARK]:oBrowse:Refresh()
        aCabec[CAB_COTACAO]:Refresh()
	EndIf			
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para customizar os arrays utilizados na marcacao do fornecedor vencedor       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	      
	If ExistBlock("M160MRK1")
		aRet160Mrk := ExecBlock("M160MRK1",.F.,.F.,{cAlias,aPlanilha,aCotacao,aListBox,aCabec})
		If ValType( aRet160Mrk ) == "A" 
			aPlanilha := aClone(aRet160Mrk[1])
			aCotacao  := aClone(aRet160Mrk[2])
			aListBox  := aClone(aRet160Mrk[3])
        EndIf           
        aCabec[CAB_MARK]:oBrowse:Refresh()
        aCabec[CAB_COTACAO]:Refresh()
	EndIf  
				
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os dados do cabecalho da analise da cotacao                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC1")
	dbSetOrder(1)
	MsSeek(xFilial("SC1")+aCotacao[nPosAtu][1][nPNumSC][2]+aCotacao[nPosAtu][1][nPItemSC][2])
	
	cCodPro  := SC1->C1_PRODUTO
	cDescPro := SC1->C1_DESCRI
	
	If lGrade .And. !Empty(aCotacao[nPosAtu][1][nPItemGrd][2])
		If (lReferencia := MatGrdPrRf(@cCodPro,.T.))
			cCodPro  := RetCodProdFam(SC1->C1_PRODUTO)
			cDescPro := DescPrRF(cCodPro)
		Endif
	Endif

	_cUM	:= SB1->(GetAdvFVal("SB1","B1_UM",xFilial("SB1") + PadR(AllTRim(cCodPro),TamSX3("B1_COD")[1]),1))
	_OGUM:Refresh()

	aCabec[CAB_SAYGET,2,2] := cCodPro	//Codigo do Produto
	aCabec[CAB_SAYGET,2,1] :Refresh()
	
	aCabec[CAB_SAYGET,3,1]:SetText( Transform( cDescPro, PesqPict("SC8","C8_DESCRI",30) ) ) //Descricao do Produto
	oScroll:Reset()
	
	aCabec[CAB_SAYGET,5,2] := aCotacao[nPosAtu][1][nPQtdSC8][2] //Quantidade
	aCabec[CAB_SAYGET,5,1] :Refresh()
	
	aCabec[CAB_SAYGET,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aPlanilha),3) //Ordem
	aCabec[CAB_SAYGET,6,1] :Refresh()
	
	aCabec[CAB_SAYGET,8,2] := nSaldo //Saldo
	aCabec[CAB_SAYGET,8,1] :Refresh()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a Grade para o Produto Analisado.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A160ColsGrade(aCabec[CAB_SAYGET,2,2], .T.)
	
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Ponto de entrada para ser utilizado antes da validação do SIGAPCO |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MT160PCOK")
	If ValType(aCols)=="A"
		If Len(aCols[1]) >= 9
			cItemPe := aCols[1][9]	// C8_ITEM
		EndIf
	EndIf
	lMt160P := ExecBlock("MT160PCOK",.F.,.F.,{aPlanilha,cItemPE})
	If Valtype(lMt160P) <> "L"
		lMt160P:=.T.
	EndIf
EndIf

If !lMarca
	Aviso(STR0027,STR0074,{STR0028})//"Este fornecedor não pode ser selecionado, pois não atende aos critérios de avaliação solicitados através dos parâmetros da rotina (F12)."
Else
	If SuperGetMV("MV_PCOINTE",.F.,"2")=="1"
		//Variaveis para analise de orcamento
		SC8->(MsGoTo(aCotacao[nPosAtu][nLinha][nSC8Recno][2]))
		SC1->(DbSetOrder(1))
		SC1->(MsSeek(xFilial("SC1")+aCotacao[nPosAtu][nLinha][nPNumSC][2]+aCotacao[nPosAtu][nLinha][nPItemSC][2]))
		
		If !PcoVldLan('000052','02',,,Empty((cAlias)->PLN_OK)) .And. lMt160P 
			//Forca a liberacao de todos os lancamentos de bloqueio, pois cada item é uma liberacao exclusiva
			PcoFreeBlq('000052')
			RecLock(cAlias)
				(cAlias)->PLN_OK := ""
			(cAlias)->(MsUnLock())
			
			//Atualizo a planilha para que, caso tenha havido bloqueio, a planilha não contenha os registros marcados
			//Isso evitará que ao ser pressionado o botão "Próximo" a MarkBrowse seja "ticada" incorretamente
			If ValType(nPlanOk) == "N" .And. nPlanOk > 0
				aPlanilha[nPosAtu][nLinha][nPlanOK] := (cAlias)->PLN_OK							
			EndIf
		Endif
		
		If !(cAlias)->(IsMark("PLN_OK",ThisMark(),ThisInv()))
			nSaldo += aCols[nLinha][nPQtdSCE]
			aCols[nLinha][nPQtdSCE] := 0
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se nao for o vencedor e o Produto for de Grade zera a Quantidade do item de Grade.                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
			aCols[nLinha][nPFornSCE] + aCols[nLinha][nPLojaSCE] + aCols[nLinha][nPPropSCE] + aCols[nLinha][nPItemSCE] })
			
			If Len(aCotaGrade[nScan][6]) > 0
				For nG := 1 To Len(aCotaGrade[nScan][6])
					aCotaGrade[nScan][6][nG][2] := 0
				Next nG
			EndIf		
		EndIf

		_cUM	:= SB1->(GetAdvFVal("SB1","B1_UM",xFilial("SB1") + PadR(AllTRim(cCodPro),TamSX3("B1_COD")[1]),1))
		_OGUM:Refresh()

		aCabec[CAB_SAYGET,2,2] := cCodPro	//Codigo do Produto
		aCabec[CAB_SAYGET,2,1] :Refresh()
		
		aCabec[CAB_SAYGET,3,1]:SetText( Transform( cDescPro, PesqPict("SC8","C8_DESCRI",30) ) ) //Descricao do Produto
		oScroll:Reset()
		
		aCabec[CAB_SAYGET,5,2] := aCotacao[nPosAtu][1][nPQtdSC8][2] //Quantidade
		aCabec[CAB_SAYGET,5,1] :Refresh()
		
		aCabec[CAB_SAYGET,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aPlanilha),3) //Ordem
		aCabec[CAB_SAYGET,6,1] :Refresh()
		
		aCabec[CAB_SAYGET,8,2] := nSaldo //Saldo
		aCabec[CAB_SAYGET,8,1] :Refresh()
		
	Endif
EndIf

RestArea(aArea)

Return(.T.)
Static Function Ma160VldGd(aCabec,aPlanilha,aCotacao,lGrava,aCpoSC8)

Local aArea    := GetArea()
Local cAlias   := aCabec[CAB_ARQTMP]
Local cHelp    := ""
Local cCodPro  := ""
Local cDescPro := ""
Local nPosAtu  := Max(aCabec[CAB_POSATU],1)
Local nPCodPro := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_PRODUTO"})
Local nPQtdSCE := aScan(aCabec[CAB_HFLD2],{|x| Trim(x[2])=="CE_QUANT"})
Local nPQtdSC8 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_QUANT"})
Local nPItemGrd:= aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_ITEMGRD"})
Local nRecNo   := (cAlias)->(RecNo())
Local nSaldo   := 0
Local nX       := 0
Local lRetorno := .T.
Local lMt160lOk:= ExistBlock("MT160LOK")
Local lRet160lOK:= .T.
Local nPlanOK   := aScan(aCpoSC8,"PLN_OK")
Local nPlanFlag := aScan(aCpoSC8,"PLN_FLAG")

DEFAULT lGrava := .T.

lGrava := If(ValType(lGrava)<>"L",.T.,lGrava)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se as quantidades informadas nao superam o quantidade limite  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len(aCols)
	nSaldo += aCols[nX][nPQtdSCE]
Next nX

If ( nSaldo > aCotacao[nPosAtu][1][nPQtdSC8][2] )
	cHelp := "QTDDIF"
	lRetorno := .F.
EndIf

If ( aCols[nRecno][nPQtdSCE] > 0 .And. nPlanFlag > 0 .And. aPlanilha[nPosAtu][nRecno][nPlanFlag] == 1 )
	cHelp := "A160ATU"
	lRetorno := .F.
EndIf

If lMt160lOk
	
	If Len(aCotacao) >= 1
		nPosNumCot  := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_NUM"})
		Private cA160num:= aCotacao[1,1,nPosNumCot,2]
	Endif
	
	lRet160Lok := Execblock("MT160LOK",.F.,.F.,aPlanilha)
	
	If Valtype( lRet160LOK ) == "L"
		lRetorno := lRet160LOK
	EndIf
	
Endif

nSaldo := aCotacao[nPosAtu][1][nPQtdSC8][2] - nSaldo

If ( lRetorno )
	
	If ( lGrava )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza a Planilha de cotacao com base na Planilha de auditoria       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAlias)
		dbGotop()
		
		For nX := 1 To Len(aCols)
			RecLock(cAlias)
			If ( aCols[nX][nPQtdSCE] == 0 )
				(cAlias)->PLN_OK := ""
			Else
				(cAlias)->PLN_OK := "XX"
			EndIf
			MsUnLock()

			If nPlanOK > 0
				aPlanilha[nPosAtu][nX][nPlanOK] := (cAlias)->PLN_OK
			EndIf
			
			dbSelectArea(cAlias)
			dbSkip()
		Next nX
		
		dbSelectArea(cAlias)
		dbGoto(nRecNo)
		
	EndIf
	
Else
	
	If !(Empty(CHelp))
		HELP(" ",1,cHelp)
	EndIf
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os dados do cabecalho da analise da cotacao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+aCotacao[nPosAtu][1][nPCodPro][2])

cCodPro  := SB1->B1_COD
cDescPro := SB1->B1_DESC

If lGrade  .And. !Empty(aCotacao[nPosAtu][1][nPItemGrd][2])
	If (lReferencia := MatGrdPrRf(@cCodPro,.T.))
		cCodPro  := RetCodProdFam(SB1->B1_COD)
		cDescPro := DescPrRF(cCodPro)
	Endif
Endif

If !l160Auto

	_cUM	:= SB1->(GetAdvFVal("SB1","B1_UM",xFilial("SB1") + PadR(AllTRim(cCodPro),TamSX3("B1_COD")[1]),1))
	_OGUM:Refresh()
	
	aCabec[CAB_SAYGET,2,2] := cCodPro	//Codigo do Produto
	aCabec[CAB_SAYGET,2,1] :Refresh()
	
	aCabec[CAB_SAYGET,3,2] := cDescPro //Descricao do Produto
	aCabec[CAB_SAYGET,3,1] :Refresh()
	
	aCabec[CAB_SAYGET,5,2] := aCotacao[nPosAtu][1][nPQtdSC8][2] //Quantidade
	aCabec[CAB_SAYGET,5,1] :Refresh()
	
	aCabec[CAB_SAYGET,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aPlanilha),3) //Ordem
	aCabec[CAB_SAYGET,6,1] :Refresh()
	
	aCabec[CAB_SAYGET,8,2] := nSaldo //Saldo
	aCabec[CAB_SAYGET,8,1] :Refresh()
	
	aCabec[CAB_MARK]:oBrowse:Gotop()
EndIf

RestArea(aArea)

Return(lRetorno)

Static Function HDA08C(cAliasSC8,nItem,_nOpc)

	Static lAltC8TxFi := Nil
	
	Local aVencto   := {}
	Local aDupl     := {}
	Local aRet      := {}
	Local aCusto    := {}
	Local nX        := 0
	Local nTaxa     := 0
	Local nValor    := 0
	Local nTotal    := 0
	Local nValBase  := 0
	Local nValIPI   := 0
	Local nValSol   := 0
	Local nRetorno  := 0
	Local lMA160CUS := ExistBlock("MA160CUS")
	Local lMtxFisCo := GetNewPar('MV_PERFORM',.T.) 
	Local nBaseDup  := IIF(lMtxFisCo,MaFisRet(,'NF_BASEDUP'),0)
	Local nTxJuro   := IIF(Alltrim(FunName())=="MATA160",mv_par14,0)
	
	//Indica se ira utilizar as funcoes fiscais para calcular o valor presente. So pode usar esse parametro quem utiliza calculo especifico via ponto de entrada.
	If !lMtxFisCo .And. !lMA160CUS
		nBaseDup  := MaFisRet(,'NF_BASEDUP')
	Endif
	
	If lMA160CUS
		nRetorno := ExecBlock("MA160CUS",.F.,.F.,{cAliasSC8,nItem})
		If Valtype( nRetorno ) <> "N"
			nRetorno := 0
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
		//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
		//| cliente, assim verificando a necessidade de uma atualizacao     |
		//| nestes fontes. NAO REMOVER !!!							        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
			Final(STR0029)  //"Atualizar patch do programa SIGACUS.PRW !!!"
		Endif
		IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
			Final(STR0030) //"Atualizar patch do programa SIGACUSA.PRW !!!"
		Endif
		IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
			Final(STR0031) //"Atualizar patch do programa SIGACUSB.PRW !!!"
		Endif
		
		If lAltC8TxFi == Nil
			nIndSX3 := SX3->(IndexOrd())
			SX3->(dbSetOrder(2))
			lAltC8TxFi := (SX3->(MsSeek('C8_TAXAFIN', .F.)) .And. SX3->X3_VISUAL $ ' A')
			If SX3->(IndexOrd()) # nIndSX3
				SX3->(dbSetOrder(nIndSX3))
			EndIf	
		EndIf
		
		If lAltC8TxFi
			nTaxa := If(Empty(nTxJuro),(cAliasSC8)->C8_TAXAFIN,nTxJuro)
		Else
			nTaxa := If(Empty(nTxJuro),SuperGetMV("MV_JUROS"),nTxJuro)
		EndIf	
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		MsSeek(xFilial("SF4")+(cAliasSC8)->C8_TES)
		If (cAliasSC8)->(FieldPos("C8_MOEDA")<>0)
			nValBase  := xMoeda(nBaseDup,(cAliasSC8)->C8_MOEDA,1,(cAliasSC8)->C8_EMISSAO,,If((cAliasSC8)->(FIELDPOS("C8_TXMOEDA")) > 0,(cAliasSC8)->C8_TXMOEDA,''))
			nValIPI   := xMoeda(MaFisRet(,"NF_VALIPI"),(cAliasSC8)->C8_MOEDA,1,(cAliasSC8)->C8_EMISSAO,,If((cAliasSC8)->(FIELDPOS("C8_TXMOEDA")) > 0,(cAliasSC8)->C8_TXMOEDA,''))
			nValSol   := xMoeda(MaFisRet(,"NF_VALSOL"),(cAliasSC8)->C8_MOEDA,1,(cAliasSC8)->C8_EMISSAO,,If((cAliasSC8)->(FIELDPOS("C8_TXMOEDA")) > 0,(cAliasSC8)->C8_TXMOEDA,''))
			nValICMS  := xMoeda(MaFisRet(,"NF_VALICM"),(cAliasSC8)->C8_MOEDA,1,(cAliasSC8)->C8_EMISSAO,,If((cAliasSC8)->(FIELDPOS("C8_TXMOEDA")) > 0,(cAliasSC8)->C8_TXMOEDA,''))
			aVencto   := Condicao(nValBase,(cAliasSC8)->C8_COND,nValIPI,dDataBase,nValSol)
		Else
			nValIPI  := MaFisRet(,"NF_VALIPI")
			nValICMS := MaFisRet(,"NF_VALICM")
			aVencto  := Condicao(nBaseDup,(cAliasSC8)->C8_COND,nValIPI,dDataBase,MaFisRet(,"NF_VALSOL"))
			nValBase := nBaseDup
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o array utilizado na geracao das duplicatas    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 to Len(aVencto)
			nValor := MaValPres(aVencto[nX][2],aVencto[nX][1],nTaxa)
			If nX == Len(aVencto) .And. ((nTotal+nValor) <> nValBase .And. !(nTaxa > 0))
				nValor += (nBaseDup - (nTotal+nValor) )
			EndIf
			nTotal += nValor
			aADD(aRet,{'MT160  ','   ',' ',aVencto[nX][1],nValor})
		Next nX
	
		For nX := 1 to Len(aRet)
			aAdd(aDupl,aRet[nX][2]+"³"+aRet[nX][1]+"³ "+aRet[nX][3]+" ³"+DTOC(aRet[nX][4])+"³ "+Transform(aRet[nX][5],PesqPict("SE2","E2_VALOR",14,1)))
		Next nX
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		MsSeek(xFilial("SF4")+(cAliasSC8)->C8_TES)
		If  cPaisLoc <> "BRA"
			aadd(aCusto,{nTotal,;
				0,;
				0,;
				"N",;
				"N",;
				"0",;
				"0",;
				(cAliasSC8)->C8_PRODUTO,;
				RetFldProd(SB1->B1_COD,"B1_LOCPAD"),;
				(cAliasSC8)->C8_QUANT,;
				0})
		Else
			aadd(aCusto,{nTotal-IIf(!Empty((cAliasSC8)->C8_TES).And.SF4->F4_IPI=="R",0,nValIPI)+MaFisRet(nItem,"IT_VALCMP"),;
				nValIPI,;
				nValICMS,;
				If(Empty((cAliasSC8)->C8_TES),"N",SF4->F4_CREDIPI) ,;
				If(Empty((cAliasSC8)->C8_TES),"N",SF4->F4_CREDICM),;
				MaFisRet(nItem,"IT_NFORI"),;
				MaFisRet(nItem,"IT_SERORI"),;
				(cAliasSC8)->C8_PRODUTO,;
				RetFldProd(SB1->B1_COD,"B1_LOCPAD"),;
				(cAliasSC8)->C8_QUANT,;
				If(!Empty((cAliasSC8)->C8_TES).And.SF4->F4_IPI=="R",;
				nValIPI,0) })
		EndIf
	
		nRetorno := _fHD8RCE(aDupl,aCusto,'N',,,_nOpc, cAliasSC8)[1][1]

EndIf

Return(nRetorno)

Static Function _fHD8RCE(aDupl,aCusto,cTipo,lDevCompra,lDevQtd0, _nOpc, cAliasSC8)
	
	Static lMTARETDC := ExistBlock('MTARETDC')
	
	Local aArea     := GetArea()
	Local aAreaSD1  := SD1->(GetArea("SD1"))
	Local aDVenc    := {}
	Local aValor    := {}
	Local aValImp   := {}
	Local dAux
	Local i         := 0
	Local j         := 0
	Local nTotDupl  := 0
	Local nValTot   := 0
	Local nValIpi   := 0
	Local nValIcm   := 0
	Local nIpiAtc   := 0
	Local nValIcmret:= 0
	Local nValEstIcm:= 0
	Local nValCOF   := 0
	Local nValImp   := 0
	Local nIVCred	:= 0
	Local nValPisPas:= 0
	Local nTaxaOri	:= 0
	Local nTaxaDest := 0
	Local nC		:= 0
	Local nValSN    := 0
	Local nValAnti	:= 0
	Local lCredCOF  := .F.
	Local lCredPIS  := .F.
	Local lDevSimb	:= (cPaisLoc <> "BRA" .And. cTipo == "B" .And. SF1->F1_TIPODOC == '63')
	Local nTaxaEIC  := .F.
	Local lCredSN   := .F.
	Local cMoeda    := ""
	Local aCustoEnt := Array(Len(aCusto), 5)
	Local cParamCus := Upper(AllTrim(GetMV("MV_CUSENT")))
	Local lICMRCus  := SuperGetMv('MV_ICMRCUS',.F.,.F.) 
	Local cCalcImpV := GetMV("MV_GERIMPV")
	Local dData     := SF1->F1_DTDIGIT
	Local nTamData 	:= IIF(__SetCentury(),10,8)
	Local nTamDocStr:= 0
	Local nTamDoc   := 0        		
	Local nDifTam   := 0
	Local aMoedDecs := {0,0,0,0,0} 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para Informar quantas casa decimais serao utulizadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMTARETDC
		aMoedDecs := ExecBlock('MTARETDC',.F.,.F.)
		If Valtype(aMoedDecs) <> "A"
			aMoedDecs := {0,0,0,0,0} 
		EndIf				
	EndIf 
	
	DEFAULT lDevQtd0 := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis de localizacoes para a entrada de Nota em varias |
	//| moeda e comtaxa variavel. Bruno 13/07/2000                 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTaxa		:=	SF1->F1_TXMOEDA
	nMoedaNF    :=	Iif(Type("nMoedaNF")=="U",1,nMoedaNF)
	
	aDupl := If(aDupl == Nil,{},aDupl)
	cTipo := If(cTipo == Nil," ",cTipo)
	lDevCompra 	:= If(lDevCompra==Nil,.F.,lDevCompra)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o tamanho da nota conforme string passada no aDupl |
	//| e a diferença para notas de 6 posições                     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTamDocStr:= IIf(ValType(aDupl) == "A" .And. !Empty(aDupl),Len(SubStr(aDupl[1],5,At("/",aDupl[1])-12)),0)
	nTamDoc   := IIf(nTamDocStr > 0,nTamDocStr,TamSX3("D1_DOC")[1])
	nDifTam   := IIf(nTamDoc > 6, nTamDoc - 6, 0)
	
	If lDevCompra
		cTipo := "D"
		SD1->(dbSetOrder(1))
		If !SD1->(MsSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI))
			cTipo := " "
		EndIf
		dData := SD2->D2_EMISSAO
		nTaxa	:=	SF2->F2_TXMOEDA
	EndIf
	
	nTaxaOri := IIf(nTaxa==0,RecMoeda(dData , nMoedaNF),nTaxa)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Utilizacao dos elementos definidos como LOCAL na funcao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// aDVenc-> Array bidimensional, dimensao 1 data de vencimento do titulo
	// aDVenc->                      dimensao 2 proporcao da data em relacao ao total
	// aValor-> Array unidimensional, para valor de cada vencimento
	// nTotDupl-> Somatoria dos desdobramentos dos titulos.
	// aCustoEnt-> Custo de Entrada para as 5 moedas.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Avalia duplicatas digitadas p/ separar valores e venctos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aDupl)
		For i:=1 To Len(aDupl)
			AADD(aDVenc, {DataValida(Ctod(Subs(aDupl[i], 16 + nDifTam, nTamData))), 0})
			AADD(aValor, DesTrans(Subs(aDupl[i], 27 + nDifTam, 18)))
			nTotDupl += DesTrans(Subs(aDupl[i], 27 + nDifTam, 18))
		Next i
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula proporcionalidade dos vencimentos            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i:=1 To Len(aDVenc)
			aDVenc[i][2] := (aValor[i] / nTotDupl)
		Next i
	Else
		dAux := IF(cTipo == "D",SD2->D2_EMISSAO,If(lDevCompra,SD2->D2_EMISSAO,SD1->D1_DTDIGIT))
		AADD(aDVenc, { dAux, 1 } )
	EndIf
	
	If cCalcImpV == "S" .And. (Len(aCusto)>0 .And. ValType(aCusto[1][2])=="A")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para Multi-Moedas, converter o custo com base na    ³
		//³ do pedido de compra qdo moeda do Pedido diferente de 1.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLucasÄÙ
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC))
		If SC7->(Found()) .and. SC7->C7_MOEDA <> 1
			dData := SC7->C7_EMISSAO
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo do Custo considerando os Impostos Variaveis, Clientes  ³
		//³ Internacionais...                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLucasÄÙ
		For i:=1 To Len(aCusto)
			For j:=1 To 5
				aCustoEnt[i][j]:=0.00
			Next j
		Next i
	
		For i:=1 To Len(aCusto)
	
			If cTipo != "D" .And. ValType(aCusto[i][2])=="A" .And. !lDevSimb
				For j:=1 To 5
					nValimp	:=	0
					nTaxaDest:=	IIf(nMoedaNF==j ,nTaxaOri, RecMoeda(dData , j))
					nTaxaCus	:=	nTaxaDest/nTaxaOri
					If j > 1
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Cuando NF de Importacao para Localizacoes, considerar as Taxas ³
						//³ de SW6, SW9 e SWD para as moedas 2 e 3 somente...              ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLucasÄÙ
						If (cPaisLoc != "BRA" .Or. cParamCus $ "TXINFORMADA")
							If (!SF1->F1_TIPO_NF $ "9AB" .And. !Empty(SF1->F1_HAWB))
								DbSelectArea("SW9")
								DbSetOrder(3)
								If MsSeek(xFilial("SW9")+SF1->F1_HAWB)
									If j == SimbToMoeda(SW9->W9_MOE_FOB) .and. SW9->W9_FORN == SF1->F1_FORNECE
										nTaxaDest := SW9->W9_TX_FOB
										nTaxaCus  := nTaxaDest/nTaxaOri
									EndIf
								EndIf
							EndIf
						EndIf
	
						If !(cParamCus $ "DIARIO" .Or. cParamCus $ "TXINFORMADA").And. Len(aDupl) > 0
							nValTot := CSoma(  aDVenc, aCusto[i][1], j )
							For nC := 1 To Len(aCusto[i][2])
								If 	Subs(aCusto[i][2][nC][5],3,1 ) == "1" //Quando incide no custo
									nValImp += CImposVar(aCusto[i][2][nC][4],j,aCusto[i][2][nC][1],dData)
								ElseIf Subs(aCusto[i][2][nC][5],3,1 ) == "2" //Quando nao incide no custo
									nValImp -= CImposVar(aCusto[i][2][nC][4],j,aCusto[i][2][nC][1],dData)
								EndIf
							Next nC
						Else
							nValTot := aCusto[i][1] / nTaxaCus
							For nC := 1 To Len(aCusto[i][2])
								If 	Subs(aCusto[i][2][nC][5],3,1 ) == "1" //Quando incide no custo
									nValImp += (aCusto[i][2][nC][4] / nTaxaCus)
								ElseIf Subs(aCusto[i][2][nC][5],3,1 ) == "2" //Quando nao incide no custo
									nValImp -= (aCusto[i][2][nC][4] / nTaxaCus)
								EndIf
							Next nC
						EndIf
					Else
						nValTot := aCusto[i][1]
						For nC := 1 To Len(aCusto[i][2])
							If 	Subs(aCusto[i][2][nC][5],3,1 ) == "1" //Quando incide no custo
								nValImp += aCusto[i][2][nC][4]
							ElseIf Subs(aCusto[i][2][nC][5],3,1 ) == "2" //Quando nao incide no custo
								nValImp -= aCusto[i][2][nC][4]
							EndIf
						Next nC
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calcula o Custo de Entrada                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aCustoEnt[i][j] := nValTot + nValimp
				Next j
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Na devolucao de Venda,busca o custo da Nf Origem      ³
				//³aCusto[i][6] -> Numero da nf Origem                   ³
				//³aCusto[i][7] -> Serie da nf Origem                    ³
				//³aCusto[i][8] -> Produto                               ³
				//³aCusto[i][9] -> Local (almoxarifado)                  ³
				//³aCusto[i][10] -> Quantidade devolvida                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aCustoDev := PegaCmDev(.T.,aCusto[i][6],aCusto[i][7],aCusto[i][8],aCusto[i][9],aCusto[i][10],,,lDevCompra)
				For j := 1 to 5
					aCustoEnt[i][j] := aCustoDev[j]
				Next
			EndIf
		Next i
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ C lculo do Custo Normal considerando IPI, ICMS, PIS, COFINS e impostos variaveis.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i:=1 To Len(aCusto)
	
			lCredPIS := .F.
			lCredCOF := .F.
	        lCredSN	 := .F.
			nValimpV :=	0
			
			If cTipo != "D"  .And. !lDevSimb
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se efetua o credito do PIS / Pasep                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len( aCusto[i] ) > 16
					lCredPIS := aCusto[i,15] $ "13" .And. IIf(lDevQtd0,aCusto[i,16] $ "1|2",aCusto[i,16] $ "1")
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se efetua o credito do COFINS                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len( aCusto[i] ) > 17
					lCredCOF := aCusto[i,15] $ "23" .And. IIf(lDevQtd0,aCusto[i,16] $ "1|2",aCusto[i,16] $ "1")
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se efetua o credito presumido do simples nacional     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len( aCusto[i] ) > 19 .And. aCusto[i,20] <> Nil .And. aCusto[i,20] > 0
					lCredSN := .T.
				EndIf
	
				For j := 1 To 5
					nTaxaEIC := .F.
					nTaxaDest:=	IIf(nMoedaNF==j ,nTaxaOri, RecMoeda(dData , j))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Para as Notas fiscais de importacao deve-se considerar a taxa  ³
					//³ informada no SW9.                                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cParamCus $ "TXINFORMADA"
						If (!SF1->F1_TIPO_NF $ "9AB" .And. !Empty(SF1->F1_HAWB))
							DbSelectArea("SW9")
							DbSetOrder(3)
							If MsSeek(xFilial("SW9")+SF1->F1_HAWB)
								If j == SimbToMoeda(SW9->W9_MOE_FOB) .And. SW9->W9_FORN == SF1->F1_FORNECE
									nTaxaDest := SW9->W9_TX_FOB
									nTaxaEIC  := .T.
								EndIf
							EndIf
						EndIf
					EndIf
					nTaxaCus := nTaxaDest/nTaxaOri
					If j > 1 .Or. nMoedaNF <> 1
						If !(cParamCus $ "DIARIO" .Or. cParamCus $ "TXINFORMADA") .And. Len(aDupl) > 0 .And. nMoedaNF <> 1
							If cTipo # "P"
								nValTot    := CSoma(  aDVenc, aCusto[i][1]+aCusto[i][2]/nTaxaCus, j )
							Else
								nValTot    := CSoma(  aDVenc, aCusto[i][1]/nTaxaCus, j )
							EndIf
							nValIpi := CImpos( aCusto[i][2]/nTaxaCus, j, "P",dData )
							nValIcm := CImpos( aCusto[i][3]/nTaxaCus, j, "I",dData )
							If Len(aCusto[i]) > 12 .And. aCusto[i][13]!=NIL
								nValIcmRet := CImpos( aCusto[i][13]/nTaxaCus,j, "I",dData )
							Else
								nvalIcmRet := 0
							EndIf
							If Len(aCusto[i]) > 10
								nIpiAtc := Cimpos(aCusto[i][11]/nTaxaCus,j,"P",dData )
							Else
								nIpiAtc :=0
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³A posicao 14 do array aCusto, contem um array com os impostos variaveis que interferem no custo.    ³
							//³Aqui esta sendo acumulado este valor, considerando os impostos que devem ser somados ou subtraidos, ³
							//³em um unico montante (nIVCred) que sera retirado do valor do custo, pois se refere ao total de      ³
							//³que sera creditado                                                                                  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Len(aCusto[i]) > 13 .And. !Empty(aCusto[i][14]) .And. ValType(aCusto[i][14]) == "A"
								nIVCred := 0
								Aeval(aCusto[i][14], { |x| nIVCred += CSoma(  aDVenc, x[2]/nTaxaCus, j )} )		   						
							EndIf
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Apura o valor do PIS / Pasep                                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lCredPIS
								nValPisPas := Cimpos(aCusto[i,17],j,"S",dData )
							Else
								nValPisPas := 0
							EndIf
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Apura o valor do COFINS                                        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lCredCOF
								nValCOF := Cimpos(aCusto[i,18],j,"S",dData )
							Else
								nValCOF := 0
							EndIf
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Apura o valor do Credito Presumido Simples Nacional            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lCredSN
								nValSN := aCusto[i,20]
							Else
								nValSN := 0
							EndIf
	
						Else
							If cTipo # "P"
								nValTot    := xMoeda((aCusto[i][1]+aCusto[i][2]),nMoedaNF,j,dData,If(aMoedDecs[j]==0,MsDecimais(j),aMoedDecs[j]),nTaxaOri,nTaxaDest)
							Else
								nValTot    := xMoeda(aCusto[i][1],nMoedaNf,j,dData,If(aMoedDecs[j]==0,MsDecimais(j),aMoedDecs[j]),nTaxaOri,nTaxaDest)
							EndIf
							nValIpi := xMoeda(aCusto[i][2],nMoedaNf,j,dData,If(aMoedDecs[j]==0,MsDecimais(j),aMoedDecs[j]),nTaxaOri,nTaxaDest)
							nValIcm := xMoeda(aCusto[i][3],nMoedaNf,j,dData,If(aMoedDecs[j]==0,MsDecimais(j),aMoedDecs[j]),nTaxaOri,nTaxaDest)
							If Len(aCusto[i]) > 12 .And. aCusto[i][13]!=NIL
								nValIcmRet := xMoeda(aCusto[i][13],nMoedaNf,j,dData,If(aMoedDecs[j]==0,MsDecimais(j),aMoedDecs[j]),nTaxaOri,nTaxaDest)
							Else
								nValIcmRet := 0
							EndIf
							If Len(aCusto[i]) > 10 .And. aCusto[i][11]!=NIL
								nIpiAtc := xMoeda(aCusto[i][11],nMoedaNf,j,dData,If(aMoedDecs[j]==0,MsDecimais(j),aMoedDecs[j]),nTaxaOri,nTaxaDest)
							Else
								nIpiAtc :=0
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³A posicao 14 do array aCusto, contem um array com os impostos variaveis que interferem no custo.    ³
							//³Aqui esta sendo acumulado este valor, considerando os impostos que devem ser somados ou subtraidos, ³
							//³em um unico montante (nIVCred) que sera retirado do valor do custo, pois se refere ao total de      ³
							//³que sera creditado                                                                                  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Len(aCusto[i]) > 13 .And. !Empty(aCusto[i][14]) .And. ValType(aCusto[i][14]) == "A"
								nIVCred := 0
								Aeval(aCusto[i][14], { |x| nIVCred += x[2]} )
								nIVCred	:=	nIVCred/nTaxaCus
							EndIf
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Apura o valor do PIS / Pasep                                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lCredPIS
								nValPisPas := aCusto[i,17] / IIf( j > 1 .And. nTaxaEIC,nTaxaDest,RecMoeda(dData ,j))
							Else
								nValPisPas := 0
							EndIf
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Apura o valor do COFINS                                        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lCredCOF
								nValCOF := aCusto[i,18] / IIf( j > 1 .And. nTaxaEIC,nTaxaDest,RecMoeda(dData ,j))
							Else
								nValCOF := 0
							EndIf
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Apura o valor do Credito Pressumido Simples Nacional           ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lCredSN
								nValSN := aCusto[i,20]  / IIf( j > 1 .And. nTaxaEIC,nTaxaDest,RecMoeda(dData ,j))
							Else
								nValSN := 0
							EndIf
	
						EndIf
					Else
						nValTot    := aCusto[i][1]
						nValIpi    := aCusto[i][2]
						nValIcm    := aCusto[i][3]
						If Len(aCusto[i]) > 18 .And. aCusto[i][19]!=NIL
							nValEstIcm := aCusto[i][19]
						EndIf
						If Len(aCusto[i]) > 12 .And. aCusto[i][13]!=NIL
							nValIcmRet := aCusto[i][13]
						Else
							nValIcmRet := 0
						EndIf
						If Len(aCusto[i]) > 10 .And. aCusto[i][11]!=NIL
							nIpiAtc := aCusto[i][11]
						Else
							nIpiAtc :=0
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³A posicao 14 do array aCusto, contem um array com os impostos variaveis que interferem no custo.    ³
						//³Aqui esta sendo acumulado este valor, considerando os impostos que devem ser somados ou subtraidos, ³
						//³em um unico montante (nIVCred) que sera retirado do valor do custo, pois se refere ao total de      ³
						//³que sera creditado                                                                                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Len(aCusto[i]) > 13  .And. !Empty(aCusto[i][14]) .And. ValType(aCusto[i][14]) == "A"
							nIVCred := 0
							Aeval(aCusto[i][14], { |x| nIVCred += x[2] } )
						EndIf
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apura o valor do PIS / Pasep                                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lCredPIS
							nValPisPas := aCusto[i,17]
						Else
							nValPisPas := 0
						EndIf
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apura o valor do COFINS                                        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lCredCOF
							nValCOF := aCusto[i,18]
						Else
							nValCOF := 0
						EndIf
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apura o valor do Credito Pressumido Simples Nacional           ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lCredSN
							nValSN := aCusto[i,20]
						Else
							nValSN := 0
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apura o valor da Atencipacao de ICMS					       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Len(aCusto[i])>20
							nValAnti:= aCusto[i,21]
						EndIf
	
					EndIf
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³           Calcula o Custo de Entrada                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  aCusto[i][5] == "N"			// Credito de ICMS?
						If cTipo != "I"
							If aCusto[i][4] == "N"		// Credito de IPI?
								If j > 1
									aCustoEnt[i][j] := nValTot   // Ja somei p/ moeda > 1
								Else
									If cTipo == "P"
										aCustoEnt[i][j] := nValTot
									Else
										If _nOpc == 1
											aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot + nValIpi + nValIcmRet)
										Else
											aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot - nValIcm - nValPisPas - nValCOF)
										EndIf
									EndIf
								EndIf
							Else
								If cTipo != "P"
									/*
									aCustoEnt[i][j] := nValTot - nIpiAtc
									If aCusto[i][4] == "S" .and. j > 1
										aCustoEnt[i][j] := nValTot - nValIpi - nIpiAtc
									EndIf
									*/
									If _nOpc == 1
										aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot + nValIpi + nValIcmRet)
									Else
										aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot - nValIcm - nValPisPas - nValCOF)
									EndIf
								Else
									aCustoEnt[i][j] := 0
								EndIf
							EndIf
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Caso o usuario tenha informado valores manualmente na aba "Impostos" os³
							//³mesmos deverao ser adicionados ao custo da nota.                       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//							aCustoEnt[i][j] := Max(0, nValTot - nValICM)
							If _nOpc == 1
								aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot + nValIpi + nValIcmRet)
							Else
								aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot - nValIcm - nValPisPas - nValCOF)
							EndIf
						EndIf
					Else
						If cTipo != "I"
							If nValTot != 0
					//			aCustoEnt[i][j] := nValTot - ( IIf(lCredSN,0,nValIcm) - nValEstIcm )
								If aCusto[i][4] == "N"
									If j = 1 .And. cTipo # "P"
										If _nOpc == 1
											aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot + nValIpi + nValIcmRet)
										Else
											aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot - nValIcm - nValPisPas - nValCOF)
										EndIf
									EndIf
								Else
									If cTipo != "P"
										If _nOpc == 1
											aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot + nValIpi + nValIcmRet)
										Else
											aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot - nValIcm - nValPisPas - nValCOF)
										EndIf
									Else
										aCustoEnt[i][j] := 0
									EndIf
								EndIf
							Else
								If _nOpc == 1
									aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot + nValIpi + nValIcmRet)
								Else
									aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot - nValIcm - nValPisPas - nValCOF)
								EndIf
							EndIf
						Else
							If _nOpc == 1
								aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot + nValIpi + nValIcmRet)
							Else
								aCustoEnt[i][j] := Iif((cAliasSC8)->A2_SIMPNAC=='S',nValTot, nValTot - nValIcm - nValPisPas - nValCOF)
							EndIf
						EndIf
					EndIf
	
				Next j
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Na devolucao de Venda,busca o custo da Nf Origem      ³
				//³aCusto[i][6] -> Numero da nf Origem                   ³
				//³aCusto[i][7] -> Serie da nf Origem                    ³
				//³aCusto[i][8] -> Produto                               ³
				//³aCusto[i][9] -> Local (almoxarifado)                  ³
				//³aCusto[i][10] -> Quantidade devolvida                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aCustoDev := PegaCmDev(.T.,aCusto[i][6],aCusto[i][7],aCusto[i][8],aCusto[i][9],aCusto[i][10],,,lDevCompra)
				For j := 1 to 5
					aCustoEnt[i][j] := aCustoDev[j]
				Next
			EndIf
		Next i
	EndIf
	RestArea(aAreaSD1)
	RestArea(aArea)
Return aCustoEnt

Static Function Ma160Bar(oDlg,bOk,bCancel,nOpc,bPage,nReg,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,lProceCot,aSC8,aCpoSC8, aHeadSC8, aColsSC8)

Local aButtons    := {}
Local aButtonUsr  := {}
Local nX		  := {}
Local cPrinter    := GetNewPar("MV_IMPRCOT"," ")
Local lMa160Imp   := IIf(!Empty( cPrinter ) .And. Existblock( cPrinter ),.T.,.F.)

DEFAULT aCpoSC8   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona os botoes padroes                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aButtons,{"PMSPRINT",{|| IIF(!lMa160Imp,MA160Imp(aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,aCpoSC8),ExecBlock( cPrinter, .F., .F., {nReg,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,aCpoSC8} )) },OemToAnsi(STR0032),OemToAnsi(STR0050) })  

If lProceCot
	aadd(aButtons,{"PREV"    ,{|| Eval(bPage,-1)},OemToAnsi(STR0020),OemToAnsi(STR0020)})	//"Anterior"
	aadd(aButtons,{"NEXT"    ,{|| Eval(bPage,+1)},OemToAnsi(STR0021),OemToAnsi(STR0021)})	//"Proximo"

	// Projeto - botoes F5 e F6 para movimentacao
	// seta as teclas para realizar a movimentacao
	SetKey(VK_F5, {|| Eval(bPage,-1)}) 	//"Anterior"
	SetKey(VK_F6, {|| Eval(bPage,+1)}) 	//"Proximo"

Else
	aadd(aButtons,{"PREV"    ,{|| M160PRVNXT(.T.,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,nOpc,bPage,lProceCot,aSC8,aCpoSC8, aHeadSC8, aColsSC8)},OemToAnsi(STR0020),OemToAnsi(STR0020)})	//"Anterior"
	aadd(aButtons,{"NEXT"    ,{|| M160PRVNXT(.F.,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,nOpc,bPage,lProceCot,aSC8,aCpoSC8, aHeadSC8, aColsSC8)},OemToAnsi(STR0021),OemToAnsi(STR0021)})	//"Proximo"

	// Projeto - botoes F5 e F6 para movimentacao
	// seta as teclas para realizar a movimentacao
	SetKey(VK_F5, {|| M160PRVNXT(.T.,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,nOpc,bPage,lProceCot,aSC8,aCpoSC8, aHeadSC8, aColsSC8)}) 	//"Anterior"
	SetKey(VK_F6, {|| M160PRVNXT(.F.,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,nOpc,bPage,lProceCot,aSC8,aCpoSC8, aHeadSC8, aColsSC8)}) 	//"Proximo"

Endif	

Eval(bPage,1)

Return(EnchoiceBar(oDlg,bOK,bCancel,,aButtons))

Static Function Ma160Page(nSoma,aCabec,aPlanilha,aAuditoria,aCotacao,oScroll,lProceCot,aCpoSC8,oDlg,aPosGet)

Local aArea   	  := GetArea()
Local cCodPro     := ""
Local cDescPro    := ""
Local cAlias      := aCabec[CAB_ARQTMP]
Local nPosAtu     := aCabec[CAB_POSATU]
Local nPosAnt     := nPosAtu
Local nPNumSC     := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_NUMSC"})
Local nPItemSC    := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_ITEMSC"})
Local nPItemGrd   := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_ITEMGRD"})
Local nPQtdSC8    := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_QUANT"})
Local nPGrdSC8    := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_GRADE"})
Local nPQtdSCE    := aScan(aCabec[CAB_HFLD2],{|x| Trim(x[2])=="CE_QUANT"})
Local nPProd      := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_PRODUTO"})
Local nSaldo      := 0
Local nX		  := 0
Local nY	  	  := 0
Local lValido     := .T.
Local lReferencia := Nil
Local lVldQuant   := GetNewPar("MV_DIFQTDC","N") == "N" .And. If(Type('lIsACC')#"L",.T.,!lIsACC)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a validacao do Saldo a Distribuir da pagina atual do Folder    ³
//³ Auditoria. O Par.MV_DIFQTDC usado para permitir que a analise gere PCs ³
//³ mesmo que exista saldo a distribuir so tera efeito com produtos que nao³
//³ usem grade de produto, caso contrario so proseguira a analise quando   ³
//³ nao existir mais saldo a distribuir para os produtos de grade.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nPosAnt <> 0 )
	For nX := 1 To Len(aCols)
		nSaldo += aCols[nX][nPQtdSCE]
	Next nX
	If lVldQuant .Or. aCotacao[nPosAnt][1][nPGrdSC8][2] == "S"
		If ( nSaldo <> aCotacao[nPosAnt][1][nPQtdSC8][2] .And. nSaldo > 0 )
			lValido := .F.	
		EndIf
	Else
		If ( nSaldo > aCotacao[nPosAnt][1][nPQtdSC8][2] .And. nSaldo > 0 )
  			lValido := .F.	
		EndIf
	Endif	
	nSaldo := 0
EndIf

If lValido 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta a nova posicao atual                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	nPosAtu += nSoma
	nPosAtu := Min(nPosAtu,Len(aPlanilha))
	nPosAtu := Max(1,nPosAtu)
	aCabec[CAB_POSATU] := nPosAtu	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o saldo restante a ser selecionado                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldo := 0
	For nX := 1 To Len(aAuditoria[nPosAtu])
		nSaldo += aAuditoria[nPosAtu][nX][nPQtdSCE]
	Next nX

	nSaldo := aCotacao[nPosAtu][1][nPQtdSC8][2] - nSaldo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa o arquivo temporario                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	ZAP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os dados da Planilha de cotacao                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aPlanilha[nPosAtu])
		RecLock(cAlias,.T.)
		For nY := 1 To FCount()
			FieldPut(nY,aPlanilha[nPosAtu][nX][nY])
		Next nY
		MsUnLock()
	Next nX         
	
	aCabec[CAB_MARK]:oBrowse:GoTop()
	aCabec[CAB_MARK]:oBrowse:Refresh()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os dados da Planilha de auditoria                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	N := 1
	If ( nPosAnt <> 0 )
		aCabec[CAB_GETDAD]:oBrowse:lDisablePaint := .T.
		aAuditoria[nPosAnt] := aClone(aCols)
		aCols := aClone(aAuditoria[nPosAtu])
		aCabec[CAB_GETDAD]:oBrowse:lDisablePaint := .F.
		aCabec[CAB_GETDAD]:oBrowse:Refresh()
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os dados do cabecalho da analise da cotacao                   ³
	//| Caso não existir a SC1, busca a descrição da SB1 ou SB5                |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC1")
	dbSetOrder(1)
	If MsSeek(xFilial("SC1")+aCotacao[nPosAtu][1][nPNumSC][2]+aCotacao[nPosAtu][1][nPItemSC][2])
		cCodPro  := SC1->C1_PRODUTO
		cDescPro := SC1->C1_DESCRI
	Else
		cCodPro  := aCotacao[nPosAtu][1][nPProd][2]
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MsSeek(xFilial("SB1")+cCodPro)    
			cDescPro := SB1->B1_DESC
			dbSelectArea("SB5")
			dbSetOrder(1)
			If MsSeek(xFilial("SB5")+cCodPro) 
				cDescPro := SB5->B5_CEME
			EndIf
		EndIf
	EndIf

	If lGrade .And. !Empty(aCotacao[nPosAtu][1][nPItemGrd][2])
		If (lReferencia := MatGrdPrRf(@cCodPro,.T.))
			cCodPro  := RetCodProdFam(SC1->C1_PRODUTO)
			cDescPro := DescPrRF(cCodPro)
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atribuido o codigo do produto a variavel PUBLICA VAR_IXB para uso em ponto de entrada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	VAR_IXB :={}
	aAdd(VAR_IXB,{"PRODUTO", cCodPro}) 
	
		_cUM	:= SB1->(GetAdvFVal("SB1","B1_UM",xFilial("SB1") + PadR(AllTRim(cCodPro),TamSX3("B1_COD")[1]),1))
		_OGUM:Refresh()
	
		aCabec[CAB_SAYGET,2,2] := cCodPro	//Codigo do Produto
		aCabec[CAB_SAYGET,2,1] :Refresh()
	
		aCabec[CAB_SAYGET,3,1]:SetText( Transform( cDescPro, PesqPict("SC8","C8_DESCRI",30) ) )
		oScroll:Reset()
	
		aCabec[CAB_SAYGET,5,2] := aCotacao[nPosAtu][1][nPQtdSC8][2] //Quantidade
		aCabec[CAB_SAYGET,5,1] :Refresh()
		If lProceCot
			aCabec[CAB_SAYGET,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aPlanilha),3) //Ordem
		Else	
			aCabec[CAB_SAYGET,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aProds),3) //Ordem
		Endif	
		aCabec[CAB_SAYGET,6,1] :Refresh()
	
		aCabec[CAB_SAYGET,8,2] := nSaldo //Saldo
		aCabec[CAB_SAYGET,8,1] :Refresh()
Else
	Help(" ",1,"QTDDIF")
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a Grade para o Produto Analisado.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
A160ColsGrade(aCabec[CAB_SAYGET,2,2], .T.)

aCabec[CAB_GETDAD]:oBrowse:refresh()

RestArea(aArea)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ao trocar o produto mantem sempre a MarkBrowse posicionada no   ³
//³no inicio do Arquivo independente do fornecedor selecionado.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
(calias)->(Dbgotop())

Return(.T.)

Static Function MA160TOK(nOpcX,nReg,aPlanilha,aAuditoria,aCotacao,aSC8)
Local lRet		:= .T.
Local nProd		:= aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_PRODUTO"})
Local nX		:= 0
Local cProd		:= ""
Local aAreaSB1	:= SB1->(GetArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Checa se produto está bloqueado                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	For nX := 1 To Len(aCotacao)
		cProd := aCotacao[nX][1][nProd][2]
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MsSeek(xFilial("SB1")+cProd)
			If !RegistroOk("SB1")
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next nX
EndIf

//Ponto de entrada para validar se permite a analise da cotacao
If ExistBlock("MA160TOK")
	lRet:= ExecBlock("MA160TOK",.F.,.F.,{nOpcX,nReg,aPlanilha,aAuditoria,aCotacao,aSC8})
	If ValType (lRet) <> "L"
		lRet:= .T.
	EndIf
EndIf

RestArea(aAreaSB1)

Return lRet

Static Function Ma160Fld(nFldDst,nFldAtu,oFolder,aCabec,aListbox,aPosObj3, aColsSC8)

Local aArea		 := GetArea()
Local aUltForn   := {}
Local aViewSB2   := {}
Local bCampo     := { |n| FieldName(n) }
Local cProduto   := ""
Local nPosAtu    := aCabec[CAB_POSATU]
Local nX         := 0
Local nR         := 0
Local nSaldo     := 0
Local nDuracao   := 0
Local nTotDisp	 := 0
Local nQtPV		 := 0
Local nQemp		 := 0
Local nSalpedi	 := 0
Local nReserva	 := 0
Local nQempSA	 := 0
Local nQtdTerc	 := 0
Local nQtdNEmTerc:= 0
Local nSldTerc	 := 0
Local nQEmpN	 := 0
Local nQAClass	 := 0
Local nScan      := 0
Local nSaldoSB2  := 0
Local lSigaCus   := .T.

DEFAULT aCabec[CAB_ULTFORN]:CARGO := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Aviso(STR0027,STR0029,{STR0028}) //"Atualizar patch do programa SIGACUS.PRW !!!"
	lSigaCus := .F.
EndIf
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Aviso(STR0027,STR0030,{STR0028}) //"Atualizar patch do programa SIGACUSA.PRW !!!"
	lSigaCus := .F.
EndIf
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Aviso(STR0027,STR0031,{STR0028}) //"Atualizar patch do programa SIGACUSB.PRW !!!"
	lSigaCus := .F.
EndIf

If lSigaCus
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua a atualizacao dos dados na Troca dos Folders                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( nFldDst <> nFldAtu )

		aCabec[CAB_MARK]:oBrowse:lDisablePaint := .T.
		aCabec[CAB_GETDAD]:oBrowse:lDisablePaint := .T.
		aCabec[CAB_ULTFORN]:lDisablePaint := .T.
		
		Do Case
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder 1 - Planilha Analisar - Efetua a atualizacao dos dados do Folder³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case ( nFldDst == 1 )
				
				aCabec[CAB_MARK]:oBrowse:lDisablePaint := .F.
				aCabec[CAB_MARK]:oBrowse:Reset()
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder 2 - Auditoria - Efetua a atualizacao dos dados do Folder        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case ( nFldDst == 2 )
				
				aCabec[CAB_GETDAD]:oBrowse:lDisablePaint := .F.
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder 3 - Fornecedor - Efetua a atualizacao dos dados do Folder       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case ( nFldDst == 3 )
				
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+(aCabec[CAB_ARQTMP])->PLN_FORNECE+(aCabec[CAB_ARQTMP])->PLN_LOJA)
				If ( M->A2_COD <> (aCabec[CAB_ARQTMP])->PLN_FORNECE .Or.;
					M->A2_LOJA <> (aCabec[CAB_ARQTMP])->PLN_LOJA )
					For nX := 1 To FCount()
						M->&(EVAL(bCampo,nX)) := FieldGet(nX)
					Next nX
					aCabec[CAB_MSMGET]:EnchRefreshAll()
				EndIf
				aCabec[CAB_SAYGET,14,2]:= SA2->A2_SALDUP
				aCabec[CAB_SAYGET,15,2]:= SA2->A2_MCOMPRA
				aCabec[CAB_SAYGET,16,2]:= SA2->A2_MNOTA
				aCabec[CAB_SAYGET,17,2]:= SA2->A2_MSALDO
				aCabec[CAB_SAYGET,18,2]:= SA2->A2_SALDUPM
				aCabec[CAB_SAYGET,19,2]:= SA2->A2_MATR
				
				aCabec[CAB_COTACAO]:SetArray(aColsSC8[nPosAtu][(aCabec[CAB_ARQTMP])->(RecNo())])
				aCabec[CAB_COTACAO]:Refresh()
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder 4 - Historico do Produto e Estoques - Atualiza os Dados         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case ( nFldDst == 4 )
				
				aCabec[CAB_ULTFORN]:lDisablePaint := .F.
				If aCabec[CAB_ULTFORN]:CARGO <> aCabec[CAB_SAYGET,2,2]
					
					nScan := aScan( aCotaGrade, { |x| x[5] == aCabec[CAB_SAYGET,2,2] } )
					
					For nX := 1 to IIF( Len(aCotaGrade[nScan,6]) > 0 , Len(aCotagrade[nScan,6]) , 1 )

						If Len(aCotaGrade[nScan,6]) > 0
							cProduto := aCotagrade[nScan,6,nX,1]
						Else
							cProduto := aCabec[CAB_SAYGET,2,2]
						EndIf
						
						dbSelectArea("SB2")
						dbSetOrder(1)
						MsSeek(xFilial("SB2")+cProduto)
						While !Eof() .And. xFilial("SB2")+cProduto == SB2->B2_FILIAL+SB2->B2_COD
							If !(SB2->B2_STATUS == '2')
								
								If SB2->B2_LOCAL < MV_PAR15 .Or. SB2->B2_LOCAL > MV_PAR16
									dbSkip()
									Loop
								EndIf
								
								nSaldoSB2:=SaldoSB2(,,,,,"SB2")
								
								aAdd(aViewSB2,{TransForm(SB2->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
								TransForm(SB2->B2_COD,PesqPict("SB2","B2_COD")),;
								TransForm(nSaldoSB2,PesqPict("SB2","B2_QATU")),;
								TransForm(SB2->B2_QATU,PesqPict("SB2","B2_QATU")),;
								TransForm(SB2->B2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
								TransForm(SB2->B2_QEMP,PesqPict("SB2","B2_QEMP")),;
								TransForm(SB2->B2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
								TransForm(SB2->B2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
								TransForm(SB2->B2_RESERVA,PesqPict("SB2","B2_RESERVA")),;
								TransForm(SB2->B2_QTNP,PesqPict("SB2","B2_QTNP")),;
								TransForm(SB2->B2_QNPT,PesqPict("SB2","B2_QNPT")),;
								TransForm(SB2->B2_QTER,PesqPict("SB2","B2_QTER")),;
								TransForm(SB2->B2_QEMPN,PesqPict("SB2","B2_QEMPN")),;
								TransForm(SB2->B2_QACLASS,PesqPict("SB2","B2_QACLASS"))})
								
								nTotDisp	+= nSaldoSB2
								nSaldo		+= SB2->B2_QATU
								nQtPV		+= SB2->B2_QPEDVEN
								nQemp		+= SB2->B2_QEMP
								nSalpedi	+= SB2->B2_SALPEDI
								nReserva	+= SB2->B2_RESERVA
								nQempSA		+= SB2->B2_QEMPSA
								nQtdTerc	+= SB2->B2_QTNP
								nQtdNEmTerc	+= SB2->B2_QNPT
								nSldTerc	+= SB2->B2_QTER
								nQEmpN		+= SB2->B2_QEMPN
								nQAClass	+= SB2->B2_QACLASS
								
							EndIf
							dbSelectArea("SB2")
							dbSkip()
						EndDo
						
					Next nX
					
					If Len(aViewSb2) > 0
						aCabec[CAB_HISTORI]:SetArray(aViewSB2)
						aCabec[CAB_HISTORI]:bLine := {|| aCabec[CAB_HISTORI]:aArray[aCabec[CAB_HISTORI]:nAt] }
						aCabec[CAB_HISTORI]:Refresh()
						
						aCabec[CAB_SAYGET,20,2] := nTotDisp
						aCabec[CAB_SAYGET,21,2] := nQemp
						aCabec[CAB_SAYGET,22,2] := nSaldo
						aCabec[CAB_SAYGET,23,2] := nSalPedi
						aCabec[CAB_SAYGET,24,2] := nQtPv
						aCabec[CAB_SAYGET,25,2] := nReserva
						aCabec[CAB_SAYGET,26,2] := nQEmpSA
						aCabec[CAB_SAYGET,27,2] := nQtdTerc
						aCabec[CAB_SAYGET,28,2] := nQtdNEmTerc
						aCabec[CAB_SAYGET,29,2] := nSldTerc
						aCabec[CAB_SAYGET,30,2] := nQEmpN
						aCabec[CAB_SAYGET,31,2] := nQAClass
						
						A160UltFor(aCabec[CAB_HISTORI]:aArray[aCabec[CAB_HISTORI]:nAt,2],aCabec)
					Else
						Aviso(STR0027,"STR0086",{STR0028})
					EndIf
				EndIf
				
		EndCase
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua Refresh nos Objetos da Getdados da Auditoria e Todos SayGets    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCabec[CAB_GETDAD]:oBrowse:Refresh()
	
	For nR :=14 to Len(aCabec[CAB_SAYGET])
		aCabec[CAB_SAYGET,nR,1]:Refresh()
	Next nR
	
EndIf

RestArea(aArea)

Return(.T.)

Static Function fMntCot(aCabec,aPlanilha,aAuditoria,aCotacao,aListBox,aRefImpos,lTes,lVisual,lProceCot,cProdCot,cItemCotID,lFirsT,aSC8,aCpoSC8, aHeadSC8, aColsSC8)

	Local aArea 	  := GetArea()
	Local aAreaSX3    := SX3->(GetArea())
	Local aStruQry	  := SC8->(dbStruct())
	Local aStruTmp    := {}
	Local aCampoSC8   := {}
	Local aRetM160PL  := {}
	Local aRetStru    := {}
	Local aScanGrd    := {}
	
	Local cNumSC8     := SC8->C8_NUM
	Local cAliasSC8   := "SC8"
	Local cQuery	  := ""
	Local cIdentSC8   := ""
	Local cGrupCom    := ""
	Local cProdRef    := ""
	Local cFiltro     := ".T."
	
	Local lVerifica   := GetMV("MV_QBLQFOR",,"N") == "S"
	Local lSigaGSP    := GetNewPar("MV_SIGAGSP","0")=="0"
	Local lMtxFisCo   := GetNewPar('MV_PERFORM',.T.) //Indica se ira utilizar as funcoes fiscais para calcular o valor presente
	Local lSolic      := SuperGetMv("MV_RESTCOM")=="S"
	Local lQuery	  := .F.
	Local lGrupCom    := .T.
	Local lPedido     := .T.
	Local lRetorno    := .F.
	Local lReferencia := .F. 
	Local lGrade      := MaGrade()
	
	Local nP		  := 0
	Local nX		  := 0
	Local nY		  := 0
	Local nZ		  := 0
	Local nPosRef1    := 0
	Local nPosRef2    := 0
	Local nCusto      := 0
	Local nCusto2	  := 0
	Local nUsadoSC8   := 0
	Local nUsadoSCE   := 0
	Local nScan       := 0
	Local nSC8Fornec  := 0
	Local nSC8Loja    := 0
	Local nSC8NumPro  := 0
	Local nSC8Item    := 0
	Local nSC8Quant   := 0
	Local nSC8Preco   := 0
	Local nSC8Total   := 0
	Local nSC8Scan    := 0
	Local nPlanScan   := 0
	Local nPlanFornec := 0
	Local nPlanLoja   := 0
	Local nPlanNumPro := 0
	Local nPlanItem   := 0
	Local nPlanPreco  := 0
	Local nPlanTotal  := 0
	
	DEFAULT aPlanilha  := {}
	DEFAULT aAuditoria := {}
	DEFAULT aCotacao   := {}
	DEFAULT aListBox   := {}
	DEFAULT aSC8       := {}
	DEFAULT aCabec     := Array(12)
	DEFAULT aCabec[CAB_HFLD1] := {}
	DEFAULT aCabec[CAB_HFLD2] := {}
	DEFAULT aCabec[CAB_HFLD3] := {}
	DEFAULT aRefImpos  := {}
	DEFAULT lTES	   := .F.
	DEFAULT lVisual	   := .F.
	DEFAULT lProceCot  := .T. 
	DEFAULT lFirsT     := .T.
	DEFAULT cProdCot   := " "
	DEFAULT cItemCotID := " "
	DEFAULT aCpoSC8    := {}
	DEFAULT aHeadSC8	:= {}
	DEFAULT aColsSC8	:= {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
	//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
	//| cliente, assim verificando a necessidade de uma atualizacao     |
	//| nestes fontes. NAO REMOVER !!!							        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	    Final("Atualizar SIGACUS.PRW !!!") //"Atualizar SIGACUS.PRW !!!"
	Endif
	IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	    Final("Atualizar SIGACUSA.PRX !!!") //"Atualizar SIGACUSA.PRX !!!"
	Endif
	IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	    Final("Atualizar SIGACUSB.PRX !!!")  //"Atualizar SIGACUSB.PRX !!!"
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao utilizada para verificar a ultima versao do ATUALIZADOR  ³
	//³ do dicionario do modulo de Compras necessario para o uso do     |
	//| recurso de grade produtos no MP10 Relese I deverá ser retirado  |
	//| no proximo Release da Versao quando o dicionario for Atualizado |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(FindFunction("UPDCOM01_V") .And. UPDCOM01_V() >= 20070615)
		Final("Atualizar UPDCOM01_V.PRW ou checar o processamento deste UPDATE !!!") // "Atualizar UPDCOM01_V.PRW ou checar o processamento deste UPDATE !!!"
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a montagem da planilha de fornecimento                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC8")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SC8" )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And.;
				SX3->X3_CONTEXT<>"V" .And. !Trim(SX3->X3_CAMPO)$"C8_ITEM" )
			If lMtxFisCo
				nUsadoSC8++
				If lFirsT
					AADD(aCabec[CAB_HFLD3],TRIM(X3Titulo()))
					AADD(aHeadSC8,{ TRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
								SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT })
				Endif	
				AADD(aCampoSC8,{SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TIPO})
			Else
				If Trim(SX3->X3_CAMPO)$ "C8_NUMPRO#C8_NUMSC#C8_ITEMSC#C8_PRODUTO#C8_PRECO#C8_QUANT#C8_TOTAL#C8_AVISTA"
					nUsadoSC8++
					If lFirsT
						AADD(aCabec[CAB_HFLD3],TRIM(X3Titulo()))
						AADD(aHeadSC8,{ TRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
								SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT })
					Endif	
					AADD(aCampoSC8,{SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TIPO})
				Endif	
			Endif	
		EndIf
		If lFirsT
			nPosRef1	:= At("MAFISREF(",Upper(SX3->X3_VALID))
			If ( nPosRef1 > 0 )
				nPosRef1    += 10
				nPosRef2    := At(",",SubStr(SX3->X3_VALID,nPosRef1))-2
				aadd(aRefImpos,{"SC8",SX3->X3_CAMPO,SubStr(SX3->X3_VALID,nPosRef1,nPosRef2)})
			EndIf
		Endif	
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a montagem da planilha de auditoria                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SCE")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SCE" )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) .Or. AllTrim(SX3->X3_CAMPO) == "CE_NUMPRO"
			If ! AllTrim(SX3->X3_CAMPO) $ "CE_NUMCOT; CE_ITEMCOT"
				nUsadoSCE++
				If lFirsT
					AADD(aCabec[CAB_HFLD2],{ TRIM(X3Titulo()),;
						Trim(SX3->X3_CAMPO),;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT } )
				Endif	
			Endif
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	If aScan(aCabec[CAB_HFLD2], {|z| AllTrim(z[2]) == "CE_ITEMCOT"}) == 0
		dbSetOrder(2)
		dbSeek(Pad("CE_ITEMCOT", 10))
		nUsadoSCE++
		AADD(aCabec[CAB_HFLD2],{ TRIM(X3Titulo()),;
			Trim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		dbSetOrder(1)
	Endif
	
	If aScan(aCabec[CAB_HFLD2], {|z| AllTrim(z[2]) == "CE_NUMCOT"}) == 0
		dbSetOrder(2)
		dbSeek(Pad("CE_NUMCOT", 10))
		nUsadoSCE++
		AADD(aCabec[CAB_HFLD2],{ TRIM(X3Titulo()),;
			Trim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		dbSetOrder(1)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Walk Thru                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ADHeadRec("SCE",aCabec[CAB_HFLD2])
	
	If lFirsT
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua a preparacao dos dados que serao mostrados na planilha          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aadd(aCabec[CAB_HFLD1],{"PLN_OK"     	,"","",""})
/*		aadd(aCabec[CAB_HFLD1],{"PLN_ITEM"		,"",RetTitle("C8_ITEM")		,PesqPict("SC8","C8_ITEM")})
		aadd(aCabec[CAB_HFLD1],{"PLN_DESCC1"	,"",RetTitle("C1_DESCRI")	,PesqPict("SC1","C1_DESCRI")})
		aadd(aCabec[CAB_HFLD1],{"PLN_QUANT"		,"",RetTitle("C8_QUANT")	,PesqPict("SC8","C8_QUANT")})
		aadd(aCabec[CAB_HFLD1],{"PLN_UM"		,"",RetTitle("C8_UM")		,PesqPict("SC8","C8_UM")}) */
		aadd(aCabec[CAB_HFLD1],{"PLN_PRECO"		,"",RetTitle("C8_PRECO")	,PesqPict("SC8","C8_PRECO")})
		aadd(aCabec[CAB_HFLD1],{"PLN_TOTSI"  	,"","Total S/Imposto"		,PesqPict("SC8","C8_TOTAL")})
		aadd(aCabec[CAB_HFLD1],{"PLN_TOTCI"  	,"","Total C/Imposto"		,PesqPict("SC8","C8_TOTAL")})
		aadd(aCabec[CAB_HFLD1],{"PLN_XCOST"  	,"","COST"					,PesqPict("SC8","C8_TOTAL")})
		aadd(aCabec[CAB_HFLD1],{"PLN_XSAVIN"  	,"","Saving"				,PesqPict("SC8","C8_TOTAL")})
		aadd(aCabec[CAB_HFLD1],{"PLN_FRETE"  	,"","Frete"					,PesqPict("SC8","C8_TOTAL")})
		aadd(aCabec[CAB_HFLD1],{"PLN_VLDESC"  	,"","Desconto"				,PesqPict("SC8","C8_TOTAL")})
		aadd(aCabec[CAB_HFLD1],{"PLN_FORNECE"	,"",RetTitle("C8_FORNECE")	,PesqPict("SC8","C8_FORNECE")})
		aadd(aCabec[CAB_HFLD1],{"PLN_LOJA"   	,"",RetTitle("C8_LOJA")		,PesqPict("SC8","C8_LOJA")})
		aadd(aCabec[CAB_HFLD1],{"PLN_NREDUZ" 	,"",RetTitle("A2_NREDUZ")	,PesqPict("SA2","A2_NREDUZ")})
		aadd(aCabec[CAB_HFLD1],{"PLN_SIMPN" 	,"",RetTitle("A2_SIMPNAC")	,PesqPict("SA2","A2_SIMPNAC")})
		aadd(aCabec[CAB_HFLD1],{"PLN_COND"   	,"",RetTitle("C8_COND")		,PesqPict("SC8","C8_COND")})
		aadd(aCabec[CAB_HFLD1],{"PLN_DESCRI" 	,"",RetTitle("E4_DESCRI")	,PesqPict("SE4","E4_DESCRI")})
		aadd(aCabec[CAB_HFLD1],{"PLN_DATPRZ" 	,"",RetTitle("C8_PRAZO")	,PesqPict("SC8","C8_DATPRF")})
		aadd(aCabec[CAB_HFLD1],{"PLN_NUMPRO"	,"",RetTitle("C8_NUMPRO")	,PesqPict("SC8","C8_NUMPRO")})
		aadd(aCabec[CAB_HFLD1],{"PLN_DATPRF" 	,"",RetTitle("C8_DATPRF")	,PesqPict("SC8","C8_DATPRF")})		
		aadd(aCabec[CAB_HFLD1],{"PLN_DESVIO" 	,"",RetTitle("A2_DESVIO")	,PesqPict("SA2","A2_DESVIO")})
		aadd(aCabec[CAB_HFLD1],{"PLN_NOTA"   	,"",RetTitle("A5_NOTA")		,PesqPict("SA5","A5_NOTA")})
		aadd(aCabec[CAB_HFLD1],{"PLN_OBS"    	,"",RetTitle("C8_OBS")		,PesqPict("SC8","C8_OBS")})  
		aadd(aCabec[CAB_HFLD1],{"PLN_PRAZO" 	,"",RetTitle("C8_PRAZO")	,PesqPict("SC8","C8_PRAZO")})
		aadd(aCabec[CAB_HFLD1],{"PLN_ITEMGRD"	,"",RetTitle("C8_ITEMGRD")	,PesqPict("SC8","C8_ITEMGRD")})
		aadd(aCabec[CAB_HFLD1],{"PLN_FLAG"   	,"","",""})		
		aadd(aCabec[CAB_HFLD1],{"PLN_VISTO"  	,"","",""})
			
		dbSelectArea("SX3")
		dbSetOrder(2)

		aadd(aStruTmp,{"PLN_OK","C",2,0})

		MsSeek("C8_PRECO")
		aadd(aStruTmp,{"PLN_PRECO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_TOTAL")
		aadd(aStruTmp,{"PLN_TOTSI",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aStruTmp,{"PLN_TOTCI",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		MsSeek("C8_XCOST")
		aadd(aStruTmp,{"PLN_XCOST",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_XSAVING")
		aadd(aStruTmp,{"PLN_XSAVIN",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_TOTFRE")
		aadd(aStruTmp,{"PLN_FRETE",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_VLDESC")
		aadd(aStruTmp,{"PLN_VLDESC",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_FORNECE")		
		aadd(aStruTmp,{"PLN_FORNEC",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_LOJA")
		aadd(aStruTmp,{"PLN_LOJA",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("A2_NREDUZ")
		aadd(aStruQry,{"A2_NREDUZ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aStruTmp,{"PLN_NREDUZ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("A2_SIMPNAC")		
		aadd(aStruTmp,{"PLN_SIMPN",SX3->X3_TIPO,SX3->X3_TAMANHO+3,SX3->X3_DECIMAL})
		aadd(aStruQry,{"A2_SIMPNAC",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_COND")
		aadd(aStruTmp,{"PLN_COND",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("E4_DESCRI")
		aadd(aStruTmp,{"PLN_DESCRI",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})		
		
		MsSeek("C8_DATPRF")
		aadd(aStruTmp,{"PLN_DATPRZ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_NUMPRO")
		aadd(aStruTmp,{"PLN_NUMPRO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})		
		
		MsSeek("C8_DATPRF")
		aadd(aStruTmp,{"PLN_DATPRF",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})		
		
		MsSeek("A2_DESVIO")
		aadd(aStruQry,{"A2_DESVIO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aStruTmp,{"PLN_DESVIO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("A5_NOTA")
		aadd(aStruTmp,{"PLN_NOTA",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_OBS")
		aadd(aStruTmp,{"PLN_OBS",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				
		MsSeek("C8_PRAZO")
		aadd(aStruTmp,{"PLN_PRAZO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		MsSeek("C8_ITEMGRD")
		aadd(aStruTmp,{"PLN_ITEMGR",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		aadd(aStruTmp,{"PLN_FLAG","N",1,0})
		aadd(aStruTmp,{"PLN_VISTO","C",1,0})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche array aCpoSC8 com os campos do cabecalho para permitir alterar³
		//³ a ordem dos campos                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		aEval( aCabec[CAB_HFLD1] , { |x| aAdd( aCpoSC8 , x[1] ) } )
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria o arquivo temporario                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCabec[CAB_ARQTMP] := CriaTrab(aStruTmp,.T.)
		dbUseArea(.T.,__LocalDrive,aCabec[CAB_ARQTMP],aCabec[CAB_ARQTMP],.F.,.F.)
	Else
		dbSelectArea("SX3")
		dbSetOrder(2)
		MsSeek("A2_NREDUZ")
		aadd(aStruQry,{"A2_NREDUZ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
		MsSeek("A2_DESVIO")
		aadd(aStruQry,{"A2_DESVIO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	Endif	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a montagem das paginas de cotacao                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC8")
	dbSetOrder(4)
	MsSeek(xFilial("SC8")+cNumSC8)
	
	#IFDEF TOP
		cAliasSC8:= "MAMONTACOT"
		lQuery := .T.
		cQuery := ""
		For nX := 1 To Len(aStruQry)
			cQuery += ","+aStruQry[nX][1]
		Next nX
		cQuery := "SELECT SB1.B1_TE,"+SubStr(cQuery,2)+",SC8.R_E_C_N_O_ SC8RECNO "
		cQuery += "FROM "+RetSqlName("SC8")+" SC8,"
		cQuery += RetSqlName("SA2")+" SA2,"
		cQuery += RetSqlName("SB1")+" SB1 "
		cQuery += "WHERE SC8.C8_FILIAL='"+xFilial("SC8")+"' AND "
		cQuery += "SC8.C8_NUM='"+cNumSC8+"' AND "
		If !lProceCot .And. !Empty(cProdCot) .And. !Empty(cItemCotID)
			cQuery += "SC8.C8_PRODUTO = '"+cProdCot+"' AND "
			cQuery += "SC8.C8_IDENT   = '"+cItemCotID+"' AND "
		Endif
		cQuery += "SC8.D_E_L_E_T_=' ' AND "
		cQuery += "SA2.A2_FILIAL='"+xFilial("SA2")+"' AND "
		cQuery += "SA2.A2_COD=SC8.C8_FORNECE AND "
		cQuery += "SA2.A2_LOJA=SC8.C8_LOJA AND "
		cQuery += "SA2.D_E_L_E_T_=' ' AND "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += "SB1.B1_COD=SC8.C8_PRODUTO AND "
		cQuery += "SB1.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(SC8->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC8,.T.,.T.)
		For nX := 1 To Len(aStruQry)
			If ( aStruQry[nX][2] <> "C" )
				TcSetField(cAliasSC8,aStruQry[nX][1],aStruQry[nX][2],aStruQry[nX][3],aStruQry[nX][4])
			EndIf
		Next nX	
	#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica ponto de entrada de filtragem                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (Type('lIsACC')#'L' .Or. !lIsACC) .And. ExistBlock("MT160FIL")
		cFiltro := ExecBlock("MT160FIL",.F.,.F.,{cAliasSC8})
	EndIf
	
	dbSelectArea(cAliasSC8)
	While ( !Eof() .And. (cAliasSC8)->C8_FILIAL == xFilial("SC8") .And. (cAliasSC8)->C8_NUM == cNumSC8 )
		
		If ( !lQuery )
			If !lProceCot .And. !Empty(cProdCot) .And. !Empty(cItemCotID)
				If RetCodProdFam((cAliasSC8)->C8_PRODUTO) <> RetCodProdFam(cProdCot) .And. (cAliasSC8)->C8_IDENT <> cItemCotID
					dbSelectArea(cAliasSC8)
					dbSkip()
					Loop
				Endif
			Endif
		Endif
	    
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o filtro utilizado e valido senao substitui por ".T."      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    If Valtype(cFiltro) == "C" .And. Empty(cFiltro)
	    	cFiltro:= ".T."
	    ElseIf Valtype(cFiltro) != "C"
	    	cFiltro:= ".T."
	    EndIf
	    
		If &(cFiltro)  .And. If( lSigaGSP,.t.,GSPF190() )
			
			If !lVisual .And. lSolic .And. !VldAnCot(RetCodUsr(),(cAliasSC8)->C8_GRUPCOM)
				cGrupCom  := (cAliasSC8)->C8_GRUPCOM
			Else
	
				lGrupCom  := .F.
	
				If lVisual .Or. Empty((cAliasSC8)->C8_NUMPED)
	
					lPedido   := .F.
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o Produto x Fornecedor esta definido para Inspecao no QIE, ³
					//³ se o mesmo possui a Situacao; "Nao-Habilitado, neste caso o mesmo nao  ³
					//³ sera selecionado para analise nas cotacoes. 						   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lVisual .And. lVerifica
						If !QieSitFornec((cAliasSC8)->C8_FORNECE,(cAliasSC8)->C8_LOJA,(cAliasSC8)->C8_PRODUTO,.F.)
							dbSelectArea(cAliasSC8)
							dbSkip()
							Loop
						EndIf
					EndIf
							
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calculo do custo da Cotacao                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lMtxFisCo
						nMoedaAval := Max((cAliasSC8)->C8_MOEDA,1)
						MaFisIni((cAliasSC8)->C8_FORNECE,(cAliasSC8)->C8_LOJA,"F","N","R")
						MaFisIniLoad(1)
						For nY := 1 To Len(aRefImpos)
							MaFisLoad(aRefImpos[nY][3],(cAliasSC8)->(FieldGet(FieldPos(aRefImpos[nY][2]))),1)
						Next nY
						If ( lTes .And. Empty((cAliasSC8)->C8_TES) )
							If ( !lQuery )
								dbSelectArea("SB1")
								dbSetOrder(1)
								MsSeek(xFilial("SB1")+(cAliasSC8)->C8_PRODUTO)
								MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),1)
							Else
								MaFisAlt("IT_TES",RetFldProd((cAliasSC8)->C8_PRODUTO,"B1_TE"),1)
							EndIf
						EndIf
						MaFisEndLoad(1)
						nCusto := HDA08C(cAliasSC8,1,1)
						nCusto2	:= HDA08C(cAliasSC8,1,2)
						MaFisEnd()
					Else
						nCusto := HDA08C(cAliasSC8,1,1)
						nCusto2	:= HDA08C(cAliasSC8,1,2)
					Endif
	                
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Quando o C8_IDENT for diferente sera construida uma nova dimensao em   ³
					//³ todo conjunto de Arrays da Analise para paginar um novo produto, isso  ³
					//³ so nao ocorrera se o Produto for um produto com item de Grade, neste   ³
					//³ caso o C8_IDENT e o mesmo para todos os itens com Grade e os arrays    ³
					//³ aPlanilha,aCotacao e aAuditoria sao construido de forma Sintetica.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cIdentSC8 <> (cAliasSC8)->C8_IDENT 
						cIdentSC8:= (cAliasSC8)->C8_IDENT
						aadd(aPlanilha,{})
						aadd(aCotacao,{})
						aadd(aAuditoria,{})
						aadd(aListBox,{})
						aadd(aColsSC8,{})
						nX 		 := Len(aPlanilha)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Array usado para Gravacao do PC pela Analise da Cotacao na MaAvalCot   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aadd(aSC8,{})
						nP 		:= Len(aSC8)
					Endif
	
					aadd(aSC8[nP],{})
					nY := Len(aSC8[nP])
					dbSelectArea(cAliasSC8)
					For nZ := 1 To FCount()
						If FieldName(nZ) $ "C8_NUMPRO#C8_FORNECE#C8_LOJA#C8_COND#C8_PRODUTO#C8_ITEM#C8_NUM#C8_ITEMGRD#SC8RECNO#C8_FILENT"
							aadd(aSC8[nP][nY],{FieldName(nZ),FieldGet(nZ)})
						Endif
					Next nZ
					If !lQuery 
						aadd(aSC8[nP][nY],{"SC8RECNO",(cAliasSC8)->(RecNo())})
					EndIf
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Planilha de cotacao                                                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
					If !lGrade .Or. Empty((cAliasSC8)->C8_ITEMGRD) .Or. aScan(aScanGrd, {|z| z[1] + z[2] + z[3] + z[4] == (cAliasSC8)->(C8_FORNECE+C8_LOJA+C8_NUMPRO+C8_ITEM)}) == 0
	
						Aadd(aScanGrd, {(cAliasSC8)->C8_FORNECE, (cAliasSC8)->C8_LOJA, (cAliasSC8)->C8_NUMPRO, (cAliasSC8)->C8_ITEM, (cAliasSC8)->(Recno())})
	
						cProdRef   := (cAliasSC8)->C8_PRODUTO
						lReferencia:= MatGrdPrrf(@cProdRef,.T.)
						dbSelectArea("SA5")
						dbSetOrder(1)
						If ! MsSeek(xFilial("SA5")+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA+(cAliasSC8)->C8_PRODUTO).And.lReferencia
							dbSelectArea("SA5")
							dbSetOrder(9)
							MsSeek(xFilial("SA5")+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA+cProdRef )
						Endif
	
						SE4->(dbSetOrder(1))
						SE4->(MsSeek(xFilial("SE4")+(cAliasSC8)->C8_COND))
											
						If !( lQuery )
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA)
						EndIf
						
						aAdd(aPlanilha[nx],Array(len(aCpoSC8)))
						
						For ny:=1 to len(aCpoSC8)
							Do Case
								Case aCpoSC8[ny] == "PLN_DESCRI"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := SE4->E4_DESCRI
								Case aCpoSC8[ny] == "PLN_NOTA"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := SA5->A5_NOTA
								Case aCpoSC8[ny] == "PLN_DESVIO"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := If(lQuery,(cAliasSC8)->A2_DESVIO,SA2->A2_DESVIO)
								Case aCpoSC8[ny] == "PLN_NREDUZ"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := If(lQuery,(cAliasSC8)->A2_NREDUZ,SA2->A2_NREDUZ)
								Case aCpoSC8[ny] == "PLN_OK"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := Space(2)
								Case aCpoSC8[ny] == "PLN_TOTAL"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := nCusto
								Case aCpoSC8[ny] == "PLN_DATPRZ"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := dDataBase+(cAliasSC8)->C8_PRAZO
								Case aCpoSC8[ny] == "PLN_PRECO"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := xMoeda((cAliasSC8)->C8_PRECO,(cAliasSC8)->C8_MOEDA,1,(cAliasSC8)->C8_EMISSAO,tamsx3("C8_PRECO")[2],If((cAliasSC8)->(FIELDPOS("C8_TXMOEDA")) > 0,(cAliasSC8)->C8_TXMOEDA,''))
								Case aCpoSC8[ny] == "PLN_FLAG"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := 0
								Case aCpoSC8[ny] == "PLN_VISTO"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := " "
								Case aCpoSC8[ny] == "PLN_TOTSI"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := nCusto2 //Iif((cAliasSC8)->A2_SIMPNAC=='S',nCusto,nCusto)
								Case aCpoSC8[ny] == "PLN_TOTCI"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := nCusto //Iif((cAliasSC8)->A2_SIMPNAC=='S',nCusto,nCusto)
								Case aCpoSC8[ny] == "PLN_DESCC1"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := SC1->(GetAdvfVal("SC1","C1_DESCRI",xFilial("SC1") + (cAliasSC8)->C8_NUMSC + (cAliasSC8)->C8_ITEMSC,1))
								Case aCpoSC8[ny] == "PLN_FRETE"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := Iif((cAliasSC8)->C8_TPFRETE=='F',(cAliasSC8)->C8_TOTFRE,0)
								Case aCpoSC8[ny] == "PLN_XSAVIN"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := (cAliasSC8)->C8_XSAVING
								Case aCpoSC8[ny] == "PLN_SIMPN"
									aPlanilha[nx,len(aPlanilha[nx]),ny] := Iif((cAliasSC8)->A2_SIMPNAC=='S','Sim','Nao')
								OtherWise
									aPlanilha[nx,len(aPlanilha[nx]),ny] := (cAliasSC8)->&("C8_"+substr(aCpoSC8[ny],at("_",aCpoSC8[ny])+1))
							EndCase
						Next
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Armazenna posicao dos campos da planilha                               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nPlanFornec := aScan(aCpoSC8,"PLN_FORNEC")
						nPlanLoja   := aScan(aCpoSC8,"PLN_LOJA")
						nPlanNumPro := aScan(aCpoSC8,"PLN_NUMPRO")
						nPlanItem   := aScan(aCpoSC8,"PLN_ITEM")
						nPlanPreco  := aScan(aCpoSC8,"PLN_PRECO")
						nPlanTotal  := aScan(aCpoSC8,"PLN_TOTAL")
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Dados da cotacao                                                       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aadd(aCotacao[nX],{})
						nY := Len(aCotacao[nX])
						dbSelectArea(cAliasSC8)
						For nZ := 1 To FCount()
							If lMtxFisCo
								aadd(aCotacao[nX][nY],{FieldName(nZ),FieldGet(nZ)})
							Else
								If FieldName(nZ) $ "C8_NUM#C8_ITEM#C8_NUMPRO#C8_FORNECE#C8_LOJA#C8_PRODUTO#C8_QUANT#C8_NUMSC#C8_ITEMSC#C8_TAXAFIN#C8_COND#SC8RECNO#C8_QTDAUDI#C8_ITEMGRD"
									aadd(aCotacao[nX][nY],{FieldName(nZ),FieldGet(nZ)})
								Endif
							Endif
						Next nZ
						If ( !lQuery )
							aadd(aCotacao[nX][nY],{"SC8RECNO",(cAliasSC8)->(RecNo())})
						EndIf
						
						nSC8Fornec  := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_FORNECE"})
						nSC8Loja    := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_LOJA"   })
						nSC8NumPro  := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_NUMPRO" })
						nSC8Item    := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_ITEM"   })
						nSC8Quant   := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_QUANT"  })
						nSC8Preco   := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_PRECO"  })
						nSC8Total   := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_TOTAL"  })
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Planilha de Auditoria                                                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aadd(aAuditoria[nX],Array(Len(aCabec[CAB_HFLD2])+1))
						For nY := 1 To Len(aCabec[CAB_HFLD2])
							Do Case
								Case IsHeadRec(aCabec[CAB_HFLD2][nY][2])
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := IIf(lQuery , (cAliasSC8)->SC8RECNO , (cAliasSC8)->(Recno()) )
								Case IsHeadAlias(aCabec[CAB_HFLD2][nY][2])
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := "SC8"
								Case aCabec[CAB_HFLD2][nY][2]=="CE_NUMPRO"
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_NUMPRO
								Case aCabec[CAB_HFLD2][nY][2]=="CE_FORNECE"
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_FORNECE
								Case aCabec[CAB_HFLD2][nY][2]=="CE_LOJA"
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_LOJA
								Case  aCabec[CAB_HFLD2][nY][2]=="CE_ENTREGA"
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_DATPRF
								Case  aCabec[CAB_HFLD2][nY][2]=="CE_ITEMCOT"
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_ITEM
								Case  aCabec[CAB_HFLD2][nY][2]=="CE_NUMCOT"
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_NUM
								Case  aCabec[CAB_HFLD2][nY][2]=="CE_ITEMGRD"
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_ITEMGRD
								Case  aCabec[CAB_HFLD2][nY][2]=="CE_QUANT"
									dbSelectArea("SCE")
									dbSetOrder(1)
									If MsSeek(xFilial("SCE")+(cAliasSC8)->C8_NUM+(cAliasSC8)->C8_ITEM+(cAliasSC8)->C8_PRODUTO+;
										(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA)
										While SCE->(!Eof()) .And. SCE->CE_FILIAL+SCE->CE_NUMCOT+SCE->CE_ITEMCOT+SCE->CE_PRODUTO+SCE->CE_FORNECE+SCE->CE_LOJA ==;
										    xFilial("SCE")+(cAliasSC8)->C8_NUM+(cAliasSC8)->C8_ITEM+(cAliasSC8)->C8_PRODUTO+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA
										    If SCE->CE_NUMPRO == (cAliasSC8)->C8_NUMPRO
												aAuditoria[nX][Len(aAuditoria[nX])][nY] := SCE->CE_QUANT
												aPlanilha[nX][Len(aPlanilha[nX])][1]    := "XX"//Marca fornecedor ganhador
												Exit
											Else
												aAuditoria[nX][Len(aAuditoria[nX])][nY] := IIF(SC8->(FieldPos("C8_QTDAUDI")) > 0 ,(cAliasSC8)->C8_QTDAUDI , 0 )
											Endif
										    SCE->(dbSkip())
										EndDo
									Else
										aAuditoria[nX][Len(aAuditoria[nX])][nY] := IIF(SC8->(FieldPos("C8_QTDAUDI")) > 0 ,(cAliasSC8)->C8_QTDAUDI , 0 )
									EndIf
								Case  aCabec[CAB_HFLD2][nY][2]=="CE_MOTIVO"
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_MOTIVO
								OtherWise
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := CriaVar(aCabec[CAB_HFLD2][nY][2],.T.)
	
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Verifica se o campo pertence a tabela SCE  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If !Empty(SCE->(FieldPos(aCabec[CAB_HFLD2][nY][2])))
										dbSelectArea("SCE")
										dbSetOrder(1)
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Verifica se o fornecedor foi o vencedor    ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If MsSeek(xFilial("SCE")+(cAliasSC8)->C8_NUM+(cAliasSC8)->C8_ITEM+(cAliasSC8)->C8_PRODUTO+;
											(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA)
	
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Verifica a proposta correta    ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											While SCE->(!Eof()) .And. SCE->CE_FILIAL+SCE->CE_NUMCOT+SCE->CE_ITEMCOT+SCE->CE_PRODUTO+SCE->CE_FORNECE+SCE->CE_LOJA ==;
											    xFilial("SCE")+(cAliasSC8)->C8_NUM+(cAliasSC8)->C8_ITEM+(cAliasSC8)->C8_PRODUTO+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA
											    If SCE->CE_NUMPRO == (cAliasSC8)->C8_NUMPRO
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³ Preenche o campo da auditoria  ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													aAuditoria[nX][Len(aAuditoria[nX])][nY] := SCE->&(aCabec[CAB_HFLD2][nY][2])
													Exit
												Endif
											    SCE->(dbSkip())
											EndDo
										EndIf							
									EndIf
							EndCase
						Next nY
						aAuditoria[nX][Len(aAuditoria[nX])][ Len(aCabec[CAB_HFLD2])+1] := .F.
	
						aadd(aListBox[nX],{})
						aadd(aColsSC8[nX],{})
						nPlanScan := Len(aListBox[nX])
					Else
						If (nPlanFornec > 0 .And. nPlanLoja > 0 .And. nPlanNumPro > 0 .And. nPlanItem > 0)
							If (nPlanScan := aScan(aPlanilha[nX], {|z|	z[nPlanFornec] == (cAliasSC8)->C8_FORNECE .And. ;
								z[nPlanLoja] == (cAliasSC8)->C8_LOJA    .And. ;
								z[nPlanNumPro] == (cAliasSC8)->C8_NUMPRO  .And. ;
								z[nPlanItem] == (cAliasSC8)->C8_ITEM   })) > 0
								If nPlanTotal > 0
									aPlanilha[nX, nPlanScan, nPlanTotal] += nCusto
								EndIf
							Endif
						EndIf
	
						If (nSC8Scan := aScan(aCotacao[nX], {|z|	z[nSC8Fornec, 2] == (cAliasSC8)->C8_FORNECE .And. ;
							z[nSC8Loja  , 2] == (cAliasSC8)->C8_LOJA    .And. ;
							z[nSC8NumPro, 2] == (cAliasSC8)->C8_NUMPRO  .And. ;
							z[nSC8Item  , 2] == (cAliasSC8)->C8_ITEM   })) > 0
							
							aCotacao[nX, nSC8Scan, nSC8Quant, 2] += (cAliasSC8)->C8_QUANT
							aCotacao[nX, nSC8Scan, nSC8Total, 2] += (cAliasSC8)->C8_TOTAL
							aCotacao[nX, nSC8Scan, nSC8Preco, 2] := aCotacao[nX, nSC8Scan, nSC8Total, 2] / aCotacao[nX, nSC8Scan, nSC8Quant, 2]
							
							If nPlanPreco > 0
								aPlanilha[nX, nPlanScan,nPlanPreco] := aCotacao[nX, nSC8Scan, nSC8Preco, 2]						
							EndIf
						Endif
	
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Planilha de Fornecimento                                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aadd(aListBox[nX][nPlanScan],Array(nUsadoSC8)) 
					aadd(aColsSC8[nX][nPlanScan],Array(nUsadoSC8))
					dbSelectArea(cAliasSC8)
					For nY := 1 To Len(aCabec[CAB_HFLD3])
						If aCampoSC8[nY][3] <> "M"
							aColsSC8[nX][nPlanScan][Len(aListBox[nX][nPlanScan])][nY] := FieldGet(FieldPos(aCampoSC8[nY][1]))
							aListBox[nX][nPlanScan][Len(aListBox[nX][nPlanScan])][nY] := TransForm(aColsSC8[nX][nPlanScan][Len(aListBox[nX][nPlanScan])][nY],aCampoSC8[nY][2])
						Else
							SC8->(msGoto( IIf(lQuery , (cAliasSC8)->SC8RECNO , (cAliasSC8)->(Recno())) ))
							aColsSC8[nX][nPlanScan][Len(aListBox[nX][nPlanScan])][nY] := &("SC8->"+aCampoSC8[nY][1])
							aListBox[nX][nPlanScan][Len(aListBox[nX][nPlanScan])][nY] := aColsSC8[nX][nPlanScan][Len(aListBox[nX][nPlanScan])][nY]
						EndIf
					Next nY
					aAdd(aColsSC8[nX][nPlanScan][Len(aListBox[nX][nPlanScan])], .F.)
					
					SCE->(dbSeek(xFilial("SCE") + (cAliasSC8)->(C8_NUM+C8_ITEM+C8_PRODUTO+C8_FORNECE+C8_LOJA)))
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Definicao da Estrutura do array aCotaGrade ³
					//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
					//³ 1 - C8_FORNECE                             ³
					//³ 2 - C8_LOJA                                ³
					//³ 3 - C8_NUMPRO                              ³
					//³ 4 - C8_ITEM                                ³
					//³ 5 - C8_PRODUTO (Familia)                   ³
					//³ 6 - Alimentado quando for produto de Grade ³
					//³ 6.1 - C8_PRODUTO                           ³
					//³ 6.2 - CE_QUANT                             ³
					//³ 6.3 - C8_DATPRF                            ³
					//³ 6.4 - C8_ITEMGRD                           ³
					//³ 6.5 - Recno SC8                            ³
					//³ 6.6 - C8_QUANT (Quantidade Original)       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
						(cAliasSC8)->C8_FORNECE + (cAliasSC8)->C8_LOJA + (cAliasSC8)->C8_NUMPRO + (cAliasSC8)->C8_ITEM})) == 0
						Aadd(aCotaGrade, {(cAliasSC8)->C8_FORNECE, (cAliasSC8)->C8_LOJA, (cAliasSC8)->C8_NUMPRO, (cAliasSC8)->C8_ITEM, RetCodProdFam((cAliasSC8)->C8_PRODUTO,!Empty((cAliasSC8)->C8_ITEMGRD)), {} })
						nScan := Len(aCotaGrade)
					Endif
					
					If (! Empty((cAliasSC8)->C8_ITEMGRD )) .And. nScan > 0
						Aadd(aCotaGrade[nScan, 6], {(cAliasSC8)->C8_PRODUTO,SCE->CE_QUANT, (cAliasSC8)->C8_DATPRF, (cAliasSC8)->C8_ITEMGRD, If(lQuery, (cAliasSC8)->SC8RECNO, (cAliasSC8)->(Recno())), (cAliasSC8)->C8_QUANT })
					Endif
													
				EndIf
			EndIf
		EndIf
	
		dbSelectArea(cAliasSC8)
		dbSkip()
	
	EndDo
	
	If !lVisual 
		If lGrupCom 
			Aviso(STR0069,STR0070+cGrupCom+ STR0072,{STR0016},2) //"Acesso Restrito"###"O  acesso  e  a utilizacao desta rotina e destinada apenas aos usuarios pertencentes ao grupo de compras : "###". com direito de analise de cotacao. Usuario sem permissao para utilizar esta rotina.  "###"Voltar"
		ElseIf lPedido 
			Help(" ",1,	"A160ENCER")
		EndIf
	EndIf
	
	lRetorno := Len(aPlanilha) > 0
	
	If lQuery
		dbSelectArea(cAliasSC8)
		dbCloseArea()
		dbSelectArea("SC8")
	EndIf
	
	RestArea(aAreaSX3)
	RestArea(aArea)

Return(lRetorno)

Static Function CalcRes(nPerc,nResHor,nResVer,lWidth)

	Local nRet
	
	DEFAULT	nResHor:= GetScreenRes()[1]
	DEFAULT nResVer:= GetScreenRes()[2]
	
	if lWidth
		nRet := nPerc * nResHor / 100
	else
		nRet := nPerc * nResVer / 100
	endif

Return nRet

Static Function AjustaSX1()

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

/*-----------------------MV_PAR17--------------------------*/
Aadd( aHelpPor, "Por Cotacao: O sistema fara a carga da  " )
Aadd( aHelpPor, "cotacao de uma vez na tela.             " )
Aadd( aHelpPor, "Por Produto: O sistema fara a carga da  " )
Aadd( aHelpPor, "cotacao a cada troca de produto. Nesse  " )
Aadd( aHelpPor, "caso, e obrigatoria a passagem por todos" )
Aadd( aHelpPor, "os itens da cotacao.                    " )

Aadd( aHelpEng, "By Quotation: the system will load the  " )
Aadd( aHelpEng, "quotation on screen at once.            " )
Aadd( aHelpEng, "By Product: the system will load the    " )
Aadd( aHelpEng, "quotation in each change of product. In " )
Aadd( aHelpEng, "this case, the passage through all the “" )
Aadd( aHelpEng, "quotation items is necessary.           " )

Aadd( aHelpSpa, "Por Cotizacion: el sistema cargara la   " ) 
Aadd( aHelpSpa, "cotizacion de unasola vez en pantalla   " ) 
Aadd( aHelpSpa, "Por Producto: el sistema cargara la co- " ) 
Aadd( aHelpSpa, "tizacion de cada cambio de producto.En e" ) 
Aadd( aHelpSpa, "se caso es obligatorio el paso por todos" ) 
Aadd( aHelpSpa, "los items de la cotizacion.             " ) 

PutSx1( "MTA160","17","Quanto ao processo de analise?","¿Cuanto a proceso de analisis?","About the analysis process?   ","mv_chh",;
"N",1,0,1,"C","","","","","mv_par17","Por Cotacao","Por Cotizacion","By Quotation","",;
"Por Produto","Por Producto","By Product","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {"Digite o preço dos produtos na rotina de"," Atualiza cotações, caso o preço já tenh","a sido atualizado, verifique se a TES in","formada no item possui o campo Gera Dupl","icatas = SIM, (F4_DUPLIC).              "}
aHelpEng := {"Type the price of the products in the ro","utine of it Modernizes quotations, I mar","ry the price it has already been moderni","zed, TES is verified informed in the ite","m it possesses the field it Generates Co","pies = YES, (F4_DUPLIC)."}
aHelpSpa := {"Teclee el precio de los productos en la ","rutina de él Moderniza citas, yo me caso"," el precio que ya se ha modernizado, TES"," se verifica informado en el artículo po","see el campo Genera Copias= Si F4_DUPLIC"}

PutHelp("SA160ATU" , aHelpPor, aHelpEng, aHelpSpa ,.F.)

/*-----------------------MV_PAR06--------------------------*/
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

Aadd( aHelpPor, "Informa ao sistema se somente as " )
Aadd( aHelpPor, "cotações relacionadas ao comprador " )
Aadd( aHelpPor, "deverão ser apresentadas." )
Aadd( aHelpPor, "Também serão apresentadas as cotações " )
Aadd( aHelpPor, "que não estiverem relacionadas a nenhum " )
Aadd( aHelpPor, "comprador." )

Aadd( aHelpEng, "It informs the system if only the " )
Aadd( aHelpEng, "quotations related to the purchaser " )
Aadd( aHelpEng, "should be presented." )
Aadd( aHelpEng, "The quotations not related to any " )
Aadd( aHelpEng, "purchaser will also be presented." )

Aadd( aHelpSpa, "Informe si se deben presentar solo " )
Aadd( aHelpSpa, "las cotizaciones relacionadas al " )
Aadd( aHelpSpa, "comprador." )
Aadd( aHelpSpa, "También se presentarán las " )
Aadd( aHelpSpa, "cotizaciones que no se refieran a " )
Aadd( aHelpSpa, "cualquier comprador." )

PutSX1Help("P.MTA16006.",aHelpPor,aHelpEng,aHelpSpa)

Return	


Static Function AjustaSX3()

Local aAreaSX3 := SX3->(GetArea())
Local cInibrw  := 'POSICIONE("SB1",1,XFILIAL("SB1",SC8->C8_FILIAL)+SC8->C8_PRODUTO,"SB1->B1_DESC")'

dbSelectArea("SX3")
dbsetOrder(2)

If MsSeek("C8_DESCRI")
   If cInibrw <> AllTrim(SX3->X3_INIBRW)
   	RecLock('SX3',.F.)
    	X3_INIBRW := cInibrw
   	MsUnLock()
   EndIf
EndIf

RestArea(aAreaSX3)

Return .T.
