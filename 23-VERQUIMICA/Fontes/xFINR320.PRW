#INCLUDE "FINR320.CH"
#include "PROTHEUS.CH"
#INCLUDE "fwcommand.ch"

Static lFWCodFil := FindFunction("FWCodFil")

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR320  ³ Autora³ Adrianne Furtado      ³ Data ³ 06/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Posi‡„o Geral da Cobran‡a.								  ³±±                  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR320()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xFINR320()

Local oReport
Local aArea		  := GetArea()
Local cPerg       := "FIN320"		// Nome do grupo de perguntas
PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"      
PRIVATE aRota	:= {}

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef( cPerg )
	oReport:PrintDialog()
Else
	Return u_xFIR320R3( ) // Executa versão anterior do fonte
Endif

RestArea( aArea )  

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Adrianne Furtado   º Data ³  06/06/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Grupo de perguntas do relatorio                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orcamentario                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef( cPerg )

Local cReport	:= "FINR320" // Nome do relatorio
Local cTitulo	:= STR0005	 // Titulo do relatorio -> "Posicao Geral do Contas a Receber"
Local cDescri	:= STR0001 +" "+ STR0002// Descricao do relatorio ->"Este programa ir  emitir a posi‡„o geral da cobran‡a no mˆs"
									//"referente a data base do sistema."
Local oReport	:= Nil
Local oSection1	:= Nil        
Local oSection2	:= Nil
Local oSecFil	:= Nil

AjustaSX1()

