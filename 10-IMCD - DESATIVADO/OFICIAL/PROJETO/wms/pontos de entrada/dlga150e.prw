#Include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DLGA150E �Autor  �  Edson Estevam       Data �  31/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adequar o novo registro gerado no SC9 ��
���          � quando � realizada a sele��o do Lote via rotina de Libera��o��
���          � de estoque. ( Clicando no bot�o Sel Lote )                   ��
�������������������������������������������������������������������������͹��
���Uso       � MAKENI                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DLGA150E()

	Local aArea     := GetArea()
	Local aAreaDCF  := DCF->(GetArea())
	Local aAreaSC9  := SC9->(GetArea())
	Local _lRet     := .T.
	Local _cPedido   := Alltrim(DCF->DCF_DOCTO)
	Local _cItem     := Alltrim(DCF->DCF_SERIE)
	Local _cLoteCTL  := Alltrim(DCF->DCF_LOTECT)

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "DLGA150E" , __cUserID ) 

	If !Empty(_cLoteCTL) // Ira processar o Apanhe Por Lote e nao por data de Validade ( Apanhe por lote Regra=1 e por Validade Regra=3)
		If !empty(_cPedido) .AND. Alltrim(DCF->DCF_ORIGEM) == "SC9"  
			DbSelectarea("SC9")
			DBSETORDER(1)
			_lAtuDCF :=.F.
			If DbSeek(xFilial("SC9")+ _cPedido+_cItem)
				While !Eof() .AND. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == xFILIAL("SC9")+_cPedido + _cItem
					If SC9->C9_BLWMS == "02"
						_lAtuDCF := .T.
						RecLock("SC9",.F.)
						SC9->C9_BLWMS := "01"
						SC9->C9_REGWMS := "1"
						MsUnLock()
					Endif
					DbSkip()
				Enddo    
				If _lAtuDCF
					DbSelectarea("DCF")
					RecLock("DCF",.F.)
					DCF->DCF_REGRA="1"
					MsUnlock()
				Endif
			Endif       
		Endif
	Endif

	RestArea(aAreaSC9)
	RestArea(aAreaDCF)
	RestArea(aArea)

Return _lRet
