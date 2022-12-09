#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

#DEFINE CRLF CHR(13) + CHR(10)
/* Esse fonte a princ�pio vai ler os arquivos retornos do SERASA, buscar os dados na base da VERQU�MICA e gerar um arquivo de concilia��o dos t�tulos*/
user function DBCONCTR()
	Private oGrid1, oGrid2
	Private cQuery := ""
	Private aH := {}
	Private aC := {}
	Private aHSE5 := {}
	Private aCSE5 := {}  
	Private aFilMov := {}
	Private cNomArq := ""
	
	If Pergunte("DIRARQCONC")
		MsgRun("Efetuando Leitura do Arquivo", "Concilia��o", {||loadFlsRet()})
	EndIf
return

// Fun��o para carregar os arquivos de retorno em arrays
Static Function loadFlsRet()
  Local aFiles := {}
  Local nX
  Local nCount := 1 
  Local nTitls := 0
  Local cFiles := ""
  Local cConteudo
  Local AOBJECTS := {}
  Local aButtons := {}
  Local ACOLS := {}
  Local aVencidos := ""
  Local nVencidos := 0
  Local nAVencer := 1
  Local aDir := StrTokArr( MV_PAR01, "\" )
  
  cNomArq := "conc_" + dtos(date()) + "_" + aDir[len(aDir)]
  aFiles := Directory(MV_PAR01)  

  For nX := 1 to Len(aFiles)
      cConteudo := ""
      oFile := FWFileReader():New(MV_PAR01)

      If (oFile:Open())
      	While (oFile:hasLine())
      		cConteudo := oFile:GetLine()
      		cLin := SubStr(cConteudo,1,130)
      		aadd(aCols, {cLin})
      		
      		If nCount == 1
      			lConcil  := "CONCILIA" $ Substr(cConteudo,37,8)
      			cDtHeader := Substr(cConteudo, 45,8) 
      		EndIf
     
      		If lConcil .AND. nCount <> 1
      			cTpOper  := Substr(cConteudo,1,2)					//Tipo Opera��o 
      			cCnpjCli := Substr(cConteudo,3,14)					//CNPJ do cliente
      			cDtTit 	 := Substr(cConteudo,29,8)					//Data do T�tulo
      			cValTit  := Substr(cConteudo,37,13) 				//duas casas decimais // Valor do T�tulo
      			cDtVencT := Substr(cConteudo,50,8) 					//Data vencimento do T�tulo
      			cDtPagT  := Substr(cConteudo,58,8)  				//Data pagamento do t�tulo
      			cPrefTit := Substr(cConteudo,68,3)					//Prefixo do T�tulo
      			cNumTit  := Substr(cConteudo,71,9)					//Numero do t�tulo
      			cNumPar  := Substr(cConteudo,80,2)					//Parcela do t�tulo
      			cTipoTit := Substr(cConteudo,82,3)					//Tipo do T�tulo
        			
      			If cTpOper == "01" .AND. cDtVencT <= cDtHeader
      				nTitls += 1
      				aadd(aC, {nTitls,cTpOper,cCnpjCli,STOD(cDtTit),Val(cValTit)/100,STOD(cDtVencT),STOD(cDtPagT),cPrefTit,cNumTit,cNumPar,cTipoTit, .F.})
      				aadd(aFilMov, {cNumTit,cNumPar,cPrefTit,cTipoTit})				
      			EndIf      			
      			
      		EndIf
      		nCount := nCount + 1
      	EndDo
      EndIf
    oFile:Close()            
  Next nX
  
  	MsgRun("Carregando Cabe�alhos do Arquivo"	, "Concilia��o", {||loadCabTit()})
  	MsgRun("Carregando Cabe�alhos do Movimentos", "Concilia��o", {||loadCabMov()})
  	MsgRun("Carregando Movimentos Banc�rios"	, "Concilia��o", {||loadMovSE5()})
  	
	aSize   := MsAdvSize()
	
	Aadd(aObjects,{100,100,.T.,.T.})
	Aadd(aObjects,{100,100,.T.,.T.})
	
	Aadd(aButtons, {"GERREM", {|| MsgRun("Gerando remessa de concilia��o"	,"Concilia��o", {|| GERREMESSA(aCols,aC)})}, "Gerar Concilia��o", "Gerar Concilia��o" , {|| .T.}} )     
	Aadd(aButtons, {"PRCDTP", {|| MsgRun("Preenchendo datas de Pagamentos"	,"Concilia��o", {|| PRCDTPAGTS(aCols,aC)})}, "Preencher Datas Pagamentos", "Preencher Datas Pagamentos" , {|| .T.}} )

	aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],2,2}
	aPosObj := MsObjSize(aInfo,aObjects)
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}})
	
	DEFINE MSDIALOG oDlg FROM aSize[7],000 TO aSize[6],aSize[5] TITLE "Visualiza��o de retorno Serasa e Concilia��o Arquivo Remessa" OF oMainWnd PIXEL
	
	oDlg:lMaximized := .T.

	oGrid1:=MsNewGetDados():New(aPosObj[1][1] + 7,aPosObj[1][2],aPosObj[2][3]/1.8,aPosObj[2][4],GD_UPDATE,/*cLinhaOk*/,/*cTudoOk*/,/*cIniCpos*/,{"DTPAGAMENTO"},/*nFreeze*/,/*nMax*/,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/,oDlg,aH,aC, {||loadSE5()} )
	oGrid2:=MsNewGetDados():New(aPosObj[2][3]/1.5,aPosObj[1][2],aPosObj[2][3],aPosObj[2][4],,/*cLinhaOk*/,/*cTudoOk*/,/*cIniCpos*/,/*aAlter*/,/*nFreeze*/,/*nMax*/,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/,oDlg,aHSE5,aCSE5, /*bChange*/ )
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons,,,.F.,.F.,.F.,.F.,.F.) CENTERED
Return

