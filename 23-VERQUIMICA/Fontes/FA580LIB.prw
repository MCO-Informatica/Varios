#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: FA580LIB   | Autor: Celso Ferrone Martins | Data: 14/01/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function FA580LIB()

Local lRet       := .T.
Local cVqFinLibe := AllTrim(GetMv("VQ_FINLIBE"))
Local cUsrAtual  := Upper(AllTrim(UsrRetName(__cUserId)))

If cUsrAtual $ cVqFinLibe
	lRet := .T.
Else
	lRet := .F.
	MsgAlert("Usuario sem permissao para liberar pagamento.","VQ_FINLIBE !!!")
EndIf

Return(lRet)