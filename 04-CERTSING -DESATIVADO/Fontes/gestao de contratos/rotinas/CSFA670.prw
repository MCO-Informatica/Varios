#include 'totvs.ch'

User Function CSFA670()
MsgAlert('Rotina sem procedimento programado.')
Return

//-------------------------------------------------------------------------
// Rotina | A670VLUNIT   | Autor | Rafael Behgini       | Data | 04/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina para criticar o valor do produto caso haja relação com 
//        | o fornecedor X produto. Rotina está sendo executado pelo ponto 
//        | de entrada CN130TOK.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670VLUNIT()
	Local lRet := .T.
	Local cCNE_PRODUT := aCols[ N,GdFieldPos("CNE_PRODUT") ]
	Local nA5_PRCUNIT := 0 
	
	IF Empty(M->CND_NUMERO)
		IF .NOT. Empty(M->CND_FORNEC)
			IF .NOT. Empty(cCNE_PRODUT)
				nA5_PRCUNIT := Posicione("SA5",1,xFilial("SA5") + M->CND_FORNEC + M->CND_LJFORN + cCNE_PRODUT, "A5_PRCUNIT")
				IF nA5_PRCUNIT > 0
					IF nA5_PRCUNIT <> M->CNE_VLUNIT
						MsgAlert('Não é permitido alterar o valor unitário do produto. Tecle ESC para retornar.',;
								'A670VlUnit - Crítica de dados')
						lRet := .F.
					EndIF
				EndIF							
			Endif 
		EndIF
	EndIF
Return(lRet)

//-------------------------------------------------------------------------
// Rotina | A670MnCp     | Autor | Robson Gonçalves     | Data | 04/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina de alteração da data início e data fim do contrato. Está
//        | sendo acionada pelo ponto de entrada CTA100MNU.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670MnCp( nAllowed )
	Local aPar := {}
	Local aRet := {}
	Local bOK := {|| .T. }
	Local cHistory := ''
	Local nP := 0
	Local cCadastro
	Local lUpdate := .F.
	cCadastro := 'Modificar data ínicio/fim'
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATENÇÃO'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revisão atual '+CN9->CN9_REVATU+', pois este registro é uma revisão antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
			If CN9->CN9_UNVIGE == '4'
				MsgInfo('Somente contratos com unidade da vigência diferente de Indeterminado poderá ser modificado por esta rotina.',cCadastro)
			Else
				AAdd( aPar,{ 9, 'Informe a data de início do contrato:', 150, 7, .T. } )
				AAdd( aPar,{ 1, 'Data início', CN9->CN9_DTINIC, '99/99/9999', 'U_A670VLDF()', '', 'U_A670When()', 50, .T. } )
				AAdd( aPar,{ 1, 'Data Final' , CN9->CN9_DTFIM , '99/99/9999', ''            , '', '.F.'         , 50, .F. } )
				bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
								MsgYesNo( 'Confirma a alteração dos dados do contrato?', cCadastro ),;
								( MsgAlert('Data de início do contrato a ser alterada não informada, verifique.', cCadastro ), .F. ) ) }	
				Set( 4, 'dd/mm/yyyy' )
				If ParamBox( aPar, 'Modificar Data Início do Contrato', @aRet, bOK, , , , , , , .F., .F. )
					cHistory := 'Mensagem informativa: A data inicial do contrato foi modificado de '+Dtoc( CN9->CN9_DTINIC )+;
			      ' para '+Dtoc( mv_par02 )+' por '+RTrim( UsrFullName( __cUserID ) )+' em '+Dtoc( MsDate() )+' as '+Time()+'.'
					CN9->( RecLock( 'CN9', .F. ) )
					If CN9->CN9_DTINIC <> mv_par02
						lUpdate := .T.
						CN9->CN9_DTINIC := mv_par02
					Endif
					If CN9->CN9_DTFIM <> mv_par03
						lUpdate := .T.
						CN9->CN9_DTFIM  := mv_par03
					Endif
					If lUpdate 
						CN9->CN9_MOTALT := AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory
					Endif
					CN9->( MsUnLock() )
					MsgInfo('Alteração realizada com sucesso.',cCadastro)
				Else
					MsgInfo('Operação abandonada pelo usuário.',cCadastro)
				Endif
			Endif
		Endif
	Else
		MsgAlert('Você não possui permissão para utilizar esta rotina. Verifique sua permissão no parâmetro MV_670USER.',cCadastro)
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | A670When     | Autor | Robson Gonçalves     | Data | 24/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina que retorna lógico a possibilidade de alterar o campo 
//        | data início da interface de alteração específica, acionado pela
//        | função U_A670MnCp().
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670When()
	Local lPodeAlterar := .F.
	Local cMV_670WHEN := 'MV_670WHEN'
	If .NOT. GetMv( cMV_670WHEN, .T. )
		CriarSX6( cMV_670WHEN, 'C', 'USUARIOS QUE PODEM ALTERAR A DATA INICIO E DATA FIM DO CONTRATO SEM MUDAR A VIGÊNCIA. CSFA670.prw', '000000|000908' )
	Endif		
	cMV_670WHEN := GetMv( cMV_670WHEN, .F. )
	If RetCodUsr() $ cMV_670WHEN
		lPodeAlterar := .T.
	Endif
