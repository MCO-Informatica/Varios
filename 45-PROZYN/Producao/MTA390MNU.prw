#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao	 ณ RESTE001 ณ Autor ณ Adriano Leonardo    ณ Data ณ 11/07/2016 ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada na tela de manuten็ใo de lotes para adi-  บฑฑ
ฑฑบ          ณ cionar novos bot๕es em outras a็๕es.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn               			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function MTA390MNU()

Local cCodUser  := RetCodUsr()
Local cUsersPar :=U_MyNewSX6("CV_USRATV", ""	,"C","Usuarios autorizados a incluir/alterar atividade enzimatica", "", "", .F. ) 
Local cUsersObs :=U_MyNewSX6("CV_USROBS", ""	,"C","Usuarios autorizados a incluir/alterar observa็๕es", "", "", .F. )

//Verifico se a rotina estแ compilada
If ExistBlock("RESTE001") .And. Alltrim(cCodUser) $ Alltrim(cUsersPar)	
	AAdd(aRotina,{"Atividade" ,"U_RESTE001"  ,0,3,0,nil})	
EndIf

//Verifico se a rotina estแ compilada
If ExistBlock("RESTE003") .And. Alltrim(cCodUser) $ Alltrim(cUsersObs)
	AAdd(aRotina,{"Observa็๕es" ,"U_RESTE003",0,3,0,nil})
EndIf

Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMyNewSX6  บAutor  ณMicrosiga	          บ Data ณ  25/03/2017บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria parametro no SX6                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 	                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MyNewSX6( cMvPar, xValor, cTipo, cDescP, cDescS, cDescE, lAlter , lFilial)

Local aAreaAtu	:= GetArea()
Local lRecLock	:= .F.
Local xlReturn

Default lAlter 	:= .F.
Default lFilial	:= .F.

If ( ValType( xValor ) == "D" )
	If " $ xValor
		xValor := Dtoc( xValor, "ddmmyy" )
	Else
		xValor	:= Dtos( xValor )
	Endif
ElseIf ( ValType( xValor ) == "N" )
	xValor	:= AllTrim( Str( xValor ) )
ElseIf ( ValType( xValor ) == "L" )
	xValor	:= If ( xValor , ".T.", ".F." )
EndIf

DbSelectArea('SX6')
DbSetOrder(1)

If lFilial
	lRecLock := !MsSeek( cFilAnt + Padr( cMvPar, Len( X6_VAR ) ) )
Else
	lRecLock := !MsSeek( Space( Len( X6_FIL ) ) + Padr( cMvPar, Len( X6_VAR ) ) )
EndIf

If lRecLock
	
	RecLock( "SX6", lRecLock )
	
	If lFilial
		FieldPut( FieldPos( "X6_FIL" ), cFilAnt )	
	EndIf
		
	FieldPut( FieldPos( "X6_VAR" ), cMvPar )
	
	FieldPut( FieldPos( "X6_TIPO" ), cTipo )
	
	FieldPut( FieldPos( "X6_PROPRI" ), "U" )
	
	If !Empty( cDescP )
		FieldPut( FieldPos( "X6_DESCRIC" ), SubStr( cDescP, 1, Len( X6_DESCRIC ) ) )
		FieldPut( FieldPos( "X6_DESC1" ), SubStr( cDescP, Len( X6_DESC1 ) + 1, Len( X6_DESC1 ) ) )
		FieldPut( FieldPos( "X6_DESC2" ), SubStr( cDescP, ( Len( X6_DESC2 ) * 2 ) + 1, Len( X6_DESC2 ) ) )
	EndIf
	
	If !Empty( cDescS )
		FieldPut( FieldPos( "X6_DSCSPA" ), cDescS )
		FieldPut( FieldPos( "X6_DSCSPA1" ), SubStr( cDescS, Len( X6_DSCSPA1 ) + 1, Len( X6_DSCSPA1 ) ) )
		FieldPut( FieldPos( "X6_DSCSPA2" ), SubStr( cDescS, ( Len( X6_DSCSPA2 ) * 2 ) + 1, Len( X6_DSCSPA2 ) ) )
	EndIf
	
	If !Empty( cDescE )
		FieldPut( FieldPos( "X6_DSCENG" ), cDescE )
		FieldPut( FieldPos( "X6_DSCENG1" ), SubStr( cDescE, Len( X6_DSCENG1 ) + 1, Len( X6_DSCENG1 ) ) )
		FieldPut( FieldPos( "X6_DSCENG2" ), SubStr( cDescE, ( Len( X6_DSCENG2 ) * 2 ) + 1, Len( X6_DSCENG2 ) ) )
	EndIf
	
	If lRecLock .Or. lAlter
		FieldPut( FieldPos( "X6_CONTEUD" ), xValor )
		FieldPut( FieldPos( "X6_CONTSPA" ), xValor )
		FieldPut( FieldPos( "X6_CONTENG" ), xValor )
	EndIf
	
	MsUnlock()
	
EndIf

xlReturn := GetNewPar(cMvPar)

RestArea( aAreaAtu )


Return(xlReturn)	

