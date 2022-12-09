#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MATR875   ³ Autor ³Felipe Nunes Toledo    ³ Data ³ 06/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao para Analise dos Estoques.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß           
*/
USER Function MATX875()
Local   oReport

If TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	U_MATX875R3()
EndIf

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Felipe Nunes Toledo    ³ Data ³06/07/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATR875			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport
Local oSection1    // Secao 1
Local oSection2    // Secao 2
Local cTitle    := OemToAnsi("Relacao para Analise dos Estoques")
Local cAliasSG1 := GetNextAlias()


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
oReport:= TReport():New("MATX875",cTitle,"MTR875", {|oReport| ReportPrint(oReport,cAliasSG1)},OemToAnsi("Este relat¢rio demonstra a situa‡„o de cada item da estrutura")+" "+OemToAnsi("do produto Pai em rela‡„o ao seu saldo , seu empenho , suas  ")+" "+OemToAnsi("entradas previstas e sua classe ABC.")) //######
oReport:SetLandscape() //Define a orientacao de pagina do relatorio como paisagem.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas (MTR875)                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // De Produto                                   ³
//³ mv_par02     // Ate Produto                                  ³
//³ mv_par03     // Lista itens fantasmas   (1-Sim 2-Nao)        ³
//³ mv_par04     // Lista Estr. do fantasma (1-Sim 2-Nao)        ³
//³ mv_par05     // Impr. OP's Firmes, Previstas ou Ambas        ³
//³ mv_par06     // De   Almoxarifado ?                          ³ 
//³ mv_par07     // Ate  Almoxarifado ?                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(oReport:GetParam(),.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao das secoes utilizadas pelo relatorio                            ³
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ oSection1 (Impressao Produto Pai)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,"Estruturas",{"SG1","SB1","SB2"},/*Ordem*/) //
oSection1:SetHeaderBreak()

TRCell():New(oSection1,'G1_COD' 	,'SG1', 'Produto Pai' ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B2_QATU'	,'SB2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ oSection2 (Impressao Componentes)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,"Produtos",{"SG1","SB1","SC1","SD4","SC7","SC2","SC6","SB3","SB2"},/*Ordem*/) //
oSection2:SetHeaderPage()

TRCell():New(oSection2,'B1_COD'  	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_DESC' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'B1_TIPO' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_QUANT' 	,'SG1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_GRUPO'  	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_UM'  	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B2_QATU' 	,'SB2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B2_QEMP' 	,'SB2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B2_RESERVA' ,'SB2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'C7_QUANT' 	,'SC7', 'PCs Coloca' ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'C2_QUANT' 	,'SC2', 'OPs Coloca' ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'C6_QTDVEN' 	,'SC6', 'PVs Coloca' ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_EMIN' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,  {|| RetFldProd(SB1->B1_COD,"B1_EMIN") })
TRCell():New(oSection2,'B1_LE' 	    ,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,  {|| RetFldProd(SB1->B1_COD,"B1_LE")   })
TRCell():New(oSection2,'B1_PE' 	    ,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,  {|| RetFldProd(SB1->B1_COD,"B1_PE") })
TRCell():New(oSection2,'B1_TIPE'	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,  {|| RetFldProd(SB1->B1_COD,"B1_TIPE") })
TRCell():New(oSection2,'B3_MEDIA' 	,'SB3',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B2_USAI' 	,'SB2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B3_CLASSE' 	,'SB3',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_FANTASM'	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,  {|| RetFldProd(SB1->B1_COD,"B1_FANTASM") })  // Projeto Implementeacao de campos MRP e FANTASM no SBZ
TRCell():New(oSection2,'G1_COD'	    ,'SG1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:SetNoFilter({"SB1","SB2"})
oSection2:SetNoFilter({"SG1","SB1","SC1","SD4","SC7","SC2","SC6","SB3","SB2"})

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³ Autor ³Felipe Nunes Toledo  ³ Data ³06/07/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR875			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSG1)
Local oSection1  := oReport:Section(1)
Local oSection2  := oReport:Section(1):Section(1)
Local oBreak, oBreak2
Local oFunction
Local cFilter
Local nCntFor
Local nSaldoPai  := 0
Local aSalAlm    := {}
Local aPai       := {}
Local lSkip      := .F.
Local cSeekAux   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis usadas na impressao dos componentes da Estrutura   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nSaldoEst:=nEmp:=nSCPro:=nPCPro:=nOPPro:=nPVPro:=NRESERVA:=0
Private dUsai := CtoD("  /  /  ") 

