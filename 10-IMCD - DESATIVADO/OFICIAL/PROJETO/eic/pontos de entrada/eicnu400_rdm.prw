#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"

User Function EICNU400

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "EICNU400" , __cUserID )

	Do Case
		Case paramixb == "INICIA_VARIAVEIS"
		cNivel:=9
	EndCase

Return .t.