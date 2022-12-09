#include "rwmake.ch"     

User function Rescisao()


Local cCaixinha:= SRA->RA_XCAIXIN
Local cChaves := SRA->RA_XCHAVE


IF cCaixinha == "S"

	Aviso("Atenção","Esse Funcionario possui  C A I X I N H A ! ",{'Ok'})
EndIf
	
If cChaves == "S"

		Aviso("Atenção"," Esse Funcionario possui  C H A V E S ! ",{'Ok'})
	
EndIf	

Return()

