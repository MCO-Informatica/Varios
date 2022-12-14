#INCLUDE "FINR130.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"

#DEFINE QUEBR				1
#DEFINE CLIENT			2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO			6
#DEFINE VENCTO			7
#DEFINE VENCREA			8
#DEFINE BANC				9
#DEFINE VL_ORIG			10
#DEFINE VL_NOMINAL			11
#DEFINE VL_CORRIG			12
#DEFINE VL_VENCIDO			13
#DEFINE NUMBC				14
#DEFINE VL_JUROS			15
#DEFINE ATRASO			16
#DEFINE HISTORICO			17
#DEFINE VL_SOMA			18

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes
// 29/05/2015 - Ajuste no grupo de perguntas - Rafael Totvs
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ? FINR130  ? Autor ? Daniel Tadashi Batori ? Data ? 01.08.06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Posi噭o dos Titulos a Receber					          潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? FINR130(void)                                              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?                                                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico                                                   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
User Function RFIN008()

Local oReport

Private cMVBR10925 := GetMv("MV_BR10925")
AjustaSX1()

//If FindFunction("TRepInUse") .And. TRepInUse()
//	oReport := ReportDef()
//	oReport:PrintDialog()
//Else
	Return RFIN008R3() // Executa vers鉶 anterior do fonte
//Endif

Return

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ? ReportDef? Autor ? Daniel Batori         ? Data ? 01.08.06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Definicao do layout do Relatorio									  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe   ? ReportDef(void)                                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico                                                   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function ReportDef()
Local oReport  
Local oSection1
Local oSection2
Local cPictTit
Local nTamVal, nTamCli, nTamQueb, nTamJur, nTamNBco

oReport := TReport():New("FINR130",STR0005,"FIN130",;
{|oReport| ReportPrint(oReport)},STR0001+STR0002)

oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.) // Imprime o total em linhas

//Nao retire esta chamada. Verifique antes !!!
//Ela ? necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

pergunte("FIN130",.F.)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Variaveis utilizadas para parametros	  								?
//? mv_par01		 // Do Cliente 	 										?
//? mv_par02		 // Ate o Cliente										?
//? mv_par03		 // Do Prefixo											?
//? mv_par04		 // Ate o prefixo 										?
//? mv_par05		 // Do Titulo											?
//? mv_par06		 // Ate o Titulo										?
//? mv_par07		 // Do Banco											?
//? mv_par08		 // Ate o Banco											?
//? mv_par09		 // Do Vencimento 										?
//? mv_par10		 // Ate o Vencimento									?
//? mv_par11		 // Da Natureza											?
//? mv_par12		 // Ate a Natureza										?
//? mv_par13		 // Da Emissao											?
//? mv_par14		 // Ate a Emissao										?
//? mv_par15		 // Qual Moeda											?
//? mv_par16		 // Imprime provisorios									?
//? mv_par17		 // Reajuste pelo vecto									?
//? mv_par18		 // Impr Tit em Descont									?
//? mv_par19		 // Relatorio Anal/Sint									?
//? mv_par20		 // Consid Data Base?  									?
//? mv_par21		 // Consid Filiais  ?  									?
//? mv_par22		 // da filial											?
//? mv_par23		 // a flial 											?
//? mv_par24		 // Da loja  											?
//? mv_par25		 // Ate a loja											?
//? mv_par26		 // Consid Adiantam.?									?
//? mv_par27		 // Da data contab. ?									?
//? mv_par28		 // Ate data contab.?									?
//? mv_par29		 // Imprime Nome    ?									?
//? mv_par30		 // Outras Moedas   ?									?
//? mv_par31       // Imprimir os Tipos										?
//? mv_par32       // Nao Imprimir Tipos									?
//? mv_par33       // Abatimentos  - Lista/Nao Lista/Despreza				?
//? mv_par34       // Consid. Fluxo Caixa									?
//? mv_par35       // Salta pagina Cliente									?
//? mv_par36       // Data Base												?
//? mv_par37       // Compoe Saldo por: Data da Baixa, Credito ou DtDigit	?
//? mv_par38       // Tit. Emissao Futura								  	?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

cPictTit := PesqPict("SE1","E1_VALOR")
nTamVal	 := TamSx3("E1_VALOR")[1]
nTamCli	 := TamSX3("E1_CLIENTE")[1] + TamSX3("E1_LOJA")[1] + 20 + 2
nTamTit	 := TamSX3("E1_PREFIXO")[1] + TamSX3("E1_NUM")[1] + TamSX3("E1_PARCELA")[1] + 12
nTamBan	 := TamSX3("E1_PORTADO")[1] + TamSX3("E1_SITUACA")[1] + 1
nTamDte	 := TamSx3("E1_EMISSAO")[1]+3
nTamQueb := nTamCli + nTamTit + nTamBan + TamSX3("E1_TIPO")[1] + TamSX3("E1_NATUREZ")[1] + TamSX3("E1_EMISSAO")[1] +;
		  	TamSX3("E1_VENCTO")[1] + TamSX3("E1_VENCREA")[1] + nTamBan + 2
nTamJur  := TamSX3("E1_JUROS")[1]

nTamNBco := TamSX3("E1_NUMBCO")[1] 

//Secao 1 --> Analitico
oSection1 := TRSection():New(oReport,STR0079,{"SE1","SA1"},;
				{STR0008,STR0009,STR0010,STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,STR0047})
//Secao 2 --> Sintetico
oSection2 := TRSection():New(oReport,STR0081,{"SE1"})
TRCell():New(oSection1,"CLIENTE",,STR0056,,nTamCli,.F.,,,,,,,.F.)  //"Codigo-Lj-Nome do Cliente"
TRCell():New(oSection1,"TITULO",,STR0057+CRLF+STR0058,,nTamTit,.F.,,,,,,,.T.)  //"Prf-Numero" + "Parcela"
TRCell():New(oSection1,"E1_TIPO","SE1",STR0059,,,.F.,,,,,,,.F.)  //"TP"
TRCell():New(oSection1,"E1_NATUREZ","SE1",STR0060,,,.F.,,,,,,,.F.)  //"Natureza"
TRCell():New(oSection1,"E1_EMISSAO","SE1",STR0061+CRLF+STR0062,,nTamDte,.F.,,,,,,,.F.)  //"Data de" + "Emissao"
TRCell():New(oSection1,"E1_VENCTO","SE1",STR0063+CRLF+STR0064,,nTamDte,.F.,,,,,,,.F.)  //"Vencto" + "Titulo"
TRCell():New(oSection1,"E1_VENCREA","SE1",STR0063+CRLF+STR0065,,nTamDte,.F.,,,,,,,.F.)  //"Vencto" + "Real"
TRCell():New(oSection1,"BANCO",,STR0066,,nTamBan,.F.,,,,,,,.F.)  //"Banco"
TRCell():New(oSection1,"VAL_ORIG",,STR0067,cPictTit,nTamVal+1,.F.,,,,,,,.T.)  //"Valor Original"
TRCell():New(oSection1,"VAL_NOMI",,STR0068+CRLF+STR0069,cPictTit,nTamVal+1,.F.,,,,,,,.T.)  //"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection1,"VAL_CORR",,STR0068+CRLF+STR0070,cPictTit,nTamVal+1,.F.,,,,,,,.T.)  //"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection1,"VAL_VENC",,STR0071+CRLF+STR0069,cPictTit,nTamVal+1,.F.,,,,,,,.T.)  //"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection1,"E1_NUMBCO","SE1",STR0072+CRLF+STR0066,,nTamNBco,.F.,,,,,,,.T.)  //"Num" + "Banco"
TRCell():New(oSection1,"JUROS",,STR0073+CRLF+STR0074,cPictTit,nTamJur,.F.,,,,,,,.T.)  //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"DIA_ATR",,STR0075+CRLF+STR0076,,5,.F.,,,,,,,.T.)  //"Dias" + "Atraso"
TRCell():New(oSection1,"E1_HIST" ,"SE1",STR0077,,25,.F.,,,,,,,.T.)  //"Historico" 19
TRCell():New(oSection1,"VAL_SOMA",,STR0078,cPictTit,22,.F.,,,,,,,.T.)  //"(Vencidos+Vencer)"


TRCell():New(oSection2,"QUEBRA",,,,nTamQueb-nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_NOMI",,STR0068+CRLF+STR0069,cPictTit,nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_CORR",,STR0068+CRLF+STR0070,cPictTit,nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_VENC",,STR0071+CRLF+STR0069,cPictTit,nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_JUROS",,STR0073+CRLF+STR0074,cPictTit,nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_SOMA",,STR0078,cPictTit,nTamVal,.F.,,,,,,,.T.)

oSection1:Cell("VAL_ORIG"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_NOMI"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_CORR"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_VENC"):SetHeaderAlign("RIGHT")
oSection1:Cell("JUROS")   :SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_SOMA"):SetHeaderAlign("LEFT")


oSection2:Cell("TOT_NOMI" ):SetHeaderAlign("RIGHT")
oSection2:Cell("TOT_CORR" ):SetHeaderAlign("RIGHT")
oSection2:Cell("TOT_VENC" ):SetHeaderAlign("RIGHT")
oSection2:Cell("TOT_JUROS"):SetHeaderAlign("RIGHT")
oSection2:Cell("TOT_SOMA" ):SetHeaderAlign("RIGHT") 
   

oSection1:SetColSpace(0)
oSection2:SetColSpace(0)

Return oReport                                                                              

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北砅rograma  砇eportPrint? Autor 矰aniel Batori          ? Data ?10.07.06  潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噮o 矨 funcao estatica ReportDef devera ser criada para todos os  潮?
北?          硆elatorios que poderao ser agendados pelo usuario.           潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃enhum                                                       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpO1: Objeto Report do Relat髍io                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北?   DATA   ? Programador   矼anutencao efetuada                          潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北?          ?               ?                                             潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function ReportPrint(oReport)
Local oSection1  	:= oReport:Section(1)
Local oSection2  	:= oReport:Section(2)
Local nOrdem 		:= oReport:GetOrder()
Local oBreak
Local oBreak2
Local oTotVenc
Local oTotCorr
//Local aTotal

Local aDados[18]
//Local aAux[18]
Local nRegEmp 		:= SM0->(RecNo())
Local nRegSM0 		:= SM0->(Recno())
Local nAtuSM0 		:= SM0->(Recno())
Local dOldDtBase 	:= dDataBase
Local dOldData		:= dDatabase

Local CbCont
Local cCond1
Local cCond2
Local nTit0			:=0
Local nTit1			:=0
Local nTit2			:=0
Local nTit3			:=0
Local nTit4			:=0
Local nTit5			:=0
Local nTotJ			:=0
Local nTot0			:=0
Local nTot1			:=0
Local nTot2			:=0
Local nTot3			:=0
Local nTot4			:=0
Local nTotTit		:=0
Local nTotJur		:=0
Local nTotFil0		:=0
Local nTotFil1		:=0
Local nTotFil2		:=0
Local nTotFil3		:=0
Local nTotFil4		:=0
Local nTotFilTit	:=0
Local nTotFilJ		:=0
Local nAtraso		:=0
Local nTotAbat		:=0
Local nSaldo		:=0
Local dDataReaj
Local dDataAnt 		:= dDataBase
Local lQuebra
Local nMesTit0 		:= 0
Local nMesTit1 		:= 0
Local nMesTit2		:= 0
Local nMesTit3 		:= 0
Local nMesTit4 		:= 0
Local nMesTTit 		:= 0
Local nMesTitj	 	:= 0
Local cIndexSe1
Local cChaveSe1
Local nIndexSE1
Local dDtCtb   	:= CTOD("//")
Local cTipos  		:= ""
Local nTotVenc		:= 0
Local nTotMes		:= 0
Local nTotGeral 	:= 0
Local nTotTitMes	:= 0
Local nTotFil		:= 0
Local cNomFor		:= ""
Local cNumBco		:= ""
Local cNomNat		:= ""
Local cNomFil		:= ""
Local cCarAnt 		:= ""
Local cCarAnt2		:= ""
//*************************************************
// Utilizada para guardar os abatimentos baixados *
// que devem subtrair o saldo do titulo principal.*
//*************************************************
Local nBx,aAbatBaixa	:= {}

#IFDEF TOP
	Local aStru 	:= SE1->(dbStruct()), ni
#ENDIF	

Local aTamCli  		:= TAMSX3("E1_CLIENTE")
Local lF130Qry 		:= ExistBlock("F130QRY")
// variavel  abaixo criada p/pegar o nr de casas decimais da moeda
Local ndecs 		:= Msdecimais(mv_par15)
Local nAbatim		:= 0
Local nDescont		:= 0
Local nVlrOrig		:= 0
Local cFilDe
Local cFilAte
Local cMoeda 		:= Str(mv_par15,1)
Local nJuros  		:=0
Local cFilterUser
Local cFilUserSA1 	:= oSection1:GetADVPLExp("SA1")
Local nGem 			:= 0
Local aFiliais 		:= {}
Local lTotFil		:= (mv_par21 == 1 .And. SM0->(Reccount()) > 1)	// Totaliza e quebra por filial
Local aAreaSE5
Local lFR130Tel   	:= ExistBlock("FR130TELC")
Local cCampoCli   	:= ""
Local nLenFil		:= 0
Local nX			:= 0
Local nValPCC	  	:= 0
Local cFilQry		:= ""
Local cFilSE1		:= ""
Local cFilSE5		:= ""
Local lHasLot		:= HasTemplate("LOT")
Local lTemGEM		:= ExistTemplate("GEMDESCTO") .And. HasTemplate("LOT")
Local lAS400		:= (Upper(TcSrvType()) != "AS/400" .And. Upper(TcSrvType()) != "ISERIES")
Local cMvDesFin		:= SuperGetMV("MV_DESCFIN",,"I")
Local aCliAbt		:= {}	// Clientes com titulos de abatimento
Local lFJurCst		:= Existblock("FJURCST")	// Ponto de entrada para calculo de juros 
Local lRelCabec		:= .F. 
Local cFilNat 		:= SE1->E1_NATUREZ

Private cTitulo 	:= ""
Private dBaixa 		:= dDataBase

oSection1:Cell("CLIENTE"   ):SetBlock( { || aDados[CLIENT]    })
oSection1:Cell("TITULO"    ):SetBlock( { || aDados[TITUL]     })
oSection1:Cell("E1_TIPO"   ):SetBlock( { || aDados[TIPO]      })
oSection1:Cell("E1_NATUREZ"):SetBlock( { || aDados[NATUREZA]  })
oSection1:Cell("E1_EMISSAO"):SetBlock( { || aDados[EMISSAO]   })
oSection1:Cell("E1_VENCTO" ):SetBlock( { || aDados[VENCTO]    })
oSection1:Cell("E1_VENCREA"):SetBlock( { || aDados[VENCREA]   })
oSection1:Cell("BANCO"     ):SetBlock( { || aDados[BANC]      })
oSection1:Cell("VAL_ORIG"  ):SetBlock( { || aDados[VL_ORIG]   })
oSection1:Cell("VAL_NOMI"  ):SetBlock( { || aDados[VL_NOMINAL]})
oSection1:Cell("VAL_CORR"  ):SetBlock( { || aDados[VL_CORRIG] })
oSection1:Cell("VAL_VENC"  ):SetBlock( { || aDados[VL_VENCIDO]})
oSection1:Cell("E1_NUMBCO" ):SetBlock( { || aDados[NUMBC]     })
oSection1:Cell("JUROS"     ):SetBlock( { || aDados[VL_JUROS]  })
oSection1:Cell("DIA_ATR"   ):SetBlock( { || aDados[ATRASO]    })
oSection1:Cell("E1_HIST"   ):SetBlock( { || aDados[HISTORICO] })
oSection1:Cell("VAL_SOMA"  ):SetBlock( { || aDados[VL_SOMA]   })

oSection1:Cell("VAL_SOMA"):Enable()
 
//Cabecalho do Relatorio sintetico
If mv_par19 == 2  //1 = Analitico - 2 = Sintetico
	oSection2:SetHeaderPage()
Endif

//Relatorio Analitico
TRPosition():New(oSection1,"SA1",1,{|| xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA})

//Define as quebras da sessao, conforme a ordem escolhida
If nOrdem == 5 //natureza
	oBreak := TRBreak():New(oSection1, {|| Iif(!MV_MULNATR,SE1->E1_NATUREZ,aDados[NATUREZA])} , {|| STR0037 + " " + cNomNat })
	If MV_MULNATR
		oBreak:OnBreak( { |x,y| cNomNat := FR130RetNat(x), FR130TotSoma( oTotCorr, oTotVenc, @nTotVenc, @nTotGeral ) } )
	EndIf	
Elseif nOrdem == 4 .Or. nOrdem == 6 //Data do vencimento e emissao
 	oBreak  := TRBreak():New(oSection1, {|| Iif(nOrdem == 4, Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA), SE1->E1_EMISSAO)} , {|| STR0037 + DtoC(dDtVenc) }) //"S U B - T O T A L ---->"
 	oBreak2 := TRBreak():New(oSection1, {|| Iif(nOrdem == 4, Month(Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA)), Month(SE1->E1_EMISSAO))} , {|| STR0041 + "("+AllTrim(Str(nTotTitMes))+" "+Iif(nTotTitMes > 1, OemToAnsi(STR0039), OemToAnsi(STR0040))+")"} ) //"T O T A L  D O  M E S --->"
    If mv_par19 == 1  //1 = Analitico   2 = Sintetico
    	TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
    	TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
    	TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
    	TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
    	TRFunction():New(oSection1:Cell("JUROS"),"","SUM",oBreak2,,,,.F.,.F.)
   	TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBreak2,,PesqPict("SE1","E1_VALOR"),{|lSection, lReport| If(lReport, nTotGeral, nTotMes)},.F.,.F.)
    Endif
 Elseif nOrdem == 3 //Banco
	oBreak := TRBreak():New(oSection1, {|| SE1->E1_PORTADO} , {|| STR0037 + cNumBco}) //"S U B - T O T A L --->"
 Elseif nOrdem == 1 .Or. nOrdem == 8 //Cliente ou Codigo do Cliente
 	oBreak := TRBreak():New(oSection1, {|| SE1->(E1_CLIENTE+E1_LOJA)} , {|| STR0037 + cNomFor}) //"S U B - T O T A L --->"
 ElseIf nOrdem == 9 // Banco/Situacao
	oBreak := TRBreak():New(oSection1, {|| SE1->E1_PORTADO+SE1->E1_SITUACA} , {|| STR0037 + cNumBco + " " + SubStr(cCarAnt2,1,2) + " "+SubStr(cCarAnt2,3,20) }) //"S U B - T O T A L --->"	
	oBreak:OnBreak( { |x,y| cCarAnt2 := Situcob(x) } )
