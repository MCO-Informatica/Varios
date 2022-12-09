//#INCLUDE "FATR050.ch"
#include "Protheus.ch"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ FATR050  ≥ Autor ≥ Marco Bianchi         ≥ Data ≥25/05/2006≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriá∆o ≥ Relatorio de metas de vendas x realizado                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥ Nenhum                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥ Programador   ≥Manutencao efetuada                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥               ≥                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function FATR050x()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	FATR050R3X()
EndIf

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ReportDef ≥ Autor ≥ Marco Bianchi         ≥ Data ≥25/05/2006≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥A funcao estatica ReportDef devera ser criada para todos os ≥±±
±±≥          ≥relatorios que poderao ser agendados pelo usuario.          ≥±±
±±≥          ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥ExpO1: Objeto do relatÛrio                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥Nenhum                                                      ≥±±
±±≥          ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥ Programador   ≥Manutencao efetuada                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥               ≥                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ReportDef()

Local oReport
Local cAliasQry := GetNextAlias() 
Local nTamProd  := TamSX3("CT_PRODUTO")[1] 

Private nValReal := 0					// Valor Real
Private nQtdReal := 0					// Quantidade Real
Private nValMeta := 0					// Valor da Meta
Private aVendas  := { 0, 0, 0 } 		
Private aDevol   := { 0, 0, 0 }   
Private cPerg    := "FTR050C"  // Pergunta do Relatorio

AjustaSX1(cPerg)    
Pergunte(cPerg,.F.)
	
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Criacao do componente de impressao                                      ≥
//≥                                                                        ≥
//≥TReport():New                                                           ≥
//≥ExpC1 : Nome do relatorio                                               ≥
//≥ExpC2 : Titulo                                                          ≥
//≥ExpC3 : Pergunte                                                        ≥
//≥ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ≥
//≥ExpC5 : Descricao                                                       ≥
//≥                                                                        ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oReport := TReport():New("FATR050",If( MV_PAR15==1, "RelaÁ„o de metas de vendas x Realizado", "Relacao de metas de vendas x pedidos vendas" ),cPerg, {|oReport| ReportPrint(oReport,cAliasQry)},If( MV_PAR15==1, "Este relatÛrio vai imprimir a relaÁ„o das metas de vendas", "Este relatorio ira imprimir a relacao das metas de vendas" )+ " " + If( MV_PAR15==1, "Em relaÁ„o as Realizadas de acordo com os par‚metros", "em relacao aos pedidos vendas conforme parametros" ))
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Criacao da secao utilizada pelo relatorio                               ≥
//≥                                                                        ≥
//≥TRSection():New                                                         ≥
//≥ExpO1 : Objeto TReport que a secao pertence                             ≥
//≥ExpC2 : Descricao da seÁao                                              ≥
//≥ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ≥
//≥        sera considerada como principal para a seÁ„o.                   ≥
//≥ExpA4 : Array com as Ordens do relatÛrio                                ≥
//≥ExpL5 : Carrega campos do SX3 como celulas                              ≥
//≥        Default : False                                                 ≥
//≥ExpL6 : Carrega ordens do Sindex                                        ≥
//≥        Default : False                                                 ≥
//≥                                                                        ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Criacao da celulas da secao do relatorio                                ≥
//≥                                                                        ≥
//≥TRCell():New                                                            ≥
//≥ExpO1 : Objeto TSection que a secao pertence                            ≥
//≥ExpC2 : Nome da celula do relatÛrio. O SX3 ser· consultado              ≥
//≥ExpC3 : Nome da tabela de referencia da celula                          ≥
//≥ExpC4 : Titulo da celula                                                ≥
//≥        Default : X3Titulo()                                            ≥
//≥ExpC5 : Picture                                                         ≥
//≥        Default : X3_PICTURE                                            ≥
//≥ExpC6 : Tamanho                                                         ≥
//≥        Default : X3_TAMANHO                                            ≥
//≥ExpL7 : Informe se o tamanho esta em pixel                              ≥
//≥        Default : False                                                 ≥
//≥ExpB8 : Bloco de cÛdigo para impressao.                                 ≥
//≥        Default : ExpC2                                                 ≥
//≥                                                                        ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oMetas := TRSection():New(oReport,If( MV_PAR15==1, "Meta De Vendas", "Meta de Vendas" ),{"SCT"},/*{Array com as ordens do relatÛrio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oMetas:SetTotalInLine(.F.)

