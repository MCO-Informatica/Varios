#INCLUDE "FATR010.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

User Function uFatr010()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	FATR010R3()
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Eduardo Riera          ³ Data ³25.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oOportunidade
Local oConcorrentes
Local oParceiros
Local oTime
Local oContatos
Local oEvolucaoVenda
Local oProdutos
Local nTamProd  := TamSX3("AD1_CODPRO")[1]

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
oReport := TReport():New("UFATR010",STR0001,"FTR010", {|oReport| ReportPrint(oReport)},STR0020) //"Relacao de Oportunidades"###"Este relatorio ira imprimir a relacao de oportunidades de venda conforme os parametros solicitados"
oReport:SetLandscape()
oReport:SetTotalInLine(.T.)
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

If ( AliasInDic("AIJ") .AND. AIJ->(FieldPos("AIJ_NROPOR")) > 0 )
	oOportunidade := TRSection():New(oReport,STR0021,{"AD1","SA3","SUS","AC1","AC2","AIJ","ADJ","SB1"},{STR0004,STR0005,STR0006,STR0007,STR0008,STR0031,"Prod. Oport.","Produtos"},/*Campos do SX3*/,/*Campos do SIX*/,,,,,,,,,,.T.) //"Oportunidade de Venda"###"Oportunidades"###"Prospects"###"Produtos"###"Representantes"###"Processo de Venda"###"Evolução da Venda"
Else
	oOportunidade := TRSection():New(oReport,STR0021,{"AD1","SA3","SUS","AC1","AC2","ADJ","SB1"},{STR0004,STR0005,STR0006,STR0007,STR0008,"Prod. Oport.","Produtos"},/*Campos do SX3*/,/*Campos do SIX*/,,,,,,,,,,.T.) //"Oportunidade de Venda"###"Oportunidades"###"Prospects"###"Produtos"###"Representantes"###"Processo de Venda"
EndIf


oOportunidade:SetTotalInLine(.F.)

