#Include "Protheus.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ AKRON Projetos e Sistemas                                  ³±±
±±³          ³ Praca Silvio Romero, 55 - cj66 - Tatuape - SP              ³±±
±±³          ³ Fone/Fax: (11) 6225-3111 - (11) 6225-3167                  ³±±
±±³          ³ Site: www.akronbr.com.br     e-mail: akron@akronbr.com.br  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³  Equifax  ³ Autor ³ Larson Zordan        ³ Data ³17/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao de Arquivo de Registros                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLIENTES EQUIFAX                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Equifax( lBat )
Local oDlg
Local cPerg       := PADR("EFXPER",LEN(SX1->X1_GRUPO))
Local nOpcProc    := 0

Default lBat	  := .F.

Private cTitulo   := "Geração do Arquivo de Registros - EQUIFAX v.3.05"
Private aDadosNeg := {}
Private aDadosPos := {}

dbSelectArea("SE1")
dbSetOrder(1)

PutSx1(cPerg,"01","Envia E-Mail ?        ","","","mv_ch1","N",01,0,0,"C","","","","","mv_par01","Sim","","","","Não","","","","","","","","","","","",{"Informe se será enviado um e-mail","após a geração do arquivo de registros."},{},{})
PutSx1(cPerg,"02","Destinatário do E-Mail","","","mv_ch2","C",30,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{"Informe a conta de e-mail do des-","tinatário."},{},{})
PutSx1(cPerg,"03","Selecionar os Títulos ","","","mv_ch3","N",01,0,0,"C","","","","","mv_par03","Sim","","","","Não","","","","","","","","","","","",{"Informe se deverá exibir os títu-","los para selecioná-los."},{},{})
PutSx1(cPerg,"04","Prefixo 1:              ","","","mv_ch4","c",03,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",{"Informe o prefixo dos titulos","para selecioná-los."},{},{})
PutSx1(cPerg,"05","Prefixo 2:             ","","","mv_ch5","c",03,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{"Informe o prefixo dos titulos","para selecioná-los."},{},{})

If lBat
	Pergunte(cPerg,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lBat
   If !Pergunte( cPerg, .T., cTitulo )
      Return
   EndIf

	Define MsDialog oDlg Title cTitulo Of oMainWnd Pixel From 200,0 To 380,380
	@ 02,05 To 060,187 Of oDlg Pixel

	@ 05,15 BitMap oBmp File "EQUIFAX.BMP" Of oDlg Pixel Size 160,200 NOBORDER
	@ 25,15 Say " Este programa irá gerar um arquivo texto, conforme os parâmetros" Of oDlg Pixel
	@ 35,15 Say " definidos pelo usuário, com os registros do arquivo de Contas  à" Of oDlg Pixel
	@ 45,15 Say " Receber - conforme lay-out da EQUIFAX v.3.05"                     Of oDlg Pixel

	Define SButton From 70,  80 Type 5 Of oDlg Enable Action (Pergunte( cPerg, .T., cTitulo ))
	Define SButton From 70, 115 Type 1 Of oDlg Enable Action (nOpcProc := 1,oDlg:End())
	Define SButton From 70, 150 Type 2 Of oDlg Enable Action (oDlg:End())

	Activate Dialog oDlg Centered

Else

   nOpcProc := 1
   mv_par03 := 2	// Nao Exibe a tela de selecao de titulos

EndIf

If nOpcProc == 1
	If !lBat
		Processa( { || ProcReg(lBat) }, "Gerando Arquivo..." )
	Else
		ProcReg(lBat)
	EndIf	

	//--> Exibir os Titulos a serem selecionado
	If !lBat
		If Len(aDadosNeg)+Len(aDadosPos) > 0
			If mv_par03 == 1
				ProcTit()
			EndIf
		Else	
			Aviso("ATENÇÃO !","Não há registros a serem enviados.",{ " Sair >> "})
		EndIf
	EndIf
	
	//--> Gerar os arquivos TXT
	If lBat .And. Len(aDadosNeg)+Len(aDadosPos) > 0
		ProcTxt(.T.)	
	EndIf	
		
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ ProcReg   ³ Autor ³ Larson Zordan        ³ Data ³17/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Processa os registros                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ProcReg(ExpL1)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 - Processa em Batch                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CLIENTES EQUIFAX                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcReg(lBat)
Local aStruSE1  	:= SE1->(dbStruct())

Local cAliasNeg 	:= "NEGA" 
Local cAliasPos 	:= "POSI" 
Local cNomeNeg  	:= CriaTrab("",.F.)
Local cNomePos  	:= CriaTrab("",.F.)
Local cQuery		:= ""
Local cString   	:= ""
Local cTrbSE1		:= CriaTrab("",.F.)

Local lNaoEnvia 	:= .F.
Local lQuery		:= .F.

Local nSeq			:= 0
Local nTamLin
Local nX

Local nDias			:= GetMv("MV_EFXPA01")	//Indica a quantidade de dias que o titulo deve estar vencido para envio a registro
Local nCorte		:= DDATABASE - 365 //GetMv("MV_EFXCUT1")	//Indica a data de corte dos titulos, titulos anteriores a data não serão conciderados.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA1->( dbSetOrder(1) )
SE1->( dbSetOrder(2) )
SE5->( dbSetOrder(7) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa Dados Negativos    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(1)
#IFDEF TOP
	If ( TcSrvType()<>"AS/400" )
		lQuery := .T.
		cQuery := "SELECT SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA"
		cQuery += " FROM "
		cQuery += RetSqlName("SE1") + " SE1, "
		cQuery += RetSqlName("SA1") + " SA1 "
		cQuery += " WHERE "
		cQuery += "     SE1.E1_FILIAL  = '"+xFilial("SE1")+"'"
		cQuery += " AND SA1.A1_FILIAL  = '"+xFilial("SA1")+"'"
		cQuery += " AND SE1.D_E_L_E_T_ <> '*'"
		cQuery += " AND SA1.D_E_L_E_T_ <> '*'"

		cQuery += " AND SE1.E1_CLIENTE =  SA1.A1_COD"
		cQuery += " AND SE1.E1_LOJA    =  SA1.A1_LOJA"
		cQuery += " AND SA1.A1_TIPO    <> 'X'"			// Nao busca Clientes Estrangeiros 
		cQuery += " AND SA1.A1_PESSOA  =  'J'"			// Somente Pessoa Jurídica 
		cQuery += " AND SE1.E1_NEGATIV <> 'N'"			// Pode Negativar
		cQuery += " AND SE1.E1_BAIXA   = '        '"	// Titulo em Aberto
		cQuery += " AND SE1.E1_ENVREG  = '        '"	// Data de Envio do Titulo // -> Esta linha estava comentada, descomentei para não exibir os registros que já tenham sidos enviados, conforme solicitado pela usuária Adriana
		cQuery += " AND SE1.E1_VENCREA <= '" + DtoS(dDataBase-nDias) + "'"
		cQuery += " AND SE1.E1_EMISSAO >= '" + DtoS(nCorte) + "'"  // <--------------------------------------- Tirar no Futuro

		cQuery += " AND SE1.E1_TIPO NOT IN ('AB-','IR-','IN-','IS-','PI-','CF-','CS-','RA ','PR ','NCC') "  // Desconsidera Titulos de Abatimento, Provisorios ou Adiantamento
	    cQuery += " AND SE1.E1_PREFIXO IN ('"+MV_PAR04+"','"+MV_PAR05+"') "
	   //	cQuery += " AND SE1.E1_PREFIXO = '"+mv_par04+"' .or. SE1.E1_PREFIXO = '"+mv_par05+"' "	// Filtra pela serie do documento


		cQuery := ChangeQuery(cQuery)
		
		If lBat
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNeg,.F.,.T.)
		Else
			MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasNeg,.F.,.T.)},"Aguarde... Processando Dados Negativos...")
		EndIf

		For nX := 1 To Len(aStruSE1)
			If ( aStruSE1[nX][2] <> "C" ) .And. FieldPos(aStruSE1[nX][1]) > 0
				TcSetField(cAliasSE1,aStruSE1[nX][1],aStruSE1[nX][2],aStruSE1[nX][3],aStruSE1[nX][4])
			EndIf
		Next nX
	EndIf
