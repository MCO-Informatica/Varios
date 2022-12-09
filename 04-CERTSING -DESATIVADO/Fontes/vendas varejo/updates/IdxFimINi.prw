#include "protheus.ch"

User Function IdxFimIni()
	If MsgYesNo('.Executar a rotina para ler o SX2 de traz para frente e criar os índices?')
		RpcSetType( 3 )
		RpcSetEnv( '04', '01' )
		GoProc("04","01")

		RpcSetType( 3 )
		RpcSetEnv( '02', '01' )
		GoProc("02","01")

		RpcSetType( 3 )
		RpcSetEnv( '01', '02' )
		GoProc("01","02")
	Endif
Return

Static Function GoProc( xEmp, xFil )
	Local aProc := {}
	Local aUsers := {}

	Local nI := 0
	Local nThread := 0
	Local nTotThread := 0
	
	dbSelectArea('SX2')
	dbGoBottom()
	
	While SX2->( .NOT. BOF() )
		For nI := 1 To 30
			AAdd( aProc, SX2->X2_CHAVE )
			SX2->( dbSkip( -1 ) )
		Next nI
		
		nThread := 0
		nTotThread:=0
		For nI := 1 To Len( aProc )
			////Faz distribuição e monitora a quantidade de thread em execução
			//nThread := 0
			//aUsers := GetUserInfoArray()
			//aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_DOPROC" .OR. ALLTRIM(UPPER(x[5])) == "PRC", nThread++, NIL )})
			
			If nThread <= 10
				nTotThread ++
				nThread ++
				CONOUT( '*** Distribuicao de Threads.  Limpar em 30/' + alltrim(str(nTotThread)) + '    limitar distribuição em 10/'+ alltrim(str(nThread))  )
				StartJob( 'U_DOPROC', GetEnvServer(), .F., aProc[ nI ], xEmp, xFil )
				
			Else
					CONOUT( '*** Aguardando Liberação de threads.  Total de threads ' + alltrim(str(nTotThread)) + ' distribuidas '+ alltrim(str(nThread))  )
					Sleep(5000)
					nThread := 0
					aUsers := GetUserInfoArray()
					aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_DOPROC" .OR. ALLTRIM(UPPER(x[5])) == "PRC", nThread++, NIL )})
			    	NI:=NI-1
			Endif
			
		    If nTotThread >= 30                           
				CONOUT( '*** limpando memória apos total de Threads = ' + alltrim(str(nTotThread))  )
				DelClassIntf()
				nTotThread := 0
			EndIf
		Next nI
		aProc := {}
	End
	Conout("Ufa!!! acabei")
	Alert("Ufa!!! acabei")
Return

User Function DOPROC( cTab, xEmp, xFil )
	Local bOldBlock	:= nil
	Local cErrorMsg	:= ""
	
	//TRATAMENTO PARA ERRO FATAL NA THREAD
	cErrorMsg := ""
	bOldBlock := ErrorBlock({|e| U_ProcError(e) })
	
	CONOUT( '***' + cTab + 'ini' )
	
	
		//Abre empresa para Faturamento
		RpcSetType(3)
		RpcSetEnv( xEmp, xFil )

		dbSelectArea( cTab )
		dbCloseArea()
	
	ErrorBlock(bOldBlock)
	cErrorMsg := U_GetProcError()
	If !empty(cErrorMsg)
		Conout("Inconsistecia no processamento: "+ cTab + Chr(13) + Chr(10) + cErrorMsg)
	else	
			CONOUT( '***' + cTab + 'Fim' )
	EndIf
Return
