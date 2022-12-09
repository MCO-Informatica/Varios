#include "Protheus.ch"

User Function filtroTrans()
	Local cFiltro := "@#sa4->a4_cod $ '"

	sz2->(DbSetOrder(1))
	sz2->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
	while !sz2->(eof()) .and. m->cj_cliente == sz2->z2_codcli .and. m->cj_loja == sz2->z2_lojcli
		if sz2->z2_tipo == "T"
			cFiltro += alltrim(sz2->z2_codigo)+"|"
		endif
		sz2->(dbskip())
	end
	cFiltro += "'@#"

return cFiltro
