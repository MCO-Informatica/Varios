/*/

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MATAK1   ³ Autor ³ Paulo Cesar T Oliveira  ³ Data ³ 23/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o Valor da Conta Contabil - CLIENTES                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Verion Oleohidraulica Ltda                                   ³±±
±±³--ÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function MATAK01()

Local _aArea :=	GetArea()
Local _WAA := 0

DbSelectArea("SI1")
DbSetOrder(1)
dbGoTop()
WHILE !EOF()
    cDG := ""
	// GERAR O DIGITO DE CONTROLE COM UM BIT
	// retorna o numero acrescido do digito verificador
	cDG := CtbDigCont(alltrim(SI1->I1_CODIGO))
	Reclock("SI1",.F.)
	REPLACE I1_DC with cDG,I1_CV2 with "D",I1_CV3 with "D"
	REPLACE I1_CV4 with "D",I1_CV5 with "D"
	REPLACE I1_CTASUP with subs(SI1->I1_Codigo,1,5)
	REPLACE I1_VLRLPD with 0,I1_VLRLPC with 0
	MsUnLock()
	DBSKIP()
END

//----> RESTAURANDO A INTEGRIDADE DA AREA ABERTA ANTES DO PROCESSAMENTO
RestArea(_aArea)

Return (Nil)