TRCell():New(oMetas,"CT_DOC"    ,"SCT","Numero"   ,/*Picture*/			  			,TamSX3("CT_DOC")        [1],/*lPixel*/,/*{|| code-block de impressao }*/)				 			// Codigo da Meta
TRCell():New(oMetas,"CT_SEQUEN" ,"SCT","Seq"   ,/*Picture*/			  			,TamSX3("CT_SEQUEN")     [1],/*lPixel*/,/*{|| code-block de impressao }*/)							// Sequencia da Meta
TRCell():New(oMetas,"CT_DESCRI" ,"SCT","DescriÁ„o"   ,/*Picture*/			  			,IIf(nTamProd==30,21, TamSX3("CT_DESCRI")[1]),/*lPixel*/,/*{|| code-block de impressao }*/)	 			// Descricao da Meta
TRCell():New(oMetas,"CT_DATA"   ,"SCT",/*Titulo*/,/*Picture*/			  			,10					 ,/*lPixel*/,/*{|| code-block de impressao }*/)			  				// Data da Meta
TRCell():New(oMetas,"CT_VEND"   ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_VEND")    	    [1],/*lPixel*/,/*{|| code-block de impressao }*/)			  				// Codigo do Vendedor
TRCell():New(oMetas,"CT_REGIAO" ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_REGIAO")	    [1],/*lPixel*/,/*{|| code-block de impressao }*/)			  				// Regiao
TRCell():New(oMetas,"CT_PRODUTO","SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_PRODUTO") 	    [1],/*lPixel*/,/*{|| code-block de impressao }*/)			  				// Codigo do Produto
TRCell():New(oMetas,"CT_GRUPO"  ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_GRUPO")	    [1],/*lPixel*/,/*{|| code-block de impressao }*/)							// Grupo do Produto
TRCell():New(oMetas,"CT_TIPO"   ,"SCT","Tipo"   ,/*Picture*/			  			,TamSX3("CT_TIPO")	    [1],/*lPixel*/,/*{|| code-block de impressao }*/)							// Tipo do Produto
TRCell():New(oMetas,"NVALMETA"  ,"   ",If( MV_PAR15==1, "Valor/objectivo", "Valor/Meta" )   ,PesqPict("SCT","CT_VALOR")				,TamSX3("CT_VALOR")	    [1],/*lPixel*/,{|| xMoeda( CT_VALOR, CT_MOEDA, MV_PAR12, CT_DATA ) },,,"RIGHT")	// Valor da Meta
TRCell():New(oMetas,"CT_QUANT"  ,"SCT",If( MV_PAR15==1, "Quant/objectivo", "Quant/Meta" )   ,PesqPict("SCT","CT_QUANT")	 			,TamSX3("CT_QUANT")	    [1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")					// Quantidade da Meta
TRCell():New(oMetas,"NVALREAL"  ,"   ",If( MV_PAR15==1, 'Vlr Realiz', 'Vlr Orcado' )   ,PesqPict("SCT","CT_VALOR")				,TamSX3("CT_VALOR")	    [1],/*lPixel*/,{|| nValReal },,,"RIGHT")			        				// Valor Real
TRCell():New(oMetas,"NQTDREAL"  ,"   ",If( MV_PAR15==1, 'Qtd Realiz', 'Qtd Orcada' )   ,PesqPict("SCT","CT_QUANT")				,TamSX3("CT_QUANT")	    [1],/*lPixel*/,{|| nQtdReal },,,"RIGHT")								// Quantidade Real
TRCell():New(oMetas,"nVRMM"     ,"   ",If( MV_PAR15==1, 'Vlr Real - Meta', 'Vlr Orc - Meta' )   ,PesqPict("SCT","CT_VALOR")				,TamSX3("CT_VALOR")	    [1],/*lPixel*/,{|| nValReal - nValMeta },,,"RIGHT")						// Valor Real - Meta
TRCell():New(oMetas,"nQRMM"     ,"   ",If( MV_PAR15==1, 'Qtd Real - Meta', 'Qtd Orc - Meta' )  ,PesqPict("SCT","CT_QUANT")				,TamSX3("CT_QUANT")	    [1],/*lPixel*/,{|| nQtdReal - CT_QUANT },,,"RIGHT")			 			// Quantidade Real - Meta

Return(oReport)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ReportPrin≥ Autor ≥Eduardo Riera          ≥ Data ≥04.05.2006≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥A funcao estatica ReportDef devera ser criada para todos os ≥±±
±±≥          ≥relatorios que poderao ser agendados pelo usuario.          ≥±±
±±≥          ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥Nenhum                                                      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ExpO1: Objeto Report do RelatÛrio                           ≥±±
±±≥          ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥ Programador   ≥Manutencao efetuada                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥               ≥                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ReportPrint(oReport,cAliasQry)

Local cEstoq 	:= If( (mv_par13 == 1),"'S'",If( (mv_par13 == 2),"'N'","'S','N'" ) )
Local cDupli 	:= If( (mv_par14 == 1),"'S'",If( (mv_par14 == 2),"'N'","'S','N'" ) )

oReport:SetTitle(If( MV_PAR15==1, "RelaÁ„o de metas de vendas x Realizado", "Relacao de metas de vendas x pedidos vendas" ))
oReport:ASECTION[1]:ACELL[10]:CTITLE := If( MV_PAR15==1, "Valor/objectivo", "Valor/Meta" )
oReport:ASECTION[1]:ACELL[11]:CTITLE := If( MV_PAR15==1, "Quant/objectivo", "Quant/Meta" )
oReport:ASECTION[1]:ACELL[12]:CTITLE := If( MV_PAR15==1, 'Vlr Realiz', 'Vlr Orcado' )
oReport:ASECTION[1]:ACELL[13]:CTITLE := If( MV_PAR15==1, 'Qtd Realiz', 'Qtd Orcada' )
oReport:ASECTION[1]:ACELL[14]:CTITLE := If( MV_PAR15==1, 'Vlr Real - Meta', 'Vlr Orc - Meta' )
oReport:ASECTION[1]:ACELL[15]:CTITLE := If( MV_PAR15==1, 'Qtd Real - Meta', 'Qtd Orc - Meta' )


#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Filtragem do relatÛrio                                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
#IFDEF TOP
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Transforma parametros Range em expressao SQL                            ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	MakeSqlExpr(oReport:uParam)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Query do relatÛrio da secao 1                                           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	oReport:Section(1):BeginQuery()	
		
	BeginSql Alias cAliasQry
    SELECT SCT.* 
		FROM %table:SCT% SCT
		WHERE CT_FILIAL = %xFilial:SCT% AND  
		CT_REGIAO >= %Exp:MV_PAR03% AND 
		CT_REGIAO <= %Exp:MV_PAR04% AND 		
		CT_TIPO   >= %Exp:MV_PAR05% AND 
		CT_TIPO   <= %Exp:MV_PAR06% AND 
		CT_GRUPO  >= %Exp:MV_PAR07% AND 
		CT_GRUPO  <= %Exp:MV_PAR08% AND 
		CT_DATA   >= %Exp:DToS(MV_PAR10)% AND 
		CT_DATA   <= %Exp:DToS(MV_PAR11)% AND 	
		SCT.%notdel% 
	EndSql 
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Metodo EndQuery ( Classe TRSection )                                    ≥
	//≥                                                                        ≥
	//≥Prepara o relatÛrio para executar o Embedded SQL.                       ≥
	//≥                                                                        ≥
	//≥ExpA1 : Array com os parametros do tipo Range                           ≥
	//≥                                                                        ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	oReport:Section(1):EndQuery()//{MV_PAR05,MV_PAR06}
		
#ELSE
    cAliasQry := "SCT"

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros para ambiente CDX ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	MakeAdvplExpr(cPerg) 

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Logica para ISAM                                                    ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	dbSelectArea("SCT")
	dbSetOrder(2)
	cCondicao += "CT_FILIAL='"      +xFilial("SCT")+"'.AND."
	
    // Regiao
	cCondicao += "CT_REGIAO>='"     + MV_PAR03+"'.AND."
	cCondicao += "CT_REGIAO<='"     + MV_PAR04+"'.AND."	

	cCondicao += "CT_TIPO>='"  +MV_PAR05+"' .AND. "
	cCondicao += "CT_TIPO<='"  +MV_PAR06+"' .AND. "	
	cCondicao += "CT_GRUPO>='" +MV_PAR07+"' .AND. "
	cCondicao += "CT_GRUPO<='" +MV_PAR08+"' .AND. "	

	cCondicao += "DTOS(CT_DATA)>='" +DToS(MV_PAR10)+"'.AND."
	cCondicao += "DTOS(CT_DATA)<='" +DToS(MV_PAR11)+"'
		
	oReport:Section(1):SetFilter(cCondicao,SCT->(IndexKey()))
	
#ENDIF		
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Metodo TrPosition()                                                     ≥
//≥                                                                        ≥
//≥Posiciona em um registro de uma outra tabela. O posicionamento ser·     ≥
//≥realizado antes da impressao de cada linha do relatÛrio.                ≥
//≥                                                                        ≥
//≥                                                                        ≥
//≥ExpO1 : Objeto Report da Secao                                          ≥
//≥ExpC2 : Alias da Tabela                                                 ≥
//≥ExpX3 : Ordem ou NickName de pesquisa                                   ≥
//≥ExpX4 : String ou Bloco de cÛdigo para pesquisa. A string ser· macroexe-≥
//≥        cutada.                                                         ≥
//≥                                                                        ≥				
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Inicio da impressao do fluxo do relatÛrio                               ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oReport:SetMeter(SCT->(LastRec()))


dbSelectArea(cAliasQry)
dbGoTop()
oReport:Section(1):Init()
While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Chama a funcao de calculo das vendas                         ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If MV_PAR15 == 1 // Comparativo com Notas Fiscais
		aVendas := FtNfVendas(4,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_REGIAO,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,mv_par12,"","","",,cDupli,cEstoq)
	ElseIf MV_PAR15 == 2 // Comparativo com Pedidos de Vendas
		aVendas := FtPdVendas(7,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,MV_PAR12,"","","")
	Endif

	aDevol := { 0,0,0 }
	If MV_PAR09 == 1 .And. MV_PAR15 == 1
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Chama a funcao de calculo das devolucoes de venda            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		aDevol := FtNfDevol(4,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_REGIAO,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,mv_par12,"","",,cDupli,cEstoq)
	EndIf 			
 	nValReal := aVendas[ 1 ] - aDevol[ 1 ]
 	nQtdReal := aVendas[ 2 ] - aDevol[ 2 ]
	nValMeta := xMoeda( ( cAliasQry )->CT_VALOR, ( cAliasQry )->CT_MOEDA, MV_PAR12, ( cAliasQry )->CT_DATA ) 

	oReport:Section(1):PrintLine()
	
	
	dbSelectArea(cAliasQry)
	dbSkip()
	oReport:IncMeter()
EndDo
oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.) 


Return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ FATR050R3≥ Autor ≥ Sergio Silveira       ≥ Data ≥09/09/2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriá∆o ≥ Relatorio de metas de vendas x realizado                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥ Nenhum                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥ Programador   ≥Manutencao efetuada                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥               ≥                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function FATR050R3X()
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Define Vari†veis                                                        ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

Local cString    := "SCT"  // Alias utilizado na Filtragem
Local lDic       := .F.    // Habilita/Desabilita Dicionario
Local lComp      := .T.    // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro    := .T.    // Habilita/Desabilita o Filtro
Local wnrel      := "FATR050"  // Nome do Arquivo utilizado no Spool
Local nomeprog   := "FATR050"  // nome do programa
Local aOrderKey  := {} 

Private Tamanho  := "G"  // P/M/G
Private Limite   := 220  // 80/132/220
Private cPerg    := "FTR050C"  // Pergunta do Relatorio
Private aReturn  := { If( MV_PAR15==1, "CÛdigo de barras", "Zebrado" ), 1, If( MV_PAR15==1, "AdministraÁ„o", "Administracao" ), 1, 2, 1, "",1 }   //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para Nß de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd     := .F.// Controle de cancelamento do relatorio
Private m_pag    := 1  // Contador de Paginas
Private nLastKey := 0  // Controla o cancelamento da SetPrint e SetDefault

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifica as Perguntas Seleciondas                                       ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

AjustaSX1(cPerg)    
Pergunte(cPerg,.F.)

Titulo  := OemToAnsi(If( MV_PAR15==1, "RelaÁ„o de metas de vendas x Realizado", "Relacao de metas de vendas x pedidos vendas" ))  //"Relacao de metas de vendas x vendas realizadas"
cDesc1  := OemToAnsi(If( MV_PAR15==1, "Este relatÛrio vai imprimir a relaÁ„o das metas de vendas", "Este relatorio ira imprimir a relacao das metas de vendas" )) //"Este relatorio ira imprimir a relacao das metas de vendas"
cDesc2  := OemToAnsi(If( MV_PAR15==1, "Em relaÁ„o as Realizadas de acordo com os par‚metros", "em relacao aos pedidos vendas conforme parametros" )) //"em relacao as vendas realizadas conforme parametros"
cDesc3  := OemToAnsi("") 

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Envia para a SetPrinter                                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

RptStatus({|lEnd| ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Program   ≥ ImpDet   ≥ Autor ≥ Sergio Silveira       ≥ Data ≥09/09/2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriá∆o ≥ Controle de Fluxo do Relatorio.                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥Nenhum                                                      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥Nenhum                                                      ≥±±
±±≥          ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥ Programador   ≥Manutencao efetuada                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥               ≥                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function ImpDet(lEnd,wnrel,cString,nomeprog,Titulo)

Local aRegAD6     := {} 
Local aVendas     := { 0, 0, 0 } 
Local aDevol      := { 0, 0, 0 } 

Local bCondFil    := { || .T. }    
Local bWhile      := { || .T. } 
Local bBlock      := { || .T. } 

Local cCabec1     := "NUMERO  SEQ  DESCRICAO                       DATA        VENDEDOR  REGIAO  PRODUTO          GRUPO  TIPO          VALOR/META      QUANT/META          VALOR/ORC      QUANT/ORC     DIFERENCA VALOR   DIFERENCA QTD"
Local cCabec2     := ""

Local cTit1       := ""        // Titulo da 1.o Quebra recebe o valor de um campo
Local cTit2       := ""        // Titulo da 2.o Quebra recebe o valor de um campo
Local cTitulo1    := ""        // Titulo descritivo em formato texto
Local cTitulo2    := ""        // Titulo descritivo em formato texto
Local cbCont      := 0         // Numero de Registros Processados
Local cbText      := ""        // Mensagem do Rodape
Local cAliasSCT   := ""
Local cIndSCT     := ""
Local cQuery      := ""
Local cCond       := ""
Local cKey        := ""
Local cBlockFil   := "" 
Local cArqInd     := "" 

Local lImp        := .F.       // Indica se algo foi impresso
Local lQuery      := .F.
Local cEstoq 		:= If( (mv_par14 == 1),"'S'",If( (mv_par14 == 2),"'N'","'S','N'" ) )
Local cDupli 		:= If( (mv_par13 == 1),"'S'",If( (mv_par13 == 2),"'N'","'S','N'" ) )

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ VARIAVEIS DE COLUNAS                                                   ≥
//≥ As variaveis abaixo nCol???, guardam valores das colunas que ser∆o     ≥
//≥ usadas na impressao, pois como tem 4 formas de quebra, a cada forma de ≥
//≥ um cabecalho diferente as colunas ir∆o mudar.                          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local nOrdem      := aReturn[ 8 ] 
Local nLoop       := 0
Local nValor      := 0 
Local nValorQueb  := 0 
Local nValorTot   := 0 
Local nValReal    := 0 
Local nValMeta    := 0 
Local nQtdReal    := 0 

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis utilizadas para parametros                     ≥
//≥                                                          ≥
//≥ mv_par01            // Dt. emissao de ?                  ≥
//≥ mv_par02            // Dt. emissao ate ?                 ≥
//≥ mv_par03            // Regiao de ?                       ≥
//≥ mv_par04            // Regiao ate ?                      ≥
//≥ mv_par05            // Tipo de ?                         ≥
//≥ mv_par06            // Tipo ate ?                        ≥
//≥ mv_par07            // Grupo de ?                        ≥
//≥ mv_par08            // Grupo ate ?                       ≥
//≥ mv_par09            // Considera devolucao Sim/Nao       ≥
//≥ mv_par10            // Dt. emissao de ?                  ≥
//≥ mv_par11            // Dt. emissao ate ?                 ≥
//≥ mv_par12            // Moeda ?                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

Li := 100 

dbSelectArea(cString)
SetRegua(LastRec())
dbSetOrder(1)
dbSeek(xFilial())

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Imprime o relatorio                                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Cria o code-block de filtro do usuario                              ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ   

If !Empty( aReturn[7] ) 
	cBlockFil := "{ || " + aReturn[ 7 ] + " }"
	bCondFil  := &cBlockFil 
EndIf 	

AD5->( dbSetOrder( 1 ) ) 
cKey := AD5->( IndexKey() ) 

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Selecao dos registros validos para o processamento           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
#IFDEF TOP                 

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Logica para SQL                                                     ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cAliasSCT := GetNextAlias()

	aStruSCT := SCT->( dbStruct() ) 

	lQuery := .T.                      
    
	If Empty( aReturn[ 7 ] ) 
		cQuery := "SELECT CT_DOC,CT_SEQUEN,CT_TIPO,CT_GRUPO,CT_PRODUTO,CT_VEND,CT_REGIAO,CT_MOEDA,CT_DESCRI,CT_DATA,CT_VALOR,CT_QUANT "
	Else	
		cQuery := "SELECT * "
	EndIf 
		
	cQuery += "FROM "
	cQuery += RetSQLName("SCT")+" SCT "
	cQuery += "WHERE CT_FILIAL='"+xFilial("SCT")+"' AND "
	cQuery += "CT_REGIAO>='"+MV_PAR03+"' AND "
	cQuery += "CT_REGIAO<='"+MV_PAR04+"' AND "	
	cQuery += "CT_TIPO>='"  +MV_PAR05+"' AND "
	cQuery += "CT_TIPO<='"  +MV_PAR06+"' AND "	
	cQuery += "CT_GRUPO>='" +MV_PAR07+"' AND "
	cQuery += "CT_GRUPO<='" +MV_PAR08+"' AND "	
	cQuery += "CT_DATA>='"  +DToS(MV_PAR10)+"' AND "
	cQuery += "CT_DATA<='"  +DToS(MV_PAR11)+"' AND "	
	
	cQuery += "SCT.D_E_L_E_T_=' '" 

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCT,.T.,.T.)

	For nLoop := 1 To Len( aStruSCT ) 
		If aStruSCT[ nLoop, 2 ] <> "C" .And. !Empty( ( cAliasSCT )->( FieldPos( aStruSCT[ nLoop, 1 ] ) ) )
			TcSetField(cAliasSCT,aStruSCT[ nLoop, 1 ],aStruSCT[ nLoop, 2 ],aStruSCT[ nLoop, 3 ],aStruSCT[ nLoop, 4 ] )
		EndIf 		
	Next nLoop 	
	
	bWhile := { || !( cAliasSCT )->( Eof() ) }
	
	nValor := 0 
	nQuant := 0     
	
#ELSE 

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Logica para ISAM                                                    ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
   
	cQuery := "" 
	cQuery += "CT_FILIAL='"  + xFilial("SCT") + "'.AND."
	cQuery += "CT_REGIAO>='" + MV_PAR03       + "'.AND."
	cQuery += "CT_REGIAO<='" + MV_PAR04+"'.AND."	
	cQuery += "CT_TIPO>='"   + MV_PAR05+"'.AND."
	cQuery += "CT_TIPO<='"   + MV_PAR06+"'.AND."	
	cQuery += "CT_GRUPO>='"  + MV_PAR07+"'.AND."
	cQuery += "CT_GRUPO<='"  + MV_PAR08+"'.AND."	
	cQuery += "DTOS(CT_DATA)>='" + DToS(MV_PAR10)+"'.AND."
	cQuery += "DTOS(CT_DATA)<='" + DToS(MV_PAR11)+"'
		
	cIndSCT := CriaTrab( , .F. ) 
	IndRegua("SCT", cIndSCT, SCT->( IndexKey()) ,,cQuery,"Selecionando Registros ...")	
	nIndex := RetIndex("SCT")
	
	SCT->( dbSetIndex(cIndSCT+OrdBagExt() ) ) 
	SCT->( dbSetOrder( nIndex+1 ) )

	bWhile := { || !SCT->( Eof() ) }
	                                 
	cAliasSCT := "SCT" 

#ENDIF	
	
While Eval( bWhile ) 
      
	If Empty( aReturn[ 7 ] ) .Or. &( aReturn[ 7 ] )       
                              
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Chama a funcao de calculo das vendas                         ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If MV_PAR15 == 1 // Comparativo com Notas Fiscais
			aVendas := FtNfVendas(4,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_REGIAO,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,mv_par12,"","","",,cDupli,cEstoq)
		ElseIf MV_PAR15 == 2 // Comparativo com Pedidos de Vendas
			aVendas := FtPdVendas(7,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,MV_PAR12,"","","")
		Endif
	
		aDevol := { 0,0,0 }
		
		If MV_PAR09 == 1 .And. MV_PAR15 == 1
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Chama a funcao de calculo das devolucoes de venda            ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			aDevol := FtNfDevol(4,(cAliasSCT)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasSCT)->CT_REGIAO,(cAliasSCT)->CT_TIPO,(cAliasSCT)->CT_GRUPO,(cAliasSCT)->CT_PRODUTO,MV_PAR12,"","",,cDupli,cEstoq)
		EndIf 			
				
		Li++                     
		
		nValMeta := xMoeda( ( cAliasSCT )->CT_VALOR, ( cAliasSCT )->CT_MOEDA, MV_PAR12, ( cAliasSCT )->CT_DATA ) 
	
		If ( Li > 58 )
			li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
			li++
		Endif         
	
	//     NUMERO    SEQ DESCRICAO                  DATA       VENDEDOR  REGIAO  PRODUTO                        GRUPO  TIPO        VALOR/META         QUANT/META        VALOR/REAL   QUANT/REAL       DIFERENCA VALOR   DIFERENCA QTD
	//               1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	//     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//     XXXXXXXXX XXX XXXXXXXXXXXXXXXXXXXXXXXXX  XX/XX/XXXX XXXXXX    XXX     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXX    XX   9,999,999,999.99       9,999,999.99  9,999,999,999.99 9,999,999.99      9,999,999,999.99    9,999,999.99     
	 	
	 	@ Li, 00 PSAY ( cAliasSCT )->CT_DOC
	 	@ Li, 10 PSAY ( cAliasSCT )->CT_SEQUEN	 	
	 	@ Li, 14 PSAY Left((cAliasSCT)->CT_DESCRI, 25) 
	 	@ Li, 41 PSAY ( cAliasSCT )->CT_DATA 
	
	 	@ Li, 52 PSAY ( cAliasSCT )->CT_VEND 	 	
	 	
	 	@ Li, 62  PSAY ( cAliasSCT )->CT_REGIAO 	 	
	 	@ Li, 70  PSAY ( cAliasSCT )->CT_PRODUTO
	 	@ Li, 101 PSAY ( cAliasSCT )->CT_GRUPO 	
	 	@ Li, 109 PSAY ( cAliasSCT )->CT_TIPO 		 	
	 	
	 	@ Li,114 PSAY nValMeta                PICTURE "@E 9,999,999,999.99"
	 	@ Li,137 PSAY ( cAliasSCT )->CT_QUANT PICTURE "@E 9,999,999.99"	 	
	 	
	 	nValReal := aVendas[ 1 ] - aDevol[ 1 ]
	 	nQtdReal := aVendas[ 2 ] - aDevol[ 2 ]
	 	
		@ Li,151 PSAY nValReal PICTURE "@E 9,999,999,999.99" 
		@ Li,168 PSAY nQtdReal PICTURE "@E 999,999,999.99" 
		                                                       
		@ Li,186 PSAY nValReal - nValMeta                 PICTURE "@E 9,999,999,999.99"
		@ Li,206 PSAY nQtdReal - ( cAliasSCT )->CT_QUANT  PICTURE "@E 9,999,999.99"

	EndIf 
			
	( cAliasSCT )->( dbSkip() ) 
	
EndDo

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Restaura a integridade da rotina                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
#IFDEF TOP
  	( cAliasSCT )->( dbCloseArea() ) 
  	dbSelectArea( "SCT" ) 
#ELSE  	
	RetIndex("SCT")
	FErase(cIndSCT+OrdBagExt())	
#ENDIF
	
If ( lImp )
	Roda(cbCont,cbText,Tamanho)
EndIf       

Set Device To Screen
Set Printer To
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

dbSelectArea( "SCT" )
RetIndex("SCT")

Return(.T.)




/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao    ≥FtPdVendas≥ Autor ≥Eduardo Riera          ≥ Data ≥12.12.2000 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥Calcula o Valor das Vendas com base nos pedidos de venda     ≥±±
±±≥          ≥para integracao com o MsOffice.                              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ExpN1: Tipo de Meta :(1-Numerico-Valor liquido - desconto )  ≥±±
±±≥          ≥                     (2-Numerico-Quantidade )                ≥±±
±±≥          ≥                     (3-Numerico-Valor bruto + desconto )    ≥±±
±±≥          ≥                     (4-Numerico-Saldo liquido - desconto )  ≥±±
±±≥          ≥                     (5-Numerico-Saldo Quantidade )          ≥±±
±±≥          ≥                     (6-Numerico-Saldo bruto + desconto )    ≥±±
±±≥          ≥                     (7-Array-contendo todos os valores acima≥±±
±±≥          ≥                     (8-Array-contendo todos os valores acima≥±±
±±≥          ≥                      por produto                            ≥±±
±±≥          ≥ExpC2: cCodigo                                               ≥±±
±±≥          ≥ExpD3: Data de Inicio                                        ≥±±
±±≥          ≥ExpD4: Data de Termino                                       ≥±±
±±≥          ≥ExpC6: Tipo de Produto                                       ≥±±
±±≥          ≥ExpC7: Grupo de Produto                                      ≥±±
±±≥          ≥ExpC8: Codigo do Produto                                     ≥±±
±±≥          ≥ExpN9: Moeda para conversao                                  ≥±±
±±≥          ≥ExpCA: Cliente                                               ≥±±
±±≥          ≥ExpCB: Loja                                                  ≥±±
±±≥          ≥ExpCC: Expressao a ser adicionada na Query ou Filtro para    ≥±±
±±≥          ≥       SGBD ISAM                                             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥ExpX1: Valor / Array conforme tipo da Meta                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Calcula o Valor das Vendas com base nas notas fiscais de     ≥±±
±±≥          ≥saida                                                        ≥±±
±±≥          ≥                                                             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥Materiais                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function FtPdVendas(nTpMeta,cCodigo,dDataIni,dDataFim,cTipo,cGrupo,cProduto,nMoeda,cCliente,cLoja,cQueryAdd)

Local aArea   := GetArea()
Local aAreaSA3:= SA3->(GetArea())
Local aAreaSF4:= SF4->(GetArea())
Local aAreaSC6:= SC6->(GetArea())
Local aAreaSC5:= SC5->(GetArea())
Local aAreaSB1:= SB1->(GetArea())
Local aGrupos := {} 
Local cQuery  := ""
Local cArqQry := "FtPDVendas"
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
DEFAULT nTpMeta := 1
DEFAULT cCodigo := ""
DEFAULT dDataIni:= dDataBase
DEFAULT dDataFim:= dDataBase
DEFAULT cTipo   := ""
DEFAULT cGrupo  := ""
DEFAULT cProduto:= ""
DEFAULT nMoeda  := 0 
DEFAULT cCliente:= ""
DEFAULT cLoja   := ""

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Acerta o Tamanho da Variaveis                                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cCodigo := PadR(cCodigo,Len(SA3->A3_COD))
cTipo   := PadR(cTipo,Len(SB1->B1_TIPO))
cGrupo  := PadR(cGrupo,Len(SB1->B1_GRUPO))
cProduto:= PadR(cProduto,Len(SC6->C6_PRODUTO))
                    
If nTpMeta == 7
	xRetorno := { 0, 0, 0 ,0,0,0} 
EndIf
If nTpMeta == 8
	xRetorno := {} 
EndIf

If !Empty( cCodigo ) 
	
	#IFNDEF TOP
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Adiciona o proprio representante                                       ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		cFilGrupo := "{ || SA3->A3_COD=='" + cCodigo + "'"
	#ENDIF 	
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Adiciona os grupos que estao abaixo deste representante                ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
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
				cQuery := "SELECT SUM(SC6.C6_VALOR) C6_VALOR "
			Case ( nTpMeta == 2 )
				cQuery := "SELECT SUM(SC6.C6_QTDVEN) C6_QTDVEN "
			Case ( nTpMeta == 3 )
				cQuery := "SELECT SUM(SC6.C6_VALDESC+(SC6.C6_QTDVEN*(SC6.C6_PRUNIT-SC6.C6_PRCVEN))) C6_VALOR "
			Case ( nTpMeta == 4 )
				cQuery := "SELECT SUM((SC6.C6_PRCVEN*(SC6.C6_QTDVEN-SC6.C6_QTDENT))) C6_VALOR "
			Case ( nTpMeta == 5 )
				cQuery := "SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) C6_QTDVEN "
			Case ( nTpMeta == 6 )
				cQuery := "SELECT SUM((SC6.C6_PRCVEN*(SC6.C6_QTDVEN-SC6.C6_QTDENT))+((SC6.C6_PRUNIT-SC6.C6_PRCVEN)*(SC6.C6_QTDVEN-SC6.C6_QTDENT))) C6_VALOR "
			Case ( nTpMeta == 7 )
				cQuery := "SELECT SUM(SC6.C6_VALOR) C6_VALOR,"
				cQuery += "SUM(SC6.C6_QTDVEN) C6_QTDVEN,"
				cQuery += "SUM(SC6.C6_VALDESC+(SC6.C6_QTDVEN*(SC6.C6_PRUNIT-SC6.C6_PRCVEN))) C6_TOTDESC,"
				cQuery += "SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) C6_QTDVEN2,"
				cQuery += "SUM((SC6.C6_PRCVEN*(SC6.C6_QTDVEN-SC6.C6_QTDENT))) C6_VALOR2,"
				cQuery += "SUM(((SC6.C6_PRUNIT-SC6.C6_PRCVEN)*(SC6.C6_QTDVEN-SC6.C6_QTDENT))) C6_TOTDESC2 "
			Otherwise
				cQuery := "SELECT SC6.C6_PRODUTO,SUM(SC6.C6_VALOR) C6_VALOR,"
				cQuery += "SUM(SC6.C6_QTDVEN) C6_QTDVEN,"
				cQuery += "SUM(SC6.C6_VALDESC+(SC6.C6_QTDVEN*(SC6.C6_PRUNIT-SC6.C6_PRCVEN))) C6_TOTDESC,"
				cQuery += "SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) C6_QTDVEN2,"
				cQuery += "SUM((SC6.C6_PRCVEN*(SC6.C6_QTDVEN-SC6.C6_QTDENT))) C6_VALOR2,"
				cQuery += "SUM(((SC6.C6_PRUNIT-SC6.C6_PRCVEN)*(SC6.C6_QTDVEN-SC6.C6_QTDENT))) C6_TOTDESC2 "
		EndCase
	
		If !Empty( nMoeda )
			cQuery += ",C5_MOEDA,C5_EMISSAO "
		EndIf
			
		cQuery += "FROM "
		
		cQuery += RetSqlName("SC6")+" SC6,"
		cQuery += RetSqlName("SF4")+" SF4,"
		cQuery += RetSqlName("SC5")+" SC5,"
		cQuery += RetSqlName("SB1")+" SB1 "
		cQuery += "WHERE "
	    
    	cQuery += "SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
    	cQuery += "SC5.C5_TIPO='N' AND "
		cQuery += "SC5.C5_PEDWEB = '' AND "
		If ( !Empty(dDataIni) )
			cQuery += "SC5.C5_EMISSAO>='"+Dtos(dDataIni)+"' AND "
		EndIf
		If ( !Empty(dDataFim) )
			cQuery += "SC5.C5_EMISSAO<='"+Dtos(dDataFim)+"' AND "
		EndIf
		If ( !Empty(cCliente) )
			cQuery += "SC5.C5_CLIENTE='"+cCliente+"' AND "
		EndIf
		If ( !Empty(cLoja) )
			cQuery += "SC5.C5_LOJACLI='"+cLoja+"' AND "
		EndIf
		cQuery += "SC5.D_E_L_E_T_<>'*' AND "
		cQuery += "SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery += "SC6.C6_NUM=SC5.C5_NUM AND "
		cQuery += "SC6.C6_CLI=SC5.C5_CLIENTE AND "
		cQuery += "SC6.C6_LOJA=SC5.C5_LOJACLI AND "
		cQuery += "SC6.C6_BLQ NOT IN('R ','S ') AND "
		If ( !Empty(cProduto) )
			cQuery += "SC6.C6_PRODUTO='"+cProduto+"' AND "
		EndIf
		cQuery += "SC6.D_E_L_E_T_<>'*' AND "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += "SB1.B1_COD=SC6.C6_PRODUTO AND "
		If ( !Empty(cTipo) )
			cQuery += "SB1.B1_TIPO='"+cTipo+"' AND "
		EndIf
		If ( !Empty(cGrupo) )
			cQuery += "SB1.B1_GRUPO='"+cGrupo+"' AND "
		EndIf
		cQuery += "SB1.D_E_L_E_T_<>'*' AND "
    	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Verifica os Vendedores.                                                 ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ		
		If !Empty( cCodigo ) 
		
			cQuery += "EXISTS ( SELECT A3_FILIAL FROM " + RetSqlName( "SA3" ) + " SA3 WHERE "
			
			If ( !Empty(cCodigo) )
		    	cVend := "1"
		    	cQuery += "("
		    	For nCntFor := 1 To nCntVend
					cQuery += "SC5.C5_VEND"+cVend+"=SA3.A3_COD OR "
					cVend := Soma1(cVend,Len(SC5->C5_VEND1))
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
		cQuery += "SF4.F4_CODIGO=SC6.C6_TES AND "
		cQuery += "SF4.F4_DUPLIC='S' AND "
		cQuery += "SF4.F4_ESTOQUE='S' AND "		
		cQuery += "SF4.D_E_L_E_T_<>'*' "

		// Tratamento para evitar Pedidos Devolvidos no Calculo de Metas - 3L Systems - 14-08-2014 - Luiz
		cQuery += "AND NOT EXISTS(SELECT 'Z' FROM " + RetSqlName("SD1") + " D1 WHERE D1_TIPO = 'D' AND D1_COD = C6_PRODUTO AND D1_LOTECTL = C6_LOTECTL AND D1.D_E_L_E_T_ = ' ')  "

		If !Empty(cQueryAdd)
			cQuery += " AND "+cQueryAdd
		EndIF
		If nTpMeta <> 8
			If !Empty( nMoeda ) 		
				cQuery += "GROUP BY C5_MOEDA,C5_EMISSAO " 
			EndIf 
		Else
			If !Empty( nMoeda )
				cQuery += "GROUP BY C5_MOEDA,C5_EMISSAO,C6_PRODUTO" 
			Else 
				cQuery += "GROUP BY C6_PRODUTO"
			EndIf 		
		EndIf
		
			
		cQuery := ChangeQuery(cQuery)      
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		Do Case
			Case ( nTpMeta == 1 .Or. nTpMeta == 3 .Or. nTpMeta == 4 .Or. nTpMeta == 6 )
				TcSetField(cArqQry,"C6_VALOR","N",18,2)
			Case nTpMeta == 2 .Or. nTpMeta == 5
				TcSetField(cArqQry,"C6_QTDVEN","N",18,2)
			OtherWise
				TcSetField(cArqQry,"C6_QTDVEN","N",18,2)
				TcSetField(cArqQry,"C6_VALOR","N",18,2)
				TcSetField(cArqQry,"C6_TOTDESC","N",18,2)
				TcSetField(cArqQry,"C6_QTDVEN2","N",18,2)
				TcSetField(cArqQry,"C6_VALOR2","N",18,2)
				TcSetField(cArqQry,"C6_TOTDESC2","N",18,2)				
		EndCase
		
		If !Empty( nMoeda ) 
			TcSetField(cArqQry,"C5_MOEDA"  ,"N",2,0)
			TcSetField(cArqQry,"C5_EMISSAO","D",8,0)			
		EndIf 						
		
		While ( !Eof() )
			Do Case
				Case ( nTpMeta == 1 .Or. nTpMeta == 3 .Or. nTpMeta == 4 .Or. nTpMeta == 6 )
					xRetorno += If( Empty( nMoeda ), C6_VALOR, xMoeda( C6_VALOR, C5_MOEDA, nMoeda, C5_EMISSAO ) )
				Case nTpMeta == 2 .Or. nTpMeta == 5
					xRetorno += C6_QTDVEN
				Case nTpMeta == 7
					xRetorno[ 1 ] += If( Empty( nMoeda ), C6_VALOR, xMoeda( C6_VALOR, C5_MOEDA, nMoeda, C5_EMISSAO ) )
					xRetorno[ 2 ] += C6_QTDVEN
					xRetorno[ 3 ] += If( Empty( nMoeda ), C6_TOTDESC, xMoeda( C6_TOTDESC, C5_MOEDA, nMoeda, C5_EMISSAO ) )
					xRetorno[ 4 ] += If( Empty( nMoeda ), C6_VALOR2, xMoeda( C6_VALOR2, C5_MOEDA, nMoeda, C5_EMISSAO ) )
					xRetorno[ 5 ] += C6_QTDVEN2
					xRetorno[ 6 ] += If( Empty( nMoeda ), C6_TOTDESC2, xMoeda( C6_TOTDESC2, C5_MOEDA, nMoeda, C5_EMISSAO ) )
				OtherWise
					nX := aScan(xRetorno,{|x| x[1] == C6_PRODUTO})
					If nX == 0
						aadd(xRetorno,{C6_PRODUTO,0,0,0,0,0,0})
						nX := Len(xRetorno)
					EndIf
					xRetorno[ nX , 2 ] += If( Empty( nMoeda ), C6_VALOR, xMoeda( C6_VALOR, C5_MOEDA, nMoeda, C5_EMISSAO ) )
					xRetorno[ nX , 3 ] += C6_QTDVEN
					xRetorno[ nX , 4 ] += If( Empty( nMoeda ), C6_TOTDESC, xMoeda( C6_TOTDESC, C5_MOEDA, nMoeda, C5_EMISSAO ) )
					xRetorno[ nX , 5 ] += If( Empty( nMoeda ), C6_VALOR2, xMoeda( C6_VALOR2, C5_MOEDA, nMoeda, C5_EMISSAO ) )
					xRetorno[ nX , 6 ] += C6_QTDVEN2
					xRetorno[ nX , 7 ] += If( Empty( nMoeda ), C6_TOTDESC2, xMoeda( C6_TOTDESC2, C5_MOEDA, nMoeda, C5_EMISSAO ) )
			EndCase
			dbSelectArea(cArqQry)
			dbSkip()
		EndDo
		dbSelectArea(cArqQry)
		dbCloseArea()
		dbSelectArea("SC6")
	Else
#ENDIF         
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Efetua a selecao dos registros                                          ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		dbSelectArea("SC5")
		dbSetOrder(2)
		cSeek  := xFilial("SC5")+AllTrim(Dtos(dDataIni))
		cComp  := "SC5->C5_FILIAL=='"+xFilial("SC5")+"'"
		If ( !Empty(dDataIni) )
			cComp += ".And. Dtos(SC5->C5_EMISSAO)>='"+Dtos(dDataIni)+"'"
		EndIf
		If ( !Empty(dDataFim) )
			cComp += ".And. Dtos(SC5->C5_EMISSAO)<='"+Dtos(dDataFim)+"'"
		EndIf
		cComp += ".And. SC5->C5_PEDWEB = '' "
		cComp += ".And. SC5->C5_TIPO = 'N' "
		MsSeek(cSeek,.T.)
		While ( !Eof() .And. &cComp )
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Posiciona Registros.                                                    ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC5->C5_NUM)
			While !Eof() .And. SC6->C6_FILIAL=xFilial("SC6") .And.;
				SC6->C6_NUM==SC5->C5_NUM				
			
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(xFilial("SF4")+SC6->C6_TES)
				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial("SB1")+SC6->C6_PRODUTO)
				cVend := "1"
				lVend := .F.
				If ( !Empty(cCodigo) )
			    	For nCntFor := 1 To nCntVend
						
						//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
						//≥ Pesquisa por todos os vendedores do SC5 no SA3                         ≥
						//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ					
						cCodVend := SC5->(FieldGet(FieldPos("C5_VEND"+cVend))) 						
						SA3->( dbSetOrder( 1 ) ) 
						If SA3->( MsSeek( xFilial( "SA3" ) + cCodVend ) )  
						
							//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
							//≥ Verifica se eh o proprio vendedor ou se o vendedor esta                ≥
							//≥ no grupo de vendedores validos                                         ≥								
							//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
						    If SA3->A3_COD == cCodigo .Or. !Empty( AScan( aGrupos, { |x| x[1]==SA3->A3_GRPREP } ) )
								lVend := .T. 
							EndIf
						EndIf 						
						cVend := Soma1(cVend,Len(SC5->C5_VEND1))
						If ( lVend )
							Exit 
						EndIf
						
					Next nCntFor
				Else
					lVend := .T.					
				EndIf
				If (( lVend .And. SC5->C5_TIPO=='N') .And.;
					(Empty(cTipo).Or.cTipo==SB1->B1_TIPO).And.;
					(Empty(cGrupo).Or.cGrupo==SB1->B1_GRUPO).And.;
					(Empty(cProduto).Or.cProduto==SC6->C6_PRODUTO).And.;
					(Empty(cCliente).Or.cCliente==SC6->C6_CLI).And.;
					(Empty(cLoja).Or.cLoja==SC6->C6_LOJA).And.;
					(SF4->F4_DUPLIC=="S".And.SF4->F4_ESTOQUE=="S") .And.;
					!SC6->C6_BLQ $ 'R ,S ').And.;
					(IIf(Empty(cQueryAdd),.T.,&cQueryAdd))
					Do Case
						Case ( nTpMeta == 1 )
							xRetorno += If( Empty( nMoeda ), SC6->C6_VALOR, xMoeda( SC6->C6_VALOR, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
						Case ( nTpMeta == 2 )
							xRetorno += SC6->C6_QTDVEN
						Case ( nTpMeta == 3 )
							xRetorno += If( Empty( nMoeda ), SC6->C6_VALOR+SC6->C6_VALDESC, xMoeda( SC6->C6_VALOR+SC6->C6_VALDESC, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
						Case ( nTpMeta == 4 )
							xRetorno += If( Empty( nMoeda ), ((SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN)-((SC6->C6_QTDVEN-SC6->C6_QTDENT)*(SC6->C6_VALDESC/SC6->C6_QTDVEN)), xMoeda( ((SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN)-((SC6->C6_QTDVEN-SC6->C6_QTDENT)*(SC6->C6_VALDESC/SC6->C6_QTDVEN)), SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
						Case ( nTpMeta == 5 )
							xRetorno += SC6->C6_QTDVEN-SC6->C6_QTDENT
						Case ( nTpMeta == 6 )
							xRetorno += If( Empty( nMoeda ), (SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN, xMoeda( (SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
						Case ( nTpMeta == 7 )
							xRetorno[ 1 ] += If( Empty( nMoeda ), SC6->C6_VALOR, xMoeda( SC6->C6_VALOR, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
							xRetorno[ 2 ] += SC6->C6_QTDVEN	
							xRetorno[ 3 ] += If( Empty( nMoeda ), SC6->C6_VALOR+SC6->C6_VALDESC, xMoeda( SC6->C6_VALOR+SC6->C6_VALDESC, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
							xRetorno[ 4 ] += If( Empty( nMoeda ), ((SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN)-((SC6->C6_QTDVEN-SC6->C6_QTDENT)*(SC6->C6_VALDESC/SC6->C6_QTDVEN)), xMoeda( ((SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN)-((SC6->C6_QTDVEN-SC6->C6_QTDENT)*(SC6->C6_VALDESC/SC6->C6_QTDVEN)), SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
							xRetorno[ 5 ] += SC6->C6_QTDVEN-SC6->C6_QTDENT
							xRetorno[ 6 ] += If( Empty( nMoeda ), (SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN, xMoeda( (SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
						OtherWise
							nX := aScan(xRetorno,{|x| x[1] == SC6->C6_PRODUTO})
							If nX == 0
								aadd(xRetorno,{SC6->C6_PRODUTO,0,0,0,0,0,0})
								nX := Len(xRetorno)
							EndIf
							xRetorno[ nX , 2 ] += If( Empty( nMoeda ), SC6->C6_VALOR, xMoeda( SC6->C6_VALOR, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
							xRetorno[ nX , 3 ] += SC6->C6_QTDVEN
							xRetorno[ nX , 4 ] += If( Empty( nMoeda ), SC6->C6_VALOR+SC6->C6_VALDESC, xMoeda( SC6->C6_VALOR+SC6->C6_VALDESC, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
							xRetorno[ nX , 5 ] += If( Empty( nMoeda ), ((SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN)-((SC6->C6_QTDVEN-SC6->C6_QTDENT)*(SC6->C6_VALDESC/SC6->C6_QTDVEN)), xMoeda( ((SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN)-((SC6->C6_QTDVEN-SC6->C6_QTDENT)*(SC6->C6_VALDESC/SC6->C6_QTDVEN)), SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
							xRetorno[ nX , 6 ] += SC6->C6_QTDVEN-SC6->C6_QTDENT
							xRetorno[ nX , 7 ] += If( Empty( nMoeda ), (SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN, xMoeda( (SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN, SC5->C5_MOEDA, nMoeda, SC5->C5_EMISSAO ) )
					EndCase
				EndIf
				dbSelectArea("SC6")
				dbSkip()			
			EndDo
			dbSelectArea("SC5")
			dbSkip()
		EndDo
		
#IFDEF TOP
	EndIf
#ENDIF
RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaSF4)
RestArea(aAreaSB1)
RestArea(aAreaSA3)
RestArea(aArea)
Return(xRetorno)


/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?tNfVendas?Autor ?duardo Riera          ?Data ?2.12.2000 ??
???????????????????????????????????????
??         ?alcula o Valor das Vendas com base nas notas fiscais de     ??
??         ?aida para intergracao com MsOffice.                         ??
???????????????????????????????????????
??arametros?xpN1: Tipo de Meta :(1-Numerico-Valor liquido - desconto )  ??
??         ?                    (2-Numerico-Quantidade )                ??
??         ?                    (3-Numerico-Valor bruto + desconto )    ??
??         ?                    (4-Array-contendo todos os valores acima??
??         ?                    (5-Array-contendo todos os valores acima??
??         ?                     por produto                            ??
??         ?xpC2: cCodigo                                               ??
??         ?xpD3: Data de Inicio                                        ??
??         ?xpD4: Data de Termino                                       ??
??         ?xpC5: Regiao de Vendas.                                     ??
??         ?xpC6: Tipo de Produto                                       ??
??         ?xpC7: Grupo de Produto                                      ??
??         ?xpC8: Codigo do Produto                                     ??
??         ?xpN9: Moeda para conversao                                  ??
??         ?xpCA: Cliente                                               ??
??         ?xpCB: Loja                                                  ??
??         ?xpCC: Expressao a ser adicionada na Query ou Filtro para    ??
??         ?      SGBD ISAM                                             ??
??         ?xpCD: Determina se devem ser consideradas Notas fiscais (1) ??
??         ?      REMITOS (2) ou ambos tipos de documento (3)           ??
???????????????????????????????????????
??etorno   ?xpX1: Valor / Array conforme tipo da Meta                   ??
???????????????????????????????????????
??escri?o ?alcula o Valor das Vendas com base nas notas fiscais de     ??
??         ?aida                                                        ??
??         ?                                                            ??
???????????????????????????????????????
??so       ?ateriais                                                    ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function FtNfVendas(nTpMeta,cCodigo,dDataIni,dDataFim,cRegiao,cTipo,cGrupo,cProduto,nMoeda,cCliente,cLoja,cQueryAdd,cTipoDoc,cDupli,cEstoq)

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

//?????????????????????????????????????
//?certa o Tamanho da Variaveis                                           ?
//?????????????????????????????????????
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
		//?????????????????????????????????????
		//?Adiciona o proprio representante                                       ?
		//?????????????????????????????????????
		cFilGrupo := "{ || SA3->A3_COD=='" + cCodigo + "'"
	#ENDIF 	
	
	//?????????????????????????????????????
	//?Adiciona os grupos que estao abaixo deste representante                ?
	//?????????????????????????????????????
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
		If cTipoDoc == '1' .Or. cTipoDoc == '3'
			cQuery += " NOT ("+IsRemito(3,'SF2.F2_TIPODOC')+") AND "			
		ElseIf cTipoDoc == '2'	
			cQuery += IsRemito(3,'SF2.F2_TIPODOC')+" AND "			
		Endif
		cQuery += "SF2.D_E_L_E_T_<>'*' AND "
		cQuery += "SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
		cQuery += "SF2.F2_SERIE BETWEEN '" + MV_PAR16 + "' AND '" + MV_PAR17 + "' AND "
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
		
    	//?????????????????????????????????????
		//?erifica os Vendedores.                                                 ?
		//?????????????????????????????????????		
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
		If !Empty(cQueryAdd)
			cQuery += " AND "+cQueryAdd
		EndIf
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
		
		//????????????????????
		//?eleciona as remisiones nao faturadas?
		//????????????????????	
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
			cQuery += "SF2.F2_SERIE BETWEEN '" + MV_PAR16 + "' AND '" + MV_PAR17 + "' AND "
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
	    	//?????????????????????????????????????
			//?erifica os Vendedores.                                                 ?
			//?????????????????????????????????????		
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
			If !Empty(cQueryAdd)
				cQuery += " AND "+cQueryAdd
			EndIf
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
		//?????????????????????????????????????
		//?fetua a selecao dos registros                                          ?
		//?????????????????????????????????????
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
			//?????????????????????????????????????
			//?osiciona Registros.                                                    ?
			//?????????????????????????????????????
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
						
							//?????????????????????????????????????
							//?Pesquisa por todos os vendedores do SF2 no SA3                         ?
							//?????????????????????????????????????
					
							cCodVend := SF2->(FieldGet(FieldPos("F2_VEND"+cVend))) 
						
							SA3->( dbSetOrder( 1 ) ) 
							If SA3->( MsSeek( xFilial( "SA3" ) + cCodVend ) )  
						
								//?????????????????????????????????????
								//?Verifica se eh o proprio vendedor ou se o vendedor esta                ?
								//?no grupo de vendedores validos                                         ?							
								//?????????????????????????????????????
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
						(SF4->F4_DUPLIC $ cDupli .And. SF4->F4_ESTOQUE $ cEstoq) .And.;
						(SD2->D2_SERIE >= MV_PAR16 .And. SD2->D2_SERIE <= MV_PAR17)  .And.;
						(IIf(Empty(cQueryAdd),.T.,&cQueryAdd)))

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
/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?tNfDevol ?Autor ?duardo Riera          ?Data ?2.12.2000 ??
???????????????????????????????????????
??         ?alcula o Valor das Devolucoes com base nas notas fiscais de ??
??         ?ntrada pra integracao com MsOffice.                         ??
???????????????????????????????????????
??arametros?xpN1: Tipo de Meta :(1-Numerico-Valor liquido - desconto )  ??
??         ?                    (2-Numerico-Quantidade )                ??
??         ?                    (3-Numerico-Valor bruto + desconto )    ??
??         ?                    (4-Array-contendo todos os valores acima??
??         ?                    (5-Array-contendo todos os valores acima??
??         ?                     por produto                            ??
??         ?xpC2: cCodigo                                               ??
??         ?xpD3: Data de Inicio                                        ??
??         ?xpD4: Data de Termino                                       ??
??         ?xpC5: Regiao de Vendas.                                     ??
??         ?xpC6: Tipo de Produto                                       ??
??         ?xpC7: Grupo de Produto                                      ??
??         ?xpC8: Codigo do Produto                                     ??
??         ?xpN9: Moeda para conversao                                  ??
??         ?xpCA: Cliente                                               ??
??         ?xpCB: Loja                                                  ??
??         ?xpCC: Determina se devem ser consideradas Notas fiscais (1) ??
??         ?      REMITOS (2) ou ambos tipos de documento (3)           ??
???????????????????????????????????????
??etorno   ?xpX1: Valor conforme tipo da Meta                           ??
???????????????????????????????????????
??escri?o ?alcula o Valor das Devolucoes com base nas notas fiscais de ??
??         ?ntrada considerando apenas as datas de entrada e nao as     ??
??         ?otas de origem                                              ??
???????????????????????????????????????
??so       ?ateriais                                                    ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function FtNfDevol(nTpMeta,cCodigo,dDataIni,dDataFim,cRegiao,cTipo,cGrupo,cProduto,nMoeda,cCliente,cLoja,cTipoDoc,cDupli,cEstoq)

Local aArea   := GetArea()
Local aAreaSD1:= SD1->(GetArea())
Local aAreaSD2:= SD2->(GetArea())
Local aAreaSF2:= SF2->(GetArea())
Local aAreaSF4:= SF4->(GetArea())
Local aAreaSA3:= SA3->(GetArea())
Local cQuery  := ""
Local cArqQry := "FtNfDevol"
Local cSeek   := ""
Local cComp   := ""
Local cVend   := ""
Local cIn     := ""
Local xRetorno:= 0
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

DEFAULT cDupli		:= "'S'"
DEFAULT cEstoq		:= "'S'"

//?????????????????????????????????????
//?certa o Tamanho da Variaveis                                           ?
//?????????????????????????????????????
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
		//?????????????????????????????????????
		//?Adiciona o proprio representante                                       ?
		//?????????????????????????????????????
		cFilGrupo := "{ || SA3->A3_COD=='" + cCodigo + "'"
	#ENDIF 	
	
	//?????????????????????????????????????
	//?Adiciona os grupos que estao abaixo deste representante                ?
	//?????????????????????????????????????
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
				cQuery := "SELECT SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) D1_TOTAL "
			Case ( nTpMeta == 2 )
				cQuery := "SELECT SUM(SD1.D1_QUANT) D1_QUANT "
			Case ( nTpMeta == 3 )
				cQuery := "SELECT SUM(SD1.D1_TOTAL) D1_TOTAL "
			Case ( nTpMeta == 4 )
				cQuery := "SELECT SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) D1_TOTAL,SUM(SD1.D1_QUANT) D1_QUANT,SUM(SD1.D1_TOTAL) D1_TOTDESC "
			OtherWise
				cQuery := "SELECT D1_COD,SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) D1_TOTAL,SUM(SD1.D1_QUANT) D1_QUANT,SUM(SD1.D1_TOTAL) D1_TOTDESC "				
		EndCase
		
		If !Empty( nMoeda ) 
			cQuery += ",D1_DTDIGIT,F2_MOEDA "  
		EndIf 	
		
		cQuery += "FROM "
		cQuery += RetSqlName("SD2")+" SD2,"
		cQuery += RetSqlName("SD1")+" SD1,"
		cQuery += RetSqlName("SF4")+" SF4,"
		cQuery += RetSqlName("SF2")+" SF2 "
		cQuery += "WHERE "
	    cQuery += "SD1.D1_FILIAL='"+xFilial("SD1")+"' AND "
   	    cQuery += "SD1.D1_TIPO='D' AND "
		If ( !Empty(dDataIni) )
			cQuery += "SD1.D1_DTDIGIT>='"+Dtos(dDataIni)+"' AND "
		EndIf
		If ( !Empty(dDataFim) )
			cQuery += "SD1.D1_DTDIGIT<='"+Dtos(dDataFim)+"' AND "
		EndIf
		If ( !Empty(cCliente) )
			cQuery += "SD1.D1_FORNECE='"+cCliente+"' AND "
		EndIf
		If ( !Empty(cLoja) )
			cQuery += "SD1.D1_LOJA='"+cLoja+"' AND "
		EndIf
		If cTipoDoc == '1' .Or. cTipoDoc == '3'
			cQuery += " NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+") AND "			
		ElseIf cTipoDoc == '2'	
			cQuery += IsRemito(3,'SD1.D1_TIPODOC')+" AND "			
		Endif
		cQuery += "SD1.D_E_L_E_T_<>'*' AND "		
		cQuery += "SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
		cQuery += "SD2.D2_DOC=SD1.D1_NFORI AND "
		cQuery += "SD2.D2_SERIE=SD1.D1_SERIORI AND "
		cQuery += "SD2.D2_ITEM=SubString(SD1.D1_ITEMORI,1,2) AND "	
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
		cQuery += "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
		cQuery += "SF2.F2_SERIE=SD2.D2_SERIE AND "
		cQuery += "SF2.F2_DOC=SD2.D2_DOC AND "
		cQuery += "SF2.F2_CLIENTE=SD2.D2_CLIENTE AND "
		cQuery += "SF2.F2_LOJA=SD2.D2_LOJA AND "
		
		If ( !Empty(cRegiao) )
			If cPaisLoc == "BRA"
				cQuery += "SF2.F2_REGIAO='"+cRegiao+"' AND "
			Else
				cQuery += "EXISTS ( SELECT A1_REGIAO FROM " + RetSqlName( "SA1" ) + " SA1 WHERE "
				cQuery += "SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND "
				cQuery += "SA1.A1_REGIAO='" + cRegiao + "' AND "
				cQuery += "SA1.D_E_L_E_T_<>'*') AND "
			EndIf                                                                            
		Endif

		cQuery += "SF2.D_E_L_E_T_<>'*' AND "
		  
	   	//?????????????????????????????????????
		//?erifica os Vendedores.                                                 ?
		//?????????????????????????????????????		
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
				cQuery += "GROUP BY F2_MOEDA,D1_DTDIGIT "
			EndIf 
		Else
			If !Empty( nMoeda )
				cQuery += "GROUP BY F2_MOEDA,D1_DTDIGIT,D1_COD "
			Else
				cQuery += "GROUP BY D1_COD "
			EndIf 		
		EndIf
		
		//????????????????????
		//?eleciona as remisiones nao faturadas?
		//????????????????????	
		If cPaisLoc <> "BRA" .And. cTipoDoc == '3'
			cQuery += " UNION ALL "
			Do Case
				Case ( nTpMeta == 1 )
					cQuery += "SELECT SUM((SD1.D1_TOTAL-SD1.D1_VALDESC) * (SD1.D1_QTDACLA / SD1.D1_QUANT)) D1_TOTAL "
				Case ( nTpMeta == 2 )
					cQuery += "SELECT SUM(SD1.D1_QTDACLA) D1_QUANT "
				Case ( nTpMeta == 3 )
					cQuery += "SELECT SUM(SD1.D1_VUNIT * SD1.D1_QTDACLA) D1_TOTAL "
				Case ( nTpMeta == 4 )
					cQuery += "SELECT SUM((SD1.D1_TOTAL-SD1.D1_VALDESC) * (SD1.D1_QTDACLA / SD1.D1_QUANT)) D1_TOTAL,SUM(SD1.D1_QTDACLA) D1_QUANT,SUM(SD1.D1_VUNIT * SD1.D1_QTDACLA) D1_TOTDESC "
				OtherWise
					cQuery += "SELECT D1_COD,SUM((SD1.D1_TOTAL-SD1.D1_VALDESC) * (SD1.D1_QTDACLA / SD1.D1_QUANT)) D1_TOTAL,SUM(SD1.D1_QTDACLA) D1_QUANT,SUM(SD1.D1_VUNIT * SD1.D1_QTDACLA) D1_TOTDESC "	
			EndCase
			If !Empty( nMoeda ) 
				cQuery += ",D1_DTDIGIT,F2_MOEDA "  
			EndIf 	
			cQuery += "FROM "
			cQuery += RetSqlName("SD2")+" SD2,"
			cQuery += RetSqlName("SD1")+" SD1,"
			cQuery += RetSqlName("SF4")+" SF4,"
			cQuery += RetSqlName("SF2")+" SF2 "
			cQuery += "WHERE "
		    cQuery += "SD1.D1_FILIAL='"+xFilial("SD1")+"' AND "
	   	    cQuery += "SD1.D1_TIPO='D' AND "
			If ( !Empty(dDataIni) )
				cQuery += "SD1.D1_DTDIGIT>='"+Dtos(dDataIni)+"' AND "
			EndIf
			If ( !Empty(dDataFim) )
				cQuery += "SD1.D1_DTDIGIT<='"+Dtos(dDataFim)+"' AND "
			EndIf
			If ( !Empty(cCliente) )
				cQuery += "SD1.D1_FORNECE='"+cCliente+"' AND "
			EndIf
			If ( !Empty(cLoja) )
				cQuery += "SD1.D1_LOJA='"+cLoja+"' AND "
			EndIf
			cQuery += IsRemito(3,'SD1.D1_TIPODOC')+" AND "
			cQuery += "SD1.D1_QTDACLA > 0 AND "
			cQuery += "SD1.D_E_L_E_T_<>'*' AND "		
			cQuery += "SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
			cQuery += "SD2.D2_DOC=SD1.D1_NFORI AND "
			cQuery += "SD2.D2_SERIE=SD1.D1_SERIORI AND "
			cQuery += "SD2.D2_ITEM=SubString(SD1.D1_ITEMORI,1,2) AND "	
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
			cQuery += "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
			cQuery += "SF2.F2_SERIE=SD2.D2_SERIE AND "
			cQuery += "SF2.F2_DOC=SD2.D2_DOC AND "
			cQuery += "SF2.F2_CLIENTE=SD2.D2_CLIENTE AND "
			cQuery += "SF2.F2_LOJA=SD2.D2_LOJA AND "
			If ( !Empty(cRegiao) )
				If cPaisLoc == "BRA"
					cQuery += "SF2.F2_REGIAO='"+cRegiao+"' AND "
				Else
					cQuery += "EXISTS ( SELECT A1_REGIAO FROM " + RetSqlName( "SA1" ) + " SA1 WHERE "
					cQuery += "SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND "
					cQuery += "SA1.A1_REGIAO='" + cRegiao + "' AND "
					cQuery += "SA1.D_E_L_E_T_<>'*') AND "
				EndIf                                                                            
			Endif
			cQuery += "SF2.D_E_L_E_T_<>'*' AND "
		   	//?????????????????????????????????????
			//?erifica os Vendedores.                                                 ?
			//?????????????????????????????????????		
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
					cQuery += "GROUP BY F2_MOEDA,D1_DTDIGIT "
				EndIf 
			Else
				If !Empty( nMoeda )
					cQuery += "GROUP BY F2_MOEDA,D1_DTDIGIT,D1_COD "
				Else
					cQuery += "GROUP BY D1_COD "
				EndIf 		
			EndIf
		Endif

		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		If ( nTpMeta == 1 .Or. nTpMeta == 3 )
			TcSetField(cArqQry,"D1_TOTAL","N",18,2)
		ElseIf nTpMeta == 2
			TcSetField(cArqQry,"D1_QUANT","N",18,2)
		Else
			TcSetField(cArqQry,"D1_QUANT"  ,"N",18,2)
			TcSetField(cArqQry,"D1_TOTAL"  ,"N",18,2)			
			TcSetField(cArqQry,"D1_TOTDESC","N",18,2)			
		EndIf                   
		
		If !Empty( nMoeda ) 
			TcSetField(cArqQry,"F2_MOEDA"  ,"N",2,0)         
			TcSetField(cArqQry,"D1_DTDIGIT","D",8,0)						
		EndIf	
		
		While ( !Eof() )
			Do Case
				Case ( nTpMeta == 1 .Or. nTpMeta == 3 )
					xRetorno += If( Empty( nMoeda ), D1_TOTAL, xMoeda( D1_TOTAL, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
				Case nTpMeta == 2
					xRetorno += D1_QUANT
				Case nTpMeta == 4
					xRetorno[ 1 ] += If( Empty( nMoeda ), D1_TOTAL, xMoeda( D1_TOTAL, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
					xRetorno[ 2 ] += D1_QUANT
					xRetorno[ 3 ] += If( Empty( nMoeda ), D1_TOTDESC, xMoeda( D1_TOTDESC, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
				OtherWise
					nX := aScan(xRetorno,{|x| x[1] == D1_COD})
					If nX == 0
						aadd(xRetorno,{D1_COD,0,0,0})
						nX := Len(xRetorno)
					EndIf
					xRetorno[nX][2] += If( Empty( nMoeda ), D1_TOTAL, xMoeda( D1_TOTAL, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
					xRetorno[nX][3] += D1_QUANT
					xRetorno[nX][4] += If( Empty( nMoeda ), D1_TOTDESC, xMoeda( D1_TOTDESC, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
			EndCase
			
			dbSelectArea(cArqQry)
			dbSkip()		
		EndDo
		dbSelectArea(cArqQry)
		dbCloseArea()
		dbSelectArea("SD1")
	Else
#ENDIF        
		//?????????????????????????????????????
		//?ria uma WorkArea Filtrada para melhorar a performace                   ?
		//?????????????????????????????????????
		cArqQry := CriaTrab(,.F.)
		//If ( Select(cArqQry)==0 )
			ChkFile("SD1",.F.,cArqQry)
			dbSelectArea(cArqQry)
			dbSetOrder(6)
			IndRegua(cArqQry,cArqQry,IndexKey(),,"D1_FILIAL=='"+xFilial("SD1")+"'.And.D1_TIPO=='D'")
		//EndIf
		//?????????????????????????????????????
		//?fetua a selecao dos registros                                          ?
		//?????????????????????????????????????
		dbSelectArea(cArqQry)
		cSeek  := xFilial("SD1")+AllTrim(Dtos(dDataIni))
		cComp  := "D1_FILIAL=='"+xFilial("SD1")+"'"
		If ( !Empty(dDataIni) )
			cComp += ".And. Dtos(D1_DTDIGIT)>='"+Dtos(dDataIni)+"'"
		EndIf
		If ( !Empty(dDataFim) )
			cComp += ".And. Dtos(D1_DTDIGIT)<='"+Dtos(dDataFim)+"'"
		EndIf


		MsSeek(cSeek,.T.)
		While ( !Eof() .And. &cComp )
			//?????????????????????????????????????
			//?osiciona Registros.                                                    ?
			//?????????????????????????????????????
			If cTipoDoc == '3' .Or. (cTipoDoc == '1' .And. !IsRemito(1,'SD1->D1_TIPODOC')).Or.;
					(cTipoDoc == '2' .And. IsRemito(1,'SD1->D1_TIPODOC'))
				If !IsRemito(1,"SD1->D1_TIPODOC") .Or. SD1->D1_QTDACLA > 0
					dbSelectArea("SD2")
					dbSetOrder(3)
					If ( (cArqQry)->D1_TIPO=="D" .And. MsSeek(xFilial("SD2")+(cArqQry)->D1_NFORI+(cArqQry)->D1_SERIORI+(cArqQry)->D1_FORNECE+(cArqQry)->D1_LOJA+(cArqQry)->D1_COD+AllTrim((cArqQry)->D1_ITEMORI)) )
						dbSelectArea("SF2")
						dbSetOrder(1)
						MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						dbSelectArea("SF4")
						dbSetOrder(1)
						MsSeek(xFilial("SF4")+SD2->D2_TES)
						cVend := "1"
						lVend := .F.
	
						If ( !Empty(cCodigo) )
					    	For nCntFor := 1 To nCntVend
							
								//?????????????????????????????????????
								//?Pesquisa por todos os vendedores do SF2 no SA3                         ?
								//?????????????????????????????????????
								cCodVend := SF2->(FieldGet(FieldPos("F2_VEND"+cVend)))
							
								If !Empty( cCodVend ) 
									SA3->( dbSetOrder( 1 ) ) 
									If SA3->( MsSeek( xFilial( "SA3" ) + cCodVend ) )   
									
										//?????????????????????????????????????
										//?Verifica se eh o proprio vendedor ou se o vendedor esta                ?
										//?no grupo de vendedores validos                                         ?							
										//?????????????????????????????????????
									    If SA3->A3_COD == cCodigo .Or. !Empty( AScan( aGrupos, { |x| x[1]==SA3->A3_GRPREP } ) )
											lVend := .T. 
										EndIf
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
							If IsRemito(1,(cArqQry)+"->D1_TIPODOC")
								Do Case
									Case ( nTpMeta==1 )
										nVlrAux := ((cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC) * ((cArqQry)->D1_QTDACLA / (cArqQry)->D1_QUANT)
										xRetorno += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
									Case ( nTpMeta==2 )
										xRetorno += (cArqQry)->D1_QTDACLA
									Case ( nTpMeta == 3 )
										nVlrAux := ((cArqQry)->D1_TOTAL+(cArqQry)->D1_DESCON * ((cArqQry)->D1_QTDACLA / (cArqQry)->D1_QUANT))
										xRetorno += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
									Case ( nTpMeta == 4 )
										nVlrAux := ((cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC) * ((cArqQry)->D1_QTDACLA / (cArqQry)->D1_QUANT)
										xRetorno[ 1 ] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
										xRetorno[ 2 ] += (cArqQry)->D1_QTDACLA
										nVlrAux := (cArqQry)->D1_VUNIT * (cArqQry)->D1_QTDACLA
										xRetorno[ 3 ] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
									OtherWise
										nX := aScan(xRetorno,{|x| x[1] == (cArqQry)->D1_COD})
										If nX == 0
											aadd(xRetorno,{(cArqQry)->D1_COD,0,0,0})
											nX := Len(xRetorno)
										EndIf
										nVlrAux := ((cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC * ((cArqQry)->D1_QTDACLA / (cArqQry)->D1_QUANT))
										xRetorno[ nX , 2 ] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
										xRetorno[ nX , 3 ] += (cArqQry)->D1_QTDACLA
										nVlrAux := (cArqQry)->D1_VUNIT * (cArqQry)->D1_QTDACLA
										xRetorno[ nX , 4 ] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
								EndCase
							Else
								Do Case
									Case ( nTpMeta==1 )
										xRetorno += If( Empty( nMoeda ), (cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC,;
												 xMoeda( (cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
									Case ( nTpMeta==2 )
										xRetorno += (cArqQry)->D1_QUANT
									Case ( nTpMeta == 3 )
										xRetorno += If( Empty( nMoeda ), (cArqQry)->D1_TOTAL+(cArqQry)->D1_DESCON,;
												 xMoeda( (cArqQry)->D1_TOTAL+(cArqQry)->D1_DESCON, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
									Case ( nTpMeta == 4 )
										xRetorno[ 1 ] += If( Empty( nMoeda ), (cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC,;
												 xMoeda( (cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
										xRetorno[ 2 ] += (cArqQry)->D1_QUANT
										xRetorno[ 3 ] += If( Empty( nMoeda ), (cArqQry)->D1_TOTAL,;
											 xMoeda( (cArqQry)->D1_TOTAL, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
									OtherWise
										nX := aScan(xRetorno,{|x| x[1] == (cArqQry)->D1_COD})
										If nX == 0
											aadd(xRetorno,{(cArqQry)->D1_COD,0,0,0})
											nX := Len(xRetorno)
										EndIf
										xRetorno[ nX , 2 ] += If( Empty( nMoeda ), (cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC,;
												 xMoeda( (cArqQry)->D1_TOTAL-(cArqQry)->D1_VALDESC, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
										xRetorno[ nX , 3 ] += (cArqQry)->D1_QUANT
										xRetorno[ nX , 4 ] += If( Empty( nMoeda ), (cArqQry)->D1_TOTAL,;
											 xMoeda( (cArqQry)->D1_TOTAL, SF2->F2_MOEDA, nMoeda, (cArqQry)->D1_DTDIGIT ) )
								EndCase
							Endif
						EndIf
					Endif
				Endif
			EndIf
			dbSelectArea(cArqQry)
			dbSkip()
		EndDo
		dbSelectArea(cArqQry)
		dbCloseArea()
		FErase(cArqQry+OrdBagExt())
		dbSelectArea("SD1")
#IFDEF TOP
	EndIf
#ENDIF
RestArea(aAreaSD1)
RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aAreaSF4)
RestArea(aAreaSA3)
RestArea(aArea)
Return(xRetorno)
/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?tNfDesc  ?Autor ?duardo Riera          ?Data ?2.12.2000 ??
???????????????????????????????????????
??         ?alcula o valor dos descontos com base nas notas fiscais de  ??
??         ?aida.                                                       ??
???????????????????????????????????????
??arametros?xpC1: cCodigo                                               ??
??         ?xpD2: Data de Inicio                                        ??
??         ?xpD3: Data de Termino                                       ??
??         ?xpC4: Regiao de Vendas.                                     ??
??         ?xpC5: Tipo de Produto                                       ??
??         ?xpC6: Grupo de Produto                                      ??
??         ?xpC7: Codigo do Produto                                     ??
???????????????????????????????????????
??etorno   ?xpN1: Valor do desconto                                     ??
???????????????????????????????????????
??escri?o ?alcula o Valor dos Descontos com base nas notas fiscais de  ??
??         ?aida.                                                       ??
???????????????????????????????????????
??so       ?ateriais                                                    ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function FtNfDesc(cCodigo,dDataIni,dDataFim,cRegiao,cTipo,cGrupo,cProduto)

Local aArea   := GetArea()
Local aAreaSA3:= SA3->(GetArea())
Local aAreaSF4:= SF4->(GetArea())
Local aAreaSD2:= SD2->(GetArea())
Local aAreaSF2:= SF2->(GetArea())
Local cQuery  := ""
Local cArqQry := "FtNfDesc"
Local cSeek   := ""
Local cComp   := ""
Local cVend   := ""
Local cIn     := ""
Local nValor  := 0
Local nCntVend:= Fa440CntVen()
Local nCntFor := 0
Local lVend   := .F.
Local nLoop
Local cRegiaoNF := ""

DEFAULT cCodigo := ""
DEFAULT dDataIni:= dDataBase
DEFAULT dDataFim:= dDataBase
DEFAULT cRegiao := ""
DEFAULT cTipo   := ""
DEFAULT cGrupo  := ""
DEFAULT cProduto:= ""

//?????????????????????????????????????
//?certa o Tamanho da Variaveis                                           ?
//?????????????????????????????????????
cCodigo := PadR(cCodigo,Len(SA3->A3_COD))
cRegiao := PadR(cRegiao,Len(SF2->F2_REGIAO))
cTipo   := PadR(cTipo,Len(SD2->D2_TP))
cGrupo  := PadR(cGrupo,Len(SD2->D2_GRUPO))
cProduto:= PadR(cProduto,Len(SD2->D2_COD))

If !Empty( cCodigo ) 

	#IFNDEF TOP
		//?????????????????????????????????????
		//?Adiciona o proprio representante                                       ?
		//?????????????????????????????????????
		cFilGrupo := "{ || SA3->A3_COD=='" + cCodigo + "'"
	#ENDIF 	
	
	//?????????????????????????????????????
	//?Adiciona os grupos que estao abaixo deste representante                ?
	//?????????????????????????????????????
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
		cQuery := "SELECT SUM(SD2.D2_DESCON) D2_TOTAL "
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
			EndIf                                                                            
		Endif

		cQuery += " NOT "+IsRemito(3,'SF2.F2_TIPODOC')+" AND "			
		cQuery += "SF2.D_E_L_E_T_<>'*' AND "
		
	   	//?????????????????????????????????????
		//?erifica os Vendedores.                                                 ?
		//?????????????????????????????????????		
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
		cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
		cQuery += "SF4.F4_CODIGO=SD2.D2_TES AND "
		cQuery += "SF4.F4_DUPLIC='S' AND "
		cQuery += "SF4.F4_ESTOQUE='S' AND "		
		cQuery += "SF4.D_E_L_E_T_<>'*' "
			
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		TcSetField(cArqQry,"D2_TOTAL","N",18,2)
	
		While ( !Eof() )
			nValor += D2_TOTAL
			dbSelectArea(cArqQry)
			dbSkip()		
		EndDo
		dbSelectArea(cArqQry)
		dbCloseArea()
		dbSelectArea("SD2")
	Else
#ENDIF 
		
		//?????????????????????????????????????
		//?fetua a selecao dos registros                                          ?
		//?????????????????????????????????????
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
			//?????????????????????????????????????
			//?osiciona Registros.                                                    ?
			//?????????????????????????????????????
			dbSelectArea("SF2")
			dbSetOrder(1)
			MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
			If !IsRemito(1,'SF2->F2_TIPODOC')
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(xFilial("SF4")+SD2->D2_TES)
				cVend := "1"
				lVend := .F.
		    	//?????????????????????????????????????
				//?erifica os Vendedores.                                                 ?
				//?????????????????????????????????????
				
				If ( !Empty(cCodigo) )
			    	For nCntFor := 1 To nCntVend
			    	
				    	//?????????????????????????????????????
						//?Pesquisa por todos os vendedores do SF2 no SA3                         ?
						//?????????????????????????????????????
						cCodVend := SF2->(FieldGet(FieldPos("F2_VEND"+cVend)))
						
						If !Empty( cCodVend )
							SA3->( dbSetOrder( 1 ) )
							If SA3->( MsSeek( xFilial( "SA3" ) + cCodVend ) )   
						    	//?????????????????????????????????????
								//?Verifica se eh o proprio vendedor ou se o vendedor esta                ?
								//?no grupo de vendedores validos                                         ?						
								//?????????????????????????????????????
							    If SA3->A3_COD == cCodigo .Or. !Empty( AScan( aGrupos,{ |x| x[1]==SA3->A3_GRPREP } ) )
									lVend := .T. 
								EndIf
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
						cRegiaoNF := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_REGIAO")
					Endif
				Endif
				If ((Empty(cRegiao).Or.cRegiao==cRegiaoNF).And.;
					( lVend .And. SF2->F2_TIPO=='N') .And.;
					(Empty(cTipo).Or.cTipo==SD2->D2_TP).And.;
					(Empty(cGrupo).Or.cGrupo==SD2->D2_GRUPO).And.;
					(Empty(cProduto).Or.cProduto==SD2->D2_COD).And.;
					(SF4->F4_DUPLIC=="S".And.SF4->F4_ESTOQUE=="S") )
	
					nValor+= SD2->D2_DESCON
				EndIf
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
Return(nValor)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AjustaSX1 ∫Autor  ≥William P. ALves     ∫ Data ≥ 07/06/2013 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Ajusta grupo de perguntas                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       |METL900                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function AjustaSX1(cPerg)    
Local aArea := GetArea()

PutSX1(cPerg,"01","Data de emissao de ?          ","Data de emissao de ?          ","Data de emissao de ?          ","mv_ch1","D",8,0,0,"G"," "," "," "," ","mv_par01"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"02","Data de emissao ate ?         ","Data de emissao ate ?         ","Data de emissao ate ?         ","mv_ch2","D",8,0,0,"G"," "," "," "," ","mv_par02"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"03","Regiao de ?                   ","Regiao de ?                   ","Regiao de ?                   ","mv_ch3","C",3,0,0,"G"," "," "," "," ","mv_par03"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"04","Regiao ate ?                  ","Regiao ate ?                  ","Regiao ate ?                  ","mv_ch4","C",3,0,0,"G"," "," "," "," ","mv_par04"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"05","Tipo de ?                     ","Tipo de ?                     ","Tipo de ?                     ","mv_ch5","C",2,0,0,"G"," ","02"," "," ","mv_par05"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"06","Tipo Ate ?                    ","Tipo Ate ?                    ","Tipo Ate ?                    ","mv_ch6","C",2,0,0,"G"," ","02"," "," ","mv_par06"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"07","Grupo de ?                    ","Grupo de ?                    ","Grupo de ?                    ","mv_ch7","C",4,0,0,"G"," ","SBM"," "," ","mv_par07"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"08","Grupo Ate ?                   ","Grupo Ate ?                   ","Grupo Ate ?                   ","mv_ch8","C",4,0,0,"G"," ","SBM"," "," ","mv_par08"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"09","Considera devolucao ?         ","Considera devolucao ?         ","Considera devolucao ?         ","mv_ch9","N",1,0,0,"C"," "," "," "," ","mv_par09","Sim","Sim","Sim"," ","Nao","Nao","Nao"," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"10","Data tabela de ?              ","Data tabela de ?              ","Data tabela de ?              ","mv_chA","D",8,0,0,"G"," "," "," "," ","mv_par10"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"11","Data tabela Ate ?             ","Data tabela Ate ?             ","Data tabela Ate ?             ","mv_chB","D",8,0,0,"G"," "," "," "," ","mv_par11"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"12","Moeda base ?                  ","Moeda base ?                  ","Moeda base ?                  ","mv_chC","N",2,0,0,"G"," "," "," "," ","mv_par12"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"13","TES Qto Faturamento ?         ","TES Qto Faturamento ?         ","TES Qto Faturamento ?         ","mv_chD","N",1,0,0,"C"," "," "," "," ","mv_par13","Gera financeiro","Gera financeiro","Gera financeiro"," ","Nao Gera Financ","Nao Gera Financ","Nao Gera Financ"," ","Considera Ambos","Considera Ambos","Considera Ambos"," "," "," "," "," ","","","") 
PutSX1(cPerg,"14","TES Qto Estoque ?             ","TES Qto Estoque ?             ","TES Qto Estoque ?             ","mv_chE","N",1,0,0,"C"," "," "," "," ","mv_par14","Atualiza       ","Atualiza       ","Atualiza       "," ","Nao Atualiza   ","Nao Atualiza   ","Nao Atualiza   "," ","Considera Ambos","Considera Ambos","Considera Ambos"," "," "," "," "," ","","","") 
PutSX1(cPerg,"15","Comparacao Meta ?             ","Comparacao Meta ?             ","Comparacao Meta ?             ","mv_chF","N",1,0,0,"C"," "," "," "," ","mv_par15","Notas Fiscais","Notas Fiscais","Notas Fiscais"," ","Pedidos","Pedidos","Pedidos"," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"16","Serie de ?"                    ,"Serie de ?"                    ,"Serie de ?"                    ,"mv_chG","C",3,0,0,"G"," "," "," "," ","mv_par16"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
PutSX1(cPerg,"17","Serie Ate ?"                   ,"Serie Ate ?"                   ,"Serie Ate ?"                   ,"mv_chH","C",3,0,0,"G"," "," "," "," ","mv_par17"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 

RestArea(aArea)
Return()
