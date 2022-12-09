#INCLUDE "MATR430.CH"
#INCLUDE "PROTHEUS.CH"
#include 'fileio.ch'
#Include "TOPCONN.CH"


Static __lMC010DES := ExistBlock('MC010DES')
Static lSB1Ok //variavel utilizada para que a verificação da tabela seja feita uma unica vez no processo.  
Static lPCPREVATU	:= FindFunction('PCPREVATU') 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR430  ³ Autor ³ Ricardo Berti         ³ Data ³07.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Planilha de Formacao de Precos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Matr430X()

Local oReport

Public nSimulados	:=	GetNewPar("MV_XFPSIM",1.00)
Public _dDataCtb	:=	GetNewPar("MV_XFPDTC",dDataBase)
Public _nIcmsSP		:=	GetNewPar("MV_XFPISP",18.00)
Public _nIcmsSE		:=	GetNewPar("MV_XFPISE",12.00)
Public _nIcmsNE		:=	GetNewPar("MV_XFPINE",07.00)
Public _nComis		:=	GetNewPar("MV_XFPCOM",00.00)
Public _nMargem		:=	GetNewPar("MV_XFPMRG",10.00)
Public _nMargem		:=	GetNewPar("MV_XFPMRG",10.00)
Public _nPlanilha	:=  GetNewPar("MV_XFPPLN",1)		// Tipo Planilha 1- Simulado, 2-Faturado, 3-Produzido
Public _nRescisao	:=	GetNewPar("MV_XFPRES",1)		// Abate Rescisão? 1 - Sim, 2 - Não
Public nProduzido	:= U_RESTA012()	
Public nFaturados	:= U_RESTA013()	
Public nQuantidade  := Iif(_nPlanilha==1,nSimulados,Iif(_nPlanilha==2,U_RESTA013(),Iif(_nPlanilha==3,U_RESTA012(),nQuantidade)) )
Public cTit			:= ''
Public _nLinha       := Iif(Type("n")<>"U",n,1)
Public aCustos		:= {{'004','1.1',"1.1.999.999",0.00000000},;
						{'005','2.1',"2.1.999.999",0.00000000},;
						{'006','3.1',"3.1.999.999",0.00000000},;
						{'007','1.2.013',"1.2.013.000",0.00000000},;
						{'008','1.2.015',"1.2.015.000",0.00000000},;
						{'009','1.2.016',"1.2.016.000",0.00000000},;
						{'010','1.2.028',"1.2.028.000",0.00000000},;
						{'011','1.2.029',"1.2.029.000",0.00000000},;
						{'014','1.1',"1.1.999.999",0.00000000},;
						{'015',"2.1","2.1.999.999",0.00000000},;
						{'016',"3.1","3.1.999.999",0.00000000},;
						{'017',"4.2.000.999","4.2.000.999",0.00000000}}

U_FVlrSimul(.F.)

oReport := ReportDef()
oReport:PrintDialog()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Ricardo Berti 		³ Data ³07.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR430                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oCell         
Local cPerg	:= "MTR430"
Local oReport 
Local oSection
Local nI
Local cPicQuant	:=PesqPictQt("G1_QUANT",13)
Local cPicUnit	:=PesqPict("SB1","B1_CUSTD",18)
Local cPicTot	:=PesqPict("SB1","B1_CUSTD",19)

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
oReport := TReport():New("MATR430",STR0004,cPerg, {|oReport| ReportPrint(oReport)},STR0001+" "+STR0002+" "+STR0003)  	//"Emite um relatorio com os calculos da planilha selecionada pa-"##"ra cada produto. Os valores calculados sao os mesmos  referen-"###"tes as formulas da planilha."
oReport:nFontBody := 9

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Produto inicial                              ³
//³ mv_par02     // Produto final                                ³
//³ mv_par03     // Nome da planilha utilizada                   ³
//³ mv_par04     // Imprime estrutura : Sim / Nao                ³
//³ mv_par05     // Moeda Secundaria  : 1 2 3 4 5                ³
//³ mv_par06     // Nivel de detalhamento da estrutura           ³
//³ mv_par07     // Qual a Quantidade Basica                     ³
//³ mv_par08     // Considera Qtde Neg na estrutura: Sim/Nao     ³
//³ mv_par09     // Considera Estrutura / Pre Estrutura          ³
//³ mv_par10     // Revisao da Estrutura 				         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Forca utilizacao da estrutura caso nao tenha SGG               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SGG") == 0
	mv_par09 := 1
EndIf
oSection := TRSection():New(oReport,STR0015,{"SB1"}) //"Produtos"
oSection:SetHeaderPage()

TRCell():New(oSection,"CEL"		,"",STR0012/*Titulo*/,"99999"/*Picture*/,5/*Tamanho*/,/*lPixel*/,/*{|| Code block }*/) //"Cel."
TRCell():New(oSection,"NIVEL"	,"",RetTitle("G1_NIV"),"XXXXXX",6)
TRCell():New(oSection,"B1_COD"	,"SB1")
TRCell():New(oSection,"B1_DESC"	,"SB1",,,30)
TRCell():New(oSection,"B1_UM"	,"SB1")
TRCell():New(oSection,"cOpcion"	,"",'Opcional')
TRCell():New(oSection,"QUANT"	,"",RetTitle("G1_QUANT"),cPicQuant)
TRCell():New(oSection,"VALUNI"	,"",STR0013,cPicUnit) //"Valor Unitario"
TRCell():New(oSection,"VALTOT"	,"",STR0014,cPicTot) //"Valor Total"
TRCell():New(oSection,"VALUNI2" ,"",STR0013,cPicUnit) //"Valor Unitario"
TRCell():New(oSection,"VALTOT2" ,"",STR0014,cPicTot) //"Valor Total"
TRCell():New(oSection,"PERCENT","",STR0009,"999.999",7) //"% Part"

