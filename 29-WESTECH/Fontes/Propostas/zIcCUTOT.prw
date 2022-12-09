#Include 'Protheus.ch'

User Function zIcCUTOT()

	Local aAreaSZF    	:= SZF->( GetArea() )
	Local cNProp 		:= ALLTRIM(M->CTD_NPROP)
	Local cItemC		:= ALLTRIM(M->CTD_ITEM)
	Local _nTotCUTOT		:= 0

	dbSelectArea("SZF")
	SZF->(dbSetOrder(2) )
	SZF->( dbGoTop() )
	

	//If SZF->( dbSeek(xFilial("SZF")+cNProp) )

	    While SZF->( ! EOF() ) 	
	    	if ALLTRIM(SZF->ZF_NPROP) == cNProp  .AND. ALLTRIM(SZF->ZF_ITEMIC)  == cItemC
	    		_nTotCUTOT += SZF->ZF_TOTAL + SZF->ZF_VLRCONT + SZF->ZF_VLRCOM + SZF->ZF_VLRROY + SZF->ZF_VLROCUS
	    	endif
			SZF->( dbSkip() )

	    EndDo

	//EndIf

	RestArea(aAreaSZF)

Return _nTotCUTOT

