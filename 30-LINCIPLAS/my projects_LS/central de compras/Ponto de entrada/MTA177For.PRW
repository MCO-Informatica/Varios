#Include "Protheus.CH"

User Function MTA177For()

Local aRet := {"", ""}
Local aParam := PARAMIXB


_cQuery := "UPDATE " + RetSqlName('AIE')
_cQuery += _cEnter + "SET AIE_TIPO = '" + _cTipoCalc + "'"
_cQuery += _cEnter + " WHERE AIE_NUM = '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + " AND AIE_FILIAL = '" + AIE->AIE_FILIAL + "'"
_cQuery += _cEnter + " AND AIE_MSFIL = '" + AIE->AIE_MSFIL + "'"
_cQuery += _cEnter + " AND " + RetSqlName('AIE') + ".D_E_L_E_T_ = ''"
TcSqlExec(_cQuery)


_CCABTXT := ''

_cTexto := 'Os pedidos de venda n?o foram gerados. O programa ser? encerrado. Entre novamente no sistema' + _cEnter + _cEnter
_cTexto += 'A rotina de central de compras tem uma nova forma de funcionamento:'  + _cEnter  + _cEnter
_cTexto += 'A partir de 1?/11/2010, rode o c?lculo das necessidades e ap?s a conclus?o do mesmo, clique no bot?o SALVAR (disquete) para gravar o c?lculo realizado.'  + _cEnter
_cTexto += 'Ap?s a grava??o, clique no bot?o CANCELAR (sim, CANCELAR) para gerar'  + _cEnter
_cTexto += 'os pedidos de vendas e romaneios.'  + _cEnter

MsgInfo(_cTexto,'Central de Compras')
__Quit()

DbSelectArea("SA2")
SA2->(DbSetOrder(8))
If SA2->(DbSeek(aParam[2]+aParam[1]))	
	aRet[1] := SA2->A2_COD
	aRet[2] := SA2->A2_LOJA
EndIf 


Return( aRet )