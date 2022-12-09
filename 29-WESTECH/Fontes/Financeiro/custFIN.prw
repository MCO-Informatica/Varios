#Include 'Protheus.ch'

User Function custFIN()
	Local _cRetorno 
	
	Local nXII, nXIPI, nXCOFINS, nXPIS, nXICMS, nXSISCO, nXSDA, nXTERM, nXTRANSP, nXFRETE, nXFUMIG, nXARMAZ, nXAFRMM, nXMALO, nXCAPA, nXCOMIS, nXISS, nXIRRF, nVLRREA, nXCUTII 
	Local cXII, cXIPI, cXCOFINS, cXPIS, cXICMS, cXSISCO, cXSDA, cXTERM, cXTRANSP, cXFRETE, cXFUMIG, cXARMAZ, cXAFRMM, cXMALO, cXCAPA, cXCOMIS, cXISS, cXIRRF 
	
	nVLRREA := M->E2_VALOR
	
	
	cXII := M->E2_XCTII
	if cXII = "1"
		nXII := M->E2_XII
	else
		nXII := 0
	end if
	
	cXIPI := M->E2_XCTIPI
	if cXIPI = "1"
		nXIPI := M->E2_XIPI
	else
		nXIPI := 0
	end if
	
	cXCOFINS := M->E2_XCTCOF
	if cXCOFINS = "1"
		nXCOFINS := M->E2_XCOFINS
	else
		nXCOFINS := 0
	end if
	
	cXPIS := M->E2_XCTPIS
	if cXPIS = "1"
		nXPIS := M->E2_XPIS
	else
		nXPIS := 0
	end if
	
	cXICMS := M->E2_XCTICMS
	if cXICMS = "1"
		nXICMS := M->E2_XICMS
	else
		nXICMS := 0
	end if
	
	cXSISCO := M->E2_XCTSISC
	if cXSISCO = "1"
		nXSISCO := M->E2_XSISCO
	else
		nXSISCO := 0
	end if
	
	cXSDA := M->E2_XCTSDA
	if cXSDA = "1"
		nXSDA := M->E2_XSDA
	else
		nXSDA := 0
	end if
	
	cXTERM := M->E2_XCTTEM
	if cXTERM = "1"
		nXTERM := M->E2_XTERM
	else
		nXTERM := 0
	end if
	
	cXTRANSP := M->E2_XCTTRAN
	if cXTRANSP = "1"
		nXTRANSP := M->E2_XTRANSP
	else
		nXTRANSP := 0
	end if
	
	cXFRETE := M->E2_XCTFRET
	if cXFRETE = "1"
		nXFRETE := M->E2_XFRETE
	else
		nXFRETE := 0
	end if
	
	cXFUMIG := M->E2_XCTFUM
	if cXFUMIG = "1"
		nXFUMIG := M->E2_XFUMIG
	else
		nXFUMIG := 0
	end if
	
	cXARMAZ := M->E2_XCTARM
	if cXARMAZ = "1"
		nXARMAZ := M->E2_XARMAZ
	else
		nXARMAZ := 0
	end if
	
	cXAFRMM := M->E2_XCTAFRM
	if cXAFRMM = "1"
		nXAFRMM := M->E2_XAFRMM
	else
		nXAFRMM := 0
	end if
	
	cXMALO := M->E2_XCTMALO
	if cXMALO = "1"
		nXMALO := M->E2_XMALO
	else
		nXMALO := 0
	end if
	
	cXCAPA := M->E2_XCTCAPA
	if cXCAPA = "1"
		nXCAPA := M->E2_XCAPA
	else
		nXCAPA := 0
	end if
	
	cXCOMIS := M->E2_XCTCOM
	if cXCOMIS = "1"
		nXCOMIS := M->E2_XCOMIS
	else
		nXCOMIS := 0
	end if
	
	cXISS := M->E2_XCTISS
	if cXISS = "1"
		nXISS := M->E2_XISS
	else
		nXISS := 0
	end if
	
	cXIRRF := M->E2_XCTIRRF
	if cXIRRF = "1"
		nXIRRF := M->E2_XIRRF
	else
		nXIRRF := 0
	end if
	
	_cRetorno := nVLRREA - (nXII + nXIPI + nXCOFINS + nXPIS + nXICMS + nXSISCO + nXSDA + nXTERM + nXTRANSP + nXFRETE + nXFUMIG + nXARMAZ + nXAFRMM + nXMALO + nXCAPA + nXCOMIS + nXISS + nXIRRF)  
	

	
Return ( _cRetorno )

