#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR225  ³ Autor ³ Marcos V. Ferreira    ³ Data ³ 08/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao simplificada das estruturas                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function MATX225()

Local oReport

If TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	U_MATX225R3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marcos V. Ferreira    ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2
Local oSection3
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
oReport:= TReport():New("MATR225",OemToAnsi("** Estruturas **"),"MTR225", {|oReport| ReportPrint(oReport)},OemToAnsi("Este programa emite a relacao de estrutura de um determinado produto")+" "+OemToAnsi("selecionado pelo usuario. Esta relacao nao demonstra custos. Caso o")+" "+OemToAnsi("produto use opcionais, sera listada a estrutura com os opcionais padrao."))  
oReport:SetLandscape()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Produto de             ³
//³ mv_par02   // Produto ate            ³
//³ mv_par03   // Tipo de                ³
//³ mv_par04   // Tipo ate               ³
//³ mv_par05   // Grupo de               ³
//³ mv_par06   // Grupo ate              ³
//³ mv_par07   // Salta Pagina: Sim/Nao  ³
//³ mv_par08   // Qual Rev da Estrut     ³
//³ mv_par09   // Imprime Ate Nivel ?    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a secao.                   ³
//³ExpA4 : Array com as Ordens do relatorio                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,"Detalhes do produto Pai",{"SG1","SB1"}) 
oSection1:SetLineStyle()

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SB1")
While !Eof() .And. (x3_arquivo == "SB1")
	If X3_CAMPO == 'B1_COD    '
		nB1_cod = SX3->X3_TAMANHO
		nB1_cod = nB1_cod + 1
	EndIf
	
	If X3_CAMPO == 'B1_DESC   '
		nB1_desc = SX3->X3_TAMANHO
		nB1_desc = nB1_desc + 1
	EndIf
	
	If X3_CAMPO == 'B1_TIPO   '
		nB1_tipo = SX3->X3_TAMANHO
		nB1_tipo = nB1_tipo + 1
	EndIf
	
	If X3_CAMPO == 'B1_GRUPO  '
		nB1_grupo = SX3->X3_TAMANHO
		nB1_grupo = nB1_grupo + 1
	EndIf
	
	If X3_CAMPO == 'B1_UM     '
		nB1_um = SX3->X3_TAMANHO
		nB1_um = nB1_um + 1
	EndIf	

	If X3_CAMPO == 'B1_QB     '
		nB1_qb = SX3->X3_TAMANHO
		nB1_qb = nB1_qb + 1
	EndIf	
	
	If X3_CAMPO == 'B1_OPC    '
		nB1_opc = SX3->X3_TAMANHO
		nB1_opc = nB1_opc + 1
	EndIf	
		
	dbSkip()
End

TRCell():New(oSection1,'G1_COD'	    ,'SG1',/*Titulo*/,/*Picture*/,nB1_cod,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC'   	,'SB1',/*Titulo*/,/*Picture*/,nB1_desc,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_TIPO'   	,'SB1',/*Titulo*/,/*Picture*/,nB1_tipo,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_GRUPO'  	,'SB1',/*Titulo*/,/*Picture*/,nB1_grupo,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_UM'	    ,'SB1',/*Titulo*/,/*Picture*/,nB1_um,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_QB'		,'SB1',/*Titulo*/,/*Picture*/,nB1_qb,/*lPixel*/, {|| IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))})
TRCell():New(oSection1,'B1_OPC'		,'SB1',/*Titulo*/,/*Picture*/,nB1_opc,/*lPixel*/, {|| RetFldProd(SB1->B1_COD,"B1_OPC")})

oSection1:SetNoFilter("SB1")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,"Estruturas",{'SG1','SB1'}) // 

