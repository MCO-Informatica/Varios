#include "rwmake.ch"

// Vanderlei A Ferreira 10/11/05

User Function Lincnat()

_cCampo := " "

If xFilial("SF2") =="01"

	If sd2->d2_tes $ "501/502"
		_cCampo := "11000102"
	ElseIf sd2->d2_tes $ "504/506"
		_cCampo := "11000104"
	ElseIf sd2->d2_tes $ "515"
		_cCampo := "11000203"
	EndIf
	
ElseIf xFilial("SF2") =="02"
    
    If sd2->d2_tes $ "501/502"
		_cCampo := "21000101"
	ElseIf sd2->d2_tes $ "504/506"
		_cCampo := "21000102"
	ElseIf sd2->d2_tes $ "515"
		_cCampo := "21000203"
	EndIf
	
EndIf

Return(_cCampo)