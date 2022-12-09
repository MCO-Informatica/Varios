#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATA021 ³ Autor ³ 	Robson Bueno         ³ Data ³ 18.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processo de Envio de informacoes as areas                   ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ...                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³XXXXXXXXXXXXXX³XX/XX/XX³XXXXXX³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATA021()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores    := {},aCampos:={}

aCores    := {{	'C5_NOTA="     "', 'BR_VERDE'},;	        // Pedido a Faturar
			   {'C5_NOTA<>"     "', 'BR_VERMELHO'}}        // Pedido Faturado

PRIVATE aRotina := { { "Pesquisar","AxPesqui"  ,0,1},;       // Pesquisa  PI
					 { "Visualizar","AxVisual",0,2},;        //  Vizualiza PI
                     { "Disposicao","U_RFTL21A",0,3},;       // Aprova SA Bloqueada
					 { "Legenda","U_RFTL21B",0,5} }  
						
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi("Envio de Pedido a Compras")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

mBrowse(6,1,22,75,"SC5",,,,,3,aCores)

Return(.T.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Legenda									             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                 
User Function RFTL21B()

BrwLegenda(cCadastro,"Situacoes",{{"BR_VERMELHO","Pedido Ja Faturado"}, {"BR_VERDE","Pedido a Faturar"}})

Return (.T.) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RFTL21A   ³ Rev.  ³Eduardo Riera          ³ Data ³26.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Visualizacao do Pedido de Venda                             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do cabecalho do pedido de venda                ³±±
±±³          ³ExpN2: Recno do cabecalho do pedido de venda                ³±±
±±³          ³ExpN3: Opcao do arotina                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a interface com o usua³±±
±±³          ³rio e o pedido de vendas                                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFTL21A()

Local cAlias   := "SC5"
lOCAL nReg     := recno()
Local nOpc     := 3
Local aArea    := GetArea()
Local aHeadSC6 := {}
Local aCpos1   := {"C6_QTDVEN ","C6_QTDLIB"}
Local aCpos2   := {}
Local aBackRot := aClone(aRotina)
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Local lContinua:= .T.
Local lGrade   := MaGrade()
Local lQuery   := .F.
Local lHeadSC6 := .F.
Local lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)

Local nGetLin  := 0
Local nOpcA    := 0
Local nUsado   := 0
Local nTotPed  := 0
Local nTotDes  := 0
Local nCntFor  := 0
Local nNumDec  := TamSX3("C6_VALOR")[2]
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)

Local cArqQry  := ""
Local cCadastro:= OemToAnsi("Atualiza‡„o de Pedidos de Venda") //
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Static oDlg
Local __lHasWSSTART
#IFDEF TOP
	Local aStruSC6 := {}
	Local cQuery   := ""
#ENDIF 

