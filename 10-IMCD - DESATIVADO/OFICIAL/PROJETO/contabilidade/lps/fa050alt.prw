#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050ALT  �Autor  �Sandra Nishida      � Data �  15/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida preenchimento do campo e2_xcodoper e e2_xlojoper     ���
���          �para operacoes de Compror e Vendor                          ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function FA050ALT()   

	cRet  := .t.
	carea := GetArea()

	If alltrim(m->e2_naturez) $'222013/222014' .and. (empty(m->e2_xforope) .or. empty(m->e2_xlojope))     
		Aviso("FA050ALT"," Operacoes de Compror/Vendor, necessario incluir o codigo de fornecedor origem da operacao (e2_xcodoper)",{"OK"},2)      
		cRet := .f.   
	endif

	RestArea(cArea)
Return cRet