ElseIf nOrdem == 7 //vencto e banco
	oBreak := TRBreak():New(oSection1, {||IIf(MV_PAR40=2,DtoC(SE1->E1_VENCTO)+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,DtoC(SE1->E1_VENCREA)+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA)},;
	{||STR0037 + DtoC(dDtVenc) + IIf(!Empty(cNumBco), " - " + STR0066 + " " + cNumBco + " " + ;
	GetAdvfVal("SA6","A6_NOME",xFilial("SA6") + AllTrim(cNumBco),1),"")},.F.,"",.F.)
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Imprimir TOTAL por filial somente quando ?
//? houver mais do que uma filial.	         ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lTotFil
	oBreak2 := TRBreak():New(oSection1,{|| SE1->E1_FILIAL },{|| STR0043+" "+ cNomFil })	//"T O T A L   F I L I A L ----> " 
	// "Salta pagina por cliente?" igual a "Sim" e a ordem eh por cliente ou codigo do cliente
	If mv_par35 == 1 .And. (nOrdem == 1 .Or. nOrdem == 8)
		oBreak2:OnPrintTotal( { || oReport:EndPage() } )	// Finaliza pagina atual
	EndIf
	If mv_par19 == 1 	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
	   	TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBreak2,,PesqPict("SE1","E1_VALOR"),{|lSection,lReport| If(lReport, nTotGeral, nTotFil)},.F.,.F.)    
	EndIf
EndIf

If mv_par19 == 1  //1 = Analitico - 2 = Sintetico
	//Altera o texto do Total Geral
	oReport:SetTotalText({|| STR0038 + "(" + AllTrim(Str(nTotTit))+" "+If(nTotTit > 1, STR0039, STR0040)+")"})
	TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
	oTotCorr := TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
	oTotVenc := TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("JUROS"),"","SUM",oBreak,,,,.F.,.T.)
    TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBreak,,PesqPict("SE1","E1_VALOR"),{|lSection, lReport| If (lReport, nTotGeral, nTotVenc )},.F.,.T.)     
               
Endif

//Nao retire esta chamada. Verifique antes !!!
//Ela ? necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? POR MAIS ESTRANHO QUE PARE?A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ?
//?                                                                  ?
//? A fun噭o SomaAbat reabre o SE1 com outro nome pela ChkFile para  ?
//? efeito de performance. Se o alias auxiliar para a SumAbat() n刼  ?
//? estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ?
//? pois o Filtro do SE1 uptrapassa 255 Caracteres.                  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
SomaAbat("","","","R")

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Atribui valores as variaveis ref a filiais                ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
If mv_par21 == 2
	cFilDe  := SM0->M0_CODFIL
	cFilAte := SM0->M0_CODFIL
ELSE
	cFilDe := mv_par22	// Todas as filiais
	cFilAte:= mv_par23
Endif

//Acerta a database de acordo com o parametro
If mv_par20 == 1    // Considera Data Base
	dBaixa := dDataBase := mv_par36
Endif	

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

oReport:NoUserFilter()

oSection1:Init()
oSection2:Init()

aFill(aDados,nil)

// Cria vetor com os codigos das filiais da empresa corrente
aFiliais := FinRetFil()

oReport:SetMeter( 0 )
oReport:IncMeter()

