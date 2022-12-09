#INCLUDE 'PROTHEUS.CH'

STATIC __LOCKID := ''
STATIC __INLOCK := 0

/* --------------------------------------------------------------------------
Casca para lock de numero de pedido GAR para processo
Atualmente utiliza license Server, com lockbyname
-------------------------------------------------------------------------- */
// Prende o lock
USER Function GarLock(cChvBPag)

Local lOk := .F.
Local cLockID := "PROCJOB_"+Alltrim(cChvBPag)

If Empty(cChvBPag)
//	conout("[GARLOCK][Thread "+alltrim(str(threadid()))+"]["+time()+"]["+cLockID+"] EMPTY ID")
	Return(.F.)
Endif

If __INLOCK > 0
	// Ja tem o lock, soma 1 e retorna .t.
	__INLOCK++
	Return .T.
Endif

If __INLOCK == 0
	// Contador zero, primeiro lock
	lOk := LockByName(cLockID,.F.,.F.)
	If lOk
		// conseguiu o lock, soma 1 e retorna
		__INLOCK++
		__LOCKID := cLockID
//		conout("[GARLOCK][Thread "+alltrim(str(threadid()))+"]["+time()+"]["+cLockID+"] OK")
	Else
//		conout("[GARLOCK][Thread "+alltrim(str(threadid()))+"]["+time()+"]["+cLockID+"] FAILED")
	Endif
Endif

Return lOk

// Soltar o lock
USER Function GarUnlock(cChvBPag)

Local cLockID := "PROCJOB_"+Alltrim(cChvBPag)

IF __INLOCK == 0
	// Uai, soltou sem ter o lock ???
//	conout("[GARUNLOCK][Thread "+alltrim(str(threadid()))+"]["+time()+"]["+cLockID+"] UNLOCK WITHOUT LOCK")
	Return
Endif

// Subtrai um do contador
__INLOCK--
IF __INLOCK == 0
	// Chegou a zero, agora sim solta o lock
//	conout("[GARUNLOCK][Thread "+alltrim(str(threadid()))+"]["+time()+"]["+cLockID+"]")
	UnLockByName(__LOCKID,.F.,.F.)
	// Reseta variaveis de contagem
	__LOCKID := ''
	__INLOCK := 0
Endif

Return





// ABAIXO ESTAO AS FUNCOES ANTIGAS


/* --------------------------------------------------------------------------
Casca para lock de numero de pedido GAR para processo
Versao utilizando lock em disco com arquivo na pasta de semaforo
-------------------------------------------------------------------------- */
/*

STATIC __LockHnd := -1 
STATIC __LockFile := ''

USER Function GarLock(cChvBPag)

If Empty(cChvBPag)
	Return(.F.)
Endif

__LockFile := "\semaforo\PROCJOB_"+Alltrim(cChvBPag)+".lck"
__LockHnd := fcreate(__LockFile)

If ( __LockHnd < 0 ) 
	conout("[GARLOCK]["+time()+"]["+__LockFile+"] FAILED - FERROR "+str(ferror(),4))
	Return .F.
Endif

conout("[GARLOCK]["+time()+"]["+__LockFile+"] OK")

Return .T.


USER Function GarUnlock(cChvBPag)
If __LockHnd <> -1
	fclose(__LockHnd) 	// fecha o handler
	ferase(__LockFile) 	// apaga o arquivo
	__LockHnd := -1  
	__LockFile := ''
	conout("[GARUNLOCK]["+time()+"]["+__LockFile+"] OK")
	Return .T.  		// Lock solto com sucesso
Endif
conout("[GARUNLOCK]["+time()+"]["+__LockFile+"] ALREADY UNLOCKED.")
Return .F.     // Lock ja estava solto ...


*/


/* --------------------------------------------------------------------------
Casca para lock de numero de pedido GAR para processo
Atualmente utiliza license Server, com lockbyname
-------------------------------------------------------------------------- */
/*
USER Function GarLock(cChvBPag)
Local lOk
Local cLockID := "PROCJOB_"+Alltrim(cChvBPag)
Local nStack := 0

If Empty(cChvBPag)
	Return(.F.)
Endif

lOk := LockByName(cLockID,.F.,.F.)
If lOk
	conout("[GARLOCK][Thread "+alltrim(str(threadid()))+"]["+time()+"]["+cLockID+"] OK")
Else
	conout("[GARLOCK][Thread "+alltrim(str(threadid()))+"]["+time()+"]["+cLockID+"] FAILED")
Endif

For nStack := 2 to 15
	If !empty(procname(nStack))
		conout('Called From '+padr(procname(nStack),30) + " "+str(procline(nStack),6,0))
	Endif
Next

Return lOk


USER Function GarUnlock(cChvBPag)
Local cLockID := "PROCJOB_"+Alltrim(cChvBPag)
Local nStack := 0
conout("[GARUNLOCK][Thread "+alltrim(str(threadid()))+"]["+time()+"]["+cLockID+"]")
For nStack := 2 to 15
	If !empty(procname(nStack))
		conout('Called From '+padr(procname(nStack),30) + " "+str(procline(nStack),6,0))
	Endif
Next
UnLockByName(cLockID,.F.,.F.)
Return
*/
