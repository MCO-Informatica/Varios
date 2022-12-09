#include "rwmake.ch"        

User Function F240Sum()        

SetPrvt("_valor,_abat,_juros")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � F240SUM.PRW                                               ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para alterar o valor utilizado na funcao  ���
���          � SOMAVALOR() do sispag                                      ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 15/09/2008                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Utilizado no sispag do Itau para totalizar os acrescimos   ���
���            e descontos no valor total enviado ao banco.               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���Alteracao �                                                            ���
���          �                                                            ���
�����������������������������������������������������������������������������
/*/
_Abat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_Abat  += SE2->E2_DECRESC 
//_Juros := (SE2->E2_XMULTA + SE2->E2_E_JUROS)//NA LIQUIDA��O O SISTEMA N�O PREENCHE ESSES 2 CAMPOS ESPECIFICO, PORTANTO NA GERA��O DO CNAB TEM QUE PEGAR DO ACRESCIMO
_Juros := (SE2->E2_ACRESC)
_Valor := SE2->E2_SALDO - _Abat + _Juros

//-- Variavel publica declarada no ponto de entrada f240arq() e zerada no ponto de entrada f240almod()
_nTotEnt    += SE2->E2_E_VLENT               
_nTotAbat  += SE2->E2_DECRESC
_nTotAcres += _Juros
_nTotGps   += (SE2->E2_SALDO - SE2->E2_E_VLENT)
    

Return(_Valor)       
