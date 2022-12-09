#Include 'Protheus.ch'

User Function zZZO_IDResp()
Local _cRetorno 
Local cEmail
Local cIDENTR := M->ZZO_IDRESP

    cEmail := UsrRetMail(cIDENTR)
	
	If !EMPTY(cEmail)
	  	_cRetorno := cEmail
	Else
	  	MsgAlert("E-mail nao cadastro, solicite cadastro ao Administrador", "Westech")
        _cRetorno := ""  
	End if
    
Return ( _cRetorno )