Return(oReport)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Ricardo Berti 		³ Data ³07.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local aArray	:= {}
Local aArray1	:= {}
Local aPar		:= Array(20)
Local aParC010	:= Array(20)
Local lFirstCb	:= .T.
Local nReg
Local nI, nX
Local oSection  := oReport:Section(1)
LOCAL cCondFiltr:= ""
Local lProdBlq := .T.
Local lRevPlan := SuperGetMV("MV_REVPLAN",.F.,.F.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cProg:="R430"  // Usada na funcao externa MontStru()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Custo a ser considerado nos calculos                           ³
//³ 1 = STANDARD    2 = MEDIO     3 = MOEDA2     4 = MOEDA3        ³
//³ 5 = MOEDA4      6 = MOEDA5    7 = ULTPRECO   8 = PLANILHA      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nQualCusto := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vetor declarado para inversao do calculo do Valor Unitario   ³
//³ Utilizado no MATC010X -> M010Forma e CalcTot                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aAuxCusto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nome do arquivo que contem a memoria de calculo desta planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cArqMemo := "STANDARD"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Direcao do calculo .T. para baixo .F. para cima                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lDirecao := .T.

PRIVATE lConsNeg := (mv_par08 = 1)     // Esta variavel sera' usada na funcao MC010FORMA



//Salvar variaveis existentes
For ni := 1 to 20
	aPar[ni] := &("mv_par"+StrZero(ni,2))
Next ni

Pergunte("MTC010", .F.)
lProdBlq := Iif(!Empty(mv_par13),mv_par13 == 2,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Forca utilizacao da estrutura caso nao tenha SGG               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SGG") == 0
	mv_par09 := 1
EndIf
//Salvar variaveis existentes
For ni := 1 to 20
	aParC010[ni] := &("mv_par"+StrZero(ni,2))
Next ni
//Forca mesmo valor do relatorio na pergunta 09
mv_par09     := aPar[09]
aParC010[09] := aPar[09]

// Restaura parametros MTR430
For ni := 1 to 20
	&("mv_par"+StrZero(ni,2)) := aPar[ni]
Next ni

oReport:NoUserFilter()  // Desabilita a aplicacao do filtro do usuario no filtro/query das secoes

dbSelectArea("SB1")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao Advpl                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeAdvplExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mantem o Cad.Produtos posicionado para cada linha impressa da planilha   ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSection,"SB1",1,{|| xFilial("SB1") + aArray[nX][04] })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o nome padrao da planilha com o nome selecionado pelo usuario ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqMemo := apar[03]

If MR430Plan(.T.,aPar)

	If apar[05] == 1
		oSection:Cell("VALUNI2"):Disable()
		oSection:Cell("VALTOT2"):Disable()
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do fluxo do relatorio                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter(SB1->(LastRec()))
	dbSeek(xFilial("SB1")+apar[01],.T.)

	oSection:Init() 


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Este procedimento e' necessario p/ transformar o filtro selecionado  ³
	//³ pelo usuario em uma condicao de IF, isto porque o filtro age em todo ³
	//³ o arquivo e devido `a posterior explosao de niveis da estrutura, em  ³
	//³ MATC010X-> M010Forma(), o filtro deve ser validado apenas no While   ³
	//³ principal															 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCondFiltr := oSection:GetAdvplExp()
	If Empty(cCondFiltr)
		cCondFiltr := ".T."
	EndIf
	oReport:cTitle := 'Formação Preços - Data Referencia: ' + DtoC(_dDataCtb) + ' ' + Iif(_nPlanilha==1,'Simulação',Iif(_nPlanilha==2,'Faturamento',Iif(_nPlanilha==3,'Produção','')) )+' - R$ ' + TransForm(nQuantidade,'@E 9,999,999,999.99')
	lPrimeiro := .T.
	While !oReport:Cancel() .And. !SB1->(Eof()) .And. ;
		SB1->B1_FILIAL == xFilial("SB1") .And. SB1->B1_COD <= apar[02]

		If oReport:Cancel()
			Exit
		EndIf
		
		If lPrimeiro	// Chama o Filtro de Opcionais, e Tipo de Custo Apenas 1 Vez
			aOpcionais := RetOpc(SB1->B1_COD)
			nQualCusto := MV_PAR03
			lPrimeiro := .F.
		Endif
		
		For nOpcItem := 1 To Len(aOpcionais)
			cGrpOpc := PadR(aOpcionais[nOpcItem,1],TamSX3("GA_GROPC")[1])
			cOpcion := PadR(aOpcionais[nOpcItem,2],TamSX3("GA_OPC")[1])

			If !SGA->(dbSetOrder(1), dbSeek(xFilial("SGA")+cGrpOpc+cOpcion))
				Loop
			Endif
			
			cOpc    := cGrpOpc+cOpcion+'/'

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro escolhido                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If &(cCondFiltr)
				nReg := Recno()
				// Restaura parametros MTC010
				For ni := 1 to 20
					&("mv_par"+StrZero(ni,2)) := aParc010[ni]
				Next ni
	
				If lRevPlan
					aArray1 := MC010Form2("SB1"	,	nReg,	99	 ,apar[07]	,		,.F.	,apar[10]	,			,		,		,cArqMemo	,lProdBlq, cOpc) 
							 //MC010Form2(cAlias,	nReg,	nOpcx,nQtdBas	,nTipo	,lMostra,cRevExt	,	lPesqR	,cCodP	,cCodR	,cPlan		,lProdBlq)
				Else
					aArray1 := MC010Forma("SB1"		,nReg	,99		,apar[07]	,		,	.F.		,apar[10]	,cArqMemo	,lProdBlq, cOpc)
							 //MC010Forma(cAlias	,nReg	,nOpcx	,nQtdBas	,nTipo	,lMostra	,cRevExt	,cPlan		,lProdBlq)
				EndIf
				// Restaura parametros MTR430
				For ni := 1 to 20
					&("mv_par"+StrZero(ni,2)) := aPar[ni]
				Next ni
	
				If Len(aArray1) > 0
					aArray	:= aClone(aArray1[2])
					MR430ImpTR(aArray1[1],aArray1[2],aArray1[3],oReport,aPar,aParC010,@nx,@lFirstCb,cOpcion)
				EndIf
				oReport:EndPage()
				dbSelectArea("SB1")
				dbGoTo(nReg)
			EndIf
		Next
		dbSkip()
		oReport:IncMeter()
	EndDo
	oSection:Finish()
EndIf
dbSelectArea("SB1")
dbClearFilter()
dbSetOrder(1) 

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR430ImpTR³ Autor ³ Ricardo Berti 		³ Data ³07.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados ja' calculados                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MR430ImpTR(ExpC1,ExpA1,ExpN1,ExpO1,ExpA2,ExpA3,ExpN2)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Titulo do custo utilizado                          ³±±
±±³          ³ ExpA1 = Array com os dados ja' calculados                  ³±±
±±³          ³ ExpN1 = Numero do elemento inicial a imprimir              ³±±
±±³          ³ ExpO1 = obj Report                                         ³±±
±±³          ³ ExpA2 = Array com os parametros de MTR430                  ³±±
±±³          ³ ExpA2 = Array com os parametros de MTC010                  ³±±
±±³          ³ ExpN2 = elemento do aArray, passado por referencia		  ³±±
±±³          ³ ExpL1 = indica primeiro acesso, para montagem de cabec.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR430                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR430ImpTR(cCusto,aArray,nPosForm,oReport,aPar,aParC010,nx,lFirstCb,cOpcional)

Local oSection  := oReport:Section(1)
LOCAL cMoeda1,cMoeda2
LOCAL nDecimal	:=0
Local lFirst	:= .T.
Local cOldAlias
Local nOrder
Local nRecno
Local nValUnit, nCotacao
Local cTit1,cTit2,cTit3,cTit4                                             

DEFAULT lFirstCb := .T.

cCusto := If(cCusto=Nil,'',AllTrim(Upper(cCusto)))
If cCusto == 'ULT PRECO'
	nDecimal := TamSX3('B1_UPRC')[2]
ElseIf 'MEDIO' $ cCusto
	nDecimal := TamSX3('B2_CM1')[2]
Else
	nDecimal := TamSX3('B1_CUSTD')[2]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ De acordo com o custo da planilha lida monta a cotacao de    ³
//³ conversao e a variavel cMoeda1 usada no cabecalho.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Str(nQualCusto,1) $ "3/4/5/6"
	nCotacao:=ConvMoeda(dDataBase,,1,Str(nQualCusto-1,1))
	cMoeda1	:=GetMV("MV_SIMB"+Str(nQualCusto-1,1,0))
	If Empty(cMoeda1)
		cMoeda1	:=GetMV("MV_MOEDA"+Str(nQualCusto-1,1,0))
	EndIf
Else
	nCotacao:=1
	cMoeda1	:=GetMV("MV_SIMB1")
EndIf

If lFirstCb
	cMoeda1	:= PADC(Alltrim(cMoeda1),12)
	cTit1:=oSection:Cell("VALUNI"):Title()
	cTit2:=oSection:Cell("VALTOT"):Title()
	oSection:Cell("VALUNI"):SetTitle(cTit1+CRLF+cMoeda1) //"Valor Unitario"
	oSection:Cell("VALTOT"):SetTitle(cTit2+CRLF+cMoeda1) //"Valor Total"
	lFirstCb := .F.
EndIf

If apar[05] <> 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ De acordo com o parametro da segunda moeda (mv_par05) remonta³
	//³ os titulos de valores no cabecalho p/ moeda secundaria		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMoeda2	:= GetMV("MV_SIMB"+Str(apar[05],1,0))
	If Empty(cMoeda2)
		cMoeda2 := GetMV("MV_MOEDA"+Str(apar[05],1,0))
	EndIf           
	cMoeda2	:= PADC(Alltrim(cMoeda2),12)
	cTit3:= oSection:Cell("VALUNI2"):Title()
	cTit4:= oSection:Cell("VALTOT2"):Title()
	oSection:Cell("VALUNI2"):SetTitle(cTit3+CRLF+PadC(AllTrim(cMoeda2),12)) //"Valor Unitario"
	oSection:Cell("VALTOT2"):SetTitle(cTit4+CRLF+PadC(AllTrim(cMoeda2),12)) //"Valor Total"
EndIf

For nX := 1 To Len(aArray)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o nivel da estrutura para ser impresso ou nao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If apar[04] == 1
		If Val(apar[06]) != 0
			If Val(aArray[nX,2]) > Val(apar[06])
				Loop
			Endif
		Endif
	Endif

	If If( (Len(aArray[ nX ])==12),aArray[nX,12],.T. )

		If lFirst
			oReport:SkipLine()
			lFirst := .F.
		EndIf
		oSection:Cell("CEL"):SetValue(aArray[nX][01])
		oSection:Cell("NIVEL"):SetValue(aArray[nX][02])
		oSection:Cell("B1_COD"):SetValue(aArray[nX][04])
		oSection:Cell("B1_DESC"):SetValue(aArray[nX][03])
		If nX == 1
			oSection:Cell("cOpcion"):SetValue(cOpcional)
		Else
			oSection:Cell("cOpcion"):SetValue('')
		Endif
		If aArray[nX][04] == Replicate("-",15)
			oSection:Cell("VALTOT"):Hide()
			oSection:Cell("PERCENT"):Hide()
			If apar[05] <> 1
				oSection:Cell("VALUNI2"):Hide()
				oSection:Cell("VALTOT2"):Hide()
			EndIf
		Else
			If nX < nPosForm-1
				If aParc010[02] == 1
					nValUnit := Round(aAuxCusto[nX]/aArray[nX][05], nDecimal)
				Else
					nValUnit := NoRound(aAuxCusto[nX]/aArray[nX][05], nDecimal)
				EndIf
			EndIf
			oSection:Cell("VALTOT"):SetValue(aArray[nX][06])
			oSection:Cell("PERCENT"):SetValue(aArray[nX][07])
			oSection:Cell("VALTOT"):Show()
			oSection:Cell("PERCENT"):Show()
			If apar[05] <> 1
				If nX < nPosForm-1
					oSection:Cell("VALUNI2"):SetValue(Round(ConvMoeda(dDataBase,,nValUnit/nCotacao,Str(apar[05],1)), nDecimal))
					oSection:Cell("VALUNI2"):Show()
				Else
					oSection:Cell("VALUNI2"):Hide()
				EndIf
				oSection:Cell("VALTOT2"):SetValue(ConvMoeda(dDataBase,,(aArray[nX][06]/nCotacao),Str(apar[05],1)))
				oSection:Cell("VALTOT2"):Show()
			EndIf	
		EndIf
		If aArray[nX][04] == Replicate("-",15) .Or. nX >= nPosForm-1
			oSection:Cell("B1_UM"):Hide()
			oSection:Cell("QUANT"):Hide()
			oSection:Cell("VALUNI"):Hide()
		Else
			oSection:Cell("B1_UM"):Show()
			oSection:Cell("QUANT"):Show()
			oSection:Cell("VALUNI"):Show()
			cOldAlias:=Alias()
			dbSelectArea("SB1")
			nOrder:=IndexOrd()
			nRecno:=Recno()
			dbSetOrder(1)
			dbSeek(xFilial()+aArray[nX][04])
			oSection:Cell("B1_UM"):SetValue(SB1->B1_UM)
			dbSetOrder(nOrder)
			dbGoTo(nRecno)
			dbSelectArea(cOldAlias)
			oSection:Cell("QUANT"):SetValue(aArray[nX][05])
			oSection:Cell("VALUNI"):SetValue(nValUnit)
		EndIf

		oSection:PrintLine()

		If nX == 1 .And. apar[04] == 2
			nX += (nPosForm-3)
		EndIf
	EndIf
Next
If !lFirst
	oReport:ThinLine()
EndIf	

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR430Plan ³ Autor ³ Eveli Morasco         ³ Data ³ 30/03/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se a Planilha escolhida existe                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR430                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR430Plan(lGravado,aPar)
Local cArq 		:= ""     
Local lRet 		:= .T.
Local aArea		:= GetArea()
Local cAliasTRB := ""
Local cQuery	:= ""

DEFAULT lGravado:=.F.

cArq:=AllTrim(If(lGravado,apar[03],&(ReadVar())))

If SuperGetMV("MV_REVPLAN",.F.,.F.)
	cAliasTRB := GetNextAlias()
	cQuery:= "SELECT CO_CODIGO, CO_REVISAO, CO_NOME FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
	cQuery+= " WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
	cQuery+= "       AND CO_NOME ='"+cArq+"'"	
	cQuery+= "Order By CO_CODIGO Desc, CO_REVISAO Desc "	
	cQuery := ChangeQuery(cQuery) 
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)

	If (cAliasTRB)->(Eof())
		Help(" ",1,"MR430NOPLA")
		lRet := .F.
	EndIf
	(cAliasTRB)->(DbCloseArea())
