#include "Protheus.ch"

user function mt415brw()
	Local cFiltro := "CJ_NUM == 'XYXYXY'"

	public lVen  := .f.
	public lGer  := .f.
	public lDir  := .f.

	cFiltro := u_gta005("CJ_ZZVEN",cFiltro)	//Faz filtro em orçamentos e pedidos conforme regras Glasstech

return cFiltro
