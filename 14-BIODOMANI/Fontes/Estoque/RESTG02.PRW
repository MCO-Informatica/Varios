#INCLUDE "rwmake.ch"

User Function RESTG02() 

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cCodPrd := ""
Local lReturn := .T.
Local cAlias  := Alias()
Local cOrdSB1 := SB1->(IndexOrd())

cCampo := ReadVar()

cCodProd := &(cCampo)

//���������������������������������������������������������������������Ŀ
//� Verifica se existe o produto no campo B1_COD.                       �
//�����������������������������������������������������������������������
If !SB1->(dbSetOrder(5), dbSeek(xFilial("SB1")+cCodProd))
	MsgAlert("Produto n�o cadastrado!","Aten��o")
	lReturn := .F.
Else
	lReturn := .T.
	&(ReadVar()) := SB1->B1_COD
	lRefresh := .T.
EndIf
SB1->(dbSetOrder(cOrdSB1))
dbSelectArea(cAlias)

Return (lReturn)