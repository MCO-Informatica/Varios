#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MKEDICAO บ Autor ณ Giane - ADV Brasil บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para editar ou nao os campos do item do orcamento,  บฑฑ
ฑฑบ          ณ caso o item esteja rejeitado ou com pedido de venda        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico MAKENI / orcamento                              บฑฑ
ฑฑบ          ณ chamada de todos os campos (modo de edicao) tabela SUB     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MKEDICAO(cTipo)
	Local _lRet := .f.   
	Local nPRejei	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "UB_XREJEIT"})       // Pega a posicao do campo rejeitado no aHeader
	Local nPPedido	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "UB_XNUMPED"})         // Pega a posicao do campo numero do pedido gerado no aHeader
	Local nPMoeda	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "UB_XMOEDA"})         // Pega a posicao do campo moeda  no aHeader                            

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MKEDICAO" , __cUserID )

	if cTipo == Nil
		cTipo := ""
	Endif

	if cTipo == 'M1'.or. cTipo == 'M2'
		//FUNCAO FOI CHAMADA DO PEDIDO de vendas  SC6
		nPMoeda	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XMOEDA"})         

		if cTipo == 'M1' //campo C6_XPRCMOE deve ficar somente visualizar para moeda em R$
			if aCols[N,nPmoeda] == 2 .or. aCols[N,nPmoeda] == 4                                // EURO introduzido em 14/09/11 by Daniel
				_lRet := .t.
			endif
		else  //campo C6_PRCVEN deve ficar somente visualizar para moeda em dolar.
			if aCols[N,nPmoeda] == 1
				_lRet := .t.
			endif
		endif

	endif


	//daqui pra baixo, foi chamada de campos do SUB, itens do orcamento callcenter
	if cTipo == "" //Nil

		If aCols[N,nPRejei] != '1' .and. EMPTY(aCols[N,nPPedido])   
			_lRet := .t.
		endif

	elseif cTipo == "R" //condicao de edicao para o campo UB_XREJEIT
		If EMPTY(aCols[N,nPPedido])
			_lRet := .t.
		endif

	elseif cTipo == "M" //condicao de edicao para o campo UB_XMOTREJ e UB_XCOMREJ
		If aCols[N,nPRejei] == '1'                                                                     
			_lRet := .t.
		endif
	elseif cTipo == "P" //so habilita para edicao o campo UB_XPRCMOE, caso moeda seja = 2   
		If (aCols[N,nPRejei] != '1') .and. (EMPTY(aCols[N,nPPedido])) .and. (aCols[N,nPMoeda] == 2 .OR. aCols[N,nPMoeda] == 4)  // EURO introduzido em 14/09/11 by Daniel
			_lRet := .t.
		endif
	elseif cTipo == "V" //so habilita para edicao o campo UB_VRUNIT, caso moeda seja = 1
		If (aCols[N,nPRejei] != '1') .and. (EMPTY(aCols[N,nPPedido])) .and. aCols[N,nPMoeda] == 1
			_lRet := .t.
		endif      
	endif

Return _lRet 