TRCell():New(oSection2,'NIVEL'		,'   ','NIVEL'	    ,/*Picture*/					,10			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_COMP'	,'SG1','CODIGO'	    ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_TRT'		,'SG1','TRT'	    ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_TIPO'	,'SB1','TP'    	    ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_GRUPO'	,'SB1','GRUP'  	    ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_DESC'	,'SB1','DESCRICAO'  ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_OBSERV'	,'SG1','OBSERVACAO' ,/*Picture*/					,25			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QUANTITEM'	,'   ','QTDE.NECESSARI' ,PesqPict('SG1','G1_QUANT',14)	,14	   		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_UM'		,'SB1','UM'				,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_PERDA'	,'SG1','PERDA %'		,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_QUANT'	,'SG1','QUANTID'		,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_QB'		,'SB1','QTD.BASE'		,/*Picture*/					,/*Tamanho*/,/*lPixel*/,{||If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))})
TRCell():New(oSection2,'G1_FIXVAR'	,'SG1','TIPO QUANTID'	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_INI'		,'SG1','INI VALID'		,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_FIM'		,'SG1','FIM VALID'		,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_GROPC'	,'SG1','GRP.OPC'		,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_OPC'		,'SG1','ITEM OPC'		,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2:SetHeaderPage()
oSection2:SetNoFilter("SB1")

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³ Autor ³Marcos V. Ferreira   ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cProduto 	:= ""
Local nNivel   	:= 0
Local lContinua := .T.
Private lNegEstr:=GETMV("MV_NEGESTR")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SG1')
dbSetOrder(1)
MsSeek(xFilial('SG1')+mv_par01,.T.)
oReport:SetMeter(SG1->(LastRec()))

While !oReport:Cancel() .And. !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD <= xFilial('SG1')+mv_par02

	oReport:IncMeter()

	cProduto := SG1->G1_COD
	nNivel   := 2
    lContinua:=.T.
    
	dbSelectArea('SB1')
	MsSeek(xFilial('SB1')+cProduto)
		
	If Eof() .Or. SB1->B1_TIPO < mv_par03 .Or. SB1->B1_TIPO > mv_par04 .Or. SB1->B1_GRUPO < mv_par05 .Or. SB1->B1_GRUPO > mv_par06
		dbSelectArea('SG1')
		While !oReport:Cancel() .And. !Eof() .And. xFilial('SG1')+cProduto == SG1->G1_FILIAL+SG1->G1_COD
			dbSkip()
			oReport:IncMeter()
		EndDo
		lContinua := .F.
	EndIf

	If lContinua	
		
		oSection1:Init(.F.)
		oReport:SkipLine()     

		//--  Imprime grupo de opcionais.
		If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
			oSection1:Cell('B1_OPC'):Show()
		Else
			oSection1:Cell('B1_OPC'):Hide()
		EndIf                

		IF SB1->B1_MSBLQL == "1" 
		   _CDESNEW := "* "+SB1->B1_COD
		   oSection1:Cell('G1_COD'	):SetValue(_CDESNEW)
		ENDIF
		

		oSection1:PrintLine()
		oReport:SkipLine()     
		oSection1:Finish()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	Impressao da Sessao 2                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oSection2:Init()

		//-- Explode Estrutura
		MX225ExplG(oReport,oSection2,cProduto,IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),nNivel,RetFldProd(SB1->B1_COD,"B1_OPC"),IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))	,IIf(Empty(mv_par08),SB1->B1_REVATU,mv_par08))

		oSection2:Finish()
		
		//-- Verifica se salta ou nao pagina
		If mv_par07 == 1
			oSection1:SetPageBreak(.T.)
		Else    
			oReport:ThinLine() //-- Impressao de Linha Simples
	 	EndIf	 
	
	EndIf
	dbSelectArea("SG1")
EndDo

