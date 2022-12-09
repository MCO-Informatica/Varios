#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function zPesqEMR()
	Local _cRetorno 
	Local cUser := alltrim(RetCodUsr())

    _cRetorno := UsrRetMail(cUser)

	/*PswOrder(2)
	If PswSeek(cUser, .T. )
		_cRetorno := alltrim(PSWRET()[1][12])
	endif*/

	MsgInfo(_cRetorno)

	/*If !EMPTY(cIDREC)
        M->ZZO_RECEMA := cEmail
	  	_cRetorno := cEmail
	Else
	  	MsgAlert("E-mail nao cadastro, solicite cadastro ao Administrador", "Westech")
        _cRetorno := ""  
	End if*/
    
Return // ( _cRetorno )
