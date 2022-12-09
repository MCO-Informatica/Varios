/*/{Protheus.doc} User Function MT120GOK
    (long_description)
    @type  Function
    @author user
    @since 11/05/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MT120GOK()

If Inclui .or. Altera
	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial("SC7") + ca120num)
	While SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + ca120num .And. !SC7->(Eof())
		Reclock("SC7",.F.)
		    SC7->C7_XNOMFOR	:= 	Posicione("SA2", 1, xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA), "A2_NREDUZ")
		SC7->( MSUnlock() )

		SC7->( DbSkip() )
	EndDo
Endif   

Return
