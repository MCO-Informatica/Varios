#include "rwmake.ch"

// Programa: SACI008
// Autor...: Alexandre Dalpiaz
// Data....: 21/06/11
// Funcao..: Apos a gravação da baixa dos titulos
//				utilizado para gravar a data da última baixa no título, para que não permita que uma 
//				proxima baixa seja feita com data anterior à última (PE fa070tit)
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
User Function SACI008()
///////////////////////

RecLock('SE1',.f.)     
//SE1->E1_DTULTBX := dDataBase
SE1->E1_CLASS := SA1->A1_CLASS
MsUnLock()

//_E2_CLASS()
_cQuery := "UPDATE " + RetSqlName('SE5')
_cQuery += _cEnter + " SET E5_CLASS = '" + SA1->A1_CLASS + "'"
_cQuery += _cEnter + " WHERE E5_FILIAL = '" + xFilial('SE5') + "'"
_cQuery += _cEnter + " AND E5_PREFIXO = '" + SE1->E1_PREFIXO + "'"
_cQuery += _cEnter + " AND E5_NUMERO = '" + SE1->E1_NUM + "'"
_cQuery += _cEnter + " AND E5_TIPO = '" + SE1->E1_TIPO + "'"
_cQuery += _cEnter + " AND E5_PARCELA = '" + SE1->E1_PARCELA + "'"
_cQuery += _cEnter + " AND E5_CLIENTE = '" + SE1->E1_CLIENTE + "'"
_cQuery += _cEnter + " AND E5_LOJA = '" + SE1->E1_LOJA + "'"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
TcSqlExec(_cQuery)
Return()


User Function FA070CAN()
Return()
