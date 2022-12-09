#include 'Protheus.ch'

/*/{Protheus.doc} CSFA900
//TODO - Rotina para gravar usu�rio/senha criptografados em par�metro SX6.
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
	Private cCadastro := 'Cadastrar Usu�rio/Senha'
	
	AAdd( aSay, 'Rotina para efetuar manuten��o em usu�rio/senha gravado como par�metro.' )
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
//TODO - Rotina que solicita o nome do par�metro.
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
	
	//AAdd( aButton, { 5, {|| Iif( Empty(MV_PAR01), MsgInfo( 'Informe o nome do par�metro.', cCadastro ), ( U_A900Reset( MV_PAR01 ) ) ) }, 'Eliminar o conte�do do par�metro usu�rio/senha...' } )
	
	dbSelectArea( 'SX6' )
	SX6->( dbSetOrder( 1 ) )
	
	AAdd( aPar, { 1, 'Par�metro',Space(Len(SX6->X6_VAR)),'@!','','','',60,.T.})
	If ParamBox( aPar, 'Informe o par�metro', @aRet,,/*aButton*/,,,,,, .F., .F. )
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
//TODO - Rotina que solicita o conte�do atual e o novo que ser� gravado.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces2()
	Local aPar := {}
	Local aRet := {}
	AAdd( aPar, { 8, 'Usu�rio/Senha atual'     ,Space(25),'','Texto()','','',90,.T.})
	AAdd( aPar, { 8, 'Novo usu�rio/senha'      ,Space(25),'','Texto()','','',90,.T.})
	AAdd( aPar, { 8, 'Confirme a usu�rio/senha',Space(25),'','Texto() .AND. U_A900Vld()','','',90,.T.})
	If ParamBox( aPar, 'Manuten��o no usu�rio/senha', @aRet,,,,,,,, .F., .F. )
		If DeCode64(Embaralha(StrTran(StrTran(StrTran(StrTran(AllTrim(SX6->X6_CONTEUD),Chr(131),''),Chr(254),''),Chr(216),''),Chr(163),''),1)) == RTrim( aRet[ 1 ] )
			c900Pass := RTrim( aRet[ 2 ] )
			updatePar()
		Else
			MsgAlert('Usu�rio/senha atual n�o confere com o usu�rio/senha armazenado.', cCadastro )
		Endif
	Endif
Return

/*/{Protheus.doc} A900Vld
//TODO - Rotina para validar a digita��o.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function A900Vld()
	If MV_PAR01 == MV_PAR02
		MsgAlert('Usu�rio/senha atual n�o pode ser igual a novo usu�rio/senha.', cCadastro )
		Return( .F. )
	Elseif MV_PAR02 <> MV_PAR03
		MsgAlert('A confirma��o do usu�rio/senha precisa ser igual a novo usu�rio/senha.', cCadastro )
		Return( .F. )
	Endif
Return

/*/{Protheus.doc} goProces3
//TODO Rotina que solicita a descri��o do par�metro.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces3()
	Local aPar := {}
	Local aRet := {}
	AAdd( aPar,{ 11,'Descri��o do par�metro','','.T.','.T.',.T.})
	If ParamBox( aPar, 'Informe o par�metro', @aRet,,,,,,,, .F., .F. )
		c900Desc := AllTrim( aRet[ 1 ] )
		goProces4()
	Endif
Return

/*/{Protheus.doc} goProces4
//TODO - Rotina que solicita o conte�do que ser� gravado.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces4()
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 8, 'Usu�rio/Senha'           ,Space(25),'','Texto()','','',90,.T.})
	AAdd( aPar, { 8, 'Confirme o usu�rio/senha',Space(25),'','(MV_PAR02==MV_PAR01)','','',90,.T.})
	If ParamBox( aPar, 'Cadastre o usu�rio/senha', @aRet,,,,,,,, .F., .F. )
		If aRet[ 1 ] == aRet[ 2 ] .AND. .NOT. Empty( aRet[ 1 ] ) .AND. .NOT. Empty( aRet[ 2 ] )
			c900Pass := RTrim( aRet[ 1 ] )
			insertPar()
		Else
			MsgAlert('Usu�rio/senha n�o confere.', cCadastro )
		Endif
	Endif
Return

/*/{Protheus.doc} goProces5
//TODO - Rotina que solicita o conte�do que ser� gravado.
@author robson.goncalves
@since 08/02/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function goProces5()
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 8, 'Usu�rio/Senha'           ,Space(25),'','Texto()','','',90,.T.})
	AAdd( aPar, { 8, 'Confirme o usu�rio/senha',Space(25),'','(MV_PAR02==MV_PAR01)','','',90,.T.})
	If ParamBox( aPar, 'Cadastre o usu�rio/senha', @aRet,,,,,,,, .F., .F. )
		If aRet[ 1 ] == aRet[ 2 ] .AND. .NOT. Empty( aRet[ 1 ] ) .AND. .NOT. Empty( aRet[ 2 ] )
			c900Pass := RTrim( aRet[ 1 ] )
			updatePar()
		Else
			MsgAlert('Usu�rio/senha n�o confere.', cCadastro )
		Endif
	Endif
Return

/*/{Protheus.doc} insertPar
//TODO - Rotina que cria o par�metro e seu conte�do criptografado.
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
	MessageBox('Usu�rio/Senha gravado com sucesso.',cCadastro,0)
Return

/*/{Protheus.doc} updatePar
//TODO - Rotina que atualiza o conte�do criptografado.
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
	MessageBox('Usu�rio/Senha gravado com sucesso.',cCadastro,0)
Return

/*/{Protheus.doc} A900Reset
//TODO - Rotina que limpa o conte�do do par�metro.
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
		MsgAlert( 'O par�metro informado est� sem conte�do, logo n�o ser� efetuado o reset.', cCadastro )
	Else
		If MsgYesNo('Esta a��o ir� apagar o conte�do do par�metro, prosseguir?', cCadastro )
			SX6->( RecLock( 'SX6', .F. ) )
			SX6->X6_CONTEUD := ''
			SX6->( MsUnLock() )
			MessageBox( 'Reset efetuado com sucesso.', cCadastro, 0 )
		Else
			MsgInfo( 'Opera��o abortada.', cCadastro )
		Endif
	Endif
Return

/*/{Protheus.doc} loginUserPassword
//TODO Classe para recuperar o conte�do.
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
//TODO M�todo que contempla a referida classe.
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
	Private cCadastro := 'Recuperar Usu�rio/Senha'
	AAdd( aPar, { 1, 'Par�metro',Space(Len(SX6->X6_VAR)),'@!','','','',60,.T.})
	If ParamBox( aPar, 'Informe o par�metro', @aRet,,,,,,,, .F., .F. )
		oObj := loginUserPassword():get(aRet[1])
		MsgAlert( oObj:cReturn )
	Endif
Return
