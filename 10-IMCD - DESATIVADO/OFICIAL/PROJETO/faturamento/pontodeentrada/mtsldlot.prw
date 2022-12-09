#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTSLDLOT   �Autor  �Delta              � Data �  18/04/10   ��
�������������������������������������������������������������������������͹��
���Desc.     � Regra para calculo de Lotes conforme regra de fator de validade���
�������������������������������������������������������������������������͹��
���Uso       � Makeni                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  


USER FUNCTION MTSLDLOT()


	Local _cProduto := PARAMIXB[01]
	Local _cLocal   := PARAMIXB[02]
	Local _cLoteCtl := PARAMIXB[03]
	Local _cLocaliz := PARAMIXB[05]
	Local _nFator   := 0
	Local  lRetorno  := .T.
	Local nDiasVal  := 0
	Local dDataLim
	Local _cTipo := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_TIPO")

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTSLDLOT" , __cUserID )

	If Upper(FUNNAME()) == "DLGA150"  // Execucao de Servi�os WMS


		_nFator := Posicione("SA1",1,xFilial("SA1")+DCF->(DCF_CLIFOR+DCF_LOJA),"SA1->A1_FATVALI")
		If _nFator > 0 .and. _cTipo  <> 'MA' // ALTERADO POR SANDRA NISHIDA EM 190516
			//RecLock("DCF",.F.)      
			//   	DCF->DCF_REGRA  := "4"
			// MsUnlock()
			dbSelectArea("SB8")
			dbSetOrder(3)
			If dbSeek(xFilial("SB8") + _cProduto + _cLocal + _cLoteCtl)

				If Empty(SB8->B8_DFABRIC)
					Alert("Aten��o: Lote " + AllTrim(SB8->B8_LOTECTL) + " do produto " + SB8->B8_PRODUTO + " sem data de fabrica��o! Verifique")
				Endif

				nDiasVal := SB8->B8_DTVALID - SB8->B8_DFABRIC
				nDiasVal := nDiasVal * ( _nFator / 100 )
				dDataLim := SB8->B8_DFABRIC + nDiasVal
				//If  dDataBase <= dDataLim
				If  dDataLim < dDataBase
					lretorno:= .F.  
				Endif
			Endif
		Endif
	Endif

Return lRetorno
