#Include 'Protheus.ch'
                       
//��������������������������������������������������������������Ŀ
//� O ponto de entrada F580AUTVL permite a altera��o do valor    �
//�	 exibido no cabe�alho do browse na rotina Libera��o para     �
//�	baixa - Autom�tica.		 									 �
//����������������������������������������������������������������

User Function F580AUTVL()   
_nValor := 0
While !QRYSE2->(EoF())
	     _nValor += QRYSE2->E2_SALDO
	QRYSE2->(DbSkip())
EndDo       
QRYSE2->(DbGoTop())     

Return(_nValor)