//-----------------------------------------------------------------------------------
// Rotina | CSFA470      | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina de Tracking de pagamentos - Contas a Pagar.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
#INCLUDE 'Protheus.ch'

#DEFINE  TIK   'NGCHECKOK.PNG'
#DEFINE  NOTIK 'NGCHECKNO.PNG'

#DEFINE REC_DEL 'UPDERROR17.PNG'
#DEFINE REC_OK  'IC_20_GRAVAR.GIF'

User Function CSFA470()
	Local aSay := {}
	Local aButton := {}
	Local nOpc := 0
	Local cPerg := 'CSFA470'
	Local lLoad := .T.
   
   Private cTRB := ''
   Private cCadastro := 'Tracking de Pagamentos'
   Private aCOLS := {}
   
	AAdd( aSay, 'Esta rotina tem por objetivo em rastrear os títulos a pagar do borderô de pagamentos' )
	AAdd( aSay, 'conforme parâmetros informados pelo usuário.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch()   } } )
	AAdd( aButton, { 22, .T., { || FechaBatch()              } } )

	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		If A470CanUse( cPerg )
			If Pergunte( cPerg, .T., cCadastro + ' - Parâmetros' )
				FwMsgRun(,{|| lLoad := A470Load( cPerg ) },,'Aguarde, processando os parâmnetros...')
				If lLoad
					A470Show( cPerg )
				Endif
		   Endif
		Endif
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470CanUse   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para verificar se pode ser utilizada em relação aos dicionários
//        | de dados.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470CanUse( cPerg )
	A470SXB()
	A470SX1( cPerg )
Return( .T. )

//-----------------------------------------------------------------------------------
// Rotina | A470SXB      | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para criar a consulta padrão SXB.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470SXB()
	Local nI := 0
	Local nJ := 0
	Local aCpoSXB := {}
	Local aSXB := {}
	Local cTamSXB := 0
	Local cXB_ALIAS := ''
	
	nTamSXB := Len( SXB->XB_ALIAS )
	aCpoSXB := { 'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM' }
	
	SXB->( dbSetOrder( 1 ) )

	cXB_ALIAS := 'SEATRK'
	If .NOT. SXB->( dbSeek( cXB_ALIAS ) )
		AAdd(aSXB,{cXB_ALIAS,'1','01','DB','Bordero Pagamento','Bordero Pagamento','Bordero Pagamento','SEA',''})
		AAdd(aSXB,{cXB_ALIAS,'2','01','01','Numero Bordero','Numero Bordero','Numero Bordero','',''})
		AAdd(aSXB,{cXB_ALIAS,'4','01','01','Bordero'   ,'Bordero'   ,'Bordero'   ,'EA_NUMBOR' ,''})
		AAdd(aSXB,{cXB_ALIAS,'4','01','02','DT Bordero','DT Bordero','DT Bordero','EA_DATABOR',''})
		AAdd(aSXB,{cXB_ALIAS,'5','01','','','','','SEA->EA_NUMBOR',''})
		AAdd(aSXB,{cXB_ALIAS,'6','01','','','','','SEA->EA_CART=="P".AND.UniqueKey( {"EA_FILIAL","EA_NUMBOR"})',''})
	Endif
	
	If Len( aSXB ) > 0
		For nI := 1 To Len( aSXB )
			If .NOT. SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470SX1      | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para criar o grupo de perguntas do parâmetro SX1.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470SX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}

	AAdd(aP,{"Data bordero de?"     ,"D", 08,0,"G",""                    ,"","","","","","",""})
	AAdd(aP,{"Data bordero ate?"    ,"D", 08,0,"G","(mv_par02>=mv_par01)","","","","","","",""})
	AAdd(aP,{"Numeros dos borderos?","C", 99,0,"R",""                    ,"SEATRK","","","","","","EA_NUMBOR"})
	AAdd(aP,{"Codigo do banco?"     ,"C",  3,0,"G",""                    ,"SA6","","","","","",""})
	AAdd(aP,{"Numero da agencia?"   ,"C",  5,0,"G",""                    ,"","","","","","",""})
	AAdd(aP,{"Conta corrente?"      ,"C", 10,0,"G",""                    ,"","","","","","",""})
	AAdd(aP,{"A partir do valor?"   ,"N", 12,2,"G","(mv_par07>=0)"       ,"","","","","","",""})
	AAdd(aP,{"Até o valor?"         ,"N", 12,2,"G","(mv_par08>=0)"       ,"","","","","","",""})

	AAdd(aHelp,{"Informe a partir de qual data de borderô","quer processar."})
	AAdd(aHelp,{"Informe até qual data de borderô quer"   ,"processar."})
	AAdd(aHelp,{"Informe os números dos borderô, ou deixe"," em branco ou digite (*) asterisco para todos os borderôs."})
	AAdd(aHelp,{"Informe o código do banco - não obrigatório.",""})
	AAdd(aHelp,{"Informe o número da agência - não obrigatório",""})
	AAdd(aHelp,{"Informe o número da conta corrente - não obrigatório",""})
	AAdd(aHelp,{"Informe a partir de qual valor quer     ","processar."})
	AAdd(aHelp,{"Informe até qual valor quer processar.",""})
 
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		aP[i,13],;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
		
		If i==7 .OR. i==8
			If Empty( SX1->X1_PICTURE )
				SX1->( RecLock( 'SX1', .F. ) )
				SX1->X1_PICTURE := '@E 999,999,999.99'
				SX1->( MsUnLock() )
			Endif
		Endif
	Next i
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Load     | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para carregar/buscar os dados conforme os parâmetros informados
//        | pelo usuário.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Load( cPerg, oGride )
	Local cMvPar03 := ''
	Local cSQL := ''
	Local nIt := 0
	
	If .NOT. Empty( cTRB )
		cTRB := ''
		aCOLS := {}
	Endif
	
	If Empty( MV_PAR03 ) .OR. RTrim( MV_PAR03 ) == '*'
		MV_PAR03 := '      -zzzzzz'
	Endif
			
	// se o parâmetro for informado da seguinte maneira: 000005;000010;000030 
	// o retorno será: (EA_NUMBOR IN('000005','000010','000030'))
	// se o parâmetro for informado da seguinte maneira: 000010-000020 
	// o retorno é: (EA_NUMBOR BETWEEN '000020' AND '000030')
	// se o parâmetro for informado da seguinte meneira: 000005;000010;000030;000015-000020 
	// o retorno é: (EA_NUMBOR IN('000005','000010','000030') OR (EA_NUMBOR BETWEEN '000015' AND '000030') )
	MakeSqlExpr( cPerg )
	cMvPar03 := MV_PAR03 
	
	cSQL := "SELECT EA_NUMBOR, "
	cSQL += "       E2_VALOR, "
	cSQL += "       EA_PREFIXO, "
	cSQL += "       EA_NUM, "
	cSQL += "       EA_PARCELA, "
	cSQL += "       EA_TIPO, "
	cSQL += "       E2_EMISSAO, "
	cSQL += "       E2_VENCTO, "
	cSQL += "       E2_VENCREA, "
	cSQL += "       A2_NOME, "
	cSQL += "       EA_FORNECE, "
	cSQL += "       EA_LOJA, "
	cSQL += "       E2_FILORIG "
	cSQL += "FROM   "+RetSqlName("SEA")+" SEA "
	cSQL += "       INNER JOIN "+RetSqlName("SE2")+" SE2 "
	cSQL += "               ON E2_FILIAL = "+ValToSql(xFilial("SE2"))+" "
	cSQL += "              AND E2_PREFIXO = EA_PREFIXO "
	cSQL += "              AND E2_NUM = EA_NUM "
	cSQL += "              AND E2_PARCELA = EA_PARCELA "
	cSQL += "              AND E2_TIPO = EA_TIPO "
	cSQL += "              AND E2_FORNECE = EA_FORNECE "
	cSQL += "              AND E2_LOJA = EA_LOJA "
	cSQL += "              AND E2_VALOR BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+" "
	cSQL += "              AND SE2.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = "+ValToSql(xFilial("SA2"))+" "
	cSQL += "              AND A2_COD = E2_FORNECE "
	cSQL += "              AND A2_LOJA = E2_LOJA "
	cSQL += "              AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  EA_FILIAL = "+ValToSql(xFilial("SEA"))+" "
	cSQL += "       AND EA_DATABOR BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "       AND " + cMvPar03
	If .NOT. Empty( MV_PAR04 )
		cSQL += "       AND EA_PORTADO = "+ValToSql(MV_PAR04)+" "
	Endif
	If .NOT. Empty( MV_PAR05 ) .AND. .NOT. Empty( MV_PAR06 )
		cSQL += "       AND EA_AGEDEP = "+ValToSql(MV_PAR05)+" "
		cSQL += "       AND EA_NUMCON = "+ValToSql(MV_PAR06)+" "
	Endif
	cSQL += "       AND EA_CART = 'P' "
	cSQL += "       AND SEA.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY EA_NUMBOR, "
	cSQL += "          E2_PREFIXO, "
	cSQL += "          E2_NUM, "
	cSQL += "          E2_PARCELA "	
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )	
	
	If (cTRB)->( .NOT. BOF() .AND. .NOT. EOF() )
		While .NOT. (cTRB)->( EOF() )
			(cTRB)->(AAdd(aCOLS,{NOTIK,StrZero(++nIt,4),EA_NUMBOR,E2_VALOR,EA_PREFIXO,EA_NUM,EA_PARCELA,EA_TIPO,E2_EMISSAO,E2_VENCTO,E2_VENCREA,RTrim(A2_NOME),EA_FORNECE,EA_LOJA,E2_FILORIG,.F.}))
			(cTRB)->( dbSkip() )
		End
		(cTRB)->(dbCloseArea())
		If oGride <> NIL
			oGride:SetArray( aCOLS, .T. )
			oGride:nMax := Len( aCOLS )
		Endif
	Else
		MsgInfo('Não foi possível encontrar informações com os parâmetros informados.', cCadastro)
	Endif
Return(Len(aCOLS)>0)

