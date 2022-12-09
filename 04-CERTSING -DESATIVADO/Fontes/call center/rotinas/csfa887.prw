/******
 * 0 = INCLUÍDO
 * 1 = PAGAMENTO IDENTIFICADO
 * 2 = PAGAMENTO NÃO IDENTIFICADO
 * 3 = AGUARDANDO FOLLOW-UP FINANCEIRO
 * 4 = AGUARDANDO FOLLOW-UP SEGURANÇA
 * 9 = ENCERRADO
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
 * <PBP_STATUS> <PBP_TENT1> <PBP_TENT2> <AÇÃO SISTÊMICA OU HUMANA>
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
 *  0            0           0           INCLUÍDO PELO RIGHTNOW.
 *  1            1           0           O 1º JOB CONSEGUIU IDENTIFICAR O PAGAMENTO.
 * ATÉ AQUI O ASSUNTO ESTÁ ENCERRADO, NÃO PRECISA MODIFICAR NENHUM STATUS.
 *  2            2           0           O 1º JOB NÃO CONSEGUIU IDENTIFICAR O PAGAMENTO, O FINANCEIRO SERÁ AVISADO POR E-MAIL + ANEXO EXCEL ATÉ 3X.
 *  2            3           0           O 1º JOB NÃO CONSEGUIU IDENTIFICAR O PAGAMENTO, O FINANCEIRO SERÁ AVISADO POR E-MAIL + ANEXO EXCEL ATÉ 3X.
 * SE NA TERCEIRA TENTATIVA NÃO HOUVER UMA AÇÃO A SEGURANÇA SERÁ AVISADA.
 *  3            3           1           O 2º JOB AVISA POR E-MAIL A SEGURANÇA DA PENDÊNCIA DO FINANCEIRO.
 *  3            3           2           O 2º JOB AVISA POR E-MAIL A SEGURANÇA DA PENDÊNCIA DO FINANCEIRO.
 *  3            3           3           O 2º JOB AVISA POR E-MAIL A SEGURANÇA DA PENDÊNCIA DO FINANCEIRO.
 * SE NA TERCEIRA TENTATIVA NÃO HOUVER UMA AÇÃO A EQUIPE DE SISTEMAS CORPORATIVOS SERÁ AVISADO DA GRAVIDADE ETERNAMENTE PELO 3º JOB.
 *  4            3           3           O 3º JOB AVISA SISTEMAS CORPORATIVOS DA PENDÊNCIA DA SEGURANÇA QUE FICOU PENDENTE DO FINANCEIRO.
 *  9            ?           ?           PROCESSO ENCERRADO PELO FINANCEIRO OU SEGURANÇA QUANDO EFETUAR O FOLLOW-UP.
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
 * 
 ***/
#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'tbiconn.ch'

