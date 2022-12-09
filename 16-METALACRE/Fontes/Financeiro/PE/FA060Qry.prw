#include "rwmake.ch"

User Function FA060Qry()
Local cPerg	:="060QRY"
Local cRet := Nil

ValidPerg(cPerg)
If !Pergunte(cPerg)
	MsgAlert("Pergunta não Cadastrada")
	Return
EndIf

// Expressao SQL de filtro que sera adicionada a clausula WHERE da Query.
IF !Empty(MV_PAR01) .Or. !Empty(MV_PAR02)
	cRet := " E1_NATUREZ BETWEEN '"+MV_PAR01+"' AND '" + MV_PAR02 + "' "
EndIf
Return cRet 

Static Function ValidPerg(cPerg)
Local nTamNatur:= TamSx3("E1_NATUREZ")[1]

PutSx1( cPerg , "01", "Da Natureza","Naturaleza","From Class",;
				"MV_CH0","C",nTamNatur,0,0,"G","","SED","","","MV_PAR01","","","","","","","",;
				"","","","","","","","","")

PutSx1( cPerg , "02", "Ate Natureza","Naturaleza","From Class",;
				"MV_CH1","C",nTamNatur,0,0,"G","","SED","","","MV_PAR02","","","","","","","",;
				"","","","","","","","","")
Return .t.