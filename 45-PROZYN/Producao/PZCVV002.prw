#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVV002		�Autor  �Microsiga	     � Data �  14/02/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o da restri��o de armazens em movimentos internos   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVV002()

Local aArea 	:= GetArea()
Local lRet		:= .T.
Local cTpObrig	:= U_MyNewSX6("CV_TPPRDQE", "MP|PI","C","Tipos de produtos obrigatorio o preenchimento da embalagem", "", "", .F. )

If (Alltrim(M->B1_TIPO) $ Alltrim(cTpObrig)) .And. M->B1_QE <= 0
	Aviso("Aten��o","O campo �Quantidade por Embalagem� � obrigat�rio para os tipos de produtos '"+Alltrim(cTpObrig)+"'. ",{"Ok"},2)
	lRet := .F.
EndIf

RestArea(aArea)	
Return lRet