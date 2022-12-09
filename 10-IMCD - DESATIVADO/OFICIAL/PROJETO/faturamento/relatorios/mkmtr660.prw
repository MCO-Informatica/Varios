#INCLUDE "FIVEWIN.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR660  ³ Autor ³ Marco Bianchi         ³ Data ³ 03/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Resumo de Vendas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION MKMTR660()

	Local oReport
	Private oTemptable 

	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³ 03/07/06 ³±±
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
	Local cColuna	:= ""
	Local cTitulo	:= "Nota Fiscal/Serie"		// "Nota Fiscal/Serie"
	Local nQuant	:= 0
	Local nPrcVen	:= 0
	Local nTotal	:= 0
	Local nValIpi	:= 0
	Local nQuant1	:= 0
	Local nPrcVen1	:= 0
	Local nTotal1	:= 0
	Local nValIpi1	:= 0

	Private cPerg   :="MTR660    "


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
	oReport:= TReport():New("MATR660","Resumo de Vendas","MTR660", {|oReport| ReportPrint(oReport)},"Emissao do Relatorio de Resumo de Vendas, podendo o mesmo ser emitido por ordem de Tipo de Entrada/Saida, Grupo, Tipo de Material ou Conta Contábil.")	// "Resumo de Vendas"###"Emissao do Relatorio de Resumo de Vendas, podendo o mesmo"###"ser emitido por ordem de Tipo de Entrada/Saida, Grupo, Tipo"###"de Material ou Conta Contábil."
	oReport:SetPortrait(.T.) 
	oReport:SetTotalInLine(.F.)

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
	oResumoVen := TRSection():New(oReport,"Resumo",{"TRB"},{"Por Tp/Saida + Produto","Por Tipo","Por Grupo","P/Ct.Contab.","Por Produto","Por Tp/Salida + Serie + Nota"},/*Campos do SX3*/,/*Campos do SIX*/)	// "Resumo"###"Por Tp/Saida + Produto"###"Por Tipo"###"Por Grupo"###"P/Ct.Contab."###"Por Produto"###"Por Tp/Salida + Serie + Nota"
	oResumoVen:SetTotalInLine(.F.)

	TRCell():New(oResumoVen,"CCOLUNA" ,/*Tabela*/,cTitulo								,/*Picture*/	 			 ,TamSx3("D2_CONTA"  )[1]+TamSx3("D2_SERIE")[1],/*lPixel*/,{|| cColuna  })	
	TRCell():New(oResumoVen,"NQUANT"  ,/*Tabela*/,"|"+CRLF+"|"+RetTitle("D2_QUANT"	)	,PesqPict("SD2","D2_QUANT"	),TamSx3("D2_QUANT"  )[1],/*lPixel*/,{|| nQuant   },,,"RIGHT")	// FATURAMENTO:		Quantidade
	TRCell():New(oResumoVen,"NPRCVEN" ,/*Tabela*/,"FATURAMENTO:"+CRLF+RetTitle("D2_PRCVEN")	,PesqPict("SD2","D2_PRCVEN"	),TamSx3("D2_PRCVEN" )[1],/*lPixel*/,{|| nPrcVen  },,,"RIGHT")	// FATURAMENTO:		Preco Unitario
	TRCell():New(oResumoVen,"NTOTAL"  ,/*Tabela*/,CRLF+RetTitle("D2_TOTAL"	)			,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"  )[1],/*lPixel*/,{|| nTotal   },,,"RIGHT")	// FATURAMENTO:		Valot Total
	If cPaisloc == "BRA"
		TRCell():New(oResumoVen,"NVALIPI" ,/*Tabela*/,CRLF+RetTitle("D2_VALIPI"	)	,PesqPict("SD2","D2_VALIPI"	),TamSx3("D2_VALIPI" )[1],/*lPixel*/,{|| nValIPI  },,,"RIGHT")	// FATURAMENTO:		Valor IPI
	Else	
		TRCell():New(oResumoVen,"NVALIPI" ,/*Tabela*/,CRLF+Substr(RetTitle("D2_VALIMP1"),1,10)	,PesqPict("SD2","D2_VALIPI"	),TamSx3("D2_VALIPI" )[1],/*lPixel*/,{|| nValIPI  },,,"RIGHT")	// FATURAMENTO:		Valor IPI
	EndIf	
	TRCell():New(oResumoVen,"NQUANT1" ,/*Tabela*/,"|"+CRLF+"|"+RetTitle("D2_QUANT"	)	,PesqPict("SD2","D2_QUANT"	),TamSx3("D2_QUANT"  )[1],/*lPixel*/,{|| nQuant1  },,,"RIGHT")	// OUTROS VALORES:	Quantidade
	TRCell():New(oResumoVen,"NPRCVEN1",/*Tabela*/,"OUTROS VALORES: "+CRLF+RetTitle("D2_PRCVEN")	,PesqPict("SD2","D2_PRCVEN"	),TamSx3("D2_PRCVEN" )[1],/*lPixel*/,{|| nPrcVen1 },,,"RIGHT")	// OUTROS VALORES:	Preco Unitario
	TRCell():New(oResumoVen,"NTOTAL1" ,/*Tabela*/,CRLF+RetTitle("D2_TOTAL"	)			,PesqPict("SD2","D2_TOTAL"		),TamSx3("D2_TOTAL"  )[1],/*lPixel*/,{|| nTotal1  },,,"RIGHT")	// OUTROS VALORES:	Valor Total
	If cPaisloc == "BRA"
		TRCell():New(oResumoVen,"NVALIPI1",/*Tabela*/,CRLF+AllTrim(RetTitle("D2_VALIPI"))+"|",PesqPict("SD2","D2_VALIPI"	),TamSx3("D2_VALIPI" )[1],/*lPixel*/,{|| nValIPI1 },,,"RIGHT")	// OUTROS VALORES:	Valor do IPI
	Else
		TRCell():New(oResumoVen,"NVALIPI1",/*Tabela*/,CRLF+Substr(RetTitle("D2_VALIMP1"),1,10)+"|"					 ,PesqPict("SD2","D2_VALIPI"	),TamSx3("D2_VALIPI" )[1],/*lPixel*/,{|| nValIPI1 },,,"RIGHT")	// OUTROS VALORES:	Valor do IPI
	EndIf
	TRFunction():New(oResumoVen:Cell("NQUANT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oResumoVen:Cell("NTOTAL"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oResumoVen:Cell("NVALIPI"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oResumoVen:Cell("NQUANT1"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oResumoVen:Cell("NTOTAL1"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oResumoVen:Cell("NVALIPI1"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estas Secoes servem apenas para receber as Querys do SD1 e SD2         ³
	//³ que nao sao as tabelas da Section Principal. A tabela para impressao   ³
	//³ e a TRB. Se deixamos o filtro de SD1 e SD2 na section principal,	   ³
	//³ no momento do filtro do SD2 o sistema fecha o filtro do SD1 nao        ³
	//³ reconhecendo o alias.											       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oTemp1 := TRSection():New(oReport,"Itens - Notas Fiscais Entrada",{"SD1"},{"Por Tp/Saida + Produto","Por Tipo","Por Grupo","P/Ct.Contab.","Por Produto","Por Tp/Salida + Serie + Nota"},/*Campos do SX3*/,/*Campos do SIX*/)	// "Itens - Notas Fiscais Entrada"###"Por Tp/Saida + Produto"###"Por Tipo"###"Por Grupo"###"P/Ct.Contab."###"Por Produto"###"Por Tp/Salida + Serie + Nota"
	oTemp1:SetTotalInLine(.F.)

	oTemp2 := TRSection():New(oReport,"Itens - Notas Fiscais Saida",{"SD2","SF2"},{"Por Tp/Saida + Produto","Por Tipo","Por Grupo","P/Ct.Contab.","Por Produto","Por Tp/Salida + Serie + Nota"},/*Campos do SX3*/,/*Campos do SIX*/)	// "Itens - Notas Fiscais Saida"###"Por Tp/Saida + Produto"###"Por Tipo"###"Por Grupo"###"P/Ct.Contab."###"Por Produto"###"Por Tp/Salida + Serie + Nota"
	oTemp2:SetTotalInLine(.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Cabecalho no top da pagina                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):SetHeaderPage()     

	oReport:Section(2):SetEdit(.F.)
	oReport:Section(2):SetEditCell(.F.)
	oReport:Section(3):SetEditCell(.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas 									   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(oReport:uParam,.F.)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Marco Bianchi         ³ Data ³ 03/07/06 ³±±
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

	Local cAliasSD1 := ""
	Local cAliasSD2 := ""
	Local cAliasSF2 := ""
	Local cOrder	:= ""
	Local nCntFor 	:= 0
	Local nVend		:= fa440CntVen()
	Local lImprime 	:= .T.
	Local cTexto	:= ""
	Local cCampo	:= ""
	Local nY		:= 0
	Local aCampos	:= {}
	Local cIndice 	:= ""
	Local cIndTrab 	:= ""
	Local lVend		:= .F.
	Local cVend		:= "1"
	Local cEstoq 	:= If( (MV_PAR05 == 1),"S",If( (MV_PAR05 == 2),"N","SN" ) )
	Local cDupli 	:= If( (MV_PAR06 == 1),"S",If( (MV_PAR06 == 2),"N","SN" ) )
	Local cCondicao := ""
	Local cFilSF2   := ""
	Local cFilSD2   := ""
	Local nImpInc   := 0
	Local aSX513    := {}

	#IFDEF TOP
	Local cWhere	:= ""
	#ENDIF

	Private nDecs:=msdecimais(mv_par08)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SetBlock: faz com que as variaveis locais possam ser                   ³
	//³ utilizadas em outras funcoes nao precisando declara-las                ³
	//³ como private.                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):Cell("CCOLUNA" 	):SetBlock({|| cColuna		})
	oReport:Section(1):Cell("NQUANT" 	):SetBlock({|| nQuant		})
	oReport:Section(1):Cell("NPRCVEN" 	):SetBlock({|| nPrcVen		})
	oReport:Section(1):Cell("NTOTAL" 	):SetBlock({|| nTotal		})
	oReport:Section(1):Cell("NVALIPI" 	):SetBlock({|| nValIpi		})
	oReport:Section(1):Cell("NQUANT1" 	):SetBlock({|| nQuant1		})
	oReport:Section(1):Cell("NPRCVEN1" 	):SetBlock({|| nPrcVen1		})
	oReport:Section(1):Cell("NTOTAL1" 	):SetBlock({|| nTotal1		})
	oReport:Section(1):Cell("NVALIPI1" 	):SetBlock({|| nValIpi1		})
	cColuna		:= ""
	nQuant		:= 0
	nPrcVen		:= 0
	nTotal		:= 0
	nValIpi		:= 0
	nQuant1		:= 0
	nPrcVen1	:= 0
	nTotal1		:= 0
	nValIpi1	:= 0


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Altera o Titulo do Relatorio de acordo com parametros	 	           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetTitle(oReport:Title() + " - " + IIf(oReport:Section(1):GetOrder() == 1,"Por Tp/Saida + Produto",IIF(oReport:Section(1):GetOrder()==2,"Por Tipo",IIF(oReport:Section(1):GetOrder()==3,"Por Grupo",IIF(oReport:Section(1):GetOrder()==4,"P/Ct.Contab.",IIF(oReport:Section(1):GetOrder()==5,"Por Produto","Por Tp/Salida + Serie + Nota"))))) + " - " + GetMv("MV_MOEDA"+STR(mv_par08,1)) )	// "Resumo de Vendas"###"Por Tp/Saida + Produto"###"Por Tipo"###"Por Grupo"###"P/Ct.Contab."###"Por Produto"###"Por Tp/Salida + Serie + Nota"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona SB1 para antes da impressao                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRPosition():New(oReport:Section(1),"SB1",1,{|| xFilial("SB1") + TRB->D2_COD })
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtragem do relatório                                                  ³
	//³Obs: Utilizamos SetFilter no SD1 e nao Query pois e dado dbSeek         ³
	//³no SD1 na funcao CALCDEVR4.                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui Devolucao                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cOrder	 := ""
	cCondicao:= ""
	If mv_par04 # 3
		cAliasSD1 := "SD1"
		dbSelectArea(cAliasSD1)
		dbSetOrder(2)
		cOrder := "D1_FILIAL+D1_COD+D1_SERIORI+D1_NFORI+D1_ITEMORI"
		cCondicao := 'D1_FILIAL=="'+xFilial("SD1")+'".And.D1_TIPO=="D"'
		cCondicao += ".And. D1_COD>='"+MV_PAR13+"'.And. D1_COD<='"+MV_PAR14+"'"
		cCondicao += '.And. !('+IsRemito(2,'D1_TIPODOC')+')'
		If (MV_PAR04 == 2)
			cCondicao +=".And.DTOS(D1_DTDIGIT)>='"+DTOS(MV_PAR01)+"'.And.DTOS(D1_DTDIGIT)<='"+DTOS(MV_PAR02)+"'"
		EndIf
		dbSelectArea(cAliasSD1)
		oReport:Section(2):SetFilter(cCondicao,cOrder)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona Indice da Nota Fiscal de Saida                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasSF2 := "SF2"
	dbSelectArea(cAliasSF2)
	dbSetOrder(1)

	#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Itens de Venda da Nota Fiscal                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasSD2 := GetNextAlias()
	dbSelectArea("SD2")
	cWhere := ""
	cWhere := "% AND NOT ("+IsRemito(2,'D2_TIPODOC')+")"
	If mv_par04 == 3 .Or. mv_par11 == 2
		cWhere += " AND D2_TIPO NOT IN ('B','D','I')"
	Else
		cWhere += " AND D2_TIPO NOT IN ('B','I')"
	EndIf		
	cWhere += "%"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ha necessidade de Indexacao no SD2               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oReport:Section(1):GetOrder() = 1 .Or. oReport:Section(1):GetOrder() = 6	// Por Tes
		cOrder := "%D2_FILIAL,D2_TES,"+IIf(oReport:Section(1):GetOrder()==1,"D2_COD","D2_SERIE,D2_DOC") + "%"
	ElseIF oReport:Section(1):GetOrder() = 2			// Por Tipo
		SD2->(dbSetOrder(2))							// Tipo do Produto, Codigo do Produto)
		cOrder := "%" + IndexKey() + "%"
	ElseIF oReport:Section(1):GetOrder() = 3			// Por Grupo
		cOrder := "%D2_FILIAL,D2_GRUPO,D2_COD%"
	ElseIF oReport:Section(1):GetOrder() = 4			// Por Conta Contabil
		cOrder := "%D2_FILIAL,D2_CONTA,D2_COD%"
	Else						  						// Por Produto
		cOrder := "%D2_FILIAL,D2_COD,D2_LOCAL,D2_SERIE,D2_DOC%"
	EndIF

	oReport:Section(3):BeginQuery()	
	BeginSql Alias cAliasSD2
		SELECT *
		FROM %Table:SD2% SD2
		WHERE D2_FILIAL = %xFilial:SD2%
		AND D2_EMISSAO >= %Exp:DtoS(mv_par01)% AND D2_EMISSAO <= %Exp:DtoS(mv_par02)%
		AND D2_COD >= %Exp:mv_par13% AND D2_COD <= %Exp:mv_par14%
		AND D2_ORIGLAN <> 'LF'
		AND SD2.%NotDel%
		%Exp:cWhere%	
		ORDER BY %Exp:cOrder%
	EndSql 
	oReport:Section(3):EndQuery(/*Array com os parametros do tipo Range*/)
	dbGoTop()

	#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Itens de Venda da Nota Fiscal                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasSD2 := "SD2"
	DbSelectArea(cAliasSD2)
	cCondicao:= ""
	cCondicao += "D2_FILIAL == '"+xFilial("SD2")+"'.And."
	cCondicao += "DTOS(D2_EMISSAO) >='"+DTOS(mv_par01)+"'.And.DTOS(D2_EMISSAO)<='"+DTOS(mv_par02)+"'"
	cCondicao += ".And. D2_COD>='"+MV_PAR13+"'.And. D2_COD<='"+MV_PAR14+"'"
	cCondicao += '.And. !('+IsRemito(2,'D2_TIPODOC')+')'		
	cCondicao += ".And.!(D2_ORIGLAN$'LF')"
	If mv_par04==3 .Or. mv_par11 == 2
		cCondicao += ".And.!(D2_TIPO$'BDI')"
	Else
		cCondicao += ".And.!(D2_TIPO$'BI')"
	EndIf		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ha necessidade de Indexacao no SD2               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oReport:Section(1):GetOrder() = 1 .Or. oReport:Section(1):GetOrder() = 6	// Por Tes
		oReport:Section(3):SetFilter(cCondicao,"D2_FILIAL+D2_TES+" + IIf(oReport:Section(1):GetOrder()==1,"D2_COD","D2_SERIE+D2_DOC"))	
	ElseIF oReport:Section(1):GetOrder() = 2				// Por Tipo
		SD2->(dbSetOrder(2))								// Tipo do Produto, Codigo do Produto
		oReport:Section(3):SetFilter(cCondicao,IndexKey())	
	ElseIF oReport:Section(1):GetOrder() = 3				// Por Grupo
		oReport:Section(3):SetFilter(cCondicao,"D2_FILIAL+D2_GRUPO+D2_COD")		
	ElseIF oReport:Section(1):GetOrder() = 4				// Por Conta Contabil
		oReport:Section(3):SetFilter(cCondicao,"D2_FILIAL+D2_CONTA+D2_COD")
	Else													// Por Produto
		oReport:Section(3):SetFilter(cCondicao,"D2_FILIAL+D2_COD+D2_LOCAL+D2_SERIE+D2_DOC")
	EndIF
	dbGoTop()

	#ENDIF		


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria tabela temporaria                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIndTrab := SubStr("TRB",1,7)+"A"
	dbSelectArea("SD2")
	aTam := TamSx3("D2_FILIAL")
	Aadd(aCampos,{"D2_FILIAL","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_COD")
	Aadd(aCampos,{"D2_COD","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_LOCAL")
	Aadd(aCampos,{"D2_LOCAL","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_SERIE")
	Aadd(aCampos,{"D2_SERIE","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_TES")
	Aadd(aCampos,{"D2_TES","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_TP")
	Aadd(aCampos,{"D2_TP","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_GRUPO")
	Aadd(aCampos,{"D2_GRUPO","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_CONTA")
	Aadd(aCampos,{"D2_CONTA","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_EMISSAO")
	Aadd(aCampos,{"D2_EMISSAO","D",aTam[1],aTam[2]})
	aTam := TamSx3("D2_TIPO")
	Aadd(aCampos,{"D2_TIPO","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_DOC")
	Aadd(aCampos,{"D2_DOC","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_QUANT")
	Aadd(aCampos,{"D2_QUANT","N",aTam[1],aTam[2]})
	aTam := TamSx3("D2_TOTAL")
	Aadd(aCampos,{"D2_TOTAL","N",aTam[1],aTam[2]})

	If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
		aTam := TamSx3("D2_VALIMP1")
		Aadd(aCampos,{"D2_VALIMP1","N",aTam[1],aTam[2]})
	else
		aTam := TamSx3("D2_VALIPI")
		Aadd(aCampos,{"D2_VALIPI","N",aTam[1],aTam[2]})
	EndIf

	aTam := TamSx3("D2_PRCVEN")
	Aadd(aCampos,{"D2_PRCVEN","N",aTam[1],aTam[2]})
	aTam := TamSx3("D2_ITEM")
	Aadd(aCampos,{"D2_ITEM","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_CLIENTE")
	Aadd(aCampos,{"D2_CLIENTE","C",aTam[1],aTam[2]})
	aTam := TamSx3("D2_LOJA")
	Aadd(aCampos,{"D2_LOJA","C",aTam[1],aTam[2]})

	//Campos para guardar a moeda/taxa da nota para a conversao durante a impressao
	aTam := TamSx3("F2_MOEDA")
	Aadd(aCampos,{"D2_MOEDA","N",aTam[1],aTam[2]})
	aTam := TamSx3("F2_TXMOEDA")
	Aadd(aCampos,{"D2_TXMOEDA","N",aTam[1],aTam[2]})

	If oTemptable <> Nil
		oTemptable:Delete()
		oTemptable := Nil
	Endif

	oTemptable := FWTemporaryTable():New("TRB")
	oTemptable:SetFields(aCampos)
	oTemptable:AddIndex("1",{"D2_FILIAL","D2_COD"})

	oTempTable:Create()

	If oReport:Section(1):GetOrder() = 1 .Or. oReport:Section(1):GetOrder() = 6							// Por Tes	
		cVaria := "D2_TES"
		IndRegua("TRB",cIndTrab,"D2_FILIAL+D2_TES+"+IIf(oReport:Section(1):GetOrder()==1,"D2_COD","D2_SERIE+D2_DOC"),,,"Selecionando Registros...")	// "Selecionando Registros..."
	ElseIF oReport:Section(1):GetOrder() = 2																// Por Tipo
		cVaria := "D2_TP"
		IndRegua("TRB",cIndTrab,SD2->(IndexKey(2)),,,"Selecionando Registros...")   											// "Selecionando Registros..."
	ElseIF oReport:Section(1):GetOrder() = 3																// Por Grupo
		cVaria := "D2_GRUPO"
		IndRegua("TRB",cIndTrab,"D2_FILIAL+D2_GRUPO+D2_COD",,,"Selecionando Registros...") 										// "Selecionando Registros..."
	ElseIF oReport:Section(1):GetOrder() = 4																// Por Conta Contabil
		cVaria := "D2_CONTA"
		IndRegua("TRB",cIndTrab,"D2_FILIAL+D2_CONTA+D2_COD",,,"Selecionando Registros...") 										// "Selecionando Registros..."
	Else																									// Por Produto
		cVaria := "D2_COD"
		IndRegua("TRB",cIndTrab,"D2_FILIAL+D2_COD+D2_LOCAL+D2_SERIE+D2_DOC",,,"Selecionando Registros...")     					// "Selecionando Registros..."
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera Arqiuvo Temporario                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Notas de Saida                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Busca filtro do usuario do SF2
	If len(oReport:Section(3):GetAdvplExp("SF2")) > 0
		cFilSF2 := oReport:Section(3):GetAdvplExp("SF2")
	EndIf
	// Busca filtro do usuario do SD2
	If len(oReport:Section(3):GetAdvplExp("SD2")) > 0
		cFilSD2 := oReport:Section(3):GetAdvplExp("SD2")
	EndIf

	dbSelectArea(cAliasSD2)
	dbGoTop()
	oReport:SetMeter(RecCount())
	While !oReport:Cancel() .And. !(cAliasSD2)->(Eof()) .And. D2_FILIAL == xFilial("SD2")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica vendedor no SF2                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbselectarea(cAliasSF2)
		dbSeek(xFilial("SF2")+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)

		// Verifica filtro do usuario
		If !Empty(cFilSF2) .And. !(&cFilSF2)
			dbSelectArea(cAliasSD2)
			dbSkip()
			Loop
		EndIf	


		For nCntFor := 1 To nVend
			cVendedor := (cAliasSF2)->(FieldGet((cAliasSF2)->(FieldPos("F2_VEND"+cVend))))
			If cVendedor >= mv_par09 .and. cVendedor <= mv_par10
				lVend := .T.
				Exit
			EndIf
			cVend := Soma1(cVend,1)
		Next nCntFor
		cVend := "1"

		If lVend
			dbSelectArea("TRB")
			Reclock("TRB",.T.)
			Replace TRB->D2_FILIAL  With (cAliasSD2)->D2_FILIAL
			Replace TRB->D2_COD     With (cAliasSD2)->D2_COD
			Replace TRB->D2_LOCAL   With (cAliasSD2)->D2_LOCAL
			Replace TRB->D2_SERIE   With (cAliasSD2)->D2_SERIE
			Replace TRB->D2_TES     With (cAliasSD2)->D2_TES
			Replace TRB->D2_TP      With (cAliasSD2)->D2_TP
			Replace TRB->D2_GRUPO   With (cAliasSD2)->D2_GRUPO
			Replace TRB->D2_CONTA   With (cAliasSD2)->D2_CONTA
			Replace TRB->D2_EMISSAO With (cAliasSD2)->D2_EMISSAO
			Replace TRB->D2_TIPO    With (cAliasSD2)->D2_TIPO
			Replace TRB->D2_DOC     With (cAliasSD2)->D2_DOC
			Replace TRB->D2_QUANT   With (cAliasSD2)->D2_QUANT

			if cPaisloc<>"BRA" // Localizado para imprimir o IVA 24/05/00
				Replace TRB->D2_PRCVEN  With (cAliasSD2)->D2_PRCVEN
				Replace TRB->D2_TOTAL   With (cAliasSD2)->D2_TOTAL

				aImpostos:=TesImpInf((cAliasSD2)->D2_TES)

				For nY:=1 to Len(aImpostos)
					cCampImp:=(cAliasSD2) + "->" + (aImpostos[nY][2])
					If ( aImpostos[nY][3]=="1" )
						nImpInc     += &cCampImp
					EndIf
				Next

				Replace TRB->D2_VALImP1  With nImpInc
				nImpInc:=0
			else
				If (cAliasSD2)->D2_TIPO <> "P" //Complemento de IPI
					Replace TRB->D2_PRCVEN  With (cAliasSD2)->D2_PRCVEN
					Replace TRB->D2_TOTAL   With (cAliasSD2)->D2_TOTAL
				Endif
				Replace TRB->D2_VALIPI  With (cAliasSD2)->D2_VALIPI
			endif

			Replace TRB->D2_ITEM    With (cAliasSD2)->D2_ITEM
			Replace TRB->D2_CLIENTE With (cAliasSD2)->D2_CLIENTE
			Replace TRB->D2_LOJA    With (cAliasSD2)->D2_LOJA

			//--------- Grava a moeda/taxa da nota para a conversao durante a impressao
			Replace TRB->D2_MOEDA   With (cAliasSF2)->F2_MOEDA
			Replace TRB->D2_TXMOEDA With (cAliasSF2)->F2_TXMOEDA

			MsUnlock()
			lVend := .F.
		EndIf
		dbSelectArea(cAliasSD2)
		dbSkip()
		oReport:IncMeter()

	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nota de Devolucao                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par04 == 2

		SF1->(dbsetorder(1))

		dbSelectArea(cAliasSD1)
		dbGoTop()
		oReport:SetMeter(RecCount())
		While !oReport:Cancel() .And. !(cAliasSD1)->(Eof()) .And. D1_FILIAL == xFilial("SD1")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica nota fiscal de origem e vendedor no SF2             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbselectarea(cAliasSF2)
			dbseek(xFilial()+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)

			// Verifica filtro do usuario
			If !Empty(cFilSF2) .And. !(&cFilSF2)
				dbSelectArea(cAliasSD1)
				dbSkip()
				Loop
			EndIf	

			// Verifica filtro do usuario no SD2     
			If !Empty(cFilSD2)
				dbSelectArea("SD2")
				dbSetOrder(3)
				If dbseek(xFilial()+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
					If !(&cFilSD2)
						dbSelectArea(cAliasSD1)
						dbSkip()
						Loop
					EndIf	
				EndIf	
			EndIf	

			For nCntFor := 1 To nVend
				cVendedor := (cAliasSF2)->(FieldGet((cAliasSF2)->(FieldPos("F2_VEND"+cVend))))
				If cVendedor >= mv_par09 .and. cVendedor <= mv_par10
					lVend := .T.
					Exit
				EndIf
				cVend := Soma1(cVend,1)
			Next nCntFor
			cVend := "1"

			If lVend
				SF1->(dbseek((cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))
				dbSelectArea("TRB")
				Reclock("TRB",.T.)
				Replace TRB->D2_FILIAL	With (cAliasSD1)->D1_FILIAL
				Replace TRB->D2_COD 	With (cAliasSD1)->D1_COD
				Replace TRB->D2_LOCAL 	With (cAliasSD1)->D1_LOCAL
				Replace TRB->D2_SERIE 	With If(mv_par12==1,(cAliasSD1)->D1_SERIORI,(cAliasSD1)->D1_SERIE)
				Replace TRB->D2_TES 	With (cAliasSD1)->D1_TES
				Replace TRB->D2_TP 		With (cAliasSD1)->D1_TP
				Replace TRB->D2_GRUPO 	With (cAliasSD1)->D1_GRUPO
				Replace TRB->D2_CONTA 	With (cAliasSD1)->D1_CONTA
				Replace TRB->D2_EMISSAO With (cAliasSD1)->D1_DTDIGIT
				Replace TRB->D2_TIPO 	With (cAliasSD1)->D1_TIPO
				Replace TRB->D2_DOC 	With If(mv_par12==1,(cAliasSD1)->D1_NFORI,(cAliasSD1)->D1_DOC)
				Replace TRB->D2_QUANT 	With -(cAliasSD1)->D1_QUANT
				Replace TRB->D2_TOTAL 	With -((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)

				If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
					Replace TRB->D2_VALIMP1 With - (cAliasSD1)->D1_VALIMP1
				Else
					Replace TRB->D2_VALIPI With - (cAliasSD1)->D1_VALIPI
				Endif

				Replace TRB->D2_ITEM 	With (cAliasSD1)->D1_ITEM
				Replace TRB->D2_CLIENTE With (cAliasSD1)->D1_FORNECE
				Replace TRB->D2_LOJA 	With (cAliasSD1)->D1_LOJA

				//--------- Grava a moeda/taxa da nota para a conversao durante a impressao
				Replace TRB->D2_MOEDA   With SF1->F1_MOEDA
				Replace TRB->D2_TXMOEDA With SF1->F1_TXMOEDA

				MsUnlock()
				lVend := .F.
			EndIf
			dbSelectArea(cAliasSD1)
			dbSkip()
			oReport:IncMeter()
		EndDo
	EndIf


	dbSelectArea("TRB")
	dbGoTop()
	oReport:Section(1):Init()
	oReport:SetMeter(RecCount())  														// Total de Elementos da regua
	While !oReport:Cancel() .And. !TRB->(Eof()) .And. lImprime

		cColuna := TRB->D2_DOC + "/" + TRB->D2_SERIE
		cTexto	:= ""
		If oReport:Section(1):GetOrder() = 1 .Or. oReport:Section(1):GetOrder() = 6	// Por Tes
			dbSelectArea("SF4")
			dbSeek(xFilial()+TRB->D2_TES)
			dbSelectArea("TRB")

			&& Personalização Makeni
			aSX513 := FWGetSX5("13",SF4->F4_CF)  

			If mv_par07 == 1															// Analitico
				cTexto  := "TES: " + TRB->D2_TES + " - "+ IF(len(aSX513) > 0 , ALLTRIM(aSX513[1][4]) , SF4->F4_TEXTO )
			Else																		// Sintetico
				cColuna := TRB->D2_TES + " - " +  IF(len(aSX513) > 0 , ALLTRIM(aSX513[1][4]) , SF4->F4_TEXTO )
			EndIf
			dbSelectArea("TRB")
			cCpo := TRB->D2_TES
		Elseif oReport:Section(1):GetOrder() = 2					   					// Por Tipo
			If mv_par07 == 1															// Analitico
				cTexto  := "TIPO DE PRODUTO: " + TRB->D2_TP
			Else																		// Sintetico
				cColuna := TRB->D2_TP
			EndIf
			cCpo := TRB->D2_TP		
		Elseif oReport:Section(1):GetOrder() = 3										// Por Grupo
			dbSelectArea("SBM")
			dbSeek(xFilial()+TRB->D2_GRUPO)
			dbSelectArea("TRB")
			If mv_par07 == 1															// Analitico
				cTexto  := "GRUPO: " + TRB->D2_GRUPO + " - " + SBM->BM_DESC 
			Else																		// Sintetico
				cColuna := TRB->D2_GRUPO + " - " + SBM->BM_DESC
			EndIf
			cCpo := TRB->D2_GRUPO		
		Elseif oReport:Section(1):GetOrder() = 4		  								// Por Conta Contabil
			dbSelectArea("SI1")
			dbSetOrder(1)
			dbSeek(xFilial()+TRB->D2_CONTA)
			dbSelectArea("TRB")		
			If mv_par07 == 1															// Analitico
				cTexto  := "CONTA: " + TRB->D2_CONTA + SI1->I1_DESC
			Else																		// Sintetico
				cColuna := TRB->D2_CONTA
			EndIf           
			cCpo := TRB->D2_CONTA
		Else																			// Por Produto
			If mv_par07 == 1															// Analitico
				cTexto  := "PRODUTO: " + TRB->D2_COD
			Else																		// Sintetico
				cColuna := TRB->D2_COD
			EndIf
			dbSelectArea("TRB")
			cCpo := TRB->D2_COD
		Endif
		cCampo 	:= "cCpo"
		nQuant	:=0;nTotal:=0;nValIpi:=0
		nQuant1	:=0;nTotal1:=0;nValIpi1:=0

		If mv_par07 == 1			// Analitico
			oReport:PrintText(cTexto)
		EndIf

		dbSelectArea("TRB")
		While &cCampo = &cVaria .And. !Eof() .And. lImprime

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trato a Devolu‡„o de Vendas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nDevQtd	:=0;nDevVal:=0;nDevIPI:=0
			nDevQtd1:=0;nDevVal1:=0;

			If mv_par04 == 1  //Devolucao pela NF Original
				CalcDevR4(cDupli,cEstoq)
			EndIf

			dbSelectArea("TRB")
			If AvalTes(TRB->D2_TES,cEstoq,cDupli)
				oReport:Section(1):Cell("NQUANT"	):Show()
				oReport:Section(1):Cell("NTOTAL"	):Show()
				oReport:Section(1):Cell("NVALIPI"	):Show()

				If mv_par07 == 1		// Analitico
					oReport:Section(1):Cell("NPRCVEN"	):Show()
					oReport:Section(1):Cell("NQUANT1"	):Hide()
					oReport:Section(1):Cell("NPRCVEN1"	):Hide()
					oReport:Section(1):Cell("NTOTAL1"	):Hide()
					oReport:Section(1):Cell("NVALIPI1"	):Hide()

					cColuna := TRB->D2_DOC + "/" + TRB->D2_SERIE
					nQuant 	:= TRB->D2_QUANT - nDevQtd
					nTotal 	:= xMoeda(TRB->D2_TOTAL,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA)  - nDevVal
					nQuant1 := nPrcVen1 := nTotal1 := nValIPI1 := 0
				Else					// Sintetico
					oReport:Section(1):Cell("NPRCVEN"	):Hide()
					oReport:Section(1):Cell("NQUANT1"	):Show()
					oReport:Section(1):Cell("NPRCVEN1"	):Hide()
					oReport:Section(1):Cell("NTOTAL1"	):Show()
					oReport:Section(1):Cell("NVALIPI1"	):Show()

					nQuant 	+= (TRB->D2_QUANT - nDevQtd)
					nTotal 	+= (xMoeda(TRB->D2_TOTAL,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA)  - nDevVal)
				EndIf	

				nPrcVen := xMoeda(TRB->D2_PRCVEN,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA)
				If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
					nValIPI  += xMoeda(TRB->D2_VALIMP1,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA)  - nDevIpi
				Else
					nValIPI  += xMoeda(TRB->D2_VALIPI ,1,mv_par08,TRB->D2_EMISSAO) -  nDevIpi
				Endif

				If mv_par07 == 1				// Analitico
					If cPaisloc<>"BRA"			// Localizado para imprimir o IVA 24/05/00
						nValIPI := xMoeda(TRB->D2_VALIMP1 ,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA) - nDevIpi
					Else
						nValIPI :=  xMoeda(TRB->D2_VALIPI,1,mv_par08,TRB->D2_EMISSAO)- nDevIpi
					Endif
				EndIf

			Else

				If mv_par07 == 1		// Analitico
					oReport:Section(1):Cell("NQUANT"	):Hide()
					oReport:Section(1):Cell("NTOTAL"	):Hide()
					oReport:Section(1):Cell("NVALIPI"	):Hide()
					oReport:Section(1):Cell("NPRCVEN1"	):Show()				

					cColuna := TRB->D2_DOC + "/" + TRB->D2_SERIE
					nQuant1 := TRB->D2_QUANT - nDevQtd1
					nQuant := nPrcVen := nTotal := nValIPI := 0
				Else	
					oReport:Section(1):Cell("NQUANT"	):Show()
					oReport:Section(1):Cell("NTOTAL"	):Show()
					oReport:Section(1):Cell("NVALIPI"	):Show()
					oReport:Section(1):Cell("NPRCVEN1"	):Hide()

					nQuant1 += (TRB->D2_QUANT - nDevQtd1)
				EndIf
				oReport:Section(1):Cell("NPRCVEN"	):Hide()
				oReport:Section(1):Cell("NQUANT1"	):Show()			
				oReport:Section(1):Cell("NTOTAL1"	):Show()
				oReport:Section(1):Cell("NVALIPI1"	):Show()

				If D2_TIPO <> "P" //Complemento de IPI
					nTotal1  += xMoeda(TRB->D2_TOTAL,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA) - nDevVal1
				EndIf

				If cPaisloc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
					nValIPI1 += xMoeda(TRB->D2_VALIMP1,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA) - nDevIpi
				Else
					nValIPI1 += xMoeda(TRB->D2_VALIPI,1,mv_par08,TRB->D2_EMISSAO) - nDevIpi
				Endif

				If mv_par07 == 1				// Analitico
					If D2_TIPO <> "P" //Complemento de IPI
						nPrcVen1 := xMoeda(TRB->D2_PRCVEN,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA) 		
						nTotal1  := xMoeda(TRB->D2_TOTAL,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA)- nDevVal1
					Else
						nPrcVen1 := 0
						nTotal1  := 0
					EndIf

					If cPaisloc<>"BRA" // Localizado para imprimir o IVA 24/05/00
						nValIPI1 := xMoeda(TRB->D2_VALIMP1,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO,nDecs+1,TRB->D2_TXMOEDA) - nDevIpi 
					Else
						nValIPI1 := xMoeda(TRB->D2_VALIPI,TRB->D2_MOEDA,mv_par08,TRB->D2_EMISSAO) - nDevIpi 
					Endif
				EndIf
			EndIf

			If mv_par07 == 1		// Analitico
				oReport:Section(1):PrintLine()			
			EndIf	

			dbSelectArea("TRB")
			dbSkip()
			oReport:IncMeter()

		End

		If mv_par07 == 1		// Analitico
			oReport:Section(1):SetTotalText("TOTAL" + " " + AllTrim(RetTitle(cVaria)) + " " + &cCampo)		// "TOTAL"
			oReport:Section(1):Finish()
			oReport:Section(1):Init()
		Else
			oReport:Section(1):PrintLine()			
			oReport:ThinLine()
		EndIf	


		dbSelectArea("TRB")
	End

	oReport:Section(1):SetPageBreak()

	#IFDEF TOP
	If mv_par04 # 3
		(cAliasSD1)->(dbCloseArea())
	EndIf
	(cAliasSF2)->(dbCloseArea())
	(cAliasSD2)->(dbCloseArea())
	#ELSE
	dbSelectArea("SD1")
	dbClearFilter()
	dbSetOrder(1)
	dbSelectArea("SD2")
	dbClearFilter()
	dbSetOrder(1)
	dbSelectArea("SF2")
	dbClearFilter()
	dbSetOrder(1)
	#ENDIF
	TRB->(dbCloseArea())

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CalcDevR4³ Autor ³     Marcos Simidu     ³ Data ³ 17.02.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo de Devolucoes                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR660                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcDevR4(cDup,cEst)

	dbSelectArea("SD1")
	If dbSeek(xFilial()+TRB->D2_COD+TRB->D2_SERIE+TRB->D2_DOC+TRB->D2_ITEM)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Soma Devolucoes          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->D2_CLIENTE+TRB->D2_LOJA == D1_FORNECE+D1_LOJA
			If !(D1_ORIGLAN == "LF")
				If AvalTes(D1_TES,cEst,cDup)
					If AvalTes(D1_TES,cEst) .And. (cEst == "S" .Or. cEst == "SN" )
						nDevQtd+= D1_QUANT
					Endif
					nDevVal +=xMoeda((D1_TOTAL-D1_VALDESC),TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
					If cPaisLoc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
						nDevipi += xMoeda(D1_VALIMP1,TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
					Else
						nDevipi += xMoeda(D1_VALIPI,1,mv_par08,D1_DTDIGIT)
					Endif
				Else
					If AvalTes(D1_TES,cEst) .And. (cEst == "S" .Or. cEst == "SN" )
						nDevQtd1+= D1_QUANT
					Endif
					nDevVal1 +=xMoeda((D1_TOTAL-D1_VALDESC),TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
				Endif
			Endif
		Endif
	Endif
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CalcDev  ³ Autor ³     Marcos Simidu     ³ Data ³ 17.02.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo de Devolucoes                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR660                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcDev(cDup,cEst)

	dbSelectArea("SD1")
	If dbSeek(xFilial()+TRB->D2_COD+TRB->D2_SERIE+TRB->D2_DOC+TRB->D2_ITEM)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Soma Devolucoes          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->D2_CLIENTE+TRB->D2_LOJA == D1_FORNECE+D1_LOJA
			If !(D1_ORIGLAN == "LF")
				If AvalTes(D1_TES,cEst,cDup)
					If AvalTes(D1_TES,cEst) .And. (cEst == "S" .Or. cEst == "SN" )
						nDevQtd1+= D1_QUANT
					Endif
					nDevVal1 +=xMoeda((D1_TOTAL-D1_VALDESC),TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
					If cPaisLoc<>"BRA"  // Localizado para imprimir o IVA 24/05/00
						nDevipi += xMoeda(D1_VALIMP1,TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
					Else
						nDevipi += xMoeda(D1_VALIPI,1,mv_par08,D1_DTDIGIT)
					Endif

				Else
					If AvalTes(D1_TES,cEst) .And. (cEst == "S" .Or. cEst == "SN" )
						nDevQtd2+= D1_QUANT
					Endif
					nDevVal2 +=xMoeda((D1_TOTAL-D1_VALDESC),TRB->D2_MOEDA,mv_par08,D1_DTDIGIT,nDecs+1,TRB->D2_TXMOEDA)
				Endif
			Endif
		Endif
	Endif
Return .T.