#Include 'Protheus.ch'
                       
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� O ponto de entrada F580AUTVL permite a altera豫o do valor    �
//�	 exibido no cabe�alho do browse na rotina Libera豫o para     �
//�	baixa - Autom�tica.		 									 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

User Function F580AUTVL()   
_nValor := 0
While !QRYSE2->(EoF())
	     _nValor += QRYSE2->E2_SALDO
	QRYSE2->(DbSkip())
EndDo       
QRYSE2->(DbGoTop())     

Return(_nValor)