Static Function GERREMESSA(aCols,aC)
Local nHandle := FCreate("S:\Remessas\Concilia��o\" + UPPER(cNomArq))
Local cDados := ""
Local cDtHeader := ""	

For nX := 1 To len(aCols)
	lEncon := .F.
	lDtPag := .F. //Valida se data de pagamento � menor que a data de emissao (n�o pode)
	
	If nX == 1
		cDados := aCols[nX,1] + CRLF
		cDtHeader := SubStr(aCols[nX,1],45,8)
	Else
		For nY := 1 To Len (oGrid1:ACols)
			If SubStr(aCols[nX,1], 1, 2) == '01' .AND. !lEncon
				If SubStr(aCols[nX,1], 68,17) == oGrid1:ACols[nY][8] + oGrid1:ACols[nY][9] + oGrid1:ACols[nY][10] + oGrid1:ACols[nY][11]
					lEncon := .T.
					If DtoS(oGrid1:Acols[nY][7])<= DtoS(oGrid1:Acols[nY][4])
						lDtPag := .T.
					EndIf
					cDados := SubStr(aCols[nX,1],1,57) + IIF(lDtPag, Space(8), IIF(DtoS(oGrid1:Acols[nY][7])<=cDtHeader,DtoS(oGrid1:Acols[nY][7]),Space(8))) + SubStr(aCols[nX,1],66,65) + CRLF
				EndIf
			EndIf
		Next nY
			
		If !lEncon
			If SubStr(aCols[nX,1],1,2) <> "01"
				cDados := aCols[nX,1] + CRLF
			Else
				cDados := SubStr(aCols[nX,1],1,57) + Space(8) + SubStr(aCols[nX,1],66,65) + CRLF
			EndIf
		EndIf		
	EndIf

	FWrite(nHandle,cDados)
Next nX

FClose(nHandle)

MsgInfo("Arquivo remessa concilia��o gerado em \\SERVERQUI\Sistema\SerasaRelato\Remessas\Concilia��o\" + cNomArq,"Arquivo Remessa Concilia��o")

Return


Static Function PRCDTPAGTS()
Local dDtBaixa

	For nX := 1 To len(oGrid1:ACols)
		lPSaldo := .T.
		For nY := 1 To Len(aCSE5)
			If (oGrid1:Acols[nX,8] + oGrid1:Acols[nX,9] + oGrid1:Acols[nX,10] + oGrid1:Acols[nX,11] == aCSE5[nY,1] + aCSE5[nY,2] + aCSE5[nY,3] + aCSE5[nY,4])	
				If aCSE5[nY,6] == 0
					lPSaldo := .F.
					dDtBaixa := aCSE5[nY,7]
				EndIf
			EndIf
		Next nY
		
		If !lPSaldo
			oGrid1:ACols[nX,7] := dDtBaixa
		Else
			oGrid1:ACols[nX,7] := StoD("")
		EndIf
	Next nX
	
oGrid1:ForceRefresh()
oGrid2:ForceRefresh()
Return

Static Function loadCabTit()
	AADD(aH, {"LINHA"   		,"TOPERACAO" 	, "" 	, 5 , 00, , , "N", /*"ZC9"*/, , , })
	AADD(aH, {"OPERACAO"   		,"TOPERACAO" 	, "@!" 	, 02 , 00, , , "C", /*"ZC9"*/, , , }) 
	AADD(aH, {"CNPJ"			,"CNPJ" 		, "@!"	, 14 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aH, {"DATA EMISSAO"	,"DTTITULO" 	, ""	, 08 , 00, , , "D", /*"ZC9"*/, , , })
	AADD(aH, {"VALOR"			,"VALOR" 		, "@E 9,999,999,999.99"	, 13 , 02, , , "N", /*"ZC9"*/, , , })
	AADD(aH, {"VENCIMENTO"		,"VENCTITULO" 	, ""	, 08 , 00, , , "D", /*"ZC9"*/, , , })
	AADD(aH, {"DATA PAGAMENTO"	,"DTPAGAMENTO" 	, ""	, 08 , 00, , , "D", /*"ZC9"*/, , , })
	AADD(aH, {"PREFIXO"			,"TPTITULO" 	, "@!"	, 03 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aH, {"NUMERO"			,"NUMTITULO" 	, "@!"	, 09 , 00, , , "C", /*"ZC9"*/, , , }) 
	AADD(aH, {"PARCELA" 		,"PARCELA" 		, "@!"	, 02 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aH, {"TIPO" 			,"TIPO" 		, "@!"	, 03 , 00, , , "C", /*"ZC9"*/, , , })
Return

Static Function loadCabMov()
	AADD(aHSE5, {"PREFIXO"   			,"PRFTIT"	 	, "@!" 	, 03 , 00, , , "C", /*"ZC9"*/, , , }) 
	AADD(aHSE5, {"NUMERO"				,"NUMTIT"		, "@!"	, 09 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aHSE5, {"PARCELA"				,"PARTIT" 		, "@!"	, 02 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aHSE5, {"TIPO"					,"TIPTIT" 		, "@!"	, 03 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aHSE5, {"VALOR"				,"VALTIT" 		, "@E 9,999,999,999.99"	, 13 , 02, , , "N", /*"ZC9"*/, , , })
	AADD(aHSE5, {"SALDO P"				,"SALTIT" 		, "@E 9,999,999,999.99"	, 13 , 02, , , "N", /*"ZC9"*/, , , })
	AADD(aHSE5, {"BAIXA"				,"DTBXTIT" 		, "@"	, 08 , 00, , , "D", /*"ZC9"*/, , , })
	AADD(aHSE5, {"EMISSAO"				,"DTEMTIT" 		, "@"	, 08 , 00, , , "D", /*"ZC9"*/, , , }) 
	AADD(aHSE5, {"VENCIMENTO" 			,"DTVCTIT" 		, "@"	, 08 , 00, , , "D", /*"ZC9"*/, , , })
	AADD(aHSE5, {"CLIENTE" 				,"CLITIT" 		, "@!"	, 06 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aHSE5, {"LOJA" 				,"LOJTIT" 		, "@!"	, 02 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aHSE5, {"MOT.BAIXA" 			,"MOTBXTIT" 	, "@!"	, 03 , 00, , , "C", /*"ZC9"*/, , , })
	AADD(aHSE5, {"HISTORICO" 			,"HISTIT" 		, "@!"	, 50 , 00, , , "C", /*"ZC9"*/, , , })
Return

Static Function loadMovSE5()

For nX := 1 To Len(aFilMov)
	cQuery := ""
	cQuery += " SELECT "   
	cQuery += " 	SE5.E5_FILIAL, "   
	cQuery += " 	SE5.E5_PREFIXO, " 
	cQuery += " 	SE5.E5_NUMERO, "  
	cQuery += " 	SE5.E5_PARCELA, " 
	cQuery += " 	SE5.E5_TIPO, "  
	cQuery += " 	SE5.E5_VALOR, " 
	cQuery += " 	SE1.E1_SALDO, " 
	cQuery += " 	SE1.E1_BAIXA, " 
	cQuery += " 	SE5.E5_DATA, "  
	cQuery += " 	SE5.E5_VENCTO, " 
	cQuery += " 	SE5.E5_CLIENTE, "
	cQuery += " 	SE5.E5_LOJA, "  
	cQuery += " 	SE5.E5_MOTBX, " 
	cQuery += " 	SE5.E5_HISTOR "
	cQuery += " FROM " 
	cQuery += " " + RetSqlName("SE5") +	" SE5 " 
	cQuery += " 		INNER JOIN " + RetSqlName("SE1") +	" SE1" 
	cQuery += " 			ON ( " 
	cQuery += " 				SE1.D_E_L_E_T_ <> '*' " 
	cQuery += " 				AND SE1.E1_FILIAL = SE5.E5_FILIAL " 
	cQuery += " 				AND SE1.E1_PREFIXO = SE5.E5_PREFIXO "
	cQuery += " 				AND SE1.E1_NUM = SE5.E5_NUMERO " 
	cQuery += " 				AND SE1.E1_PARCELA = SE5.E5_PARCELA "
	cQuery += " 				AND SE1.E1_TIPO = SE5.E5_TIPO "
	cQuery += " 				AND SE1.E1_CLIENTE = SE5.E5_CLIENTE "
	cQuery += " 				AND SE1.E1_LOJA = SE5.E5_LOJA "
	cQuery += " 				) "
	cQuery += " 	WHERE SE5.E5_NUMERO = '"+aFilMov[nX][1]+"' AND SE5.E5_PARCELA = '"+aFilMov[nX][2]+"' AND SE5.E5_PREFIXO = '"+aFilMov[nX][3]+"' AND SE5.E5_TIPO = '"+aFilMov[nX][4]+"' AND SE5.D_E_L_E_T_ <> '*' "
	     
	cQuery := ChangeQuery(cQuery)
	
	If Select("TMPCON") > 0
		TMPCON->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TMPCON"
	Dbselectarea("TMPCON") 
	 	
	While !TMPCON->(Eof())  
		aadd(aCSE5, { TMPCON->E5_PREFIXO, TMPCON->E5_NUMERO, TMPCON->E5_PARCELA, TMPCON->E5_TIPO, TMPCON->E5_VALOR, TMPCON->E1_SALDO, STOD(TMPCON->E1_BAIXA), STOD(TMPCON->E5_DATA), STOD(TMPCON->E5_VENCTO), TMPCON->E5_CLIENTE, TMPCON->E5_LOJA, TMPCON->E5_MOTBX,TMPCON->E5_HISTOR, .F.})
		TMPCON->(DbSkip())    
	EndDo
	
Next nX	

Return

Static Function loadSE5() 
Local aChange := {}
For nX := 1 To Len(aCSE5)
	If oGrid1:Acols[oGrid1:nAt][8]+oGrid1:Acols[oGrid1:nAt][9]+oGrid1:Acols[oGrid1:nAt][10]+oGrid1:Acols[oGrid1:nAt][11] == aCSE5[nX][1]+aCSE5[nX][2]+aCSE5[nX][3]+aCSE5[nX][4]
		Aadd(aChange, {aCSE5[nX][1],aCSE5[nX][2],aCSE5[nX][3],aCSE5[nX][4],aCSE5[nX][5],aCSE5[nX][6],aCSE5[nX][7],aCSE5[nX][8],aCSE5[nX][9],aCSE5[nX][10],aCSE5[nX][11],aCSE5[nX][12],aCSE5[nX][13],.F.})
	EndIf 
Next nX

oGrid2:Acols := aChange
oGrid2:ForceRefresh()

Return