Return(lPodeAlterar)

//-------------------------------------------------------------------------
// Rotina | A640NVen     | Autor | Robson Gonçalves     | Data | 24/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina que retorna possibilita efetuar manutenção no campo do 
//        | contrato onde estará registrado os emails para receber o aviso
//        | de vencimentos.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A640NVen( nAllowed )
	Local aPar := {}
	Local aRet := {}
	Local bOK := {|| .T. }
	Local cHistory := ''
	Local cCadastro
	cCadastro := 'Notificação Vencimento'
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATENÇÃO'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revisão atual '+CN9->CN9_REVATU+', pois este registro é uma revisão antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
			AAdd( aPar,{ 9, 'Abaixo registre e-Mails para notificações de vencimentos:', 200, 7, .T. } )	
			AAdd( aPar,{ 11 ,'Notifificação de Vencimentos', CN9->CN9_NOTVEN, '', '',  .F. } )
			bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
							MsgYesNo( 'Confirma a alteração dos dados do contrato?', cCadastro ),;
							( MsgAlert('E-Mails para receber notificação de vencimento não informado, verifique.', cCadastro ), .F. ) ) }	
			If ParamBox( aPar, 'Registrar e-Mails', @aRet, bOK, , , , , , , .F., .F. )
				cHistory := 'Mensagem informativa: Alterado o endereço eletrônica para receber notificação de vencimento, por '+RTrim( UsrFullName( __cUserID ) )+' em '+Dtoc( MsDate() )+' as '+Time()+'.'
				CN9->( RecLock( 'CN9', .F. ) )
				CN9->CN9_MOTALT := AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory
				CN9->CN9_NOTVEN := AllTrim( mv_par02 )
				CN9->( MsUnLock() )
				MsgInfo('Alteração realizada com sucesso.',cCadastro)
			Else
				MsgInfo('Operação abandonada pelo usuário.',cCadastro)
			Endif
		Endif
	Else
		MsgAlert('Você não possui permissão para utilizar esta rotina. Verifique sua permissão no parâmetro MV_670USER.',cCadastro)
	Endif
	
Return

//-------------------------------------------------------------------------
// Rotina | A670VLDF     | Autor | Robson Gonçalves     | Data | 04/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina responsável por executar a função de cálculo de data e 
//        | alimentar a variável com seu retorno.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670VLDF()
	MV_PAR03 := U_ZCN100Dt(CN9->CN9_UNVIGE,MV_PAR02,CN9->CN9_VIGE)
Return(.T.)

