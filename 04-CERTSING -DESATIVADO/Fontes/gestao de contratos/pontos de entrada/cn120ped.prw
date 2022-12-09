#INCLUDE "PROTHEUS.CH"
STATIC lNewCP610 := IIf( FindFunction( 'U_NewCP610' ) , U_NewCP610() , .F. )
//Ponto de entrada chamado na realizacao da medicao rotina CNTA120
//utilizado para acrescentar campos de usuario no exec auto do pedido de vendas
//Caso nao exista apresenta erro no momento da geracao. 
//criado por Erik dia 23/02/11 deve ser compilado apos liberacao Bianca.

User Function CN120PED()
	Local aCabec := AClone( ParamIXB[ 1 ] )
	Local aItens := AClone( ParamIXB[ 2 ] )
	Local cNaturez	:= GetNewPar( "MV_XNATCLI", "FT010010" )
	Local cEspCtr := Iif( Empty( CN9->CN9_CLIENT ), "1", "2" )
	Local aReturn := {}
	Local nP := 0
	Local aPar := {}
	Local aRet := {}
	Local aArea := {}
	
	aArea := { GetArea(), CN1->( GetArea() ), CN9->( GetArea() ), CNA->( GetArea() ), CND->( GetArea() ), CNE->( GetArea() ) }
	
	If lNewCP610
		If cEspCtr == '2'
			nP := AScan( aCabec, {|p| p[ 1 ] == 'C5_CONDPAG' } )
			AAdd( aCabec,{ "C5_XNATURE", cNaturez, NIL } )
		Endif
	Else
		If cEspCtr == '1'
		   nP := AScan( aCabec, {|p| p[1]=='C7_COND'})
		Else
			nP := AScan( aCabec, {|p| p[1]=='C5_CONDPAG'})
			aadd(aCabec,{"C5_XNATURE",cNaturez,nil})
		Endif	
		If nP > 0
		  	If MsgYesNo('Modificar a condição de pagamento?','CN120PED')
		  		AAdd(aPar,{1,"Código Cond. Pagto.",Space(Len(SE4->E4_CODIGO)),"","","SE4","",0,.T.})
		  		If ParamBox(aPar,"Condição de Pagamento",@aRet)
		  			If aCabec[ nP, 2 ] <> aRet[ 1 ]
		  				aCabec[ nP, 2 ] := aRet[ 1 ] 
		  			Endif
		  	   Endif
		  	Endif
		Endif
	Endif
	AAdd( aReturn, aCabec )
	AAdd( aReturn, aItens )
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( aReturn )