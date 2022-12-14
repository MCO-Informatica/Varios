#INCLUDE "rwmake.ch"

User Function RESTG02() 

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de Variaveis                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
Local cCodPrd := ""
Local lReturn := .T.
Local cAlias  := Alias()
Local cOrdSB1 := SB1->(IndexOrd())

cCampo := ReadVar()

cCodProd := &(cCampo)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Verifica se existe o produto no campo B1_COD.                       ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
If !SB1->(dbSetOrder(5), dbSeek(xFilial("SB1")+cCodProd))
	MsgAlert("Produto n?o cadastrado!","Aten豫o")
	lReturn := .F.
Else
	lReturn := .T.
	&(ReadVar()) := SB1->B1_COD
	lRefresh := .T.
EndIf
SB1->(dbSetOrder(cOrdSB1))
dbSelectArea(cAlias)

Return (lReturn)
