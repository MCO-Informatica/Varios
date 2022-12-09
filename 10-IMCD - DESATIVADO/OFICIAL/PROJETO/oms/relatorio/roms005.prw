#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROMS005   ºAutor  ³  Daniel   Gondran  º Data ³  17/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de controle de frete                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ROMS005

	Local nOpcA       := 0
	Local aSays       := {}
	Local aButtons    := {} 
	Local cCadastro   := "Relatorio de Controle de Frete"
	Local cPerg       := "ROMS05" 

	Pergunte( cPerg, .F.)

	aAdd( aSays, "Essa rotina efetua a geracao da planilha de " )
	aAdd( aSays, "controle de frete" )

	aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
	aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
	aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1
		Processa( { || ROMS005Proc() }, "Gerando Controle de Frete" )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROMS005   ºAutor  ³  Daniel   Gondran  º Data ³  17/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ROMS005Proc

	Local aAreaAtu := GetArea()
	Local nCount := 0

	Local aCabec 	:= {}
	Local aDados 	:= {}      
	Local aTrans 	:= {}
	Local aDados2	:= {}
	Local nRecno  
	Local cChave
	Local nQuant
	Local cUm
	Local lEnt,lSai
	Local nX := 0

	dbSelectArea("SD1")
	dbSetOrder(3)
	dbSeek(xFilial("SD1") + Dtos(MV_PAR03))
	do While !Eof() .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_EMISSAO <= MV_PAR04
		If Empty(SD1->D1_VEIC)
			SD1->(dbSkip())
			Loop
		Endif

		If SD1->D1_VEIC < MV_PAR06 .OR. SD1->D1_VEIC > MV_PAR07
			SD1->(dbSkip())
			Loop
		Endif

		If SD1->D1_FORNECE < MV_PAR01 .OR. SD1->D1_FORNECE > MV_PAR02
			SD1->(dbSkip())
			Loop
		Endif

		nCount++
		nQuant 	:= 0  
		lEnt	:= .F.
		lSai	:= .F.

		//Veiculo
		dbSelectArea("DA3")
		dbSetOrder(1)
		dbSeek(xFilial("DA3") + SD1->D1_VEIC)

		//Transportadora
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2") + SD1->D1_FORNECE + SD1->D1_LOJA)

		// Entrada
		If !Empty(SD1->D1_NFRENT)  
			nRecno 	:= SD1->( Recno() )
			lEnt := .T.
			cChave := SD1->D1_NFRENT + SD1->D1_SERENT
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbSeek(xFilial("SD1") + cChave)
			cUm := SD1->D1_UM
			do While !Eof() .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC + SD1->D1_SERIE == cChave
				nQuant += SD1->D1_QUANT
				SD1->(dbSkip()) 
			Enddo
			SD1->( dbGoto(nRecno) )
		Endif


		// Saida
		If !Empty(SD1->D1_NFRSAI)  
			lSai := .T.
			cChave := SD1->D1_NFRSAI + SD1->D1_SERSAI
			dbSelectArea("SD2")
			dbSetOrder(3)
			dbSeek(xFilial("SD2") + cChave)
			cUm := SD2->D2_UM
			do While !Eof() .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC + SD2->D2_SERIE == cChave
				nQuant += SD2->D2_QUANT
				SD2->(dbSkip()) 
			Enddo
		Endif

		aAdd( aDados, {	SA2->A2_COD + "-" + SA2->A2_LOJA + " - " + SA2->A2_NREDUZ,;   	//01
		DA3->DA3_COD + "-" + DA3->DA3_DESC,;                          	//02
		DA3->DA3_PLACA,;                                               	//03
		SD1->D1_TOTAL,;                                                	//04
		SD1->D1_EMISSAO,;                                              	//05
		Substr(cChave,1,9) + "/" + Substr(cChave,10,3),;              	//06
		IIF(lEnt, "E", IIF(lSai, "S", "*")),;                         	//07
		nQuant,;                                                       	//08
		cUM,;                                                          	//09
		DA3->DA3_CAPACN,;                                             	//10
		( nQuant / DA3->DA3_CAPACN ) * 100,;                         	//11
		SD1->D1_TOTAL / nQuant })                                    	//12	

		dbSelectArea("SD1")
		dbSetOrder(3)
		dbSkip()
	Enddo   

	If MV_PAR05 == 2
		For nX := 1 to Len (aDados)
			If Ascan(aTrans,aDados[nX,1]) == 0
				Aadd(aTrans,aDados[nX,1])     
				Aadd(aDados2, aDados[nX])
			Else             
				aDados2[Ascan(aTrans,aDados[nX,1]),04] += aDados[nX,04]
				aDados2[Ascan(aTrans,aDados[nX,1]),08] += aDados[nX,08]
				aDados2[Ascan(aTrans,aDados[nX,1]),10] += aDados[nX,10]
			Endif
		Next
	Endif

	If MV_PAR05 == 3
		For nX := 1 to Len (aDados)
			If Ascan(aTrans,aDados[nX,2]) == 0
				Aadd(aTrans,aDados[nX,2])     
				Aadd(aDados2, aDados[nX])
			Else             
				aDados2[Ascan(aTrans,aDados[nX,2]),04] += aDados[nX,04]
				aDados2[Ascan(aTrans,aDados[nX,2]),08] += aDados[nX,08]
				aDados2[Ascan(aTrans,aDados[nX,2]),10] += aDados[nX,10]
			Endif
		Next
	Endif


	For nX := 1 to Len (aDados2)	
		If MV_PAR05 == 2
			aDados2[nX,2] := " "
			aDados2[nX,3] := " "
		Endif
		If MV_PAR05 == 3
			aDados2[nX,1] := " "
		Endif
		aDados2[nX,05] := ""
		aDados2[nX,05] := ""
		aDados2[nX,06] := ""
		aDados2[nX,07] := ""	
		aDados2[nX,09] := ""			
		aDados2[nX,11] := ( aDados2[nX,08] / aDados2[nX,10] ) * 100
		aDados2[nX,12] := aDados2[nX,04] / aDados2[nX,08]
	Next


	If nCount == 0
		MsgStop( "Não foram encontrados dados para os parametros informados. Verifique os Parametros" )
		Return
	Endif

	aAdd( aCabec, "Transportadora")
	aAdd( aCabec, "Veiculo" )
	aAdd( aCabec, "Placa" )
	aAdd( aCabec, "Valor" )
	aAdd( aCabec, "Data" )
	aAdd( aCabec, "Serie/Nota Fiscal" )
	aAdd( aCabec, "Tipo NF" )
	aAdd( aCabec, "Volume" )
	aAdd( aCabec, "UM" )
	aAdd( aCabec, "Capac. Nominal" )
	aAdd( aCabec, "% utilização" )
	aAdd( aCabec, "Frete/Kg" )

	DlgToExcel( { { "ARRAY", "Controle Frete", aCabec, Iif(MV_PAR05 == 1, aDados, aDados2) } } ) 

	RestArea( aAreaAtu )

Return()