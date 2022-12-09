#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT241EXT �Autor  � Junior Carvalho    � Data �  31/01/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � BLOQUEAR EXCLUSAO DE MOVIMENTACAO INTERNA  QUE GERARAM     ���
���          � CUSTOS do DOC. DE ENTRADA                                  ���
�������������������������������������������������������������������������͹��
���Uso       � IMCD                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT241EXT()

	Local lRet := .T.
	Local cDocSd1 := SD3->D3_XIMPEIC
	If !Empty(cDocSd1)
		cChvSF1 := Substr(D3_XIMPEIC,1,At("EIC",cDocSd1)-1)

		cUsuarios := SuperGetMV("ES_USRCEIC", ," ")

		if __CUSERID $ cUsuarios
			lRet := .T.
		Else
			cMsg1:= "Essa movimenta��o foi gerada por custos de Importa��o."
			cMsg2:= "S� poder� ser estornada, pelo Departamento de Custos."

			Aviso( "MT241EXT", cMsg1+CRLF+cMsg2, { "Ok" }, 2 )
			lRet := .F.
		EndIf
	Endif

Return lRet