#ENDIF
If !lQuery
	cQuery := " E1_FILIAL  == '" + xFilial("SE1") + "'"
	cQuery += " .And. E1_NEGATIV <> 'N'"
	cQuery += " .And. Empty(E1_BAIXA)"
	cQuery += " .And. !(E1_TIPO $ 'AB-|IR-|IN-|IS-|PI-|CF-|CS-|RA |PR |NCC')"
	cQuery += " .And. DtoS(E1_VENCREA) <= '" + DtoS(dDataBase-nDias) + "'"
	cQuery += " .AND. E1_EMISSAO >= '" + DtoS(nCorte) + "'"  // <--------------------------------------- Tirar no Futuro
	cQuery += " .AND. SE1.E1_PREFIXO IN ('"+MV_PAR04+"','"+MV_PAR05+"') "	// Filtra pela serie do documento
	IndRegua("SE1", cTrbSE1,IndexKey(),,cQuery)
	nIndex := RetIndex("SE1")
	#IFNDEF TOP
		dbSetIndex(cTrbSE1+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	cAliasNeg := "SE1"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Registros Negativos   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasNeg)
dbGoTop()
nTotReg := RecCount()
ProcRegua(nTotReg)
nContReg := 0

While !Eof()
    nContReg += 1
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Incrementa a regua                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !lBat
    	IncProc("Processando Negativas: "+StrZero(nContReg,6,0)+If(lQuery,"","/"+StrZero(nTotReg,6,0)) )
    EndIf	

    SA1->( dbSeek(xFilial("SA1")+(cAliasNeg)->(E1_CLIENTE+E1_LOJA)) )
    SE1->( dbSeek(xFilial("SE1")+(cAliasNeg)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)) )
         
    If !lQuery
	    If SA1->A1_TIPO == "X"
	    	dbSkip()
	    	Loop
	    EndIf
	    If SA1->A1_PESSOA <> "J"
	    	dbSkip()
	    	Loop
	    EndIf
	EndIf
       
    nTamLin  := 387
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ³
    //³ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ³
    //³ string dentro de outra string.                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cString := "U"  // Negativacao
    MontaString( @cString, "U" )
    
    dbSelectArea(cAliasNeg)
    dbSkip()
EndDo
If lQuery
	dbSelectArea(cAliasNeg)
	dbCloseArea()
