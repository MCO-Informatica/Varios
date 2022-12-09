#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPE	 	 ³MT010INC  ºAutor  ³ João Zabotto			º Data ³  22/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava o codigo autoincremental para determinados tipos.     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010INC()
	Local cQuery	:= ""
	Local cAuxCod   := ""
	Local cAuxTipo	:= Alltrim(SB1->B1_TIPO)
	Local cAuxCC	:= SB1->B1_CC
	Local aArea		:= GetArea()
	Local lContinua := .T.
	Local xArea	    := GetArea()
	If AllTrim(SB1->B1_TIPO) != AllTrim(SB1->B1_COD)
		lContinua := .F.
	EndIf

	cQuery := 	"SELECT " + cEOL
	cQuery += 		"MAX(B1_COD) B1_COD " + cEOL
	cQuery += 	"FROM " + cEOL
	cQuery += 		RetSQLName("SB1") + " " + cEOL
	cQuery += 	"WHERE " + cEOL
	cQuery += 		"SUBSTRING(B1_COD,1,2) = '" + cAuxTipo + "' AND " + cEOL
	cQuery += 		"D_E_L_E_T_ = ' ' "

	TcQuery cQuery Alias TSB1 New

	If cAuxTipo = 'MO'
		DbSelectArea("SB1")
		dbSetOrder(1)
		xArea	    := GetArea()
		If !DbSeek(xFilial('SB1') + ALLTRIM(cAuxTipo) + 'D' + cAuxCC)
			cAuxCod := ALLTRIM(cAuxTipo + "D" + cAuxCC)
		Else
			Aviso("Produto Já Cadastrado","Este Produto " + ALLTRIM(cAuxTipo) + 'D' + cAuxCC + " já está cadastrado!",{"OK"})
			Return .F.
		EndIf
		RestArea(xArea)
	Else
		cAuxCod := cAuxTipo + If(TSB1->(EOF()),"00000001",StrZero(Val(SubStr(TSB1->B1_COD,3,8)) + 1,8))
	EndIf

	TSB1->(DbCloseArea())

	If SB1->(RecLock("SB1",.F.))
		SB1->B1_COD		:= cAuxCod
		SB1->B1_CODBAR	:= cAuxCod
		If Empty(SB1->B1_ZZCATAL)
			SB1->B1_ZZCATAL	:= SB1->B1_COD
		EndIF
		SB1->(MsUnLock())
	EndIF

	&& Alterar codigo no SB5
	DbSelectArea("SB5")
	SB5->(DbSetOrder(1))
	If SB5->(DbSeek(xFilial("SB5") + cAuxTipo))
		RecLock("SB5",.F.)
		SB5->B5_COD := cAuxCod
		SB5->(MsUnLock())
	EndIf

	RestArea(aArea)

	Return

