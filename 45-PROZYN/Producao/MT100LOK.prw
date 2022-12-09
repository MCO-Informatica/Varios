#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A175GRV �Autor  � Adriano Leonardo    � Data �  23/01/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na valida��o da linha do documento de     ���
���          � entrada, utilizado para validar os armaz�ns em notas de    ���
���          � devolu��o.                                                 ���
�������������������������������������������������������������������������͹�� 
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT100LOK()

Local _aSavArea := GetArea()
Local _cRotina	:= "MT100LOK"
Local _lRet		:= .T.
Local _nPosArm	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})
Local _nCont
Local _nQtdBlq	:= 0

If cTipo=="D" .And. Procname(5)<>"A103NFISCAL"

	For _nCont := 1 To Len(aCols)
		If !aCols[_nCont,Len(aCols[_nCont])]
			If aCols[_nCont,_nPosArm] <> SuperGetMV("MV_CQ",,"98")
				_nQtdBlq++
			EndIf
		EndIf
	Next
	
	If _nQtdBlq>1
		If MsgYesNo("Aten��o, para notas devolu��o � obrigat�rio, utilizar o armaz�m " + SuperGetMV("MV_CQ",,"98") + ", deseja alterar os armaz�ns automaticamente?",_cRotina+"_001")		
			For _nCont := 1 To Len(aCols)
				If !aCols[_nCont,Len(aCols[_nCont])]
					If aCols[_nCont,_nPosArm] <> SuperGetMV("MV_CQ",,"98")
						aCols[_nCont,_nPosArm] := SuperGetMV("MV_CQ",,"98")
					EndIf
				EndIf
			Next			
		Else
			_lRet := .F.
		EndIf
	Else
		For _nCont := 1 To Len(aCols)
			If !aCols[_nCont,Len(aCols[_nCont])]
				If aCols[_nCont,_nPosArm] <> SuperGetMV("MV_CQ",,"98")
					MsgStop("Aten��o, para notas devolu��o � obrigat�rio, utilizar o armaz�m " + SuperGetMV("MV_CQ",,"98") + ", favor corrigir o armaz�m desse item!",_cRotina+"_002")
					_lRet := .F.
					Exit
				EndIf
			EndIf
		Next	
	EndIf	
EndIf

RestArea(_aSavArea)

Return(_lRet)