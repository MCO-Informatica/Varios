#include "Protheus.ch"
#INCLUDE "TOTVS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RQIEE001()   �Autor  �Roberta Alonso   � Data �  11/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para preenchimento das medi��es no resultados do    ���
���          � inspe��o de entrada                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 12                          	                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//�������������������������
User Function RQIEE001()
//�������������������������

Local _aSavArea := GetArea()
Local _lRet 	:= .T.
Local _nMed 	:= 1
Local _nMaxMed	:= 15

//esta rotina � executada de qualquer campo Medicao da especifica��o tecnica, pois os campos tem o mesmo nome.
//a Deborah (resp. pela qualidade) disse que eles possuem apenas uma medicao para todos os produtos, mas o XBR trabalha com no minimo duas.
//Entao nossa rotina pega o que digitou e replica na Medicao 02.

_cMedicao := &(ReadVar())  //conteudo digitado

For _nMed := 1 To _nMaxMed
	
	_cCampo := "Medicao " + StrZero(_nMed,2)
	_nPosMed := aScan(aHeader, {|x| alltrim(x[1]) == _cCampo})
	
	If _nPosMed > 0
		aCols[n,_nPosMed] := _cMedicao  //atualizacao da medicao
	EndIf

Next

Q215VERCAL(M->QES_MEDICA) //Chamada de fun��o para avaliar m�dia dos resultados e atualizar status do lote (aprovado/reprovado)

RestArea(_aSavArea)

Return(_lRet)