DEFAULT __lHasWSSTART := FindFunction("WS_HEADSC6")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis Privates.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTrocaF3  := {}
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aHeader	  := {}
PRIVATE aCols	  := {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1
PRIVATE aGEMCVnd  := {"",{},{}} //Template GEM - Condicao de Venda
private oGetd
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Ambiente/Objeto para tratamento de grade        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ        
If FindFunction("MsMatGrade") .And. IsAtNewGrd()
	//MsMatGrade():New(cObj,cProdRef,cCpo,cTudoOk,cVldCpoGrd,aSetKey,aCposCtrlGrd,lShowGrd)  	
	PRIVATE oGrade	  := MsMatGrade():New('oGrade',,"C6_QTDVEN",,"a410GValid()",;
	  						{ 	{VK_F4,{|| A440Saldo(.T.,oGrade:aColsAux[oGrade:nPosLinO][aScan(oGrade:aHeadAux,{|x| AllTrim(x[2])=="C6_LOCAL"})])}} },;
	  						{ 	{"C6_QTDVEN",NIL,NIL},;
	  							{"C6_QTDLIB",NIL,NIL},;
	  							{"C6_QTDENT",NIL,NIL},;
	  							{"C6_ITEM"	,NIL,NIL},;
	  							{"C6_UNSVEN",NIL,NIL}	})
Else
	PRIVATE aColsGrade:= {}
	PRIVATE aHeadGrade:= {}
EndIf	                   

If Type("Inclui") == "U"
	Inclui := .F.
	Altera := .F.
EndIf  
Pergunte("MTA410",.F.)
If ( lGrade )
	aRotina[nOpc][4] := 6
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis da Enchoice.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "SC5", .F., .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lHeadSC6 := .f.
If __lHasWSSTART
	lHEADSC6 := WS_HEADSC6(.t.,cEmpAnt,@aHeadSC6)
EndIf

If !lHEADSC6
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If ( cNivel >= SX3->X3_NIVEL .AND.;
				(Trim(SX3->X3_CAMPO) == "C6_ITEM"  	.OR.;
				Trim(SX3->X3_CAMPO) == "C6_PRODUTO" .OR.;
				Trim(SX3->X3_CAMPO) == "C6_DESCRI" 	.OR.;
				Trim(SX3->X3_CAMPO) == "C6_QTDVEN" 	.OR.;
				Trim(SX3->X3_CAMPO) == "C6_QTDENT" 	.OR.;
				Trim(SX3->X3_CAMPO) == "C6_ENTREG" .OR.;			   //	Trim(SX3->X3_CAMPO) == "C6_SEPAR" .OR.;
				Trim(SX3->X3_CAMPO) == "C6_QTSP" 	.OR.;			  //	Trim(SX3->X3_CAMPO) == "C6_COMPRAR" .OR.;
				Trim(SX3->X3_CAMPO) == "C6_QTOC" 	.OR.;			  //	Trim(SX3->X3_CAMPO) == "C6_OS" .OR.;
				Trim(SX3->X3_CAMPO) == "C6_QTOS" .OR.;			  //	trim(SX3->X3_CAMPO) == "C6_RETORNO" .OR.;
				Trim(SX3->X3_CAMPO) == "C6_QTRET" .OR.;
				Trim(SX3->X3_CAMPO) == "C6_QTINSP" .OR.;
				Trim(SX3->X3_CAMPO) == "C6_DTDISP"))
				
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo

	If __lHasWSSTART
		WS_HEADSC6(.f.,cEmpAnt,aHeader)
	EndIf
Else
	aHeader := aClone( aHeadSC6 )
	nUsado  := Len( aHeader )
EndIf

For nCntFor := 1 To Len(aHeader)
	If aHeader[nCntFor][8] == "M"
		aadd(aCpos1,aHeader[nCntFor][2])
	EndIf
Next nCntFor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SC6")
dbSetOrder(1)
#IFDEF TOP
	If Ascan(aHeader,{|x| x[8] == "M"}) == 0
		aStruSC6:= SC6->(dbStruct())
		cArqQry := "SC6"
		lQuery  := .T.
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
		cQuery += "SC6.D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbSelectArea("SC6")
		dbCloseArea()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		For nCntFor := 1 To Len(aStruSC6)
			If ( aStruSC6[nCntFor,2]<>"C" )
				TcSetField(cArqQry,aStruSC6[nCntFor,1],aStruSC6[nCntFor,2],aStruSC6[nCntFor,3],aStruSC6[nCntFor,4])
			EndIf
		Next nCntFor
	Else
#ENDIF
	cArqQry := "SC6"
	MsSeek(xFilial("SC6")+SC5->C5_NUM)
	#IFDEF TOP
	EndIf
	#ENDIF
While ( !Eof() .And. (cArqQry)->C6_FILIAL == xFilial("SC6") .And.;
		(cArqQry)->C6_NUM 	== SC5->C5_NUM )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se este item foi digitada atraves de uma    ³
	//³ grade, se for junta todos os itens da grade em uma   ³
	//³ referencia , abrindo os itens so quando teclar enter ³
	//³ na quantidade                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (cArqQry)->C6_GRADE == "S" .And. lGrade )
		a410Grade(.F.,,cArqQry,.T.)
	Else
		AADD(aCols,Array(Len(aHeader)))
		For nCntFor:=1 To Len(aHeader)
			If ( aHeader[nCntFor,10] <>  "V" .And. AllTrim(aHeader[nCntFor,2]) <> "C6_QTDLIB" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mesmo nao sendo um item digitado atraves de grade e' necessa-³
		//³ rio criar o Array referente a este item para controle da     ³
		//³ grade                                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
		If FindFunction("MsMatGrade") .And. IsAtNewGrd()
	   		oGrade:MontaGrade(Len(aCols)) 
	 	Else
			MatGrdMont(Len(aCols))
	 	EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua a Somatoria do Rodape                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotPed	+= (cArqQry)->C6_VALOR
	If ( (cArqQry)->C6_PRUNIT = 0 )
		nTotDes	+= (cArqQry)->C6_VALDESC
	Else
		nTotDes += A410Arred(((cArqQry)->C6_PRUNIT*(cArqQry)->C6_QTDVEN),"C6_VALOR")-A410Arred(((cArqQry)->C6_PRCVEN*(cArqQry)->C6_QTDVEN),"C6_VALOR")
	EndIf

	dbSelectArea(cArqQry)
	dbSkip()
EndDo
nTotPed  -= M->C5_DESCONT
nTotDes  += M->C5_DESCONT
nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
If ( lQuery )
	dbSelectArea(cArqQry)
	dbCloseArea()
	ChkFile("SC6",.F.)
	dbSelectArea("SC6")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o array com as formas de pagamento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ma410MtFor(@aHeadFor,@aColsFor)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao ache nenhum item , abandona rotina.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Len(aCols) == 0 )
	Help(" ",1,"A410SEMREG")
	lContinua := .F.
EndIf

If ( lContinua )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
		{{003,033,160,200,240,263}} )

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( M->C5_TIPO $ "DB" )
		aTrocaF3 := {{"C5_CLIENTE","SA2"}}
	Else
		aTrocaF3 := {}
	EndIf
	EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1],aCpos2,3,,,"A415VldTOk")
	nGetLin := aPosObj[3,1]
	@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB","Fornec:","Cliente")) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!" OF oDlg PIXEL
	@ nGetLin,aPosGet[1,3]  SAY OemToAnsi("Total :")						SIZE 020,09 OF oDlg PIXEL	//"Total :"
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL
	@ nGetLin,aPosGet[1,5]  SAY OemToAnsi("Desc. :")						SIZE 020,09 OF oDlg PIXEL	//"Desc. :"
	@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL RIGHT
	@ nGetLin+10,aPosGet[1,5] SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
	@ nGetLin+10,aPosGet[1,6] SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,nNumDec) OF oDlg PIXEL RIGHT
	oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
		oSay2:SetText(n2),;
		oSay3:SetText(n3),;
		oSay4:SetText(n4) }
	oGetd   := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,nColFreeze,,"",,,,,,lFreeze)	
	Ma410Rodap(oGetd,nTotPed,nTotDes)
	ACTIVATE MSDIALOG oDlg ON INIT (/*A410LIMPA(.F.,M->C5_TIPO),*/HC410BAR(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},nOpc,oGetD))
    //(A410Limpa(.F.,M->C5_TIPO),MA410OPC(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},nOpc,oGetD))
