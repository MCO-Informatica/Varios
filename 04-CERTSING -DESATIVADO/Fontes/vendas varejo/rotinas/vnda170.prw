#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA170    �Autor  �Opvs (Darcio)       � Data �  05/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte criado para trazer as informacoes do tipo de voucher  ���
���          �para a aba Regras de Movimentacao.                          ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VNDA170(cCampo)

Local aArea	:= GetArea()
Local cRet	:= ""

//ZF_EMNTVEN - ZF_TESS    - ZF_TESP  - ZF_ALBIVE - ZF_EMNTENT - ZF_TESE   - ZF_ARQEST - ZF_TPMOVIM
//ZH_EMNTVEN - ZH_TPOPSER - ZH_TPOPP - ZH_ALBIVE - ZH_EMNTENT - ZH_TPOENT - ZH_ARQEST - ZH_TPMOVIM

If "ZF_EMNTVEN" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_EMNTVEN")
ElseIf "ZF_TPOPSER" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_TPOPSER")
ElseIf "ZF_TPOPP" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_TPOPP")
ElseIf "ZF_ALBIVE" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_ALBIVE")
ElseIf "ZF_EMNTENT" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_EMNTENT")
ElseIf "ZF_TPOPENT" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_TPOPENT")
ElseIf "ZF_ARQEST" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZH_ARQEST")
ElseIf "ZF_TPMOVIM" $ cCampo
	cRet := Posicione("SZH",1,xFilial("SZH") + M->ZF_TIPOVOU, "ZF_TPMOVIM")
EndIf

RestArea(aArea)
Return(cRet)