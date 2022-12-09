#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F4LOTIND  �Autor  �Danilo Alves Del Busso �Data� 25/01/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada respons�vel por organizar os lotes por    ���
���          � data de validade, do mais antigo para o mais novo. N�o � po- ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function F4LOTIND()

Local aLotes:= PARAMIXB[1] //Recebe o array com os lotes j� carregados           
ASort(aLotes,,,{|x,y| DtoS(x[5])+x[1] < DtoS(y[5])+y[1] })

Return(aLotes)