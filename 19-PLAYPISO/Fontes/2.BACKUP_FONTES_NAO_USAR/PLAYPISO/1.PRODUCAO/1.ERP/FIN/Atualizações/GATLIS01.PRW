#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GATLIS01   ³ Autor ³ J.Marcelino Correa     ³ Data ³16.11.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza campo E2_XPROJET ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ LISONDA					Gatilho E2_XCC                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GATLIS01()

	Local a_area := GetArea()      
	Local n

	cProjeto := " "
	If Upper(AllTrim(FunName())) == "FINA050"
	
		cObra := M->E2_XCC
		
		dbSelectArea("AF8")
		dbsetOrder(08)
		If dbSeek(xFilial("AF8")+cObra)
			cProjeto     := AF8_PROJET    
		EndIf
		
	Else
		//nPosObra 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "E2_XCC"  		} )
		nPosProjeto	:= aScan(aHeader,{|x| AllTrim(x[2]) == "E2_XPROJET"	} )
		//cObra	 		:= aCols[n,nPosObra]
		
		nPosObra 		:= M->E2_XCC
//		nPosProjeto		:= M->E2_XPROJET
		cObra	 		:= nPosObra
		
		dbSelectArea("AF8")
		dbsetOrder(08)
		If dbSeek(xFilial("AF8")+cObra)
			cProjeto := AF8_PROJET
		EndIf
		
		Acols[n,nPosProjeto]	:= cProjeto
	EndIf

	RestArea(a_area)
	
Return(cProjeto)