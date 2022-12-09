#include 'protheus.ch'
#include 'parmtype.ch'

//////////////////////////////////////////////////////////////////////////////////////////////
//+----------------------------------------------------------------------------------------+//
//| VALIDCLI  | Cadastro de Contatos e Busca | AUTOR | Claudio Correa  | DATA | 21/09/2016 |//
//+----------------------------------------------------------------------------------------+//
//| DESCRICAO | Verifica se o cliente esta bloqueado no campo A1_MSBLQL                    |//
//+----------------------------------------------------------------------------------------+//
//////////////////////////////////////////////////////////////////////////////////////////////

user function VALIDCLI(cCodCli)

Local lRet := .T.

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+cCodCli)

If SA1->(Found())

	If Val(SA1->A1_MSBLQL) <> 2
	
		Aviso( "Aviso", "Cliente encontra-se bloqueado!", {"Ok"} )
		
		lRet := .F.
		
	End If
	
Else

	Aviso( "Aviso", "O codigo de cliente informado não foi localizado, favor informar um codigo valido", {"Ok"} )
	
	lRet := .F.

End If

return lRet