//--------------------------------------------------------------------------
// Rotina | CSFA710    | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de workflow de solicita��o de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'
#Include "Ap5Mail.ch"

#DEFINE cFONT   '<b><font size="4" color="blue"><b>'
#DEFINE cFONT_V '<b><font size="4" color="red"><b>'
#DEFINE cNOFONT '</b></font></b> '

User Function CSFA710( cC1_NUM, cOrigem, lJobNotify, cNewLink )
	Local lAProvSI := GetNewPar( 'MV_APROVSI', .F. )
	Local lTrb := .T.
	Local lAK_MSBLQL := .F.
	Local lEmpty := .F.
	Local lSeek := .F.
	
	Local cTRB := ''
	Local cSQL := ''
	Local cC1_EMISSAO := ''
	Local cC1_CC := ''
	Local cGrpAprov := ''
	Local cAK_USER := ''
	Local cMsg := ''
	Local cC1_SOLICIT := ''
	Local cC1_CC_Sub := ''
	Local cAprovSubst := ''
	
	Local lContinua := .T.
	
	Local nC := 0
	Local nP := 0
	Local nTamElem := 0
	Local nQtosCCust := 0
	Local nLocalizei := 0
	
	Local aArea := {}
	Local aItens := {}
	Local aCCUSTO := {}
	Local aMailID := {}
	Local aTroca := {}
	Local aRATEIO := {}
	
	Local cMV_710_01 := 'MV_710_01'
	Local cC1_MAIL_ID := ''
	
	Private cAK_COD := ''
	
	DEFAULT cNewLink := ''
	DEFAULT lJobNotify := .F.
	
	aArea := SC1->( GetArea() )
	
	// Verificar se a solicita��o de compras est� em condi��es para enviar WF de aprova��o.
	If SC1->(FieldPos('C1_TIPO'))>0 .And. SC1->C1_TIPO == 2
		Help(' ',1,'A113TIPO')
		SC1->( RestArea(aArea) )
		Return
	Endif
	
	If .NOT. GetMv( cMV_710_01, .T. )
		CriarSX6( cMV_710_01, 'C', 'ENDERECO PARA O LINK NO E-MAIL DE AVISO DE APROVACAO DE SC - ROTINA CSFA710.prw', '' )
	Endif
	
	cMV_710_01 := GetMv( cMV_710_01, .F. )
	
	// Antes de qualquer a��o verificar se no centro de custo de cada item possui grupo de aprovador.
	SC1->( dbSeek( xFilial( 'SC1' ) + cC1_NUM ) )
	While SC1->( .NOT. EOF() ) .And. SC1->C1_FILIAL == xFilial('SC1') .And. SC1->C1_NUM == cC1_NUM
		If SoftLock( 'SC1' ) ;
		    .And. SC1->C1_APROV $ 'B,R, ' ;
			.And. SC1->C1_QUJE == 0 ;
			.And. IIf( lAProvSI ,( Empty( SC1->C1_COTACAO ) .OR. SC1->C1_COTACAO == 'IMPORT' ), Empty( SC1->C1_COTACAO ) ) ;
			.And. Empty( SC1->C1_RESIDUO )
			
			// 1=Sim;2=Nao
			If SC1->C1_RATEIO == '1'
				SC1->( AAdd( aRATEIO, { SC1->( RecNo()), C1_ITEM, C1_PRODUTO, RTrim( C1_DESCRI ) } ) )
			Else
				CTT->( dbSetOrder( 1 ) )
				CTT->( dbSeek( xFilial( 'CTT' ) + SC1->C1_CC ) )
				
				cGrpAprov := A710CpoCC()
				cGrpAprov := 'CTT->' + cGrpAprov
				cGrpAprov := &( cGrpAprov )
				
				// H� defini��o de qual campo capturar o c�digo do grupo de aprovadores?
				If Empty( cGrpAprov )
					ApMsgAlert( 'N�o foi poss�vel localizar a defini��o do campo para capturar o c�digo do grupo de aprovadores, n�o ser� poss�vel prosseguir.','CSFA710')
					lContinua := .F.
					Exit
				Endif
				
				// O grupo de aprova��o existe com n�vel 01?
				cSQL := "SELECT COUNT(*) nExiste " 
				cSQL += "FROM   "+RETSQLNAME('SAL')+" "
				cSQL += "WHERE  AL_FILIAL = "+ValToSql(xFilial("SAL"))+" "
				cSQL += "       AND AL_COD = "+ValToSql(cGrpAprov)+" "
				cSQL += "       AND AL_NIVEL = '01' "
				cSQL += "       AND AL_MSBLQL <> '1' "
				cSQL += "       AND D_E_L_E_T_ = ' ' "
				
				cSQL := ChangeQuery( cSQL )
				cTRB := 'TRB_SAL'
				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
				
				If	(cTRB)->nExiste == 0
					(cTRB)->( dbCloseArea() )
					ApMsgAlert( 'N�o foi poss�vel localizar o grupo de aprova��o '+cGrpAprov+;
					' no centro de custo '+RTrim( SC1->C1_CC )+' desta solicita��o de compras. Portanto n�o ser� poss�vel ennviar o workflow de aprova��o.','CSFA710' )
					lContinua := .F.
					Exit			
				Endif
				
				(cTRB)->( dbCloseArea() )
			Endif
		Endif
		SC1->( dbSkip() )
	End
	
	// Se n�o localizou grupo de aprova��o, sair.
	If .NOT. lContinua
		Return
	Endif
	
	// Se h� rateio, questionar o usu�rio.
	If Len( aRATEIO ) > 0 .AND. .NOT. lJobNotify
		If A710Rateio( aRATEIO, @cC1_CC_Sub )
			A710UpdCC( aRATEIO, 1, cC1_CC_Sub ) 
		Else
			ApMsgAlert('Voc� optou em abandonar a rotina, para prosseguir � preciso informar o centro de custo de aprova��o.','Centro de custo de aprova��o')
			Return
		Endif
	Endif
	
	SC1->( dbSetOrder( 1 ) )
	SC1->( dbSeek( xFilial( 'SC1' ) + cC1_NUM ) )
	While SC1->( .NOT. EOF() ) .And. SC1->C1_FILIAL == xFilial('SC1') .And. SC1->C1_NUM == cC1_NUM
		If SoftLock( 'SC1' ) ;
			.And. SC1->C1_APROV $ 'B,R, ' ;
			.And. SC1->C1_QUJE == 0 ;
			.And. IIf( lAProvSI ,( Empty( SC1->C1_COTACAO ) .OR. SC1->C1_COTACAO == 'IMPORT' ), Empty( SC1->C1_COTACAO ) ) ;
			.And. Empty( SC1->C1_RESIDUO )
			
			If cC1_SOLICIT == ''
				PswOrder( 2 )
				PswSeek( SC1->C1_SOLICIT )
				cC1_SOLICIT := RTrim( PswRet( 1 )[ 1, 4 ] ) + ' (' + RTrim( SC1->C1_SOLICIT ) + ')'
			Endif
			
			If Empty( cC1_EMISSAO )
				cC1_EMISSAO := Dtoc( SC1->C1_EMISSAO )
			Endif
			
			If cC1_CC <> SC1->C1_CC
				nQtosCCust++
				cC1_CC := SC1->C1_CC
				// O centro de custo em quest�o j� est� no vetor?
				// O objetivo � otimizar a busca do usu�rio por centro de custo.
				nP := AScan( aItens, {|e| e[ 6 ] == cC1_CC } )
			Endif
			
			// N�o. Ent�o localizar o centro de custo, o grupo de aprova��o pontual e os dados do usu�rio aprovador do primeiro n�vel.
			If nP == 0
				CTT->( dbSetOrder( 1 ) )
				CTT->( dbSeek( xFilial( 'CTT' ) + SC1->C1_CC ) )
				
				cGrpAprov := A710CpoCC()
				cGrpAprov := 'CTT->' + cGrpAprov
				cGrpAprov := &( cGrpAprov )
				
				cSQL := "SELECT AL_COD, "               // C�digo do grupo de aprovadores.
				cSQL += "       AK_COD, "               // C�digo do aprovador.
				cSQL += "       AK_USER, "              // C�digo do usu�rio aprovador.
				cSQL += "       AK_APROSUP, "           // C�digo do aprovador superior.
				cSQL += "       AK_VINCULO, "           // C�digo da matr�cula do aprovador.
				cSQL += "       AK_MSBLQL "             // Indica se o registro est� bloqueado.
				cSQL += "FROM   "+RetSqlName('SAL')+" SAL "
				cSQL += "       INNER JOIN "+RetSqlName('SAK')+" SAK "
				cSQL += "               ON AK_FILIAL = "+ValtoSql( xFilial( 'SAK' ) )+" " 
				cSQL += "              AND AK_COD = AL_APROV "
				cSQL += "              AND AK_USER = AL_USER "
				
				//-----------------------------------------------------
				// Esta condi��o ser� analisada na leitura do registro.
				// cSQL += "              AND AK_MSBLQL <> '1' "
				//-----------------------------------------------------
				
				cSQL += "              AND SAK.D_E_L_E_T_ = ' ' " 
				cSQL += "WHERE  AL_FILIAL = "+ValtoSql( xFilial( 'SAL' ) )+" " 
				cSQL += "       AND AL_COD = " + ValToSql( cGrpAprov ) + " "
				cSQL += "       AND AL_MSBLQL <> '1' "
				cSQL += "       AND AL_NIVEL = '01' "
				cSQL += "       AND SAL.D_E_L_E_T_ = ' ' "
				
				cSQL := ChangeQuery( cSQL )
				cTRB := GetNextAlias()
				
				dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
				
				If (cTRB)->(.NOT. BOF()) .AND. (cTRB)->(.NOT.EOF())
				
					// O usu�rio aprovador est� bloqueado?
					If (cTRB)->AK_MSBLQL == '1'
						lAK_MSBLQL := .T.
					Endif
					
					// O usu�rio aprovador tem superior?
					If Empty( (cTRB)->AK_APROSUP )
						lEmpty := .T.
					Endif
					
					// Se o aprovador est� bloqueado ou n�o h� aprovador superior.
					If lAK_MSBLQL .AND. lEmpty
						ApMsgAlert(cFONT_V+'ATEN��O'+cFONT+'<br><br>O aprovador '+(cTRB)->AK_COD+;
						' est� bloqueado e sem aprovador superior, logo n�o ser� poss�vel enviar workflow.'+cNOFONT,;
						'WF-SC/ITEM '+SC1->( C1_NUM + '/' + C1_ITEM ))
						
						(cTRB)->( dbCloseArea() )
						SC1->( dbSkip() )
						Loop
					Endif
					
					// Se o usu�rio aprovador est� bloqueado e h� aprovador superior.
					If lAK_MSBLQL .AND. .NOT. lEmpty
						SAK->( dbSetOrder( 1 ) )
						lSeek := SAK->( MsSeek( xFilial( 'SAK' ) + (cTRB)->AK_APROSUP ) )
						// Se n�o localizou o usu�rio aprovador superior.
						If .NOT. lSeek
							ApMsgAlert(cFONT_V+'ATEN��O'+cFONT+'<br><br>O aprovador '+(cTRB)->AK_APROSUP+;
							' � superior do aprovador '+(cTRB)->AK_COD+;
							' e este superior n�o foi localizado como aprovador, logo n�o ser� poss�vel enviar workflow.'+cNOFONT,;
							'WF-SC/ITEM '+SC1->( C1_NUM + '/' + C1_ITEM ))
							
							(cTRB)->( dbCloseArea() )
							SC1->( dbSkip() )
							Loop
						Else
							lTrb := .F.
							AAdd( aTroca, 'Item ' + SC1->C1_ITEM + ' enviado WF p/ ' + A710NomUsr( SAK->AK_USER ) +;
							' do C.Custo ' + RTrim( SC1->C1_CC ) + ' porque o aprovador ' + A710NomUsr( (cTRB)->AK_USER ) + ' est� bloqueado.' )
						Endif
					Endif
					
					//-----------------------------------
					// H� c�digo de aprovador substituto?
					//-----------------------------------
					If .NOT. Empty( SC1->C1_ORCAM )
						cAprovSubst := RTrim( SC1->C1_ORCAM )
						SAK->( dbSetOrder( 1 ) )
						SAK->( MsSeek( xFilial( 'SAK' ) + cAprovSubst ) )
					Endif
					
					// Antes de buscar os dados do usu�rio aprovador,
					// procurar saber se ele est� presente na empresa,
					// pois talves seja necess�rio buscar os dados do 
					// seu superior informado no cadastro de aprovador.
					If cAprovSubst == ''
						aFerias    := A710Ferias( cTRB, @aTroca, lTrb )
					Else
						aFerias    := A710Ferias( NIL, @aTroca, .F. )
					Endif
					
					cAK_USER   := aFerias[ 1 ]
					nLocalizei := aFerias[ 2 ] // 0=Aprovador; 1=Superior; 2=F�rias.
					
					PswOrder( 1 )
					PswSeek( cAK_USER )
					aPswRet := PswRet()
					
					SC1->( AAdd( aItens, { C1_PRODUTO,;                   //  1 C�digo do produto
					                       C1_DESCRI,;                    //  2 Descri��o do produto
					                       C1_UM,;                        //  3 Unidade de medida
					                       C1_QUANT,;                     //  4 Quantidade
					                       C1_OBS,;                       //  5 Observa��o
					                       C1_CC,;                        //  6 Centro de custo
					                       C1_CONTA,;                     //  7 Conta cont�bil
					                       cC1_SOLICIT,;                  //  8 Solicitante
					                       cAK_USER,;                     //  9 C�digo do usu�rio aprovador
					                       aPswRet[ 1, 2 ],;              // 10 Login do usu�rio aprovador
					                       RTrim( aPswRet[ 1, 4 ] ),;     // 11 Nome do usu�rio aprovador
					                       RTrim( aPswRet[ 1, 14 ] ),;    // 12 E-mail do aprovador aprovador
					                       C1_ITEM,;                      // 13 Item da solicita��o de compras
					                       nLocalizei,;                   // 14 Identifica��o para saber se aprovador est� presente
					                       SC1->( RecNo() ),;             // 15 N� do recno do registro para reposicionamento
					                       cAK_COD } ) )                  // 16 C�digo do aprovador em quest�o.
					                       
				Endif
				(cTRB)->( dbCloseArea() )
			Else
		   	SC1->( AAdd( aItens, { C1_PRODUTO,;           //  1 C�digo do produto
		   	                       C1_DESCRI,;            //  2 Descri��o do produto
		   	                       C1_UM,;                //  3 Unidade de medida
		   	                       C1_QUANT,;             //  4 Quantidade
		   	                       C1_OBS,;               //  5 Observa��o
		   	                       C1_CC,;                //  6 Centro de custo
		   	                       C1_CONTA,;             //  7 Conta cont�bil
		   	                       cC1_SOLICIT,;          //  8 Solicitante
		   	                       aItens[ nP, 9 ],;      //  9 C�digo do usu�rio aprovador
		   	                       aItens[ nP, 10 ],;     // 10 Login do usu�rio aprovador
		   	                       aItens[ nP, 11 ],;     // 11 Nome do usu�rio aprovador
		   	                       aItens[ nP, 12 ],;     // 12 E-mail do aprovador aprovador
		   	                       C1_ITEM,;              // 13 Item da solicita��o de compras
			                       nLocalizei,;           // 14 Identifica��o para saber se aprovador est� presente
			                       SC1->( RecNo() ),;     // 15 N� do recno do registro para reposicionamento
			                       aItens[ nP, 16 ] } ) ) // 16 C�digo do aprovador em quest�o.
			Endif
		Endif
		
		lTrb := .T.
		lSeek := .F.
		lEmpty := .F.
		lAK_MSBLQL := .F.
		cAprovSubst := ''
		
		SC1->( dbSkip() )
	End
	
	// Fazer o envio do workflow quebrado por centro de custo.
	If nQtosCCust > 1
		// Order por Centro de Custo.
		ASort( aItens,,, {|a,b| a[ 6 ] < b[ 6 ] } )
		// Enviar o WF por centro de custo.
		nC := 1
		nTamElem := Len( aItens )
		While nC <= nTamElem
			cC1_CC := aItens[ nC, 6 ]
			While nC <= nTamElem .AND. cC1_CC == aItens[ nC, 6 ]
				AAdd( aCCUSTO, AClone( aItens[ nC ] ) )
				nC++
			End
			A710WF( cC1_NUM, cC1_EMISSAO, aCCUSTO, @aMailID, NIL, lJobNotify, @cNewLink )
			aCCUSTO := {}
		End
	Else
		A710WF( cC1_NUM, cC1_EMISSAO, aItens, @aMailID, cMV_710_01, lJobNotify, @cNewLink )
	Endif
	
	cC1_MAIL_ID := '#' + Dtos( MsDate() ) + StrTran( Time(), ':', '' ) + '@'
	
	For nC := 1 To len( aMailID )
		SC1->( dbGoTo( aMailID[ nC, 1 ] ) )
		If SC1->( RecNo() ) == aMailID[ nC, 1 ]
			If SC1->( MsRLock( RecNo() ) )
				SC1->( RecLock( 'SC1', .F. ) )
				SC1->C1_MAIL_ID := Iif( Empty( cMV_710_01 ), aMailID[ nC, 2 ], cC1_MAIL_ID )
				SC1->( MsUnLock() )
			Else
				FSSendMail( 'sistemascorporativos@certisign.com.br',;
				'Imposs�vel gravar MailId em SC1 ['+Iif( Empty( cMV_710_01 ), aMailID[ nC, 2 ], cC1_MAIL_ID )+']',;
				'Este e-mail � informativo para alertar que n�o foi poss�vel gravar no campo C1_MAIL_ID a chave do WF da solicita��o de compras/item '+SC1->C1_NUM+' '+SC1->C1_ITEM + '.', /*cAnexo*/ )
			Endif
			SC1->( MsRUnLock( RecNo() ) )
		Endif
	Next nC
	
	SC1->( RestArea( aArea ) )
	
 	For nC := 1 To Len( aTroca )
		cMsg += '* ' + aTroca[ nC ] + CRLF
	Next nC
	
	If Len( aRATEIO ) > 0
		A710UpdCC( aRATEIO, 0, '' )
	Endif
	
	If .NOT. lJobNotify
		Aviso( 'Workflow - Solicita��es de compras', cMsg, { 'Sair' }, 3, 'Workflow da solicita��o de compras ' + xFilial( 'SC1' ) + '-' + cC1_NUM )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A710Rateio | Autor | Robson Goncalves        | Data | 15/05/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que solicita o centro de custo caso seja rateio no item.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710Rateio( aRATEIO, cC1_CC_Sub )
	Local bExecute := {|| }
	Local bValid := {|| }
	
	Local cC1_CC := ''
	Local cMsg1 := ''
	Local cMsg2 := ''
	Local cRateio := ''
	
	Local lRet := .F.
	
	Local nI := 0
	
	Local oAbandonar
	Local oBmp
	Local oConfirmar
	Local oDlg
	Local oFont1
	Local oFont2
	Local oGet1
	Local oGet2
	
	DEFINE FONT oFont1 NAME 'Calibri'     SIZE 0, -12 BOLD
	DEFINE FONT oFont2 NAME 'Courier new' SIZE 0, -10
	
	cC1_CC := Space( Len( SC1->C1_CC ) )
	
	bValid := {|| A710VldCC(cC1_CC) }
	bExecute := bValid
	
	cRateio := 'ITEM  C�DIGO           PRODUTO' + CRLF
	cRateio += '----  ---------------  ------------------------------' + CRLF
	
	// [1] - C1_NUM
	// [2] - C1_ITEM
	// [3] - C1_PRODUTO
	// [4] - C1_DESCRI
	For nI := 1 To Len( aRATEIO )
		cRateio += aRATEIO[ nI, 2 ] + '  ' +aRATEIO[ nI, 3 ] + '  ' +aRATEIO[ nI, 4 ] + CRLF 
	Next nI
	
	cMsg1 := 'Identifiquei produto(s) com rateio, veja rela��o abaixo:'
	cMsg2 := 'Por conta disto � preciso definir qual centro de custo ir� aprovar este(s) item(s).'

	DEFINE MSDIALOG oDlg FROM 0,0 TO 220,550 TITLE 'Identifica��o de rateio' PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		@ -15,-3 BITMAP oBmp RESNAME 'IMPORT.PNG' oF oDlg SIZE 75,130 NOBORDER WHEN .F. PIXEL
		
		@ 11,70 TO 12,274 LABEL '' OF oDlg PIXEL
		
		@ 15,70 SAY cMsg1 OF oDlg PIXEL SIZE 200,10 FONT oFont1

		@ 26,70 GET oGet1 VAR cRateio OF oDlg PIXEL SIZE 204,52 READONLY MEMO FONT oFont2

		@ 82,70 SAY cMsg2 OF oDlg PIXEL SIZE 200,10 FONT oFont1

		oGet2 := TGet():New(96,75,{|u| If(PCount() > 0, cC1_CC := u, cC1_CC ) },oDlg,90,9,,bValid,,,,,,.T.,,,,,,bExecute,,,'CTT',cC1_CC,,,,,,,,,,,)
		oGet2:cPlaceHold := 'Informe o centro de custo aqui...' 
			
		@ 92,70 TO 93,274 LABEL '' OF oDlg PIXEL

		@ 96,191	BUTTON oConfirmar ;
					PROMPT 'Confirmar' ; 
					SIZE 40,11 PIXEL OF oDlg ;
					ACTION (Iif(Eval(bValid),(lRet:=.T.,oDlg:End()),(MsgAlert('� obrigat�rio informar o centro de custo.','CSFA710'),NIL)))

		@ 96,234 BUTTON oAbandonar PROMPT 'Abandonar' SIZE 40,11 PIXEL OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTER ON INIT oGet2:SetFocus()
	If lRet
		cC1_CC_Sub := cC1_CC
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A710VldCC  | Autor | Robson Goncalves        | Data | 15/05/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para validar o c�digo do centro de custo digitado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710VldCC( cCusto )
	Local lRet	:= .T.
	If .NOT. CtbInUse()
		Return ExistCpo("SI3",cCusto)
	Endif
	ConvCusto(@cCusto)
	lRet := ValidaCusto(cCusto,,,,.T.)
	If lRet
		lRet := ValidaBloq(cCusto,MsDate(),"CTT")
		C102ExbCC(cCusto)
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A710UpdCC  | Autor | Robson Goncalves        | Data | 15/05/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que atualiza os campos centro de custo conforme situa��o. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710UpdCC( aArray, nTipo, cC1_CC_Sub )
	Local aArea := {}
	Local cSpace := Space( Len( SC1->C1_CC ) )
	Local nI := 0
	If Len(aArray)>0 .AND. nTipo <> NIL .AND. cC1_CC_Sub <> NIL
		aArea := { GetArea(), SC1->( GetArea() ) }
		For nI := 1 To Len( aArray )
			SC1->( MsGoTo( aArray[ nI, 1 ] ) )
			SC1->( RecLock( 'SC1', .F. ) )
			If nTipo == 0
				SC1->C1_CC := cSpace
			Elseif nTipo == 1
				SC1->C1_CC      := cC1_CC_Sub
				SC1->C1_APROVCC := cC1_CC_Sub + 'CC APROV.IT.C/RATEIO'
			Endif
			SC1->( MsUnLock() )
		Next nI
		AEval( aArea, {|xArea| RestArea( xArea ) } )
	Endif
