#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200ABAT  �Autor  �Opvs (David)        � Data �  17/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para ajustar o Banco Informado no Portador ���
���          �do T�tulo ou mantem o Banco Informado nos Paramentros de Bx ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/
User Function F200ABAT

//Parametros Informados na Baixa do CNAB
Local cBancoPar	:= mv_par06
Local cAgenPar	:= mv_par07
Local cContPar 	:= mv_par08
//Informacoes de Portador do T�tulo
Local cBancoSE1	:= SE1->E1_PORTADO
Local cAgenSE1	:= SE1->E1_AGEDEP
Local cContSE1 	:= SE1->E1_CONTA

//Retorna conta e agencia novamente
cBanco	:= IIf( Empty(cBancoSE1), cBancoPar, cBancoSE1 )
cAgencia:= IIf( Empty(cAgenSE1), cAgenPar, cAgenSE1 )
cConta	:= IIf( Empty(cContSE1), cContPar, cContSE1 )  

Return