STATIC cPasta 	:= 'ident_pagto'
STATIC cBarra 	:= Iif( IsSrvUnix(), '/', '\' )
STATIC cExt   	:= '.xml'
STATIC __url 	:= ''
STATIC __Head 	:= {}
STATIC __endPoint := ''

User Function CSFA887A( aParamJob )
	Local cEmp := ''
	Local cFil := ''
	
	cEmp := Iif( aParamJob == NIL, '01', aParamJob[ 1 ] )
	cFil := Iif( aParamJob == NIL, '02', aParamJob[ 2 ] )
	
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'FAT'
		U_A887Prc1()
	RESET ENVIRONMENT
Return

User Function CSFA887B( aParamJob )
	Local cEmp := ''
	Local cFil := ''
	
	cEmp := Iif( aParamJob == NIL, '01', aParamJob[ 1 ] )
	cFil := Iif( aParamJob == NIL, '02', aParamJob[ 2 ] )
	
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'FAT'
		U_A887Prc2()
	RESET ENVIRONMENT
Return

User Function CSFA887C( aParamJob )
	Local cEmp := ''
	Local cFil := ''
	
	cEmp := Iif( aParamJob == NIL, '01', aParamJob[ 1 ] )
	cFil := Iif( aParamJob == NIL, '02', aParamJob[ 2 ] )
	
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'FAT'
		U_A887Prc3()
	RESET ENVIRONMENT
Return

user function A887Prc1()
A887P1()
return

user function A887Prc2()
A887P2()
return

user function A887Prc3()
A887P3()
return

//-----------------------------------------------------------------------
// Rotina | A887P1  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Rotina do primeira situação - Identifica os pedidos  
//-----------------------------------------------------------------------
Static Function A887P1()
	Local aChkOut 		:= {}
	Local aMsg			:= {}
	Local cHTML 		:= ''
	Local cLog 			:= ''
	Local cProtocolo 	:= ''
	Local cAssunto		:= ''
	Local cSQL 			:= ''
	Local cTRB 			:= ''
	Local cStatus 		:= ''
	Local cTime 		:= Time()
	Local dDate			:= Date()
	Local dMV_DATA 		:= dDate-1
	Local nDow 			:= Dow( dDate )
	Local nElem 		:= 0	
	Local lSC5 			:= .F.
	Local lSE1 			:= .F.
	
	Private aIdent 		:= {}
	Private aNoIdent 	:= {}
	Private aLog		:= {}
	Private oFwRest 	:= NIL
	
	MakeDir( cBarra + cPasta + cBarra )
	
	// Se for domingo ou sábado não processa
	If nDow > 1 .AND. nDow < 7
		// PBP_STATUS = '0' =====================================> Liberação de pagamento incluído. 
		// PBP_STATUS = '2' AND PBP_TENT1 < 3 AND PBP_TENT2 = 0 => Liberação de pagamento não identificado. 
		cSQL := "SELECT PBP.R_E_C_N_O_ AS PBP_RECNO "
		cSQL += "FROM   " + RetSqlName( "PBP" ) + " PBP "
		cSQL += "WHERE  PBP_FILIAL = " + ValToSql( xFilial( "PBP" ) ) + " "
		cSQL += "       AND PBP_STATUS IN ('0','2') " 
		cSQL += "       AND PBP_TENT1 < 3 "
		cSQL += "       AND PBP_TENT2 = 0 "
		cSQL += "       AND PBP_DATA <= " + ValToSql( dMV_DATA ) + " "
		cSQL += "       AND PBP.D_E_L_E_T_ = ' ' "

		cSQL += "ORDER  BY PBP_FILIAL, "
		cSQL += "          PBP_PSITE "
		
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		
		dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTRB, .T., .T. )
		dbSelectArea( cTRB )
		
		If (cTRB)->( .NOT. BOF() ) .AND. (cTRB)->( .NOT. EOF() )
			// Criar um número de protocolo.
			cProtocolo := CriaTrab( NIL , .F. )
			
			dbSelectArea( 'SE1' )
			SE1->( dbSetOrder( 1 ) )
			
			dbSelectArea( 'SC5' )
			If FindNickName( 'SC5', 'PEDSITE' )
				SC5->( dbOrderNickName( 'PEDSITE' ) )
			Endif
			
			dbSelectArea( 'PBP' )
			PBP->( dbSetOrder( 1 ) )
			
			// Ler a query.
			While (cTRB)->( .NOT. EOF() )
				// Posicionar no registro origem da query.
				PBP->( dbGoTo( (cTRB)->PBP_RECNO ) )
				
				// Tentar localizar o pedido protheus com o pedido site.
				lSC5 := SC5->( dbSeek( xFilial( 'SC5' ) + PBP->PBP_PSITE ) )
				
				// Se achou, tentar localizar o título a receber.
				If lSC5
					lSE1 := SE1->( dbSeek( xFilial( 'SE1' ) + 'RCP' + SC5->C5_NUM ) )
					If .NOT. lSE1
						lSE1 := SE1->( dbSeek( xFilial( 'SE1' ) + 'RCO' + SC5->C5_NUM ) )
					Endif
				Endif

				// Se acho pedido protheus e achou o títlo a receber.
				If lSC5 .AND. lSE1
					cStatus := '1'
					cLog := 'EM ' + Dtoc( dDate ) + ' ' + cTime + ' IDENTIFICADO O PAGAMENTO DO PEDIDO SITE ' + RTrim( PBP->PBP_PSITE ) + ' PEDIDO PROTHEUS ' + SC5->C5_NUM + ' E TITULO A RECEBER ' + LTrim( Str( SE1->( RecNo() ) ) ) + '.'
				Else
					cStatus := '2'
					cLog := 'EM ' + Dtoc( dDate ) + ' ' + cTime + ' NÃO IDENTIFICADO O PAGAMENTO DO PEDIDO SITE ' + RTrim( PBP->PBP_PSITE ) + '.'
				Endif
				
				cLog := cLog + ' PROTOCOLO: ' + cProtocolo + '.'
				
				// Buscar os dados do check-out.
				PesqChkOut( cLog, @aChkOut )
				
				// Atribuir para os arrays que irão gerar base de dados para o excel.
				If cStatus == '1'
					AAdd( aIdent, '' )
					nElem := Len( aIdent )
					aIdent[ nElem ] := {}
					aIdent[ nElem ] := Array( 35 )
					aFill( aIdent[ nElem ], '' )
					aIdent[ nElem ] := AClone( aChkOut )
				Else
					AAdd( aNoIdent, '' )
					nElem := Len( aNoIdent )
					aNoIdent[ nElem ] := {}
					aNoIdent[ nElem ] := Array( 35 )
					aFill( aNoIdent[ nElem ], '' )
					aNoIdent[ nElem ] := AClone( aChkOut )
				Endif
				
				// Limpar o array de transição.
				aChkOut := {}
				
				// Atualizar o registro em questão na situação aqui identificada.
				UpDatePBP( cStatus, cLog )
				
				(cTRB)->( dbSkip() )
				
				lSC5 := .F.
				lSE1 := .F.
			End

			// Criar a planilha excel.
			CreateExcel( cProtocolo )
			
			// Monta a mensagem do corpo do e-Mail.
			aMsg := MakeMsg( 'FIN' )

			// Gerar o HTML para enviar e-Mail.
			cHTML := LoadHTML( aMsg[ 1 ], aMsg[ 2 ], aMsg[ 3 ], cProtocolo )
			
			// Enviar o e-Mail para o financeiro com a o planilha em anexo.
			SendMail( cHTML, 1, cProtocolo )
		Endif
		(cTRB)->( dbCloseArea() )	
		FErase( cTRB + GetDBExtension() )		
	Endif

	If Len( aLog ) > 0
		cAssunto := 'Log de identificação de pagamento [' + Dtoc( dDate ) + '].'
		
		cLog := 'Prezados, ' + CRLF
		cLog += 'Abaixo o log relativo ao resultado do processamento da rotina job1 (CSFA887) de identificação de pagamento:' + CRLF + CRLF 
		For i := 1 To Len( aLog )
			cLog += aLog[ i ] + CRLF
		Next i
		cLog += CRLF
		cLog += 'Atenciosamente, ' + CRLF 
		cLog += 'Sistema de Gestão ERP Protheus'
		FSSendMail( 'sistemascorporativos@certisign.com.br', cAssunto, cLog, /*cAnexo*/ )
	Endif

