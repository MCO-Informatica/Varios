#Include 'protheus.ch'
#Include 'fwmvcdef.ch'

/*/{Protheus.doc} CSFA886
//Rotina para visualizar registros da integra��o RN x P12 Libera��o de Pagamento.
@author robson.goncalves - Rleg.
@since 08/11/2018
@version 1.0
/*/
User Function CSFA886()	
	Local oBrowse
	
	oBrowse := FwMBrowse():New()
	oBrowse:SetAlias( 'PBP' )
	oBrowse:SetDescription( 'Integra��o Protheus x RightNow - Libera��o/Identifica��o de Pagamento' )
	oBrowse:DisableDetails()
	
	/*
	0 = INCLU�DO.........................[white]
	1 = PAGAMENTO IDENTIFICADO...........[green]
	2 = PAGAMENTO N�O IDENTIFICADO.......[red]
	3 = AGUARDANDO FOLLOW-UP FINANCEIRO..[yellow]
	4 = AGUARDANDO FOLLOW-UP SEGURAN�A...[blue]
	5 = FINANCEIRO EM NEGOCIA��O.........[pink]
	6 = SEGURAN�A EM NEGOCIA��O..........[black]
	9 = ENCERRADO (FIN/SEG)..............[orange]
	*/
	oBrowse:AddLegend( 'PBP_STATUS="0"', 'WHITE' , '0=Inserido (n�o processado).' )
	oBrowse:AddLegend( 'PBP_STATUS="1"', 'GREEN' , '1=Pagamento identificado.' )
	oBrowse:AddLegend( 'PBP_STATUS="2"', 'RED'   , '2=Pagamento n�o identificado.' )
	oBrowse:AddLegend( 'PBP_STATUS="3"', 'YELLOW', '3=Aguardando follow-up do financeiro.' )
	oBrowse:AddLegend( 'PBP_STATUS="4"', 'BLUE'  , '4=Aguardando follow-up de seguran�a.' )
	oBrowse:AddLegend( 'PBP_STATUS="5"', 'PINK'  , '5=Financeiro em negocia��o.' )
	oBrowse:AddLegend( 'PBP_STATUS="6"', 'BLACK' , '6=Seguran�a em negocia��o' )
	oBrowse:AddLegend( 'PBP_STATUS="9"', 'ORANGE', '9=Pend�ncia encerrada (Fin/Seg)' )
	
	oBrowse:Activate()
Return

/*/{Protheus.doc} MenuDef
//Define as opera��es quer ser�o realizadas pela aplica��o.
@author robson.goncalves - Rleg.
@since 08/11/2018
@version 1.0
/*/
Static Function MenuDef()
	Local aRotina := {}
	Local aSubFin := {}
	Local aSubSeg := {}
	Local cMV_886_01 	:= 'MV_886_01'
	Local cMV_886_02 	:= 'MV_886_02'
	
	If .NOT. GetMv( cMV_886_01, .T. )
		CriarSX6( cMV_886_01, 'C', 'USUARIOS FINANCEIRO PARA ACESSO A ROTINA. CSFA886.','000000;002517' )
	Endif

	If .NOT. GetMv( cMV_886_02, .T. )
		CriarSX6( cMV_886_02, 'C', 'USUARIOS SEGURANCA PARA ACESSOA ROTINA. CSFA886.','000000' )
	Endif
	
	cMV_886_01 	:= GetMv(cMV_886_01)
	cMV_886_02 	:= GetMv(cMV_886_02)
	
	IF __cUserID $ cMV_886_01 //Usu�rio financeiro
		ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.CSFA886'	OPERATION 2 ACCESS 0
		ADD OPTION aRotina TITLE 'Negociar'		ACTION 'U_A886FNEG'			OPERATION 3 ACCESS 0
		ADD OPTION aRotina TITLE 'Encerrar'		ACTION 'U_A886FENC'      	OPERATION 4 ACCESS 0
		ADD OPTION aRotina TITLE 'Transferir'	ACTION 'U_A886TRANSF'    	OPERATION 2 ACCESS 0
		ADD OPTION aRotina TITLE 'Relat�rio'	ACTION 'U_A886R01'   		OPERATION 2 ACCESS 0
	ElseIF __cUserID $ cMV_886_02 //Usu�rio Seguran�a
		ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.CSFA886'	OPERATION 2 ACCESS 0
		ADD OPTION aRotina TITLE 'Auditoria'	ACTION 'U_A886SAUD'			OPERATION 4 ACCESS 0
		ADD OPTION aRotina TITLE 'Encerrar'		ACTION 'U_A886SENC'      	OPERATION 5 ACCESS 0
		ADD OPTION aRotina TITLE 'Transferir'	ACTION 'U_A886TRANSF'    	OPERATION 2 ACCESS 0
		ADD OPTION aRotina TITLE 'Relat�rio'	ACTION 'U_A886R01'   		OPERATION 2 ACCESS 0
	EndIF

