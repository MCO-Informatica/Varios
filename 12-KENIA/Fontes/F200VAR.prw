
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200VAR	�Autor  �  Cadubitski        � Data �  01/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para considerar o valor de outros creditos ���
���          �como juros. Isso porque quando o cliente da Boiron faz 	  ���

���          �pagamento com atraso em um estabelecimento credenciado 	  ���
���          �Santander, para diferenciacao o banco lanca os valores 	  ���
���          �referentes a juros no campo "outros creditos" e quando o 	  ���
���          �pagamento com atraso eh feito no banco Santander, eh lancado���
���          �normalmente no campo "Juros". O Protheus reconhece somente  ���
���          �quando eh lancado em "Juros". O ajuste pode ser feito 	  ���
���          �gravando o valor de "Outros Creditos" no campo "Juros".	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Boiron                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*------------------------------------------------------------------------*
*------------------------------------------------------------------------*
*       POSICOES DO ARRAY PARAMIXB[] UTILIZADOS NESTE PONTO DE ENTRADA            *
*                                                                                 *
* PARAMIXB[1, 1] := cNumTit    PREFIXO+NUMERO+PARCELA                            *
* PARAMIXB[1, 2] := dBaixa     DATA DA BAIXA                                     *
* PARAMIXB[1, 3] := cTipo      TIPO DO TITULO NA TABELA 17                       *
* PARAMIXB[1, 4] := cNsNum     NOSSO NUMERO                                      *
* PARAMIXB[1, 5] := nDespes    VALOR DA DESPESA                                  *
* PARAMIXB[1, 6] := nDescont   VALOR DO DESCONTO                                 *
* PARAMIXB[1, 7] := nAbatim    VALOR DO ABATIMENTO                               *
* PARAMIXB[1, 8] := nValRec    VALOR RECEBIDO                                    *
* PARAMIXB[1, 9] := nJuros     VALOR DO JUROS                                    *
* PARAMIXB[1,10] := nMulta     VALOR DA MULTA                                    *
* PARAMIXB[1,11] := nOutrDesp  VALOR OUTRAS DESPESAS                             *
* PARAMIXB[1,12] := nValCc     VALOR                                             *
* PARAMIXB[1,13] := dDataCred  DATA DO CREDITO                                   *
* PARAMIXB[1,14] := cOcorr     OCORRENCIA                                        *
* PARAMIXB[1,15] := cMotBan    MOTIVO DA BAIXA                                   *
* PARAMIXB[1,16] := xBuffer    LINHA INTEIRA DO CNAB                             *
*                                                                                 *
*------------------------------------------------------------------------*
*------------------------------------------------------------------------*
*/


User Function F200VAR()

_aArea		:= 	GetArea()
_aValores	:=	{}

dbSelectArea("SE1")
cIndSE1 := IndexOrd()
nRecSE1	:=	Recno()                                                                                                                                                                                        

dbSetOrder(19)


If dbSeek(cNumTit,.f.)
	
	_nSaldo	:= SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,DDATABASE,SE1->E1_CLIENTE,SE1->E1_LOJA) - SE1->E1_DECRESC
	_nAbat	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,DDATABASE,SE1->E1_CLIENTE,SE1->E1_LOJA) + SE1->E1_DECRESC

	nDescont += SE1->E1_DECRESC
	nAbatim	 += SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,DDATABASE,SE1->E1_CLIENTE,SE1->E1_LOJA)
	//----> VERIFICA SE EXISTE SALDO NO T�TULO
	If _nSaldo > 0
		
		
		//----> VERIFICA SE SALDO � DIFERENTE DO VALOR RECEBIDO E SE A OCORR�NCIA � LIQUIDA��O
		_lRet	:=		Iif(_nSaldo <> 	(nValRec-nJuros-nMulta)  .AND. Alltrim(cOcorr)$"06",.T.,.F.)
		
		If _lRet
			
			ALERT("Diverg�ncia entre o saldo a receber e o valor recebido no arquivo retorno."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"T�tulo "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Vlr. Saldo Sistema R$ "+Space(30-Len("Vlr. Saldo Sistema R$ "))+Transform(SE1->E1_SALDO,"@E 999,999,999.99")+CHR(13)+CHR(10)+;
			"Vlr. Abat. Sistema R$ "+Space(32-Len("Vlr. Abat. Sistema R$ "))+Transform(_nAbat,"@E 999,999,999.99")+CHR(13)+CHR(10)+;
			"Vlr. Retorno Arquivo R$ "+Space(29-Len("Vlr. Retorno Arquivo R$ "))+Transform((nValRec-nJuros-nMulta),"@E 999,999,999.99")+CHR(13)+CHR(10)+;
			"Vlr. Diferen�a R$ "+Space(34-Len("Vlr. Diferen�a R$ "))+Transform(_nSaldo - (nValRec-nJuros-nMulta),"@E 999,999,999.99") )

			//nValRec := 0
		EndIf
	EndIf
EndIf

dbSelectArea("SE1")
dbSetOrder(cIndSE1)
dbGoTo(nRecSE1)

nJuros	+= nValCc  //Somo o valor de outros creditos no juros
nValCc	:= 0			//Zero o valor de outros creditos
                                       

RestArea(_aArea)

Return(_aValores)


Return()
