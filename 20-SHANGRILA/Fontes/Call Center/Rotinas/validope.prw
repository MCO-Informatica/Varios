#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 25/08/11 - Rotina para validar Tipo Operação
//========================================================================================================================================================

User Function VALIDOPE()  

xCodRe	:=Alltrim(M->UA_X_CODRE)
lSim	:=.T.

If 		xCodRe=="5100"
			If M->UB_OPER<>"01"
			lSim:=.F.
			EndIf
ElseIf 	xCodRe=="5150"
			If M->UB_OPER<>"02"
			lSim:=.F.
			EndIf
ElseIf 	xCodRe=="5130"
			If M->UB_OPER<>"03"
			lSim:=.F.
			EndIf
ElseIf 	xCodRe=="51100"
			If M->UB_OPER<>"04"
			lSim:=.F.
			EndIf
ElseIf 	xCodRe==""
			lSim:=.F.
EndIf

If !lSim
Alert("Tipo de operação inválida ou não preenchida no cabeçalho.")
EndIf

Return(.T.)          

