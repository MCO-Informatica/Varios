#include 'protheus.ch'



/*/{Protheus.doc} SC6460X
Ponto de entrada no pedido de venda
para realizar a atualização da PTAX.
@type function
@version 1.0
@author marcio.katsumata
@since 27/07/2020
@return return_type, return_description
/*/
user function SC6460X()
    local cTabela	as character	
    local dDataPed  as numeric  
    local cCliente 	as character
	local cLoja 	as character	
    local nQtd      as numeric  
    local nPMoeda   as numeric  
    local nVlrInf   as numeric  
    local nAliqIMP	as numeric
    local nPMoeda	as numeric	
    local nTaxa     as numeric  
	local nPreco    as numeric  

    if SC6->C6_CF == '7102'

	    cTabela		:= SC5->C5_TABELA
        dDataPed    := SC5->C5_EMISSAO
	    cCliente 	:= SC5->C5_CLIENTE
	    cLoja 		:= SC5->C5_LOJACLI
        nQtd        := SC6->C6_QTDVEN
        nPMoeda     := SC6->C6_XMOEDA
        nVlrInf     := SC6->C6_XVLRINF
        nAliqIMP	:= SC6->(C6_XICMEST+C6_XPISCOF)
        nTaxa       := u_ptaxCompra(ALLTRIM(str(nPmoe,1) ))
		nPreco      := MaTabPrVen(cTabela,cProd,nQtd,cCliente, cLoja, nPMoeda ,dDataPed)

		
		If nVlrInf > 0
			nPreco :=  nVlrInf
		Endif
		
		IF(nAliqIMP > 0)
			nAliqIMP := ( nAliqImp / 100 )
		Endif

		nPreco := Round( (nPreco / (1- nAliqImp)) * nTaxa, TamSx3("C6_PRCVEN")[2] )
        nTotal := Round(nQtd * nPreco, TamSx3("C6_VALOR")[2] )



    endif


return