Return( aRotina )

/*/{Protheus.doc} ModelDef
//Define a regra de neg�cios.
@author robson.goncalves - Rleg.
@since 08/11/2018
@version 1.0
/*/
Static Function ModelDef()
	Local oModel 
	Local oStruc
	
	oModel := MPFormModel():New('A886VIEW')
	
	oStruc := FWFormStruct( 1, 'PBP' )
	
	oModel:AddFields( 'PBPMASTER', /*cOwner*/, oStruc )
	oModel:SetDescription('Libera��o/Identifica��o de Pagamento')
	oModel:SetPrimaryKey( { 'PBP_FILIAL', 'PBP_PSITE', 'DTOS(PBP_DATA)', 'PBP_HORA' } )
	oModel:GetModel('PBPMASTER'):SetDescription('Libera��o/Identifica��o de Pagamento')
Return( oModel )

/*/{Protheus.doc} ViewDef
//Define como ser� a interface e portanto como o usu�rio interage com o modelo de dados.
@author robson.goncalves - Rleg.
@since 08/11/2018
@version 1.0
/*/
Static Function ViewDef()
	Local oModel 
	Local oStruct
	Local oView
	
	oModel := FWLoadModel( 'CSFA886' )
	
	oStruct := FWFormStruct( 2, 'PBP' )
	
	oStruct:AddGroup( 'id1', 'a) Entrega do RightNow',                                'TELA', 2 )
	oStruct:AddGroup( 'id2', 'b) XML enviado para o HUB',                             'TELA', 2 )
	oStruct:AddGroup( 'id3', 'c) LOG de processamento de identifica��o',              'TELA', 2 )
	oStruct:AddGroup( 'id4', 'd) Registros de Follow-up - Financeiro e/ou Seguran�a', 'TELA', 2 )
	
	oStruct:SetProperty( '*',          MVC_VIEW_GROUP_NUMBER, 'id1' ) //todos os campos
	oStruct:SetProperty( 'PBP_ENVIAD', MVC_VIEW_GROUP_NUMBER, 'id2' ) //campo memo
	oStruct:SetProperty( 'PBP_TENT1',  MVC_VIEW_GROUP_NUMBER, 'id3' ) //campo numerico
	oStruct:SetProperty( 'PBP_TENT2',  MVC_VIEW_GROUP_NUMBER, 'id3' ) //campo numerico
	oStruct:SetProperty( 'PBP_LOG',    MVC_VIEW_GROUP_NUMBER, 'id3' ) //campo memo
	oStruct:SetProperty( 'PBP_FOLLOW', MVC_VIEW_GROUP_NUMBER, 'id4' ) //campo memo
	
	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField( 'VIEW_PBP', oStruct, 'PBPMASTER' )
	oView:CreateHorizontalBox('MODELO1', 100 )
	oView:SetOwnerView('VIEW_PBP', 'MODELO1' )
	
Return( oView )

/******
 *
 * FINANCEIRO ABRE NEGOCIA��O.
 *
 */