EndIf

aRotina := aClone(aBackRot)
RestArea(aArea)
Return( nOpcA )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta posicao de follow-up para entrega do produto                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function RFTL21K()
Local aBackRo2 := aClone(aCOLS)
Local oDlgl
Local oButton
Local oCombo1
Local cCombo1
Local aItems1:= {"Comprar","Fazer OS","Separado"} 
Static nQtd1:=0

Local oCombo2
Local cCombo2
Local aItems2:= {"Comprar","Fazer OS","Separado"}
Static nQtd2:=0

Local oCombo3
Local cCombo3
Local aItems3:= {"Comprar","Fazer OS","Separado"}
Static nQtd3:=0 
LOCAL LRET:=.T.

Local oCombo4
Local cCombo4
Local aItems4:= {"Comprado"}
Static nQtd4:=0  

Local oCombo5
Local cCombo5
Local aItems5:= {"Em Inspecao"}
Static nQtd5:=0 

LOCAL LRET:=.T.
Static cStatus:=SC6->C6_STATUS

nQtd1:=acols[n,7]
nQtd3:=acols[n,8]
nQtd2:=acols[n,9]
nQtd4:=acols[n,10]
nQtd5:=acols[n,11]
IF ACOLS[N,4]<>aCOLS[N,5]		
  @ 000,000 To 450,400 Dialog Odlgl Title OemToAnsi("Follow up de vendas")
  @ 003,004 To 25,200 Title OemToAnsi("Processo") 
  @ 010,015 Say OemToAnsi("Pedido") OF Odlgl PIXEL
  //@ 035,015 GET cTpAverb SIZE 30,10 F3 "12" 
  @ 010,055 Say SC5->C5_NUM SIZE 45,10 PICTURE PesqPict("SC6","C6_NUM")OF Odlgl PIXEL
  @ 010,115 Say OemToAnsi("Item")OF Odlgl PIXEL
  //@ 035,015 GET cTpAverb SIZE 30,10 F3 "12" 
  @ 010,155 say ACOLS[N,1] SIZE 30,10 PICTURE PesqPict("SC6","C6_ITEM")OF Odlgl PIXEL
  
  @ 027,004 To 100,200 Title OemToAnsi("Dados do Produto") 
  @ 035,015 Say OemToAnsi("Produto")OF Odlgl PIXEL
  @ 035,055 Say ACOLS[N,2] SIZE 100,10 PICTURE PesqPict("SC6","C6_COD") OF Odlgl PIXEL  
  @ 047,015 Say OemToAnsi("Descricao")OF Odlgl PIXEL
  @ 047,055 SAY ACOLS[N,3] SIZE 200,10 PICTURE PesqPict("SC6","C6_DESCRI")OF Odlgl PIXEL
  @ 059,015 Say OemToAnsi("Qtd Venda")OF Odlgl PIXEL
  @ 059,055 SAY ACOLS[N,4] SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDVEN")OF Odlgl PIXEL                                           
  @ 071,015 Say OemToAnsi("Qtd Entr.")OF Odlgl PIXEL
  @ 071,055 SAY aCOLS[N,5] SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDENT")OF Odlgl PIXEL
  @ 083,015 Say OemToAnsi("Prazo")OF Odlgl PIXEL
  @ 083,055 SAY ACOLS[N,6] SIZE 40,10 PICTURE PesqPict("SC6","C6_ENTREG") OF Odlgl PIXEL 

  @ 103,004 To 195,200 Title OemToAnsi("Follow_up") 
  cCombo1:= aItems1[3]
  oCombo1:= tComboBox():New(110,12,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems1,100,20,oDlgl,,,,,,.T.,,,,,,,,,"cCombo1")
  @ 110,150 MSGET nQtd1 SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDVEN")OF Odlgl PIXEL
  cCombo2:= aItems2[2]
  oCombo2:= tComboBox():New(122,12,{|u|if(PCount()>0,cCombo2:=u,cCombo2)},aItems2,100,20,oDlgl,,,,,,.T.,,,,,,,,,"cCombo2")
  @ 122,150 MSGET nQtd2 SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDVEN")OF Odlgl PIXEL
  cCombo3:= aItems3[1]
  oCombo3:= tComboBox():New(134,12,{|u|if(PCount()>0,cCombo3:=u,cCombo3)},aItems3,100,20,oDlgl,,,,,,.T.,,,,,,,,,"cCombo3")
  @ 134,150 MSGET nQtd3 SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDVEN")OF Odlgl PIXEL
  cCombo4:= aItems4[1]
  oCombo4:= tComboBox():New(146,12,{|u|if(PCount()>0,cCombo4:=u,cCombo4)},aItems4,100,20,oDlgl,,,,,,.T.,,,,,,,,,"cCombo4")
  @ 146,150 MSGET nQtd4 SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDVEN")OF Odlgl PIXEL
  cCombo5:= aItems5[1]
  oCombo5:= tComboBox():New(158,12,{|u|if(PCount()>0,cCombo5:=u,cCombo5)},aItems5,100,20,oDlgl,,,,,,.T.,,,,,,,,,"cCombo5")
  @ 158,150 MSGET nQtd5 SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDVEN")OF Odlgl PIXEL
  @ 182,015 Say OemToAnsi("Disposicao")OF Odlgl PIXEL
  @ 182,045 MSGET cStatus SIZE 140,10 PICTURE PesqPict("SC6","C6_STATUS")OF Odlgl PIXEL
  */ 
  @ 205,100 BMPBUTTON TYPE 1 ACTION OkProc(odlgl)
  @ 205,150 BMPBUTTON TYPE 2 ACTION FINALIZA(odlgl)

  Activate Dialog Odlgl CENTER
