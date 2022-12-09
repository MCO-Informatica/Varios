#include "rwmake.ch"
 
//Validação de usuário para definir almoxarifado para os produtos SPIDER

User Function Localspider()

cRet := ""

If LEFT(M->B1_COD,2)=="S0"
	cRet := PERTENCE(GETMV("MV_ALMS0"))
ElseIf LEFT(M->B1_COD,3)=="SPI"
	cRet := PERTENCE(GETMV("MV_ALMSPI"))
EndIf

Return cRet	