Return

//-----------------------------------------------------------------------
// Rotina | A887P2  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Rotina da segunda situação - Notifica Segurança
//-----------------------------------------------------------------------
Static Function A887P2()
	Local aChkOut 		:= {}
	Local aMsg			:= {}
	Local cHTML 		:= ''
	Local cLog 			:= ''
	Local cProtocolo 	:= ''
	Local cSQL 			:= ''
	Local cTRB 			:= ''
	Local cStatus 		:= ''
	Local cTime 		:= Time()
	Local dDate			:= Date()
	Local dMV_DATA 		:= dDate-1
	Local nDow 			:= Dow( dDate )
	Local nPBP_TENT2 	:= 0
	
	Private aIdent 		:= {}
	Private aNoIdent 	:= {}
	Private aLog		:= {}
	Private oFwRest 	:= NIL

	MakeDir( cBarra + cPasta + cBarra )

	// Se for domingo ou sábado não processa
	If nDow > 1 .AND. nDow < 7
		// PBP_STATUS = 2 AND PBP_TENT1 = 3 AND PBP_TENT2 < 3 => Liberação de pagamento não identificado e tentativa1 excedida.
		cSQL := "SELECT PBP.R_E_C_N_O_ AS PBP_RECNO "
		cSQL += "FROM   " + RetSqlName( "PBP" ) + " PBP "
		cSQL += "WHERE  PBP_FILIAL = " + ValToSql( xFilial( "PBP" ) ) + " "
		cSQL += "       AND PBP_STATUS IN ('2','3') "
		cSQL += "       AND PBP_TENT1 = 3 "
		cSQL += "       AND PBP_TENT2 < 3 "
		cSQL += "       AND PBP_DATA <= " + ValToSql( dMV_DATA ) + " "
		cSQL += "       AND PBP.D_E_L_E_T_ = ' ' "
		
		cSQL += "ORDER  BY PBP_FILIAL, "
		cSQL += "          PBP_PSITE "
		
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		
		dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTRB, .T., .T. )
		dbSelectArea( cTRB )
		
		If (cTRB)->( .NOT. BOF() ) .AND. (cTRB)->( .NOT. EOF() )
			// Criar um número de protocolo.
			cProtocolo := CriaTrab( NIL , .F. )

			dbSelectArea( 'PBP' )
			PBP->( dbSetOrder( 1 ) )
			
			While (cTRB)->( .NOT. EOF() )
				PBP->( dbGoTo( (cTRB)->PBP_RECNO ) )
				
				nPBP_TENT2 := PBP->PBP_TENT2 + 1
				
				cLog := 'EM ' + Dtoc( dDate ) + ' ' + cTime + ' INFORMADO A FINALIZAÇÃO DE TENTATIVAS DE IDENTIFICAÇÃO DE PAGAMENTO.'
				cPBP_LOG := AllTrim( PBP->PBP_LOG )
				
				// Buscar os dados do check-out.
				PesqChkOut( cLog, @aChkOut )

				If .NOT. Empty( cPBP_LOG )
					cLog := cLog + CRLF + cPBP_LOG
				Endif
				
				PBP->( RecLock( 'PBP', .F. ) )
				PBP->PBP_LOG   := cLog
				PBP->PBP_TENT2 := nPBP_TENT2
				If PBP->PBP_STATUS == '2'
					PBP->PBP_STATUS := '3'
					PBP->PBP_DESCRI := 'AGUARDANDO FOLLOW-UP FINANCEIRO'
				Endif
				PBP->( MsUnLock() )
				
				AAdd( aNoIdent, '' )
				nElem := Len( aNoIdent )
				aNoIdent[ nElem ] := {}
				aNoIdent[ nElem ] := Array( 35 )
				aFill( aNoIdent[ nElem ], '' )
				aNoIdent[ nElem ] := AClone( aChkOut )

				// Limpar o array de transição.
				aChkOut := {}

				(cTRB)->( dbSkip() )
			End
			
			// Criar a planilha excel.
			CreateExcel( cProtocolo )
			
			// Monta a mensagem do corpo do e-Mail.
			aMsg := MakeMsg( 'SEG' )

			// Gerar o HTML para enviar e-Mail.
			cHTML := LoadHTML( aMsg[ 1 ], aMsg[ 2 ], aMsg[ 3 ], cProtocolo )
			
			// Enviar o e-Mail para a segurança com a o planilha em anexo.
			SendMail( cHTML, 2, cProtocolo )
		Endif
		(cTRB)->( dbCloseArea() )
		FErase( cTRB + GetDBExtension() )
	Endif

	If Len( aLog ) > 0
		cAssunto := 'Log de identificação de pagamento [' + Dtoc( dDate ) + '].'
		
		cLog := 'Prezados, ' + CRLF
		cLog += 'Abaixo o log relativo ao resultado do processamento da rotina job2 (CSFA887) de identificação de pagamento:' + CRLF + CRLF 
		For i := 1 To Len( aLog )
			cLog += aLog[ i ] + CRLF
		Next i
		cLog += CRLF
		cLog += 'Atenciosamente, ' + CRLF 
		cLog += 'Sistema de Gestão ERP Protheus'
		FSSendMail( 'sistemascorporativos@certisign.com.br', cAssunto, cLog, /*cAnexo*/ )
	Endif

