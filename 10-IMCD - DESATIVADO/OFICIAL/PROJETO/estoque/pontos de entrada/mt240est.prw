#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT240EST �Autor  � Junior Carvalho    � Data �  31/01/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � BLOQUEAR EXCLUSAO DE MOVIMENTACAO INTERNA  QUE GERARAM     ���
���          � CUSTOS do DOC. DE ENTRADA                                  ���
�������������������������������������������������������������������������͹��
���Uso       � IMCD                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT240EST()

	Local lRet := .T.
	Local cDocSd1 := SD3->D3_XIMPEIC
	If !Empty(cDocSd1)

		cChvSF1 := Substr(D3_XIMPEIC,1,At("EIC",cDocSd1)-1)

		cUsuarios := SuperGetMV("ES_USRCEIC", ," ")

		if __CUSERID $ cUsuarios
			dbSelectArea("SD1")
			dbSetOrder(1)
			if MsSeek(cChvSF1)
				RecLock("SD1" , .F.)
				SD1->D1_XINTSD3 := ' '
				MsUnLock()
			EndIf
			lRet := .T.
		Else
			cMsg1:= "Essa movimenta��o foi gerada por custos de Importa��o."
			cMsg2:= "S� poder� ser estornada pelo Departamento de Custos."

			Aviso( "MT240EST", cMsg1+CRLF+cMsg2, { "Ok" }, 2 )
			lRet := .F.
		EndIf
	Endif

Return lRet

