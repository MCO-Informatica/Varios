#INCLUDE "PROTHEUS.CH"
User Function AT010SN1() 
Local aCposSN1 := paramixb [1] 
AAdd(aCposSN1,"N1_STATUS")
AAdd(aCposSN1,"N1_PATRIM")
AAdd(aCposSN1,"N1_ESTUSO")
AAdd(aCposSN1,"N1_ART32")
AAdd(aCposSN1,"N1_DISTGRP") 
AAdd(aCposSN1,"N1_VLAQUIS") 
//Alert ("Seguem os campos habilitado para atualização: N1_STATUS, N1_PATRIM, N1_ESTUSO, N1_ART32, N1_DISTGRP, N1_VLAQUIS") 
Return aCposSN1