//-------------------------------------------------------------------------
// Rotina | A670TudOk    | Autor | Robson Gonçalves     | Data | 09/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina responsável por validar o valor do produto relacionado 
//        | com o fornecedor. Esta rotina é executada pelo ponto de entrada
//        | CN130TOK.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670TudOk()
	Local lRet := .T.
	Local nI := 0
	Local nCNE_PRODUT := 0
	Local nCNE_VLUNIT := 0
	Local lVinculo	:= .F.
	Local lPlanilha := .F.
	
	nCNE_PRODUT := GdFieldPos('CNE_PRODUT')
	nCNE_VLUNIT := GdFieldPos('CNE_VLUNIT')
	
	SA5->( dbSetOrder( 1 ) )
	lVinculo := SA5->( dbSeek( xFilial( 'SA5' ) + M->CND_FORNEC + M->CND_LJFORN ) )

	CNA->( dbSetOrder( 1 ) )
	lPlanilha := CNA->( dbSeek( xFilial( 'CNA' ) + M->CND_CONTRA + M->CND_REVISA + M->CND_NUMERO ) )

	CNB->( dbSetOrder( 1 ) )
	lPlanilha := lPlanilha .And. CNB->( dbSeek( xFilial( 'CNA' ) + CNA->CNA_CONTRA + CNA->CNA_REVISA + CNA->CNA_NUMERO ) )

	For nI := 1 To Len( aCOLS )
		If .NOT. aCOLS[ nI, Len( aHeader )+1 ]
			If SA5->( dbSeek( xFilial( 'SA5' ) + M->CND_FORNEC + M->CND_LJFORN + aCOLS[ nI, nCNE_PRODUT ] ) )
				If SA5->A5_PRCUNIT > 0
					If SA5->A5_PRCUNIT <> aCOLS[ nI, nCNE_VLUNIT ]
						MsgAlert('O valor do produto informado está diferente da relação Fornecedor X Produto. Não será possível continuar...','A670TudOk - Criticar dados')
						lRet := .F.
						Exit
					Endif
				Endif
				//Se o lPlanilha for TRUE, nao deve bloquear.
			ElseIF lVinculo .And. !lPlanilha .And. !SA5->( dbSeek( xFilial( 'SA5' ) + M->CND_FORNEC + M->CND_LJFORN + aCOLS[ nI, nCNE_PRODUT ] ) )
				MsgAlert('O produto informado não existe na relação Fornecedor X Produto. Não será possível continuar...','A670TudOk - Criticar dados')
				lRet := .F.
				Exit
			Endif
		Endif
	Next nI


Return( lRet )

//-------------------------------------------------------------------------
// Rotina | A670VIGE     | Autor | Rafael Beghini     | Data | 28/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina de alteração da data de Vigencia do contrato. Está
//        | sendo acionada pelo ponto de entrada CTA100MNU.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670VIGE( nOpcao )
	Local cCadastro := 'A670Vige - Alteração Vigência'
	Local cDtVenc := ''
	Local cCompet := ''
	Local cCNFRecno := ''
	Local dNewDay := ''
	Local nDias := 0
	Local lExecute := .F.
	Local aPar := {}
	Local aRet := {}
	
	IF nOpcao == 1
		IF CN9->CN9_UNVIGE == '4'
			cDtVenc := A670Qry( CN9->CN9_FILIAL, CN9->CN9_NUMERO )
			
			AAdd( aPar,{ 9, 'Informe a data de vigência', 150, 7, .T. } )
			AAdd( aPar,{ 1, 'Data', StoD(cDtVenc), '99/99/9999', '', '', '', 50, .T. } )
			
			If ParamBox( aPar, '', @aRet )
				IF Mv_par02 < StoD(cDtVenc)
					IF MsgYesNo('Atenção,' + CRLF + CRLF +;
							'A data de vigência informada deve ser igual ou maior que a última data do cronograma que é: ' + DtoC(StoD(cDtVenc)) + CRLF +;
							'Deseja informar esta data e prosseguir?', cCadastro)
						lExecute := .T.
						dNewDay  := StoD( cDtVenc )
					EndIF
				Else
					lExecute := .T.
					dNewDay  := Mv_par02
				EndIF
				
				IF lExecute
					nDias := dNewDay - CN9->CN9_DTINIC
					
					CNA->( dbSetOrder(1) )
					IF CNA->( dbSeek( CN9->CN9_FILIAL + CN9->CN9_NUMERO + CN9->CN9_REVISA ) )
						While .NOT. Eof() .And. CNA->CNA_FILIAL == CN9->CN9_FILIAL .And. CNA->CNA_CONTRA == CN9->CN9_NUMERO;
									    .And. CNA->CNA_REVISA == CN9->CN9_REVISA
							Begin Transaction
								CNA->(RecLock('CNA',.F.))
								CNA->CNA_DTFIM := dNewDay
								CNA->(MsUnLock())
							End Transaction
						
						CNA->( dbSkip() )
						End
					EndIF
					cHistory := 'Mensagem informativa: ' + RTrim( UsrFullName( __cUserID ) ) + ' em [' + Dtoc( MsDate() ) + ' as ' + Time()+'] ' +;
							   'alterou a Vigência do contrato de indeterminado para ' + lTrim(Str(nDias)) + ' dias com data fim para ' + DtoC(dNewDay)
					
					Begin Transaction
					CN9->( RecLock( 'CN9', .F. ) )
			      		CN9->CN9_UNVIGE := '1' 
			      		CN9->CN9_VIGE   := nDias 
			      		CN9->CN9_DTFIM  := dNewDay 
			      		CN9->CN9_MOTALT := IIF( Empty(CN9->CN9_MOTALT), cHistory, AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory )
		      		CN9->( MsUnLock() )
		      		End Transaction
		      		
					MsgInfo('Alteração realizada com sucesso.',cCadastro)
				EndIF
			Else
				MsgInfo('Operação abandonada pelo usuário.',cCadastro)
			Endif
		Else
			MsgAlert('ATENÇÃO'+CRLF+CRLF+;
			'Opção disponível apenas para contratos do tipo Indeterminado.' + CRLF +; 
			'Para alterar a vigência deste contrato, faça a Revisão do Contrato.',cCadastro)	
		EndIF	
	Else
		MsgAlert('Você não possui permissão para utilizar esta rotina. Verifique sua permissão no parâmetro MV_670USER.',cCadastro)
	EndIF