dbSelectarea("SG1")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MakeSqlExpr(oReport:GetParam())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatorio                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

BEGIN REPORT QUERY oSection1
BeginSql Alias cAliasSG1

SELECT G1_FILIAL, G1_COD, G1_COMP, G1_TRT, G1_QUANT, R_E_C_N_O_ SG1RecNo
FROM %table:SG1% SG1
WHERE G1_FILIAL  = %xFilial:SG1%   AND                                 
  		G1_COD          >= %Exp:mv_par01%  AND 
  		G1_COD          <= %Exp:mv_par02%  AND 
SG1.%NotDel%

ORDER BY %Order:SG1%		

EndSql 
END REPORT QUERY oSection1 

TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1") + (cAliasSG1)->G1_COD})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definindo a quebra do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBreak := TRBreak():New(oSection1,oSection1:Cell('G1_COD'),NIL,.F.)
oBreak2:= TRBreak():New(oSection2,oSection2:Cell('G1_COD'),NIL,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definindo os totalizadores do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFunction := TRFunction():New(oSection2:Cell('B2_QATU'    ),NIL,"SUM",oBreak2,NIL,/*Picture*/,/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection2:Cell('B2_QEMP'    ),NIL,"SUM",oBreak2,NIL,/*Picture*/,/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection2:Cell('B2_RESERVA' ),NIL,"SUM",oBreak2,NIL,/*Picture*/,/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection2:Cell('C7_QUANT'   ),NIL,"SUM",oBreak2,NIL,/*Picture*/,/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection2:Cell('C2_QUANT'   ),NIL,"SUM",oBreak2,NIL,/*Picture*/,/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection2:Cell('C6_QTDVEN'  ),NIL,"SUM",oBreak2,NIL,/*Picture*/,/*uFormula*/,.F.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inibindo o titulo da secao 1                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:Cell('B1_DESC'):HideHeader()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inibindo impressao da celula utilizada apenas para Quebra               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2:Cell('G1_COD'):Hide()
oSection2:Cell('G1_COD'):HideHeader()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter( SG1->(LastRec()) )
oSection1:Init()
While !oReport:Cancel() .And. !(cAliasSG1)->(Eof())
	oReport:IncMeter()
	If mv_par04 == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona SB1 para produto Pai	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek( xFilial("SB1")+(cAliasSG1)->G1_COD ) 
		If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S"  // Projeto Implementeacao de campos MRP e FANTASM no SBZ
			dbSelectArea(cAliasSG1)
			dbSkip()
			Loop
		Endif
	Endif
	
	dbSelectArea(cAliasSG1)
	nSaldoPai := 0

	nScan:=aScan(aPai,(cAliasSG1)->G1_COD)
	If nScan == 0
		AADD(aPai,(cAliasSG1)->G1_COD)
	Else
		(cAliasSG1)->(dbSkip())
		Loop
	EndIf
    
    aEstru := {}
	nReg   := (cAliasSG1)->(Recno())
	ExplodX((cAliasSG1)->G1_COD)
	dbGoto(nReg)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona SB2 para Produto Pai					             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+(cAliasSG1)->G1_COD)
	While B2_FILIAL+B2_COD == xFilial()+(cAliasSG1)->G1_COD
		If B2_LOCAL >= mv_par06 .And. B2_LOCAL <= mv_par07
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega array com dados do produto na data base.             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSalAlm	  := CalcEst((cAliasSG1)->G1_COD,B2_LOCAL,dDataBase+1)
			nSaldoPai += aSalAlm[1]
			cSeekAux  := B2_LOCAL
			
		EndIf
		dbSkip()
		lSkip := .T.
	End
	
	// Reposiciona no registro corrente da tabela SB2, para correta exibicao de campos personalizados
	If lSkip
		MsSeek(xFilial("SB2")+(cAliasSG1)->G1_COD+cSeekAux) // FILIAL+COD+LOCAL
	EndIf
	
	dbSelectArea(cAliasSG1)
	oSection1:Cell('B2_QATU'):SetValue( nSaldoPai )
	oReport:SkipLine()
	oSection1:PrintLine() // Impressao da secao 1
	oSection2:Init()
	
	For nCntFor :=1 to Len(aEstru)
		If mv_par03 == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona SB1 para produto Pai	     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+aEstru[nCntFor,1])
			If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
				Loop
			Endif
		Endif
		ImprimX(Nil,Nil,nCntFor,.T.)
		oSection2:Cell('B1_COD'    ):SetValue( SB1->B1_COD   )
		oSection2:Cell('B1_DESC'   ):SetValue( SB1->B1_DESC  )