ENDIF

Return(LRET)

Static Function Finaliza(Odlg1)
 Close(Odlg1)
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkProc    ºAutor  ³Robson Bueno        º Data ³ 10/08/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Confirmacao do Processo de digitacao dados                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkProc(odlg1)

Local aArea    := GetArea()
Local nDisp    :=nQtd1+nQtd2+nQtd3+nQtd4+nQtd5
Local nSaldo   :=ACOLS[N,4]-ACOLS[N,5]  
Local nGuarda  :=n
IF nDisp>nSaldo
  MsgInfo("A quantidade disposta: " + ALLTRIM(str(nDISP)) +" é maior que o saldo do pedido "+ ALLTRIM(str(nSALDO)) + ", verifique")
else
dbSelectArea("SC6")
dbSetOrder(1)
MsSeek(xFilial("SC6")+SC5->C5_NUM+ACOLS[N,1])
IF (!Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And.;
		SC6->C6_NUM	== SC5->C5_NUM )
  RecLock("SC6",.F.)
  // gravando e atualizando disposicao 1
  if nQtd1=ACOLS[N,4]   
    SC6->C6_SEPAR:="1"
    SC6->C6_QTSP :=nQtd1
  endif
  if nQtd1<>ACOLS[N,4] .and. nQtd1>0   
    SC6->C6_SEPAR:="2"
    SC6->C6_QTSP :=nQtd1
  endif  
  if nQtd1=0   
    SC6->C6_SEPAR:="3"
    SC6->C6_QTSP:=nQtd1
  endif 
  //ACOLS[N,7]:=SC6->C6_SEPAR
  ACOLS[N,7]:=SC6->C6_QTSP
  
  // gravando e atualizando disposicao 2
  if nQtd3=ACOLS[N,4]   
    SC6->C6_COMPRAR:="3"
    SC6->C6_QTOC   :=nQtd3
  endif
  if nQtd3<>ACOLS[N,4] .and. nQtd3>0   
    SC6->C6_COMPRAR:="2"
    SC6->C6_QTOC   :=nQtd3
  endif  
  if nQtd3=0   
    SC6->C6_COMPRAR:="1"
    SC6->C6_QTOC   :=nQtd3
  endif
  //ACOLS[N,9]:=SC6->C6_COMPRAR
  ACOLS[N,8]:=SC6->C6_QTOC
    
  // gravando e atualizando disposicao 3
  if nQtd2=ACOLS[N,4]   
    SC6->C6_OS  :="3"
    SC6->C6_QTOS:=nQtd2
  endif
  if nQtd2<>ACOLS[N,4] .and. nQtd2>0   
    SC6->C6_OS  :="2"
    SC6->C6_QTOS:=nQtd2
  endif  
  if nQtd2=0   
    SC6->C6_OS  :="1"
    SC6->C6_QTOS:=nQtd2
  endif
  //ACOLS[N,11] :=SC6->C6_OS
  ACOLS[N,9]:=SC6->C6_QTOS
    
  // gravando e atualizando disposicao 4
  if nQtd4=ACOLS[N,4]   
    SC6->C6_Retorno:="3"
    SC6->C6_QTRET :=nQtd4
  endif
  if nQtd4<>ACOLS[N,4] .and. nQtd4>0   
    SC6->C6_RETORNO:="2"
    SC6->C6_QTRET :=nQtd4
  endif  
  if nQtd4=0   
    SC6->C6_RETORNO:="1"
    SC6->C6_QTRET:=nQtd4
  endif 
  //ACOLS[N,13]:=SC6->C6_RETORNO
  ACOLS[N,10]:=SC6->C6_QTRET 
  
  
  // gravando e atualizando disposicao 5
  if nQtd5=ACOLS[N,4]   
    SC6->C6_INSPEC:="3"
    SC6->C6_QTINSP :=nQtd5
  endif
  if nQtd5<>ACOLS[N,4] .and. nQtd5>0   
    SC6->C6_INSPEC:="2"
    SC6->C6_QTINSP :=nQtd5
  endif  
  if nQtd5=0   
    SC6->C6_INSPEC:="1"
    SC6->C6_QTINSP:=nQtd5
  endif 
  //ACOLS[N,13]:=SC6->C6_RETORNO
  ACOLS[N,11]:=SC6->C6_QTINSP
  
  
  IF SC6->C6_DTDISP=CTOD("  /  /  ")
    SC6->C6_DTDISP :=DATE()
  ENDIF
  ACOLS[N,12]:=SC6->C6_DTDISP
  SC6->C6_STATUS := cStatus 
  MsUnLock()               	