Return

//-----------------------------------------------------------------------
// Rotina | A887P3  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Rotina da segunda situação - Notifica Sistemas
//-----------------------------------------------------------------------
Static Function A887P3()
	Local aChkOut 		:= {}
	Local aMsg			:= {}
	Local cHTML 		:= ''
	Local cLog 			:= ''
	Local cProtocolo 	:= ''
	Local cSQL 			:= ''
	Local cTRB 			:= ''
	Local cStatus 		:= ''
	Local cTime 		:= Time()
	Local dDate			:= Date()
	Local dMV_DATA 		:= dDate-1
	Local nDow 			:= Dow( dDate )
	
	Private aIdent 		:= {}
	Private aNoIdent 	:= {}
	Private aLog		:= {}
	Private oFwRest 	:= NIL

	MakeDir( cBarra + cPasta + cBarra )
	
	// Se for domingo ou sábado não processa
	If nDow > 1 .AND. nDow < 7
		cSQL := "SELECT PBP.R_E_C_N_O_ AS PBP_RECNO "
		cSQL += "FROM   " + RetSqlName( "PBP" ) + " PBP "
		cSQL += "WHERE  PBP_FILIAL = " + ValToSql( xFilial( "PBP" ) ) + " "
		cSQL += "       AND PBP_STATUS IN ('3','4') "
		cSQL += "       AND PBP_TENT1 = 3 "
		cSQL += "       AND PBP_TENT2 = 3 "
		cSQL += "       AND PBP_DATA <= " + ValToSql( dMV_DATA ) + " "
		cSQL += "       AND PBP.D_E_L_E_T_ = ' ' "
		
		cSQL += "ORDER  BY PBP_FILIAL, "
		cSQL += "          PBP_PSITE "
		
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		
		dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTRB, .T., .T. )
		dbSelectArea( cTRB )
		
		If (cTRB)->( .NOT. BOF() ) .AND. (cTRB)->( .NOT. EOF() )
			// Criar um número de protocolo.
			cProtocolo := CriaTrab( NIL , .F. )
			
			dbSelectArea( 'PBP' )
			PBP->( dbSetOrder( 1 ) )
			
			While (cTRB)->( .NOT. EOF() )
				PBP->( dbGoTo( (cTRB)->PBP_RECNO ) )
				
				cLog := 'EM ' + Dtoc( dDate ) + ' ' + cTime + ' INFORMADO QUE NÃO HOUVER FOLLOW-UP FINANCEIRO E SEGURANÇA. SITUAÇÃO CRÍTICA.'
				cPBP_LOG := AllTrim( PBP->PBP_LOG )
				
				// Buscar os dados do check-out.
				PesqChkOut( cLog, @aChkOut )

				If .NOT. Empty( cPBP_LOG )
					cLog := cLog + CRLF + cPBP_LOG
				Endif
				
				PBP->( RecLock( 'PBP', .F. ) )
				PBP->PBP_LOG   := cLog
				If PBP->PBP_STATUS == '3'
					PBP->PBP_STATUS := '4'
					PBP->PBP_DESCRI := 'AGUARDANDO FOLLOW-UP SEGURANCA'
				Endif
				PBP->( MsUnLock() )
				
				AAdd( aNoIdent, '' )
				nElem := Len( aNoIdent )
				aNoIdent[ nElem ] := {}
				aNoIdent[ nElem ] := Array( 35 )
				aFill( aNoIdent[ nElem ], '' )
				aNoIdent[ nElem ] := AClone( aChkOut )

				// Limpar o array de transição.
				aChkOut := {}
				
				(cTRB)->( dbSkip() )
			End
			
			// Criar a planilha excel.
			CreateExcel( cProtocolo )
			
			// Monta a mensagem do corpo do e-Mail.
			aMsg := MakeMsg( 'SIS' )

			// Gerar o HTML para enviar e-Mail.
			cHTML := LoadHTML( aMsg[ 1 ], aMsg[ 2 ], aMsg[ 3 ], cProtocolo )
			
			// Enviar o e-Mail para a segurança com a o planilha em anexo.
			SendMail( cHTML, 3, cProtocolo )
		Endif
		(cTRB)->( dbCloseArea() )
		FErase( cTRB + GetDBExtension() )
	Endif

	If Len( aLog ) > 0
		cAssunto := 'Log de identificação de pagamento [' + Dtoc( dDate ) + '].'
		
		cLog := 'Prezados, ' + CRLF
		cLog += 'Abaixo o log relativo ao resultado do processamento da rotina job3 (CSFA887) de identificação de pagamento:' + CRLF + CRLF 
		For i := 1 To Len( aLog )
			cLog += aLog[ i ] + CRLF
		Next i
		cLog += CRLF
		cLog += 'Atenciosamente, ' + CRLF 
		cLog += 'Sistema de Gestão ERP Protheus'
		FSSendMail( 'sistemascorporativos@certisign.com.br', cAssunto, cLog, /*cAnexo*/ )
	Endif
	
