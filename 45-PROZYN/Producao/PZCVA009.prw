#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PZCVA009		ºAutor  ³Microsiga	     º Data ³  06/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Complemento de importação									  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PZCVA009(cDoc, cSerie, cFornece, cLoja)

	Local aArea	:= GetArea()

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""

	//Verifica se a NF é de importação
	If IsDocImp(cDoc, cSerie, cFornece, cLoja)
		TelaComple(cDoc, cSerie, cFornece, cLoja)
	EndIf

	RestArea(aArea)	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³IsDocImp		ºAutor  ³Microsiga	     º Data ³  06/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o documento é de importação					  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IsDocImp(cDoc, cSerie, cFornece, cLoja)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lRet		:= .F.

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""

	cQuery := " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("SF1")+" SF1 "+CRLF

	cQuery += " WHERE SF1.F1_FILIAL = '"+xFilial("SF1")+"' "+CRLF
	cQuery += " AND SF1.F1_DOC = '"+cDoc+"' "+CRLF
	cQuery += " AND SF1.F1_SERIE = '"+cSerie+"' "+CRLF
	cQuery += " AND SF1.F1_FORNECE = '"+cFornece+"' "+CRLF
	cQuery += " AND SF1.F1_LOJA = '"+cLoja+"' "+CRLF
	cQuery += " AND SF1.F1_FORMUL = 'S' "+CRLF
	cQuery += " AND SF1.F1_EST = 'EX' "+CRLF
	cQuery += " AND SF1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR > 0
		lRet := .T.
	Else
		lRet := .F.
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)	
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TelaComple	ºAutor  ³Microsiga	     º Data ³  06/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os dados na tabela CD5, com base na tabela SD1		  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TelaComple(cDoc, cSerie, cFornece, cLoja)

	Local aArea	:= GetArea()
	Local oDlg 
	Local oScr
	Local oFWLayer 
	Local oButtConf
	Local oFont 		:= TFont():New("CALIBRI",,-14,.T.)
	Local cDi			:= Space(TAMSX3("CD5_NDI")[1])
	Local dDtDi			:= CTOD('')
	Local cDescLocal	:= Space(TAMSX3("CD5_LOCDES")[1])
	Local cUfDesemb		:= Space(TAMSX3("CD5_UFDES")[1])
	Local dDtDesemb		:= CTOD('')
	Local aCombTrans	:= Separa(StrTran(cBoxVTrans()," ",""),";")
	Local cCombTrans	:= Space(1)
	Local oWin01		:= Nil
	Local nLin			:= 5
	Local nPulLin		:= 20
	Local cObsNf		:= ""
	Local cAtoConces	:= Space(TAMSX3("CD5_ACDRAW")[1])
	Local lOk			:= .F. 
	Local lAtoConces	:= .F.

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""

	lAtoConces := IsAtoConces(cDoc, cSerie, cFornece, cLoja)

	//-----------------------------------------
	// Criação de classe para definição da proporção da interface
	//-----------------------------------------
	oSize := FWDefSize():New(.T., , nOr(WS_VISIBLE,WS_POPUP) )
	oSize:AddObject("TOP", 100, 100, .T., .T.)
	oSize:aMargins := {0,0,0,0}
	oSize:Process()

	DEFINE DIALOG oDlg TITLE "Complemento de Importação"  FROM 10,10 TO 600,800 PIXEL //STYLE nOr(WS_VISIBLE,WS_POPUP)

	//Cria instancia do fwlayer
	oFWLayer := FWLayer():New()

	//Inicializa componente passa a Dialog criada,o segundo parametro é para 
	//criação de um botao de fechar utilizado para Dlg sem cabeçalho 		  
	oFWLayer:Init( oDlg, .T. )

	// Efetua a montagem das colunas das telas
	oFWLayer:AddCollumn( "Col01", 100, .T. )


	// Cria windows passando, nome da coluna onde sera criada, nome da window			 	
	// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,	
	// se é redimensionada em caso de minimizar outras janelas e a ação no click do split 	
	oFWLayer:AddWindow( "Col01", "Win01", "Dados do complemento", 100, .F., .T., ,,) 

	oWin01 := oFWLayer:getWinPanel('Col01','Win01')

	//Scroll dos parametros
	oScr		:= TScrollBox():New(oWin01,00,00,oWin01:NCLIENTHEIGHT*.45,oWin01:NCLIENTWIDTH*.50,.T.,.T.,.T.)
	oScr:Align 	:= CONTROL_ALIGN_ALLCLIENT

	//nLin+=nPulLin
	TSay():New(nLin,010,{||"*No. da DI/DA: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
	TGet():New(nLin,85,bSetGet(cDi),oScr,80,09,"@!", {||},,,, .T.,, .T.,, .T., /*&(cBlkWhen)*/, .F., .F.,, .F., .F. ,"","",,,,.T.)

	nLin+=nPulLin
	TSay():New(nLin,010,{||"*Registro DI: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)           
	TGet():New(nLin,85,bSetGet(dDtDi),oScr,080,09,"@!", /*&(cBlkVld)*/,,,, .T.,, .T.,, .T., /*&(cBlkWhen)*/, .F., .F.,, .F., .F. ,"","",,,,.T.)

	nLin+=nPulLin
	TSay():New(nLin,010,{||"*Descr.Local: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
	TGet():New(nLin,85,bSetGet(cDescLocal),oScr,120,09,"@!", {||},,,, .T.,, .T.,, .T., /*&(cBlkWhen)*/, .F., .F.,, .F., .F. ,"","",,,,.T.)

	nLin+=nPulLin
	TSay():New(nLin,010,{||"*UF Desembaraço: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
	TGet():New(nLin,85,bSetGet(cUfDesemb),oScr,060,09,"@!", {||},,,, .T.,, .T.,, .T., /*&(cBlkWhen)*/, .F., .F.,, .F., .F. ,"","",,,,.T.)

	nLin+=nPulLin
	TSay():New(nLin,010,{||"*Dt.Desembaraço: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)           
	TGet():New(nLin,85,bSetGet(dDtDesemb),oScr,060,09,"@!", /*&(cBlkVld)*/,,,, .T.,, .T.,, .T., /*&(cBlkWhen)*/, .F., .F.,, .F., .F. ,"","",,,,.T.)

	nLin+=nPulLin
	TSay():New(nLin,010,{||"*Via Transp: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
	TComboBox():New(nLin,085,{|u|if(PCount()>0,cCombTrans:=u,cCombTrans)},aCombTrans,110,50,oScr,,{||},,,,.T.,,,,,,,,,'cCombTrans')

	//nLin+=nPulLin
	//TSay():New(nLin,010,{||"*Forma Import.: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
	//TComboBox():New(nLin,085,{|u|if(PCount()>0,cFormImp:=u,cFormImp)},aFormImp,110,50,oScr,,{||},,,,.T.,,,,,,,,,'cFormImp')

	If lAtoConces
		nLin+=nPulLin
		TSay():New(nLin,010,{||"*Ato concessório: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
		TGet():New(nLin,85,bSetGet(cAtoConces),oScr,80,09,"@!", {||},,,, .T.,, .T.,, .T., /*&(cBlkWhen)*/, .F., .F.,, .F., .F. ,"","",,,,.T.)
	EndIf

	nLin+=nPulLin
	TSay():New(nLin,010,{||"*Observação NF: "},oScr,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
	TMultiGet():New( nLin,85, {|u| if( Pcount()>0, cObsNf:= u, cObsNf) },oScr,183,60 ,,.T.,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,.T.)

	//Adiciona as barras dos botões                                                                                                                   
	DEFINE BUTTONBAR oBarTree SIZE 10,10 3D BOTTOM OF oWin01

	oButtConf 	:= thButton():New(01,01, "Confirma"	, oBarTree,  {|| lOk := VldParam(cDi, dDtDi, cDescLocal, cUfDesemb, dDtDesemb,;
	cCombTrans, cObsNf, cAtoConces, lAtoConces),; 
	Iif(lOk,oDlg:End(),Nil) },35,20,)
	//oButtSaid	:= thButton():New(01,01, "Sair"		, oBarTree,  {|| oDlg:End() },25,20,)

	//oButtSaid:Align 	:= CONTROL_ALIGN_RIGHT 
	oButtConf:Align 	:= CONTROL_ALIGN_RIGHT

	ACTIVATE DIALOG oDlg CENTERED

	If lOk
		//Realiza a gravação dos dados complementares da importação
		GrvCd5D1(cDoc, cSerie, cFornece, cLoja, cDi, dDtDi, cDescLocal, cUfDesemb, dDtDesemb, cCombTrans, cAtoConces, cObsNf)
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³VldParam		ºAutor  ³Microsiga	     º Data ³  06/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação dos parametros									  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldParam(cDi, dDtDi, cDescLocal, cUfDesemb, dDtDesemb, cCombTrans, cObsNf, cAtoConces, lAtoConces)

	Local aArea		:= GetArea()
	Local lRet		:= .T.
	Local cMsgAux	:= ""

	DEFAULT cDi			:= ""
	DEFAULT dDtDi		:= CTOD('')
	DEFAULT cDescLocal	:= ""
	DEFAULT cUfDesemb	:= ""
	DEFAULT dDtDesemb	:= CTOD('')
	DEFAULT cCombTrans	:= ""
	DEFAULT cObsNf		:= ""
	DEFAULT cAtoConces	:= "" 
	DEFAULT lAtoConces	:= .F.

	If Empty(cDi)
		cMsgAux	+= '-Campo "No. da DI/DA" não preenchido;'+CRLF
		lRet	:= .F.
	EndIf

	If Empty(dDtDi)
		cMsgAux	+= '-Campo "Registro DI" não preenchido;'+CRLF
		lRet	:= .F.
	EndIf

	If Empty(cDescLocal)
		cMsgAux	+= '-Campo "Descr.Local" não preenchido;'+CRLF
		lRet	:= .F.
	EndIf

	If Empty(cUfDesemb)
		cMsgAux	+= '-Campo "UF Desembaraço" não preenchido;'+CRLF
		lRet	:= .F.
	EndIf

	If Empty(dDtDesemb)
		cMsgAux	+= '-Campo "Dt.Desembaraço" não preenchido;'+CRLF
		lRet	:= .F.
	EndIf

	If Empty(cCombTrans)
		cMsgAux	+= '-Campo "Via Transp" não preenchido;'+CRLF
		lRet	:= .F.
	EndIf

	If Empty(cObsNf)
		cMsgAux	+= '-Campo "Observação NF" não preenchido;'+CRLF
		lRet	:= .F.
	EndIf

	If lAtoConces .And. Empty(cAtoConces)
		cMsgAux	+= '-Campo "Ato concessório" não preenchido;'+CRLF
		lRet	:= .F.
	EndIf

	If !lRet
		Aviso("Validação",cMsgAux,{"Ok"},2)
	EndIf

	RestArea(aArea)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvCd5D1		ºAutor  ³Microsiga	     º Data ³  06/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os dados na tabela CD5, com base na tabela SD1		  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCd5D1(cDoc, cSerie, cFornece, cLoja, cDi, dDtDi, cDescLocal, cUfDesemb, dDtDesemb, cCombTrans, cAtoConces, cObsNf)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cCFOPAc	:= U_MyNewSX6("CV_CFOPAC", "3127;3211"	,"C","CFOP´s dos atos concessórios", "", "", .F. )

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""
	DEFAULT cDi			:= ""
	DEFAULT dDtDi		:= CTOD('')
	DEFAULT cDescLocal	:= ""
	DEFAULT cUfDesemb	:= ""
	DEFAULT dDtDesemb	:= CTOD('')
	DEFAULT cCombTrans	:= ""
	Default cAtoConces	:= "" 
	Default cObsNf		:= ""

	cQuery	:= " SELECT D1_ITEM, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_BASIMP6, D1_ALQIMP6, D1_VALIMP6, D1_BASIMP5, D1_ALQIMP5, D1_CF, "+CRLF
	cQuery	+= " D1_VALIMP5, F1_ESPECIE, CD5.R_E_C_N_O_ RECCD5 "+CRLF

	cQuery	+= " FROM "+RetSqlName("SF1")+" SF1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SD1")+" SD1 "+CRLF
	cQuery	+= " ON SD1.D1_FILIAL = SF1.F1_FILIAL "+CRLF
	cQuery	+= " AND SD1.D1_DOC = SF1.F1_DOC "+CRLF
	cQuery	+= " AND SD1.D1_SERIE = SF1.F1_SERIE "+CRLF
	cQuery	+= " AND SD1.D1_FORNECE = SF1.F1_FORNECE "+CRLF
	cQuery	+= " AND SD1.D1_LOJA = SF1.F1_LOJA "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("CD5")+" CD5 "+CRLF
	cQuery	+= " ON CD5.CD5_FILIAL = '"+xFilial("CD5")+"' "+CRLF
	cQuery	+= " AND CD5.CD5_DOC = SD1.D1_DOC "+CRLF
	cQuery	+= " AND CD5.CD5_SERIE = SD1.D1_SERIE "+CRLF
	cQuery	+= " AND CD5.CD5_FORNEC = SD1.D1_FORNECE "+CRLF
	cQuery	+= " AND CD5.CD5_LOJA = SD1.D1_LOJA "+CRLF
	cQuery	+= " AND CD5.CD5_ITEM = SD1.D1_ITEM "+CRLF
	cQuery	+= " AND CD5.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SF1.F1_FILIAL = '"+xFilial("SF1")+"' "+CRLF
	cQuery	+= " AND SF1.F1_DOC = '"+cDoc+"' "+CRLF
	cQuery	+= " AND SF1.F1_SERIE = '"+cSerie+"' "+CRLF
	cQuery	+= " AND SF1.F1_FORNECE = '"+cFornece+"' "+CRLF
	cQuery	+= " AND SF1.F1_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SF1.F1_FORMUL = 'S' "+CRLF
	cQuery	+= " AND SF1.F1_EST = 'EX' "+CRLF
	cQuery	+= " AND SF1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If !Empty(cObsNf)
		DbSelectArea("SF1")
		DbSetOrder(1)
		If SF1->(DbSeek(xFilial("SF1")+cDoc+cSerie+cFornece+cLoja))
			RecLock("SF1",.F.)
			SF1->F1_OBSERV  := cObsNf
			SF1->(MsUnLock())
		EndIf
	EndIf

	DbSelectArea("CD5")
	DbSetOrder(1)
	While (cArqTmp)->(!Eof())


		If (cArqTmp)->RECCD5 != 0
			CD5->(DbGoTo((cArqTmp)->RECCD5))

			RecLock("CD5", .F.)
			CD5->CD5_DOC    := (cArqTmp)->D1_DOC 
			CD5->CD5_SERIE	:= (cArqTmp)->D1_SERIE
			CD5->CD5_ESPEC	:= (cArqTmp)->F1_ESPECIE
			CD5->CD5_FORNEC	:= (cArqTmp)->D1_FORNECE 
			CD5->CD5_LOJA	:= (cArqTmp)->D1_LOJA  
			CD5->CD5_BSPIS	:= (cArqTmp)->D1_BASIMP6
			CD5->CD5_ALPIS	:= (cArqTmp)->D1_ALQIMP6
			CD5->CD5_VLPIS	:= (cArqTmp)->D1_VALIMP6
			CD5->CD5_BSCOF	:= (cArqTmp)->D1_BASIMP5
			CD5->CD5_ALCOF	:= (cArqTmp)->D1_ALQIMP5
			CD5->CD5_VLCOF	:= (cArqTmp)->D1_VALIMP5                    
			CD5->CD5_CODEXP	:= (cArqTmp)->D1_FORNECE
			CD5->CD5_CODFAB	:= (cArqTmp)->D1_FORNECE
			CD5->CD5_ITEM	:= (cArqTmp)->D1_ITEM
			CD5->CD5_LOCAL  := "1"//0=Executado no País;1=Executado no Exterior, cujo resultado se verifique no País
			CD5->CD5_TPIMP	:= "0"//0=Declaracao de importacao;1=Declaracao simplificada de importacao			

			CD5->CD5_DOCIMP	:= cDi//Número doc. importação - Numero da Invoice
			CD5->CD5_NDI	:= cDi// No. da DI/DA
			CD5->CD5_DTDI	:= dDtDi //Data de Reistro da DI
			CD5->CD5_LOCDES	:= cDescLocal
			CD5->CD5_UFDES	:= cUfDesemb
			CD5->CD5_DTDES	:= dDtDesemb
			CD5->CD5_VTRANS	:= cCombTrans
			CD5->CD5_INTERM	:= "1"//1=Importação por conta própria;2=Importação por conta e ordem;3=Importação por encomenda
			
			If Alltrim((cArqTmp)->D1_CF) $ Alltrim(cCFOPAc) .And. !Empty(cAtoConces)
				CD5->CD5_ACDRAW	:= cAtoConces
			EndIf
			
			CD5->CD5_NADIC	:= "1"        
			CD5->CD5_SQADIC	:= "1"  
			CD5->CD5_DTPPIS	:= dDtDi
			CD5->CD5_DTPCOF	:= dDtDi
			CD5->(MsUnLock())
		Else
			RecLock("CD5", .T.)
			CD5->CD5_FILIAL	:= xFilial("CD5")
			CD5->CD5_DOC    := (cArqTmp)->D1_DOC 
			CD5->CD5_SERIE	:= (cArqTmp)->D1_SERIE
			CD5->CD5_ESPEC	:= (cArqTmp)->F1_ESPECIE
			CD5->CD5_FORNEC	:= (cArqTmp)->D1_FORNECE 
			CD5->CD5_LOJA	:= (cArqTmp)->D1_LOJA  
			CD5->CD5_BSPIS	:= (cArqTmp)->D1_BASIMP6
			CD5->CD5_ALPIS	:= (cArqTmp)->D1_ALQIMP6
			CD5->CD5_VLPIS	:= (cArqTmp)->D1_VALIMP6
			CD5->CD5_BSCOF	:= (cArqTmp)->D1_BASIMP5
			CD5->CD5_ALCOF	:= (cArqTmp)->D1_ALQIMP5
			CD5->CD5_VLCOF	:= (cArqTmp)->D1_VALIMP5                    
			CD5->CD5_CODEXP	:= (cArqTmp)->D1_FORNECE
			CD5->CD5_CODFAB	:= (cArqTmp)->D1_FORNECE
			CD5->CD5_ITEM	:= (cArqTmp)->D1_ITEM
			CD5->CD5_LOCAL  := "1"//0=Executado no País;1=Executado no Exterior, cujo resultado se verifique no País
			CD5->CD5_TPIMP	:= "0"//0=Declaracao de importacao;1=Declaracao simplificada de importacao

			CD5->CD5_DOCIMP	:= cDi//Número doc. importação - Numero da Invoice
			CD5->CD5_NDI	:= cDi// No. da DI/DA
			CD5->CD5_DTDI	:= dDtDi //Data de Reistro da DI
			CD5->CD5_LOCDES	:= cDescLocal
			CD5->CD5_UFDES	:= cUfDesemb
			CD5->CD5_DTDES	:= dDtDesemb
			CD5->CD5_VTRANS	:= cCombTrans
			CD5->CD5_INTERM	:= "1"//1=Importação por conta própria;2=Importação por conta e ordem;3=Importação por encomenda

			If Alltrim((cArqTmp)->D1_CF) $ Alltrim(cCFOPAc) .And. !Empty(cAtoConces)
				CD5->CD5_ACDRAW	:= cAtoConces
			EndIf

			CD5->CD5_NADIC	:= "1"        
			CD5->CD5_SQADIC	:= "1"  
			CD5->CD5_DTPPIS	:= dDtDi
			CD5->CD5_DTPCOF	:= dDtDi			

			CD5->(MsUnLock()) 
		EndIf

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³IsAtoConces	ºAutor  ³Microsiga	     º Data ³  11/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se existe ato concessório						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IsAtoConces(cDoc, cSerie, cFornece, cLoja)

	Local aArea		:= GetArea()
	Local lRet		:= .F.
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cCFOPAc	:= U_MyNewSX6("CV_CFOPAC", "3127;3211"	,"C","CFOP´s dos atos concessórios", "", "", .F. )

	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cFornece	:= "" 
	Default cLoja		:= ""

	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("SD1")+" SD1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SD1.D1_TES "+CRLF
	cQuery	+= " AND SF4.F4_CF IN"+FormatIn(cCFOPAc,";")+" "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "+CRLF
	cQuery	+= " AND SD1.D1_DOC = '"+cDoc+"' "+CRLF
	cQuery	+= " AND SD1.D1_SERIE = '"+cSerie+"' "+CRLF
	cQuery	+= " AND SD1.D1_FORNECE = '"+cFornece+"' "+CRLF
	cQuery	+= " AND SD1.D1_LOJA = '"+cLoja+"' "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR
		lRet := .T.
	EndIf
	
	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet
