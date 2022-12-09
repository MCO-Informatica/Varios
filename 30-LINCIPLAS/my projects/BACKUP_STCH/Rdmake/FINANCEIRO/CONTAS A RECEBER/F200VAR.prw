#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200VAR �Autor  �Rodrigo Okamoto       � Data �  25/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para anular as despesas banc�rias no      ���
���          � retorno do CNAB a Receber para contas garantias            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - LINCIPLAS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F200VAR

Private aSE1 := GetArea()

//aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc,{} })
//VERIFICA SE TEM VALOR DE DESPESA E REALIZA O MOVIMENTO DE DESPESA NA CONTA CORRENTE INFORMADA POR DANIELLE


If nDespes <> 0 .and. cBanco=="341" .and. cAgencia=="7646 " .and. cConta=="075270    "
	nDespes	:= 0
ElseIf nDespes <> 0 .and. cBanco=="341" .and. cAgencia=="7646 " .and. cConta=="004791    "
	nDespes	:= 0
ElseIf nDespes <> 0 .and. cBanco=="356" .and. cAgencia=="1560 " .and. cConta=="2089811   "
	nDespes	:= 0
ElseIf nDespes <> 0 .and. dDataCred == Ctod("//")
	dDataCred := ddatabase
EndIf               
//TRATAMENTO PARA QUE O RETORNO DA COBRAN�A DESCONTADA PROCESSE FAZENDO AS BAIXAS
IF ALLTRIM(UPPER(MV_PAR05)) == "ITAUDESC.RET" .AND. ALLTRIM(cOcorr) == "02"
	cOcorr := "06 "
	nDespes:= nDespes+nAbatim//+nOutrDesp
	nValRec:= nValRec+nDespes+nOutrDesp
EndIf


RestArea(aSE1)

Return



