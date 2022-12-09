#include 'Protheus.ch'

/*/{Protheus.doc} CSFA900
//TODO - Rotina para gravar usuário/senha criptografados em parâmetro SX6.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function CSFA900()
	Local aButton := {}
	Local aSay := {}
	
	Local nOpc := 0
	
	Private c900Par := ''
	Private c900Desc := ''
	Private c900Pass := ''
	Private cCadastro := 'Cadastrar Usuário/Senha'
	
	AAdd( aSay, 'Rotina para efetuar manutenção em usuário/senha gravado como parâmetro.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		goProces1()
	Endif
Return

/*/{Protheus.doc} goProces1
//TODO - Rotina que solicita o nome do parâmetro.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces1()
	Local aButton := {}
	Local aPar := {}
	Local aRet := {}
	
	//AAdd( aButton, { 5, {|| Iif( Empty(MV_PAR01), MsgInfo( 'Informe o nome do parâmetro.', cCadastro ), ( U_A900Reset( MV_PAR01 ) ) ) }, 'Eliminar o conteúdo do parâmetro usuário/senha...' } )
	
	dbSelectArea( 'SX6' )
	SX6->( dbSetOrder( 1 ) )
	
	AAdd( aPar, { 1, 'Parâmetro',Space(Len(SX6->X6_VAR)),'@!','','','',60,.T.})
	If ParamBox( aPar, 'Informe o parâmetro', @aRet,,/*aButton*/,,,,,, .F., .F. )
		c900Par := RTrim( aRet[ 1 ] ) 
		If SX6->( dbSeek( xFilial( 'SX6' ) + c900Par ) )
			If Empty( SX6->X6_CONTEUD )
				goProces5()
			Else
				goProces2()
			Endif
		Else
			goProces3()
		Endif 
	Endif
Return

/*/{Protheus.doc} goProces2
//TODO - Rotina que solicita o conteúdo atual e o novo que será gravado.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces2()
	Local aPar := {}
	Local aRet := {}
	AAdd( aPar, { 8, 'Usuário/Senha atual'     ,Space(25),'','Texto()','','',90,.T.})
	AAdd( aPar, { 8, 'Novo usuário/senha'      ,Space(25),'','Texto()','','',90,.T.})
	AAdd( aPar, { 8, 'Confirme a usuário/senha',Space(25),'','Texto() .AND. U_A900Vld()','','',90,.T.})
	If ParamBox( aPar, 'Manutenção no usuário/senha', @aRet,,,,,,,, .F., .F. )
		If DeCode64(Embaralha(StrTran(StrTran(StrTran(StrTran(AllTrim(SX6->X6_CONTEUD),Chr(131),''),Chr(254),''),Chr(216),''),Chr(163),''),1)) == RTrim( aRet[ 1 ] )
			c900Pass := RTrim( aRet[ 2 ] )
			updatePar()
		Else
			MsgAlert('Usuário/senha atual não confere com o usuário/senha armazenado.', cCadastro )
		Endif
	Endif
Return

/*/{Protheus.doc} A900Vld
//TODO - Rotina para validar a digitação.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function A900Vld()
	If MV_PAR01 == MV_PAR02
		MsgAlert('Usuário/senha atual não pode ser igual a novo usuário/senha.', cCadastro )
		Return( .F. )
	Elseif MV_PAR02 <> MV_PAR03
		MsgAlert('A confirmação do usuário/senha precisa ser igual a novo usuário/senha.', cCadastro )
		Return( .F. )
	Endif
Return

/*/{Protheus.doc} goProces3
//TODO Rotina que solicita a descrição do parâmetro.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces3()
	Local aPar := {}
	Local aRet := {}
	AAdd( aPar,{ 11,'Descrição do parâmetro','','.T.','.T.',.T.})
	If ParamBox( aPar, 'Informe o parâmetro', @aRet,,,,,,,, .F., .F. )
		c900Desc := AllTrim( aRet[ 1 ] )
		goProces4()
	Endif
Return

/*/{Protheus.doc} goProces4
//TODO - Rotina que solicita o conteúdo que será gravado.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces4()
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 8, 'Usuário/Senha'           ,Space(25),'','Texto()','','',90,.T.})
	AAdd( aPar, { 8, 'Confirme o usuário/senha',Space(25),'','(MV_PAR02==MV_PAR01)','','',90,.T.})
	If ParamBox( aPar, 'Cadastre o usuário/senha', @aRet,,,,,,,, .F., .F. )
		If aRet[ 1 ] == aRet[ 2 ] .AND. .NOT. Empty( aRet[ 1 ] ) .AND. .NOT. Empty( aRet[ 2 ] )
			c900Pass := RTrim( aRet[ 1 ] )
			insertPar()
		Else
			MsgAlert('Usuário/senha não confere.', cCadastro )
		Endif
	Endif
