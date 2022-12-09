/*/{Protheus.doc} User Function MA030BRW
    (Ponto de entrada para filtro de cliente por vendedor)
    @type  Function
    @author Thiago Souza
    @since 15/12/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MA030BRW()
Local cFiltro	:= Nil
Local cVend 	:= ""
Local cClient 	:= ""
Local aArea     := GetArea()

dbselectarea("SA3")
dbsetorder(1)

SA3->(DBGotop())

Do While !SA3->(Eof())

	If Alltrim(__cUserID) == Alltrim(SA3->A3_CODUSR)
		cVend 	:= SA3->A3_COD
        cFiltro := "A1_VEND == '"+cVend+"' "
		Exit
	Endif

	SA3->(DBSkip())

EndDo

RestArea(aArea)

return cFiltro
