#include "totvs.ch"

/*/{Protheus.doc} xRelat
@EXTRUSION
Gatilho - Numeração Automática Pedido de Venda
@author Rickson Oliveira
@since 29/09/2019
/*/

User Function APCPG001()

Local aSaveArea := GetArea()
Local cRet   := ""
Local cQuery := ""
Local cNum   := ""
Local ctipo := AllTrim(M->C5_XTIPO)
cMsg := ""

if Empty(AllTrim(M->C5_XTIPO)) 
   Return(cRet)
endif

cQuery  :=  "      Select ISNULL(Max(C5_NUM), ' ')  AS NUM  FROM SC5010 "
cQuery  +=  "      WHERE D_E_L_E_T_ = ' '                               "
cQuery  +=  "      and SUBSTRING(C5_NUM,1,1) = '"+cTipo+"'"
cQuery  +=  "      and SUBSTRING(C5_NUM,2,1) not in ('A', 'T','L','R')                  "


   dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBTMPX", .F., .T.)
	dbSelectArea( "TRBTMPX" )
      iF Empty(NUM)
         cRet := M->C5_XTIPO + "00001"     
      Else
         cNum := Soma1(substr(num,2,6))
         cRet :=  M->C5_XTIPO + cNum
      EndIf
  
    DbCloseArea()

RestArea(aSaveArea)
                       
Return(cRet)   