Else
	FERASE(cTrbSE1+OrdbagExt())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa Dados Positivos    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	If ( TcSrvType()<>"AS/400" )
		lQuery := .T.
		cQuery := " SELECT SE1.E1_PREFIXO, SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA" 
		cQuery += " FROM "
		cQuery += RetSqlName("SA1") + " SA1, "
		cQuery += RetSqlName("SE1") + " SE1, "
		cQuery += RetSqlName("SE5") + " SE5, "
		
		cQuery += " ( SELECT E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, MAX( E5_SEQ ) E5_SEQ"
		cQuery += " FROM "
		cQuery += RetSqlName("SE5") + " SE5 "
		cQuery += " WHERE D_E_L_E_T_ <> '*'"
		cQuery += " AND E5_FILIAL = '"+xFilial("SE5")+"'"
		cQuery += " AND E5_SITUACA <> 'C'"
		cQuery += " AND E5_TIPO NOT IN ('AB-','IR-','IN-','IS-','PI-','CF-','CS-','RA ','PR ','NCC')"
		cQuery += " AND E5_TIPODOC IN ('BA','VL')"
		cQuery += " GROUP BY E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA	) SE5AUX"
		cQuery += " WHERE " 
//		cQuery += " SE1.E1_FILIAL = '"+xFilial("SE1")+"'" 
//		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'" 
//		cQuery += " AND SE5.E5_FILIAL = '"+xFilial("SE5")+"'"
		cQuery += " SA1.D_E_L_E_T_ <> '*'"  
		cQuery += " AND SE1.D_E_L_E_T_ <> '*'" 
		cQuery += " AND SE5.D_E_L_E_T_ <> '*'" 
		       
		cQuery += " AND SE5.E5_PREFIXO 	 = SE5AUX.E5_PREFIXO" 
		cQuery += " AND SE5.E5_NUMERO 	 = SE5AUX.E5_NUMERO" 
		cQuery += " AND SE5.E5_PARCELA 	 = SE5AUX.E5_PARCELA" 
		cQuery += " AND SE5.E5_TIPO 	 = SE5AUX.E5_TIPO"
		cQuery += " AND SE5.E5_CLIFOR 	 = SE5AUX.E5_CLIFOR" 
		cQuery += " AND SE5.E5_LOJA 	 = SE5AUX.E5_LOJA" 
		cQuery += " AND SE5.E5_SEQ 		 = SE5AUX.E5_SEQ"
		cQuery += " AND SE5.E5_MOTBX     = 'NOR'" 
		cQuery += " AND SE5.E5_TIPODOC IN ('BA','VL')" 
		
		cQuery += " AND SE1.E1_PREFIXO 	 = SE5.E5_PREFIXO" 
		cQuery += " AND SE1.E1_NUM    	 = SE5.E5_NUMERO" 
		cQuery += " AND SE1.E1_PARCELA 	 = SE5.E5_PARCELA" 
		cQuery += " AND SE1.E1_TIPO 	 = SE5.E5_TIPO"
		cQuery += " AND SE1.E1_CLIENTE	 = SE5.E5_CLIFOR" 
		cQuery += " AND SE1.E1_LOJA 	 = SE5.E5_LOJA" 
		   
		cQuery += " AND SE1.E1_ENVREG	 = '        '" // -> Esta linha estava comentada, descomentei para não exibir os registros que já tenham sidos enviados, conforme solicitado pela usuária Adriana
		cQuery += " AND SE1.E1_CLIENTE 	 = SA1.A1_COD" 
		cQuery += " AND SE1.E1_LOJA		 = SA1.A1_LOJA" 
		  
		cQuery += " AND SA1.A1_TIPO <> 'X'" 
		cQuery += " AND SA1.A1_PESSOA = 'J'" 
		  
		cQuery += " AND SE1.E1_TIPO NOT IN ('AB-','IR-','IN-','IS-','PI-','CF-','CS-','RA ','PR ','NCC')" 
		cQuery += " AND SE1.E1_BAIXA <> '        '" 
		cQuery += " AND SE1.E1_PREFIXO IN ('"+MV_PAR04+"','"+MV_PAR05+"') "	// Filtra pela serie do documento
		cQuery += " AND SE1.E1_EMISSAO >= '" + DtoS(nCorte) + "'"  // <--------------------------------------- Tirar no Futuro
		cQuery := ChangeQuery(cQuery)   

		If lBat
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPos,.F.,.T.)
		Else
			MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasPos,.F.,.T.)},"Aguarde... Processando Dados Positivos...")
			nTotReg := RecCount()
		EndIf	

		For nX := 1 To Len(aStruSE1)
			If ( aStruSE1[nX][2] <> "C" ) .And. FieldPos(aStruSE1[nX][1]) > 0
				TcSetField(cAliasSE1,aStruSE1[nX][1],aStruSE1[nX][2],aStruSE1[nX][3],aStruSE1[nX][4])
			EndIf
		Next nX
	EndIf
#ENDIF
If !lQuery
	cQuery := " E1_FILIAL  == '" + xFilial("SE1") + "'"
	cQuery += " .And. Empty(E1_ENVREG)" // -> Esta linha estava comentada, descomentei para não exibir os registros que já tenham sidos enviados, conforme solicitado pela usuária Adriana
	cQuery += " .And. !Empty(E1_BAIXA)"
	cQuery += " .And. !(E1_TIPO $ 'AB-|IR-|IN-|IS-|PI-|CF-|CS-|RA |PR |NCC')"
	cQuery += " .AND. SE1.E1_PREFIXO IN ('"+MV_PAR04+"','"+MV_PAR05+"') "	// Filtra pela serie do documento
	cQuery += " .And. E1_EMISSAO >= '" + DtoS(nCorte) + "'"  // <--------------------------------------- Tirar no Futuro
	IndRegua("SE1",cTrbSE1,IndexKey(),,cQuery)
	nIndex := RetIndex("SE1")
	#IFNDEF TOP
		dbSetIndex(cTrbSE1+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	cAliasPos := "SE1"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Registros Positivos   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasPos)