ENDIF
oGetd:ForceRefresh()
IF LEN(ACOLS)<nGuarda+1 
 oGetD:oBrowse:nAt := nguarda
 N:=nGuarda  
else
 oGetD:oBrowse:nAt := nguarda +1
 N:=nGuarda +1  
endif 
 
//RestArea(aArea)
//ACOLS:REFRESH()
Close(Odlg1)
//RestArea(aArea)


endif
Return
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta posicao de follow-up para entrega do produto                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function RFTL21M()
Local aBackRo3 := aClone(aCOLS)
Local oDlgl
Static nQtd7:=0
Static nQtd8:=0
Static nQtd9:=0 
Static nQtd10:=0  
Static nQtd11:=0 
LOCAL LRET:=.T.
Static cStatus:=SC6->C6_STATUS
FOR n:=1 to len(acols)
  nQtd7:=acols[n,7]
  nQtd8:=acols[n,8]
  nQtd9:=acols[n,9]
  nQtd10:=acols[n,10]
  nQtd11:=acols[n,11]
  IF ACOLS[N,4]<>aCOLS[N,5]
    dbSelectArea("SC6")
    dbSetOrder(1)
    MsSeek(xFilial("SC6")+SC5->C5_NUM+ACOLS[N,1])
    IF (!Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And.;
	                         	SC6->C6_NUM	== SC5->C5_NUM )
        RecLock("SC6",.F.)
        // gravando e atualizando disposicao 1
        SC6->C6_SEPAR  :="3"
        SC6->C6_QTSP   :=0
        ACOLS[N,7]     :=0
        SC6->C6_COMPRAR:="3"
        SC6->C6_QTOC   :=ACOLS[N,4]-ACOLS[N,5]
        ACOLS[N,8]     :=SC6->C6_QTOC
        SC6->C6_OS     :="1"
        SC6->C6_QTOS   :=0
        ACOLS[N,9]     :=0
        SC6->C6_RETORNO:="1"
        SC6->C6_QTRET  :=0
        ACOLS[N,10]    :=0 
        SC6->C6_INSPEC :="1"
        SC6->C6_QTINSP :=0
        ACOLS[N,11]    :=0
        IF SC6->C6_DTDISP=CTOD("  /  /  ")
          SC6->C6_DTDISP :=DATE()
        ENDIF
        ACOLS[N,12]:=SC6->C6_DTDISP
        SC6->C6_STATUS := cStatus 
        MsUnLock()               	
    ENDIF  
  ENDIF  
 NEXT
 MsgInfo("Processo Realizado com Sucesso")
 oGetd:ForceRefresh()
 oGetD:oBrowse:nAt := 1
 