While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL <= cFilAte
     
	If !lRelCabec
   		If mv_par19 == 1  //1 = Analitico - 2 = Sintetico
			cTitulo := oReport:Title() + STR0080 + GetMv("MV_MOEDA" +cMoeda)  //"Posicao dos Titulos a Receber"+" - Analitico"
		Else
			cTitulo := oReport:Title() + STR0080 + GetMv("MV_MOEDA" +cMoeda)  //"Posicao dos Titulos a Receber"+" - Sintetico"
		EndIf
	EndIf 
	
	If !lRelCabec
		If mv_par19 == 1   //1 = Analitico - 2 = Sintetico
			cTitulo += STR0026 //" - Analitico"
		Else
			cTitulo += STR0027 //" - Sintetico"
		EndIf
	EndIf	
	
		
	dbSelectArea("SE1")
	cFilAnt :=SM0->M0_CODFIL 
	Set Softseek On

	cFilSE5		:= xFilial("SE5")
	cFilSE1		:= xFilial("SE1")
	lVerCmpFil	:= !Empty(cFilSE1) .And. !Empty(cFilSE5) .And. Len(aFiliais) > 1

	#IFDEF TOP

		// Verifica se deve montar filtro de filiais para compensacao em filiais diferentes
		If mv_par20 == 1 .And. lVerCmpFil
			nLenFil	:= Len( aFiliais )	
			cFilQry	:= ""
			For nX := 1 To nLenFil
				If aFiliais[nX] != cFilSE5
					If !Empty( cFilQry ) 
						cFilQry += ", "
					Endif
					cFilQry += "'" + aFiliais[nX] + "'"
				EndIf
			Next nX
		EndIf	

		// Verifica os titulos que possuem qualquer tipo de abatimento, para evitar chamada da SumAbat sem necessidade
		cQuery := "SELECT "

		cQuery += "SE1.E1_CLIENTE, SE1.E1_LOJA "
		cQuery += "FROM " + RetSQLName( "SE1" ) + " SE1 "
		cQuery += "WHERE "                                             
		cQuery += "    SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
		cQuery += "AND SE1.E1_TIPO IN " + FormatIn( MVABATIM, '|' ) + " "
		cQuery += "AND SE1.D_E_L_E_T_ = ' ' "
		cQuery += "GROUP BY SE1.E1_CLIENTE, SE1.E1_LOJA "

		cQuery := ChangeQuery(cQuery)                   
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBABT",.T.,.T.)	
		
		While TRBABT->( ! EoF() )
			AAdd( aCliAbt, TRBABT->( E1_CLIENTE + E1_LOJA ) )
			TRBABT->( dbSkip() )	
		EndDo                   
		
		dbSelectArea( "SE1" )
		
		TRBABT->( dbCloseArea() )

		cFilterUser := oSection1:GetSqlExp("SE1")
		If nOrdem = 1
			cQuery := ""
			aEval(SE1->(DbStruct()),{|e| If(!Alltrim(e[1])$"E1_FILIAL#E1_NOMCLI#E1_CLIENTE#E1_LOJA#E1_PREFIXO#E1_NUM#E1_PARCELA#E1_TIPO", cQuery += ","+AllTrim(e[1]),Nil)})
			cQuery := "SELECT E1_FILIAL, E1_NOMCLI, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM,E1_PARCELA, E1_TIPO, "+ SubStr(cQuery,2)
		Else
			cQuery := "SELECT * "
		EndIf
		
		cQuery += "  FROM "+	RetSqlName("SE1") + " SE1"
		cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		If !empty(cFilterUser)
      		cQuery += " AND ("+ cFilterUser +")"
      	EndIf
	#ENDIF
	
	IF nOrdem = 1 .and. !lRelCabec
		#IFDEF TOP
			cChaveSe1 := "E1_FILIAL, E1_NOMCLI, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
			cOrder := SqlOrder(cChaveSe1)
		#ELSE
			cChaveSe1 := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ENDIF
		cCond1	:= "SE1->E1_CLIENTE <= mv_par02"
		cCond2	:= "SE1->E1_CLIENTE + SE1->E1_LOJA"
		cTitulo	+= STR0017  //" - Por Cliente" 
		lRelCabec := .T.
	Elseif nOrdem = 2 .and. !lRelCabec
		SE1->(dbSetOrder(1))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par03+mv_par05)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_NUM <= mv_par06"
		cCond2	:= "SE1->E1_NUM"
		cTitulo	+= STR0018  //" - Por Numero" 
		lRelCabec := .T.
	Elseif nOrdem = 3 .and. !lRelCabec
		SE1->(dbSetOrder(4))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par07)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_PORTADO <= mv_par08"
		cCond2	:= "SE1->E1_PORTADO"
		cTitulo	+= STR0019  //" - Por Banco" 
		lRelCabec := .T.
	Elseif nOrdem = 4  .and. !lRelCabec
		SE1->(dbSetOrder(7))
		#IFNDEF TOP
			dbSeek(cFilial+DTOS(mv_par09))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+" <= mv_par10"
		cCond2	:= Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")
		cTitulo	+= STR0020  //" - Por Data de Vencimento"
		lRelCabec := .T.
	Elseif nOrdem = 5 .and. !lRelCabec
		SE1->(dbSetOrder(3))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par11)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_NATUREZ <= mv_par12"
		cCond2	:= "SE1->E1_NATUREZ"
		cTitulo	+= STR0021  //" - Por Natureza"
		lRelCabec := .T.
	Elseif nOrdem = 6 .and. !lRelCabec
		SE1->(dbSetOrder(6))
		#IFNDEF TOP
			dbSeek( cFilial+DTOS(mv_par13))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_EMISSAO <= mv_par14"
		cCond2	:= "SE1->E1_EMISSAO"
		cTitulo	+= STR0042  //" - Por Emissao" 
		lRelCabec := .T.
	Elseif nOrdem == 7 .and. !lRelCabec
		cChaveSe1 := "E1_FILIAL+DTOS("+Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+")+E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ELSE
			cOrder := SqlOrder(cChaveSe1)
		#ENDIF
		cCond1	:= Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+" <= mv_par10"
		cCond2	:= "DtoS("+Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA"
		cTitulo	+= STR0023  //" - Por Vencto/Banco" 
		lRelCabec := .T.
	Elseif nOrdem = 8 .and. !lRelCabec
		SE1->(dbSetOrder(2))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par01,.T.)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_CLIENTE <= mv_par02"
		cCond2	:= "SE1->E1_CLIENTE"
		cTitulo	+= STR0024  //" - Por Cod.Cliente"
		lRelCabec := .T.
	Elseif nOrdem = 9  .and. !lRelCabec
		cChave := "E1_FILIAL+E1_PORTADO+E1_SITUACA+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,fr130IndR(),OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbSeek(xFilial("SE1"))
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1	:= "SE1->E1_PORTADO <= mv_par08"
		cCond2	:= "SE1->E1_PORTADO+SE1->E1_SITUACA"
		cTitulo	+= STR0025 //" - Por Banco e Situacao"  
		lRelCabec := .T.
	ElseIf nOrdem == 10 .and. !lRelCabec
		cChave := "E1_FILIAL+E1_NUM+E1_TIPO+E1_PREFIXO+E1_PARCELA"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,,OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbSeek(xFilial("SE1")+mv_par05)
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1	:= "SE1->E1_NUM <= mv_par06"
		cCond2	:= "SE1->E1_NUM"
		cTitulo	+= STR0048 //" - Numero/Prefixo"
		lRelCabec := .T.		
	Endif


	oReport:SetTitle(cTitulo)    
			
	Set Softseek Off
	
	#IFDEF TOP
		cQuery += " AND E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02 + "'"
		cQuery += " AND E1_LOJA    between '" + mv_par24        + "' AND '" + mv_par25 + "'"
		cQuery += " AND E1_PREFIXO between '" + mv_par03        + "' AND '" + mv_par04 + "'"
		cQuery += " AND E1_NUM     between '" + mv_par05        + "' AND '" + mv_par06 + "'"
		cQuery += " AND E1_PORTADO between '" + mv_par07        + "' AND '" + mv_par08 + "'"
		If mv_par40 == 2
			cQuery += " AND E1_VENCTO between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"
		Else
			cQuery += " AND E1_VENCREA between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"
		Endif
		cQuery += " AND (E1_MULTNAT = '1' OR (E1_NATUREZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'))"
		cQuery += " AND E1_EMISSAO between '" + DTOS(mv_par13)  + "' AND '" + DTOS(mv_par14) + "'"
      
		If MV_PAR38 == 2 //Nao considerar titulos com emissao futura
			cQuery += " AND E1_EMISSAO <=      '" + DTOS(mv_par36) + "'"
		Endif

		cQuery += " AND ((E1_EMIS1  Between '"+ DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"') OR E1_EMISSAO Between '"+DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"')"
		If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
			cQuery += " AND E1_TIPO IN "+FormatIn(mv_par31,";") 
		ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32
			cQuery += " AND E1_TIPO NOT IN "+FormatIn(mv_par32,";")
		EndIf
		If mv_par18 == 2
			cQuery += " AND E1_SITUACA NOT IN ('2','7')"
		Endif
		If mv_par20 == 2
			cQuery += ' AND E1_SALDO <> 0'
		Endif
		If mv_par34 == 1
			cQuery += " AND E1_FLUXO <> 'N'"
		Endif   		
		If mv_par21 == 2
			cQuery +=  " AND E1_FILIAL = '" + xFilial("SE1") + "'"		
		Else
			If Empty( E1_FILIAL )
				cQuery += " AND E1_FILORIG between '" + mv_par22 + "' AND '" + mv_par23 + "'"				
			Else
				cQuery += " AND E1_FILIAL between '" + mv_par22 + "' AND '" + mv_par23 + "'"				
			EndIf
		Endif            

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Ponto de entrada para inclusao de parametros no filtro a ser executado ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If lF130Qry 
			cQuery += ExecBlock("F130QRY",.f.,.f.)
		Endif

		cQuery += " ORDER BY "+ cOrder
		
		cQuery := ChangeQuery(cQuery)
		
		dbSelectArea("SE1")
		dbCloseArea()
		dbSelectArea("SA1")
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	#ELSE
		cFilterUser := oSection1:GetADVPLExp("SE1")
		If !Empty(cFilterUser)
			oSection1:SetFilter(cFilterUser)
		Endif	
		DbSetfilter( { | |  !(ALLTRIM(Mv_par32) $ ALLTRIM(SE1->E1_TIPO) ) }, '!(ALLTRIM(Mv_par32) $ ALLTRIM(SE1->E1_TIPO) )' )  
		SE1->(DBGoTop())
		
	#ENDIF

	If MV_MULNATR .And. nOrdem == 5
                 
		// No relatorio analitico desabilita secao de totais quando MV_MULNATR e ordenacao por natureza,
		// para forcar a utilizacao da totalizacao com oBreak e TRFunction da oSection1.
		If mv_par19 == 1
			oSection2:Disable()
		EndIf

		Finr135(cTipos, .F., @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ, oReport, aDados, @oSection2)

		#IFDEF TOP
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSelectArea("SE1")
			dbSetOrder(1)
		#ENDIF

		If Empty(xFilial("SE1"))
			Exit
		Endif

		dbSelectArea("SM0")
		dbSkip()
		Loop

	Endif

	While !Eof() .And. SE1->E1_FILIAL == cFilSE1 .And. &cCond1
	
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Carrega data do registro para permitir ?
		//? posterior analise de quebra por mes.   ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dDataAnt := Iif(nOrdem == 6 , SE1->E1_EMISSAO,  Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))
		
		cCarAnt := &cCond2
		
		While !Eof() .And. SE1->E1_FILIAL == cFilSE1 .And. &cCond2 == cCarAnt 

			dbSelectArea("SE1")

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			//砈e nao atender a condicao para impressao, despreza o registro?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
			If !Fr130Cond(cTipos)
				SE1->(DbSkip())
				Loop
			EndIf

			// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtCtb	:=	CTOD("//")	
			dDtCtb	:= Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se esta dentro dos parametros ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE1")

			#IFDEF TOP

				If ( MV_PAR38 == 2 .And. SE1->E1_EMISSAO > mv_par36 )
					SE1->( dbSkip() )
					Loop
				Endif
			
				If dDtCtb < mv_par27 .Or. dDtCtb > mv_par28 
					SE1->( dbSkip() )
					Loop
				Endif

			#ELSE                  
			
				If mv_par18 == 2 .and. E1_SITUACA $ "27"
					SE1->(dbSkip())
					Loop
				EndIf	

				IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
					SE1->E1_PREFIXO < mv_par03 .OR. SE1->E1_PREFIXO > mv_par04 .OR. ;
					SE1->E1_NUM	 	 < mv_par05 .OR. SE1->E1_NUM 		> mv_par06 .OR. ;
					SE1->E1_PORTADO < mv_par07 .OR. SE1->E1_PORTADO > mv_par08 .OR. ;
					Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) < mv_par09 .OR. ;
					Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) > mv_par10 .OR. ;
					SE1->E1_NATUREZ < mv_par11 .OR. SE1->E1_NATUREZ > mv_par12 .OR. ;	
					SE1->E1_EMISSAO < mv_par13 .OR. SE1->E1_EMISSAO > mv_par14 .OR. ; 				
					SE1->E1_LOJA    < mv_par24 .OR. SE1->E1_LOJA    > mv_par25 .OR. ;
					dDtCtb          < mv_par27 .OR. dDtCtb          > mv_par28 .OR. ;
					(SE1->E1_EMISSAO > mv_par36 .and. MV_PAR38 == 2)
					SE1->( dbSkip() )
					Loop
				Endif

			#ENDIF

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Filtro de usu醨io pela tabela SA1.					 ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If !Empty(cFilUserSA1)
				dbSelectArea("SA1")
				MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				If !SA1->(&cFilUserSA1)
					SE1->(dbSkip())
					Loop
				EndIf
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se trata-se de abatimento ou somente titulos?
			//? at? a data base. 									 ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE1")
			IF (SE1->E1_TIPO $ MVABATIM .And. mv_par33 != 1) .Or.;
				(SE1->E1_EMISSAO > mv_par36 .and. MV_PAR38 == 2)
				IF !Empty(SE1->E1_TITPAI)
					aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1->E1_TITPAI } )
				Else
					cMTitPai := FTITPAI()
					aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , cMTitPai } )
				EndIf
				dbSkip()
				Loop
			Endif
			
			//Quando Retroagir saldo, data menor que o solicitado e o titulo estiver 
			//baixado nao mostrar no relatorio
			If (MV_PAR20 == 1 .and. cMVBR10925 == "1" .and. SE1->E1_EMISSAO <= MV_PAR36 .and. SE1->E1_TIPO $ "PIS/COF/CSL")
				dbSkip()
				Loop				
			EndIf

			 // Tratamento da correcao monetaria para a Argentina
			If cPaisLoc=="ARG" .And. mv_par15 <> 1  .And.  SE1->E1_CONVERT=='N'
				dbSkip()
				Loop
			Endif
			
			// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
			If SE1->E1_VENCREA < dDataBase
				If mv_par17 == 2 .And. RecMoeda(SE1->E1_VENCREA,cMoeda) > 0
					dDataReaj := SE1->E1_VENCREA
				Else
					dDataReaj := dDataBase
				EndIf	
			Else
				dDataReaj := dDataBase
			EndIf
			
			If mv_par20 == 1	// Considera Data Base
				nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par15,dDataReaj,MV_PAR36,SE1->E1_LOJA,,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0),mv_par37)
				//Verifica se existem compensa珲es em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimenta珲es da filial corrente. Nao deve processar quando existe somente uma filial.
				If lVerCmpFil
					nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,mv_par37,aFiliais,cFilQry,lAS400),;
									SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(mv_par39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA) ),0 ) ),;
									nDecs+1),nDecs)
				EndIf
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If (Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2)) .And. ((SE1->E1_DECRESC > 0) .OR. (SE1->E1_DESCONT >0 .And. SE1->E1_SDDECRE == 0) ) .and. F130DESC()
					If  SE1->E1_DECRESC > 0 
						nSAldo -= SE1->E1_DECRESC
					Endif
					If SE1->E1_DESCONT>0 .and. SE1->E1_DECRESC == 0 
						nSAldo -= SE1->E1_DESCONT
					Endif
				Endif

				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					nSAldo += SE1->E1_ACRESC
				Endif

				//Se abatimento verifico a data da baixa.
				//Por nao possuirem movimento de baixa no SE5, a saldotit retorna 
				//sempre saldo em aberto quando mv_par33 = 1 (Abatimentos = Lista)
				If SE1->E1_TIPO == "BOL"  				
					aParam := {SE1->E1_FILIAL,SE1->E1_NOMCLI,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA}
					aAbatBaixa:=PesqAbat(aParam)
				Else				
					If SE1->E1_TIPO $ MVABATIM .and. ;
						((SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA)) .or. ;
						 (SE1->E1_MOVIMEN <= dDataBase .and. !Empty(SE1->E1_MOVIMEN))	) .and.;
						 SE1->E1_SALDO == 0
						 
						nSaldo := 0
						IF !Empty(SE1->E1_TITPAI)
							aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1->E1_TITPAI } )
						Else
							cMTitPai := FTITPAI()
							aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , cMTitPai } )
						EndIf
					Endif  
				EndIF
	
			  	If ( cMVBR10925 == "1" .and. SE1->E1_EMISSAO <= MV_PAR36 .and. !(SE1->E1_TIPO $ "PIS/COF/CSL") .and. !(SE1->E1_TIPO $ MVABATIM))
					nValPcc := SumPCC130(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,dBaixa,SE1->E1_CLIENTE,SE1->E1_LOJA,mv_par15)
					nSaldo -= nValPcc
				EndIf
				
				If nSaldo <> 0 .and. SE1->E1_TIPO $ "NCC" .and. (MV_PAR37 == 2 .OR. MV_PAR37 == 3).and. SE1->E1_MOVIMEN <= dDataBase .and. SE1->E1_SALDO == 0
					DbSkip()
					Loop
				EndIf                   
				
				If SE1->E1_TIPO == "RA "   //somente para titulos ref adiantamento verifica se nao houve cancelamento da baixa posterior data base (mv_par36)
					nSaldo -= F130TipoBA()
				EndIf
			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			Endif

			// Se titulo do Template GEM
			If lHasLOT .And. SE1->(FieldPos("E1_NCONTR")) > 0 .And. !Empty(SE1->E1_NCONTR) 
				nGem := CMDtPrc(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_VENCREA,SE1->E1_VENCREA)[2]
				If SE1->E1_VALOR==SE1->E1_SALDO
					nSaldo += nGem
				EndIf
			EndIf

			//Caso exista desconto financeiro (cadastrado na inclusao do titulo), 
			//subtrai do valor principal.
			If Empty( SE1->E1_BAIXA ) .Or. cMvDesFin == "P" .Or. (mv_par20==1 .And. cMvDesFin=="I" .And. dDataBase<SE1->E1_BAIXA)
				nDescont := FaDescFin("SE1",dBaixa,nSaldo,1, .T.,lTemGEM)
				If nDescont > 0
					nSaldo := nSaldo - nDescont
				Endif   
			EndIf	
			
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
						!( MV_PAR20 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

					dbSelectArea("__SE1")
			   		dbSetOrder(2)
			   		dbSeek(xFilial("SED")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					cFilNat:= SE1->E1_NATUREZ				
					aTitImp:= F130RETIMP(cFilNat)

		   			If (nPos := (aScan(aTitImp, {|x| x[1] <> SE1->E1_TIPO }))) > 0 .and. aTitImp[nPos][2]	

					//Quando considerar Titulos com emissao futura, eh necessario
					//colocar-se a database para o futuro de forma que a Somaabat()
					//considere os titulos de abatimento
					If mv_par38 == 1
						dOldData := dDataBase
						dDataBase := CTOD("31/12/40")
					Endif
                           
					// Somente verifica abatimentos se existirem titulos deste tipo para o cliente
					If aScan( aCliAbt, SE1->(E1_CLIENTE + E1_LOJA) ) > 0
						nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,dDataReaj,SE1->E1_CLIENTE,SE1->E1_LOJA)
					Else
						nAbatim := 0
					EndIf		

					If mv_par38 == 1
	   				dDataBase := dOldData
					Endif

					If mv_par33 != 1 //somente deve considerar abatimento no saldo se nao listar
					      
						If STR(nSaldo,17,2) == STR(nAbatim,17,2)
							nSaldo := 0
						ElseIf mv_par33 == 2 //Se nao listar ele diminui do saldo
							nSaldo-= nAbatim
						Endif
					Else       
					    // Subtrai o Abatimento caso o mesmo j? tenho sido baixado ou n鉶 esteja listado no relatorios
 					  	nBx := aScan( aAbatBaixa, {|x| x[2]= SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) } )
					  	If (SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA) .and. nBx>0)
					  		aDel( aAbatBaixa , nBx)
					  		aSize(aAbatBaixa, Len(aAbatBaixa)-1)
							nSaldo-= nAbatim
						EndIf                                        
					EndIf
				Endif
				Endif
			Endif	
			nSaldo:=Round(NoRound(nSaldo,3),2)

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Desconsidera caso saldo seja menor ou igual a zero   ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If nSaldo <= 0
				dbSkip()
				Loop
			Endif					
		    		                                                       
			SA1->( MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA) )
			SA6->( MSSeek(cFilial+SE1->E1_PORTADO) )
			dbSelectArea("SE1")  
				
			aDados[CLIENT] := RTrim(SE1->E1_CLIENTE) + "-" + SE1->E1_LOJA + "-" + IIF(mv_par29 == 1, SubStr(SA1->A1_NREDUZ,1,20), SubStr(SA1->A1_NOME,1,20))
			aDados[TITUL] := SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA
			aDados[TIPO] := SE1->E1_TIPO
			aDados[NATUREZA] := SE1->E1_NATUREZ
			aDados[EMISSAO] := SE1->E1_EMISSAO
			aDados[VENCTO] := SE1->E1_VENCTO
			aDados[VENCREA] := SE1->E1_VENCREA

			If mv_par20 == 1  //Recompoe Saldo Retroativo              
			    //Titulo foi Baixado e Data da Baixa e menor ou igual a Data Base do Relat髍io
			    IF !Empty(SE1->E1_BAIXA)
			    	If SE1->E1_BAIXA <= mv_par36 .Or. !Empty( SE1->E1_PORTADO )
						aDados[BANC] := SE1->E1_PORTADO+" "+SE1->E1_SITUACA
					EndIf	
				Else                                                                                   
				    //Titulo n鉶 foi Baixado e foi transferido para Carteira e Data Movimento e menor 
				    //ou igual a Data Base do Relat髍io
					If Empty(SE1->E1_BAIXA) .and. SE1->E1_MOVIMEN <= mv_par36
						aDados[BANC] := SE1->E1_PORTADO+" "+SE1->E1_SITUACA             
					EndIf
				ENDIF
			Else   // Nao Recompoe Saldo Retroativo
				aDados[BANC] := SE1->E1_PORTADO+" "+SE1->E1_SITUACA 
			EndIf
			
			aDados[VL_ORIG] := Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),nDecs+1),nDecs)
			aDados[VL_NOMINAL] :=0
			aDados[VL_CORRIG]:=0    
			aDados[VL_VENCIDO]:=0
			
			If dDataBase > E1_VENCREA	//vencidos
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_NOMINAL] := nSaldo * If(SE1->E1_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM, -1,1)  
				EndIf
				// Somente chamad fa070juros se realmente houver necessidade de calculo de juros			
				If lFJurCst .Or. !Empty(SE1->E1_VALJUR) .Or. !Empty(SE1->E1_PORCJUR)
					nJuros := fa070Juros(mv_par15)
				EndIf	
				// Se titulo do Template GEM
				If lHasLOT .And. SE1->(FieldPos("E1_NCONTR")) > 0 .And. !Empty(SE1->E1_NCONTR) .And. SE1->E1_VALOR==SE1->E1_SALDO
					nJuros -= nGem
				EndIf
				dbSelectArea("SE1")
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_CORRIG] := (nSaldo+nJuros)* If(SE1->E1_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM, -1,1) 
				EndIf

				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .or. (mv_par33 == 1 .and. SE1->E1_TIPO $ MVABATIM)
					nTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit1 -= (nSaldo)
					nTit2 -= (nSaldo+nJuros)
					nMesTit0 -= Round(NoRound( xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit1 -= (nSaldo)
					nMesTit2 -= (nSaldo+nJuros)
					nTotJur  -= nJuros
					nMesTitj -= nJuros
					nTotFilJ -= nJuros
				Else
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)						
						nTit1 += (nSaldo)
						nTit2 += (nSaldo+nJuros)
						nMesTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
						nMesTit1 += (nSaldo)
						nMesTit2 += (nSaldo+nJuros)
						nTotJur  += nJuros
						nMesTitj += nJuros
						nTotFilJ += nJuros
					Endif	
				Endif
			Else						//a vencer
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_VENCIDO] := nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1)
				EndIf

				If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM)
					nTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit3 += (nSaldo-nTotAbat)
					nTit4 += (nSaldo-nTotAbat)
					nMesTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit3 += (nSaldo-nTotAbat)
					nMesTit4 += (nSaldo-nTotAbat)
				Else
					nTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit3 -= (nSaldo-nTotAbat)
					nTit4 -= (nSaldo-nTotAbat)
					nMesTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit3 -= (nSaldo-nTotAbat)
					nMesTit4 -= (nSaldo-nTotAbat)
				Endif

			Endif
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				aDados[NUMBC] := SE1->E1_NUMBCO
			EndIf

			If nJuros > 0

				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_JUROS] := nJuros
				EndIf

				nJuros := 0

			Endif
			
			If dDataBase > SE1->E1_VENCREA .And. !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
				nAtraso:=dDataBase-SE1->E1_VENCTO
				If Dow(SE1->E1_VENCTO) == 1 .Or. Dow(SE1->E1_VENCTO) == 7
					If Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso := 0
					EndIf
				EndIf
				nAtraso:=If(nAtraso<0,0,nAtraso)
				If nAtraso>0
					If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
						aDados[ATRASO] := nAtraso
					EndIf
				EndIf
			Else
				If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)				
					nAtraso:=dDataBase-if(dDataBase==SE1->E1_VENCREA,SE1->E1_VENCREA,SE1->E1_VENCTO)          
					nAtraso:=If(nAtraso<0,0,nAtraso)
				Else
					nAtraso:=0
				EndIf						
				aDados[ATRASO] := nAtraso
			EndIf
            
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico 18
				aDados[HISTORICO] := SubStr(SE1->E1_HIST,1,25)+IIF(E1_TIPO $ MVPROVIS,"*"," ")+ ;
				Iif(Str(nSaldo,17,2) == Str(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),17,2)," ","P")
				//exibe a linha no relatorio
				oSection1:PrintLine()
				aFill(aDados,nil)
			EndIf

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Carrega data do registro para permitir ?
			//? posterior an爈ise de quebra por mes.   ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dDataAnt := If(nOrdem == 6, SE1->E1_EMISSAO, Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))

			If lFR130Tel
				cCampoCli := ExecBlock("FR130TELC",.F.,.F.)
				If !SA1->(FieldPos(cCampoCli)) > 0
					cCampoCli := ""
				EndIf
			EndIf
			                        
			If nOrdem == 1 //Cliente
				cNomFor := If(mv_par29 == 1, AllTrim(SA1->A1_NREDUZ),AllTrim(SA1->A1_NOME)) +"  "+Substr(Iif(!Empty(cCampoCli),SA1->(&cCampocli),SA1->A1_DDD+"-"+SA1->A1_TEL),1,18)
			Elseif nOrdem == 8 //codigo do cliente
				cNomFor := SA1->A1_COD+" "+SA1->A1_LOJA+" "+AllTrim(SA1->A1_NOME)+"  "+Substr(Iif(!Empty(cCampoCli),SA1->(&cCampocli),SA1->A1_DDD+"-"+SA1->A1_TEL),1,18)
			Endif
			
			If nOrdem == 5 //Natureza
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+SE1->E1_NATUREZ)
				cNomNat := SED->ED_CODIGO+" "+SED->ED_DESCRIC
			Endif
			
			If nOrdem == 7
				cNumBco := SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA
			Else
				cNumBco := SE1->E1_PORTADO			
			Endif
			dDtVenc := Iif(nOrdem == 4 .OR. nOrdem == 7, Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA), SE1->E1_EMISSAO)
			nTotVenc := nTit2+nTit3
			nTotMes := nMesTit2+nMesTit3	
			
			SE1->(dbSkip())
			
			nTotTit ++
			nMesTTit ++
			nTotFiltit++
			nTit5 ++

		Enddo

		If nOrdem == 3
			SA6->(dbSeek(xFilial()+cCarAnt))
		ELSEIf nOrdem == 7
			SA6->(dbSeek(xFilial()+SUBSTR(cCarAnt,9) ))
		EndIf
			
		IF nTit5 > 0 .And. nOrdem != 2 .And. nOrdem != 10 .And. mv_par19 == 2 //1 = Analitico - 2 = Sintetico
			SubTot130R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs,oReport,,oSection2)
		Endif
		
		nTotTitMes	:= nMesTTit
		nTotGeral	+= (nTit2+nTit3)
					
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Verifica quebra por m坰	  			    ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		lQuebra := .F.
		If nOrdem == 4  .and. (Month(Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA)) # Month(dDataAnt) .or. Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) > mv_par10)
		 	If(mv_par19 == 2) //1 = Analitico - 2 = Sintetico
				lQuebra := .T.
		    Else
			  	nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
			EndIf  	
		Elseif nOrdem == 6 .and. (Month(SE1->E1_EMISSAO) # Month(dDataAnt) .or. SE1->E1_EMISSAO > mv_par14)
			If(mv_par19 == 2) //1 = Analitico - 2 = Sintetico
				lQuebra := .T.
			Endif
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif
			
		If lQuebra .and. nMesTTit # 0
			//QUEBRA POR MES  
			oReport:SkipLine()
			oReport:ThinLine()
			IMes130R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs,oReport,,oSection2)

			If nOrdem == 4  .and. (Month(Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA)) # Month(dDataAnt) .or.;
			   Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) > mv_par10) .And. (mv_par19 == 2)		
				nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
			EndIf
		
		
		Endif

		// Quebra por Cliente. 
		// "Salta pagina por cliente?" igual a "Sim" e a ordem eh por cliente ou codigo do cliente
		If mv_par35 == 1 .And. (nOrdem == 1 .Or. nOrdem == 8)
			oBreak:OnPrintTotal( { || oReport:EndPage() } )	// Finaliza pagina atual
		EndIf
		
		dbSelectArea("SE1")
		
		nTot0+=nTit0
		nTot1+=nTit1
		nTot2+=nTit2
		nTot3+=nTit3
		nTot4+=nTit4
		nTotJ+=nTotJur
		
		nTotFil0+=nTit0
		nTotFil1+=nTit1
		nTotFil2+=nTit2
		nTotFil3+=nTit3
		nTotFil4+=nTit4
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur,nTotAbat
	Enddo

	nTotFil := IIf(Empty(nTotFil2),nTotFil0,nTotFil2)
	If nTotFil0 <> 0
		cNomFil := cFilAnt + " - " + AllTrim(SM0->M0_FILIAL)
	EndIf	
	
	If mv_par19 == 2 //1= Analitico   2 = Sintetico
		If mv_par21 == 1 .And. SM0->(Reccount()) > 1
			//Imprimir TOTAL por filial somente quando houver mais do que 1 filial.
			IFil130R(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFiltit,nTotFilJ,nDecs,oReport,,oSection2)
		Endif
	Endif
	dbSelectArea("SE1")		// voltar para alias existente, se nao, nao funciona
	
	Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ
	If Empty(xFilial("SE1"))
		Exit
	Endif
	
	#IFDEF TOP
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	#ENDIF

	// Quebra por Cliente. 
	// Evitar salto de pagina antes da impressao do total geral
	If mv_par35 == 1 .And. (nOrdem == 1 .Or. nOrdem == 8)	// Cliente ou Codigo do Cliente
		oBreak:OnPrintTotal( { || } )
	EndIf	
	
	dbSelectArea("SM0")
	dbSkip()
