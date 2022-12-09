#Include "Totvs.ch"

//Funcao para atualizar status(Z6_TIPO) dos pedidos de periodos anteriores.
User Function UPDREM04()

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

BeginSql Alias "TMPEXC"

	SELECT  SZ3.Z3_CODENT CODENT, 
	        R_E_C_N_O_ RECNOZ3
	FROM SZ3010 SZ3
	WHERE
	SZ3.Z3_FILIAL = ' ' AND
	SZ3.Z3_DESENT LIKE '% IT %' AND
	SZ3.Z3_CODCCR IN ('054577',
	'054536',
	'054876',
	'054920',
	'054311') AND
	SZ3.D_E_L_E_T_ = ' '
	
EndSql	

DbSelectArea("TMPEXC")
TMPEXC->(DbGoTop())

While !TMPEXC->(EOF())
    
    SZ3->(DbGoTo(TMPEXC->recnoz3))
    
    If AllTrim(SZ3->Z3_CODENT) == AllTrim(TMPEXC->CODENT)
    	RecLock("SZ3",.F.) // Define que será realizada uma alteração no registro posicionado
			SZ3->Z3_QUEBRA := "2"
		SZ3->(MsUnLock()) // Confirma e finaliza a operação
    EndIf
	
	TMPEXC->(DbSkip())

EndDo

Return