Return

//-------------------------------------------------------------------------
// Rotina | A670ANIV     | Autor | Rafael Beghini     | Data | 16.08.2016
//-------------------------------------------------------------------------
// Descr. | Rotina de alteração da data de Aniversário do contrato. Está
//        | sendo acionada pelo ponto de entrada CTA100MNU.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670ANIV(nAllowed)
	Local aPar := {}
	Local aRet := {}
	Local bOK := {|| .T. }
	Local cHistory := ''
	Local nP := 0
	Local cCadastro
	Local lUpdate := .F.
	cCadastro := 'Modificar data de Aniversário'
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATENÇÃO'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revisão atual '+CN9->CN9_REVATU+', pois este registro é uma revisão antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
				AAdd( aPar,{ 9, 'Informe a data de aniversário:', 150, 7, .T. } )
				AAdd( aPar,{ 1, 'Data', CN9->CN9_DTANIV, '99/99/9999', '', '', '', 50, .F. } )
				bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
								MsgYesNo( 'Confirma a alteração dos dados do contrato?', cCadastro ),;
								( MsgAlert('Data de aniversário do contrato a ser alterada não informada, verifique.', cCadastro ), .F. ) ) }	
				Set( 4, 'dd/mm/yyyy' )
				If ParamBox( aPar, 'Modificar Data Início do Contrato', @aRet, bOK, , , , , , , .F., .F. )
					
					CN9->( RecLock( 'CN9', .F. ) )
					If CN9->CN9_DTANIV <> mv_par02
						CN9->CN9_DTANIV := mv_par02
					Endif
					CN9->( MsUnLock() )
					MsgInfo('Alteração realizada com sucesso.',cCadastro)
				Else
					MsgInfo('Operação abandonada pelo usuário.',cCadastro)
				Endif
		Endif
	Else
		MsgAlert('Você não possui permissão para utilizar esta rotina. Verifique sua permissão no parâmetro MV_670USER.',cCadastro)
	Endif
	
Return

