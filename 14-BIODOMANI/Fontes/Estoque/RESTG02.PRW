#INCLUDE "rwmake.ch"

User Function RESTG02() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCodPrd := ""
Local lReturn := .T.
Local cAlias  := Alias()
Local cOrdSB1 := SB1->(IndexOrd())

cCampo := ReadVar()

cCodProd := &(cCampo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe o produto no campo B1_COD.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !SB1->(dbSetOrder(5), dbSeek(xFilial("SB1")+cCodProd))
	MsgAlert("Produto não cadastrado!","Atenção")
	lReturn := .F.
Else
	lReturn := .T.
	&(ReadVar()) := SB1->B1_COD
	lRefresh := .T.
EndIf
SB1->(dbSetOrder(cOrdSB1))
dbSelectArea(cAlias)

Return (lReturn)
