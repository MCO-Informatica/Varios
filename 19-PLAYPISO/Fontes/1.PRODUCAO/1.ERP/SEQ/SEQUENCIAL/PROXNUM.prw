#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "FONT.ch"
#Include "COLORS.ch"
#include "TCBROWSE.CH"


user function ProxNum()
local cali := alias()

//do case
//case calias =='AF1'
U_NumAF1(cali)
//CASE Calias <>'AF1'//
//alert('alias diferente de AF1')
//ENDCASE
//RETURN

//Neste exemplo, determinamos qual área de trabalho está atualmente em uso.
//cAlias := alias() IF empty(cAlias)   alert('Não há área em uso')Else   alert('Área em uso atual : '+cAlias)Endif

STATIC FUNCTION NumAF1()     


 LOCAL CNUM :=""
local cQuery :=""
local QRYF1:=""
 
cQuery :="select MAX(AF1_ORCAME) AS CODIGO SELECT* from "+RETSQLNAME("AF1")+"  "
cQuery :="WHERE D_E_L_E_T_<>'*'     "

QRYF1 := GetNextAlias ()       

dbusearea(.T.,'topconn',tcgenqry(,,cQuery),QRYF1,.F.,.T.)    

DBSELECTAREA(QRYF1)     
IF(QRYF1) ->(EOF()) .AND. (QRYF1) ->(BOF())    
CNUM := STRZERO(1,6) 
ELSE
CNUM := SOMA1((QRYF1) ->CODIGO)
ENDIF


if select(QRYF1)     >0
dbselectarea(QRYF1)
dbclosearea(QRYF1)
endif
            
RETURN CNUM