Return

//-----------------------------------------------------------------------
// Rotina | UpDatePBP  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Atualiza status do registro  
//-----------------------------------------------------------------------
Static Function UpDatePBP( cStatus, cLog )
	Local cPBP_DESCRI := ''
	Local cPBP_LOG := ''
	Local nPBP_TENT1 := 0
	
	nPBP_TENT1 := PBP->PBP_TENT1 + 1
	
	cPBP_DESCRI := Iif( cStatus == '1', 'PAGAMENTO IDENTIFICADO', 'PAGAMENTO NAO IDENTIFICADO' )
	
	cPBP_LOG := AllTrim( PBP->PBP_LOG )
	
	If .NOT. Empty( cPBP_LOG )
		cLog := cLog + CRLF + cPBP_LOG
	Endif
	
	PBP->( RecLock( 'PBP', .F. ) )
	PBP->PBP_STATUS := cStatus
	PBP->PBP_DESCRI := cPBP_DESCRI
	PBP->PBP_LOG    := cLog
	PBP->PBP_TENT1 := nPBP_TENT1
	PBP->( MsUnLock() )
Return

//-----------------------------------------------------------------------
// Rotina | PesqChkOut  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Consulta dados do pedido no CheckOut  
//-----------------------------------------------------------------------
Static Function PesqChkOut( cLog, aChkOut )
	Local aHead := {}
	
	Local cGetResult := ''
	Local cTpPessoa := ''
	
	Local lGet := .F.
	
	Local oChkOut 
	
	Private json 
	
	If oFwRest == NIL
		oChkOut := checkoutParam():get()
		__url := oChkOut:url
		__endPoint := oChkOut:endPoint
		
		AAdd( aHead, 'Content-Type: application/json' )
		AAdd( aHead, 'Accept: application/json' )
		AAdd( aHead, 'Authorization: Basic ' + EnCode64( oChkOut:userCode + ':' + oChkOut:password ) )
		
		__Head := AClone( aHead )
		
		oFwRest := FWRest():New( __url )
	Endif
	
	oFwRest:setPath( __endPoint + '/' + PBP->PBP_PSITE )
	
	lGet := oFwRest:Get( __Head )
	cGetResult := oFwRest:GetResult()
	
	aChkOut := Array( 35 )
	aFill( aChkOut, '' )

	If lGet
		FWJsonDeserialize( cGetResult, @json )
		
		If Type( "jSon:faturamentoPJ:cnpj" ) == "U"
			cTpPessoa := 'FISICA'
		Else
			cTpPessoa := 'JURIDICA'
		Endif
		
		aChkOut[ 1 ] := cLog
		aChkOut[ 2 ] := Iif( Type( "json:pedidoOrigem" )    == "U", "", cValToChar( json:pedidoOrigem ) )
		aChkOut[ 3 ] := Iif( Type( "json:numero" )          == "U", "", cValToChar( json:numero ) )
		aChkOut[ 4 ] := Iif( Type( "json:dataFaturamento" ) == "U", "", cValToChar( json:dataFaturamento ) )
		aChkOut[ 5 ] := Iif( Type( "json:data" )            == "U", "", cValToChar( json:data ) )
		aChkOut[ 6 ] := Iif( Type( "json:contato:nome" )    == "U", "", U_RnNoAcento( cValToChar( json:contato:nome ) ) )
		aChkOut[ 7 ] := Iif( Type( "json:contato:email" )   == "U", "", cValToChar( json:contato:email ) )
		aChkOut[ 8 ] := Iif( Type( "json:contato:fone" )    == "U", "", cValToChar( json:contato:fone ) )
		
		aChkOut[ 9 ] := 'PESSOA ' + cTpPessoa
		
		If cTpPessoa == 'F'
			aChkOut[ 10] := Iif( Type( "json:faturamentoPF:nome" )          == "U", "", U_RnNoAcento( cValToChar( json:faturamentoPF:nome ) ) )
			aChkOut[ 11] := Iif( Type( "json:faturamentoPF:endereco:fone" ) == "U", "", cValToChar( json:faturamentoPF:endereco:fone ) )
			aChkOut[ 12] := Iif( Type( "json:faturamentoPF:email" )         == "U", "", cValToChar( json:faturamentoPF:email ) )
		Else
			aChkOut[ 10] := Iif( Type( "json:faturamentoPJ:razaoSocial" )   == "U", "", U_RnNoAcento( cValToChar( json:faturamentoPJ:razaoSocial ) ) )
			aChkOut[ 11] := Iif( Type( "json:faturamentoPJ:endereco:fone" ) == "U", "", cValToChar( json:faturamentoPJ:endereco:fone ) )
			aChkOut[ 12] := Iif( Type( "json:faturamentoPJ:email" )         == "U", "", cValToChar( json:faturamentoPJ:email ) )
		Endif
		
		aChkOut[ 13 ] := Iif( Type( "json:titular:nome" )                 == "U", "", cValToChar( json:titular:nome ) )
		aChkOut[ 14 ] := Iif( Type( "json:titular:email" )                == "U", "", cValToChar( json:titular:email ) )
		aChkOut[ 15 ] := Iif( Type( "json:titular:dataRegistro" )         == "U", "", cValToChar( json:titular:dataRegistro ) )
		
		aChkOut[ 16 ] := Iif( Type( "json:statusFaturamento" )            == "U", "", cValToChar( json:statusFaturamento ) )
		aChkOut[ 17 ] := Iif( Type( "json:statusPagamento" )              == "U", "", cValToChar( json:statusPagamento ) )
		
		aChkOut[ 18 ] := Iif( Type( "json:pagamento:formaPagamento" )     == "U", "", cValToChar( json:pagamento:formaPagamento ) )
		aChkOut[ 19 ] := Iif( Type( "json:dataVencimentoBoleto" )         == "U", "", cValToChar( json:dataVencimentoBoleto ) ) 
		aChkOut[ 20 ] := Iif( Type( "json:parcelamentoDisponivel" )       == "U", "", cValToChar( json:parcelamentoDisponivel ) )
		
		aChkOut[ 21 ] := Iif( Type( "json:pagamento:cartao:bandeira" )    == "U", "", cValToChar( json:pagamento:cartao:bandeira ) )
		aChkOut[ 22 ] := Iif( Type( "json:pagamento:cartao:tipo" )        == "U", "", cValToChar( json:pagamento:cartao:tipo ) )
		aChkOut[ 23 ] := Iif( Type( "json:pagamento:cartao:parcelas" )    == "U", "", cValToChar( json:pagamento:cartao:parcelas ) )
		aChkOut[ 24 ] := Iif( Type( "json:pagamento:cartao:falha" )       == "U", "", cValToChar( json:pagamento:cartao:falha ) )
		aChkOut[ 25 ] := Iif( Type( "json:pagamento:cartao:tid" )         == "U", "", cValToChar( json:pagamento:cartao:tid ) )
		aChkOut[ 26 ] := Iif( Type( "json:pagamento:cartao:nsu" )         == "U", "", cValToChar( json:pagamento:cartao:nsu ) )
		aChkOut[ 27 ] := Iif( Type( "json:pagamento:cartao:autorizacao" ) == "U", "", cValToChar( json:pagamento:cartao:autorizacao ) )
		
		aChkOut[ 28 ] := Iif( Type( "json:pagamento:voucher:codigo" )     == "U", "", cValToChar( json:pagamento:voucher:codigo ) )
		aChkOut[ 29 ] := Iif( Type( "json:pagamento:voucher:emissor" )    == "U", "", cValToChar( json:pagamento:voucher:emissor ) )
		aChkOut[ 30 ] := Iif( Type( "json:voucherDesconto" )              == "U", "", cValToChar( json:voucherDesconto ) )
		
		aChkOut[ 31 ] := Iif( Type( "json:valorBruto" )                   == "U", "", cValToChar( json:valorBruto ) )
		aChkOut[ 32 ] := Iif( Type( "json:valorLiquido" )                 == "U", "", cValToChar( json:valorLiquido ) )
		aChkOut[ 33 ] := Iif( Type( "json:valorDesconto" )                == "U", "", cValToChar( json:valorDesconto ) )
		aChkOut[ 34 ] := Iif( Type( "json:percentualDesconto" )           == "U", "", cValToChar( json:percentualDesconto ) )
		
		aChkOut[ 35 ] := Iif( Type( "json:dataCancelamento" )             == "U", "", cValToChar( json:dataCancelamento ) )
	Else
		AAdd( aLog, 'NAO CONSEGUI FAZER O GET [' + __url + __endPoint + '/' + PBP->PBP_PSITE + ' --->getResult: ' + cGetResult + ']' )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | CreateExcel  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Cria a relatório no formato Xml
