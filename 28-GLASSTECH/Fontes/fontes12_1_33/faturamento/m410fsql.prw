#Include "Protheus.ch"

User Function m410fsql()
	Local cFiltro := "C5_NUM == 'XYXYXY'"

	public lVen  := .f.
	public lGer  := .f.
	public lDir  := .f.

	cFiltro := u_gta005("C5_VEND1",cFiltro)	//Faz filtro em orçamentos e pedidos conforme regras Glasstech

return cFiltro
