#INCLUDE "Protheus.ch"

User Function RETNOME(cCliLoja,cTipo)
Local cRet := ""

IF cTipo $ "B|D"
	cRet := posicione("SA2",1,xFilial("SA2")+cCliLoja,"A2_NOME")
ELSE
	cRet := posicione("SA1",1,xFilial("SA1")+cCliLoja,"A1_NOME")
ENDIF

Return cRet