Return
//--------------------------------------------------------------------------
// Rotina | A710Ferias | Autor | Robson Goncalves        | Data | 08/09/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para identificar se o aprovador est� ausente.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710Ferias( cTRB, aTroca, lTrb )
	Local aSAK := {}
	
	Local cAK_APROSUP := ''
	Local cAK_VINCULO := ''
	Local cAK_USER := ''
	Local cBKP_AK_USER:= ''
	Local cR8_FILIAL := ''
	Local cR8_MAT := ''
	Local cSQL := ''
	Local cTMP := ''

	Local lAfastado := .F.
	Local lTrocou := .F.
	Local nLocalizei := 0
	
	Local dDataHoje := MsDate() 
	
	Local cMV710_05 := 'MV_710_05'

	If .NOT. GetMv( cMV710_05, .T. )
		CriarSX6( cMV710_05, 'N', 'HABILITAR VERIFICACAO DE AFASTAMENTO NA GERA��O DE AL�ADA (SC). 0=DESABILITADO E 1=HABILITADO - ROTINA CSFA710.prw', '0' )
	Endif
	
	cAK_APROSUP := Iif( lTrb, (cTRB)->AK_APROSUP, SAK->AK_APROSUP )
	cAK_VINCULO := Iif( lTrb, (cTRB)->AK_VINCULO, SAK->AK_VINCULO )
	cAK_USER    := Iif( lTrb, (cTRB)->AK_USER   , SAK->AK_USER )
	cBKP_AK_USER:= Iif( lTrb, (cTRB)->AK_USER   , SAK->AK_USER )
	cAK_COD     := Iif( lTrb, (cTRB)->AK_COD    , SAK->AK_COD )
	
	//--Se o par�metro estiver habilitado, valida a aus�ncia, caso contr�rio gera a al�ada.
	IF GetMv( cMV710_05, .F. ) == 1
		While .T.
			cR8_FILIAL := SubStr( cAK_VINCULO, 1, 2 )
			cR8_MAT    := SubStr( cAK_VINCULO, 3, 6 )
				
			cSQL := "SELECT COUNT(*) AS SR8RECNO "
			cSQL += "FROM "+RetSqlName("SR8")+" SR8 "
			cSQL += "WHERE R8_FILIAL = "+ValToSql( cR8_FILIAL )+" "
			cSQL += "      AND R8_MAT = "+ValToSql( cR8_MAT )+" "
			cSQL += "      AND D_E_L_E_T_ = ' ' "
			cSQL += "      AND ( "+ValToSql( dDataHoje )+" >= R8_DATAINI "
			cSQL += "      AND "+ValToSql( dDataHoje )+" <= R8_DATAFIM ) "
			cSQL += "       OR ( R8_DATAINI >= "+ValToSql( dDataHoje )+" "
			cSQL += "            AND R8_DATAFIM <= "+ValToSql( dDataHoje )+" ) "
				
			cSQL := ChangeQuery( cSQL )
			cTMP := GetNextAlias()
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTMP,.F.,.T.)
			If (cTMP)->(.NOT. BOF()) .AND. (cTMP)->(.NOT.EOF())
				lAfastado := ((cTMP)->( SR8RECNO ) > 0 )
				(cTMP)->( dbCloseArea() )
				
				// Est� afastado?
				If lAfastado
					// N�o tem aprovador superior?
					If Empty( cAK_APROSUP )  
						//O aprovador em quest�o est� afastado e n�o possui aprovador superior, mesmo assim ser� gerado WF de aprova��o para ele.
						cAK_USER := cBKP_AK_USER
						nLocalizei := 2
						AAdd( aTroca, 'Item ' + SC1->C1_ITEM + ' enviado WF p/ ' + A710NomUsr( cBKP_AK_USER ) + ' do C.Custo ' + RTrim( SC1->C1_CC ) + ', por�m ele est� afastado e n�o h� superior no seu cadastro de aprovador.' )
						Exit
					// Tem aprovador superior, capturar dados.
					Else
						aSAK := SAK->( GetAdvFVal( 'SAK', { 'AK_VINCULO', 'AK_APROSUP', 'AK_USER', 'AK_COD' }, xFilial( 'SAK' ) + cAK_APROSUP, 1 ) )
						cAK_VINCULO := aSAK[ 1 ]
						cAK_APROSUP := aSAK[ 2 ] 
						cAK_USER    := aSAK[ 3 ]
						cAK_COD     := aSAK[ 4 ]
						AAdd( aTroca, 'Item ' + SC1->C1_ITEM + ' enviado WF p/ ' + A710NomUsr( cAK_USER ) + ' do C.Custo ' + RTrim( SC1->C1_CC ) + ' porque o aprovador ' + A710NomUsr( cBKP_AK_USER ) + ' est� de f�rias.' )
						lTrocou := .T.
					Endif 
				Else
					If .NOT. lTrocou
						AAdd( aTroca, 'Item ' + SC1->C1_ITEM + ' enviado WF p/ ' + A710NomUsr( cAK_USER ) + ' do C.Custo '+ RTrim( SC1->C1_CC ) + '.' )
					Endif
					nLocalizei := 0
					Exit
				Endif
			Endif
		End
	EndIF
