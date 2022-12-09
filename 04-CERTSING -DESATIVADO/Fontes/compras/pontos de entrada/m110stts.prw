//--------------------------------------------------------------------------
// Rotina | M110STTS   | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no final da grava��o dos da solicita��o
//        | de compras.
//--------------------------------------------------------------------------
// PAR�METROS - PROTHEUS 12
// ParamIXB[ 1 ] - N�mero da solicita��o de compras.
// ParamIXB[ 2 ] - N�mero que representa a funcionalidade, sendo 1=Incluir;
//                                                               2=Alterar;
//                                                               3=Excluir.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'

User Function M110STTS()
	Local cC1_NUM := ''
	Local cMsg := ''
	
	cC1_NUM := ParamIXB[ 1 ] 
	 
	If INCLUI .OR. ALTERA .OR. lCopia
		If INCLUI .OR. lCopia
			A110ChkBlq( cC1_NUM )
		Endif
		
		If ALTERA .OR. lCopia
			A110BackBlq( cC1_NUM )
		Endif
		
		LjMsgRun('Gerando e anexando o documento, aguarde...','Formul�rio de solicita��o de compra',;
		{|| U_A800FormSC( cC1_NUM ) }, NIL )
		
		cMsg := 'Neste momento existe a possibilidade de solicitar aprova��o desta solicita��o de compras '
		cMsg += 'para o gestor respons�vel pelo centro de custo informado, por favor, selecione uma das '
		cMsg += 'op��es abaixo para continuar com sua opera��o. '+CRLF+CRLF+'Enviar - enviar workflow neste momento. '+CRLF+'N�o enviar - n�o enviar workflow neste momento.'
		
		If Aviso('Workflow Solicita��o de Compras',cMsg,{'N�o enviar','Enviar'},3,'Solicitar Aprova��o') == 2
			If IsBlind()
				U_CSFA710( cC1_NUM, 'M110STTS' )
			Else
				FWMsgRun( , {|| U_CSFA710( cC1_NUM, 'M110STTS' ) }, ,'Solicita��o de compras, enviando WF...' )
			Endif
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A110ChkBlq | Autor | Robson Goncalves         | Data | 26/01/18
//--------------------------------------------------------------------------
// Descr. | Rotina para cheqcar se realmente todos os itens est�o aguardando
//        | aprova��o.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A110ChkBlq( cC1_NUM )
	Local cUpd := ''
	
	SC1->( dbSetOrder( 1 ) )
	If SC1->( dbSeek( xFilial( 'SC1' ) + cC1_NUM ) )
	
		cUpd := "UPDATE " + RetSqlName( "SC1" ) + " "
		cUpd += "SET C1_APROV = 'B', C1_DTAVAL = ' ', C1_NOMAPRO = ' ' "
		cUpd += "WHERE D_E_L_E_T_ = ' ' "
		cUpd += "AND C1_NUM = '" + SC1->C1_NUM + "' "
		cUpd += "AND C1_FILIAL = '" + xFilial( "SC1" ) + "' "
		
		TCSqlExec( cUpd )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A110BackApr | Autor | Robson Goncalves         | Data | 26/01/18
//--------------------------------------------------------------------------
// Descr. | Rotina para voltar o bloqueio da solicita��o de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A110BackBlq( cC1_NUM )
	Local cUpd := ''
	
	SC1->( dbSetOrder( 1 ) )
	If SC1->( dbSeek( xFilial( 'SC1' ) + cC1_NUM ) )
	
		cUpd := "UPDATE " + RetSqlName( "SC1" ) + " "
		cUpd += "SET C1_APROV = 'B', C1_DTAVAL = ' ', C1_NOMAPRO = ' ' "
		cUpd += "WHERE D_E_L_E_T_ = ' ' "
		cUpd += "AND C1_NUM = '" + SC1->C1_NUM + "' "
		cUpd += "AND C1_FILIAL = '" + xFilial( "SC1" ) + "' "
		
		TCSqlExec( cUpd )
		
		MsgInfo( '� necess�rio solicitar novamente aprova��o desta solicita��o de compras: ' + cC1_NUM, 'Solicita��o de Compras' )
	Endif
Return