RETURN


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta posicao de follow-up para entrega do produto                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function RFTL21N()
Local aBackRo3 := aClone(aCOLS)
Local oDlgl
Static nQtd7:=0
Static nQtd8:=0
Static nQtd9:=0 
Static nQtd10:=0  
Static nQtd11:=0 
LOCAL LRET:=.T.
Static cStatus:=SC6->C6_STATUS
FOR n:=1 to len(acols)
  nQtd7:=acols[n,7]
  nQtd8:=acols[n,8]
  nQtd9:=acols[n,9]
  nQtd10:=acols[n,10]
  nQtd11:=acols[n,11]
  IF ACOLS[N,4]<>aCOLS[N,5]
    dbSelectArea("SC6")
    dbSetOrder(1)
    MsSeek(xFilial("SC6")+SC5->C5_NUM+ACOLS[N,1])
    IF (!Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And.;
	                         	SC6->C6_NUM	== SC5->C5_NUM )
        RecLock("SC6",.F.)
        // gravando e atualizando disposicao 1
        SC6->C6_SEPAR  :="3"
        SC6->C6_QTSP   :=0
        ACOLS[N,7]     :=0
        SC6->C6_COMPRAR:="1"
        SC6->C6_QTOC   :=0
        ACOLS[N,8]     :=0
        SC6->C6_OS     :="1"
        SC6->C6_QTOS   :=0
        ACOLS[N,9]     :=0
        SC6->C6_RETORNO:="1"
        SC6->C6_QTRET  :=0
        ACOLS[N,10]    :=0 
        SC6->C6_INSPEC :="3"
        SC6->C6_QTINSP :=ACOLS[N,4]-ACOLS[N,5]
        ACOLS[N,11]    :=SC6->C6_QTINSP
        IF SC6->C6_DTDISP=CTOD("  /  /  ")
          SC6->C6_DTDISP :=DATE()
        ENDIF
        ACOLS[N,12]:=SC6->C6_DTDISP
        SC6->C6_STATUS := cStatus 
        MsUnLock()               	
    ENDIF  
  ENDIF  
 NEXT
 MsgInfo("Processo Realizado com Sucesso")
 oGetd:ForceRefresh()
 oGetD:oBrowse:nAt := 1
 
