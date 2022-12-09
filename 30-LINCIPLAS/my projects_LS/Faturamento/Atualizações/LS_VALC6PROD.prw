#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'rwmake.CH'
              
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		LS_VALC6PROD
// Autor		Alexandre Dalpiaz
// Data			25/09/2012
// Descricao	Valida��o do produto no pedido de vendas
//				n�o permite inclus�o de produtos que n�o estejam cadastrados na tabela de pre�os 001 (somente na clio matriz C0)
// Uso			Laselva 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_VALC6PROD()
////////////////////////////

Local _lRet := .t.

If cFilAnt == 'C0' .and. !empty(M->C5_TABELA) .and. FunName() <> 'FATP014'
	DA1->(DbSetOrder(1))
	If !(DA1->(DbSeek(xFilial('DA1') + M->C5_TABELA + M->C6_PRODUTO,.f.)))
		MSgBox('Produto n�o cadastrado na tabela de pre�os','ATEN��O!!!','ALERT')
		_lRet := .f.
	EndIf
EndIf

Return(_lRet)