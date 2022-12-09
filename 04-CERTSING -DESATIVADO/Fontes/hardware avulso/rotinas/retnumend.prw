#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RetNumEnd �Autor  �Darcio R. Sporl     � Data �  15/06/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que retorna o numero do endereco e tira o numero do  ���
���          �endereco.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RetNumEnd(cEndereco)
Local cEnd		:= ""
Local cNumEnd	:= ""
Local cNumero	:= ""
Local nPosNum	:= 0
Local nI		:= 0
	
nPosNum := 0
cNumEnd := AllTrim(cEndereco)
			
For nI := 1 To Len(cNumEnd)
	If Type(SubStr(cNumEnd,Len(cNumEnd) + 1 - nI ,1)) == "N"
		nPosNum := nPosNum + 1
	Else
		Exit
	EndIf
Next nI
			
cNumero	:= AllTrim(SubStr(cNumEnd, Len(cNumEnd) + 1 - nPosNum, nPosNum))
cEnd	:= AllTrim(StrTran(cNumEnd, cNumero, ""))
cEnd	:= AllTrim(StrTran(cEnd, ",", ""))

Return({cEnd, cNumero})