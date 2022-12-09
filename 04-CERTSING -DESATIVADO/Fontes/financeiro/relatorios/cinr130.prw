#INCLUDE "FINR130.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE QUEBR				1
#DEFINE CLIENT				2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO			6
#DEFINE VENCTO				7
#DEFINE VENCREA			8
#DEFINE BANC				9
#DEFINE VL_ORIG			10
#DEFINE VL_NOMINAL			11
#DEFINE VL_CORRIG			12
#DEFINE VL_VENCIDO			13
#DEFINE NUMBC				14
#DEFINE VL_JUROS			15
#DEFINE ATRASO				16
#DEFINE HISTORICO			17
#DEFINE VL_SOMA			18

Static lFWCodFil := FindFunction("FWCodFil")

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � FINR130  � Autor � Daniel Tadashi Batori � Data � 01.08.06 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Posi噭o dos Titulos a Receber					          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � FINR130(void)                                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
User Function CINR130()

Local oReport

AjustaSX1()

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return FINR130R3() // Executa vers鉶 anterior do fonte
Endif

Return

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � ReportDef� Autor � Daniel Batori         � Data � 01.08.06 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Definicao do layout do Relatorio									  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � ReportDef(void)                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function ReportDef()
Local oReport  
Local oSection1
Local oSection2
Local cPictTit
Local nTamVal, nTamCli, nTamQueb, nTamJur, nTamNBco

Private cLoja    := ''
Private cNomeCli := ''
Private cPrefixo := ''
Private cNumTit  := ''
Private cParcela := ''
Private cVendedor := ''
Private cCodHist  := ''

oReport := TReport():New("FINR130",STR0005,"FIN130",;
{|oReport| ReportPrint(oReport)},STR0001+STR0002)

oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.) // Imprime o total em linhas

//Nao retire esta chamada. Verifique antes !!!
//Ela � necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

pergunte("FIN130",.F.)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Variaveis utilizadas para parametros	  								�
//� mv_par01		 // Do Cliente 	 										�
//� mv_par02		 // Ate o Cliente										�
//� mv_par03		 // Do Prefixo											�
//� mv_par04		 // Ate o prefixo 										�
//� mv_par05		 // Do Titulo											�
//� mv_par06		 // Ate o Titulo										�
//� mv_par07		 // Do Banco											�
//� mv_par08		 // Ate o Banco											�
//� mv_par09		 // Do Vencimento 										�
//� mv_par10		 // Ate o Vencimento									�
//� mv_par11		 // Da Natureza											�
//� mv_par12		 // Ate a Natureza										�
//� mv_par13		 // Da Emissao											�
//� mv_par14		 // Ate a Emissao										�
//� mv_par15		 // Qual Moeda											�
//� mv_par16		 // Imprime provisorios									�
//� mv_par17		 // Reajuste pelo vecto									�
//� mv_par18		 // Impr Tit em Descont									�
//� mv_par19		 // Relatorio Anal/Sint									�
//� mv_par20		 // Consid Data Base?  									�
//� mv_par21		 // Consid Filiais  ?  									�
//� mv_par22		 // da filial											�
//� mv_par23		 // a flial 											�
//� mv_par24		 // Da loja  											�
//� mv_par25		 // Ate a loja											�
//� mv_par26		 // Consid Adiantam.?									�
//� mv_par27		 // Da data contab. ?									�
//� mv_par28		 // Ate data contab.?									�
//� mv_par29		 // Imprime Nome    ?									�
//� mv_par30		 // Outras Moedas   ?									�
//� mv_par31       // Imprimir os Tipos										�
//� mv_par32       // Nao Imprimir Tipos									�
//� mv_par33       // Abatimentos  - Lista/Nao Lista/Despreza				�
//� mv_par34       // Consid. Fluxo Caixa									�
//� mv_par35       // Salta pagina Cliente									�
//� mv_par36       // Data Base												�
//� mv_par37       // Compoe Saldo por: Data da Baixa, Credito ou DtDigit	�
//� mv_par38       // Tit. Emissao Futura								  	�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�

cPictTit := PesqPict("SE1","E1_VALOR")
nTamVal	 := TamSx3("E1_VALOR")[1]
nTamCli	 := TamSX3("E1_CLIENTE")[1]
nTamLoja	 := TamSX3("E1_LOJA")[1]
nTamNome	 := 20
nTamPre   := TamSX3("E1_PREFIXO")[1]
nTamTit	 := TamSX3("E1_NUM")[1]
nParcela  := TamSX3("E1_PARCELA")[1] + 12 

nTamBan	 := TamSX3("E1_PORTADO")[1] + TamSX3("E1_SITUACA")[1] + 1
nTamDte	 := TamSx3("E1_EMISSAO")[1]+1
nTamQueb := nTamCli + nTamTit + nTamBan + TamSX3("E1_TIPO")[1] + TamSX3("E1_NATUREZ")[1] + TamSX3("E1_EMISSAO")[1] +;
		  	TamSX3("E1_VENCTO")[1] + TamSX3("E1_VENCREA")[1] + nTamBan + 2
nTamJur  := TamSX3("E1_JUROS")[1]

nTamNBco := TamSX3("E1_NUMBCO")[1] 

//Secao 1 --> Analitico
oSection1 := TRSection():New(oReport,STR0079,{"SE1","SA1"},;
				{STR0008,STR0009,STR0010,STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,STR0047})
//Secao 2 --> Sintetico
oSection2 := TRSection():New(oReport,STR0081,{"SE1"})
TRCell():New(oSection1,"CLIENTE",,'C骴igo',,nTamCli,.F.,,,,,,,.F.)  //"Codigo-Lj-Nome do Cliente"
TRCell():New(oSection1,"Loja","SE1",,,nTamLoja,.F.,) 
TRCell():New(oSection1,"Nome Cliente","SE1",,,nTamNome,.F.,)

TRCell():New(oSection1,"Prefixo","SE1",,,nTamPre,.F.,)
TRCell():New(oSection1,"Titulo","SE1",,,nTamTit,.F.,)
TRCell():New(oSection1,"Parcela","SE1",,,nParcela,.F.,)

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
//TRCell():New(oSection1,"JUROS",,STR0073+CRLF+STR0074,cPictTit,nTamJur,.F.,,,,,,,.T.)  //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"JUROS",,"Vendedor",cPictTit,nTamJur,.F.,,,,,,,.T.)  //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"DIA_ATR",,STR0075+CRLF+STR0076,,5,.F.,,,,,,,.T.)  //"Dias" + "Atraso"
TRCell():New(oSection1,"Historico","SE1",,,20,.F.,)
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北砅rograma  砇eportPrint� Autor 矰aniel Batori          � Data �10.07.06  潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噮o 矨 funcao estatica ReportDef devera ser criada para todos os  潮�
北�          硆elatorios que poderao ser agendados pelo usuario.           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃enhum                                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpO1: Objeto Report do Relat髍io                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北�   DATA   � Programador   矼anutencao efetuada                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北�          �               �                                             潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function ReportPrint(oReport)
Local oSection1  	:= oReport:Section(1)
Local oSection2  	:= oReport:Section(2)
Local nOrdem 		:= oSection1:GetOrder()
Local oBreak
Local oBreak2
Local oTotVenc
Local oTotCorr
//Local aTotal

Local aDados[22]
//Local aAux[18]
Local nRegEmp 		:= SM0->(RecNo())
Local nRegSM0 		:= SM0->(Recno())
Local nAtuSM0 		:= SM0->(Recno())
Local dOldDtBase 	:= dDataBase
Local dOldData		:= dDatabase

Local CbCont
Local lContinua 	:= .T.
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
Local dDtContab
Local cTipos  		:= ""
Local nTotsRec 		:= SE1->(RecCount())
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
Local nPula 		:= 1
Local lFR130Tel   := ExistBlock("FR130TELC")
Local cCampoCli   := ""

Private cTitulo 	:= ""
Private dBaixa 		:= dDataBase
Private Li			:= 0

oSection1:Cell("CLIENTE"   ):SetBlock( { || aDados[CLIENT]    })
oSection1:Cell("LOJA"      ):SetBlock( { || cLoja })
oSection1:Cell("NOME CLIENTE"):SetBlock( { || cNomeCli      })
oSection1:Cell("Prefixo"):SetBlock( { || cPrefixo      })
oSection1:Cell("Titulo"):SetBlock( { || cNumTit     })
oSection1:Cell("Parcela"    ):SetBlock( { || cParcela     })
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
oSection1:Cell("JUROS"     ):SetBlock( { || cVendedor  })
oSection1:Cell("DIA_ATR"   ):SetBlock( { || aDados[ATRASO]    })
oSection1:Cell("Historico"   ):SetBlock( { || cCodHist })
oSection1:Cell("VAL_SOMA"  ):SetBlock( { || aDados[VL_SOMA]   })

oSection1:Cell("VAL_SOMA"):Enable()
 
//Cabecalho do Relatorio sintetico
If mv_par19 == 2 //1 = Analitico - 2 = Sintetico
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
    If mv_par19 == 1 //1 = Analitico   2 = Sintetico
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
//� Imprimir TOTAL por filial somente quando �
//� houver mais do que uma filial.	         �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lTotFil
	oBreak2 := TRBreak():New(oSection1,{|| SE1->E1_FILIAL },{|| STR0043+" "+ cNomFil })	//"T O T A L   F I L I A L ----> " 
	// "Salta pagina por cliente?" igual a "Sim" e a ordem eh por cliente ou codigo do cliente
	If mv_par35 == 1 .And. (nOrdem == 1 .Or. nOrdem == 8)
		oBreak2:OnPrintTotal( { || oReport:EndPage() } )	// Finaliza pagina atual
	EndIf
	If mv_par19 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBreak2,,PesqPict("SE1","E1_VALOR"),{|lSection,lReport| If(lReport, nTotGeral, nTotFil)},.F.,.F.)
	EndIf
EndIf

If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
	//Altera o texto do Total Geral
	oReport:SetTotalText({|| STR0038 + "(" + AllTrim(Str(nTotTit))+" "+If(nTotTit > 1, STR0039, STR0040)+")"})
	TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
	oTotCorr := TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
	oTotVenc := TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("JUROS"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBreak,,PesqPict("SE1","E1_VALOR"),{|lSection, lReport| If (lReport, nTotGeral, nTotVenc)},.F.,.T.)
Endif

