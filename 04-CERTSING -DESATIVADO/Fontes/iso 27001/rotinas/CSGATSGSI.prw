#Include "Protheus.Ch"
#Include "TopConn.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO7     ºAutor  ³Microsiga           º Data ³  02/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSGATSGSI()

Local aArea		:= GetArea()
Local aAreaSZZ	:= SZZ->(GetArea())
Local cAlias	:= GetNextAlias()
Local cQry		:= ""
Local cNomSup	:= ""

cQry := " Select RD4_CODIGO,RD4_TREE "
cQry += " From " +RetSqlName("RDE")+ " RDE "
cQry += " Inner Join " +RetSqlName("RD4")+ " RD4 On RDE.RDE_CODVIS = RD4.RD4_CODIGO And RDE.RDE_ITEVIS = RD4.RD4_ITEM "
cQry += " Where RDE.RDE_CODPAR = '" +M->ZZ_PARTIC+ "' "

TCQUERY	cQry NEW ALIAS(cAlias)

RDE->(DbSetOrder(2))
If RDE->(DbSeek(xFilial("RDE") + (cAlias)->RD4_CODIGO + (cAlias)->RD4_TREE))
	RD0->(DbSetOrder(1))
	If RD0->(DbSeek(xFilial("RD0") + RDE->RDE_CODPAR))
		SRA->(DbSetOrder(13))
		If SRA->(DbSeek(RD0->RD0_MAT))
			cNomSup	:= SRA->RA_NOME
		EndIf
	EndIf 
EndIf

(cAlias)->(DbCloseArea())

RestArea(aAreaSZZ)
RestArea(aArea)

Return cNomSup