//-- Devolve a condicao original do arquivo principal
dbSelectArea("SG1")
Set Filter To
dbSetOrder(1)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MX225ExplG³ Autor ³ Marcos V. Ferreira    ³ Data ³ 17/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MX225Expl(ExpO1,ExpO2,ExpC3,ExpN4,ExpN5,ExpC6,ExpN7,ExpC8) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto do Relatorio                                ³±±
±±³          ³ ExpO2 = Sessao a ser impressa                              ³±±
±±³          ³ ExpC3 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN4 = Quantidade do pai a ser explodida                  ³±±
±±³          ³ ExpN5 = Nivel a ser impresso                               ³±±
±±³          ³ ExpC6 = Opcionais do produto                               ³±±
±±³          ³ ExpN7 = Quantidade do Produto Nivel Anterior               ³±±
±±³          ³ ExpC8 = Numero da Revisao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function MX225ExplG(oReport,oSection2,cProduto,nQuantPai,nNivel,cOpcionais,nQtdBase,cRevisao)
Local nReg 		  := 0
Local nQuantItem  := 0
Local nPrintNivel := 0
Local cAteNiv     := If(mv_par09=Space(3),"999",mv_par09)

dbSelectArea('SG1')
While !oReport:Cancel() .And. !Eof() .And. G1_FILIAL+G1_COD == xFilial('SG1')+cProduto
	oSection2:IncMeter()
	nReg       := Recno()
	nQuantItem := ExplEstr(nQuantPai,,cOpcionais,cRevisao)
	
	dbSelectArea('SG1')
	
	If nNivel <= Val(cAteNiv) // Verifica ate qual Nivel devera ser impresso
		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
		
			dbSelectArea('SB1')
			dbSetOrder(1)
			MsSeek(xFilial('SB1')+SG1->G1_COMP)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao da Sessao 2			                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPrintNivel:=IIf(nNivel>17,17,nNivel-2)
			oSection2:Cell('NIVEL'		):SetValue(Space(nPrintNivel)+StrZero(nNivel,3))
			oSection2:Cell('QUANTITEM'	):SetValue(nQuantItem)

			IF SB1->B1_MSBLQL == "1" 
			   _CDEXNEW := "* " + SG1->G1_COMP
			   oSection2:Cell('G1_COMP'	):SetValue(_CDEXNEW)
			ENDIF

			oSection2:PrintLine()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe sub-estrutura                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea('SG1')
			MsSeek(xFilial('SG1')+G1_COMP)
			If Found()
				MX225ExplG(oReport,oSection2,G1_COD,nQuantItem,nNivel+1,cOpcionais,IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),If(!Empty(SB1->B1_REVATU),SB1->B1_REVATU,mv_par08),0)
			EndIf

			dbGoto(nReg)

		EndIf
	EndIf
	dbSkip()
EndDo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR225R3³ Autor ³ Marcos V. Ferreira    ³ Data ³ 08/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao simplificada das estruturas - Release 3            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function MATX225R3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "G"
LOCAL titulo   := "Relacao Simplificada das Estruturas"
LOCAL cDesc1   := "Este programa emite a rela‡„o de estrutura de um determinado produto"
LOCAL cDesc2   := "selecionado pelo usu rio. Esta rela‡„o n„o demonstra custos. Caso o"
LOCAL cDesc3   := "produto use opcionais, ser  listada a estrutura com os opcionais padr„o."
LOCAL cString  := "SG1"
LOCAL wnrel	   := "MATR225"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lNegEstr:=GETMV("MV_NEGESTR")
PRIVATE aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 ,cPerg := "MTR225"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Produto de             ³
//³ mv_par02   // Produto ate            ³
//³ mv_par03   // Tipo de                ³
//³ mv_par04   // Tipo ate               ³
//³ mv_par05   // Grupo de               ³
//³ mv_par06   // Grupo ate              ³
//³ mv_par07   // Salta Pagina: Sim/Nao  ³
//³ mv_par08   // Qual Rev da Estrut     ³
//³ mv_par09   // Imprime Ate Nivel ?    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
EndIf

