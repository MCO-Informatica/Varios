#Include 'Protheus.ch'
#Include "TopConn.ch"

Static aE1_COMPLEMENTO := {}
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VNDA600  บAutor  ณOpvs (Robson/David) บ Data ณ  08/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Processamento de Liquida็ใo de titulos consi-    บฑฑ
ฑฑบ          ณ derando vouchers emitidos e que geram NF e Titulos a Rec  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VNDA600()
	Local aSay := {}
	Local aButton := {}
	Local lImp := .F.
	Local aRet := {}
	Local nOpcao := 0
	
	Private aPBox := {}
	Private cCadastro	:= 'Voucher Corporativo'
	
	AAdd( aSay, 'Este programa permite efetuar a liquida็ใo dos tํtulos a receber relativos aos' )
	AAdd( aSay, 'mesmos c๓digos de fluxo de voucher corporativo.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir ou em Imprimir para extrair os dados.' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 06, .T., { || nOpcao := 1, lImp := .T., FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1                                   
		AAdd( aPBox,{ 1, 'Data emissใo de'     , Ctod(Space(8)), '99/99/99', ''                    , ''   , '', 50, .T. } )
		AAdd( aPBox,{ 1, 'Data emissใo at้'    , Ctod(Space(8)), '99/99/99', ''                    , ''   , '', 50, .T. } )
		
		AAdd( aPBox,{ 1, 'Cliente de'          , Space(6)      , '@!'      , ''                    , 'SA1', '', 50, .F. } )
		AAdd( aPBox,{ 1, 'Cliente at้'         , Space(6)      , '@!'      , ''                    , 'SA1', '', 50, .T. } )
	
		AAdd( aPBox,{ 1, 'C๓digo de fluxo de'  , Space(7)      , '@!'      , ''                    , ''   , '', 50, .F. } )
		AAdd( aPBox,{ 1, 'C๓digo de fluxo at้' , Space(7)      , '@!'      , ''                    , ''   , '', 50, .T. } )
		
		If lImp
			FWMsgRun(, {|| A200Rel() },,'Extraindo dados, aguarde...')
		Else
			If ParamBox(aPBox,'Parโmetros de busca', @aRet,,,,,,,,.T.,.T.)		
				FWMsgRun(, {|| A200Show( aRet ) },,'Buscando, aguarde...')
			Endif
		Endif
	Endif
Return
                                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA200Show  บAutor  ณOpvs                บ Data ณ  08/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina acionada para mostrar tela de parโmetros para pro-   บฑฑ
ฑฑบ          ณcessamento da rotina                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A200Show( aRet )
	Local cTRB := ''
	Local cSQL := ''
	Local cCount := ''
	
	Local oDlg
	Local oBrw
	Local oTela
	Local oRoda 
	Local oBrowse
	Local oColumn
	Local oColumnMrk
	Local oBtnOk
	Local oBtnSair
	Local oBtnRel 
	
	Local cCpo := ''
	Local cTexto := ''
	Local cIdBrowse := ''
	Local cIdRodape := ''
	Local cQtdReg := " tํtulo(s) selecionado(s)"	
	
	Local lMrk := .F.
	Local oMrk := NIL
	
	Local nI := 0
	Local nPos := 0
	Local nCount := 0
	Local nQtdReg := 0
	Local nTamTexto := 0
	
	Local aCpos := {}
	Local aSeek := {}
	Local aIndex := {}
	Local aSX3E1 := {}
	lOCAL aColumn := {}
	Local aTitulos := {}
	
	Local bMarca := {|| }
	Local bDataMark := {|| }
	Local bDataColumn := {|| }
	
	DEFINE FONT oFont NAME "Arial" SIZE 0,-12 //BOLD

	//-----------------------------
	// Estrutura do vetor
	//-----------------------------
	// [1] Nome do campo
	// [2] Habilita pesquisa (seek)
	//-----------------------------
	AAdd(aCpos,{"E1_CLIENTE",.T.})
	AAdd(aCpos,{"E1_LOJA"   ,.F.})
	AAdd(aCpos,{"E1_NOMCLI" ,.F.})
	AAdd(aCpos,{"E1_PREFIXO",.T.})
	AAdd(aCpos,{"E1_NUM"    ,.T.})
	AAdd(aCpos,{"E1_PARCELA",.F.})
	AAdd(aCpos,{"E1_TIPO"   ,.T.})
	AAdd(aCpos,{"E1_EMISSAO",.F.})
	AAdd(aCpos,{"E1_VENCTO" ,.T.})
	AAdd(aCpos,{"E1_VENCREA",.T.})
	AAdd(aCpos,{"E1_XNUMVOU",.F.})
	AAdd(aCpos,{"E1_XFLUVOU",.T.})
	AAdd(aCpos,{"E1_VALOR"  ,.F.})
	AAdd(aCpos,{"ZF_CODCLI" ,.T.})
	AAdd(aCpos,{"ZF_LOJCLI" ,.F.})
	
	//------------------------------
	// Estrutura do vetor aSX3E1
	//------------------------------
	// [1] Nome do campo
	// [2] Tํtulo do campo
	// [3] Tipo do campo
	// [4] Tamanho do campo
	// [5] Tamanho decimal do campo
	// [6] Picture do campo
	//------------------------------
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For nI := 1 To Len(aCpos)
		SX3->(dbSeek(aCpos[nI,1]))
		
		AAdd( aSX3E1 ,{aCpos[nI,1],RetTitle(aCpos[nI,1]),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,RTrim(SX3->X3_PICTURE)})
		
		// Somente ํndices por estas colunas.
		If aCpos[nI,2]
			//---------------------------------------------------------------------------------
			// Estrutura do vetor aSeek para efetura busca de dados nas colunas do Browse/Query
			//---------------------------------------------------------------------------------
			// [n,1] Tํtulo da pesquisa
			//	[n,2,n,1] LookUp
			//	[n,2,n,2] Tipo de dados
			//	[n,2,n,3] Tamanho
			//	[n,2,n,4] Decimal
			//	[n,2,n,5] Tํtulo do campo
			//	[n,2,n,6] Mแscara
			//	[n,3] Ordem da pesquisa
			//	[n,4] Exibe na pesquisa
			AAdd( aSeek  ,{RetTitle(aCpos[nI,1]),{{"",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_TITULO,SX3->X3_PICTURE,}},1})
			//--------------------------------------------------------
			// Estrutura do vetor aIndex de ํndice temporแrio da query
			//--------------------------------------------------------
			// [1] Nome do campo
			//--------------------------------------------------------
			AAdd( aIndex ,aCpos[nI,1])
		Endif
		
		cCpo += aCpos[nI,1]+", "
	Next nI
	cCpo := SubStr(cCpo,1,Len(cCpo)-2)
	
	cSQL := "SELECT "+cCpo+", SE1.R_E_C_N_O_ AS E1_RECSE1 " + CRLF
	cSQL += "FROM   "+RetSqlName("SE1")+" SE1 "
	cSQL += "       INNER JOIN "+RetSqlName("SZF")+" SZF "
	cSQL += "               ON E1_XFLUVOU = ZF_CODFLU " + CRLF
	cSQL += " 				  AND E1_XNUMVOU = ZF_COD   " + CRLF
	cSQL += "WHERE  E1_FILIAL = "+ValToSql(xFilial("SE1"))+" " + CRLF
	cSQL += "       AND E1_EMISSAO BETWEEN "+ValToSql(aRet[1])+" AND "+ValToSql(aRet[2])+" " + CRLF
	cSQL += "       AND E1_SALDO > 0 " + CRLF
	cSQL += "       AND E1_PORTADO = ' ' " + CRLF
	cSQL += "       AND E1_BAIXA = ' ' " + CRLF
	cSQL += "       AND E1_NUMBOR = ' ' " + CRLF
	cSQL += "       AND E1_XNUMVOU > ' ' " + CRLF
	cSQL += "       AND E1_XFLUVOU BETWEEN "+ValToSql(aRet[5])+" AND "+ValToSql(aRet[6])+" " + CRLF
	cSQL += "       AND SE1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND ZF_CODCLI BETWEEN "+ValToSql(aRet[3])+" AND "+ValToSql(aRet[4])+" " + CRLF
	cSQL += "       AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "ORDER  BY ZF_CODCLI, ZF_LOJCLI " + CRLF
	
	cSQL := ChangeQuery( cSQL )	
	cTRB := GetNextAlias()
	
	DEFINE MSDIALOG oDlg FROM 0,0 To 400,900 TITLE "Selecione os tํtulos " PIXEL OF oMainWnd STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oTela := FWFormContainer():New( oDlg )  
		cIdBrowse := oTela:CreateHorizontalBox( 85 )
		cIdRodape := oTela:CreateHorizontalBox( 15 )
		oTela:Activate( oDlg, .F. )
		oBrw := oTela:GeTPanel( cIdBrowse )
		oRoda := oTela:GeTPanel( cIdRodape )
		
		//-------------------------------------------------------------------------------
		// A็ใo de quando houver o clique para marcar ou desmarcar um registro no browse.
		//-------------------------------------------------------------------------------
		cTexto := LTrim( Str( nQtdReg ) ) + cQtdReg
		nTamTexto := GetTextWidth(0,cTexto)
		
		bMarca := {|oBrowse| ;
			Iif( ( nPos := AScan( aTitulos, {|x| x[1]==(cTRB)->( E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA )} ) ) == 0,;
				AAdd( aTitulos,{(cTRB)->( E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA ),;
				                (cTRB)->E1_VALOR,;
				                (cTRB)->E1_XNUMVOU,;
				                (cTRB)->E1_XFLUVOU,;
				                (cTRB)->E1_PREFIXO,;
				                (cTRB)->E1_NUM,;
				                (cTRB)->E1_PARCELA,;
				                (cTRB)->E1_TIPO,;
				                (cTRB)->(ZF_CODCLI+ZF_LOJCLI),;
				                (cTRB)->E1_RECSE1  } ),;
				(ADel( aTitulos, nPos), aSize( aTitulos, Len( aTitulos ) - 1 ) ) ),  nQtdReg:=Len(aTitulos), cTexto := LTrim( Str( nQtdReg ) ) + cQtdReg, oSay:Refresh() }
		
		//------------------------------
		// Estanciar a classe do browse.
		//------------------------------
		oBrowse := FWBrowse():New()
		oBrowse:SetOwner(oBrw)
		oBrowse:SetDataQuery(.T.)
		oBrowse:SetAlias(cTRB)
		oBrowse:SetQueryIndex(aIndex)
		oBrowse:SetQuery(cSQL)
		oBrowse:SetSeek(,aSeek)
		oBrowse:SetFieldFilter(aSX3E1)
		oBrowse:SetUseFilter()
		//oBrowse:DisableConfig()
				
		//-----------------------
		// Definir a coluna mark.
		//-----------------------
		bDataMark := { || Iif(AScan(aTitulos,{|x| x[1]==(cTRB)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)})==0,'LBNO','LBOK') }
		oColumnMrk := oBrowse:AddMarkColumns(bDataMark,bMarca)

		//------------------------------------
		// Montar as demais colunas do browse.
		//------------------------------------
		For nI := 1 To Len(aSX3E1)
			If aSX3E1[nI,3] == "D"
				bDataColumn := &('{ || SubStr(&("'+aSX3E1[nI,1]+'"),7,2)+"/"+SubStr(&("'+aSX3E1[nI,1]+'"),5,2)+"/"+SubStr(&("'+aSX3E1[nI,1]+'"),1,4) }')
			Else
				bDataColumn := &( '{ ||' + aSX3E1[nI,1] + ' }' )
			Endif
			
			oColumn := FWBrwColumn():New()
			oColumn:SetData(bDataColumn)
			oColumn:SetTitle(aSX3E1[nI,2])
			oColumn:SetType(aSX3E1[nI,3])
			oColumn:SetSize(aSX3E1[nI,4])
			If aSX3E1[nI,3] == "N"
				oColumn:SetAlign(2) // Alinhado a direita.
				oColumn:SetDecimal(aSX3E1[nI,5])
				oColumn:SetPicture(aSX3E1[nI,6])
			Elseif aSX3E1[nI,3] == "D"
				oColumn:SetAlign(0) //Alinhado ao centro.
			Else
				oColumn:SetAlign(1) //Alinhado a esquerda.
			Endif
			AAdd(aColumn,oColumn)
		Next nI
		oBrowse:SetColumns(aColumn)
		oBrowse:Activate()
		
		@ oRoda:nTop+5,oRoda:nLeft+03 BUTTON oBtnOk PROMPT 'Processar' SIZE 35,12 OF oRoda PIXEL ACTION ;
			(Iif(Len(aTitulos)>0,;
				Iif(MsgYesNo('Confirma o processamento para o(s) '+LTrim(Str(Len(aTitulos)))+' registro(s) selecionado(s)?',cCadastro),;
				(Processa({|| A200Proc(aTitulos,aRet)},cCadastro,'Processando, aguarde...',.F.),(oDlg:End())),;
				NIL),;
			MsgInfo('Nใo hแ titulos selecionados, verifique.',cCadastro)))
		
		@ oRoda:nTop+5,oRoda:nLeft+43 BUTTON oBtnRel PROMPT 'Relat๓rio' SIZE 35,12 OF oRoda PIXEL ACTION ;
			(A200Rel()) 
		
		@ oRoda:nTop+5,oRoda:nLeft+83 BUTTON oBtnSair PROMPT '&Sair' SIZE 35,12 OF oRoda PIXEL ACTION ;
			(Iif(MsgYesNo('Deseja realmente sair da rotina Voucher Corporativo?',cCadastro),;
			(oDlg:End()),;
			NIL))  
		
		@ oRoda:nTop+7,oRoda:nLeft+123 CHECKBOX oMrk VAR lMrk PROMPT "Selecionar todos tํtulos?" SIZE 70,7 PIXEL OF oRoda ;
		ON CLICK( A200MrkAll(lMrk,cTRB,@aTitulos), oBrowse:Refresh(), nQtdReg:=Len(aTitulos), cTexto := LTrim( Str( nQtdReg ) ) + cQtdReg, oSay:Refresh() )

		oSay := TSay():New(oRoda:nTop+4,(oRoda:nRight/2)-(nTamTexto/1.1),{|| cTexto},oRoda,,oFont,.T.,.F.,.F.,.T.,CLR_BLUE,,GetTextWidth(0,cTexto),15,.F.,.F.,.F.,.F.,.F.)
	ACTIVATE MSDIALOG oDlg CENTERED
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA200Proc   บAutor  ณOpvs                บ Data ณ  08/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de processamento de informa็๕es de acordo os parโme-บฑฑ
ฑฑบ          ณtros                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A200Proc(aTitulos,aDadFil)
	Local nI 		:= 0
	Local aTitLiq	:= {}
	Local cCli		:= ""
	Local cLoja	:= ""
	Local cFluxAnt:= ""
	Local cLiq		:= ""
	Local cTexto	:= ""
	Local aPar		:= {}
	Local aRetPar	:= {}
	Local bValid	:= {|| .T.}
	Local aLiq		:= {}	
	Local aCombo	:= StrToKarr( U_CSC5XBOX(), ';' )

	Asort( aTitulos,,, { |x,y| x[4]<y[4] } )
	
	AAdd( aPar,{ 1, 'Natureza'			, Space(GetSx3Cache( "E1_NATUREZ", "X3_TAMANHO" ))	, '@!'	, ''	, 'SED', '', 50, .T. } )
	AAdd( aPar,{ 1, 'Condi็ใo'			, Space(3)	                                        , '@!'	, 'ExistCpo("SE4",M->MV_PAR02) .and. SE4->E4_TIPO != "9"'	, 'SE4', '', 20, .T. } )
	AAdd( aPar,{ 1, 'Tipo'	   			, Space(GetSx3Cache( "E1_TIPO" 	 , "X3_TAMANHO" ))	, '@!'	, ''	, '05', '', 20, .T. } )
	AAdd( aPar,{ 1, 'Prefixo'			, Space(GetSx3Cache( "E1_PREFIXO", "X3_TAMANHO" ))	, '@!'	, ''	, '', '', 20, .T. } )
	AAdd( aPar,{ 1, 'Ocorr๊ncia CNAB'	, '01'												, '@!'	, ''	, '', '', 20, .T. } )
	AAdd( aPar,{ 2, 'Origem P.V.'		, 1, aCombo,100,"",.T.})
	
	//Parametros para gera็ใo da liquida็ใo
	If !ParamBox( aPar, 'Parโmetros para Liquida็ใo', @aRetPar, bValid,,,,,,, .F., .F. )		
		Return
	Endif
	
	ProcRegua(Len(aTitulos))
	
	aTitLiq	:= {}
	cCli		:= ""
	cLoja		:= ""
	
	For nI := 1 To Len( aTitulos )
		IncProc()
		
		If Len(aTitLiq) > 0 .and. !Empty(cCli+cLoja) .and. cCli+cLoja <> aTitulos[nI,9]
			aLiq := A200Liq(aTitLiq,cCli,cLoja,aRetPar,cFluxAnt,aDadFil)
		
			If aLiq[1]
				cTexto += "Gerada liquida็ใo "+aLiq[2]+" para cliente "+cCli+"/"+cLoja+chr(13)+chr(10)
			Else	
				cTexto += "Encontrada inconsist๊ncia "+chr(13)+chr(10)+aLiq[2]+chr(13)+chr(10)
			EndIf
			
			aTitLiq	:= {}
			cCli		:= ""
			cLoja		:= ""
		EndIf
		//             chave          valor           prefixo         num             parcela         tipo           recno
		aadd(aTitLiq, {aTitulos[nI,1],aTitulos[nI,2], aTitulos[nI,5], aTitulos[nI,6], aTitulos[nI,7], aTitulos[nI,8],aTitulos[nI,10] })
		cCli		:= Left(aTitulos[nI,9],6)
		cLoja		:= Right(aTitulos[nI,9],2)
	Next nI
	
	If Len(aTitLiq) > 0 .and. !Empty(cCli+cLoja)
			
		aLiq := A200Liq(aTitLiq,cCli,cLoja,aRetPar,cFluxAnt,aDadFil)
		
		If aLiq[1]
			cTexto += "Gerada liquida็ใo "+aLiq[2]+" para cliente "+cCli+"/"+cLoja+chr(13)+chr(10)
		Else	
			cTexto += "Encontrada inconsist๊ncia "+chr(13)+chr(10)+aLiq[2]+chr(13)+chr(10)
		EndIf
		
	EndIf
	
	If !Empty(cTexto)
		Aviso("Liquida็ใo automatica",cTexto,{"ok"},3)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA200Liq   บAutor  ณOpvs                บ Data ณ  08/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para execu็ใo do ExecAuto de Liquida็ใo              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A200Liq( aTitulos, cCli, cLoja, aRetPar, cFlux, aDadFil )
	Local cNatur	:= ""
	Local cCond	   	:= ""
	Local cTipo	   	:= ""
	Local cPrefix  	:= ""
	Local aParc	   	:= ""
	Local cMsg		:= ""
	Local cLiq		:= GetMv("MV_NUMLIQ")
	Local cNum		:= "LQ"+Alltrim(Soma1(cLiq))
	Local cOcorren	:= ""
	Local cOrigPV	:= ""
	
	Local nI := 0
	Local nValor := 0
	
	Local aRet := {}
	Local aSE1 := {}
	Local aParam := {}
	Local aLiquidacao := {}
	
	cNatur		:= aRetPar[ 1 ]
	cCond		:= aRetPar[ 2 ]
	cTipo		:= aRetPar[ 3 ]
	cPrefix		:= aRetPar[ 4 ]
	cOcorren	:= aRetPar[ 5 ]
	cOrigPV		:= cValToChar( aRetPar[ 6 ] )
	
	aADD( aE1_COMPLEMENTO, cOcorren )
	aADD( aE1_COMPLEMENTO, cOrigPV  )

	For nI := 1 To Len( aTitulos ) 
		AAdd( aSE1, aTitulos[ nI, 7 ] )
		nValor += aTitulos[ nI, 2 ] 
	Next nI
	
	aParc := Condicao( nValor, cCond, , dDataBase )
	
	// aLiquida  - Dados da liquida็ใo.
	//LQ_PREFIXO  1
	//LQ_BANCO    2
	//LQ_AGENCIA  3
	//LQ_CONTA    4
	//LQ_NROCHQ   5
	//LQ_DATABOA  6
	//LQ_VALOR    7
	//LQ_TIPO     8
	//LQ_NATUREZA 9
	//LQ_MOEDA   10
	//LQ_DATALIQ 11
	//LQ_CLIENTE 12
	//LQ_LOJA    13
	//LQ_NUMLIQ  14 - NรO PASSAR ESTE ELEMENTO.
	For nI := 1 To Len( aParc )
		AAdd( aLiquidacao, { cPrefix, '001', '001', '001', cNum, aParc[ nI, 1 ], aParc[ nI, 2 ], cTipo, cNatur, 1, dDataBase, cCli, cLoja } )
	Next nI
	
	//[1]-Contabiliza on-line
	//[2]-Aglutina lan็amentos
	//[3]-Digita lan็amentos contแbeis
	//[4]-Juros para comissใo
	//[5]-Desconto para comissใo
	//[6]-Calcula comissใo s/ NCC
	aParam := { .F., .F., .F., .F., .F., .F. }	
	aRet := U_CSFA530( 2, aSE1, /*aBaixa*/, /*aNCC_RA*/, aLiquidacao, aParam, /*bBlock*/, /*aEstorno*/, /*aNFDDados*/, /*aNewSE1*/ )
	
	If aRet[ 1 ] 
		cLiq := GetMv("MV_NUMLIQ")
		aRet := { .T., cLiq }
	Else
		aRet := { .F., '' }
	Endif
Return( aRet )	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA200MrkAll บAutor  ณOpvs                บ Data ณ  08/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para marca็ใo de todos os tํtulos filtrados         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A200MrkAll(lMrk,cTRB,aTitulos)
	Local nRecNo := 0
	nRecNo := (cTRB)->(RecNo())
	If lMrk
		(cTRB)->(dbGoTop())
	
		MsgRun(	'Selecionado tํtulos, aguarde...',;
				'',;
				{|| iif (( nPos := AScan( aTitulos, {|x| x[1]==(cTRB)->( E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA )} ) ) == 0,;
					 (cTRB)->( dbEval( {|| AAdd(aTitulos,{(cTRB)->( E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA ), ;
					 (cTRB)->E1_VALOR, (cTRB)->E1_XNUMVOU, (cTRB)->E1_XFLUVOU, (cTRB)->E1_PREFIXO,(cTRB)->E1_NUM,(cTRB)->E1_PARCELA,(cTRB)->E1_TIPO,;
					 (cTRB)->(ZF_CODCLI+ZF_LOJCLI),(cTRB)->E1_RECSE1   } ) } ) ),;
					 nil)} )
		
	Else
		aTitulos := {}
	Endif
	(cTRB)->(dbGoTo(nRecNo))
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA200Rel บAutor  ณOpvs                บ Data ณ  14/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para emissao de Relaorio de Liquida็ใo de Titulos   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A200Rel()
	Local aRet		:= {}
	Local bValid	:= {|| .T. }
	Local aDados := {}
	Local aCab := { "Cod. Cliente",;
					"Nome Cliente",;
					"CPF/CNPJ",;
					"Tipo Cliente",;
					"Cod. Tํtulo",;
					"Emissใo",;
					"Vencimento",;
					"Baixa",;
					"Voucher",;
					"Fluxo",;
					"Valor",;
					"Pedido Site",;
					"Pedido GAR",;
					"Produto GAR",;
					"Cod. Cliente Pagto.",;
					"Nome do cliente Pagto."}

	Local cPedGAR	:= ''
	
	AAdd( aPBox,{ 1, 'Movimentado em - bco.p/todos', Ctod(Space(8)), '99/99/99', '', '', '', 50, .F. } )
	
	//Parโmetros inicial para processamento da rotina
	If .NOT. ParamBox( aPBox, 'Parโmetros do Relat๓rio', @aRet, bValid,,,,,,, .T., .T. )		
		Return
	Endif
	
	cSQL := "SELECT E1_CLIENTE,"+ CRLF 
	cSQL += "       A1NOME.A1_NOME AS A1NOME,"+ CRLF
	cSQL += "       A1NOME.A1_CGC AS A1CGC,"+ CRLF 
	cSQL += "       DECODE(A1NOME.A1_PESSOA,'J','JURIDICO','FISICO') A1PESSOA,"+ CRLF 
	cSQL += "       E1_NUM,"+ CRLF 
	cSQL += "       E1_EMISSAO,"+ CRLF 
	cSQL += "       E1_VENCTO,"+ CRLF 
	cSQL += "       E1_BAIXA,"+ CRLF
	cSQL += "       E1_XNUMVOU,"+ CRLF 
	cSQL += "       E1_XFLUVOU,"+ CRLF 
	cSQL += "       E1_VALOR,"+ CRLF
	cSQL += "       E1_XNPSITE,"+ CRLF
	cSQL += "       E1_PEDGAR,"+ CRLF
	cSQL += "       E1_PEDIDO,"+ CRLF
	cSQL += "       ZF_PDESGAR,"+ CRLF
	cSQL += "       ZF_CODCLI,"+ CRLF
	cSQL += "       SA1.A1_NOME" + CRLF
	cSQL += "FROM   "+RetSqlName("SE1")+" SE1 "+ CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SZF")+" SZF "+ CRLF 
	cSQL += "               ON  E1_XFLUVOU = ZF_CODFLU "+ CRLF 
	cSQL += "              AND  E1_XNUMVOU = ZF_COD   " + CRLF
	cSQL += "              AND  SE1.D_E_L_E_T_ = ' ' " + CRLF

   cSQL += "       INNER JOIN "+RetSqlName("SA1")+" A1NOME " + CRLF
   cSQL += "               ON A1NOME.A1_FILIAL = ' ' " + CRLF
   cSQL += "              AND A1NOME.A1_COD = E1_CLIENTE " + CRLF
   cSQL += "              AND A1NOME.A1_LOJA = E1_LOJA " + CRLF
   cSQL += "              AND A1NOME.D_E_L_E_T_ = ' '	" + CRLF

   cSQL += "       INNER JOIN "+RetSqlName("SA1")+" SA1 " + CRLF
   cSQL += "               ON SA1.A1_FILIAL = ' ' " + CRLF
   cSQL += "              AND SA1.A1_COD = ZF_CODCLI " + CRLF
   cSQL += "              AND SA1.A1_LOJA = ZF_LOJCLI " + CRLF
   cSQL += "              AND SA1.D_E_L_E_T_ = ' '	" + CRLF

	cSQL += "WHERE  E1_FILIAL = "+ValToSql(xFilial("SE1"))+" " + CRLF
	cSQL += "       AND E1_EMISSAO BETWEEN "+ValToSql(aRet[1])+" AND "+ValToSql(aRet[2])+" " + CRLF
	cSQL += "       AND E1_XNUMVOU <> ' ' " + CRLF
	cSQL += "       AND E1_XFLUVOU BETWEEN "+ValToSql(aRet[5])+" AND "+ValToSql(aRet[6])+" " + CRLF
	cSQL += "       AND SE1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND ZF_CODCLI BETWEEN "+ValToSql(aRet[3])+" AND "+ValToSql(aRet[4])+" " + CRLF
	cSQL += "       AND SZF.D_E_L_E_T_ = ' ' " + CRLF
	
	If .NOT. Empty( aRet[ 7 ] )
		cSQL += "       AND E1_BAIXA = "+ValToSql( aRet[ 7 ] )+" " + CRLF
	Endif
	
	cSQL += "ORDER  BY E1_XFLUVOU, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_XNUMVOU " + CRLF

	cSQL := ChangeQuery(cSQL)
	TCQUERY cSQL NEW ALIAS "TMPSZF"
	
	DbSelectArea("TMPSZF")
	If TMPSZF->(!Eof())
		While TMPSZF->(!Eof())
			IF Empty( TMPSZF->E1_PEDGAR )
				cPedGAR := Posicione( 'SC5', 1, xFilial('SC5') + TMPSZF->E1_PEDIDO, 'C5_CHVBPAG' )
			Else
				cPedGAR := TMPSZF->E1_PEDGAR
			EndIF
			TMPSZF->( AADD(aDados,{E1_CLIENTE,A1NOME,A1CGC,A1PESSOA,E1_NUM,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_XNUMVOU,E1_XFLUVOU,E1_VALOR,E1_XNPSITE,cPedGAR,ZF_PDESGAR,ZF_CODCLI,A1_NOME}))
			TMPSZF->(DbSkip())
			cPedGAR := ''
		Enddo
	Endif    
	TMPSZF->(DbCloseArea()) 
	DlgToExcel( { { "ARRAY", "", aCab, aDados } } )
Return

//----------------------------------------------------------------
// Rotina | UPD600     | Autor | Robson Gon็alves     | 06.01.2015
//----------------------------------------------------------------
// Descr. | Rotina update para criar tabela, campos, ํndices e 
//        | gatilhos.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function UPD600()
	Local cModulo := 'FIN'
	Local bPrepar := {|| U_U600Ini() }
	Local nVersao := 1
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return
//----------------------------------------------------------------
// Rotina | U400Ini    | Autor | Robson Gon็alves     | 06.01.2015
//----------------------------------------------------------------
// Descr. | Rotina auxiliar de update para criar tabela, campos, 
//        | ํndices e gatilhos.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function U600Ini()
	aSIX := {}
	AAdd(aSIX,{'SZF','4','ZF_FILIAL+ZF_CODCLI+ZF_LOJCLI','Cliente+Loja','Cliente+Loja','Cliente+Loja','U','S','CODLOJCLI'})
Return

//-----------------------------------------------------------------------
// Rotina | A320RetFile| Autor | Robson Gon็alves     | Data | 09.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar para alimentar o endere็o do arquivo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A600E1COMP()
Return(aE1_COMPLEMENTO)