//-----------------------------------------------------------------------
Static Function CreateExcel( cProtocolo )
	Local aCab := {}
	
	Local cTable := ''
	Local cWorkSheet := ''
	
	Local i := 0
	
	Local oExcel
	
	AAdd( aCab, 'LOG DE PROCESSAMENTO' )
	AAdd( aCab, 'PEDIDO GAR' )
	AAdd( aCab, 'PEDIDO SITE' )
	AAdd( aCab, 'DT FAT' )
	AAdd( aCab, 'DATA DA COMPRA' )
	AAdd( aCab, 'NOME CONTATO' )
	AAdd( aCab, 'EMAIL CONTATO' )
	AAdd( aCab, 'TELEFONE CONTATO' )
	AAdd( aCab, 'TIPO PESSOA' )
	AAdd( aCab, 'NOME FAT' )
	AAdd( aCab, 'TELFONE FAT' )
	AAdd( aCab, 'EMAIL FAT' )
	AAdd( aCab, 'NOME TITULAR' )
	AAdd( aCab, 'E-MAIL TITULAR' )
	AAdd( aCab, 'DATA REGISTRO' )
	AAdd( aCab, 'STATUS FAT' )
	AAdd( aCab, 'STATUS PAGTO' )
	AAdd( aCab, 'FORMA PAGTO' )
	AAdd( aCab, 'DT VENCTO BOLETO' )
	AAdd( aCab, 'PARCELAMENTO DISP' )
	AAdd( aCab, 'BANDEIRA' )
	AAdd( aCab, 'TIPO' )
	AAdd( aCab, 'PARCELAS' )
	AAdd( aCab, 'FALHAS' )
	AAdd( aCab, 'TID' )
	AAdd( aCab, 'NSU' )
	AAdd( aCab, 'AUTORIZAÇÃO' )
	AAdd( aCab, 'VOUCHER CÓDIGO' )
	AAdd( aCab, 'VOUCHER EMISSOR' )
	AAdd( aCab, 'VOUCHER DESCONTO' )
	AAdd( aCab, 'VALOR BRUTO' )
	AAdd( aCab, 'VALOR LIQUIDO' )
	AAdd( aCab, 'VALOR DESCONTO' )
	AAdd( aCab, 'PERCENTUAL DESCONTO' )
	AAdd( aCab, 'DATA CANCELAMENTO' )
	
	oExcel := FWMsExcel():New()
	
	cWorkSheet := 'NAO_IDENTIFICADO' 
	cTable := 'LOG DE PROCESSAMENTO - LIBERAÇÃO DE PAGAMENTO NÃO IDENTIFICADO'
	
	oExcel:AddWorkSheet( cWorkSheet )
	oExcel:AddTable( cWorkSheet, cTable )
	
	For i := 1 To Len( aCab )
		oExcel:AddColumn( cWorkSheet, cTable , aCab[ i ], 1, 1, .F. )
	Next i
	
	For i := 1 To Len( aNoIdent )
		oExcel:AddRow( cWorkSheet, cTable, aNoIdent[ i ] )
	Next i
	
	If Len( aIdent ) > 0
		cWorkSheet := 'IDENTIFICADO' 
		cTable := 'LOG DE PROCESSAMENTO - LIBERAÇÃO DE PAGAMENTO IDENTIFICADO'
		
		oExcel:AddWorkSheet( cWorkSheet )
		oExcel:AddTable( cWorkSheet, cTable )
		
		For i := 1 To Len( aCab )
			oExcel:AddColumn( cWorkSheet, cTable , aCab[ i ], 1, 1, .F. )
		Next i
		
		For i := 1 To Len( aIdent )
			oExcel:AddRow( cWorkSheet, cTable, aIdent[ i ] )
		Next i
	Endif
	
	oExcel:Activate()
	oExcel:GetXMLFile( cBarra + cPasta + cBarra + cProtocolo + cExt )
	Sleep( 500 )
