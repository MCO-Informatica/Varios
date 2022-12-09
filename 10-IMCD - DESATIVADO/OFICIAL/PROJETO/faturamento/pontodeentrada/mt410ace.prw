#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MT410ACE  � Autor � Eneovaldo Roveri Juni � Data �17/11/2009���
�������������������������������������������������������������������������Ĵ��
���Descricao �Checar se o pedido est� cancelado                           ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT410ACE()
	Local _nOpc
	Local _lRet := .T.
	Local aArea := GetArea()
	Local aAreaSC6 := SC6->( GetArea() )
	Local cUserAcesso := ""
	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT410ACE" , __cUserID )

	_nOpc := ParaMixB[1]

	//--------------------------------------------
	//Alterado em 16/01/18 por Marcos Andrade
	//Desabilitar a fun��o copiar pedido de venda
	//--------------------------------------------
	cUserAcesso := SUPERGETMV("ES_BTCOPPV", .F., "000390/000315")

	If _nOpc == 3 .and. !(__cUserID $  cUserAcesso )
		msgAlert("Fun��o indispon�vel!")
		_lRet:=.F. 
	Endif

	if _lRet
		if _nOpc == 4
			if SC5->C5_X_CANC == "C"
				msgAlert("Pedido est� cancelado")
				_lRet := .F.
			endif
		endif
	endif

	if _lRet
		if _nOpc == 4
			if SC5->C5_TPCARGA == "1"
				dbSelectArea( "DAI" )
				dbsetorder(4)
				if DAI->( dbSeek( xFilial("DAI") + SC5->C5_NUM ) )
					msgAlert("Pedido tem rota cadastrada. Proibida Altera��o")
					_lRet := .F.
				endif
			endif
		endif
	endif

	If _lRet .and. _nOpc == 4
		SC6->( dbSetOrder( 1 ) )
		SC6->( dbSeek( xFilial( "SC6" ) + SC5->C5_NUM ) )
		While SC6->( !Eof() ) .and. SC6->( C6_FILIAL + C6_NUM ) == xFilial( "SC6" ) + SC5->C5_NUM 
			If !Empty( SC6->C6_NOTA )
				msgAlert("Esse pedido j� teve um faturamento. Proibida Altera��o")
				_lRet := .F.
				Exit
			Endif

			SC6->( dbSkip() )
		End

	Endif

	RestArea( aAreaSC6 )
	RestArea(aArea)
Return( _lRet )