RptStatus({|lEnd| X225Imp(@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C225IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 11.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function X225Imp(lEnd,WnRel,titulo,Tamanho)

LOCAL cRodaTxt  := "ESTRUTURA(S)"
LOCAL nCntImpr  := 0
LOCAL nTipo     := 0
LOCAL cProduto  := ""
LOCAL nNivel    := 0
LOCAL cPictQuant:=""
LOCAL cPictPerda:=""
LOCAL nX        := 0
LOCAL nPosCnt	:= 0
LOCAL nPosOld	:= 0
LOCAL i 		:= 0  
LOCAL nEstouro
LOCAL nLen            
LOCAL nCol      :=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIf(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1   := "NIVEL                CODIGO          TRT TP GRUP DESCRICAO                          OBSERVACAO                                        QUANTIDADE UM PERDA     QUANTIDADE QTD. BASE  TIPO DE     INICIO      FIM    GRP. ITEM"
cabec2   := "                                                                                                                                      NECESSARIA      %                  ESTRUTURA QUANTIDADE  VALIDADE   VALIDADE OPCI  OPCI"
//                      99999999999999999999 999999999999999 999 99 9999 9999999999999999999999999999999999 XXXXXXXXX1XXXXXXXXX2XXXXXXXXX3XXXXXXXXX4XXXXX 9999999.999999 XX 99.99 9999999.999999   9999999  XXXXXXXX  99/99/9999 99/99/9999 XXX  XXXX
//                      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a Picture da quantidade (maximo de 14 posicoes)         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("G1_QUANT")
If X3_TAMANHO >= 14
	For nX := 1 To 14
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictQuant := cPictQuant+"."
		Else
			cPictQuant := cPictQuant+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 14
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictQuant := "."+cPictQuant
		Else
			cPictQuant := "9"+cPictQuant
		EndIf
	Next nX
EndIf
dbSeek("G1_PERDA")
If X3_TAMANHO >= 6
	For nX := 1 To 6
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictPerda := cPictPerda+"."
		Else
			cPictPerda := cPictPerda+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 6
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictPerda := "."+cPictPerda
		Else
			cPictPerda := "9"+cPictPerda
		EndIf
	Next nX
EndIf
dbSetOrder(1)
dbSelectArea("SG1")
SetRegua(LastRec())
Set SoftSeek On
dbSeek(xFilial("SG1")+mv_par01)
Set SoftSeek Off
While !Eof() .And. G1_FILIAL+G1_COD <= xFilial("SG1")+mv_par02
	If lEnd
		@ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	IncRegua()
	cProduto := G1_COD
	nNivel   := 2

	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+cProduto)

	If EOF() .Or. B1_TIPO < mv_par03 .Or. B1_TIPO > mv_par04 .Or. B1_GRUPO < mv_par05 .Or. B1_GRUPO > mv_par06
		dbSelectArea("SG1")
		While !EOF() .And. xFilial("SG1")+cProduto == G1_FILIAL+G1_COD
			dbSkip()
			IncRegua()
		EndDo

	Else

		If li > 58
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona 1 ao contador de registros impressos         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCntImpr++
		dbSelectArea("SB1") 	
		
		nEstouro := .F.                   
		
		nLen := LEN(RTRIM(cProduto))
			
		if nLen > 15
			nEstouro := .T.
  		endif
		
        IF alltrim(SB1->B1_MSBLQL) <> "1"
	 	   @ li,004 PSAY cProduto
	    ELSE
	 	   @ li,004 PSAY "(*) " + cProduto
	    ENDIF
		
		nCol := 0

		if nEstouro  
			@ li,036 PSAY '-'


        IF alltrim(SB1->B1_MSBLQL) <> "1"
  			@ li,038 PSAY SubStr(SB1->B1_DESC,1,34)
	    ELSE
			@ li,038 PSAY SubStr(SB1->B1_DESC,1,34) + " * "
	    ENDIF

			li++
			if Len(RTrim(SB1->B1_DESC)) > 34				
				@ li, 038 PSay SubStr(SB1->B1_DESC,35,34)
			EndIf
		else
			nCol := 1
		endif
		
		@ li,024 + nCol PSAY SB1->B1_TIPO
		@ li,027 + nCol PSAY SB1->B1_GRUPO    
		
		if !nEstouro
			@ li,032 + nCol PSAY SubStr(SB1->B1_DESC,1,34)
			if Len(RTrim(SB1->B1_DESC)) > 34
				li++
				@ li, 032 PSay SubStr(SB1->B1_DESC,35,34)
			EndIf
		endif
		
		@ li,105 + nCol PSAY SB1->B1_UM
		@ li,129 + nCol PSAY If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime grupo de opcionais.                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
			@ li,137 + nCol PSAY "Opc. "
			@ li,142 + nCol PSAY RetFldProd(SB1->B1_COD,"B1_OPC") Picture PesqPict("SB1","B1_OPC",80)
		EndIf
		Li += 2
		nPosOld:=nPosCnt
		nPosCnt+=MX225Expl(cProduto,IF(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),nNivel,cPictQuant,cPictPerda,RetFldProd(SB1->B1_COD,"B1_OPC"),IF(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(Empty(mv_par08),SB1->B1_REVATU,mv_par08))
		For i:=nPosOld to nPosCnt
			IncRegua()
		Next I

		//-- Verifica se salta ou nao pagina	
		If mv_par07 == 1
		    Li:= 90
		Else    
	 		@ li,000 PSAY __PrtThinLine()
	 		Li +=2
	 	EndIf	 
	EndIf
	dbSelectArea("SG1")
EndDo
If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SG1")
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf
MS_FLUSH()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MX225Expl ³ Autor ³ Eveli Morasco         ³ Data ³ 08/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MX225Expl(ExpC1,ExpN1,ExpN2,ExpC2,ExpC3,ExpC4,ExpN3)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade do pai a ser explodida                  ³±±
±±³          ³ ExpN2 = Nivel a ser impresso                               ³±±
±±³          ³ ExpC2 = Picture da quantidade                              ³±±
±±³          ³ ExpC3 = Picture da perda                                   ³±±
±±³          ³ ExpC4 = Opcionais do produto                               ³±±
±±³          ³ ExpN3 = Quantidade do Produto Nivel Anterior               ³±±
±±³          ³ As outras 6 variaveis sao utilizadas pela funcao Cabec     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function MX225Expl(cProduto,nQuantPai,nNivel,cPictQuant,cPictPerda,cOpcionais,nQtdBase,Titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,cRevisao)
LOCAL nReg,nQuantItem,nCntItens := 0
LOCAL nPrintNivel
LOCAL nX        := 0
LOCAL aObserv   := {}
LOCAL aAreaSB1:={}
LOCAL cAteNiv   := If(mv_par09=Space(3),"999",mv_par09) 
LOCAL nEstouro
LOCAL nLen 
LOCAL cComp
LOCAL nCol := 0

dbSelectArea("SG1")
While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto
	nReg       := Recno()
	nQuantItem := ExplEstr(nQuantPai,,cOpcionais,cRevisao)
	dbSelectArea("SG1")
	If nNivel <= Val(cAteNiv) // Verifica ate qual Nivel devera ser impresso
		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
			If li > 58
				Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				dbSelectArea("SB1")
				aAreaSB1:=GetArea()
				dbSeek(xFilial("SB1")+cProduto)        
				
				nEstouro := .F.                   
		
	   			nLen := LEN(RTRIM(cProduto))
			
				if nLen > 15
		 			nEstouro := .T.
  	  			endif
				
				@ li,004 PSAY cProduto  
				
				if nEstouro  
		   			@ li,036 PSAY '-'
		   			@ li,038 PSAY SubStr(SB1->B1_DESC,1,34)					
					li++
					if Len(RTrim(SB1->B1_DESC)) > 34						
						@ li, 038 PSay SubStr(SB1->B1_DESC,35,34)
					EndIf
				else
				   nCol := 1
	   			endif
				
				@ li,024 + nCol PSAY SB1->B1_TIPO
				@ li,027 + nCol PSAY SB1->B1_GRUPO  
				
				if !nEstouro 
					@ li,032 + nCol PSAY SubStr(SB1->B1_DESC,1,34)
					if Len(RTrim(SB1->B1_DESC)) > 34
						li++
						@ li, 032 PSay SubStr(SB1->B1_DESC,35,34)
					EndIf
				endif
				
				@ li,105 + nCol PSAY SB1->B1_UM
				@ li,129 + nCol PSAY If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime grupo de opcionais.                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
					@ li,137 + nCol PSAY "Opc. "
					@ li,142 + nCol PSAY RetFldProd(SB1->B1_COD,"B1_OPC") Picture PesqPict("SB1","B1_OPC",80)
				EndIf
				RestArea(aAreaSB1)
				Li += 2
				dbSelectArea("SG1")
			EndIf
		
			//-- Divide a Observa‡„o em Sub-Arrays com 45 posi‡”es
			aObserv := {}
			For nX := 1 to MlCount(AllTrim(G1_OBSERV),45)
				aAdd(aObserv, MemoLine(AllTrim(G1_OBSERV),45,nX))
			Next nX
		
			nPrintNivel:=IIF(nNivel>17,17,nNivel-2)
			@ li,nPrintNivel PSAY StrZero(nNivel,3)
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))  
			
			nEstouro := .F.                   
		    
		    cComp = G1_COMP
	 		nLen := LEN(RTRIM(cComp))
			
			if nLen > 15
		 		nEstouro := .T.
  	  		endif
  	  			
			@ li,21  PSay G1_COMP   
			
			nCol := 0
			if nEstouro  
		 		@ li,052 PSAY '-'
		   	   	@ li,054 PSAY SubStr(SB1->B1_DESC,1,34)
		  		li++
				if Len(RTrim(SB1->B1_DESC)) > 34
					@ li, 054 PSay SubStr(SB1->B1_DESC,35,34)
				EndIf
		  	else
			  	nCol := 1
	   	  	endif
			
			@ li,37 + nCol PSay Substr(G1_TRT,1,3)
			@ li,41 + nCol PSay SB1->B1_TIPO
			@ li,44 + nCol  PSay SB1->B1_GRUPO
			
			if !nEstouro
				@ li,49 + nCol PSay SubStr(SB1->B1_DESC,1,34) 
				if Len(RTrim(SB1->B1_DESC)) > 34
					li++
					@ li, 49 PSay SubStr(SB1->B1_DESC,35,34)
				EndIf
			endif
			
			@ li,84 + nCol  PSay If(Len(aObserv)>0,aObserv[1],Left(G1_OBSERV,45))
	  	    @ li,130 + nCol PSay nQuantItem Picture cPictQuant
 			@ li,145 + nCol PSay SB1->B1_UM
			@ li,147 + nCol PSay G1_PERDA   Picture cPictPerda
			@ li,152 + nCol PSay G1_QUANT   Picture cPictQuant
			@ li,168 + nCol PSay If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
			@ li,180 + nCol PSay If(G1_FIXVAR $' úV',"VARIAVEL","FIXA")
			@ li,190 + nCol PSay G1_INI	Picture PesqPict("SG1","G1_INI",10)
			@ li,201 + nCol PSay G1_FIM	Picture PesqPict("SG1","G1_FIM",10)
			@ li,212 + nCol PSay G1_GROPC	Picture PesqPict("SG1","G1_GROPC",3)
			@ li,216 + nCol PSay G1_OPC	Picture PesqPict("SG1","G1_OPC",4)
			//-- Caso existam, Imprime as outras linhas da Observa‡„o
			If Len(aObserv) > 1
				For nX := 2 to Len(aObserv)
					Li ++
					@ li,84 + nCol PSAY aObserv[nX]
				Next nX
			EndIf
		
			Li++
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe sub-estrutura                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SG1")
			dbSeek(xFilial("SG1")+G1_COMP)
			If Found()
				MX225Expl(G1_COD,nQuantItem,nNivel+1,cPictQuant,cPictPerda,cOpcionais,IF(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(!Empty(SB1->B1_REVATU),SB1->B1_REVATU,mv_par08))
			EndIf
			dbGoto(nReg)
		EndIf
	EndIf
	dbSkip()
	nCntItens++
EndDo
nCntItens--
Return nCntItens
