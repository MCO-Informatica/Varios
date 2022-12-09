#include "rwmake.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZ2     �Autor  �Marcos Zanetti GZ   � Data �  20/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � AxCadastro da tabela SZ2 (Grupo de naturezas)              ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Presstecnica                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function AXSZR()

Private cString := "SZR"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Grupos de Naturezas","U_AXSZREXC()",".T.")

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZ2EXC �Autor  �Marcos Zanetti GZ   � Data �  20/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a exclusao do registro                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function AXSZREXC()
local _lRet := .T.
local _nRecSZR := SZR->(recno())
local _cGrupo := SZR->ZR_GRUPO

SED->(dbgotop())

while SED->(!eof()) .and. _lRet
	_lRet := _lRet .and. SED->ED_XGRUPO <> SZR->ZR_GRUPO
	SED->(dbskip())
enddo

if !_lRet
	msgstop("Existem naturezas vinculadas a esse grupo. Antes de exclui-lo, remova os v�nculos existentes.")
	return(_lRet)
endif

SZR->(dbgotop())

while SZR->(!eof()) .and. _lRet
	_lRet := _lRet .and. SZR->ZR_CODSUP <> _cGrupo
	SZR->(dbskip())
enddo

SZR->(Dbgoto(_nRecSZR))

if !_lRet
	msgstop("Esse grupo � est� vinculados a outros grupos como superior. Antes de exclui-lo, remova os v�nculos existentes.")
	return(_lRet)
endif

return(_lRet)
