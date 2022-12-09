#Include "Matr200.ch"
#Include "FIVEWIN.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR200  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 01.06.06    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da Rela‡„o de Divergencias entre SC e Pedidos de      ³±±
±±³          ³ Compras.                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR200(void)                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XMatr200()
Local oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()
oReport:PrintDialog()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³01.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oSection1 
Local oSection2
Local oCell         
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
oReport := TReport():New("MATR200",STR0003,"MTR200", {|oReport| ReportPrint(oReport)},STR0001+" "+STR0002) ////"Relacao de Divergencias de SC E Pedidos de Compras"##"Emissao da Relacao de Itens para Compras"##"com divergencias"
Pergunte("MTR200",.F.)

oSection1 := TRSection():New(oReport,STR0013,{"SC1","SA2","SB1"}) //"Relacao de Divergencias de SC E Pedidos de Compras"
oSection1 :SetHeaderPage()
oSection1:SetNoFilter({"SA2","SB1"})

TRCell():New(oSection1,"C1_NUM","SC1",STR0015,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_ITEM","SC1",STR0016,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_EMISSAO","SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_FORNECE","SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_LOJA","SC1",STR0019,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,16,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_PRODUTO","SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_UM","SB1",STR0020,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_QUANT","SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_CC","SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_CONTA","SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_DATPRF","SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2 := TRSection():New(oReport,STR0014,{"SC7","SC1","SA2","SB1"}) //"Relacao de Divergencias de SC E Pedidos de Compras"
oSection2 :SetHeaderPage()
oSection2:SetNoFilter({"SC1","SA2","SB1"})

TRCell():New(oSection2,"C7_NUM","SC7",STR0017,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //Pedido
TRCell():New(oSection2,"C7_ITEM","SC7",STR0018,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_EMISSAO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection2,"C7_LOJA","SC7",STR0019,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,16,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_PRODUTO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B1_UM","SB1",STR0020,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"nQuant","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_CC","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_CONTA","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_DATPRF","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³01.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
LOCAL nFlag 	:= 0
LOCAL nQuant	:= 0
LOCAL aPed		:= {}
LOCAL nc		:= 1
LOCAL nQtTot	:= 0
LOCAL aArea  	:= Nil
LOCAL nP		:= 0
LOCAL aVet 		:= {}
LOCAL aProdut,aCotac,nSol
LOCAL cFilUsr1  := oSection1:GetAdvplExp()
LOCAL cFilUsr2  := oSection2:GetAdvplExp()
LOCAL cFilSC7	:= ""

oSection2:Cell("nQuant"):GetFieldInfo("C7_QUANT")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC1")
dbGoTop()
dbSetOrder(1)
Set SoftSeek On
dbSeek(cFilial)
Set SoftSeek Off

oReport:SetMeter(SC1->(LastRec()))

While !oReport:Cancel() .and. C1_FILIAL = xFilial() .And. !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro de usuario para secao 1                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilUsr1) .And. !(&(cFilUsr1))
		SC1->(dbSkip())
  		Loop
	EndIf
	
	If SC1->C1_EMISSAO < mv_par01 .Or. SC1->C1_EMISSAO > mv_par02
		SC1->(dbSkip())
		Loop
	Endif
	If SC1->C1_FORNECE < mv_par03 .Or. SC1->C1_FORNECE > mv_par04
		SC1->(dbSkip())
		Loop
	Endif
	If SC1->C1_PRODUTO < mv_par05 .Or. SC1->C1_PRODUTO > mv_par05
		SC1->(dbSkip())
		Loop
	Endif
	
	aArea := { Alias() , IndexOrd() , Recno() }
	aProdut := SC1->C1_PRODUTO
	aCotac := SC1->C1_COTACAO
	nSol := 0
	
	dbSetOrder(5)
	If !Empty(C1_COTACAO)
		IF	dbSeek( xFilial() + aCotac + aProdut )
			While !Eof() .And. C1_FILIAL+C1_COTACAO+C1_PRODUTO == xFilial()+aCotac+aProdut
				nSol += C1_QUANT
				dbSkip()
			EndDo
		EndIf
	EndIf
	
	DbSelectArea( aArea[1] )
	DbSetOrder( aArea[2] )
	DbGoTo( aArea[3] )
	
	If !Empty(SC1->C1_CODED) .And. !Empty(SC1->C1_SCORI) .And. Posicione("CO1",1,xFilial("CO1")+SC1->(C1_CODED+C1_NUMPR),"CO1_COPC") == "C"
		cFilSC7 := xFilial("SC7",SC1->C1_FILENT)
	Else
		cFilSC7 := xFilial("SC7")
	EndIf
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(cFilSC7+SC1->C1_PEDIDO+SC1->C1_ITEMPED)
	nFlag 	:= 2
	nQuant	:= 0
	nQtTot	:= 0
	Do While	 C7_FILIAL == cFilSC7 .AND. C7_PRODUTO == SC1->C1_PRODUTO .AND. !Eof()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro de usuario para secao 2                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilUsr2) .And. !(&(cFilUsr2))
			SC7->(dbSkip())
	  		Loop
		EndIf
		
		If C7_NUM == SC1->C1_PEDIDO .and. C7_ITEM == SC1->C1_ITEMPED
			
			// soma a quantidade total dos pedidos com a solicitacao .
			nQtTot += C7_QUANT
			
			nPos := Ascan(aPed,{|x|x[1] == C7_NUM})
			If nPos != 0
				aPed[nPos][2] += C7_QUANT
			Else
				nQuant:= C7_QUANT
				Aadd( aPed,{ C7_NUM,nQuant,C7_EMISSAO,C7_FORNECE,C7_LOJA,C7_PRODUTO,C7_CC,C7_CONTA,C7_DATPRF})
			Endif
			
			// achou a solicitacao de compras com o pedido
			
			nFlag := 1
		Endif
		dbSkip()
	EndDo
	For nc := 1 to len( aPed )
		If nFlag == 1
			dbSetOrder(1)
			If	dbSeek(xFilial()+aPed[nc][1])
				dbSelectArea("SA2")
				dbSeek(cFilial+aPed[nc][4]+aPed[nc][5])
			Endif
			/*Chamada da antiga funcao Imprlinha-----*/
			dbSelectArea("SB1")
			dbSeek(cFilial+SC1->C1_PRODUTO)
			If nFlag == 1
				IF(nQtTot != SC1->C1_QUANT .and. nQuant != SC1->C1_QUANT .OR. aPed[nc][9] != SC1->C1_DATPRF).And.!Empty(SC1->C1_COTACAO).And.nSol!=aPed[nc][2]
					
					//Se existir mais pedidos com a mesma solicitacao imprimir
					//a Solicitacao com todos os pedidos em divergencia.
					If nC == 1
						oSection1:Init()
						oSection1:PrintLine()
					Endif
			
					oSection2:Init()
			       
					oSection2:Cell("C7_NUM"):SetValue(aPed[nc][1])
					oSection2:Cell("C7_ITEM"):SetValue(SC7->C7_ITEM)
					oSection2:Cell("C7_EMISSAO"):SetValue(aPed[nc][3])
					oSection2:Cell("C7_FORNECE"):SetValue(aPed[nc][4])
					oSection2:Cell("C7_LOJA"):SetValue(aPed[nc][5])
					oSection2:Cell("A2_NOME"):SetValue(SA2->A2_NOME)
					oSection2:Cell("C7_PRODUTO"):SetValue(aPed[nc][6])
					oSection2:Cell("B1_UM"):SetValue(SB1->B1_UM)
					oSection2:Cell("nQuant"):SetValue(aPed[nc][2])
					oSection2:Cell("C7_CC"):SetValue(aPed[nc][7])
					oSection2:Cell("C7_CONTA"):SetValue(aPed[nc][8])
					oSection2:Cell("C7_DATPRF"):SetValue(aPed[nc][9])
					
					oSection2:PrintLine()
					oSection2:Finish()
			
				Endif
			Else
			
				oSection1:Init()
				oSection1:PrintLine()
				oReport:PrintText(STR0011) //"Nao ha' pedido de compra colocado"
				oReport:SkipLine()
			Endif
			/*-----*/
		Endif
	Next nc
	
	If nFlag == 2
		dbSelectArea("SA2")
		dbSeek(cFilial+SC1->C1_FORNECE+SC1->C1_LOJA)
		/*Chamada da antiga funcao Imprlinha-----*/
		dbSelectArea("SB1")
		dbSeek(cFilial+SC1->C1_PRODUTO)
		If nFlag == 1
			IF(nQtTot != SC1->C1_QUANT .and. nQuant != SC1->C1_QUANT .OR. aPed[nc][9] != SC1->C1_DATPRF).And.!Empty(SC1->C1_COTACAO).And.nSol!=aPed[nc][2]
				
				//Se existir mais pedidos com a mesma solicitacao imprimir
				//a Solicitacao com todos os pedidos em divergencia.
				If nC == 1
					oSection1:Init()
					oSection1:PrintLine()
				Endif
		
				oSection2:Init()
		
				oSection2:Cell("C7_NUM"):SetValue(aPed[nc][1])
				oSection2:Cell("C7_ITEM"):SetValue(SC7->C7_ITEM)
				oSection2:Cell("C7_EMISSAO"):SetValue(aPed[nc][3])
				oSection2:Cell("C7_FORNECE"):SetValue(aPed[nc][4])
				oSection2:Cell("C7_LOJA"):SetValue(aPed[nc][5])
				oSection2:Cell("A2_NOME"):SetValue(SA2->A2_NOME)
				oSection2:Cell("C7_PRODUTO"):SetValue(aPed[nc][6])
				oSection2:Cell("B1_UM"):SetValue(SB1->B1_UM)
				oSection2:Cell("nQuant"):SetValue(aPed[nc][2])
				oSection2:Cell("C7_CC"):SetValue(aPed[nc][7])
				oSection2:Cell("C7_CONTA"):SetValue(aPed[nc][8])
				oSection2:Cell("C7_DATPRF"):SetValue(aPed[nc][9])
				
				oSection2:PrintLine()
				oSection2:Finish()
		
			Endif
		Else
		
			oSection1:Init()
			oSection1:PrintLine()
			oReport:PrintText(STR0011) //"Nao ha' pedido de compra colocado"
			oReport:SkipLine()
		Endif
		/*-----*/		
	Endif
	
	aPed := {}
	dbSelectArea("SC1")
	dbSkip()
EndDo
oSection1:Finish()
oReport:ThinLine() 

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Impr200  ³ Autor ³ Jose Lucas            ³ Data ³ 15.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void Impr200(ExpC1,ExpC2,ExpC3,ExpC4,ExpN1,ExpN2)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Titulo do Relatorio                               ³±±
±±³          ³ ExpC2 := Cabecalho                                         ³±±
±±³          ³ ExpC1 := Cabecalho                                         ³±±
±±³          ³ ExpC1 := Nome do Programa                                  ³±±
±±³          ³ ExpN1 := Comprimento da Linha                              ³±±
±±³          ³ ExpN2 := Tipo de impressao Comprimido ou Normal            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impr200(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)
LOCAL nFlag 	:= 0
LOCAL nQuant	:= 0
LOCAL aPed		:= {}
LOCAL nc		:= 1
LOCAL nQtTot	:= 0
LOCAL aArea  	:= Nil
LOCAL nP		:= 0
LOCAL aVet 		:= {}
LOCAL aProdut,aCotac,nSol
LOCAL cFilSC7   := ""

dbSelectArea("SC1")
dbGoTop()
dbSetOrder(1)
Set SoftSeek On
dbSeek(cFilial)
Set SoftSeek Off

SetRegua(RecCount())

While !Eof() .and. C1_FILIAL = xFilial()
	
	If lEnd
		@PROW()+1,001 PSAY STR0010	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	If C1_EMISSAO < mv_par01 .Or. C1_EMISSAO > mv_par02
		dbSkip()
		Loop
	Endif
	If C1_FORNECE < mv_par03 .Or. C1_FORNECE > mv_par04
		dbSkip()
		Loop
	Endif
	If C1_PRODUTO < mv_par05 .Or. C1_PRODUTO > mv_par05
		dbSkip()
		Loop
	Endif
	aArea := { Alias() , IndexOrd() , Recno() }
	aProdut := SC1->C1_PRODUTO
	aCotac := SC1->C1_COTACAO
	nSol := 0
	
	dbSetOrder(5)
	If !Empty(C1_COTACAO)
		IF	dbSeek( xFilial() + aCotac + aProdut )
			While !Eof() .And. C1_FILIAL+C1_COTACAO+C1_PRODUTO == xFilial()+aCotac+aProdut
				nSol += C1_QUANT
				dbSkip()
			EndDo
		EndIf
	EndIf
	
	DbSelectArea( aArea[1] )
	DbSetOrder( aArea[2] )
	DbGoTo( aArea[3] )
	
	If !Empty(SC1->C1_CODED) .And. !Empty(SC1->C1_SCORI) .And. Posicione("CO1",1,xFilial("CO1")+SC1->(C1_CODED+C1_NUMPR),"CO1_COPC") == "C"
		cFilSC7 := xFilial("SC7",SC1->C1_FILENT)
	Else
		cFilSC7 := xFilial("SC7")
	EndIf
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(cFilSC7+SC1->C1_PEDIDO+SC1->C1_ITEMPED)
	nFlag 	:= 2
	nQuant	:= 0
	nQtTot	:= 0
	Do While	 C7_FILIAL == cFilSC7 .AND. C7_PRODUTO == SC1->C1_PRODUTO .AND. !Eof()
		If C7_NUM == SC1->C1_PEDIDO .and. C7_ITEM == SC1->C1_ITEMPED
			
			// soma a quantidade total dos pedidos com a solicitacao .
			nQtTot += C7_QUANT
			
			nPos := Ascan(aPed,{|x|x[1] == C7_NUM})
			If nPos != 0
				aPed[nPos][2] += C7_QUANT
			Else
				nQuant:= C7_QUANT
				Aadd( aPed,{ C7_NUM,nQuant,C7_EMISSAO,C7_FORNECE,C7_LOJA,C7_PRODUTO,C7_CC,C7_CONTA,C7_DATPRF})
			Endif
			
			// achou a solicitacao de compras com o pedido
			
			nFlag := 1
		Endif
		dbSkip()
	EndDo
	For nc := 1 to len( aPed )
		If nFlag == 1
			dbSetOrder(1)
			If	dbSeek(xFilial()+aPed[nc][1])
				dbSelectArea("SA2")
				dbSeek(cFilial+aPed[nc][4]+aPed[nc][5])
			Endif
			
			If li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			Endif
			ImprLinha(nFlag,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nQuant,aPed,nC,nQtTot,nSol)
		Endif
	Next nc
	
	If nFlag == 2
		dbSelectArea("SA2")
		dbSeek(cFilial+SC1->C1_FORNECE+SC1->C1_LOJA)
		If li > 55
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		ImprLinha(2,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nQuant)
	Endif
	
	aPed := {}
	dbSelectArea("SC1")
	dbSkip()
EndDo

Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImprLinha³ Autor ³ Jose Lucas            ³ Data ³ 15.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Linha Detalhe.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void Impr200(ExpN1,ExpC1,ExpC2,ExpC3,ExpN1,ExpN2)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Flag de Controle para Impressao.                  ³±±
±±³          ³ ExpC2 := Titulo                                            ³±±
±±³          ³ ExpC1 := Cabecalho                                         ³±±
±±³          ³ ExpC1 := Nome do Programa                                  ³±±
±±³          ³ ExpN1 := Comprimento da Linha                              ³±±
±±³          ³ ExpN2 := Tipo de impressao Comprimido ou Normal            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImprLinha(nFlag,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nQuant,aPed,nC,nQtTot,nSol)

LOCAL nTamNome :=16
LOCAL nTamRedu :=16
LOCAL aColuna  := Array(12) // Posicao das colunas onde serao impressos os 
									 // dados do relatorio, podendo variar de acordo
									 // com o tamanho do Codigo do fornecedor.
aColuna[01] :=   0
aColuna[02] :=   7
aColuna[03] :=  12
aColuna[04] :=  23
aColuna[05] :=  30
aColuna[06] :=  32
aColuna[07] :=  49
aColuna[08] :=  65
aColuna[09] :=  68
aColuna[10] :=  81
aColuna[11] := 101
aColuna[12] := 122

IF aTamSXG[1] != aTamSXG[3]
	nTamNome    :=  40
	nTamRedu    :=  40
	aColuna[01] :=   0
	aColuna[02] :=   7
	aColuna[03] :=  12
	aColuna[04] :=  21
	aColuna[06] += ((aTamSXG[4]-aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
	aColuna[05] += (aTamSXG[4]-aTamSXG[3])
	aColuna[07] := 112
	aColuna[08] := 127
	aColuna[09] := 131
	aColuna[10] := 144
	aColuna[11] := 165
	aColuna[12] := 186
Endif
If nFlag == 1
	IF(nQtTot != SC1->C1_QUANT .and. nQuant != SC1->C1_QUANT .OR. aPed[nc][9] != SC1->C1_DATPRF).And.!Empty(SC1->C1_COTACAO).And.nSol!=aPed[nc][2]
		
		//Se existir mais pedidos com a mesma solicitacao imprimir
		//a Solicitacao com todos os pedidos em divergencia.
		
		If nC == 1
			@ li,aColuna[01] PSAY SC1->C1_NUM
			@ li,aColuna[02] PSAY SC1->C1_ITEM
			@ li,aColuna[03] PSAY SC1->C1_EMISSAO
			@ li,aColuna[04] PSAY SC1->C1_FORNECE
			@ li,aColuna[05] PSAY SC1->C1_LOJA
			@ li,aColuna[06] PSAY IIF(nTamNome>30,SUBS(SA2->A2_NOME,1,nTamNome),SUBS(SA2->A2_NREDUZ,1,nTamRedu))
			@ li,aColuna[07] PSAY SC1->C1_PRODUTO
			dbSelectArea("SB1")
			dbSeek(cFilial+SC1->C1_PRODUTO)
			@ li,aColuna[08] PSAY SB1->B1_UM
			@ li,aColuna[09] PSAY SC1->C1_QUANT     Picture PesqPict("SC1","C1_QUANT",12)
			@ li,aColuna[10] PSAY SC1->C1_CC
			@ li,aColuna[11] PSAY SC1->C1_CONTA     Picture "@!"
			@ li,aColuna[12] PSAY SC1->C1_DATPRF
			Li++
		Endif
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		@ li,aColuna[01] PSAY aPed[nc][1]  				//Nr. do Pedido
		@ li,aColuna[02] PSAY SC1->C1_ITEM
		@ li,aColuna[03] PSAY aPed[nc][3]  				//Dt. Emissao do Pedido
		@ li,aColuna[04] PSAY aPed[nc][4]   				//Fornecedor
		@ li,aColuna[05] PSAY aPed[nc][5]			//Loja
		@ li,aColuna[06] PSAY IIF(nTamNome>30,SUBS(SA2->A2_NOME,1,nTamNome),SUBS(SA2->A2_NREDUZ,1,nTamRedu))
		@ li,aColuna[07] PSAY aPed[nc][6]   				//Codigo Produto
		dbSelectArea("SB1")
		dbSeek(cFilial+SC1->C1_PRODUTO)
		@ li,aColuna[08] PSAY SB1->B1_UM
		@ li,aColuna[09] PSAY aPed[nc][2] Picture PesqPict("SC7","C7_QUANT",12)
		@ li,aColuna[10] PSAY aPed[nc][7]   				//Centro Custo
		@ li,aColuna[11] PSAY aPed[nc][8] Picture "@!"	//Conta Contabil do Produto
		@ li,aColuna[12] PSAY aPed[nc][9]  				//Dt.Entrega
		If nc > 1
			Li+=2
		Else
			Li++
		Endif
		
	Endif
Else
	@ li,aColuna[01] PSAY SC1->C1_NUM
	@ li,aColuna[02] PSAY SC1->C1_ITEM
	@ li,aColuna[03] PSAY SC1->C1_EMISSAO
	@ li,aColuna[04] PSAY SC1->C1_FORNECE
	@ li,aColuna[05] PSAY SC1->C1_LOJA
	@ li,aColuna[06] PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,nTamNome),SUBS(SA2->A2_NREDUZ,1,nTamRedu))
	@ li,aColuna[07] PSAY SC1->C1_PRODUTO
	
	dbSelectArea("SB1")
	dbSeek(cFilial+SC1->C1_PRODUTO)
	
	@ li,aColuna[08] PSAY SB1->B1_UM
	@ li,aColuna[09] PSAY SC1->C1_QUANT    Picture PesqPict("SC1","C1_QUANT",12)
	@ li,aColuna[10] PSAY SC1->C1_CC
	@ li,aColuna[11] PSAY SC1->C1_CONTA	 Picture "@!"
	@ li,aColuna[12] PSAY SC1->C1_DATPRF
	
	Li++
	
	
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	
	@ li,000 PSAY STR0011	//"Nao ha' pedido de compra colocado"
	Li+=2
Endif

Return .T.
