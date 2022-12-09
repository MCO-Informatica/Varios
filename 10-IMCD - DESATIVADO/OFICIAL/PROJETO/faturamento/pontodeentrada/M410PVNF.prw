   
/*/{Protheus.doc} MA410PVNF
Ponto de entrada para validação.
Executado antes da rotina de geração de NF's (MA410PVNFS()).
Programa Fonte
MATA410X.PRW
Sintaxe
M410PVNF - Geração de notas fiscais ( < nReg> ) --> lContinua
@type function
@version 1.0
@author marcio.katsumata
@since 28/07/2020
@return logical, continua?
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6784152
/*/  
user function MA410PVNF()
    
	local cCampo 	as character	
    local nPrc      as numeric  
    local nVlrTt   as numeric  
    local nAliqIMP	as numeric
    local nTaxa     as numeric  
	local nPreco    as numeric  
    local lRet      as logical
    local cChavePed  as character
    local cAltera  as character
    local aAreas   as array


    aAreas := {SC5->(getArea()), SC6->(getArea()),SC9->(getArea()), SA1->(getArea()), getArea()}
    lRet := .T.
    

    dbSelectArea("SC6")
    SC6->(dbSetOrder(1))
    if SC6->(dbSeek(SC5->(C5_FILIAL+C5_NUM)))

        cChavePed := SC5->(C5_FILIAL+C5_NUM)

        while SC6->(C6_FILIAL+C6_NUM) == cChavePed
            //-----------------------------------------
            //Verifica atualização da cotação da moeda
            //------------------------------------------
	        If SC6->C6_XMOEDA > 1
	        	IF SC6->C6_XMEDIO != 'S' .AND. SC5->C5_CONDPAG != '000'
	        		nTaxa := 0

	        		if SC5->C5_TIPOCLI == 'X'
	        			nTaxa       := u_ptaxCompra(alltrim(str(SC6->C6_XMOEDA,1)))
	        		else
	        			cCampo := 'M2_MOEDA' + alltrim(str(SC6->C6_XMOEDA,1))
	        			//msgAlert("Variavel da Moeda " + cCampo,"ATENÇÃO")
	        			DbSelectArea("SM2")
	        			DbSetOrder(1)
	        			If DbSeek(dDataBase)
	        				nTaxa := &cCampo
	        			endif
	        		endif

	        		if nTaxa > 0

	        			nAliqIMP := SC6->C6_XICMEST + SC6->C6_XPISCOF

	        			IF(nAliqIMP > 0)
	        				nAliqIMP := ( nAliqImp / 100 )
	        			Endif

	        			if SC6->C6_XVLRINF > 0
	        				nPreco :=  SC6->C6_XVLRINF
	        			else
	        				nPreco := MaTabPrVen(SC5->C5_TABELA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC5->C5_CLIENTE, SC5->C5_LOJACLI, SC6->C6_XMOEDA ,dDataBase)
	        			endif

	        			nPrc 	:= Round( (nPreco / (1- nAliqImp)) * nTaxa, TamSx3("C6_PRCVEN")[2] )
	        			nVlrTt	:= A410Arred( nPrc * SC6->C6_QTDVEN ,"C6_VALOR")


	        			cAltera := 'Taxa de: ' + alltrim(str(SC6->C6_XTAXA)) + ' Para: ' + alltrim( STR(nTaxa ) )
	        			cAltera += ' - Preço Unitario ' + alltrim( STR(nPrc))

	        			Reclock("SC6")
	        			SC6->C6_XTAXA  := nTaxa
	        			SC6->C6_PRCVEN := nPrc
	        			SC6->C6_PRUNIT := nPrc
	        			SC6->C6_VALOR  := nVlrTt
	        			MsUnlock()


                        dbSelectArea("SC9")
                        SC9->(dbSetOrder(2))
                        if SC9->(dbSeek(SC6->(C6_FILIAL+C6_CLI+C6_LOJA+C6_NUM+C6_ITEM)))
	        			    RecLock("SC9", .F.)
	        			    SC9->C9_PRCVEN := nPrc
	        			    MsUnlock()
                        endif

	        			U_GrvLogPd(SC6->C6_NUM,SC6->C6_CLI,SC6->C6_LOJA,'Geração NF','Atualizou Taxa Moeda - P.E. M410PVNF',SC6->C6_ITEM,cAltera)

	        		endif

	        	Endif
	        Endif
            SC6->(dbSkip())
        enddo
    endif

    aEval(aAreas, {|aArea|restArea(aArea)})
    aSize(aAreas,0)
    
return lRet
