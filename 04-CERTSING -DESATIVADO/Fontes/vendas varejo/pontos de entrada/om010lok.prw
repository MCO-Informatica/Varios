#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM010LOK  �Autor  �Darcio R. Sporl     � Data �  13/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada criado para fazer a validacao do item      ���
���          �da tabela de preco quando deletado, pois se tiver combo nao ���
���          �podera ser deletado.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function OM010LOK()
Local aArea		:= GetArea()
Local nPosC		:= aScan(aHeader, {|x| alltrim(x[2]) == "DA1_CODCOB"})
Local nPosGar		:= aScan(aHeader, {|x| alltrim(x[2]) == "DA1_CODGAR"})
Local nPosAtivo	:= aScan(aHeader, {|x| alltrim(x[2]) == "DA1_ATIVO"})
Local nPosQtd		:= aScan(aHeader, {|x| alltrim(x[2]) == "DA1_QTDLOT"})

Local lRet	:= .T.

//������������������������������������������������������������������������Ŀ
//�Se a linha do aCols estiver deletada verifica se o combo esta preenchido�
//��������������������������������������������������������������������������
//Renato Ruy - 18/04/2018
//Retirada Valida��o, o sistema n�o entra quando a linha esta deletada.
//If aCols[n][Len(aHeader) + 1]
//	If !Empty(aCols[n][nPosC])
//		MsgStop('Este item n�o pode ser exclu�do, por se tratar de um Combo.')
//		lRet := .F.
//	EndIf
//EndIf

If nPosGar > 0
	cProdGar := aCols[n][nPosGar] 
	nQtd	 := aCols[n][nPosQtd]
	If !Empty(cProdGar) 
		For nI := 1 to Len(aCols)
	    	If nI <> n .and. alltrim(aCols[nI,nPosGar]) == alltrim(cProdGar) .And. aCols[n,nPosAtivo] =='1' .And. aCols[nI,nPosAtivo] =='1' .and. aCols[nI,nPosQtd] == nQtd
	    		MsgStop('Produto GAR j� existe para a tabela.')
				lRet := .F.  		
				exit
		    EndIf
		Next
	EndIf
EndIf

RestArea(aArea)
Return(lRet)