#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A650PROC  ³ Autor ³ GENILSON LUCAS - MVG	³ Data ³ 27/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para apagar a OP se necessário.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Shangri-la                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A650PROC()

Local aArea 		:= GetArea()
Local aAreaSC2	:= SC2->(GetArea())

If FUNNAME() = "MATA650"
	If	lApagaOP
	   Tmata650()
	   aDelOP   := {}
	   lApagaOP := .F.
	EndIf
EndIf

RestArea(aArea)
RestArea(aAreaSC2)
Return()

Static Function Tmata650()

Local aVetor := {}
lMsErroAuto := .F.


For i := 1 to len(aDelOP)
	/*
	aVetor:={ {"C2_NUM",nOP,NIL},;
	{"C2_ITEM",nItem,NIL},;
	{"C2_SEQUEN",nSequen,NIL}}
	*/
	
	//Posiciona na SC2 para execAuto
	SC2->(DbSetOrder(1))
	SC2->(dbSeek(xFilial("SC2") + aDelOP[i][1] + aDelOP[i][2] + aDelOP[i][3])) // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD    

	aVetor:={ {"C2_NUM",aDelOP[i][1],NIL},;
	{"C2_ITEM",aDelOP[i][2],NIL},;
	{"C2_SEQUEN",aDelOP[i][3],NIL}}
	
	MSExecAuto({|x,y| mata650(x,y)},aVetor,5) //Exclusao

	If lMsErroAuto
		Alert("Erro ao apagar OP " + aDelOP[i][1] + aDelOP[i][2] + aDelOP[i][3] )
	Else
		MsgAlert("OP " + aDelOP[i][1] + aDelOP[i][2] + aDelOP[i][3] + " apagada com sucesso!")
	Endif

Next
//A650OpenBatch()
A650CloseBatch()
Return()