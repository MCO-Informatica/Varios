#INCLUDE "Totvs.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA029    º Autor ³ Renato Ruy	     º Data ³  12/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz atualização de valores no lançamento de remuneração.   º±±
±±º          ³ 					                      					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA029


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oDlg
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cDirIn	:= Space(256)
Local aDirIn	:= {}

Private cPeriodo	:= AllTrim(GetMv("MV_REMMES"))
Private cTipo
Private aTipo     := {"1=Posto",;
"2=AC",;
"3=Canal",;
"4=Federacao",;
"5=Campanha do Contador",;
"6=Clube do Revendedor",;
"7=Visita Externa",;
"8=Zera Valores",;
"9=Pagos IFEN",;
"A=Novo Clube",;
"B=Valor Extra",;
"C=Boa Vista",;
"D=Portal de Assinatura"}

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Leitura de Dados do GAR e Atualização via WebService" PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 25,10 SAY "Tipo Entidade" OF oDlg PIXEL
@ 25,70 ComboBox cTipo Items aTipo Size 075,010 PIXEL OF oDlg

@ 25,172 SAY "Periodo" OF oDlg PIXEL
@ 25,198 MSGET cPeriodo SIZE 072,010 OF oDlg PIXEL

@ 46,146 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CRPA029A(@aDirIn,@cDirIn)
@ 46,188 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 46,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1
	Return(.F.)
EndIf

