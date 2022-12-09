#include "PROTHEUS.CH"

USER FUNCTION FVLDNAT(cLpOri)

Local lret:=.F.     

//Trata nataureza no processo de inclusão
If cLpOri=='500' 
   If SE1->E1_TIPO=='NCC' .and. SC6->(DbSeek(xFilial("SC6")+ALLTRIM(SE1->E1_NUM)))
      If  SC6->C6_XOPER $ ("61/62")
      	lret:=.T.
	  Endif	  
   Endif
Endif
               


Return lret

