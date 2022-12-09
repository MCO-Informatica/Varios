#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'rwmake.CH'
              
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		LS_VALC6PROD
// Autor		Alexandre Dalpiaz
// Data			25/09/2012
// Descricao	Validação do produto no pedido de vendas
//				não permite inclusão de produtos que não estejam cadastrados na tabela de preços 001 (somente na clio matriz C0)
// Uso			Laselva 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_VALC6PROD()
////////////////////////////

Local _lRet := .t.

If cFilAnt == 'C0' .and. !empty(M->C5_TABELA) .and. FunName() <> 'FATP014'
	DA1->(DbSetOrder(1))
	If !(DA1->(DbSeek(xFilial('DA1') + M->C5_TABELA + M->C6_PRODUTO,.f.)))
		MSgBox('Produto não cadastrado na tabela de preços','ATENÇÃO!!!','ALERT')
		_lRet := .f.
	EndIf
EndIf

Return(_lRet)