Return( { cAK_USER, nLocalizei } )

//--------------------------------------------------------------------------
// Rotina | A710NomUsr | Autor | Robson Goncalves        | Data | 23/09/2016
//--------------------------------------------------------------------------
// Descr. | Rotina buscar o primeiro nome do aprovador.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710NomUsr( cCodeUser )
	Local cNome := RTrim( UsrFullName( cCodeUser ) )
	Local nP := At(' ', cNome )
Return( Iif( nP > 0, Capital( SubStr( cNome, 1, nP-1 ) ), cNome ) )

//--------------------------------------------------------------------------
// Rotina | A710CpoCC  | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar o conte�do do campo especificado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710CpoCC()
	Local cMV_710GRAP := 'MV_710GRAP'
	If .NOT. GetMv( cMV_710GRAP, .T. )
		CriarSX6( cMV_710GRAP, 'C', 'CAMPO NO CENTRO DE CUSTO COM O CODIGO DO GRUPO DE APROVACAO PARA APROVAR SOLICITACAO DE COMPRAS COM CONTROLE DE APROVACAO POR WF. - ROTINA CSFA710.prw', 'CTT_GAPONT' )
	Endif
Return( GetMv( cMV_710GRAP, .F. ) )

//--------------------------------------------------------------------------
// Rotina | A710MnuSC  | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada MTA110MNU.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A710MnuSC()
	Local cMsg := ''
	Local cC1_NUM := SC1->C1_NUM
	Local nItem := 0
	Local nBloq := 0
	Local nReg := SC1->( RecNo() )
	SC1->( dbSetOrder( 1 ) )
	SC1->( dbSeek( xFilial( 'SC1' ) + cC1_NUM ) )
	While SC1->( .NOT. EOF() ) .AND. SC1->C1_FILIAL == xFilial( 'SC1' ) .AND. SC1->C1_NUM == cC1_NUM
		nItem++
		If SC1->C1_QUJE == 0 .AND. SC1->C1_COTACAO == Space( Len( SC1->C1_COTACAO ) ) .AND. SC1->C1_APROV == 'B'
			nBloq++
		End
		SC1->( dbSkip() )
	End
	SC1->( dbGoTo( nReg ) )
	If nBloq > 0 
		cMsg := 'O objetivo desta rotina � solicitar aprova��o desta solicita��o de compras '
		cMsg += 'para o gestor respons�vel pelo centro de custo informado, por favor, selecione uma das '
		cMsg += 'op��es abaixo para continuar com sua opera��o. '+CRLF+CRLF+'Enviar - enviar workflow neste momento. '+CRLF+'N�o enviar - n�o enviar workflow neste momento.'
		If Aviso('Workflow Solicita��o de Compras',cMsg,{'N�o enviar','Enviar'},3,'Solicitar Aprova��o') == 2
			FWMsgRun( , {|| U_CSFA710( cC1_NUM, 'MTA110MNU' ) }, ,'Solicita��o de compras, enviando WF...' )
		Endif
	Else
		MsgAlert(cFONT_V+'ATEN��O'+cFONT+'<br><br>Somente solicita��o de compras bloqueadas � que podem ser submetidas a aprova��o por workflow.'+cNOFONT,'Workflow solicita��o de compras')
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A710CC     | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar o nome do aprovador conforme o centro de
//        | custo informado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A710CC()
	Local cAL_NOME := Space( 30 )
	Local cGrpAprov := ''
	
	CTT->( dbSetOrder( 1 ) )
	If CTT->( MsSeek( xFilial( 'CTT' ) + M->C1_CC ) )
		cGrpAprov := &( 'CTT->'+A710CpoCC() )
		If Empty( cGrpAprov )
			MsgAlert(cFONT_V+'ATEN��O'+cFONT+'<br><br>No cadastro do c�digo do centro de custo em quest�o n�o h� c�digo do grupo de aprova��o recorrente fixo,'+;
			         '<br>por favor, busque a informa��o com a equipe do fiscal tribut�rio.<br>Da forma que est� n�o ser� poss�vel enviar workflow.'+cNOFONT,cCadastro)
		Else
			SAL->( dbSetOrder( 1 ) )
			SAL->( dbSeek( xFilial( 'SAL' ) + cGrpAprov) )
			While SAL->( .NOT. EOF() ) .AND. SAL->AL_FILIAL == xFilial( 'SAL' ) .AND. SAL->AL_COD == cGrpAprov
				If SAL->AL_NIVEL == '01'
					cAL_NOME := RTrim( SAK->( GetAdvFVal( 'SAK', 'AK_NOME', xFilial( 'SAK' ) + SAL->AL_APROV, 1 ) ) )
					Exit
				Endif
				SAL->( dbSkip() )
			End
			If Empty( cAL_NOME )
				MsgAlert(cFONT_V+'ATEN��O'+cFONT+'<br><br>O grupo de aprova��o '+cGrpAprov+' est� sem aprovador com n�vel 01,'+;
				         '<br>busque a informa��o com a equipe do planejamento financeiro. Da forma que est� n�o ser� poss�vel enviar workflow'+cNOFONT,cCadastro)
			Endif
		Endif
	Else
		MsgAlert(cFONT_V+'ATEN��O'+cFONT+'<br>C�digo do centro de custo n�o localizado.'+cNOFONT,cCadastro)
	Endif