//Nao retire esta chamada. Verifique antes !!!
//Ela � necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� POR MAIS ESTRANHO QUE PARE�A, ESTA FUNCAO DEVE SER CHAMADA AQUI! �
//�                                                                  �
//� A fun噭o SomaAbat reabre o SE1 com outro nome pela ChkFile para  �
//� efeito de performance. Se o alias auxiliar para a SumAbat() n刼  �
//� estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   �
//� pois o Filtro do SE1 uptrapassa 255 Caracteres.                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
SomaAbat("","","","R")

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Atribui valores as variaveis ref a filiais                �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
If mv_par21 == 2
	cFilDe  := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
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

While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte



	
	If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
		cTitulo := oReport:Title() + STR0080 + GetMv("MV_MOEDA"+cMoeda)  //"Posicao dos Titulos a Receber"+" - Analitico"
	Else
		cTitulo := oReport:Title() + STR0080 + GetMv("MV_MOEDA"+cMoeda)  //"Posicao dos Titulos a Receber"+" - Sintetico"
	EndIf
		
	dbSelectArea("SE1")
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	Set Softseek On
	
	#IFDEF TOP
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
	
	IF nOrdem = 1
		#IFDEF TOP
			cChaveSe1 := "E1_FILIAL, E1_NOMCLI, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
			cOrder := SqlOrder(cChaveSe1)
		#ELSE
			cChaveSe1 := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			SE1->(dbSetIndex(cIndexSe1+OrdBagExt()))
			SE1->(dbSetOrder(nIndexSe1+1))
			SE1->(dbSeek(xFilial("SE1")))
		#ENDIF
		cCond1	:= "SE1->E1_CLIENTE <= mv_par02"
		cCond2	:= "SE1->E1_CLIENTE + SE1->E1_LOJA"
		cTitulo	+= STR0017  //" - Por Cliente"
	Elseif nOrdem = 2
		SE1->(dbSetOrder(1))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+mv_par03+mv_par05))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_NUM <= mv_par06"
		cCond2	:= "SE1->E1_NUM"
		cTitulo	+= STR0018  //" - Por Numero"
	Elseif nOrdem = 3
		SE1->(dbSetOrder(4))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+mv_par07))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_PORTADO <= mv_par08"
		cCond2	:= "SE1->E1_PORTADO"
		cTitulo	+= STR0019  //" - Por Banco"
	Elseif nOrdem = 4
		SE1->(dbSetOrder(7))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+DTOS(mv_par09)))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+" <= mv_par10"
		cCond2	:= Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")
		cTitulo	+= STR0020  //" - Por Data de Vencimento"
	Elseif nOrdem = 5
		SE1->(dbSetOrder(3))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+mv_par11))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_NATUREZ <= mv_par12"
		cCond2	:= "SE1->E1_NATUREZ"
		cTitulo	+= STR0021  //" - Por Natureza"
	Elseif nOrdem = 6
		SE1->(dbSetOrder(6))
		#IFNDEF TOP
			SE1->(dbSeek( cFilial+DTOS(mv_par13)))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_EMISSAO <= mv_par14"
		cCond2	:= "SE1->E1_EMISSAO"
		cTitulo	+= STR0042  //" - Por Emissao"
	Elseif nOrdem == 7
		cChaveSe1 := "E1_FILIAL+DTOS("+Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+")+E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			SE1->(dbSetIndex(cIndexSe1+OrdBagExt()))
			SE1->(dbSetOrder(nIndexSe1+1))
			SE1->(dbSeek(xFilial("SE1")))
		#ELSE
			cOrder := SqlOrder(cChaveSe1)
		#ENDIF
		cCond1	:= Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+" <= mv_par10"
		cCond2	:= "DtoS("+Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA"
		cTitulo	+= STR0023  //" - Por Vencto/Banco"
	Elseif nOrdem = 8
		SE1->(dbSetOrder(2))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+mv_par01,.T.))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1	:= "SE1->E1_CLIENTE <= mv_par02"
		cCond2	:= "SE1->E1_CLIENTE"
		cTitulo	+= STR0024  //" - Por Cod.Cliente"
	Elseif nOrdem = 9
		cChave := "E1_FILIAL+E1_PORTADO+E1_SITUACA+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,fr130IndR(),OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			SE1->(dbSetIndex(cIndex+OrdBagExt()))
			SE1->(dbSetOrder(nIndex+1))
			SE1->(dbSeek(xFilial("SE1")))
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1	:= "SE1->E1_PORTADO <= mv_par08"
		cCond2	:= "SE1->E1_PORTADO+SE1->E1_SITUACA"
		cTitulo	+= STR0025 //" - Por Banco e Situacao"
	ElseIf nOrdem == 10
		cChave := "E1_FILIAL+E1_NUM+E1_TIPO+E1_PREFIXO+E1_PARCELA"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,,OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			SE1->(dbSetIndex(cIndex+OrdBagExt()))
			SE1->(dbSetOrder(nIndex+1))
			SE1->(dbSeek(xFilial("SE1")+mv_par05))
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1	:= "SE1->E1_NUM <= mv_par06"
		cCond2	:= "SE1->E1_NUM"
		cTitulo	+= STR0048 //" - Numero/Prefixo"	
	Endif
	
	If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
		cTitulo += STR0026 //" - Analitico"
	Else
		cTitulo += STR0027 //" - Sintetico"
	EndIf

	oReport:SetTitle(cTitulo)    
			
	Set Softseek Off
	
	#IFDEF TOP
		cQuery += " AND E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02 + "'"
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
		cQuery += " AND E1_LOJA    between '" + mv_par24        + "' AND '" + mv_par25 + "'"
      
		If MV_PAR38 == 2 //Nao considerar titulos com emissao futura
			cQuery += " AND E1_EMISSAO <=      '" + DTOS(dDataBase) + "'"
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
        //谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
        //� Ponto de entrada para inclusao de parametros no filtro a ser executado �
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
	#ENDIF

	oReport:SetMeter(nTotsRec)

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
			SE1->(dbSetOrder(1))
		#ENDIF

		If Empty(xFilial("SE1"))
			Exit
		Endif

		dbSelectArea("SM0")
		SM0->(dbSkip())
		Loop

	Endif

	While &cCond1 .and. !Eof() .and. lContinua .and. SE1->E1_FILIAL == xFilial("SE1")
	
		oReport:IncMeter()
		
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Carrega data do registro para permitir �
		//� posterior analise de quebra por mes.   �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dDataAnt := Iif(nOrdem == 6 , SE1->E1_EMISSAO,  Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))
		
		cCarAnt := &cCond2
		
		While &cCond2==cCarAnt .and. !Eof() .and. lContinua .and. SE1->E1_FILIAL == xFilial("SE1")
		
			oReport:IncMeter()
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Filtro de usu醨io pela tabela SA1.					 �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SA1")
			SA1->(MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			If !Empty(cFilUserSA1).And.!SA1->(&cFilUserSA1)
				SE1->(dbSkip())
				Loop                
			Endif
			
			dbSelectArea("SE1")
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Filtrar com base no Pto de entrada do Usuario...             �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪Jose Lucas, Localiza嚁es Argentina馁
			If !Empty(cTipos)
				If !(SE1->E1_TIPO $ cTipos)
					SE1->(dbSkip())
					Loop
				Endif
			Endif   			             

			nPula := 2
					
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Modificado tratamento para o par鈓etro MV_PAR36(CONSIDERA DATABASE)�
			//� para quando se imprime um relat髍io com o par鈓etro MV_PAR20(SALDO �
			//� RETROATIVO) = SIM verificando corretamente na SE5 a data de baixa, � 
			//� cr閐ito ou digita玢o para impress鉶. 							   �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE1")
			IF !Empty(SE1->E1_BAIXA) .And. SE1->E1_SALDO == 0
				If(mv_par20 == 1)
					aAreaSE5 := SE5->(GetArea())
					DbSelectArea("SE5")
 					SE5->(DbSetOrder(7))
					If SE5->(DbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))												
						//Dependendo do conteudo do parametro mv_par37 deve-se verificar a data de baixa, credito ou digitacao.
						If (mv_par37 == 1 .And. SE5->E5_DATA <= MV_PAR36)	.OR. (mv_par37 == 2 .And. SE5->E5_DTDISPO  <= MV_PAR36) .OR.;
						   (mv_par37 == 3 .And. SE5->E5_DTDIGIT <= MV_PAR36)	
						  nPula := 2
						 
						EndIf																
					EndIf
					RestArea(aAreaSE5)
					dbSelectArea("SE1")
					If (nPula == 1)
					  SE1->(dbSkip())
					  Loop					
					Endif					
				EndIF
			EndIf
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se trata-se de abatimento ou somente titulos�
			//� at� a data base. 									 �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE1")
			IF (SE1->E1_TIPO $ MVABATIM .And. mv_par33 != 1) .Or.;
				(SE1->E1_EMISSAO > dDataBase .and. MV_PAR38 == 2)
				SE1->(dbSkip())
				Loop
			Endif
			
			 // Tratamento da correcao monetaria para a Argentina
			If  cPaisLoc=="ARG" .And. mv_par15 <> 1  .And.  SE1->E1_CONVERT=='N'
				SE1->(dbSkip())
				Loop
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se ser� impresso titulos provisios		 	�
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF SE1->E1_TIPO $ MVPROVIS .and. mv_par16 == 2
				SE1->(dbSkip())
				Loop
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se ser� impresso titulos de Adiantamento	 �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par26 == 2
				SE1->(dbSkip())
				Loop
			Endif
			
			// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtContab := Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se esta dentro dos parametros �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE1")
			IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
				SE1->E1_PREFIXO < mv_par03 .OR. SE1->E1_PREFIXO > mv_par04 .OR. ;
				SE1->E1_NUM	 	 < mv_par05 .OR. SE1->E1_NUM 		> mv_par06 .OR. ;
				SE1->E1_PORTADO < mv_par07 .OR. SE1->E1_PORTADO > mv_par08 .OR. ;
				Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) < mv_par09 .OR. ;
				Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) > mv_par10 .OR. ;
				SE1->E1_NATUREZ < mv_par11 .OR. SE1->E1_NATUREZ > mv_par12 .OR. ;
				SE1->E1_EMISSAO < mv_par13 .OR. SE1->E1_EMISSAO > mv_par14 .OR. ;
				SE1->E1_LOJA    < mv_par24 .OR. SE1->E1_LOJA    > mv_par25 .OR. ;
				dDtContab       < mv_par27 .OR. dDtContab       > mv_par28 .OR. ;
				(SE1->E1_EMISSAO > dDataBase .and. MV_PAR38 == 2) .Or. !&(fr130IndR())
				SE1->(dbSkip())
				Loop
			Endif
			
			If mv_par18 == 2 .and. SE1->E1_SITUACA $ "27"
				SE1->(dbSkip())
				Loop
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se deve imprimir outras moedas�
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If mv_par30 == 2 // nao imprime
				if SE1->E1_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
					SE1->(dbSkip())
					Loop
				endif
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
				nSaldo := u_CSSldTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par15,dDataReaj,MV_PAR36,SE1->E1_LOJA,,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0),mv_par37)
				//Verifica se existem compensa珲es em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimenta珲es da filial corrente. Nao deve processar quando existe somente uma filial.
				If !Empty(xFilial("SE1")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1
					nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,mv_par37,aFiliais),;
									SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(mv_par39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA) ),0 ) ),;
									nDecs+1),nDecs)
				EndIf
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
					nSAldo -= SE1->E1_DECRESC
				Endif

				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					nSAldo += SE1->E1_ACRESC
				Endif

				//Se abatimento verifico a data da baixa.
				//Por nao possuirem movimento de baixa no SE5, a saldotit retorna 
				//sempre saldo em aberto quando mv_par33 = 1 (Abatimentos = Lista)
				If SE1->E1_TIPO $ MVABATIM .and. ;
					((SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA)) .or. ;
					 (SE1->E1_MOVIMEN <= dDataBase .and. !Empty(SE1->E1_MOVIMEN))	) .and.;
					 SE1->E1_SALDO == 0
					nSaldo := 0                                                        
				Endif

			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			Endif

			// Se titulo do Template GEM
			If HasTemplate("LOT") .And. SE1->(FieldPos("E1_NCONTR")) > 0 .And. !Empty(SE1->E1_NCONTR) 
				nGem := CMDtPrc(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_VENCREA,SE1->E1_VENCREA)[2]
				If SE1->E1_VALOR==SE1->E1_SALDO
					nSaldo += nGem
				EndIf
			EndIf

			//Caso exista desconto financeiro (cadastrado na inclusao do titulo), 
			//subtrai do valor principal.
			nDescont := FaDescFin("SE1",dBaixa,nSaldo,1, .T.)   
			If nDescont > 0
				nSaldo := nSaldo - nDescont
			Endif
			
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
						!( MV_PAR20 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

					//Quando considerar Titulos com emissao futura, eh necessario
					//colocar-se a database para o futuro de forma que a Somaabat()
					//considere os titulos de abatimento
					If mv_par38 == 1
						dOldData := dDataBase
						dDataBase := CTOD("31/12/40")
					Endif

					nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,dDataReaj,SE1->E1_CLIENTE,SE1->E1_LOJA)

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
					    // Subtrai o Abatimento, pois caso contr醨io, sempre ir� listar o titulo como pendente a
					    // receber  
						If (SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA))
							 nSaldo-= nAbatim
						EndIf                                        
					EndIf
				Endif
			Endif	
			nSaldo:=Round(NoRound(nSaldo,3),2)
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Desconsidera caso saldo seja menor ou igual a zero   �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If nSaldo <= 0
				SE1->(dbSkip())
				Loop
			Endif
			
			dbSelectArea("SA1")
			SA1->(MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA))
			dbSelectArea("SA6")
			SA6->(MSSeek(cFilial+SE1->E1_PORTADO))
			dbSelectArea("SE1")
				
			aDados[CLIENT]   := RTrim(SE1->E1_CLIENTE)
			cLoja            := SE1->E1_LOJA
			cNomeCli         := IIF(mv_par29 == 1, SubStr(SA1->A1_NREDUZ,1,15), SubStr(SA1->A1_NOME,1,15))
			cPrefixo         := SE1->E1_PREFIXO
			cNumTit          := SE1->E1_NUM
			cParcela         := SE1->E1_PARCELA
			aDados[TIPO]     := SE1->E1_TIPO
			aDados[NATUREZA] := SE1->E1_NATUREZ
			aDados[EMISSAO]  := SE1->E1_EMISSAO
			aDados[VENCTO]   := SE1->E1_VENCTO
			aDados[VENCREA]  := SE1->E1_VENCREA

			If mv_par20 == 1  //Recompoe Saldo Retroativo              
			    //Titulo foi Baixado e Data da Baixa e menor ou igual a Data Base do Relat髍io
			    IF !Empty(SE1->E1_BAIXA)
			    	If SE1->E1_BAIXA <= mv_par36 .Or. !Empty( SE1->E1_PORTADO )
						aDados[BANC] := SE1->E1_PORTADO//+" "+SE1->E1_SITUACA
					EndIf	
				Else                                                                                   
				    //Titulo n鉶 foi Baixado e foi transferido para Carteira e Data Movimento e menor 
				    //ou igual a Data Base do Relat髍io
					If Empty(SE1->E1_BAIXA) .and. SE1->E1_MOVIMEN <= mv_par36
						aDados[BANC] := SE1->E1_PORTADO//+" "+SE1->E1_SITUACA             
					EndIf
				ENDIF
			Else   // Nao Recompoe Saldo Retroativo
				aDados[BANC] := SE1->E1_PORTADO+" "+SE1->E1_SITUACA 
			EndIf
			
			aDados[VL_ORIG] := Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),nDecs+1),nDecs)
			aDados[VL_NOMINAL] :=0
			aDados[VL_CORRIG]:=0    
			aDados[VL_VENCIDO]:=0
			
			If dDataBase > SE1->E1_VENCREA	//vencidos
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_NOMINAL] := nSaldo * If(SE1->E1_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM, -1,1)  
				EndIf
				nJuros := fa070Juros(mv_par15)
				// Se titulo do Template GEM
				If HasTemplate("LOT") .And. SE1->(FieldPos("E1_NCONTR")) > 0 .And. !Empty(SE1->E1_NCONTR) .And. SE1->E1_VALOR==SE1->E1_SALDO
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
            
			/******************************************************************************
			Coluna de Valor de Juros e dias de atraso confome solicitacao da Ana Cleide.
			If nJuros > 0

				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_JUROS] := nJuros
				EndIf

				nJuros := 0

			Endif
			*******************************************************************************/
			
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
           
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				vCodVend	:=	SE1->E1_VEND1
				//aAreaAtu	:=	GetArea()
				DbSelectArea("SA3")
				SA3->(DbSetOrder(1)) // Filial + Codigo
				SA3->(DbSeek(xfilial("SA3")+alltrim(vCodVend)))
				@ Li,182 PSAY ALLTRIM(SA3->A3_NOME) // Nome do Vendedor
				//_nomvend := ALLTRIM(SA3->A3_NOME)
				cVendedor := Rtrim(SA3->A3_NOME)
				SA3->(DbCloseArea())	
				cCodHist := SubStr(SE1->E1_HIST,1,20)
				
			EndIf
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				aDados[HISTORICO] := SubStr(SE1->E1_HIST,1,18)+IIF(SE1->E1_TIPO $ MVPROVIS,"*"," ")+ ;
				Iif(Str(nSaldo,17,2) == Str(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),17,2)," ","P")
				//exibe a linha no relatorio
				oSection1:PrintLine()
				aFill(aDados,nil)
			EndIf

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Carrega data do registro para permitir �
			//� posterior an爈ise de quebra por mes.   �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dDataAnt := If(nOrdem == 6, SE1->E1_EMISSAO, Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))

			If lFR130Tel
				cCampoCli := ExecBlock("FR130TELC",.F.,.F.)
				If !SA1->(FieldPos(cCampoCli)) > 0
					cCampoCli := ""
				EndIf
			EndIf
			                        
			If nOrdem == 1 //Cliente
				cNomFor := If(mv_par29 == 1, AllTrim(SA1->A1_NREDUZ),AllTrim(SA1->A1_NOME)) +" "+Substr(Iif(!Empty(cCampoCli),SA1->(&cCampocli),SA1->A1_TEL),1,15)
			Elseif nOrdem == 8 //codigo do cliente
				cNomFor := SA1->A1_COD+" "+SA1->A1_LOJA+" "+AllTrim(SA1->A1_NOME)+" "+Substr(Iif(!Empty(cCampoCli),SA1->(&cCampocli),SA1->A1_TEL),1,15)
			Endif
			
			If nOrdem == 5 //Natureza
				dbSelectArea("SED")
				SED->(dbSetOrder(1))
				SED->(dbSeek(xFilial("SED")+SE1->E1_NATUREZ))
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
		//� Verifica quebra por m坰	  			    �
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
		SE1->(dbSetOrder(1))
	#ENDIF

	// Quebra por Cliente. 
	// Evitar salto de pagina antes da impressao do total geral
	If mv_par35 == 1 .And. (nOrdem == 1 .Or. nOrdem == 8)	// Cliente ou Codigo do Cliente
		oBreak:OnPrintTotal( { || } )
	EndIf	
	
	dbSelectArea("SM0")
	SM0->(dbSkip())
