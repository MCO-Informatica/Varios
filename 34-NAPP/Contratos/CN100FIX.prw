#include 'protheus.ch'
#include 'parmtype.ch'

User Function CN100FIX()

	Local lRet  := .T.
	Local aArea := GetArea()
	Local cCliFor := ""
	Local cCod := ""

	IF Empty(CN9->CN9_CLIENT) .OR. CN9->CN9_ESPCTR == '1'
		cCod 	:=  POSICIONE("CNC",1,CN9->(xFilial("CN9")+CN9_NUMERO+CN9_REVISA),"CNC_CODIGO+CNC_LOJA")
		cCliFor :=  POSICIONE("SA2",1,xFilial("SA2")+cCod,"A2_NOME")
	Else
		cCod 	:=  POSICIONE("CNC",1,CN9->(xFilial("CN9")+CN9_NUMERO+CN9_REVISA),"CNC_CLIENT+CNC_LOJACL")
		cCliFor :=  POSICIONE("SA1",1,xFilial("SA1")+cCod,"A1_NOME")
	EndIf

	RecLock("CN9",.F.)
	CN9->CN9_XCLIFO := cCliFor
	MsUnlock("CN9")

	RestArea(aArea)

Return lRet

