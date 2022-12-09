#Include 'Protheus.ch'
                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O ponto de entrada F580AUTVL permite a alteração do valor    ³
//³	 exibido no cabeçalho do browse na rotina Liberação para     ³
//³	baixa - Automática.		 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function F580AUTVL()   
_nValor := 0
While !QRYSE2->(EoF())
	     _nValor += QRYSE2->E2_SALDO
	QRYSE2->(DbSkip())
EndDo       
QRYSE2->(DbGoTop())     

Return(_nValor)