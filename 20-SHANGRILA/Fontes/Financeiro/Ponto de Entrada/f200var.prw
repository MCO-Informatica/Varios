#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | F200VAR .PRW   | AUTOR | GENILSON LUCAS (MVG) | DATA | 16/09/2010 |//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - F200VAR ()                                     |//
//|           | Ponto de entrada para manipular a data de compensação das tarifas |//
//|           | referente a emissão dos boletos.                                  |//
//+-------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ o array aValores ir permitir ³
//³ que qualquer exce+"o ou neces-³
//³ sidade seja tratado no ponto ³
//³ de entrada em PARAMIXB        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
           
// 1.	cNumTit -> Número do título
// 2.	dBaixa -> Data da Baixa
// 3.   cTipo -> Tipo do título
// 4.   cNsNum -> Nosso Número
// 5.   nDespes -> Valor da despesa
// 6.   nDescont -> Valor do desconto
// 7.   nAbatim -> Valor do abatimento
// 8.   nValRec -> Valor recebidos
// 9.   nJuros -> Juros
// 10.  nMulta -> Multa
// 11.  nOutrDesp -> Outras despesas
// 12.  nValCc -> Valor do crédito
// 13.  dDataCred -> Data do crédito
// 14.  cOcorr -> Ocorrência
// 15.  cMotBai -> Motivo da baixa
// 16.  xBuffer -> Linha inteira
// 17.  dDtVc -> Data do vencimento

User Function F200VAR()
	
Local _dBaixa	:= dBaixa

                                          
If cOcorr  $ "02 09 28 29"
	//dBaixa 		:= DataValida(_dBaixa + 1) 
	//dDataCred	:= DataValida(_dBaixa + 1) 
	//dDtVc		:= DataValida(_dBaixa + 1)
EndIf

If cBanco$"237/341" .and. cOcorr $"06"
	dDataCred	:= DataValida(dDataCred + 1)
EndIf

If nOutrDesp > 0
	nDespes := nDespes + nOutrDesp
EndIf

Return(nil)