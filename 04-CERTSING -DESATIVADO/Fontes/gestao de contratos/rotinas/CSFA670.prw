#include 'totvs.ch'

User Function CSFA670()
MsgAlert('Rotina sem procedimento programado.')
Return

//-------------------------------------------------------------------------
// Rotina | A670VLUNIT   | Autor | Rafael Behgini       | Data | 04/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina para criticar o valor do produto caso haja rela��o com 
//        | o fornecedor X produto. Rotina est� sendo executado pelo ponto 
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
						MsgAlert('N�o � permitido alterar o valor unit�rio do produto. Tecle ESC para retornar.',;
								'A670VlUnit - Cr�tica de dados')
						lRet := .F.
					EndIF
				EndIF							
			Endif 
		EndIF
	EndIF
Return(lRet)

//-------------------------------------------------------------------------
// Rotina | A670MnCp     | Autor | Robson Gon�alves     | Data | 04/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina de altera��o da data in�cio e data fim do contrato. Est�
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
	cCadastro := 'Modificar data �nicio/fim'
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATEN��O'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revis�o atual '+CN9->CN9_REVATU+', pois este registro � uma revis�o antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
			If CN9->CN9_UNVIGE == '4'
				MsgInfo('Somente contratos com unidade da vig�ncia diferente de Indeterminado poder� ser modificado por esta rotina.',cCadastro)
			Else
				AAdd( aPar,{ 9, 'Informe a data de in�cio do contrato:', 150, 7, .T. } )
				AAdd( aPar,{ 1, 'Data in�cio', CN9->CN9_DTINIC, '99/99/9999', 'U_A670VLDF()', '', 'U_A670When()', 50, .T. } )
				AAdd( aPar,{ 1, 'Data Final' , CN9->CN9_DTFIM , '99/99/9999', ''            , '', '.F.'         , 50, .F. } )
				bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
								MsgYesNo( 'Confirma a altera��o dos dados do contrato?', cCadastro ),;
								( MsgAlert('Data de in�cio do contrato a ser alterada n�o informada, verifique.', cCadastro ), .F. ) ) }	
				Set( 4, 'dd/mm/yyyy' )
				If ParamBox( aPar, 'Modificar Data In�cio do Contrato', @aRet, bOK, , , , , , , .F., .F. )
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
					MsgInfo('Altera��o realizada com sucesso.',cCadastro)
				Else
					MsgInfo('Opera��o abandonada pelo usu�rio.',cCadastro)
				Endif
			Endif
		Endif
	Else
		MsgAlert('Voc� n�o possui permiss�o para utilizar esta rotina. Verifique sua permiss�o no par�metro MV_670USER.',cCadastro)
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | A670When     | Autor | Robson Gon�alves     | Data | 24/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina que retorna l�gico a possibilidade de alterar o campo 
//        | data in�cio da interface de altera��o espec�fica, acionado pela
//        | fun��o U_A670MnCp().
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670When()
	Local lPodeAlterar := .F.
	Local cMV_670WHEN := 'MV_670WHEN'
	If .NOT. GetMv( cMV_670WHEN, .T. )
		CriarSX6( cMV_670WHEN, 'C', 'USUARIOS QUE PODEM ALTERAR A DATA INICIO E DATA FIM DO CONTRATO SEM MUDAR A VIG�NCIA. CSFA670.prw', '000000|000908' )
	Endif		
	cMV_670WHEN := GetMv( cMV_670WHEN, .F. )
	If RetCodUsr() $ cMV_670WHEN
		lPodeAlterar := .T.
	Endif
Return(lPodeAlterar)