Enddo

// Quebra por Filial.
// Evitar salto de pagina antes da impressao do total geral
If mv_par35 == 1 .And. lTotFil .And. (nOrdem == 1 .Or. nOrdem == 8)
	oBreak2:OnPrintTotal( { || } )
EndIf

SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

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
	SE1->(dbSetOrder(1))
#ELSE
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	SE1->(dbSetOrder(1))
#ENDIF

SM0->(dbGoTo(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//Acerta a database de acordo com a database real do sistema
If mv_par20 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪�-穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噭o	 砈ubTot130R � Autor � Daniel Tadashi Batori � Data � 03.08.06 潮�
北媚哪哪哪哪呐哪哪哪哪�-牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噭o 矷mprimir SubTotal do Relatorio										  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � SubTot130R()															  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�																				  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso 	    � Generico																	  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
oSection:Cell("TOT_VENC" ):SetBlock({|| nTit3  })
oSection:Cell("TOT_SOMA" ):SetBlock({|| nTit2+nTit3})

oSection:PrintLine()

Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪-履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 � TotGer130R� Autor � Paulo Boschetti       � Data � 01.06.92 潮�
北媚哪哪哪哪呐哪哪哪哪�-牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噭o � Imprimir total do relatorio										   潮�
北媚哪哪哪哪呐哪哪哪哪哪-哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � TotGer130R()															   潮�
北媚哪哪哪哪呐哪哪哪哪哪�-哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros�																				   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪-哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico																	   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪�-哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 矷Mes130R	� Autor � Vinicius Barreira	  � Data � 12.12.94 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o 矷MPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � IMes130R()	 															  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� 																			  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Generico 																  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 � IFil130R � Autor � Paulo Boschetti  	  � Data � 01.06.92 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Imprimir total do relatorio por filial							  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � IFil130R()																  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�																				  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso 	    � Generico																	  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
STATIC Function IFil130R(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ,nDecs,oReport,aDados,oSection)

HabiCel(oReport)

oSection:Cell("QUEBRA"   ):SetBlock({|| STR0043 + " " + If(mv_par21==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")})  //"T O T A L   F I L I A L ----> "
oSection:Cell("TOT_NOMI" ):SetBlock({|| nTotFil1})
oSection:Cell("TOT_CORR" ):SetBlock({|| nTotFil2})
oSection:Cell("TOT_VENC" ):SetBlock({|| nTotFil3})
oSection:Cell("TOT_JUROS"  ):SetBlock({|| nTotFilJ})
oSection:Cell("TOT_SOMA" ):SetBlock({||nTotFil2+nTotFil3})

If mv_par19 == 1 // 1 = Analitico - 2 = Sintetico
	aDados[VL_ORIG] := nTotFil0
Endif

oSection:PrintLine()

Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 矵abiCel	� Autor � Daniel Tadashi Batori � Data � 04/08/06 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o 砲abilita ou desabilita celulas para imprimir totais			  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � HabiCel()	 															  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� lHabilit->.T. para habilitar e .F. para desabilitar		  潮�
北�			 � oReport ->objeto TReport que possui as celulas 				  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Generico 																  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
STATIC Function HabiCel(oReport, lMultNat)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)

Default lMultNat := .F.

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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 � FINR130R3� Autor � Paulo Boschetti	     � Data � 01.06.92 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Posi噭o dos Titulos a Receber 						 	  		  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � FINR130R3(void)									  					  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Generico 												  				  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
Static Function FINR130R3()
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

//谀哪哪哪哪哪哪哪哪哪哪哪哪目
//� Defini噭o dos cabe嘺lhos �
//滥哪哪哪哪哪哪哪哪哪哪哪哪馁
titulo := OemToAnsi(STR0005)  //"Posicao dos Titulos a Receber"
cabec1 := OemToAnsi(STR0006)  //"Codigo Nome do Cliente      Prf-Numero         TP  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos Vencidos          | Titulos a Vencer | Num        Vlr.juros ou  Dias   Historico     "
cabec2 := OemToAnsi(STR0007)  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor Nominal   Valor Corrigido |   Valor Nominal  | Banco       permanencia  Atraso               "

//Nao retire esta chamada. Verifique antes !!!
//Ela � necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

pergunte("FIN130",.F.)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis utilizadas para parametros												�
//� mv_par01		 // Do Cliente 													   �
//� mv_par02		 // Ate o Cliente													   �
//� mv_par03		 // Do Prefixo														   �
//� mv_par04		 // Ate o prefixo 												   �
//� mv_par05		 // Do Titulo													      �
//� mv_par06		 // Ate o Titulo													   �
//� mv_par07		 // Do Banco														   �
//� mv_par08		 // Ate o Banco													   �
//� mv_par09		 // Do Vencimento 												   �
//� mv_par10		 // Ate o Vencimento												   �
//� mv_par11		 // Da Natureza														�
//� mv_par12		 // Ate a Natureza													�
//� mv_par13		 // Da Emissao															�
//� mv_par14		 // Ate a Emissao														�
//� mv_par15		 // Qual Moeda															�
//� mv_par16		 // Imprime provisorios												�
//� mv_par17		 // Reajuste pelo vecto												�
//� mv_par18		 // Impr Tit em Descont												�
//� mv_par19		 // Relatorio Anal/Sint												�
//� mv_par20		 // Consid Data Base?  												�
//� mv_par21		 // Consid Filiais  ?  												�
//� mv_par22		 // da filial													      �
//� mv_par23		 // a flial 												         �
//� mv_par24		 // Da loja  															�
//� mv_par25		 // Ate a loja															�
//� mv_par26		 // Consid Adiantam.?												�
//� mv_par27		 // Da data contab. ?												�
//� mv_par28		 // Ate data contab.?												�
//� mv_par29		 // Imprime Nome    ?												�
//� mv_par30		 // Outras Moedas   ?												�
//� mv_par31       // Imprimir os Tipos												�
//� mv_par32       // Nao Imprimir Tipos												�
//� mv_par33       // Abatimentos  - Lista/Nao Lista/Despreza					�
//� mv_par34       // Consid. Fluxo Caixa												�
//� mv_par35       // Salta pagina Cliente											�
//� mv_par36       // Data Base													      �
//� mv_par37       // Compoe Saldo por: Data da Baixa, Credito ou DtDigit  �
//� MV_PAR38       // Tit. Emissao Futura												�
//� MV_PAR39       // Converte Valores 												�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Envia controle para a fun噭o SETPRINT �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�

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

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| FA130Imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

SM0->(dbGoTo(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//Acerta a database de acordo com a database real do sistema
If mv_par20 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 � FA130Imp � Autor � Paulo Boschetti		  � Data � 01.06.92 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Imprime relatio dos Tulos a Receber						  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � FA130Imp(lEnd,WnRel,cString)										  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� lEnd	  - A嚻o do Codeblock				    					  潮�
北�			 � wnRel   - Tulo do relatio 									  潮�
北�			 � cString - Mensagem													  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Generico 																  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
Local dDtContab
Local cTipos  		:= ""
#IFDEF TOP
	Local aStru 	:= SE1->(dbStruct()), ni
#ENDIF	
Local nTotsRec 		:= SE1->(RecCount())
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
Local nPula 		:= 1

PRIVATE nRegSM0 	:= SM0->(Recno())
PRIVATE nAtuSM0 	:= SM0->(Recno())
PRIVATE nOrdem		:= 0
PRIVATE dBaixa 		:= dDataBase
PRIVATE cFilDe
PRIVATE cFilAte
Private Li			:= 0

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Ponto de entrada para Filtrar os tipos sem entrar na tela do �
//� FINRTIPOS(), localizacao Argentina.                          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪Jose Lucas, Localiza嚁es Argentina馁
IF EXISTBLOCK("F130FILT")
	cTipos	:=	EXECBLOCK("F130FILT",.f.,.f.)
ENDIF

nOrdem:=aReturn[8]
cMoeda:=Str(mv_par15,1)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Vari爒eis utilizadas para Impress刼 do Cabe嘺lho e Rodap� �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
cbtxt 	:= OemtoAnsi(STR0046)
cbcont	:= 1
li 		:= 80
m_pag 	:= 1

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� POR MAIS ESTRANHO QUE PARE�A, ESTA FUNCAO DEVE SER CHAMADA AQUI! �
//�                                                                  �
//� A fun噭o SomaAbat reabre o SE1 com outro nome pela ChkFile para  �
//� efeito de performance. Se o alias auxiliar para a SumAbat() n刼  �
//� estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   �
//� pois o Filtro do SE1 uptrapassa 255 Caracteres.                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
SomaAbat("","","","R")

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Atribui valores as variaveis ref a filiais                �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
If mv_par21 == 2
	cFilDe  := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
ELSE
	cFilDe := mv_par22	// Todas as filiais
	cFilAte:= mv_par23
Endif

//Acerta a database de acordo com o parametro
If mv_par20 == 1    // Considera Data Base
	dBaixa := dDataBase := mv_par36
Endif	

dbSelectArea("SM0")
SM0->(dbSeek(cEmpAnt+cFilDe,.T.))

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

// Cria vetor com os codigos das filiais da empresa corrente
aFiliais := FinRetFil()

While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	
	dbSelectArea("SE1")
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	Set Softseek On
	
	If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
		titulo := AllTrim(Titulo) + " " + OemToAnsi(STR0080)+ " " + AllTrim(GetMv("MV_MOEDA"+cMoeda))+ OemToAnsi(STR0026)  //" - Analitico"
		
	Else
		titulo := AllTrim(Titulo) + " " + OemToAnsi(STR0080)+ " " + AllTrim(GetMv("MV_MOEDA"+cMoeda)) + OemToAnsi(STR0027)  //" - Sintetico"
		cabec1 := OemToAnsi(STR0044)  //"                                                                                                               |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0045)  //"                                                                                                               |  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
	EndIf
	
	#IFDEF TOP
		
		// Monta total de registros para IncRegua()
		If !Empty(mv_par09)	
			cQuery := "SELECT COUNT( R_E_C_N_O_ ) TOTREC "
			cQuery += "FROM " + RetSqlName("SE1") + " "
			cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' AND "
			If mv_par40 == 2
				cQuery += "E1_VENCTO >= '" + DtoS(mv_par09) + "' AND "
				cQuery += "E1_VENCTO <= '" + DtoS(mv_par10) + "' AND "
			Else
				cQuery += "E1_VENCREA >= '" + DtoS(mv_par09) + "' AND "
			 	cQuery += "E1_VENCREA <= '" + DtoS(mv_par10) + "' AND "
			Endif
			cQuery += "D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
			nTotsRec := TRB->TOTREC
		Else
			cQuery := "SELECT COUNT( R_E_C_N_O_ ) TOTREC "
			cQuery += "FROM " + RetSqlName("SE1") + " "
			cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' AND "
			cQuery += "E1_EMISSAO >= '" + DtoS(mv_par13) + "' AND "
			cQuery += "E1_EMISSAO <= '" + DtoS(mv_par14) + "' AND "
			cQuery += "D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
			nTotsRec := TRB->TOTREC
		EndIf

		dbSelectArea("TRB")
		dbCloseArea()
		dbSelectArea("SE1")
		
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
	#ENDIF
	
	IF nOrdem = 1
		cChaveSe1 := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFDEF TOP
			cOrder := SqlOrder(cChaveSe1)
		#ELSE
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			SE1->(dbSetIndex(cIndexSe1+OrdBagExt()))
			SE1->(dbSetOrder(nIndexSe1+1))
			SE1->(dbSeek(xFilial("SE1")))
		#ENDIF
		cCond1 := "SE1->E1_CLIENTE <= mv_par02"
		cCond2 := "SE1->E1_CLIENTE + SE1->E1_LOJA"
		titulo := titulo + OemToAnsi(STR0017)  //" - Por Cliente"
		
	Elseif nOrdem = 2
		SE1->(dbSetOrder(1))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+mv_par03+mv_par05))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "SE1->E1_NUM <= mv_par06"
		cCond2 := "SE1->E1_NUM"
		titulo := titulo + OemToAnsi(STR0018)  //" - Por Numero"
	Elseif nOrdem = 3
		SE1->(dbSetOrder(4))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+mv_par07))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "SE1->E1_PORTADO <= mv_par08"
		cCond2 := "SE1->E1_PORTADO"
		titulo := titulo + OemToAnsi(STR0019)  //" - Por Banco"
	Elseif nOrdem = 4
		SE1->(dbSetOrder(7))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+DTOS(mv_par09)))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+" <= mv_par10"
		cCond2 := Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")
		titulo := titulo + OemToAnsi(STR0020)  //" - Por Data de Vencimento"
	Elseif nOrdem = 5
		SE1->(dbSetOrder(3))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+mv_par11))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "SE1->E1_NATUREZ <= mv_par12"
		cCond2 := "SE1->E1_NATUREZ"
		titulo := titulo + OemToAnsi(STR0021)  //" - Por Natureza"
	Elseif nOrdem = 6
		SE1->(dbSetOrder(6))
		#IFNDEF TOP
			SE1->(dbSeek( cFilial+DTOS(mv_par13)))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "SE1->E1_EMISSAO <= mv_par14"
		cCond2 := "SE1->E1_EMISSAO"
		titulo := titulo + OemToAnsi(STR0042)  //" - Por Emissao"
	Elseif nOrdem == 7
		cChaveSe1 := "E1_FILIAL+DTOS("+Iif(mv_par40 = 2, "E1_VENCTO", "E1_VENCREA")+")+E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi(STR0022))
			nIndexSE1 := RetIndex("SE1")
			SE1->(dbSetIndex(cIndexSe1+OrdBagExt()))
			SE1->(dbSetOrder(nIndexSe1+1))
			SE1->(dbSeek(xFilial("SE1")))
		#ELSE
			cOrder := SqlOrder(cChaveSe1)
		#ENDIF
		cCond1 := Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+" <= mv_par10"
		cCond2 := "DtoS("+Iif(mv_par40 = 2, "SE1->E1_VENCTO", "SE1->E1_VENCREA")+")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA"
		titulo := titulo + OemToAnsi(STR0023)  //" - Por Vencto/Banco"
	Elseif nOrdem = 8
		SE1->(dbSetOrder(2))
		#IFNDEF TOP
			SE1->(dbSeek(cFilial+mv_par01,.T.))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "SE1->E1_CLIENTE <= mv_par02"
		cCond2 := "SE1->E1_CLIENTE"
		titulo := titulo + OemToAnsi(STR0024)  //" - Por Cod.Cliente"
	Elseif nOrdem = 9
		cChave := "E1_FILIAL+E1_PORTADO+E1_SITUACA+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,fr130IndR(),OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			SE1->(dbSetIndex(cIndex+OrdBagExt()))
			SE1->(dbSetOrder(nIndex+1))
			SE1->(dbSeek(xFilial("SE1")))
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1 := "SE1->E1_PORTADO <= mv_par08"
		cCond2 := "SE1->E1_PORTADO+SE1->E1_SITUACA"
		titulo := titulo + OemToAnsi(STR0025)  //" - Por Banco e Situacao"
	ElseIf nOrdem == 10
		cChave := "E1_FILIAL+E1_NUM+E1_TIPO+E1_PREFIXO+E1_PARCELA"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,,OemToAnsi(STR0022))
			nIndex := RetIndex("SE1")
			SE1->(dbSetIndex(cIndex+OrdBagExt()))
			SE1->(dbSetOrder(nIndex+1))
			SE1->(dbSeek(xFilial("SE1")+mv_par05))
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1 := "SE1->E1_NUM <= mv_par06"
		cCond2 := "SE1->E1_NUM"
		titulo := titulo + OemToAnsi(STR0048)  //" - Numero/Prefixo"	
	Endif
	
	If mv_par19 <> 1 //1 = Analitico - 2 = Sintetico
		cabec1 := OemToAnsi(STR0044)  //"Nome do Cliente      |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0045)  //"|  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
	EndIf
	
	cFilterUser:=aReturn[7]
	Set Softseek Off
	
	#IFDEF TOP
		cQuery += " AND E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02 + "'"
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
		cQuery += " AND E1_LOJA    between '" + mv_par24        + "' AND '" + mv_par25 + "'"

		If MV_PAR38 == 2 //Nao considerar titulos com emissao futura
			cQuery += " AND E1_EMISSAO <=      '" + DTOS(dDataBase) + "'"
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
        //谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
        //� Ponto de entrada para inclusao de parametros no filtro a ser executado �
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
	SetRegua(nTotsRec)
	
	If MV_MULNATR .And. nOrdem == 5
		Finr135R3(cTipos, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ)
		#IFDEF TOP
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSelectArea("SE1")
			SE1->(dbSetOrder(1))
		#ENDIF
		If Empty(xFilial("SE1"))
			Exit
		Endif
		dbSelectArea("SM0")
		SM0->(dbSkip())
		Loop
	Endif

	While &cCond1 .and. !Eof() .and. lContinua .and. SE1->E1_FILIAL == xFilial("SE1")
		
		IF	lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0028)  //"CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		IncRegua()
		
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Carrega data do registro para permitir �
		//� posterior analise de quebra por mes.   �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dDataAnt := If(nOrdem == 6 , SE1->E1_EMISSAO,  Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))
		
		cCarAnt := &cCond2

		While &cCond2==cCarAnt .and. !Eof() .and. lContinua .and. SE1->E1_FILIAL == xFilial("SE1")
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0028)  //"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIF
			
			IncRegua()
			
			dbSelectArea("SE1")
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Filtrar com base no Pto de entrada do Usuario...             �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪Jose Lucas, Localiza嚁es Argentina馁
			If !Empty(cTipos)
				If !(SE1->E1_TIPO $ cTipos)
					SE1->(dbSkip())
					Loop
				Endif
			Endif
			
			 // Tratamento da correcao monetaria para a Argentina
			If  cPaisLoc=="ARG" .And. mv_par15 <> 1  .And.  SE1->E1_CONVERT=='N'
					SE1->(dbSkip())
					Loop
			Endif
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Considera filtro do usuario                                  �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If !Empty(cFilterUser).and.!(&cFilterUser)
				SE1->(dbSkip())
				Loop
			Endif
			
			nPula := 2
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Modificado tratamento para o par鈓etro MV_PAR36(CONSIDERA DATABASE)�
			//� para quando se imprime um relat髍io com o par鈓etro MV_PAR20(SALDO �
			//� RETROATIVO) = SIM verificando corretamente na SE5 a data de baixa, � 
			//� cr閐ito ou digita玢o para impress鉶. 							   �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE1")
			IF !Empty(SE1->E1_BAIXA) .And. SE1->E1_SALDO == 0
				If(mv_par20 == 1)
					aAreaSE5 := SE5->(GetArea())
					DbSelectArea("SE5")
					SE5->(DbSetOrder(7))
					If SE5->(DbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
						//Dependendo do conteudo do parametro mv_par37 deve-se verificar a data de baixa, credito ou digitacao.					
						If (mv_par37 == 1 .And. SE5->E5_DATA <= MV_PAR36)	.OR. (mv_par37 == 2 .And. SE5->E5_DTDISPO  <= MV_PAR36) .OR.;
						   (mv_par37 == 3 .And. SE5->E5_DTDIGIT <= MV_PAR36)	
						  nPula := 2
						EndIf										
					EndIf
					RestArea(aAreaSE5)
					dbSelectArea("SE1")
					If (nPula == 1)
					  SE1->(dbSkip())
					  Loop
					Endif					
				EndIF
			EndIf
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se trata-se de abatimento ou somente titulos�
			//� at� a data base. 									 �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE1")
			IF (SE1->E1_TIPO $ MVABATIM .And. mv_par33 != 1) .Or.;
				(SE1->E1_EMISSAO > dDataBase .and. MV_PAR38 == 2)
				SE1->(dbSkip())
				Loop
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se ser� impresso titulos provisios		 �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF SE1->E1_TIPO $ MVPROVIS .and. mv_par16 == 2
				SE1->(dbSkip())
				Loop
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se ser� impresso titulos de Adiantamento	 �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par26 == 2
				SE1->(dbSkip())
				Loop
			Endif
			
			// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtContab := Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se esta dentro dos parametros �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE1")
			IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
				SE1->E1_PREFIXO < mv_par03 .OR. SE1->E1_PREFIXO > mv_par04 .OR. ;
				SE1->E1_NUM	 	 < mv_par05 .OR. SE1->E1_NUM 		> mv_par06 .OR. ;
				SE1->E1_PORTADO < mv_par07 .OR. SE1->E1_PORTADO > mv_par08 .OR. ;
				Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) < mv_par09 .OR. ;
				Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA) > mv_par10 .OR. ;
				SE1->E1_NATUREZ < mv_par11 .OR. SE1->E1_NATUREZ > mv_par12 .OR. ;
				SE1->E1_EMISSAO < mv_par13 .OR. SE1->E1_EMISSAO > mv_par14 .OR. ;
				SE1->E1_LOJA    < mv_par24 .OR. SE1->E1_LOJA    > mv_par25 .OR. ;
				dDtContab       < mv_par27 .OR. dDtContab       > mv_par28 .OR. ;
				(SE1->E1_EMISSAO > dDataBase .and. MV_PAR38 == 2) .Or. !&(fr130IndR())
				SE1->(dbSkip())
				Loop
			Endif
			
			If mv_par18 == 2 .and. SE1->E1_SITUACA $ "27"
				SE1->(dbSkip())
				Loop
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se deve imprimir outras moedas�
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If mv_par30 == 2 // nao imprime
				if SE1->E1_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
					SE1->(dbSkip())
					Loop
				endif
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
				nSaldo := u_CSSldTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par15,dDataReaj,MV_PAR36,SE1->E1_LOJA,,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0),mv_par37)
				//Verifica se existem compensa珲es em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimenta珲es da filial corrente. Nao deve processar quando existe somente uma filial.
				If !Empty(xFilial("SE1")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1
					nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,mv_par37,aFiliais),;
									SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(mv_par39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA) ),0 ) ),;
									nDecs+1),nDecs)
				EndIf
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
					nSAldo -= SE1->E1_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					nSAldo += SE1->E1_ACRESC
				Endif

				//Se abatimento verifico a data da baixa.
				//Por nao possuirem movimento de baixa no SE5, a saldotit retorna 
				//sempre saldo em aberto quando mv_par33 = 1 (Abatimentos = Lista)
				If SE1->E1_TIPO $ MVABATIM .and. ;
					((SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA)) .or. ;
					 (SE1->E1_MOVIMEN <= dDataBase .and. !Empty(SE1->E1_MOVIMEN))	) .and.;
					 SE1->E1_SALDO == 0			
					nSaldo := 0
				Endif

			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			Endif
			
			// Se titulo do Template GEM
			If HasTemplate("LOT") .And. SE1->(FieldPos("E1_NCONTR")) > 0 .And. !Empty(SE1->E1_NCONTR) 
				nGem := CMDtPrc(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_VENCREA,SE1->E1_VENCREA)[2]
				If SE1->E1_VALOR==SE1->E1_SALDO
					nSaldo += nGem
				EndIf
			EndIf

			//Caso exista desconto financeiro (cadastrado na inclusao do titulo), 
			//subtrai do valor principal.
			nDescont := FaDescFin("SE1",dBaixa,nSaldo,1,.T.)   
			If nDescont > 0
				nSaldo := nSaldo - nDescont
			Endif
			
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
						!( MV_PAR20 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

					//Quando considerar Titulos com emissao futura, eh necessario
					//colocar-se a database para o futuro de forma que a Somaabat()
					//considere os titulos de abatimento
					If mv_par38 == 1
						dOldData := dDataBase
						dDataBase := CTOD("31/12/40")
					Endif

					nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,dDataReaj,SE1->E1_CLIENTE,SE1->E1_LOJA)

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
					    // Subtrai o Abatimento, pois caso contr醨io, sempre ir� listar o titulo como pendente a
					    // receber  
						If (SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA))
							 nSaldo-= nAbatim
						EndIf                                        
					EndIf
				EndIf
			Endif	
			nSaldo:=Round(NoRound(nSaldo,3),2)
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Desconsidera caso saldo seja menor ou igual a zero   �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If nSaldo <= 0
				SE1->(dbSkip())
				Loop
			Endif
			
			dbSelectArea("SA1")
			SA1->(DbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA))
			dbSelectArea("SA6")
			SA6->(DbSeek(cFilial+SE1->E1_PORTADO))
			dbSelectArea("SE1")
			
			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				
				@li,	0 PSAY SE1->E1_CLIENTE + "-" + SE1->E1_LOJA + "-" +;
					IIF(mv_par29 == 1, SubStr(SA1->A1_NREDUZ,1,17), SubStr(SA1->A1_NOME,1,17))
				li := IIf (aTamCli[1] > 6,li+1,li)
				
				@li, 28 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA
				li := if( LEN( SE1->E1_NUM ) > 9, li+1, li )
				
				@li, 47 PSAY AllTrim(SE1->E1_TIPO)
				@li, 51 PSAY SE1->E1_NATUREZ
				@li, 62 PSAY SE1->E1_EMISSAO
				@li, 73 PSAY SE1->E1_VENCTO
				@li, 84 PSAY SE1->E1_VENCREA   
				
				If mv_par20 == 1  //Recompoe Saldo Retroativo              
				    //Titulo foi Baixado e Data da Baixa e menor ou igual a Data Base do Relat髍io
				    IF !Empty(SE1->E1_BAIXA) 
				    	If SE1->E1_BAIXA <= mv_par36 .Or. !Empty( SE1->E1_PORTADO )
							@li, 94 PSAY SE1->E1_PORTADO+" "+SE1->E1_SITUACA
						EndIf
					Else                                                                                   
					    //Titulo n鉶 foi Baixado e foi transferido para Carteira e Data Movimento e menor 
				    	//ou igual a Data Base do Relat髍io
						If Empty(SE1->E1_BAIXA) .and. SE1->E1_MOVIMEN <= mv_par36
							@li, 94 PSAY SE1->E1_PORTADO+" "+SE1->E1_SITUACA             
						EndIf
					ENDIF
				Else   // Nao Recompoe Saldo Retroativo
					@li, 94 PSAY SE1->E1_PORTADO+" "+SE1->E1_SITUACA 
				EndIf
				
				nVlrOrig := Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1),nDecs+1),nDecs)
				@li,100 PSAY nVlrOrig Picture TM(nVlrOrig,15,nDecs)
			Endif
			
			If dDataBase > SE1->E1_VENCREA	//vencidos
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@li,116 PSAY nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1) Picture TM(nSaldo,15,nDecs)
				EndIf
				nJuros := 0
				fa070Juros(mv_par15)
				// Se titulo do Template GEM
				If HasTemplate("LOT") .And. SE1->(FieldPos("E1_NCONTR")) > 0 .And. !Empty(SE1->E1_NCONTR) .And. SE1->E1_VALOR==SE1->E1_SALDO
					nJuros -= nGem
				EndIf
				dbSelectArea("SE1")
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@li,132 PSAY (nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM, -1,1) Picture TM(nSaldo+nJuros,15,nDecs)
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
			EndIf
			/******************************************************************************
			If nJuros > 0
				If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
					@ Li,182 PSAY nJuros Picture Tm(nJuros, 15,nDecs)//PesqPict("SE1","E1_JUROS",16,MV_PAR15)
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
				nAtraso:=IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
						@li ,200 PSAY nAtraso Picture "99999"
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
				EndIf	
			EndIF
			***********************************************************************/
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				vCodVend	:=	SE1->E1_VEND1
				//aAreaAtu	:=	GetArea()
				DbSelectArea("SA3")
				SA3->(DbSetOrder(1)) // Filial + Codigo
				SA3->(DbSeek(xfilial("SA3")+alltrim(vCodVend)))
				@ Li,182 PSAY ALLTRIM(SA3->A3_NOME) // Nome do Vendedor
				//_nomvend := ALLTRIM(SA3->A3_NOME)
				SA3->(DbCloseArea())	
				
			EndIf
			
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				@li,206 PSAY SubStr(SE1->E1_HIST,1,14)+ ;
					IIF(SE1->E1_TIPO $ MVPROVIS,"*"," ")+ ;
					Iif(Str(nSaldo,17,2) == Str(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,Iif(MV_PAR39==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)),17,2)," ","P")
			EndIf
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Carrega data do registro para permitir �
			//� posterior an爈ise de quebra por mes.   �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dDataAnt := Iif(nOrdem == 6, SE1->E1_EMISSAO, Iif(mv_par40 = 2, SE1->E1_VENCTO, SE1->E1_VENCREA))
			SE1->(dbSkip())
			nTotTit ++
			nMesTTit ++
			nTotFiltit++
			nTit5 ++
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				li++
			EndIf
		Enddo

		If nOrdem == 3
			SA6->(dbSeek(xFilial()+cCarAnt))
		EndIf
			
		IF nTit5 > 0 .and. nOrdem != 2 .and. nOrdem != 10
			SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
			If mv_par19 == 1 //1 = Analitico - 2 = Sintetico
				Li++
			EndIf
		Endif
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Verifica quebra por m坰	  			   �
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
	//� Imprimir TOTAL por filial somente quan-�
	//� do houver mais do que 1 filial.        �
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
		SE1->(dbSetOrder(1))
	#ENDIF
	
	dbSelectArea("SM0")
	SM0->(dbSkip())