User Function A886FNEG()
	Local cMotivo := Space( 1000 )
	If PBP->PBP_STATUS $ '2|3|5'
		If ReportCause( @cMotivo )
			UpdStatus( '5', 'FINANCEIRO EM NEGOCIACAO', 'negocia��o financeira', cMotivo )
		Endif
	Else
		MsgAlert('Somente libera��o de pagamento n�o identificado (status=2 ou 5) pode negociar com o financeiro.','Negocia��o financeira' )
	Endif
Return

/******
 *
 * FINANCEIRO ENCERRA A PEND�NCIA.
 *
 */
User Function A886FENC()
	Local cMotivo := Space( 1000 )
	If PBP->PBP_STATUS == '5'
		If ReportCause( @cMotivo )
			UpdStatus( '9', 'ENCERRADO PELO FINANCEIRO', 'encerramento financeiro', cMotivo )
		Endif
	Else
		MsgAlert('Somente libera��o de pagamento em negocia��o com o financeiro (status=5) ser� encerrado pelo financeiro.','Encerramento de pend�ncia' )
	Endif
Return

/******
 *
 * SEGURAN�A ABRE NEGOCIA��O.
 *
 */
User Function A886SAUD()
	Local cMotivo := Space( 1000 )
	If PBP->PBP_STATUS $ '2|3|6'
		If ReportCause( @cMotivo )
			UpdStatus( '6', 'SEGURANCA EM NEGOCIACAO', 'auditoria', cMotivo )
		Endif
	Else
		MsgAlert('Somente libera��o de pagamento sem follow-up financeiro (status=3 ou 6) pode ser auditado pela seguran�a.','Auditoria' )
	Endif
Return

/******
 *
 * SEGURAN�A ENCERRA A PEND�NCIA.
 *
 */
User Function A886SENC()
	Local cMotivo := Space( 1000 )
	If PBP->PBP_STATUS $ '3|4|6'
		If ReportCause( @cMotivo )
			UpdStatus( '9', 'ENCERRADO PELA SEGURANCA', 'encerramento seguran�a', cMotivo )
		Endif
	Else
		MsgAlert('Somente libera��o de pagamento em auditoria (status=6) ser� encerrado pela seguran�a.','Encerramento de pend�ncia' )
	Endif
Return

Static Function UpdStatus( cStatusDest, cDescricao, cTexto, cMotivo )
	Local cResp := Dtoc( Date() ) + '-' + Time() + '-' + Upper( RTrim( UsrFullName( RetCodUsr() ) ) )
	PBP->( RecLock( 'PBP', .F. ) )
	If PBP->PBP_STATUS <> cStatusDest
		PBP->PBP_STATUS := cStatusDest
		PBP->PBP_DESCRI := cDescricao
	Endif
	PBP->PBP_FOLLOW := cResp + ' registrou a informa��o abaixo como ' + cTexto + '. [Follow-up: ' + Alltrim( cMotivo ) + '] ' + Iif( Empty( PBP->PBP_FOLLOW ), '', CRLF + AllTrim( PBP->PBP_FOLLOW ) )
	PBP->( MsUnLock() )
Return

Static Function ReportCause( cMotivo )
	Local lReturn := .F.
	Local oDlg
	Local oGet 
	Local oGrv
	Local oSair 
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 200, 400 TITLE 'Registrar follow-up' PIXEL OF oMainWnd STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		oGet := TMultiGet():New( 4, 3, {| u | Iif( PCount() > 0, cMotivo := u, cMotivo ) }, oDlg, 193, 71,,,,,,.T.,,,,,,,,,,,, 'Digite o follow-up:', 1 )
		@ 86,112 BUTTON oGrv;
		         PROMPT 'Gravar';
		         SIZE 40,11 PIXEL OF oDlg;
		         ACTION (Iif(Empty( cMotivo ),;
		         MsgAlert('� obrigat�rio informar o follow-up para registro','Follow-up'),(nOpc:=1,lReturn:=.T.,oDlg:End())))
		@ 86,156 BUTTON oSair;
		         PROMPT 'Sair';
		         SIZE 40,11 PIXEL OF oDlg; 
		         ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED
