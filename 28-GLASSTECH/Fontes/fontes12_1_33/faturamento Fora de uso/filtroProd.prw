#include "Protheus.ch"

User Function filtroProd()
	Local cFiltro := "@#sb1->b1_cod $ '"
	Local cQuery  := ""

	cQuery := "select da1_codpro from "+retsqlname("DA1")+" where da1_filial = '"+xfilial("DA1")+"' "
	cQuery += "and da1_codtab = '"+m->cj_tabela+"' and d_e_l_e_t_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"trb",.F.,.T.)
	while !trb->(eof())
		cFiltro += alltrim(trb->da1_codpro)+"|"
		trb->(dbskip())
	end
	trb->(dbclosearea())
	cFiltro += "'@#"

return cFiltro