RETURN





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma410Bar  ³ Autor ³ Eduardo Riera         ³ Data ³ 18.02.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do Mata410                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oDlg: 	Objeto Dialog                                     ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:    nOpc transmitido pela mbrowse                     ³±±
±±³          ³ aForma: Array com as formas de pagamento                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function HC410Bar(oDlg,bOk,bCancel,nOpc,oGetD)

Local aButtons  := {}
Local aButtonUsr := {}
Local nI        := 0
LOCAL lOpcPadrao := GetNewPar("MV_REPGOPC","N") == "N"
Local nPProduto	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPOpcional:= If(lOpcPadrao,aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPC"}),aScan(aHeader,{|x| AllTrim(x[2])=="C6_MOPC"}))
Local aROpc := {}
Local cOpcional := ""
If ( nOpc == 2 .Or. nOpc == 5 ) .And. nPOpcional > 0
	If lOpcPadrao
		cOpcional := aCols[n][nPOpcional]
	Else
		aROpc:=STR2Array(aCols[n][nPOpcional],.F.)
		If !Empty(aRopc)
			For nI := 1 To Len(aROpc)
				cOpcional += aROpc[nI,2]
			Next
		Endif
	Endif
	Aadd(aButtons,{"SDUCOUNT", {|| SeleOpc(2,,aCols[n][nPProduto],,,cOpcional,"M->C6_PRODUTO",.T.) } ,"Opcionais Selecionados","Opcionais"}) //"Opcionais Selecionados"###"Opcionais"
EndIf
aadd(aButtons,{"BUDGET",{|| U_RFTL21K(nOpc)},"Dispor Acao ao Item" , "Dispor" }) //"Formas de Pagamento"
aadd(aButtons,{"BUDGET",{|| U_RFTL21M(nOpc)},"Sol. Compra a Todos" , "SCompra" }) //"Formas de Pagamento" 
aadd(aButtons,{"BUDGET",{|| U_RFTL21N(nOpc)},"Sol. Insp. a Todos" , "SInsp." }) //"Formas de Pagamento"
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))
/*/
                 
