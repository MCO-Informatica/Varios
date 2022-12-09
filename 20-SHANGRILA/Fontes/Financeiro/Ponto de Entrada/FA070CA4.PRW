#include "protheus.ch"

User Function FA070CA4()

Local _nomeuser	:= Alltrim(substr(cusuario,7,15)) 
Local _BloqUser	:= GETMV("MV_CANCBAI")

If _nomeuser $ _BloqUser
   	cFiltraSA1 := .F.                      
   	alert("Usuário sem permissão para executar essa rotina")
Else
	cFiltraSA1 := .T.
Endif

Return(cFiltraSA1)