Return

/*/{Protheus.doc} goProces5
//TODO - Rotina que solicita o conteúdo que será gravado.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces5()
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 8, 'Usuário/Senha'           ,Space(25),'','Texto()','','',90,.T.})
	AAdd( aPar, { 8, 'Confirme o usuário/senha',Space(25),'','(MV_PAR02==MV_PAR01)','','',90,.T.})
	If ParamBox( aPar, 'Cadastre o usuário/senha', @aRet,,,,,,,, .F., .F. )
		If aRet[ 1 ] == aRet[ 2 ] .AND. .NOT. Empty( aRet[ 1 ] ) .AND. .NOT. Empty( aRet[ 2 ] )
			c900Pass := RTrim( aRet[ 1 ] )
			updatePar()
		Else
			MsgAlert('Usuário/senha não confere.', cCadastro )
		Endif
	Endif
Return

/*/{Protheus.doc} insertPar
//TODO - Rotina que cria o parâmetro e seu conteúdo criptografado.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function insertPar()
	dbSelectArea( 'SX6' )
	dbSetOrder( 1 ) 
	SX6->( RecLock( 'SX6', .T. ) )
	SX6->X6_FIL     := xFilial( 'SX6' )
	SX6->X6_VAR     := c900Par
	SX6->X6_TIPO    := 'C'
	SX6->X6_DESCRIC := SubStr( c900Desc, 1, 50 )
	SX6->X6_DESC1   := SubStr( c900Desc, 51, 50 )
	SX6->X6_DESC2   := SubStr( c900Desc, 101, 50 )
	SX6->X6_CONTEUD := Chr(131)+Chr(254)+Embaralha(EnCode64(c900Pass),0)+Chr(216)+Chr(163)
	SX6->X6_PROPRI  := 'U'
	SX6->( MsUnLock() )
	MessageBox('Usuário/Senha gravado com sucesso.',cCadastro,0)
Return

/*/{Protheus.doc} updatePar
//TODO - Rotina que atualiza o conteúdo criptografado.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function updatePar()
	SX6->( RecLock( 'SX6', .F. ) )
	SX6->X6_CONTEUD := Chr(131)+Chr(254)+Embaralha(EnCode64(c900Pass),0)+Chr(216)+Chr(163)
	SX6->( MsUnLock() )
	MessageBox('Usuário/Senha gravado com sucesso.',cCadastro,0)
Return

/*/{Protheus.doc} A900Reset
//TODO - Rotina que limpa o conteúdo do parâmetro.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}
@param cPar, characters, descricao
@type function
/*/
User Function A900Reset( cPar )
	dbSelectArea( 'SX6' )
	dbSetOrder( 1 )
	dbSeek( xFilial( 'SX6' ) + RTrim( cPar ) )
	If Empty( SX6->X6_CONTEUD )
		MsgAlert( 'O parâmetro informado está sem conteúdo, logo não será efetuado o reset.', cCadastro )
	Else
		If MsgYesNo('Esta ação irá apagar o conteúdo do parâmetro, prosseguir?', cCadastro )
			SX6->( RecLock( 'SX6', .F. ) )
			SX6->X6_CONTEUD := ''
			SX6->( MsUnLock() )
			MessageBox( 'Reset efetuado com sucesso.', cCadastro, 0 )
		Else
			MsgInfo( 'Operação abortada.', cCadastro )
		Endif
	Endif
Return

/*/{Protheus.doc} loginUserPassword
//TODO Classe para recuperar o conteúdo.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type class
/*/
CLASS loginUserPassword
	DATA cReturn
	METHOD get()
END CLASS

/*/{Protheus.doc} get
//TODO Método que contempla a referida classe.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}
@param cParam, characters, descricao
@type function
/*/
METHOD get( cParam ) CLASS loginUserPassword
	Local cCont := GetMv(cParam,.F.)
	Self:cReturn := DeCode64(Embaralha(StrTran(StrTran(StrTran(StrTran(cCont,Chr(131),''),Chr(254),''),Chr(216),''),Chr(163),''),1)) 
RETURN

/*/{Protheus.doc} MyTstUsr
//TODO Exemplo de uso da classe.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function A900MyTst()
	Local aPar := {}
	Local aRet := {}
	Local oObj
	Private cCadastro := 'Recuperar Usuário/Senha'
	AAdd( aPar, { 1, 'Parâmetro',Space(Len(SX6->X6_VAR)),'@!','','','',60,.T.})
	If ParamBox( aPar, 'Informe o parâmetro', @aRet,,,,,,,, .F., .F. )
		oObj := loginUserPassword():get(aRet[1])
		MsgAlert( oObj:cReturn )
	Endif
Return