If len(aDirIn) = 0
	MsgAlert("Não Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

//Proc2BarGauge({|| OkLeTxt(cDirIn,aDirIn) },"Processamento de Arquivo TXT")
Processa( {|| OkLeTxt(cDirIn,aDirIn) }, "Importando Arquivos...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSA01   ºAutor  ³Microsiga           º Data ³  01/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CRPA029A(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diretórios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.CSV")

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  12/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt(cDirIn,aDirIn)

Local nIg	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cArqTxt := ""
Private nHdl    := ""

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nIg:= 1 to len(aDirIn)
	cArqTxt := cDirIn+aDirIn[nIg][1]
	nHdl    := fOpen(cArqTxt,68)
	//IncProcG1("Proc. Arquivo "+aDirIn[nIg][1])
	//ProcessMessage()
	CRPA29PR()
Next

MsgInfo("A planilha foi importada!")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  12/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CRPA29PR()

Local nQtdReg 	:= 0
Local nRecAtu	:= 0
Local aStrucSZ6	:= SZ6->( DbStruct() )
Local aDadosSZ6	:= {}
Local lMidiaAvulsa := .F.
Local lEntLoc	:= .F.
Local lRegLoc	:= .F.
Local cTipEnt	:= ""
Local nOrdem	:= 0
Local cCodFed	:= ""
Local cCodEnt  :=  ""
Local cDesEnt  :=  ""
Local cAgVal   :=  ""
Local cCodPro  :=  ""
Local cDesPro  :=  ""
Local cPedido  :=  ""
Local cStatPed :=  ""
Local dDtPed   :=  CtoD("  /  /  ")
Local dDtVal   :=  CtoD("  /  /  ")
Local dDtVer   :=  CtoD("  /  /  ")
Local dDtEmi   :=  CtoD("  /  /  ")
Local cNomCli  :=  ""
Local nValtTot :=  0
Local nValtSw  :=  0
Local cProjeto  :=  ""
Local nValtHW  :=  0
Local cTipVou  :=  ""
Local cPedAnt  :=  ""
Local dDtPedA  :=  CtoD("  /  /  ")
Local cDesCcr  :=  ""
Local cCodAc   :=  ""
Local cDesAc   :=  ""
Local cCodACAnt:= ""
Local cCodARAnt:= ""
Local cDesGru  :=  ""
Local nValAbt  :=  0
Local nValBSw  :=  0
Local nValBHw  :=  0
Local nValBTot :=  0
Local nValCSw  :=  0
Local nValCHw  :=  0
Local nValCTot :=  0
Local nValFed  :=  0
Local nValTFed :=  0
Local nConTot  :=  0
Local nContHw  :=  0
Local nContSw  :=  0
Local cVisita  :=  "000001"
Local cUf 	   :=  ""
Local cRegiao  :=  ""
Local cCodVen  :=  ""
Local cNomVen  :=  ""
Local cLink    :=  ""
Local nQtdVis  :=  ""
Local cMsgObs  :=  ""
Local nX	   := 0
Local nJ	   := 0
Local nk	   := 0
Local nz	   := 0
Local ni	   := 0

//Modelo de Importação - Campanha e Clube
// | 1 - Código Entidade                         |
// | 2 - Descrição Entidade                      |
// | 3 - Cod.Vendedor                            |
// | 4 - Nome Vendedor                           |
// | 5 - Desc. Agente Val.                       |
// | 6 - Cod. Produto                            |
// | 7 - Desc.Produto                            |
// | 8 - Pedido                               	 |
// | 9 - Status Pedido                           |
// | 10 - Dt.Pedido                              |
// | 11 - Dt.Validação                           |
// | 12 - Dt.Verificação                         |
// | 13 - Dt.Emissão/Renovação                   |
// | 14 - Nome Cliente                           |
// | 15 - Tipo Voucher                           |
// | 16 - Ped. Anterior                          |
// | 17 - Dt.Pedido Anterior                     |
// | 18 - Cód. AC                                |
// | 19 - Desc. Grupo                            |
// | 20 - Link                               	 |
// | 21 - Val. Bruto                             |
// | 22 - Val. Faturamento                       |
// | 23 - Valor Tot. Comiss.                     |
// | 24 - Contador                               |

//Modelo de Importação Posto, AC, Canal e Federacao.
// | 01 - Cod.Ent.                                           |
// | 02 - Des. Entidade                                      |
// | 03 - Desc. Agente Val.                                  |
// | 04 - Cod. Produto                                       |
// | 05 - Desc.Produto                                       |
// | 06 - Pedido                                             |
// | 07 - Status Pedido                                      |
// | 08 - Dt.Pedido                                          |
// | 09 - Dt.Validação                                       |
// | 10 - Dt.Verificação                                     |
// | 11 - Dt.Emissão/Renovação                               |
// | 12 - Nome Cliente                                       |
// | 13 - Valot Tot. Base                                    |
// | 14 - Base Software                                      |
// | 15 - Base Hardware                                      |
// | 16 - Tipo Voucher                                       |
// | 17 - Ped. Anterior                                      |
// | 18 - Dt.Pedido Anterior                                 |
// | 19 - Desc. CCR                                          |
// | 20 - Cód. AC                                            |
// | 21 - Desc. AC                                           |
// | 22 - Desc. Grupo                                        |
// | 23 - Val. Abatimento                                    |
// | 24 - Val. Bruto Soft                                    |
// | 25 - Val. Bruto Hard                                    |
// | 26 - Valor Bruto Total                                  |
// | 27 - Val. Comiss. Soft                                  |
// | 28 - Val. Comiss. Hard                                  |
// | 29 - Valor Tot. Comiss.                                 |
// | 30 - Val. Comissão Fed.                                 |
// | 31 - Val. Tot. Comiss+Fed.                              |
// | 32 - Contagem Geral                                     |
// | 33 - Contagem Hard.                                     |
// | 34 - Contagem Soft.                                     |
// | 35 - UF                                                 |
// | 36 - REGIAO                                             |


//Armazeno o tipo da Entidade
If cTipo == "1"
	cTipEnt := "4" //Posto
ElseIf cTipo == "2"
	cTipEnt := "2" //AC
ElseIf cTipo == "3"
	cTipEnt := "1" //Canal
ElseIf cTipo == "4"
	cTipEnt := "8" //Federacao
ElseIf cTipo == "5"
	cTipEnt := "7" //Campanha do Contador
ElseIf cTipo == "6"
	cTipEnt := "10" //Clube do Revendedor
EndIf

// Cria a matriz e inicializa as variaveis
FT_FUSE(cArqTxt)

nTotRec := FT_FLASTREC()

FT_FGOTOP()

//IncprocG2( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
//ProcessMessage()

While !FT_FEOF()
	
	//Leio a linha e gero array com os dados
	xBuff	:= alltrim(FT_FREADLN())
	
	//Faço tratamento para não gerar erro nas colunas
	While ";;" $ xBuff
		xBuff	:= StrTran(xBuff,";;",";-;")
	EndDo
	
	If SubStr(xBuff,len(xBuff),1) == ";"
		xBuff 	+= "-"
	EndIf
	
	aLin 	:= StrTokArr(xBuff,";")
	
	IncProc( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
	ProcessMessage()
	
	If AllTrim(cTipo) $ "1/2/3/4/5/6"
		
		//Se o tamanho da linha estiver divergente pulo para o proximo registro.
		If (Len(aLin) < 36 .And. AllTrim(cTipo) $ "1/2/3/4") .Or. (Len(aLin) < 24 .And. AllTrim(cTipo) $ "5/6")
			FT_FSKIP()
			Loop
		EndIf
		
		//Adiciono o conteúdo em uma variavel para enviar para o array
		cCodEnt  :=  aLin[1] //Cod.Ent.
		cDesEnt  :=  aLin[2] //Des. Entidade
		cAgVal   :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[3],aLin[5]) //Desc. Agente Val.
		cCodPro  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[4],aLin[6])//Cod. Produto
		cDesPro  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[5],aLin[7]) //Desc.Produto
		cPedido  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[6],aLin[8])//Pedido
		cStatPed :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[7],aLin[9]) //Status Pedido
		dDtPed   :=  Iif(!(AllTrim(cTipo) $  "5/6"), CtoD(aLin[8]),CtoD(aLin[10])) //Dt.Pedido
		dDtVal   :=  Iif(!(AllTrim(cTipo) $  "5/6"), CtoD(aLin[9]),CtoD(aLin[11])) //Dt.Validação
		dDtVer   :=  Iif(!(AllTrim(cTipo) $  "5/6"), CtoD(aLin[10]),CtoD(aLin[12])) //Dt.Verificação
		dDtEmi   :=  Iif(!(AllTrim(cTipo) $  "5/6"), CtoD(aLin[11]),CtoD(aLin[13])) //Dt.Emissão/Renovação
		cNomCli  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[12],aLin[14]) //Nome Cliente
		nValtTot :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[13],".",""),",",".")),Val(StrTran(StrTran(aLin[22],".",""),",",".")))//Valot Tot. Base
		nValtSw  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[14],".",""),",",".")),0) //Base Software
		nValtHW  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[15],".",""),",",".")),0) //Base Hardware
		cTipVou  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[16],aLin[15])//Tipo Voucher
		cPedAnt  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[17],aLin[16]) //Ped. Anterior
		dDtPedA  :=  Iif(!(AllTrim(cTipo) $  "5/6"), CtoD(aLin[18]),CtoD(aLin[17])) //Dt.Pedido Anterior
		cDesCcr  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[19],"") //Desc. CCR
		cCodAc 	 := Iif(!(AllTrim(cTipo) $  "5/6"), aLin[20],aLin[18]) //Cod. AC
		cDesAc   :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[21],"") //Desc. AC
		cDesGru  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[22],aLin[19])  //Desc. Grupo
		nValAbt  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[23],".",""),",",".")),0)  //Val. Abatimento
		nValBSw  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[24],".",""),",",".")),0)  //Val. Bruto Soft
		nValBHw  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[25],".",""),",",".")),0)  //Val. Bruto Hard
		nValBTot :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[26],".",""),",",".")),Val(StrTran(StrTran(aLin[21],".",""),",",".")))  //Valor Bruto Total
		nValCSw  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[27],".",""),",",".")),0) //Val. Comiss. Soft
		nValCHw  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[28],".",""),",",".")),0) //Val. Comiss. Hard
		nValCTot :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[29],".",""),",",".")),Val(StrTran(StrTran(aLin[23],".",""),",","."))) //Valor Tot. Comiss.
		nValFed  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[30],".",""),",",".")),0) //Val. Comissão Fed.
		nValTFed :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(StrTran(StrTran(aLin[31],".",""),",",".")),0) //Val. Tot. Comiss+Fed.
		nConTot  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(aLin[32]),Val(aLin[24])) //Contagem Geral
		nContHw  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(aLin[33]),0) //Contagem Hard.
		nContSw  :=  Iif(!(AllTrim(cTipo) $  "5/6"), Val(aLin[34]),0)  //Contagem Soft.
		cUf 	 :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[35],"")  //UF
		cRegiao  :=  Iif(!(AllTrim(cTipo) $  "5/6"), aLin[36],"") //REGIAO
		cCodVen  :=  Iif(!(AllTrim(cTipo) $  "5/6"), "",aLin[3]) //Cod. Vendedor
		cNomVen  :=  Iif(!(AllTrim(cTipo) $  "5/6"), "",aLin[4]) //Cod. Vendedor
		cLink 	 :=  Iif(!(AllTrim(cTipo) $  "5/6"), "",aLin[20]) //Cod. Vendedor
		
		If cPedido >= "A" .Or. Empty(cPedido)
			FT_FSKIP()
			Loop
		EndIf
		
		lMidiaAvulsa := Iif(AllTrim(Upper(cStatPed)) == 'HARDWARE AVULSO',.T.,.F.)
		
		//Armazeno a ordem para excluir itens da SZ6.
		If lMidiaAvulsa
			nOrdem := 4
		Else
			nOrdem := 1
		EndIf
		
		//Zero a quantidade de registros
		nQtdReg := 0
		nZ 		:= 0
		
		//Se tem valor de software gera registro na SZ6
		If (nValBSw > 0 .Or. AllTrim(cTipo) $  "5/6" .Or. (nValBSw == 0 .And. nValBHw == 0) .Or. (nValBSw == 0 .And. nValBHw > 0 .And. !lMidiaAvulsa)) .And. !(nValFed > 0 .And. nValCTot == 0 .And. AllTrim(cCodAc) != "CER" )
			nQtdReg += 1
		EndIf
		
		//Se tem valor de software gera registro na SZ6
		If (nValBHw > 0 .Or. lMidiaAvulsa) .And. !(nValFed > 0 .And. nValCTot == 0)
			nQtdReg += 1
		EndIf
		
		aDadosSZ6 := {}
		
		For nX :=1 To nQtdReg
			Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) )
			For nJ := 1 To Len(aStrucSZ6)
				Do Case
					Case aStrucSZ6[nJ][2] == "C"
						aDadosSZ6[Len(aDadosSZ6)][nJ] := ""
					Case aStrucSZ6[nJ][2] == "N"
						aDadosSZ6[Len(aDadosSZ6)][nJ] := 0
					Case aStrucSZ6[nJ][2] == "D"
						aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//")
					Otherwise
						aDadosSZ6[Len(aDadosSZ6)][nJ] := ""
				Endcase
			Next nJ
		Next nX
		
		cCodEnt := Iif(!(AllTrim(cTipo) $  "2/5/6"), PadL(cCodEnt,6,"0"),cCodEnt)
		
		SZ5->(DbSetOrder(1))
		If SZ5->(DbSeek(xFilial("SZ5") + PadR(cPedido,10," ") )) .And. !lMidiaAvulsa
			lRegLoc := .T.
			//Atualiza dados com o GAR
			//CRPA029B(cPedido,.F.)
		Elseif !lMidiaAvulsa
			//Atualiza dados com o GAR
			//CRPA029B(cPedido,.T.)
			If SZ5->(DbSeek(xFilial("SZ5") + PadR(cPedido,10," ") ))
				lRegLoc := .T.
			EndIf
		Elseif lMidiaAvulsa
			SC5->(DbSetOrder(8))
			If SC5->(DbSeek(xFilial("SC5") + PadR(cPedido,10," ") ))
				SZ5->(DbSetOrder(3))
				If SZ5->(DbSeek(xFilial("SZ5") + SC5->C5_NUM ))
					lRegLoc := .T.
				EndIf
			EndIf
		EndIf
		
		//Me Posiciono na Entidade
		SZ3->(DbSetOrder(1))
		If SZ3->(DbSeek(xFilial("SZ3") + cCodEnt)) .And. !(AllTrim(cTipo) $  "5/6")
			lEntLoc := .T.
			
			//Caso o tipo de entidade seja diferente da atual desconsidero o registro.
			If cTipEnt <> AllTrim(SZ3->Z3_TIPENT)
				FT_FSKIP()
				Loop
			EndIf
			
			//Se nao encontrar a entidade e a mesma não seja de Clube / Campanha, pulo o registro.
		Elseif !(AllTrim(cTipo) $  "5/6")
			FT_FSKIP()
			Loop
		EndIf
		
		//Apago os registros, caso ja existam para este pedido.
		//Renato Ruy - 23/09/15
		//Alterei para apagar somente o registro, caso o pedido seja do mesmo tipo de entidade especificada pelo usuário.
		SZ6->(DbSetOrder(nOrdem))          
			//Armazeno a ordem para excluir itens da SZ6.
			cPedido := PadR(cPedido,10," ")
		
		If SZ6->(DbSeek(xFilial("SZ6")+cPedido))
			If lMidiaAvulsa
				If !(nValFed > 0 .And. nValCTot == 0 .And. AllTrim(cCodAc) != "CER")
					While AllTrim(cPedido) == AllTrim(SZ6->Z6_PEDSITE)
						If AllTrim(SZ6->Z6_PERIODO) == AllTrim(cPeriodo) .And. AllTrim(cCodEnt) == AllTrim(SZ6->Z6_CODENT) .And. AllTrim(SZ6->Z6_TPENTID) == cTipEnt .And. AllTrim(cCodPro) = AllTrim(SZ6->Z6_PRODUTO)		
							SZ6->( RecLock("SZ6",.F.) )
							SZ6->( DbDelete() )
							SZ6->( MsUnLock() )
						EndIf
						SZ6->(DbSkip())
					EndDo
				EndIf
			Else
				If !(nValFed > 0 .And. nValCTot == 0 .And. AllTrim(cCodAc) != "CER")
					While AllTrim(SZ6->Z6_PERIODO) == AllTrim(cPeriodo) .And. AllTrim(cCodEnt) == AllTrim(SZ6->Z6_CODENT) .And. AllTrim(cPedido) == AllTrim(SZ6->Z6_PEDGAR)
						If AllTrim(SZ6->Z6_TPENTID) == cTipEnt					
							SZ6->( RecLock("SZ6",.F.) )
							SZ6->( DbDelete() )
							SZ6->( MsUnLock() )
						EndIf
						SZ6->(DbSkip())
					EndDo
				EndIf
			EndIf
		EndIf
		
		
		For nX := 1 To nQtdReg
			nZ	:=	nZ	+	1
			For nK := 1 To Len(aStrucSZ6)
				cCampo := AllTrim(aStrucSZ6[nK][1])
				Do Case
					Case cCampo == "Z6_FILIAL"
						aDadosSZ6[nZ][nK]	:= xFilial("SZ6")
					Case cCampo == "Z6_PERIODO"
						aDadosSZ6[nZ][nK]	:= cPeriodo
					Case cCampo == "Z6_TPENTID"
						aDadosSZ6[nZ][nK]	:= cTipEnt
					Case cCampo == "Z6_CODENT"
						aDadosSZ6[nZ][nK]	:= cCodEnt
					Case cCampo == "Z6_DESENT"
						aDadosSZ6[nZ][nK]	:= cDesEnt
					Case cCampo == "Z6_PRODUTO"
						aDadosSZ6[nZ][nK]	:= cCodPro
					Case cCampo == "Z6_CATPROD"
						aDadosSZ6[nZ][nK]	:= IiF(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware
					Case cCampo == "Z6_DESCRPR"
						aDadosSZ6[nZ][nK]	:= cDesPro
					Case cCampo == "Z6_PEDGAR"
						aDadosSZ6[nZ][nK]	:= IiF(!lMidiaAvulsa,cPedido,"")
					Case cCampo == "Z6_DTPEDI"
						aDadosSZ6[nZ][nK]	:= dDtPed
					Case cCampo == "Z6_VERIFIC"
						aDadosSZ6[nZ][nK]	:= dDtVer
					Case cCampo == "Z6_VALIDA"
						aDadosSZ6[nZ][nK]	:= dDtVal
					Case cCampo == "Z6_DTEMISS"
						aDadosSZ6[nZ][nK]	:= dDtEmi
					Case cCampo == "Z6_TIPVOU"
						aDadosSZ6[nZ][nK]	:= cTipVou
					Case cCampo == "Z6_CODVOU"
						aDadosSZ6[nZ][nK]	:= "" //Nao grava no relatorio
					Case cCampo == "Z6_DESCVOU"
						aDadosSZ6[nZ][nK]	:= ""
					Case cCampo == "Z6_VLRPROD"
						If !(AllTrim(cTipo) $  "5/6")
							aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValBSw,nValBHw)
						Else
							aDadosSZ6[nZ][nK]	:= nValBTot
						EndIf
					Case cCampo == "Z6_BASECOM"
						If !(AllTrim(cTipo) $  "5/6")
							aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValtSw,nValtHw)
						Else
							aDadosSZ6[nZ][nK]	:= nValtTot
						EndIf
					Case cCampo == "Z6_VALCOM"
						If !(AllTrim(cTipo) $  "5/6")
							aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValCSw,nValCHw)
						Else
							aDadosSZ6[nZ][nK]	:= nValCTot
						EndIf
					Case cCampo == "Z6_REGCOM"
						aDadosSZ6[nZ][nK]	:= "IMPORTACAO: " + DtoC(dDataBase) + " - " + Time()
					Case cCampo == "Z6_CODCAN"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODCAN,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODAC"
						aDadosSZ6[nZ][nK]	:= If(cTipo == "2", cCodEnt, cCodAc)
					Case cCampo == "Z6_CODAR"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODAR,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODPOS"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODGAR,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODCCR"
						aDadosSZ6[nZ][nK]	:= RetCodEnt( PadR(cDesCcr,100," ") )
					Case cCampo == "Z6_CCRCOM"
						aDadosSZ6[nZ][nK]	:= cDesCcr
					Case cCampo == "Z6_CODPAR"
						aDadosSZ6[nZ][nK]		:= Iif(lEntLoc,SZ3->Z3_CODPAR,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODFED"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODFED,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODVEND"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc .And. !(AllTrim(cTipo) $  "5/6"),SZ5->Z5_CODVEND,cCodVen)
					Case cCampo == "Z6_NOMVEND"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc .And. !(AllTrim(cTipo) $  "5/6"),SZ5->Z5_NOMVEND,cNomVen)
					Case cCampo == "Z6_TIPO"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_TIPO,"")
					Case cCampo == "Z6_PEDSITE"
						aDadosSZ6[nZ][nK]	:= IiF(lMidiaAvulsa,cPedido,"")
					Case cCampo == "Z6_REDE"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_REDE,"")
					Case cCampo == "Z6_GRUPO"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_GRUPO,"")
					Case cCampo == "Z6_DESGRU"
						aDadosSZ6[nZ][nK]	:= cDesGru
					Case cCampo == "Z6_CODAGE"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_CODAGE,"") //Nao grava no relatorio
					Case cCampo == "Z6_NOMEAGE"
						aDadosSZ6[nZ][nK]	:= cAgVal
					Case cCampo == "Z6_AGVER"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_AGVER,"")
					Case cCampo == "Z6_NOAGVER"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_NOAGVER,"")
					Case cCampo == "Z6_NTITULA"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_NTITULA,"")
					Case cCampo == "Z6_DESREDE"
						aDadosSZ6[nZ][nK]	:= Iif(lRegLoc .And. !(AllTrim(cTipo) $  "5/6"),SZ5->Z5_DESREDE,cLink)
					Case cCampo == "Z6_PEDORI"
						aDadosSZ6[nZ][nK]	:= cPedAnt
					Case cCampo == "Z6_VLRABT"
						aDadosSZ6[nZ][nK]	:= nValAbt
					Case cCampo == "Z6_ACLCTO"
						aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE
					Case cCampo == "Z6_ARLCTO"
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAR 	
				Endcase
			Next nK
		Next nX
		
		//Armazeno o codigo da federacao.
		cCodFed := SZ3->Z3_CODFED
		
		//Me Posiciono na Entidade
		
		If !Empty(cCodFed) .And. lEntLoc
			SZ3->(DbSetOrder(1))
			If !SZ3->(DbSeek(xFilial("SZ3") + cCodFed))
				lEntLoc := .F.
			EndIf
		EndIf
		
		//Gera calculo da federação
		If (lEntLoc .And. !Empty(cCodFed)) .Or. nValFed > 0
			
			//Apago os registros, caso ja existam para este pedido.
			SZ6->(DbSetOrder(nOrdem))
			cPedido := PadR(cPedido,10," ")
		
			If SZ6->(DbSeek(xFilial("SZ6")+cPedido))
				If lMidiaAvulsa
					While AllTrim(cPedido) == AllTrim(SZ6->Z6_PEDSITE)
						If AllTrim(SZ6->Z6_TPENTID) == "8" .And. AllTrim(cCodPro) == AllTrim(SZ6->Z6_PRODUTO)
							SZ6->( RecLock("SZ6",.F.) )
							SZ6->( DbDelete() )
							SZ6->( MsUnLock() )
						EndIf
						SZ6->(DbSkip())
					EndDo
				Else
					While AllTrim(cPedido) == AllTrim(SZ6->Z6_PEDGAR)
						If AllTrim(SZ6->Z6_TPENTID) == "8"					
							SZ6->( RecLock("SZ6",.F.) )
							SZ6->( DbDelete() )
							SZ6->( MsUnLock() )
						EndIf
						SZ6->(DbSkip())
					EndDo
				EndIf
			EndIf
			
			//Adiciona mais uma linha para calculo da Federação
			nQtdReg := 1
			
			For nX :=1 To nQtdReg
				Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) )
				For nJ := 1 To Len(aStrucSZ6)
					Do Case
						Case aStrucSZ6[nJ][2] == "C"
							aDadosSZ6[Len(aDadosSZ6)][nJ] := ""
						Case aStrucSZ6[nJ][2] == "N"
							aDadosSZ6[Len(aDadosSZ6)][nJ] := 0
						Case aStrucSZ6[nJ][2] == "D"
							aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//")
						Otherwise
							aDadosSZ6[Len(aDadosSZ6)][nJ] := ""
					Endcase
				Next nJ
			Next nX
			
			For nX := 1 To nQtdReg
				nZ	:=	nZ	+	1
				For nK := 1 To Len(aStrucSZ6)
					cCampo := AllTrim(aStrucSZ6[nK][1])
					Do Case
						Case cCampo == "Z6_FILIAL"
							aDadosSZ6[nZ][nK]	:= xFilial("SZ6")
						Case cCampo == "Z6_PERIODO"
							aDadosSZ6[nZ][nK]	:= cPeriodo
						Case cCampo == "Z6_TPENTID"
							aDadosSZ6[nZ][nK]	:= "8" //Tipo da Entidade
						Case cCampo == "Z6_CODENT"
							aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODENT," ")
						Case cCampo == "Z6_DESENT"
							aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_DESENT," ")
						Case cCampo == "Z6_PRODUTO"
							aDadosSZ6[nZ][nK]	:= cCodPro
						Case cCampo == "Z6_CATPROD"
							aDadosSZ6[nZ][nK]	:= IiF(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware
						Case cCampo == "Z6_DESCRPR"
							aDadosSZ6[nZ][nK]	:= cDesPro
						Case cCampo == "Z6_PEDGAR"
							aDadosSZ6[nZ][nK]	:= IiF(!lMidiaAvulsa,cPedido,"")
						Case cCampo == "Z6_DTPEDI"
							aDadosSZ6[nZ][nK]	:= dDtPed
						Case cCampo == "Z6_VERIFIC"
							aDadosSZ6[nZ][nK]	:= dDtVer
						Case cCampo == "Z6_VALIDA"
							aDadosSZ6[nZ][nK]	:= dDtVal
						Case cCampo == "Z6_DTEMISS"
							aDadosSZ6[nZ][nK]	:= dDtEmi
						Case cCampo == "Z6_TIPVOU"
							aDadosSZ6[nZ][nK]	:= cTipVou
						Case cCampo == "Z6_CODVOU"
							aDadosSZ6[nZ][nK]	:= "" //Nao grava no relatorio
						Case cCampo == "Z6_DESCVOU"
							aDadosSZ6[nZ][nK]	:= ""
						Case cCampo == "Z6_VLRPROD"
							aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValBSw,nValBHw)
						Case cCampo == "Z6_BASECOM"
							aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValtSw,nValtHw)
						Case cCampo == "Z6_VALCOM"
							aDadosSZ6[nZ][nK]	:= nValFed
						Case cCampo == "Z6_REGCOM"
							aDadosSZ6[nZ][nK]	:= "IMPORTACAO: " + DtoC(dDataBase) + " - " + Time()
						Case cCampo == "Z6_CODCAN"
							aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODCAN,"") //Nao grava no relatorio
						Case cCampo == "Z6_CODAC"
							aDadosSZ6[nZ][nK]	:= cCodAc
						Case cCampo == "Z6_CODAR"
							aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODGAR,"") //Nao grava no relatorio
						Case cCampo == "Z6_CODPOS"
							aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODGAR,"") //Nao grava no relatorio
						Case cCampo == "Z6_CODCCR"
							aDadosSZ6[nZ][nK]	:= Posicione("SZ3",7,xFilial("SZ3")+"9"+PADL(cDesCcr,100," "),"Z3_CODENT") //Nao grava no relatorio
						Case cCampo == "Z6_CCRCOM"
							aDadosSZ6[nZ][nK]	:= cDesCcr
						Case cCampo == "Z6_CODPAR"
							aDadosSZ6[nZ][nK]		:= Iif(lEntLoc,SZ3->Z3_CODPAR,"") //Nao grava no relatorio
						Case cCampo == "Z6_CODFED"
							aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODFED,"") //Nao grava no relatorio
						Case cCampo == "Z6_CODVEND"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_CODVEND,"")
						Case cCampo == "Z6_NOMVEND"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_NOMVEND,"")
						Case cCampo == "Z6_TIPO"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_TIPO,"")
						Case cCampo == "Z6_PEDSITE"
							aDadosSZ6[nZ][nK]	:= IiF(lMidiaAvulsa,cPedido,"")
						Case cCampo == "Z6_REDE"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_REDE,"")
						Case cCampo == "Z6_GRUPO"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_GRUPO,"")
						Case cCampo == "Z6_DESGRU"
							aDadosSZ6[nZ][nK]	:= cDesGru
						Case cCampo == "Z6_CODAGE"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_CODAGE,"") //Nao grava no relatorio
						Case cCampo == "Z6_NOMEAGE"
							aDadosSZ6[nZ][nK]	:= cAgVal
						Case cCampo == "Z6_AGVER"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_AGVER,"")
						Case cCampo == "Z6_NOAGVER"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_NOAGVER,"")
						Case cCampo == "Z6_NTITULA"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_NTITULA,"")
						Case cCampo == "Z6_DESREDE"
							aDadosSZ6[nZ][nK]	:= Iif(lRegLoc,SZ5->Z5_DESREDE,"")
						Case cCampo == "Z6_PEDORI"
							aDadosSZ6[nZ][nK]	:= cPedAnt
						Case cCampo == "Z6_VLRABT"
							aDadosSZ6[nZ][nK]	:= nValAbt
						Case cCampo == "Z6_ACLCTO"
							aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE
						Case cCampo == "Z6_ARLCTO"
							aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 							
					Endcase
				Next nK
			Next nX
		EndIf
	Elseif AllTrim(cTipo) == "7"
		//Tratamento para importar dados da visita externa.
		// 1 - AR/Posto									  |
		// 2 - Agente									  |
		// 3 - Quantidade/Visitas						  |
		// 4 - Valor Unitário 	 						  |
		// 5 - Valor Total 	 							  |
		// 6 - Valor de Repasse 	 					  |
		// 7 - OS 										  |  
		// 8 - Projeto									  |
		//------------------------------------------------/
		
		//Se o tamanho da linha estiver divergente pulo para o proximo registro.
		If Len(aLin) < 6
			FT_FSKIP()
			Loop
		EndIf
		
		//Leio os dados
		cCodEnt  := AllTrim(Upper(aLin[1])) //Desc. Entidade
		cAgVal	 := aLin[2] 	 //Nome Agente Validacao
		nQtdVis  := Val(aLin[3]) //Quantidade de Visitas
		nValBTot := Val(StrTran(StrTran(aLin[4],".",""),",",".")) //Valor Unitario
		nValtTot := Val(StrTran(StrTran(aLin[5],".",""),",",".")) //Valor Total
		nValCTot := Val(StrTran(StrTran(aLin[6],".",""),",",".")) //Valor Comissao
		cPedido	 := StrTran(aLin[7],"-","0") //Numero da OS 
		cProjeto :=  Iif(Len(aLin) > 7,aLin[8],"")
		
		//caso seja importado duas vezes a planilha, não apaga o conteúdo mesmo que não tenha OS.
		If AllTrim(cPedido) == "0" .Or. Empty(cPedido)
			cVisita:= Soma1(cVisita)
			cPedido:= cVisita
		EndIf
		
		//Limpa dados existente.
		SZ6->(DbSetOrder(1))
		If SZ6->(DbSeek(xFilial("SZ6")+PadR(cPedido,10," ")))
			While AllTrim(cPedido) == AllTrim(SZ6->Z6_PEDGAR)
				If AllTrim(SZ6->Z6_PRODUTO) == "VISITAEXTERNA" .AND. AllTrim(cCodEnt) == AllTrim(SZ6->Z6_DESENT)
					SZ6->( RecLock("SZ6",.F.) )
					SZ6->( DbDelete() )
					SZ6->( MsUnLock() )
				EndIf
				SZ6->(DbSkip())
			EndDo
		EndIf
		
		//Adiciona mais uma linha para calculo da Federação
		nQtdReg   := 1
		aDadosSZ6 := {}
		nZ		  := 0
		
		For nX :=1 To nQtdReg
			Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) )
			For nJ := 1 To Len(aStrucSZ6)
				Do Case
					Case aStrucSZ6[nJ][2] == "C"
						aDadosSZ6[Len(aDadosSZ6)][nJ] := ""
					Case aStrucSZ6[nJ][2] == "N"
						aDadosSZ6[Len(aDadosSZ6)][nJ] := 0
					Case aStrucSZ6[nJ][2] == "D"
						aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//")
					Otherwise
						aDadosSZ6[Len(aDadosSZ6)][nJ] := ""
				Endcase
			Next nJ
		Next nX
		
		
		//Me posiciono na entidade
		SZ3->(DbSetOrder(7))
		If SZ3->(DbSeek( xFilial("SZ3") +"9" + cCodEnt))
			lEntLoc := .T.
		Else
			FT_FSKIP()
			Loop
		EndIf
		
		cPeriodo := Iif(Empty(cPeriodo),AllTrim(GetMv("MV_REMMES")),cPeriodo)
		
		//Renato Ruy - 22/03/2018
		//Bloqueio de recalculo de faixa quando existe planilha ativa
		ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
		If ZZG->(DbSeek(xFilial("ZZG")+cPeriodo+SZ3->Z3_CODENT+"1"))
			//MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
			//Return	.F.
			RecLock("ZZG",.F.)
				ZZG->ZZG_ATIVO := "2"
			ZZG->(MsUnlock())
		Endif
		
		For nX := 1 To nQtdReg
			nZ	:=	nZ	+	1
			For nK := 1 To Len(aStrucSZ6)
				cCampo := AllTrim(aStrucSZ6[nK][1])
				Do Case
					Case cCampo == "Z6_FILIAL"
						aDadosSZ6[nZ][nK]	:= xFilial("SZ6")
					Case cCampo == "Z6_PERIODO"
						aDadosSZ6[nZ][nK]	:= Iif(Empty(cPeriodo),AllTrim(GetMv("MV_REMMES")),cPeriodo)
					Case cCampo == "Z6_TIPO"
						aDadosSZ6[nZ][nK]	:= "VISITA"
					Case cCampo == "Z6_TPENTID"
						aDadosSZ6[nZ][nK]	:= "B" //Tipo da Entidade
					Case cCampo == "Z6_CODENT"
						aDadosSZ6[nZ][nK]	:= SZ3->Z3_CODENT
					Case cCampo == "Z6_DESENT"
						aDadosSZ6[nZ][nK]	:= SZ3->Z3_DESENT
					Case cCampo == "Z6_PRODUTO"
						aDadosSZ6[nZ][nK]	:= "VISITAEXTERNA"
					Case cCampo == "Z6_DESGRU"
						aDadosSZ6[nZ][nK]	:= cProjeto
					Case cCampo == "Z6_CATPROD"
						aDadosSZ6[nZ][nK]	:= IiF(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware
					Case cCampo == "Z6_DESCRPR"
						aDadosSZ6[nZ][nK]	:= "VISITA EXTERNA"
					Case cCampo == "Z6_PEDGAR"
						aDadosSZ6[nZ][nK]	:= cPedido
					Case cCampo == "Z6_VLRPROD"
						aDadosSZ6[nZ][nK]	:= nValBTot
					Case cCampo == "Z6_BASECOM"
						aDadosSZ6[nZ][nK]	:= nValtTot
					Case cCampo == "Z6_VALCOM"
						aDadosSZ6[nZ][nK]	:= nValCTot
					Case cCampo == "Z6_REGCOM"
						aDadosSZ6[nZ][nK]	:= "IMPORTACAO: " + DtoC(dDataBase) + " - " + Time()
					Case cCampo == "Z6_CODCAN"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODCAN,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODAC"
						aDadosSZ6[nZ][nK]	:= cCodAc
					Case cCampo == "Z6_CODAR"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODGAR,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODPOS"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODGAR,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODCCR"
						aDadosSZ6[nZ][nK]	:= Iif(SZ3->Z3_TIPENT == "9", SZ3->Z3_CODENT, SZ3->Z3_CODCCR) //Caso a entidade seja um CCR gravo o codigo.
					Case cCampo == "Z6_CCRCOM"
						aDadosSZ6[nZ][nK]	:= Iif(SZ3->Z3_TIPENT == "9", SZ3->Z3_DESENT, SZ3->Z3_CCRCOM) //Caso a entidade seja um CCR gravo o nome.
					Case cCampo == "Z6_CODPAR"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODPAR,"") //Nao grava no relatorio
					Case cCampo == "Z6_CODFED"
						aDadosSZ6[nZ][nK]	:= Iif(lEntLoc,SZ3->Z3_CODFED,"") //Nao grava no relatorio
					Case cCampo == "Z6_NOMEAGE"
						aDadosSZ6[nZ][nK]	:= cAgVal
					Case cCampo == "Z6_CODAC"
						aDadosSZ6[nZ][nK]	:= Iif(Empty(cCodACAnt),cCodAc,cCodACAnt)
					Case cCampo == "Z6_CODAR"
						aDadosSZ6[nZ][nK]	:= IIf(Empty(cCodARAnt),Iif(lEntLoc,SZ3->Z3_CODGAR,""),cCodARAnt) //Nao grava no relatorio						
				Endcase
			Next nK
		Next nX
		
		//Solicitante: Priscila Kuhn
		//Zera valores dos projetos sem evidência
	Elseif AllTrim(cTipo) == "8"
		
		xBuff	:= alltrim(FT_FREADLN())
		aLin 	:= StrTokArr(xBuff,";")
		
		If aLin[1] >= "A" .Or. aLin[1] < "0" .Or. Len(aLin) < 2
			FT_FSKIP()
			Loop
		EndIf
		
		SZ6->(DbSetOrder(1))
		If SZ6->(DbSeek(xFilial("SZ6")+PADR(AllTrim(StrTran(aLin[1],"-"," ")),10," ") ))
		
			While SZ6->Z6_PEDGAR == PADR(AllTrim(StrTran(aLin[1],"-"," ")),10," ")

				//Yuri Volpe - 03/12/2018
				//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
				If Substr(AllTrim(SZ6->Z6_PRODUTO),1,4) != "IFEN"			
					//Renato Ruy - 22/03/2018
					//Bloqueio de recalculo de faixa quando existe planilha ativa
					ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
					If ZZG->(DbSeek(xFilial("ZZG")+SZ6->Z6_PERIODO+SZ6->Z6_CODCCR+"1"))
						//MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
						//Return	.F.
						
						RecLock("ZZG",.F.)
							ZZG->ZZG_ATIVO := "2"
						ZZG->(MsUnlock())
					Endif
				EndIf
				
				SZ6->(Reclock("SZ6",.F.))
				SZ6->Z6_VLRPROD	   := 0
				SZ6->Z6_BASECOM	   := 0
				SZ6->Z6_VALCOM	   := 0
				SZ6->Z6_VLRABT	   := 0
				If !(UPPER(aLin[2]) $ UPPER(SZ6->Z6_DESGRU))
					SZ6->Z6_DESGRU := AllTrim(SZ6->Z6_DESGRU) + " - " + aLin[2] 
				EndIf
				SZ6->(MsUnlock())
				SZ6->(DbSkip())
			EndDo
			
		EndIf
		//Solicitante: Priscila Kuhn - 12/01/2016
		//Marca como pedidos recebidos anteriormente.
	Elseif AllTrim(cTipo) == "9"
		
		//Leio a linha e gero array com os dados
		xBuff	:= alltrim(FT_FREADLN())
		
		//Faço tratamento para não gerar erro nas colunas
		While ";;" $ xBuff
			xBuff	:= StrTran(xBuff,";;",";-;")
		EndDo
		
		If SubStr(xBuff,len(xBuff),1) == ";"
			xBuff 	+= "-"
		EndIf
		
		aLin 	:= StrTokArr(xBuff,";")
		
		If Len(aLin) < 3 .Or. aLin[1] >= "A" .Or. Empty(aLin[1])
			FT_FSKIP()
			Loop
		EndIf
		
		//Grava tabela de vouchers IFEN.
		ZZ4->(DbSetOrder(1))
		If !ZZ4->(DbSeek(xFilial("ZZ4")+aLin[1]))
			//Grava um nova registro na ZZ4.
			GravaZZ4(aLin,.T.)
		Else
			//Atualiza registro na ZZ4.
			GravaZZ4(aLin,.F.)
		EndIf
	//Renato Ruy - 30/12/2016
	//Importacao de dados para novo clube do contador.
	Elseif AllTrim(cTipo) == "A"
		
		cPedido	 := Iif(Len(aLin) > 0,aLin[1],"") //Adiciona Pedido Gar
		cCodVen  := Iif(Len(aLin) > 1,aLin[2],"") //Adiciona Codigo do Vendedor
		cNomVen  := Iif(Len(aLin) > 2,aLin[3],"") //Adiciona Nome do Vendedor
		cCodEnt  := Iif(Len(aLin) > 3,aLin[4],"") //Adiciona Codigo do Parceiro
		cDesEnt  := Iif(Len(aLin) > 4,aLin[5],"") //Adiciona Nome do Parceiro
		
		SZ5->(DbSetOrder(1))
		If SZ5->(DbSeek(xFilial("SZ5")+cPedido))
		    
			//Verifica se o nome esta diferente e atualiza
			If AllTrim(Upper(cNomVen)) != AllTrim(Upper(SZ5->Z5_NOMVEND))
				
				//Atualiza dados da SZ5 - Origem de remuneracao, para em um recalculo nao danificar os dados
				SZ5->(Reclock("SZ5",.F.))
					SZ5->Z5_CODVEND	:= Iif(Empty(cCodVen),SZ5->Z5_CODVEND,cCodVen)
					SZ5->Z5_NOMVEND	:= Iif(Empty(cNomVen),SZ5->Z5_NOMVEND,cNomVen)
					SZ5->Z5_CODPAR	:= Iif(Empty(cCodEnt),SZ5->Z5_CODPAR ,cCodEnt)
					SZ5->Z5_NOMPAR	:= Iif(Empty(cDesEnt),SZ5->Z5_NOMPAR ,cDesEnt)
				SZ5->(Msunlock())
			Endif
		
		EndIf
		
		//Procuro registros de remuneracao
		SZ6->(DbSetOrder(1))
		If SZ6->(DbSeek(xFilial("SZ6")+cPedido))

			While !SZ6->(EOF()) .And. AllTrim(cPedido) == AllTrim(SZ6->Z6_PEDGAR)
			    //Somente faz a atualizacao para campanha e quando o nome é diferente.
				If AllTrim(SZ6->Z6_TPENTID) == "7" .And. AllTrim(cNomVen) != AllTrim(SZ6->Z6_NOMVEND)
					SZ6->(Reclock("SZ6",.F.))
				    	SZ6->Z6_CODVEND	:= Iif(Empty(cCodVen),SZ6->Z6_CODVEND,cCodVen)
						SZ6->Z6_NOMVEND	:= Iif(Empty(cNomVen),SZ6->Z6_NOMVEND,cNomVen)
						SZ6->Z6_CODENT	:= Iif(Empty(cCodEnt),SZ6->Z6_CODENT ,cCodEnt)
						SZ6->Z6_DESENT	:= Iif(Empty(cDesEnt),SZ6->Z6_DESENT ,cDesEnt)
					SZ6->(Msunlock())
				Endif
				SZ6->(DbSkip())
			Enddo
		
		Endif
	Elseif AllTrim(cTipo) == "B"
		//Tratamento para importar dados de valor extra sincor.
		// 1 - Entidade									  |
		// 2 - AC										  |
		// 3 - Tipo de Registro 						  |
		// 4 - Valor de Repasse 	 					  |
		//------------------------------------------------/
		
		//Se o tamanho da linha estiver divergente pulo para o proximo registro.
		If !AllTrim(aLin[3])$"E/D"
			FT_FSKIP()
			Loop
		EndIf
		
		//Leio os dados
		cCodEnt  := Iif(Val(aLin[1])>0,PadL(AllTrim(aLin[1]),6,"0"),aLin[1]) //Codigo Entidade
		cCodAC   := AllTrim(aLin[2]) //Codigo AC
		nValCTot := Val(StrTran(StrTran(aLin[4],".",""),",",".")) //Valor Comissao
		cMsgObs	 := If(Len(aLin) > 4, AllTrim(aLin[5]),"")
		
		SZ3->(DbSetOrder(1))
		If !SZ3->(DbSeek(xFilial("SZ3")+cCodEnt))
			Alert("A entidade Não foi encontrada, por favor verifique!")
			Loop
		Endif
		
		//Renato Ruy - 22/03/2018
		//Bloqueio de recalculo de faixa quando existe planilha ativa
		ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
		If ZZG->(DbSeek(xFilial("ZZG")+cPeriodo+cCodEnt+"1"))
			//MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
			//Return	.F.
			RecLock("ZZG",.F.)
				ZZG->ZZG_ATIVO := "2"
			ZZG->(MsUnlock())
		EndIf
		
		Reclock("SZ6",.T.)
			SZ6->Z6_PERIODO := cPeriodo
			SZ6->Z6_TIPO	:= Iif(AllTrim(aLin[3])=="E","EXTRA","DESCON")
			SZ6->Z6_PEDGAR  := Iif(AllTrim(aLin[3])=="E","EXTRA","DESCONTO")
			SZ6->Z6_PRODUTO := Iif(AllTrim(aLin[3])=="E","EXTRA","DESCONTO")
			SZ6->Z6_DESCRPR := Iif(AllTrim(aLin[3])=="E","VALOR EXTRA AR","DESCONTO VALOR EXTRA AR")
			SZ6->Z6_PEDGAR  := Iif(AllTrim(aLin[3])=="E","EXTRA","DESCONTO")
			SZ6->Z6_CODAC   := cCodAC
			SZ6->Z6_CODCCR  := cCodEnt
			SZ6->Z6_CODENT  := cCodEnt
			SZ6->Z6_DESENT  := Posicione("SZ3",1,xFilial("SZ3")+cCodEnt,"Z3_DESENT")
			SZ6->Z6_TPENTID := Iif(SZ3->Z3_TIPENT=="9","4",SZ3->Z3_TIPENT)
			SZ6->Z6_DESGRU	:= cMsgObs
			SZ6->Z6_CATPROD := "2"
			SZ6->Z6_VALCOM	:= nValCTot
		SZ6->(MsUnlock())
	//OTRS: 2017121810001714 - Priscila Kuhn
	//Importacao BV	
	Elseif AllTrim(cTipo) == "C"
		//Tratamento para importar dados de valor extra sincor.
		// 1 - Entidade								  |
		// 2 - AC										  |
		// 3 - Tipo de Registro 						  |
		// 4 - Valor de Repasse 	 					  |
		//------------------------------------------------/
		
		//Se o tamanho da linha estiver divergente pulo para o proximo registro.
		If LEN(aLin)!= 3
			FT_FSKIP()
			Loop
		EndIf
		
		//Ler os dados
		cPedido  := aLin[1] //Pedido Gar
		nValCSw  := Val(StrTran(StrTran(aLin[2],".",""),",",".")) //Valor Comissao SW
		nValCHw  := Val(StrTran(StrTran(aLin[3],".",""),",",".")) //Valor Comissao HW
		
		//Se o pedido Gar não e numero, pula registro
		If Val(cPedido) == 0
			FT_FSKIP()
			Loop
		EndIf
		
		SZ6->(DbSetOrder(1)) //Filial + Pedido Gar
		If SZ6->(DbSeek(xFilial("SZ6")+cPedido))
			While !SZ6->(EOF()) .And. AllTrim(SZ6->Z6_PEDGAR) == AllTrim(cPedido)
				//Somente efetua processo para AC
				If RTrim(SZ6->Z6_TPENTID) == "2"
				
					//Yuri Volpe - 03/12/2018
					//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
					If Substr(AllTrim(SZ6->Z6_PRODUTO),1,4) != "IFEN"
						//Renato Ruy - 22/03/2018
						//Bloqueio de recalculo de faixa quando existe planilha ativa
						ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
						If ZZG->(DbSeek(xFilial("ZZG")+SZ6->Z6_PERIODO+SZ6->Z6_CODENT+"1"))
							//MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
							//Return	.F.
							RecLock("ZZG",.F.)
								ZZG->ZZG_ATIVO := "2"
							ZZG->(MsUnlock())
						Endif
					EndIf
				
					SZ6->(Reclock("SZ6",.F.))
					If SZ6->Z6_CATPROD == "1" //Hardware
						SZ6->Z6_VALCOM := nValCHw
					Else 					  //Software
						SZ6->Z6_VALCOM := nValCSw
					Endif
					SZ6->(MsUnlock())
				Endif
				SZ6->(DbSkip())
			EndDo
		Endif
	//Yuri Volpe - 20.09.19
	//OTRS 2019080710003881 - Inclusão de linha para Portal de Assinatura
	ElseIf cTipo == "D"

		nValBase := 0
		cCodProd := ""
		cDescPrd := ""
		cPedSite := ""
		nValCom	 := 0
		cCodEnt  := ""
		cCodAC   := ""
		lLinha   := .T.		
		
		//Entidade (aLin[1]);AC (aLin[2]);Tipo (aLin[3]);ValorBase (aLin[4]);Produto (aLin[5]);DescProd (aLin[6]);PedSite (aLin[7]);ValComissao (aLin[8])
		//75594;AC;P;180,40;PA010002;Plano Pré Pago;9738952;27,06
		
		//Se o tamanho da linha estiver divergente pulo para o proximo registro.
		If !AllTrim(aLin[3]) $ "L|T"
			FT_FSKIP()
			Loop
		EndIf
		
		lLinha := AllTrim(aLin[3]) == "L" 
		
		//Leio os dados
		cCodEnt  := Iif(Val(aLin[1])>0,PadL(AllTrim(aLin[1]),6,"0"),aLin[1]) //Codigo Entidade
		cCodAC   := AllTrim(aLin[2]) //Codigo AC
		If lLinha
			nValBase := Val(StrTran(StrTran(aLin[4],".",""),",",".")) //Valor Produto e Valor Base
			cCodProd := Iif(!Empty(AllTrim(aLin[5])),AllTrim(aLin[5]),"")
			cDescPrd := NoAcento(Iif(!Empty(AllTrim(aLin[6])),AllTrim(aLin[6]),""))
			cPedSite := Iif(!Empty(AllTrim(aLin[7])),AllTrim(aLin[7]),"")
			nValCom	 := Val(StrTran(StrTran(aLin[8],".",""),",",".")) //Valor Produto e Valor Base
		Else
			nValCom	 := Val(StrTran(StrTran(aLin[4],".",""),",",".")) //Valor Produto e Valor Base
		EndIf
		
		If lLinha
			If Empty(cDescPrd)
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + cCodProd))
					cDescPrd := SB1->B1_DESC
				Else
					cDescPrd := "Produto Portal de Assinaturas"
				EndIf 
			EndIf
		EndIf
		
		SZ3->(DbSetOrder(1))
		If !SZ3->(DbSeek(xFilial("SZ3")+cCodEnt))
			Alert("A entidade Não foi encontrada, por favor verifique!")
			Loop
		Endif

		/*dbSelectArea("SZ6")
		SZ6->(dbSetOrder(4))
		If SZ6->(dbSeek(xFilial("SZ6") + cPedSite))
			RecLock("SZ6",.F.)
				dbDelete()
			SZ6->(MsUnlock())
		EndIf*/
				
		Reclock("SZ6",.T.)
			SZ6->Z6_PERIODO := cPeriodo
			SZ6->Z6_TIPO	:= "PORTAL"
			SZ6->Z6_PEDGAR	:= "PORTALASSI"
			SZ6->Z6_PRODUTO := cCodProd
			SZ6->Z6_DESCRPR := cDescPrd
			SZ6->Z6_CODAC   := cCodAC
			SZ6->Z6_CODCCR  := cCodEnt
			SZ6->Z6_CCRCOM	:= SZ3->Z3_DESENT
			SZ6->Z6_CODENT  := cCodEnt
			SZ6->Z6_DESENT  := SZ3->Z3_DESENT
			SZ6->Z6_TPENTID := Iif(AllTrim(SZ3->Z3_TIPENT) == "9", "4", SZ3->Z3_TIPENT)
			SZ6->Z6_CATPROD := "2"
			SZ6->Z6_VALCOM	:= nValCom
			SZ6->Z6_PEDSITE := cPedSite
			SZ6->Z6_REGCOM	:= DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(UsrRetName(RetCodUsr()))+"-"+FunName()+"-"+">>> (" + SZ3->Z3_CODENT + ") >>> (VALORES INFORMADOS) >>> (PORTAL DE ASSINATURAS)"
			SZ6->Z6_VLRPROD	:= nValBase
			SZ6->Z6_BASECOM := nValBase
		SZ6->(MsUnlock())
	EndIf
	
	If !(AllTrim(cTipo) $ "8/9/A/B/C")
		
		//Gravo dados
		Begin Transaction
		
		nTotReg  := 1
		nTamSZ6  := Len(aDadosSZ6)
		nStruSZ6 := Len(aStrucSZ6)
		nRecSZ5  := AllTrim( Str( SZ5->(Recno() ) ) )
		
		For nI := 1 To nTamSZ6
			SZ6->( RecLock("SZ6",.T.) )
			For nJ := 1 To nStruSZ6
				cCampo := AllTrim(aStrucSZ6[nJ,1])
				SZ6->( FieldPut( FieldPos( cCampo ), aDadosSZ6[nI, nJ] ) )
			Next nJ
			SZ6->Z6_RECORI := nRecSZ5
			If nTotReg > 5000
				SZ6->( MsUnLockAll() )
			EndIf
			nTotReg ++
		Next nI
		
		SZ6->( MsUnLockAll() )
		
		End Transaction
	EndIf
	
	FT_FSKIP()
