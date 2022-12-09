#INCLUDE "PROTHEUS.CH"  	


User Function EICDI158()

Local cParam:= ""

Local xRet := .T.
Local uData :=  &(Readvar())
local cCampo := Subs(READVAR(),4)
Private cValid := ""

IF Type("ParamIXB") == "C"
	cParam:= PARAMIXB
Elseif Type("ParamIXB") == "A"
	cParam:= PARAMIXB[1]
Endif

if cParam ==  "DI158_NFVAL_FIM"
 
    If cCampo == "cNF_NFD"
		If len(alltrim(cNF_NFD)) < 9
			Alert("Numero de nota informado incorreto")
			xRet:= .F.
	   	Endif  	
	Endif    

Endif
Return xRet

