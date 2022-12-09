#Include "Protheus.ch"   
#DEFINE CRLF CHR(13)+CHR(10) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK271BOK  � Danilo Alves Del Busso     � Data �  29/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte respons�vel pela valida��o da TES que calcula DIFAL  ���
���          � valida��o ocorre ao confirmar o or�amento/faturamento      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TK271BOK()
Local lRet     := .T.                                                        
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) 
Local nPosTes := aScan(aHeader,{|x| Alltrim(x[2])=="UB_TES"}) //Posicao TES 
Local cEstFil := GetMv("MV_ESTADO")       

cMotivo  := CRLF + "Diverg�ncias identificadas: "

If (M->UA_VQ_FVAL > M->UA_VQ_FVRE .And. M->UA_VQ_FVRE = 0 )
	cMotivo += CRLF + "Informe o valor do frete Real - O Frete real � o valor do frete negociado entre o Vendedor(Verqu�mica) e a Transportadora"
	lRet := .F.                               
EndIf

DbSelectArea("SA1");DbSetOrder(1)
If SA1->(DbSeek(xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA)))                                   
	If(SA1->A1_EST <> cEstFil)
		lDifObr := exigeDifal()
		If (lDifObr)
	   		DbSelectArea("SF4");DbSetOrder(1)
   			For nX := 1 To Len(aCols)
				If SF4->(DbSeek(xFilial("SF4")+aCols[nX,nPosTes]))   
					If(SF4->F4_DIFAL = "2" .Or. Empty(SF4->F4_DIFAL))
						cMotivo += CRLF + "Linha[" + cValToChar(nX) + "] Referente ao Produto [" + aCols[nX,nPosProd] +"] : Para clientes n�o contribuintes e fora do estado de origem da filial, n�o � poss�vel atrelar uma TES que n�o calcule a DIFAL" +CRLF   
						lRet := .F.
					EndIf
				EndIf
			Next
		EndIf
	EndIf
EndIf

If !lRet
	MsgAlert(cMotivo+CRLF, "Divergencias Identificadas")
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