Return

//-----------------------------------------------------------------------
// Rotina | MakeMsg  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Cria as mensagens do corpo do e-Mail 
//-----------------------------------------------------------------------
Static Function MakeMsg( cArea )
	Local aTRB	:= Array(3)
	aFill( aTRB, '' )
	IF cArea == 'FIN'
		aTRB[ 1 ] := 'PROCESSAMENTO DE (NÃO) IDENTIFICAÇÃO DE PAGAMENTO'
		aTRB[ 2 ] := 'A rotina de identificação de pagamento processou os registros de solicitação de liberação de pagamento que foram requisitados pelo sistema de atendimento ao cliente.'
		aTRB[ 3 ] := 'Em anexo, planilha com o resultado de liberações de pagamentos efetuados que não constam seus comprovantes de pagamentos no sistema de gestão.'
	ElseIF cArea == 'SEG'
		aTRB[ 1 ] := 'FINALIZAÇÃO DE TENTATIVAS DE IDENTIFICAÇÃO DE PAGAMENTO'
		aTRB[ 2 ] := 'A rotina de identificação de pagamento processou os registros de solicitação de liberação de pagamento que foram requisitados pelo sistema de atendimento ao cliente.'
		aTRB[ 3 ] := 'Em anexo, planilha com os pedidos que não sofreram ação pela área financeira e necessitam de análise'
	Else
		aTRB[ 1 ] := 'RELAÇÃO CRÍTICA DA LIBERAÇÃO DE PAGAMENTO NÃO IDENTIFICADA E SEM FOLLOW-UP FINANCEIRO E DE SEGURANÇA'
		aTRB[ 2 ] := 'Constam pedidos liberados pelo sistema RightNow sem o follow-up das áreas financeiro e segurança'
		aTRB[ 3 ] := ''
	EndIF
