#Include "Protheus.CH"
#Include "rwmake.CH"
/*
+==============================================================+
|Programa: MTA177Cli |Autor: Antonio Carlos |Data:26/09/08     |
+==============================================================+
|Descricao: PE Central de Compras onde permite a troca do      |
|cliente(filial necessidade) na geracao dos Pedidos de Vendas  |
+==============================================================+
|Uso: Especifico Laselva                                       |
+==============================================================+
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MTA177Cli()
/////////////////////////

Local aArea		:= GetArea()
Local aRet		:= {"",""}
Local aParam	:= PARAMIXB

_cQuery := "UPDATE " + RetSqlName('AIE')
_cQuery += _cEnter + "SET AIE_TIPO = '" + _cTipoCalc + "'"
_cQuery += _cEnter + " WHERE AIE_NUM = '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + " AND AIE_FILIAL = '" + AIE->AIE_FILIAL + "'"
_cQuery += _cEnter + " AND AIE_MSFIL = '" + AIE->AIE_MSFIL + "'"
_cQuery += _cEnter + " AND AIE_FILIAL = '" + AIE->AIE_FILIAL + "'"
_cQuery += _cEnter + " AND " + RetSqlName('AIE') + ".D_E_L_E_T_ = ''"
TcSqlExec(_cQuery)


_CCABTXT := ''

_cTexto := 'Os pedidos de venda n�o foram gerados. O programa ser� encerrado. Entre novamente no sistema' + _cEnter + _cEnter
_cTexto += 'A rotina de central de compras tem uma nova forma de funcionamento:'  + _cEnter  + _cEnter
_cTexto += 'A partir de 1�/11/2010, rode o c�lculo das necessidades e ap�s a conclus�o do mesmo, clique no bot�o SALVAR (disquete) para gravar o c�lculo realizado.'  + _cEnter
_cTexto += 'Ap�s a grava��o, clique no bot�o CANCELAR (sim, CANCELAR) para gerar'  + _cEnter
_cTexto += 'os pedidos de vendas e romaneios.'  + _cEnter

MsgInfo(_cTexto,'Central de Compras')
__Quit()

DbSelectArea("SA1")
SA1->(DbSetOrder(9))
If SA1->(DbSeek(aParam[2]+aParam[1]))
	aRet[1] := SA1->A1_COD
	aRet[2] := SA1->A1_LOJA
EndIf

Return()

