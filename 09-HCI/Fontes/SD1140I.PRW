#Include "rwmake.ch"
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD1100I  ºAutor  ³ ROBSON BUENO       º Data ³  20/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ BAIXANDO A COMPRA CASADA                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SD1140I()
Local lOk := .T.
 lok := U_SD1140BX(.T.)
 lok := U_SD1140RI(.T.)
Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD1100BX ºAutor  ³ ROBSON BUENO       º Data ³  20/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ BAIXANDO OC X PI CASADO                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION SD1140BX(lOkOP)
local cProcura
Local aArea      := (GetArea())  
LOCAL nSaldo	 :=0	
Local cTabela:="OC"
dbSelectArea("SZK")
DbSetOrder(9)
IF SD1->D1_OP<>"             " 
  cTabela:="OS"  
Endif
MsSeek(xFilial("SZK")+cTabela+SD1->D1_PEDIDO+SUBSTR(SD1->D1_ITEMPC,2,3))
IF !EOF()
  nSaldo:=SD1->D1_QUANT
ENDIF
DO WHILE (!Eof() .And. SCK->CK_FILIAL == xFilial("SZK") .And.	SZK->ZK_OC==SD1->D1_PEDIDO .AND. SZK->ZK_ITEM=SUBSTR(SD1->D1_ITEMPC,2,3) .AND. SZK->ZK_TIPO2=cTabela)
     Reclock("SZK",.F.)
     IF SZK->ZK_QTS>0 .AND. nsaldo>0
       IF SZK->ZK_QTS<=nSaldo
         nSaldo:=nSaldo-SZK->ZK_QTS
         SZK->ZK_QTS:=0
         SZK->ZK_STATUS:="4"
         SZK->ZK_DT_BX=SD1->D1_DTDIGIT
       else
         SZK->ZK_QTS:=SZK->ZK_QTS-nSaldo
         SZK->ZK_STATUS:="2"
         nSaldo:=0
       endif
     ENDIF
     MsUnLock()
     dbSkip()
EndDo
RestArea(aArea)
Return lOkOP     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD1100RI ºAutor  ³ ROBSON BUENO       º Data ³  20/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alterando Status de Ri Para Recebido                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION SD1140RI(lOkOP)
local cProcura
Local aArea      := (GetArea())  
Local cTabela:="OC"
dbSelectArea("SZI")
DbSetOrder(1)
FOR X=1 TO LEN(ACOLS)
    IF aCOLS[X,Len(aHeader)+1]
      MsSeek(xFilial("SZI")+ACOLS[x,9])
      IF !EOF()
        RecLock("SZI",.F.)
        IF SZI->ZI_STATUS="N" 
          SZI->ZI_DTR    :=CTOD("  /  /  ")
          SZI->ZI_USUR   :=""   
        ELSE
          SZI->ZI_STATUS :="I" 
          SZI->ZI_DTR    :=CTOD("  /  /  ")
          SZI->ZI_USUR   :=""   
        ENDIF
        MsUnLock()   
      ENDIF  
    ENDIF
NEXT   
MsSeek(xFilial("SZI")+SD1->D1_LOTEHCI)
IF !EOF()
      RecLock("SZI",.F.)
      IF SZI->ZI_STATUS="N"
        SZI->ZI_DTR    :=DATE()
        SZI->ZI_USUR   :=Substr(cUsuario,7,15)
      ELSE
        SZI->ZI_STATUS :="R"
        SZI->ZI_DTR    :=DATE()
        SZI->ZI_USUR   :=Substr(cUsuario,7,15)
      ENDIF  
      MsUnLock()   
ENDIF
RestArea(aArea)
Return lOkOP     
