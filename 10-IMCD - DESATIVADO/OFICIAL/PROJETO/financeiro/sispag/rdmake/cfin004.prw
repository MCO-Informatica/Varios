#Include "Protheus.ch" 

User Function FA740BRW()                          

	Local aR := {{"Posição do Cliente","U_CFIN004",0,2,0,NIL}}
	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "FA740BRW" , __cUserID )
Return(aR)

User FUNCTION CFIN004()	 

	Local nPosArotina := 0 

	Finc010(nPosArotina)

Return()    



