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
    
User Function FSFILCPSA1()
Local cVend :=RetVend()
Local cRet  :=  "@#.T.@#"


//Alert("Vendedor"+cVend)
//Alert("Vend Cliente"+SA1->A1_VEND)

If !Empty(cVend)
    cRet := "@# A1_VEND == '"+cVend+"' @#"
Endif

return cRet



Static Function RetVend()
Local cVend :=""

dbselectarea("SA3")
dbsetorder(1)

SA3->(DBGotop())

Do While !SA3->(Eof())

	If Alltrim(__cUserID) == Alltrim(SA3->A3_CODUSR)
		cVend := SA3->A3_COD
	Endif

	SA3->(DBSkip())

EndDo

return cVend


   
Return return_var