Else
	cArq += ".PDV"
	If !File(cArq)
		Help(" ",1,"MR430NOPLA")
		lRet := .F.
	EndIf
EndIf
RestArea( aArea )
Return (lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MC010Forma³ Autor ³ Eveli Morasco         ³ Data ³ 22/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra toda estrutura de um item selecionado com todos seus³±±
±±³          ³ custos , permitindo simulacoes diversas                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MC010Forma(ExpC1,ExpN1,ExpN2,ExpN3,ExpN4,ExpL1,ExpC2)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada. Se neste campo estiver³±±
±±³          ³         o valor 99 , significa que esta funcao foi chamada ³±±
±±³          ³         pela rotina de impressao da planilha (MATR430) ,se ³±±
±±³          ³         estiver o valor 98 ,significa que foi chamada pela ³±±
±±³          ³         rotina de atualizacao de precos (MATA420)          ³±±
±±³          ³ ExpN3 = Quantidade Basica (Somente ExpN2 == 99)            ³±±
±±³          ³ ExpN4 =                                                    ³±±
±±³          ³ ExpL1 = Exibir mensagem de processamento                   ³±±
±±³          ³ ExpC2 = Revisao passada pelo MATR430		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MC010Forma(cAlias,nReg,nOpcx,nQtdBas,nTipo,lMostra,cRevExt,cPlan,lProdBlq,cOpc)
Local nSavRec,cPictQuant,nX,cArq:=Trim(cArqMemo)+".PDV", cPictVal
Local nUltNivel,cProduto,nMatPrima,nQuant := nNivel := 1
Local nTamReg:=143,nHdl1,nTamArq,nRegs,cBuffer,cLayout,nIni,nFim,nY,nDif,aFormulas:={}
Local cTitulo,aPreco, nTamDif
Local xIdent, xNivel, xDesc, xCod, xQuant, xCusto, xPart, xAlt, xTipo, xDigit, xSz
Local nOrder:=IndexOrd()
Local cNivInv
Local nTamFormula
Local i := 0
Local nQuantPe := 1
Local aMC010Alt := {}
Local cCarac := ""
Local lMC010ADD := ExistBlock('MC010ADD')
Local lMC010ALT := ExistBlock('MC010ALT')

PRIVATE aInv:={} //Array usado para calculo do custo de reposicao
PRIVATE nOldCusto:=nQualcusto
PRIVATE cProdPai:=""

DEFAULT nTipo   := 1
DEFAULT lMostra := .T.
DEFAULT cRevExt := ""
DEFAULT cOpc    := ''

dbSetOrder(1)	// Ordem correta para montar a estrutura
aArray := {}
aHeader:={}
aTotais:={}


If nQualcusto == 8 
	cArqMemo := "STANDARD"
	cArq := Trim(cArqMemo)+".PDV"
	nQualCusto := 1
EndIf

If nOpcx >= 90
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Esta variavel devera' ficar com .F. quando esta funcao for cha-³
	//³ mada de um programa que nao seja a propria consulta. Ela inibi-³
	//³ ra' as mensagens de help.                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lExibeHelp := .F.
	lConsNeg := If(nOpcx = 98 .or. Type("lConsNeg") # "L", .T., lConsNeg)
Else
	lConsNeg := mv_par03 = 1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe algum dado no arquivo                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAlias )
If RecCount() == 0
	Return .T.
EndIf

If cAlias <> "SB1"
	dbSelectArea("SB1")
Endif	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta' na filial correta                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX2->( Dbseek("SB1"))
If FWModeAccess("SB1",3) <> "C" .and. cFilAnt != SB1->B1_FILIAL
	Help(" ",1,"A000FI")
	Return .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tenta abrir o arquivo de memorias de calculo                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdl1 := FOpen(cArq,FO_READWRITE+FO_SHARED)
If nHdl1 < 0
	Help(" ",1,"MC010FORMU")
	Return .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a primeira posicao do arquivo que identifica o NOVO Lay-Out ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FSeek(nHdl1,0,0)
cLayout := Space(1)
Fread(nHdl1,@cLayout,1)

If .Not. (cLayout == "P")
	If .Not. (cLayout == "N")
		nHdl1 := MC010Conv(nHdl1, cArq)
		If nHdl1 < 0
			Return .F.
		EndIf
	EndIf

	FSeek(nHdl1,0,0)
	cBuffer := Space(3)
	Fread(nHdl1,@cBuffer,3)
	cLayout := Left(cBuffer,1)
	If Val(Right(cBuffer,1)) < 8  // So' ha' conversao para layout "P" caso nao seja arq. binario
		nHdl1 := MC010ConvP(nHdl1, cArq)
		If nHdl1 < 0
			Return .F.
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o tamanho do arquivo e o numero de registros              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTamArq := Fseek(nHdl1,0,2)
nRegs   := Int((nTamArq-5)/nTamReg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a segunda posicao do arquivo que identifica a direcao do calculo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Fseek(nHdl1,0,0)
cBuffer := Space(2)
Fread(nHdl1,@cBuffer,2)
lDirecao := .T.
If Subst(cBuffer,2,1) == "1"
	lDirecao := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a terceira posicao do arquivo que identifica o custo selecionado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := Space(1)
Fread(nHdl1,@cBuffer,1)
nQualCusto := Val(cBuffer)
If nQualCusto < 1 .Or. nQualCusto > 8
	nQualCusto := 1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a 4a e a 5a posicao do arquivo se a planilha possuir ateh 99    ³
//³ linhas de totais. Se possuir 100 ou mais linhas de Totais, obtem-se a³
//³ 4a, 5a e 6a posicoes                                                 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := Space(8)
Fread(nHdl1,@cBuffer,8)
Fseek(nHdl1,0) // Reposicionamento do cursor do arquivo
Fseek(nHdl1,3)

cCarac := SubStr(cBuffer,8,8)

// Se o ultimo caracter da selecao eh uma letra, significa que a planilha
// contem menos de 100 linhas Totais
If !(cCarac $ "0123456789")
	cBuffer := Space(2)
	Fread(nHdl1,@cBuffer,2)
Else
	// Se o ultimo caracter nao for uma letra, significa que a planilha contem
	// 100 ou mais linhas Totais. Assim, eh preciso fazer a leitura de 3 digitos
	cBuffer := Space(3)
	Fread(nHdl1,@cBuffer,3)
EndIf

nQtdTotais := Val(cBuffer)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o nome do custo                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nQualCusto     == 1
	cCusto := "STANDARD"
ElseIf nQualCusto == 2
	cCusto := "MEDIO "+MV_MOEDA1
ElseIf nQualCusto == 3
	cCusto := "MEDIO "+MV_MOEDA2
ElseIf nQualCusto == 4
	cCusto := "MEDIO "+MV_MOEDA3
ElseIf nQualCusto == 5
	cCusto := "MEDIO "+MV_MOEDA4
ElseIf nQualCusto == 6
	cCusto := "MEDIO "+MV_MOEDA5
ElseIf nQualCusto == 7
	cCusto := "ULT PRECO"
ElseIf nQualCusto == 8
	cCusto := "PLANILHA"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a tela de formacao de precos                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTitulo := STR0001+cArqMemo+STR0002+cCusto+" "		//" Planilha "###" - Custo "
nSavRec := RecNo()
If nQualCusto < 8
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recuperacao padrao de arquivos                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cProduto  := SB1->B1_COD
	cProdPai  := SB1->B1_COD

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trabalha com a Quantidade Basica do mv_par07 (MATR430)      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcx==99 .Or. nTipo == 2
		nQuant := nQtdBas
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para manipular a quantidade basica         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If (ExistBlock('MC010QTD'))
		nQuantPe := ExecBlock('MC010QTD',.F.,.F.,{SB1->B1_COD})
		If ValType(nQuantPe) == "N" 
			nQuant := nQuantPe
		Endif
	Endif		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AddArray(nQuant,nNivel,.F.,.T.,NIL)
	AAdd(aInv,{SB1->B1_COD,"100",1,0,0,"0",Len(aInv)+1})
	If Empty(cOpc)
		If mv_par12 == 1
			cOpc := SeleOpc(4,"MATC010",SB1->B1_COD,,,,,,nQuant,dDataBase,If(Empty(mv_par04),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU),mv_par04),mv_par09==2)
		Else
			cOpc := RetFldProd(SB1->B1_COD,"B1_OPC")
		EndIf
	Endif

	// Processa Customizacao Formacao de Preco

	aCustos := U_RESTATTT(@aCustos,.T.)

	If lMostra	
		MsAguarde( {|lEnd| MontStru(cProduto,nQuant,nNivel+1,cOpc,If(nOpcx==99,If(Empty(cRevExt),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU),cRevExt),If(Empty(mv_par04),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU),mv_par04)),,,,lProdBlq) }, ;	
		STR0012, STR0013, .F. )
	Else
		MontStru(cProduto,nQuant,nNivel+1,cOpc,If(nOpcx==99,If(Empty(cRevExt),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU),cRevExt),If(Empty(mv_par04),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU),mv_par04)),,lMostra,cRevExt,lProdBlq)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacao utilizada para nao permitir B1_TIPO = 'SE', porque ³
	//³ 'SE' e uma palavra reservada utilizada nas formulas.		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:= 1 to Len(aArray)
		If aArray[nX,9] $ "SE"
			Aviso("MATC010",STR0010+STR0011,{"Ok"})
			aArray := {}
			Return (aArray)
		EndIf
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ExecBlock Para Inserir Elementos na Estrutura - MC010Add ³
	//³ Retorno: 1 - Nivel (C/6)                                 ³
	//³          2 - Codigo (C/6)                                ³
	//³          3 - Descricao (C/50)                            ³
	//³          4 - Quantidade (N)                              ³
	//³          5 - Tipo do Produto (C/2)                       ³
	//³          6 - G1_TRT - Sequencia (C/3)                    ³
	//³          7 - "F"ixo ou "V"ariavel                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMC010ADD 
		aMC010Add := ExecBlock('MC010ADD',.F.,.F.,cProduto)
		If ValType(aMC010Add) == "A" .And. (Len(aMC010Add)>0)
			For nX := 1 To Len(aMC010Add)
				AAdd(aArray, { Len(aArray)+1,;
									aMC010Add[nX][1],;						// 1 - Nivel
									SubStr(aMC010Add[nX][3],1,38),;	 	// 3 - B1_DESC
									aMC010Add[nX][2],;						// 2 - B1_COD
									aMC010Add[nX][4],;						// 4 - Quantidade
									0,;
									0,;
									.T.,;
									aMC010Add[nX][5],;						// 5 - B1_TIPO
									.F.,;
									aMC010Add[nX][6],;						// 6 - G1_TRT
									IIF(Subs(cAcesso,39,1) != "S",.F.,.T.),;
									aMC010Add[nX][7]})						// 7 - G1_FIXVAR
			Next
		EndIf
	EndIf
	// Ponto de entrada para permitir alteração na estrutura do produto através do array aArray
	If lMC010ALT 
		aMC010Alt := ExecBlock ('MC010ALT',.F.,.F.,{aArray})
		If ValType(aMC010Alt) == "A"
			aArray := aClone(aMC010Alt)
		EndIf
	EndIf                      

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Este vetor (aAuxCusto) deve ser declarado somente no MATR430 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcx==99
		aAuxCusto := Array(Len(aArray))
		AFill(aAuxCusto, 0)
	EndIf

	cPictQuant := x3Picture(If(mv_par09==1,"G1_QUANT","GG_QUANT"))
	If Subs(cPictQuant,1,1) == "@"
		cPictQuant := Subs(cPictQuant,1,1)+""+Subs(cPictQuant,2,Len(cPictQuant))
	Else
		cPictQuant := "@E "+cPictQuant
	EndIf

	If nQualCusto     == 2
		cPictVal := x3Picture('B2_CM1')
	ElseIf nQualCusto == 3
		cPictVal := x3Picture('B2_CM2')
	ElseIf nQualCusto == 4
		cPictVal := x3Picture('B2_CM3')
	ElseIf nQualCusto == 5
		cPictVal := x3Picture('B2_CM4')
	ElseIf nQualCusto == 6
		cPictVal := x3Picture('B2_CM5')
	ElseIf nQualCusto == 7
		cPictVal := x3Picture('B1_UPRC')
	Else
		cPictVal := x3Picture('B1_CUSTD')
	EndIf

	If Subs(cPictVal,1,1) == "@"
		cPictVal := Subs(cPictVal,1,1)+""+Subs(cPictVal,2,Len(cPictVal))
	Else
		cPictVal := "@E "+cPictVal
	EndIf
	AAdd(aHeader,{STR0003	   , "99999"})			//"Cel"
	AAdd(aHeader,{STR0004	   , "@9" })			//"Niv"
	AAdd(aHeader,{STR0005	   , "@X" })			//"Descri‡„o"
	AAdd(aHeader,{STR0006	   , "@!" })			//"Codigo"
	AAdd(aHeader,{STR0007	   , cPictQuant }) 		//"Quantd"
	AAdd(aHeader,{STR0008		, cPictVal })		//"Valor Total"
	AAdd(aHeader,{STR0009      , "@E 999.99" })		//"%Part"

	AAdd(aArray,{   (Len(aArray)+1),;
					"------",;
					Replicate("-",30),;
					Replicate("-",Len(SB1->B1_COD)),;
					0,0,0,.F.,"  ",.F.," ",.T.," " } )  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a primeira linha com formulas                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMatPrima := Len(aArray)+1

	For nX := 1 To nQtdTotais
		cBuffer := Space(nTamReg)
		Fread(nHdl1,@cBuffer,nTamReg)
		AAdd(aTotais,SubStr(cBuffer,36,100))
		AAdd(aArray, { Len(aArray)+1,;								//[01]
							"------",;										//[02]
							SubStr(cBuffer,6,30),;						//[03]
							Replicate(".",Len(SB1->B1_COD)),;		//[04]
							0,;												//[05]
							0,;												//[06]
							0,;												//[07]
							.F.,;												//[08]
							"MP",;											//[09]
							.F.,;												//[10]
							" ",;												//[11]
							.T.,;												//[12]
							" ",;												//[13]
							" " } )											//[14]

		// Projeto Precificacao
		// incluir os novos campos mesmo que seja leitura direto do arquivo Standard.pdv
		
			aSize(aArray[Len(aArray)],15)
			aArray[Len(aArray)][15] := { Space(Len(SCO->CO_INTPV)), Space(Len(SCO->CO_INTPUB)) }
		
	Next nX

	AAdd(aArray,{  Len(aArray)+1,;								// [01]
						"------",;										// [02]
						Replicate("-",30),;							// [03]
						Replicate("-",Len(SB1->B1_COD)),;		// [04]
						0,;												// [05]
						0,;												// [06]
						0,;												// [07]
						.F.,;												// [08]
						"  ",;											// [09]
						.F.,;												// [10]
						" ",;												// [11]
						.T.,;												// [12]
						" ",;												// [13]
						" " } )											// [14]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le as formulas do arquivo (PDV)                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nQtdFormula := nRegs-nQtdTotais
	For nX := 1 To nQtdFormula
		cBuffer := Space(nTamReg)
		Fread(nHdl1,@cBuffer,nTamReg)
		If nDif == NIL
			nDif := nMatPrima - (Val(SubStr(cBuffer,1,5)) - (nQtdTotais+1))
		EndIf
		AAdd(aFormulas,{SubStr(cBuffer,36,100),Substr(cBuffer,136,6)})
		If AT("#",aFormulas[nX,1]) > 0
			nTamFormula := Len(aFormulas[nX,1])
			For nY := 1 To Len(aFormulas[nX,1])
				If SubStr(aFormulas[nX,1],nY,1) == "#"
					nFim := nIni := nY+1
					While (IsDigit(SubStr(aFormulas[nX,1],nFim,1)))
						nFim++
					EndDo
					cNum := AllTrim(Str(Val(SubStr(aFormulas[nX,1],nIni,nFim-nIni))+nDif,5))
					aFormulas[nX,1]:=SubStr(aFormulas[nX,1],1,nIni-1)+cNum+SubStr(aFormulas[nX,1],nFim)
					//Ajusta Tamanho do Campo para 100 posicoes.
					If Len(aFormulas[nX,1]) < 100
						nTamDif := 100 - len(aFormulas[nX,1])
						aFormulas[nX,1] := aFormulas[nX,1] + Space(nTamDif)
					ElseIf Len(aFormulas[nX,1]) > 100
						aFormulas[nX,1] := Substr(aFormulas[nX,1],1,100)
					EndIf
				EndIf
			Next nY
		EndIf
		If AT("#",aFormulas[nX,2]) > 0
			nTamFormula := Len(aFormulas[nX,2])
			For nY := 1 To Len(Trim(aFormulas[nX,2]))
				If SubStr(aFormulas[nX,2],nY,1) == "#"
					nFim := nIni := nY+1
					While (IsDigit(SubStr(aFormulas[nX,2],nFim,1)))
						nFim++
					EndDo
					cNum := AllTrim(Str(Val(SubStr(aFormulas[nX,2],nIni,nFim-nIni))+nDif,5))
					aFormulas[nX,2]:=SubStr(aFormulas[nX,2],1,nIni-1)+cNum+SubStr(aFormulas[nX,2],nFim)
					aFormulas[nx,2]:=aFormulas[nx,2]+Space(6-Len(aFormulas[nx,2]))
					//Ajusta Tamanho do Campo para 6 posicoes.
					If Len(aFormulas[nX,2]) < 6
						nTamDif := 6 - len(aFormulas[nX,2])
						aFormulas[nX,2] := aFormulas[nX,2] + Space(nTamDif)
					ElseIf Len(aFormulas[nX,2]) > 6
						aFormulas[nX,2] := Substr(aFormulas[nX,2],1,6)
					EndIf
				EndIf
			Next nY
		EndIf
		AAdd(aArray, { Len(aArray)+1,;								//[01]
							"------",;										//[02]
							SubStr(cBuffer,6,30),;						//[03]
							Replicate(".",Len(SB1->B1_COD)),;		//[04]
							0,;												//[05]
							0,;												//[06]
							0,;												//[07]
							.T.,;												//[08]
							"  ",;											//[09]
							.F.,;												//[10]
							" ",;												//[11]
							.T.,;												//[12]
							" ",;												//[13]
							" " } )											//[14]

		// Projeto Precificacao
		// incluir os novos campos mesmo que seja leitura direto do arquivo Standard.pdv
		
			aSize(aArray[Len(aArray)],15)
			aArray[Len(aArray)][15] := { Posicione("SX3",2,"CO_INTPV","X3_RELACAO"), Posicione("SX3",2,"CO_INTPUB","X3_RELACAO") }
		
	Next nX

	//FClose(nHdl1)

	AAdd(aArray, { Len(aArray)+1,;								// [01]
						"------",;										// [02]
						Replicate("-",30),;							// [03]
						Replicate("-",Len(SB1->B1_COD)),;		// [04]
						0,;												// [05]
						0,;												// [06]
						0,;												// [07]
						.F.,;												// [08]
						"  ",;			  								// [09]
						.F.,;				  								// [10]
						" ",;				  								// [11]
						.T.,;				 								// [12]
						" ",;												// [13]
						" " } )											// [14]

Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recuperacao de Arquivos tipo PLANILHA            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBuffer := Space(2)
	FRead(nHdl1,@cBuffer,2)
	nLen := Bin2I(cBuffer)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do array aArray                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i:= 1 To nLen
		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		xIdent := Bin2I(cBuffer)
		xNivel := Space(6)
		FRead(nHdl1,@xNivel,6)

		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		xSz := Bin2I(cBuffer)
		xDesc := Space(xSz)
		FRead(nHdl1,@xDesc,xSz)

		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		xSz := Bin2I(cBuffer)
		xCod := Space(xSz)
		FRead(nHdl1,@xCod,xSz)

		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		xSz := Bin2I(cBuffer)

		cBuffer := Space(xSz)
		FRead(nHdl1,@cBuffer,xSz)
		xQuant := Val(cBuffer)

		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		xSz := Bin2I(cBuffer)
		cBuffer := Space(xSz)
		FRead(nHdl1,@cBuffer,xSz)
		xCusto := Val(cBuffer)
		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		xSz := Bin2I(cBuffer)
		cBuffer := Space(xSz)
		FRead(nHdl1,@cBuffer,xSz)
		xPart := Val(cBuffer)
		cBuffer := Space(1)
		FRead(nHdl1,@cBuffer,1)
		xAlt := if(cBuffer=="T",.T.,.F.)
		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		xSz := Bin2I(cBuffer)
		xTipo := Space(xSz)
		FRead(nHdl1,@xTipo,xSz)
		cBuffer := Space(1)
		FRead(nHdl1,@cBuffer,1)
		xDigit := if(cBuffer=="T",.T.,.F.)
		AAdd(aArray,{xIdent,xNivel,xDesc,xCod,xQuant,xCusto,xPart,xAlt,xTipo,xDigit,criavar(If(mv_par09==1,"G1_TRT","GG_TRT")), (Subs(cAcesso,39,1)=='S'), CriaVar(If(mv_par09==1,"G1_FIXVAR","GG_FIXVAR"))})
		If xNivel != Replicate("-",Len(xNivel))
			cNivInv:=StrZero(101-Val(Alltrim(xNivel)),3,0)
			AAdd(aInv,{xCod,cNivInv,xQuant,xCusto,0,"0",Len(aInv)+1})
		EndIf
	Next
	cBuffer := Space(2)
	FRead(nHdl1,@cBuffer,2)
	nMatPrima := Bin2I(cBuffer)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array aTotais                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBuffer := Space(2)
	FRead(nHdl1,@cBuffer,2)
	nLen := Bin2I(cBuffer)
	For i:= 1 To nLen
		cBuffer := Space(100)
		FRead(nHdl1,@cBuffer,100)
		AAdd(aTotais,cBuffer)
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array aFormulas                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBuffer := Space(2)
	FRead(nHdl1,@cBuffer,2)
	nLen        := Bin2I(cBuffer)
	nQtdFormula := nLen
	For i:= 1 To nLen
		cBuffer := Space(If(cLayout=="P",106,105))
		FRead(nHdl1,@cBuffer,If(cLayout=="P",106,105))
		If cLayout=="P"
			AAdd(aFormulas,{Left(cBuffer,100), Right(cBuffer,6)})
		Else
			AAdd(aFormulas,{Left(cBuffer,100), Right(cBuffer,5)+" "})
		EndIf
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do array aHeader                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cPictQuant := x3Picture(If(mv_par09==1,"G1_QUANT","GG_QUANT"))
	If Subs(cPictQuant,1,1) == "@"
		cPictQuant := Subs(cPictQuant,1,1)+""+Subs(cPictQuant,2,Len(cPictQuant))
	Else
		cPictQuant := "@E "+cPictQuant
	EndIf

	If nQualCusto     == 2
		cPictVal := x3Picture('B2_CM1')
	ElseIf nQualCusto == 3
		cPictVal := x3Picture('B2_CM2')
	ElseIf nQualCusto == 4
		cPictVal := x3Picture('B2_CM3')
	ElseIf nQualCusto == 5
		cPictVal := x3Picture('B2_CM4')
	ElseIf nQualCusto == 6
		cPictVal := x3Picture('B2_CM5')
	ElseIf nQualCusto == 7
		cPictVal := x3Picture('B1_UPRC')
	Else
		cPictVal := x3Picture('B1_CUSTD')
	EndIf

	If Subs(cPictVal,1,1) == "@"
		cPictVal := Subs(cPictVal,1,1)+""+Subs(cPictVal,2,Len(cPictVal))
	Else
		cPictVal := "@E "+cPictVal
	EndIf

	AAdd(aHeader,{STR0003	, "99999"	})		//"Cel"
	AAdd(aHeader,{STR0004	, "@9" })			//"Niv"
	AAdd(aHeader,{STR0005	, "@X" })			//"Descri‡„o"
	AAdd(aHeader,{STR0006	, "@!" })			//"Codigo"
	AAdd(aHeader,{STR0007	, cPictQuant })		//"Quantd"
	AAdd(aHeader,{STR0008	, cPictVal })		//"Valor Total"
	AAdd(aHeader,{STR0009	, "@E 999.99" })	//"%Part"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Este vetor (aAuxCusto) deve ser declarado somente no MATR430 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcx==99
		aAuxCusto := Array(Len(aArray))
		AFill(aAuxCusto, 0)
	EndIf