Enddo

// Quebra por Filial.
// Evitar salto de pagina antes da impressao do total geral
If mv_par35 == 1 .And. lTotFil .And. (nOrdem == 1 .Or. nOrdem == 8)
	oBreak2:OnPrintTotal( { || } )
EndIf

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL

//Total geral para o Relatorio Sintetico   
If mv_par19 == 2 .And. nOrdem != 2 .And. nOrdem != 10 //1 = Analitico - 2 = Sintetico
	oReport:SkipLine()
	oReport:ThinLine()
	TotGer130R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs,oReport,,oSection2)
Endif

oSection1:Finish()
oSection2:Finish()

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndexSE1)
		FErase (cIndexSE1+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	dbSetOrder(1)
#ENDIF

SM0->(dbGoTo(nRegEmp))
cFilAnt :=SM0->M0_CODFIL 

//Acerta a database de acordo com a database real do sistema
If mv_par20 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪?-穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噭o	 砈ubTot130R ? Autor ? Daniel Tadashi Batori ? Data ? 03.08.06 潮?
北媚哪哪哪哪呐哪哪哪哪?-牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噭o 矷mprimir SubTotal do Relatorio										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? SubTot130R()															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?																				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso 	    ? Generico																	  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function SubTot130R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs,oReport,aDados,oSection)

Local cQuebra := ""

If nOrdem = 1
	//mv_par29 - Imprime Nome?
	cQuebra := If(mv_par29 == 1,Substr(SA1->A1_NREDUZ,1,40),Substr(SA1->A1_NOME,1,40))+" "+ STR0054 + Right(cCarAnt,2)+Iif(mv_par21==1,STR0055+cFilAnt + " - " + Alltrim(SM0->M0_FILIAL),"")//"Loja - "###" Filial - "
Elseif nOrdem == 4 .or. nOrdem == 6
	cQuebra := PadR(STR0037,28) + DtoC(cCarAnt) + "  " + If(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"  ")