EndDo

//Fecho o arquivo
FT_FUSE()

Return

Static Function RetCodEnt( cDesCcr )

Local cCodEnt 	:= ""
Local nRecSZ3	:= SZ3->( Recno() )
Local nOrdSZ3	:= SZ3->( IndexOrd() )

SZ3->( DbSetOrder( 7 ) )
SZ3->( DbSeek( xFilial( "SZ3" ) + "9" + cDesCcr ) )

cCodEnt := SZ3->Z3_CODENT

SZ3->( DbSetOrder( nOrdSZ3 ) )
SZ3->( DbGoTo( nRecSZ3 ) )

Return cCodEnt

//Importa dados do Gar para tabela de voucher IFEN.
Static Function GravaZZ4(aLin,lNovo)

Local oWSObj

Begin Sequence
// Busca os dados do pedido de GAR para atualizar o movimento
oWSObj := WSIntegracaoGARERPImplService():New()
IF oWSObj:findDadosPedido("erp","password123",Val(aLin[3]))
	
	If ZZ4->(Reclock("ZZ4",lNovo))
		
		//Se o pedido é novo, gravo codigo do pedido gar
		If lNovo
			ZZ4->ZZ4_PEDGAR := aLin[1]
		EndIf
		
		ZZ4->ZZ4_CODVOU := aLin[2]
		ZZ4->ZZ4_PEDANT := aLin[3]
		
		//Pedido GAR Anterior
		If ValType(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO) <> "U"
			ZZ4->ZZ4_PEDORI	:= Iif(Empty(ZZ4->ZZ4_PEDORI),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO)),ZZ4->ZZ4_PEDORI)
		EndIf
		
		//Data de Emissao do Pedido GAR
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO) <> "U"
			ZZ4->ZZ4_DATPED := Iif(Empty(ZZ4->ZZ4_DATPED),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO),1,10)),ZZ4->ZZ4_DATPED)
		EndIf
		
		//Data da Validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO) <> "U"
			ZZ4->ZZ4_DATVAL := Iif(Empty(ZZ4->ZZ4_DATVAL),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO),1,10)),ZZ4->ZZ4_DATVAL)
		EndIf
		
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO) <> "U"
			ZZ4->ZZ4_DATVER := Iif(Empty(ZZ4->ZZ4_DATVER),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO),1,10)),ZZ4->ZZ4_DATVER)
		EndIf
		
		//Data de Emissao do Pedido GAR
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO) <> "U"
			ZZ4->ZZ4_DATEMI := Iif(ZZ4->ZZ4_DATEMI < CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO),1,10)) + 1,CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO),1,10)) + 1,ZZ4->ZZ4_DATEMI)
		EndIf
		
		ZZ4->(MsUnlock())
		
	EndIf
Else
	Conout("GRAVAZZ4 - Erro ao conectar com WS IntegracaoERP. Pedido GAR " + Alltrim(aLin[3]) + " não atualizado")
Endif

DelClassIntF()
End Sequence



Return