Return( lReturn )

/*
User Function A886LPM( cAlias, nRecNo, nOpc )
	Local aButton := {}
	Local aSay := {}
	
	Local cCadastro := 'Libera��o Manual'
	
	Local nOpcao := 0
	
	AAdd( aSay, 'Esta rotina possibilita enviar para o HUB os dados de Libera��o de Pagamento,' )
	AAdd( aSay, 'estes dados foram inclu�dos pela integra��o com a ferramenta de atendimento ao ' )
	AAdd( aSay, 'cliente utilizada pelo SAC.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		If MsgYesNo( 'Confirma a execu��o da libera��o de pagamento manual para fila do HUB?', cCadastro )
			A886Lib()
		Endif
	Endif
Return
*/
/*
Static Function A886Lib()
	Local cLog := ''
	Local cMsgLog := ''
	Local cName := ''
	Local cUser := ''
	Local cUserName := ''
	Local nP := 0
	
	If PBP->PBP_STATUS == '0'
		U_RnLibPag( RTrim( PBP->PBP_PSITE ), AllTrim( PBP->PBP_ENVIAD ) )
		
		cUser := RetCodUsr()
		cUserName := Upper( RTrim( UsrFullName( cUser ) ) )
		
		nP := At(' ', cUserName )
		
		If nP > 0
			cName := Capital( SubStr( cUserName, 1, At(' ', cUserName )-1 ) )
		Else
			cName := Capital( cUserName )
		Endif
		
		cMsgLog := Dtoc( Date() ) + ' ' + Time() + ' ENVIO DE LIBERA��O DE PAGAMENTO MANUAL EFETUADO POR [' + cUser + '-' + cUserName + '].'
		
		If .NOT. Empty( PBP->PBP_LOG )
			cLog := cMsgLog + CRLF + AllTrim( PBP->PBP_LOG )
		Else
			cLog := cMsgLog 
		Endif
		
		PBP->( RecLock( 'PBP', .F. ) )
		PBP->PBP_LOG := cLog
		PBP->( MsUnLock() )
		
		MsgInfo( cName + ', o processo de libera��o de pagamento foi iniciado, por favor, verifique no HUB a mensagem "NOTIFICA-STATUS-PEDIDO".', 'Libera��o solicitada para HUB' )
	Else
		MsgAlert( 'Somente com status "INCLU�DO" que � poss�vel enviar a libera��o de pagamento para o HUB.', 'N�o posso enviar' )
	Endif
Return
*/
User Function A886TRANSF()
	Local aButton := {}
	Local aSay := {}
	Local aStatus := {}
	
	Local cLog := ''
	Local cResp := ''
	
	Local nOpcao := 0
	
	Local p := 0
	
	Private cCadastro := ''
	
	If PBP->PBP_STATUS $ '5|6'
		cCadastro := 'Transfer�ncia de responsabilidade'
		
		AAdd( aSay, 'O registro em quest�o onde est� posicionado ser� transferido' )
		AAdd( aSay, 'para �rea ' + Iif( PBP->PBP_STATUS == '5', 'seguran�a/auditoria', 'financeiro') + '.' )
		AAdd( aSay, '' )
		AAdd( aSay, 'Seguir com a transfer�ncia de responsabilidade?' )
		AAdd( aSay, '' )
		AAdd( aSay, '' )
		AAdd( aSay, 'Clique em OK para prosseguir...' )
		
		AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
		AAdd( aButton, { 22, .T., { || FechaBatch() } } )
		
		FormBatch( cCadastro, aSay, aButton )
		
		If nOpcao == 1
			If MsgYesNo( 'Ao confirmar a transfer�ncia de responsabilidade ser� registrado sua a��o. Prosseguir?', cCadastro )
				
				//[1] De.
				//[2] Para.
				//[3] Descri��o do status para.
				AAdd( aStatus, { '5', '6', 'SEGURANCA EM NEGOCIACAO' } )
				AAdd( aStatus, { '6', '5', 'FINANCEIRO EM NEGOCIACAO' } )
				
				p := AScan( aStatus, {|e| e[ 1 ] == PBP->PBP_STATUS } )
				
				cResp := Dtoc( Date() ) + '-' + ;
				         Time() + '-' + ;
				         RetCodUsr() + '-' + ;
				         Upper( RTrim( UsrFullName( RetCodUsr() ) ) ) + ;
				         ' transferiu a responsabilidade de negocia��o para �rea ' + ;
				         Iif( PBP->PBP_STATUS == '5', '6-SEGURAN�A/AUDITORIA', '5-FINANCEIRA' ) + '.'
				
				If Empty( PBP->PBP_LOG )
					cLog := cResp
				Else
					cLog := cResp + CRLF + AllTrim( PBP->PBP_LOG ) 
				Endif
				
				PBP->( RecLock( 'PBP', .F. ) )
				PBP->PBP_STATUS := aStatus[ p, 2 ]
				PBP->PBP_DESCRI := aStatus[ p, 3 ]
				PBP->PBP_LOG    := cLog
				PBP->( MsUnLock() )
				
				MessageBox( 'Opera��o de transfer�ncia realizada com sucesso.', cCadastro, 0 )
			Endif
		Endif
	Else
		MsgAlert('Somente registro com STATUS 5 ou 6 pode ser transferido responsabilidade entre �reas.','N�o pode transferir')
	Endif