Elseif nOrdem = 3
	cQuebra := PadR(STR0037,28) + If(Empty(SA6->A6_NREDUZ),STR0029,SA6->A6_NREDUZ) + " " + If(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem == 5 //por Natureza
	SED->( dbSetOrder( 1 ) )
	SED->( dbSeek(cFilial+cCarAnt) )
	cQuebra := PadR(STR0037,28) + cCarAnt + " "+Substr(SED->ED_DESCRIC,1,50) + " " + If(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
Elseif nOrdem == 7
	cQuebra := PadR(STR0037,28) + SubStr(cCarAnt,7,2)+"/"+SubStr(cCarAnt,5,2)+"/"+SubStr(cCarAnt,3,2)+" - "+SubStr(cCarAnt,9,3) + " " +Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem = 8
   	cQuebra := SA1->A1_COD+" "+Substr(SA1->A1_NOME,1,40)+" " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem = 9
	cCarteira := Situcob(cCarAnt)
	cQuebra := SA6->A6_COD+" "+SA6->A6_NREDUZ + SubStr(cCarteira,1,2) + " "+SubStr(cCarteira,3,20) + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
Endif

HabiCel(oReport, ( nOrdem == 5 .And. MV_MULNATR ) )

oSection:Cell("QUEBRA"   ):SetBlock({|| cQuebra})
oSection:Cell("TOT_NOMI" ):SetBlock({|| nTit1  })
oSection:Cell("TOT_CORR" ):SetBlock({|| nTit2  })
oSection:Cell("TOT_VENC" ):SetBlock({|| nTit3 })
oSection:Cell("TOT_SOMA" ):SetBlock({|| nTit2+nTit3})

oSection:PrintLine()

Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪-履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? TotGer130R? Autor ? Paulo Boschetti       ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪?-牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噭o ? Imprimir total do relatorio										   潮?
北媚哪哪哪哪呐哪哪哪哪哪-哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? TotGer130R()															   潮?
北媚哪哪哪哪呐哪哪哪哪哪?-哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros?																				   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪-哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico																	   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪?-哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function TotGer130R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs,oReport,aDados,oSection)

DEFAULT nDecs := Msdecimais(mv_par15)

HabiCel(oReport)

oSection:Cell("QUEBRA"   ):SetBlock({|| STR0038 +"("+ AllTrim(Str(nTotTit)) +" "+ If(nTotTit > 1, STR0039, STR0040) +")"}) //"TOTAL"
oSection:Cell("TOT_NOMI" ):SetBlock({|| nTot1  })
oSection:Cell("TOT_CORR" ):SetBlock({|| nTot2  })
oSection:Cell("TOT_VENC" ):SetBlock({|| nTot3  })
oSection:Cell("TOT_SOMA" ):SetBlock({|| nTot2+nTot3}) 
oSection:PrintLine()

Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矷Mes130R	? Autor ? Vinicius Barreira	  ? Data ? 12.12.94 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷MPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? IMes130R()	 															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function IMes130R(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs,oReport,aDados,oSection)

HabiCel(oReport)

oSection:Cell("QUEBRA"   ):SetBlock({|| PadR(STR0041,28) + "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi(STR0039),OemToAnsi(STR0040))+")"})
oSection:Cell("TOT_NOMI" ):SetBlock({|| nMesTot1})
oSection:Cell("TOT_CORR" ):SetBlock({|| nMesTot2})
oSection:Cell("TOT_VENC" ):SetBlock({|| nMesTot3})
oSection:Cell("TOT_SOMA" ):SetBlock({|| nMesTot2+nMesTot3})

oSection:PrintLine()

Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? IFil130R ? Autor ? Paulo Boschetti  	  ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Imprimir total do relatorio por filial							  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? IFil130R()																  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?																				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso 	    ? Generico																	  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function IFil130R(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ,nDecs,oReport,aDados,oSection)

HabiCel(oReport)

oSection:Cell("QUEBRA"   ):SetBlock({|| STR0043 + " " + If(mv_par21==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")})  //"T O T A L   F I L I A L ----> "
oSection:Cell("TOT_NOMI" ):SetBlock({|| nTotFil1})
oSection:Cell("TOT_CORR" ):SetBlock({|| nTotFil2})
oSection:Cell("TOT_VENC" ):SetBlock({|| nTotFil3})
oSection:Cell("TOT_JUROS"):SetBlock({|| nTotFilJ})
oSection:Cell("TOT_SOMA" ):SetBlock({||nTotFil2+nTotFil3})   

If mv_par19 == 1 // 1 = Analitico - 2 = Sintetico
	aDados[VL_ORIG] := nTotFil0
Endif

oSection:PrintLine()

Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矵abiCel	? Autor ? Daniel Tadashi Batori ? Data ? 04/08/06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砲abilita ou desabilita celulas para imprimir totais			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? HabiCel()	 															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? lHabilit->.T. para habilitar e .F. para desabilitar		  潮?
北?			 ? oReport ->objeto TReport que possui as celulas 				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function HabiCel(oReport, lMultNat)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)

Default lMultNat	:= .F.

If mv_par19 == 1 //1 =  Analitico - 2 = Sintetico
	If !lMultNat
		oSection1:Cell("CLIENTE"   ):SetSize(50)
		oSection1:Cell("TITULO"    ):Disable()
		oSection1:Cell("E1_TIPO"   ):Hide()
		oSection1:Cell("E1_NATUREZ"):Hide()
		oSection1:Cell("E1_EMISSAO"):Hide()
		oSection1:Cell("E1_VENCTO" ):Hide()
		oSection1:Cell("E1_VENCREA"):Hide()
		oSection1:Cell("VAL_ORIG"  ):Hide()
		oSection1:Cell("BANCO"     ):Hide()
		oSection1:Cell("DIA_ATR"   ):Hide()
		oSection1:Cell("E1_HIST"   ):Disable()
		oSection1:Cell("VAL_SOMA"  ):Enable()
		
		oSection1:Cell("CLIENTE"   ):HideHeader()
		oSection1:Cell("E1_TIPO"   ):HideHeader()
		oSection1:Cell("E1_NATUREZ"):HideHeader()
		oSection1:Cell("E1_EMISSAO"):HideHeader()
		oSection1:Cell("E1_VENCTO" ):HideHeader()
		oSection1:Cell("E1_VENCREA"):HideHeader()
		oSection1:Cell("VAL_ORIG"  ):HideHeader()
		oSection1:Cell("BANCO"     ):HideHeader()
		oSection1:Cell("DIA_ATR"   ):HideHeader()
	
	EndIf	
Else
	oSection2:Cell("QUEBRA"   ):SetSize(100)
Endif

Return(.T.)



/*
---------------------------------------------------------- RELEASE 3 ---------------------------------------------
*/



/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? FINR130R3? Autor ? Paulo Boschetti	     ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Posi噭o dos Titulos a Receber 						 	  		  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? FINR130R3(void)									  					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 												  				  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
Static Function RFIN008R3()
Local cDesc1 :=OemToAnsi(STR0001)  //"Imprime a posi噭o dos titulos a receber relativo a data ba-"
Local cDesc2 :=OemToAnsi(STR0002)  //"se do sistema."
Local cDesc3 :=""
Local wnrel
Local cString:="SE1"
Local nRegEmp:=SM0->(RecNo())
Local dOldDtBase := dDataBase
Local dOldData	:= dDatabase

Private titulo  :=""
Private cabec1  :=""
Private cabec2  :=""

Private aLinha  :={}
Private aReturn :={ OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg	 :="FIN130"
Private nJuros  :=0
Private nLastKey:=0
Private nomeprog:="FINR130"
Private tamanho :="G"

Private _aDados := {}
Private _aCabec := {}

//谀哪哪哪哪哪哪哪哪哪哪哪哪目
//? Defini噭o dos cabe嘺lhos ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪馁
titulo := OemToAnsi(STR0005)  //"Posicao dos Titulos a Receber"
cabec1 := OemToAnsi(STR0006)  //"Codigo Nome do Cliente      Prf-Numero         TP  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos Vencidos          | Titulos a Vencer | Num        Vlr.juros ou  Dias   Historico     "
cabec2 := OemToAnsi(STR0007)  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor Nominal   Valor Corrigido |   Valor Nominal  | Banco       permanencia  Atraso               "

//Nao retire esta chamada. Verifique antes !!!
//Ela ? necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

pergunte("FIN130",.F.)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Variaveis utilizadas para parametros												?
//? mv_par01		 // Do Cliente 													   ?
//? mv_par02		 // Ate o Cliente													   ?
//? mv_par03		 // Do Prefixo														   ?
//? mv_par04		 // Ate o prefixo 												   ?
//? mv_par05		 // Do Titulo													      ?
//? mv_par06		 // Ate o Titulo													   ?
//? mv_par07		 // Do Banco														   ?
//? mv_par08		 // Ate o Banco													   ?
//? mv_par09		 // Do Vencimento 												   ?
//? mv_par10		 // Ate o Vencimento												   ?
//? mv_par11		 // Da Natureza														?
//? mv_par12		 // Ate a Natureza													?
//? mv_par13		 // Da Emissao															?
//? mv_par14		 // Ate a Emissao														?
//? mv_par15		 // Qual Moeda															?
//? mv_par16		 // Imprime provisorios												?
//? mv_par17		 // Reajuste pelo vecto												?
//? mv_par18		 // Impr Tit em Descont												?
//? mv_par19		 // Relatorio Anal/Sint												?
//? mv_par20		 // Consid Data Base?  												?
//? mv_par21		 // Consid Filiais  ?  												?
//? mv_par22		 // da filial													      ?
//? mv_par23		 // a flial 												         ?
//? mv_par24		 // Da loja  															?
//? mv_par25		 // Ate a loja															?
//? mv_par26		 // Consid Adiantam.?												?
//? mv_par27		 // Da data contab. ?												?
//? mv_par28		 // Ate data contab.?												?
//? mv_par29		 // Imprime Nome    ?												?
//? mv_par30		 // Outras Moedas   ?												?
//? mv_par31       // Imprimir os Tipos												?
//? mv_par32       // Nao Imprimir Tipos												?
//? mv_par33       // Abatimentos  - Lista/Nao Lista/Despreza					?
//? mv_par34       // Consid. Fluxo Caixa												?
//? mv_par35       // Salta pagina Cliente											?
//? mv_par36       // Data Base													      ?
//? mv_par37       // Compoe Saldo por: Data da Baixa, Credito ou DtDigit  ?
//? MV_PAR38       // Tit. Emissao Futura												?
//? MV_PAR39       // Converte Valores 												?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Envia controle para a fun噭o SETPRINT ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

wnrel:="FINR130"            //Nome Default do relatorio em Disco
aOrd :={	OemToAnsi(STR0008),;	//"Por Cliente"
	OemToAnsi(STR0009),;	//"Por Prefixo/Numero"
	OemToAnsi(STR0010),; //"Por Banco"
	OemToAnsi(STR0011),;	//"Por Venc/Cli"
	OemToAnsi(STR0012),;	//"Por Natureza"
	OemToAnsi(STR0013),; //"Por Emissao"
	OemToAnsi(STR0014),;	//"Por Ven\Bco"
	OemToAnsi(STR0015),; //"Por Cod.Cli."
	OemToAnsi(STR0016),; //"Banco/Situacao"
	OemToAnsi(STR0047) } //"Por Numero/Tipo/Prefixo"

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

CONOUT( "["+ "RFIN008" + " - " + Dtoc( date() ) + " - " + time() + " ] " + "INICIO" )

RptStatus({|lEnd| FA130Imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

SM0->(dbGoTo(nRegEmp))
cFilAnt := SM0->M0_CODFIL 

//Acerta a database de acordo com a database real do sistema
If mv_par20 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

CONOUT( "["+ "RFIN008" + " - " + Dtoc( date() ) + " - " + time() + " ] " + "FINAL" )

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? FA130Imp ? Autor ? Paulo Boschetti		  ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Imprime relatio dos Tulos a Receber						  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? FA130Imp(lEnd,WnRel,cString)										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? lEnd	  - A嚻o do Codeblock				    					  潮?
北?			 ? wnRel   - Tulo do relatio 									  潮?
北?			 ? cString - Mensagem													  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function FA130Imp(lEnd,WnRel,cString)
Local CbCont
Local CbTxt
Local lContinua 	:= .T.
Local cCond1
Local cCond2
Local cCarAnt
Local nTit0			:=0
Local nTit1			:=0
Local nTit2			:=0
Local nTit3			:=0
Local nTit4			:=0
Local nTit5			:=0
Local nTotJ			:=0
Local nTot0			:=0
Local nTot1			:=0
Local nTot2			:=0
Local nTot3			:=0
Local nTot4			:=0
Local nTotTit		:=0
Local nTotJur		:=0
Local nTotFil0		:=0
Local nTotFil1		:=0
Local nTotFil2		:=0
Local nTotFil3		:=0
Local nTotFil4		:=0
Local nTotFilTit	:=0
Local nTotFilJ		:=0
Local nAtraso		:=0
Local nTotAbat		:=0
Local nSaldo		:=0
Local dDataReaj
Local dDataAnt := dDataBase
Local lQuebra
Local nMesTit0		:= 0
Local nMesTit1 		:= 0
Local nMesTit2 		:= 0
Local nMesTit3 		:= 0
Local nMesTit4 		:= 0
Local nMesTTit	 	:= 0
Local nMesTitj 		:= 0
Local cIndexSe1
Local cChaveSe1
Local nIndexSE1
Local dDtCtb	:=	CTOD("//")
Local cTipos  		:= ""
#IFDEF TOP
	Local aStru 	:= SE1->(dbStruct()), ni
#ENDIF	
Local aTamCli  		:= TAMSX3("E1_CLIENTE")
Local lF130Qry 		:= ExistBlock("F130QRY")
// variavel  abaixo criada p/pegar o nr de casas decimais da moeda
Local ndecs 		:= Msdecimais(mv_par15)
Local nAbatim 		:= 0
Local nDescont		:= 0
Local nVlrOrig		:= 0
Local nGem 			:= 0
Local aFiliais 		:= {}
Local aAreaSE5

//*************************************************
// Utilizada para guardar os abatimentos baixados *
// que devem subtrair o saldo do titulo principal.*
//*************************************************
Local nBx,aAbatBaixa	:= {}
Local nValPCC		:= 0
Local nLenFil		:= 0
Local nX			:= 0
Local cFilQry		:= ""
Local cFilSE1		:= ""
Local cFilSE5		:= ""
Local lHasLot		:= HasTemplate("LOT")
Local lTemGEM		:= ExistTemplate("GEMDESCTO") .And. HasTemplate("LOT")
Local lAS400		:= (Upper(TcSrvType()) != "AS/400" .And. Upper(TcSrvType()) != "ISERIES")
Local cMvDesFin		:= SuperGetMV("MV_DESCFIN",,"I")
Local aCliAbt		:= {}	// Clientes com titulos de abatimento
Local lFJurCst		:= Existblock("FJURCST")	// Ponto de entrada para calculo de juros
Local lRelCabec		:= .F.
Local cFilNat 		:= SE1->E1_NATUREZ
Local cWhere		:= ""                            
Local cFilSA1		:= ""
Local cFilSA6		:= ""
Local cFilSED		:= ""

Local cCodVend := ""

Local _cCodCli     := ""
Local _cLojCli     := ""
Local _cNomCli     := ""
Local _cPrefixo    := ""
Local _cTitulo     := ""
Local _cParcela    := ""
Local _cTipoTit    := ""
Local _cNatureza   := ""
Local _cEmissao    := ""
Local _cVecto      := ""
Local _cVectoReal  := ""
Local _cBanco      := ""
Local _cValorOri   := ""
Local _cTitVenc    := ""
Local _cTitVcorri  := ""
Local _cTitVlrAtu  := ""
Local _cNumBanco   := ""
Local _cDiasAtraso := ""
Local _cHistorico  := ""
Local _cVencidos   := ""
Local _cVendedor   := ""

Local nRecSE1    := 0
Local nHdl       := 0

Local lRet       := .F.
Local cPath      := GetTempPath() //Fun玢o que retorna o caminho da pasta temp do usu醨io logado, exemplo: %temp%
Local cDir       := Curdir()
Local cNameFile  := 'Aging1_' + dTos(Date()) + '.CSV'
Local cDado      := ''
Local cCabec     := "CLIENTE" + ';' + "LOJA" + ';' + "NOME CLIENTE" + ';' + "PREFIXO" + ';' + "TITULO" + ';' + "PARCELA" + ';' + "TP" + ';' + "NATUREZA" + ';' +;
                    "DATA EMISSAO" + ';' + "VENCTO TITULO" + ';' + "VENCTO REAL" + ';' + "BANCO" + ';' + "VALOR ORIGINAL" + ';' + ;
                    "TIT VENCIDOS VALOR ATUAL" + ';' + "TIT VENCIDOS VALOR CORRIGIDO" + ';' + "TIT a VENCER VALOR ATUAL" + ';' + "NUM BANCARIO" + ';' +; 
                    "VENDEDOR" + ';' + "DIAS ATRASO" + ';' + "HISTORICO"


PRIVATE nRegSM0 	:= SM0->(Recno())
PRIVATE nAtuSM0 	:= SM0->(Recno())
PRIVATE nOrdem		:= 0
PRIVATE dBaixa 		:= dDataBase
PRIVATE cFilDe
PRIVATE cFilAte

nOrdem:=aReturn[8]
cMoeda:=Str(mv_par15,1)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Vari爒eis utilizadas para Impress刼 do Cabe嘺lho e Rodap? ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
cbtxt 	:= OemtoAnsi(STR0046)
cbcont	:= 1
li 		:= 80
m_pag 	:= 1

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? POR MAIS ESTRANHO QUE PARE?A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ?
//?                                                                  ?
//? A fun噭o SomaAbat reabre o SE1 com outro nome pela ChkFile para  ?
//? efeito de performance. Se o alias auxiliar para a SumAbat() n刼  ?
//? estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ?
//? pois o Filtro do SE1 uptrapassa 255 Caracteres.                  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
SomaAbat("","","","R")

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Atribui valores as variaveis ref a filiais                ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
If mv_par21 == 2
	cFilDe  := SM0->M0_CODFIL
	cFilAte := SM0->M0_CODFIL
ELSE
	cFilDe := mv_par22	// Todas as filiais
	cFilAte:= mv_par23
Endif

//Acerta a database de acordo com o parametro
If mv_par20 == 1    // Considera Data Base
	dBaixa := dDataBase := mv_par36
Endif	

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

// Cria vetor com os codigos das filiais da empresa corrente
aFiliais := FinRetFil()

SetRegua(0)
IncRegua()

While !Eof() .and. SM0->M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL <= cFilAte

	dbSelectArea("SE1")
	cFilAnt := SM0->M0_CODFIL 
	Set Softseek On

	cFilSE5		:= xFilial( "SE5" )
	cFilSE1		:= xFilial( "SE1" )
	cFilSA1		:= xFilial( "SA1" )
	cFilSA6		:= xFilial( "SA6" )
	cFilSED		:= xFilial( "SED" )

	lVerCmpFil	:= !Empty(cFilSE1) .And. !Empty(cFilSE5) .And. Len(aFiliais) > 1

	If !lRelCabec
		If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
			titulo := AllTrim(Titulo) + " " + OemToAnsi(STR0080)+ " " + AllTrim(GetMv("MV_MOEDA"+cMoeda))+ OemToAnsi(STR0026)  //" - Analitico"
			
		Else
			titulo := AllTrim(Titulo) + " " + OemToAnsi(STR0080)+ " " + AllTrim(GetMv("MV_MOEDA"+cMoeda)) + OemToAnsi(STR0027)  //" - Sintetico"
			cabec1 := OemToAnsi(STR0044)  //"                                                                                                               |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
			cabec2 := OemToAnsi(STR0045)  //"                                                                                                               |  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
		EndIf
	EndIf	
	#IFDEF TOP

		// Verifica se deve montar filtro de filiais para compensacao em filiais diferentes
		If mv_par20 == 1 .And. lVerCmpFil
			nLenFil	:= Len( aFiliais )
			cFilQry	:= ""
			For nX := 1 To nLenFil
				If aFiliais[nX] != cFilSE5
					If !Empty( cFilQry ) 
						cFilQry += ", "
					Endif
					cFilQry += "'" + aFiliais[nX] + "'"
				EndIf
			Next nX
		EndIf

		// Verifica os titulos que possuem qualquer tipo de abatimento, para evitar chamada da SumAbat sem necessidade
		cQuery := "SELECT "

		cQuery += "E1_CLIENTE, E1_LOJA "
		cQuery += "FROM " + RetSQLName( "SE1" ) + " "
		cQuery += "WHERE "                                             
		cQuery += "    E1_FILIAL = '" + cFilSE1 + "' "
		cQuery += "AND E1_TIPO IN " + FormatIn( MVABATIM, "|" ) + " "
		cQuery += "AND D_E_L_E_T_ = ' ' "
		cQuery += "GROUP BY E1_CLIENTE, E1_LOJA "

		cQuery := ChangeQuery(cQuery)                   
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBABT",.T.,.T.)	
		
		Do While ! EoF()
			AAdd( aCliAbt, TRBABT->E1_CLIENTE + TRBABT->E1_LOJA )
			dbSkip()
		EndDo                   
		
 		dbSelectArea( "SE1" )
		
		TRBABT->( dbCloseArea() )
		/*
		If nOrdem = 1
			cQuery := ""
			aEval(SE1->(DbStruct()),{|e| If(!Alltrim(e[1])$"E1_FILIAL#E1_NOMCLI#E1_CLIENTE#E1_LOJA#E1_PREFIXO#E1_NUM#E1_PARCELA#E1_TIPO", cQuery += ","+AllTrim(e[1]),Nil)})
			cQuery := "SELECT E1_FILIAL, E1_NOMCLI, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM,E1_PARCELA, E1_TIPO, "+ SubStr(cQuery,2)
		Else
			cQuery := "SELECT * "
		EndIf*/
		
		cQuery := "SELECT * "
		
		cQuery += "  FROM "+	RetSqlName("SE1") 
		cQuery += " WHERE E1_FILIAL = '" + cFilSE1 + "'"
		cQuery += "   AND D_E_L_E_T_ = ' ' "
	#ENDIF
	
	IF nOrdem = 1 .and. !lRelCabec
		//cChaveSe1 := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		cChaveSe1 := "E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFDEF TOP
			cOrder := SqlOrder(cChaveSe1)
		#ELSE
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ENDIF
		cCond1 := "SE1->E1_CLIENTE <= mv_par02"
		cCond2 := "SE1->E1_CLIENTE + SE1->E1_LOJA"
		titulo := titulo + OemToAnsi(STR0017)  //" - Por Cliente"
		lRelCabec := .T.
		
	Elseif nOrdem = 2 .and. !lRelCabec
		SE1->(dbSetOrder(1))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par03+mv_par05)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_NUM <= mv_par06"
		cCond2 := "E1_NUM"
		titulo := titulo + OemToAnsi(STR0018)  //" - Por Numero"
		lRelCabec := .T.
		
	Elseif nOrdem = 3 .and. !lRelCabec
		SE1->(dbSetOrder(4))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par07)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_PORTADO <= mv_par08"
		cCond2 := "E1_PORTADO"
		titulo := titulo + OemToAnsi(STR0019)  //" - Por Banco"
		lRelCabec := .T.
		
	Elseif nOrdem = 4 .and. !lRelCabec
		SE1->(dbSetOrder(7))
		#IFNDEF TOP
			dbSeek(cFilial+DTOS(mv_par09))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+" <= mv_par10"
		cCond2 := Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")
		titulo := titulo + OemToAnsi(STR0020)  //" - Por Data de Vencimento"
		lRelCabec := .T.
		
	Elseif nOrdem = 5 .and. !lRelCabec
		SE1->(dbSetOrder(3))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par11)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_NATUREZ <= mv_par12"
		cCond2 := "E1_NATUREZ"
		titulo := titulo + OemToAnsi(STR0021)  //" - Por Natureza"
		lRelCabec := .T.
		
	Elseif nOrdem = 6 .and. !lRelCabec
		SE1->(dbSetOrder(6))
		#IFNDEF TOP
			dbSeek( cFilial+DTOS(mv_par13))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_EMISSAO <= mv_par14"
		cCond2 := "E1_EMISSAO"
		titulo := titulo + OemToAnsi(STR0042)  //" - Por Emissao"
		lRelCabec := .T.
		
	Elseif nOrdem == 7 .and. !lRelCabec
		cChaveSe1 := "E1_FILIAL+DTOS("+Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+")+E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ELSE
			cOrder := SqlOrder(cChaveSe1)
		#ENDIF
		cCond1 := Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+" <= mv_par10"
		cCond2 := "DtoS("+Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+")+E1_PORTADO+E1_AGEDEP+E1_CONTA"
		titulo := titulo + OemToAnsi(STR0023)  //" - Por Vencto/Banco"
		lRelCabec := .T.
		
	Elseif nOrdem = 8 .and. !lRelCabec
		SE1->(dbSetOrder(2))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par01,.T.)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_CLIENTE <= mv_par02"
		cCond2 := "E1_CLIENTE"
		titulo := titulo + OemToAnsi(STR0024)  //" - Por Cod.Cliente"
		lRelCabec := .T.
		
	Elseif nOrdem = 9 .and. !lRelCabec
		cChave := "E1_FILIAL+E1_PORTADO+E1_SITUACA+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,fr130IndR(),OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbSeek(xFilial("SE1"))
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1 := "E1_PORTADO <= mv_par08"
		cCond2 := "E1_PORTADO+E1_SITUACA"
		titulo := titulo + OemToAnsi(STR0025)  //" - Por Banco e Situacao"
		lRelCabec := .T.
		
	ElseIf nOrdem == 10 .and. !lRelCabec
		cChave := "E1_FILIAL+E1_NUM+E1_TIPO+E1_PREFIXO+E1_PARCELA"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,,OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbSeek(xFilial("SE1")+mv_par05)
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1 := "E1_NUM <= mv_par06"
		cCond2 := "E1_NUM"
		titulo := titulo + OemToAnsi(STR0048)  //" - Numero/Prefixo"	
		lRelCabec := .T.
		
	Endif
	
	If mv_par19 <> 1 //1 = Analitico - 2 = Sintetico
		cabec1 := OemToAnsi(STR0044)  //"Nome do Cliente      |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0045)  //"|  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
	EndIf
	
	cFilterUser:=aReturn[7]
	Set Softseek Off
	
	#IFDEF TOP                                  
		If ! ( Empty( mv_par01 ) .And. AllTrim( Upper( mv_par02 ) ) == Replicate( "Z", Len( mv_par02 ) ) )
			cQuery += " AND E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02 + "'"
		EndIf	
		
		If ! ( Empty( mv_par24 ) .And. AllTrim( Upper( mv_par25 ) ) == Replicate( "Z", Len( mv_par25 ) ) )
			cQuery += " AND E1_LOJA    between '" + mv_par24        + "' AND '" + mv_par25 + "'"
		EndIf
		
		If ! ( Empty( mv_par03 ) .And. AllTrim( Upper( mv_par04 ) ) == Replicate( "Z", Len( mv_par04 ) ) )		
			cQuery += " AND E1_PREFIXO between '" + mv_par03        + "' AND '" + mv_par04 + "'"
		EndIf	
		
		If ! ( Empty( mv_par05 ) .And. AllTrim( Upper( mv_par06 ) ) == Replicate( "Z", Len( mv_par06 ) ) )		
			cQuery += " AND E1_NUM     between '" + mv_par05        + "' AND '" + mv_par06 + "'"
		EndIf
		
		If ! ( Empty( mv_par07 ) .And. AllTrim( Upper( mv_par08 ) ) == Replicate( "Z", Len( mv_par08 ) ) )		
			cQuery += " AND E1_PORTADO between '" + mv_par07        + "' AND '" + mv_par08 + "'"
		EndIf
			
		If mv_par40 == 2
			cQuery += " AND E1_VENCTO between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"
		Else
			cQuery += " AND E1_VENCREA between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"		
		Endif
		
		If 	! ( Empty( mv_par11 ) .And. AllTrim( Upper( mv_par12 ) ) == Replicate( "Z", Len( mv_par12 ) ) )				
			cQuery += " AND (E1_MULTNAT = '1' OR (E1_NATUREZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'))"
		EndIf
			                                        
		If mv_par13 <> mv_par27 .Or. mv_par14 <> mv_par28
			cQuery += " AND E1_EMISSAO between '" + DTOS(mv_par13)  + "' AND '" + DTOS(mv_par14) + "'"
		EndIf	

		If MV_PAR38 == 2 .And. mv_par28 <> mv_par36  //Nao considerar titulos com emissao futura
			cQuery += " AND E1_EMISSAO <= '" + DTOS(mv_par36) + "'"
		Endif

		cQuery += " AND ((E1_EMIS1  Between '"+ DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"') OR E1_EMISSAO Between '"+DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"')"
		If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
			cQuery += " AND E1_TIPO IN "+FormatIn(AllTrim(mv_par31),";") 
		ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32
			cQuery += " AND E1_TIPO NOT IN "+FormatIn(AllTrim(mv_par32),";")
		EndIf              
		
		//If mv_par18 == 2
			//cQuery += " AND E1_SITUACA NOT IN ( '2', '7' ) "
		//Endif
		
		If mv_par20 == 2
			cQuery += ' AND E1_SALDO <> 0'   
		Else                                                                                   
			If mv_par37 == 1
				cQuery += " AND ( E1_SALDO > 0 OR E1_BAIXA > '" + DtoS( dDataBase ) + "' ) " 
			EndIf	
		Endif

		If mv_par26 == 2 
			cQuery += "AND E1_TIPO NOT IN " + FormatIn( MVRECANT + "/" + MV_CRNEG, "/" )
		Endif
		         
		If mv_par33 != 1                                            
			If mv_par16 == 2
				cQuery += " AND E1_TIPO NOT IN " + FormatIn( MVABATIM + "|" + MVPROVIS, "|" ) 
			Else	
				cQuery += " AND E1_TIPO NOT IN " + FormatIn( MVABATIM, "|" ) 
			EndIf	
		EndIf	

		If mv_par34 == 1
			cQuery += " AND E1_FLUXO <> 'N'"
		Endif		                                      
		
		If mv_par21 <> 2
			If Empty( E1_FILIAL )
				cQuery += " AND E1_FILORIG between '" + mv_par22 + "' AND '" + mv_par23 + "'"				
			Else
				cQuery += " AND E1_FILIAL between '" + mv_par22 + "' AND '" + mv_par23 + "'"				
			EndIf
		Endif                  
        //谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
        //? Ponto de entrada para inclusao de parametros no filtro a ser executado ?
        //滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	    If lF130Qry 
			cQuery += ExecBlock("F130QRY",.f.,.f.)
		Endif

		cQuery += " ORDER BY "+ cOrder
		
		cQuery := ChangeQuery(cQuery)
		
		dbSelectArea("SE1")
		dbCloseArea()
		dbSelectArea("SA1")
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
		
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	#ENDIF
	
	If MV_MULNATR .And. nOrdem == 5
		Finr135R3(cTipos, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ)
		#IFDEF TOP
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSelectArea("SE1")
			dbSetOrder(1)
		#ENDIF
		If Empty(xFilial("SE1"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif

	/*
	aAdd( _aDados, { "CLIENTE","LOJA","NOME CLIENTE","PREFIXO","TITULO","PARCELA","TP","NATUREZA","DATA EMISSAO","VENCTO TITULO","VENCTO REAL",;
		             "BANCO","VALOR ORIGINAL","TIT VENCIDOS VALOR ATUAL","TIT VENCIDOS VALOR CORRIGIDO","TIT a VENCER VALOR ATUAL","NUM BANCO",;
		             "VENDEDOR","DIAS ATRASO","HISTORICO" } )
	*/
	
	IF File( cDir + cNameFile )
		Ferase( cDir + cNameFile)
	EndIF
	
	nHdl := FCreate( cNameFile )
	FWrite( nHdl, cCabec + CRLF )
		
	While SE1->( !Eof() ) .And. SE1->E1_FILIAL == cFilSE1 .And. &cCond1
		
		IF	lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0028)  //"CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Carrega data do registro para permitir ?
		//? posterior analise de quebra por mes.   ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dDataAnt := If(nOrdem == 6 , SE1->E1_EMISSAO,  Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))
		
		cCarAnt := &cCond2

		dbSelectArea( "SE1" )
		
		While &cCond2==cCarAnt .and. !Eof() .and. lContinua .and. SE1->E1_FILIAL == cFilSE1
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0028)  //"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIF

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Considera filtro do usuario                                  ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSelectArea("SE1")			
				dbSkip()
				Loop
			Endif
			
			If mv_par18 == 2
				If SE1->E1_SITUACA == '2' .OR. SE1->E1_SITUACA == '7'
					dbSkip()
					Loop
				Endif	
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se trata-se de abatimento ou somente titulos?
			//? at? a data base. 									 ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If (mv_par38 == 2 .And. SE1->E1_EMISSAO > mv_par36)
				IF !Empty(SE1->E1_TITPAI)
					aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1->E1_TITPAI } )
				Else
					cMTitPai := FTITPAI()
					aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , cMTitPai } )
				EndIf              
				dbSelectArea("SE1")				
				dbSkip()
				Loop
			Endif
			
			//Quando Retroagir saldo, data menor que o solicitado e o titulo estiver 
			//baixado nao mostrar no relatorio
			If (MV_PAR20 == 1 .and. cMVBR10925 == "1" .and. SE1->E1_EMISSAO <= MV_PAR36 .and. SE1->E1_TIPO $ "PIS/COF/CSL")
				dbSelectArea("SE1")			
				dbSkip()
				Loop				
			EndIf	
			
			// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtCtb	:=	CTOD("//")
			dDtCtb	:= Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)
                    
			If ( MV_PAR38 == 2 .And. SE1->E1_EMISSAO > mv_par36 )
				dbSelectArea("SE1")			
				dbSkip()
				Loop
			Endif
			
			If dDtCtb < mv_par27 .Or. dDtCtb > mv_par28 
				dbSelectArea("SE1")			
				dbSkip()
				Loop
			Endif

			// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
			If SE1->E1_VENCREA < dDataBase
				If mv_par17 == 2 .And. RecMoeda(SE1->E1_VENCREA,cMoeda) > 0
					dDataReaj := SE1->E1_VENCREA
				Else
					dDataReaj := dDataBase
				EndIf	
			Else
				dDataReaj := dDataBase
			EndIf
						
			If mv_par20 == 1	// Considera Data Base

			    If SE1->E1_SALDO == SE1->E1_VALOR
			    	nSaldo := SE1->E1_SALDO
				Else
					nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par15,dDataReaj,MV_PAR36,SE1->E1_LOJA,,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0),mv_par37)
				EndIf
				
				//Verifica se existem compensa珲es em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimenta珲es da filial corrente. Nao deve processar quando existe somente uma filial.
				If lVerCmpFil
					nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,mv_par37,aFiliais,cFilQry,lAS400),;
									SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(mv_par39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA) ),0 ) ),;
									nDecs+1),nDecs)
				EndIf  
				
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If (Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2)) .And. ((SE1->E1_DECRESC > 0) .OR. (SE1->E1_DESCONT >0 .And. SE1->E1_SDDECRE == 0) ) .and. F130DESC()
					If  SE1->E1_DECRESC > 0 
						nSAldo -= SE1->E1_DECRESC
					Endif
					If SE1->E1_DESCONT>0 .and. SE1->E1_DECRESC == 0 
						nSAldo -= SE1->E1_DESCONT
					Endif
				EndIf
				
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					nSAldo += SE1->E1_ACRESC
				Endif

				//Se abatimento verifico a data da baixa.
				//Por nao possuirem movimento de baixa no SE5, a saldotit retorna 
				//sempre saldo em aberto quando mv_par33 = 1 (Abatimentos = Lista) 
				If mv_par33 == 1
					If SE1->E1_TIPO == "BOL"
						aParam := {SE1->E1_FILIAL,SE1->E1_NOMCLI,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA}
						aAbatBaixa:=PesqAbat(aParam)
					Else			
						If SE1->E1_TIPO $ MVABATIM .and. ;
							((SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA)) .or. ;
							 (SE1->E1_MOVIMEN <= dDataBase .and. !Empty(SE1->E1_MOVIMEN))	) .and.;
							 SE1->E1_SALDO == 0			
							nSaldo := 0
							IF !Empty(SE1->E1_TITPAI)
								aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1->E1_TITPAI } )
							Else
								cMTitPai := FTITPAI()
								aAdd( aAbatBaixa , { SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , cMTitPai } )
							EndIf
						Endif 
					EndIf
				EndIf
								
				If ( cMVBR10925 == "1" .and. SE1->E1_EMISSAO <= MV_PAR36 .and. !(SE1->E1_TIPO $ "PIS/COF/CSL") .and. !(SE1->E1_TIPO $ MVABATIM))
					nValPcc := SumPCC130(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,dBaixa,SE1->E1_CLIENTE,SE1->E1_LOJA,mv_par15)
					nSaldo -= nValPcc
				EndIf
				If nSaldo <> 0 .and. SE1->E1_TIPO $ "NCC" .and. (MV_PAR37 == 2 .OR. MV_PAR37 == 3).and. SE1->E1_MOVIMEN <= dDataBase .and. SE1->E1_SALDO == 0
					dbSelectArea("SE1")				
					DbSkip()
					Loop
				EndIf
				If SE1->E1_TIPO == "RA "   //somente para titulos ref adiantamento verifica se nao houve cancelamento da baixa posterior data base (mv_par36)
					nSaldo -= F130TipoBA( cFilSE5 )
				EndIf
			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			Endif
			
			//Caso exista desconto financeiro (cadastrado na inclusao do titulo), 
			//subtrai do valor principal.
			If SE1->E1_DESCFIN > 0 .Or. SE1->E1_DECRESC > 0
  				If Empty( SE1->E1_BAIXA ) .Or. cMvDesFin == "P" .Or. (mv_par20==1 .And. cMvDesFin=="I" .And. dDataBase<SE1->E1_BAIXA)
					nDescont := FaDescFin("SE1",dBaixa,nSaldo,1,.T.,lTemGem)
					If nDescont > 0
						nSaldo := nSaldo - nDescont
					Endif
				EndIf
			EndIf	
						
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
					!( MV_PAR20 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					                                                          
			   		dbSelectArea("__SE1")
			   		dbSetOrder(2)
			   		dbSeek( cFilSED + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO )
					cFilNat := SE1->E1_NATUREZ				
					aTitImp := F130RETIMP( cFilNat, cFilSED )					
					
					If (nPos := (aScan(aTitImp, {|x| x[1] <> SE1->E1_TIPO }))) > 0 .and. aTitImp[nPos][2]
						
						//Quando considerar Titulos com emissao futura, eh necessario
						//colocar-se a database para o futuro de forma que a Somaabat()
						//considere os titulos de abatimento
						If mv_par38 == 1
							dOldData := dDataBase
							dDataBase := CTOD("31/12/40")
						Endif

						// Somente verifica abatimentos se existirem titulos deste tipo para o cliente
						If aScan( aCliAbt, SE1->(E1_CLIENTE + E1_LOJA) ) > 0
							nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,dDataReaj,SE1->E1_CLIENTE,SE1->E1_LOJA)
						Else
							nAbatim := 0
						EndIf
						
						If mv_par38 == 1
							dDataBase := dOldData
						Endif
						
						If mv_par33 != 1  //somente deve considerar abatimento no saldo se nao listar
							If STR(nSaldo,17,2) == STR(nAbatim,17,2)
								nSaldo := 0
							ElseIf mv_par33 == 2 //Se nao listar ele diminui do saldo
								nSaldo-= nAbatim
							Endif
						Else
							// Subtrai o Abatimento caso o mesmo j? tenho sido baixado ou n鉶 esteja listado no relatorios
							nBx := aScan( aAbatBaixa, {|x| x[2]= SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) } )
							If (SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA) .and. nBx>0)
								aDel( aAbatBaixa , nBx)
								aSize(aAbatBaixa, Len(aAbatBaixa)-1)
								nSaldo-= nAbatim
							EndIf
						EndIf
					EndIf
				EndIf
			Endif	
			nSaldo:=Round(NoRound(nSaldo,3),2)	
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Desconsidera caso saldo seja menor ou igual a zero   ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If nSaldo <= 0
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif					
				
			SA1->( dbSeek( cFilSA1 + SE1->E1_CLIENTE + SE1->E1_LOJA ) )
			If nOrdem == 3 .Or. nOrdem == 9
				SA6->( dbSeek( cFilSA6 + SE1->E1_PORTADO ) )
			EndIf
    	
			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico 
			
				@li,	0 PSAY SE1->E1_CLIENTE + "-" + SE1->E1_LOJA + "-" +;
					IIF(mv_par29 == 1, SubStr(SA1->A1_NREDUZ,1,20), SubStr(SA1->A1_NOME,1,20))
				li := IIf (aTamCli[1] > 6,li+1,li)
				
				@li, 31 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA         
				li := if( LEN( SE1->E1_NUM ) > 9, li+1, li )
				
				@li, 49 PSAY AllTrim(SE1->E1_TIPO)
				@li, 53 PSAY SE1->E1_NATUREZ
				@li, 63 PSAY SE1->E1_EMISSAO
				@li, 74 PSAY SE1->E1_VENCTO
				@li, 85 PSAY SE1->E1_VENCREA   
				
				_cCodCli    := SE1->E1_CLIENTE
				_cLojCli    := SE1->E1_LOJA
				_cNomCli    := IIF( mv_par29 == 1, SA1->A1_NREDUZ, SA1->A1_NOME )
				_cNomCli    := Alltrim( STRTRAN(_cNomCli, ';', ' ') )
				_cPrefixo   := SE1->E1_PREFIXO
				_cTitulo    := SE1->E1_NUM
				_cParcela   := SE1->E1_PARCELA
				_cTipoTit   := AllTrim(SE1->E1_TIPO)
				_cNatureza  := SE1->E1_NATUREZ 
				_cEmissao   := dToC(SE1->E1_EMISSAO)
				_cVecto     := dToC(SE1->E1_VENCTO)
				_cVectoReal := dToC(SE1->E1_VENCREA) 
				
				
				If mv_par20 == 1  //Recompoe Saldo Retroativo              
				    //Titulo foi Baixado e Data da Baixa e menor ou igual a Data Base do Relat髍io
				    IF !Empty(SE1->E1_BAIXA) 
				    	If SE1->E1_BAIXA <= mv_par36 .Or. !Empty( SE1->E1_PORTADO )
							@li, 95 PSAY SE1->E1_PORTADO+" "+SE1->E1_TIPMOV
						EndIf
					Else                                                                                   
					    //Titulo n鉶 foi Baixado e foi transferido para Carteira e Data Movimento e menor 
				    	//ou igual a Data Base do Relat髍io
						If Empty(SE1->E1_BAIXA) .and. SE1->E1_MOVIMEN <= mv_par36
							@li, 95 PSAY SE1->E1_PORTADO+" "+SE1->E1_TIPMOV             
						EndIf
					ENDIF
				Else   // Nao Recompoe Saldo Retroativo
					@li, 95 PSAY SE1->E1_PORTADO+" "+SE1->E1_TIPMOV
				EndIf
				
				_cBanco := SE1->E1_PORTADO
				
				nVlrOrig := Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),nDecs+1),nDecs)
				@li,100 PSAY nVlrOrig Picture TM(nVlrOrig,15,nDecs)
				
				_cValorOri := lTrim(Transform(nVlrOrig,"@E 999,999,999.99"))
			Endif
			
			If dDataBase > E1_VENCREA	//vencidos

				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@li,116 PSAY lTrim(Transform(nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1), "@E 999,999,999.99"))
					_cTitVenc := lTrim(Transform(nSaldo * If(SE1->E1_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM, -1,1),"@E 999,999,999.99"))
					//Transform(nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),"@E 999,999,999.99")
					                         
				EndIf

				nJuros := 0

				// Somente chamad fa070juros se realmente houver necessidade de calculo de juros			
				If lFJurCst .Or. !Empty(SE1->E1_VALJUR) .Or. !Empty(SE1->E1_PORCJUR)
					fa070Juros(mv_par15)
				EndIf	

				dbSelectArea("SE1")
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@li,132 PSAY lTrim(Transform((nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1), "@E 999,999,999.99"))
					_cTitVcorri := lTrim(Transform((nSaldo+nJuros)* If(SE1->E1_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM, -1,1) ,"@E 999,999,999.99"))
					//Transform((nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),"@E 999,999,999.99")
					                         
				EndIf
				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .or. (mv_par33 == 1 .and. SE1->E1_TIPO $ MVABATIM)
					nTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit1 -= (nSaldo)
					nTit2 -= (nSaldo+nJuros)
					nMesTit0 -= Round(NoRound( xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit1 -= (nSaldo)
					nMesTit2 -= (nSaldo+nJuros)
					nTotJur  -= nJuros
					nMesTitj -= nJuros
					nTotFilJ -= nJuros
				Else
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)						
						nTit1 += (nSaldo)
						nTit2 += (nSaldo+nJuros)
						nMesTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
						nMesTit1 += (nSaldo)
						nMesTit2 += (nSaldo+nJuros)
						nTotJur  += nJuros
						nMesTitj += nJuros
						nTotFilJ += nJuros
					Endif	
				Endif
			Else						//a vencer
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@li,149 PSAY nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1) Picture TM(nSaldo,15,nDecs)
					_cTitVlrAtu := Transform(nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),"@E 999,999,999.99")
					//Transform(nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),"@E 999,999,999.99")
					
				EndIf
				If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM)
					nTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit3 += (nSaldo-nTotAbat)
					nTit4 += (nSaldo-nTotAbat)
					nMesTit0 += Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit3 += (nSaldo-nTotAbat)
					nMesTit4 += (nSaldo-nTotAbat)
				ElseIF ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG ) .or. (mv_par33 == 1 .and. SE1->E1_TIPO $ MVABATIM) 
					nTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nTit3 -= (nSaldo-nTotAbat)
					nTit4 -= (nSaldo-nTotAbat)
					nMesTit0 -= Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),ndecs+1),ndecs)
					nMesTit3 -= (nSaldo-nTotAbat)
					nMesTit4 -= (nSaldo-nTotAbat)
				Endif
			Endif
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				@ li, 166 PSAY Substr(SE1->E1_NUMBCO,1,TamSx3("E1_NUMBCO")[1])
				_cNumBanco := AllTrim(Substr(SE1->E1_NUMBCO,1,TamSx3("E1_NUMBCO")[1]))
			EndIf
			If nJuros > 0
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@ Li,182 PSAY nJuros Picture Tm(nJuros, 15,nDecs)//PesqPict("SE1","E1_JUROS",16,MV_PAR15)
					_cJuros := Transform(nJuros,"@E 999,999,999.99")
				EndIf
				nJuros := 0
			Endif
			
			IF dDataBase > SE1->E1_VENCREA .And. !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
				nAtraso:=dDataBase-SE1->E1_VENCTO
				IF Dow(SE1->E1_VENCTO) == 1 .Or. Dow(SE1->E1_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso := 0
					EndIF
				EndIF
				nAtraso := IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
						@li ,200 PSAY nAtraso Picture "99999"
						_cDiasAtraso := Transform(nAtraso,"99999")
					EndIf
				EndIF
			Else
				If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					nAtraso:=dDataBase-if(dDataBase==SE1->E1_VENCREA,SE1->E1_VENCREA,SE1->E1_VENCTO)
					nAtraso:=If(nAtraso<0,0,nAtraso)					
				Else
					nAtraso:=0
				EndIf						
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@li ,200 PSAY nAtraso Picture "99999"
					_cDiasAtraso := lTrim(Transform(nAtraso,"99999"))
				EndIf	
			EndIF
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				@li,206 PSAY SubStr(SE1->E1_HIST,1,14)//+SE1->E1_ORIGPV
				_cHistorico := Alltrim(SE1->E1_HIST)
			EndIf
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				cCodVend := SE1->E1_VEND1
				DbSelectArea("SA3")
				SA3->(DbSetOrder(1)) // Filial + Codigo
				SA3->(DbSeek( xfilial("SA3")+ Alltrim(cCodVend) ))
					_cVendedor := Rtrim(SA3->A3_NOME)
				SA3->(DbCloseArea())	
			EndIf
			
			//Adiciona no Array para gera玢o no Excel
			/*
			aAdd( _aDados, { _cCodCli, _cLojCli, _cNomCli, _cPrefixo, _cTitulo, _cParcela, _cTipoTit, _cNatureza, _cEmissao, _cVecto,;
				             _cVectoReal, _cBanco, _cValorOri, _cTitVenc, _cTitVcorri, _cTitVlrAtu, _cNumBanco, _cVendedor, _cDiasAtraso, _cHistorico } )
			*/
			cDado := _cCodCli + ';' +  _cLojCli + ';' +  _cNomCli + ';' +  _cPrefixo + ';' +  _cTitulo + ';' +  _cParcela + ';' +  _cTipoTit + ';' +;  
			         _cNatureza + ';' +  _cEmissao + ';' +  _cVecto + ';' + _cVectoReal + ';' +  _cBanco + ';' +  _cValorOri + ';' +  _cTitVenc + ';' +;
			         _cTitVcorri + ';' +  _cTitVlrAtu + ';' +  _cNumBanco + ';' +  _cVendedor + ';' +  _cDiasAtraso + ';' +  _cHistorico
			
			FWrite( nHdl, cDado + CRLF )
			
			 _cTitVenc    := ''
			 _cTitVcorri  := ''  
			 _cTitVlrAtu  := ''
			 _cDiasAtraso := ''
			 cDado        := ''	              
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Carrega data do registro para permitir ?
			//? posterior an爈ise de quebra por mes.   ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dDataAnt := Iif(nOrdem == 6, SE1->E1_EMISSAO, Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))
			dbSelectArea("SE1")
			dbSkip()
			nTotTit ++
			nMesTTit ++
			nTotFiltit++
			nTit5 ++
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				li++
			EndIf
			
		Enddo

		If nOrdem == 3 .Or. nOrdem == 9
			SA6->(dbSeek(xFilial()+cCarAnt))
		EndIf
			
		IF nTit5 > 0 .and. nOrdem != 2 .and. nOrdem != 10
			SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				Li++
			EndIf
		Endif
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Verifica quebra por m坰	  			   ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		lQuebra := .F.
		If nOrdem == 4  .and. (Month(Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA)) # Month(dDataAnt) .or. Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) > mv_par10)
			lQuebra := .T.
		Elseif nOrdem == 6 .and. (Month(SE1->E1_EMISSAO) # Month(dDataAnt) .or. SE1->E1_EMISSAO > mv_par14)
			lQuebra := .T.
		Endif
		If lQuebra .and. nMesTTit # 0
			ImpMes130(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs)
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif
		nTot0+=nTit0
		nTot1+=nTit1
		nTot2+=nTit2
		nTot3+=nTit3
		nTot4+=nTit4
		nTotJ+=nTotJur
		
		nTotFil0+=nTit0
		nTotFil1+=nTit1
		nTotFil2+=nTit2
		nTotFil3+=nTit3
		nTotFil4+=nTit4
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur,nTotAbat
	Enddo

	dbSelectArea("SE1")		// voltar para alias existente, se nao, nao funciona
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//? Imprimir TOTAL por filial somente quan-?
	//? do houver mais do que 1 filial.        ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	if mv_par21 == 1 .and. SM0->(Reccount()) > 1
		ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFiltit,nTotFilJ,nDecs)
	Endif
	Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ
	If Empty(xFilial("SE1"))
		Exit
	Endif
	
	#IFDEF TOP
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	#ENDIF

	dbSelectArea("SM0")
	dbSkip()
Enddo

	Sleep(500)
		
	FClose( nHdl )
	
	IF File( cPath + cNameFile )
		Ferase( cPath + cNameFile)
	EndIF		
	
	Sleep(500)
	
	lRet := __CopyFile( cNameFile, cPath + cNameFile )
	
	IF lRet
		Sleep(500)
		
		Ferase( cDir + cNameFile)
		
		IF ! ApOleClient("MsExcel") 
			MsgAlert("MsExcel n鉶 instalado. Para abrir o arquivo, localize-o na pasta %temp% .","Confer阯cia Aging")
		Else
			ShellExecute( "Open", cPath + cNameFile , '', '', 1 )
		EndIF
	Else
		MsgAlert('N鉶 foi poss韛el copiar o arquivo para a pasta %temp%, o arquivo encontra-se no diret髍io [' + cDir + cNameFile + '] ;' + CRLF +;
		         'Verifique com Sistemas Corporativos.','Confer阯cia Aging')
	EndIF

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL 
IF li != 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)
	Roda(cbcont,cbtxt,"G")