EndIf

FClose(nHdl1)

nUltNivel := CalcUltNiv()
CalcTot(nMatPrima,nUltNivel,aFormulas,, nOpcx)
RecalcTot(nMatPrima)
CalcForm(aFormulas,nMatPrima)

If nOpcx < 90 .Or. nTipo == 2
	Browplanw(nMatPrima,@aFormulas,nTipo)
EndIf

If nOpcx == 99
	aPreco := {cCusto,aArray,nMatPrima}
	Return (aPreco)
ElseIf nOpcx == 98
	Return aArray
EndIf
dbSelectArea(cAlias)
dbSetOrder(nOrder)
MsGoTo(nSavRec)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Prograd.³ALTERACAO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³22.12.98³MELHOR³Bruno   ³Modificacao do array de retorno do MC010Form()³±±
±±³        ³      ³        ³(aumento do string da descricao do produto).  ³±±
±±³30.04.99³21387A³Fernando³Montar corretamente o aArray quando o PDV for ³±±
±±³        ³      ³        ³do tipo PLANILHA.                             ³±±
±±³02.07.99³18443A³Fernando³ Utilizar a Picture de Valores correta.       ³±±
±±³22/07/99³22152A³CesarVal³Passar mv_par07 (QtdBas) p/ Mc010Forma().     ³±±
±±³        ³      ³        ³Somente Quando de (MATR430).                  ³±±
±±³30/08/99³21448A³CesarVal³Fazer a inversao do calculo do Valor          ³±±
±±³        ³      ³        ³Unitario com o maximo de casas decimais.      ³±±
±±³        ³      ³        ³Somente Quando de (MATR430).                  ³±±
±±³13/10/99³22282A³CesarVal³Novo Lay-Out com Celula Percentual com 4      ³±±
±±³        ³      ³        ³Digitos e Formula com 100 Caracteres.         ³±±
±±³02/01/00³  2082³CesarVal³Inclusao do P.E. MC010ADD P/ Inserir Elementos³±±
±±³        ³      ³        ³Na Estrutura do Produto.                      ³±±
±±³23/08/00³  5742³Iuspa   ³Var lConsNeg Considera/nao quant neg estrutura³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA                    MATC010X.PRX ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data       ³ BOPS               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³Marcos V. Ferreira        ³03/08/2006  ³00000100434         ³±±
±±³      02  ³Flavio Luiz Vicco         ³26/04/2006  ³00000097637         ³±±
±±³      03  ³                          ³            ³                    ³±±
±±³      04  ³                          ³            ³                    ³±±
±±³      05  ³Marcos V. Ferreira        ³03/08/2006  ³00000100434         ³±±
±±³      06  ³Nereu Humberto Junior     ³14/08/2006  ³00000098126         ³±±
±±³      07  ³Nereu Humberto Junior     ³14/08/2006  ³00000098126         ³±±
±±³      08  ³                          ³            ³                    ³±±
±±³      09  ³                          ³            ³                    ³±±
±±³      10  ³Flavio Luiz Vicco         ³26/04/2006  ³00000097637         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStru ³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStru(ExpC1,ExpN1,ExpN2,ExpC2,ExpC3,ExpL1,ExpL2,ExpC4)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±³          ³ ExpN2 = Contador de niveis da estrutura                    ³±±
±±³          ³ ExpC2 = String com os opcionais default do produto pai     ³±±
±±³          ³ ExpC3 =                                                    ³±±
±±³          ³ ExpL1 =                                                    ³±±
±±³          ³ ExpL2 = Exibir mensagem de processamento                   ³±±
±±³          ³ ExpC4 = Revisao passada pelo MATR430                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontStru(cProduto,nQuant,nNivel,cOpcionais,cRevisao,lSomouComp,lMostra,cRevExt,lProdblq)
Local nReg,nQuantItem, lAcesso := .T.,cRoteiro:=""
Local lRel        :=If(cProg$"R430A420",.T.,.F.)
Local aArea       :=GetArea()
Local aAreaSG2    :=SG2->(GetArea())
Local aAreaSB1    :=SB1->(GetArea())
Local aAreaSH1    :=SH1->(GetArea())
Local lOkExec     :=ExistBlock("MC010PR")
Local nRetorno    :=0
Local nPosOri     :=0,nPosOriInv:=0
Local lPassaComp  :=.F.
Local cWhile      :=IF(mv_par09==1,"SG1->G1_FILIAL+SG1->G1_COD","SGG->GG_FILIAL+SGG->GG_COD")
Local cAliasWhile :=IF(mv_par09==1,"SG1","SGG")
Local cAliasComp  :=""
Local cAliasCod   :=""
Local cAliasTRT   :=""
Local cAliasNivInv:=""
Local cProdMod    :=""
Local lMc010Est   :=ExistBlock("MC010EST")
Local lRetPE      := .T.
Local lFilSG2     := .F.
Local lVConsNeg   := Type("lConsNeg") == "L"
Local lMCFILSG2   := ExistBlock('MCFILSG2')
Static nI := 0

