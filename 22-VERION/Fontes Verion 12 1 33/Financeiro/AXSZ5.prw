#include "rwmake.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZ5     �Autor  �Silverio Bastos     � Data �  05/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � AxCadastro da tabela SZ5 (Grupo de naturezas)              ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Verion                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function AXSZ5()

Private cString := "SZ5"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Grupos de Naturezas","U_AXSZ5EXC()",".T.")

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZ5EXC �Autor  �Marcos Zanetti GZ   � Data �  20/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a exclusao do registro                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function AXSZ5EXC()
local _lRet := .T.
local _nRecSZ5 := SZ5->(recno())
local _cGrupo := SZ5->Z5_GRUPO

SED->(dbgotop())

while SED->(!eof()) .and. _lRet
	_lRet := _lRet .and. SED->ED_XGRUPO <> SZ5->Z5_GRUPO
	SED->(dbskip())
enddo

if !_lRet
	msgstop("Existem naturezas vinculadas a esse grupo. Antes de exclui-lo, remova os v�nculos existentes.")
	return(_lRet)
endif

SZ5->(dbgotop())

while SZ5->(!eof()) .and. _lRet
	_lRet := _lRet .and. SZ5->Z5_CODSUP <> _cGrupo
	SZ5->(dbskip())
enddo

SZ5->(Dbgoto(_nRecSZ5))

if !_lRet
	msgstop("Esse grupo � est� vinculados a outros grupos como superior. Antes de exclui-lo, remova os v�nculos existentes.")
	return(_lRet)
endif

return(_lRet)