//		oSection2:Cell('B1_TIPO'   ):SetValue( SB1->B1_TIPO  )
		oSection2:Cell('G1_QUANT'  ):SetValue( aEstru[nCntFor,2]  )
		oSection2:Cell('B1_GRUPO'  ):SetValue( SB1->B1_GRUPO )
		oSection2:Cell('B1_UM'     ):SetValue( SB1->B1_UM    )
		oSection2:Cell('B2_QATU'   ):SetValue( nSaldoEst     )
		oSection2:Cell('B2_QEMP'   ):SetValue( nEmp          )
		oSection2:Cell('B2_RESERVA'):SetValue( nRESERVA      )
		oSection2:Cell('C7_QUANT'  ):SetValue( nPCPro        )
		oSection2:Cell('C2_QUANT'  ):SetValue( nOPPro        )
		oSection2:Cell('C6_QTDVEN' ):SetValue( nPVPro        )
		oSection2:Cell('B1_EMIN'   ):SetValue( RetFldProd(SB1->B1_COD,"B1_EMIN") )
		oSection2:Cell('B1_LE'     ):SetValue( RetFldProd(SB1->B1_COD,"B1_LE") )
		oSection2:Cell('B1_PE'     ):SetValue( RetFldProd(SB1->B1_COD,"B1_PE") )
		oSection2:Cell('B1_TIPE'   ):SetValue( RetFldProd(SB1->B1_COD,"B1_TIPE") )
		oSection2:Cell('B3_MEDIA'  ):SetValue( SB3->B3_MEDIA   )
		oSection2:Cell('B2_USAI'   ):SetValue( dUsai           )
		oSection2:Cell('B3_CLASSE' ):SetValue( SB3->B3_CLASSE  )
		oSection2:Cell('B1_FANTASM'):SetValue( If(RetFldProd(SB1->B1_COD,"B1_FANTASM")=='S','F','N') ) // Projeto Implementeacao de campos MRP e FANTASM no SBZ
		
		oSection2:PrintLine() // Impressao da secao 2
	Next nCntFor
	oSection2:Finish()
	dbSelectArea(cAliasSG1)
	dbGoto(nReg)
	dbSkip()
EndDo
dbSelectArea("SC1")
dbSetOrder(1)
dbSelectArea("SC2")
dbSetOrder(1)
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SC7")
dbSetOrder(1)

