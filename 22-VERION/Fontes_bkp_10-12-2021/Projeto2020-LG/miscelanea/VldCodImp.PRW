#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDCODIMP ºAutor  ³Microsiga           º Data ³  08/30/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do campo B1_CODIMP, nao permitindo duplicidades  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verion                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VldCodImp(cCodImp)

Local cQuery, lRet

lRet := .t.

If !Empty(cCodImp)
	If Select("WorkTt")>0
		WorkTt->(dbCloseArea())
	EndIf
				
	cQuery := " SELECT COUNT(1) TTPROD"
	cQuery += " FROM " +RetSqlName("SB1")
	cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
	cQuery += " AND B1_CODIMP = '"+cCodImp+"' "
	cQuery += " AND D_E_L_E_T_=' ' "
	tcQuery cQuery New Alias "WorkTt"
	
	If WorkTt->TTPROD >= 1
		If Select("Work")>0
			Work->(dbCloseArea())
		EndIf
		
		cQuery := " SELECT B1_COD "
		cQuery += " FROM " +RetSqlName("SB1")
		cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
		cQuery += " AND B1_CODIMP = '"+cCodImp+"' "
		cQuery += " AND D_E_L_E_T_=' ' "
		tcQuery cQuery New Alias "Work"
		
		msgStop("Produto IMPORTAÇÃO " + cCodImp + "já cadastrado no Protheus... Código do Produto que o possui é o: " + Work->B1_COD + " ... Checar e corrigir!")
		lRet := .f.
	EndIf
EndIf
	
Return lRet
