#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³vldxokeng   Autor ³ TOTALIT AP6 IDE    º Data ³  30/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida se o produto foi liberado pela engenharia.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CARMAR - Abertura da Ordem de Produção                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function vldlfiscal(cproduto)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _xAlias := GetArea()
Local _lRet := .T.
Local _VlEmp := GetNewPar("ES_VALEMP","02")
Local _cParAtiv := GetNewPar("ES_VALPROD",.T.)

DbSelectArea("SB1")

If _cParAtiv .And. Alltrim(cEmpAnt)$ _VlEmp
	
	If Alltrim(cModulo) $ "EST/PCP"     
		If SB1->(FieldPos("B1_XOKENGE")) > 0
			SB1->(DbSeek(xFilial("SB1")+cproduto))
			If Alltrim(SB1->B1_XOKENGE) != "1"
				MsgAlert("PRODUTO NÃO LIBERADO PARA MOVIMENTAÇÃO, POR FAVOR VERIFIQUE COM A ENGENHARIA RESPONSAVEL PELO CADASTRO!!!",ReadVar())
				_lRet := .F.
			EndIf
		EndIf
	Endif
	
	If Alltrim(cModulo) $ "COM" 
		If SB1->(FieldPos("B1_XOKSUPR")) > 0
			SB1->(DbSeek(xFilial("SB1")+cproduto))
			If  Alltrim(SB1->B1_XOKSUPR) != "1"
				MsgAlert("PRODUTO NÃO LIBERADO PARA MOVIMENTAÇÃO, POR FAVOR VERIFIQUE COM A AREA FISCAL RESPONSAVEL PELO CADASTRO!!!",ReadVar())
				_lRet := .F.
			EndIf
		EndIf
	Endif
	
EndIf

RestArea(_xAlias)

Return(_lRet)
