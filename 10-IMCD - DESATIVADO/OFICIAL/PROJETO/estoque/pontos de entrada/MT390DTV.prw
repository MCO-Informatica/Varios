#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MT390DTV
LOCALIZA��O : Function A390PrcVal() - Respons�vel por processar altera��o da data de validade.
EM QUE PONTO: Ap�s a altera��o da data de validade.
@type function
@version 1.0
@author marcio.katsumata
@since 16/07/2020
@return nil, nil
@see    https://tdn.totvs.com/display/public/PROT/MT390DTV+-+Data+de+Validade
/*/
user function MT390DTV()
Local dFab 	:= SB8->B8_DFABRIC
Local nReg	:= 1

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT390VLV" , __cUserID )

If Type("aRecno") == "A"
	lRetMsgGet2 := MsgGet2("Data de Fabrica��o", "Data de fabrica��o:", @dFab, , {||.T.})
	
	IF lRetMsgGet2 .AND. dFab < ddatabase
		dbSelectArea("SB8")
		RecLock("SB8",.F.)
		sb8->B8_DFABRIC := dFab
		msUnlock()
	Endif
Endif