dbGoTop()
nTotReg := RecCount()
ProcRegua(nTotReg)
nContReg := 0

While !(cAliasPos)->(Eof())
	nContReg += 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lBat
		IncProc("Processando Positivas: "+StrZero(nContReg,6,0)+If(lQuery,"","/"+StrZero(nTotReg,6,0)) )
	EndIf	
    
	SA1->( dbSeek(xFilial("SA1")+(cAliasPos)->(E1_CLIENTE+E1_LOJA)) )
    SE1->( dbSeek(xFilial("SE1")+(cAliasPos)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)) )
	SE5->( dbSeek(xFilial("SE5")+(cAliasPos)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)) )
	
	If !lQuery
	    If SA1->A1_TIPO == "X"
	    	(cAliasPos)->(dbSkip())
	    	Loop
	    EndIf
	    If SA1->A1_PESSOA <> "J"
	    	(cAliasPos)->(dbSkip())
	    	Loop
	    EndIf

		//--> Posiciona na ultima sequencia da baixa no SE5
		While !SE5->(Eof()) .And. (cAliasPos)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
			nSeq := SE5->(Recno())
			SE5->(dbskip())
		EndDo
		SE5->(dbGoTo(nSeq))
		
		If !SE5->E5_SITUACA <> "C"
			(cAliasPos)->(dbSkip())
			Loop
		EndIf
		
		If SE5->E5_TIPO $ "AB-|IR-|IN-|IS-|PI-|CF-|CS-|RA |PR |NCC"
			(cAliasPos)->(dbSkip())
			Loop
		EndIf
		
		If !(SE5->E5_TIPODOC $ "BA|VL")
			(cAliasPos)->(dbSkip())
			Loop
		EndIf
	EndIf

//	If !SE1->(dbSeek(xFilial("SE1")+(cAliasPos)->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
//		(cAliasPos)->(dbSkip())
//		Loop
//	EndIf

//	SE1->(dbSeek(xFilial("SE1")+(cAliasPos)->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
//	If !FOUND()
//		(cAliasPos)->(dbSkip())
//		Loop
//	EndIf

	
	dbSelectArea(cAliasPos)
    
    nTamLin  := 387

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ³
	//³ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ³
	//³ string dentro de outra string.                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString := "J"  // POSITIVACAO    
	MontaString( @cString, "J" )
      
	dbSelectArea(cAliasPos)
	(cAliasPos)->(dbSkip())
EndDo
If lQuery
	dbSelectArea(cAliasPos)
	dbCloseArea()
Else
	FERASE(cTrbSE1+OrdbagExt())
EndIf

dbSelectArea("SE1")
dbSetOrder(1)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³MontaString³ Autor ³ Larson Zordan        ³ Data ³17/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera String para gravacao do Arquivo Texto                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ OkGeraTxt                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CLIENTES EQUIFAX                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaString( cString, cTipoReg )
Local cEOL      := Chr(13)+Chr(10)
Local cTelefone 
Local cEqFax
Local cDDDTel
Local cDDDFax
 
cString += Substr(Alltrim( SA1->A1_CGC )+SPACE(14),1, 14)  
cString += Substr(Alltrim( SA1->A1_NOME)+SPACE(55),1, 55)
cString += Substr(Alltrim( SA1->A1_NREDUZ)+SPACE(55),1, 55)  
cString += "C"  // Envia sempre como Endereço de Cobrança  
cString += Substr(Alltrim(SA1->A1_END)+SPACE(70),1,70)  
cString += Substr(Alltrim(SA1->A1_MUN)+SPACE(30),1,30)  
cString += Substr(Alltrim(SA1->A1_EST),1,2)  
cString += Substr(Alltrim(SA1->A1_CEP)+SPACE(8),1,8)  

If (trim(SA1->A1_TEL)<>"") .and. (trim(SA1->A1_TEL)<>"0")
	nPosTel   := AT(")",Alltrim(SA1->A1_TEL))
	If nPosTel > 0
	   cTelefone := Substr( Alltrim(SA1->A1_TEL), nPosTel, 10 )
	   cDDDTel   := Substr( Alltrim(SA1->A1_TEL), 01, nPosTel )
	Else
	   cTelefone := Alltrim(SA1->A1_TEL)
	   cDDDTel   := Alltrim(SA1->A1_DDD)
	EndIf   
	cTelefone := StrTran(cTelefone, "(", "")
	cTelefone := StrTran(cTelefone, ")", "")
	cTelefone := StrTran(cTelefone, "-", "")
	cTelefone := StrTran(cTelefone, ".", "")
	cTelefone := StrTran(cTelefone, " ", "")
	cTelefone := Alltrim(Substr(cTelefone,1,10))  
	cTelefone := Space( 10 - Len(cTelefone))+cTelefone

	cDDDTel  := StrTran(cDDDTel , "(", "")
	cDDDTel  := StrTran(cDDDTel , ")", "")
	cDDDTel  := StrTran(cDDDTel , "-", "")
	cDDDTel  := StrTran(cDDDTel , ".", "")
	cDDDTel  := StrTran(cDDDTel , " ", "")
	cDDDTel  := Alltrim(Substr(cDDDTel ,1,10))  
	cDDDTel  := Space( 04 - Len(cDDDTel ))+cDDDTel 

	cString += cDDDTel      
	cString += cTelefone  
else
	cString += space(14)
Endif


