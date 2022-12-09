#include "TOPCONN.CH"
#include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  XVLDSUBGRP  ºAutor  ³Romay Oliveira      º Data ³  12/01/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida campo subgrupo para deixar informar apenas se conterº±±
±±º          ³ o b1_grupo				                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XVLDSUBGRP()
Local lRet 			:= .F.
Local cGrupoProd	:= ""
//Local cGrupoProd 	:= Posicione("SZ8",1, XFilial("SZ8")+M->B1_XSUBGRP,"Z8_GRPPRD")

If Select("Qry2") > 0//Verifica se ja existe alias criado
	Qry2->( dbCloseArea() )
EndIf

cQuery := "	SELECT  "
cQuery += "	Z8_GRPPRD "
cQuery += "	FROM "
cQuery += RetSqlName("SZ8") + " SZ8 "
cQuery += "	WHERE "
cQuery += "		Z8_FILIAL 		= '" + xFilial('SZ8') + "' "
cQuery += " 	AND SZ8.D_E_L_E_T_ <> '*' "
cQuery += "		AND Z8_GRPPRD = '"+ M->B1_GRUPO +"'    "
cQuery += "		AND Z8_CODIGO = '"+ M->B1_XSUBGRP +"'    "



DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry2",.T.,.T.)

If Qry2->( !EOF() )
	
	cGrupoProd := (Qry2->Z8_GRPPRD)
	
EndIf

IF EMPTY(M->B1_XSUBGRP)
	lRet := .T.
	
ELSEIF(M->B1_GRUPO == cGrupoProd)
	lRet := .T.
Else
	Alert('Subgrupo nao pertence ao grupo informado, favor ajustar')
	lRet := .F.
EndIf

Return(lRet)