PRIVATE cTipoTemp	:=SuperGetMV("MV_TPHR")

DEFAULT lMostra := .T.
DEFAULT cRevExt := ""
DEFAULT lProdBlq := .T. // True trata o produto bloqueado, false não trata

lAcesso   :=IIf(Subs(cAcesso,39,1) != "S",.F.,.T.) // Forma‡Æo de pre‡os todos n¡veis
cRevisao  :=IIf(cRevisao==NIL,"",IIF((cProdPai == cProduto),cRevisao,""))
cOpcionais:=IIf(cOpcionais==NIL,"",cOpcionais)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ - Messagem de Processamento - ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lMostra
	nI := (nI+1) % 4
	MsProcTxt(STR0013+Replicate(".",nI+1))
	ProcessMessage()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no produto desejado                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasWhile)
dbSeek(xFilial(cAliasWhile)+cProduto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto MOD deve ser considerado  ³
//³ do roteiro de operacoes.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par05 == 2 .Or. mv_par05 == 3
	dbSelectArea("SB1")
	dbSetOrder(1)
	If MsSeek(xFilial("SB1")+cProduto)
		If !Empty(mv_par06)
			cRoteiro:=mv_par06
		ElseIf !Empty(SB1->B1_OPERPAD)
			cRoteiro:=SB1->B1_OPERPAD
		EndIf
		dbSelectArea("SG2")
		dbSetOrder(1)
		MsSeek(xFilial("SG2")+cProduto+If(Empty(cRoteiro),"01",cRoteiro))
		While !Eof() .And.	xFilial("SG2")+cProduto+If(Empty(cRoteiro),"01",cRoteiro) == G2_FILIAL+G2_PRODUTO+G2_CODIGO
            If lMCFILSG2
  		   		lFilSG2 := ExecBlock("MCFILSG2",.F.,.F.,)
		   		If Valtype(lRetPE) == "L" .And. !lFilSG2
			   		dbSkip()
			   		Loop
		   		EndIf	
			EndIf
			dbSelectArea("SH1")
			dbSetorder(1)
			If MsSeek(xFilial("SH1")+SG2->G2_RECURSO)
				// Calcula Tempo de Dura‡„o baseado no Tipo de Operacao
				If SG2->G2_TPOPER $ " 1"
					nTemp := Round((nQuant * ( If(mv_par07 == 3,A690HoraCt(SG2->G2_SETUP) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ), 0) + IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ))+If(mv_par07 == 2, A690HoraCt(SG2->G2_SETUP), 0) ),5)
					If SH1->H1_MAOOBRA # 0
						nTemp :=Round( nTemp / SH1->H1_MAOOBRA,5)
					EndIf
				ElseIf SG2->G2_TPOPER == "4"
					nQuantAloc:=nQuant % IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)
					nQuantAloc:=Int(nQuant)+If(nQuantAloc>0,IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)-nQuantAloc,0)
					nTemp := Round(nQuantAloc * ( IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ) ),5)
					If SH1->H1_MAOOBRA # 0
						nTemp :=Round( nTemp / SH1->H1_MAOOBRA,5)
					EndIf
				ElseIf SG2->G2_TPOPER == "2" .Or. SG2->G2_TPOPER == "3"
					nTemp := IIf( SG2->G2_TEMPAD == 0 , 1 ,A690HoraCt(SG2->G2_TEMPAD) )
				EndIf
				nTemp:=nTemp*If(Empty(SG2->G2_MAOOBRA),1,SG2->G2_MAOOBRA)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no produto da Mao de Obra.             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cProdMod:=APrModRec(SH1->H1_CODIGO)
				SB1->(dbSetOrder(1))
				If SB1->(MsSeek(xFilial("SB1")+cProdMod))
					// Inclui componente no array
					AddArray(nTemp,nNivel,.F.,lAcesso,SG2->G2_OPERAC)
					AAdd(aInv,{	SB1->B1_COD,PADL(99,3,"0"),;
					nTemp,QualCusto(SB1->B1_COD),0,	"0",Len(aInv)+1,lAcesso})
					aArray[Len(aArray)][8]:=.T.
					aInv[Len(aInv),6]:= "1"
				EndIf
			EndIf
			dbSelectArea("SG2")
			dbSkip()
		End
	EndIf
	RestArea(aAreaSG2)
	RestArea(aAreaSB1)
	RestArea(aAreaSH1)
