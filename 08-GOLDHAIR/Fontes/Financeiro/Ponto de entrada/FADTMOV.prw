#INCLUDE "Protheus.ch"

USER FUNCTION FADTMOV()

   Local dData := ParamIxb[ 1 ] //Data informada pela fun��o DtMovFin
   Local lRet := .T.
/*
   If MsgYesNo("Est� utilizando a data base " + DTOC(dData) + ", deseja continuar?") 
      lRet := .T. 
   Else 
      lRet := .F. 
   EndIF
*/
RETURN lRet