Return( cAL_NOME )

//--------------------------------------------------------------------------
// Rotina | A710CCIni  | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina acionada pelo X3_RELACAO do campo C1_APROVCC. O objetivo
//        | � retornar o nome do aprovador conforme o centro de custo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A710CCIni()
	Local nElem := Len( aCOLS )
	Local cAL_NOME := ''
	Local nP_C1_CC := GdFieldPos('C1_CC')
	Local cGrpAprov := ''
	
	cGrpAprov := 'CTT->'+A710CpoCC()
	
	CTT->( dbSetOrder( 1 ) )
	CTT->( MsSeek( xFilial( 'CTT' ) + aCOLS[ nElem, nP_C1_CC ] ) )

	SAL->( dbSetOrder( 1 ) )
	SAL->( MsSeek( xFilial( 'SAL' ) + &( cGrpAprov ) ) )
	
	While SAL->( .NOT. EOF() ) .AND. SAL->AL_FILIAL == xFilial( 'SAL' ) .AND. SAL->AL_COD == &( cGrpAprov )
		If SAL->AL_NIVEL == '01'
			cAL_NOME := RTrim( SAK->( GetAdvFVal( 'SAK', 'AK_NOME', xFilial( 'SAK' ) + SAL->AL_APROV, 1 ) ) )
			Exit
		Endif
		SAL->( dbSkip() )
	End
Return( cAL_NOME )

