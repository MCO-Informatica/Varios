#Include "Protheus.ch"   
#DEFINE CRLF CHR(13)+CHR(10) 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DBVALTES  � Danilo Alves Del Busso     � Data �  29/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte respons�vel pela valida��o da TES que calcula DIFAL  ���
���          � valida��o inserida no SIGACFG campo UB_TES                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function DBVALTES()       

Local lRet     := .T.
Local nPosTes := aScan(aHeader,{|x| Alltrim(x[2])=="UB_TES"}) // Posicao TES 
Local cEstFil := GetMv("MV_ESTADO")       

cMotivo := CRLF + "Diverg�ncias identificadas: "
cSolucao := CRLF +"Solu��o: " + CRLF + "Fornecer TES que calcule DIFAL ou Atualizar cadastro do cliente como contribuinte ou n�o" + CRLF + "Em caso de d�vidas, comunicar o Depto. Fiscal da Verqu�mica."

DbSelectArea("SA1");DbSetOrder(1)
If SA1->(DbSeek(xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA)))                                   
	If(SA1->A1_EST <> cEstFil)
		lDifObr := exigeDifal()
		If (lDifObr)
	   		DbSelectArea("SF4");DbSetOrder(1)
			If SF4->(DbSeek(xFilial("SF4")+aCols[n,nPosTes]))   
				If(SF4->F4_DIFAL = "2" .Or. Empty(SF4->F4_DIFAL))
					cMotivo += CRLF + "Para clientes n�o contribuintes e fora do estado de origem da filial, n�o � poss�vel atrelar uma TES que n�o calcule a DIFAL" +CRLF   
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

If (Empty(SA1->A1_INSCR) .AND. SA1->A1_CONTRIB == "1") 								//N�O/BRANCO	- SIM		- NAO	
	lRet := .F.
EndIf
If (Empty(SA1->A1_INSCR) .AND. (SA1->A1_CONTRIB == "2" .Or. Empty(SA1->A1_CONTRIB))) //N�O/BRANCO	- BRANCO	- SIM	
	lRet := .T.
EndIf 

If (SA1->A1_EST == "EX" .AND. SA1->A1_TIPO == "X")
	lRet := .F.
EndIf


Return lRet