//-------------------------------------------------------------------------
// Rotina | A670RENO     | Autor | Rafael Beghini     | Data | 14.09.2016
//-------------------------------------------------------------------------
// Descr. | Rotina de alteração dO Tipo de Renovação do contrato, aviso de
//        | vencimento periódico. Está sendo acionada pelo PE CTA100MNU.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670RENO(nAllowed)
	Local aPar := {}
	Local aRet := {}
	Local aCN9_RENOV := {}
	
	Local bOK := {|| .T. }
	Local cHistory := ''
	Local cMVpar02 := ''
	Local nP := 0
	Local cCadastro
	Local lUpdate := .F.
	cCadastro := 'Modificar tipo de Renovação'
	
	aCN9_RENOV := StrToKarr( Posicione( 'SX3', 2, 'CN9_TPRENO', 'X3CBox()' ), ';' )
	
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATENÇÃO'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revisão atual '+CN9->CN9_REVATU+', pois este registro é uma revisão antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
				AAdd( aPar,{ 9, 'Selecione o tipo de Renovação:', 150, 7, .T. } )
				AAdd( aPar,{ 2, 'Tipo', 1, aCN9_RENOV, 100, "",.T.} )
				
				AAdd( aPar,{ 9, 'Informe a periodicidade:', 150, 7, .T. } )
				AAdd( aPar,{ 1, 'Aviso de Término',CN9->CN9_AVITER,"@E 999","","","",20,.F.})
				AAdd( aPar,{ 1, 'Aviso Periódico' ,CN9->CN9_AVIPER,"@E 999","","","",20,.F.})
				
				bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
								MsgYesNo( 'Confirma a alteração dos dados do contrato?', cCadastro ),;
								( MsgAlert('Tipo renovação do contrato a ser alterada não informada, verifique.', cCadastro ), .F. ) ) }	
				
				If ParamBox( aPar, '', @aRet, bOK, , , , , , , .F., .F. )
					cMVpar02 := IIF( ValType( mv_par02 ) == 'C', Subs(mv_par02,1,1), LTrim( Str( mv_par02, 1, 0 ) ) )
					
					CN9->( RecLock( 'CN9', .F. ) )
					If CN9->CN9_TPRENO <> cMVpar02
						CN9->CN9_TPRENO := cMVpar02
					Endif
					If CN9->CN9_AVITER <> mv_par04
						CN9->CN9_AVITER := mv_par04
					Endif
					If CN9->CN9_AVIPER <> mv_par05
						CN9->CN9_AVIPER := mv_par05
					Endif
					CN9->( MsUnLock() )
					MsgInfo('Alteração realizada com sucesso.',cCadastro)
				Else
					MsgInfo('Operação abandonada pelo usuário.',cCadastro)
				Endif
		Endif
	Else
		MsgAlert('Você não possui permissão para utilizar esta rotina. Verifique sua permissão no parâmetro MV_670USER.',cCadastro)
	Endif

Return

//-------------------------------------------------------------------------
// Rotina | A670REAJ     | Autor | Rafael Beghini     | Data | 14.09.2016
//-------------------------------------------------------------------------
// Descr. | Rotina de alteração REAJUSTE=Sim/Nao e o Índice utilizado
//        | Está sendo acionada pelo PE CTA100MNU.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670REAJ(nAllowed)
	Local aPar := {}
	Local aRet := {}
	Local aCN9_FLGREJ := {}
	
	Local bOK := {|| .T. }
	Local cHistory := ''
	Local cMVpar02 := ''
	Local nP := 0
	Local cCadastro := ''
	Local lUpdate := .F.
	cCadastro := 'Modificar Reajuste/Indice'
	
	aCN9_FLGREJ := StrToKarr( Posicione( 'SX3', 2, 'CN9_FLGREJ', 'X3CBox()' ), ';' )
	
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATENÇÃO'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revisão atual '+CN9->CN9_REVATU+', pois este registro é uma revisão antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
				AAdd( aPar,{ 9, 'Informe se o contrato possui Reajuste', 150, 7, .T. } )
				AAdd( aPar,{ 2, 'Reajusta', 1, aCN9_FLGREJ, 50, "",.T.} )
				
				AAdd( aPar,{ 9, 'Informe o Indice de correção', 150, 7, .T. } )
				AAdd( aPar,{ 1, 'Indice',CN9->CN9_INDICE,"","Vazio().or.ExistCpo('CN6')","CN6","",20,.F.})
				
				bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
								MsgYesNo( 'Confirma a alteração dos dados do contrato?', cCadastro ),;
								( MsgAlert('Reajuste do contrato a ser alterada não informada, verifique.', cCadastro ), .F. ) ) }	
				
				If ParamBox( aPar, '', @aRet, bOK, , , , , , , .F., .F. )
					cMVpar02 := IIF( ValType( mv_par02 ) == 'C', Subs(mv_par02,1,1), LTrim( Str( mv_par02, 1, 0 ) ) )
				
					CN9->( RecLock( 'CN9', .F. ) )
					If CN9->CN9_FLGREJ <> cMVpar02
						CN9->CN9_FLGREJ := cMVpar02
					Endif
					If CN9->CN9_INDICE <> mv_par04
						CN9->CN9_INDICE := mv_par04
					Endif
					CN9->( MsUnLock() )
					MsgInfo('Alteração realizada com sucesso.',cCadastro)
				Else
					MsgInfo('Operação abandonada pelo usuário.',cCadastro)
				Endif
		Endif
	Else
		MsgAlert('Você não possui permissão para utilizar esta rotina. Verifique sua permissão no parâmetro MV_670USER.',cCadastro)
	Endif