Return( aTRB )

//-----------------------------------------------------------------------
// Rotina | LoadHTML  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Monta o conteúdo do eMail  
//-----------------------------------------------------------------------
Static Function LoadHTML( cTitulo, cMsg1, cMsg2, cProtocolo )
	Local cBody		:= ''
	Local cPath		:= '\htmls\'
	Local cTemplate := cPath + 'CSFA887.htm'
	Local cFileHTML := cPath + CriaTrab( NIL, .F. ) + '.htm'	
	Local oHTML
	        
	oHTML := TWFHtml():New( cTemplate )
	
	oHTML:ValByName( 'cTitulo'	 , cTitulo	 )
	oHTML:ValByName( 'cMSG1'	 , cMsg1 	 )
	oHTML:ValByName( 'cMSG2'	 , cMsg2 	 )
	oHTML:ValByName( 'cProtocolo', cProtocolo)
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()		
		Ferase( cFileHTML )
	Endif
Return( cBody )

//-----------------------------------------------------------------------
// Rotina | SendMail  | Autor | Rafael Beghini    | Data | 05/07/2019
//-----------------------------------------------------------------------
// Descr. | Envia o e-mail para o responsável  
//-----------------------------------------------------------------------
Static Function SendMail( cHTML, nAssunto, cProtocolo )
	Local cAssunto := ''
	Local cMail := ''
	Local cMV_887_01 := 'MV_887_01' // EMAIL P/ FINANCEIRO COM A PLANILHA DO RESULTADO DO PROCESSAMENTO.
	Local cMV_887_02 := 'MV_887_02' // EMAIL P/ SIMULAR TESTES.
	Local cMV_887_03 := 'MV_887_03' // EMAIL P/ SISTEMAS CORPORATIVOS.
	Local cMV_887_04 := 'MV_887_04' // EMAIL P/ SEGURANCA COM O REULTADO DO PROCESSAMENTO.
	
	Local lServerTst := .T. //GetServerIP() $ GetMv( 'MV_610_IP' )

	If .NOT. GetMv( cMV_887_02, .T. )
		CriarSX6( cMV_887_02, 'C', 'EMAIL P/ SIMULAR TESTES. CSFA887.prw', 'rafael.augusto@totvs.com.br' )
	Endif
	
	cMail := GetMv( cMV_887_02, .F. )
	
	If nAssunto == 1
		cAssunto := IIF( lServerTst, "[TESTE] ", "" ) + 'Processamento de (não) identificação de pagamento [Protocolo: ' + cProtocolo + ']'
		If .NOT. GetMv( cMV_887_01, .T. )
			CriarSX6( cMV_887_01, 'C', 'EMAIL P/ FINANCEIRO COM A PLANILHA DO RESULTADO DO PROCESSAMENTO. CSFA887.prw', 'boletofi@certisign.com.br' )
		Endif
		
		If Empty( cMail )
			cMail := GetMv( cMV_887_01, .F. )
		Endif
		
	Elseif nAssunto == 2
		cAssunto := IIF( lServerTst, "[TESTE] ", "" ) + 'Finalização de tentativas de identificação de pagamento [Protocolo: ' + cProtocolo + ']'
		If .NOT. GetMv( cMV_887_04, .T. )
			CriarSX6( cMV_887_04, 'C', 'EMAIL P/ SEGURANCA COM O REULTADO DO PROCESSAMENTO. CSFA887.prw', 'seguranca@certisign.com.br' )
		Endif
		
		If Empty( cMail )
			cMail := GetMv( cMV_887_04, .F. )
		Endif
	
	Elseif nAssunto == 3
		cAssunto := IIF( lServerTst, "[TESTE] ", "" ) + 'Relação crítica da liberação de pagamento não identificada e sem follow-up [Protocolo: ' + cProtocolo + ']'
		If .NOT. GetMv( cMV_887_03, .T. )
			CriarSX6( cMV_887_03, 'C', 'EMAIL P/ SISTEMAS CORPORATIVOS. CSFA887.prw', 'sistemascorporativos@certisign.com.br' )
		Endif
		
		If Empty( cMail )
			cMail := GetMv( cMV_887_03, .F. )
		Endif
	Endif
	
	FSSendMail( cMail, cAssunto, cHTML, ( cBarra + cPasta + cBarra + cProtocolo + cExt ) )	
Return