//--------------------------------------------------------------------------
// Rotina | A710WF     | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de elabora��o da p�gina de workflow.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710WF( cC1_NUM, cC1_EMISSAO, aCCUSTO, aMailID, cMV_710_01, lJobNotify, cNewLink )
	Local aC1_ANEXOS := {}
	
	Local nI := 0
	Local oWFEnv  
	Local oHTML	
	Local cIdMail := ''
	Local cNumSC := ''
	Local cBody := ''
	Local cAnexo := ''
	Local cSaveFile := ''
	Local cDir := SubStr( GetMv('MV_XWFHTTP'), 10 )
	Local cLOG := ''
	Local cPastaUsr := ''
	Local cMV_IPSRV := GetMv( 'MV_610_IP', .F. )
	Local lServerTst := GetServerIP() $ cMV_IPSRV
	 
	Private cUSER_LOG := aCCUSTO[ 1, 10 ]
	Private cMV_710WF1 := GetNewPar('MV_710WF1', '\WORKFLOW\EVENTO\CSFA710a.HTM')
	Private cMV_710WF2 := GetNewPar('MV_710WF2', '\WORKFLOW\EVENTO\CSFA710b.HTM')
	
	DEFAULT lJobNotify := .F.
	DEFAULT cNewLink := ''
	
	cNumSC := xFilial( 'SC1' ) + '-' + cC1_NUM
	
	If Empty( cMV_710_01 )
		oWFEnv := TWFProcess():New( 'SOLCOMWF', 'Aprovar solicita��o de compras')
		oWFEnv:NewTask( 'SOLCOMWF', cMV_710WF1 )
		oWFEnv:cSubject := IIF( lServerTst, "[TESTE] ", "" ) + 'Aprova��o Solicita��o de Compras'
		oWFEnv:bReturn := 'U_CSFA710A(1)'
		
		// Carrega modelo HTML
		oHTML := oWFEnv:oHTML
	Else
		oHTML := TWFHTML():New( cMV_710WF2 )
	Endif
	
	oHTML:ValByName( 'cPrezado', aCCUSTO[ 1, 11 ] + ' (' + aCCUSTO[ 1, 9 ] + ')' )
	oHTML:ValByName( 'cNumSC', cNumSC )
	oHTML:ValByName( 'cSolicitante', aCCUSTO[ 1, 8 ] )
	oHTML:ValByName( 'cDtEmissao', cC1_EMISSAO )
	
	For nI := 1 To Len( aCCUSTO )
		AAdd( ( oHTML:ValByName( 'IT.cProduto' )), RTrim( aCCUSTO[ nI, 1 ] ) + ' - ' + RTrim( aCCUSTO[ nI, 2 ] ) )
		AAdd( ( oHTML:ValByName( 'IT.cUM'      )), aCCUSTO[ nI, 3 ] )
		AAdd( ( oHTML:ValByName( 'IT.cQuant'   )), TransForm( aCCUSTO[ nI, 4 ], '@E 999,999,999.99' ) )
		AAdd( ( oHTML:ValByName( 'IT.cObserv'  )), aCCUSTO[ nI, 5 ]  )
		AAdd( ( oHTML:ValByName( 'IT.cCCusto'  )), aCCUSTO[ nI, 6 ] )
		AAdd( ( oHTML:ValByName( 'IT.cCConta'  )), aCCUSTO[ nI, 7 ] )
		AAdd( ( oHTML:ValByName( 'IT.cIt'      )), aCCUSTO[ nI, 13 ] )
	Next nI
	
	If Empty( cMV_710_01 )
		cPastaUsr := StrTran( StrTran( cUSER_LOG, '.', '' ), '\', '' )
		oWFEnv:cTo := cPastaUsr
		
		oWFEnv:FDesc := IIF( lServerTst, "[TESTE] ", "" ) + 'Aprovar Solicita��o de Compras n� '+ cC1_NUM
		
		oWFEnv:ClientName( cUSER_LOG )
		
		cIdMail := oWFEnv:Start()
		
		cBody := A710LeArq( cDir + cPastaUsr + '\' + cIdMail + '.htm' )
		
		cLOG := "P�GINA HTML PARA A APROVA��O DA SOLICITA��O DE COMPRAS."
				
		If lJobNotify
			cNewLink := cIdMail
		Else
			A710WFLink( cC1_NUM, cC1_EMISSAO, aCCUSTO, @oWFEnv, cIdMail, lServerTst )
		Endif
		
		oWFEnv:Free()
		
		A710LogResp( aCCUSTO[1,12], "", aCCUSTO[1,16], aCCUSTO[1,9], xFilial( 'SC1' ), cC1_NUM, cBody, Time(), cLOG, .T., 'CRIACAO DA PAG HTML PARA APROVACAO VIA NAVEGADOR.' )
	Else
		If oHTML:ExistField( 1, 'proc_link' )
			oHTML:ValByName( 'proc_link', cMV_710_01 )
		Endif
		
		A710GetAnexo( @aC1_ANEXOS, cC1_NUM )
		
		For nI := 1 To Len( aC1_ANEXOS )
			If .NOT. Empty( aC1_ANEXOS )
				cAnexo += aC1_ANEXOS[ nI ] + ', '
			Endif
		Next nI
		
		If cAnexo <> ''
			cAnexo := SubStr( cAnexo, 1, Len( cAnexo )-2 )
		Endif
		
		cSaveFile := CriaTrab( NIL , .F. )
		oHTML:SaveFile( cSaveFile + '.htm' )
		
		Sleep( Randomize( 1, 1500 ) )
		
		cBody := STATICCALL( CSFA610, A610LoadFile, ( cSaveFile + '.htm' ) )
		cBody := StrTran( cBody, 'systemaccesslink', cMV_710_01 )
		
		FSSendMail( aCCUSTO[ 1, 12 ], IIF( lServerTst, "[TESTE] ", "" ) + 'Aprova��o Solicita��o de Compras N� ' + cNumSC, cBody, cAnexo )
		
		cLOG := 'P�GINA HTML (E-MAIL) PARA O LINK DE APROVA��O DA SOLICITA��O DE COMPRAS VIA APLICA��O WEB.'
				
		oHTML:Free()
		oHTML := NIL
		
		A710LogResp( aCCUSTO[1,12], "", aCCUSTO[1,16], aCCUSTO[1,9], xFilial( 'SC1' ), cC1_NUM, cBody, Time(), cLOG, .T., 'ENVIO DE AVISO DE APROVACAO VIA APLICACAO WEB.' )
	Endif
	
	AEval( aCCUSTO, {|e| AAdd( aMailID, { e[ 15 ], cIdMail } ) } )
Return

//--------------------------------------------------------------------------
// Rotina | A710WFLink | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para elaborar o e-mail com o link da p�gina do workflow.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710WFLink( cC1_NUM, cC1_EMISSAO, aCCUSTO, oWFEnv, cIdMail, lServerTst )
	Local aC1_ANEXOS := {}
	
	Local cId := ''
	Local cEMail := aCCUSTO[ 1, 12 ]
	Local cLink	:= GetNewPar('MV_XLINKWF', 'http://192.168.16.10:1804/wf/')
	Local cLinkUser := StrTran( StrTran( cUSER_LOG, '.', '' ), '\', '' )
	Local cNumSC := ''
	Local cBody := ''
	Local cLOG := ''
	Local cDir := SubStr( GetMv('MV_XWFHTTP'), 10 )
	
	Local nI := 0
	
	Local oHTML
	
	cNumSC := xFilial( 'SC1' ) + '-' + cC1_NUM
	
	cLink += 'emp' + cEmpAnt + '/'
	
	oWFEnv:NewTask( 'SOLCOMWF', cMV_710WF2 )
	oWFEnv:cSubject := IIF( lServerTst, "[TESTE] ", "" ) + 'Aprova��o da solicita��o de compras ' + cC1_NUM
	oWFEnv:cTo := cEMail
	
	oHTML := oWFEnv:oHTML
	
	oHTML:ValByName( 'cPrezado', aCCUSTO[ 1, 11 ] + ' ('+aCCUSTO[ 1, 9 ] + ')' )
	oHTML:ValByName( 'cNumSC',  cNumSC )
	oHTML:ValByName( 'cSolicitante', aCCUSTO[ 1, 8 ] )
	oHTML:ValByName( 'cDtEmissao', cC1_EMISSAO )
	
	For nI := 1 To Len( aCCUSTO )
		AAdd( ( oHTML:ValByName( 'IT.cProduto' )), RTrim( aCCUSTO[ nI, 1 ] ) + ' - ' + RTrim( aCCUSTO[ nI, 2 ] ) )
		AAdd( ( oHTML:ValByName( 'IT.cUM'      )), aCCUSTO[ nI, 3 ] )
		AAdd( ( oHTML:ValByName( 'IT.cQuant'   )), TransForm( aCCUSTO[ nI, 4 ], '@E 999,999,999.99' ) )
		AAdd( ( oHTML:ValByName( 'IT.cObserv'  )), aCCUSTO[ nI, 5 ]  )
		AAdd( ( oHTML:ValByName( 'IT.cCCusto'  )), aCCUSTO[ nI, 6 ] )
		AAdd( ( oHTML:ValByName( 'IT.cCConta'  )), aCCUSTO[ nI, 7 ] )
		AAdd( ( oHTML:ValByName( 'IT.cIt'  ))    , aCCUSTO[ nI, 13 ] )
	Next nI

	oHTML:ValByName( 'proc_link', cLink + cLinkUser + '/' + cIdMail + '.htm' )
	oHTML:ValByName( 'titulo', cIdMail )
	
	A710GetAnexo( @aC1_ANEXOS, cC1_NUM )
	
	For nI := 1 To Len( aC1_ANEXOS )
		If .NOT. Empty( aC1_ANEXOS )
			oWFEnv:AttachFile( aC1_ANEXOS[ nI ] )
		Endif
	Next nI
	
	cId := oWFEnv:Start()
	
	oWFEnv:SaveValFile( cDir + cLinkUser + "\" + cId + ".htm" )
	
	cBody := A710LeArq( cDir + cLinkUser + "\" + cId + ".htm" )
	
	oWFEnv:Free()
		
	cLOG := "P�GINA HTML (E-MAIL) PARA O LINK DE APROVA��O DA SOLICITA��O DE COMPRAS."
	
	A710LogResp( aCCUSTO[1,12], "", aCCUSTO[1,16], aCCUSTO[1,9], xFilial( 'SC1' ), cC1_NUM, cBody, Time(), cLOG, .T., 'ENVIO DO EMAIL DE APROVACAO PARA CLICAR NO LINK.' )
Return

//--------------------------------------------------------------------------
// Rotina | A710GetAnexo | Autor | Robson Goncalves      | Data | 01.06.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para capturar os arquivos anexos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710GetAnexo( aC1_ANEXOS, cC1_NUM )
	Local cSQL := ''
	Local cTRB := ''
	Local cRoot := MsDocPath()+'\'
	Local cKeyAte := ''
	Local cKeyDe := ''
	Local nTam := Len( SC1->C1_ITEM )
	
	cKeyDe  := xFilial( 'SC1' ) + cC1_NUM + Space( nTam )
	cKeyAte := xFilial( 'SC1' ) + cC1_NUM + Replicate( 'z', nTam )
	
	cSQL := "SELECT ACB_OBJETO "
	cSQL += "FROM   "+RetSqlName("AC9")+" AC9 "
	cSQL += "       INNER JOIN "+RetSqlName("ACB")+" ACB "
	cSQL += "               ON ACB_FILIAL = "+ValToSql(xFilial("ACB"))+" "
	cSQL += "                  AND ACB_CODOBJ = AC9_CODOBJ "
	cSQL += "                  AND ACB.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  AC9_FILIAL = "+ValToSql(xFilial("AC9"))+" "
	cSQL += "       AND AC9_FILENT = "+ValToSql(xFilial('SC1'))+" "
	cSQL += "       AND AC9_ENTIDA = 'SC1' "
	cSQL += "       AND AC9_CODENT >= "+ValToSql(cKeyDe)+" "
	cSQL += "       AND AC9_CODENT <= "+ValToSql(cKeyAte)+" "
	cSQL += "       AND AC9.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		AAdd( aC1_ANEXOS, cRoot + RTrim( (cTRB)->ACB_OBJETO ) )
		(cTRB)->( dbSkip() )
	End
	
   (cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | CSFA710A   | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de retorno do workflow.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA710A( nOPC, o710Proc )
	If nOPC == 1
		A710RetWF( o710Proc )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A710RetWF  | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento de retorno do WF.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710RetWF( o710Proc )
	Local nI          := 0
	Local nReg        := 0
	Local nRej        := 0
	Local nAprov      := 0
	Local cAprovBkp   := ''
	Local lAProvSI 	  := GetNewPar( 'MV_APROVSI', .F. )
	Local cNumSC      := AllTrim( o710Proc:oHTML:RetByName('cNumSC') )
	Local cC1_FILIAL  := SubStr( cNumSC, 1, At( '-', cNumSC )-1 )
	Local cC1_NUM     := SubStr( cNumSC, Rat( '-', cNumSC )+1 )
	Local cMotivo     := AllTrim( o710Proc:oHTML:RetByName('cMotivo') )
	Local cAprovacao  := AllTrim( o710Proc:oHTML:RetByName('cAprovacao') )
	Local cSituacao   := Iif( cAprovacao == 'S', 'Aprovada', Iif( cAprovacao == 'N', 'Rejeitada', '' ) )
	Local cWFMailID   := SubStr( RTrim( o710Proc:oHTML:RetByName('WFMailID') ), 3 )
	Local cUsrAprv    := AllTrim( o710Proc:oHTML:RetByName('cPrezado') )
	Local cC1_ITEM    := ''
	Local cItens      := ''
	Local nQtdItens   := Len( o710Proc:oHTML:RetByName( 'it.cIt') )
	Local cC1_SOLICIT := ''
	Local cCodAprov   := ''
	Local lRet        := .T.
	
	Conout("*** INICIANDO O PROCESSO DE RETORNO DO WORKFLOW DE SOLICITACAO DE COMPRAS ***")
	
	cCodAprov := SubStr( cUsrAprv, At( '(', cUsrAprv )+1, 6 )
	cUsrAprv  := UsrRetName( cCodAprov )
	
	cMotivo := Iif( Empty( cMotivo ), 'Motivo n�o informado.', cMotivo )
	
	Conout("*** cCodAprov: " + cCodAprov )
	Conout("*** cUsrAprv: " + cUsrAprv )
	
	SC1->( dbSetOrder( 1 ) )
	If cAprovacao $ 'S|N'
		
		Conout("*** ENTREI NO IF/ENDIF DO cAprovacao: " + cAprovacao)
		
		// Salvar o ID do WF.
		U_A603Save( cWFMailID, 'CSFA710' )
		// Quantidade de registros que ser�o lidos.
		nReg := nQtdItens
		// Ler os registros que retornaram no WF.
		For nI := 1 To nQtdItens
			// Capturar o n�mero do item.
			cC1_ITEM := o710Proc:oHTML:RetByName( 'IT.cIt')[ nI ]
			// Localizar o registro.
			If SC1->( dbSeek( cC1_FILIAL + cC1_NUM + cC1_ITEM ) )
				// Capturar o login do elaborador da SC.
				If cC1_SOLICIT == ''
					cC1_SOLICIT := SC1->C1_SOLICIT 
				Endif
				// Se for aprova��o.
				If cAprovacao == 'S'
					Conout("*** INICIAR APROVAR")
					
					// Aprovar.
					lRet := A710Aprovar( lAProvSI, cUsrAprv, SC1->C1_FILIAL, SC1->C1_NUM, SC1->C1_ITEM )
					If .NOT. lRet
						Loop
					Endif
					nAprov++
					cItens += SC1->C1_ITEM + ', '
				Else
					Conout("*** INICIAR REJEITAR")

					// Rejeitar.
					lRet := A710Rejeitar( lAProvSI, cUsrAprv, SC1->C1_FILIAL, SC1->C1_NUM, SC1->C1_ITEM )
					If .NOT. lRet
						Loop
					Endif
					nRej++
					cItens += SC1->C1_ITEM + ', '
				Endif
			Endif
		Next nI
	Else
		Conout("*** NAO ENTREI NO IF/ENDIF DO cAprovacao")
	Endif
	cItens := SubStr( cItens, 1, Len( cItens )-2 )

	U_A710MsgUsr( cC1_FILIAL+'-'+cC1_NUM+' - '+cItens, cSituacao, cMotivo, cC1_SOLICIT, cCodAprov )
	
	Conout("*** FINALIZANDO O PROCESSO DE RETORNO DO WORKFLOW DE SOLICITACAO DE COMPRAS ***")
Return

/*User Function teste1()
	Local cItens := ''
	Local nOpc := 0
	
	cItens := '0001, 0002'
	
	nOpc := Aviso("T�tulo","Mensagem",{"aprovar","bloquear"},1,"Sub-t�tulo")
	
	If nOpc == 1
		A710Aprovar( .F., 'rleg30@gmail.com', '02', '002151', '0001' )
		A710Aprovar( .F., 'rleg30@gmail.com', '02', '002151', '0002' )
		
		U_A710MsgUsr( '02'+'-'+'002151'+' - '+cItens, 'A-P-R-O-V-A-D-O', '_MOTIVO_', 'totvs\robson.goncalves', '000043','PROCESSO DE APROVAR SC EXECUTADO.' )
	Else
		A710Rejeitar( .F., 'rleg30@gmail.com', '02', '002151', '0001' )
		A710Rejeitar( .F., 'rleg30@gmail.com', '02', '002151', '0002' )
	
		U_A710MsgUsr( '02'+'-'+'002151'+' - '+cItens, 'R-E-J-E-I-T-A-D-O', '_MOTIVOS_', 'totvs\robson.goncalves', '000043','PROCESSO DE REJEITAR SC EXECUTADO.' )
	Endif
Return*/

//--------------------------------------------------------------------------
// Rotina | A710Aprovar| Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento de aprova��o.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710Aprovar( lAProvSI, cUsrAprv, cFIL, cNUM, cITEM )
	Local cAprovBkp := ''
	Local cErroSql := ''
	Local cUpd := ''
	Local lRet := .T.
	Local nStatus := 0
	Local cSituacao := 'APROVADO'
	
	If .NOT. PcoVldLan('000051','02','MATA110',/*lUsaLote*/,/*lDeleta*/, .F./*lVldLinGrade*/)  // valida bloqueio na aprovacao de SC
		Return( .F. )
	Endif
	
	cUpd := "UPDATE "+RetSqlName("SC1")+" SC1 "
	cUpd += "   SET C1_APROV = 'L', " 
	cUpd += "       C1_NOMAPRO = "+ValToSql(cUsrAprv)+", "
	cUpd += "       C1_DTAVAL = "+ValToSql(Dtos(MsDate()))+" "
	cUpd += " WHERE C1_FILIAL = "+ValToSql(cFIL)+" "
	cUpd += "       AND C1_NUM = "+ValToSql(cNUM)+" "
	cUpd += "       AND C1_ITEM = "+ValToSql(cITEM)+" "
	cUpd += "       AND C1_QUJE = 0 "
	cUpd += "       AND C1_APROV IN(' ','B','R') "
	cUpd += "       AND C1_COTACAO = ' ' "+Iif(lAprovSI," OR C1_COTACAO = 'IMPORT' "," ")
	cUpd += "       AND C1_RESIDUO = ' ' "
	cUpd += "       AND SC1.D_E_L_E_T_ = ' ' "

	Begin Transaction
		Conout("*** VOU FAZER O UPDATE DE APROVACAO" + cUpd)
		
		nStatus := TCSqlExec( cUpd )
		If nStatus < 0
			lRet := .F.
			cErroSql := TCSQLError()
			cSituacao := 'N�O FOI POSS�VEL APROVAR'
			FSSendMail( 'sistemascorporativos@certisign.com.br',;
			'APROV. SC ['+cC1_FIL+'-'+cC1_NUM+'-'+cC1_ITEM+']',;
			'Este e-mail � um alertar que n�o foi poss�vel APROVAR a solicita��o de compras/item ['+cC1_FIL+'-'+cC1_NUM+'-'+cC1_ITEM+'].'+;
			'Abaixo o erro reportando pelo banco de dados:'+CRLF+cErroSql, /*cAnexo*/ )
			
			Conout("*** NAO CONSEGUI FAZER O UPDATE DE APROVACAO" + cErroSql )
		Else
			SC1->( MsSeek( cFIL + cNUM + cITEM ) )
			cAprovBkp := SC1->C1_APROV
			MaAvalSC( 'SC1', 8,,,,,, cAprovBkp )
			
			Conout("*** CONSEGUI FAZER O UPDATE APROVACAO" )
		Endif
	End Transaction
	
	// Gravar o log do processo.
	A710LogResp( cUsrAprv, cSituacao, "", "", cFIL, cNUM, "", Time(), cErroSql, .T.,'PROCESSO DE APROVAR SC ['+cFIL+'-'+cNUM+'-'+cITEM+'] EXECUTADO.' )
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A710Rejeitar| Autor | Robson Goncalves       | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento da rejei��o por workflow.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710Rejeitar( lAProvSI, cUsrAprv, cFIL, cNUM, cITEM )
	Local cAprovBkp := ''
	Local cErroSql := ''
	Local cUpd := ''
	Local lRet := .T.
	Local nStatus := 0
	Local cSituacao := 'REJEITADO'
	
	cUpd := "UPDATE "+RetSqlName("SC1")+" SC1 "
	cUpd += "   SET C1_APROV = 'R', " 
	cUpd += "       C1_NOMAPRO = "+ValToSql(cUsrAprv)+", "
	cUpd += "       C1_DTAVAL = "+ValToSql(Dtos(MsDate()))+" "
	cUpd += " WHERE C1_FILIAL = "+ValToSql(cFIL)+" "
	cUpd += "       AND C1_NUM = "+ValToSql(cNUM)+" "
	cUpd += "       AND C1_ITEM = "+ValToSql(cITEM)+" "
	cUpd += "       AND C1_QUJE = 0 "
	cUpd += "       AND C1_APROV IN(' ','B','L') "
	cUpd += "       AND C1_COTACAO = ' ' "+Iif(lAprovSI," OR C1_COTACAO = 'IMPORT' "," ")
	cUpd += "       AND C1_RESIDUO = ' ' "
	cUpd += "       AND SC1.D_E_L_E_T_ = ' ' "
	
	Begin Transaction
		Conout("*** VOU FAZER O UPDATE DE REJEICAO" + cUpd)

		nStatus := TCSqlExec( cUpd )
		If nStatus < 0
			lRet := .F.
			cErroSql := TCSQLError()
			cSituacao := 'N�O FOI POSS�VEL REPROVAR'
			FSSendMail( 'sistemascorporativos@certisign.com.br',;
			'APROV. SC ['+cC1_FIL+'-'+cC1_NUM+'-'+cC1_ITEM+']',;
			'Este e-mail � um alertar que n�o foi poss�vel REJEITAR a solicita��o de compras/item ['+cC1_FIL+'-'+cC1_NUM+'-'+cC1_ITEM+'].'+;
			'Abaixo o erro reportando pelo banco de dados:'+CRLF+cErroSql, /*cAnexo*/ )

			Conout("*** NAO CONSEGUI FAZER O UPDATE DE REJEICAO" + cErroSql )
		Else
			SC1->( MsSeek( cFIL + cNUM + cITEM ) )
			cAprovBkp := SC1->C1_APROV
			MaAvalSC( 'SC1', 8,,,,,, cAprovBkp )

			Conout("*** CONSEGUI FAZER O UPDATE REJEICAO" )
		Endif
	End Transaction
	
	// Gravar o log do processo.
	A710LogResp( cUsrAprv, cSituacao, "", "", cFIL, cNUM, "", Time(), cErroSql, .T.,'PROCESSO DE REJEITAR SC ['+cFIL+'-'+cNUM+'-'+cITEM+'] EXECUTADO.' )
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A710MsgUsr | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de aviso ao usu�rio do compras quanto ao retorno do WF.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A710MsgUsr( cNumSC, cAcao, cMotivo, cC1_SOLICIT, cCodAprov )
	Local cHTML := ''
	Local cMV_710SUPR := 'MV_710SUPR'
	Local cAssunto := 'Retorno do workflow solicita��o de compras n� ' + SubStr( cNumSC, 1, 9 )
	Local cEMailElab := ''
	Local cSituacao := SubStr( cAcao, 1, 1 ) // Pode ser A=Aprovada ou R=Rejeitada.
	Local lRet1 := .T.
	Local lRet2 := .T.
	Local nVezes := 0
	Local cMV_710_04 := 'MV_710_04'
	Local cC1_FILIAL := SubStr( cNumSC, 1, 2 )
	Local cC1_NUM := SubStr( cNumSC, 4, 6 )
	Local cTime := ''
	Local cError := ''
	Local nTentativa := 0
	
	Conout("*** INICIANDO O PROCESSO A710MSGUSR" )
	
	If .NOT. GetMv( cMV_710SUPR, .T. )
		CriarSX6( cMV_710SUPR, 'C', 'EMAIL (ALIAS) DA AREA DE COMPRAS - ROTINA CSFA710.prw', 'compras1@certisign.com.br' )
	Endif
	
	cMV_710SUPR := GetMv( cMV_710SUPR, .F. )
	
	If .NOT. GetMv( cMV_710_04, .T. )
		CriarSX6( cMV_710_04, 'N',;
		'QTDE DE TENTATIVA DE ENVIAR E-MAIL DE RESPOSTA DO WF DE APROV SC. ROTINA CSFA710.prw.',;
		'2' )
	Endif
	
	nVezes := GetMv( cMV_710_04, .F. )
	
	PswOrder( 2 )
	PswSeek( cC1_SOLICIT )
	cEMailElab := PswRet( 1 )[ 1, 14 ]
	
	cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
	cHTML += '		<title>Aprova&ccedil;&atilde;o da solicita&ccedil;&atilde;o de compras</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle">'
	cHTML += '						<em><span style="font-size:22px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Aprova&ccedil;&atilde;o da Solicita&ccedil;&atilde;o de Compras</strong></font></span><br />'
	cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em></td>'
	cHTML += '					<td align="right" width="210">'
	cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
	cHTML += '						&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#F4811D" colspan="2" height="4" width="0">'
	cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px;" width="0">'
	cHTML += '						<p>'
	cHTML += '							<font color="#333333" face="Arial, Helvetica, sans-serif" size="2">Prezado(s),<br />'
	cHTML += '							<br />'
	cHTML += '							Este e-mail &eacute; informativo com o resultado da an&aacute;lise da solicita&ccedil;&atilde;o de compras.</font><br />'
	cHTML += '							<br />'
	cHTML += '							<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Por favor, qualquer necessidade procurar o respons&aacute;vel pela a a&ccedil;&atilde;o.</span></p>'
	cHTML += '						<hr />'
	cHTML += '						<table align="center" border="0" cellpadding="1" cellspacing="1" style="height: 160px; width: 400px">'
	cHTML += '							<tbody>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; vertical-align: middle; width: 150px; background-color: rgb(254, 219, 171);">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">N&ordm; Solicita&ccedil;&atilde;o:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+cNumSC+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; border-color: rgb(254, 219, 171); vertical-align: middle;">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Situa&ccedil;&atilde;o:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; border-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+cAcao+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Data:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+Dtoc(MsDate())+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; vertical-align: middle; border-color: rgb(254, 219, 171);">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Hora:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; border-color: rgb(254, 219, 171);">'
	cTime := Time()
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+cTime+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Motivo/Observa&ccedil;&atilde;o:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+cMotivo+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '							</tbody>'
	cHTML += '						</table>'
	cHTML += '						<hr />'
	cHTML += '						<p>'
	cHTML += '							<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Qualquer d&uacute;vida verfique a referida solicita&ccedil;&atilde;o de compras no sistema de gest&atilde;o</span><font color="#333333" face="Arial, Helvetica, sans-serif" size="2">.</font></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#02519B" colspan="2" height="2" width="0">'
	cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding: 5px; text-align: center;" width="0">'
	cHTML += '						<em style="color: rgb(102, 102, 102); font-family: Arial, Helvetica, sans-serif; font-size: small;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	cHTML += '</html>'
	
	// Enviar e-mail de resposta para compras.
	While nTentativa <= nVezes
		nTentativa++
		lRet1 := fSendMail( cMV_710SUPR, cAssunto, cHTML, /*cAnexo*/, @cError )
		If lRet1
			Exit
		Endif
		cError := cError + CRLF
	End
	
	// Gravar o log.
	A710LogResp( cMV_710SUPR, cMotivo, cCodAprov, cCodAprov, cC1_FILIAL, cC1_NUM, cHTML, cTime, cError, lRet1, 'E-MAIL P/ SUPRIMENTOS C/ RETORNO DO WF.' )
	
	nTentativa := 0
	
	// Enviar e-mail de resposta para o elaborador da solicita��o de compras.
	While nTentativa <= nVezes
		nTentativa++
		lRet2 := fSendMail( cEMailElab, cAssunto, cHTML, /*cAnexo*/, @cError )
		If lRet2
			Exit
		Endif
		cError := cError + CRLF
	End
	
	// Gravar o log.
	A710LogResp( cEMailElab, cMotivo, cCodAprov, cCodAprov, cC1_FILIAL, cC1_NUM, cHTML, cTime, cError, lRet2,'E-MAIL P/ O ELABORADOR C/ RETORNO DO WF.' )
	
	// Enviar e-mail para o compras.
	If .NOT. lRet1 .OR. .NOT. lRet2
		cMsg := 'ATEN��O,' + CRLF 
		If .NOT. lRet1
			cMsg += 'N�O CONSEGUI ENVIAR E-MAIL DE AVISO PARA �REA DE COMPRAS.' + CRLF
		Endif
		If .NOT. lRet2
			cMsg += 'N�O CONSEGUI ENVIAR E-MAIL DE AVISO PARA O ELABORADOR DA SOLICITA��O DE COMPRAS.' + CRLF
		Endif
		cMsg += 'POR FAVOR, ENCAMINHE PARA A �REA O ANEXO EM QUEST�O.' + CRLF + CRLF
		cMsg += 'PROTHEUS. ' + CRLF
		FsSendMail ( 'sistemascorporativos@certisign.com.br', 'RESPOSTA DE S.COMPAS N�O ENVIADA', cMsg, /*cAnexo*/ )
	Endif
	
	Conout("*** FINALIZANDO O PROCESSO A710MSGUSR" )
Return

//--------------------------------------------------------------------------
// Rotina | A710LogResp  | Autor | Robson Goncalves      | Data | 15/03/2018
//--------------------------------------------------------------------------
// Descr. | Rotina para gravar log de processo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710LogResp( cEMAIL, cMOTIVO, cAPROV, cUSER, cFIL, cSC, cHTML, cTIME, cLOG, lRet, cINFO )
	Local cGT_IDOPER := ''
	//----------------------------------
	// Fazer a abertura da tabela GTLOG.
	If Select('GTLOG') <= 0
		StaticCall( CSFA610, A610USEGTL )
	Endif
	//--------------------------------------
	// Capturar o pr�ximo n�mero dispon�vel.
	cGT_IDOPER := 'SC-' + A710PrxNum()
	
	Conout("*** INICIANDO O PROCESSO A710LOGRESP " + cGT_IDOPER)
	
	//---------------------------
	// Efetuar a grava��o do LOG.
	GTLOG->( RecLock( 'GTLOG', .T. ) )
	GTLOG->GT_IDOPER  := cGT_IDOPER
	GTLOG->GT_DTOPER  := MsDate()
	GTLOG->GT_ACAO    := 'L'
	GTLOG->GT_EMAIL   := cEMAIL
	GTLOG->GT_MOTIVO  := cMOTIVO
	GTLOG->GT_CODAPRO := cAPROV
	GTLOG->GT_CODUSER := cUSER
	GTLOG->GT_FILPC   := cFIL
	GTLOG->GT_NUMPC   := cSC
	GTLOG->GT_PARAM   := cHTML
	GTLOG->GT_SEND    := Iif( lRet, 'T', 'F' )
	GTLOG->GT_INIPROC := Iif( lRet, 'T', 'F' )
	GTLOG->GT_DTPROC  := MsDate()
	GTLOG->GT_HRPROC  := cTIME
	GTLOG->GT_LOG     := cLOG
	GTLOG->GT_INFO    := cINFO
	GTLOG->( MsUnLock() )

	Conout("*** FINALIZANDO O PROCESSO A710LOGRESP" )
Return

//--------------------------------------------------------------------------
// Rotina | A710PrxNum | Autor | Robson Goncalves        | Data | 15/03/2018
//--------------------------------------------------------------------------
// Descr. | Rotina para capturar o pr�ximo n�mero de registro de log.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710PrxNum()
	Local cMV_710_03 := 'MV_710_03'
	
	If .NOT. GetMv( cMV_710_03, .T. )
		CriarSX6( cMV_710_03, 'C',;
		'ULTIMO NUMERO SEQUENCIAL COM A TABELA DE LOG DE PROCESSAMENTO DE RETORNO DE WF. ESTE VALOR NAO DEVE SER ALTERADO PELOS USUARIOS. ROTINA CSFA710.prw.',;
		'000000' )
	Endif
	
	cMV_710_03 := Soma1( GetMv( cMV_710_03, .F. ) )
	
	While GTLOG->( dbSeek( 'SC-' + cMV_710_03 ) )
		cMV_710_03 := Soma1( cMV_710_03 )
	End
	
	PutMV( 'MV_710_03', cMV_710_03 )
Return( cMV_710_03 )

//--------------------------------------------------------------------------
// Rotina | A710LeArq | Autor | Robson Goncalves         | Data | 15.03.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para ler arquivo texto.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A710LeArq( cFile )
	Local cLine := ""
	FT_FUSE( cFile )
	FT_FGOTOP()
	While .NOT. FT_FEOF()
		cLine += FT_FREADLN()
		FT_FSKIP()
	End
	FT_FUSE()
Return( cLine )

//--------------------------------------------------------------------------
// Rotina | A710Tranf | Autor | Robson Goncalves         | Data | 15.03.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para transferir a responsabilidade de al�ada.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A710Tranf()
	Local aArea := {}
	Local aButton := {}
	Local aPar := {}
	Local aRet := {}
	Local aSay := {}
	
	Local cMV_710_02 := 'MV_710_02'
	Local cObs := ''
	Local cTexto := ''
	Local cTitulo := 'Transfer�ncia de aprovador de solicita��o de compras'
	Local cUsr := RetCodUsr()
	
	Local lFez := .F.
	Local nOpcao := 0
	
	If .NOT. GetMv( cMV_710_02, .T. )
		CriarSX6( cMV_710_02, 'C', 'CODIGO DOS USUARIOS AUTORIZADOS A UTILIZAR A ROTINA (CSFA710) TRANSF. APROV. SC', '000000|002577' )
	Endif
	
	cMV_710_02 := GetMv( cMV_710_02, .F. )

	CreateSXB()
	
	AAdd( aSay, 'Esta rotina permite transferir o aprovador da solicita��o de compras sem modificar' )
	AAdd( aSay, 'a apropria��o do custo, ou seja, sem modificar o centro de custo dos produtos/rateios.' )
	AAdd( aSay, 'Somente usu�rios autorizados rodam este processo - par�metro MV_710_02.' )
	AAdd( aSay, 'Usu�rios autorizados: ' + cMV_710_02 )
	AAdd( aSay, 'Seu c�digo de usu�rio �: ' + cUsr )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpcao <> 1
		Return
	Endif
	
	aArea := { GetArea(), SC1->( GetArea() ), SAK->( GetArea() ) }
		
	AAdd( aPar, { 1, 'N� SC de'      ,Space(Len(SC1->C1_NUM)) ,'','','710SC1','',50,.T.})
	AAdd( aPar, { 1, 'Item da SC de' ,Space(Len(SC1->C1_ITEM)),'','',''      ,'',30,.T.})
	
	AAdd( aPar, { 1, 'N� SC at�'     ,Space(Len(SC1->C1_NUM)) ,'','','710SC1','',50,.T.})
	AAdd( aPar, { 1, 'Item da SC at�',Space(Len(SC1->C1_ITEM)),'','',''      ,'',30,.T.})
	
	AAdd( aPar, { 1, 'Aprovador substituto',Space(6)                ,'','','SAK'   ,'',50,.T.})
	
	While .T.
		If ParamBox( aPar, 'Par�metros de transf. de aprovador', @aRet,,,,,,,, .F., .F. )
			cTexto := 'O usu�rio '+cUsr+' '+RTrim(UsrFullName(cUsr))+;
			          ' substituiu o aprovador deste documento para '+aRet[5]+' '+;
					  RTrim(SAK->(GetAdvFVal('SAK','AK_NOME',xFilial('SAK')+aRet[5],1)))+' '+;
					  ' em '+Dtoc(MsDate())+' '+Time()+'.'
			
			dbSelectArea( 'SC1' )
			dbSetOrder( 1 ) 
			If dbSeek( xFilial( 'SC1' ) + aRet[ 1 ] + aRet[ 2 ] ) 
				While SC1->( .NOT. EOF() ) .AND. ;
					SC1->C1_FILIAL == xFilial( 'SC1' ) .AND. ;
					SC1->C1_NUM + SC1->C1_ITEM <= aRet[ 3 ] + aRet[ 4 ]
					
					If Empty( SC1->C1_RESIDUO ) .AND. ;
						SC1->C1_QUJE == 0 .AND. ;
						SC1->C1_APROV == 'B' .AND. ;
						Empty( SC1->C1_COTACAO ) .AND. ;
						Empty( SC1->C1_PEDIDO )
						
						lFez := .T.
						SC1->( RecLock( 'SC1', .F. ) )
						SC1->C1_ORCAM := aRet[ 5 ]
						
						If .NOT. Empty( SC1->C1_OBS_SOL )
							cObs := AllTrim( SC1->C1_OBS_SOL ) + CRLF + cTexto
						Else
							cObs := cTexto
						Endif
						
						SC1->C1_OBS_SOL := cTexto 
						
						SC1->( MsUnLock() )
					Endif
					SC1->( dbSkip() )
				End
				If lFez
					MessageBox('Opera��o de transfer�ncia de aprovavor realizada com sucesso.',cTitulo,0)
				Endif
				lFez := .F.
			Endif
		Else
			Exit
		Endif
	End
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return

//--------------------------------------------------------------------------
// Rotina | fSendMail | Autor | Robson Goncalves         | Data | 01.03.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para enviar e-mail, espec�fico para recuperar o erro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function fSendMail( cEmail, cAssunto, cMensagem, cAttach, cError )
	Local aArea     := GetArea()
	Local cEmailTo  := ""								// E-mail de destino
	Local cEmailBcc := ""								// E-mail de copia
	Local lResult   := .F.								// Se a conexao com o SMPT esta ok
	Local lRelauth  := SuperGetMv("MV_RELAUTH",, .F.)	// Parametro que indica se existe autenticacao no e-mail
	Local lRet	    := .F.								// Se tem autorizacao para o envio de e-mail
	Local cConta    := Trim(GetMV('MV_RELACNT')) 		// Conta Autenticacao Ex.: fuladetal@fulano.com.br
	Local cPsw      := Trim(GetMV('MV_RELAPSW')) 		// Senha de acesso Ex.: 123abc
	Local cServer   := Trim(GetMV('MV_RELSERV')) 		// Ex.: smtp.ig.com.br ou 200.181.100.51
	Local cFrom	    := Trim(GetMV('MV_RELFROM')) 		// e-mail utilizado no campo From'MV_RELACNT' ou 'MV_RELFROM' e 'MV_RELPSW'
	
	Default cError  := ""								// String de erro
	Default cAttach := ""
	
	//�����������������������������������������������������������������������������Ŀ
	//�Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense�
	//�que somente ela recebeu aquele email, tornando o email mais personalizado.   �
	//�������������������������������������������������������������������������������
	cEmailTo := cEmail
	If At( ";", cEmail ) > 0 // existe um segundo e-mail.
		cEmailBcc := SubStr( cEmail, At( ";", cEmail ) + 1, Len( cEmail ) )
	Endif
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPsw RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth( cConta, cPsw )
		Else
			lRet := .T.
		Endif
		
		If lRet
			SEND MAIL;
			FROM 		cFrom;
			TO      	cEmailTo;
			BCC     	cEmailBcc;
			SUBJECT 	cAssunto;
			BODY    	cMensagem;
			ATTACHMENT  cAttach  ;
			RESULT 		lResult
			
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				If !IsBlind()
					Help( " ", 1, "01 - " + "Aten��o", , cError + " " + cEmailTo, 4, 5 )
				Else
					ApMsgInfo( "01 - " + "Aten��o" + " " + cError + " " + cEmailTo )
				EndIf
			Endif
			
		Else
			GET MAIL ERROR cError
			If !IsBlind()
				Help( " ", 1, "02 - " + "Autentica��o", , cError, 4, 5 )
			Else
				ApMsgStop( "02 - " + "Erro de autentica��o", "Verifique a conta e a senha para envio." )
			EndIf
		Endif
		
		DISCONNECT SMTP SERVER
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		If !IsBlind()
			Help( " ", 1, "03 - " + "Aten��o", , cError, 4, 5 )
		Else
			ApMsgInfo( "03 - " + "Aten��o" + " " + cError )
		EndIf
	Endif
	
	RestArea( aArea )
Return (lResult)

//--------------------------------------------------------------------------
// Rotina | CreateSXB | Autor | Robson Goncalves         | Data | 15.03.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para criar a consulta SXb.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function CreateSXB()
	Local aDADOS := {}
	Local cXB_ALIAS := '710SC1'
	
	AAdd( aDADOS, { cXB_ALIAS, "1", "01", "DB", "Solicitacao + Item","Solicitacao + Item","Solicitacao + Item","SC1","" } )

	AAdd( aDADOS, { cXB_ALIAS, "2", "01", "01", "Solicitacao","Solicitacao","Solicitacao","","" } )

	AAdd( aDADOS, { cXB_ALIAS, "4", "01", "01", "Solicitacao","","","C1_NUM"    ,"" } )
	AAdd( aDADOS, { cXB_ALIAS, "4", "01", "02", "Item"       ,"","","C1_ITEM"   ,"" } )
	AAdd( aDADOS, { cXB_ALIAS, "4", "01", "03", "Produto"    ,"","","C1_PRODUTO","" } )
	AAdd( aDADOS, { cXB_ALIAS, "4", "01", "04", "Quantidade" ,"","","C1_QUANT"  ,"" } )

	AAdd( aDADOS, { cXB_ALIAS, "5", "01", ""  , "","","","SC1->C1_NUM" ,"" } )
	AAdd( aDADOS, { cXB_ALIAS, "5", "02", ""  , "","","","SC1->C1_ITEM","" } )
	
	StaticCall( CSFA610, CRIASXB, aDADOS )
Return

//-----------------------------------------------------------------------
// Rotina | UPD710     | Autor | Robson Gon�alves     | Data | 21/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD710()
	Local cModulo := 'COM'
	Local bPrepar := {|| NIL }
	Local nVersao := 2
	
	If nVersao == 1
		bPrepar := {|| U_U710Ini1() }
	Elseif nVersao == 2
		bPrepar := {|| U_U710Ini2() }
	Endif
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U710Ini1   | Autor | Robson Gon�alves     | Data | 21/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U710Ini1()
	aSX3 := {}
	aSX7 := {}
	aHelp := {}
	AAdd(aSX3,{"SC1",NIL,"C1_APROVCC","C",30,0,"Aprov.C.Cust","Aprov.C.Cust","Aprov.C.Cust","Nome aprovador do C.Custo","Nome aprovador do C.Custo","Nome aprovador do C.Custo","","","���������������","","",0,"��","","","U","N","V","R","","","","","","","","","","","","",""," ","N","N","",""})
	AAdd(aSX3,{"SC1",NIL,"C1_DTAVAL" ,"D", 8,0,"Dt. Acao WF","Dt. Acao WF","Dt. Acao WF","Data da acao do WF","Data da acao do WF","Data da acao do WF","","","���������������","","",0,"��","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aHelp,{"C1_APROVCC","Nome do aprovador conforme o centro de custo informado."})
	AAdd(aHelp,{"C1_DTAVAL","Data de retorno da avalia��o do workflow de aprova��o da solicita��o de compras."})
	AAdd(aSX7,{"C1_CC","001","U_A710CC()","C1_APROVCC","P","N","",0,"","","U"})
Return

//-----------------------------------------------------------------------
// Rotina | U710Ini2   | Autor | Robson Gon�alves     | Data | 21/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U710Ini2()
	aSX3 := {}
	aSX7 := {}
	aHelp := {}
	AAdd(aSX3,{"SC1",NIL,"C1_MAIL_ID","C",20,0,"Mail ID WF","Mail ID WF","Mail ID WF","Mail ID do WF de Aprov.","Mail ID do WF de Aprov.","Mail ID do WF de Aprov.","","","���������������","","",0,"��","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aHelp,{"C1_MAIL_ID","Mail ID do workflow da aprova��o da solicita��o de compras."})
Return