If trim(SA1->A1_FAX)<>""
	nPosFax   := AT(")",Alltrim(SA1->A1_FAX))
	IF nPosFax > 0
	   cEqFax  := Substr( Alltrim(SA1->A1_FAX), nPosFax, 10 )
	   cDDDFax := Substr( Alltrim(SA1->A1_FAX), 01, nPosFax )
	Else
	   cEqFax  := Alltrim(SA1->A1_FAX)
	   cDDDFax := Alltrim(SA1->A1_DDD)
	EndIf   

	cEqFax := StrTran(cEqFax, "(", "")
	cEqFax := StrTran(cEqFax, ")", "")
	cEqFax := StrTran(cEqFax, "-", "")
	cEqFax := StrTran(cEqFax, ".", "")                                  '
	cEqFax := StrTran(cEqFax, " ", "")
	cEqFax := Alltrim(Substr(cEqFax,1,10))  
	cEqFax := Space( 10 - Len(cEqFax))+cEqFax

	cDDDFax  := StrTran(cDDDFax , "(", "")
	cDDDFax  := StrTran(cDDDFax , ")", "")
	cDDDFax  := StrTran(cDDDFax , "-", "")
	cDDDFax  := StrTran(cDDDFax , ".", "")
	cDDDFax  := StrTran(cDDDFax , " ", "")
	cDDDFax  := Alltrim(Substr(cDDDFax ,1,10))  
	cDDDFax  := Space( 04 - Len(cDDDFax ))+cDDDFax 

	cString += cDDDFax 
	cString += cEqFax
else
	cString += space(14)
Endif

nPosEml := AT("@",Alltrim(SA1->A1_EMAIL))
If nPosEml > 0
	cEmail = Alltrim(SA1->A1_EMAIL)
	If AT(" ",cEmail)>0
		cEmail = SubStr(cEmail,1,AT(" ",cEmail)-1)
	endif
	If AT("/",cEmail)>0
		cEmail = SubStr(cEmail,1,AT("/",cEmail)-1)
	endif	
	cString += Substr(Alltrim(cEmail)+SPACE(50),1,50)
else
	cString += space(50)
endif

cString  += Strzero( Month(SA1->A1_PRICOM),2,0) + Strzero( Year(SA1->A1_PRICOM),4,0)
cString  += StrZero(Val(SE1->E1_NUM),9,0) + PADL(Alltrim(SE1->E1_PARCELA),3,"0")  &&Strzero( Year(SE1->E1_EMISSAO),4,0) + StrZero(Val(SE1->E1_NUM),7,0) + SE1->E1_PARCELA 
cTipoTit := "O"

If Alltrim(SE1->E1_TIPO) == "DP"
   cTipoTit := "D"
ElseIf Alltrim(SE1->E1_TIPO) == "NF"
   cTipoTit := "N"
ElseIf Alltrim(SE1->E1_TIPO) == "FT"
   cTipoTit := "F"
ElseIf Alltrim(SE1->E1_TIPO) == "BOL"
   cTipoTit := "B"
ElseIf Alltrim(SE1->E1_TIPO) == "CH"
   cTipoTit := "C"
Else
   cTipoTit := "O"
EndIf

cString += cTipoTit
cString += "R$  "
cString += StrZero(NOROUND((SE1->E1_VALOR) * 100,0),13)

If cTipoReg == "U"  // Negativado
   cString += Space(13)
Else
   cString += StrZero(NOROUND((SE1->E1_VALLIQ) * 100,0),13)
EndIf

If ((SE1->E1_EMISSAO == SE1->E1_VENCREA) .and. (SE1->E1_VENCREA <> SE1->E1_BAIXA))
   cString += Space(8)
Else
   cString += GravaData(SE1->E1_EMISSAO,.F.,5)
EndIf

cString += GravaData(SE1->E1_VENCREA,.F.,5)  

If cTipoReg == "U"  // Negativado
   cString += Space(8)
Else
   cString += GravaData(SE1->E1_BAIXA,.F.,5)
EndIf
    
cString += cEOL

If cTipoReg == "U"
	aAdd( aDadosNeg , { .F. , SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NOME, SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_VALOR , SE1->E1_EMISSAO, SE1->E1_VENCREA, cString, SE1->(Recno()) } )
Else
	aAdd( aDadosPos , { .T. , SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NOME, SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_VALLIQ, SE1->E1_EMISSAO, SE1->E1_BAIXA  , cString, SE1->(Recno()) } )
EndIf
    
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ ProcTit   ³ Autor ³ Larson Zordan        ³ Data ³17/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exibe a Tela Para Selecionar os Titulos a Negativar        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ProcTit()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CLIENTES EQUIFAX                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcTit()
Local oBmp
Local oChk1
Local oChk2
Local oDlg
Local oFld
Local oLbx1
Local oLbx2
Local oQNeg
Local oQPos
Local oTNeg
Local oTPos
Local oOk	    := LoadBitmap( GetResources(), "LBOK" )
Local oNo	    := LoadBitmap( GetResources(), "LBNO" )

Local aObjects  := {}
Local aPosObj   := {}
Local aSize     := MsAdvSize()
Local aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

Local aFolder   := { "Negativações", "Positivações" }

Local lNega     := .T.
Local lPosi     := .T.
Local lGrv      := .F.

Local nQtNeg    := 0
Local nQtPos    := 0
Local nTtNeg    := 0
Local nTtPos    := 0
Local nX

//--> Totaliza as Negativacoes
For nX := 1 To Len(aDadosNeg)
	nQtNeg ++
	nTtNeg += aDadosNeg[nX,9]