EndIF

Set Device To Screen

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndexSE1)
		FErase (cIndexSE1+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	dbSetOrder(1)
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()
/*
If MsgYesNo('Gerar excel dos registros?') 
	FWMsgRun(,{|| DlgToExcel({ {"ARRAY",titulo, _aCabec, _aDados} }) }, titulo, 'Aguarde, Exportando os Registros para o Excel...')	 		         
EndIf
*/
Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 砈ubTot130 ? Autor ? Paulo Boschetti 		  ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷mprimir SubTotal do Relatorio										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? SubTot130()																  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?																				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso 	    ? Generico																	  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

Local cCarteira := " "  
Local lFR130Tel := ExistBlock("FR130TELC")
Local cCampoCli := ""
Local cTelefone := ""                        
Local nSeconds	:= 0

If lFR130Tel
	cCampoCli := ExecBlock("FR130TELC",.F.,.F.)
	If !SA1->(FieldPos(cCampoCli)) > 0
		cCampoCli := ""
	EndIf
EndIf                             

cTelefone := Alltrim(Transform(SA1->A1_DDD, PesqPict("SA1","A1_DDD"))+"-"+ Iif(!Empty(cCampoCli),Transform(SA1->(&cCampocli),PesqPict("SA1",cCampoCli)),TransForm(SA1->A1_TEL,PesqPict("SA1","A1_TEL")) ) )

DEFAULT nDecs := Msdecimais(mv_par15)

If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	li++
EndIf
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
If nOrdem = 1
	@li,000 PSAY IIF(mv_par29 == 1,Substr(SA1->A1_NREDUZ,1,40),Substr(SA1->A1_NOME,1,40))+" "+ cTelefone + " "+ STR0054 + Right(cCarAnt,2)+Iif(mv_par21==1,STR0055+cFilAnt + " - " + Alltrim(SM0->M0_FILIAL),"") //"Loja - "###" Filial - "
Elseif nOrdem == 4 .or. nOrdem == 6
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt
	@li,PCOL()+2 PSAY Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"  ")
