#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT110GRV
//LOCALIZAÇÃO : Function A110GRAVA - Função da Solicitação de Compras responsavel pela 
                gravação das SCs.
EM QUE PONTO : No laco de gravação dos itens da SC na função A110GRAVA, executado após
               gravar o item da SC, a cada item gravado da SC o ponto é executado.
@author marcio.katsumata
@since 19/03/2020
@version 1.0
@return nil, nil
@see http://tdn.totvs.com/display/public/PROT/MT110GRV
/*/
user function MT110GRV()
	local aArea := getArea()
	
	//Grava o conteúdo do campo C1_XURGENT
	recLock("SC1", .F.)
	SC1->C1_PRECO   := SC1->C1_XPRECO
	SC1->C1_TOTAL   := SC1->C1_XTOTAL
	SC1->C1_CONDPAG := u_getCondicaoPagamentoEic(.T.,SC1->C1_XCONPAG)
	SC1->C1_MOEDA   := SC1->C1_XMOEDA
	SC1->(msUnlock())
	
	restArea(aArea)

	if type("cForn110") == 'C'
		cForn110    := ""
    	cLoj110     := ""
    	cCodTb110   := ""
    	lImport110  := .F.
    	cVia110     := ""
    	cInco110    := ""
	endif

	
return