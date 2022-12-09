#Include 'Protheus.ch'

User Function ValidaHRS_SZ4()
	local nQTDHRS
	 
	/*
	IF  EMPTY(M->Z3_HRINI)
		msgAlert ( "Informe Hora Inicial corretamente." )
		M->Z3_HRINI := 0
		nQTDHRS := 0
		
	ELSEIF  EMPTY(M->Z3_HRFIN)
		msgAlert ( "Informe Hora Final corretamente." )
		M->Z3_HRFIN := 0
		nQTDHRS := 0
	*/	 
	IF M->Z4_HRFIN < M->Z4_HRINI
		nQTDHRS := 0
		  
	ELSEIF M->Z4_HRINI < M->Z4_HRFIN
		nQTDHRS := M->Z4_HRFIN - M->Z4_HRINI
		
	ENDIF  
	
Return nQTDHRS