Enddo

SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
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
	SE1->(dbSetOrder(1))
#ELSE
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	SE1->(dbSetOrder(1))
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 砈ubTot130 � Autor � Paulo Boschetti 		  � Data � 01.06.92 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o 矷mprimir SubTotal do Relatorio										  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � SubTot130()																  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�																				  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso 	    � Generico																	  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

Local cCarteira := " "  
Local lFR130Tel := ExistBlock("FR130TELC")
Local cCampoCli := ""
Local cTelefone := ""

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
	SED->(dbSeek(cFilial+cCarAnt))
	@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt + " "+Substr(SED->ED_DESCRIC,1,50) + " " + Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"")
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 � TotGer130� Autor � Paulo Boschetti       � Data � 01.06.92 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Imprimir total do relatorio										  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � TotGer130()																  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�																				  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico																	  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 矷mpMes130 � Autor � Vinicius Barreira	  � Data � 12.12.94 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o 矷MPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � ImpMes130() 															  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� 																			  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Generico 																  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 � ImpFil130� Autor � Paulo Boschetti  	  � Data � 01.06.92 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Imprimir total do relatorio										  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � ImpFil130()																  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�																				  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso 	    � Generico																	  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 砯r130Indr � Autor � Wagner           	  � Data � 12.12.94 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o 矼onta Indregua para impressao do relatio						  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Generico 																  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
	cString += '.And.!(MV_PAR32$'+'"'+SE1->E1_TIPO+'")'            
