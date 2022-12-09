/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPORTAR  ºAutor  ³Microsiga           º Data ³  11/27/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Importação dos dados do microsiga para           º±±
±±º          ³ Integrar com Sistema da fenix.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "Fileio.ch"

#Define CRLF  CHR(13)+CHR(10)

Static _cCodCli	
User Function Importar()

	Private nOpc      := 0
	Private cCadastro := "Exportação de dados."
	Private aSay      := {}
	Private aButton   := {}
	Private cPerg		  := PADR("IMPORTAR",10)

	aAdd( aSay, "Esta rotina irá importar os dados do Fenix para Microsiga" )

	ValidPerg()
	Pergunte(cPerg,.F.)
	aButton  := {	{ 5,.T.,{|| Pergunte(cPerg,.T.) }   } ,;
	{ 1,.T.,{|| nOpc := 1,FechaBatch()} } ,;
	{ 2,.T.,{|| FechaBatch() }          }  ;
	}
	FormBatch( cCadastro, aSay, aButton )
	If nOpc == 1
		if Empty( MV_PAR01 )
			MsgInfo("Necessario preencher o nome do arquivo cabecalho do pedido","Atenção")
			Return(Nil)
		Endif

		if Empty(MV_PAR02)
			MsgInfo("Necessario preencher o caminho do arquivo","Atenção")
			Return(Nil)
		Endif

		if Empty(MV_PAR03)
			MsgInfo("Necessario preencher o TES","Atenção")
			Return(Nil)
		Endif



		if MsgYesNo("Deseja prosseguir com esta operação?","Atencao")
			oProcess:=MsNewProcess():New({|lEnd| Importa()},"Processando","",.T.)
			oProcess:Activate()
			//Processa( {|| Importa() }, "Processando..." )
		Endif
	Endif

Return(Nil)
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Static Function ValidPerg()
	Local aAreaX1 := GetArea()


	PutSx1( cPerg ,"01","Pedido"      			,"","","MV_CH1" ,"C",40,00,01,"G","U_CarAr1",""   ,"","","MV_PAR01","","","","","","","","","","","","","","","","",{"Informe o caminho do arquivo a ser gerado "},{},{})
	PutSx1( cPerg ,"02","Itens Pedido"		  ,"","","MV_CH2" ,"C",40,00,01,"G","U_CarAr2",""   ,"","","MV_PAR02","","","","","","","","","","","","","","","","",{"Informe o Arquivo do cabeçalho do Pedido"},{},{})
	PutSx1( cPerg ,"03","TES"  						  ,"","","MV_CH3" ,"C",40,00,01,"G",""		     ,"SF4","","","MV_PAR03","","","","","","","","","","","","","","","","",{"Informe o TES do Pedido"},{},{})
	PutSx1( cPerg ,"04","Cond.Pagto"   			,"","","MV_CH4" ,"C",40,00,01,"G",""		     ,"SE4","","","MV_PAR04","","","","","","","","","","","","","","","","",{"Informe a Cond. de Pagato"},{},{})
	PutSx1( cPerg ,"05","Valor %"      			,"","","MV_CH5" ,"C",40,00,01,"G",""		     ,""   ,"","","MV_PAR05","","","","","","","","","","","","","","","","",{"Informe Valor de desconto Cond.Pagto"},{},{})
	PutSx1( cPerg ,"06","Comissão Vendedor" ,"","","MV_CH6" ,"C",40,00,01,"G",""		     ,"","",""   ,"MV_PAR06","","","","","","","","","","","","","","","","",{"Informe o Valor de Comissão do Vendedor valor é em porcentagem"},{},{})
	PutSx1( cPerg ,"07","Tabela Padrao" 		,"","","MV_CH6" ,"C",40,00,01,"G",""		     ,"DA0","","","MV_PAR07","","","","","","","","","","","","","","","","",{"Informe o Valor tabela padrão"},{},{})
	PutSx1( cPerg ,"08","Tipo Cliente ?"		,"","","mv_ch8","N",1,0,2,"C","","","","","mv_par08","Solidario","","","","Cons. Final","","","","","Isento","","","","","","",{"Informe o tipo cliente"},{},{},"")
	PutSx1( cPerg ,"09","Dividir comissão ?"	,"","","mv_ch9","N",1,0,2,"C","","","","","mv_par09","Sim","","","","Não","","","","","","","","","","","",{"Informe dividir comissão"},{},{},"")
	PutSx1(	cPerg, "10", "Estado: ", "Estado: ", "Estado: ","mv_chA", "C", 80, 0, 0, "G", "u_LoadEstado()", "","", "", "mv_par10","","","","","","","","","","","","","","","","",{"Selecione os Estados","",""},{"Selecione os Estados","",""},{"Selecione os Estados","",""},"")//U_LoadEstado() veio do fonte DHFATC01
	RestArea(aAreaX1)