//-------------------------------------------------------------------------
// Rotina | A640NVen     | Autor | Robson Gon�alves     | Data | 24/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina que retorna possibilita efetuar manuten��o no campo do 
//        | contrato onde estar� registrado os emails para receber o aviso
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
	cCadastro := 'Notifica��o Vencimento'
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATEN��O'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revis�o atual '+CN9->CN9_REVATU+', pois este registro � uma revis�o antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
			AAdd( aPar,{ 9, 'Abaixo registre e-Mails para notifica��es de vencimentos:', 200, 7, .T. } )	
			AAdd( aPar,{ 11 ,'Notififica��o de Vencimentos', CN9->CN9_NOTVEN, '', '',  .F. } )
			bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
							MsgYesNo( 'Confirma a altera��o dos dados do contrato?', cCadastro ),;
							( MsgAlert('E-Mails para receber notifica��o de vencimento n�o informado, verifique.', cCadastro ), .F. ) ) }	
			If ParamBox( aPar, 'Registrar e-Mails', @aRet, bOK, , , , , , , .F., .F. )
				cHistory := 'Mensagem informativa: Alterado o endere�o eletr�nica para receber notifica��o de vencimento, por '+RTrim( UsrFullName( __cUserID ) )+' em '+Dtoc( MsDate() )+' as '+Time()+'.'
				CN9->( RecLock( 'CN9', .F. ) )
				CN9->CN9_MOTALT := AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory
				CN9->CN9_NOTVEN := AllTrim( mv_par02 )
				CN9->( MsUnLock() )
				MsgInfo('Altera��o realizada com sucesso.',cCadastro)
			Else
				MsgInfo('Opera��o abandonada pelo usu�rio.',cCadastro)
			Endif
		Endif
	Else
		MsgAlert('Voc� n�o possui permiss�o para utilizar esta rotina. Verifique sua permiss�o no par�metro MV_670USER.',cCadastro)
	Endif
	
Return

//-------------------------------------------------------------------------
// Rotina | A670VLDF     | Autor | Robson Gon�alves     | Data | 04/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina respons�vel por executar a fun��o de c�lculo de data e 
//        | alimentar a vari�vel com seu retorno.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670VLDF()
	MV_PAR03 := U_ZCN100Dt(CN9->CN9_UNVIGE,MV_PAR02,CN9->CN9_VIGE)
Return(.T.)

//-------------------------------------------------------------------------
// Rotina | A670TudOk    | Autor | Robson Gon�alves     | Data | 09/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina respons�vel por validar o valor do produto relacionado 
//        | com o fornecedor. Esta rotina � executada pelo ponto de entrada
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
						MsgAlert('O valor do produto informado est� diferente da rela��o Fornecedor X Produto. N�o ser� poss�vel continuar...','A670TudOk - Criticar dados')
						lRet := .F.
						Exit
					Endif
				Endif
				//Se o lPlanilha for TRUE, nao deve bloquear.
			ElseIF lVinculo .And. !lPlanilha .And. !SA5->( dbSeek( xFilial( 'SA5' ) + M->CND_FORNEC + M->CND_LJFORN + aCOLS[ nI, nCNE_PRODUT ] ) )
				MsgAlert('O produto informado n�o existe na rela��o Fornecedor X Produto. N�o ser� poss�vel continuar...','A670TudOk - Criticar dados')
				lRet := .F.
				Exit
			Endif
		Endif
	Next nI


Return( lRet )

