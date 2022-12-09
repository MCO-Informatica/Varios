#INCLUDE "TOPCONN.CH"

User Function M410PVNF()

	Local _aArea 	:= GetArea()
	Local _lRet	 	:= .t.
	local cTipo      := SC5->C5_TIPO
	local cTransp    := SC5->C5_TRANSP
	local cPedShopfy := SC5->C5_XPEDSHP
	local cIdIntelip := if( ! Empty( cTransp ), Posicione( 'SA4', 1, xFilial( 'SA4' ) + cTransp, 'A4_XIDINTE' ), '' )


	if "NAO FATURAR" $ SC5->C5_MENNOTA
		_lRet := .F.
		Alert("O Pedido de Venda "+SC5->C5_NUM+" não pode ser faturado pois se trata da operção PAGE")
		Return _lRet
	endif

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.f.)

	
	IF SC5->C5_NOTA <> ' ' .AND. SC5->C5_SERIE <> ' '
		_lRet := .F.
		Alert("O Pedido de Venda "+SC5->C5_NUM+" já foi faturado."+chr(13)+;
			chr(13)+;
			"A Nota Fiscal é "+SC5->C5_NOTA+" Série "+SC5->C5_SERIE)
		Return _lRet
	ENDIF

	if cTipo == 'N' .And.;
			! Empty( cPedShopfy ) .And.;
			( Empty( cTransp ) .Or. Empty( cIdIntelip ) )

		ApMsgAlert( 'Informe uma transportadora com o código intelipost informado em seu cadastro.', 'Atenção' )

		_lRet := .f.

	endif


	RestArea(_aArea)


Return(_lRet)
