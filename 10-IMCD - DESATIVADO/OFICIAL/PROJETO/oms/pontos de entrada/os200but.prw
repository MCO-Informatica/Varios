#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �OS200BUT  � Autor �   Daniel   Gondran    � Data �03/11/2009���
�������������������������������������������������������������������������Ĵ��
���Descricao �Adicionar bot�es para consulta                              ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function OS200BUT()
	Local aBotoes := {}                             
	Local D1 := MV_PAR15
	Local D2 := MV_PAR16

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "OS200BUT" , __cUserID )

	aadd(aBotoes,{'PRODUTO' ,{|| U_MTMK001B(1,d1,d2)},"Ver Pedidos"})
	aadd(aBotoes,{'AVGBOX1' ,{|| U_MGRVCOMP() },"Compart."})

Return(aBotoes)