EndIf

If (cAliasWhile)->(Eof())
	aArray[1][8] := .T.
Else

	dbSelectArea(cAliasWhile)

	While !Eof() .And. &(cWhile) == xFilial(cAliasWhile)+cProduto
		cAliasComp  :=If(mv_par09==1,SG1->G1_COMP,SGG->GG_COMP)
		cAliasCod   :=If(mv_par09==1,SG1->G1_COD,SGG->GG_COD)
		cAliasTRT   :=If(mv_par09==1,SG1->G1_TRT,SGG->GG_TRT)
		cAliasNivInv:=If(mv_par09==1,SG1->G1_NIVINV,SGG->GG_NIVINV)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Produto esta Bloqueado no Cadastro de Produto   ³
		//³ B1_MSBLQL = 1 Desconsidera para Formacao de Preco   		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If GetAdvFVal( "SB1", "B1_MSBLQL", FWxFilial( "SB1" ) + cAliasComp , 1 ) == '1' .and. Iif(!Empty(mv_par13),!Isincallstack('MATR430') .And. mv_par13 == 2,.T.)
			( cAliasWhile )->( dbSkip() ) ; Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Funcao que devolve a quantidade utilizada do componente ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nQuantItem := ExplEstr(nQuant,NIL,cOpcionais,cRevisao,NIL,mv_par09==2,mv_par10==1,,,,,,,Iif(isincallstack('MATC010') .and. !Empty(mv_par13),mv_par13==2,lProdBlq))
		If lVConsNeg .And. (!lConsNeg) .and. QtdComp(nQuantItem,.T.) < QtdComp(0)
			dbSelectArea(cAliasWhile)
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o produto MOD deve ser considerado  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par05 == 2 .And. IsProdMod(cAliasComp)
			dbSelectArea(cAliasWhile)
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa ponto de Entrada para filtrar componentes da estrutura ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If lMc010Est
			lRetPE := ExecBlock("MC010EST",.F.,.F.,{cAliasWhile,cAliasCod,cAliasComp})
			If Valtype(lRetPE) == "L" .And. !lRetPE
				dbSelectArea(cAliasWhile)
				dbSkip()
				Loop			
			Endif
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona SB1                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		MsSeek(xFilial("SB1")+cAliasComp)

		dbSelectArea(cAliasWhile)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa P.E.                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lOkExec .And. (QtdComp(nQuantItem,.T.) == QtdComp(0)) 	
			nRetorno:=ExecBlock("MC010PR",.F.,.F.,{cAliasCod,cAliasComp,cAliasTRT,nQuant,Recno()})
			If Valtype(nRetorno) == "N"
				nQuantItem:=nRetorno
			EndIf
		EndIf
		
		If (QtdComp(nQuantItem,.T.) != QtdComp(0))
			dbSelectArea(cAliasWhile)
			nReg := Recno()
			
			If RetFldProd(SB1->B1_COD,"B1_FANTASM") $ " N" .Or. (RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" .And. mv_par08 == 1) // Projeto Implementeacao de campos MRP e FANTASM no SBZ
				lSomouComp:=.T.
				AddArray(nQuantItem,nNivel,.F.,lAcesso,NIL)
				AAdd(aInv,{cAliasComp,;
	 				PADL(cAliasNivInv,3,"0"),;
					nQuantItem,;
					QualCusto(cAliasComp),;
					0,;
					"0",;
					Len(aInv)+1,;
					lAcesso			})
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o filho tem estrutura               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			( cAliasWhile )->( MsSeek( xFilial( cAliasWhile ) + cAliasComp ) )
			If Eof()
				aArray[Len(aArray)][8]:= .T.
				aInv[Len(aInv),6]	   := "1"
			Else
				nPosOri:=Len(aArray)
				nPosOriInv:=Len(aArray)
				lPassaComp:=.F.
				MontStru(cAliasComp,nQuantItem,nNivel+1,cOpcionais,If(lRel,If(Empty(cRevExt),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU),cRevExt),If(Empty(mv_par04),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU),mv_par04)),@lPassaComp,lMostra,cRevExt,lProdBlq)
				If !lPassaComp
					aArray[nPosOri][8]:= .T.
					aInv[nPosOriInv,6]:= "1"
				EndIf
			EndIf
			MsGoTo(nReg)
		EndIf
		dbSkip()
	EndDo