Next nX

//--> Totaliza as Positivacoes
For nX := 1 To Len(aDadosPos)
	nQtPos ++
	nTtPos += aDadosPos[nX,9]
Next nX

If Len(aDadosNeg) == 0
	aAdd( aDadosNeg , { .F. , CriaVar("A1_COD",.F.), CriaVar("A1_LOJA",.F.), CriaVar("A1_NOME",.F.), CriaVar("E1_PREFIXO",.F.), CriaVar("E1_NUM",.F.), CriaVar("E1_PARCELA",.F.), CriaVar("E1_TIPO",.F.), CriaVar("E1_VALOR",.F.) , CriaVar("E1_EMISSAO",.F.), CriaVar("E1_VENCREA",.F.) })
	lNega := .F.
EndIf

If Len(aDadosPos) == 0
	aAdd( aDadosPos , { .F. , CriaVar("A1_COD",.F.), CriaVar("A1_LOJA",.F.), CriaVar("A1_NOME",.F.), CriaVar("E1_PREFIXO",.F.), CriaVar("E1_NUM",.F.), CriaVar("E1_PARCELA",.F.), CriaVar("E1_TIPO",.F.), CriaVar("E1_VALLIQ",.F.) , CriaVar("E1_EMISSAO",.F.), CriaVar("E1_BAIXA" ,.F.) })
	lPosi := .F.
EndIf
       
aDadosNeg := aSort( aDadosNeg ,,, { |x,y| x[11] > y[11] })
aDadosPos := aSort( aDadosPos ,,, { |x,y| x[11] > y[11] })

aAdd(aObjects,{100,100,.T.,.T.,.F.})
aAdd(aObjects,{100,020,.T.,.F.,.F.})
aPosObj:=MsObjSize(aInfo,aObjects)

Define MsDialog oDlg Title cTitulo Of oMainWnd Pixel From aSize[7],0 To aSize[6],aSize[5]
oFld:=TFolder():New(aPosObj[1,1],aPosObj[1,2],aFolder,{},oDlg,,,, .T., .F.,aPosObj[1,4],aPosObj[1,3]-10,)
oFld:aDialogs[1]:oFont :=oDlg:oFont
oFld:aDialogs[2]:oFont :=oDlg:oFont

@ aPosObj[2,1]+3,aPosObj[2,2] BitMap oBmp File "EQUIFAX.BMP" Of oDlg Pixel Size 160,200 NOBORDER

Define SButton oBtn1 From aPosObj[2,1]+7,aPosObj[2,4]-85 Type 1 Enable Of oDlg Action (lGrv := .T.,oDlg:End())
Define SButton oBtn2 From aPosObj[2,1]+7,aPosObj[2,4]-50 Type 2 Enable Of oDlg Action (oDlg:End())

@ aPosObj[2,3]-59,10 CheckBox oChk1 Var lNega Prompt " Marca/Desmarca Todos" Of oFld:aDialogs[1] Pixel Size 140,12 Color CLR_RED On Click ( AEval(aDadosNeg , {|z| z[1] := !z[1] }), oLbx1:Refresh(), SomaItem(aDadosNeg,@nQtNeg,@nTtNeg), oQNeg:Refresh(), oTNeg:Refresh()  )
@ aPosObj[2,3]-59,10 CheckBox oChk2 Var lPosi Prompt " Marca/Desmarca Todos" Of oFld:aDialogs[2] Pixel Size 140,12 Color CLR_RED On Click ( AEval(aDadosPos , {|z| z[1] := !z[1] }), oLbx2:Refresh(), SomaItem(aDadosPos,@nQtPos,@nTtPos), oQPos:Refresh(), oTPos:Refresh()  )

@ aPosObj[2,1]+ 5,110 Say "Negativações: "		Size 50,09 Of oDlg Pixel Color CLR_BLUE
@ aPosObj[2,1]+15,110 Say "Positivações: "		Size 50,09 Of oDlg Pixel Color CLR_BLUE

@ aPosObj[2,1]+ 5,135 Say oQNeg Var nQtNeg 		Picture "@E 999,999" Size 30,09 Of oDlg Pixel Color CLR_BLUE Right
@ aPosObj[2,1]+15,135 Say oQPos Var nQtPos 		Picture "@E 999,999" Size 30,09 Of oDlg Pixel Color CLR_BLUE Right

@ aPosObj[2,1]+ 5,170 Say " -  R$" 				Size 30,09 Of oDlg Pixel Color CLR_BLUE
@ aPosObj[2,1]+15,170 Say " -  R$"				Size 30,09 Of oDlg Pixel Color CLR_BLUE

@ aPosObj[2,1]+ 5,170 Say oTNeg Var nTtNeg 		Picture "@E 999,999,999.99" Size 50,09 Of oDlg Pixel Color CLR_BLUE Right
@ aPosObj[2,1]+15,170 Say oTPos Var nTtPos 		Picture "@E 999,999,999.99" Size 50,09 Of oDlg Pixel Color CLR_BLUE Right

@ 2,1 ListBox oLbx1 Fields Header " ",RetTitle("E1_CLIENTE"), RetTitle("E1_LOJA"), RetTitle("E1_NOMCLI"), RetTitle("E1_PREFIXO"), RetTitle("E1_NUM"), RetTitle("E1_PARCELA"), RetTitle("E1_TIPO"), RetTitle("E1_VALOR" ), RetTitle("E1_EMISSAO"), RetTitle("E1_VENCREA") ;
			ColSizes 10,30,20,40,20,40,30,30 Size aPosObj[1,4]-3,aPosObj[1,3]-40 Of oFld:aDialogs[1] Pixel On dBlClick ( aDadosNeg[oLbx1:nAt,1] := !aDadosNeg[oLbx1:nAt,1], oLbx1:Refresh(), SomaItem(aDadosNeg,@nQtNeg,@nTtNeg), oQNeg:Refresh(), oTNeg:Refresh() ) Of oDialog
		
