User Function filda1()

	dbselectarea("Z05")
    dbsetorder(1) 

        AxCadastro("Z05","Gestor x Centro de Custo - Alertas")

        cFiltro	:= "ADL->ADL_FILIAL == '"+xFilial("ADL")+"' .AND. ADL->ADL_VEND $ '"+cVendorList+"'"
		
		DbSelectArea("ADL")
		Set Filter to &cFiltro

Return