#Include 'Protheus.ch'

User Function zIcVDSI()

	Local aAreaSZF    	:= SZF->( GetArea() )
	Local cNProp 		:= ALLTRIM(M->CTD_NPROP)
	Local cItemC		:= ALLTRIM(M->CTD_ITEM)
	Local _nVDSI		:= 0

	dbSelectArea("SZF")
	SZF->(dbSetOrder(2) )
	SZF->( dbGoTop() )

	//If SZF->( dbSeek(xFilial("SZF")+cNProp) )

	    While SZF->( ! EOF() ) 		
	    	if ALLTRIM(SZF->ZF_NPROP) == cNProp  .AND. ALLTRIM(SZF->ZF_ITEMIC)  == cItemC
	    		_nVDSI += SZF->ZF_TOTVSI
	    	endif
			SZF->( dbSkip() )

	    EndDo

	//EndIf

	RestArea(aAreaSZF)

Return _nVDSI

