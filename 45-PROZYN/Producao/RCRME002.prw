#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCRME002  ºAutor  ³Derik Santos        º Data ³  19/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Execblock para verificar se o prospect possui contato      º±±
±±ºDesc.     ³ cadastrado, caso não tenha exibe um alerta e abre tela     º±±
±±ºDesc.     ³ para cadastro    									      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RCRME002() 

_cOport  := M->AD1_NROPOR
_cRevis1 := "01"
_cRevis2 := M->AD1_REVISA
_cTipo   := M->AD1_TIPO
_cPerc   := M->AD1_PERCEN 
_cPont	 := M->AD1_PONTUA

DbSelectArea("AD1")
dbSetOrder(1) //Filial + Projeto + Revisão
If dbSeek(xFilial("AD1") + _cOport + _cRevis1)
	Alert("Alteração não permitida")
	Return (.F.)
Else
	If _cPont == "2" .AND. _cTipo <> "1"
		_cPerc += 60
		M->AD1_PERC   := _cPerc
		M->AD1_PERCEN := _cPerc
		Return (.T.)
	Elseif _cPont == "1" .AND. _cTipo == "1"
		_cPerc -= 60
		M->AD1_PERC   := _cPerc
		M->AD1_PERCEN := _cPerc
		M->AD1_PONTUA := "2"
		M->AD1_CONCL1 := ""
		M->AD1_CONCL3 := ""
		M->AD1_DOCS   := .F.
		Return (.T.)
	Else
		Return (.T.)			
	EndIf
EndIf