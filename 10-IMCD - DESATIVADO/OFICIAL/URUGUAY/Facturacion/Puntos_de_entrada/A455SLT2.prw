#include 'protheus.ch'

/*/{Protheus.doc} A455SLT2
Este ponto de entrada é executado na montagem dos lotes que 
serão apresentados pelo usuário pela rotina MATA455.
Ele permite ao cliente personalizar o browse adicionando 
novos campos, porém não será permitido retirar os do sistema.
Este ponto é executado a cada registro de lote avaliado na 
tabela temporaria.
@type function
@version 1.0
@author marcio.katsumata
@since 17/04/2020
@return return_type, return_description
@see    https://tdn.totvs.com/display/public/PROT/A455SLT2+-+Montagem+de+lotes
/*/
user function A455SLT2()

    //--------------------------------------
    //Realiza validação shelf life do lote.
    //---------------------------------------
    if !u_ValidaShelfLife(SC9->C9_CLIENTE, SC9->C9_LOJA,SC9->C9_PEDIDO, SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL, TRB->TRB_LOTECT, SC9->C9_QTDLIB,.T.)
    	TRB->TRB_OK := ""
		TRB->TRB_LOTECT := ""
		TRB->TRB_NUMLOT := ""
		TRB->TRB_LOCALI := ""
		TRB->TRB_NUMSER := ""
		TRB->TRB_QTDLIB := 0
		TRB->TRB_POTENC := 0
		TRB->TRB_DTVALI := stod("")
    endif

return