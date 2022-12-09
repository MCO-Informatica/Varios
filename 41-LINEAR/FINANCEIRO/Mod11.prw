#Include "Protheus.ch"
#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcDig   �Autor  �Ricardo Nunes       � Data �  27/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do digito verificador do nosso numero.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Uso especifico para o Modulo 11                            ���
�������������������������������������������������������������������������͹��
���Parametros�01-_cNum - Numero do Titulo (Nosso Numero)                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Mod11(cStr,nMultIni,nMultFim)
Local i, nModulo := 0, cChar, nMult

nMultIni := Iif( nMultIni==Nil,2,nMultIni )
nMultFim := Iif( nMultFim==Nil,9,nMultFim )
nMult := nMultIni
cStr := AllTrim(cStr)

For i := Len(cStr) to 1 Step -1
	cChar := Substr(cStr,i,1)
	If isAlpha( cChar )
		Help(" ", 1, "ONLYNUM")
		Return .f.
	End
	nModulo += Val(cChar)*nMult
	nMult:= IIf(nMult==nMultfim,2,nMult+1)
Next
nRest := nModulo % 11
IF nRest == 0
	nRest := 0
ELSEIF nRest == 1
	nRest := 10
ELSE
	nRest := 11-nRest
	//nRest := IIf(nRest==0 .or. nRest==1,0,11-nRest)
ENDIF

Return(Str(nRest,2))