oSection1:Finish()
(cAliasSG1)->(DbCloseArea())

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATR875   ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 02.08.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao da Analise de Estoques Referentes ao Produto Pai    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Pim.³24/11/97³13529A³ Criacao de param.p/ listar itens fantasm.³±±
±±³            ³        ³13529A³ e listar estru. do fantasma.             ³±±
±±³Edson   M.  ³19/01/98³XXXXXX³ Inclusao do Campo C2_SLDOP.              ³±±
±±³Edson   M.  ³03/02/98³XXXXXX³ Subst. do Campo C2_SLDOP por funcao.     ³±±
±±³Rodrigo Sart³20/05/98³14386A³ Acerto no filtro das SC's (SC1)          ³±±
±±³Marcos Simi.³01/07/98³13110A³ Acertos no lay-out de impressao.         ³±±
±±³Rodrigo Sart³04/11/98³XXXXXX³ Acerto p/ Bug Ano 2000                   ³±±
±±³Fernando J. ³07/02/99³META  ³Imprimir OP's Firmes, Previstas ou Ambas. ³±±
±±³Patricia Sal³27/07/00³005280³Incluir mv_par06: "Qual Almoxarifado ?"   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function MATX875R3()
LOCAL titulo 	:= "Relacao para Analise dos Estoques"
LOCAL cString  	:= "SG1"
LOCAL wnrel 	:= "MATR875"
LOCAL cDesc1   	:= "Este relat¢rio demonstra a situa‡„o de cada item da estrutura"
LOCAL cDesc2   	:= "do produto Pai em rela‡„o ao seu saldo , seu empenho , suas  "
LOCAL cDesc3   	:= "entradas previstas e sua classe ABC."
LOCAL Tamanho  	:= "G"
LOCAL i			:= 0