Return
//-------------------------------------------------------------------------
// Rotina | A670Qry     | Autor | Rafael Beghini     | Data | 28/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina para buscar a última data do cronograma do contrato em 
//        | questão.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A670Qry( cCN9Fil, cCN9Num )
	Local cAliasA := GetNextAlias()
	Local cQuery  := ''
	Local cReturn := ''
	
	cQuery += "SELECT MAX(CNF_DTVENC) DTVENC"         + CRLF
	cQuery += "FROM " + RetSqlName("CNF") + " CNF "   + CRLF
	cQuery += "WHERE CNF.D_E_L_E_T_ = ' ' "           + CRLF
	cQuery += "  AND CNF_FILIAL = '" + cCN9Fil + "' " + CRLF
	cQuery += "  AND CNF_CONTRA = '" + cCN9Num + "' " + CRLF
	cQuery += "ORDER BY CNF_FILIAL,CNF_CONTRA,CNF_REVISA,CNF_NUMERO,CNF_PARCEL ASC"
	
	cQuery := ChangeQuery(cQuery)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasA, .F., .T.)
		
	IF .NOT. Eof( cAliasA )
		cReturn := (cAliasA)->DTVENC
	EndIF
Return(cReturn)

//-------------------------------------------------------------------------
// Rotina | A670Upd      | Autor | Rafael Behgini       | Data | 04/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina de update para criar o campo na tabela SA5 - Fornecedor
//        | x produto.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670Upd()
	Local cModulo := 'GCT'
	Local bPrepar := {|| U_A670Ini() }
	Local nVersao := 01

	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-------------------------------------------------------------------------
// Rotina | A670Ini      | Autor | Rafael Behgini       | Data | 04/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670Ini()
	aSX3  := {}
	aHelp := {}
	
	AAdd(aSX3,{	'SA5',NIL,'A5_PRCUNIT','N',12,2,;                                          //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
				'Prc.Unitario','Prc.Unitario','Prc.Unitario',;                             //Tit. Port.,Tit.Esp.,Tit.Ing.
				'Preco Unitario','Preco Unitario','Preco Unitario',;                       //Desc. Port.,Desc.Esp.,Desc.Ing.
				'@E 999,999,999.99',;                                                      //Picture
				'',;                                                                       //Valid
				X3_EMUSO_USADO,;                                                           //Usado
				'',;                                                                       //Relacao
				'',1,X3_USADO_RESERV,'','S',;                                              //F3,Nivel,Reserv,Check,Trigger
				'U','N','A','R',' ',;                                                      //Propri,Browse,Visual,Context,Obrigat
				'Positivo()',;	                                                         //VldUser
				'','','',;                                                                 //Box Port.,Box Esp.,Box Ing.
				'','','','','',;                                                           //PictVar,When,Ini BRW,GRP SXG,Folder
				'N','','','',' ','1'})
	
	AAdd(aSX3,{	'CNA',NIL,'CNA_DESCRI','C',40,0,;                                          //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
				'Descricao','Descricao','Descricao',;                             		  //Tit. Port.,Tit.Esp.,Tit.Ing.
				'Descricao Planilha','Descricao Planilha','Descricao Planilha',;           //Desc. Port.,Desc.Esp.,Desc.Ing.
				'@!',;                                                      			  //Picture
				'',;                                                                       //Valid
				X3_EMUSO_USADO,;                                                           //Usado
				'',;                                                                       //Relacao
				'',1,X3_USADO_RESERV,'','S',;                                              //F3,Nivel,Reserv,Check,Trigger
				'U','S','A','R',' ',;                                                      //Propri,Browse,Visual,Context,Obrigat
				'Texto()',;	                                                             //VldUser
				'','','',;                                                                 //Box Port.,Box Esp.,Box Ing.
				'','','','','',;                                                           //PictVar,When,Ini BRW,GRP SXG,Folder
				'N','','','',' ','1'})
				
	aAdd(aHelp,{'A5_PRCUNIT', 'Preco unitario do produto.'})
	aAdd(aHelp,{'CNA_DESCRI', 'Descrição da planilha.'    })
