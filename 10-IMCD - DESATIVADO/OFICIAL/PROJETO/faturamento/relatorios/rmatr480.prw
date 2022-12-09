#INCLUDE "PROTHEUS.CH"
#define STR0001 "Este programa ira emitir o Relatorio de Materiais"
#define STR0002 "de Terceiros em nosso poder e/ou nosso Material em"
#define STR0003 "poder de Terceiros."
#define STR0004 " Produto/Armazem    "
#define STR0005 " Cliente/Fornecedor "
#define STR0006 " Dt. Mov/Produto "
#define STR0007 "Zebrado"
#define STR0008 "Administracao"
#define STR0009 "Relacao de materiais de Terceiros e em Terceiros"
#define STR0010 "RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - PRODUTO/ARMAZEM"
#define STR0011 "RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - PRODUTO/ARMAZEM"
#define STR0012 "RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - PRODUTO/ARMAZEM"
#define STR0013 "            Cliente /        Loja  -  Documento  - Data de  Unid.de ---------------------- Quantidade ------------------- --------------- Valores -----------   Custo Prod. TM  Segunda    Quantidade      Data    Dt Ult."
#define STR0014 "            Fornecedor              Numero  Serie  Emissao   Medida          Original      Ja' entregue             Saldo    Total N.Fiscal   Total Devolvido    na Moeda "
#define STR0015 ""
#define STR0016 "CANCELADO PELO OPERADOR"
#define STR0017 "PRODUTO/ARMAZEM: "
#define STR0018 "Clie:"
#define STR0019 "Fornec.:"
#define STR0020 "TOTAL DESTE PRODUTO/ARMAZEM ------ >"
#define STR0021 "T O T A L    G E R A L  ---------- >"
#define STR0022 " Criando Indice ...    "
#define STR0023 "RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - CLIENTE / FORNECEDOR"
#define STR0024 "RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - CLIENTE / FORNECEDOR"
#define STR0025 "RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - CLIENTE / FORNECEDOR"
#define STR0026 "                 -    Documento    -  Data de         Unid. de ---------------------- Quantidade ---------------------  ------------ Valores --------------  Custo do Prod. TM  Segunda   Quantidade     Data   Data da Ult."
#define STR0027 "Produto          Numero        Serie  Emissao  Armaz.  Medida           Original       Ja' entregue              Saldo  Total Nota Fiscal   Total Devolvido    na Moeda "
#define STR0028 "CLIENTE / LOJA: "
#define STR0029 "FORNECEDOR / LOJA: "
#define STR0030 "CLIENTE ---->"
#define STR0031 "FORNECEDOR --->"
#define STR0032 "TOTAL DO PRODUTO NO "
#define STR0033 "RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - DATA DO MOVIMENTO"
#define STR0034 "RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - DATA DO MOVIMENTO"
#define STR0035 "RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - DATA DO MOVIMENTO"
#define STR0036 "         Cliente /                             -   Documento   - Data de       UM --------------------- Quantidade ----------------- ------------ Valores ------------ Custo Produto TM Seg. Quantidade -       Data       -"
#define STR0037 "         Fornec.          Loja Produto         Numero      Serie Emissao  Armazem         Original     Ja' entregue            Saldo Total Nota Fiscal Total Devolvido  na Moeda "
#define STR0038 "DATA DE MOVIMENTACAO : "
#define STR0039 "Forn:"
#define STR0040 "TOTAL DO PRODUTO NA DATA --------- >"
#define STR0041 "Notas Fiscais de Retorno"
#define STR0042 "Quantidade"
#define STR0043 "Original"
#define STR0044 "Ja entregue"
#define STR0045 "Saldo"
#define STR0046 "Total"
#define STR0047 "N.Fiscal"
#define STR0048 "Devolvido"
#define STR0049 "Custo"
#define STR0050 "Prod."
#define STR0051 "TM"
#define STR0052 "Produto / Fornecedor"
#define STR0053 "Saldo em Poder de Terceiros"
#define STR0054 "Saldo em Poder de Terceiros (Retorno)"
#define STR0055 "            Cliente /        Loja  -  Documento         - Data de  Unid.de ---------------------- Quantidade ------------------- --------------- Valores -----------   Custo Prod. TM  2a  Quantidade      Data    Dt Ult."
#define STR0056 "            Fornecedor              Numero         Serie  Emissao   Medida          Original      Ja' entregue             Saldo    Total N.Fiscal   Total Devolvido    na Moeda "
#define STR0057 "                 -    Documento           -  Data de         Unid. de ---------------------- Quantidade ---------------------  ------------ Valores --------------  Custo do Prod. TM 2a. Quantidade     Data   Data da Ult."
#define STR0058 "Produto          Numero               Serie  Emissao  Armaz.  Medida           Original       Ja' entregue              Saldo  Total Nota Fiscal   Total Devolvido    na Moeda "
#define STR0059 "  Cliente/Fornec.         Loja          -   Documento          - Data de       UM --------------------- Quantidade ----------------- ------------ Valores ------------ Custo Produto TM Seg. Quantidade -       Data       -"
#define STR0060 "                        Produto         Numero             Serie Emissao  Armazem         Original     Ja' entregue            Saldo Total Nota Fiscal Total Devolvido  na Moeda "
#define STR0061 "UM"
#define STR0062 "2a.UM"
#define STR0063 "     Un.Med.       Seg. UM    Lancto    Entrega"
#define STR0064 "       Unid. Med.   Seg. UM  Lancamento  Entrega"
#define STR0065 "      UM    Seg. UM   Lancamento   Entrega"
#define STR0066 "     UM     Seg. UM    Lancto    Entrega"
#define STR0067 "      UM        Seg. UM  Lancamento  Entrega"
#define STR0068 "      UM    Seg. UM   Lancamento   Entrega"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR480  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 16.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Controle de Materiais de Terceiros em nosso po-³±±
±±³          ³der e nosso Material em poder de Terceiros.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR480(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RMatr480()
	Local oReport

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RMatr480" , __cUserID )

	If FindFunction("TRepInUse") .And. TRepInUse()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport := ReportDef()
		oReport:PrintDialog()
	Else
		MATR480R3()
	EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³16.06.2006³±±
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
Static Function ReportDef(nReg)

	Local cAliasQry := GetNextAlias()
	Local oReport 
	Local oSection1
	Local oSection2 
	Local oSection3 
	Local oCell         
	Local aOrdem := {}
	Local cTamVal:= TamSX3('B6_CUSTO1' )[1]
	Local cTamQtd:= TamSX3('B6_QUANT' )[1]

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
	oReport:= TReport():New("MATR480",STR0009,"MTR480", {|oReport| ReportPrint(oReport,cAliasQry)},STR0001+" "+STR0002+" "+STR0003) //"Relacao de materiais de Terceiros e em Terceiros"##"Este programa ira emitir o Relatorio de Materiais"##"de Terceiros em nosso poder e/ou nosso Material em"##"poder de Terceiros."
	oReport:SetLandscape()    
	oReport:SetTotalInLine(.F.)

	Pergunte("MTR480",.F.)

	//Aadd( aOrdem, STR0004 ) //" Produto/Local " 
	Aadd( aOrdem, STR0005 ) //" Cliente/Fornecedor " 
	//Aadd( aOrdem, STR0006 ) //" Dt. Mov/Produto " 

	oSection1 := TRSection():New(oReport,STR0052,{"SB6"},aOrdem) //"Relacao de materiais de Terceiros e em Terceiros"
	oSection1 :SetTotalInLine(.F.)

	TRCell():New(oSection1,"B1_COD","SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_DESC","SB1",/*Titulo*/,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B6_LOCAL","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"cCliFor","   ",/*Titulo*/,/*Picture*/,6,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"cLoja","   ",/*Titulo*/,/*Picture*/,2,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"cNome","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	oSection1:Cell("cNome"):GetFieldInfo("A2_NOME")
	TRCell():New(oSection1,"B6_EMISSAO","SB6",STR0038,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"DATA DE MOVIMENTACAO : "

	oSection2 := TRSection():New(oSection1,STR0053,{"SB6"}) //"Relacao de materiais de Terceiros e em Terceiros"
	oSection2 :SetTotalInLine(.F.)
	oSection2 :SetHeaderPage()

	TRCell():New(oSection2,"B6_PRODUTO","SB6",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B6_TPCF","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIf(SB6->B6_TPCF == "C",STR0018,STR0019) })
	TRCell():New(oSection2,"B6_CLIFOR","SB6",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B6_LOJA","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B6_DOC","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B6_SERIE","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B6_EMISSAO","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B6_UM","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,SB6->B6_SEGUM,SB6->B6_UM) })
	TRCell():New(oSection2,"B6_QUANT","SB6",STR0042+CRLF+STR0043,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,SB6->B6_QUANT,0,2),SB6->B6_QUANT) }) //"Quantidade"##"Original"
	TRCell():New(oSection2,"nQuJe","   ",STR0042+CRLF+STR0044,PesqPict("SB6","B6_QUANT",17),cTamQtd,/*lPixel*/,/*{|| code-block de impressao }*/) //"Quantidade"##"Ja entregue"				
	TRCell():New(oSection2,"nSaldo","   ",STR0045,PesqPict("SB6", "B6_QUANT",17),cTamQtd,/*lPixel*/,/*{|| code-block de impressao }*/) //"Saldo"
	TRCell():New(oSection2,"nTotNF","   ",STR0046+CRLF+STR0047,'@E 99,999,999,999.99',cTamVal,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"N.Fiscal"
	TRCell():New(oSection2,"nTotDev","   ",STR0046+CRLF+STR0048,'@E 99,999,999,999.99',cTamVal,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"Devolvido"
	TRCell():New(oSection2,"nCusto","   ",STR0049+CRLF+STR0050,'@E 999,999,999.99',cTamVal,/*lPixel*/,/*{|| code-block de impressao }*/) //"Custo"##"Prod."
	TRCell():New(oSection2,"B6_TIPO","SB6",STR0051,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIF(SB6->B6_TIPO=="D","D","E") }) //"TM"
	TRCell():New(oSection2,"B6_SEGUM","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B6_QTSEGUM","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B6_DTDIGIT","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)				
	TRCell():New(oSection2,"B6_UENT","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	TRFunction():New(oSection2:Cell("B6_QUANT"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 
	TRFunction():New(oSection2:Cell("nQuJe"),NIL,"SUM",/*oBreak*/,/*Titulo*/,PesqPict("SB6","B6_QUANT",17),/*uFormula*/,.T.,.T.,,oSection1)
	TRFunction():New(oSection2:Cell("nSaldo"),NIL,"SUM",/*oBreak*/,/*Titulo*/,PesqPict("SB6","B6_QUANT",17),/*uFormula*/,.T.,.T.,,oSection1)
	TRFunction():New(oSection2:Cell("nTotNF"),NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 99,999,999,999.99',/*uFormula*/,.T.,.T.,,oSection1)
	TRFunction():New(oSection2:Cell("nTotDev"),NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 99,999,999,999.99',/*uFormula*/,.T.,.T.,,oSection1)
	TRFunction():New(oSection2:Cell("nCusto"),NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 999,999,999.99',/*uFormula*/,.T.,.T.,,oSection1)

	oSection3 := TRSection():New(oSection2,STR0054,{"SB6"}) //"Relacao de materiais de Terceiros e em Terceiros"
	oSection3 :SetTotalInLine(.F.)

	TRCell():New(oSection3,"B6_PRODUTO","SB6",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B6_TPCF","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIf(SB6->B6_TPCF == "C",STR0018,STR0019) })
	TRCell():New(oSection3,"B6_CLIFOR","SB6",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B6_LOJA","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B6_DOC","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B6_SERIE","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B6_EMISSAO","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B6_UM","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,SB6->B6_SEGUM,SB6->B6_UM) })
	TRCell():New(oSection3,"B6_QUANT","SB6",STR0042+CRLF+STR0043,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,SB6->B6_QUANT,0,2),SB6->B6_QUANT) }) //"Quantidade"##"Original"
	TRCell():New(oSection3,"nQuJe","   ",STR0042+CRLF+STR0044,PesqPict("SB6","B6_QUANT",17),cTamQtd,/*lPixel*/,/*{|| code-block de impressao }*/) //"Quantidade"##"Ja entregue"				
	TRCell():New(oSection3,"nSaldo","   ",STR0045,PesqPict("SB6", "B6_QUANT",17),cTamQtd,/*lPixel*/,/*{|| code-block de impressao }*/) //"Saldo"
	TRCell():New(oSection3,"nTotNF","   ",STR0046+CRLF+STR0047,'@E 99,999,999,999.99',cTamVal,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"N.Fiscal"
	TRCell():New(oSection3,"nTotDev","   ",STR0046+CRLF+STR0048,'@E 99,999,999,999.99',cTamVal,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"Devolvido"
	TRCell():New(oSection3,"nCusto","   ",STR0049+CRLF+STR0050,'@E 999,999,999.99',cTamVal,/*lPixel*/,/*{|| code-block de impressao }*/) //"Custo"##"Prod."
	TRCell():New(oSection3,"B6_TIPO","SB6",STR0051,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIF(SB6->B6_TIPO=="D","D","E") }) //"TM"
	TRCell():New(oSection3,"B6_SEGUM","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B6_QTSEGUM","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B6_DTDIGIT","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)				
	TRCell():New(oSection3,"B6_UENT","SB6",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
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

	Local oSection1 := oReport:Section(1) 
	Local oSection2 := oReport:Section(1):Section(1)  
	Local oSection3 := oReport:Section(1):Section(1):Section(1)  
	Local nOrdem    := oReport:Section(1):GetOrder() 
	Local cFilter   :=""
	Local lListCustM:= .T.
	Local lCusFIFO  := GetMV('MV_CUSFIFO')
	Local cProdLOCAL:= ""
	Local cCliFor   := ""
	Local cNomeCliFor:=""                     
	Local cCliForAnt:= ""
	Local lImprime  := .F.
	lListCustM := (mv_par16==1)


	If Len(oReport:ASECTION[1]:AUSERFILTER)<>0
		cFilter:=oReport:ASECTION[1]:AUSERFILTER[1][2]
	Endif

	nOrdem:=2 // Ajustes a Makeni

	If nOrdem == 1
		oSection1 :SetTotalText(STR0020) //"TOTAL DESTE PRODUTO / LOCAL ------ >"
		If mv_par10 == 1
			oReport:SetTitle(STR0010) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - PRODUTO / LOCAL"
		ElseIf mv_par10 == 2
			oReport:SetTitle(STR0011) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - PRODUTO / LOCAL"
		Else
			oReport:SetTitle(STR0012) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - PRODUTO / LOCAL"
		EndIf
	ElseIf nOrdem == 2
		oSection1 :SetTotalText(STR0032) //"TOTAL DO PRODUTO NO "
		If mv_par10 == 1
			oReport:SetTitle(STR0023) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - CLIENTE / FORNECEDOR"
		ElseIf mv_par10 == 2
			oReport:SetTitle(STR0024) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - CLIENTE / FORNECEDOR"
		Else
			oReport:SetTitle(STR0025) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - CLIENTE / FORNECEDOR"
		EndIf
	ElseIf nOrdem == 3
		oSection1 :SetTotalText(STR0040) //"TOTAL DO PRODUTO NA DATA --------- >"
		If mv_par10 == 1
			oReport:SetTitle(STR0033) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - DATA DO MOVIMENTO"
		ElseIf mv_par10 == 2
			oReport:SetTitle(STR0034) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - DATA DO MOVIMENTO"
		Else
			oReport:SetTitle(STR0035) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - DATA DO MOVIMENTO"
		EndIf
	Endif

	Do Case
		Case nOrdem == 1
		oSection1:Cell("cCliFor"):Disable()
		oSection1:Cell("cLoja"):Disable()
		oSection1:Cell("cNome"):Disable()
		oSection1:Cell("B6_EMISSAO"):Disable()
		oSection2:Cell("B6_PRODUTO"):Disable()
		oSection3:Cell("B6_PRODUTO"):Disable()
		Case nOrdem == 2

		oSection1:Cell("B1_COD"):Disable()
		oSection1:Cell("B1_DESC"):Disable()
		oSection1:Cell("B6_LOCAL"):Disable()
		oSection1:Cell("B6_EMISSAO"):Disable()

		oSection2:Cell("B6_TPCF"):Disable()
		oSection2:Cell("B6_CLIFOR"):Disable()
		oSection2:Cell("B6_LOJA"):Disable()		    

		oSection3:Cell("B6_TPCF"):Disable()
		oSection3:Cell("B6_CLIFOR"):Disable()
		oSection3:Cell("B6_LOJA"):Disable()

		Case nOrdem == 3
		oSection1:Cell("B1_COD"):Disable()
		oSection1:Cell("B1_DESC"):Disable()
		oSection1:Cell("B6_LOCAL"):Disable()
		oSection1:Cell("cCliFor"):Disable()
		oSection1:Cell("cLoja"):Disable()
		oSection1:Cell("cNome"):Disable()
	EndCase			

	lQuery	:= .T.  

	cWhere := ""
	If ! Empty(mv_par17)
		cWhere+=" AND SB6.B6_TES IN " + FormatIn(Alltrim(mv_par17),';')
	Endif

	cSql:="SELECT SB6.R_E_C_N_O_ RECNO, SB6.* "
	cSql+="FROM "+RETSQLNAME("SB6")+" SB6 , "+RETSQLNAME("SF4")+" SF4  "
	cSql+="WHERE SB6.B6_FILIAL = '"+xFilial("SB6") + "' AND "
	cSql+="SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.F4_CODIGO = SB6.B6_TES AND "
	cSql+="SF4.F4_PODER3 <> 'D' AND SB6.D_E_L_E_T_= ' '  AND SF4.D_E_L_E_T_ = ' ' "+cWhere
	cSql+=" ORDER BY SB6.B6_CLIFOR+SB6.B6_LOJA "

	If Select(cAliasQry) # 0
		(cAliasQry)->(E_EraseArq(cAliasQry)) 
	EndIf

	cSql := ChangeQuery(cSql)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cSql),cAliasQry, .F., .T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do fluxo do relatório                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter((cAliasQry)->(LastRec()))

	While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

		If oReport:Cancel()
			Exit
		EndIf

		oReport:IncMeter()

		SB6->(dbgoto( (cAliasQry)->RECNO) )

		If ! Empty(mv_par17) .and. !(sb6->b6_tes $ mv_par17)
			(cAliasQry)->(dbSkip())
			Loop
		Endif       

		SF4->(dbSeek(xFilial("SF4")+SB6->B6_TES))
		If SF4->F4_PODER3 == "D"
			(cAliasQry)->(dbSkip())
			Loop
		EndIf

		If SB6->B6_TPCF == "C"
			If SB6->B6_CLIFOR   < mv_par01 .Or. SB6->B6_CLIFOR  > mv_par02
				(cAliasQry)->(dbSkip())
				Loop
			EndIf
		Else
			If SB6->B6_CLIFOR   < mv_par03 .Or. SB6->B6_CLIFOR  > mv_par04
				(cAliasQry)->(dbSkip())
				Loop
			EndIf
		Endif	

		If	SB6->B6_PRODUTO < mv_par05 .Or. SB6->B6_PRODUTO > mv_par06 .Or.;
		SB6->B6_DTDIGIT < mv_par07 .Or. SB6->B6_DTDIGIT > mv_par08 .Or.;
		SB6->B6_QUANT == 0 
			(cAliasQry)->(dbSkip())
			Loop
		Endif	

		aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
		nSaldo  := aSaldo[1]
		nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])

		If mv_par09 == 2 .And. nSaldo <= 0
			(cAliasQry)->(dbSkip())
			Loop
		EndIf

		If mv_par09 == 2 .And. sb6->b6_saldo <= 0
			(cAliasQry)->(dbSkip())
			Loop
		EndIf

		If mv_par10 == 1 .And. SB6->B6_TIPO != "D"
			(cAliasQry)->(dbSkip())
			Loop
		ElseIf mv_par10 == 2 .And. SB6->B6_TIPO != "E"
			(cAliasQry)->(dbSkip())
			Loop
		EndIf

		If nOrdem == 1
			cQuebra := SB6->B6_PRODUTO+SB6->B6_LOCAL
		ElseIf nOrdem == 2
			cQuebra := (cAliasQry)->B6_CLIFOR+(cAliasQry)->B6_LOJA
		ElseIf nOrdem == 3
			cQuebra := Dtos(SB6->B6_EMISSAO)+SB6->B6_PRODUTO
			lImprime:= .T.
		Endif

		While ! oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. xFilial("SB6") == (cAliasQry)->B6_FILIAL ;
		.And. cQuebra == (cAliasQry)->B6_CLIFOR+(cAliasQry)->B6_LOJA

			If oReport:Cancel()
				Exit
			EndIf

			SB6->(dbgoto( (cAliasQry)->RECNO) )

			oReport:IncMeter()

			SF4->(dbSeek(xFilial("SF4")+SB6->B6_TES))
			If SF4->F4_PODER3 == "D"
				(cAliasQry)->(dbSkip())
				Loop
			EndIf

			If SB6->B6_TPCF == "C"
				If SB6->B6_CLIFOR   < mv_par01 .Or. SB6->B6_CLIFOR  > mv_par02
					(cAliasQry)->(dbSkip())
					Loop
				EndIf
			Else
				If SB6->B6_CLIFOR   < mv_par03 .Or. SB6->B6_CLIFOR  > mv_par04
					(cAliasQry)->(dbSkip())
					Loop
				EndIf
			Endif	

			If	SB6->B6_PRODUTO < mv_par05 .Or. SB6->B6_PRODUTO > mv_par06 .Or.;
			SB6->B6_DTDIGIT < mv_par07 .Or. SB6->B6_DTDIGIT > mv_par08 .Or.;
			SB6->B6_QUANT == 0 
				(cAliasQry)->(dbSkip())
				Loop
			Endif	

			aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
			nSaldo  := aSaldo[1]
			nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])

			If mv_par09 == 2 .And. nSaldo <= 0
				(cAliasQry)->(dbSkip())
				Loop
			EndIf

			If mv_par09 == 2 .And. sb6->b6_saldo <= 0
				(cAliasQry)->(dbSkip())
				Loop
			EndIf

			If mv_par10 == 1 .And. SB6->B6_TIPO != "D"
				(cAliasQry)->(dbSkip())
				Loop
			ElseIf mv_par10 == 2 .And. SB6->B6_TIPO != "E"
				(cAliasQry)->(dbSkip())
				Loop
			EndIf
			oSection1:Init()
			If nOrdem == 1
				If cProdLOCAL != SB6->B6_PRODUTO+SB6->B6_LOCAL
					If SB1->(dbSeek(xFilial("SB1")+SB6->B6_PRODUTO))
						oSection1:PrintLine()			
						cProdLOCAL := SB6->B6_PRODUTO+SB6->B6_LOCAL
					Else
						Help(" ",1,"R480PRODUT")
						dbSelectArea("SB6")
						Return .F.
					EndIf
				EndIf
				If !Empty(cProdLocal)
					oSection2:Init()

					oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
					oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
					oSection2:Cell("nTotNF"):SetValue(SB6->B6_QUANT * nPrUnit)
					oSection2:Cell("nTotDev"):SetValue((SB6->B6_QUANT-nSaldo) * nPrUnit)
					// Custo na Moeda
					nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
					oSection2:Cell("nCusto"):SetValue(nCusto)

					oSection2:PrintLine()
				Endif	
			ElseIf nOrdem == 2
				If cNomeCliFor != SB6->B6_CLIFOR+SB6->B6_LOJA
					If SB6->B6_TPCF == "C" 
						dbSelectArea("SA1")
						dbSeek(xFilial("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA)
						oSection1 :SetTotalText(STR0032+STR0030) //"TOTAL DO PRODUTO NO "##"CLIENTE ---->"###"FORNECEDOR --->"
					Else
						dbSelectArea("SA2")
						dbSeek(xFilial("SA2")+SB6->B6_CLIFOR+SB6->B6_LOJA)
						oSection1 :SetTotalText(STR0032+STR0031) //"TOTAL DO PRODUTO NO "##"FORNECEDOR --->"
					Endif	
					If Found()
						dbSelectArea("SB6")

						oSection1:Cell("cCliFor"):SetTitle(IIf(SB6->B6_TPCF == "C",STR0028,STR0029)) //"CLIENTE / LOJA: "###"FORNECEDOR / LOJA: "
						oSection1:Cell("cCliFor"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_COD,SA2->A2_COD))

						oSection1:Cell("cLoja"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_LOJA,SA2->A2_LOJA))
						oSection1:Cell("cNome"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_NOME,SA2->A2_NOME))

						oSection1:PrintLine()			

						cNomeCliFor := SB6->B6_CLIFOR+SB6->B6_LOJA
						cCliForAnt 	:= SB6->B6_TPCF
					Else
						Help(" ",1,"R480CLIFOR")
						RetIndex("SB6")
						dbSelectArea("SB6")
						dbSetOrder(1)
						cIndex += OrdBagExt()
						Ferase(cIndex)
						Return .F.
					EndIf
				EndIf
				If Len(cNomeCliFor) != 0
					oSection2:Init()

					oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
					oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
					oSection2:Cell("nTotNF"):SetValue(SB6->B6_QUANT * nPrUnit)
					oSection2:Cell("nTotDev"):SetValue((SB6->B6_QUANT-nSaldo) * nPrUnit)
					// Custo na Moeda
					nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'SB6->B6_CUSTO', 'SB6->B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
					oSection2:Cell("nCusto"):SetValue(nCusto)

					oSection2:PrintLine()
				Endif
			ElseIf nOrdem == 3
				If lImprime
					oSection1:PrintLine()			
					lImprime := .F.
				Endif	

				oSection2:Init()

				oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
				oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
				oSection2:Cell("nTotNF"):SetValue(SB6->B6_QUANT * nPrUnit)
				oSection2:Cell("nTotDev"):SetValue((SB6->B6_QUANT-nSaldo) * nPrUnit)
				// Custo na Moeda
				nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
				oSection2:Cell("nCusto"):SetValue(nCusto)

				oSection2:PrintLine()				
			Endif	
			// Lista as devolucoes da remessa
			If mv_par12 == 1 .And. ((SB6->B6_QUANT - nSaldo) > 0)
				aAreaSB6 := SB6->(GetArea())
				SB6->(dbSetOrder(3))
				cSeek:=xFilial("SB6")+SB6->B6_IDENT+SB6->B6_PRODUTO+"D"
				If sb6->(dbSeek(cSeek))
					oReport:PrintText(STR0041) //"Notas Fiscais de Retorno"
					Do While !Eof() .And. SB6->B6_FILIAL+SB6->B6_IDENT+SB6->B6_PRODUTO+SB6->B6_PODER3 == cSeek
						If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
							SB6->(dbSkip())
							Loop
						Endif
						oSection3:Init(.F.)
						If nOrdem == 2
							oSection3:Cell("B6_PRODUTO"):Hide()
						Endif	
						oSection3:Cell("nQuJe"):Hide()
						oSection3:Cell("nSaldo"):Hide()
						oSection3:Cell("nTotDev"):Hide()
						oSection3:Cell("nCusto"):Hide()

						oSection3:Cell("nTotNF"):SetValue(SB6->B6_QUANT * nPrUnit)
						oSection3:PrintLine()
						SB6->(dbSkip())
					EndDo
					oSection3:Finish()
				EndIf
				RestArea(aAreaSB6)
			EndIf					
			dbselectarea(cAliasQry)
			(cAliasQry)->(dbSkip())
		EndDo
		oSection1:Finish()
		oSection2:Finish()
	EndDo

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATR480R3 ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 12.05.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Controle de Materiais de Terceiros em nosso po-³±±
±±³          ³der e nosso Material em poder de Terceiros. (Antigo)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR480(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rodrigo     ³23/06/98³XXXXXX³Acerto no tamanho do documento para 12    ³±±
±±³            ³        ³      ³posicoes                                  ³±±
±±³Fernando J. ³08.12.98³3781A ³Substituir PesqPictQt por PescPict        ³±±
±±³CesarValadao³30/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±³CesarValadao³04/05/99³21554A³Manutencao Lay-Out P Imprimir Quant c/ 17 ³±±
±±³CesarValadao³12/08/99³21421A³Manutencao Lay-Out P Imprimir NF Retorno  ³±±
±±³            ³        ³      ³Alinhada a NF de Origem                   ³±±
±±³Patricia Sal³13/12/99³14655A³Validacao p/Data Digitacao nas Devolucoes ³±±
±±³            ³        ³      ³Incl. Param Dt.Inicial/Final na CalcTerc()³±±
±±³Patricia Sal³20/12/99³XXXXXX³Conversao dos Campos Fornec./Cliente p/   ³±±
±±³            ³        ³      ³(20 posicoes) e Loja p/ 4 posicoes.       ³±±
±±³Iuspa       ³06/12/00³      ³Data de/ate para devolucoes               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Matr480R3()
	LOCAL wnrel, nOrdem
	LOCAL Tamanho := "G"
	LOCAL cDesc1  := STR0001	//"Este programa ira emitir o Relatorio de Materiais"
	LOCAL cDesc2  := STR0002	//"de Terceiros em nosso poder e/ou nosso Material em"
	LOCAL cDesc3  := STR0003	//"poder de Terceiros."
	LOCAL cString := "SB6"
	LOCAL aOrd    := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006)}	//" Produto/Local "###" Cliente/Fornecedor "###" Dt. Mov/Produto "

	PRIVATE cCondCli, cCondFor
	PRIVATE aReturn := {OemToAnsi(STR0007), 1,OemToAnsi(STR0008), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
	PRIVATE nomeprog:= "MATR480"
	PRIVATE aLinha  := { },nLastKey := 0
	PRIVATE cPerg   := "MTR480"
	PRIVATE Titulo  := OemToAnsi(STR0009)	//"Relacao de materiais de Terceiros e em Terceiros"
	PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont
	PRIVATE lListCustM := .T.
	PRIVATE lCusFIFO   := GetMV('MV_CUSFIFO')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Utiliza variaveis static p/ Grupo de Fornec/Clientes(001) e de Loja(002)    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Static aTamSXG, aTamSXG2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CbTxt := SPACE(10)
	CbCont:= 00
	li	  := 80
	m_pag := 01

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica conteudo da variavel p/ Grupo de Clientes/Forneced.(001) e Loja(002) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
	aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("MTR480",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                                  ³
	//³ mv_par01   		// Cliente Inicial                		              ³
	//³ mv_par02        // Cliente Final                       	              ³
	//³ mv_par03        // Fornecedor Inicial                     	          ³
	//³ mv_par04        // Fornecedor Final                          	      ³
	//³ mv_par05        // Produto Inicial                              	  ³
	//³ mv_par06        // Produto Final                         		      ³
	//³ mv_par07        // Data Inicial                              	      ³
	//³ mv_par08        // Data Final                                   	  ³
	//³ mv_par09        // Situacao   (Todos / Em aberto)                     ³
	//³ mv_par10        // Tipo   (De Terceiros / Em Terceiros / Ambos)		  ³
	//³ mv_par11        // Custo em Qual Moeda  (1/2/3/4/5)             	  ³
	//³ mv_par12        // Lista NF Devolucao  (Sim) (Nao)              	  ³
	//³ mv_par13        // Devolucao data de                            	  ³
	//³ mv_par14        // Devolucao data ate                           	  ³
	//³ mv_par15        // QTDE. na 2a. U.M.? Sim / Nao                       ³
	//³ mv_par16        // Lista Custo? Medio / Fifo                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define variaveis p/ filtrar arquivo.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCondCli := "B6_CLIFOR   <= mv_par02 .And. B6_CLIFOR  >= mv_par01 .And."+;
	" B6_PRODUTO <= mv_par06 .And. B6_PRODUTO >= mv_par05 .And."+;
	" B6_DTDIGIT <= mv_par08 .And. B6_DTDIGIT >= mv_par07 .And."+;
	" B6_QUANT   <> 0 "

	cCondFor := "B6_CLIFOR   <= mv_par04 .And. B6_CLIFOR  >= mv_par03 .And."+;
	" B6_PRODUTO <= mv_par06 .And. B6_PRODUTO >= mv_par05 .And."+;
	" B6_DTDIGIT <= mv_par08 .And. B6_DTDIGIT >= mv_par07 .And."+;
	" B6_QUANT   <> 0 "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SetPrint                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := "MATR480"

	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)

	If nLastKey == 27
		Return .T.
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return .T.
	Endif

	RptStatus({|lEnd| R480Imp(@lEnd,wnRel,cString,Tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R480IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 16.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR480			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R480Imp(lEnd,WnRel,cString,Tamanho)

	nTipo:=IIF(aReturn[4]==1,15,18)

	nOrdem := aReturn[8]

	lListCustM := (mv_par16==1)

	dbSelectArea("SB6")

	If nOrdem == 1
		R480Prod(lEnd,Tamanho)
	ElseIf nOrdem == 2
		R480CliFor(lEnd,Tamanho)
	ElseIf nOrdem == 3
		R480Data(lEnd,Tamanho)
	EndIf

	dbSelectArea("SB6")
	Set Filter To
	dbSetOrder(1)

	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R480Prod ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 12/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Por Ordem de Produto / LOCAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR480                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R480Prod(lEnd,Tamanho)
	LOCAL cCliFor, cProdLOCAL := ""
	LOCAL cQuebra,aSaldo:={}
	LOCAL nCusTot := nQuant := nQuJe := nTotal := nTotDev := nTotQuant := nTotQuJe := nTotSaldo := 0
	LOCAL nGerTot := nGerTotDev:=nGerCusTot:=0
	LOCAL nSaldo  := 0
	Local nCusto  := 0
	Local nPrUnit := 0
	LOCAL cSeek   := ""
	LOCAL aAreaSB6:= {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1
		titulo := STR0010		//"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - PRODUTO / LOCAL"
	ElseIf mv_par10 == 2
		titulo := STR0011		//"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - PRODUTO / LOCAL"
	Else
		titulo := STR0012		//"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - PRODUTO / LOCAL"
	EndIf

	cabec1 := STR0013			//"            Cliente /        Loja  -  Documento  - Data de  Unid.de ---------------------- Quantidade ------------------- --------------- Valores -----------   Custo Prod. TM  Segunda    Quantidade      Data    Dt Ult.
	cabec2 := STR0014			//"            Fornecedor              Numero  Serie  Emissao   Medida          Original      Ja' entregue             Saldo Total Nota Fiscal   Total Devolvido    na Moeda X     Un.Med.       Seg. UM    Lancto    Entrega
	//  Cliente:XXXXXXXXXXXXXXXXXXXX XX    999999   XXX  99/99/9999   XX   99999999999999999 99999999999999999 99999999999999999 99999999999999999 99999999999999999 9999999999999  X    XX     999999999999  99/99/9999 99/99/9999
	//            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
	//  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	dbSelectArea("SB6")
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par05,.T.)

	SetRegua(LastRec())

	While !Eof() .And. B6_FILIAL == xFilial()

		IncRegua()

		If lEnd
			@Prow()+1,001 PSay STR0016		//"CANCELADO PELO OPERADOR"
			Exit
		Endif

		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf	

		dbSelectArea("SF4")
		dbSeek(cFilial+SB6->B6_TES)
		If SF4->F4_PODER3 == "D"
			dbselectArea("SB6")
			dbSkip()
			Loop
		EndIf

		dbSelectArea("SB6")

		IF	IIf(B6_TPCF == "C" , &cCondCli , &cCondFor )
			aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
			dbSelectArea("SB6")
			nSaldo  := aSaldo[1]
			nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
		Else
			dbSkip()
			Loop
		Endif

		If mv_par09 == 2 .And. nSaldo <= 0
			dbSkip()
			Loop
		EndIf
		If mv_par10 == 1 .And. B6_TIPO != "D"
			dbSkip()
			Loop
		ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
			dbSkip()
			Loop
		EndIf




		nCusTot:=0
		nQuant :=0
		nQuJe  :=0
		nTotal :=0
		nTotDev:=0
		nSaldo :=0
		aSaldo :={}
		nCusto :=0
		cQuebra:= B6_PRODUTO+B6_LOCAL

		While !Eof() .And. xFilial() == B6_FILIAL .And. cQuebra == B6_PRODUTO+B6_LOCAL

			IncRegua()

			If li > 55
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf

			If !Empty(aReturn[7])
				If !&(aReturn[7])
					dbSkip()
					Loop
				EndIf
			EndIf	

			dbSelectArea("SF4")
			dbSeek(cFilial+SB6->B6_TES)
			If SF4->F4_PODER3 == "D"
				dbselectArea("SB6")
				dbSkip()
				loop
			Endif

			dbSelectArea("SB6")

			IF	IIf(B6_TPCF == "C" , &cCondCli , &cCondFor )
				aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
				dbSelectArea("SB6")
				nSaldo  := aSaldo[1]
				nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
				If mv_par09 == 2 .And. nSaldo <= 0
					dbSkip()
					Loop
				EndIf
				If mv_par10 == 1 .And. B6_TIPO != "D"
					dbSkip()
					Loop
				ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
					dbSkip()
					Loop
				EndIf
				If cProdLOCAL != B6_PRODUTO+B6_LOCAL
					dbSelectArea("SB1")
					If dbSeek(cFilial+SB6->B6_PRODUTO)
						If !Empty(cProdLOCAL)
							li += 2
						EndIf
						If li > 55
							Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
						EndIf
						@ li,000 PSay STR0017+B1_COD+" - "+Trim(Substr(B1_DESC,1,30))+" / "+SB6->B6_LOCAL		//"PRODUTO / LOCAL: "
						cProdLOCAL := SB6->B6_PRODUTO+SB6->B6_LOCAL
					Else
						Help(" ",1,"R480PRODUT")
						dbSelectArea("SB6")
						dbSetOrder(1)
						Return .F.
					EndIf
				EndIf
				dbSelectArea("SB6")

				If li > 55
					Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
				EndIf

				If !Empty(cProdLocal)

					li++
					@ li,000 PSay IIf(B6_TPCF == "C",STR0018,STR0019)		//"Clie:"###"Forn:"
					@ li,008 PSay (Substr(B6_CLIFOR,1,15))
					@ li,025 PSay B6_LOJA
					@ li,030 PSay B6_DOC
					@ li,045 PSay B6_SERIE
					@ li,050 PSay Dtoc(B6_EMISSAO)
					@ li,062 PSay If(mv_par15==1,B6_SEGUM,B6_UM)

					// Quantidade Original
					@ li,068 PSay If(mv_par15==1,ConvUM(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6","B6_QUANT",17)
					nQuant += If(mv_par15==1,ConvUM(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT)

					// Quantidade Ja Entregue
					@ li,086 PSay If(mv_par15==1,ConvUM(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo)) Picture PesqPict("SB6","B6_QUANT",17)
					nQuJe += If(mv_par15==1,ConvUM(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo))

					// Saldo
					@ li,104 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,nSaldo,0,2),nSaldo) Picture PesqPict("SB6", "B6_QUANT",17)

					// Total Nota Fiscal
					@ li,122 PSay Transform(B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
					nTotal += B6_QUANT * nPrUnit
					nGerTot+= B6_QUANT * nPrUnit

					// Total Nota Fiscal Devolvido
					@ li,140 PSay Transform((B6_QUANT-nSaldo) * nPrUnit,'@E 99,999,999,999.99')
					nTotDev += (B6_QUANT-nSaldo) * nPrUnit
					nGerTotDev+=(B6_QUANT-nSaldo) * nPrUnit

					// Custo na Moeda

					nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / B6_QUANT) * nSaldo
					nCusTot+= nCusto
					nGerCusTot+=nCusto

					@ li,158 PSay Transform(nCusto,'@E 999,999,999.99')
					@ li,173 PSay B6_TIPO
					@ li,178 PSay B6_SEGUM
					@ li,184 PSay B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",12)
					@ li,199 PSay Dtoc(B6_DTDIGIT)
					@ li,210 PSay Dtoc(B6_UENT)

					// Lista as devolucoes da remessa
					If mv_par12 == 1 .And. ((B6_QUANT - nSaldo) > 0)
						aAreaSB6 := SB6->(GetArea())
						dbSetOrder(3)
						cSeek:=xFilial()+B6_IDENT+B6_PRODUTO+"D"
						If dbSeek(cSeek)
							li++
							@ li,000 PSay STR0041	//"Notas Fiscais de Retorno"
							Do While !Eof() .And. B6_FILIAL+B6_IDENT+B6_PRODUTO+B6_PODER3 == cSeek
								If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
									DbSelectArea("SB6")
									DbSkip()
									Loop
								Endif
								If li > 55
									Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
								EndIf									
								li++
								@ li,000 PSay IIf(B6_TPCF == "C",STR0018,STR0019)		//"Clie:"###"Forn:"
								@ li,008 PSay (Substr(B6_CLIFOR,1,15))
								@ li,025 PSay B6_LOJA
								@ li,030 PSay B6_DOC
								@ li,045 PSay B6_SERIE
								@ li,050 PSay Dtoc(B6_EMISSAO)
								@ li,062 PSay If(mv_par15==1,B6_SEGUM,B6_UM)
								// Quantidade Original
								@ li,068 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",17)

								// Total Nota Fiscal
								@ li,122 PSay Transform(B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
								@ li,173 PSay B6_TIPO
								@ li,178 PSay B6_SEGUM
								@ li,184 PSay B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",12)
								@ li,199 PSay Dtoc(B6_DTDIGIT)
								@ li,210 PSay Dtoc(B6_UENT)
								dbSkip()
							EndDo
							li++
						EndIf
						RestArea(aAreaSB6)
						dbSetOrder(1)
					EndIf
				EndIf
			EndIf
			dbSkip()
		EndDo
		If nQuant > 0
			li++
			@ li,000 PSay STR0020		//"TOTAL DESTE PRODUTO / LOCAL ------ >"
			@ li,068 PSay nQuant        		Picture PesqPict("SB6", "B6_QUANT",17)
			@ li,086 PSay nQuje             	Picture PesqPict("SB6", "B6_QUANT",17)
			@ li,104 PSay (nQuant - nQuJe)  	Picture PesqPict("SB6", "B6_QUANT",17)
			@ li,122 PSay Transform(nTotal, '@E 99,999,999,999.99')
			@ li,140 PSay Transform(nTotDev,'@E 99,999,999,999.99')
			@ li,158 PSay Transform(nCusTot,'@E 999,999,999.99')
			nTotQuant += nQuant
			nTotQuje  += nQuje
			nTotSaldo += (nQuant - nQuJe)
		Endif
	End

	If nQuant > 0 .Or. nTotal > 0
		li++;li++
		@ li,000 PSay STR0021			//"T O T A L    G E R A L  ---------- >"
		@ li,068 PSay nTotQuant Picture PesqPict("SB6","B6_QUANT",17)
		@ li,086 PSay nTotQuJe Picture PesqPict("SB6","B6_QUANT",17)
		@ li,104 PSay nTotSaldo Picture PesqPict("SB6","B6_QUANT",17)
		@ li,122 PSay Transform(nGerTot	  ,'@E 99,999,999,999.99')
		@ li,140 PSay Transform(nGerTotDev,'@E 99,999,999,999.99')
		@ li,158 PSay Transform(nGerCusTot,'@E 999,999,999.99')
		Roda(CbCont,CbTxt,Tamanho)
	EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R480CliFor³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 12/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Por Ordem de Cliente / Fornecedor.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR480                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R480CliFor(lEnd,Tamanho)
	LOCAL cCliFor, cCliForAnt
	LOCAL cQuebra,aSaldo:={}
	LOCAL cIndex, cKey, nIndex, cNomeCliFor := "", cDescCliFor := ""
	LOCAL cVar,cFilter
	LOCAL nSaldo  := 0
	LOCAL nCusto  := 0
	LOCAL nPrUnit := 0
	LOCAL nGerTot := nGerTotDev:=nGerCusTot:=0
	LOCAL nCusTot := nQuant:=nQuJe:=nTotal:=nTotDev:= 0
	LOCAL aAreaSB6:= {}
	LOCAL nTotQuant := nTotQuJe := nTotSaldo := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho usando indice condicional.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB6")
	cIndex  := CriaTrab(NIL,.F.)
	cKey    := 'B6_FILIAL+B6_TPCF+B6_CLIFOR+B6_LOJA+B6_PRODUTO'
	cFilter := SB6->(DbFilter())
	If Empty( cFilter )
		cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
	Else
		cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. ' + cFilter
	EndIf

	IndRegua("SB6",cIndex,cKey,,cFilter,STR0022)		//" Criando Indice ...    "
	nIndex := RetIndex("SB6")
	#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1
		titulo := STR0023		//"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - CLIENTE / FORNECEDOR"
	ElseIf mv_par10 == 2
		titulo := STR0024		//"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - CLIENTE / FORNECEDOR"
	Else
		titulo := STR0025		//"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - CLIENTE / FORNECEDOR"
	EndIf
	cabec1 := STR0026			//"                 -    Documento    -  Data de         Unid. de ---------------------- Quantidade ---------------------  ------------ Valores --------------  Custo do Prod. TM  Segunda   Quantidade     Data   Data da Ult.
	cabec2 := STR0027			//"Produto          Numero        Serie  Emissao  Almox.  Medida        Original        Ja' entregue           Saldo       Total Nota Fiscal   Total Devolvido    na Moeda X       Unid. Med.   Seg. UM  Lancamento  Entrega
	// XXXXXXXXXXXXXXX  999999999999    XXX  99/99/9999 XX      XX    99999999999999999  99999999999999999  99999999999999999  99999999999999999 99999999999999999 99999999999999  X   XX      999999999999   99/99/99   99/99/99
	//           1         2         3         4         5         6         7         8         9         C         1         2         3         4         5         6         7         8         9         D       & 1         2
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	SetRegua(LastRec())

	While !Eof()

		IncRegua()

		If lEnd
			@Prow()+1,001 PSay STR0016		//"CANCELADO PELO OPERADOR"
			Exit
		EndIf

		dbSelectArea("SF4")
		dbSeek(cFilial+SB6->B6_TES)
		If SF4->F4_PODER3 == "D"
			dbselectArea("SB6")
			dbSkip()
			Loop
		EndIf

		dbSelectArea("SB6")

		IF	IIf(B6_TPCF == "C" , &cCondCli , &cCondFor )
			aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
			dbSelectArea("SB6")
			nSaldo:= aSaldo[1]
			nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
		Else
			dbSkip()
			Loop
		EndIf

		If mv_par09 == 2 .And. nSaldo <= 0
			dbSkip()
			Loop
		EndIf
		If mv_par10 == 1 .And. B6_TIPO != "D"
			dbSkip()
			Loop
		ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
			dbSkip()
			Loop
		EndIf

		cQuebra  := B6_CLIFOR+B6_LOJA+B6_PRODUTO+B6_TPCF
		nCusTot  := 0
		nQuant	 := 0
		nQuJe	 := 0
		nTotal	 := 0
		nTotDev	 := 0

		Do While B6_CLIFOR+B6_LOJA+B6_PRODUTO+B6_TPCF == cQuebra

			IncRegua()		

			If	!(If(B6_TPCF == "C" , &cCondCli , &cCondFor ))
				dbSkip()
				Loop
			EndIf

			dbSelectArea("SF4")
			dbSeek(cFilial+SB6->B6_TES)
			If SF4->F4_PODER3 == "D"
				dbSelectArea("SB6")
				dbSkip()
				Loop
			Endif

			dbSelectArea("SB6")
			aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
			dbSelectArea("SB6")
			nSaldo:= aSaldo[1]

			If mv_par09 == 2 .And. nSaldo <= 0
				dbSkip()
				Loop
			EndIf

			If mv_par10 == 1 .And. B6_TIPO != "D"
				dbSkip()
				Loop
			ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
				dbSkip()
				Loop
			EndIf

			If Li > 55
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf

			If cCliForAnt != B6_TPCF .Or. cNomeCliFor != B6_CLIFOR+B6_LOJA
				dbSelectArea(IIf(B6_TPCF == "C" , "SA1" , "SA2" ) )
				dbSeek(cFilial+SB6->B6_CLIFOR+SB6->B6_LOJA)
				If Found()
					If !Empty(cDescCliFor)
						li++
					EndIf
					cDescCliFor	:= IIf(SB6->B6_TPCF == "C" , STR0028 , STR0029)		//"CLIENTE / LOJA: "###"FORNECEDOR / LOJA: "
					@ li,000 PSay cDescCliFor+Trim( IIf(SB6->B6_TPCF == "C" ,A1_COD+" - "+A1_NOME , A2_COD+" - "+A2_NOME )  )+" / "+IIf(SB6->B6_TPCF == "C" , A1_LOJA , A2_LOJA )
					cNomeCliFor := SB6->B6_CLIFOR+SB6->B6_LOJA
					cCliForAnt 	:= SB6->B6_TPCF
				Else
					Help(" ",1,"R480CLIFOR")
					RetIndex("SB6")
					dbSelectArea("SB6")
					dbSetOrder(1)
					cIndex += OrdBagExt()
					Ferase(cIndex)
					Return .F.
				EndIf
				dbSelectArea("SB6")
			EndIf

			If Li > 55
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf

			If Len(cNomeCliFor) != 0
				li++
				@ li,000 PSay B6_PRODUTO
				@ li,017 PSay B6_DOC
				@ li,033 PSay B6_SERIE
				@ li,038 PSay Dtoc(B6_EMISSAO)
				@ li,049 PSay B6_LOCAL
				@ li,057 PSay If(mv_par15==1,B6_SEGUM,B6_UM)

				// Quantidade Original
				@ li,063 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",17)
				nQuant     += If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT)

				// localiza Saldo
				aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
				dbSelectArea("SB6")
				nSaldo  := aSaldo[1]
				nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])

				// Quantidade Ja Entregue
				@ li,082 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo)) Picture PesqPict("SB6", "B6_QUANT",17)
				nQuJe     +=  If(mv_par15==1,ConvUm(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo))

				// Saldo
				@ li,101 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,nSaldo,0,2),nSaldo) Picture PesqPict("SB6", "B6_QUANT",17)

				// Total da Nota Fiscal
				@ li,120 PSay Transform(B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
				nTotal	+= B6_QUANT * nPrUnit
				nGerTot	+= B6_QUANT * nPrUnit

				// Total da Nota Fiscal Devolvido
				@ li,138 PSay Transform((B6_QUANT - nSaldo) * nPrUnit,'@E 99,999,999,999.99')
				nTotDev		+= (B6_QUANT - nSaldo) * nPrUnit
				nGerTotDev	+= (B6_QUANT - nSaldo) * nPrUnit
				nCusto 		:= (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / B6_QUANT) * nSaldo
				nCusTot 	+= nCusto
				nGerCusTot 	+= nCusto

				@ li,156 PSay Transform(nCusto,'@E 999,999,999.99')
				@ li,172 PSay B6_TIPO
				@ li,176 PSay B6_SEGUM
				@ li,184 PSay B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",12)
				@ li,199 PSay Dtoc(B6_DTDIGIT)
				@ li,210 PSay Dtoc(B6_UENT)
			EndIf

			// Lista as devolucoes da remessa
			If mv_par12 == 1 .And. ((B6_QUANT - nSaldo) > 0)
				aAreaSB6 := SB6->(GetArea())
				dbSetOrder(3)
				cSeek:=xFilial()+B6_IDENT+B6_PRODUTO+"D"
				If dbSeek(cSeek)
					li++
					@ li,000 PSay STR0041	//"Notas Fiscais de Retorno"
					Do While !Eof() .And. B6_FILIAL+B6_IDENT+B6_PRODUTO+B6_PODER3 == cSeek
						If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
							DbSelectArea("SB6")
							DbSkip()
							Loop
						EndIf
						If li > 55
							Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
						EndIf					
						li++
						@ li,017 PSay B6_DOC
						@ li,033 PSay B6_SERIE
						@ li,038 PSay Dtoc(B6_EMISSAO)
						@ li,049 PSay B6_LOCAL
						@ li,057 PSay If(mv_par15==1,B6_SEGUM,B6_UM)
						// Quantidade Original
						@ li,063 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",17)
						// Total da Nota Fiscal
						@ li,120 PSay Transform(B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
						// Total da Nota Fiscal Devolvido
						@ li,172 PSay B6_TIPO
						@ li,176 PSay B6_SEGUM
						@ li,184 PSay B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",12)
						@ li,199 PSay Dtoc(B6_DTDIGIT)
						@ li,210 PSay Dtoc(B6_UENT)
						dbSkip()
					EndDo
					li++
				EndIf
				RestArea(aAreaSB6)
				dbSetOrder(nIndex+1)
			EndIf

			dbSkip()
		EndDo
		If nQuant > 0
			li++
			dbSkip(-1)
			cVar:=IIF(B6_TPCF == "C" ,STR0030,STR0031)	//"CLIENTE ---->"###"FORNECEDOR --->"
			dbSkip();IncRegua()
			If li > 55
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf
			@ li,000 PSay STR0032 +cVar		//"TOTAL DO PRODUTO NO "
			@ li,063 PSay nQuant					Picture PesqPict("SB6", "B6_QUANT",17)
			@ li,082 PSay nQuje					Picture PesqPict("SB6", "B6_QUANT",17)
			@ li,101 PSay (nQuant - nQuJe)	Picture PesqPict("SB6", "B6_QUANT",17)
			@ li,119 PSay Transform(nTotal ,'@E 999,999,999,999.99')
			@ li,137 PSay Transform(nTotDev,'@E 999,999,999,999.99')
			@ li,156 PSay Transform(nCusTot,'@E 999,999,999.99')
			li++
			nTotQuant += nQuant
			nTotQuJe  += nQuje
			nTotSaldo += (nQuant - nQuJe)
		Endif
	End
	If Len(cNomeCliFor) != 0
		li++
		@ li,000 PSay STR0021		//"T O T A L    G E R A L  ---------- >"
		@ li,063 PSay nTotQuant Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,082 PSay nTotQuJe  Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,101 PSay nTotSaldo Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,119 PSay Transform(nGerTot	 ,'@E 999,999,999,999.99')
		@ li,137 PSay Transform(nGerTotDev,'@E 999,999,999,999.99')
		@ li,156 PSay Transform(nGerCusTot,'@E 999,999,999.99')
		Roda(CbCont,CbTxt,Tamanho)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve condicao original ao SB6 e apaga arquivo de trabalho.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex("SB6")
	dbSelectArea("SB6")
	dbSetOrder(1)
	cIndex += OrdBagExt()
	Ferase(cIndex)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R480Data ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Por Ordem de Data do Movimento (B6_DTDIGIT).       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR480                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R480Data(lEnd,Tamanho)
	LOCAL nCusTot := nQuant := nQuJe := nTotal := nTotDev := 0
	LOCAL	nGerTot:=nGerTotDev:=nGerCusTot:=0
	LOCAL cIndex, cKey, nIndex, cFilter
	LOCAL cCondFiltr:=""
	LOCAL aSaldo  := {}
	Local nSaldo  := 0
	Local nCusto  := 0
	Local nPrUnit := 0
	LOCAL cQuebra, lImprime:=.F.
	LOCAL aAreaSB6:= {}
	LOCAL nTotQuant := nTotQuJe := nTotSaldo := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho usando indice condicional.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB6")
	cIndex  := CriaTrab(NIL,.F.)
	cKey    := "B6_FILIAL+DTOS(B6_DTDIGIT)+B6_PRODUTO+B6_CLIFOR+B6_LOJA"
	cFilter := SB6->(DbFilter())
	If Empty( cFilter )
		cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
	Else
		cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. ' + cFilter
	EndIf
	IndRegua("SB6",cIndex,cKey,,cFilter,STR0022)		//" Criando Indice ...    "
	nIndex := RetIndex("SB6")
	#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1
		titulo := STR0033		//"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - DATA DO MOVIMENTO"
	ElseIf mv_par10 == 2
		titulo := STR0034		//"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - DATA DO MOVIMENTO"
	Else
		titulo := STR0035		//"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - DATA DO MOVIMENTO"
	EndIf

	cabec1 := STR0036			//"         Cliente /                             -   Documento   - Data de       UM --------------------- Quantidade ----------------- ------------ Valores ------------ Custo Produto TM Seg. Quantidade -       Data       -
	cabec2 := STR0037			//"         Fornec.          Loja Produto         Numero      Serie Emissao  Almox           Original     Ja' entregue            Saldo Total Nota Fiscal Total Devolvido  na Moeda X      UM    Seg. UM   Lancamento   Entrega
	// Forn:XXXXXXXXXXXXXXXXXXXX XXXX XXXXXXXXXXXXXXX 999999999999 xxx 99/99/9999 XX  XX 9999999999999999  999999999999999 9999999999999999 99999999999999999 999999999999999 99999999999999 X XX 99999999999 99/99/9999 99/99/9999
	// Clie:     1         2         3         4         5         6         7         8         9         C         1         2         3         4         5         6         7         8         9         D         1         2
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890



	SetRegua(LastRec())

	While !Eof()

		IncRegua()

		If lEnd
			@Prow()+1,001 PSay STR0016		//"CANCELADO PELO OPERADOR"
			Exit
		Endif

		IF	!(Iif(B6_TPCF == "C" , &cCondCli , &cCondFor ))
			dbSkip()
			Loop
		EndIf

		dbSelectArea("SF4")
		dbSeek(cFilial+SB6->B6_TES)
		If SF4->F4_PODER3 == "D"
			dbselectArea("SB6")
			dbSkip()
			loop
		Endif

		dbSelectArea("SB6")
		aSaldo  := CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
		dbSelectArea("SB6")
		nSaldo  := aSaldo[1]
		nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])

		If mv_par09 == 2 .And. nSaldo <= 0
			dbSkip()
			Loop
		ElseIf mv_par10 == 1 .And. B6_TIPO != "D"
			dbSkip()
			Loop
		ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
			dbSkip()
			Loop
		Endif
		nCusTot  := 0
		nQuant   := 0
		nQuJe    := 0
		nTotal   := 0
		nTotDev  := 0
		cQuebra  := dTos(B6_EMISSAO)+B6_PRODUTO
		lImprime := .T.
		While !Eof() .And. cQuebra == dTos(B6_EMISSAO)+B6_PRODUTO .And. B6_Filial == xFilial()

			IncRegua()

			If li > 55
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf

			IF	!(Iif(B6_TPCF == "C" , &cCondCli , &cCondFor ))
				dbSkip()
				Loop
			EndIf

			dbSelectArea("SF4")
			dbSeek(cFilial+SB6->B6_TES)
			If SF4->F4_PODER3 == "D"
				dbselectArea("SB6")
				dbSkip()
				loop
			Endif

			dbSelectArea("SB6")
			aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
			dbSelectArea("SB6")
			nSaldo  := aSaldo[1]
			nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])

			If mv_par09 == 2 .And. nSaldo <= 0
				dbSkip()
				Loop
			ElseIf mv_par10 == 1 .And. B6_TIPO != "D"
				dbSkip()
				Loop
			ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
				dbSkip()
				Loop
			Endif

			If lImprime
				li++
				@ li,000 PSay STR0038 + dToc(B6_EMISSAO)		//"DATA DE MOVIMENTACAO : "
				lImprime := .F.
			Endif

			li++
			@ li,000 PSay IIf(B6_TPCF == "C" , STR0018, STR0039 )		//"Clie:"###"Forn:"
			@ li,005 PSay (Substr(B6_CLIFOR,1,15))
			@ li,023 PSay B6_LOJA
			@ li,028 PSay B6_PRODUTO
			@ li,045 PSay B6_DOC
			@ li,060 PSay B6_SERIE
			@ li,064 PSay Dtoc(B6_EMISSAO)
			@ li,075 PSay B6_LOCAL
			@ li,079 PSay If(mv_par15==1,B6_SEGUM,B6_UM)

			// Quantidade Original
			@ li,082 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",16)
			nQuant += If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT)

			// Localiza o Saldo
			aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par13,mv_par14)
			dbSelectArea("SB6")
			nSaldo  := aSaldo[1]
			nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])

			// Quantidade Ja Entregue
			@ li,100 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo)) Picture PesqPict("SB6", "B6_QUANT",15)
			nQuJe += If(mv_par15==1,ConvUm(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo))

			// Saldo
			@ li,116 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,nSaldo,0,2),nSaldo) Picture PesqPict("SB6", "B6_QUANT",16)

			// Total da Nota Fiscal
			@ li,133 PSay Transform(B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
			nTotal += B6_QUANT * nPrUnit
			nGerTot+= B6_QUANT * nPrUnit

			// Total da Nota Fiscal Devolvido
			@ li,151 PSay Transform((B6_QUANT - nSaldo) * nPrUnit,'@E 999,999,999.99')
			nTotDev += (B6_QUANT - nSaldo) * nPrUnit
			nGerTotDev	+= (B6_QUANT - nSaldo) * nPrUnit
			nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / B6_QUANT) * nSaldo
			nCusTot+= nCusto
			nGerCusTot+= nCusto

			@ li,167 PSay Transform(nCusto,'@E 999,999,999.99')
			@ li,182 PSay B6_TIPO
			@ li,184 PSay B6_SEGUM
			@ li,187 PSay B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",11)
			@ li,199 PSay Dtoc(B6_DTDIGIT)
			@ li,210 PSay Dtoc(B6_UENT)

			// Lista as devolucoes da remessa
			If mv_par12 == 1 .And. ((B6_QUANT - nSaldo) > 0)
				aAreaSB6 := SB6->(GetArea())
				dbSetOrder(3)
				cSeek:=xFilial()+B6_IDENT+B6_PRODUTO+"D"
				If dbSeek(cSeek)
					li++
					@ li,000 PSay STR0041	//"Notas Fiscais de Retorno"
					Do While !Eof() .And. B6_FILIAL+B6_IDENT+B6_PRODUTO+B6_PODER3 == cSeek
						If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
							DbSelectArea("SB6")
							DbSkip()
							Loop
						Endif
						If li > 55
							Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
						EndIf		
						li++					
						@ li,000 PSay IIf(B6_TPCF == "C" , STR0018, STR0039 )		//"Clie:"###"Forn:"
						@ li,005 PSay (Substr(B6_CLIFOR,1,15))
						@ li,023 PSay B6_LOJA
						@ li,027 PSay B6_PRODUTO
						@ li,045 PSay B6_DOC
						@ li,060 PSay B6_SERIE
						@ li,064 PSay Dtoc(B6_EMISSAO)
						@ li,075 PSay B6_LOCAL
						@ li,079 PSay If(mv_par15==1,B6_SEGUM,B6_UM)
						// Quantidade Original
						@ li,082 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",16)
						// Total da Nota Fiscal
						@ li,133 PSay Transform(B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
						@ li,182 PSay B6_TIPO
						@ li,184 PSay B6_SEGUM
						@ li,187 PSay B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",11)
						@ li,199 PSay Dtoc(B6_DTDIGIT)
						@ li,210 PSay Dtoc(B6_UENT)
						dbSkip()
					EndDo
					li++
				EndIf
				RestArea(aAreaSB6)
				dbSetOrder(nIndex+1)
			EndIf

			dbSkip()
		EndDo
		If nQuant > 0
			li++
			@ li,000 PSay STR0040		//"TOTAL DO PRODUTO NA DATA --------- >"
			@ li,082 PSay nQuant 			 Picture PesqPict("SB6", "B6_QUANT",16)
			@ li,100 PSay nQuJe  			 Picture PesqPict("SB6", "B6_QUANT",15)
			@ li,116 PSay (nQuant - nQuJe) Picture PesqPict("SB6", "B6_QUANT",16)
			@ li,133 PSay Transform(nTotal, '@E 99,999,999,999.99')
			@ li,151 PSay Transform(nTotDev,'@E 999,999,999.99')
			@ li,167 PSay Transform(nCusTot,'@E 999,999,999.99')
			nTotQuant += nQuant
			nTotQuJe  += nQuJe
			nTotSaldo += (nQuant - nQuJe)
			li++
		Endif
	End

	If nQuant > 0 .Or. nTotal > 0
		li++;li++
		@ li,000 PSay STR0021		//"T O T A L    G E R A L  ---------- >"
		@ li,082 PSay nTotQuant Picture PesqPict("SB6", "B6_QUANT",16)
		@ li,100 PSay nTotQuJe  Picture PesqPict("SB6", "B6_QUANT",16)
		@ li,116 PSay nTotSaldo Picture PesqPict("SB6", "B6_QUANT",16)
		@ li,133 PSay Transform(nGerTot	 ,'@E 99,999,999,999.99')
		@ li,151 PSay Transform(nGerTotDev,'@E 999,999,999.99')
		@ li,167 PSay Transform(nGerCusTot,'@E 999,999,999.99')
		Roda(CbCont,CbTxt,Tamanho)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve condicao original ao SB6 e apaga arquivo de trabalho.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex("SB6")
	dbSelectArea("SB6")
	dbSetOrder(1)
	cIndex += OrdBagExt()
	Ferase(cIndex)

Return .T.