Elseif nOrdem = 3
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY Iif(Empty(SA6->A6_NREDUZ),OemToAnsi(STR0029),SA6->A6_NREDUZ) + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem == 5
	dbSelectArea("SED")
	dbSeek(cFilial+cCarAnt)
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt + " "+Substr(ED_DESCRIC,1,50) + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
	dbSelectArea("SE1")
Elseif nOrdem == 7
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY SubStr(cCarAnt,7,2)+"/"+SubStr(cCarAnt,5,2)+"/"+SubStr(cCarAnt,3,2)+" - "+SubStr(cCarAnt,9,3) + " " +Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem = 8
	@li,000 PSAY SA1->A1_COD+" "+Substr(SA1->A1_NOME,1,40)+" "+ cTelefone + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
ElseIf nOrdem = 9
	cCarteira := Situcob(cCarAnt)
	@li,000 PSAY SA6->A6_COD+" "+SA6->A6_NREDUZ + SubStr(cCarteira,1,2) + " "+SubStr(cCarteira,3,20) + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
Endif
If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	@li,102 PSAY nTit0		  Picture TM(nTit0,14,nDecs)
Endif
@li,116 PSAY nTit1		  Picture TM(nTit1,15,nDecs)
@li,132 PSAY nTit2		  Picture TM(nTit2,15,nDecs)
If nOrdem <> 5
	@li,149 PSAY nTit3		  Picture TM(nTit3,15,nDecs)
Else
	@li,148 PSAY nTit3		  Picture TM(nTit3,15,nDecs)
EndIf
If nTotJur > 0
	@li,182 PSAY nTotJur  Picture TM(nTotJur,15,nDecs)
Endif
@li,200 PSAY nTit2+nTit3 Picture TM(nTit2+nTit3,15,nDecs)
li++
If (nOrdem = 1 .Or. nOrdem == 8) .And. mv_par35 == 1 // Salta pag. por cliente
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
Endif
Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? TotGer130? Autor ? Paulo Boschetti       ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Imprimir total do relatorio										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? TotGer130()																  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?																				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico																	  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

@li,000 PSAY OemToAnsi(STR0038) //"T O T A L   G E R A L ----> " + " " + Iif(mv_par21==1,cFilAnt,"")
@li,028 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi(STR0039),OemToAnsi(STR0040))+")"		//"TITULOS"###"TITULO" 
If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	@li,102 PSAY nTot0		  Picture TM(nTot0,14,nDecs)
Endif
@li,116 PSAY nTot1		  Picture TM(nTot1,15,nDecs)
@li,132 PSAY nTot2		  Picture TM(nTot2,15,nDecs)

If nOrdem <> 5
	@li,149 PSAY nTot3		  Picture TM(nTot3,15,nDecs)
Else
	@li,148 PSAY nTot3		  Picture TM(nTot3,15,nDecs)
