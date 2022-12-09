#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "SET.CH" 


User Function ValidaOrc()    
	Local _lRet := .T.

	Local nMaxArray     := Len(aCols) //luiz
	Local nPos      := 0 //luiz
	Local Vdel :=.F.

	Cont:= nMaxArray  
	While Cont > 1 
		cProduto1 := aCols[nMaxArray,GDFieldPos("UB_PRODUTO")]
		cProduto2 := aCols[(Cont-1),GDFieldPos("UB_PRODUTO")]

		cONU1 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1__CODONU" )
		cLinha1 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1_SEGMENT" )     

		cONU2 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2, "B1__CODONU" )
		cLinha2 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2, "B1_SEGMENT" )

		If cLinha1 $ "000005|000006|000007" .and. !Empty( cONU2 ) .and. cLinha1 <> cLinha2
			Alert (" Produto: " + cProduto1 + " Incompativel Com Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
			_lRet := .F.
		Endif   

		If cLinha2 $ "000005|000006|000007" .and. !Empty( cONU1 ) .and. cLinha1 <> cLinha2 
			Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
			_lRet := .F.
		Endif  

		ZAA->( dbSetOrder( 1 ) )
		If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )
			Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
			_lRet := .F.
		Endif

		If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )
			Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
			_lRet := .F.
		Endif

		ZAA->( dbSetOrder( 2 ) )
		If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )
			Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
			_lRet := .F.
		Endif

		If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )
			Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
			_lRet := .F.
		Endif

		Cont := Cont-1
	enddo

	//If Type("oGetDad") == "O"
	//	oGetDad:oBrowse:Refresh()
	//EndIf

Return _lRet