PRIVATE aReturn	:= {"Zebrado",1,"Administracao", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0
PRIVATE cPerg 	:= "MTR875"  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // De Produto                                   ³
//³ mv_par02     // Ate Produto                                  ³
//³ mv_par03     // Lista itens fantasmas   (1-Sim 2-Nao)        ³
//³ mv_par04     // Lista Estr. do fantasma (1-Sim 2-Nao)        ³
//³ mv_par05     // Impr. OP's Firmes, Previstas ou Ambas        ³
//³ mv_par06     // De   Almoxarifado ?                          ³ 
//³ mv_par07     // Ate  Almoxarifado ?                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| X875Imp(@lEnd,wnRel,titulo,tamanho,cString)},titulo)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R875Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR875			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function X875Imp(lEnd,wnRel,titulo,tamanho,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cRodaTxt := "PRODUTO(S)"
Local i			:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para controle do cursor de progressao do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nSaldoEst:= 0
LOCAL aSalAlm  := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nColAdd  := 0
PRIVATE nomeprog := "MATX875"
PRIVATE nTipo    := 0
PRIVATE cabec1,cabec2
PRIVATE nCntImpr := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array usado na impressao da estrutura                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aEstru:={}
PRIVATE aPai  :={}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis usadas na impressao dos componentes da Estrutura   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nSaldoEst:=nEmp:=nSCPro:=nPCPro:=nOPPro:=nPVPro:=NRESERVA:=0
PRIVATE dUsai := CtoD("  /  /  ")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis usadas na impressao da totalizacao do produto PAI  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nTotSaldo:=nTotEmp:=nTotSCPro:=nTotPCPro:=nTotOPPro:=nTotPVPro:=0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nColadd := iif(TamSx3('B1_COD')[1] > 15,TamSx3('B1_COD')[1]-15,0)

If !tamsx3('B1_COD')[1] > 15
	cabec1 := "CODIGO          DESCRICAO                     QTD GRUP       SALDO ATUAL   EMPENHO PARA           SC's           PC's           OP's           PV's     PONTO DE         LOTE   PRAZO EST.EM       CONSUMO  ULTIMA   CL  TP"
Else	
	cabec1 := "CODIGO          DESCRICAO                     QTD GRUP       SALDO ATUAL   EMPENHO PARA           SC's           PC's           OP's           PV's     PONTO DE         LOTE   PRAZO EST.EM       CONSUMO   ULTIMA   CL  TP"
EndIf

cabec2 := "                                                                         REQ/PV/RESERVA      COLOCADAS      COLOCADOS      COLOCADAS      COLOCADOS       PEDIDO    ECONOMICO ENTREGA  MESES         MEDIO   SAIDA      N/F"

//*****  	     	      123456789012345 123456789012345678901234567890 12 1234 12 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 9,999,999.99 9,999,999.99 99999 D  99999 99,999,999.99  11/11/1111 A  X
//***** 			      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//***** 		         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial())

SetRegua(LastRec())

lFirst	 :=.F.
lContinua := .T.

While !Eof() .And. xFilial()==SG1->G1_FILIAL
	
	If lEnd
		@ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIf
	
	IncRegua()
	
	If G1_COD < mv_par01 .Or. G1_COD > mv_par02
		dbSkip()
		Loop
	EndIf
	
	If mv_par04 == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona SB1 para produto Pai	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+SG1->G1_COD)
		If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
			dbSelectArea("SG1")
			dbSkip()
			Loop
		Endif
	Endif
	dbSelectArea("SG1")
	
	nScan:=aScan(aPai,G1_COD)
	If nScan == 0
		AADD(aPai,G1_COD)
	Else
		dbSkip()
		Loop
	EndIf
	
	aEstru := {}
	nReg   := Recno()
	ExplodX(G1_COD)
	dbGoto(nReg)
	
	If li > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona 1 ao contador de registros impressos         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCntImpr++
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Zera variaveis para Impressao do Total do produto Pai		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldoEst:=nTotSaldo:=nTotEmp:=nTotSCPro:=nTotPCPro:=nTotOPPro:=nTotPVPro:=0      
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona SB1 para produto Pai					             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+SG1->G1_COD)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona SB2 para Produto Pai					             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial()+SG1->G1_COD)
	While B2_FILIAL+B2_COD == xFilial()+SG1->G1_COD
		If B2_LOCAL >= mv_par06 .And. B2_LOCAL <= mv_par07
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega array com dados do produto na data base.             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSalAlm	:= CalcEst(SG1->G1_COD,B2_LOCAL,dDataBase+1)
			nSaldoEst+= aSalAlm[1]
		EndIf
		dbSkip()
	EndDo
	dbSelectArea("SG1")
	If lFirst
		@ li,000 PSAY __PrtThinLine()
		li++
	EndIf

	@ li,000    PSAY "PRODUTO PAI: " + SG1->G1_COD + " - " + SB1->B1_DESC + "  SALDO ATUAL  ---> "
	@ li,PCol() PSAY nSaldoEst Picture PesqPictQt("B2_QATU",14)
	li++
	li++
	lFirst:=.T.
	
	For i:=1 to Len(aEstru)
		If mv_par03 == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona SB1 para produto Pai	     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+aEstru[i,1])
			If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
				Loop
			Endif
		Endif
		ImprimX(titulo,tamanho,i,.F.)
	Next i
	
	ImpToX(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbGoto(nReg)
	dbSkip()
	
End

dbSelectArea("SC1")
dbSetOrder(1)
dbSelectArea("SC2")
dbSetOrder(1)
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SC7")
dbSetOrder(1)

If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cString)
Set Filter To
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return NIL

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Explode  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 03/08/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Explode(ExpC1) 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR875                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
STATIC Function ExplodX(cProduto)
LOCAL nRegi

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial()+cProduto)

While !Eof() .And. G1_FILIAL+G1_COD == xFilial()+cProduto
	
	nRegi    := Recno()
	nProcura := Ascan(aEstru,{|X| X[1] == SG1->G1_COMP})   //aScan(aEstru,G1_COMP,1)
	If nProcura  = 0
		AADD(aEstru,{G1_COMP,G1_QUANT})
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe sub-estrutura                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRecno := Recno()
	If dbSeek(xFilial()+G1_COMP,.F.)
		ExplodX(G1_COD)
	Else
		dbGoto(nRecno)
		nProcura :=  Ascan(aEstru,{|X| X[1] == SG1->G1_COMP})  //aScan(aEstru,G1_COMP,1)
		If nProcura  = 0
			AADD(aEstru,{G1_COMP,G1_QUANT})
		EndIf
	Endif
	
	dbGoto(nRegi)                                                 
	dbSkip()