EndIf
@li,182 PSAY nTotJ		  Picture TM(nTotJ,15,nDecs)
@li,200 PSAY nTot2+nTot3 Picture TM(nTot2+nTot3,15,nDecs) 
li++
li++
Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矷mpMes130 ? Autor ? Vinicius Barreira	  ? Data ? 12.12.94 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷MPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? ImpMes130() 															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function ImpMes130(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)
li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0041)  //"T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi(STR0039),OemToAnsi(STR0040))+")"  //"TITULOS"###"TITULO"
If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	@li,102 PSAY nMesTot0   Picture TM(nMesTot0,14,nDecs)
Endif
@li,116 PSAY nMesTot1	Picture TM(nMesTot1,15,nDecs)
@li,132 PSAY nMesTot2	Picture TM(nMesTot2,15,nDecs)
@li,149 PSAY nMesTot3	Picture TM(nMesTot3,15,nDecs)
@li,182 PSAY nMesTotJ	Picture TM(nMesTotJ,15,nDecs)
@li,200 PSAY nMesTot2+nMesTot3 Picture TM(nMesTot2+nMesTot3,15,nDecs)
li+=2
Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? ImpFil130? Autor ? Paulo Boschetti  	  ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Imprimir total do relatorio										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? ImpFil130()																  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?																				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso 	    ? Generico																	  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0043)+" "+Iif(mv_par21==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")  //"T O T A L   F I L I A L ----> "
If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	@li,102 PSAY nTotFil0        Picture TM(nTotFil0,14,nDecs)
Endif
@li,116 PSAY nTotFil1        Picture TM(nTotFil1,15,nDecs)
@li,132 PSAY nTotFil2        Picture TM(nTotFil2,15,nDecs)
@li,149 PSAY nTotFil3        Picture TM(nTotFil3,15,nDecs)
@li,182 PSAY nTotFilJ		  Picture TM(nTotFilJ,15,nDecs)
@li,200 PSAY nTotFil2+nTotFil3 Picture TM(nTotFil2+nTotFil3,15,nDecs)
li+=2
Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 砯r130Indr ? Autor ? Wagner           	  ? Data ? 12.12.94 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矼onta Indregua para impressao do relatio						  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function fr130IndR()
Local cString

cString := 'SE1->E1_FILIAL=="'+xFilial("SE1")+'".And.'
cString += 'SE1->E1_CLIENTE>="'+mv_par01+'".and.SE1->E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'SE1->E1_PREFIXO>="'+mv_par03+'".and.SE1->E1_PREFIXO<="'+mv_par04+'".And.'
cString += 'SE1->E1_NUM>="'+mv_par05+'".and.SE1->E1_NUM<="'+mv_par06+'".And.'
cString += 'DTOS('+Iif(mv_par40 = 2, 'SE1->E1_VENCTO', 'SE1->E1_VENCREA')+')>="'+DTOS(mv_par09)+'".And.'
cString += 'DTOS('+Iif(mv_par40 = 2, 'SE1->E1_VENCTO', 'SE1->E1_VENCREA')+')<="'+DTOS(mv_par10)+'".And.'
cString += '(SE1->E1_MULTNAT == "1" .OR. (SE1->E1_NATUREZ>="'+mv_par11+'".and.SE1->E1_NATUREZ<="'+mv_par12+'")).And.'
cString += 'DTOS(SE1->E1_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(SE1->E1_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
	cString += '.And.SE1->E1_TIPO$"'+mv_par31+'"'
ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32 
	cString += '.And. !(Alltrim(SE1->E1_TIPO) $ "'+ ALLTRIM(MV_PAR32)+'")'
EndIf
IF mv_par34 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(SE1->E1_FLUXO!="N")'	
Endif
Return cString

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ? PutDtBase? Autor ? Mauricio Pequim Jr    ? Data ? 18/07/02 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Acerta parametro database do relatorio                     潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ? Finr130.prx                                                潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("FIN130    36")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  砈itucob   篈utor  矼auricio Pequim Jr. ? Data ?13.04.2005   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     砇etorna situacao de cobranca do titulo                      罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? FINR130                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function SituCob(cCarAnt)

Local aSituaca := {}
Local aArea		:= GetArea()
Local cCart		:= " "

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Monta a tabela de situa嚁es de Tulos										 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea("SX5")
dbSeek(cFilial+"07")
While SX5->X5_FILIAL+SX5->X5_tabela == cFilial+"07"
	cCapital := Capital(X5Descri())
	AADD( aSituaca,{SubStr(SX5->X5_CHAVE,1,2),OemToAnsi(SubStr(cCapital,1,20))})
	dbSkip()
EndDo

nOpcS := (Ascan(aSituaca,{|x| Alltrim(x[1])== Substr(cCarAnt,4,1) }))
If nOpcS > 0
	cCart := aSituaca[nOpcS,1]+aSituaca[nOpcs,2]		
ElseIf Empty(SE1->E1_SITUACA)
	cCart := "0 "+STR0029
Endif
RestArea(aArea)
Return cCart

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪目北
北矲un噮o    ? SumPCC130? Autor ? Igor Franzoi			 ? Data?19/12/2011 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪拇北
北矰escri噮o ? Soma os abatimentos do PCC em caso de saldo retroativo	   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       ? Finr130.prx                                                 潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
Static Function SumPCC130(cPrefixo,cNumero,cParcela,dDataRef,cCodCli,cLoja,nMoeda)

Local cAlias	:= Alias()
Local nOrdem	:= indexord()

Local nTotPcc	:= 0

Default nMoeda	:= 1

cQryAlias := GetNextAlias()

cCondSE1 := "% E1_FILIAL = '"+xFilial("SE1")+"' AND "
cCondSE1 += " E1_PREFIXO = '"+cPrefixo+"' AND "
cCondSE1 += " E1_NUM = '"+cNumero+"' AND "
cCondSE1 += " E1_CLIENTE = '"+cCodCli+"' AND "
cCondSE1 += " E1_LOJA = '"+cLoja+"' AND "
cCondSE1 += " E1_TIPO IN ('PIS','COF','CSL') AND "
cCondSE1 += " E1_EMISSAO <= '"+Dtos(dDataRef)+"' %"

BeginSql alias cQryAlias
	SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_TXMOEDA, E1_MOEDA, R_E_C_N_O_ RECNO
	FROM %table:SE1% SE1
	WHERE 
	%exp:cCondSE1% AND SE1.%NotDel%
EndSql

While (cQryAlias)->( !Eof() )
	nTotPcc += xMoeda((cQryAlias)->E1_VALOR,(cQryAlias)->E1_MOEDA,nMoeda,dDataRef,,If(cPaisLoc=="BRA",(cQryAlias)->E1_TXMOEDA,0))
	(cQryAlias)->(dbSkip())		
EndDo

(cQryAlias)->(dbCloseArea())

DbSelectArea(cAlias)
DbSetOrder(nOrdem)

Return(nTotPcc)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矨justaSX1 篈utor  砇aphael Zampieri    ? Data ?11.06.2008   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矨justa perguntas da tabela SX1                              罕?
北?          ?                                                            罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? FINR130                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function AjustaSX1()

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local aRegs		:= {}  
Local nTamTitSX3:= 0       
Local cGrupoSX3	:= ""


dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("E1_NUM")     
nTamTitSX3	:= SX3->X3_TAMANHO
cGrupoSX3	:= SX3->X3_GRPSXG  
dbSetOrder(1)

//            cPerg	Ordem	PergPort         cPerSpa        cPerEng           cVar  Tipo     nTam	 1 2 3    4   cVar01  cDef01  cDefSpa1    cDefEng1    cCont01	        cVar02	   cDef02           cDefSpa2         cDefEng2   cCnt02 cVar03 cDef03   cDefSpa3  cDefEng3  	cCnt03	cVar04	cDef04  cDefSpa4  cDefEng4  cCnt04 	cVar05 	 cDef05	 cDefSpa5  cDefEng5	 cCnt05	 cF3	cGrpSxg  cPyme	 aHelpPor aHelpEng	aHelpSpa  cHelp
AAdd(aRegs,{"FIN130", "05","Do Titulo  ?","緿e Titulo  ?","From Bill  ?",  "mv_ch5","C",nTamTitSX3,0,0,"G","","mv_tit_de","",      "",         "",         "",               "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})
AAdd(aRegs,{"FIN130", "06","Ate o Titulo  ?","緼 Titulo  ?","To Bill  ?",  "mv_ch6","C",nTamTitSX3,0,0,"G","","mv_tit_ate","",      "",         "",    "ZZZZZZZZZZZZZZZZZZZZ",          "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})

ValidPerg(aRegs,"FIN130",.T.)

RestArea( aArea )
 
//Inclusao da pergunta: "Considera data - Vencimento ou Vencimento Real"
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a data de vencimento que ser? "  )
Aadd( aHelpPor, "considerada na impressao do relat髍io "  )

Aadd( aHelpSpa, "Informe la fecha de vencimiento que se "   )
Aadd( aHelpSpa, "considerar? en la impresi髇 del informe. " )

Aadd( aHelpEng, "Enter expiration date to be considered "  )
Aadd( aHelpEng, "to print the report."                     )


PutSx1( "FIN130", "40","Considera data","Considera fecha","Consider date","mv_chv","N",1,0,1,"C","","","","",;
	"mv_par40","Vencimento Real","Venc. Real","Real Expiration","","Vencimento","Vencimiento","Expiration","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//Ajuste da pergunta: "Considera Adiantam. ? - MV_PAR26"
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Selecione a op玢o 揝im? para que os " )
Aadd( aHelpPor, "t韙ulos referentes a adiantamentos, " )
Aadd( aHelpPor, "cadastrados sob os tipos 揜A e NCC? " )
Aadd( aHelpPor, "devam ser considerados na gera玢o do" )
Aadd( aHelpPor, " relat髍io, ou 揘鉶?, caso contr醨io.")

Aadd( aHelpSpa, "Elija la opcion 揝i? para que los ")
Aadd( aHelpSpa, "titulos referentes a anticipos, ")
Aadd( aHelpSpa, "registrados bajo los tipos 揜A e NCC?")
Aadd( aHelpSpa, ", sean considerados en la generacion ")
Aadd( aHelpSpa, "del informe, o en caso contrario, ")
Aadd( aHelpSpa, "elija 揘o?.")                                  

Aadd( aHelpEng, "Select the option 揧es? so that the ")     
Aadd( aHelpEng, "bills related to the advances ")
Aadd( aHelpEng, "registered under the types 揜A and ")
Aadd( aHelpEng, "NCC? can be considered in the report")
Aadd( aHelpEng, " generation, or 揘o?, otherwise.")

PutHelp("P.FIN13026.",aHelpPor,aHelpEng,aHelpSpa,.T.)               

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Selecione a op玢o '揝im'? para que    " )
Aadd( aHelpPor, "sejam pesquisados movimentos em todas")
Aadd( aHelpPor, "filiais para procurar compensacoes  " )
Aadd( aHelpPor, "entre filiais. Caso nao tenha estes " )
Aadd( aHelpPor, "movimentos, seleciona 'N鉶'.        " )
Aadd( aHelpPor, "*Somente ambiente com SE5 exclusiva." )

Aadd( aHelpSpa, "Seleccione la opcion 'Si' para que  " )
Aadd( aHelpSpa, "se busquen los movimientos en todas " )
Aadd( aHelpSpa, "las sucursales para encontrar 		 " )
Aadd( aHelpSpa, "compensaciones entre sucursales.    " )
Aadd( aHelpSpa, "En caso de que existan estos        " )
Aadd( aHelpSpa, "movimientos, seleccione 'No'. Solo  ")
Aadd( aHelpSpa, "entorno con SE5 exclusiva." )

Aadd( aHelpEng, "Select option Yes so the transactions" )
Aadd( aHelpEng, "among branches as well as            " )
Aadd( aHelpEng, "compensations among branches are     " )
Aadd( aHelpEng, "searched. If there are no transactions" )
Aadd( aHelpEng, "select No. Only exclusive SES        " )
Aadd( aHelpEng, "environment.                         " )

PutSx1( "FIN130", "41","Compensa玢o entre Filiais?","?Compensaciones sucursales?","Compensations branches?","mv_chx","N",1,0,2,"C","","","","",;
	"mv_par41","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
/*
GESTAO - inicio */
If SX1->(DbSeek(PadR("FIN130",Len(SX1->X1_GRUPO))+"21"))
	aHelpPor := {'Selecione a op玢o "Sim" para que a','gera玢o do relat髍io considere as','filiais a serem informadas nos','par鈓etros seguintes, ou "N鉶",','caso contr醨io. Esta pergunta n鉶 ter?','efeito em ambientes TOPCONNECT /','TOTVSDBACCESS.'}
	aHelpSpa := {'Elija la opcion "Si" para que la','generacion del informe considere las','sucursales que se deben informar en los','siguientes parametros, o en caso','contrario, elija "No". Esta pregunta no','tendra efecto en el entorno TOPCONNECT/','TOTVSDBACCES.'}
	aHelpEng := {'Select the option "Yes" so that the','report generation can consider the','branches to be entered in the following','parameters. This question does not work','in TOPCONNECT/TOTVSDBACCESS environments'}
	PutSX1Help("P.FIN13021.",aHelpPor,aHelpEng,aHelpSpa,.T.)
Endif
If SX1->(DbSeek(PadR("FIN130",Len(SX1->X1_GRUPO))+"22"))
	aHelpPor := {'Informe o c骴igo inicial do intervalo de',' filiais da sua empresa a serem',' consideradas na gera玢o do relat髍io,',' quando o par鈓etro anterior "Considera',' Filiais Abaixo?" estiver "Sim". Esta',' pergunta n鉶 ter? efeito em ambientes',' TOPCONNECT / TOTVSDBACCESS.'}
	aHelpSpa := {'Digite el codigo inicial del intervalo','de sucursales de su empresa que se debe','considerar en la generacion del informe,','cuando el parametro anterior "緾onsidera',' Siguientes Sucursales?" este "Si". Esta',' pregunta no tendra efecto en el',' entorno TOPCONNECT/TOTVSDBACCES.'} 
	aHelpEng := {'Enter the initial code of your company磗',' branches interval to be considered in',' the report generation when the previous',' parameters ("Consider branches below?")','is marked with "Yes". This question does',' not work','in TOPCONNECT/TOTVSDBACCESS',' environments'}
	PutSX1Help("P.FIN13022.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
Endif
If SX1->(DbSeek(PadR("FIN130",Len(SX1->X1_GRUPO))+"23"))
	aHelpPor := {'Informe o c骴igo final do intervalo de','filiais da sua empresa a serem','consideradas na gera玢o do relat髍io,','quando o par鈓etro anterior "Considera','Filiais Abaixo?" estiver "Sim". Esta','pergunta n鉶 ter? efeito em ambientes','TOPCONNECT / TOTVSDBACCESS.'} 
	aHelpSpa := {'Digite el codigo final del intervalo de','sucursales de su empresa que se debe','considerar en la generacion del informe,','cuando el parametro anterior "緾onsidera','Siguientes Sucursales?" este "Si". Esta','pregunta no tendra efecto en el entorno','TOPCONNECT/TOTVSDBACCES.'}
	aHelpEng := {'Enter the final code of your company磗','branches interval to be considered in','the report generation when the previous','parameters ("Consider branches below?")','is marked with "Yes". This question does','not work in TOPCONNECT/TOTVSDBACCESS.','environments.'}
	PutSX1Help("P.FIN13023.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
Endif
If !(SX1->(DBSeek(PadR("FIN130",Len(SX1->X1_GRUPO))+"42")))
	aHelpPor := {"Escolha Sim se deseja selecionar ","as filiais. ","Esta pergunta somente ter? efeito em","ambiente TOTVSDBACCESS (TOPCONNECT) / ","TReport."}			
	aHelpEng := {"Enter Yes if you want to select ","the branches.","This question affects TOTVSDBACCESS","(TOPCONNECT) / TReport environment only."}
	aHelpSpa := {"La opci髇 S?, permite seleccionar ","las sucursales.","Esta pregunta solo tendra efecto en el ","entorno TOTVSDBACCESS (TOPCONNECT) / ","TReport."}
	PutSx1( "FIN130", "42", "Seleciona Filiais?" ,"縎elecciona sucursales?" ,"Select Branches?","mv_chW","N",1,0,2,"C","","","","S","mv_par42","Sim","Si ","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	PutSX1Help("P.FIN13042.",aHelpPor,aHelpEng,aHelpSpa,.T.)
Endif
/* GESTAO - fim 
*/
Return

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯槐?
北篜rograma  ? FR130RetNat 篈utor ? Gustavo Henrique  ? Data ? 25/05/10   罕?
北掏屯屯屯屯拓屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯贡?
北篋escricao ? Retorna codigo e descricao da natureza para quebra do      罕?
北?          ? relatorio analitico por ordem de natureza.                 罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篜arametros? EXPC1 - Codigo da natureza para pesquisa                   罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Financeiro                                                 罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function FR130RetNat( cCodNat )

SED->( dbSetOrder( 1 ) )
SED->( MsSeek( xFilial("SED") + cCodNat ) )

Return( SED->ED_CODIGO + " - " + SED->ED_DESCRIC + If( mv_par21==1, cFilAnt + " - " + Alltrim(SM0->M0_FILIAL), "" ) )

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯槐?
北篜rograma  ? FR130TotSoma 篈utor ? Gustavo Henrique ? Data ? 05/26/10   罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯贡?
北篋escricao ? Totaliza somatoria da coluna (Vencidos+A Vencer) quando    罕?
北?          ? selecionado relatorio por ordem de natureza e parametro    罕?
北?          ? MV_MULNATR ativado.                                        罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Financeiro                                                 罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function FR130TotSoma( oTotCorr, oTotVenc, nTotVenc, nTotGeral )

nTotVenc	:= oTotCorr:GetValue() + oTotVenc:GetValue()
nTotGeral	+= nTotVenc

Return .T.


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篟otina    矲r135Cond 篈utor  矯laudio D. de Souza ? Data ?  28/08/01   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ? Avalia condicoes para filtrar os registros que serao       罕?
北?          ? impressos.                                                 罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? FINR135                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function Fr130Cond(cTipos)
Local lRet := .T.

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Filtrar com base no Pto de entrada do Usuario...             ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪Jose Lucas, Localiza嚁es Argentina馁
Do Case 
	Case !Empty(SE1->E1_BAIXA) .and. Iif(mv_par20 == 2 ,SE1->E1_SALDO == 0 ,;
	  (SE1->E1_SALDO == 0 .and. SE1->E1_BAIXA <= dDataBase .And. MV_PAR37==1))

		lRet := .F.
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//? Verifica se trata-se de abatimento ou somente titulos?
	//? at? a data base. 									         ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁	
	Case (MV_PAR33 != 1 .AND. SE1->E1_TIPO $ MVABATIM)
		lRet := .F.
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//? Verifica se ser? impresso titulos provisios		   ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	Case mv_par16 == 2 .And. SE1->E1_TIPO $ MVPROVIS
		lRet := .F.
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//? Verifica se ser? impresso titulos de Adiantamento	   ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	Case mv_par26 == 2 .And. SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG
		lRet := .F.

	Case !Empty(cTipos)
		If !(SE1->E1_TIPO $ cTipos)
		   lRet := .F.
		Endif

	Case mv_par30 == 2 // nao imprime
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Verifica se deve imprimir outras moedas?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If SE1->E1_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
			lRet := .F.
		Endif
EndCase
	
Return lRet
    
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲TITPAI   篈utor Leandro Sousa         ? Data ?  12/23/11   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ? Caso algum titulo de abatimento tenho o campo E1_TITPAI em 罕?
北?          ? branco a fun鏰o ira preencher para o relatorio ficar correto北
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? FINR130                                                   罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function FTITPAI()
Local aAreaSE1 := SE1->(GetArea())
Local cChave := xFilial("SE1")+__SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
Local cTitP 

DbSelectArea("__SE1")
dbSetOrder(2)
If DbSeek(cChave)
	While SE1->(!Eof()) .and. cChave == xFilial("SE1")+__SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
		If ! __SE1->E1_TIPO $ MVABATIM
			CTitP := PADR(__SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA),TAMSX3('E1_TITPAI')[1])
			Exit
		EndIf	
	DbSkip()
	EndDo
EndIF

RestArea(aAreaSE1)            

Return cTitP


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲INR130   篈utor  矼icrosiga           ? Data ?  05/11/12   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ? Rotina que ira definir qual desconto sera levado em considera?
北?          ? 鏰o o registro da SE5 ou o campo da tabela SE1             罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? AP                                                        罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/

STATIC Function F130DESC()
Local lRet := .T.
Local aArea := GetArea()
Local cChave := SE1->(E1_PREFIXO + E1_NUM +E1_PARCELA +E1_TIPO +E1_CLIENTE +E1_LOJA )

dbSelectArea("SE5")
dbSetOrder(7) // filial + prefixo + numero + parcela + tipo + clifor + loja + sequencia
If DbSeek(xFilial("SE5")+cChave)
	While SE5->(!EOF()) .and. cChave == SE5->(E5_PREFIXO + E5_NUMERO +E5_PARCELA +E5_TIPO +E5_CLIENTE +E5_LOJA )
		If SE5->E5_TIPODOC == "DC" .and. (SE1->E1_DESCONT == SE5->E5_VALOR) .and. SE1->E1_DECRESC == 0
			lRet := .F.
		Endif
		SE5->(dbSkip())
	EndDo
Endif

RestArea(aArea)

Return lRet

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲040RETIMP篈utor  ? Totvs              ? Data ?  30/07/12   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ? Efetua a validacao na exclusao do titulo                   罕?
北?          ?                                                            罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? AP                                                         罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function F130RETIMP(cFiltro,cFilSED)

Local aTitulos := {}
Local lPercIrf := .F.
Local lPercins := .F.
Local lPerccsl := .F.
Local lPerccof := .F.
Local lPercpis := .F.
Local lPerciss := .F.
Local cAlias   := Alias()

dbSelectArea("SED")
dbSetOrder(1)
If DbSeek(cFilSED+cFiltro)
	If SED->ED_CALCIRF=="S"	  	
     	AADD(aTitulos,{MVIRABT, .T.})
 	EndIf
   	If SED->ED_CALCINS=="S"
       	AADD(aTitulos,{MVINABT,.T.})
   	EndIf
 	If SED->ED_CALCPIS=="S"	 
    	 AADD(aTitulos,{MVPIABT,.T.})
 	EndIf
   	If SED->ED_CALCCOF=="S"	  	  	
     	AADD(aTitulos,{MVCFABT,.T.})
 	EndIf
   	If SED->ED_CALCCSL=="S"
     	AADD(aTitulos,{MVCSABT,.T.})
   	EndIf
 	If SED->ED_CALCISS=="S"	
     	AADD(aTitulos,{MVISABT,.T.})
	EndIf
EndIf

dbSelectArea( cAlias )

Return aTitulos

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲130TipoBA篈utor  矼icrosiga           ? Data ?  13/08/12   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ? Rotina para buscar na SE5 quando titulo eh tipo RA para    罕?
北?          ? verificar a data de cancelamento que sera gravado no       罕?
北?          ? campo E5_HIST entre ###[AAAAMMDD]### a fim de compor o     罕?
北?          ? saldo adequadamente                                        罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? AP                                                         罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
STATIC Function F130TipoBA( cFilSE5 )

Local nPosDtCanc 	:= 0
Local nValor 		:= 0
Local aArea  		:= GetArea()
Local cAliasSE5		:= GetNextAlias()                    
                 
cWhere := " AND SE5.E5_PREFIXO = '" + SE1->E1_PREFIXO + "' "
cWhere += " AND SE5.E5_NUMERO  = '" + SE1->E1_NUM + "' "
cWhere += " AND SE5.E5_PARCELA = '" + SE1->E1_PARCELA + "' "
cWhere += " AND SE5.E5_TIPO    = '" + SE1->E1_TIPO + "' "
cWhere += " AND SE5.E5_CLIENTE = '" + SE1->E1_CLIENTE + "' "
cWhere += " AND SE5.E5_LOJA    = '" + SE1->E1_LOJA + "' "
cWhere += " AND SE5.E5_TIPODOC = 'BA' "
cWhere += " AND SE5.E5_SITUACA = 'C' "

cWhere := "%" + cWhere + "%"		
	
BeginSql Alias cAliasSE5
	SELECT SE5.E5_FILIAL, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, SE5.E5_TIPO, SE5.E5_CLIENTE, SE5.E5_LOJA, SE5.E5_HISTOR, SE5.E5_DATA, SE5.E5_VALOR
	FROM %table:SE5% SE5, %table:SE1% SE1
	WHERE SE5.E5_FILIAL	= %xFilial:SE5%    
			%Exp:cWhere%
			AND SE5.%NotDel%
			AND SE1.E1_FILIAL = %xFilial:SE1%
			AND SE1.%NotDel%					 
EndSql                   

Do While (cAliasSE5)->( ! EoF() )

	If ( nPosDtCanc := At("###[", (cAliasSE5)->E5_HISTOR) ) > 0
		If  (cAliasSE5)->E5_DATA <= MV_PAR36 .And. StoD( SubStr( (cAliasSE5)->E5_HISTOR, nPosDtCanc + 4, 8 ) ) > MV_PAR36
			nValor := (cAliasSE5)->E5_VALOR
			Exit
		EndIf
	EndIf

	(cAliasSE5)->( dbSkip() )
	                              
EndDo

(cAliasSE5)->( dbCloseArea() )

RestArea(aArea)

Return nValor





/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲INR130   篈utor  砇amon Teodoro       ? Data ?  17/08/12   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ? Fun玢o para identificar a abatimento de t韙ulos do tipo BOL罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? AP                                                        罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
                          
Static Function PesqAbat(aParam)
Local cQuery := ""   
Local aAbatBaixa := {}
Local aAreaSE1	:= GetArea()

#IFDEF TOP
	cQuery := " SELECT * "
	cQuery += "FROM " + RetSQLName( "SE1" ) 
	cQuery += " WHERE "
	cQuery += "E1_FILIAL = '" + aParam[1] + "' AND "
	cQuery += "E1_NOMCLI = '" + aParam[2] + "' AND "
	cQuery += "E1_CLIENTE = '" + aParam[3] + "' AND "
	cQuery += "E1_LOJA = '" + aParam[4] + "' AND "
	cQuery += "E1_PREFIXO = '" + aParam[5] + "' AND "
	cQuery += "E1_NUM = '" + aParam[6] + "' AND "
	cQuery += "E1_PARCELA = '" + aParam[7] + "' AND "
	cQuery += "D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSE1" )

  	dbSelectArea("TRBSE1")
   
	While ! Eof()

		If (E1_TIPO $ MVABATIM .and. ;
			((E1_BAIXA <= DtoS(dDataBase) .and. !Empty(E1_BAIXA)) .or. ;
			 (E1_MOVIMEN <= DtoS(dDataBase) .and. !Empty(E1_MOVIMEN))	) .and.;
			  E1_SALDO == 0)            
			IF !Empty(E1_TITPAI)
				aAdd( aAbatBaixa , { E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA , E1_TITPAI } )
			Else
				cMTitPai := FTITPAI()
				aAdd( aAbatBaixa , { E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA , cMTitPai } )
			EndIf
		EndIf
		TRBSE1->(DbSKip())
	End
       
	TRBSE1->( dbCloseArea() )
#ENDIF    
  
RestArea( aAreaSE1 )
Return aAbatBaixa