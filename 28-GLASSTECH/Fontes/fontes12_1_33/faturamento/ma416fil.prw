#Include "Protheus.ch"

User Function ma416fil()
	Local cFiltro := "CJ_NUM == 'XYXYXY'"

	public lVen  := .f.
	public lGer  := .f.
	public lDir  := .f.

	cFiltro := u_gta005("CJ_ZZVEN",cFiltro)	//Faz filtro em or�amentos e pedidos conforme regras Glasstech

return cFiltro
