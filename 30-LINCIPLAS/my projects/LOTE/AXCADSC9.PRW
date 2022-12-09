#include "TOPCONN.CH"
#include "rwmake.ch"
//
//
// Cadastro de Pedidos de Venda Liberados
User Function AXCADSC9()

AxCadastro("SC9","PEDIDOS DE VENDA LIBERADOS","U_DelC9Ok()","U__fC9OK()")

Return

User Function _fC9OK()
_lRet := .T.
If Inclui
    Alert('Opcao de Inclusao Nao Disponivel para essa rotina...')
    _lRet := .F.
EndIf
If Exclui
    MsgAlert("Opcao Excluir Nao Disponivel para essa rotina...")
    _lRet := .F.
EndIf
Return(_lRet)

User Function DelC9Ok()
MsgAlert("Opcao Nao Disponivel para essa rotina...")
_lRet := .F.
Return(_lRet)