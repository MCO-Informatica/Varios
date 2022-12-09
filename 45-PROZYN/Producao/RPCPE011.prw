
#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCPA011  �Autor � DERIK SANTOS           � Data � 11/11/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para copiar o lote de destino da linha 1 para as    ���
���Desc.     � outras linhas caso o D3_SUGLOTE esteja como "S"            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico para Prozyn                                     ���        
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RPCPE011()
                                                                             
_pProd    := aScan(aHeader,{|x| AllTrim(x[1]) == "Prod.Orig."})
_cProd    := aCols[n][_pProd]
_pSuglote := aScan(aHeader,{|x| AllTrim(x[1]) == "Sugere Lote"})
_cSuglote := aCols[1][_pSuglote]
_pLote    := aScan(aHeader,{|x| AllTrim(x[1]) == "Lote Destino"})
_cLote    := aCols[1][_pLote]

If _cSuglote == "S"
	aCols[n][_pLote]    := _cLote
	aCols[n][_pSuglote] := "S"
Endif

ReTurn (_cProd)