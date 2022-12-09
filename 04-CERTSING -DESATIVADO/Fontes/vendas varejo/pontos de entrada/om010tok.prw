#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM010TOK  �Autor  �RENATO RUY BERNARDO � Data �  18/04/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada criado para fazer a validacao Geral        ���
���          �na confirmar��o da rotina de tabela de pre�o.               ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign			                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function OM010TOK()

Local oModelx 	:= FWModelActive() //Abre o modelo ativo MVC
Local oModelxDet	:= oModelx:GetModel('DA1DETAIL') //Abre o aCols do MVC
Local nTotCab 	:= Len(oModelxDet:aCols[1])
Local lRet			:= .T.

//Percorre o la�o do acols da tela
For nI := 1 To Len(oModelxDet:aCols)
	//Se � atualiza��o valida
	If Len(oModelxDet:aCols[nI]) >= nTotCab
		//Se uma linha e de combo, faz a validacao.
		If !Empty(oModelxDet:GetValue("DA1_CODCOB",nI)) .And. oModelxDet:aCols[nI,nTotCab]
			MsgStop('O item '+oModelxDet:GetValue("DA1_ITEM",nI)+' n�o pode ser exclu�do, por se tratar de um Combo.')
			lRet := .F.
			nI := Len(oModelxDet:aCols)
		EndIf
	Endif
Next


Return(lRet)