Return

//Renato Ruy - 28/10/2017
//Copia do fonte padrão CN100DtFim
User Function ZCN100Dt(cTipV,dDtIni,nVig,lExec)
Local nX			:= 0
Local nDiaIni		:= 1
Local dDtOri		:= dDtIni
Local dDtUsr		:= dDtIni
Local dDataAssi	    := Iif(IsInCallStack('GCP320Grv'), dDtIni,  CN9->CN9_DTASSI)
Local oModel		:= FWModelActive()
Local lMVC			:= oModel <> Nil
Local aSaveLines	:= FWSaveRows()
Local lDtAssi		:= SuperGetMv("MV_GCTDTTR",.F.,.F.) // Calcula a data de término da vigência tendo como início a data de assinatura.
Local lGCTDTAN		:= SuperGetMv("MV_GCTDTAN",.F.,.F.)
Local lOrigemGCP
Local lUpdateCNA

Default lExec := .T.

//Tratativa feita para quando vier da Ata pegar a data de publicação da Ata
If !(IsInCallStack('GCP320Grv'))
	dDataAssi	:= CN9->CN9_DTASSI
Else
	dDataAssi := dDtIni
EndIf

If lMVC .And. !Empty(CN9->CN9_ASSINA)
	dDataAssi := CN9->CN9_ASSINA
EndIf

//Considera a data da assinatura e não da abertura do contrato.
If lDtAssi .And. !Empty(dDataAssi)
	dDtIni := dDataAssi
EndIf

If (!Empty(nVig) .Or. cTipV == "4") .And. !Empty(dDtIni)
	Do Case
		Case cTipV == "1"  //Dia
			dDtIni += nVig
		Case cTipV == "2"  //Mes
			nDiaIni := Day(dDtIni) //Dia do início do contrato.
			For nX := 1 to nVig
				dDtIni += CalcAvanco(dDtIni,.F.,.F.,nDiaIni)
			Next
		Case cTipV == "3"  //Ano
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Valida ano bissexto                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Day(dDtIni) == 29 .And. Month(dDtIni) == 2 .And. ((Year(dDtIni)+nVig) % 4 != 0)
				dDtIni := cTod("28/02/"+str(Year(dDtIni)+nVig))
			Else
				dDtIni := cTod(str(Day(dDtIni))+"/"+str(Month(dDtIni))+"/"+str(Year(dDtIni)+nVig))
			EndIf
			//segundo a legislação de contrato o primeiro dia não conta na vigencia sendo assim o dia de inicio é o mesmo dia do fim no mes final
		Case cTipV == "4"  //Indeterminada
			dDtIni := CTOD("31/12/49")//Retorna data limite do sistema
	EndCase
EndIf

//Parametro MV_GCTDTAN criado para Dataprev para considerar um dia antes do final do contrato
If lGCTDTAN
	dDtIni := dDtIni-1
EndIf

If ExistBlock("CN100ALTDF")
	dDtIni := If( ValType (dDtUsr := ExecBlock("CN100ALTDF",.F.,.F., {dDtIni,cTipV,nVig} ) ) == "D",dDtUsr, dDtIni)
EndIf

Return dDtIni

//-------------------------------------------------------------------------
// Rotina | A670Prod   | Autor | Rafael Behgini       | Data | 06.08.2018
//-------------------------------------------------------------------------
// Descr. | Gatilho a partir do campo CNE_PRODUT para trazer valor
//        | unitário conforme amarração do fornecedor X produto. 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670Prod()
	Local nCNE_PRODUT := 0
	Local nCNE_VLUNIT := 0
	
	nCNE_PRODUT := GdFieldPos('CNE_PRODUT')
	nCNE_VLUNIT := GdFieldPos('CNE_VLUNIT')
	
	SA5->( dbSetOrder( 1 ) )
	
	If .NOT. aCOLS[ N, Len( aHeader ) + 1 ]
		If SA5->( dbSeek( xFilial( 'SA5' ) + M->CND_FORNEC + M->CND_LJFORN + aCOLS[ N, nCNE_PRODUT ] ) )
			If SA5->A5_PRCUNIT > 0
				aCols[ N, nCNE_VLUNIT ] := SA5->A5_PRCUNIT
			Endif
		Endif
	Endif
	
Return( aCOLS[ N, nCNE_PRODUT ] )