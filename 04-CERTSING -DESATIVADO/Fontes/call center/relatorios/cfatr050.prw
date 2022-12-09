#INCLUDE "FATR050.ch"
#INCLUDE "FATR050.CH"
#include "fivewin.ch"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FATR050  ³ Autor ³ Marco Bianchi         ³ Data ³25/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Relatorio de metas de vendas x realizado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER Function CFATR050()

Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³25/05/2006³±±
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
Local cAliasQry := GetNextAlias()

Private nValReal := 0					// Valor Real
Private nQtdReal := 0					// Quantidade Real
Private nValMeta := 0					// Valor da Meta
Private aVendas  := { 0, 0, 0 } 		
Private aDevol   := { 0, 0, 0 }   

	
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
oReport := TReport():New("FATR050",STR0007,"FTR050P9R1", {|oReport| ReportPrint(oReport,cAliasQry)},STR0008+ " " + STR0009)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)
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
oMetas := TRSection():New(oReport,STR0020,{"SCT"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oMetas:SetTotalInLine(.F.)

TRCell():New(oMetas,"CT_DOC"    ,"SCT",STR0019   ,/*Picture*/			  			,TamSX3("CT_DOC")		[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Codigo da Meta
TRCell():New(oMetas,"CT_SEQUEN" ,"SCT",STR0012   ,/*Picture*/			  			,TamSX3("CT_SEQUEN")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Sequencia da Meta
TRCell():New(oMetas,"CT_DESCRI" ,"SCT",STR0011   ,/*Picture*/			  			,TamSX3("CT_DESCRI")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Descricao da Meta
TRCell():New(oMetas,"CT_DATA"   ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_DATA")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Data da Meta
TRCell():New(oMetas,"CT_VEND"   ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_VEND")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Codigo do Vendedor
TRCell():New(oMetas,"CT_REGIAO" ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_REGIAO")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Regiao
TRCell():New(oMetas,"CT_PRODUTO","SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_PRODUTO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Codigo do Produto
TRCell():New(oMetas,"CT_GRUPO"  ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_GRUPO")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Grupo do Produto
TRCell():New(oMetas,"CT_TIPO"   ,"SCT",STR0013   ,/*Picture*/			  			,TamSX3("CT_TIPO")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Tipo do Produto
TRCell():New(oMetas,"NVALMETA"  ,"   ",STR0010   ,PesqPict("SCT","CT_VALOR")	,TamSX3("CT_VALOR")	[1],/*lPixel*/,{|| xMoeda( CT_VALOR, CT_MOEDA, MV_PAR10, CT_DATA ) })	// Valor da Meta
TRCell():New(oMetas,"CT_QUANT"  ,"SCT",STR0018   ,PesqPict("SCT","CT_QUANT")	,TamSX3("CT_QUANT")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Quantidade da Meta
TRCell():New(oMetas,"NVALREAL"  ,"   ",STR0014   ,PesqPict("SCT","CT_VALOR")	,TamSX3("CT_VALOR")	[1],/*lPixel*/,{|| nValReal })			        						// Valor Real
TRCell():New(oMetas,"NQTDREAL"  ,"   ",STR0015   ,PesqPict("SCT","CT_QUANT") ,TamSX3("CT_QUANT")	[1],/*lPixel*/,{|| nQtdReal })											// Quantidade Real
TRCell():New(oMetas,"nVRMM"     ,"   ",STR0016   ,PesqPict("SCT","CT_VALOR")	,TamSX3("CT_VALOR")	[1],/*lPixel*/,{|| nValReal - nValMeta })								// Valor Real - Meta
TRCell():New(oMetas,"nQRMM"     ,"   ",STR0017   ,PesqPict("SCT","CT_QUANT")	,TamSX3("CT_QUANT")	[1],/*lPixel*/,{|| nQtdReal - CT_QUANT })								// Quantidade Real - Meta

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Eduardo Riera          ³ Data ³04.05.2006³±±
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
Static Function ReportPrint(oReport,cAliasQry)

Local cEstoq 	:= If( (mv_par12 == 1),"'S'",If( (mv_par12 == 2),"'N'","'S','N'" ) )
Local cDupli 	:= If( (mv_par11 == 1),"'S'",If( (mv_par11 == 2),"'N'","'S','N'" ) )

#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	
		
	BeginSql Alias cAliasQry
    SELECT SCT.* 
		FROM %table:SCT% SCT
		WHERE CT_FILIAL = %xFilial:SCT% AND  
		CT_REGIAO >= %Exp:MV_PAR03% AND 
		CT_REGIAO <= %Exp:MV_PAR04% AND 		
		CT_DATA   >= %Exp:DToS(MV_PAR08)% AND 
		CT_DATA   <= %Exp:DToS(MV_PAR09)% AND 	
		SCT.%notdel% 
		ORDER BY CT_VEND, CT_CATEGO
	EndSql 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery({MV_PAR05,MV_PAR06})
		
#ELSE
    cAliasQry := "SCT"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros para ambiente CDX ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr("FTR050P9R1") 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Logica para ISAM                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SCT")
	dbSetOrder(2)
	cCondicao += "CT_FILIAL='"      +xFilial("SCT")+"'.AND."
	
    // Regiao
	cCondicao += "CT_REGIAO>='"     + MV_PAR03+"'.AND."
	cCondicao += "CT_REGIAO<='"     + MV_PAR04+"'.AND."	

    // Tipo de produto
	If !Empty(mv_par05)
		cCondicao += +MV_PAR05+" .AND."
	EndIf	           

	// Grupo de produto
	If !Empty(mv_par06)
		cCondicao += +MV_PAR06+" .AND."
	EndIf	          

	cCondicao += "DTOS(CT_DATA)>='" +DToS(MV_PAR08)+"'.AND."
	cCondicao += "DTOS(CT_DATA)<='" +DToS(MV_PAR09)+"'
		
	oReport:Section(1):SetFilter(cCondicao,SCT->(IndexKey()))
	
#ENDIF		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(SCT->(LastRec()))


dbSelectArea(cAliasQry)
dbGoTop()
oReport:Section(1):Init()
While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a funcao de calculo das vendas                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
	
		/*	
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ExpN1: Tipo de Meta :(1-Numerico-Valor liquido - desconto )  ³±±
		±±³          ³                     (2-Numerico-Quantidade )                ³±±
		±±³          ³                     (3-Numerico-Valor bruto + desconto )    ³±±
		±±³          ³                     (4-Array-contendo todos os valores acima³±±
		±±³          ³                     (5-Array-contendo todos os valores acima³±±
		±±³          ³                      por produto                            ³±±
		±±³          ³ExpC2: cCodigo                                               ³±±
		±±³          ³ExpD3: Data de Inicio                                        ³±±
		±±³          ³ExpD4: Data de Termino                                       ³±±
		±±³          ³ExpC5: Regiao de Vendas.                                     ³±±
		±±³          ³ExpC6: Tipo de Produto                                       ³±±
		±±³          ³ExpC7: Grupo de Produto                                      ³±±
		±±³          ³ExpC8: Codigo do Produto                                     ³±±
		±±³          ³ExpN9: Moeda para conversao                                  ³±±
		±±³          ³ExpCA: Cliente                                               ³±±
		±±³          ³ExpCB: Loja                                                  ³±±
		±±³          ³ExpCC: CATEGORIA DO PRODUTO								   ³±±
		±±³          ³       SGBD ISAM                                             ³±±
		±±³          ³ExpCD: Determina se devem ser consideradas Notas fiscais (1) ³±±
		±±³          ³       REMITOS (2) ou ambos tipos de documento (3)           ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Retorno   ³ExpX1: Valor / Array conforme tipo da Meta                   ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³Calcula o Valor das Vendas com base nas notas fiscais de     ³±±
		±±³          ³saida                                                        ³±±
		±±³          ³                                                             ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		*/

	aVendas := NfVendas(4,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_REGIAO,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,MV_PAR10,"","",(cAliasQry)->CT_CATEGO,,cDupli,cEstoq)
	
	aDevol := { 0,0,0 }
/*
	If MV_PAR07 == 1  	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chama a funcao de calculo das devolucoes de venda            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDevol := FtNfDevol(4,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_REGIAO,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,MV_PAR10,"","",,cDupli,cEstoq)
	EndIf 			
*/ 
 	nValReal := aVendas[ 1 ] - aDevol[ 1 ]
 	nQtdReal := aVendas[ 2 ] - aDevol[ 2 ]
	nValMeta := xMoeda( ( cAliasQry )->CT_VALOR, ( cAliasQry )->CT_MOEDA, MV_PAR10, ( cAliasQry )->CT_DATA ) 

	oReport:Section(1):PrintLine()
	
	
	dbSelectArea(cAliasQry)
	dbSkip()
	oReport:IncMeter()
EndDo
oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.) 


Return


Static Function NfVendas(nTpMeta,cCodigo,dDataIni,dDataFim,cRegiao,cTipo,cGrupo,cProduto,nMoeda,cCliente,cLoja,cCatego,cTipoDoc,cDupli,cEstoq)

Local aArea   := GetArea()
Local aAreaSA3:= SA3->(GetArea())
Local aAreaSF4:= SF4->(GetArea())
Local aAreaSD2:= SD2->(GetArea())
Local aAreaSF2:= SF2->(GetArea())
Local aGrupos := {} 
Local cQuery  := ""
Local cArqQry := "FtNfVendas"
Local cSeek   := ""
Local cComp   := ""
Local cVend   := ""
Local cIn     := ""
Local xRetorno := 0
Local nCntVend:= Fa440CntVen()
Local nCntFor := 0
Local nX      := 0
Local lVend   := .F.
Local nLoop
Local cRegiaoNF := ""
Local nVlrAux := 0

DEFAULT nTpMeta := 1
DEFAULT cCodigo := ""
DEFAULT dDataIni:= dDataBase
DEFAULT dDataFim:= dDataBase
DEFAULT cRegiao := ""
DEFAULT cTipo   := ""
DEFAULT cGrupo  := ""
DEFAULT cProduto:= ""
DEFAULT nMoeda  := 0 
DEFAULT cCliente:= ""
DEFAULT cLoja   := ""
DEFAULT cTipoDoc:= '3'
DEFAULT cDupli	 := "'S'"
DEFAULT cEstoq	 := "'S'"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acerta o Tamanho da Variaveis                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCodigo := PadR(cCodigo,Len(SA3->A3_COD))
cRegiao := PadR(cRegiao,Len(SF2->F2_REGIAO))
cTipo   := PadR(cTipo,Len(SD2->D2_TP))
cGrupo  := PadR(cGrupo,Len(SD2->D2_GRUPO))
cProduto:= PadR(cProduto,Len(SD2->D2_COD))
                    
If nTpMeta == 4
	xRetorno := { 0, 0, 0 } 
EndIf
If nTpMeta == 5
	xRetorno := {} 
EndIf 

If !Empty( cCodigo ) 
	
	#IFNDEF TOP
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona o proprio representante                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilGrupo := "{ || SA3->A3_COD=='" + cCodigo + "'"
	#ENDIF 	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona os grupos que estao abaixo deste representante                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( aGrupos := FtReprEst( cCodigo ) )
	
		#IFDEF TOP
			cIn := "( "	
		#ENDIF	
		
		For nLoop := 1 to Len( aGrupos ) 
			
		    #IFDEF TOP
				cIn       += "'" + aGrupos[ nLoop, 1 ] + "',"
			#ELSE
				cFilGrupo += ".Or.SA3->A3_GRPREP=='" + aGrupos[ nLoop, 1 ] + "'" 			
			#ENDIF	
				
		Next nLoop  
		
		#IFDEF TOP
			cIn := Left( cIn, Len( cIn ) - 1 ) + ") "	
		#ENDIF	
		
	EndIf	
		
EndIf 		


#IFDEF TOP
	If ( TcSrvType()!="AS/400" )
		Do Case
			Case ( nTpMeta == 1 )
				cQuery := "SELECT SUM(SD2.D2_TOTAL) D2_TOTAL "
			Case ( nTpMeta == 2 )
				cQuery := "SELECT SUM(SD2.D2_QUANT) D2_QUANT "
			Case ( nTpMeta == 3 )
				cQuery := "SELECT SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTAL "
			Case ( nTpMeta == 4 )
				cQuery := "SELECT SUM(SD2.D2_TOTAL) D2_TOTAL, SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTDESC,SUM(SD2.D2_QUANT) D2_QUANT "
			OtherWise
				cQuery := "SELECT D2_COD,SUM(SD2.D2_TOTAL) D2_TOTAL, SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTDESC,SUM(SD2.D2_QUANT) D2_QUANT "
		EndCase 
		
		If !Empty( nMoeda ) 	
			cQuery += ",F2_MOEDA,D2_EMISSAO "
		EndIf 
			
		cQuery += "FROM "
		
		cQuery += RetSqlName("SD2")+" SD2,"
		cQuery += RetSqlName("SF4")+" SF4,"
		cQuery += RetSqlName("SF2")+" SF2, "
		cQuery += RetSqlName("ACV")+" ACV "
		cQuery += "WHERE "
	    
    	cQuery += "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
    	cQuery += "SF2.F2_TIPO='N' AND "
				
		If ( !Empty(dDataIni) )
			cQuery += "SF2.F2_EMISSAO>='"+Dtos(dDataIni)+"' AND "
		EndIf
		If ( !Empty(dDataFim) )
			cQuery += "SF2.F2_EMISSAO<='"+Dtos(dDataFim)+"' AND "
		EndIf
		
		If ( !Empty(cRegiao) ) 
			If cPaisLoc == "BRA"
				cQuery += "SF2.F2_REGIAO='"+cRegiao+"' AND "                                    
			Else
				cQuery += "EXISTS ( SELECT A1_REGIAO FROM " + RetSqlName( "SA1" ) + " SA1 WHERE "
				cQuery += "SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND "
				cQuery += "SA1.A1_REGIAO='" + cRegiao + "' AND "
				cQuery += "SA1.D_E_L_E_T_<>'*') AND "
			Endif
		Endif
		
		If ( !Empty(cCliente) )
			cQuery += "SF2.F2_CLIENTE='"+cCliente+"' AND "
		EndIf
		If ( !Empty(cLoja) )
			cQuery += "SF2.F2_LOJA='"+cLoja+"' AND "
		EndIf           
		If cTipoDoc == '1' .Or. cTipoDoc == '3'
			cQuery += " NOT ("+IsRemito(3,'SF2.F2_TIPODOC')+") AND "			
		ElseIf cTipoDoc == '2'	
			cQuery += IsRemito(3,'SF2.F2_TIPODOC')+" AND "			
		Endif
		cQuery += "SF2.D_E_L_E_T_<>'*' AND "
		cQuery += "SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
		cQuery += "SD2.D2_SERIE=SF2.F2_SERIE AND "
		cQuery += "SD2.D2_DOC=SF2.F2_DOC AND "
		cQuery += "SD2.D2_CLIENTE=SF2.F2_CLIENTE AND "
		cQuery += "SD2.D2_LOJA=SF2.F2_LOJA AND "
		If ( !Empty(cTipo) )
			cQuery += "SD2.D2_TP='"+cTipo+"' AND "
		EndIf
		If ( !Empty(cGrupo) )
			cQuery += "SD2.D2_GRUPO='"+cGrupo+"' AND "
		EndIf
		If ( !Empty(cProduto) )
			cQuery += "SD2.D2_COD='"+cProduto+"' AND "
		EndIf
		cQuery += "SD2.D_E_L_E_T_<>'*' AND "            

	  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a amaração com a categoria de produtos.                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	                                 
	    If ( !Empty (cCatego) )
			cQuery += "ACV.ACV_FILIAL='"+xFilial("ACV")+"' AND "
			cQuery += "ACV.ACV_CATEGO='"+cCatego+"' AND "
			cQuery += "(ACV.ACV_CODPRO=SD2.D2_COD OR ACV.ACV_GRUPO=SD2.D2_GRUPO) AND "
			cQuery += "ACV.D_E_L_E_T_<>'*' AND "            
		Endif
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica os Vendedores.                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If !Empty( cCodigo ) 
		
			cQuery += "EXISTS ( SELECT A3_FILIAL FROM " + RetSqlName( "SA3" ) + " SA3 WHERE "
			
			If ( !Empty(cCodigo) )
		    	cVend := "1"
		    	cQuery += "("
		    	For nCntFor := 1 To nCntVend
					cQuery += "SF2.F2_VEND"+cVend+"=SA3.A3_COD OR "
					cVend := Soma1(cVend,Len(SF2->F2_VEND1))
				Next nCntFor
				cQuery := SubStr(cQuery,1,Len(cQuery)-3)+") AND "
			EndIf
			                                                                                 
			cQuery += "SA3.A3_FILIAL='"+xFilial("SA3")+"' AND "
			
	    	If Empty( cIn ) 
		    	cQuery  += "SA3.A3_COD='"+cCodigo+"' AND "
	    	Else
		    	cQuery  += "(SA3.A3_COD='"+cCodigo+"' OR SA3.A3_GRPREP IN " + cIn + " ) AND "
			EndIf	    	
			
			cQuery += "	SA3.D_E_L_E_T_<>'*' ) AND " 
			
		EndIf		
		
		cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
		cQuery += "SF4.F4_CODIGO=SD2.D2_TES AND "
		cQuery += "SF4.F4_DUPLIC IN (" + cDupli + ") AND "
		cQuery += "SF4.F4_ESTOQUE IN (" + cEstoq + ") AND "
		cQuery += "SF4.D_E_L_E_T_<>'*' "
		If nTpMeta <> 5
			If !Empty( nMoeda )
				cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO" 
			EndIf 
		Else
			If !Empty( nMoeda )
				cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO,D2_COD"
			Else
				cQuery += "GROUP BY D2_COD "
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Seleciona as remisiones nao faturadas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If cPaisLoc <> "BRA" .And. cTipoDoc == "3"
			cQuery += " UNION ALL "
			Do Case
				Case ( nTpMeta == 1 )
					cQuery += "SELECT SUM(SD2.D2_PRCVEN * SD2.D2_QTDAFAT) D2_TOTAL "
				Case ( nTpMeta == 2 )
					cQuery += "SELECT SUM(SD2.D2_QTDAFAT) D2_QUANT "
				Case ( nTpMeta == 3 )
					cQuery += "SELECT SUM((SD2.D2_TOTAL+SD2.D2_DESCON) * (SD2.D2_QTDAFAT / SD2.D2_QUANT)) D2_TOTAL "
				Case ( nTpMeta == 4 )
					cQuery += "SELECT SUM(SD2.D2_PRCVEN * SD2.D2_QTDAFAT) D2_TOTAL, SUM((SD2.D2_TOTAL+SD2.D2_DESCON) * (SD2.D2_QTDAFAT / SD2.D2_QUANT)) D2_TOTDESC,SUM(SD2.D2_QTDAFAT) D2_QUANT "
				OtherWise
					cQuery += "SELECT D2_COD,SUM(SD2.D2_PRCVEN * SD2.D2_QTDAFAT) D2_TOTAL, SUM((SD2.D2_TOTAL+SD2.D2_DESCON) * (SD2.D2_QTDAFAT / SD2.D2_QUANT)) D2_TOTDESC,SUM(SD2.D2_QTDAFAT) D2_QUANT "
			EndCase 
			If !Empty( nMoeda ) 	
				cQuery += ",F2_MOEDA,D2_EMISSAO "
			EndIf 
			cQuery += "FROM "
			cQuery += RetSqlName("SD2")+" SD2,"
			cQuery += RetSqlName("SF4")+" SF4,"
			cQuery += RetSqlName("SF2")+" SF2 "
			cQuery += "WHERE "
	    	cQuery += "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
	    	cQuery += "SF2.F2_TIPO='N' AND "
			If ( !Empty(dDataIni) )
				cQuery += "SF2.F2_EMISSAO>='"+Dtos(dDataIni)+"' AND "
			EndIf
			If ( !Empty(dDataFim) )
				cQuery += "SF2.F2_EMISSAO<='"+Dtos(dDataFim)+"' AND "
			EndIf
			If ( !Empty(cRegiao) ) 
				If cPaisLoc == "BRA"
					cQuery += "SF2.F2_REGIAO='"+cRegiao+"' AND "                                    
				Else
					cQuery += "EXISTS ( SELECT A1_REGIAO FROM " + RetSqlName( "SA1" ) + " SA1 WHERE "
					cQuery += "SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND "
					cQuery += "SA1.A1_REGIAO='" + cRegiao + "' AND "
					cQuery += "SA1.D_E_L_E_T_<>'*') AND "
				Endif
			Endif
			If ( !Empty(cCliente) )
				cQuery += "SF2.F2_CLIENTE='"+cCliente+"' AND "
			EndIf
			If ( !Empty(cLoja) )
				cQuery += "SF2.F2_LOJA='"+cLoja+"' AND "
			EndIf
			cQuery += IsRemito(3,'SF2.F2_TIPODOC')+" AND "
			cQuery += "SF2.D_E_L_E_T_<>'*' AND "
			cQuery += "SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
			cQuery += "SD2.D2_SERIE=SF2.F2_SERIE AND "
			cQuery += "SD2.D2_DOC=SF2.F2_DOC AND "
			cQuery += "SD2.D2_CLIENTE=SF2.F2_CLIENTE AND "
			cQuery += "SD2.D2_LOJA=SF2.F2_LOJA AND "
			If ( !Empty(cTipo) )
				cQuery += "SD2.D2_TP='"+cTipo+"' AND "
			EndIf
			If ( !Empty(cGrupo) )
				cQuery += "SD2.D2_GRUPO='"+cGrupo+"' AND "
			EndIf
			If ( !Empty(cProduto) )
				cQuery += "SD2.D2_COD='"+cProduto+"' AND "
			EndIf
			cQuery += "SD2.D2_QTDAFAT > 0 AND "
			cQuery += "SD2.D_E_L_E_T_<>'*' AND "            
	    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica os Vendedores.                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If !Empty( cCodigo ) 
				cQuery += "EXISTS ( SELECT A3_FILIAL FROM " + RetSqlName( "SA3" ) + " SA3 WHERE "
				If ( !Empty(cCodigo) )
			    	cVend := "1"
			    	cQuery += "("
			    	For nCntFor := 1 To nCntVend
						cQuery += "SF2.F2_VEND"+cVend+"=SA3.A3_COD OR "
						cVend := Soma1(cVend,Len(SF2->F2_VEND1))
					Next nCntFor
					cQuery := SubStr(cQuery,1,Len(cQuery)-3)+") AND "
				EndIf                                                                        
				cQuery += "SA3.A3_FILIAL='"+xFilial("SA3")+"' AND "
		    	If Empty( cIn ) 
			    	cQuery  += "SA3.A3_COD='"+cCodigo+"' AND "
		    	Else
			    	cQuery  += "(SA3.A3_COD='"+cCodigo+"' OR SA3.A3_GRPREP IN " + cIn + " ) AND "
				EndIf	    	
				cQuery += "	SA3.D_E_L_E_T_<>'*' ) AND " 
			EndIf
			cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
			cQuery += "SF4.F4_CODIGO=SD2.D2_TES AND "
			cQuery += "SF4.F4_DUPLIC IN (" + cDupli + ") AND "
			cQuery += "SF4.F4_ESTOQUE IN (" + cEstoq + ") AND "
			cQuery += "SF4.D_E_L_E_T_<>'*' "

			If nTpMeta <> 5
				If !Empty( nMoeda )
					cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO" 
				EndIf 
			Else
				If !Empty( nMoeda )
					cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO,D2_COD"
				Else
					cQuery += "GROUP BY D2_COD "
				EndIf
			EndIf
		Endif
					
		cQuery := ChangeQuery(cQuery)      
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		If ( nTpMeta == 1 .Or. nTpMeta == 3 )
			TcSetField(cArqQry,"D2_TOTAL","N",18,2)
		ElseIf nTpMeta == 2
			TcSetField(cArqQry,"D2_QUANT","N",18,2)
		Else
			TcSetField(cArqQry,"D2_QUANT"  ,"N",18,2)
			TcSetField(cArqQry,"D2_TOTAL"  ,"N",18,2)
			TcSetField(cArqQry,"D2_TOTDESC","N",18,2)
		EndIf
		
		If !Empty( nMoeda ) 
			TcSetField(cArqQry,"F2_MOEDA"  ,"N",2,0)
			TcSetField(cArqQry,"D2_EMISSAO","D",8,0)
		EndIf 						
		
		While ( !Eof() )
			Do Case
				Case ( nTpMeta == 1 .Or. nTpMeta == 3 )
					xRetorno += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
				Case nTpMeta == 2
					xRetorno += D2_QUANT
				Case nTpMeta == 4
					xRetorno[ 1 ] += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
					xRetorno[ 2 ] += D2_QUANT
					xRetorno[ 3 ] += If( Empty( nMoeda ), D2_TOTDESC, xMoeda( D2_TOTDESC, F2_MOEDA, nMoeda, D2_EMISSAO ) )
				OtherWise
					nX := aScan(xRetorno,{|x| x[1] == D2_COD})
					If nX == 0
						aadd(xRetorno,{D2_COD,0,0,0})
						nX := Len(xRetorno)
					EndIf
					xRetorno[nX][2] += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
					xRetorno[nX][3] += D2_QUANT
					xRetorno[nX][4] += If( Empty( nMoeda ), D2_TOTDESC, xMoeda( D2_TOTDESC, F2_MOEDA, nMoeda, D2_EMISSAO ) )
			EndCase
			dbSelectArea(cArqQry)
			dbSkip()		
		EndDo
		dbSelectArea(cArqQry)
		dbCloseArea()
		dbSelectArea("SD2")
	Else
#ENDIF         
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua a selecao dos registros                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD2")
		dbSetOrder(5)
		cSeek  := xFilial("SD2")+AllTrim(Dtos(dDataIni))
		cComp  := "SD2->D2_FILIAL=='"+xFilial("SD2")+"'"
		If ( !Empty(dDataIni) )
			cComp += ".And. Dtos(SD2->D2_EMISSAO)>='"+Dtos(dDataIni)+"'"
		EndIf
		If ( !Empty(dDataFim) )
			cComp += ".And. Dtos(SD2->D2_EMISSAO)<='"+Dtos(dDataFim)+"'"
		EndIf
		MsSeek(cSeek,.T.)
		While ( !Eof() .And. &cComp )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Registros.                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SF2")
			dbSetOrder(1)
			MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)

			If cTipoDoc == '3' .Or. (cTipoDoc == '1' .And. !IsRemito(1,'SF2->F2_TIPODOC')).Or.;
					(cTipoDoc == '2' .And. IsRemito(1,'SF2->F2_TIPODOC'))
				If !IsRemito(1,"SD2->D2_TIPODOC") .Or. SD2->D2_QTDAFAT > 0
					dbSelectArea("SF4")
					dbSetOrder(1)
					MsSeek(xFilial("SF4")+SD2->D2_TES)
					cVend := "1"
					lVend := .F.
					If ( !Empty(cCodigo) )
				    	For nCntFor := 1 To nCntVend
						
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Pesquisa por todos os vendedores do SF2 no SA3                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
							cCodVend := SF2->(FieldGet(FieldPos("F2_VEND"+cVend))) 
						
							SA3->( dbSetOrder( 1 ) ) 
							If SA3->( MsSeek( xFilial( "SA3" ) + cCodVend ) )  
						
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se eh o proprio vendedor ou se o vendedor esta                ³
								//³ no grupo de vendedores validos                                         ³								
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							    If SA3->A3_COD == cCodigo .Or. !Empty( AScan( aGrupos, { |x| x[1]==SA3->A3_GRPREP } ) )
									lVend := .T. 
								EndIf
							EndIf 					
	
							cVend := Soma1(cVend,Len(SF2->F2_VEND1))
							If ( lVend )
								Exit 
							EndIf
						
						Next nCntFor
					Else
						lVend := .T.					
					EndIf
					cRegiaoNF := SF2->F2_REGIAO
					If cPaisLoc <> "BRA" .And. !Empty(cRegiao)
						If Empty(cRegiaoNF)
							cRegiaoNF := Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"A1_REGIAO")
						Endif
					Endif
					If ((Empty(cRegiao).Or.cRegiao==cRegiaoNF).And.;
						( lVend .And. SF2->F2_TIPO=='N') .And.;
						(Empty(cTipo).Or.cTipo==SD2->D2_TP).And.;
						(Empty(cGrupo).Or.cGrupo==SD2->D2_GRUPO).And.;
						(Empty(cProduto).Or.cProduto==SD2->D2_COD).And.;
						(Empty(cCliente).Or.cCliente==SD2->D2_CLIENTE).And.;
						(Empty(cLoja).Or.cLoja==SD2->D2_LOJA).And.;
						(SF4->F4_DUPLIC $ cDupli .And. SF4->F4_ESTOQUE $ cEstoq)) 
		
						If IsRemito(1,"SD2->D2_TIPODOC")
							Do Case
								Case ( nTpMeta == 1 )
									nVlrAux := SD2->D2_PRCVEN * SD2->D2_QTDAFAT
									xRetorno += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								Case ( nTpMeta == 2 )
									xRetorno += SD2->D2_QTDAFAT
								Case ( nTpMeta == 3 )
									nVlrAux := (SD2->D2_TOTAL+SD2->D2_DESCON) * (SD2->D2_QTDAFAT / SD2->D2_QUANT)
									xRetorno += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								Case ( nTpMeta == 4 )
									nVlrAux := SD2->D2_PRCVEN * SD2->D2_QTDAFAT
									xRetorno[ 1 ] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
									xRetorno[ 2 ] += SD2->D2_QTDAFAT
									nVlrAux := (SD2->D2_TOTAL+SD2->D2_DESCON) * (SD2->D2_QTDAFAT / SD2->D2_QUANT)
									xRetorno[ 3 ] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								OtherWise
									nX := aScan(xRetorno,{|x| X[1] == SD2->D2_COD})
									If nX == 0
										aadd(xRetorno,{SD2->D2_COD,0,0,0})
										nX := Len(xRetorno)
									EndIf
									nVlrAux := SD2->D2_PRCVEN * SD2->D2_QTDAFAT
									xRetorno[nX][2] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
									xRetorno[nX][3] += SD2->D2_QTDAFAT
									nVlrAux := (SD2->D2_TOTAL+SD2->D2_DESCON) * (SD2->D2_QTDAFAT / SD2->D2_QUANT)
									xRetorno[nX][4] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
							EndCase
						Else
							Do Case
								Case ( nTpMeta == 1 )
									xRetorno += If( Empty( nMoeda ), SD2->D2_TOTAL, xMoeda( SD2->D2_TOTAL, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								Case ( nTpMeta == 2 )
									xRetorno += SD2->D2_QUANT
								Case ( nTpMeta == 3 )
									xRetorno += If( Empty( nMoeda ), SD2->D2_TOTAL+SD2->D2_DESCON, xMoeda( SD2->D2_TOTAL+SD2->D2_DESCON, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								Case ( nTpMeta == 4 )
									xRetorno[ 1 ] += If( Empty( nMoeda ), SD2->D2_TOTAL, xMoeda( SD2->D2_TOTAL, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
									xRetorno[ 2 ] += SD2->D2_QUANT
									xRetorno[ 3 ] += If( Empty( nMoeda ), SD2->D2_TOTAL+SD2->D2_DESCON, xMoeda( SD2->D2_TOTAL+SD2->D2_DESCON, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								OtherWise
									nX := aScan(xRetorno,{|x| X[1] == SD2->D2_COD})
									If nX == 0
										aadd(xRetorno,{SD2->D2_COD,0,0,0})
										nX := Len(xRetorno)
									EndIf
									xRetorno[nX][2] += If( Empty( nMoeda ), SD2->D2_TOTAL, xMoeda( SD2->D2_TOTAL, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
									xRetorno[nX][3] += SD2->D2_QUANT
									xRetorno[nX][4] += If( Empty( nMoeda ), SD2->D2_TOTAL+SD2->D2_DESCON, xMoeda( SD2->D2_TOTAL+SD2->D2_DESCON, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
							EndCase
						Endif
					EndIf
				Endif
			Endif
			dbSelectArea("SD2")
			dbSkip()
		EndDo
		
#IFDEF TOP
	EndIf
#ENDIF
RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aAreaSF4)
RestArea(aAreaSA3)
RestArea(aArea)
Return(xRetorno)

