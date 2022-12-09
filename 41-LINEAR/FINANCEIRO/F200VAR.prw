#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF200VAR บAutor  ณRodrigo Okamoto       บ Data ณ  25/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para anular as despesas bancแrias no      บฑฑ
ฑฑบ          ณ retorno do CNAB a Receber para contas garantias            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - LINCIPLAS                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
//TRATAMENTO PARA QUE O RETORNO DA COBRANวA DESCONTADA PROCESSE FAZENDO AS BAIXAS
IF ALLTRIM(UPPER(MV_PAR05)) == "ITAUDESC.RET" .AND. ALLTRIM(cOcorr) == "02"
	cOcorr := "06 "
	nDespes:= nDespes+nAbatim//+nOutrDesp
	nValRec:= nValRec+nDespes+nOutrDesp
EndIf


RestArea(aSE1)

Return



