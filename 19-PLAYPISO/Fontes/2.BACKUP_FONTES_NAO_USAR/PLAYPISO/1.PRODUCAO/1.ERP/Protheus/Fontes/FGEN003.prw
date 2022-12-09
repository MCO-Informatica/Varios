#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FGEN003   ºAutor  ³Alexandre Martins   º Data ³  09/26/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o proximo numero do alias informado.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FGEN003(c_Alias, c_campo, c_where, n_tam)

	Local c_Ret   := ""
	Local c_query := ""
	Local n_taman := Iif(n_tam=nil, 0, n_tam)
	Local a_Area  := GetArea()
	Local a_AreaX3:= SX3->(GetArea())

	c_where 	  := Iif(c_where=Nil, '', c_where)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o tamanho do campo              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If n_taman = 0
		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek(c_campo)
		n_taman := SX3->X3_TAMANHO
	EndIf

	c_query := "select max(" + c_campo + ") as NUM from "+RetSqlName(c_Alias)+" where D_E_L_E_T_ <> '*'"
	If !Empty(c_where)
		c_query += " and " + c_where
	EndIf

	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	
	TcQuery c_Query New Alias "QRY"

	If QRY->(EOF()) .or. QRY->NUM = ''     
		c_Ret 	:= StrZero(1,n_taman)
	Else
		c_Ret	:= Soma1(substr(QRY->NUM,1,n_taman))
	EndIf

	RestArea(a_AreaX3)
	RestArea(a_Area)
	
Return c_Ret
