#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o     ³ RFAT035  ³ Autor ³                      ³ Data ³22/01/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Relatorio de Controle de Lote                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFAT035()

	Local oReport   

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT035" , __cUserID )

	If FindFunction("TRepInUse") .And. TRepInUse()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:= ReportDef()
		oReport:PrintDialog()
		//Else
		//	U_MKR35R()
	EndIf                   

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³                              ³28/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ oExpO1: Objeto do relatorio                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

	Local cPicSaldo   := PesqPict("SD5","D5_QUANT"  ,18)
	Local oReport 
	Local oSection1
	Local oSection2

	Local cPerg := "RFAT035"
	Local cAlias := "SD5"   
	Local _lImp := .t.

	Private cTitle      := "Relatorio de Controle de Lote"

	Static STR0001 := "Este programa emitir um relatorio com todas as movimentacoes "
	Static STR0002 := "do estoque por Lote diariamente. Observacao "
	Static STR0003:=  "movimento de cada Lote se refere a criacao do mesmo"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                     	 ³
	//³ mv_par01       	// Do  Produto                         	 	 ³
	//³ mv_par02        // Ate Produto                         	 	 ³
	//³ MV_PAR05        // De  Lote                            	 	 ³
	//³ MV_PAR06        // Ate Lote			        			 	 ³
	//³ MV_PAR07        // De  Sub-Lote                          	 ³
	//³ MV_PAR08        // Ate Sub-Lote			        		 	 ³
	//³ MV_PAR09        // De  Local		        			 	 ³
	//³ MV_PAR10        // Ate Local							 	 ³
	//³ MV_PAR11        // De  Data			        			 	 ³
	//³ MV_PAR12        // Ate Data								 	 ³
	//³ MV_PAR13       	// Lotes/Sub S/ Movimentos (Lista/Nao Lista) ³
	//³ MV_PAR14       	// Lote/Sub Saldo Zerado   (Lista/Nao Lista) ³ 
	//³ MV_PAR15       	// QTDE. na 2a. U.M. ?     (Sim/Nao)         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

	Pergunte("RFAT035")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao do componente de impressao                                      ³
	//³                                                                        ³
	//³TReport():New                                                           ³
	//³ExpC1 : Nome do relatorio                                               ³
	//³ExpC2 : Titulo                                                          ³
	//³ExpC3 : Pergunte                                                        ³
	//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
	//³ExpC5 : Descricao                                                       ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Descricao do Relatorio                                                 ³
	//³                                                                        ³
	//³ STR0001	//"Este programa emitir  um Kardex com todas as movimenta‡”es" ³
	//³ STR0002	//"do estoque por Lote/Sub-Lote, diariamente. Observa‡„o: o 1o"³                                                                        
	//³ STR0003	//"movimento de cada Lote/Sub-Lote se refere a cria‡„o do mesmo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     

	cTitle += " - Periodo de " + dtoc(MV_PAR09) + " ate " + dtoc(MV_PAR10)
	oReport:= TReport():New("RFAT035",cTitle,cPerg, {|oReport| ReportPrint(oReport,cAlias)}," "+" "+" "+" "+" ") 

	oReport:SetLandscape()  
	//oReport:HideParamPage()   // Desabilita a impressao da pagina de parametros.
	oReport:nFontBody	:= 08 // Define o tamanho da fonte.
	oReport:nLineHeight	:= 30 // Define a altura da linha.   

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da secao utilizada pelo relatorio                               ³
	//³                                                                        ³
	//³TRSection():New                                                         ³
	//³ExpO1 : Objeto TReport que a secao pertence                             ³
	//³ExpC2 : Descricao da seçao                                              ³
	//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
	//³        sera considerada como principal para a seção.                   ³
	//³ExpA4 : Array com as Ordens do relatório                                ³
	//³ExpL5 : Carrega campos do SX3 como celulas                              ³
	//³        Default : False                                                 ³
	//³ExpL6 : Carrega ordens do Sindex                                        ³
	//³        Default : False                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da celulas da secao do relatorio                                ³
	//³                                                                        ³
	//³TRCell():New                                                            ³
	//³ExpO1 : Objeto TSection que a secao pertence                            ³
	//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
	//³ExpC3 : Nome da tabela de referencia da celula                          ³
	//³ExpC4 : Titulo da celula                                                ³
	//³        Default : X3Titulo()                                            ³
	//³ExpC5 : Picture                                                         ³
	//³        Default : X3_PICTURE                                            ³
	//³ExpC6 : Tamanho                                                         ³
	//³        Default : X3_TAMANHO                                            ³
	//³ExpL7 : Informe se o tamanho esta em pixel                              ³
	//³        Default : False                                                 ³
	//³ExpB8 : Bloco de código para impressao.                                 ³
	//³        Default : ExpC2                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:= TRSection():New(oReport,"Controle de Lote",{"SD5","SDB","SB1","SD3","SF5"}) //"Saldos por Lote"
	//oSection1:SetTotalInLine(.F.)
	//oSection1:SetTotalText(" ")
	oSection1:SetLineStyle()

	TRCell():New(oSection1,"D5_PRODUTO","SD5","Produto",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_DESC"   ,"SB1"," ",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"LEFT")
	TRCell():New(oSection1,"B1_UM"     ,"SB1","Unid",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(MV_PAR11 <> 2 ,SB1->B1_UM,SB1->B1_SEGUM)})
	TRCell():New(oSection1,"D5_FILIAL","SD5","Filial",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"D5_LOTECTL","SD5","Lote"	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DB_LOCALIZ","SDB","Endereço",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //endereço
	TRCell():New(oSection1,"D5_LOCAL"  ,"SD5","Armazem",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //armazem

	TRCell():New(oSection1,"D5_ORIGLAN","SD5","Orig.Lcto",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection1,"F5_TEXTO"  ,"SF5"," ",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection1,"D5_DATA"   ,"SD5","Emissão",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection1,"D5_DTVALID","SD5","Validade",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection1,"D3_DTFABRI","SD3","Fabricação",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")


	oSection2:= TRSection():New(oSection1,"Movimentos por Lote",{"SD5","SB8","SA1","T3","SF4","SA4","DAK","DAI","DA3","SD2","SD1","SF2"}) 
	//ection3:= TRSection():New(oSection2,"Controle de Lote",{"SD5","SD3"})  //"Movimentos por Lote"
	//oSection2:SetTotalInLine(.F.)
	oSection2:SetHeaderPage()
	//oSection2:SetNoFilter("SD5") 
	oSection2:SetCharSeparator("")
	//oSection2:SetLineStyle()

	TRCell():New(oSection2,"D5_DOC"    ,"SD5","Documento" ,/*Picture*/,09,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"D5_OP"     ,"SD5","Nr.OP",/*Picture*/,13,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"D5_CLIFOR" ,"SD5","Cli/For",/*Picture*/,06,/*lPixel*/,/*{|| code-block de impressao }*/) 
	TRCell():New(oSection2,"RAZAOSOC"  ," ","Nome Fantasia",/*Picture*/,20 ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"SEGVENDA"  ," ","Seg.Vendas",/*Picture*/,55,/*lPixel*/,/*{|| code-block de impressao }*/) //segmento de vendas
	TRCell():New(oSection2,"D2_PEDIDO" ,"SD2","Pedido",/*Picture*/,06,/*lPixel*/,/*{|| code-block de impressao }*/) //pedido de vendas
	TRCell():New(oSection2,"TES"       ," " ,"TES",/*Picture*/,03,/*lPixel*/,/*{| code-block de impressao }*/) 
	TRCell():New(oSection2,"CFOP"      ," ","Cfop",/*Picture*/,05,/*lPixel*/,/*{| code-block de impressao }*/)
	TRCell():New(oSection2,"A4_NREDUZ" ,"SA4","Transport.",/*Picture*/,15,/*lPixel*/,/*{| code-block de impressao }*/) //transportadora
	TRCell():New(oSection2,"DA3_PLACA" ,"DA3","Veiculo",/*Picture*/,08,/*lPixel*/,/*{| code-block de impressao }*/) //placa do veiculo
	TRCell():New(oSection2,"QUANTIDADE" ,"   ","Quantidade"	 ,cPicSaldo  ,18		 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection2,"TIPO"     ,"   ",""	 ,,01 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"LEFT")

	//TRCell():New(oSection3,"SALDO"     ,"   ","Saldo"	 ,cPicSaldo  ,18		 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³                       ³Data  ³28/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAlias)

	Local oSection1 := oReport:Section(1) 
	Local oSection2 := oReport:Section(1):Section(1)  
	Local cWorkSD5  := ""
	Local cFilter   := ""           
	Local nIndSD5   := 0
	Local nSD5Quant := 0

	DbSelectArea("SX5")
	DbSetOrder(1)

	dbSelectArea('SB1')
	dbSetOrder(1)   

	DbSelectArea("SDB")
	DbSetOrder(7)

	DbSelectArea("SD3")
	DbSetOrder(2) //FILIAL + DOC + COD          

	DbSelectArea("SD2")
	DbSetOrder(3) //FILIAL + DOC + SERIE + CLIENTE + LOJA + COD 

	DbSelectArea("SD1")
	DbSetOrder(1) //FILIAL + DOC + SERIE + CLIENTE + LOJA + COD 

	DbSelectArea("DAI")
	DbSetOrder(4) // filial + PEDIDO

	DbSelectArea("DAK")
	DbSetOrder(1)

	DbSelectArea("SA1")
	DbSetOrder(1)

	DbSelectArea("SA2")
	DbSetOrder(1)        

	DbSelectArea("SF2")
	DbSetOrder(1)        

	DbSelectArea("SF5")
	DbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho para a tabela SD5.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD5")

	cWorkSD5:= CriaTrab("",.F.)
	cFilter := 'D5_FILIAL=="'+xFilial("SD5")+'".And.D5_PRODUTO>="'+mv_par01+'".And.D5_PRODUTO<="'+mv_par02+'".And.'
	cFilter += 'D5_LOTECTL>="'+MV_PAR05+'".And.D5_LOTECTL<="'+MV_PAR06+'".And.'
	cFilter += 'D5_ESTORNO <> "S" .and. '
	cFilter += 'D5_LOCAL>="'  +MV_PAR07+'".And.D5_LOCAL<="'  +MV_PAR08+'".And.'
	cFilter += 'Dtos(D5_DATA)>="'+Dtos(MV_PAR09)+'".And.Dtos(D5_DATA)<="'+Dtos(MV_PAR10)+'"'

	IndRegua("SD5",cWorkSD5,"D5_PRODUTO+D5_LOCAL+D5_LOTECTL+Dtos(D5_DATA)",,cFilter,"Selecionando Registros") //"Selecionando Registros..."

	nIndSD5 := RetIndex("SD5")
	#IFNDEF TOP
	dbSetIndex(cWorkSD5 + OrdBagExt())
	#ENDIF
	dbSetOrder(nIndSD5+1)
	dbGotop()

	oReport:SetMeter(SD5->(LastRec()))
	dbSelectArea(cAlias)
	(cAlias)->(DbGotop())

	While !oReport:Cancel() .And. !(cAlias)->(Eof())

		oReport:IncMeter()
		If oReport:Cancel()
			Exit
		EndIf     

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SD5->D5_PRODUTO))

		_lImp:= .t.

		if !(SB1->B1_FAM >= MV_PAR03 .and. SB1->B1_FAM <= MV_PAR04 )
			_lImp := .f.
		endif   


		If _lImp                                                            
			SF5->(DbSeek(xFilial("SF5")+SD5->D5_ORIGLAN))
			SD3->(DbSeek(xFilial("SD3")+SD5->D5_DOC + SD5->D5_PRODUTO))   		

			nSD5Quant := If(MV_PAR11 <> 2, SD5->D5_QUANT,SD5->D5_QTSEGUM)

			If SD5->D5_ORIGLAN <= "500" .Or. Substr( SD5->D5_ORIGLAN,1,2) $ "DE/PR" .Or. SD5->D5_ORIGLAN == "MAN"
				If MV_PAR18 == 3 //somente entradas ou todos
					_lImp := .f.
				Endif
				if !(SD5->D5_CLIFOR >= MV_PAR16 .and. SD5->D5_CLIFOR <= MV_PAR17)     
					_lImp := .f.
				endif
				SA2->(DbSeek(xFilial("SA2")+SD5->D5_CLIFOR+SD5->D5_LOJA))                                                          
				oSection2:Cell("RAZAOSOC"):SetValue(SA2->A2_NREDUZ) 
				oSection2:Cell("QUANTIDADE"):SetValue(nSD5Quant)
				oSection2:Cell("TIPO"  ):SetValue("E")           
				oSection2:Cell("SEGVENDA"  ):SetValue("")
				oSection2:Cell("D2_PEDIDO"  ):SetValue(SD2->D2_PEDIDO)

				SD1->(DbSeek(xFilial("SD1")+SD5->D5_DOC + SD5->D5_SERIE + SD5->D5_CLIFOR+SD5->D5_LOJA  ))   			  
				oSection2:Cell("TES"  ):SetValue(SD1->D1_TES)
				oSection2:Cell("CFOP"  ):SetValue(SD1->D1_CF)
				oSection2:Cell("A4_NREDUZ"  ):SetValue(SA4->A4_NREDUZ)      
				oSection2:Cell("DA3_PLACA"  ):SetValue(DA3->DA3_PLACA)

			Elseif SD5->D5_ORIGLAN > "500" .Or. Substr(SD5->D5_ORIGLAN,1,2) == "RE"
				If MV_PAR18 == 2 //somente saidas ou todos
					_lImp := .f.
				Endif                                                        
				cSegVen := ""
				SA1->(DbSeek(xFilial("SA1")+SD5->D5_CLIFOR+SD5->D5_LOJA))	
				if !(SD5->D5_CLIFOR >= MV_PAR14 .and. SD5->D5_CLIFOR <= MV_PAR15)     
					_lImp := .f.
				endif

				if SX5->( DbSeek(xFilial("SX5")+"T3"+SA1->A1_SATIV1))
					cSegVen := X5DESCRI()
				Endif                                                                 

				oSection2:Cell("RAZAOSOC"):SetValue(SA1->A1_NREDUZ)                                                                    
				oSection2:Cell("QUANTIDADE"  ):SetValue(nSD5Quant)
				oSection2:Cell("TIPO"):SetValue("S")        
				oSection2:Cell("SEGVENDA"):SetValue(cSegVen)

				If SD2->(DbSeek(xFilial("SD2")+SD5->D5_DOC + SD5->D5_SERIE + SD5->D5_CLIFOR+SD5->D5_LOJA  )) 
					oSection2:Cell("TES"  ):SetValue(SD2->D2_TES)
					oSection2:Cell("CFOP"  ):SetValue(SD2->D2_CF)  

					If SC5->(DbSeek(xFilial("SC5")+ SD2->D2_PEDIDO))
						SA4->(DbSeek(xFilial("SA4")+SC5->C5_TRANSP))   //PEGA O NOME DA TRANSPORTADORA
						If !(SC5->C5_TRANSP >= MV_PAR12 .AND. SC5->C5_TRANSP <= MV_PAR13)
							_lImp := .f.                  
						Endif
					Endif     

					if DAI->(DbSeek(xFilial("DAI")+SD2->D2_PEDIDO))
						If DAK->(DbSeeK(xFilial("DAK")+DAI->DAI_COD))
							DA3->(DbSeek(xFilial("DA3")+DAK->DAK_CAMINH))      //PEGA A PLACA DO VEICULO                 
						Endif
					Else
						If SF2->(dbSeek(xFilial("SF2") + SD2->D2_DOC))
							DA3->(DbSeek(xFilial("DA3")+SF2->F2_VEICUL1))      //PEGA A PLACA DO VEICULO                 
						Endif
					Endif                                              
					oSection2:Cell("A4_NREDUZ"  ):SetValue(SA4->A4_NREDUZ)      
					oSection2:Cell("DA3_PLACA"  ):SetValue(DA3->DA3_PLACA)

				endif			
			EndIf 
		Endif

		If _lImp
			SDB->(DbSeek(xFilial("SDB")+SD5->D5_PRODUTO+SD5->D5_DOC+SD5->D5_SERIE+SD5->D5_CLIFOR+SD5->D5_LOJA)) 
			oSection2:Init()       
			oSection2:PrintLine()	    

			oSection1:Init()			   

			oSection1:PrintLine()	

			//oSection2:Finish()
			//oSection1:Finish()

			oReport:SkipLine()
		Endif

		(cAlias)->(DbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve ordens originais da tabela e apaga indice de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex("SD5")
	dbSelectArea("SD5")
	dbSetOrder(1)
	dbClearFilter()

	If File(cWorkSD5+OrdBagExt())
		Ferase(cWorkSD5+OrdBagExt())
	EndIf

Return Nil
