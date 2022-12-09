#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCRME002  �Autor  �Derik Santos        � Data �  19/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Execblock para verificar se o prospect possui contato      ���
���Desc.     � cadastrado, caso n�o tenha exibe um alerta e abre tela     ���
���Desc.     � para cadastro    									      ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 12 - Prozyn                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function RCRME002() 

_cOport  := M->AD1_NROPOR
_cRevis1 := "01"
_cRevis2 := M->AD1_REVISA
_cTipo   := M->AD1_TIPO
_cPerc   := M->AD1_PERCEN 
_cPont	 := M->AD1_PONTUA

DbSelectArea("AD1")
dbSetOrder(1) //Filial + Projeto + Revis�o
If dbSeek(xFilial("AD1") + _cOport + _cRevis1)
	Alert("Altera��o n�o permitida")
	Return (.F.)
Else
	If _cPont == "2" .AND. _cTipo <> "1"
		_cPerc += 60
		M->AD1_PERC   := _cPerc
		M->AD1_PERCEN := _cPerc
		Return (.T.)
	Elseif _cPont == "1" .AND. _cTipo == "1"
		_cPerc -= 60
		M->AD1_PERC   := _cPerc
		M->AD1_PERCEN := _cPerc
		M->AD1_PONTUA := "2"
		M->AD1_CONCL1 := ""
		M->AD1_CONCL3 := ""
		M->AD1_DOCS   := .F.
		Return (.T.)
	Else
		Return (.T.)			
	EndIf
EndIf