Return
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
User Function CarAr1()
	if Empty( MV_PAR01 )
		MV_PAR01 := Padr(cGetFile("Todos Arquivo(s) *.* |*.*|","Selecione arquivo Valido"),255)
	Endif
Return(Nil)
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
User Function CarAr2()
	if Empty( MV_PAR02 )
		MV_PAR02 := Padr(cGetFile("Todos Arquivo(s) *.* |*.*|","Selecione arquivo Valido"),255)
	Endif
Return(Nil)
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Static Function Importa()
	Local aAux,aCab,aItens,aArPedido
	Local cArquivo,cArquivo1
	Local cTes,cTabela
	Local nFor
	Local cTranspMV	:= GetMv("MV_TRANSPAD",,"000001")
	Local cItem := StrZero(0, TamSx3("C6_ITEM")[1])
	Local nPos	:= 0
	//Local nSaveSx8Len := GetSx8Len()

	Private lMsErroAuto
	Private cMemoObs


	Conout("Inicio da importacao "+Dtoc(ddatabase)+ " " +Time())
	cArquivo := RTrim(MV_PAR01)
	if !File( cArquivo )
		MsgInfo("Atenção Arquivo de Cabeçalho não existente!","Atenção")
		Return(Nil)
	Endif

	cArquivo1 := RTrim(MV_PAR02)
	if !File( cArquivo1 )
		MsgInfo("Atenção Arquivo de Corpo não existente!","Atencao")
		Return(Nil)
	Endif


	cTes     := RTrim( MV_PAR03 )
	cTabela  := RTrim( MV_PAR07 )

	xPagto   := AllTrim(MV_PAR04)
	nVDesc1  := Val(MV_PAR05)


	nPorc    := StrTran(MV_PAR06,",",".")
	nPorc    := Val(RTrim( nPorc ))


	aPedidos	:= {}
	FT_FUSE(cArquivo1)
	nTotRec	:= FT_FLASTREC()
	FT_FGOTOP()	

	//ljWriteLog("teste.log","Ponto 4 - Itens do Array")
	While !FT_FEOF()
		cLinha := FT_FREADLN()
		aAux := {}
		cCodPro  := RTrim(SubStr(cLinha,11,20))
		cDescPro := Posicione("SB1", 1, xFilial("SB1")+cCodPro, "B1_DESC")
		cUM      := Posicione("SB1", 1, xFilial("SB1")+cCodPro, "B1_UM")
		cLocal   := Posicione("SB1", 1, xFilial("SB1")+cCodPro, "B1_LOCPAD")
		cQtdVend := SubStr(cLinha,61,10)
		cPrcUnit := SubStr(cLinha,71,20)

		//+--------------------------------------------------------------------------------------
		//| Selecionando a TES Inteligente.
		//| Caso não encontre Utiliza a TES definido no Paramentro
		//+--------------------------------------------------------------------------------------
		//| Sintaxe  MaTesInt(ExpN1,ExcC1,ExpC2,ExpC3,ExpC4,ExpC5)
		//+--------------------------------------------------------------------------------------
		//| Descri??o ³
		//|  1.ExpN1 = Documento de 1-Entrada / 2-Saida                     ³±±
		//|  2.ExpC1 = Tipo de Operacao Tabela "DF" do SX5                  ³±±
		//|  3.ExpC2 = Codigo do Cliente ou Fo¹²³£¢¬rnecedor                ³±±
		//|  4.ExpC3 = Codigo do gracao E-Entrada                           ³±±
		//|  5.ExpC4 = Tipo de Operacao E-Entrada                           ³±±
		//+--------------------------------------------------------------------------------------
		//ljWriteLog("teste.log","Ponto 5 - Tes Inteligente 1")

		cTesInt := ""
		//cTesInt := MaTesInt(2				,"01"			,aCodSiga[1],SA1->A1_LOJA	,"C"		,cCodPro )

		//if Empty(cTesInt)
		//	cTesInt := cTes
		//Endif

		oProcess:SetRegua1(0)
		oProcess:IncRegua1("Pedido: "+SubStr(cLinha,1,10))

		oProcess:SetRegua2(nTotRec)
		oProcess:IncRegua2("Item: "+Alltrim(cDescPro))

		nPos := aScan(aPedidos,{|x| x[1]== SubStr(cLinha,1,10)})
		If nPos == 0 
			aAdd(aPedidos,{SubStr(cLinha,1,10),;
			{	cCodPro,;
			cDescPro,;
			cUM,;
			cLocal,;
			cQtdVend,;
			cPrcUnit,;
			cTesInt}})
		Else
			aAdd(aPedidos[nPos],{	cCodPro,;
			cDescPro,;
			cUM,;
			cLocal,;
			cQtdVend,;
			cPrcUnit,;
			cTesInt})								
		EndIf						
		FT_FSKIP()
	End
	//FT_FUSE()

	// Carregando o Arquivo para Array.
	// Cabecalho do Pedido
	aArPedido := {}
	FT_FUSE(cArquivo)
	FT_FGOTOP()	
	While !FT_FEOF()     
		Conout("Inicio do Pedido "+SubStr(cLinha,001,10)+" "+Dtoc(ddatabase)+ " " +Time())
		cLinha := FT_FREADLN()
		//AADD(aArPedido,cLinha)
		//FT_FUSE()
		//ljWriteLog("teste.log","Inicio do Arquivo")
		//ProcRegua( Len(aArPedido) )
		//For nFor := 1 to Len(aArPedido)	
		//IncProc()
		//ljWriteLog("teste.log","Ponto 1")
		aCab 	 := {}
		//cLinha := aArPedido[nFor]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validando o cliente Fenix					   ³
		//|No microsiga                                    |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cPedido   := SubStr(cLinha,001,10)
		cCNPJ     := SubStr(cLinha,557,20)
		//cCodPagto := SubStr(cLinha,134,10)
		cRepres   := SubStr(cLinha,011,15)
		cRepres   := STRZERO(VAL(cRepres),3)
		cTransp   := SubStr(cLinha,542,15)
		oProcess:SetRegua1(0)
		oProcess:IncRegua1("Pedido: "+cPedido)

		dEmissao  := Left(SubStr(cLinha,026,14),8)
		dEmissao  := CTOD( Right(dEmissao,2)+"/"+SubStr(dEmissao,5,2)+"/"+ Left(dEmissao,4) )
		aCliente  := { SubStr(cLinha,557,20)   	,; // 01 - CNPJ/CPF
		SubStr(cLinha,238,50)   	,; // 02 - Nome do Cliente
		SubStr(cLinha,288,75)   	,; // 03 - Endereco
		SubStr(cLinha,438,40)   	,; // 04 - Cidade
		SubStr(cLinha,478,02)   	,; // 05 - Estado
		SubStr(cLinha,480,10)   	,; // 06 - CEP
		SubStr(cLinha,054,20)   	,; // 07 - Codigo do Cliente
		STRZERO(Val(SubStr(cLinha,011,15)),3) } // 08 - Representante

		// Buscando o Codigo no microsiga.
		aCodSiga  := CadCliSiga(cCNPJ,aCliente)

		//if Empty(cTransp)
		cTransp:= Iif(Empty(SA1->A1_TRANSP),cTranspMV,SA1->A1_TRANSP)
		//Else
		//	cTransp   := Padl(cTransp,6,"0")
		//EndIf	

		lRat 	 := .F.
		nComiss1 := 0.00
		nComiss2 := 0.00
		if STRZERO(Val(aCodSiga[2]),3) != cRepres
			lRat  := .T.
			If MV_PAR09 == 1
				nComiss1 := Round(nPorc/2,2)
				nComiss2 := nComiss1
			Else
				nComiss2 := Round(nPorc,2)
			EndIf	
		Else
			nComiss1 := Round(nPorc,2)
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dados do cabecalho do pedido de venda.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCondPgto := UPPER(RTrim(SubStr(cLinha,134,10)))
		cTpFrete  := iif(Empty(aCodSiga[3]),"F",iif(AllTrim(aCodSiga[3])="C","C","F"))

		If Alltrim(aCodSiga[2]) == "106"
			nComiss1:= 0			
		EndIf

		If Alltrim(cRepres) == "106"
			nComiss2:= 0
		EndIf

		c__Respr  :=0
		c__Respr1 :=0
		c__Respr2 :=0
		c__Respr3 :=0
		c__Respr5 := Space(6)

		c__Respr := len(cRepres)
		If c__Respr == 6
			c__Respr3 := cRepres
		else
			c__Respr2 := SPACE(3)
			c__Respr4 := cRepres+c__Respr2
		endif

		//ljWriteLog("teste.log","Ponto 2 - Numero do Pedido")
		//cNumPed   := CriaVar("C5_NUM")
		//ConfirmSX8()
		//ljWriteLog("teste.log","Ponto 3 - Inicio do Array")
		//aAdd(aCab,{"C5_FILIAL"	, xFilial("SC5")	, Nil		, ""		})
		//aAdd(aCab,{"C5_NUM"		, cNumPed			, Nil		, ""		})
		aAdd(aCab,{"C5_TIPO"	  	, "N"				, Nil		, ""		})
		aAdd(aCab,{"C5_CLIENTE"		, aCodSiga[1]		, Nil		, ""		})
		aAdd(aCab,{"C5_LOJACLI"		, SA1->A1_LOJA		, Nil		, ""		})
		aAdd(aCab,{"C5_NOME"	  	, SA1->A1_NOME  	, Nil	  	, ""		})
		aAdd(aCab,{"C5_EMISSAO"		, dDataBase			, Nil		, ""		})
		aAdd(aCab,{"C5_TIPOCLI"		, SA1->A1_TIPO	  	, Nil		, ""		})
		If MV_PAR09 == 1 .or. cRepres == "106"     
			aAdd(aCab,{"C5_VEND1"	  	, aCodSiga[2]  		, Nil		, ""		})
		Else
			aAdd(aCab,{"C5_VEND1"	, c__Respr4  		, Nil		, ""		})
		ENDIF		
		aAdd(aCab,{"C5_TRANSP"		, cTransp	  		, Nil		, ""		})
		aAdd(aCab,{"C5_PEDFNX"		, cPedido		  	, Nil		, ""		})
		aAdd(aCab,{"C5_DTFNX"	  	, dEmissao	      	, Nil		, ""		})
		aAdd(aCab,{"C5_CLIFNX"		, aCliente[7]  	  	, Nil		, ""		})
		aAdd(aCab,{"C5_TABELA"		, cTabela	        , Nil 		, ""		})
		aAdd(aCab,{"C5_OPER"	  	, "01"   	        , Nil 		, ""		})
		aAdd(aCab,{"C5_COMIS1"  	, nComiss1      	, Nil		, ""		})
		aAdd(aCab,{"C5_TPFRETE" 	, cTpFrete   	    , Nil		, ""		})
		aAdd(aCab,{"C5_DHORIGA" 	, "F"		        , Nil		, ""		})
		aAdd(aCab,{"C6_OPER"	  	, "01"   	     	, "AlwaysTrue()"		, ""		})

		if lRat   
			aAdd(aCab,{"C5_VEND2"	, c__Respr5		 	, Nil		, ""		})
			aAdd(aCab,{"C5_COMIS2"  , nComiss2      	, Nil		, ""		})
		Endif
		
		if lRat .and. MV_PAR09 == 1   
			aAdd(aCab,{"C5_VEND2"	, cRepres+c__Respr2	, Nil		, ""		})
			aAdd(aCab,{"C5_COMIS2"  , nComiss2      	, Nil		, ""		})
		Endif

		if  AllTrim(cCondPgto) == xPagto
			aAdd(aCab,{"C5_DESC1"	, nVDesc1			, Nil		,  "" 	})
		Endif

		SE4->(DbSetOrder(1))
		if !SE4->(DbSeek( xFilial("SE4") + cCondPgto ))
			cCondPgto := GetMv("MV_CONDPAD")
		Endif
		aAdd(aCab,{"C5_CONDPAG"	, cCondPgto    , "AlwaysTrue()"	, "" })

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ordena os campos de acordo com a ordem do SX3³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//aEval(aCab,{|x| x[4] := Posicione("SX3", 2, x[1], "X3_ORDEM") })
		//aCab := aSort(aCab,,,{|x,y| x[4] < y[4]})

		nPos := aScan(aPedidos,{|x| x[1]== cPedido})
		If nPos > 0
			nItem := 0
			aItens:= {}          
			aAux:= {}   

			//Inicializa variavel de item
			cItem := StrZero(0, TamSx3("C6_ITEM")[1])

			For nX:= 2 To Len(aPedidos[nPos])       

				SB1->(DbSetOrder(1))
				If SB1->(!(Dbseek(xFilial("SB1")+aPedidos[nPos][nX][1])))
					Loop
				EndIf

				cTesInt := MaTesInt(2				,"01"			,SA1->A1_COD,SA1->A1_LOJA	,"C"		,aPedidos[nPos][nX][1] )

				if Empty(cTesInt)
					cTesInt := cTes
				Endif				

				if Empty(aPedidos[nPos][nX][7])
					aPedidos[nPos][nX][7] := cTesInt
				Endif	

				cItem := Soma1(cItem)
				nComiss1	:= U_SNLGATILHOS(3,aPedidos[nPos][nX][1],aCodSiga[2],cTabela,nComiss1)
				cPromo		:= U_SNLGATILHOS(4,aPedidos[nPos][nX][1],aCodSiga[2],cTabela,nComiss1)

				If nComiss1 > 0
					if STRZERO(Val(aCodSiga[2]),3) != cRepres
						lRat  := .T.
						If MV_PAR09 == 1
							nComiss1 := Round(nComiss1/2,2)
							nComiss2 := nComiss1
						Else
							nComiss2 := Round(nComiss1,2)
						EndIf	
					Else
						nComiss1 := Round(0,2)
					Endif
				Else
					if STRZERO(Val(aCodSiga[2]),3) != cRepres
						lRat  := .T.
						If MV_PAR09 == 1
							nComiss1 := Round(nPorc/2,2)
							nComiss2 := nComiss1
						Else
							nComiss1 := Round(nPorc,2)							
							nComiss2 := Round(0,2)
						EndIf	
					Else
						nComiss1 := Round(0,2)
					Endif				
				Endif	

				//	aAdd(aAux,{"C6_FILIAL"  , xFilial("SC6")					 				, Nil	, "" })
				aAdd(aAux,{"C6_ITEM"	  	, cItem /*Soma1(nItem,1)*/				 					, Nil	, "" })
				//aAdd(aAux,{"C6_NUM"		, cNumPed											, Nil	, "" })
				aAdd(aAux,{"C6_CLI"			, SA1->A1_COD							 			, Nil	, "" })
				aAdd(aAux,{"C6_LOJA"	  	, SA1->A1_LOJA						 				, Nil	, "" })
				aAdd(aAux,{"C6_PRODUTO"		, aPedidos[nPos][nX][1]								, Nil	, "" })
				aAdd(aAux,{"C6_DESCRI"		, aPedidos[nPos][nX][2]	            	 			, Nil	, "" })
				aAdd(aAux,{"C6_LOCAL"	  	, aPedidos[nPos][nX][4]                	 			, Nil	, "" })
				aAdd(aAux,{"C6_TES"	    	, aPedidos[nPos][nX][7]					      	 	, Nil	, "" })
				aAdd(aAux,{"C6_QTDVEN" 		, Round(Val(aPedidos[nPos][nX][5]), MsDecimais(1))	, Nil	, "" })
				aAdd(aAux,{"C6_ENTREG"		, dDataBase								 			, Nil	, "" })
				aAdd(aAux,{"C6_VEND1"	  	, aCodSiga[2]	 						 			, Nil	, "" })
				//aAdd(aAux,{"C6_COMIS1"  	, nComiss1       					 				, Nil	, "" })
				aAdd(aAux,{"C6_COMIS1"  	, nComiss1											, Nil	, "" })
				aAdd(aAux,{"C6_XPROMO"  	, cPromo											, Nil	, "" })

				if lRat
					aAdd(aAux,{"C6_VEND2"	, cRepres		 									, Nil	, "" })
					aAdd(aAux,{"C6_COMIS2"  , nComiss2      									, Nil	, "" })
				Endif

				oProcess:SetRegua2(Len(aPedidos[nPos]))
				oProcess:IncRegua2("Item: "+Alltrim(Str(nItem))+" "+Alltrim(aPedidos[nPos][nX][2]))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ordena os campos de acordo com a ordem do SX3³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//aEval(aAux,{|x| x[4] := Posicione("SX3", 2, x[1], "X3_ORDEM") })
				//aAux := aSort(aAux,,,{|x,y| x[4] < y[4]})                     

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Incrementa no array de itens o array auxiliar³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				AAdd(aItens, aAux)
				aAux:= {}
			Next nX
		EndIf


		if Len(aItens) = 0
			MsgInfo("Não foi encontrado Itens para o Pedido " + cPedido)
		Endif
		//+---------------------------------------------------------+
		//|Executa rotina automatica de inclusao de Pedidos de Venda|
		//+---------------------------------------------------------+     
		//ljWriteLog("teste.log","Inicio do MSExecAuto")
		cMemoObs    := ""
		lMsErroAuto := .F.
		l410Auto    := .T.
		MSExecAuto({|x,y,z| Mata410(x,y,z)}, aCab, aItens, 3)
		If lMsErroAuto
			cErro       := "C:\FNX"+cPedido+".LOG"
			lMsErroAuto := .F.
			MostraErro("", cErro)
			DisarmTransaction()
		Else
			// reprocessa as comissoes
			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6") + SC5->C5_NUM)
				While !SC6->(Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM

					nComiss1	:= U_SNLGATILHOS(3,SC6->C6_PRODUTO,SC5->C5_VEND1,cTabela,nComiss1)
					cPromo		:= U_SNLGATILHOS(4,SC6->C6_PRODUTO,SC5->C5_VEND1,cTabela,nComiss1)

					lRat		:= .F.

					If nComiss1 > 0
						if STRZERO(Val(aCodSiga[2]),3) != cRepres
							lRat  := .T.
							If MV_PAR09 == 1
								nComiss1 := Round(nComiss1/2,2)
								nComiss2 := nComiss1
							Else
								nComiss2 := Round(0,2)
							EndIf	
						Endif
					Else
						if STRZERO(Val(aCodSiga[2]),3) != cRepres
							lRat  := .T.
							If MV_PAR09 == 1
								nComiss1 := Round(nPorc/2,2)
								nComiss2 := nComiss1
							Else
								nComiss1	:= nPorc
								nComiss2 := Round(0,2)
							EndIf	
						Else
							nComiss1 := Round(nPorc,2)
						Endif				
					Endif

					If RecLock("SC6",.F.)
						SC6->C6_COMIS1	:= nComiss1

						If lRAT
							SC6->C6_COMIS2	:= nComiss2						
						Endif

						SC6->(Msunlock())
					EndIf

					SC6->(DbSkip())
				EndDo
				Conout("Arquivo importado com sucesso!")
			Endif
		Endif

		//ljWriteLog("teste.log","Fim do MSExecAuto")
		Conout("Fim do Pedido "+SubStr(cLinha,001,10)+" "+Dtoc(ddatabase)+ " " +Time())
		FT_FSKIP()
	End
	DbSelectArea("SA1")
	DbSetOrder(1)
	SA1->(DbGoTop())
	If SA1->(DbSeek(xFilial("SA1")+_cCodCli))
		If SA1->A1_INSCR == "111111111111111111"
			RecLock("SA1", .F.)
			SA1->A1_INSCR := ""
			SA1->(MsUnLock())
		EndIf	
	EndIf

	//Next nFor
	CursorArrow()

	MsgInfo("Fim da importacao "+Dtoc(ddatabase)+ " " +Time())
	ConOut("Fim da importacao "+Dtoc(ddatabase)+ " " +Time())

Return(Nil)
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Static Function CadCliSiga(cCNPJ,aCliente)
	Local aRetorno

	cCNPJ := RTrim(cCNPJ)
	DbSelectArea("SA1")
	DbSetOrder(3)
	//cPesquisa := xFilial("SA1") +  cCNPJ
	cPesquisa := xFilial("SA1") + cCNPJ

	if !SA1->(DbSeek(cPesquisa))
		aRetorno := 	{GetSxeNum("SA1","A1_COD"),;
		aCliente[8]							,;
		'F'											 }

		RecLock("SA1",.T.)
		SA1->A1_FILIAL 	:= xFilial("SA1") //cFilAnt //cFilAtu // cFilAnt
		SA1->A1_COD    	:= aRetorno[1]
		SA1->A1_LOJA   	:= "01"
		SA1->A1_PESSOA 	:= iif(Len(AllTrim(aCliente[1]))=11,"F","J")
		SA1->A1_NREDUZ 	:= Left(aCliente[2],At(" ",aCliente[2]))
		SA1->A1_TIPO   	:= Iif(MV_PAR08 == 1,"S","F")//iif(Len(aCliente[1])=11,"F","R")
		SA1->A1_CGC    	:= aCliente[1]
		SA1->A1_NOME   	:= aCliente[2]
		SA1->A1_END    	:= aCliente[3]
		SA1->A1_MUN    	:= aCliente[4]
		SA1->A1_EST    	:= aCliente[5]				

		SA1->A1_ENDCOB 	:= aCliente[3]
		SA1->A1_MUNC   	:= aCliente[4]
		SA1->A1_ESTC   	:= aCliente[5]
		SA1->A1_ENDENT 	:= aCliente[3]
		SA1->A1_MUNE   	:= aCliente[4]
		SA1->A1_ESTE   	:= aCliente[5]
		SA1->A1_VEND   	:= RTrim(aCliente[8])

		SA1->A1_GRPTRIB	:= GrpTrip(SA1->A1_TIPO,MV_PAR10,MV_PAR08,SA1->A1_EST)//Iif(SA1->A1_TIPO == "R","CF1","SLD")
		SA1->A1_TRANSP	:= "000051"

		If SA1->A1_GRPTRIB $ 'CF3,ZF1,ZF2,ZF3,ZF4'
			SA1->A1_ISENTO	:= "S"
			SA1->A1_INSCR	:= "ISENTO"
			SA1->A1_CONTRIB	:= "2"
			SA1->A1_XIESIMP	:= "2"
			SA1->A1_IENCONT := "2"
		Else
			SA1->A1_ISENTO	:= "N"
			SA1->A1_INSCR	:= "111111111111111111"
			SA1->A1_CONTRIB	:= "1"
			SA1->A1_XIESIMP	:= "1"
			SA1->A1_IENCONT := "1"
		EndIf 
		SA1->A1_TPFRET 	:= "F"
		MSunLock()
		ConfirmSx8()
	Else
		aRetorno := {SA1->A1_COD  ,;    // 01 - Codigo do Cliente
		SA1->A1_VEND ,;    // 02 - Codigo do Vendedor
		SA1->A1_TPFRET}    // 03 - Tipo de Frete Fob/Cib
	Endif
	_cCodCli := SA1->A1_COD+SA1->A1_LOJA
Return(aRetorno)

Static Function GrpTrip(cTipo,cEstado,cPar,cEstCl)

	Local cGrpTrip := ""
	Local aEstados := Separa(cEstado,"/")
	Local lBolEst :=.F.

	IF cPar==1
		cGrpTrip:="SLD"
	ElseIF cPar==3 //Isento
		cGrpTrip:="CF3"
	ElseIF cPar==2 //Cons. Final 

		For i:=1 to Len(aEstados)
			IF cEstCl== aEstados[i]
				lBolEst:=.T.
			EndIf 
		Next i

		IF lBolEst
			cGrpTrip:="CF1"
		Else
			cGrpTrip:="CF2"
		Endif
	EndIf

Return(cGrpTrip)