oLbx1:SetArray(aDadosNeg)
oLbx1:bLine := { || {If(aDadosNeg[oLbx1:nAt,1],oOk,oNo), aDadosNeg[oLbx1:nAt,2], aDadosNeg[oLbx1:nAt,3], aDadosNeg[oLbx1:nAt,4], aDadosNeg[oLbx1:nAt,5], aDadosNeg[oLbx1:nAt,6], aDadosNeg[oLbx1:nAt,7], aDadosNeg[oLbx1:nAt,8], Transform(aDadosNeg[oLbx1:nAt,9],"@E 999,999,999.99"), DtoC(aDadosNeg[oLbx1:nAt,10]), DtoC(aDadosNeg[oLbx1:nAt,11]) }}

@ 2,1 ListBox oLbx2 Fields Header " ",RetTitle("E1_CLIENTE"), RetTitle("E1_LOJA"), RetTitle("E1_NOMCLI"), RetTitle("E1_PREFIXO"), RetTitle("E1_NUM"), RetTitle("E1_PARCELA"), RetTitle("E1_TIPO"), RetTitle("E1_VALLIQ"), RetTitle("E1_EMISSAO"), RetTitle("E1_BAIXA"  ) ;
			ColSizes 10,30,20,40,20,40,30,30 Size aPosObj[1,4]-3,aPosObj[1,3]-40 Of oFld:aDialogs[2] Pixel On dBlClick ( aDadosPos[oLbx2:nAt,1] := !aDadosPos[oLbx2:nAt,1], oLbx1:Refresh(), SomaItem(aDadosPos,@nQtPos,@nTtPos), oQPos:Refresh(), oTPos:Refresh() ) Of oDialog
		
oLbx2:SetArray(aDadosPos)
oLbx2:bLine := { || {If(aDadosPos[oLbx2:nAt,1],oOk,oNo), aDadosPos[oLbx2:nAt,2], aDadosPos[oLbx2:nAt,3], aDadosPos[oLbx2:nAt,4], aDadosPos[oLbx2:nAt,5], aDadosPos[oLbx2:nAt,6], aDadosPos[oLbx2:nAt,7], aDadosPos[oLbx2:nAt,8], Transform(aDadosPos[oLbx2:nAt,9],"@E 999,999,999.99"), DtoC(aDadosPos[oLbx2:nAt,10]), DtoC(aDadosPos[oLbx2:nAt,11]) }}

Activate MsDialog oDlg Center

If lGrv
	ProcTxt(.F.)
EndIf	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ SomaItem  ³ Autor ³ Larson Zordan        ³ Data ³17/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Somatoria dos itens selecionados e os valores dos titulos  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SomaItem(ExpA1,ExpN1,ExpN2)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 - Dados dos itens a serem negativados/positivados    ³±±
±±³          ³ ExpN1 - Quantidade de itens selecionados                   ³±±
±±³          ³ ExpN2 - Soma dos valores dos titulos selecionados          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CLIENTES EQUIFAX                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SomaItem(aDados,nQtd,nTot)
Local nX
nQtd := 0
nTot := 0
For nX := 1 To Len(aDados)
	If aDados[nX,1]
		nQtd ++
		nTot += aDados[nX,9]
	EndIf
Next nX
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ ProcTXT   ³ Autor ³ Larson Zordan        ³ Data ³17/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera os arquivos txt                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Proctxt()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CLIENTES EQUIFAX                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcTxt(lBat)
Local cArqTxt 		:= DtoS(dDataBase)+"a.txt"
Local cPath			:= "\equifax\"
Local cLin    		:= ""
Local nHdl    		:= 0
Local nX
Local lEnvioOk      := .F.

Local cMailConta	:= GetMv("MV_WFMAIL")  	//Conta utilizada p/envio do email
Local cMailServer	:= GetMv("MV_WFSMTP")  	//Server
Local cMailSenha	:= GetMv("MV_WFPASSW") 	//Password

//--> O Tamanho da linha do registro eh 387

SE1->(dbSetOrder(2))

If ExistArq(cPath,@cArqTxt,@nHdl)
	For nX := 1 To Len(aDadosNeg)
		If aDadosNeg[nX,1]
			//--> Indica que ja foi enviado para o Sistema
			If SE1->(dbSeek(xFilial("SE1")+aDadosNeg[nX,2]+aDadosNeg[nX,3]+aDadosNeg[nX,5]+aDadosNeg[nX,6]+aDadosNeg[nX,7]+aDadosNeg[nX,8] ))
				RecLock("SE1",.F.)
				Replace SE1->E1_ENVREG With dDataBase
				MsUnLock()
				
				//--> Cria registro no arquivo TXT
				cLin := aDadosNeg[nX,12]
				fWrite(nHdl,cLin,Len(cLin))
			EndIf	
		EndIf
	Next nX	
	
	For nX := 1 To Len(aDadosPos)
		If aDadosPos[nX,1]
			//--> Indica que ja foi enviado para o Sistema
			If SE1->(dbSeek(xFilial("SE1")+aDadosPos[nX,2]+aDadosPos[nX,3]+aDadosPos[nX,5]+aDadosPos[nX,6]+aDadosPos[nX,7]+aDadosPos[nX,8] ))
				RecLock("SE1",.F.)
				Replace SE1->E1_ENVREG With dDataBase
				MsUnLock()
				
				//--> Cria registro no arquivo TXT
				cLin := aDadosPos[nX,12]
				fWrite(nHdl,cLin,Len(cLin))
			EndIf	
		EndIf
	Next nX	
	
	fClose(nHdl)