//-------------------------------------------------------------------------
// Rotina | A670VIGE     | Autor | Rafael Beghini     | Data | 28/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina de altera��o da data de Vigencia do contrato. Est�
//        | sendo acionada pelo ponto de entrada CTA100MNU.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A670VIGE( nOpcao )
	Local cCadastro := 'A670Vige - Altera��o Vig�ncia'
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
			
			AAdd( aPar,{ 9, 'Informe a data de vig�ncia', 150, 7, .T. } )
			AAdd( aPar,{ 1, 'Data', StoD(cDtVenc), '99/99/9999', '', '', '', 50, .T. } )
			
			If ParamBox( aPar, '', @aRet )
				IF Mv_par02 < StoD(cDtVenc)
					IF MsgYesNo('Aten��o,' + CRLF + CRLF +;
							'A data de vig�ncia informada deve ser igual ou maior que a �ltima data do cronograma que �: ' + DtoC(StoD(cDtVenc)) + CRLF +;
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
							   'alterou a Vig�ncia do contrato de indeterminado para ' + lTrim(Str(nDias)) + ' dias com data fim para ' + DtoC(dNewDay)
					
					Begin Transaction
					CN9->( RecLock( 'CN9', .F. ) )
			      		CN9->CN9_UNVIGE := '1' 
			      		CN9->CN9_VIGE   := nDias 
			      		CN9->CN9_DTFIM  := dNewDay 
			      		CN9->CN9_MOTALT := IIF( Empty(CN9->CN9_MOTALT), cHistory, AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory )
		      		CN9->( MsUnLock() )
		      		End Transaction
		      		
					MsgInfo('Altera��o realizada com sucesso.',cCadastro)
				EndIF
			Else
				MsgInfo('Opera��o abandonada pelo usu�rio.',cCadastro)
			Endif
		Else
			MsgAlert('ATEN��O'+CRLF+CRLF+;
			'Op��o dispon�vel apenas para contratos do tipo Indeterminado.' + CRLF +; 
			'Para alterar a vig�ncia deste contrato, fa�a a Revis�o do Contrato.',cCadastro)	
		EndIF	
	Else
		MsgAlert('Voc� n�o possui permiss�o para utilizar esta rotina. Verifique sua permiss�o no par�metro MV_670USER.',cCadastro)
	EndIF
Return

//-------------------------------------------------------------------------
// Rotina | A670ANIV     | Autor | Rafael Beghini     | Data | 16.08.2016
//-------------------------------------------------------------------------
// Descr. | Rotina de altera��o da data de Anivers�rio do contrato. Est�
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
	cCadastro := 'Modificar data de Anivers�rio'
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATEN��O'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revis�o atual '+CN9->CN9_REVATU+', pois este registro � uma revis�o antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
				AAdd( aPar,{ 9, 'Informe a data de anivers�rio:', 150, 7, .T. } )
				AAdd( aPar,{ 1, 'Data', CN9->CN9_DTANIV, '99/99/9999', '', '', '', 50, .F. } )
				bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
								MsgYesNo( 'Confirma a altera��o dos dados do contrato?', cCadastro ),;
								( MsgAlert('Data de anivers�rio do contrato a ser alterada n�o informada, verifique.', cCadastro ), .F. ) ) }	
				Set( 4, 'dd/mm/yyyy' )
				If ParamBox( aPar, 'Modificar Data In�cio do Contrato', @aRet, bOK, , , , , , , .F., .F. )
					
					CN9->( RecLock( 'CN9', .F. ) )
					If CN9->CN9_DTANIV <> mv_par02
						CN9->CN9_DTANIV := mv_par02
					Endif
					CN9->( MsUnLock() )
					MsgInfo('Altera��o realizada com sucesso.',cCadastro)
				Else
					MsgInfo('Opera��o abandonada pelo usu�rio.',cCadastro)
				Endif
		Endif
	Else
		MsgAlert('Voc� n�o possui permiss�o para utilizar esta rotina. Verifique sua permiss�o no par�metro MV_670USER.',cCadastro)
	Endif
	
Return

//-------------------------------------------------------------------------
// Rotina | A670RENO     | Autor | Rafael Beghini     | Data | 14.09.2016
//-------------------------------------------------------------------------
// Descr. | Rotina de altera��o dO Tipo de Renova��o do contrato, aviso de
//        | vencimento peri�dico. Est� sendo acionada pelo PE CTA100MNU.
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
	cCadastro := 'Modificar tipo de Renova��o'
	
	aCN9_RENOV := StrToKarr( Posicione( 'SX3', 2, 'CN9_TPRENO', 'X3CBox()' ), ';' )
	
	If nAllowed == 1
		If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATEN��O'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revis�o atual '+CN9->CN9_REVATU+', pois este registro � uma revis�o antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
				AAdd( aPar,{ 9, 'Selecione o tipo de Renova��o:', 150, 7, .T. } )
				AAdd( aPar,{ 2, 'Tipo', 1, aCN9_RENOV, 100, "",.T.} )
				
				AAdd( aPar,{ 9, 'Informe a periodicidade:', 150, 7, .T. } )
				AAdd( aPar,{ 1, 'Aviso de T�rmino',CN9->CN9_AVITER,"@E 999","","","",20,.F.})
				AAdd( aPar,{ 1, 'Aviso Peri�dico' ,CN9->CN9_AVIPER,"@E 999","","","",20,.F.})
				
				bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
								MsgYesNo( 'Confirma a altera��o dos dados do contrato?', cCadastro ),;
								( MsgAlert('Tipo renova��o do contrato a ser alterada n�o informada, verifique.', cCadastro ), .F. ) ) }	
				
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
					MsgInfo('Altera��o realizada com sucesso.',cCadastro)
				Else
					MsgInfo('Opera��o abandonada pelo usu�rio.',cCadastro)
				Endif
		Endif
	Else
		MsgAlert('Voc� n�o possui permiss�o para utilizar esta rotina. Verifique sua permiss�o no par�metro MV_670USER.',cCadastro)
	Endif

Return