TRCell():New(oOportunidade,"AD1_NROPOR","AD1",STR0022	   ,/*Picture*/,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/) //"Codigo"
TRCell():New(oOportunidade,"AD1_REVISA","AD1",STR0023	   ,/*Picture*/,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/) //"Rev"
TRCell():New(oOportunidade,"AD1_DESCRI","AD1",/*Titulo*/,/*Picture*/,20 /*Tamanho*/		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AD1_VEND"  ,"AD1",/*Titulo*/,/*Picture*/,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"A3_NOME"   ,"SA3",/*Titulo*/,/*Picture*/,20 /*Tamanho*/		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"US_COD"    ,"SUS",/*Titulo*/,/*Picture*/,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"US_LOJA"   ,"SUS",/*Titulo*/,/*Picture*/,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"US_NOME"   ,"SUS",/*Titulo*/,/*Picture*/,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AD1_PROVEN","AD1",/*Titulo*/,/*Picture*/,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AC1_DESCRI","AC1",/*Titulo*/,/*Picture*/,15/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AD1_STAGE" ,"AD1",/*Titulo*/,/*Picture*/,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AC2_DESCRI","AC2",/*Titulo*/,/*Picture*/,/*Tamanho*/ 			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AD1_VERBA" ,"AD1",/*Titulo*/,/*Picture*/,/*Tamanho*/  			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AD1_MOEDA" ,"AD1",/*Titulo*/,/*Picture*/,/*Tamanho*/ 			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AD1_CODPRO","AD1",/*Titulo*/,/*Picture*/,TamSx3("AD1_CODPRO")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AD1_STATUS","AD1",/*Titulo*/,/*Picture*/,/*Tamanho*/  			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOportunidade,"AD1_DATA","AD1",/*Titulo*/,/*Picture*/,/*Tamanho*/  			,/*lPixel*/,/*{|| code-block de impressao }*/)


TRFunction():New(oOportunidade:Cell("AD1_VERBA"),/* cID */,"SUM",/*oBreak*/,STR0024,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/) //"Total / Verba"
TRFunction():New(oOportunidade:Cell("AD1_NROPOR"),/* cID */,"COUNT",/*oBreak*/,STR0025,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/) //"Total / Oportunidade"

oConcorrentes := TRSection():New(oOportunidade,STR0026,{"AD3","AC3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Concorrentes"
oConcorrentes:SetTotalInLine(.F.)
TRCell():New(oConcorrentes,"AD3_CODCON","AD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConcorrentes,"AC3_NOME"  ,"AC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oParceiros := TRSection():New(oOportunidade,STR0027,{"AD4","AC4"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Parceiros"
oParceiros:SetTotalInLine(.F.)
TRCell():New(oParceiros,"AD4_PARTNE","AD4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oParceiros,"AC4_NOME"  ,"AC4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oTime := TRSection():New(oOportunidade,STR0028,{"AD2","SA3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Time de Vendas"
oTime:SetTotalInLine(.F.)
TRCell():New(oTime,"AD2_VEND" ,"AD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTime,"A3_NOME"  ,"SA3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oContatos := TRSection():New(oOportunidade,STR0029,{"AD9","SU5"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Contatos"
oContatos:SetTotalInLine(.F.)
TRCell():New(oContatos,"AD9_CODCON" ,"AD9",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oContatos,"U5_CONTAT"  ,"SU5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

If ( AliasInDic("AIJ") .AND. AIJ->(FieldPos("AIJ_NROPOR")) > 0 )
	oEvolucaoVenda := TRSection():New(oOportunidade,STR0031,{"AIJ"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Evolução da Venda"
	oEvolucaoVenda:SetTotalInLine(.F.)
	TRCell():New(oEvolucaoVenda,"AIJ_PROVEN","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oEvolucaoVenda,"AIJ_STAGE","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oEvolucaoVenda,"AIJ_DTINIC","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oEvolucaoVenda,"AIJ_HRINIC","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oEvolucaoVenda,"AIJ_DTLIMI","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oEvolucaoVenda,"AIJ_HRLIMI","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oEvolucaoVenda,"AIJ_DTENCE","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oEvolucaoVenda,"AIJ_HRENCE","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oEvolucaoVenda,"AIJ_DUREST","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,;
	{|| TKCalcPer(AIJ_DTINIC,AIJ_HRINIC,IIF(!Empty(AIJ_DTENCE),AIJ_DTENCE,dDataBase),IIF(!Empty(AIJ_HRENCE),AIJ_HRENCE,SubStr(Time(),1,5))) })
	TRCell():New(oEvolucaoVenda,"AIJ_STATUS","AIJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| FTR10AIJSt(AIJ_PROVEN, AIJ_STAGE, AIJ_DTINIC, AIJ_HRINIC, AIJ_STATUS)  })
EndIf

oProdutos := TRSection():New(oOportunidade,"Produtos",{"ADJ","SB1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oProdutos:SetTotalInLine(.F.)
TRCell():New(oProdutos,"ADJ_NROPOR"	,"ADJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProdutos,"ADJ_REVISA"	,"ADJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProdutos,"ADJ_ITEM" 	,"ADJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProdutos,"ADJ_PROD" 	,"ADJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProdutos,"B1_DESC"  	,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProdutos,"ADJ_QUANT"	,"ADJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProdutos,"ADJ_PRUNIT"	,"ADJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProdutos,"ADJ_VALOR"	,"ADJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oProdutos:Cell("ADJ_VALOR"),/* cID */,"SUM",/*oBreak*/,"Total Produtos",/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/) //"Total / Verba"

// Totais por Moeda

If ( AliasInDic("AIJ") .AND. AIJ->(FieldPos("AIJ_NROPOR")) > 0 )
	oTotMoeda := TRSection():New(oReport,STR0021,{"AD1","SA3","SUS","AC1","AC2","AIJ"},{STR0004,STR0005,STR0006,STR0007,STR0008,STR0031},/*Campos do SX3*/,/*Campos do SIX*/,,,,,,,,,,.T.) //"Oportunidade de Venda"###"Oportunidades"###"Prospects"###"Produtos"###"Representantes"###"Processo de Venda"##"Evolução da Venda"
Else
	oTotMoeda := TRSection():New(oReport,STR0021,{"AD1","SA3","SUS","AC1","AC2"},{STR0004,STR0005,STR0006,STR0007,STR0008},/*Campos do SX3*/,/*Campos do SIX*/,,,,,,,,,,.T.) //"Oportunidade de Venda"###"Oportunidades"###"Prospects"###"Produtos"###"Representantes"###"Processo de Venda"
EndIf

TRCell():New(oTotMoeda,"AD1_MOEDA" ,"AD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTotMoeda,"AD1_VERBA" ,"AD1",STR0024,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oTotMoeda:SetLineStyle(.T.)
oTotMoeda:SetEdit(.F.)
If nTamProd >=25
	oOportunidade:SetLineBreak(.T.)  /*Quebra automatica de linha*/
EndIf

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
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local cAliasAD1M 	:= "AD1"
Local cAliasAD1  	:= "AD1"
Local cAliasAD2  	:= "AD2"
Local cAliasAD3  	:= "AD3"
Local cAliasAD4 	:= "AD4"
Local cAliasAD9 	:= "AD9"
Local cAliasAIJ  	:= "AIJ"
Local cAliasADJ		:= "ADJ"
Local cWhereA    	:= ""
Local cWhereB    	:= ""
Local cWhere    	:= ""
Local lQuery    	:= .F.
Local aIndexKey 	:= {}
Local bMais     	:= { || .T. }
Local bMenos     	:= { || .T. }
Local aMoeda 	 	:= {0,0,0,0,0}
Local nI		  	:= 0
Local cNomeMoeda	:= ""
Local cIndice		:= ""
Local nSection		:= 0

#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

AAdd( aIndexKey, "AD1_NROPOR" )
AAdd( aIndexKey, "AD1_PROSPE,AD1_LOJPRO" )
AAdd( aIndexKey, "AD1_CODPRO" )
AAdd( aIndexKey, "AD1_VEND" )
AAdd( aIndexKey, "AD1_PROVEN,AD1_STAGE" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR19 == 1
	bMais    := { || .T. }
	cWhereA  += ""
Else
	If MV_PAR19 <> 5
		bMais    := { || AD1->AD1_STATUS == Str( MV_PAR19 - 1, 1 ) }
		cWhereA := "AD1_STATUS='" + Str( MV_PAR19 - 1, 1 ) + "' AND "
	Else
		cWhereA := "AD1_STATUS='9' AND "
	EndIf
EndIf

If MV_PAR20 == 1
	bMenos  := { || .T. }
	cWhereB := ""
Else
	If MV_PAR20 <> 5
		bMenos    := { || AD1->AD1_STATUS<>Str( MV_PAR20 - 1, 1 ) }
		cWhereB   := "AD1_STATUS<>'" + Str( MV_PAR20 - 1, 1 ) + "' AND "
	Else
		bMenos    := { || AD1->AD1_STATUS<>"9" }
		cWhereB   := "AD1_STATUS<>'9' AND "
	EndIf
EndIf
cWhere := "%"+cWhereA+cWhereB+"%"

#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cIndice := (aIndexKey[oReport:Section(1):nOrder])
	cIndice := '%'+ cIndice + '%'

	lQuery := .T.
	cAliasAD1 := GetNextAlias()
	oReport:Section(1):BeginQuery()
	BeginSql Alias cAliasAD1
		SELECT AD1.*
		FROM %Table:AD1% AD1
		WHERE
		AD1_FILIAL=%xFilial:AD1% AND
		AD1_PROSPE>=%exp:MV_PAR01% AND
		AD1_PROSPE<=%exp:MV_PAR03% AND
		AD1_LOJPRO>=%exp:MV_PAR02% AND
		AD1_LOJPRO<=%exp:MV_PAR04% AND
		AD1_VEND  >=%exp:MV_PAR05% AND
		AD1_VEND  <=%exp:MV_PAR06% AND
		AD1_DTINI >=%exp:DToS(MV_PAR07)% AND
		AD1_DTFIM <=%exp:DToS(MV_PAR08)% AND
		AD1_PROVEN>=%exp:MV_PAR09% AND
		AD1_PROVEN<=%exp:MV_PAR11% AND
		AD1_STAGE >=%exp:MV_PAR10% AND
		AD1_STAGE <=%exp:MV_PAR12% AND
		AD1_CODPRO>=%exp:MV_PAR13% AND
		AD1_CODPRO<=%exp:MV_PAR14% AND
		AD1.%NotDel%
		ORDER BY %exp:cIndice%
		EndSql

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1.1                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuery := .T.
	cAliasAD3 := GetNextAlias()
	AD3->(dbSetOrder(1))
	BEGIN REPORT QUERY oReport:Section(1):Section(1)
	BeginSql Alias cAliasAD3
		SELECT AD3_CODCON, AC3_NOME
		FROM %table:AD3% AD3,%table:AC3% AC3
		WHERE
		AD3_FILIAL=%xFilial:AD3% AND
		AD3_NROPOR=%report_param: (cAliasAD1)->AD1_NROPOR% AND
		AD3_REVISA=%report_param: (cAliasAD1)->AD1_REVISA% AND
		AD3.%NotDel% AND
		AC3_FILIAL=%xFilial:AC3% AND
		AD3_CODCON=AC3_CODCON AND
		AC3.%NotDel%
		ORDER BY %ORDER:AD3%
	EndSql
	END REPORT QUERY oReport:Section(1):Section(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1.2                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuery := .T.
	cAliasAD4 := GetNextAlias()
	AD4->(dbSetOrder(1))
	BEGIN REPORT QUERY  oReport:Section(1):Section(2)
	BeginSql Alias cAliasAD4
		SELECT AD4_PARTNE, AC4_NOME
		FROM %table:AD4% AD4,
			%table:AC4% AC4
		WHERE
		AD4_FILIAL=%xFilial:AD4%  AND
		AD4_NROPOR=%report_param: (cAliasAD1)->AD1_NROPOR% AND
		AD4_REVISA=%report_param: (cAliasAD1)->AD1_REVISA% AND
		AD4.%NotDel% AND
		AC4_FILIAL=%xFilial:AC4% AND
		AD4_PARTNE=AC4_PARTNE AND
		AC4.%NotDel%
		ORDER BY %ORDER:AD4%
	EndSql
	END REPORT QUERY oReport:Section(1):Section(2)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1.3                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuery := .T.
	cAliasAD2 := GetNextAlias()
	AD2->(dbSetOrder(1))
	BEGIN REPORT QUERY  oReport:Section(1):Section(3)
	BeginSql Alias cAliasAD2
		SELECT AD2_VEND, A3_NOME
		FROM %Table:AD2% AD2,
			%Table:SA3% SA3
		WHERE
		AD2_FILIAL=%xFilial:AD2% AND
		AD2_NROPOR=%report_param: (cAliasAD1)->AD1_NROPOR% AND
		AD2_REVISA=%report_param: (cAliasAD1)->AD1_REVISA% AND
		AD2.%NotDel% AND
		A3_FILIAL=%xFilial:SA3% AND
		AD2_VEND=A3_COD AND
		SA3.%NotDel%
		ORDER BY %ORDER:AD2%
	EndSql
	END REPORT QUERY oReport:Section(1):Section(3)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1.4                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuery := .T.
	cAliasAD9 := GetNextAlias()
	AD9->(dbSetOrder(1))
	BEGIN REPORT QUERY oReport:Section(1):Section(4)
	BeginSql Alias cAliasAD9
		SELECT AD9_CODCON, U5_CONTAT
		FROM %Table:AD9% AD9,
			%Table:SU5% SU5
		WHERE
		AD9_FILIAL=%xFilial:AD9% AND
		AD9_NROPOR=%report_param: (cAliasAD1)->AD1_NROPOR% AND
		AD9_REVISA=%report_param: (cAliasAD1)->AD1_REVISA% AND
		AD9.%NotDel% AND
		U5_FILIAL=%xFilial:SU5% AND
		AD9_CODCON=U5_CODCONT AND
		SU5.%NotDel%
		ORDER BY %ORDER:AD9%
	EndSql
	END REPORT QUERY oReport:Section(1):Section(4)

	nSection := 5

	If ( AliasInDic("AIJ") .AND. AIJ->(FieldPos("AIJ_NROPOR")) > 0 )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query do relatório da secao 1.5                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lQuery := .T.
		cAliasAIJ := GetNextAlias()
		AIJ->(dbSetOrder(1))
		BEGIN REPORT QUERY oReport:Section(1):Section(nSection)
		BeginSql Alias cAliasAIJ
			SELECT AIJ.*
			FROM %Table:AIJ% AIJ
			WHERE
			AIJ_FILIAL=%report_param:(cAliasAD1)->AD1_FILIAL% AND
			AIJ_NROPOR=%report_param:(cAliasAD1)->AD1_NROPOR% AND
			AIJ_REVISA=%report_param:(cAliasAD1)->AD1_REVISA% AND
			AIJ.%NotDel%
			ORDER BY %ORDER:AIJ%
		EndSql
		END REPORT QUERY oReport:Section(1):Section(nSection)
		nSection++
	EndIf

	lQuery := .T.
	cAliasADJ := GetNextAlias()
	ADJ->(dbSetOrder(1))
	BEGIN REPORT QUERY oReport:Section(1):Section(nSection)
	BeginSql Alias cAliasADJ
		SELECT
			ADJ_ITEM,
	       	ADJ_PROD,
	       	B1_DESC,
	       	ADJ_VALOR,
	       	ADJ_QUANT,
	       	ADJ_PRUNIT,
	       	ADJ_NROPOR,
	       	ADJ_REVISA
		FROM
			%Table:ADJ% ADJ INNER JOIN %Table:SB1% SB1 ON
				ADJ_FILIAL = B1_FILIAL AND
				ADJ_PROD = B1_COD AND
				ADJ.%NotDel% AND
				SB1.%NotDel%
		WHERE
			ADJ_FILIAL =%report_param:(cAliasAD1)->AD1_FILIAL% AND
			ADJ_NROPOR =%report_param:(cAliasAD1)->AD1_NROPOR% AND
			ADJ_REVISA =%report_param:(cAliasAD1)->AD1_REVISA%
		ORDER BY
			%ORDER:ADJ%
	EndSql
	END REPORT QUERY oReport:Section(1):Section(nSection)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 2 (totais por moeda)                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuery := .T.
	cAliasAD1M := GetNextAlias()
	oReport:Section(2):BeginQuery()
	BeginSql Alias cAliasAD1M
		SELECT AD1_MOEDA, SUM(AD1_VERBA) AD1_VERBA
		FROM %Table:AD1% AD1
		WHERE
		AD1_FILIAL=%xFilial:AD1% AND
		AD1_PROSPE>=%exp:MV_PAR01% AND
		AD1_PROSPE<=%exp:MV_PAR03% AND
		AD1_LOJPRO>=%exp:MV_PAR02% AND
		AD1_LOJPRO<=%exp:MV_PAR04% AND
		AD1_VEND  >=%exp:MV_PAR05% AND
		AD1_VEND  <=%exp:MV_PAR06% AND
		AD1_DTINI >=%exp:DToS(MV_PAR07)% AND
		AD1_DTFIM <=%exp:DToS(MV_PAR08)% AND
		AD1_PROVEN>=%exp:MV_PAR09% AND
		AD1_PROVEN<=%exp:MV_PAR11% AND
		AD1_STAGE >=%exp:MV_PAR10% AND
		AD1_STAGE <=%exp:MV_PAR12% AND
		AD1_CODPRO>=%exp:MV_PAR13% AND
		AD1_CODPRO<=%exp:MV_PAR14% AND
		AD1.%NotDel%
		GROUP BY AD1_MOEDA
	EndSql
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)

#ELSE
	dbSelectArea(cAliasAD1)
	dbSetOrder(1)

	cCondicao := ""
	cCondicao += "AD1_FILIAL=='"  + xFilial( 'AD1' ) + "'.And."
	cCondicao += "AD1_PROSPE>='"  + MV_PAR01 + "'.And."
	cCondicao += "AD1_LOJPRO>='"  + MV_PAR02 + "'.And."
	cCondicao += "AD1_PROSPE<='"  + MV_PAR03 + "'.And."
	cCondicao += "AD1_LOJPRO<='"  + MV_PAR04 + "'.And."
	cCondicao += "AD1_VEND>='"    + MV_PAR05 + "'.And."
	cCondicao += "AD1_VEND<='"    + MV_PAR06 + "'.And."
	cCondicao += "DToS(AD1_DTINI)>='" + DToS( MV_PAR07 ) + "'.And."
	cCondicao += "DToS(AD1_DTFIM)<='" + DToS( MV_PAR08 ) + "'.And."
	cCondicao += "AD1_PROVEN>='" + MV_PAR09 + "'.And."
	cCondicao += "AD1_STAGE >='" + MV_PAR10 + "'.And."
	cCondicao += "AD1_PROVEN<='" + MV_PAR11 + "'.And."
	cCondicao += "AD1_STAGE <='" + MV_PAR12 + "'.And."
	cCondicao += "AD1_CODPRO>='" + MV_PAR13 + "' .And."
	cCondicao += "AD1_CODPRO<='" + MV_PAR14 + "' "

	oReport:Section(1):SetFilter(cCondicao,aIndexKey[ oReport:Section(1):nOrder ])
	oReport:Section(1):SetLineCondition({|| dbSelectArea("SB1"),;
		dbSetOrder(1),;
		SB1->( MsSeek( xFilial( "SB1" ) + ( cAliasAD1 )->AD1_CODPRO ) ) ,;
		Eval(bMenos) .And. Eval(bMais) .And. SB1->B1_TIPO >= MV_PAR15 .And. SB1->B1_TIPO <= MV_PAR16 .And.;
					SB1->B1_GRUPO >= MV_PAR17 .And. SB1->B1_GRUPO <= MV_PAR18})

	oReport:Section(1):Section(1):SetRelation({|| xFilial( "AD3" ) + (cAliasAD1)->AD1_NROPOR + (cAliasAD1)->AD1_REVISA },"AD3",1,.T.)
	oReport:Section(1):Section(1):SetParentFilter({|| xFilial( "AD3" ) == AD3->AD3_FILIAL .And. (cAliasAD1)->AD1_NROPOR == AD3->AD3_NROPOR .And.  (cAliasAD1)->AD1_REVISA == AD3->AD3_REVISA})
	TRPosition():New(oReport:Section(1):Section(1),"AC3",1,{|| xFilial( "AC3" ) + AD3->AD3_CODCON })

	oReport:Section(1):Section(2):SetRelation({|| xFilial( "AD4" ) + (cAliasAD1)->AD1_NROPOR + (cAliasAD1)->AD1_REVISA },"AD4",1,.T.)
	oReport:Section(1):Section(2):SetParentFilter({|| xFilial( "AD4" ) == AD4->AD4_FILIAL .And. (cAliasAD1)->AD1_NROPOR == AD4->AD4_NROPOR .And.  (cAliasAD1)->AD1_REVISA == AD4->AD4_REVISA})
	TRPosition():New(oReport:Section(1):Section(2),"AC4",1,{|| xFilial( "AC4" ) + AD4->AD4_PARTNE })

	oReport:Section(1):Section(3):SetRelation({|| xFilial( "AD2" ) + (cAliasAD1)->AD1_NROPOR + (cAliasAD1)->AD1_REVISA },"AD2",1,.T.)
	oReport:Section(1):Section(3):SetParentFilter({|| xFilial( "AD2" ) == AD2->AD2_FILIAL .And. (cAliasAD1)->AD1_NROPOR == AD2->AD2_NROPOR .And.  (cAliasAD1)->AD1_REVISA == AD2->AD2_REVISA})
	TRPosition():New(oReport:Section(1):Section(3),"SA3",1,{|| xFilial( "SA3" ) + AD2->AD2_VEND })

	oReport:Section(1):Section(4):SetRelation({|| xFilial( "AD9" ) + (cAliasAD1)->AD1_NROPOR + (cAliasAD1)->AD1_REVISA },"AD9",1,.T.)
	oReport:Section(1):Section(4):SetParentFilter({|| xFilial( "AD9" ) == AD9->AD9_FILIAL .And. (cAliasAD1)->AD1_NROPOR == AD9->AD9_NROPOR .And.  (cAliasAD1)->AD1_REVISA == AD9->AD9_REVISA})
	TRPosition():New(oReport:Section(1):Section(4),"SU5",1,{|| xFilial( "SU5" ) + AD9->AD9_CODCON })

	If ( AliasInDic("AIJ") .AND. AIJ->(FieldPos("AIJ_NROPOR")) > 0 )
		oReport:Section(1):Section(5):SetRelation({|| (cAliasAD1)->AD1_FILIAL + (cAliasAD1)->AD1_NROPOR + (cAliasAD1)->AD1_REVISA },"AIJ",1,.T.)
   		oReport:Section(1):Section(5):SetParentFilter({|| (cAliasAD1)->AD1_FILIAL == AIJ->AIJ_FILIAL .And. (cAliasAD1)->AD1_NROPOR == AIJ->AIJ_NROPOR .And.  (cAliasAD1)->AD1_REVISA == AIJ->AIJ_REVISA})
	EndIf

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
TRPosition():New(oReport:Section(1),"SA3",1,{|| xFilial( "SA3" ) + ( cAliasAD1 )->AD1_VEND })
TRPosition():New(oReport:Section(1),"SUS",1,{|| xFilial( "SUS" ) + ( cAliasAD1 )->AD1_PROSPE })
TRPosition():New(oReport:Section(1),"AC1",1,{|| xFilial( "AC1" ) + ( cAliasAD1 )->AD1_PROVEN })
TRPosition():New(oReport:Section(1),"AC2",1,{|| xFilial( "AC2" ) + ( cAliasAD1 )->AD1_PROVEN + ( cAliasAD1 )->AD1_STAGE })
oReport:Section(1):Cell("AD1_VERBA" ):SetBlock({|| xMoeda( (cAliasAD1)->AD1_VERBA, (cAliasAD1)->AD1_MOEDA, MV_PAR22, dDataBase ) })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR21 <> 1
	oReport:Section(1):Section(1):Hide()
	oReport:Section(1):Section(2):Hide()
	oReport:Section(1):Section(3):Hide()
	oReport:Section(1):Section(4):Hide()
	If ( AliasInDic("AIJ") .AND. AIJ->(FieldPos("AIJ_NROPOR")) > 0 )
		oReport:Section(1):Section(5):Hide()
	EndIf
EndIf
oReport:SetMeter((cAliasAD1)->(LastRec()))

oReport:Section(1):Print()

#IFDEF TOP
	oReport:Section(2):Print()
#ELSE
	aMoeda := {0,0,0,0,0}
   dbSelectArea(cAliasAD1M)
   dbGoTop()
   While !Eof()
   	aMoeda[AD1_MOEDA] += AD1_VERBA
   	dbSkip()
   EndDo
   oReport:PrintText(" ")
   For nI := 1 to Len(aMoeda)
   	If aMoeda[nI] > 0
  			cNomeMoeda := Capital( AllTrim( GetMV( "MV_MOEDA" + AllTrim( Str( nI ) ) ) ) )
		   oReport:PrintText(STR0024 + "( " + STR0030 + AllTrim(Str(nI)) + " " + cNomeMoeda + ")" + Transform( aMoeda[nI], "@E 99,999,999.99"))
		EndIf
	Next

#ENDIF

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FATR010R3³ Autor ³ Sergio Silveira       ³ Data ³27/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Relat¢rio de Oportunidades                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FATR010R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Vari veis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Titulo  := OemToAnsi(STR0001)  //"Relacao de Oportunidades"
Local cDesc1  := OemToAnsi(STR0002 ) //"Este relatorio ira imprimir a relacao de oportunidades"
Local cDesc2  := OemToAnsi(STR0003 )  //"de venda conforme os parametros solicitados"
Local cDesc3  := OemToAnsi("")

Local cString    := "AD1"  // Alias utilizado na Filtragem
Local lDic       := .F.    // Habilita/Desabilita Dicionario
Local lComp      := .T.    // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro    := .T.    // Habilita/Desabilita o Filtro
Local wnrel      := "FATR010"  // Nome do Arquivo utilizado no Spool
Local nomeprog   := "FATR010"  // nome do programa
Local aOrderKey  := {}

Private Tamanho  := "G"  // P/M/G
Private Limite   := 220  // 80/132/220
Private aOrdem   := { STR0004, STR0005, STR0006, STR0007, STR0008 }   // Ordem do Relatorio //"Oportunidades"###"Prospects"###"Produtos"###"Representantes"###"Processo de Venda"
Private cPerg    := "FTR010"  // Pergunta do Relatorio
Private aReturn  := { STR0009, 1,STR0010, 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PARAMETROS                                                             ³
//³ nOrdem : Tipo de Quebra ?                                              ³
//³ MV_PAR01 : Prospect de       ?                                         ³
//³ MV_PAR02 : Loja de           ?                                         ³
//³ MV_PAR03 : Prospect ate      ?                                         ³
//³ MV_PAR04 : Loja ate          ?                                         ³
//³ MV_PAR05 : Representante de  ?                                         ³
//³ MV_PAR06 : Representante ate ?                                         ³
//³ MV_PAR07 : Data de           ?                                         ³
//³ MV_PAR08 : Data de           ?                                         ³
//³ MV_PAR09 : Processo de       ?                                         ³
//³ MV_PAR10 : Etapa de          ?                                         ³
//³ MV_PAR11 : Processo ate      ?                                         ³
//³ MV_PAR12 : Etapa ate         ?                                         ³
//³ MV_PAR13 : Produto de        ?                                         ³
//³ MV_PAR14 : Produto ate       ?                                         ³
//³ MV_PAR15 : Tipo de           ?                                         ³
//³ MV_PAR16 : Tipo Ate          ?                                         ³
//³ MV_PAR17 : Grupo de          ?                                         ³
//³ MV_PAR18 : Grupo Ate         ?                                         ³
//³ MV_PAR19 : Status +          ?                                         ³
//³ MV_PAR20 : Status -          ?                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ ImpDet   ³ Autor ³ Sergio Silveira       ³ Data ³27/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³Faz filtragem de Dados acumulando na  rea de trabalho (TRAB)³±±
±±³          ³e faz o Controle de Fluxo do Relatorio.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpDet(lEnd,wnrel,cString,nomeprog,Titulo)

Local aStruct
Local aIndexKey := {}
Local aTotVerba := {}

Local bCondFil  := { || .T. }
Local bWhile    := { || .T. }
Local bSkip     := { || .T. }
Local bCondAD1  := { || .T. }

//                Codigo  Rev  Descricao                      Representante               Prospect                    Processo de Venda              Estagio                        Verba          Verba Md.Base  Produto        Situacao
//                          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


Local cCabec1    := STR0011 // "Codigo  Rev  Descricao                      Representante               Prospect                    Processo de Venda              Estagio                                    Verba  Verba Md.Base Produto         Situacao   "
Local cCabec2    := ""

Local cTit1      := ""        // Titulo da 1.o Quebra recebe o valor de um campo
Local cTit2      := ""        // Titulo da 2.o Quebra recebe o valor de um campo
Local cTitulo1   := ""        // Titulo descritivo em formato texto
Local cTitulo2   := ""        // Titulo descritivo em formato texto

Local cbCont     := 0         // Numero de Registros Processados
Local cbText     := ""        // Mensagem do Rodape

Local cSeekABD   := ""
Local cArqInd    := ""
Local cIndexKey  := ""
Local cArqTrab   := ""
Local cIndTrab   := ""
Local cMemo      := ""
Local cQuery     := ""
Local cCond      := ""
Local cQryMais   := ""
Local cQryMenos  := ""
Local bMais      := { || .T. }
Local bMenos     := { || .T. }
Local cNomeMoeda := ""
Local cRevisa    := ""

Local dDataAnt   := CtoD("")  // Guarda o valor do campo para comparar com o mesmo apos o skip, verif. se o anterior ‚ igual ao corrente para fazer a quebra

Local lImp       := .F.       // Indica se algo foi impresso
Local lQuery     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VARIAVEIS DE COLUNAS                                                   ³
//³ As variaveis abaixo nCol???, guardam valores das colunas que serÆo     ³
//³ usadas na impressao, pois como tem 4 formas de quebra, a cada forma de ³
//³ um cabecalho diferente as colunas irÆo mudar.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nColCCl    := 0
Local nColNCl    := 0
Local nColFab    := 0
Local nColCPr    := 0
Local nColNpr    := 0
Local nColLoj    := 0
Local nVerbaBase := 0
Local nColDat    := 0
Local nColDbx    := 0
Local nOrdem     := aReturn[ 8 ]
Local nMemCount  := 0
Local nLoop      := 0
Local nTotVerba  := 0
Local nTotOpor   := 0
Local nColDes    := 0

aIndexKey := {}

AAdd( aIndexKey, "AD1_NROPOR" )
AAdd( aIndexKey, "AD1_PROSPE+AD1_LOJPRO" )
AAdd( aIndexKey, "AD1_CODPRO" )
AAdd( aIndexKey, "AD1_VEND" )
AAdd( aIndexKey, "AD1_PROVEN+AD1_STAGE" )

Li := 100

dbSelectArea(cString)
SetRegua(LastRec())
dbSetOrder(1)
dbSeek(xFilial())

aStruct := {}
AAdd( aStruct, { "STATUS" , "C",  1, 0 } )

If MV_PAR19 == 1
	bMais    := { || .T. }
	cQryMais := ""
Else
	If MV_PAR19 <> 5
		bMais    := { || AD1->AD1_STATUS == Str( MV_PAR19 - 1, 1 ) }
		cQryMais := "AD1_STATUS='" + Str( MV_PAR19 - 1, 1 ) + "' AND "
	Else
		cQryMais := "AD1_STATUS='9' AND "
	EndIf
EndIf

If MV_PAR20 == 1
	bMenos    := { || .T. }
	cQryMenos := ""
Else
	If MV_PAR20 <> 5
		bMenos    := { || AD1->AD1_STATUS<>Str( MV_PAR19 - 1, 1 ) }
		cQryMenos := "AD1_STATUS<>'" + Str( MV_PAR19 - 1, 1 ) + "' AND "
	Else
		bMenos    := { || AD1->AD1_STATUS<>"9" }
		cQryMenos := "AD1_STATUS<>'9' AND "
	EndIf
EndIf

#IFDEF TOP

	If (TcSrvType()#'AS/400')
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Query para SQL                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cAliasQry := GetNextAlias()

		cQuery := ""

		cQuery += "SELECT * FROM " + RetSqlName( "AD1" ) + " AD1 "

		cQuery += " WHERE "

		cQuery += "AD1_FILIAL='"              + xFilial( 'AD1' )     + "' AND "
		cQuery += "AD1_PROSPE>='"+MV_PAR01+"' AND "
		cQuery += "AD1_PROSPE<='"+MV_PAR03+"' AND "
		cQuery += "AD1_LOJPRO>='"+MV_PAR02+"' AND "
		cQuery += "AD1_LOJPRO<='"+MV_PAR04+"' AND "
		cQuery += "AD1_VEND>='"               + MV_PAR05             + "' AND "
		cQuery += "AD1_VEND<='"               + MV_PAR06             + "' AND "
		cQuery += "AD1_DTINI>='"              + DToS( MV_PAR07 )     + "' AND "
		cQuery += "AD1_DTFIM<='"              + DToS( MV_PAR08 )     + "' AND "
		cQuery += "AD1_PROVEN>='"+MV_PAR09+"' AND "
		cQuery += "AD1_PROVEN<='"+MV_PAR11+"' AND "
		cQuery += "AD1_STAGE>='"+MV_PAR10+"' AND "
		cQuery += "AD1_STAGE<='"+MV_PAR12+"' AND "
		cQuery += "AD1_CODPRO>='"             + MV_PAR13             + "' AND "
		cQuery += "AD1_CODPRO<='"             + MV_PAR14             + "' AND "

		cQuery += "AD1.D_E_L_E_T_<>'*' AND "

		cQuery += cQryMais
		cQuery += cQryMenos

		cQuery += "( AD1_CODPRO='" + Space( Len( AD1->AD1_CODPRO ) ) + "' OR "
		cQuery += "EXISTS ( SELECT B1_COD FROM " + RetSqlName( "SB1" ) + " SB1 "
		cQuery += "WHERE "

      cQuery += "B1_COD=AD1_CODPRO AND "
		cQuery += "B1_FILIAL='"             + xFilial( 'SB1' )     + "' AND "
		cQuery += "B1_TIPO>='"              + MV_PAR15             + "' AND "
		cQuery += "B1_TIPO<='"              + MV_PAR16             + "' AND "
		cQuery += "B1_GRUPO>='"             + MV_PAR17             + "' AND "
		cQuery += "B1_GRUPO<='"             + MV_PAR18             + "' AND "

		cQuery += "SB1.D_E_L_E_T_<>'*' ) )"

		cQuery += "ORDER BY " + SqlOrder( aIndexKey[ nOrdem ] )

		cQuery := ChangeQuery(cQuery)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T. )

		aStruAD1 := AD1->( dbStruct() )

		For nLoop := 1 To Len( aStruAD1 )
			If aStruAD1[ nLoop, 2 ] <> "C"
				TcSetField( cAliasQry,AllTrim(aStruAD1[nLoop,1]),aStruAD1[nLoop,2],aStruAD1[nLoop,3],aStruAD1[nLoop,4])
			EndIf
		Next nLoop

		lQuery := .T.

		bWhile   := { || !( cAliasQry )->( Eof() ) }
		bSkip    := { || ( cAliasQry )->( dbSkip() ) }
		bCondAD1 := { || .T. }

		cAliasOpor := cAliasQry

	Else

#ENDIF

		cArqInd   := GetNextAlias()
		cIndexKey := aIndexKey[ nOrdem ] //Index utilizado para filtrar o AD1

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Condi‡Æo de filtragem do AD1   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCond   := ""

		cCond += "AD1_FILIAL=='"             + xFilial( 'AD1' )      + "'.And."
		cCond += "AD1_PROSPE>='"  + MV_PAR01 + "'.And."
		cCond += "AD1_PROSPE<='"  + MV_PAR03 + "'.And."
		cCond += "AD1_LOJPRO>='"  + MV_PAR02 + "'.And."
		cCond += "AD1_LOJPRO<='"  + MV_PAR04 + "'.And."
		cCond += "DToS(AD1_DTINI)>='"        + DToS( MV_PAR07 )      + "'.And."
		cCond += "DToS(AD1_DTFIM)<='"        + DToS( MV_PAR08 )      + "'.And."
		cCond += "AD1_CODPRO>='"             + MV_PAR13              + "' .And."
		cCond += "AD1_CODPRO<='"             + MV_PAR14              + "'"

		bCondAD1 := { || AD1->AD1_VEND >= MV_PAR05 .And. AD1->AD1_VEND <= MV_PAR06.And.;
			AD1->AD1_PROVEN + AD1->AD1_STAGE >= MV_PAR09 + MV_PAR10 .And. AD1->AD1_PROVEN + ;
			AD1->AD1_STAGE <= MV_PAR11 + MV_PAR12 }

		bWhile   := { || !AD1->( Eof() ) }
		bSkip    := { || AD1->( dbSkip() ) }

		IndRegua( "AD1", cArqInd, cIndexKey, , cCond )

		nIndice := RetIndex( "AD1" ) + 1

		dbSelectArea( "AD1" )
		AD1->( dbSetIndex( cArqInd + OrdBagExt() ) )

		AD1->( dbSetOrder(nIndice) )
		AD1->( dbGotop() )


		cAliasOpor := "AD1"

	#IFDEF TOP
		EndIf
	#ENDIF

DbSelectArea("AD1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o relatorio                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

bIf       := { || .T. }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o code-block de filtro do usuario                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Empty( aReturn[7] )
	cBlockFil := "{ || " + aReturn[ 7 ] + " }"
	bCondFil  := &cBlockFil
EndIf

While Eval( bWhile )

	If ( Li > 60 )
		li:=0
		cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
		li++
	Endif

	#IFDEF TOP
		bCondSB1 := { || .T. }
	#ELSE

		If Empty( ( cAliasOpor )->AD1_CODPRO )
			bCondSB1 := { || .T. }
		Else
			bCondSB1 := { || .F. }

			SB1->( dbSetOrder( 1 ) )
			If SB1->( dbSeek( xFilial( "SB1" ) + ( cAliasOpor )->AD1_CODPRO ) )
				lCondSB1 := ( SB1->B1_TIPO >= MV_PAR15 .And. SB1->B1_TIPO <= MV_PAR16 .And.;
					SB1->B1_GRUPO >= MV_PAR17 .And. SB1->B1_GRUPO <= MV_PAR18 )
				bCondSB1 := { || lCondSB1 }
			EndIf
		EndIf

	#ENDIF

	cCondFil := aReturn[7]

	dbSelectArea( cAliasOpor )

	If Eval( bCondSB1 ) .And. Eval( bCondAD1 ) .And. Eval( bCondFil ) .And. Eval( bMais ) .And. Eval( bMenos )

		nMoedaOpor := ( cAliasOpor )->AD1_MOEDA

		nVerbaBase := xMoeda( ( cAliasOpor )->AD1_VERBA, nMoedaOpor, MV_PAR22, dDataBase )
		nTotVerba += nVerbaBase

		If Empty( nScan := AScan( aTotVerba, { |x| x[1] == nMoedaOpor } ) )
			AAdd( aTotVerba , { nMoedaOpor, ( cAliasOpor )->AD1_VERBA } )
		Else
			aTotVerba[ nScan, 2 ] += ( cAliasOpor )->AD1_VERBA
		EndIf

		nTotOpor++

		cOpor   := ( cAliasOpor )->AD1_NROPOR
		cRevisa := ( cAliasOpor )->AD1_REVISA


//    Codigo  Rev  Descricao                      Representante               Prospect                    Processo de Venda              Estagio                           Verba Verba           Md.Base  Produto        Situacao
//              1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

		@ li, 00 PSAY cOpor
		@ li, 08 PSAY cRevisa
		@ li, 13 PSAY Left( ( cAliasOpor )->AD1_DESCRI, 30 )

		SA3->( dbSetOrder( 1 ) )
		If SA3->( dbSeek( xFilial( "SA3" ) + ( cAliasOpor )->AD1_VEND ) )
			@ li, 44 PSAY Left( AllTrim( SA3->A3_COD ) + "-" + SA3->A3_NOME, 27 )
		EndIf

		SUS->( dbSetOrder( 1 ) )
		If SUS->( dbSeek( xFilial( "SUS" ) + ( cAliasOpor )->AD1_PROSPE ) )
			@ li, 72 PSAY Left( AllTrim( SUS->US_COD ) + SUS->US_LOJA + "-" + SUS->US_NOME, 27 )
		EndIf

		AC1->( dbSetOrder( 1 ) )
		If AC1->( dbSeek( xFilial( "AC1" ) + ( cAliasOpor )->AD1_PROVEN ) )
			@ li, 100 PSAY Left( AllTrim( AC1->AC1_PROVEN ) + "-" + AC1->AC1_DESCRI, 25 )
		EndIf

		AC2->( dbSetOrder( 1 ) )
		If AC2->( dbSeek( xFilial( "AC2" ) + ( cAliasOpor )->AD1_PROVEN + ( cAliasOpor )->AD1_STAGE ) )
			@ li, 127 PSAY Left( AllTrim( AC2->AC2_STAGE ) + "-" + AC2->AC2_DESCRI, 25 )
		EndIf

		@ li, 152 PSAY ( cAliasOpor )->AD1_VERBA PICTURE PesqPict( "AD1", "AD1_VERBA",, MV_PAR22 ) + "(" + AllTrim( Str( ( cAliasOpor )->AD1_MOEDA ) ) + ")"

		@ li, 165 PSAY nVerbaBase PICTURE PesqPict( "AD1", "AD1_VERBA",, MV_PAR22 )

		@ li, 183 PSAY ( cAliasOpor )->AD1_CODPRO
		@ li, 209 PSAY X3Combo( "AD1_STATUS", ( cAliasOpor )->AD1_STATUS )

		If MV_PAR21 == 1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os detalhes da oportunidade ( campo memo )  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cMemo     := MSMM(( cAliasOpor )->AD1_CODMEM)
			nMemCount := MlCount( cMemo, 80 )

			If !Empty( nMemCount )
				Li+=2
				@ Li, nColDes PSAY STR0012 //"Notas:"
				Li++
				@ Li, nColDes PSAY Replicate( "-", Len( STR0012 ) )
				Li++
				For nLoop := 1 To nMemCount
					cLinha := MemoLine( cMemo, 80, nLoop )
					@ Li, nColDes PSAY cLinha
					Li++
					If ( Li > 60 )
						li:=0
						cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
						li++
					Endif
				Next nLoop

			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os concorrentes                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			aDadosAD3 := {}

			#IFDEF TOP

				If TcSrvType() <> "AS/400"

					cTrabAD3 := GetNextAlias()

					cQuery := ""

					cQuery += "SELECT AD3_CODCON, AC3_NOME FROM " + RetSqlName( "AD3" ) + " AD3, "
					cQuery += RetSqlName( "AC3" ) + " AC3 "
					cQuery += "WHERE "
					cQuery += "AD3_FILIAL='" + xFilial( "AD3" ) + "' AND "
					cQuery += "AD3_NROPOR='" + cOpor            + "' AND "
					cQuery += "AD3_REVISA='" + cRevisa          + "' AND "
					cQuery += "AD3_CODCON=AC3_CODCON AND "
					cQuery += "AD3.D_E_L_E_T_<>'*' AND "

					cQuery += "AC3_FILIAL='" + xFilial( "AC3" ) + "' AND "
					cQuery += "AC3.D_E_L_E_T_<>'*' ORDER BY " + SqlOrder( AD3->( IndexKey() ) )

					cQuery := ChangeQuery( cQuery )

					dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cTrabAD3, .F., .T. )

					If Alias() == cTrabAD3

						While !Eof()
							AAdd( aDadosAD3, { AD3_CODCON, AC3_NOME } )
							dbSkip()
						EndDo

						dbCloseArea()
						dbSelectArea( "AD3" )

					EndIf
				Else

			#ENDIF

					AD3->( dbSetOrder( 1 ) )

					cSeekAD3 := xFilial( "AD3" ) + cOpor + cRevisa
					If AD3->( dbSeek( cSeekAD3 ) )
 						While !AD3->( Eof() ) .And. cSeekAD3 == AD3->AD3_FILIAL + AD3->AD3_NROPOR + AD3->AD3_REVISA

 						 	AC3->( dbSetOrder( 1 ) )
 						    If AC3->( dbSeek( xFilial( "AC3" ) + AD3->AD3_CODCON ) )
								AAdd( aDadosAD3, { AD3->AD3_CODCON, AC3->AC3_NOME } )
							EndIf

							AD3->( dbSkip() )
						EndDo
			        EndIf
			#IFDEF TOP
				EndIf
			#ENDIF

            If !Empty( aDadosAD3 )

    			Li+=2
				@ Li, nColDes PSAY STR0013 //"Concorrentes:"
				Li++
				@ Li, nColDes PSAY Replicate( "-", Len( STR0013 ) )

                For nLoop := 1 To Len( aDadosAD3 )
                  	li++
               		If ( Li > 60 )
						li:=0
						cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
						li++
					Endif
					@ li, 00 PSAY aDadosAD3[ nLoop, 1 ] + " - " + aDadosAD3[ nLoop, 2 ]
            	Next nLoop
				Li++
			EndIf


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os parceiros                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			aDadosAD4 := {}

			#IFDEF TOP

				If TcSrvType() <> "AS/400"

					cTrabAD4 := GetNextAlias()

					cQuery := ""

					cQuery += "SELECT AD4_PARTNE, AC4_NOME FROM " + RetSqlName( "AD4" ) + " AD4, "
					cQuery += RetSqlName( "AC4" ) + " AC4 "
					cQuery += "WHERE "
					cQuery += "AD4_FILIAL='" + xFilial( "AD4" ) + "' AND "
					cQuery += "AD4_NROPOR='" + cOpor            + "' AND "
					cQuery += "AD4_REVISA='" + cRevisa          + "' AND "
					cQuery += "AD4.D_E_L_E_T_<>'*' AND "

					cQuery += "AD4_PARTNE=AC4_PARTNE AND "

					cQuery += "AC4_FILIAL='" + xFilial( "AC4" ) + "' AND "
					cQuery += "AC4.D_E_L_E_T_<>'*' ORDER BY " + SqlOrder( AD4->( IndexKey() ) )

					cQuery := ChangeQuery( cQuery )

					dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cTrabAD4, .F., .T. )

					If Alias() == cTrabAD4

						While !Eof()
							AAdd( aDadosAD4, { AD4_PARTNE, AC4_NOME } )
							dbSkip()
						EndDo

						dbCloseArea()
						dbSelectArea( "AD4" )

					EndIf
				Else

			#ENDIF

					AD4->( dbSetOrder( 1 ) )

					cSeekAD4 := xFilial( "AD4" ) + cOpor + cRevisa
					If AD4->( dbSeek( cSeekAD4 ) )
 						While !AD4->( Eof() ) .And. cSeekAD4 == AD4->AD4_FILIAL + AD4->AD4_NROPOR + AD4->AD4_REVISA

 							AC4->( dbSetOrder( 1 ) )
							If AC4->( dbSeek( xFilial( "AC4" ) + AD4->AD4_PARTNE ) )
								AAdd( aDadosAD4, { AD4->AD4_PARTNE, AC4->AC4_NOME } )
							EndIf
							AD4->( dbSkip() )
						EndDo
			        EndIf
			#IFDEF TOP
				EndIf
			#ENDIF

            If !Empty( aDadosAD4 )

    			Li++
				@ Li, nColDes PSAY STR0014 //"Parceiros:"
				Li++
				@ Li, nColDes PSAY Replicate( "-", Len( STR0014 ) )

                For nLoop := 1 To Len( aDadosAD4 )
                  	li++
               		If ( Li > 60 )
						li:=0
						cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
						li++
					Endif
					@ li, 00 PSAY aDadosAD4[ nLoop, 1 ] + " - " + aDadosAD4[ nLoop, 2 ]
            	Next nLoop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe o time de vendas                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			aDadosAD2 := {}

			#IFDEF TOP

				If TcSrvType() <> "AS/400"

					cTrabAD2 := GetNextAlias()

					cQuery := ""

					cQuery += "SELECT AD2_VEND, A3_NOME FROM " + RetSqlName( "AD2" ) + " AD2, "
					cQuery += RetSqlName( "SA3" ) + " SA3 "
					cQuery += "WHERE "
					cQuery += "AD2_FILIAL='" + xFilial( "AD2" ) + "' AND "
					cQuery += "AD2_NROPOR='" + cOpor            + "' AND "
					cQuery += "AD2_REVISA='" + cRevisa          + "' AND "
					cQuery += "AD2.D_E_L_E_T_<>'*' AND "

					cQuery += "AD2_VEND=A3_COD AND "

					cQuery += "A3_FILIAL='" + xFilial( "SA3" ) + "' AND "
					cQuery += "SA3.D_E_L_E_T_<>'*' ORDER BY " + SqlOrder( AD2->( IndexKey() ) )

					cQuery := ChangeQuery( cQuery )

					dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cTrabAD2, .F., .T. )

					If Alias() == cTrabAD2
						While !Eof()
							AAdd( aDadosAD2, { AD2_VEND, A3_NOME } )
							dbSkip()
						EndDo

						dbCloseArea()
						dbSelectArea( "AD2" )

					EndIf
				Else

			#ENDIF

					AD2->( dbSetOrder( 1 ) )

					cSeekAD2 := xFilial( "AD2" ) + cOpor + cRevisa
					If AD2->( dbSeek( cSeekAD2 ) )
 						While !AD2->( Eof() ) .And. cSeekAD2 == AD2->AD2_FILIAL + AD2->AD2_NROPOR + AD2->AD2_REVISA

 							SA3->( dbSetOrder( 1 ) )
 							If SA3->( dbSeek( xFilial( "SA3" ) + AD2->AD2_VEND ) )
								AAdd( aDadosAD2, { AD2->AD2_VEND, SA3->A3_NOME } )
							EndIf
							AD2->( dbSkip() )
						EndDo
			        EndIf
			#IFDEF TOP
				EndIf
			#ENDIF

            If !Empty( aDadosAD2 )

    			Li+=2
				@ Li, nColDes PSAY STR0015 //"Representantes:"
				Li++
				@ Li, nColDes PSAY Replicate( "-", Len( STR0015 ) )

                For nLoop := 1 To Len( aDadosAD2 )
                  	li++
               		If ( Li > 60 )
						li:=0
						cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
						li++
					Endif
					@ li, 00 PSAY aDadosAD2[ nLoop, 1 ] + " - " + aDadosAD2[ nLoop, 2 ]
				Next nLoop

			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os contatos                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			aDadosAD9 := {}

			#IFDEF TOP

				If TcSrvType() <> "AS/400"

					cTrabAD9 := GetNextAlias()

					cQuery := ""

					cQuery += "SELECT AD9_CODCON, U5_CONTAT FROM " + RetSqlName( "AD9" ) + " AD9, "
					cQuery += RetSqlName( "SU5" ) + " SU5 "
					cQuery += "WHERE "
					cQuery += "AD9_FILIAL='" + xFilial( "AD9" ) + "' AND "
					cQuery += "AD9_NROPOR='" + cOpor            + "' AND "
					cQuery += "AD9_REVISA='" + cRevisa          + "' AND "
					cQuery += "AD9.D_E_L_E_T_<>'*' AND "

					cQuery += "AD9_CODCON=U5_CODCONT AND "

					cQuery += "U5_FILIAL='" + xFilial( "SU5" ) + "' AND "
					cQuery += "SU5.D_E_L_E_T_<>'*' "

					cQuery += "ORDER BY " + SqlOrder( AD9->( IndexKey() ) )

					cQuery := ChangeQuery( cQuery )

					dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cTrabAD9, .F., .T. )

					If Alias() == cTrabAD9
						While !Eof()
							AAdd( aDadosAD9, { AD9_CODCON, U5_CONTAT } )
							dbSkip()
						EndDo

						dbCloseArea()
						dbSelectArea( "AD9" )

					EndIf
				Else

			#ENDIF

					AD9->( dbSetOrder( 1 ) )

					cSeekAD9 := xFilial( "AD9" ) + cOpor + cRevisa
					If AD9->( dbSeek( cSeekAD9 ) )
 						While !AD9->( Eof() ) .And. cSeekAD9 == AD9->AD9_FILIAL + AD9->AD9_NROPOR + AD9->AD9_REVISA

 							SU5->( dbSetOrder( 1 ) )

 							If SU5->( dbSeek( xFilial( "SU5" ) + AD9->AD9_CODCON ) )
								AAdd( aDadosAD9, { AD9->AD9_CODCON, SU5->U5_CONTAT } )
							EndIf
							AD9->( dbSkip() )
						EndDo
			        EndIf

			#IFDEF TOP
				EndIf
			#ENDIF

            If !Empty( aDadosAD9 )

    			Li+=2
				@ Li, nColDes PSAY STR0016 //"Contatos:"
				Li++
				@ Li, nColDes PSAY Replicate( "-", Len( STR0016 ) )

                For nLoop := 1 To Len( aDadosAD9 )
                  	li++
               		If ( Li > 60 )
						li:=0
						cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
						li++
					Endif
					@ li, 00 PSAY aDadosAD9[ nLoop, 1 ] + " - " + aDadosAD9[ nLoop, 2 ]
            	Next nLoop
			EndIf

		EndIf

		Li++
		@ Li, 00 PSAY Replicate( "-", Limite )
		Li++

	EndIf

	Eval( bSkip )

Enddo

Li+=2

@ li, 00 PSAY STR0017 + AllTrim( Str( nTotOpor ) )  //"Total / Oportunidades : "
Li++
@ li, 00 PSAY STR0018 + Str( MV_PAR22, 2 ) + " ): " + TransForm( nTotVerba, PesqPict( "AD1", "AD1_VERBA",, MV_PAR22 ) ) //"Total / Verba ( moeda "

li++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lista os totais por moeda                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Empty( aTotVerba )

	li++
	@ li,00 PSAY STR0019 // "Totais por moeda:"
	li++

	ASort( aTotVerba, , , { |x,y| y[1] > x[1] } )

	For nLoop := 1 To Len( aTotVerba )
		li++

		cNomeMoeda := Capital( AllTrim( GetMV( "MV_MOEDA" + AllTrim( Str( aTotVerba[ nLoop, 1 ] ) ) ) ) )
		@ li, 00 PSAY STR0018 + Str( aTotVerba[ nLoop, 1 ], 2 ) + "-" + cNomeMoeda + ;
				" ): " + Transform( aTotVerba[ nLoop, 2 ],;
				PesqPict( "AD1", "AD1_VERBA", , aTotVerba[ nLoop, 1 ] ) )
	Next nLoop
EndIf

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga os arquivos de trabalho                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFNDEF TOP
	FErase(cArqInd + OrdBagExt() )
#ENDIF

dbSelectArea( "AD1" )
RetIndex("AD1")

Return(.T.)

//------------------------------------------------------------------------------
/*/{Protheus.doc} FTR10AIJSt

Adiciona o status da evolucao da venda no relatorio.

@sample 	FTR10AIJSt(cProVen, cStage, cDtIni, cHrIni, cStatus)

@param		ExpC1	Processo de Venda
@param		ExpC2	Estagio
@param		ExpC3	Data Inicial
@param		ExpC4	Hora Final
@param		ExpC4	Status encerrado.


@return	ExpC Status da Evolucao.

@author	Anderson Silva
@since		21/05/2013
@version	P12
/*/
//------------------------------------------------------------------------------
Static Function FTR10AIJSt(cProVen, cStage, cDtIni, cHrIni, cStatus)

Local aArea 		:= GetArea()			// Guarda a area atual.
Local nDtHrLimit	:= 0 					// Data / Hora limite para avancar o estagio.
Local nDtHrBase		:= 0   					// Database do sistema (Data/Hora).
Local dDtNotif		:= cTod("//") 			// Data que comecara a notificacao.
Local cHrNotif		:= ""					// Hora que comecara a notificacao.
Local nDtHrNotif	:= 0					// Data / Hora de notificacao.
Local dDtLimit		:= cTod("//") 			// Data limite.
Local cHrLimit		:= ""  					// Hora limite.
Local nHrsInt		:= 0					// Hora em inteiro.
Local cRetorno		:= STR0034              // Status da evolucao.

DbSelectArea("AC2")
DbSetOrder(1)

If Empty(cStatus)

	If AC2->(DbSeek(xFilial("AC2")+cProVen+cStage))

		// Calcula a data e hora limite para avancar o estagio.
		Ft300LtEst(cDtIni, cHrIni, @dDtLimit,@cHrLimit)

		If ( AC2->AC2_DNOTIF <> 0 .OR. ( !Empty(AC2->AC2_HNOTIF) .AND. AC2->AC2_HNOTIF <> "00:00" ) )

			dDtNotif := dDtLimit - AC2->AC2_DNOTIF
			cHrNotif :=	cHrLimit
			nHrsInt  := HoraToInt(AC2->AC2_HNOTIF)

			SubtDiaHor(@dDtNotif,@cHrNotif,nHrsInt)

			nDtHrNotif	:= Val(DtoS(dDtNotif)+StrTran(cHrNotif,":",""))

		EndIf

		nDtHrLimit	:= Val(DtoS(dDtLimit)+StrTran(cHrLimit,":",""))
		nDtHrBase	:= Val(DtoS(dDataBase)+StrTran(SubStr(Time(),1,5),":",""))

		// Legenda do estagio atual.
		If nDtHrLimit <> 0
			If ( nDtHrNotif <> 0 .AND. nDtHrBase >=  nDtHrNotif  .AND. nDtHrNotif <= nDtHrLimit  .AND. nDtHrLimit > nDtHrBase  )
				cRetorno := STR0032 // "Em alerta"
			ElseIf nDtHrBase > nDtHrLimit
				cRetorno := STR0033	// "Em atraso"
			EndIf
		Else
			cRetorno := STR0034 // "Em dia"
		EndIf

	EndIf
Else
	cRetorno := X3Combo("AIJ_STATUS",cStatus)
EndIf

RestArea(aArea)

Return( cRetorno )