EndIf

RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±    Funcoes para interpretacao das formulas construidas para a rotina    ±±
±±    de calculo de preco.                                                 ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CalcForm ³ Autor ³ Eveli Morasco         ³ Data ³ 24/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa as formulas desta planilha                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CalcForm(ExpA1,ExpN1)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array contendo as formulas                         ³±±
±±³          ³ ExpN1 = Elemento que comeca as linhas de totais            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcForm(aFormulas,nMatPrima)
Local cFormula,nIni,nFim,nPulo,nLinha
Local nX := 0
// Projeto Precificacao
// necessario proteger a execucao da macro
Local bBlock:=ErrorBlock()
Local bErro := ErrorBlock( { |e| Erro(e) } )

If lDirecao
	nIni  := nMatPrima+nQtdTotais+1
	nFim  := Len(aArray)-1
	nPulo := 1
Else
	nIni  := Len(aArray)-1
	nFim  := nMatPrima+nQtdTotais+1
	nPulo := -1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona SB1 no 1. elemento do array, ou seja, o Pai    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SB1")
MsSeek(xFilial("SB1")+aArray[1][4])

// Projeto Precificacao
// necessario proteger a execucao da macro
BEGIN SEQUENCE

	For nX := nFim To nIni Step nPulo*-1
		cFormula := aFormulas[nX-nMatPrima-nQtdTotais,1]
		If Len(aArray[nX]) >= 15 .And. aArray[nX][15][2] == "2" .And. C010GetVLine(nX) != Nil
			aArray[nX][6] := C010GetVLine(nX)
		Else
			If     "ERRO" $ cFormula
				aArray[nX][6] := 0
			ElseIf "SE"   $ cFormula
				aArray[nX][6] := SE(cFormula)
			ElseIf "SOMA" $ cFormula
				aArray[nX][6] := SOMA(cFormula)
			ElseIf "#"    $ cFormula
				aArray[nX][6] := CALCULO(cFormula)
			ElseIf "FORMULA" $ cFormula
				aArray[nX][6] := &(cFormula)
			ElseIf "ITPRC" $ cFormula
				aArray[nX][6] := MATA317Cnt(SB1->B1_COD,Substr(cFormula,At("ITPRC",cFormula)+7, Len(SAV->AV_CODPRC) ))
			Else
				aArray[nX][6] := &(cFormula)
			EndIf
		EndIf
		aArray[nx][6] := MC010VCpo(aArray[nx][6])
		If !Empty(Substr(aFormulas[nX-nMatPrima-nQtdTotais,2],2,5))
			nLinha:=Val(Substr(aFormulas[nX-nMatPrima-nQtdTotais,2],2,5))
			If nLinha > 0
				aArray[nX][7] := (aArray[nX][6] / aArray[nLinha,6]) * 100
			EndIf
		EndIf
	Next nX
	For nX := nIni To nFim Step nPulo
		cFormula := aFormulas[nX-nMatPrima-nQtdTotais,1]
		If Len(aArray[nX]) >= 15 .And. aArray[nX][15][2] == "2" .And. C010GetVLine(nX) != Nil
			aArray[nX][6] := C010GetVLine(nX)
		Else
			If     "ERRO" $ cFormula
				aArray[nX][6] := 0
			ElseIf "SE"   $ cFormula
				aArray[nX][6] := SE(cFormula)
			ElseIf "SOMA" $ cFormula
				aArray[nX][6] := SOMA(cFormula)
			ElseIf "#"    $ cFormula
				aArray[nX][6] := CALCULO(cFormula)
			ElseIf "FORMULA" $ cFormula
				aArray[nX][6] := &(cFormula)
			ElseIf "ITPRC" $ cFormula
				aArray[nX][6] := MATA317Cnt(SB1->B1_COD,Substr(cFormula,At("ITPRC",cFormula)+7, Len(SAV->AV_CODPRC) ) )
			Else
				aArray[nX][6] := &(cFormula)
			EndIf
		EndIf
		aArray[nx][6] := MC010VCpo(aArray[nx][6])
		If !Empty(Substr(aFormulas[nX-nMatPrima-nQtdTotais,2],2,5))
			nLinha:=Val(Substr(aFormulas[nX-nMatPrima-nQtdTotais,2],2,5))
			If nLinha > 0
				aArray[nX][7] := (aArray[nX][6] / aArray[nLinha,6]) * 100
			EndIf
		EndIf
	Next nX
	