Return


User Function A886R01()
	Local aRet   	:= {}
	Local aStatus 	:= {'0=Inserido(n�o processado)','1=Pagamento identificado','2=Pagamento n�o identificado',;
						'3=Aguardando follow-up do financeiro','4=Aguardando follow-up de seguran�a','5=Financeiro em negocia��o',;
						'6=Seguran�a em negocia��o','9=Pend�ncia encerrada (Fin/Seg)','7=Todos'}
	Local aParamBox := {}

	Private cTitulo := "Status Libera��o Pagamento"
	
	AAdd(aParamBox,{1,'Data de emiss�o de ' 	,Ctod(Space(8))	,'','','','',50,.F.})
	AAdd(aParamBox,{1,'Data de emiss�o at� ' 	,dDataBase		,'','','','',50,.T.})
	AAdd(aParamBox,{2,'Status '					,1,aStatus,115,'',.F.})
	
	If ParamBox(aParamBox,"Par�metros...",aRet)
		aRET[ 3 ] := Iif( ValType(aRET[ 3 ])=="N", '0', cValTochar( aRet[3] ) )
		FWMsgRun(, {|| A886QRY( aRet ) },cTitulo,'Gerando excel, aguarde...')
	EndIF
Return

Static Function A886QRY( aRet )
	Local cSQL	:= ''
	Local cTRB	:= ''

	cSQL := " SELECT * FROM "+RetSqlName("PBP")
	cSQL += " WHERE  D_E_L_E_T_ = ' ' "
	cSQL += " AND PBP_DATA >= '" + dToS( aRET[ 1 ] ) + "' "
	cSQL += " AND PBP_DATA <= '" + dToS( aRET[ 2 ] ) + "' "
	If aRET[ 3 ] <> '7'
		cSQL += " AND PBP_STATUS = '" + aRET[ 3 ] + "' "
	EndIf
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery(cSQL)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	
	TcSetField( cTRB, "PBP_DATA"   , "D", 8 )

	IF (cTRB)->( !EOF() )
		A886EXC( cTRB )
	Else
        (cTRB)->( dbCloseArea() )
	    FErase( cTRB + GetDBExtension() )
        MsgInfo('N�o h� dados para extra��o conforme par�metros informados.',cTitulo)
    EndIF
Return