End
Return(aEstru)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Imprime  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 03/08/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime a Analise de Estoque de cada Nivel de uma estrutura³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Imprime()		 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR875                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
STATIC Function ImprimX(titulo,tamanho,i,lRelease4)
LOCAL lSB3:=.F.      
LOCAL aSalAlm  := {}
Local lSkip    := .F.
Local cSeekAux := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zerando os valores das variaveis utiliadas na impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSaldoEst:=nEmp:=nSCPro:=nPCPro:=nOPPro:=nPVPro:=NRESERVA:=0
dUsai := CtoD("  /  /  ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona os indices dos arquivos consultados                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC1")
dbSetOrder(2)
dbSelectArea("SC2")
dbSetOrder(2)
dbSelectArea("SC6")
dbSetOrder(2)
dbSelectArea("SC7")
dbSetOrder(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona SB1 										         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)         
If dbSeek(xFilial()+aEstru[i,1])
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona SB2											     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial()+aEstru[i,1])                  
	While B2_FILIAL+B2_COD == xFilial()+aEstru[i,1]
		If B2_LOCAL >= mv_par06 .And. B2_LOCAL <= mv_par07
			nEmp += (If(mv_par05==1,SB2->B2_QEMP,If(mv_par05==2,SB2->B2_QEMPPRE,SB2->B2_QEMP+SB2->B2_QEMPPRE))+SB2->B2_RESERVA)
			NRESERVA += SB2->B2_RESERVA
			aSalAlm  := CalcEst(B2_COD,SB2->B2_LOCAL,dDataBase+1)
			nSaldoEst+= aSalAlm[1]
						
			If dUsai < B2_USAI
        		dUsai := B2_USAI
			EndIf
			cSeekAux := B2_LOCAL
		EndIf
		dbSkip()
		lSkip := .T.
	End
	
	// Reposiciona no registro corrente da tabela SB2, para correta exibicao de campos personalizados
	If lRelease4 .And. lSkip 
		MsSeek(xFilial("SB2")+aEstru[i,1]+cSeekAux)  // ORDER 1 - FILIAL + PRODUTO + LOCAL
		lSkip    := .F.
		cSeekAux := ""
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona-se no arquivo de Demandas para pegar dados         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB3")
	lSB3:=dbSeek(xFilial()+aEstru[i,1])
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aglutina as Solicitacos de Compra sem pedido colocado        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC1")
	dbSeek(xFilial()+aEstru[i,1])
	While !Eof() .And. C1_FILIAL+C1_PRODUTO == xFilial()+aEstru[i,1]
		//-- Valida se a OP deve ser Impressa ou n„o
		If !MtrAValOP(mv_par05, 'SC1')
			dbSkip()
			lSkip := .T.
			Loop
		EndIf
		If C1_LOCAL < mv_par06 .Or. C1_LOCAL > mv_par07
			dbSkip()
			lSkip := .T.
			Loop	
		EndIf
		If C1_QUJE < C1_QUANT .And. Empty(C1_PEDIDO)
			nSCPro += (C1_QUANT - C1_QUJE)
			cSeekAux := C1_NUM + C1_ITEM + C1_FORNECE + C1_LOJA
		EndIf
		dbSkip()
		lSkip := .T.
	EndDo
	
	// Reposiciona no registro corrente da tabela SC1, para correta exibicao de campos personalizados
	If lRelease4 .And. lSkip
		MsSeek(xFilial("SC1")+aEstru[i,1]+cSeekAux) // ORDER 2 - FILIAL+PRODUTO+NUM+ITEM+FORNECE+LOJA
		lSkip    := .F.
		cSeekAux := ""
	EndIf	
	
	dbSelectArea("SD4")
	dbSetOrder(1)
	dbSeek(cSeek := xFilial("SD4") + aEstru[i,1])
	do While ! Eof() .And. SD4->(D4_FILIAL + D4_COD) == cSeek
		If SD4->D4_QUANT < 0
			nSCPro += ( SD4->D4_QUANT * -1 )
			cSeekAux := SD4->D4_OP + SD4->D4_TRT + SD4->D4_LOTECTL + SD4->D4_NUMLOTE
		Endif
		dbSkip()
		lSkip := .T.
	Enddo		
	
	// Reposiciona no registro corrente da tabela SD4, para correta exibicao de campos personalizados
	If lRelease4 .And. lSkip
		MsSeek(xFilial("SD4") + aEstru[i,1]+cSeekAux) // ORDER 1 - FILIAL+COD+OP+TRT+LOTECTL+NUMLOTE
		lSkip 	  := .F.
		cSeekAux := ""
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aglutina as Ordens de Producao em aberto                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC2")
	dbSeek(xFilial()+aEstru[i,1])
	While !Eof() .And. C2_FILIAL+C2_PRODUTO == xFilial()+aEstru[i,1]
		//-- Valida se a OP deve ser Impressa ou n„o
		If !MtrAValOP(mv_par05, 'SC2')
			dbSkip()
			lSkip := .T.
			Loop
		EndIf
		If C2_LOCAL < mv_par06 .Or. C2_LOCAL > mv_par07
			dbSkip()
			lSkip := .T.
			Loop	
		EndIf		
		If Empty(C2_DATRF) .And. aSC2Sld() > 0
			nOPPro += aSC2Sld()
			cSeekAux := DTOS(C2_DATPRF)
		EndIf
		dbSkip()
		lSkip := .T.
	EndDo
	
	// Reposiciona no registro corrente da tabela SC2, para correta exibicao de campos personalizados
	If lRelease4 .And. lSkip
		MsSeek(xFilial("SC2")+aEstru[i,1]+cSeekAux) // ORDER 2 - FILIAL+PRODUTO+DTOS(DATPRF)
		lSkip 	  := .F.
		cSeekAux := ""
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aglutina os Pedidos de Vendas ainda nao entregues            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC6")
	dbSeek(xFilial()+aEstru[i,1])
	While !Eof() .And. C6_FILIAL+C6_PRODUTO == xFilial()+aEstru[i,1]
		//-- Valida se a OP deve ser Impressa ou n„o
		If !MtrAValOP(mv_par05, 'SC6')
			dbSkip()
			lSkip := .T.
			Loop
		EndIf
		If C6_LOCAL < mv_par06 .Or. C6_LOCAL > mv_par07
			dbSkip()
			lSkip := .T.
			Loop	
		EndIf
		If ( C6_QTDVEN - ( C6_QTDEMP + C6_QTDENT ) ) > 0
			nPVPro += ( C6_QTDVEN - ( C6_QTDEMP + C6_QTDENT ) )
			cSeekAux := C6_NUM + C6_ITEM
		EndIf
		dbSkip()
		lSkip := .T.
	EndDo
	
	// Reposiciona no registro corrente da tabela SC6, para correta exibicao de campos personalizados
	If lRelease4 .And. lSkip
		MsSeek(xFilial("SC6")+aEstru[i,1]+cSeekAux) // ORDER 2 - FILIAL+PRODUTO+NUM+ITEM
		lSkip    := .F.
		cSeekAux := ""
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aglutina os Pedidos de Compra ainda nao entregues            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC7")
	dbSeek(xFilial()+aEstru[i,1])
	While !Eof() .And. C7_FILIAL+C7_PRODUTO == xFilial()+aEstru[i,1]
		//-- Valida se a OP deve ser Impressa ou n„o
		If !MtrAValOP(mv_par05, 'SC7')
			dbSkip()
			lSkip := .T.
			Loop
		EndIf
		If C7_LOCAL < mv_par06 .Or. C7_LOCAL > mv_par07
			dbSkip()
			lSkip := .T.
			Loop	
		EndIf
		If (C7_QUANT-C7_QUJE) > 0 .And. Empty(C7_RESIDUO)
			nPCPro += (C7_QUANT-C7_QUJE)
			cSeekAux := C7_FORNECE + C7_LOJA + C7_NUM
		EndIf
		dbSkip()
		lSkip := .T.
	EndDo
	
	// Reposiciona no registro corrente da tabela SC7, para correta exibicao de campos personalizados
	If lRelease4 .And. lSkip
		MsSeek(xFilial("SC7")+aEstru[i,1]+cSeekAux) // ORDER 2 - FILIAL+PRODUTO+FORNECE+LOJA+NUM
		lSkip    := .F.
		cSeekAux := ""
	EndIf

	If !lRelease4
		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		EndIf             

		@ li,000 PSAY SB1->B1_COD
		@ li,016+nColadd PSAY Substr(SB1->B1_DESC,1,30)
		
		If nColadd > 0
			li++
			
			If li > 58
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf 
			
			@ li,000 PSAY "-"
		EndIf
		
		@ li,047 PSAY aEstru[i,2] Picture "@e 999.99"
		@ li,055 PSAY SB1->B1_GRUPO
