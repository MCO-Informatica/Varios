/*/{Protheus.doc} User Function FILVEND
    (long_description)
    @type  Function
    @author THIAGO SOUZA
    @since 24/11/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FILVEND()
Local cVend :=""

dbselectarea("SA3")
dbsetorder(1)

SA3->(DBGotop())

Do While !SA3->(Eof())

	If __cUserID == SA3->A3_CODUSR
		cVend := SA3->A3_COD
	Endif

	SA3->(DBSkip())

EndDo

return cVend






    
Return return_var
