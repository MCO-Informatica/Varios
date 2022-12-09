#INCLUDE "PROTHEUS.CH"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACERTOB9  ºAutor  ³Microsiga           º Data ³  05/16/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACERTGRP()
Processa({||xrocessa()})
MSGSTOP ("FIM")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROCESSA  ºAutor  ³Microsiga           º Data ³  05/16/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xrocessa()
cquery := ""

cquery := "SELECT B1_COD,R_E_C_N_O_ REG "
cquery += " FROM SB1010 B1 "
cquery += " WHERE B1_GRUPO IN ('VE','Y-','VB') AND B1.D_E_L_E_T_ = '' "
cquery += " ORDER BY 1 "

TCQUERY CQUERY NEW ALIAS "MOX"

Dbselectarea("MOX")
DBGOTOP()
WHILE !EOF()
      _CPROD := MOX->B1_COD
      _CREGI := MOX->REG
      _ANFEN := ACHNFE(_CPROD)
      
      // AJUSTA O PRODUTO
      IF LEN(_ANFEN) > 0
	      DBSELECTAREA("SB1")
    	  DBGOTO(_CREGI)
    	  RECLOCK("SB1",.F.)
    	   SB1->B1_UPRC := _ANFEN[2]
    	   SB1->B1_UCOM := STOD(_ANFEN[1])
    	  MSUNLOCK("SB1")
      ENDIF      
      
      Dbselectarea("MOX")      
      DBSKIP()
      LOOP
END

Return

                
STATIC FUNCTION ACHNFE(_PROD)
_ARETNF := {}
_CQUERR := ""
_CQUERR := "SELECT TOP 1 D1_EMISSAO,D1_COD,D1_VUNIT"
_CQUERR += " FROM SD1010 D1"
_CQUERR += " INNER JOIN SF4010 F4 ON F4_FILIAL = D1_FILIAL AND F4_CODIGO = D1_TES AND F4.D_E_L_E_T_ = ''"
_CQUERR += " WHERE D1.D_E_L_E_T_ = ''  AND D1_COD = '" + _PROD + "'"
_CQUERR += " ORDER BY 2,1 DESC "

TCQUERY _CQUERR NEW ALIAS "NFEV"

DBSELECTAREA("NFEV")
If EOF()
    _ARETNF := {}
   NFEV->(DBCLOSEAREA())
ELSE
   _ARETNF := {NFEV->D1_EMISSAO,NFEV->D1_VUNIT}
   NFEV->(DBCLOSEAREA())
Endif
RETURN(_ARETNF)