//		@ li,055 PSAY SB1->B1_UM
		@ li,058 PSAY nSaldoEst    	Picture PesqPictQt("B2_QATU",14)
		@ li,073 PSAY nEmp			Picture PesqPictQt("B2_QEMP",14)
		@ li,088 PSAY nRESERVA    		Picture PesqPictQt("B2_RESERVA",14)
		@ li,103 PSAY nPCPro    		Picture PesqPictQt("C7_QUANT",14)
		@ li,118 PSAY nOPPro    		Picture PesqPictQt("C2_QUANT",14)
		@ li,133 PSAY nPVPro    		Picture PesqPictQt("C6_QTDVEN",14)
		@ li,148 PSAY RetFldProd(SB1->B1_COD,"B1_EMIN") Picture PesqPictQt("B1_EMIN",12)
		@ li,161 PSAY RetFldProd(SB1->B1_COD,"B1_LE") 	 Picture PesqPictQt("B1_LE",12)
		@ li,174 PSAY RetFldProd(SB1->B1_COD,"B1_PE") Picture PesqPictQt("B1_PE",12)
		@ li,180 PSAY RetFldProd(SB1->B1_COD,"B1_TIPE")
		If lSB3
			If SB3->B3_MEDIA != 0
				@ li,183 PSAY nSaldoEst/SB3->B3_MEDIA Picture "99999"
			Else
				@ li,183 PSAY "99999"
			EndIf
			@ li,189 PSAY SB3->B3_MEDIA Picture PesqPictQt("B3_MEDIA",13)
		EndIf
		@ li,204 PSAY SB2->B2_USAI
		If lSB3
			@ li,215 PSAY SB3->B3_CLASSE
		EndIf
		If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
			@ li,218 PSAY "F"
		Else
			@ li,218 PSAY "N"
		Endif
		li++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Soma no Totalizador por Produto Pai				       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotSaldo+=nSaldoEst
		nTotEmp+=nEmp
		nTotSCPro+=NRESERVA
		nTotPCPro+=nPCPro
		nTotOPPro+=nOPPro
		nTotPVPro+=nPVPro
	EndIf
EndIf
Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ ImpTot   ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 03/08/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Totais por Produto Pai                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ ImpTot()	    	 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR875                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
STATIC Function ImpToX(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)

li++
If li > 58
	Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	li++
EndIf
@ li,000 PSAY "T O T A I S  :"
@ li,058 PSAY nTotSaldo			Picture PesqPictQt("B2_QATU",14)
@ li,073 PSAY nTotEmp			Picture PesqPictQt("B2_QEMP",14)
@ li,088 PSAY nTotSCPro    		Picture PesqPictQt("B2_RESERVA",14)
@ li,103 PSAY nTotPCPro    		Picture PesqPictQt("C7_QUANT",14)
@ li,118 PSAY nTotOPPro    		Picture PesqPictQt("C2_QUANT",14)
@ li,133 PSAY nTotPVPro    		Picture PesqPictQt("C6_QTDVEN",14)
li++

Return