#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA410    �Autor  �Bruno Abrigo        � Data �  06/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no 'ok' para validar o campo xEmbalagem   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA410()
Local lRet:=.T.
Local nPosLacre := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XLACRE" })
Local nPosxEmb  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XEMBALA" })

If Type("_lConfirm") # "U"
	MsgStop('N�o permitido copia de Pedidos com standy by !! Favor, incluir um novo Pedido !')
	Return _lConfirm
Endif

For i:=1 To Len(aCols)
	If nPosLacre > 0 .And. !Empty(aCols[i,nPosLacre]) .and. !aCols[i,Len(aHeader)+1]
		If Empty(aCols[i,nPosxEmb])
			MsgStop('N�o ser� possivel confirmar a grava��o do Pedido, verifique se os campos obrig�torios est�o preenchidos! - Campo: (xEmbalagem vazio)' )
			lRet:=.F.
			Return(lRet)
		Endif
	Endif
Next i

Return(lRet)
