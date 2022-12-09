#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


/* **************************************************************************
***Programa  *AFAT011   * Autor * Eneovaldo Roveri Jr.  * Data *01/12/2009***
*****************************************************************************
***Locacao   * Fabr.Tradicional *Contato *                                ***
*****************************************************************************
***Descricao * Validação dos campos de valor unitário do pedido e orcamento**
*****************************************************************************
***Parametros* _cProduto  - Código do produto                             ***
***          * _nPrcVen   - Preço unitário digitado                       ***
***          * _cTabela   - Tabela de preço do pedido                     ***
*****************************************************************************
***Analista Resp.*  Data  * Bops * Manutencao Efetuada                    ***
*****************************************************************************
***              *  /  /  *      *                                        ***
***              *  /  /  *      *                                        ***
************************************************************************** */


User Function AFAT011( _cCampoPro, _nPrcVen, _cTabela, _cCampoMoe )
	Local _aArea    := GetArea()
	Local _lRet     := .T.
	Local _nPProd   := 0
	Local _cProduto := ""
	Local _nPMoeda  := 0
	Local _nMoeda   := 0
	Local _nPrcMin  := 0
	Local _nPUM     := 0
	Local _cUm      := ""

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "AFAT011" , __cUserID )

	if substr( _cCampoPro, 1, 2 ) == "UB"
		_nPUM  := aScan(aHeader,{ |x| Alltrim(x[2])=="UB_UM"})
		If _nPUM > 0
			_cUm := aCols[n][_nPUM]
		endif
	else
		_nPUM  := aScan(aHeader,{ |x| Alltrim(x[2])=="C6_UM"})
		If _nPUM > 0
			_cUm := aCols[n][_nPUM]
		endif
	endif

	_nPProd  := aScan(aHeader,{ |x| Alltrim(x[2])==_cCampoPro})          
	If _nPProd > 0
		_cProduto := aCols[n][_nPProd]
	endif

	_nPMoeda := aScan(aHeader,{ |x| Alltrim(x[2])==_cCampoMoe})
	If _nPMoeda > 0
		_nMoeda := aCols[n][_nPMoeda]
	endif


	DbSelectArea( "DA1" )
	dbSetorder( 2 )

	if DA1->( dbSeek( xFilial( "DA1" ) + _cProduto + _cTabela ) ) .and. _nMoeda == DA1->DA1_MOEDA

		_nPrcMin := DA1->DA1_VMMIN
		_nPrcMin := U_Conv2Um( _cUm, _nPrcMin, _cProduto )
		if Round(_nPrcVen,2) < NoRound(_nPrcMin,2)
			MSGBOX("O Preço informado está abaixo do preço mínimo especificado na tabela de preços", "Erro", "ALERT")
			_lRet := .T.
		endif

	endif

	RestArea(_aArea)
Return( _lRet )

/*
*/