// Projeto Precificacao
// necessario proteger a execucao da macro
END SEQUENCE

ErrorBlock(bBlock)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Se       ³ Autor ³ Jorge Queiroz         ³ Data ³ 24/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Interpreta a funcao SE. Esta funcao e' igual ao IIF        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := Se(ExpC1)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Resultado da operacao devolvido pela funcao        ³±±
±±³          ³ ExpC1 = Formula a ser interpretada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Se(cFormula)
Local nIni,nRet,bBlock:=ErrorBlock(),bErro := errorBlock( { |e| Erro(e) } )

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Substitui o nome da funcao                                   ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFormula:=AllTrim(cFormula)
While ("SE" $ cFormula)
	nIni     := At("SE",cFormula)
	cFormula := SubStr(cFormula,1,nIni-1)+"IF"+SubStr(cFormula,nIni+2,Len(cFormula))
EndDo
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Substitui o elemento # da formula por elemento de array      ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFormula := Substitui(cFormula)
BEGIN SEQUENCE
nRet := &cFormula
END SEQUENCE

If nRet == NIL
	nRet := 999999999999999999
EndIf
ErrorBlock(bBlock)
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Soma     ³ Autor ³ Jorge Queiroz         ³ Data ³ 24/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Interpreta a funcao SOMA. Esta funcao soma os elementos    ³±±
±±³          ³ que estiverem no intervalo passado como parametro.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := Soma(ExpC1)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Resultado da operacao devolvido pela funcao        ³±±
±±³          ³ ExpC1 = Formula a ser interpretada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Soma(cFormula)
Local nX,nEleIni,nEleFim,nIni,nFim,nRet:=0
Local bBlock:=ErrorBlock(),bErro := errorBlock( { |e| Erro(e) } )

cFormula:=AllTrim(cFormula)

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Substitui o elemento # da formula por elemento de array      ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFormula := Substitui(cFormula)

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Localiza o 1o e o ultimo elemento do array que sera' somado  ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BEGIN SEQUENCE
nEleIni := At("[",cFormula)+1
nEleFim := At("]",cFormula)
nIni := Subs(cFormula,nEleIni,nEleFim-nEleIni)
nEleIni := Rat("[",SubStr(cFormula,1,Len(cFormula)-4))+1
nEleFim := Rat("]",SubStr(cFormula,1,Len(cFormula)-4))
nFim := Subs(cFormula,nEleIni,nEleFim-nEleIni)
For nX := Val(nIni) To Val(nFim)
	nRet += aArray[nX][6]
Next nX
END SEQUENCE
ErrorBlock(bBlock)
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Calculo  ³ Autor ³ Jorge Queiroz         ³ Data ³ 24/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Interpreta a funcao CALCULO. Esta funcao executa diretamen-³±±
±±³          ³ te seu conteudo , somente operacoes de + - * /.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := Calculo(ExpC1)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Resultado da operacao devolvido pela funcao        ³±±
±±³          ³ ExpC1 = Formula a ser interpretada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Calculo(cFormula)
Local nRet
Local bBlock:=ErrorBlock(),bErro := errorBlock( { |e| Erro(e) } )

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Substitui o elemento # da formula por elemento de array      ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFormula := Substitui(cFormula)

BEGIN SEQUENCE
nRet := &cFormula
END SEQUENCE

If nRet == NIL
	nRet := 999999999999999999
EndIf
ErrorBlock(bBlock)
Return nRet

Static Function MC010VCpo(nConta)
If ValType(nConta) # "N"
	// Projeto Precificacao
	// Nao funcionava quando utilizaca itens de precificacao
	//	nConta := 0
	nConta := Val(nConta)
EndIf
Return(nConta)


Static Function RetOpc(cProduto)
Local aArea := GetArea()
Local aOpcionais := {}
Local cPerg		 := PadR('AJOPC',10)

AjustaSX1(cPerg)

Pergunte(cPerg,.T.)

cOpIni	:= AllTrim(StrTran(Str(MV_PAR01,6,2),'.',','))
cOpFim	:= AllTrim(StrTran(Str(MV_PAR02,6,2),'.',','))

cQuery := 	 " SELECT G1_GROPC, G1_OPC "
cQuery +=	 " FROM " + RetSqlName("SG1") + " SG1 (NOLOCK) "
cQuery +=	 " WHERE  G1_FILIAL = '" + xFilial("SG1") + "' "
cQuery +=	 " AND SG1.D_E_L_E_T_ = '' "      
cQuery +=	 " AND SG1.G1_COD = '" + cProduto + "' "
cQuery +=	 " AND SG1.G1_OPC BETWEEN '" + AllTrim(StrTran(cOpIni,'.',','))+"' AND '" + AllTrim(StrTran(cOpFim,'.',','))+"' "
cQuery +=	 " AND SG1.G1_OPC <> '' "
cQuery +=	 " ORDER BY G1_GROPC+G1_OPC "
	
TCQUERY cQuery NEW ALIAS "CHK1"

While CHK1->(!Eof())
	AAdd(aOpcionais,{CHK1->G1_GROPC, CHK1->G1_OPC})
	
	CHK1->(dbSkip(1))
Enddo

CHK1->(dbCloseArea())

RestArea(aArea)
Return aOpcionais


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AjustaSX1ºAutor ³Luis Henrique Robustoº Data ³  25/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta o SX1 - Arquivo de Perguntas..                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(cPerg)
Local	aRegs   := {},;
		_sAlias := Alias(),;
		nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campos a serem grav. no SX1³
		//³aRegs[nx][01] - X1_GRUPO   ³
		//³aRegs[nx][02] - X1_ORDEM   ³
		//³aRegs[nx][03] - X1_PERGUNTE³
		//³aRegs[nx][04] - X1_PERSPA  ³
		//³aRegs[nx][05] - X1_PERENG  ³
		//³aRegs[nx][06] - X1_VARIAVL ³
		//³aRegs[nx][07] - X1_TIPO    ³
		//³aRegs[nx][08] - X1_TAMANHO ³
		//³aRegs[nx][09] - X1_DECIMAL ³
		//³aRegs[nx][10] - X1_PRESEL  ³
		//³aRegs[nx][11] - X1_GSC     ³
		//³aRegs[nx][12] - X1_VALID   ³
		//³aRegs[nx][13] - X1_VAR01   ³
		//³aRegs[nx][14] - X1_DEF01   ³
		//³aRegs[nx][15] - X1_DEF02   ³
		//³aRegs[nx][16] - X1_DEF03   ³
		//³aRegs[nx][17] - X1_F3      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria uma array, contendo todos os valores...³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aRegs,{cPerg,'01','Tamanho Opcional De?','Numero do Pedido   ?','Numero do Pedido   ?','mv_ch1','N', 6,2,0,'G','','mv_par01','','','','','@E 999.99'})
		aAdd(aRegs,{cPerg,'02','Tam. Opcional Ate  ?','Imprime precos     ?','Imprime precos     ?','mv_ch2','N', 6,2,0,'G','','mv_par02','','','','','@E 999.99'})
		aAdd(aRegs,{cPerg,'03','Tipo Custo         ?','Tipo Custo         ?','Tipo Custo         ?','mv_ch3','N', 1,0,0,'C','','mv_par03','Standard','Medio','','','@E 999.99'})

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For nX:=1 to Len(aRegs)
			If !SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02]))
				RecLock('SX1',.t.)
				Replace SX1->X1_GRUPO		With aRegs[nx][01]
				Replace SX1->X1_ORDEM   	With aRegs[nx][02]
				Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
				Replace SX1->X1_PERSPA		With aRegs[nx][04]
				Replace SX1->X1_PERENG		With aRegs[nx][05]
				Replace SX1->X1_VARIAVL		With aRegs[nx][06]
				Replace SX1->X1_TIPO		With aRegs[nx][07]
				Replace SX1->X1_TAMANHO		With aRegs[nx][08]
				Replace SX1->X1_DECIMAL		With aRegs[nx][09]
				Replace SX1->X1_PRESEL		With aRegs[nx][10]
				Replace SX1->X1_GSC			With aRegs[nx][11]
				Replace SX1->X1_VALID		With aRegs[nx][12]
				Replace SX1->X1_VAR01		With aRegs[nx][13]
				Replace SX1->X1_DEF01		With aRegs[nx][14]
				Replace SX1->X1_DEF02		With aRegs[nx][15]
				Replace SX1->X1_DEF03		With aRegs[nx][16]
				Replace SX1->X1_F3   		With aRegs[nx][17]
				Replace SX1->X1_PICTURE		With aRegs[nx][18]
				MsUnlock('SX1')
			Endif
		Next nX

Return
