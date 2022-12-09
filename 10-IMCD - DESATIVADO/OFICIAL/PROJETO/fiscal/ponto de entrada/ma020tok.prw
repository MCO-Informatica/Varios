#INCLUDE 'PROTHEUS.CH'

User Function MA020TOK()
Local lExecuta := .T.
local aFields as array
local cFields as character
local oImcdLog as object
local nIndFld as numeric
local nFields as numeric

IF cEmpAnt == '04'
	Return (lExecuta)
Endif

IF cEmpAnt == '02'
	dbselectarea("CTD")
	dbsetorder(1)
	dbgotop()
	dbseek("  " + ("F" + M->A2_COD + M->A2_LOJA) )
	
	IF Empty(CTD->CTD_ITEM)
		RECLOCK("CTD",.T.)
		CTD->CTD_FILIAL := "  "
		CTD->CTD_ITEM := "F" + M->A2_COD + M->A2_LOJA
		CTD->CTD_CLASSE := "2"
		CTD->CTD_NORMAL := "0"
		CTD->CTD_DESC01 := M->A2_NOME
		CTD->CTD_BLOQ := "2"
		CTD->CTD_DTEXIS := date()
		CTD->CTD_ITLP := "F" + M->A2_COD + M->A2_LOJA
		CTD->CTD_CLOBRG := "2"
		CTD->CTD_ACCLVL := "1"
		
		MSUNLOCK()
		
		Alert("Item Contabil Criado -> " + "F" + M->A2_COD + M->A2_LOJA )
	endif
	
	CTD->(dbclosearea())
Endif


if Altera
	
	cFields := superGetMv("ES_AUDFL2A", .F., "/") + superGetMv("ES_AUDFL2B", .F., "/") 
    aFields := strTokArr2(cFields,"/", .F.)
    oImcdLog := ImcdLogAudit():new()
	nFields := len(aFields)

	for nIndFld := 1 to nFields
    	if M->&(aFields[nIndFld]) <> SA2->&(aFields[nIndFld])
        	oImcdLog:recordLog("SA2",1,SA2->(A2_FILIAL+A2_COD+A2_LOJA),aFields[nIndFld] ,SA2->&(aFields[nIndFld]),M->&(aFields[nIndFld]))
   		endif
	next nIndFld

    aSize(aFields,0)

endif

Return (lExecuta)