EndIf
IF mv_par34 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(SE1->E1_FLUXO!="N")'	
Endif
Return cString

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � PutDtBase� Autor � Mauricio Pequim Jr    � Data � 18/07/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Acerta parametro database do relatorio                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Finr130.prx                                                潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
SX1->(dbSetOrder(1))
If SX1->(MsSeek("FIN130    36"))
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace SX1->x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  砈itucob   篈utor  矼auricio Pequim Jr. � Data �13.04.2005   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     砇etorna situacao de cobranca do titulo                      罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � FINR130                                                    罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function SituCob(cCarAnt)

Local aSituaca := {}
Local aArea		:= GetArea()
Local cCart		:= " "

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Monta a tabela de situa嚁es de Tulos										 �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea("SX5")
SX5->(dbSeek(cFilial+"07"))
While SX5->X5_FILIAL+SX5->X5_tabela == cFilial+"07"
	cCapital := Capital(X5Descri())
	AADD( aSituaca,{SubStr(SX5->X5_CHAVE,1,2),OemToAnsi(SubStr(cCapital,1,20))})
	SX5->(dbSkip())
EndDo

nOpcS := (Ascan(aSituaca,{|x| Alltrim(x[1])== Substr(cCarAnt,4,1) }))
If nOpcS > 0
	cCart := aSituaca[nOpcS,1]+aSituaca[nOpcs,2]		
