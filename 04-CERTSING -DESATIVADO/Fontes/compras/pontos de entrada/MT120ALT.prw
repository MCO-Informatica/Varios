#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | MT120ALT | Autor | Rafael Beghini | Data | 16.10.2018 
//+-------------------------------------------------------------------+
//| Descr. | PE - Valida o registro do PC se autoriza a altera��o
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function MT120ALT()
    Local lRet  := .T.
    Local lStop := cValToChar( ParamIXB[1] ) == '4' //-- Altera��o
    Local cPed  := SC7->C7_FILIAL + '-' + SC7->C7_NUM

    IF lStop .And. ( SC7->C7_QTDACLA >0 .Or. ( SC7->C7_QUJE <> 0 .And. SC7->C7_QUJE < SC7->C7_QUANT ) .Or. ;
        ( SC7->C7_QUJE >= SC7->C7_QUANT ) ) .And. Empty( SC7->C7_CONTRA ) .And. Empty( SC7->C7_RESIDUO )
        MsgStop( 'O pedido de compras ' + cPed + ' j� sofreu movimenta��o.' + CRLF + CRLF +;
                    'Para qualquer altera��o efetue a exclus�o da pr� nota.', '[MT120ALT] Altera��o Pedido')
        lRet := .F.
    EndIF
Return( lRet )