Pergunte( cPerg, .F. )
                  
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
//"Este relatorio irá apresentar a posiçäo geral da cobrança no mês referente a data base do sistema."
oReport  := TReport():New( cReport , cTitulo, cPerg, { |oReport| U_xF320Imp( oReport ) }, cDescri )
/*
GESTAO - inicio */
oReport:SetUseGC(.F.)
/* GESTAO - fim
*/ 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New( oReport, STR0059, {"SA1"}, )//"Dados do Cliente"
TRCell():New( oSection1, "A1_COD"	,"SA1",,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "A1_LOJA"	,"SA1",,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "A1_NOME"	,"SA1",,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:SetNoFilter({"SA1"})
oSection1:HideHeader()
oSection1:Hide()

oSection2 := TRSection():New( oSection1, STR0060, {"SE1","SED"}, ) // "Faturamento (no mes)"
TRCell():New( oSection2, "CelDesc"	,,STR0058					,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)	// Descricao
TRCell():New( oSection2, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)	// Valor
TRCell():New( oSection2, "CelQuant"	,,STR0055					,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)	// Quantidade

//Faz o alinhamento do cabecalho das celulas
oSection2:Cell("CelValor"):SetHeaderAlign("RIGHT")
oSection2:Cell("CelQuant"):SetHeaderAlign("RIGHT")

oSection3 := TRSection():New( oSection1, STR0061, {"SE1","SED"} )	// "Valores Baixados"
TRCell():New( oSection3, "CelDesc"	,,STR0058,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Descricao
TRCell():New( oSection3, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,/*lPixel*/,/*{|| code-block de impressao }*/)					// Valor
TRCell():New( oSection3, "CelQuant"	,,STR0055,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Quantidade

oSection4 := TRSection():New( oSection1, STR0062, {"SE1","SED"} )	// "Titulos a vencer"
TRCell():New( oSection4, "CelDesc"	,,STR0058,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Descricao
TRCell():New( oSection4, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Valor
TRCell():New( oSection4, "CelQuant"	,,STR0055,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Quantidade

oSection5 := TRSection():New( oSection1, STR0063, {"SE1","SED"} )	// "Titulos vencidos"
TRCell():New( oSection5, "CelDesc"	,,STR0058,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Descricao
TRCell():New( oSection5, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Valor
TRCell():New( oSection5, "CelQuant"	,,STR0055,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Quantidade

oSection6 := TRSection():New( oSection1, STR0064, {"SE1","SED"} )	// "Recebimento e notas de credito"
TRCell():New( oSection6, "CelDesc"	,,STR0058,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Descricao
TRCell():New( oSection6, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Valor
TRCell():New( oSection6, "CelQuant"	,,STR0055,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Quantidade

oSection7 := TRSection():New( oSection1, STR0065, {"SE1","SED"} )	// "Distribuicao da cobranca"
TRCell():New( oSection7, "CelDesc"	,,STR0058,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Descricao
TRCell():New( oSection7, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Valor
TRCell():New( oSection7, "CelQuant"	,,STR0055,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Quantidade

oSection8 := TRSection():New( oSection1, STR0066, {"SE1","SED"} )	// "Por tipo de titulo"
TRCell():New( oSection8, "CelDesc"	,,STR0058,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Descricao
TRCell():New( oSection8, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Valor
TRCell():New( oSection8, "CelQuant"	,,STR0055,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Quantidade

oSection9 := TRSection():New( oSection1, STR0067, {"SE1","SED"} )	// "Carteira de pedidos a entregar"
TRCell():New( oSection9, "CelDesc"	,,STR0058,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Descricao
TRCell():New( oSection9, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Valor
TRCell():New( oSection9, "CelQuant"	,,STR0055,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Quantidade

oSection10 := TRSection():New( oSection1, STR0068, {"SE1","SED"} )	// "Prazos medios e quociente de atraso"
TRCell():New( oSection10, "CelDesc"	,,STR0058,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Descricao
TRCell():New( oSection10, "CelValor"	,,STR0054+GetMv("MV_SIMB1"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Valor
TRCell():New( oSection10, "CelQuant"	,,STR0055,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)					// Quantidade
/*
GESTAO - inicio */
/* Relacao das filiais selecionadas para compor o relatorio */
oSecFil := TRSection():New(oReport,"SECFIL",{"SE1","SED"})
TRCell():New(oSecFil,"CODFIL",,"Código",/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecFil,"EMPRESA",,"Empresa",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecFil,"UNIDNEG",,"Unidade de negócio",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecFil,"NOMEFIL",,"Filial",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)
/* GESTAO - fim
*/
Return oReport                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ xF320Imp ºAutor³Adrianne Furtado    º Data ³  07/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPO1 - Objeto TReport do relatorio                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xF320Imp( oReport )
Local oCliente  := oReport:Section(1)
Local oSection1 := oReport:Section(1):Section(1) 
Local oSection2 := oReport:Section(1):Section(1)
Local oSection3 := oReport:Section(1):Section(1)
Local oSection4 := oReport:Section(1):Section(1)
Local oSection5 := oReport:Section(1):Section(1)
Local oSection6 := oReport:Section(1):Section(1)
Local oSection7 := oReport:Section(1):Section(1)
Local oSection8 := oReport:Section(1):Section(1)
Local oSection9 := oReport:Section(1):Section(1)
Local nLinha	:= 0
Local aVal
Local aValor	:={}
Local nX
Local nMeter	:= 0          
Local cFiltSE1 := oReport:Section(1):GetAdvplExp("SE1")
Local cFiltSED := oReport:Section(1):GetAdvplExp("SED")
/*
GESTAO - inicio */
Local aSelFil		:= {}
Local aSM0			:= {}
Local nRegSM0		:= 0
Local nTamEmp		:= 0
Local nTamUnNeg		:= 0
Local nTamTit		:= 0
Local cFiLSel		:= ""
Local cTitulo		:= ""
Local oSecFil		:= oReport:Section("SECFIL")

If FindFunction("FwSelectGC")
	nRegSM0 := SM0->(Recno())
	If MV_PAR01 == 1	//filial
		aSelFil := FwSelectGC(.T.)
	Else
		aSelFil := FwSelectGC()
	Endif
	If Empty(aSelFil)
		aSelFil := {cFilAnt}
		MV_PAR01 := 1
	Endif
	SM0->(DbGoTo(nRegSM0))
Else
	aSelFil := AdmGetFil(.F.,(MV_PAR01 == 1),"SE1")
	If Empty(aSelFil)
		Aadd(aSelFil,cFilAnt)
	Endif
Endif
/* imprime a lista de filiais selecionadas para o relatorio */
If Len(aSelFil) > 1
	aSM0 := FWLoadSM0()
	nTamEmp := Len(FWSM0LayOut(,1))
	nTamUnNeg := Len(FWSM0LayOut(,2))
	cTitulo := oReport:Title()
	oReport:SetTitle(cTitulo + " (" + "Filiais selecionadas para o relatorio" + ")")
	nTamTit := Len(oReport:Title())
	oSecFil:Init()  
	oSecFil:Cell("CODFIL"):SetBlock({||cFilSel})
	oSecFil:Cell("EMPRESA"):SetBlock({||aSM0[nLinha,SM0_DESCEMP]})
	oSecFil:Cell("UNIDNEG"):SetBlock({||aSM0[nLinha,SM0_DESCUN]})
	oSecFil:Cell("NOMEFIL"):SetBlock({||aSM0[nLinha,SM0_NOMRED]})
	For nX := 1 To Len(aSelFil)
		nLinha := Ascan(aSM0,{|sm0|,sm0[SM0_CODFIL] == aSelFil[nX]})
		If nLinha > 0
			cFilSel := Substr(aSM0[nLinha,SM0_CODFIL],1,nTamEmp)
			cFilSel += " "
			cFilSel += Substr(aSM0[nLinha,SM0_CODFIL],nTamEmp + 1,nTamUnNeg)
			cFilSel += " "
			cFilSel += Substr(aSM0[nLinha,SM0_CODFIL],nTamEmp + nTamUnNeg + 1)
			oSecFil:PrintLine()
		Endif
	Next
	oReport:SetTitle(cTitulo)
	oSecFil:Finish()
	oReport:EndPage()
Endif
/* GESTAO - fim
*/
aVal := xFA320Calc(cFiltSE1,cFiltSED,@aSelFil)
                                                  

If Len(aRota) > 0
	Alert("Parou")
EndIf

aADD(aValor,{STR0010,aVal[1,1]+aVal[2,1],aVal[1,2]+aVal[2,2]}) 		//"FATURAMENTO (no mes)"
aADD(aValor,{STR0011,aVal[1,1],aVal[1,2]})	 						//"A Vista"
aADD(aValor,{STR0012,aVal[2,1],aVal[2,2]}) 							//"A Prazo"

aADD(aValor,{STR0051,""					 ,""		}) 				//"VALORES BAIXADOS"
aADD(aValor,{STR0013,aVal[40,1]			 ,""		}) 				//"RECEBIDO"
aADD(aValor,{STR0014,aVal[41,1]			 ,""		}) 				//"TAXA DE PERMANENCIA"          
aADD(aValor,{STR0015,aVal[42,1]			 ,""		}) 				//"Multa"
aADD(aValor,{STR0016,aVal[43,1]			 ,""		}) 				//"CORRECAO"
aADD(aValor,{STR0017,aVal[44,1]			 ,""		}) 				//"DESCONTO"
aADD(aValor,{STR0018,aVal[45,1]			 ,""		}) 				//"ORIGINAL"

//"TITULOS A VENCER"
aADD(aValor,{STR0019,(aVal[39,1]+aVal[7,1]+aVal[8,1]+aVal[9,1]+aVal[10,1])  ,(aVal[39,2]+aVal[7,2]+aVal[8,2]+aVal[9,2]+aVal[10,2])}) 
aADD(aValor,{STR0052,aVal[39,1]			 ,aVal[39,2]	}) 				//"Ate 15 Dias"
aADD(aValor,{STR0053,aVal[07,1]    		 ,aVal[07,2]	}) 				//"De 16 a 30 dias"
aADD(aValor,{STR0023,aVal[08,1]    		 ,aVal[08,2]	}) 				//"De 31 a 60 dias"
aADD(aValor,{STR0024,aVal[09,1]    		 ,aVal[09,2]	}) 				//"De 61 a 90 dias"
aADD(aValor,{STR0025,aVal[10,1]   		 ,aVal[10,2]	}) 				//"Acima de 90 Dias

//"TITULOS VENCIDOS"
aADD(aValor,{STR0026,(aVal[38,1]+aVal[3,1]+aVal[4,1]+aVal[5,1]+aVal[6,1])  ,(aVal[38,2]+aVal[3,2]+aVal[4,2]+aVal[5,2]+aVal[6,2])}) 
aADD(aValor,{STR0052,aVal[38,1]			 ,aVal[38,2]	}) 				//"Ate 15 Dias"
aADD(aValor,{STR0053,aVal[03,1]    		 ,aVal[03,2]	}) 				//"De 16 a 30 dias"
aADD(aValor,{STR0023,aVal[04,1]    		 ,aVal[04,2]	}) 				//"De 31 a 60 dias"
aADD(aValor,{STR0024,aVal[05,1]    		 ,aVal[05,2]	}) 				//"De 61 a 90 dias"
aADD(aValor,{STR0025,aVal[06,1]   		 ,aVal[06,2]	}) 				//"Acima de 90 Dias

aADD(aValor,{STR0020,aVal[24,1]   		 ,aVal[24,2]	}) 				//"Recebimento Antecipado"
aADD(aValor,{STR0021,aVal[36,1]			 ,aVal[36,2]	}) 				//"Notas de Credito"

aADD(aValor,{STR0027,""					 ,""			}) 				//"DISTRIBUICAO DA COBRANCA"
aADD(aValor,{STR0028,aVal[25,1]			 ,aVal[25,2]	}) 				//"Carteira"
aADD(aValor,{STR0029,aVal[26,1]			 ,aVal[26,2]	}) 				//"Cobranca Simples"
aADD(aValor,{STR0030,aVal[27,1]			 ,aVal[27,2]	}) 				//"Cobranca Descontada"
aADD(aValor,{STR0031,aVal[28,1]			 ,aVal[28,2]	}) 				//"Cobranca Caucionada"
aADD(aValor,{STR0032,aVal[29,1]			 ,aVal[29,2]	}) 				//"Cobranca Vinculada"
aADD(aValor,{STR0033,aVal[30,1]			 ,aVal[30,2]	}) 				//"Cobranca Extra-Judicial" "Cobrança c/Advogado"
aADD(aValor,{STR0034,aVal[31,1]			 ,aVal[31,2]	}) 				//"Cobranca Cartorio" "Cobranca Judicial"
aADD(aValor,{STR0035,aVal[37,1]			 ,aVal[37,2]	}) 				//"Cobr Cauc Descont"

aADD(aValor,{STR0036,""					 ,""			}) 				//"POR TIPO DE TITULO"
aADD(aValor,{STR0037,aVal[11,1]			 ,aVal[11,2]	}) 				//"Duplicatas"
aADD(aValor,{STR0038,aVal[12,1]			 ,aVal[12,2]	}) 				//"Notas Fiscais"
aADD(aValor,{STR0039,aVal[13,1]			 ,aVal[13,2]	}) 				//"Cheques Pre-Datados"
aADD(aValor,{STR0040,aVal[14,1]			 ,aVal[14,2]	}) 				//"Carnet De Pagamento"
aADD(aValor,{STR0041,aVal[15,1]			 ,aVal[15,2]	}) 				//"Impostos"
aADD(aValor,{STR0042,aVal[35,1]			 ,aVal[35,2]	}) 				//"Abatimentos"
aADD(aValor,{STR0043,aVal[16,1]			 ,aVal[16,2]	}) 				//"Outros"

//"CARTEIRA DE PEDIDOS A ENTREGAR"
aADD(aValor,{STR0044,(aVal[17,1]+aVal[18,1]+aVal[19,1]+aVal[20,1]+aVal[21,1])  ,(aVal[17,2]+aVal[18,2]+aVal[19,2]+aVal[20,2]+aVal[21,2])}) 
aADD(aValor,{STR0045,aVal[21,1]			 ,aVal[21,2]	}) 				//"Itens de Pedidos Vencidos"
aADD(aValor,{STR0022,aVal[17,1]    		 ,aVal[17,2]	}) 				//"Ate 30 Dias"
aADD(aValor,{STR0023,aVal[18,1]    		 ,aVal[18,2]	}) 				//"De 31 a 60 dias"
aADD(aValor,{STR0024,aVal[19,1]    		 ,aVal[19,2]	}) 				//"De 61 a 90 dias"
aADD(aValor,{STR0025,aVal[20,1]   		 ,aVal[20,2]	}) 				//"Acima de 90 Dias

aADD(aValor,{STR0047,"" 	,(aVal[22,1]/aVal[22,2])	}) 				//"Prazo Medio Absoluto"
aADD(aValor,{STR0048,""  	,(aVal[23,1]/aVal[23,2])	}) 				//"Prazo Medio Ponderado"
aADD(aValor,{STR0049,""  	,(((aVal[38,1]+aVal[3,1]+aVal[4,1]+aVal[5,1]+aVal[6,1])/aVal[34,1]))*100})	//"Quociente De Atraso"

oReport:SetMeter(Len(aValor))       

oCliente:Init()
oCliente:PrintLine()
oCliente:Finish()

// primeira secao  --> FATURAMENTO
oSection1:Init()                 
oSection1:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection1:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection1:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )
oSection1:Cell("CelValor"):SetPicture(TM(aValor[1,2],18, MsDecimais(mv_par09)))
For nLinha := 1 to 3
	oReport:IncMeter()
	oSection1:PrintLine()
Next 
oSection1:Finish()      

// segunda secao --> VALORES BAIXADOS
oSection2:Init()     
oSection2:SetHeaderSection(.F.)
oReport:ThinLine()
oSection2:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection2:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection2:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )   
For nLinha := 4 to 10
	If nLinha == 4
		oSection1:Cell("CelValor"):SetPicture("") //Não deve utilizar picture no titulo da secao que n imprime valores
	ElseIf nLinha == 5
		oSection1:Cell("CelValor"):SetPicture(PesqPict("SE5","E5_VALOR",oSection1:Cell("CelValor"):nSize,mv_par09))
	EndIf
	oReport:IncMeter()
	oSection2:PrintLine()
Next 
oSection2:Finish()      

// terceira secao --> TITULOS A VENCER
oSection3:Init()
oReport:ThinLine()
oSection3:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection3:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection3:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )
oSection3:Cell("CelValor"):SetPicture(PesqPict("SE5","E5_VALOR",oSection3:Cell("CelValor"):nSize,mv_par09))
For nLinha := 11 to 16
	oReport:IncMeter()
	oSection3:PrintLine()
Next 
oSection3:Finish()      

// quarta secao --> TITULOS VENCIDOS
oSection4:Init()
oReport:ThinLine()
oSection4:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection4:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection4:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )
oSection4:Cell("CelValor"):SetPicture(PesqPict("SE5","E5_VALOR",oSection4:Cell("CelValor"):nSize,mv_par09))
For nLinha := 17 to 22
	oReport:IncMeter()
	oSection4:PrintLine()
Next 
oSection4:Finish()      

// quinta secao --> RECEBIMENTO ANTECIPADO E NOTAS DE CREDITO
oSection5:Init()
oReport:ThinLine()
oSection5:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection5:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection5:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )
oSection5:Cell("CelValor"):SetPicture(PesqPict("SE5","E5_VALOR",oSection5:Cell("CelValor"):nSize,mv_par09))
For nLinha := 23 to 24
	oReport:IncMeter()
	oSection5:PrintLine()
Next 
oSection5:Finish()      

// sexta secao -->DISTRIBUICAO DA COBRANCA
oSection6:Init()
oReport:ThinLine()
oSection6:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection6:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection6:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )
For nLinha := 25 to 33
	If nLinha == 25
		oSection6:Cell("CelValor"):SetPicture("") //Não deve utilizar picture no titulo da secao que n imprime valores
	ElseIf nLinha == 26
		oSection6:Cell("CelValor"):SetPicture(PesqPict("SE5","E5_VALOR",oSection6:Cell("CelValor"):nSize,mv_par09))
	EndIf
	oReport:IncMeter()
	oSection6:PrintLine()
Next 
oSection6:Finish()      

// sétima secao  --> POR TIPO DE TITULO
oSection7:Init()
oReport:ThinLine()
oSection7:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection7:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection7:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )
For nLinha := 34 to 41
	If nLinha == 34
		oSection7:Cell("CelValor"):SetPicture("") //Não deve utilizar picture no titulo da secao que n imprime valores
	ElseIf nLinha == 35
		oSection7:Cell("CelValor"):SetPicture(PesqPict("SE5","E5_VALOR",oSection7:Cell("CelValor"):nSize,mv_par09))
	EndIf
	oReport:IncMeter()
	oSection7:PrintLine()
Next 
oSection7:Finish()      

// oitava secao  -->CARTEIRA DE PEDIDOS A ENTREGAR
oSection8:Init()
oReport:ThinLine()
oSection8:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection8:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection8:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )   
oSection8:Cell("CelValor"):SetPicture(PesqPict("SE5","E5_VALOR",oSection8:Cell("CelValor"):nSize,mv_par09))
For nLinha := 42 to 47
	oReport:IncMeter()
	oSection8:PrintLine()
Next 
oSection8:Finish()      

// nona secao --> PRAZO MEDIO E QUOCIENTE DE ATRASO
oSection9:Init()
oReport:ThinLine()
oSection9:Cell("CelDesc" ):SetBlock( { || aValor[nLinha,1] } )
oSection9:Cell("CelValor"):SetBlock( { || aValor[nLinha,2] } )
oSection9:Cell("CelQuant"):SetBlock( { || aValor[nLinha,3] } )
oSection9:Cell("CelValor"):SetPicture("")
oSection9:Cell("CelQuant"):SetPicture("999.99")
For nLinha := 48 to 50
	oReport:IncMeter()
	oSection9:PrintLine()
Next 
oSection9:Finish()      

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ xFINR320  ³ Autor ³ Paulo Boschetti       ³ Data ³ 05.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o Geral da Cobran‡a.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ xFINR320(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xFIR320R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cString:="SE1"
LOCAL cDesc1 := STR0001 //"Este programa ir  emitir a posi‡„o geral da cobran‡a no mˆs"
LOCAL cDesc2 := STR0002 //"referente a data base do sistema."
LOCAL cDesc3 :=""
LOCAL Tamanho := "M"
Local aPergs	:= {}
Local dOldDtBase := dDataBase

PRIVATE titulo
PRIVATE cabec1
PRIVATE cabec2 
PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR320"
PRIVATE cPerg   :="FIN320"
PRIVATE nLastKey:= 0
PRIVATE nJuros  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0005)  //"Posicao Geral do Contas a Receber"
cabec1 := OemToAnsi(STR0006)+GetMv("MV_SIMB1")+OemToAnsi(STR0007)  //"                                             Valores ("###")            Quantidade"
cabec2 := ""

//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 13 (Data Base)
PutDtBase()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN320",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01            // Imprime Por Filial ou Empresa.       ³
//³ mv_par02            // Nas baixas, Dt Baixa, Digit ou Dispo ³
//³ mv_par03            // Seleciona tipos ( Sim / Nao ).       ³
//³ mv_par04            // Prefixo inicial                      ³
//³ mv_par05            // Prefixo final                        ³
//³ mv_par06            // Considera Juros                      ³
//³ mv_par07            // Considera TES para Pedido Venda      ³
//³ mv_par08            // Considera data base                  ³
//³ mv_par09            // Qual moeda                           ³
//³ mv_par10            // Outras moedas                        ³
//³ mv_par11            // Considerar Abatimentos(Sim/Nao)      ³
//³ mv_par12            // Considerar Pedidos Vendas(Sim/Nao)   ³
//³ mv_par13            // Data Base									 ³
//³ mv_par14            // Tit. Emissao Futura 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR320"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
dDataBase := mv_par13 // Altera data base conforme parametro
RptStatus({|lEnd| xFA320Imp(@lEnd,wnRel,cString)},titulo)
dDataBase := dOldDtBase // Restaura Data base

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ xFINR320  ³ Autor ³ Paulo Boschetti       ³ Data ³ 05.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o Geral da Cobran‡a.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ xFA320Imp(lEnd,wnRelm,Cstring)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Parametro 1 - lEnd    - A‡Æo do CodeBlock                  ³±±
±±³          ³ Parametro 2 - wnRel   - T¡tulo do relat¢rio                ³±±
±±³          ³ Parametro 3 - cString - Mensagem                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xFA320Imp(lEnd,wnRel,cString)

LOCAL CbCont,CbTxt
LOCAL tamanho:="M"
LOCAL nSaldo :=0,nDias:=0,I:=0,J:=0,nSaldoAtu:=0
LOCAL nFirst :=1,nFirst1:=1
LOCAL aVal[39,2]
LOCAL nRecebido:=0
LOCAL nValJuros:=0
LOCAL nDesconto:=0
LOCAL nCorrecao:=0
LOCAL nMulta   :=0
LOCAL nOriginal:=0
LOCAL dDataBaixa
Local cCondSC6 
Local dOldDtBase := dDataBase
#IFDEF TOP
	LOCAL nX,cCondFil,nIndex
	Local cQuery
#ELSE
	Local cArq	
#ENDIF	
Local cFilterUser := aReturn[7]
Local aSitua := ARRAY(8)
Local nI:=0
Local nMoedaBco := 1
Local nDecs := MsDecimais(mv_par09)
Local cFiltro, cIndTmp, cAliasTmp
Local nTipoData := 1
Local lAdto
Local nValAbat := 0
Local nAbt		:= 0
Local nTamFilial:= IIf( lFWCodFil, FWGETTAMFILIAL, 2 )
Local lPrjCni := FindFunction("ValidaCNI") .And. ValidaCNI()

aSitua[1] := OemtoAnsi(STR0028)		//"Carteira"
aSitua[2] := OemtoAnsi(STR0029)		//"Cobranca Simples"
aSitua[3] := OemToAnsi(STR0030) 		//"Cobranca Descontada"
aSitua[4] := OemToAnsi(STR0031) 		//"Cobranca Caucionada"
aSitua[5] := OemToAnsi(STR0032)		//"Cobranca Vinculada"
aSitua[6] := OemToAnsi(STR0033)		//"Cobranca Extra-Judicial"
aSitua[7] := OemToAnsi(STR0034)	   //"Cobranca Cartorio"
aSitua[8] := OemToAnsi(STR0035) 	   //"Cobr Cauc Descont"

//Tipo da data para a composicao do saldo via SaldoTit()
If mv_par02 == 1			// Data da baixa (E5_BAIXA)
	nTipoData := 1
ElseIf mv_par02 == 2 	//Data de Digitacao (E5_DTDIGIT)
	nTipoData := 3
Else							//Data de Disponibilidade (E5_DTDISPO)
	nTipoData := 2
Endif

dbSelectArea("SX5")
dbSeek( Space( nTamFilial ) + "07")

While !Eof() .and. X5_TABELA == "07"

	nI++
	If nI > Len(aSitua)
		Aadd(aSitua," ")		// garante um novo elemento
	Endif
	aSitua[nI] := TRIM(X5Descri())
	dbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
PRIVATE  cTipos := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se seleciona tipos para total faturamento         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par03 == 1
	finaTipos()
Endif

dbSelectArea("SE1")
dbSetOrder(1)
If mv_par01 == 1
	dbSeek(xFilial("SE1"))
Else 
	dbGotop()
Endif

For i := 1 to 39
	For j := 1 to 2
		aVal[I,J] := 0
	Next j
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra APENAS os emitidos antes da database, pois este rela³
//³ torio pode ser retroativo.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	IF TcSrvType() != "AS/400"
		aStru  := SE1->(dbStruct())
		cAliasTmp := "FINR320"
		cQuery := ""
		aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery +=         ",R_E_C_N_O_ RECNO "
		cQuery += "FROM "+RetSqlName("SE1")+ " SE1 "
		cQuery += "WHERE "
		If mv_par01 == 1
			cQuery += "SE1.E1_FILIAL ='"+xFilial("SE1")+"' AND "
		Endif	
		If MV_PAR14 == 2 //Nao considerar titulos com emissao futura
			cQuery += "SE1.E1_EMISSAO <= '"+Dtos(dDataBase)+"' AND "
		Endif	
		cQuery += "SE1.E1_PREFIXO >= '"+MV_PAR04+"' AND "	
		cQuery += "SE1.E1_PREFIXO <= '"+MV_PAR05+"' AND " 
		If lPrjCni
			cQuery += "SE1.E1_BAIXA = '' AND "
		EndIf
		If mv_par10 == 2 
			cQuery += "SE1.E1_MOEDA = "+Str(MV_PAR09,2)+" AND "
		Endif	         
		If lPrjCni

			cQuery += "(SE1.E1_FATURA = '      ' OR SE1.E1_FATURA = 'NOTFAT') AND "
			cQuery += "(SE1.E1_DTFATUR > '"+Dtos(dDataBase)+"' OR SE1.E1_DTFATUR = '        ') AND "
		EndIf
		If mv_par01 == 1
			cQuery += "SE1.E1_FILIAL = '" + xFilial("SE1")+"' AND "
		Endif	  
		cQuery += "SE1.E1_SALDO >= '0' AND "		         
		cQuery += "SE1.D_E_L_E_T_=' ' "
   	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)	
		For nX :=  1 To Len(aStru)
			If aStru[nX][2] <> "C"
				TcSetField(cAliasTmp,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	Else
#ENDIF
		cFiltro := ""
		If Mv_par01 == 1
			cFiltro += "E1_FILIAL>='"+xFilial("SE1")+"'.And."
		Endif
		If MV_PAR14 == 2 //Nao considerar titulos com emissao futura
			cFiltro += "Dtos(E1_EMISSAO)<='"+Dtos(dDataBase)+"'.And."
		Endif	
		cFiltro += "E1_PREFIXO>='"+MV_PAR04+"'.And."	
		cFiltro += "E1_PREFIXO<='"+MV_PAR05+"'"
		If mv_par10 == 2 
			cFiltro += ".And.E1_MOEDA == "+Str(MV_PAR09,2)
		Endif	
		cFiltro += ".And. (E1_FATURA = '      ' .Or. E1_FATURA = 'NOTFAT')"
		cFiltro += ".And. (E1_DTFATUR > '"+Dtos(dDataBase)+"' .Or. E1_DTFATUR = '        ')"
		If mv_par01 == 1
			cFiltro += ".And. E1_FILIAL = '" + xFilial("SE1")+"'"
		Endif	           

		dbSelectArea("SE1")
		dbSetOrder(1)
		cIndTmp := CriaTrab(,.F.)
		IndRegua("SE1",cIndTmp,IndexKey(),,cFiltro)
		dbGotop()
		cAliasTmp := "SE1"
#IFDEF TOP
	Endif
#ENDIF

dbSelectArea(cAliasTmp)
SetRegua(RecCount()+SE5->(RecCount())+SC6->(RecCount()))

While !Eof()

	dbSelectArea(cAliasTmp)

	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
		Exit
	Endif
    
	IncRegua()
   
	If mv_par03 == 1
		If !Inside(E1_TIPO)
			dbSkip()
			Loop
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser) .and. !(cAliasTmp)->(&cFilterUser)
		dbSkip()
		Loop
	Endif
	
	IF !Empty(E1_FATURA) .and. Substr(E1_FATURA,1,6) != "NOTFAT" .and. E1_DTFATUR <= dDataBase
		dbSkip()
		Loop
	Endif 
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica se ‚ provis¢rio ou abatimento ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If E1_TIPO $ MVPROVIS+"/"+MVABATIM
    	If E1_TIPO $ MVABATIM	//Somo o valor caso seja abatimento 
      		If mv_par11 == 1  
				nAbt := IIF(dDatabase < E1_BAIXA, xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0)), xMoeda(E1_SALDO,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0)))		// no resumo por tipo de titulos
				aVal[35,1] += nAbt
				aVal[35,2] += IIF(nAbt > 0,1,0)
			Endif
		Else            
        	aVal[16,1] += xMoeda(E1_SALDO,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
			aVal[16,2] += IIF(SE1->E1_SALDO > 0,1,0)
		Endif
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o faturamento baseado na data base/item 1 analise    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Month(E1_EMISSAO) == Month(dDatabase) .and. Year(E1_EMISSAO) == Year(dDataBase)
		If !(E1_TIPO $MV_CRNEG+"/"+MVRECANT)
			nDias := (E1_VENCREA - E1_EMISSAO)
			If nDias <= 1
				aVal[1,1] += xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
				aVal[1,2] += 1
			Else
				aVal[2,1] += xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
				aVal[2,2] += 1
			Endif
		Endif
	Endif
	nSaldoAtu := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acumula titulos vencidos/vencer / Item 2 e 3 da analise      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		IF TcSrvType() != "AS/400"
			// Posiciona SE2 ou SE1 para pegar o saldo do titulo correto
			SE1->(DbGoto((cAliasTmp)->RECNO))
		Endif	
	#ENDIF 
	
	If mv_par08 == 1    // Considera Data Base
		 dDataBase := mv_par13
	Endif		

	If mv_par08 == 1
		IF !Empty(SE1->E1_BAIXA) .and. IIF(mv_par02 == 1,(SE1->E1_SALDO == 0 .and. SE1->E1_BAIXA <= dDataBase),.F.)
			nSaldoAtu := 0
		Else
			nSaldoAtu := SaldoTit( 	E1_PREFIXO,;
										E1_NUM,;
										E1_PARCELA,;
										E1_TIPO,;
										E1_NATUREZ,;
										"R",;
										E1_CLIENTE,;
										MV_PAR09,;
										dDataBase,;
										dDataBase,;
										E1_LOJA,;
										E1_FILIAL,;
										IIf(cPaisLoc=="BRA",E1_TXMOEDA,0),nTipoData )

			// Subtrai decrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldoAtu,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
				nSaldoAtu -= SE1->E1_DECRESC
			Endif
			// Soma Acrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldoAtu,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
				nSaldoAtu += SE1->E1_ACRESC
			Endif
			
		Endif
	Else       
		If cPaisLoc == "BRA"
			nSaldoAtu := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),E1_MOEDA,mv_par09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
		Else
			nSaldoAtu := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
		EndIf
	Endif
	
	nValAbat := 0		
	If !(E1_TIPO $MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM)
		// Se considerar titulos com emissao futura, envia a data de ref. para Somaabat para que ela considere os
		// titulos de abatimento com emissao <= Database + 40 anos (30 * 480) - Emissao futura
		nValAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",1,,E1_CLIENTE,E1_LOJA,E1_FILIAL,If(mv_par14==1,dDataBase+(30*480),dDataBase))
	Endif
	
	If nSaldoAtu > 0 .and. (mv_par11 == 1 .or. STR(nSaldoAtu,17,2) == STR(nValAbat,17,2))
		nSaldoAtu-= nValAbat
	Endif  
  	nSaldoAtu:=Round(NoRound(nSaldoAtu,3),2)

	If nSaldoAtu > 0
		dBaixa := dDataBase
		nJuros := 0
		If mv_par06 == 1
			fa070juros(mv_par09)
		Endif

		lAdto := E1_TIPO $ MVRECANT+"/"+MV_CRNEG

		If E1_VENCREA < dDataBase
			nSaldoAtu+=nJuros
			nDias := (dDatabase - E1_VENCTO)
	
			aVal[34,1] += nSaldoAtu

			If !lAdto
				If nDias <= 15
					aVal[38,1] += nSaldoAtu
					aVal[38,2] += 1
				ElseIf nDias > 15 .And. nDias <= 30
					aVal[3,1] += nSaldoAtu
					aVal[3,2] += 1
				ElseIf nDias > 30 .And. nDias <= 60
					aVal[4,1] += nSaldoAtu
					aVal[4,2] += 1               
				ElseIf nDias > 60 .And. nDias <= 90
					aVal[5,1] += nSaldoAtu
					aVal[5,2] += 1
				Else
					aVal[6,1] += nSaldoAtu
					aVal[6,2] += 1
				Endif
			Endif
		Else
			If !lAdto
				aVal[34,1] += nSaldoAtu
	         	nDias      := (E1_VENCREA - dDatabase)
				If nDias <= 15
    	   	  		aVal[39,1] += nSaldoAtu
    		   		aVal[39,2] += 1
	            ElseIf nDias > 15 .And. nDias <= 30
    	        	aVal[7,1] += nSaldoAtu
        	    	aVal[7,2] += 1
	         	ElseIf nDias > 30 .And. nDias <= 60
    	       		aVal[8,1] += nSaldoAtu
        	    	aVal[8,2] += 1
	         	ElseIf nDias > 60 .And. nDias <= 90
    	       		aVal[9,1] += nSaldoAtu
        	    	aVal[9,2] += 1
	         	Else
    	       		aVal[10,1] += nSaldoAtu
        	    	aVal[10,2] += 1
	         	EndIF
			Endif
		EndIF
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a distribuicao de cobranca / item 4  analise         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nSaldoAtu > 0
		IF !(E1_TIPO $MV_CRNEG+"/"+MVRECANT)
			Do Case
				Case E1_SITUACA   $ " 0FG"
					aVal[25,1] += nSaldoAtu
					aVal[25,2] += 1
				Case E1_SITUACA   $ "1H"
					aVal[26,1] += nSaldoAtu
					aVal[26,2] += 1
				Case E1_SITUACA   = "2"
					aVal[27,1] += nSaldoAtu
					aVal[27,2] += 1
				Case E1_SITUACA   = "3"
					aVal[28,1] += nSaldoAtu
					aVal[28,2] += 1
				Case E1_SITUACA   = "4"
					aVal[29,1] += nSaldoAtu
					aVal[29,2] += 1
				Case E1_SITUACA   = "5"
					aVal[30,1] += nSaldoAtu
					aVal[30,2] += 1
				Case E1_SITUACA   = "6"
					aVal[31,1] += nSaldoAtu
					aVal[31,2] += 1
				Case E1_SITUACA   = "7"
					aVal[37,1] += nSaldoAtu
					aVal[37,2] += 1
			EndCase
		Endif
	Endif
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor Recebido.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nFirst1 == 1
		SA6->(dbSetorder(1)) // para pegar a moeda do banco.
		dbSelectArea("SE5") 
		If mv_par01 == 1
			dbSeek(xFilial("SE5"))
		Else
			dbGotop()
		Endif
		#IFDEF TOP
			IF TcSrvType() != "AS/400"
				aStru  := SE5->(dbStruct())
				cAliasSe5 := "NEWSE5"
				cCondFil := ""
				aEval(aStru,{|x| cCondFil += ","+AllTrim(x[1])})
				cCondFil := "SELECT "+SubStr(cCondFil,2)
				cCondFil +=         ",R_E_C_N_O_ RECNO "
				cCondFil += "FROM "+RetSqlName("SE5") + " SE5 "
				cCondFil += "WHERE " 
				If mv_par01 == 1
					cCondFil += "E5_FILIAL='" + xFilial("SE5") + "' AND "
				Endif
				cCondFil += "E5_TIPODOC IN ('VL','V2','JR','J2','CM','C2','MT','M2','DC','D2','TL','BA') AND E5_RECPAG = 'R' AND "
				cCondFil += "E5_PREFIXO >= '"+MV_PAR04+"' AND "	
				cCondFil += "E5_PREFIXO <= '"+MV_PAR05+"' AND "
        	    If mv_par02 == 1
					cCondFil += "E5_DATA >= '"
				ElseIf mv_par02 == 2
					cCondFil += "E5_DTDIGIT >= '"
				ElseIf mv_par02 == 3
					cCondFil += "E5_DTDISPO >= '"
				Endif				
				cCondFIl += Subs(dtos(dDataBase),1,6)+"01"+"' AND "
            	If mv_par02 == 1
					cCondFil += "E5_DATA <= '"
				ElseIf mv_par02 == 2
					cCondFil += "E5_DTDIGIT <= '"
				ElseIf mv_par02 == 3
					cCondFil += "E5_DTDISPO <= '"
				Endif				
				cCondFIl += Dtos(LastDay(dDataBase))+"' AND "
				If mv_par01 == 1      
					cCondFil += "E5_FILIAL = '"+ xFilial("SE5")+"' AND "
				EndIf                                   
				cCondFil += "D_E_L_E_T_=' ' "
		   	
				cCondFil := ChangeQuery(cCondFil)
  	
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCondFil),cAliasSe5,.T.,.T.)
				For nX :=  1 To Len(aStru)
					If aStru[nX][2] <> "C"
						TcSetField(cAliasSe5,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
					EndIf
				Next nX
			Else
		#ENDIF
				cCondFil := ""
				If mv_par01 == 1
					cCondFil += "E5_FILIAL=='" + xFilial("SE5") + "' .And. "
				Endif
				cCondFil += "E5_TIPODOC$'VL/V2/JR/J2/CM/C2/MT/M2/DC/D2/TL/BA' .and. E5_RECPAG == 'R' .and. "
				cCondFil += "E5_PREFIXO>='"+MV_PAR04+"'.And."	
				ccondFil += "E5_PREFIXO<='"+MV_PAR05+"'.And."
	
	            If mv_par02 == 1
					cCondFil += "DTOS(E5_DATA) >= '"
				ElseIf mv_par02 == 2
					cCondFil += "DTOS(E5_DTDIGIT) >= '"
				ElseIf mv_par02 == 3
					cCondFil += "DTOS(E5_DTDISPO) >= '"
				Endif				
				cCOndFIl += Subs(dtos(dDataBase),1,6)+"01"+"'.and."
				If mv_par01 == 1
					cCondFil += "E5_FILIAL == '"+ xFilial("SE5")+"' .and."
				EndIf
	
	            If mv_par02 == 1
					cCondFil += "DTOS(E5_DATA) <= '"
				ElseIf mv_par02 == 2
					cCondFil += "DTOS(E5_DTDIGIT) <= '"
				ElseIf mv_par02 == 3
					cCondFil += "DTOS(E5_DTDISPO) <= '"
				Endif				
				cCOndFIl += Dtos(LastDay(dDataBase))+"'"  
			
				cArq :=CriaTrab(NIL,.F.)
				IndRegua("SE5",cArq,IndexKey(),,cCondFil,STR0009) //"Selecionando Registros.."
				nIndex:=RetIndex("SE5")
				#IFNDEF TOP
					dbSetIndex(cArq+OrdBagExt())
				#ENDIF					
				dbSetOrder(nIndex+1)
				cAliasSe5 := "SE5"
				DbGoTop()
		#IFDEF TOP
			Endif
		#ENDIF
		
		DbSelectArea(cAliasSe5)
		DbGoTop()
       
		While !Eof()
			IncRegua()            

        	// Ignora registros que nao sao da moeda quando escolhido nao imprimir
			SA6->(dbSeek(xFilial()+(cAliasSe5)->E5_BANCO+(cAliasSe5)->E5_AGENCIA+(cAliasSe5)->E5_CONTA))
	        If mv_par10 == 2 .AND. Max(SA6->A6_MOEDA, 1) != mv_par09 
    	     	dbSkip()
	            Loop
			Endif                 
     
	     	nMoedaBco := If(SA6->(Found()), Max(SA6->A6_MOEDA, 1), 1)

			If mv_par02 == 1
		  		dDataBaixa := (cAliasSe5)->E5_DATA
			ElseIf mv_par02 == 2
		  		dDataBaixa := (cAliasSe5)->E5_DTDIGIT
			ElseIf mv_par02 == 3
		  		dDataBaixa := (cAliasSe5)->E5_DTDISPO
			Endif				
            
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Valor Recebido.   ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Month(dDatabase)== Month(dDataBaixa) .and.;
				Year(dDataBase) ==Year(dDataBaixa)   .and.;
				(cAliasSe5)->E5_RECPAG=="R" .and. dDataBaixa <= dDatabase .AND.;
				(cAliasSe5)->E5_TIPODOC$"VL/V2/BA" ;
				.and.  (cAliasSe5)->E5_SITUACA <> "C" .and. ;
				(	MovBcoBx((cAliasSe5)->E5_MOTBX) .or. ;
				((cAliasSe5)->E5_MOTBX=="CMP" .and. (cAliasSe5)->E5_TIPO $ MVRECANT+"#"+MV_CRNEG ) )			

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe estorno para esta baixa                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				#IFDEF TOP
					IF TcSrvType() != "AS/400"
						SE5->(dbGoto((cAliasSe5)->RECNO))
					Endif
				#ENDIF	   						
								
				If !TemBxCanc((cAliasSe5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
					nRecebido += xMoeda((cAliasSe5)->E5_VALOR,nMoedaBco,mv_par09,(cAliasSe5)->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",(cAliasSe5)->E5_TXMOEDA,0))   
				EndIf
			EndIf

	      If Month(dDatabase) = Month(dDataBaixa) .and. ;
	      	Year(dDataBase)  = Year(dDataBaixa)  .and. (cAliasSe5)->E5_RECPAG=="R" .and. ;
	         dDataBaixa <= dDatabase .and. (cAliasSe5)->E5_SITUACA <> "C" .and. ;
	         MovBcoBx((cAliasSe5)->E5_MOTBX) 
	         nValorE5 := xMoeda((cAliasSe5)->E5_VALOR,nMoedaBco,mv_par09,(cAliasSe5)->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",(cAliasSe5)->E5_TXMOEDA,0))
	         Do Case 
	         	Case (cAliasSe5)->E5_TIPODOC $ "JR/J2/TL"  //Valor juros
	            	nValJuros += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "CM/C2"     //Valor da correcao
	            	nCorrecao += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "MT/M2"     //Valor da Multa
	            	nMulta    += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "DC/D2"     //Valor do Desconto
	            	ndesconto += nValorE5
				EndCase
			EndIf
			dbSelectArea(cAliasSe5)
	      dbSkip()
		Enddo
		#IFDEF TOP
			IF TcSrvType() != "AS/400"
				dbSelectArea(cAliasSe5)
				dbCloseArea()
				dbSelectArea("SE5")
			Else
		#ENDIF
				dbSelectArea("SE5")
				DbClearFil()
				RetIndex("SE5")
				FErase(cArq+OrdBagExt())
		#IFDEF TOP
			Endif
		#ENDIF
		nFirst1++
		dbSelectArea(cAliasTmp)
	EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a distribuicao por tipo de titulo / item 5 analise   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nSaldoAtu > 0 .and. (mv_par14 == 1 .Or. E1_EMISSAO <= dDatabase)
		Do Case
			Case E1_TIPO  $ MVDUPLIC
				aVal[11,1] += nSaldoAtu
	            aVal[11,2] += 1
			Case E1_TIPO  $ MVNOTAFIS
				aVal[12,1] += nSaldoAtu
				aVal[12,2] += 1
			Case E1_TIPO  $ MVCHEQUES
				aVal[13,1] += nSaldoAtu
				aVal[13,2] += 1
			Case E1_TIPO   = "CN"
				aVal[14,1] += nSaldoAtu
				aVal[14,2] += 1
			Case E1_TIPO  $ MVTAXA
				aVal[15,1] += nSaldoAtu
				aVal[15,2] += 1
			Case E1_TIPO  $ MVRECANT
				aVal[24,1] += nSaldoAtu
				aVal[24,2] += 1
			Case E1_TIPO $ MV_CRNEG				
				aVal[36,1] += nSaldoAtu
				aVal[36,2] += 1
			OtherWise
				aVal[16,1]  += nSaldoAtu
				aVal[16,2]  += 1	
		EndCase
	End
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula T.Carteira pedidos a entregar / item 6 da analise    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nFirst == 1 .and. mv_par12 == 1	
		dbSelectArea("SC6")
		cCondSC6 := 'C6_QTDVEN > C6_QTDENT '
		cArq :=CriaTrab("",.F.)
		INDREGUA("SC6",cArq,IndexKey(),,cCondSC6,OemToAnsi(STR0009))  //"Selecionando Registros.."
		nIndex:=RetIndex("SC6")
		#IFNDEF TOP
			dbSetIndex(cArq+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		If mv_par01 == 1
			dbSeek(cFilial)
		Else
			dbGotop()
		Endif
        
		While !Eof()

         IF mv_par01 == 1 .and. cFilial != C6_FILIAL
				Exit
         Endif

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Posicionar do SC5 para localiza moeda do pedido              ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         dbSelectArea( "SC5" )
         dbSeek( cFilial + SC6->C6_NUM )
         dbSelectArea( "SC6" )

		 	// Calcula se moeda for igual a escolhida ou for para converter
		 	If SC5->C5_MOEDA == mv_par09 .OR. mv_par10 == 1             
            nSaldo := xMoeda(u_xF320Sld(),SC5->C5_MOEDA, mv_par09,SC5->C5_EMISSAO,nDecs+1)
            If nSaldo > 0
					If dDatabase < C6_ENTREG // itens a vencer					 
						nDias := (C6_ENTREG - dDatabase)
						If nDias <= 30
							aVal[17,2]++
							aVal[17,1]+= nSaldo
						ElseIf nDias > 30 .And. nDias <= 60
							aVal[18,2]++
							aVal[18,1]+= nSaldo
						ElseIf nDias > 60 .And. nDias <= 90
							aVal[19,2]++
							aVal[19,1]+= nSaldo
						Else
							aVal[20,2]++
							aVal[20,1]+= nSaldo
						Endif
					Else // itens vencidos
						nDias := (dDatabase - C6_ENTREG)
						aVal[21,2]++
						aVal[21,1]+= nSaldo
					EndIf
				Endif
			Endif
			dbSkip()
		EndDo
		RetIndex("SC6")
		Set Filter to
		Ferase(cArq+OrdBagExt())
		nFirst++
		dbSelectArea(cAliasTmp)
	Endif
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o P.M.A e P.M.P - indices / item 7 da analise        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nSaldoAtu != 0
		aVal[22,1] += (E1_VENCREA-E1_EMISSAO)
		aVal[22,2] += 1
		aVal[23,1] += (E1_VENCREA-E1_EMISSAO)*;
					   xMoeda(nSaldoAtu,E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
		aVal[23,2] +=  xMoeda(nSaldoAtu,E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
	EndIf
	dbSelectArea(cAliasTmp)
	nSaldoAtu:=0
	dbSkip()
Enddo
#IFDEF TOP
	IF TcSrvType() != "AS/400"
		dbSelectArea(cAliasTmp)
		dbCloseArea()
		dbSelectArea("SE1")
	Else
#ENDIF
		dbSelectArea("SE1")
		DbClearFil()
		RetIndex("SE1")
		FErase(cIndTmp+OrdBagExt())
#IFDEF TOP
	Endif
#ENDIF

IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Endif

@Li ,  0 PSAY OemToAnsi(STR0010)  //"FATURAMENTO (no mes)"
@Li , 40 PSAY aVal[1,1]+aVal[2,1]    PICTURE TM(aVal[1,1]+aVal[2,1],18, nDecs)
@Li , 72 PSAY aVal[1,2]+aVal[2,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0011)  //"A Vista"
@Li , 40 PSAY aVal[1,1]	     	 PICTURE TM(aVal[1,1],18,nDecs)
@Li , 72 PSAY aVal[1,2]   	      PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0012)  //"A Prazo"
@Li , 40 PSAY aVal[2,1]	     	 PICTURE TM(aVal[2,1],18,nDecs)
@Li , 72 PSAY aVal[2,2]   	      PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
li++
nOriginal := nRecebido-(nValJuros+nMulta+nCorrecao-nDesconto)
@li,   0 PSAY OemToAnsi(STR0051)  //"VALORES BAIXADOS"
li++
@li,   0 PSAY OemToAnsi(STR0013)  //"Recebido"
@li,  40 PSAY nRecebido			Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0014)  //"Taxa Permanencia"
@li,  40 PSAY nValJuros            Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0015)  //"Multa"
@li,  40 PSAY nMulta           Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0016)  //"Correcao"
@li,  40 PSAY nCorrecao        Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0017)  //"Descontos"
@li,  40 PSAY nDesconto			Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@li,   0 PSAY OemToAnsi(STR0018)  //"Original"
@li,  40 PSAY nOriginal        Picture PesqPict("SE5","E5_VALOR",18,mv_par09)
li++
@Li ,  0 PSAY REPLICATE("-",80) 
li++
@Li ,  0 PSAY OemToAnsi(STR0019)  //"TITULOS A VENCER"
@Li , 40 PSAY (aVal[39,1]+aVal[7,1]+aVal[8,1]+aVal[9,1]+aVal[10,1])             PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[39,2]+aVal[7,2]+aVal[8,2]+aVal[9,2]+aVal[10,2]               PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0052)  //"Ate 15 Dias"
@Li , 40 PSAY aVal[39,1]   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[39,2]   PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0053)  //"De 16 a 30 Dias"
@Li , 40 PSAY aVal[7,1]    PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[7,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0023)  //"De 31 a 60 dias"
@Li , 40 PSAY aVal[8,1]    PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[8,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0024)  //"De 61 a 90 dias"
@Li , 40 PSAY aVal[9,1]    PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[9,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0025)  //"Acima de 90 Dias"
@Li , 40 PSAY aVal[10,1]   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[10,2]   PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
Li++
@Li ,  0 PSAY OemToAnsi(STR0026)  //"TITULOS VENCIDOS"
@Li , 40 PSAY (aVal[38,1]+aVal[3,1]+aVal[4,1]+aVal[5,1]+aVal[6,1])    PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[38,2]+aVal[3,2]+aVal[4,2]+aVal[5,2]+aVal[6,2]    PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0052)  //"Ate 15 Dias"
@Li , 40 PSAY aVal[38,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[38,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0053)  //"De 16 a 30 Dias"
@Li , 40 PSAY aVal[3,1]	   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[3,2]		PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0023)  //"De 31 a 60 dias"
@Li , 40 PSAY aVal[4,1]	   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[4,2]   	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0024)  //"De 61 a 90 dias"
@Li , 40 PSAY aVal[5,1]	   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[5,2]		PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0025)  //"Acima de 90 Dias"
@Li , 40 PSAY aVal[6,1]		PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[6,2]		PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
li++
@Li ,  0 PSAY OemToAnsi(STR0020)   //"Recebimento Antecipado"
@Li , 40 PSAY aVal[24,1]   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[24,2]   PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0021)  //"Notas de Credito"
@Li , 40 PSAY aVal[36,1]   PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[36,2]   PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
li++
@Li ,  0 PSAY OemToAnsi(STR0027)  //"DISTRIBUICAO DA COBRANCA"
Li++

@Li ,  0 PSAY aSitua[1]
@Li , 40 PSAY aVal[25,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[25,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[2]
@Li , 40 PSAY aVal[26,1]  	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[26,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[3]
@Li , 40 PSAY aVal[27,1]  	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[27,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[4]
@Li , 40 PSAY aVal[28,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[28,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[5]
@Li , 40 PSAY aVal[29,1]  	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[29,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[6]
@Li , 40 PSAY aVal[30,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[30,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[7]
@Li , 40 PSAY aVal[31,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[31,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY aSitua[8]
@Li , 40 PSAY aVal[37,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[37,2]	PICTURE "999999"
Li++

@Li ,  0 PSAY REPLICATE("-",80) 
Li++
@Li ,  0 PSAY OemToAnsi(STR0036)  //"POR TIPO DE TITULO"
Li++
@Li ,  0 PSAY OemToAnsi(STR0037)  //"Duplicatas"
@Li , 40 PSAY aVal[11,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[11,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0038)  //"Notas Fiscais"
@Li , 40 PSAY aVal[12,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[12,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0039)  //"Cheques Pre-Datados"
@Li , 40 PSAY aVal[13,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[13,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0040)  //"Carne De Pagamento"
@Li , 40 PSAY aVal[14,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[14,2]	PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0041)  //"Impostos"
@Li , 40 PSAY aVal[15,1]	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[15,2]			      PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0042)  //"Abatimentos"
@Li , 40 PSAY aVal[35,1]        			PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[35,2]        			PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0043)  //"Outros"
@Li , 40 PSAY aVal[16,1]				  	PICTURE PesqPict("SE5","E5_VALOR",18,mv_par09)
@Li , 72 PSAY aVal[16,2]					PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
Li++
@Li ,  0 PSAY OemToAnsi(STR0044)  //"CARTEIRA DE PEDIDOS A ENTREGAR"
@Li , 43 PSAY aVal[17,1]+aVal[18,1]+aVal[19,1]+aVal[20,1]+aVal[21,1]  Picture PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[17,2]+aVal[18,2]+aVal[19,2]+aVal[20,2]+aVal[21,2]  Picture "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0045)  //"Itens de Pedidos Vencidos"
@Li , 43 PSAY aVal[21,1]             PICTURE  PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[21,2]             PICTURE  "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0022)  //"Ate 30 Dias"
@Li , 43 PSAY aVal[17,1]             PICTURE PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[17,2]             PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0023)  //"De 31 a 60 Dias"
@Li , 43 PSAY aVal[18,1]             PICTURE PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[18,2]             PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0024)  //"De 61 a 90 Dias"
@Li , 43 PSAY aVal[19,1]             PICTURE PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[19,2]             PICTURE "999999"
Li++
@Li ,  0 PSAY OemToAnsi(STR0025)  //"Acima De 90 Dias"
@Li , 43 PSAY aVal[20,1]             PICTURE PesqPict("SC6","C6_PRCVEN",16,mv_par09)
@Li , 72 PSAY aVal[20,2]             PICTURE "999999"
Li++
@Li ,  0 PSAY REPLICATE("-",80) 
Li++
@Li ,  0 PSAY OemToAnsi(STR0047)  //"Prazo Medio Absoluto"
@Li , 72 PSAY (aVal[22,1]/aVal[22,2])   	      PICTURE "999.99"
Li++
@Li ,  0 PSAY OemToAnsi(STR0048)  //"Prazo Medio Ponderado"
@Li , 72 PSAY (aVal[23,1]/aVal[23,2])   	      PICTURE "999.99"
Li++
@Li ,  0 PSAY OemToAnsi(STR0049)  //"Quociente De Atraso"
@Li , 72 PSAY  (((aVal[38,1]+aVal[3,1]+aVal[4,1]+aVal[5,1]+aVal[6,1])/aVal[34,1]))*100 PICTURE "999.99"
Li++

Set Device To Screen
dbSelectArea("SE1")
dbSetOrder(1)
Set Filter to
dbSelectArea("SE5")
dbSetOrder(1)
Set Filter to

If aReturn[5] = 1
    Set Printer TO
    dbCommitAll()
    Ourspool(wnrel)
Endif
MS_FLUSH()

dDataBase := dOldDtBase // Restaura Data base
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INSIDE     ºAutor³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InSide(cTp)
Return (cTp$cTipos)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³xF320Sld³ Autor ³ Alessandro Freire     ³ Data ³ 16.01.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo do item do pedido                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ xF320Sld()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xF320Sld()
LOCAL nRetSaldo := 0

If (C6_QTDVEN-C6_QTDENT) > 0 .And. C6_BLQ != "R"
	If !Empty( SC6->C6_TES )
		dbSelectArea("SF4")
 		dbSetOrder(1)
		dbSeek( xFilial("SF4")+SC6->C6_TES )
		If mv_par08 == 1
			nRetSaldo := SC6->C6_PRCVEN * (SC6->C6_QTDVEN)
		ElseIf mv_par08 == 2	
			nRetSaldo := SC6->C6_PRCVEN * (SC6->C6_QTDVEN - SC6->C6_QTDENT)
		Endif
		If mv_par07 == 1		// Verifica se ir  considerar o TES (F4_DUPLIC)
			nRetSaldo := 0
			If SF4->F4_DUPLIC == "S"
				If mv_par08 == 1
					nRetSaldo := SC6->C6_PRCVEN * (SC6->C6_QTDVEN)
				ElseIf mv_par08 == 2	
					nRetSaldo := SC6->C6_PRCVEN * (SC6->C6_QTDVEN - SC6->C6_QTDENT)
				Endif
			Endif
		EndIf
	EndIf
EndIf
dbSelectArea("SC6")
Return(nRetSaldo)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PutDtBase³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 18/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acerta parametro database do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ xFINR320.prx                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek( Padr( "FIN320" , Len( X1_GRUPO ) , ' ' ) + "13")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)

	Replace x1_cnt01 With "'"+DTOC(dDataBase)+"'"

	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³xFA320Calc ³ Autor ³ Adrianne Furtado      ³ Data ³ 07.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calculo dos valores do relatorio Posi‡„o Geral da Cobran‡a.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ xFA320Calc(cFiltSE1)                            				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xFA320Calc(cFiltSE1,cFiltSED,aSelFil)

LOCAL CbCont,CbTxt
LOCAL tamanho:="M"
LOCAL nSaldo :=0,nDias:=0,I:=0,J:=0,nSaldoAtu:=0
LOCAL nFirst :=1,nFirst1:=1
LOCAL aVal[45,2]
LOCAL nRecebido:=0
LOCAL nValJuros:=0
LOCAL nDesconto:=0
LOCAL nCorrecao:=0
LOCAL nMulta   :=0
LOCAL nOriginal:=0
LOCAL dDataBaixa
Local cCondSC6
Local dOldDtBase := dDataBase
#IFDEF TOP
	LOCAL nX,cCondFil,nIndex
	Local cQuery
#ELSE
	Local cArq	
#ENDIF	
Local aSitua := ARRAY(8)
Local nI:=0
Local nMoedaBco := 1
Local nDecs := MsDecimais(mv_par09)
Local cFiltro, cIndTmp, cAliasTmp
Local nTipoData := 1
Local lAdto
Local nValAbat := 0
Local nAbt		:= 0
Local nTamFilial:= IIf( lFWCodFil, FWGETTAMFILIAL, 2 )
Local dDataBase:=mv_par13
/*
GESTAO - inicio */
Local aTmpFil		:= {}
Local cTmpFil		:= {}
Local cFilOrig		:= ""
Local cFilTit		:= ""
Local cAliasSC6		:= ""

DEFAULT aSelFil 	:= {cFilAnt}
/* GESTAO - fim
*/
DEFAULT cFiltSE1 := ""
DEFAULT cFiltSED := ""

aSitua[1] := OemtoAnsi(STR0028)		//"Carteira"
aSitua[2] := OemtoAnsi(STR0029)		//"Cobranca Simples"
aSitua[3] := OemToAnsi(STR0030) 		//"Cobranca Descontada"
aSitua[4] := OemToAnsi(STR0031) 		//"Cobranca Caucionada"
aSitua[5] := OemToAnsi(STR0032)		//"Cobranca Vinculada"
aSitua[6] := OemToAnsi(STR0033)		//"Cobranca Extra-Judicial"
aSitua[7] := OemToAnsi(STR0034)	   //"Cobranca Cartorio"
aSitua[8] := OemToAnsi(STR0035) 	   //"Cobr Cauc Descont"

//Tipo da data para a composicao do saldo via SaldoTit()
If mv_par02 == 1			// Data da baixa (E5_BAIXA)
	nTipoData := 1
ElseIf mv_par02 == 2 	//Data de Digitacao (E5_DTDIGIT)
	nTipoData := 3
Else							//Data de Disponibilidade (E5_DTDISPO)
	nTipoData := 2
Endif

dbSelectArea("SX5")
dbSeek( Space( nTamFilial ) +"07")

While !Eof() .and. X5_TABELA == "07"

	nI++
	If nI > Len(aSitua)
		Aadd(aSitua," ")		// garante um novo elemento
	Endif
	aSitua[nI] := TRIM(X5Descri())
	dbSkip()
Enddo

PRIVATE  cTipos := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se seleciona tipos para total faturamento         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par03 == 1
	finaTipos()
Endif

dbSelectArea("SE1")
dbSetOrder(1)
If mv_par01 == 1
	dbSeek(xFilial("SE1"))
Else 
	dbGotop()
Endif

For i := 1 to 45
	For j := 1 to 2
		aVal[I,J] := 0
	Next j
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra APENAS os emitidos antes da database, pois este rela³
//³ torio pode ser retroativo.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	IF TcSrvType() != "AS/400"
		aStru  := SE1->(dbStruct())
		cAliasTmp := "FINR320"
		cQuery := ""
		aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery +=         ",R_E_C_N_O_ RECNO "
		cQuery += "FROM "+RetSqlName("SE1")+ " SE1 "
		cQuery += "WHERE "
		/*
		GESTAO - inicio */
		If !Empty(aSelFil)
			cQuery += "SE1.E1_FILIAL " + GetRngFil( aSelFil, "SE1", .T., @cTmpFil) + " AND "
			Aadd(aTmpFil,cTmpFil)
		Else
		   	cQuery += "SE1.E1_FILIAL = '" + xFilial("SE1") + "' AND "
		Endif
		/* GESTAO - fim
		*/
		If mv_par14 == 2 //Nao considerar titulos com emissao futura
			cQuery += "SE1.E1_EMISSAO <= '"+Dtos(dDataBase)+"' AND "
		Endif	                                                    
		If mv_par08 == 1 .and. valtype(mv_par13)=="D"
			cQuery += "SE1.E1_EMIS1  <= '"+DTOS(mv_par13)+"' AND "
		Endif		
		cQuery += "SE1.E1_PREFIXO >= '"+MV_PAR04+"' AND "	
		cQuery += "SE1.E1_PREFIXO <= '"+MV_PAR05+"' AND "
		If mv_par10 == 2 
			cQuery += "SE1.E1_MOEDA = "+Str(MV_PAR09,2)+" AND "
		Endif 
		cQuery += "SE1.E1_SALDO >= '0' AND "	
		cQuery += "SE1.D_E_L_E_T_=' ' "
   	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)	         //LEANDRO
		For nX :=  1 To Len(aStru)
			If aStru[nX][2] <> "C"
				TcSetField(cAliasTmp,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	Else
#ENDIF
		cFiltro := ""
		If Mv_par01 == 1
			cFiltro += "E1_FILIAL>='"+xFilial("SE1")+"'.And."
		Endif
		If MV_PAR14 == 2 //Nao considerar titulos com emissao futura
			cFiltro += "Dtos(E1_EMISSAO)<='"+Dtos(dDataBase)+"'.And."
		Endif	
		cFiltro += "E1_PREFIXO>='"+MV_PAR04+"'.And."	
		cFiltro += "E1_PREFIXO<='"+MV_PAR05+"'"
		If mv_par10 == 2 
			cFiltro += ".And.E1_MOEDA == "+Str(MV_PAR09,2)
		Endif	
		dbSelectArea("SE1")
		dbSetOrder(1)
		cIndTmp := CriaTrab(,.F.)
		dbGotop()
		cAliasTmp := "SE1"
#IFDEF TOP
	Endif
#ENDIF

dbSelectArea(cAliasTmp)
/*
GESTAO - inicio */
cFilOrig := cFilAnt
/* GESTAO - fim
*/
While !Eof()

	dbSelectArea(cAliasTmp)
	/*
	GESTAO - inicio */
	cFilAnt := (cAliasTmp)->E1_FILORIG
	/* GESTAO - fim
	*/
   	If mv_par03 == 1
		If !Inside(E1_TIPO)
			dbSkip()
			Loop
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario - SE1                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFiltSE1).and.!(&cFiltSE1)
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario - SED                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFiltSED)                       
		SED->(DbSetOrder(1))
		SED->(MsSeek(xFilial()+SE1->E1_NATUREZ)) 
		If SED->(!&(cFiltSED))
			SE1->(DbSkip())		
			Loop
		Endif
	Endif		
		
	IF !Empty(E1_FATURA) .and. Substr(E1_FATURA,1,6) != "NOTFAT" .and. E1_DTFATUR <= dDataBase
		dbSkip()
		Loop
	Endif
	/*
	GESTAO - inicio */
	#IFNDEF TOP 	
		If mv_par01 == 1 .and. E1_FILIAL != xFilial("SE1")
			Exit
		EndIF
	#ENDIF
	/* GESTAO - fim 
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica se ‚ provis¢rio ou abatimento ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If E1_TIPO $ MVPROVIS+"/"+MVABATIM
    	If E1_TIPO $ MVABATIM	//Somo o valor caso seja abatimento 
      		If mv_par11 == 1  
				nAbt := IIF(dDatabase < E1_BAIXA, xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0)), xMoeda(E1_SALDO,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0)))		// no resumo por tipo de titulos
				aVal[35,1] += nAbt
				aVal[35,2] += IIF(nAbt > 0,1,0)
			Endif
		Else            
        	aVal[16,1] += xMoeda(E1_SALDO,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
			aVal[16,2] += IIF(SE1->E1_SALDO > 0,1,0)
		Endif
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o faturamento baseado na data base/item 1 analise    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Month(E1_EMISSAO) == Month(dDatabase) .and. Year(E1_EMISSAO) == Year(dDataBase)
		If !(E1_TIPO $MV_CRNEG+"/"+MVRECANT)
			nDias := (E1_VENCREA - E1_EMISSAO)
			If nDias <= 1 
				aVal[1,1] += xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
				aVal[1,2] += 1
			Else
				aVal[2,1] += xMoeda(E1_VALOR,E1_MOEDA,MV_PAR09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
				aVal[2,2] += 1
			Endif
		Endif
	Endif
    
	nSaldoAtu := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acumula titulos vencidos/vencer / Item 2 e 3 da analise      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		IF TcSrvType() != "AS/400"
			// Posiciona SE2 ou SE1 para pegar o saldo do titulo correto
			SE1->(DbGoto((cAliasTmp)->RECNO))
		Endif	
	#ENDIF 
	
	
	
If mv_par08 == 1    // Considera Data Base
	 dDataBase := mv_par13
Endif	

	If mv_par08 == 1
		IF !Empty(SE1->E1_BAIXA) .and. IIF(mv_par02 == 1,(SE1->E1_SALDO == 0 .and. SE1->E1_BAIXA <= dDataBase),.F.)
			nSaldoAtu := 0
		Else
			nSaldoAtu := SaldoTit( 	E1_PREFIXO,;
										E1_NUM,;
										E1_PARCELA,;
										E1_TIPO,;
										E1_NATUREZ,;
										"R",;
										E1_CLIENTE,;
										MV_PAR09,;
										dDataBase,;
										dDataBase,;
										E1_LOJA,;
										E1_FILIAL,;
										IIf(cPaisLoc=="BRA",E1_TXMOEDA,0),nTipoData )

			// Subtrai decrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldoAtu,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
				nSaldoAtu -= SE1->E1_DECRESC
			Endif
			// Soma Acrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldoAtu,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
				nSaldoAtu += SE1->E1_ACRESC
			Endif
			
		Endif
	Else       
		If cPaisLoc == "BRA"
			nSaldoAtu := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),E1_MOEDA,mv_par09,,,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
		Else
			nSaldoAtu := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
		EndIf
	Endif
	
	nSaldoAtu -= FaDescFin("SE1",dDataBase,nSaldoAtu,1)
	
	nValAbat := 0		
	If !(E1_TIPO $MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM)
		// Se considerar titulos com emissao futura, envia a data de ref. para Somaabat para que ela considere os
		// titulos de abatimento com emissao <= Database + 40 anos (30 * 480) - Emissao futura
		nValAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",1,,E1_CLIENTE,E1_LOJA,E1_FILIAL,If(mv_par14==1,dDataBase+(30*480),dDataBase))
	Endif
	
	If nSaldoAtu > 0 .and. (mv_par11 == 1 .or. STR(nSaldoAtu,17,2) == STR(nValAbat,17,2))
		nSaldoAtu-= nValAbat
	Endif  
  	nSaldoAtu:=Round(NoRound(nSaldoAtu,3),2)

	If nSaldoAtu > 0
		dBaixa := dDataBase
		nJuros := 0
		If mv_par06 == 1
			fa070juros(mv_par09)
		Endif

		lAdto := E1_TIPO $ MVRECANT+"/"+MV_CRNEG

		If E1_VENCREA < dDataBase
			nSaldoAtu+=nJuros
			nDias := (dDatabase - E1_VENCTO)
	
			aVal[34,1] += nSaldoAtu

			If !lAdto
				If nDias <= 15
					aVal[38,1] += nSaldoAtu
					aVal[38,2] += 1
				ElseIf nDias > 15 .And. nDias <= 30
					aVal[3,1] += nSaldoAtu
					aVal[3,2] += 1
				ElseIf nDias > 30 .And. nDias <= 60
					aVal[4,1] += nSaldoAtu
					aVal[4,2] += 1
				ElseIf nDias > 60 .And. nDias <= 90
					aVal[5,1] += nSaldoAtu
					aVal[5,2] += 1
				Else
					aVal[6,1] += nSaldoAtu
					aVal[6,2] += 1
				Endif
			Endif
		Else
			If !lAdto
				aVal[34,1] += nSaldoAtu
	         	nDias      := (E1_VENCREA - dDatabase)
				If nDias <= 15
    	   	  		aVal[39,1] += nSaldoAtu
    		   		aVal[39,2] += 1
	            ElseIf nDias > 15 .And. nDias <= 30
    	        	aVal[7,1] += nSaldoAtu
        	    	aVal[7,2] += 1
	         	ElseIf nDias > 30 .And. nDias <= 60
    	       		aVal[8,1] += nSaldoAtu
        	    	aVal[8,2] += 1
	         	ElseIf nDias > 60 .And. nDias <= 90
    	       		aVal[9,1] += nSaldoAtu
        	    	aVal[9,2] += 1
	         	Else
    	       		aVal[10,1] += nSaldoAtu
        	    	aVal[10,2] += 1
	         	EndIF
			Endif
		EndIF
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a distribuicao de cobranca / item 4  analise         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nSaldoAtu > 0
		IF !(E1_TIPO $MV_CRNEG+"/"+MVRECANT)
			Do Case
				Case E1_SITUACA   $ " 0FG"
					aVal[25,1] += nSaldoAtu
					aVal[25,2] += 1
				Case E1_SITUACA   $ "1H"
					aVal[26,1] += nSaldoAtu
					aVal[26,2] += 1
				Case E1_SITUACA   = "2"
					aVal[27,1] += nSaldoAtu
					aVal[27,2] += 1
				Case E1_SITUACA   = "3"
					aVal[28,1] += nSaldoAtu
					aVal[28,2] += 1
				Case E1_SITUACA   = "4"
					aVal[29,1] += nSaldoAtu
					aVal[29,2] += 1
				Case E1_SITUACA   = "5"
					aVal[30,1] += nSaldoAtu
					aVal[30,2] += 1
				Case E1_SITUACA   = "6"
					aVal[31,1] += nSaldoAtu
					aVal[31,2] += 1
				Case E1_SITUACA   = "7"
					aVal[37,1] += nSaldoAtu
					aVal[37,2] += 1
			EndCase
		Endif
	Endif
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor Recebido.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilTit := cFilAnt
	If nFirst1 == 1
		SA6->(dbSetorder(1)) // para pegar a moeda do banco.
		dbSelectArea("SE5") 
		If mv_par01 == 1
			dbSeek(xFilial("SE5"))
		Else
			dbGotop()
		Endif
		#IFDEF TOP
			IF TcSrvType() != "AS/400"
				aStru  := SE5->(dbStruct())
				cAliasSe5 := "NEWSE5"
				cCondFil := ""
				aEval(aStru,{|x| cCondFil += ","+AllTrim(x[1])})
				cCondFil := "SELECT "+SubStr(cCondFil,2)
				cCondFil +=         ",R_E_C_N_O_ RECNO "
				cCondFil += "FROM "+RetSqlName("SE5") + " SE5 "
				cCondFil += "WHERE "
				/*
				GESTAO - inicio */
				If !Empty(aSelFil)
					cCondFil += "E5_FILIAL " + GetRngFil( aSelFil, "SE5", .T., @cTmpFil) + " AND "
					Aadd(aTmpFil,cTmpFil)
				Else
	   				cCondFil += "E5_FILIAL = '" + xFilial("SE5") + "' AND "
				Endif
				/* GESTAO - fim
				*/
				cCondFil += "E5_TIPODOC IN ('VL','V2','JR','J2','CM','C2','MT','M2','DC','D2','TL','BA') AND E5_RECPAG = 'R' AND "
				cCondFil += "E5_PREFIXO >= '"+MV_PAR04+"' AND "	
				cCondFil += "E5_PREFIXO <= '"+MV_PAR05+"' AND "
	            If mv_par02 == 1
					cCondFil += "E5_DATA >= '"
				ElseIf mv_par02 == 2
					cCondFil += "E5_DTDIGIT >= '"
				ElseIf mv_par02 == 3
					cCondFil += "E5_DTDISPO >= '"
				Endif				
				cCondFIl += Subs(dtos(dDataBase),1,6)+"01"+"' AND "
	            If mv_par02 == 1
					cCondFil += "E5_DATA <= '"
				ElseIf mv_par02 == 2
					cCondFil += "E5_DTDIGIT <= '"
				ElseIf mv_par02 == 3
					cCondFil += "E5_DTDISPO <= '"
				Endif				
				cCondFIl += Dtos(LastDay(dDataBase))+"' AND "
				cCondFil += "D_E_L_E_T_=' ' "
		   	
				cCondFil := ChangeQuery(cCondFil)
		   	
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCondFil),cAliasSe5,.T.,.T.)
				For nX :=  1 To Len(aStru)
					If aStru[nX][2] <> "C"
						TcSetField(cAliasSe5,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
					EndIf
				Next nX
			Else
		#ENDIF
				cCondFil := ""
				If mv_par01 == 1
					cCondFil += "E5_FILIAL=='" + xFilial("SE5") + "' .And. "
				Endif
				cCondFil += "E5_TIPODOC$'VL/V2/JR/J2/CM/C2/MT/M2/DC/D2/TL/BA' .and. E5_RECPAG == 'R' .and. "
				cCondFil += "E5_PREFIXO>='"+MV_PAR04+"'.And."	
				ccondFil += "E5_PREFIXO<='"+MV_PAR05+"'.And."
	            If mv_par02 == 1
					cCondFil += "DTOS(E5_DATA) >= '"
				ElseIf mv_par02 == 2
					cCondFil += "DTOS(E5_DTDIGIT) >= '"
				ElseIf mv_par02 == 3
					cCondFil += "DTOS(E5_DTDISPO) >= '"
				Endif				
				cCOndFIl += Subs(dtos(dDataBase),1,6)+"01"+"'.and."
	            If mv_par02 == 1
					cCondFil += "DTOS(E5_DATA) <= '"
				ElseIf mv_par02 == 2
					cCondFil += "DTOS(E5_DTDIGIT) <= '"
				ElseIf mv_par02 == 3
					cCondFil += "DTOS(E5_DTDISPO) <= '"
				Endif				
				cCOndFIl += Dtos(LastDay(dDataBase))+"'"
				cArq :=CriaTrab(NIL,.F.)
				IndRegua("SE5",cArq,IndexKey(),,)
				nIndex:=RetIndex("SE5")
				#IFNDEF TOP
					dbSetIndex(cArq+OrdBagExt())
				#ENDIF					 
				dbSetOrder(nIndex+1)
				cAliasSe5 := "SE5"
				DbGoTop()
		#IFDEF TOP
			Endif
		#ENDIF
		
		DbSelectArea(cAliasSe5)
		DbGoTop()
		/*
		GESTAO - inicio */
		#IFDEF TOP
			While !Eof()
				cFilAnt := (cAliasSE5)->E5_FILIAL
		#ELSE
			While (mv_par01 != 1 .OR. xFilial("SE5") == (cAliasSe5)->E5_FILIAL) .AND. !Eof()
		#ENDIF
		/* GESTAO - fim
		*/
        	// Ignora registros que nao sao da moeda quando escolhido nao imprimir
			SA6->(dbSeek(xFilial()+(cAliasSe5)->E5_BANCO+(cAliasSe5)->E5_AGENCIA+(cAliasSe5)->E5_CONTA))
         If mv_par10 == 2 .AND. Max(SA6->A6_MOEDA, 1) != mv_par09 
         	dbSkip()
            Loop
			Endif                 
     
	     	nMoedaBco := If(SA6->(Found()), Max(SA6->A6_MOEDA, 1), 1)

			If mv_par02 == 1
		  		dDataBaixa := (cAliasSe5)->E5_DATA
			ElseIf mv_par02 == 2
		  		dDataBaixa := (cAliasSe5)->E5_DTDIGIT
			ElseIf mv_par02 == 3
		  		dDataBaixa := (cAliasSe5)->E5_DTDISPO
			Endif				
            
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Valor Recebido.   ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Month(dDatabase)== Month(dDataBaixa) .and.;
				Year(dDataBase) ==Year(dDataBaixa)   .and.;
				(cAliasSe5)->E5_RECPAG=="R" .and. dDataBaixa <= dDatabase .AND.;
				(cAliasSe5)->E5_TIPODOC$"VL/V2/BA" ;
				.and.  (cAliasSe5)->E5_SITUACA <> "C" .and. ;
				(	MovBcoBx((cAliasSe5)->E5_MOTBX) .or. ;
				((cAliasSe5)->E5_MOTBX=="CMP" .and. (cAliasSe5)->E5_TIPO $ MVRECANT+"#"+MV_CRNEG ) )			

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe estorno para esta baixa                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				#IFDEF TOP
					IF TcSrvType() != "AS/400"
						SE5->(dbGoto((cAliasSe5)->RECNO))
					Endif
				#ENDIF	
				If !TemBxCanc((cAliasSe5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
					nRecebido += xMoeda((cAliasSe5)->E5_VALOR,nMoedaBco,mv_par09,(cAliasSe5)->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",(cAliasSe5)->E5_TXMOEDA,0)) 
				Else
					AADD(aRota,(cAliasSe5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) )
				EndIf
			EndIf

	      If Month(dDatabase) = Month(dDataBaixa) .and. ;
	      	Year(dDataBase)  = Year(dDataBaixa)  .and. (cAliasSe5)->E5_RECPAG=="R" .and. ;
	         dDataBaixa <= dDatabase .and. (cAliasSe5)->E5_SITUACA <> "C" .and. ;
	         MovBcoBx((cAliasSe5)->E5_MOTBX) 
   	         nValorE5 := xMoeda((cAliasSe5)->E5_VALOR,nMoedaBco,mv_par09,(cAliasSe5)->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",(cAliasSe5)->E5_TXMOEDA,0))
	         Do Case 
	         	Case (cAliasSe5)->E5_TIPODOC $ "JR/J2/TL"  //Valor juros
	            	nValJuros += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "CM/C2"     //Valor da correcao
	            	nCorrecao += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "MT/M2"     //Valor da Multa
	            	nMulta    += nValorE5
					Case (cAliasSe5)->E5_TIPODOC $ "DC/D2"     //Valor do Desconto
	            	ndesconto += nValorE5
				EndCase
			EndIf
			dbSelectArea(cAliasSe5)
	      dbSkip()
		Enddo
		#IFDEF TOP
			IF TcSrvType() != "AS/400"
				dbSelectArea(cAliasSe5)
				dbCloseArea()
				dbSelectArea("SE5")
			Else
		#ENDIF
				dbSelectArea("SE5")
				DbClearFil()
				RetIndex("SE5")
				FErase(cArq+OrdBagExt())
		#IFDEF TOP
			Endif
		#ENDIF
		nFirst1++
		dbSelectArea(cAliasTmp)
	EndIf
	/*
	GESTAO - inicio */
	cFilAnt := cFilTit
	/* GESTAO - fim
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a distribuicao por tipo de titulo / item 5 analise   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nSaldoAtu > 0 .and. (mv_par14 == 1 .Or. E1_EMISSAO <= dDatabase)
		Do Case
			Case E1_TIPO  $ MVDUPLIC
				aVal[11,1] += nSaldoAtu
            aVal[11,2] += 1
			Case E1_TIPO  $ MVNOTAFIS
				aVal[12,1] += nSaldoAtu
				aVal[12,2] += 1
			Case E1_TIPO  $ MVCHEQUES
				aVal[13,1] += nSaldoAtu
				aVal[13,2] += 1
			Case E1_TIPO   = "CN"
				aVal[14,1] += nSaldoAtu
				aVal[14,2] += 1
			Case E1_TIPO  $ MVTAXA
				aVal[15,1] += nSaldoAtu
				aVal[15,2] += 1
			Case E1_TIPO  $ MVRECANT
				aVal[24,1] += nSaldoAtu
				aVal[24,2] += 1
			Case E1_TIPO $ MV_CRNEG				
				aVal[36,1] += nSaldoAtu
				aVal[36,2] += 1
			OtherWise
				aVal[16,1]  += nSaldoAtu
				aVal[16,2]  += 1	
		EndCase
	End
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula T.Carteira pedidos a entregar / item 6 da analise    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nFirst == 1 .and. mv_par12 == 1	
		dbSelectArea("SC6")
		cCondSC6 := 'C6_QTDVEN > C6_QTDENT '
		cArq :=CriaTrab("",.F.)
		nIndex:=RetIndex("SC6")
/*		#IFNDEF TOP
			dbSetIndex(cArq+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)*/
		/* 
		GESTAO - inicio */
		#IFDEF TOP
			cCondFil := "select R_E_C_N_O_ from " + RetSQLName("SC6") + " where"
			If Empty(aSelFil)
				cCondFil += " C6_FILIAL = '" + xFilial("SC6") + "'"
			Else
				cCondFil += " C6_FILIAL " + GetRngFil( aSelFil, "SC6", .T., @cTmpFil)
				Aadd(aTmpFil,cTmpFil)
			Endif
			cCondFil += " and D_E_L_E_T_ = ''"
			cCondFil += " order by C6_FILIAL,C6_NUM"
			cCondFil := ChangeQuery(cCondFil)
			cAliasSC6 := GetNextAlias()
		   	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCondFil),cAliasSC6,.T.,.T.)
		#ELSE
			DbSelectArea("SC6")
			cAliasTmp := "SC6"
			If mv_par01 == 1
				dbSeek(cFilial)
			Else
				dbGotop()
			Endif
		#ENDIF
        /* GESTAO - fim
       */
		While !((cAliasSC6)->(Eof()))
			/*
			GESTAO - inicio */
			#IFDEF TOP
				SC6->(DbGoto((cAliasSC6)->R_E_C_N_O_))
			#ELSE
	         	IF mv_par01 == 1 .and. cFilial != C6_FILIAL
					Exit
         		Endif
        	#ENDIF
         	/* GESTAO fim
        	*/
         	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         	//³ Posicionar do SC5 para localiza moeda do pedido              ³
         	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         	dbSelectArea( "SC5" )
         	dbSeek( cFilial + SC6->C6_NUM )
         	dbSelectArea( "SC6" )

		 	// Calcula se moeda for igual a escolhida ou for para converter
		 	If SC5->C5_MOEDA == mv_par09 .OR. mv_par10 == 1             
            	nSaldo := xMoeda(u_xF320Sld(),SC5->C5_MOEDA, mv_par09,SC5->C5_EMISSAO,nDecs+1)
            	If nSaldo > 0
					If dDatabase < C6_ENTREG // itens a vencer					 
						nDias := (C6_ENTREG - dDatabase)
						If nDias <= 30
							aVal[17,2]++
							aVal[17,1]+= nSaldo
						ElseIf nDias > 30 .And. nDias <= 60
							aVal[18,2]++
							aVal[18,1]+= nSaldo
						ElseIf nDias > 60 .And. nDias <= 90
							aVal[19,2]++
							aVal[19,1]+= nSaldo
						Else
							aVal[20,2]++
							aVal[20,1]+= nSaldo
						Endif
					Else // itens vencidos
						nDias := (dDatabase - C6_ENTREG)
						aVal[21,2]++
						aVal[21,1]+= nSaldo
					EndIf
				Endif
			Endif
			(cAliasSC6)->(dbSkip())
		EndDo
		RetIndex("SC6")
		Set Filter to
		Ferase(cArq+OrdBagExt())
		nFirst++
		#IFDEF TOP
			dbSelectArea(cAliasSC6)
			dbCloseArea()
		#ENDIF
		dbSelectArea(cAliasTmp)
	Endif
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o P.M.A e P.M.P - indices / item 7 da analise        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nSaldoAtu != 0
		aVal[22,1] += (E1_VENCREA-E1_EMISSAO)
		aVal[22,2] += 1
		aVal[23,1] += (E1_VENCREA-E1_EMISSAO)*;
					   xMoeda(nSaldoAtu,E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
		aVal[23,2] +=  xMoeda(nSaldoAtu,E1_MOEDA,mv_par09,E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",E1_TXMOEDA,0))
	EndIf
	dbSelectArea(cAliasTmp)
	nSaldoAtu:=0
	dbSkip()
Enddo
/*
GESTAO - inicio */
cFilAnt := cFilOrig
/* GESTAO - fim
*/
#IFDEF TOP
	IF TcSrvType() != "AS/400"
		/*
		GESTAO - inicio */
		If !Empty(aTmpFil)
			For nI := 1 To Len(aTmpFil)
				CtbTmpErase(aTmpFil[nI])
			Next
		Endif
		/* GESTAO - fim 
		*/
		dbSelectArea(cAliasTmp)
		dbCloseArea()
		dbSelectArea("SE1")
	Else
#ENDIF
		dbSelectArea("SE1")
		DbClearFil()
		RetIndex("SE1")
		FErase(cIndTmp+OrdBagExt())
#IFDEF TOP
	Endif
#ENDIF

dbSelectArea("SE1")
dbSetOrder(1)
Set Filter to
dbSelectArea("SE5")
dbSetOrder(1)
Set Filter to

aVal[40,1] := nRecebido
aVal[41,1] := nValJuros
aVal[42,1] := nMulta           
aVal[43,1] := nCorrecao        
aVal[44,1] := nDesconto			
aVal[45,1] := nRecebido-(nValJuros+nMulta+nCorrecao-nDesconto)  
dDataBase := dOldDtBase // Restaura Data base

Return aVal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AJUSTASX1p ºAutor³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
Local aArea		:= {}
/*
GESTAO - inicio */
Local aHelpPor	:= {}			
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aArea := GetArea()
/* GESTAO - fim
*/
If (cPaisLoc == "BRA")
   DbSelectarea("SX1")
   DbSetOrder(1)
   If dbSeek("FIN320    07")
   	RecLock("SX1")
		Replace X1_DEF02 	 With "Não Considera"			
		MsUnlock()
   Endif
EndIf  
/*
GESTAO - inicio */
aHelpPor := {"Selecione se a impressão será por",'"Filial ou por "Empresa".'}
aHelpEng := {"Indicate if the printing will be per",'"Branch" or per "Company".'}
aHelpSpa := {"Indique si la impresion sera por",'"Sucursal" o por "Empresa".'}

PutSX1Help("P.FIN32001.",aHelpPor,aHelpEng,aHelpSpa,.T.)
/* GESTAO - fim
*/
RestArea(aArea)
Return