ElseIf Empty(SE1->E1_SITUACA)
	cCart := "0 "+STR0029
Endif
RestArea(aArea)
Return cCart


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矨justaSX1 篈utor  砇aphael Zampieri    � Data �11.06.2008   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     矨justa perguntas da tabela SX1                              罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � FINR130                                                    罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
SX3->(dbSetOrder(2))
SX3->(dbSeek("E1_NUM"))
nTamTitSX3	:= SX3->X3_TAMANHO
cGrupoSX3	:= SX3->X3_GRPSXG  
SX3->(dbSetOrder(1))

//            cPerg	Ordem	PergPort         cPerSpa        cPerEng           cVar  Tipo     nTam	 1 2 3    4   cVar01  cDef01  cDefSpa1    cDefEng1    cCont01	        cVar02	   cDef02           cDefSpa2         cDefEng2   cCnt02 cVar03 cDef03   cDefSpa3  cDefEng3  	cCnt03	cVar04	cDef04  cDefSpa4  cDefEng4  cCnt04 	cVar05 	 cDef05	 cDefSpa5  cDefEng5	 cCnt05	 cF3	cGrpSxg  cPyme	 aHelpPor aHelpEng	aHelpSpa  cHelp
AAdd(aRegs,{"FIN130", "05","Do Titulo  ?","緿e Titulo  ?","From Bill  ?",  "mv_ch5","C",nTamTitSX3,0,0,"G","","mv_tit_de","",      "",         "",         "",               "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})
AAdd(aRegs,{"FIN130", "06","Ate o Titulo  ?","緼 Titulo  ?","To Bill  ?",  "mv_ch6","C",nTamTitSX3,0,0,"G","","mv_tit_ate","",      "",         "",    "ZZZZZZZZZZZZZZZZZZZZ",          "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})

ValidPerg(aRegs,"FIN130",.T.)

RestArea( aArea )
 
//Inclusao da pergunta: "Considera data - Vencimento ou Vencimento Real"
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informe a data de vencimento que ser� "  )
Aadd( aHelpPor, "considerada na impressao do relat髍io "  )

Aadd( aHelpSpa, "Informe la fecha de vencimiento que se "   )
Aadd( aHelpSpa, "considerar� en la impresi髇 del informe. " )

Aadd( aHelpEng, "Enter expiration date to be considered "  )
Aadd( aHelpEng, "to print the report."                     )


PutSx1( "FIN130", "40","Considera data","Considera fecha","Consider date","mv_chv","N",1,0,1,"C","","","","",;
	"mv_par40","Vencimento Real","Venc. Real","Real Expiration","","Vencimento","Vencimiento","Expiration","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return



/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯槐�
北篜rograma  � FR130RetNat 篈utor � Gustavo Henrique  � Data � 25/05/10   罕�
北掏屯屯屯屯拓屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯贡�
北篋escricao � Retorna codigo e descricao da natureza para quebra do      罕�
北�          � relatorio analitico por ordem de natureza.                 罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篜arametros� EXPC1 - Codigo da natureza para pesquisa                   罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Financeiro                                                 罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function FR130RetNat( cCodNat )

SED->( dbSetOrder( 1 ) )
SED->( MsSeek( xFilial("SED") + cCodNat ) )

Return( SED->ED_CODIGO + " - " + SED->ED_DESCRIC + If( mv_par21==1, cFilAnt + " - " + Alltrim(SM0->M0_FILIAL), "" ) )

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯槐�
北篜rograma  � FR130TotSoma 篈utor � Gustavo Henrique � Data � 05/26/10   罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯贡�
北篋escricao � Totaliza somatoria da coluna (Vencidos+A Vencer) quando    罕�
北�          � selecionado relatorio por ordem de natureza e parametro    罕�
北�          � MV_MULNATR ativado.                                        罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Financeiro                                                 罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function FR130TotSoma( oTotCorr, oTotVenc, nTotVenc, nTotGeral )

nTotVenc	:= oTotCorr:GetValue() + oTotVenc:GetValue()
nTotGeral	+= nTotVenc

Return .T.







User Function CSSldTit(cPrefixo,cNumero,cParcela,cTipo,cNatureza,cCart,cCliFor,nMoeda,;
						dData,dDataBaixa,cLoja,cFilTit,nTxMoeda,nTipoData)
//Tipos de Data (cTipoData ou xTipoData)
// 0 = Data Da Baixa (E5_DATA) (Default)
// 1 = Data de Disponibilidade (E5_DTDISPO)
// 2 = Data de Contabilida玢o (E5_DTDIGIT)

#IFDEF TOP
	LOCAL nSaldo     := 0
	LOCAL cxFilial   := nil
	Local cProcedure := IIF(FindFunction("GetSPName"), GetSPName("FIN002","10"), "FIN002")
	LOCAL cTiPoData  := "0"
	LOCAL cAliasTit
	
	LOCAL lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )       
				 
	LOCAL cPCCBaixa   := iif(lPCCBaixa,"1","0")  
	LOCAL cAdiant		:= IIF( (cTipo $ MVRECANT+"/"+MVPAGANT+"/"+MV_CRNEG+"/"+MV_CPNEG), "1","0")

	DEFAULT nTxMoeda := 0
	
	dDataBaixa  := iif(dDataBaixa ==nil, dDataBase, dDataBaixa )
	dData       := iif(dData      ==nil, dDataBase, dData )
	nMoeda      := iif(nMoeda     ==nil, 1        , nMoeda )
	cLoja       := iif(cLoja      ==nil, iif(cCart=="R",SE1->E1_LOJA   ,SE2->E2_LOJA   ), cLoja )
	nTipoData	:= iif(nTipoData  ==nil, 1 , nTipoData )

	If nTipoData == 1
		cTipoData := "0"  // E5_DATA
	ElseIf nTipodata == 2
		cTipoData := "1"  // E5_DTDISPO
	Else
		cTipoData := "2"  // E5_DTDIGIT
	Endif


	//If ExistProc( cProcedure, VerIDProc() ) .and. ( TcSrvType() <> "AS/400" )
	If ExistProc( cProcedure ) .and. ( TcSrvType() <> "AS/400" ) //Retirado verifica玢o de vers鉶 da Procedure
		aResult := {}

		cCliFor:=Iif( cCliFor=NIL,Iif(cCart=="R",SE1->E1_CLIENTE,SE2->E2_FORNECE),cCliFor )
		cLoja  :=Iif( cLoja  =NIL,Iif(cCart=="R",SE1->E1_LOJA   ,SE2->E2_LOJA   ),cLoja   )

		If cCart = "R"
			cAliasTit := "SE1"
			dbSelectArea("SE1")
			nSaldo    := E1_VALOR+SE1->E1_SDACRES-SE1->E1_SDDECRE  
			nMoedaTit := SE1->E1_MOEDA
			cCliFor   := Iif(Empty(cCliFor),SE1->E1_CLIENTE,cCliFor)
			cLoja     := Iif(Empty(cLoja  ),SE1->E1_LOJA,cLoja)
		Else
			cAliasTit := "SE2"
			dbSelectArea("SE2")
			nSaldo    := E2_VALOR+SE2->E2_SDACRES-SE2->E2_SDDECRE  
			nMoedaTit := SE2->E2_MOEDA
		Endif

		nMoeda    := ((nMoeda+1.00)-1.00)
		nMoedaTit := ((nMoedaTit+1.00)-1.00)

		aResult := TCSPEXEC( xProcedures(cProcedure),;
			cPrefixo,                cNumero,;
			cParcela,                cTipo,;
			cCliFor,                 DTOS(dData),;
			DTOS(dDataBaixa),        cLoja,;
			DTOS(dDataBase),         cFilAnt,;
			nSaldo,                  nMoedaTit,;
			cPaisLoc,                cTipoData,;
			cPCCBaixa,               cCart, cAdiant )

		nSaldo := aResult[1]
		// Zera o Saldo devido problema de arredondamento nos juros, ou seja, o valor dos juros que eh gravado com
		// 2 casas decimais, gera diferena na recomposicao do saldo no titulo
		// Exemplo: Titulo com valor de 24.450, com E1_PORCJUR de 0.13 e tres dias de atraso, grava em E5_JUROS o valor 
		// de 95.36, sendo que o valor dos juros seria 95.355
		// Movimentacao no SE5:
		//	      Baixa	Juros	       Saldo
		//		 		            24.450,00
		//-------------------------------
		//		4.001,04	95,36 	20.544,32 3 dias apos vencto.
		//		2.100,95		      18.443,37 mesma data
		//		3.474,23		      14.969,14 mesma data
		//		6.000,00		       8.969,14 5 dias apos vencto
		//		5.060,00		       3.909,14 10 dias apos vencto
		//		3.919,29	10,16	        0,01 12 dias apos vencto
		If Empty((cAliasTit)->&(Right(cAliasTit,2)+"_SALDO")) .And. Abs(nSaldo) <= 0.009
			nSaldo := 0
		Else
			nSaldo := Round(NoRound(xMoeda(nSaldo,nMoedaTit,nMoeda,dData,Msdecimais(nMoeda)+1,nTxMoeda),Msdecimais(nMoeda)+1),Msdecimais(nMoeda))
		Endif
		Return (nSaldo)
	Elseif ExistProc( cProcedure ) .and. ( TcSrvType() == "AS/400" )
		aResult := {}
		cxFilial := BuildStrFil("SE5")

		cCliFor:=Iif( cCliFor=NIL,Iif(cCart=="R",SE1->E1_CLIENTE,SE2->E2_FORNECE),cCliFor )
		cLoja  :=Iif( cLoja  =NIL,Iif(cCart=="R",SE1->E1_LOJA   ,SE2->E2_LOJA   ),cLoja   )

		If cCart = "R"
			dbSelectArea("SE1")
			nSaldo    := E1_VALOR+SE1->E1_SDACRES-SE1->E1_SDDECRE  
			nMoedaTit := SE1->E1_MOEDA
			cCliFor   := Iif(Empty(cCliFor),SE1->E1_CLIENTE,cCliFor)
			cLoja     := Iif(Empty(cLoja  ),SE1->E1_LOJA,cLoja)
		Else
			dbSelectArea("SE2")
			nSaldo    := E2_VALOR+SE2->E2_SDACRES-SE2->E2_SDDECRE  
			nMoedaTit := SE2->E2_MOEDA
		Endif

		nMoeda    := ((nMoeda+1.00)-1.00)
		nMoedaTit := ((nMoedaTit+1.00)-1.00)

		aResult := TCSPEXEC( xProcedures(cProcedure), cxFilial,;
			cPrefixo,                cNumero,;
			cParcela,                cTipo,;
			cNatureza,               cCart,;
			cCliFor,                 nMoeda,;
			DTOS(dData),             DTOS(dDataBaixa),;
			cLoja,                   DTOS(dDataBase),;
			cFilAnt,                 '',;
			nSaldo,                  nMoedaTit, cTipoData)

		nSaldo := aResult[1]
		// Zera o Saldo devido problema de arredondamento nos juros, ou seja, o valor dos juros que eh gravado com
		// 2 casas decimais, gera diferena na recomposicao do saldo no titulo
		// Exemplo: Titulo com valor de 24.450, com E1_PORCJUR de 0.13 e tres dias de atraso, grava em E5_JUROS o valor 
		// de 95.36, sendo que o valor dos juros seria 95.355
		// Movimentacao no SE5:
		//	      Baixa	Juros	       Saldo
		//		 		            24.450,00
		//-------------------------------
		//		4.001,04	95,36 	20.544,32 3 dias apos vencto.
		//		2.100,95		      18.443,37 mesma data
		//		3.474,23		      14.969,14 mesma data
		//		6.000,00		       8.969,14 5 dias apos vencto
		//		5.060,00		       3.909,14 10 dias apos vencto
		//		3.919,29	10,16	        0,01 12 dias apos vencto
		If Empty((cAliasTit)->&(Right(cAliasTit,2)+"_SALDO")) .And. Abs(nSaldo) <= 0.009
			nSaldo := 0
		Else
			nSaldo := Round(NoRound(xMoeda(nSaldo,nMoedaTit,nMoeda,dData,Msdecimais(nMoeda)+1,nTxMoeda),Msdecimais(nMoeda)+1),Msdecimais(nMoeda))
		Endif
		Return (nSaldo)
	Else
		Return u_CSxSldTit(@cPrefixo,@cNumero,@cParcela,@cTipo,@cNatureza,@cCart,@cCliFor,@nMoeda,@dData,@dDataBaixa,@cLoja,@cFilTit,nTxMoeda,nTipoData)
	Endif

	/*/
	苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
	北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
	北矲un噮o    � SaldoTit � Autor � Wagner Xavier         � Data � 20/08/93 潮�
	北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
	北矰escri噮o � Calcula o valor de um titulo em uma determinada data       潮�
	北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
	北砈intaxe   � SaldoTit(ExpC1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6,ExpC7,ExpN1)  潮�
	北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
	北砅arametros� ExpC1=Numero do Prefixo                                    潮�
	北�          � ExpC2=Numero do Titulo                                     潮�
	北�          � ExpC3=Parcela                                              潮�
	北�          � ExpC4=Tipo                                                 潮�
	北�          � ExpC5=Natureza                                             潮�
	北�          � ExpC6=Carteira  (R/P)                                      潮�
	北�          � ExpC7=Fornecedor (se ExpC6 = 'R')                          潮�
	北�          � ExpN1=Moeda                                                潮�
	北�          � ExpD1=Data para conversao                                  潮�
	北�          � ExpD2=Data data baixa a ser considerada (retroativa)       潮�
	北�          � ExpC8=Loja do titulo                                       潮�
	北�          � ExpC9=Filial do titulo                                     潮�
	北�          � ExpX10=Tipo de data para compor saldo (baixa/dispo/digit)  潮�
	北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
	哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
	*/

	User Function CSxSldTit(cPrefixo,cNumero,cParcela,cTipo,cNatureza,cCart,cCliFor,nMoeda,;
							 dData,dDataBaixa,cLoja,cFilTit,nTxMoeda,nTipoData)
#ENDIF

//Tipos de Data (cTipoData)
// 0 = Data Da Baixa (E5_DATA)
// 1 = Data de Disponibilidade (E5_DTDISPO)
// 2 = Data de Contabilida玢o (E5_DTDIGIT)

LOCAL cAlias:=Alias(),nSaldo:=0,dDataMoeda, nMoedaTit
LOCAL cCarteira
LOCAL dDtFina 
LOCAL cAliasTit

//Controla o Pis Cofins e Csll na baixa
LOCAL lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

LOCAL aRelat:= {}
LOCAL lRelat:= .F.
LOCAL i:=0
AADD(aRelat,"FINR150")
AADD(aRelat,"FINR130")
AADD(aRelat,"FINR340")

DEFAULT nTxMoeda := 0

//Verifica se Relat髍ios est鉶 na Pilha //
For i=1 To Len(aRelat)
	If IsInCallStack(aRelat[i])
		lRelat:=.t.
		exit 
	EndIf
Next i

cCliFor:=Iif( cCliFor=NIL,Iif(cCart=="R",SE1->E1_CLIENTE,SE2->E2_FORNECE),cCliFor )
cLoja  :=Iif( cLoja  =NIL,Iif(cCart=="R",SE1->E1_LOJA   ,SE2->E2_LOJA   ),cLoja   )
nMoeda :=IIF( nMoeda==NIL,1,nMoeda )
dDataMoeda :=IIF( dData==NIL,dDataBase,dData )
dDataBaixa :=IIF( dDataBaixa==NIL,dDataBase,dDataBaixa )
nTipoData  := IIF( nTipoData  ==nil, 0 , nTipoData )

If nTipoData == 1
	cTipoData := "0"  // E5_DATA
ElseIf nTipodata == 2
	cTipoData := "1"  // E5_DTDISPO
Else
	cTipoData := "2"  // E5_DTDIGIT
Endif


// cFiltit somente e' usado no caso de relatorios que podem ser tirados
// por empresa (opcional)
cFilTit := Iif(cFilTit==Nil,xFilial("SE5"),cFilTit)

dbSelectArea("SE5")
If Empty( xFilial() )
	cFilTit := Space( IIf( lFWCodFil, FWGETTAMFILIAL, 2 ) )
Endif

If cCart = "R"
	cAliasTit := "SE1"
	dbSelectArea("SE1")
	nSaldo := E1_VALOR+SE1->E1_SDACRES-SE1->E1_SDDECRE  
	nMoedaTit := SE1->E1_MOEDA
	cCliFor := Iif(Empty(cCliFor),SE1->E1_CLIENTE,cCliFor)
	cLoja   := Iif(Empty(cLoja  ),SE1->E1_LOJA,cLoja)
Else
	cAliasTit := "SE2"
	dbSelectArea("SE2")
	nSaldo := SE2->E2_VALOR+SE2->E2_SDACRES-SE2->E2_SDDECRE  
	nMoedaTit := SE2->E2_MOEDA
Endif

If Select("__BAIXA") == 0
	ChkFile("SE5",.F.,"__BAIXA")
Else
	dbSelectArea("__BAIXA")
Endif
dbSetOrder(7)
dbSeek(cFilTit+cPrefixo+cNumero+cParcela+cTipo)

While E5_FILIAL + E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO == ;
		cFilTit + cPrefixo + cNumero + cParcela + cTipo .and. !EOF()

	IF E5_SITUACA = "C"
		dbSkip()
		Loop
	Endif
	//Posicionar o SE5 pois dentro da TEMBXCANC condulta o SE5 e nao o __BAIXA
   SE5->(DbGoTo(__BAIXA->(Recno())))
	If TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
		dbskip()
		Loop
	EndIf

	cCarteira := cCart
	If cCart == "R"
		If (E5_TIPO$MVRECANT+"/"+MV_CRNEG).and. E5_TIPODOC $ "BA|VL|MT|JR|CM" ;
				.and. Empty(E5_DOCUMEN) .and. IIF(!(MovBcoBx(E5_MOTBX)), .T. , !Empty(E5_BANCO) )
			cCarteira := "P"        //Baixa de adiantamento (inverte)
			cLoja     := SE1->E1_LOJA
		Endif
	Endif

	If cCart == "P"
		If (E5_TIPO$MVPAGANT+"/"+MV_CPNEG).and. E5_TIPODOC $ "BA|VL|MT|JR|CM" .and. ;
				Empty(E5_DOCUMEN) .and. IIF(!(MovBcoBx(E5_MOTBX)), .T. , !Empty(E5_BANCO) )
			cCarteira := "R"        //Baixa de adiantamento (inverte)
		Endif
	Endif
	
 	If !lRelat // Colocado este tratamento para conseguir compor o saldo no relat髍io de titulos a receber. Antes do Tratamento, fazia skip e ignorava o registro nos relat髍ios
 		IF (cCarteira == "P" .and. E5_RECPAG == "R") .or. (cCarteira == "R" .and. E5_RECPAG == "P")
			dbSkip( )
			Loop
		Endif
	EndIf

	IF cCliFor + cLoja  != E5_CLIFOR + E5_LOJA
		dbSkip()
		Loop
	EndIF

	//Defino qual o tipo de data a ser utilizado para compor o saldo do titulo
	If cTipoData == "0"
		dDtFina := E5_DATA
	ElseIf cTipoData == "1"
		dDtFina := E5_DTDISPO
	Else	
		dDtFina := E5_DTDIGIT
	Endif			

	IF dDtFina <= dDataBaixa
		IF E5_TIPODOC $ "VL#BA#V2#CP#LJ"
			nSaldo -= IIF((nMoedaTit < 2.And.cPaisLoc=="BRA").Or. (cPaisLoc <>"BRA" .And. nMoedaTit > 1 .And. !Empty(E5_BANCO)),E5_VALOR,E5_VLMOED2)
			nSaldo += Round(NoRound(xMoeda(E5_VLMULTA+E5_VLJUROS-E5_VLDESCO,1,nMoedaTit,E5_DATA,3,,IIF(E5_TXMOEDA==0,nTxMoeda,E5_TXMOEDA)),3),2)
			//Retencao de impostos na baixa
			If lPccBaixa .and. cCarteira == "P" .and. Empty(E5_PRETPIS) .and. !(E5_MOTBX == "PCC")
				nSaldo -= Round(NoRound(xMoeda(E5_VRETPIS+E5_VRETCOF+E5_VRETCSLL,1,nMoedaTit,E5_DATA,3,,IIF(E5_TXMOEDA==0,nTxMoeda,E5_TXMOEDA)),3),2)				
			Endif			
			If nSaldo <= 0.009
				nSaldo := 0
			Endif
		Endif
	EndIF
	dbSkip()
Enddo
// Zera o Saldo devido problema de arredondamento nos juros, ou seja, o valor dos juros que eh gravado com
// 2 casas decimais, gera diferena na recomposicao do saldo no titulo
// Exemplo: Titulo com valor de 24.450, com E1_PORCJUR de 0.13 e tres dias de atraso, grava em E5_JUROS o valor 
// de 95.36, sendo que o valor dos juros seria 95.355
// Movimentacao no SE5:
//	      Baixa	Juros	       Saldo
//		 		            24.450,00
//-------------------------------
//		4.001,04	95,36 	20.544,32 3 dias apos vencto.
//		2.100,95		      18.443,37 mesma data
//		3.474,23		      14.969,14 mesma data
//		6.000,00		       8.969,14 5 dias apos vencto
//		5.060,00		       3.909,14 10 dias apos vencto
//		3.919,29	10,16	        0,01 12 dias apos vencto
If Empty((cAliasTit)->&(Right(cAliasTit,2)+"_SALDO")) .And. Abs(nSaldo) <= 0.009
	nSaldo := 0
Else
	nSaldo := Round(NoRound(xMoeda(nSaldo,nMoedaTit,nMoeda,dData,Msdecimais(nMoeda)+1,nTxMoeda),Msdecimais(nMoeda)+1),Msdecimais(nMoeda))
Endif
dbSelectArea(cAlias)
Return ( nSaldo )