//-----------------------------------------------------------------------------------
// Rotina | A470Show     | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para apresentar os dados encontrados conforme os parâmetros
//        | informados pelo usuário.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Show( cPerg )
	Local oDlg 
	Local oPnl1, oPnl2
	Local oGride
	Local oPross
	Local oSair
	Local oMenu
	Local oThb1, oThb2, oThb3
	
	Local nI := 0
	
	Local cMsg1 := 'Prosseguir com processamento dos parâmetros?'
	Local cMsg2 := '- Refazer parâmetros'
	Local cMsg3 := 'Aguarde, processando os parâmnetros...'
	Local bPar  := {|| Iif(MsgYesNo(cMsg1,cCadastro),Iif(Pergunte(cPerg,.T.,cCadastro+cMsg2),(FwMsgRun(,{|| A470Load(cPerg,@oGride)},,cMsg3)),NIL),NIL)}
	Local bSair := {|| Iif(MsgYesNo('Deseja realmente sair?',cCadastro),(oDlg:End()),NIL) }
	Local bCapa := {|| MsAguarde( {|| A470Copy( oGride ) }, cCadastro, 'Início do processo, aguarde...', .F. ) }
	
	Local aC := {}
	Local aCpo := {'EA_NUMBOR','E2_VALOR','EA_PREFIXO','EA_NUM','EA_PARCELA','EA_TIPO','E2_EMISSAO','E2_VENCTO','E2_VENCREA','A2_NOME','EA_FORNECE','EA_LOJA','E2_FILORIG'}
	Local aHeader := {}
	
	Private nColor := ''
	Private lAzul := .T.
	Private nLenCOLS := 0
	Private cBordero := ''
	Private nAzul := RGB(192,217,217)
	Private nVerde := RGB(155,205,155)
	Private c470Filial := ''
	
	AAdd( aHeader, { CRLF+'','GD_MARK', '@BMP', 1, 0, '', '', '' , '', ''  } )
	AAdd( aHeader, { 'Item' ,'GD_ITEM', '@!'  , 4, 0, '', '', 'C', '', 'V' } )

	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpo )
		SX3->( dbSeek( aCpo[ nI ] ) )
		SX3->( AAdd( aHeader, { X3_TITULO, RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
	Next nI

	aC := FWGetDialogSize( oMainWnd )
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
		oDlg:lEscClose := .F.

		oPnl1:= TPanel():New(2,2,,oDlg,,,,,,60,26)
		oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnl2:= TPanel():New(2,2,,oPnl1,,,,,RGB(100,100,100),1,13)
		oPnl2:Align := CONTROL_ALIGN_BOTTOM

		oGride := MsNewGetDados():New(2,2,1000,1000,0,,,,,,Len(aCOLS),,,,oPnl1,aHeader,aCOLS)
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		oGride:oBrowse:bRClicked := { |oObj,oX,oY| A470Verify(@oMenu,oGride), oMenu:Activate(oX+2,oY+20,oGride:oBrowse)}
		//oGride:oBrowse:SetBlkBackColor({|| A470Cor( oGride ) })
		//oGride:oBrowse:SetBlkColor({|| CLR_BLACK })
		
		oBar := TBar():New( oPnl2, 10, 9, .T.,'BOTTOM')
		oThb1 := THButton():New(1,1, '&Sair'                  , oBar,  bSair , 25, 9 )
		oThb2 := THButton():New(1,1, '&Refazer parâmetros'    , oBar,  bPar  , 60, 9 )
		oThb3 := THButton():New(1,1, '&Copiar capa de despesa', oBar,  bCapa , 65, 9 )
				
		oThb1:Align := CONTROL_ALIGN_RIGHT
		oThb2:Align := CONTROL_ALIGN_RIGHT
		oThb3:Align := CONTROL_ALIGN_RIGHT		
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Verify   | Autor | Robson Gonçalves               | Data | 13/01/2015 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para verificar se existem rastreios a ser feito.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Verify( oMenu, oGride )
	Local nAt := oGride:nAt
	Local nEA_PREFIXO := GdFieldPos('EA_PREFIXO',oGride:aHeader)
	Local nEA_NUM     := GdFieldPos('EA_NUM'    ,oGride:aHeader)
	Local nEA_PARCELA := GdFieldPos('EA_PARCELA',oGride:aHeader)
	Local nEA_TIPO    := GdFieldPos('EA_TIPO'   ,oGride:aHeader)
	Local nEA_FORNECE := GdFieldPos('EA_FORNECE',oGride:aHeader)
	Local nEA_LOJA    := GdFieldPos('EA_LOJA'   ,oGride:aHeader)
	Local nE2_FILORIG := GdFieldPos('E2_FILORIG',oGride:aHeader)
	
	Local aD1_PEDIDO := {}
	Local aC7_CONTRA := {}
	Local aCtr := {}
	
	Local cKeySE2 := ''
	Local cKeySF1 := ''
	Local cKeySD1 := ''
	Local cTRB := ''
	Local cSQL := ''
	Local cF1_SERIE := ''
	Local cD1_PEDIDO := ''
	Local cC7_FILIAL := ''
	
	Private lSE2 := .F.
	Private lSF1 := .F.
	Private lSC7 := .F.
	Private lCN9 := .F.
	Private lSE5 := .F.
	Private lSCR := .F.
	Private lCND := .F.
	Private lSE2_AC9 := .F.
	Private lSF1_AC9 := .F.
	Private lSC7_AC9 := .F.
	Private lCN9_AC9 := .F.
	
	cKeySE2 := oGride:aCOLS[nAt,nEA_PREFIXO]+oGride:aCOLS[nAt,nEA_NUM]+oGride:aCOLS[nAt,nEA_PARCELA]+oGride:aCOLS[nAt,nEA_TIPO]+oGride:aCOLS[nAt,nEA_FORNECE]+oGride:aCOLS[nAt,nEA_LOJA]
	cKeySF1 := oGride:aCOLS[nAt,nEA_FORNECE]+oGride:aCOLS[nAt,nEA_LOJA]+oGride:aCOLS[nAt,nEA_NUM]
	
	// Verificar se a filial acessa é diferente da filial de origem do registro.
	If oGride:aCOLS[ nAt, nE2_FILORIG ] <> cFilAnt
		c470Filial := oGride:aCOLS[ nAt, nE2_FILORIG ]
	Else
		c470Filial := cFilAnt
	Endif
	
	// Tem registro de título a pagar?
   SE2->( dbSetOrder( 1 ) )
   If SE2->( dbSeek( xFilial( 'SE2' ) + cKeySE2 ) )
   	lSE2 := .T.
   Endif
   
   // Tem registro no banco de conhecimento do título a pagar?
   AC9->( dbSetOrder( 2 ) )
   If AC9->( dbSeek( xFilial( 'AC9' ) + 'SE2' + xFilial( 'SE2' ) + cKeySE2 ) )
   	lSE2_AC9 := .T.
   Endif
   
   // Localizar o documento fiscal.
	SF1->( dbSetOrder( 2 ) )
	If SF1->( dbSeek( Iif( c470Filial == cFilAnt, xFilial( 'SF1' ), c470Filial ) + cKeySF1 ) )
		cF1_SERIE := SF1->F1_SERIE
		lSF1 := .T.
	Endif
   
   // Tem registro no banco de conhecimento da nota fiscal?
   AC9->( dbSetOrder( 2 ) )
   If AC9->( dbSeek( xFilial( 'AC9' ) + 'SF1' + SF1->F1_FILIAL + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
   	lSF1_AC9 := .T.
   Endif
	
	cKeySD1 := oGride:aCOLS[nAt,nEA_NUM]+cF1_SERIE+oGride:aCOLS[nAt,nEA_FORNECE]+oGride:aCOLS[nAt,nEA_LOJA]
	
	SD1->( dbSetOrder( 1 ) )
  			
  	If SD1->( dbSeek( SF1->F1_FILIAL + cKeySD1 ) )
		While .NOT. SD1->(EOF()) .AND. SD1->D1_FILIAL == SF1->F1_FILIAL  .AND. ;
			SD1->D1_DOC     == oGride:aCOLS[nAt,nEA_NUM]                   .AND. ;
			SD1->D1_SERIE   == cF1_SERIE                                   .AND. ;
			SD1->D1_FORNECE == oGride:aCOLS[nAt,nEA_FORNECE]               .AND. ;
			SD1->D1_LOJA    == oGride:aCOLS[nAt,nEA_LOJA]
			
			If cD1_PEDIDO <> SD1->D1_PEDIDO
				lSC7 := .T.
				cD1_PEDIDO := SD1->D1_PEDIDO
				AAdd( aD1_PEDIDO, {SD1->D1_PEDIDO,Ctod(Space(8)),;
				                   SD1->D1_FORNECE+'-'+SD1->D1_LOJA+' '+RTrim(Posicione('SA2',1,xFilial('SA2')+SD1->(D1_FORNECE+D1_LOJA),'A2_NOME'))})
			Endif
  			
  			SC7->( dbSetOrder( 14 ) )
			SC7->( dbSeek( SD1->( D1_FILIAL + D1_PEDIDO + D1_ITEMPC ) ) )
			If SC7->( Found() )
				cC7_FILIAL := SC7->C7_FILIAL
				aD1_PEDIDO[ Len( aD1_PEDIDO ), 2 ] := SC7->C7_EMISSAO
				If .NOT. Empty( SC7->C7_CONTRA )
 					If AScan( aC7_CONTRA, {|e| e[1]==SC7->C7_CONTRA } ) == 0
 						aCtr := GetAdvFVal( 'CN9', { 'CN9_DTINIC', 'CN9_DESCRI' }, SC7->C7_FILIAL + SC7->C7_CONTRA, 1 ) 
 						AAdd( aC7_CONTRA, { SC7->C7_CONTRA, aCtr[ 1 ], aCtr[ 2 ] } )
 					Endif
 				Endif
 				
   			SCR->( dbSetOrder( 1 ) )
   			If SCR->( dbSeek( cC7_FILIAL + 'PC' + SC7->C7_NUM ) )
   				lSCR := .T. 
				Endif
			Endif
			SD1->( dbSkip() )
		End  		
  	Endif
  	
   AC9->( dbSetOrder( 2 ) )
   If AC9->( dbSeek( xFilial( 'AC9' ) + 'SC7' + cC7_FILIAL + cC7_FILIAL + cD1_PEDIDO + '0001' ) )
   	lSC7_AC9 := .T.
   Endif
      
  	If Len( aC7_CONTRA ) > 0
  		lCN9 := .T.
  	Endif
  	
  	If lCN9
		CND->( dbSetOrder( 1 ) )
		lCND := CND->( dbSeek( cC7_FILIAL + aC7_CONTRA[ 1, 1 ]  ) )
  	Endif
  	
  	If lCN9
	   AC9->( dbSetOrder( 2 ) )
	   If AC9->( dbSeek( xFilial( 'AC9' ) + 'CN9' + cC7_FILIAL + aC7_CONTRA[ 1, 1 ] ) )
	   	lCN9_AC9 := .T.
	   Endif
   Endif

	cSQL := "SELECT COUNT(*) AS nCOUNT "
	cSQL += "FROM   "+RetSqlName("SE5")+" SE5 "
	cSQL += "WHERE  E5_FILIAL = "+ValToSql( xFilial( "SE5" ) )+" "
	cSQL += "       AND E5_NUMERO = "+ValToSql( oGride:aCOLS[nAt,nEA_NUM] )+" "
	cSQL += "       AND E5_PREFIXO = "+ValToSql( oGride:aCOLS[nAt,nEA_PREFIXO] )+" "
	cSQL += "       AND E5_PARCELA = "+ValToSql( oGride:aCOLS[nAt,nEA_PARCELA] )+" "
	cSQL += "       AND E5_TIPO = "+ValToSql( oGride:aCOLS[nAt,nEA_TIPO] )+" "
	cSQL += "       AND E5_CLIFOR = "+ValToSql( oGride:aCOLS[nAt,nEA_FORNECE] )+" "
	cSQL += "       AND E5_LOJA = "+ValToSql( oGride:aCOLS[nAt,nEA_LOJA] )+" "
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	If (cTRB)->nCOUNT > 0
		lSE5 := .T.
	Endif
	(cTRB)->( dbCloseArea() )
	
	A470Menu(@oMenu,oGride)
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Menu     | Autor | Robson Gonçalves               | Data | 13/01/2015 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para montar o menu de contexto e sinalizar se há registros.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Menu( oMenu, oGride )
	Local oSubMenu := NIL
	Local cTem := '*'

	MENU oMenu POPUP
		MENUITEM 'Pesquisar' ACTION GdSeek( oGride ) RESOURCE 'NG_ICO_LOCALIZAR.PNG'
		
		MENUITEM 'Título a pagar'
		MENU oSubMenu POPUP
			MENUITEM 'Visualizar o título' + Iif(lSE2,cTem,'')     ACTION A470Option( oGride, 1 ) RESOURCE 'NG_ICO_TAREFA.PNG'
			MENUITEM 'Anexos do título'    + Iif(lSE2_AC9,cTem,'') ACTION A470Option( oGride, 2 ) RESOURCE 'BMPSDOC.PNG'
		ENDMENU
		
		MENUITEM 'Documento fiscal' 
		MENU oSubMenu POPUP
			MENUITEM 'Visualizar documento' + Iif(lSF1,cTem,'')     ACTION A470Option( oGride, 3 ) RESOURCE 'NG_ICO_RETOSM.PNG'
			MENUITEM 'Anexos do documento'  + Iif(lSF1_AC9,cTem,'') ACTION A470Option( oGride, 4 ) RESOURCE 'BMPSDOC.PNG'
		ENDMENU
		
		MENUITEM 'Pedido de compra' 
		MENU oSubMenu POPUP
			MENUITEM 'Visualizar o pedido' + Iif(lSC7,cTem,'')     ACTION A470Option( oGride, 5 )   RESOURCE 'PEDIDO.PNG'
			MENUITEM 'Anexos do pedido'    + Iif(lSC7_AC9,cTem,'') ACTION A470Option( oGride, 6 )   RESOURCE 'BMPSDOC.PNG'
			MENUITEM 'Aprovação do pedido' + Iif(lSCR,cTem,'')     ACTION A470Option( oGride, 6.1 ) RESOURCE 'PEDIDO.PNG'
		ENDMENU
		
		MENUITEM 'Contrato'
		MENU oSubMenu POPUP
			MENUITEM 'Visualizar o contrato' + Iif(lCN9,cTem,'')     ACTION A470Option( oGride, 7 )   RESOURCE 'CRDIMG16.PNG'
			MENUITEM 'Anexos do contrato'    + Iif(lCN9_AC9,cTem,'') ACTION A470Option( oGride, 8 )   RESOURCE 'BMPSDOC.PNG'
			MENUITEM 'Medição do contrato'   + Iif(lCND,cTem,'')     ACTION A470Option( oGride, 7.1 ) RESOURCE 'RPMFUNC.PNG'
			MENUITEM 'Aprovação do contrato' + Iif(lCND,cTem,'')     ACTION A470Option( oGride, 7.2 ) RESOURCE 'PEDIDO.PNG'
		ENDMENU
		
		MENUITEM 'Posição financeira do título' ACTION A470Option( oGride, 9 ) RESOURCE 'POSCLI.PNG'
		MENUITEM 'Movimento(s) do título'       ACTION A470Option( oGride,10 ) RESOURCE 'CTBREPLA.PNG'
	ENDMENU
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Cor      | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para alternar a cor conforme o número de borderô.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Cor( oGride )
	local nao_sei := 0
	If nLenCOLS <= Len( oGride:aCOLS ) 
		nLenCOLS++
		If cBordero <> oGride:aCOLS[oGride:nAt,GdFieldPos('EA_NUMBOR',oGride:aHeader)]
			cBordero := oGride:aCOLS[oGride:nAt,GdFieldPos('EA_NUMBOR',oGride:aHeader)]
			If lAzul
				lAzul := .F.
				nColor := nAzul
			Else
				lAzul := .T.
				nColor := nVerde
			Endif
		Endif
	Else
		nColor := Iif(oGride:oBrowse:nClrPane==nAzul,nVerde,nAzul)
	Endif
Return( nColor )

//-----------------------------------------------------------------------------------
// Rotina | A470Option   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para executar a ação do menu de contexto conforme registro
//        | selecionado pelo usuário.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Option( oGride, nAcao )
	Local nAt := oGride:nAt
	Local nEA_PREFIXO := GdFieldPos('EA_PREFIXO',oGride:aHeader)
	Local nEA_NUM     := GdFieldPos('EA_NUM'    ,oGride:aHeader)
	Local nEA_PARCELA := GdFieldPos('EA_PARCELA',oGride:aHeader)
	Local nEA_TIPO    := GdFieldPos('EA_TIPO'   ,oGride:aHeader)
	Local nEA_FORNECE := GdFieldPos('EA_FORNECE',oGride:aHeader)
	Local nEA_LOJA    := GdFieldPos('EA_LOJA'   ,oGride:aHeader)
	Local nE2_FILORI  := GdFieldPos('E2_FILORI' ,oGride:aHeader)
	
	Local cBkp := ''
	Local cD1_PEDIDO := ''
	Local aD1_PEDIDO := {}
	Local aC7_CONTRA := {}
	Local aCtr := {}
	Local lFlag := .F.
	Local nVisual := 2     // Visualização.
	Local cTipoDoc := 'MD' // Aprovação da medição do contrato.
	Local lStatus := .F.   // Não salvar aHeader e aCOLS.
	Local cBkpFil := ''
	
	Private aRotina := {}
	Private cVldCtr := ''
	Private lVldCtr := .F.
	Private cMV_470ACES := 'MV_470ACES'
	Private cMV_470ROTA := 'MV_470ROTA'

	Private ALTERA := .F.
	
	If .NOT. GetMV( cMV_470ACES, .T. )
		CriarSX6( cMV_470ACES, 'C', 'USUARIOS COM ACESSO A TRACKING DE PAGTO (CSFA470.prw) E QUE PODEM CONSULTAR OS CONTRATOS.', '000445|000262' )
	Endif
	cMV_470ACES := GetMv( cMV_470ACES, .F. )
	
	If .NOT. GetMV( cMV_470ROTA, .T. )
		CriarSX6( cMV_470ROTA, 'C', 'QUAL ROTINA USAR PARA LIBERAR ACESSO DO USUARIO NOS CONTRATOS. PODENDO SER 1=A470VldCtr() OU 2=A470Acesso().', '2' )
	Endif
	cMV_470ROTA := GetMv( cMV_470ROTA, .F. )

	// Posicionar no título.
   SE2->( dbSetOrder( 1 ) )
   SE2->( dbSeek( xFilial('SE2')+;
					   oGride:aCOLS[nAt,nEA_PREFIXO]+;
					   oGride:aCOLS[nAt,nEA_NUM]+;
					   oGride:aCOLS[nAt,nEA_PARCELA]+;
					   oGride:aCOLS[nAt,nEA_TIPO]+;
					   oGride:aCOLS[nAt,nEA_FORNECE]+;
					   oGride:aCOLS[nAt,nEA_LOJA] ) )
   
   // Se não achar avisar o usuário.
   If .NOT. SE2->( Found() )
   	MsgAlert('Título a pagar não localizado.', cCadastro )
   	Return
   Endif
   
   aRotina := {{'','',0,1 },{'','', 0,2},{'','',0,3},{'','',0,4},{'','',0,5}}
	
   // Visualizar o título.
   If nAcao==1
   	cBkp := cCadastro
   	cCadastro := 'Consulta ao Título a Pagar'
   	AxVisual('SE2',SE2->(RecNo()),2)
   	cCadastro := cBkp 
   	lFlag := .T.
   
   // Visualizar os documentos anexados ao título.
   Elseif nAcao==2
   	MsDocument('SE2',SE2->(RecNo()),2)
   	lFlag := .T.
   	
   Elseif nAcao >= 3 .AND. nAcao <= 8  		
		// Se for devolução ou pagamento antecipado, avisar e sair.
		If (SE2->E2_TIPO $ 'DEV|PA ')
			MsgAlert('Este título não possui documento fiscal de entrada.', cCadastro)
			Return
		Endif   
   
		SF1->( dbSetOrder( 2 ) )
		If .NOT. SF1->( dbSeek( Iif( c470Filial == cFilAnt, xFilial( 'SF1' ), c470Filial ) + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM ) )
			MsgAlert('Documento fical não localizado.', cCadastro)
			Return
		Endif
		
		// Visualizar o documento fiscal.
		If nAcao==3
			cBkp := cCadastro
			cCadastro := 'Consulta Documento Fiscal de Entrada'
			If cFilAnt <> SF1->F1_FILIAL
				cBkpFil := cFilAnt
				cFilAnt := SF1->F1_FILIAL
			Endif
			A103NFiscal('SF1',SF1->(Recno()),2)
			If cBkpFil <> ''
				cFilAnt := cBkpFil
			Endif
			cCadastro := cBkp
			lFlag := .T.
		
		// Visualizar os documentos anexados ao documento fiscal.
		Elseif nAcao==4
			If cFilAnt <> SF1->F1_FILIAL
				cBkpFil := cFilAnt
				cFilAnt := SF1->F1_FILIAL
			Endif
			MsDocument('SF1',SF1->(RecNo()),2)
			If cBkpFil <> ''
				cFilAnt := cBkpFil
			Endif
			lFlag := .T.
			
		Elseif nAcao >= 5 .OR. nAcao <= 8
  			SD1->( dbSetOrder( 1 ) )
  			
  			If .NOT. SD1->( dbSeek( SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
  				MsgAlert('Item do documento fiscal não localizado.', cCadastro)
  				Return
  			Endif
  			
  			// Capturar dados dos itens do documentos fiscal.
  			While .NOT. SD1->(EOF()) .AND. SD1->D1_FILIAL == SF1->F1_FILIAL   .AND. ;
  			                               SD1->D1_DOC == SF1->F1_DOC         .AND. ;
  			                               SD1->D1_SERIE == SF1->F1_SERIE     .AND. ;
  			                               SD1->D1_FORNECE == SF1->F1_FORNECE .AND. ;
  			                               SD1->D1_LOJA == SF1->F1_LOJA
   				
  				If cD1_PEDIDO <> SD1->D1_PEDIDO
  					cD1_PEDIDO := SD1->D1_PEDIDO
  					AAdd( aD1_PEDIDO, {SD1->D1_PEDIDO,Ctod(Space(8)),;
  					                   SD1->D1_FORNECE+'-'+SD1->D1_LOJA+' '+RTrim(Posicione('SA2',1,xFilial('SA2')+SD1->(D1_FORNECE+D1_LOJA),'A2_NOME'))})
  				Endif
  				
  				// Verificar se há pedido de compras e contrato e capturar seus dados.
  				SC7->( dbSetOrder( 14 ) )
  				SC7->( dbSeek( SD1->( D1_FILIAL + D1_PEDIDO + D1_ITEMPC ) ) )
  				
				If SC7->( Found() )
					cC7_FILIAL := SC7->C7_FILIAL
					aD1_PEDIDO[ Len( aD1_PEDIDO ), 2 ] := SC7->C7_EMISSAO
  					If .NOT. Empty( SC7->C7_CONTRA )
	  					If AScan( aC7_CONTRA, {|e| e[1]==SC7->C7_CONTRA } ) == 0
	  						aCtr := GetAdvFVal( 'CN9', { 'CN9_DTINIC', 'CN9_DESCRI' }, c470Filial + SC7->C7_CONTRA, 1 ) 
	  						AAdd( aC7_CONTRA, { SC7->C7_CONTRA, aCtr[ 1 ], aCtr[ 2 ], SC7->C7_MEDICAO } )
	  					Endif
	  				Endif
  				Endif
   				
  				SD1->( dbSkip() )
  			End
   		
   		If c470Filial <> cC7_FILIAL
   			c470Filial := cC7_FILIAL
   		Endif 
   		
  			If nAcao == 5 .OR. nAcao == 6 .OR. nAcao == 6.1
  				If Len( aD1_PEDIDO ) == 0
  					MsgAlert('Não localizei o pedido de compras.', cCadastro)
  					Return
  					
  				Else
  					// Visualizar o pedido de compras.
  					If nAcao == 5
  						A470Pedido( aD1_PEDIDO, @lFlag, cC7_FILIAL )
  					
  					// Visualizar os documentos anexados ao pedido de compras.
  					Elseif nAcao == 6
  						SC7->( dbSetOrder( 1 ) ) 
  						SC7->( dbSeek( cC7_FILIAL + aD1_PEDIDO[ 1, 1 ] ) )
  						If cFilAnt <> cC7_FILIAL
  							cBkpFil := cFilAnt
  							cFilAnt := cC7_FILIAL
  						Endif
  						MsDocument('SC7',SC7->(RecNo()),2)
  						If cBkpFil <> ''
  							cFilAnt := cBkpFil
  						Endif
  						lFlag := .T.
  						
  					// Visualizar as aprovaçoes.
  					Elseif nAcao == 6.1
  						A470AprPC( aD1_PEDIDO, @lFlag, cC7_FILIAL )
  						
  					Endif
  				Endif
  			Elseif nAcao == 7 .OR. nAcao == 7.1 .OR. nAcao == 7.2 .OR. nAcao == 8
				If Len( aC7_CONTRA ) == 0
  					MsgAlert('Não localizei o contrato.', cCadastro)
  					Return
  					
  				Else
  					// Visualizar o contrato.
  					If nAcao == 7
  						A470Contrato( aC7_CONTRA, @lFlag, cC7_FILIAL )
  					
  					// Visualizar as medições.
  					Elseif nAcao == 7.1
  						CN9->( dbSetOrder( 1 ) ) 
  						CN9->( dbSeek( cC7_FILIAL + aC7_CONTRA[ 1, 1 ] ) )
  						A470Medicao( aC7_CONTRA[ 1, 1 ], @lFlag, aC7_CONTRA[ 1, 4 ], cC7_FILIAL )
  						
  					// Visualizar aprovação da medição.
  					Elseif nAcao == 7.2  						
  						CN9->( dbSetOrder( 1 ) ) 
  						CN9->( dbSeek( cC7_FILIAL + aC7_CONTRA[ 1, 1 ] ) )
  						
  						CND->( dbSetOrder( 1 ) )
  						CND->( dbSeek( cC7_FILIAL + CN9->CN9_NUMERO + CN9->CN9_REVISA ) )
  						
  						// Permitir o acesso ao contrato.
  						If cMV_470ROTA=='1'
  							A470VldCtr()
  						Else
  							A470Acesso(cC7_FILIAL)
  						Endif

  						// Rotina padrão Prothues.
  						// Consulta do status das Aprovacoes de documentos PC/AE/CP/NF.
  						A120Posic('CND', CND->( RecNo() ), nVisual, cTipoDoc, lStatus )
  						
  						// Restaurar o controle de acesso do contrato.
  						If cMV_470ROTA=='1' .AND. lVldCtr
  							A470VldCtr()
  						Endif
  						
  					// Visualizar os documentos anexados ao contrato.
  					Elseif nAcao == 8
  						CN9->( dbSetOrder( 1 ) ) 
  						CN9->( dbSeek( cC7_FILIAL + aC7_CONTRA[ 1, 1 ] ) )
  						MsDocument('CN9',CN9->(RecNo()),2)
  						lFlag := .T.
  					Endif  					
  				Endif
  			Endif
		Endif
	
	// Visualizar a posição do título.
   Elseif nAcao == 9
   	A470PosTit(@lFlag)
   
   // Consultar a movimentaçao do título no movimento financeiro.
   Elseif nAcao == 10
   	A470ConMov(@lFlag)
   	
   Endif
   
   // Marcar se o registro já foi consultado.
   If lFlag 
		If oGride:aCOLS[ oGride:nAt, 1 ] == NOTIK
			oGride:aCOLS[ oGride:nAt, 1 ] := TIK
			oGride:Refresh()
		Endif
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Medicao  | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Montar a interface com os dados da medição.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Medicao( cContrato, lFlag, cMedicao, cC7_FILIAL )
	Local aC := {}
	Local oDlg 
	Local oPnlEsq, oPnlSup, oPnlInf
	Local oBar
	Local oThb2
	Local oLbx 
	Local aMedicao := {}
	Local aCND_RECNO := {}
	Local uMedicao
	Local nAlt := 0
	Local nLarg := 0
	Local oFont := TFont():New('Consolas',NIL,18,NIL,.T.,NIL,NIL,NIL,NIL,.F.,.F.)
	Local nMedicao := 0
	
	Private aHeader := {}
	Private aCOLS := {}
	Private oMsMGet 
	Private oGride
	
	// Buscar as medições.
	CND->( dbSetOrder( 1 ) )
	CND->( dbSeek( cC7_FILIAL + cContrato ) )
	While CND->( .NOT. EOF() ) .AND. CND->CND_FILIAL == cC7_FILIAL .AND. CND->CND_CONTRA == cContrato
		AAdd( aCND_RECNO, CND->( RecNo() ) )
		AAdd( aMedicao, CND->CND_NUMMED )
		If CND->CND_NUMMED == cMedicao
			nMedicao := Len( aMedicao )
		Endif
		CND->( dbSkip() )
	End
	
	// Se não houver medição, sair.
	If Len( aMedicao ) == 0
		MsgAlert('Não há medição do contrato ' + cContrato, cCadastro )
		Return
	Endif
	
	INCLUI := .F.
	ALTERA := .F.
	
	// Montar o aHeader.
	aHeader := APBuildHeader('CNE')
	
	aC := FWGetDialogSize( oMainWnd )
	DEFINE MSDIALOG oDlg TITLE 'Mediçoes do Contrato - ' + CN9->CN9_NUMERO FROM aC[1],aC[2] TO aC[3]-100, aC[4]-100 PIXEL
		oPnlEsq:= TPanel():New(1,1,,oDlg,,,,,,45,0)
		oPnlEsq:Align := CONTROL_ALIGN_LEFT
		
		nAlt  := (oPnlEsq:nClientHeight/2)-27
		nLarg := (oPnlEsq:nRight/2)-2
		
		@ 1,1 TO nAlt, nLarg LABEL 'Medições' OF oPnlEsq PIXEL

		oSplitter := TSplitter():New( 1, 1, oDlg, 1000, 1000, 1 )
		oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
				
		oPnlSup:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
		oPnlSup:Align := CONTROL_ALIGN_ALLCLIENT
				
		oPnlInf:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
		oPnlInf:Align := CONTROL_ALIGN_ALLCLIENT
		
		oLbx := TListBox():New( 0.6, 0.3, {|u| Iif( PCount() > 0, uMedicao := u, uMedicao ) },aMedicao,nLarg-3,nAlt-9,,oPnlEsq)
		oLbx:bChange := {|| A470LoadMed( aCND_RECNO[ oLbx:nAt ], oPnlSup, oPnlInf ) }
		oLbx:oFont:= oFont
		oLbx:nAt := nMedicao 
		
		oBar := TBar():New( oDlg, 10, 9, .T.,'BOTTOM')
		oThb2 := THButton():New(1,1, '&Sair', oBar,  {|| oDlg:End() }, 25, 9 )
	ACTIVATE MSDIALOG oDlg
	lFlag := .T.
Return

//-----------------------------------------------------------------------------------
// Rotina | A470LoadMed  | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Carregar os dados para os objetos MsMGet e MsNewGetDados.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470LoadMed( nRecNo, oPnlSup, oPnlInf )
	Local nI := 0
	Local nElem := 0
	Local cCpo := ''
	Local cX3_RELACAO := ''
	Local cCN1_CTRFIX := ''
	Local aAcho := {}
	
	Private lFixo := .T.
	Private cFilCtr := cFilAnt // Esta variável é necessária da função CN120RetTip.
	
	// Posicionar o registro caso necessário.
	If CND->( RecNo() ) <> nRecNo 
		CND->( dbGoTo( nRecNo ) )
	Endif
	
	// Verificar o controle do contrato.
	cCN1_CTRFIX := Posicione( 'CN1', 1, xFilial( 'CN1' ) + CN9->CN9_TPCTO, 'CN1_CTRFIX' )
	lFixo := ( Empty( cCN1_CTRFIX ) .OR. cCN1_CTRFIX == '1' )
	
	// Montar as MemVar para a MsMGet.
	SX3->( dbSetOrder( 1 ) )
	SX3->( dbSeek( 'CND' ) )
	While SX3->( .NOT. EOF() ) .AND. SX3->X3_ARQUIVO == 'CND'
		If SX3->X3_CONTEXT <> 'V'
			AAdd( aAcho, SX3->X3_CAMPO )
			M->&(SX3->X3_CAMPO) := CND->(FieldGet(FieldPos(SX3->X3_CAMPO)))
		Endif
		SX3->( dbSkip() )
	End
	
	// Caso haja dados, zerar.
	If Len( aCOLS ) > 0
		aCOLS := {}
	Endif
	
	// Montar o aCOLS.
	CNE->( dbSetOrder( 1 ) )
	CNE->( dbSeek( c470Filial + CND->( CND_CONTRA + CND_REVISA + CND_NUMERO + CND_NUMMED ) ) )
	While CNE->( .NOT. EOF() ) .AND. CNE->CNE_FILIAL == c470Filial .AND. CNE->CNE_CONTRA == CND->CND_CONTRA .AND. ;
		CNE->CNE_REVISA == CND->CND_REVISA .AND. CNE->CNE_NUMERO == CND->CND_NUMERO .AND. ;
		CNE->CNE_NUMMED == CND->CND_NUMMED
		
		AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		nElem := Len( aCOLS )
		
		For nI := 1 To Len( aHeader )
			If aHeader[ nI, 10 ] == 'V'
				cX3_RELACAO := Posicione( 'SX3', 2, aHeader[ nI, 2 ], 'X3_RELACAO' )
				If .NOT. Empty( cX3_RELACAO )
					aCOLS[ nElem, nI ] := &( cX3_RELACAO )
				Endif
			Else
				aCOLS[ nElem, nI ] := CNE->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
			Endif
		Next nI
		
		aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
		CNE->( dbSkip() )
	End
	
	// Caso não haja dados, montar o elemento sem dados.
	If Len( aCOLS ) == 0
		AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			aCOLS[ 1, nI ] := CriaVar( aHeader[ nI, 2 ], .F. )
		Next nI
		aCOLS[ 1, Len( aHeader ) + 1 ] := .F.
	Endif
	
	// Se já existir o objeto, apenas fazer o refresh.
	If ValType( oMsMGet ) == 'O'
		oMsMGet:Refresh()
	Else
		oMsMGet := MsMGet():New('CND',nRecNo,2,,,,aAcho,{0,0,400,600},,,,,,oPnlSup)
		oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
	Endif
	
	// Se já existir o objeto, apenas fazer o refresh.
	If ValType( oGride ) == 'O'
		oGride:SetArray( aCOLS )
		oGride:oBrowse:Refresh()
	Else
		oGride := MsNewGetDados():New(2,2,1000,1000,0,,,,,,Len(aCOLS),,,,oPnlInf,aHeader,aCOLS)
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Pedido   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para apresentar o pedido de compras ou a relação de pedidos de 
//        | compras que quer consultar
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Pedido( aD1_PEDIDO, lFlag, cC7_FILIAL )
	Local oDlg 
	Local oLbx
	Local oPnl 
	Local oVisual
	Local oSair 
	Local cPedido := aD1_PEDIDO[ 1, 1 ]
	
	If Len( aD1_PEDIDO ) == 1
		A470AuxPC( cPedido, @lFlag, cC7_FILIAL )
	Else
		DEFINE MSDIALOG oDlg TITLE 'QUAL PEDIDO DE COMPRAS QUER CONSULTAR?' FROM 0,0 TO 200,500 PIXEL
		   oLbx := TwBrowse():New(0,0,0,0,,{'Nº Pedido','Emissão','Fornecedor'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aD1_PEDIDO )
		   oLbx:bChange := {|| cPedido := oLbx:aArray[ oLbx:nAt, 1 ] }
		   oLbx:bLDblClick := {||  A470AuxPC( cPedido, @lFlag, cC7_FILIAL ) }
			oLbx:bLine := {|| { aD1_PEDIDO[ oLbx:nAt, 1 ], aD1_PEDIDO[ oLbx:nAt, 2 ], aD1_PEDIDO[ oLbx:nAt, 3 ] } }
			oPnl := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPnl:Align := CONTROL_ALIGN_BOTTOM
			@ 1, 1 BUTTON oVisual PROMPT 'Pedido' SIZE 40,11 PIXEL OF oPnl ACTION A470AuxPC( cPedido, @lFlag )
			@ 1,44 BUTTON oSair   PROMPT 'Sair'   SIZE 40,11 PIXEL OF oPnl ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470AuxPC    | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina auxiliar para efetivamente mostrar a visualização do pedido de 
//        | compras.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470AuxPC( cPedido, lFlag, cC7_FILIAL )
	Local cSavCadastro := cCadastro
	Private nTipoPed  := 1
	Private cCadastro := 'Consulta ao Pedido de Compra'
	Private l120Auto  := .F.
	Private INCLUI    := .F.
	Private ALTERA    := .F.
	Private aBackSC7  := {}
	
	SC7->( dbSetOrder( 1 ) )
	If .NOT. SC7->( dbSeek( cC7_FILIAL + cPedido ) )
		MsgAlert('Não existe pedido de compras para este registro.',cCadastro)
		Return
	Endif
	
	A120Pedido( 'SC7', SC7->( RecNo() ), 2 )
	cCadastro := cSavCadastro
	lFlag := .T.
Return

//-----------------------------------------------------------------------------------
// Rotina | A470AprPC    | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para buscar o(s) pedido(s) de compra(s) e logo apresentar os  
//        | aprovadores.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470AprPC( aD1_PEDIDO, lFlag, cC7_FILIAL )
	Local oDlg 
	Local oLbx
	Local oPnl 
	Local oPnlTxt
	Local oVisual
	Local oSair 
	Local cPedido := aD1_PEDIDO[ 1, 1 ]
	
	If Len( aD1_PEDIDO ) == 1
		A470AuxSCR( cPedido, @lFlag, cC7_FILIAL )
	Else
		DEFINE MSDIALOG oDlg TITLE 'Selecione o pedido de compras a consultar' FROM 0,0 TO 200,500 PIXEL
			oPnlTxt := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPnlTxt:Align := CONTROL_ALIGN_TOP
			
			@ 1,1 SAY 'O título a pagar em questão é de um documento fiscal que possui mais de um pedido de compras, por favor, selecione qual pedido de compras quer consultar.' ;
			SIZE 100,8 OF oPnlTxt  PIXEL
			
		   oLbx := TwBrowse():New(0,0,0,0,,{'Nº Pedido','Emissão','Fornecedor'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aD1_PEDIDO )
		   oLbx:bChange := {|| cPedido := oLbx:aArray[ oLbx:nAt, 1 ] }
		   oLbx:bLDblClick := {||  A470AuxSCR( cPedido, @lFlag ) }
			oLbx:bLine := {|| { aD1_PEDIDO[ oLbx:nAt, 1 ], aD1_PEDIDO[ oLbx:nAt, 2 ], aD1_PEDIDO[ oLbx:nAt, 3 ] } }
			oPnl := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPnl:Align := CONTROL_ALIGN_BOTTOM
			@ 1, 1 BUTTON oVisual PROMPT 'Aprovador(es)' SIZE 40,11 PIXEL OF oPnl ACTION A470AuxSCR( cPedido, @lFlag )
			@ 1,44 BUTTON oSair   PROMPT 'Sair'          SIZE 40,11 PIXEL OF oPnl ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470AuxSCR   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina auxiliar para apresentar os dados dos aprovadores do pedido de 
//        | compras.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470AuxSCR( cPedido, lFlag, cC7_FILIAL )
	Local cNome := ''
	Local cStatus := ''
	Local cC7_NUM := ''
	Local aAprov := {}
	Local oDlg
	Local oLbx
	Local oPnl
	Local oSair 
	Local oVisual
	
	SC7->( dbSetOrder( 1 ) )
	SC7->( dbSeek( cC7_FILIAL + cPedido ) )
	
	SCR->( dbSetOrder( 1 ) )
	SCR->( dbSeek( cC7_FILIAL + 'PC' + cPedido ) )
	While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == SC7->C7_FILIAL .AND. SCR->CR_TIPO == 'PC' .AND. RTrim(SCR->CR_NUM) == cPedido
		cNome := RTrim( SAK->( Posicione( 'SAK', 1, xFilial( 'SAK' ) + SCR->CR_APROV, 'AK_NOME' ) ) )
		If SCR->CR_STATUS=='01'
			cLeg := 'BR_AZUL'
			cStatus := 'Bloqueado (aguardando outros níveis)'
		Elseif SCR->CR_STATUS=='02'
			cLeg := 'DISABLE'
			cStatus := 'Aguardando liberação do usuário'
		Elseif SCR->CR_STATUS=='03'
			cLeg := 'ENABLE'
			cStatus := 'Documento liberado pelo usuário'
		Elseif SCR->CR_STATUS=='04'
			cLeg := 'BR_PRETO'
			cStaus := 'Documento bloqueado pelo usuário'
		Elseif SCR->CR_STATUS=='05'
			cLeg := 'BR_CINZA'
			cStatus := 'Documento liberado por outro usuário'
		Endif
		SCR->( AAdd( aAprov, { cLeg, cNome, cStatus, CR_NIVEL, CR_USER, CR_APROV, RTrim(CR_NUM) } ) )
		SCR->( dbSkip() )
	End
	If Len( aAprov ) > 0
		DEFINE MSDIALOG oDlg TITLE 'Aprovador(es)' FROM 0,0 TO 200,710 PIXEL
		   oLbx := TwBrowse():New(0,0,0,0,,{'','Nome do usuário/aprovador','Status','Nível','Usuário','Aprovador','Nº Pedido'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aAprov )
		   oLbx:bChange := {|| cC7_NUM := oLbx:aArray[ oLbx:nAt, 7 ] }
		   oLbx:bLDblClick := {|| A470AuxPC( cC7_NUM, @lFlag ) }
			oLbx:bLine := {|| { LoadBitmap(,aAprov[ oLbx:nAt, 1 ]), aAprov[ oLbx:nAt, 2 ], aAprov[ oLbx:nAt, 3 ],;
			aAprov[ oLbx:nAt, 4 ], aAprov[ oLbx:nAt, 5 ], aAprov[ oLbx:nAt, 6 ], aAprov[ oLbx:nAt, 7 ] } }
			oPnl := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPnl:Align := CONTROL_ALIGN_BOTTOM
			@ 1, 1 BUTTON oVisual PROMPT 'Pedido' SIZE 40,11 PIXEL OF oPnl ACTION A470AuxPC( cC7_NUM, @lFlag )
			@ 1,44 BUTTON oSair   PROMPT 'Sair'   SIZE 40,11 PIXEL OF oPnl ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
		lFlag := .T.
	Else
		MsgAlert('Não localizado os registro de aprovação.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Contrato | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para apresentar o contrato ou a relação de contratos que quer 
//        | consultar.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Contrato( aC7_CONTRA, lFlag, cC7_FILIAL )
	Local oDlg 
	Local oLbx
	Local oPnl 
	Local oVisual
	Local oSair 
	Local cContrato := aC7_CONTRA[ 1, 1 ]
	
	If Len( aC7_CONTRA ) == 1
		A470AuxCtr( cContrato, @lFlag, cC7_FILIAL )
	Else
		DEFINE MSDIALOG oDlg TITLE 'QUAL CONTRATO QUER CONSULTAR?' FROM 0,0 TO 200,500 PIXEL
		   oLbx := TwBrowse():New(0,0,0,0,,{'Nº Contrato','Data Início','Descrição'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aC7_CONTRA )
		   oLbx:bChange := {|| cContrato := oLbx:aArray[ oLbx:nAt, 1 ] }
		   oLbx:bLDblClick := {||  A470AuxCtr( cContrato, @lFlag ) }
			oLbx:bLine := {|| { aC7_CONTRA[ oLbx:nAt, 1 ], aC7_CONTRA[ oLbx:nAt, 2 ], aC7_CONTRA[ oLbx:nAt, 3 ] } }
			oPnl := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPnl:Align := CONTROL_ALIGN_BOTTOM
			@ 1, 1 BUTTON oVisual PROMPT 'Contrato' SIZE 40,11 PIXEL OF oPnl ACTION A470AuxCtr( cContrato, @lFlag )
			@ 1,44 BUTTON oSair   PROMPT 'Sair'     SIZE 40,11 PIXEL OF oPnl ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470AuxCtr   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina auxiliar para efetivamente mostrar a visualização do contrato.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470AuxCtr( cContrato, lFlag, cC7_FILIAL )
	Local cBkp := cCadastro
	INCLUI := .F.
	ALTERA := .F.
	cCadastro := 'Consulta ao Contrato'
   CN9->( dbSetOrder( 1 ) )
   CN9->( dbSeek( cC7_FILIAL + cContrato ) )
	
	// Permitir o acesso ao contrato.
	If cMV_470ROTA=='1'
		A470VldCtr()
	Else
		A470Acesso(cC7_FILIAL)
	Endif

	CN100Manut( 'CN9', CN9->( RecNo() ), 2 )
	
	// Restaurar o controle de acesso do contrato.
	If cMV_470ROTA=='1' .AND. lVldCtr
		A470VldCtr()
	Endif

	cCadastro := cBkp 
	lFlag := .T.
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Acesso   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para permitir acesso ao contrato para usuários configurado no 
//        | parâmetro MV_470ACES.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Acesso(cC7_FILIAL)
	Local cRetCodUsr := ''
	cRetCodUsr := RetCodUsr()
	If cRetCodUsr $ cMV_470ACES 
		CNN->( dbSetOrder( 1 ) )
		If CNN->( dbSeek( cC7_FILIAL + cRetCodUsr + CN9->CN9_NUMERO ) )
			CNN->( RecLock( 'CNN', .F. ) )
			CNN->CNN_FILIAL := cC7_FILIAL
			CNN->CNN_CONTRA := CN9->CN9_NUMERO
			CNN->CNN_USRCOD := cRetCodUsr
			CNN->CNN_GRPCOD := ''
			CNN->CNN_TRACOD := '001'
			CNN->( MsUnLock() )
			A470GrvLog( cRetCodUsr )
		Endif
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470GrvLog   | Autor | Robson Gonçalves               | Data | 13/02/2015
//-----------------------------------------------------------------------------------
// Descr. | Rotina para gravar o LOG do usuário inserido no acesso ao contrato.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470GrvLog( cRetCodUsr )
	Local nHdl := 0
	Local cArq := 'ACESSGCT.LOG'
	If .NOT. File( cArq )
		nHdl := MSFCreate( cFile, 0 )
		FWrite( 'ESTE ARQUIVO ARMAZENA OS USUÁRIOS QUE TIVERAM ACESSO AO CONTRATO POR MEIO DA CONSULTA TRACKING DE PAGAMENTOS (CSFA470.PRW);' + CRLF )
		FWrite( 'NUMERO CONTRATO;CODIGO E NOME USUÁRIO;DATA;HORA' + CRLF )
	Else
		nHdl := FOpen( cArq )
	Endif
	If nHdl > 0
		FSeek( nHdl, 0, 2 )
		FWrite( CN9->CN9_NUMERO + ';' + cRetCodUsr + '-' + cUserName + ';' + Dtoc( dDataBase ) + ';' + Time() + CRLF )
		FClose( nHdl )
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470VldCtr   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para modificar ou restaurar o controle de acesso do contrato para
//        | todos os usuários.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470VldCtr()
	// Foi modificado o conteúdo do campo CN9_VLDCTR por esta rotina?
	If lVldCtr
		// Voltar para o valor default.
		lVldCtr := .F.
		// Restaurar o valor armazenado.
		CN9->( RecLock( 'CN9', .F. ) )
		CN9->CN9_VLDCTR := cVldCtr
		CN9->( MsUnLock() )
	Else
		// O contrato em questão possui controle de acesso de usuário.
		If CN9->CN9_VLDCTR <> '2'
			// Indicar que o conteúdo do campo foi modificado por esta rotina.
			lVldCtr := .T.
			// Armazenar o valor do campo.
			cVldCtr := CN9->CN9_VLDCTR
			// Alterar o valor do campo para ser possível a consulta do contrato e seus dependentes.
			CN9->( RecLock( 'CN9', .F. ) )
			CN9->CN9_VLDCTR := '2'
			CN9->( MsUnLock() )
		Endif
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470ConMov   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para consultar o movimento financeiro.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470ConMov(lFlag)
	Local oDlg 
	Local oPnl1
	Local oPnl2
	Local oGride
	Local oBar
	Local oThb1
	Local oThb2
	Local oThb3
	
	Local aCpo := {}
	Local aCOLS := {}
	Local aHeader := {}
	Local aLegenda := {}
	Local aMotBx := {}
		
	Local cSQL := ''
	Local cTRB := ''
	Local cLGI := ''
	Local cLGA := ''
	Local cMotivo := ''
		
	Local nI := 0
	Local nP := 0
		
	Private a470User := {}
	
	aCpo := {'E5_DATA','E5_TIPO','E5_BANCO','E5_AGENCIA','E5_CONTA','E5_NUMCHEQ','E5_DOCUMEN','E5_VENCTO','E5_BENEF','E5_HISTOR','E5_TIPODOC',;
	'E5_SITUACA','E5_PREFIXO','E5_NUMERO','E5_PARCELA','E5_CLIFOR','E5_LOJA','E5_DTDIGIT','E5_MOTBX','E5_SEQ','E5_DTDISPO','E5_USERLGI','E5_USERLGA'}	
	
	AAdd( aHeader, { CRLF+'','GD_DEL', '@BMP', 1, 0, '', '', '' , '', ''  } )

	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpo )
		If SX3->( dbSeek( aCpo[ nI ] ) )
			SX3->( AAdd( aHeader, { X3_TITULO, RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
		Endif
	Next nI
	
	AAdd( aHeader, { 'Nº Registro' ,'GD_RECNO', '@!', 12, 0, '', '', 'C', '', 'V' } )
	
	cSQL := "SELECT E5_DATA, "
	cSQL += "       E5_TIPO, "
	cSQL += "       E5_BANCO, "
	cSQL += "       E5_AGENCIA, "
	cSQL += "       E5_CONTA, "
	cSQL += "       E5_NUMCHEQ, "
	cSQL += "       E5_DOCUMEN, "
	cSQL += "       E5_VENCTO, "
	cSQL += "       E5_BENEF, "
	cSQL += "       E5_HISTOR, "
	cSQL += "       E5_TIPODOC, "
	cSQL += "       E5_SITUACA, "
	cSQL += "       E5_PREFIXO, "
	cSQL += "       E5_NUMERO, "
	cSQL += "       E5_PARCELA, "
	cSQL += "       E5_CLIFOR, "
	cSQL += "       E5_LOJA, "
	cSQL += "       E5_DTDIGIT, "
	cSQL += "       E5_MOTBX, "
	cSQL += "       E5_SEQ, "
	cSQL += "       E5_DTDISPO, "
	cSQL += "       E5_USERLGI, "
	cSQL += "       E5_USERLGA, "
	cSQL += "       SE5.R_E_C_N_O_ AS GD_RECNO, "
	cSQL += "       SE5.D_E_L_E_T_ AS GD_DEL "
	cSQL += "FROM   "+RetSqlName("SE5")+" SE5 "
	cSQL += "WHERE  E5_FILIAL = "+ValToSql( xFilial( "SE5" ) )+" "
	cSQL += "       AND E5_NUMERO = "+ValToSql( SE2->E2_NUM )+" "
	cSQL += "       AND E5_PREFIXO = "+ValToSql( SE2->E2_PREFIXO )+" "
	cSQL += "       AND E5_PARCELA = "+ValToSql( SE2->E2_PARCELA )+" "
	cSQL += "       AND E5_TIPO = "+ValToSql( SE2->E2_TIPO )+" "
	cSQL += "       AND E5_CLIFOR = "+ValToSql( SE2->E2_FORNECE )+" "
	cSQL += "       AND E5_LOJA = "+ValToSql( SE2->E2_LOJA )+" "
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )	

	If (cTRB)->( .NOT. BOF() .AND. .NOT. EOF() )
		// Capturar o nome dos motivos de baixas.
		aMotBx := ReadMotBx()
		
		While .NOT. (cTRB)->( EOF() )
			// Capturar a data e nome dos usuários que incluiu e que alterou o registro.
			A470LgiLga( @cTRB, @cLGI, @cLGA )
			// Localizar o motivo da baixa.
			nP := AScan( aMotBx, {|e| Left(e,3)==(cTRB)->E5_MOTBX } )
			// Se encontrar montar a string, do contrário apenas apresentar a sigla.
			If nP > 0
				cMotivo := (cTRB)->E5_MOTBX + ' - ' + SubStr( aMotBx[ nP ], 7, 10 )
			Else
				cMotivo := (cTRB)->E5_MOTBX
			Endif
			
			(cTRB)->(AAdd(aCOLS,{Iif(GD_DEL=='*',REC_DEL,REC_OK),E5_DATA,E5_TIPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,;
			                     E5_DOCUMEN,E5_VENCTO,E5_BENEF,E5_HISTOR,E5_TIPODOC,E5_SITUACA,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,;
			                     E5_DTDIGIT,cMotivo,E5_SEQ,E5_DTDISPO,cLGI,cLGA,GD_RECNO,.F.}))
			
			(cTRB)->( dbSkip() )
		End
		(cTRB)->(dbCloseArea())
	Else
		MsgInfo('Não existe informações de movimentos.', cCadastro)
		Return
	Endif
	
	AAdd( aLegenda, { REC_OK , 'Registro Ativo'    } )
	AAdd( aLegenda, { REC_DEL, 'Registro Excluído' } )

	DEFINE MSDIALOG oDlg TITLE 'Consulta ao Movimento Financeiro do Título' OF oMainWnd FROM 0,0 TO 300, 900 PIXEL
		oPnl1:= TPanel():New(2,2,,oDlg,,,,,,60,26)
		oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnl2:= TPanel():New(2,2,,oPnl1,,,,,RGB(100,100,100),1,13)
		oPnl2:Align := CONTROL_ALIGN_BOTTOM

		oGride := MsNewGetDados():New(2,2,1000,1000,0,,,,,,Len(aCOLS),,,,oPnl1,aHeader,aCOLS)
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		oBar := TBar():New( oPnl2, 10, 9, .T.,'BOTTOM')
		oThb1 := THButton():New(1,1, '&Legenda'   , oBar,  {|| BrwLegenda( cCadastro, 'Status do registro', aLegenda ) }, 30, 9 )
		oThb2 := THButton():New(1,1, '&Visualizar', oBar,  {|| A470SE5( oGride) }, 35, 9 )
		oThb3 := THButton():New(1,1, '&Sair'      , oBar,  {|| oDlg:End() }, 25, 9 )
	ACTIVATE MSDIALOG oDlg CENTERED
	lFlag := .T.
Return

//-----------------------------------------------------------------------------------
// Rotina | A470SE5      | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para visualizar o registro do movimento bancário.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470SE5( oGride )
	Local cBkp := cCadastro
	cCadastro := 'Visualizar Movimento Financeiro'
	SE5->( dbGoTo( oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'GD_RECNO' } ) ] ) )
	AxVisual( 'SE5', SE5->( RecNo() ), 2 )
	cCadastro := cBkp 
Return

//-----------------------------------------------------------------------------------
// Rotina | A470LgiLga   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para converter o conteúdo do campo USERLGI e USERLGA.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470LgiLga( cTRB, cLGI, cLGA )
	Local lIgual := .T.
	Local lVazio := .T.
	
	Local cUserI := ''
	Local cUserA := ''
	Local cDateI := ''
	Local cDateA := ''
	Local cFullName := ''
	
	Local nP := 0
	
	// Os dados dos campos USERLGI e USERLGA são iguais?
	lIgual := ( (cTRB)->E5_USERLGI == (cTRB)->E5_USERLGA )
	
	// Se não são iguais o campo USERLGA está vazio?
	If .NOT. lIgual
		lVazio := Empty( (cTRB)->E5_USERLGA )
	Endif
	
	// Capturar o código do usuário USERLGI.
	cUserI := RTrim( FwLeUserLg( cTRB+'->E5_USERLGI' ) )
	// Capturar a data da inclusão do USERLGI.
	cDateI := FwLeUserLg( cTRB+'->E5_USERLGI', 2 )
	
	// Se não são iguais USERLGI e USERLGA e USERLGA não está vazio.
	If .NOT. lIgual .AND. .NOT. lVazio
		// Capturar o código do usuário USERLGA.
		cUserA := RTrim( FwLeUserLg( cTRB+'->E5_USERLGA' ) )
		// Capturar a data da inclusão do USERLGA.
		cDateA := FwLeUserLg( cTRB+'->E5_USERLGA', 2 )
	Endif
	
	// O codigo do USERLGI está no vetor?
	nP := AScan( a470User, {|p| p[ 1 ] == cUserI } )
	
	// Se o código do USERLGI não está no vetor.
	If nP == 0
		// Estabelecer a ordem de busca.
		PswOrder(2)
		// Buscar.
		PswSeek( cUserI )
		// Capturar o nome completo.
		cFullName := PswRet( 1 )[ 1, 4 ]
		// Adicionar no vetor para novas buscas.
		AAdd( a470User, { cUserI, cFullName } )
	Else
		// Se o código do USERLGI está no vetor, capturar apenas o nome.
		cFullName := a470User[ nP, 2 ]
	Endif
	
	// Montar a string data da inclusão e nome do usuário que incluiu.
	cLGI :=  cDateI + ' ' + cFullName
	
	// Se há código de usuário e data da alteração.
	If .NOT. Empty( cUserA ) .AND. .NOT. Empty( cDateA )	
		// O codigo do USERLGA está no vetor?
		nP := AScan( a470User, {|p| p[ 1 ] == cUserA } )
		// Se o código do USERLGA não está no vetor.
		If nP == 0
			// Estabelecer a ordem de busca.
			PswOrder(2)
			// Buscar.
			PswSeek( cUserA )
			// Capturar o nome completo.
			cFullName := PswRet( 1 )[ 1, 4 ]
			// Adicionar no vetor para novas buscas.
			AAdd( a470User, { cUserA, cFullName } )
		Else
			cFullName := a470User[ nP, 2 ]
		Endif
		// Se o código do USERLGA está no vetor, capturar apenas o nome.
		cLGA :=  cDateA + ' ' + cFullName
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470PosTit   | Autor | Robson Gonçalves               | Data | 06/12/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para executar a posição de títulos a pagar (padrão).
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470PosTit( lFlag )
	FC050Con()
	lFlag := .T.
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Copy   | Autor | Robson Gonçalves                 | Data | 06.02.2017 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para copiar o arquivo PDF da capa de despesa.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Copy( oGride )
	Local aAnexo := {}
	Local aCapa := {}
	Local aOpc := {}
	Local aPar := {}
	Local aPoint := {"/","-","|","-","\","|"}
	Local aRet := {}
	
	Local c470Filial := ''
	Local cF1_SERIE := ''
	Local cKeySD1 := ''
	Local cKeySF1 := ''
	Local cRoot := MsDocPath() + '\'
	
	Local lMark := .T.
	
	Local nA2_NOME    := GdFieldPos('A2_NOME'   ,oGride:aHeader)
	Local nE2_FILORIG := GdFieldPos('E2_FILORIG',oGride:aHeader)
	Local nEA_FORNECE := GdFieldPos('EA_FORNECE',oGride:aHeader)
	Local nEA_LOJA    := GdFieldPos('EA_LOJA'   ,oGride:aHeader)
	Local nEA_NUM     := GdFieldPos('EA_NUM'    ,oGride:aHeader)
	Local nEA_NUMBOR  := GdFieldPos('EA_NUMBOR' ,oGride:aHeader)
	Local nLoop := 0
	Local nOpc := 0
	Local nOrd := 1
	Local nPoint := 1
	
	Local oDlg
	Local oLbx
	Local oMrk := LoadBitmap( , 'LBOK' )
	Local oNoMrk := LoadBitmap( , 'LBNO' )
	Local oOrdem
	Local oPesq
	Local oPnl1 
	Local oPnl2
	Local oPnlTop
	Local oSeek 
	Local oThb1 
	Local oThb2
	
	Local cOrd := ''
	Local cSeek := Space(100)
	
	aOpc := {'Somente capa de despesa','Todos os anexos do PC e NFE'}
	
	AAdd( aPar, { 2, 'Considerar', 1, aOpc, 99, '', .T. } )
	
	If .NOT. ParamBox( aPar, 'Parâmetro',@aRet,,,,,,,,.F.,.T.)
		Return
	Endif
	
	nOpc := Iif( ValType( aRet[ 1 ] ) == 'N', aRet[ 1 ], AScan( aOpc, {|e| e==aRet[ 1 ] } ) )	
		
	For nLoop := 1 To Len( oGride:aCOLS )
		nPoint++
		
		If nPoint == 7
			nPoint := 1
		Endif
	   
	   MsProcTxt( 'Aguarde, buscando os documentos [ ' + aPoint[ nPoint ] + ' ]'  )
	   ProcessMessage()
		
		If oGride:aCOLS[ nLoop, nE2_FILORIG ] <> cFilAnt
			c470Filial := oGride:aCOLS[ nLoop, nE2_FILORIG ]
		Else
			c470Filial := cFilAnt
		Endif
		
		SF1->( dbSetOrder( 2 ) )
		cKeySF1 := oGride:aCOLS[nLoop,nEA_FORNECE]+oGride:aCOLS[nLoop,nEA_LOJA]+oGride:aCOLS[nLoop,nEA_NUM]
		
		If SF1->( dbSeek( Iif( c470Filial == cFilAnt, xFilial( 'SF1' ), c470Filial ) + cKeySF1 ) )
			cF1_SERIE := SF1->F1_SERIE
		Endif
		
		If nOpc == 2
			A470Anexo( 'SF1', SF1->F1_FILIAL, SF1->F1_DOC + SF1->F1_PREFIXO + SF1->F1_FORNECE + SF1->F1_LOJA, @aAnexo )
		Endif
	   
		SD1->( dbSetOrder( 1 ) )
		cKeySD1 := oGride:aCOLS[nLoop,nEA_NUM]+cF1_SERIE+oGride:aCOLS[nLoop,nEA_FORNECE]+oGride:aCOLS[nLoop,nEA_LOJA]
	
  		If SD1->( dbSeek( SF1->F1_FILIAL + cKeySD1 ) )
			While .NOT. SD1->(EOF()) .AND. SD1->D1_FILIAL == SF1->F1_FILIAL .AND. ;
				SD1->D1_DOC == oGride:aCOLS[nLoop,nEA_NUM] .AND. ;
				SD1->D1_SERIE == cF1_SERIE .AND. ;
				SD1->D1_FORNECE == oGride:aCOLS[nLoop,nEA_FORNECE] .AND. ;
				SD1->D1_LOJA == oGride:aCOLS[nLoop,nEA_LOJA]
				
  				SC7->( dbSetOrder( 14 ) )
  				SC7->( dbSeek( SD1->D1_FILIAL + SD1->D1_PEDIDO + SD1->D1_ITEMPC ) )
				
				If SC7->( Found() )
					If nOpc == 1
						A470AnexCP( SC7->C7_FILIAL, SC7->C7_FILIAL + SD1->D1_PEDIDO, @aAnexo )
					Else
						A470Anexo( 'SC7', SC7->C7_FILIAL, SC7->C7_FILIAL + SC7->C7_NUM + SC7->C7_ITEM, @aAnexo )
					Endif
				
					For nP := 1 To Len( aAnexo )
						AAdd( aCapa, { .T.,;
						oGride:aCOLS[nLoop,nEA_NUMBOR],;
						oGride:aCOLS[nLoop,nEA_NUM],;
						oGride:aCOLS[nLoop,nEA_FORNECE]+'-'+oGride:aCOLS[nLoop,nEA_LOJA]+' '+oGride:aCOLS[nLoop,nA2_NOME],;
						aAnexo[ nP ],;
						''} )
					Next nP
					aAnexo := {}				
				Endif
				SD1->( dbSkip() )
			End  		
  		Endif
	Next nLoop
	 
	If Len( aCapa ) > 0
		DEFINE MSDIALOG oDlg TITLE 'Documento de capa de despesa' FROM 0,0 TO 340,700 PIXEL
			oPnlTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPnlTop:Align := CONTROL_ALIGN_TOP

			@ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS {'Título','Fornecedor','Borderô'} SIZE 80,36 ON CHANGE ( nOrd:=oOrdem:nAt ) PIXEL OF oPnlTop
			@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPnlTop
			@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPnlTop ACTION ( A470Pesq(nOrd, RTrim( cSeek ), @oLbx ) )
			
			oPnl1:= TPanel():New(2,2,,oDlg,,,,,,60,26)
			oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
			
			oPnl2:= TPanel():New(2,2,,oPnl1,,,,,RGB(100,100,100),1,13)
			oPnl2:Align := CONTROL_ALIGN_BOTTOM
		
			oBar := TBar():New( oPnl2, 10, 9, .T.,'BOTTOM')
			oThb2 := THButton():New(1,1, '&Sair'  , oBar,{|| oDlg:End()}, 25, 9 )
			
			oThb1 := THButton():New(1,1, '&Copiar', oBar,{|| nP:=Ascan(oLbx:aArray,{|e|e[1]==.T.}),;
			Iif(nP>0,(MsAguarde({|| A470GoCopy(oLbx)},'Cópia da capa de despesa','Início do processo, aguarde...',.F.),;
			oDlg:End()),(MsgAlert('Selecione o(s) documento(s)',cCadastro),NIL))}, 30, 9 )
			
			oThb2:Align := CONTROL_ALIGN_RIGHT
			oThb1:Align := CONTROL_ALIGN_RIGHT
			
			oLbx := TwBrowse():New(0,0,0,0,,{' x','Borderô','Título','Fornecedor','Documento capa de despesa',''},,oPnl1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			oLbx:SetArray( aCapa )
			oLbx:bLine := {|| {Iif(aCapa[oLbx:nAt,1],oMrk,oNoMrk),aCapa[oLbx:nAt,2],aCapa[oLbx:nAt,3],aCapa[oLbx:nAt,4],aCapa[oLbx:nAt,5],aCapa[oLbx:nAt,6]}}
			oLbx:bLDblClick := {||  aCapa[ oLbx:nAt, 1 ] := .NOT. aCapa[ oLbx:nAt, 1 ] }
			oLbx:bHeaderClick := {|| AEval( aCapa, {|p| p[1] := lMark } ), lMark := .NOT. lMark, oLbx:Refresh() }
		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgAlert( 'Dados não localizados.', cCadastro )
	Endif	
Return

//-----------------------------------------------------------------------------------
// Rotina | A470GoCopy | Autor | Robson Gonçalves                 | Data | 06.02.2017 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para efetuar a copiar do arquivo PDF da capa de despesa.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470GoCopy(oLbx)
	Local aPoint := {"/","-","|","-","\","|"}
	Local aWarning := { 'Não foi possível copiar os arquivos: ' }
	Local cPath := MsDocPath()
	Local cMsg := ''
	Local cDiaria := Dtos(MsDate())
	Local cRaiz := 'c:\doc_capa_desp'
	Local nLoop := 0
	Local nPoint := 1
	MakeDir( cRaiz )
	MakeDir( cRaiz + '\' + cDiaria )
	For nLoop := 1 To Len(oLbx:aArray)
		nPoint++
		If nPoint == 7
			nPoint := 1
		Endif
	   MsProcTxt( 'Aguarde, copiando arquivo [ ' + aPoint[ nPoint ] + ' ]'  )
	   ProcessMessage()
		If oLbx:aArray[ nLoop, 1 ]
			If File( cPath + '\' + oLbx:aArray[ nLoop, 5 ] )
				If .NOT. __CopyFile( cPath + '\' + oLbx:aArray[ nLoop, 5 ], cRaiz + '\' + cDiaria + '\' + oLbx:aArray[ nLoop, 5 ] )
					AAdd( aWarning, oLbx:aArray[ nLoop, 5 ] )
				Endif
			Else
				AAdd( aWarning, 'Não localizado o arquivo ' + oLbx:aArray[ nLoop, 5 ] )
			Endif
		Endif
	Next nLoop
	If Len( aWarning ) > 1
		For nLoop := 1 To Len( aWarning )
			cMsg += aWarning[ nLoop ] + CRLF
		Next nLoop
		CopyToClipboard( cMsg )
		MsgAlert( cMsg, 'Cópia da capa de despesa' )
	Endif
	MsgInfo('Processo finalizado.','Cópia da capa de despesa')
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Pesq | Autor | Robson Gonçalves                 | Data |   06.02.2017 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para pesquisar os registro do documento da capa de despesa.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Pesq( nOrd, cSeek, oLbx )
	Local aPesq := { 3, 4, 2 } // ordem da pesquisa x ordem da coluna para pesquisar. {'Título','Fornecedor','Borderô'}
	Local bAScan := {|| .T. }
	Local bCampo := {|nCPO| Field(nCPO) }
	
	Local nBegin := 0
	Local nColumn := aPesq[ nOrd ]
	Local nEnd := 0
	Local nP := 0
	
	nBegin := Iif( oLbx:nAt==1, 1, Min( oLbx:nAt + 1, Len( oLbx:aArray ) ) )
	nEnd := Len( oLbx:aArray )
	
	If oLbx:nAt == Len( oLbx:aArray )
		nBegin := 1
	Endif
	
	If 'DATA' $ Upper( oLbx:aHeaders[ nColumn ] )
		bAScan := {|p| Ctod( cSeek ) == p[ nColumn ] } 
	Else	
		bAScan := {|p| Upper( cSeek ) $ AllTrim( p[ nColumn ] ) } 
	Endif
	
	nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
	
	If nP > 0
		oLbx:nAt := nP
		oLbx:Refresh()
		oLbx:SetFocus()
	Else
		nBegin := 1
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		Else
			ShowHelpDlg('Pesquisar',;
			           {'Não foi possível localizar sua pesquisa.'},,; //Problema
			           {'Verifique a sua pesquisa:',;
			            '1) A chave de pesquisa;',;
			            '2) A ordem selecionada;',;
			            '3) Se há realmente o que deseja pesquisar.'}) // Solução
		Endif
	Endif
Return

//-----------------------------------------------------------------------------------
// Rotina | A470AnexCP | Autor | Robson Gonçalves                 | Data | 09.02.2017 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para buscar os anexos de capa de despesa somente do PC.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470AnexCP( cFilEnt, cKey, aAnexo )
	Local cObjeto := ''
	Local cSQL := ''
	Local cString := 'CAPADESPESA_CT|CAPADESPESA_PC|CAPADESPESA_CO' //-> CTR-CONTRATO, PC-PEDIDO DE COMPRAS, CO-COTAÇÃO
	Local cTRB := GetNextAlias()
	Local nP := 0
	Local nQ := 0
	
	cSQL := "SELECT ACB_OBJETO "
	cSQL += "FROM   "+RetSqlName("AC9")+" AC9 "
	cSQL += "       INNER JOIN "+RetSqlName("ACB")+" ACB "
	cSQL += "               ON ACB_FILIAL = "+ValToSql(xFilial("ACB"))+" "
	cSQL += "                  AND ACB_CODOBJ = AC9_CODOBJ "
	cSQL += "                  AND ACB.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  AC9_FILIAL = "+ValToSql(xFilial("AC9"))+" "
	cSQL += "       AND AC9_ENTIDA = 'SC7' "
	cSQL += "       AND AC9_FILENT = "+ValToSql(SC7->C7_FILIAL)+" "
	cSQL += "       AND SUBSTRING(AC9_CODENT,1,8) = "+ValToSql(SC7->C7_FILIAL+SD1->D1_PEDIDO)+" "
	cSQL += "       AND AC9.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		If Upper( SubStr( (cTRB)->ACB_OBJETO, 1, 14 ) ) $ cString
			nP := At( '_V', Upper( (cTRB)->ACB_OBJETO ) )
			If nP > 0
				cObjeto := SubStr( (cTRB)->ACB_OBJETO, 1, nP-1 )
				nQ := AScan( aAnexo, cObjeto )
				If nQ == 0
					AAdd( aAnexo, RTrim( (cTRB)->ACB_OBJETO ) )
				Else
					aAnexo[ nQ ] := RTrim( (cTRB)->ACB_OBJETO )
				Endif
			Endif
		Endif
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
Return

//-----------------------------------------------------------------------------------
// Rotina | A470Anexo | Autor | Robson Gonçalves                 | Data | 09.02.2017 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para buscar todos os anexos do PC e NFE.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A470Anexo( cEntidade, cFilEnt, cKey, aAnexo )
	Local cSQL := ''
	Local cTRB := GetNextAlias()

	cSQL := "SELECT ACB_OBJETO "
	cSQL += "FROM   "+RetSqlName("AC9")+" AC9 "
	cSQL += "       INNER JOIN "+RetSqlName("ACB")+" ACB "
	cSQL += "               ON ACB_FILIAL = "+ValToSql(xFilial("ACB"))+" "
	cSQL += "                  AND ACB_CODOBJ = AC9_CODOBJ "
	cSQL += "                  AND ACB.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  AC9_FILIAL = "+ValToSql(xFilial("AC9"))+" "
	cSQL += "       AND AC9_ENTIDA = " + ValToSql( cEntidade ) + " "
	cSQL += "       AND AC9_FILENT = "+ValToSql(cFilEnt)+" "
	cSQL += "       AND AC9_CODENT = "+ValToSql(cKey)+" "
	cSQL += "       AND AC9.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
					
	While (cTRB)->( .NOT. EOF() )
		AAdd( aAnexo, RTrim( (cTRB)->ACB_OBJETO ) )
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
Return