Static Function A886EXC( cAliasA )
	Local cWorkSheet	:= 'LogLib'
	Local cTable     	:= 'Libera��es de Pagamento - RightNow'
	Local oExcel     	:= Nil
	Local cPath      	:= GetTempPath() //Fun��o que retorna o caminho da pasta temp do usu�rio logado, exemplo: %temp%
	Local cNameFile  	:= cPath + cTable + ".XML"
	Local lSC5			:= .F.
	Local lSE1			:= .F.
	Local aPED			:= {}
	
	oExcel := FWMSEXCEL():New() //M�todo para gera��o em XML

	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela

	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >     , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Site" 	, 1     , 1     , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "ID RN" 			, 1     , 1     , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data" 			, 1     , 4     , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Hora" 			, 1     , 1     , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Status" 			, 1     , 1     , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Desc.Status" 	, 1     , 1     , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "ID User" 		, 1     , 1     , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nome User"		, 1     , 1	    , .F. )

	oExcel:AddColumn( cWorkSheet, cTable, "Pedido ERP"		, 1     , 1	    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido GAR"		, 1     , 1	    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Emiss�o Pedido"  , 1     , 4	    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cod. Cliente"	, 1     , 1	    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nome Cliente"	, 1     , 1	    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Emiss�o T�tulo"	, 1     , 4	    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vencto T�tulo"	, 1     , 4	    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor T�tulo"	, 1     , 3	    , .T. )

	//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formata��o ( 1-General,2-Number,3-Monet�rio,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada
	
	dbSelectArea( 'SE1' )
	SE1->( dbSetOrder( 1 ) )
	
	dbSelectArea( 'SC5' )
	If FindNickName( 'SC5', 'PEDSITE' )
		SC5->( dbOrderNickName( 'PEDSITE' ) )
	Endif

	(cAliasA)->( dbGotop() )
	While (cAliasA)->(!Eof())
		// Tentar localizar o pedido protheus com o pedido site.
		lSC5 := SC5->( dbSeek( xFilial( 'SC5' ) + (cAliasA)->PBP_PSITE ) )
		// Se achou, tentar localizar o t�tulo a receber.
		If lSC5
			lSE1 := SE1->( dbSeek( xFilial( 'SE1' ) + 'RCP' + SC5->C5_NUM ) )
			IF .NOT. lSE1
				lSE1 := SE1->( dbSeek( xFilial( 'SE1' ) + 'RCO' + SC5->C5_NUM ) )
			EndIF	
		Endif

		aPED := Array( 8 )
		aFill( aPED, '' )
		
		// Se acho pedido protheus e achou o t�tlo a receber.
		IF lSC5 .AND. lSE1
			aPED[ 1 ] := SC5->C5_NUM
			aPED[ 2 ] := SC5->C5_CHVBPAG
			aPED[ 3 ] := SC5->C5_EMISSAO
			aPED[ 4 ] := SC5->C5_CLIENTE
			aPED[ 5 ] := rTrim( SE1->E1_NOMCLI )
			aPED[ 6 ] := SE1->E1_EMISSAO
			aPED[ 7 ] := SE1->E1_VENCREA
			aPED[ 8 ] := SE1->E1_VALOR
		EndIF

		oExcel:AddRow( cWorkSheet, cTable, { (cAliasA)->PBP_PSITE, (cAliasA)->PBP_ID_RN, (cAliasA)->PBP_DATA, (cAliasA)->PBP_HORA,;
											 (cAliasA)->PBP_STATUS,(cAliasA)->PBP_DESCRI, (cAliasA)->PBP_ID_USR,(cAliasA)->PBP_NOMUSR,;
											 aPED[1], aPED[2], aPED[3], aPED[4], aPED[5], aPED[6], aPED[7], aPED[8] } )

	(cAliasA)->( dbSkip() )
	End

	(cAliasA)->( dbCloseArea() )
	FErase( cAliasA + GetDBExtension() )

	oExcel:Activate()              //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diret�rio

	ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela ap�s salvar
Return