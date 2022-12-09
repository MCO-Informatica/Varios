#INCLUDE "PROTHEUS.CH"


User Function EICPSI01()

Local cParam:= ""

Local xRet := .T.
Local uData :=  &(Readvar())
local cCampo := Subs(READVAR(),4)
Local xRet := .T.

IF Type("ParamIXB") == "C"
	cParam:= PARAMIXB
Else
	cParam:= PARAMIXB[1]
Endif

IF cEMPANT == '02'
	if cParam == "9"

		If cCampo $ "W1_FABR / W1_FABLOJ / W1_FORN / W1_FORLOJ"
		
			If cCampo ==  "W1_FABR"
				cFabr :=   "M->W1_FABR"
			Else
				cFabr :=   "TRB->W1_FABR"
			Endif		
			if  cCampo ==  "W1_FABLOJ"
				cFabloj :=   "M->W1_FABLOJ"
				cTabfab := "M"
			Else
				cFabloj :=   "TRB->W1_FABLOJ"
				cTabfab := "TRB"
			Endif		
			if  cCampo ==  "W1_FORN"
				cForn :=   "M->W1_FORN"
			Else
				cForn :=   "TRB->W1_FORN"
			Endif				
			if  cCampo ==  "W1_FORLOJ"
				cForloj :=   "M->W1_FORLOJ"
				cTabfor := "M"
			Else
				cForloj :=   "TRB->W1_FORLOJ"
				cTabfor := "TRB"
			Endif		
		
			If !Empty(&cFabr) .and.  !Empty(&cFabLoj) .and.  !Empty(&cForn) .and.  !Empty(&cForLoj) .and.  !Empty(TRB->W1_COD_I)
				SA5->(DBSetOrder(1))
				If SA5->(DBSeek(xFilial()+AvKey(&cForn,"W1_FORN")+EICRetLoja(cTabFor,"W1_FORLOJ")+TRB->W1_COD_I+AvKey(&cFabr,"W1_FABR")+EICRetLoja(cTabFab, "W1_FABLOJ")))
			   		If SA5->A5_XBLOQ == "1" //sim
				   		Alert("Registro bloqueado para uso. Falta liberação da área responsável")
				   		xRet := .F.
			   		Endif						        
		       Endif	       
		   Endif
		Endif

	Endif
Endif
Return xRet 