Else
	If !lBat
		Aviso("ATENÇÃO !","O arquivo de nome "+cPath+cArqTxt+" não pode ser gerado!" + Chr(13) + "Verifique se existe o caminho " + cPath + " .",{ "Sair >>"},2,"Processo Abortado !")
	EndIf
	Return
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia e-mail             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 1
	aFiles := { cPath+cArqTxt }  // Attachments
	cEmail := Alltrim(mv_par02)
	cCC  := "adriana.mendes@gruposhangrila.com.br"
	cCCo := "ricardo.souza@mcinfotec.com.br"
	cSubject  := "ARQUIVO REGISTROS"
	cMensagem := "Anexo Arquivo contendo dados de Registros"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia email                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
		If ( MailSmtpOn(cMailServer,cMailConta,cMailSenha) )
			//ALERT("ANTES DE ENVIAR O EMAIL")
			//lEnvioOK := MailSend(cMailConta,{cEmail},{cCC},{cCCo},cSubject,cMensagem,aFiles)
			lEnvioOK := U_EMail(cEmail, cCc, cSubject, cMensagem,aFiles)
			
			//ALERT("DEPOIS DE ENVIAR O EMAIL")
			//ALERT(LENVIOOK)
			//ALERT(LBAT)
			
			MailSmtpOff()
		EndIf
	EndIf
	
	If !lBat .And. lEnvioOk
	   Aviso("Atenção!","Arquivo Enviado Com Sucesso !!!",{ " Ok " },1,"E-Mail...")
	EndIf   
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ ExistArq  ³ Autor ³ Larson Zordan        ³ Data ³17/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica a existencia do arquivo a ser gerado              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ OkGeraTxt                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CLIENTES EQUIFAX                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ExistArq(cPath,cArqTxt,nHdl)
Local cExt	:= "a"
Local lRet  := .T.
While .T.  
	If File( cPath+cArqTxt )
		cExt := Soma1(cExt)
		cArqTxt := DtoS(dDataBase) + cExt + ".txt"
	Else
		Exit	
	EndIf   
EndDo

nHdl := fCreate(cPath+cArqTxt)

If nHdl == -1
	lRet := .F.
EndIf

Return(lRet)


//Envia E-mail
User Function EMail(cTo, cCc, cAssunto, cMsg, aAnexo)

	Local oServer
	Local oMessage
	Local cUsr := GetMv("MV_RELACNT") //Conta de autenticao do email
	Local cPsw := GetMv("MV_RELPSW") //Senha para autenticao no servidor de e-mail
	Local cSrv := GetMv("MV_RELSERV") //Servidor SMTP
	Local lAut := GetMv("MV_RELAUTH") //Servidor SMTP necessite de AUTENTICAÎ—AO para envio de e-mailÂ’s
	Local nPrt := 25
	//Local aAnexo := StrTokArr(cAnexo, ";")

	//Cria a conexÎ³o com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()
	//oServer:SetUseTLS( .T. )
	//O servidor esta com a porta
	If ":" $ cSrv
		nPrt := Val(Substr(cSrv, At(":",cSrv)+1))
		cSrv := Substr(cSrv, 1 , At(":",cSrv)-1)
	EndIf

	oServer:Init( "", cSrv, cUsr, cPsw, , nPrt )

	//seta um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		 MsgAlert( "Falha ao setar o time out", "Email nao enviado!" )
		Return .F.
	EndIf

	//realiza a conexÎ³o SMTP
	If oServer:SmtpConnect() != 0
		 MsgAlert( "Falha ao conectar", "Email nao enviado!" )
		Return .F.
	EndIf

	If lAut
		If oServer:SmtpAuth( cUsr, cPsw ) != 0
			 MsgAlert( "Falha ao autenticar", "Email nao enviado!" )
			Return .F.
		EndIf
	EndIf
	//Apos a conexÎ³o, cria o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpa o objeto
	oMessage:Clear()

	//Popula com os dados de envio
	oMessage:cFrom              := cUsr
	oMessage:cTo                := cTo 
	oMessage:cCc                := "adriana.mendes@gruposhangrila.com.br"
	//oMessage:cBcc             := ""
	oMessage:cSubject           := cAssunto
	oMessage:cBody              := cMsg

	//Adiciona um attach
	If !Empty(aAnexo) //.AND. !Empty(cAnexo)
		For nI:= 1 To Len(aAnexo)
			If oMessage:AttachFile(aAnexo[nI]) < 0
				 MsgAlert( "Erro ao anexar o arquivo", "Email nao enviado!")
				Return .F.
				//Else
				//adiciona uma tag informando que e um attach e o nome do arq
				//oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=arquivo.txt')
			EndIf
		Next nI
	EndIf
	//Envia o e-mail
	If oMessage:Send( oServer ) != 0
		 MsgAlert( "Erro ao enviar o e-mail", "Email nao enviado!")
		Return .F.
	EndIf

	//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		 MsgAlert( "Erro ao disconectar do servidor SMTP", "Email nao enviado!")
		Return .F.
	EndIf

Return .T.
