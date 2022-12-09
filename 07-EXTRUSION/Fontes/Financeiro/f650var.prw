#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | F200VAR .PRW   | AUTOR | GENILSON LUCAS (MVG) | DATA | 16/09/2010 |//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - F200VAR ()                                     |//
//|           | Ponto de entrada para manipular a data de compensa��o das tarifas |//
//|           | referente a emiss�o dos boletos.                                  |//
//+-------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////      

//�������������������������������Ŀ
//� o array aValores ir permitir �
//� que qualquer exce+"o ou neces-�
//� sidade seja tratado no ponto �
//� de entrada em PARAMIXB        �
//��������������������������������� 
           
// 1.	cNumTit -> N�mero do t�tulo
// 2.	dBaixa -> Data da Baixa
// 3.   cTipo -> Tipo do t�tulo
// 4.   cNsNum -> Nosso N�mero
// 5.   nDespes -> Valor da despesa
// 6.   nDescont -> Valor do desconto
// 7.   nAbatim -> Valor do abatimento
// 8.   nValRec -> Valor recebidos
// 9.   nJuros -> Juros
// 10.  nMulta -> Multa
// 11.  nOutrDesp -> Outras despesas
// 12.  nValCc -> Valor do cr�dito
// 13.  dDataCred -> Data do cr�dito
// 14.  cOcorr -> Ocorr�ncia
// 15.  cMotBai -> Motivo da baixa
// 16.  xBuffer -> Linha inteira
// 17.  dDtVc -> Data do vencimento

User Function F650VAR()

If mv_par03 $ "033|26 " .and. nValRec == 0 .and. nDespes > 0
   if cOcorr == "02 "
	  dCred := DataValida(dCred + 1)
   else
      nDespes := 0
   endif
EndIf

Return(nil)
