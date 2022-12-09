//--------------------------------------------------------------------------
// Rotina | M110STTS   | Autor | Robson Goncalves        | Data | 21/12/2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no final da gravação dos da solicitação
//        | de compras.
//--------------------------------------------------------------------------
// PARÂMETROS - PROTHEUS 12
// ParamIXB[ 1 ] - Número da solicitação de compras.
// ParamIXB[ 2 ] - Número que representa a funcionalidade, sendo 1=Incluir;
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
		
		LjMsgRun('Gerando e anexando o documento, aguarde...','Formulário de solicitação de compra',;
		{|| U_A800FormSC( cC1_NUM ) }, NIL )
		
		cMsg := 'Neste momento existe a possibilidade de solicitar aprovação desta solicitação de compras '
		cMsg += 'para o gestor responsável pelo centro de custo informado, por favor, selecione uma das '
		cMsg += 'opções abaixo para continuar com sua operação. '+CRLF+CRLF+'Enviar - enviar workflow neste momento. '+CRLF+'Não enviar - não enviar workflow neste momento.'
		
		If Aviso('Workflow Solicitação de Compras',cMsg,{'Não enviar','Enviar'},3,'Solicitar Aprovação') == 2
			If IsBlind()
				U_CSFA710( cC1_NUM, 'M110STTS' )
			Else
				FWMsgRun( , {|| U_CSFA710( cC1_NUM, 'M110STTS' ) }, ,'Solicitação de compras, enviando WF...' )
			Endif
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A110ChkBlq | Autor | Robson Goncalves         | Data | 26/01/18
//--------------------------------------------------------------------------
// Descr. | Rotina para cheqcar se realmente todos os itens estão aguardando
//        | aprovação.
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
// Descr. | Rotina para voltar o bloqueio da solicitação de compras.
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
		
		MsgInfo( 'É necessário solicitar novamente aprovação desta solicitação de compras: ' + cC1_NUM, 'Solicitação de Compras' )
	Endif
Return