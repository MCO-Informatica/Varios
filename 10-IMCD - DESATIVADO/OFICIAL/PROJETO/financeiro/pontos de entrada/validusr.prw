#include "PROTHEUS.CH" 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidUser ºAutor  ³  Sandra Nishida    º Data ³  12/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Quebra galho                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ValidUsr()
	local aArea as array
	local lRetVld as logical
	local cUserLC1 as character
	local cUserLC2 as character
	local cUserLC3 as character
	local nVlrLimite as numeric

	aArea := GetArea()               
	lRetVld   := .t.                   
	cUserLC1    := GetMv("FS_LC01") //ATE 10 MIL   
	cUserLC2    := GetMv("FS_LC02") //ATE 30 MIL    
	cUserLC3    := GetMv("FS_LC03") //ACIMA DE 30 MIL     

	nVlrLimite 	:= 0   

	If __cUserId $ cUserLC1
		nVlrLimite := 10000.00
	Endif

	If __cUserId $ cUserLC2
		nVlrLimite := 30000.00
	Endif

	If __cUserId $ cUserLC3
		nVlrLimite := 999999999.99
	Endif


	IF M->A1_LC <= nVlrLimite 
		lRetVld := .T.
	Else
		Aviso("ValidUsr","Atenção o usuario :  " + substr(cUserName,1,15) + " nao esta autorizado a liberar credito maior que U$ " + transform(nVlrLimite, "@E 999,999,999.99")  ,{"Ok"},2)                               
		lRetVld := .F.
	Endif      

	RestArea(aArea)
	aSize(aArea,0)

Return lRetVld