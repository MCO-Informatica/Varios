# include 'protheus.ch'

#DEFINE DEF_SVIGE "05" //Vigente

User Function CN100FOL()
Local nOpc		:= ParamIxb[1]
Local aCpoNH 	:= {"CNX_CONTRA","CNX_CLIENT","CNX_LOJACL"}
Local aSize     := MsAdvSize()
Local aPosObj   := {}
Local aObjects  := {}
Local nGd1 		:= 0
Local nGd2 		:= 0
Local nGd3 		:= 0
Local nGd4 		:= 0
Local lVisAprCt := .F.   

Local cParcela		:= "001" 
Local cTipo			:= "PA " 

Local nCNX_PREFIX	:= 0
Local nCNX_NUMTIT	:= 0 
Local nCNX_FORNEC 	:= 0           
Local nCNX_LJFORN	:= 0 
Local nCNX_XVLSOM	:= 0
Local nX			:= 0

If nOpc == 2	// Visualiza

	nCNX_PREFIX	:= Ascan( aHeader7, { |x| Alltrim( x[2] ) == 'CNX_PREFIX'})
	nCNX_NUMTIT	:= Ascan( aHeader7, { |x| Alltrim( x[2] ) == 'CNX_NUMTIT'}) 
	nCNX_FORNEC := Ascan( aHeader7, { |x| Alltrim( x[2] ) == 'CNX_FORNEC'})           
	nCNX_LJFORN	:= Ascan( aHeader7, { |x| Alltrim( x[2] ) == 'CNX_LJFORN'}) 
	nCNX_XVLSOM	:= Ascan( aHeader7, { |x| Alltrim( x[2] ) == 'CNX_XVLSOM'})	

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monta a Tela Principal										 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aObjects := {}
	aAdd( aObjects, {   0, 119, .t., .t. } )
	aAdd( aObjects, { 120, 101, .t., .t. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects ) 
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Define as posicoes da Getdados a partir do folder    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nGd1 := 2
	nGd2 := 2
	nGd3 := aPosObj[2,3]-aPosObj[2,1]-15
	nGd4 := aPosObj[2,4]-aPosObj[2,2]-2
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё CNX - Adiantamento de Contrato                  Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддды
	CN100LdAl(nOpc,"CNX",aCols7,aHeader7,"CNX.CNX_CONTRA = '"+ M->CN9_NUMERO +"' AND CNX.CNX_XORIGE = ' '",{"CNX_NUMERO"},oGetDad7,aCpoNH) 

	For nX:=1 To Len( aCols7 )  
		nSaldoTit	:= GetAdvFval("SE2","E2_SALDO",xFilial("SE2")+aCols7[nX][nCNX_PREFIX]+aCols7[nX][nCNX_NUMTIT]+cParcela+cTipo+aCols7[nX][nCNX_FORNEC]+aCols7[nX][nCNX_LJFORN],1)	
	   	aCols7[nX][nCNX_XVLSOM]	:= nSaldoTit
	Next 
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monta folder Dos  Adiantamentos                      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oGetDad7 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,0,,,,,,,,,,oFolder:aDialogs[7],aHeader7,aCols7)
	
EndIf

Return()