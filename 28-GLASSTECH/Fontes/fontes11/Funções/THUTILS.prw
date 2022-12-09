#Include 'Protheus.ch'

Static _version := '0.1'
Static ERR_IX := 1
Static ERR_MENS_IX := 2

User Function THUTILS()
	Alert('Versão ' + _version)
Return

// Retorna estrutura da tabela requisitada
// Os espaços [1] e [2] do array são reservados para erro e mensagem de erro respectivamente
user function GetTStru(cTableName)
	local _aStruct := {"Error", ""}
	local i := 1
	
	if AllTrim(cTableName) == ""
		_aStruct[2] := "Nenhuma tabela informada"
		return _aStruct
	endif
	
	dbSelectArea("SX3")
	dbsetorder(1)
	dbseek(cTableName)
	
	while (!eof() .and. AllTrim(SX3->X3_ARQUIVO) == AllTrim(cTableName))
		aAdd(_aStruct, {X3_ARQUIVO, X3_ORDEM, X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_TITULO, X3_DESCRIC, X3_CBOX})
		dbskip()
	enddo
return _aStruct

// Retorna as informações do usuãrio
User Function GetUInfo(cUserNam, cSenhaV)
	//Local oUsr
	Local _aUser := {"Error", ""}
	Local _aUsr
	
	//oUsr := UserControl():New()
	
	PswOrder(2)
	if PswSeek(cUserNam, .T.)
		_aUsr := PswRet(1)
		
		if !PswName(cSenhaV)	
			_aUser[2] := "Usuário ou senha inválidos"
			return _aUser
		endif
	else
		_aUser[2] := "Usuário ou senha inválidos"
		return _aUser
	endif
	
	dbSelectArea("ZZC")
	dbSetOrder(1)
	dbSeek(xFilial() + _aUsr[1][1])
	
	aAdd(_aUser, {_aUsr[1][1], AllTrim(_aUsr[1][14]), 1, AllTrim(ZZC->ZZC_VEND)})
	
Return _aUser