//-------------------------------------------------------------------------
// Rotina | A670REAJ     | Autor | Rafael Beghini     | Data | 14.09.2016
//-------------------------------------------------------------------------
// Descr. | Rotina de altera��o REAJUSTE=Sim/Nao e o �ndice utilizado
//        | Est� sendo acionada pelo PE CTA100MNU.
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
			MsgInfo('ATEN��O'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revis�o atual '+CN9->CN9_REVATU+', pois este registro � uma revis�o antiga '+CN9->CN9_REVISA+'.',cCadastro)
		Else
				AAdd( aPar,{ 9, 'Informe se o contrato possui Reajuste', 150, 7, .T. } )
				AAdd( aPar,{ 2, 'Reajusta', 1, aCN9_FLGREJ, 50, "",.T.} )
				
				AAdd( aPar,{ 9, 'Informe o Indice de corre��o', 150, 7, .T. } )
				AAdd( aPar,{ 1, 'Indice',CN9->CN9_INDICE,"","Vazio().or.ExistCpo('CN6')","CN6","",20,.F.})
				
				bOk := {|| 	Iif( .NOT. Empty( mv_par02 ), ;
								MsgYesNo( 'Confirma a altera��o dos dados do contrato?', cCadastro ),;
								( MsgAlert('Reajuste do contrato a ser alterada n�o informada, verifique.', cCadastro ), .F. ) ) }	
				
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
					MsgInfo('Altera��o realizada com sucesso.',cCadastro)
				Else
					MsgInfo('Opera��o abandonada pelo usu�rio.',cCadastro)
				Endif
		Endif
	Else
		MsgAlert('Voc� n�o possui permiss�o para utilizar esta rotina. Verifique sua permiss�o no par�metro MV_670USER.',cCadastro)
	Endif
Return
//-------------------------------------------------------------------------
// Rotina | A670Qry     | Autor | Rafael Beghini     | Data | 28/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina para buscar a �ltima data do cronograma do contrato em 
//        | quest�o.
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
	aAdd(aHelp,{'CNA_DESCRI', 'Descri��o da planilha.'    })
Return

//Renato Ruy - 28/10/2017
//Copia do fonte padr�o CN100DtFim
User Function ZCN100Dt(cTipV,dDtIni,nVig,lExec)
Local nX			:= 0
Local nDiaIni		:= 1
Local dDtOri		:= dDtIni
Local dDtUsr		:= dDtIni
Local dDataAssi	    := Iif(IsInCallStack('GCP320Grv'), dDtIni,  CN9->CN9_DTASSI)
Local oModel		:= FWModelActive()
Local lMVC			:= oModel <> Nil
Local aSaveLines	:= FWSaveRows()
Local lDtAssi		:= SuperGetMv("MV_GCTDTTR",.F.,.F.) // Calcula a data de t�rmino da vig�ncia tendo como in�cio a data de assinatura.
Local lGCTDTAN		:= SuperGetMv("MV_GCTDTAN",.F.,.F.)
Local lOrigemGCP
Local lUpdateCNA

Default lExec := .T.

//Tratativa feita para quando vier da Ata pegar a data de publica��o da Ata
If !(IsInCallStack('GCP320Grv'))
	dDataAssi	:= CN9->CN9_DTASSI
Else
	dDataAssi := dDtIni
EndIf

If lMVC .And. !Empty(CN9->CN9_ASSINA)
	dDataAssi := CN9->CN9_ASSINA
EndIf

//Considera a data da assinatura e n�o da abertura do contrato.
If lDtAssi .And. !Empty(dDataAssi)
	dDtIni := dDataAssi
EndIf

If (!Empty(nVig) .Or. cTipV == "4") .And. !Empty(dDtIni)
	Do Case
		Case cTipV == "1"  //Dia
			dDtIni += nVig
		Case cTipV == "2"  //Mes
			nDiaIni := Day(dDtIni) //Dia do in�cio do contrato.
			For nX := 1 to nVig
				dDtIni += CalcAvanco(dDtIni,.F.,.F.,nDiaIni)
			Next
		Case cTipV == "3"  //Ano
			//���������������������������������������Ŀ
			//� Valida ano bissexto                   �
			//�����������������������������������������
			If Day(dDtIni) == 29 .And. Month(dDtIni) == 2 .And. ((Year(dDtIni)+nVig) % 4 != 0)
				dDtIni := cTod("28/02/"+str(Year(dDtIni)+nVig))
			Else
				dDtIni := cTod(str(Day(dDtIni))+"/"+str(Month(dDtIni))+"/"+str(Year(dDtIni)+nVig))
			EndIf
			//segundo a legisla��o de contrato o primeiro dia n�o conta na vigencia sendo assim o dia de inicio � o mesmo dia do fim no mes final
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
//        | unit�rio conforme amarra��o do fornecedor X produto. 
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