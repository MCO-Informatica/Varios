#Include "Protheus.ch"   
#DEFINE CRLF CHR(13)+CHR(10) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DBVALTES  º Danilo Alves Del Busso     º Data ³  29/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fonte responsável pela validação da TES que calcula DIFAL  º±±
±±º          ³ validação inserida no SIGACFG campo UB_TES                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function DBVALTES()       

Local lRet     := .T.
Local nPosTes := aScan(aHeader,{|x| Alltrim(x[2])=="UB_TES"}) // Posicao TES 
Local cEstFil := GetMv("MV_ESTADO")       

cMotivo := CRLF + "Divergências identificadas: "
cSolucao := CRLF +"Solução: " + CRLF + "Fornecer TES que calcule DIFAL ou Atualizar cadastro do cliente como contribuinte ou não" + CRLF + "Em caso de dúvidas, comunicar o Depto. Fiscal da Verquímica."

DbSelectArea("SA1");DbSetOrder(1)
If SA1->(DbSeek(xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA)))                                   
	If(SA1->A1_EST <> cEstFil)
		lDifObr := exigeDifal()
		If (lDifObr)
	   		DbSelectArea("SF4");DbSetOrder(1)
			If SF4->(DbSeek(xFilial("SF4")+aCols[n,nPosTes]))   
				If(SF4->F4_DIFAL = "2" .Or. Empty(SF4->F4_DIFAL))
					cMotivo += CRLF + "Para clientes não contribuintes e fora do estado de origem da filial, não é possível atrelar uma TES que não calcule a DIFAL" +CRLF   
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

If !lRet
	MsgAlert(cMotivo+CRLF+cSolucao, "DIFAL")
EndIf

Return(lRet)            


Static Function exigeDifal()
lRet := .F.       
                         
If (!Empty(SA1->A1_INSCR) .AND.SA1->A1_CONTRIB == "2" )								//SIM		- NAO		- SIM
	lRet := .T.	
EndIf
If (!Empty(SA1->A1_INSCR) .AND. (SA1->A1_CONTRIB == "1" .Or. Empty(SA1->A1_CONTRIB)))	//SIM		- SIM		- NAO	
	lRet := .F.
EndIf

If (AllTrim(UPPER(SA1->A1_INSCR)) == "ISENTO" .And. SA1->A1_CONTRIB == "1")								//ISENTO		- SIM		- NAO	
	lRet := .F.
EndIf
If (AllTrim(UPPER(SA1->A1_INSCR)) == "ISENTO" .And. (SA1->A1_CONTRIB == "2" .Or. Empty(SA1->A1_CONTRIB)))	//ISENTO		- BRANCO	- SIM	
	lRet := .T.
EndIf

If (Empty(SA1->A1_INSCR) .AND. SA1->A1_CONTRIB == "1") 								//NÃO/BRANCO	- SIM		- NAO	
	lRet := .F.
EndIf
If (Empty(SA1->A1_INSCR) .AND. (SA1->A1_CONTRIB == "2" .Or. Empty(SA1->A1_CONTRIB))) //NÃO/BRANCO	- BRANCO	- SIM	
	lRet := .T.
EndIf 

If (SA1->A1_EST == "EX" .AND. SA1->A1_TIPO == "X")
	lRet := .F.
EndIf


Return lRet