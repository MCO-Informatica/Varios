#INCLUDE "Totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA024    บ Autor ณ Renato Ruy	     บ Data ณ  12/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Faz atualiza็ใo de valores no lan็amento de remunera็ใo.   บฑฑ
ฑฑบ          ณ 					                      					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CRPA024


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local oDlg
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.
Private cTipMan
Private aTipo     := {"1=Nใo",;
					  "2=Sim"}

Private cPeriod	:= Space(6)
Private lZero	:= .F.

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Leitura de Dados do GAR e Atualiza็ใo via WebService" PIXEL

@ 10,010 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,070 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 22,040 SAY "Periodo: " OF oDlg PIXEL
@ 22,070 MSGET cPeriod   SIZE 40,5 OF oDlg PIXEL

@ 22,130 SAY "Retifica็ใo:" OF oDlg PIXEL
@ 22,160 ComboBox cTipMan Items aTipo Size 072,010 PIXEL OF oDlg

@ 45,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CRPA024A(@aDirIn,@cDirIn)
@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1
	Return(.F.)
EndIf

If cPeriod > "201507"
	MsgInfo("Este parโmetro ้ temporแrio e pode apenas ser usado em periodos inferiores a 201508.")
	Return(.F.)
EndIf

lZero	:= Iif(!Empty(cPeriod),.T.,.F.)
cPeriod := Iif(Empty(cPeriod),GetMv("MV_REMMES"),cPeriod)

If len(aDirIn) = 0
	MsgAlert("Nใo Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

//Proc2BarGauge({|| OkLeTxt(cDirIn,aDirIn) },"Processamento de Arquivo TXT")
Processa( {|| OkLeTxt(cDirIn,aDirIn) }, "Processamento de Arquivo TXT") 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP6 IDE            บ Data ณ  12/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkLeTxt(cDirIn,aDirIn)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abertura do arquivo texto                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local Ni

Private cArqTxt := ""
Private nHdl    := ""

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

For nI:= 1 to len(aDirIn)
	cArqTxt := cDirIn+aDirIn[nI][1]
	nHdl    := fOpen(cArqTxt,68)
	//	If nHdl == -1
	//    	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	//	Endif
	
	//IncProcG1("Proc. Arquivo "+aDirIn[nI][1])
	//ProcessMessage()
	
	IncProc( "Proc. Arquivo "+aDirIn[nI][1] )
	ProcessMessage()
	
	RunCont(aDirIn[nI][1])
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  12/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont(cArqcalc)

Local nTamFile, nTamLin, cBuffer, nBtLidos, xBuff, aLin, cTipLin
Local  nRecAtu 		:= 0
Local  cPedido 		:= ""
Local  cProduto		:= ""
Local  nValSoft		:= 0
Local  nValHard		:= 0
Local  cProjeto		:= ""
Local  cPosto		:= ""
Local  cPedTipo		:= ""
Local  cRecPost		:= ""
Local cCodPar		:= ""
Local cCodPosto		:= ""
Local cCodAR		:= ""
Local cCodAC		:= ""
Local cCodCanal		:= ""
Local cCodCanal2	:= ""
Local cCodFeder		:= ""
Local aStrucSZ6		:= SZ6->( DbStruct() )
Local aDadosSZ6		:= {}
Local nI			:= 0
Local nJ			:= 0
Local nK			:= 0
Local nX			:= 0
Local nZ			:= 0
Local cCampo		:= ""
Local cStEntid		:= ""
Local nBaseSw		:= 0
Local nValSw		:= 0
Local cRegSw		:= 0
Local nBaseHw		:= 0
Local nValHw		:= 0
Local cRegHw		:= ""
Local cTipoGar		:= GetMV("MV_TIPGAR") // VERIFI;EMISSA;HWAVUL;ENTMID;CAMPCO;CLUBRE
Local cCalcRem		:= ""
Local nQtdReg		:= 0
Local nQtd			:= 0
Local cFxCodEnt		:= ""
Local cChaveSZ4		:= ""
Local cFaixa		:= ""
Local lProdConta	:= .F.
Local lVoucher		:= .F.
Local lPed			:= .F.
Local nValorSw		:= 0
Local nValorHw		:= 0
Local nValSoft 		:= 0
Local nValHard 		:= 0
Local nValTot       := 0
Local nValTotHW     := 0
Local nValTotSW     := 0
Local nAbtCamH 	    := 0
Local nAbtCamS      := 0
Local cTipPar       := ""
Local cCodPar       := ""
Local cDesPar       := ""
Local nPorSfw		:= 0
Local nPorHdw		:= 0
Local cDescPrd		:= ""
Local cOABSP		:= "8DSAS6/GAOAB"//SuperGetMv("MV_OABSPCL",.F.,"")
Local nValOAB		:= 77.50//SuperGetMv("MV_VALOAB",.F.,77.50)
Local lMidiaAvulsa  := .F.
Local cAbateCcrAC	:= "" //Variแvel para gravar se abate CCR e GRUPO\Rede(AC) do Canal 1 e 2.
Local cAbateCamp	:= "" //Variแvel para gravar se campanha do contator do Canal 1 e 2.
Local cCalcIFEN		:= "" //Variavel para armazena se calcula o produto IFEN.
Local nAbtAR		:= 0  //Armazena Valor da CCR para abatimento
Local nAbtImp		:= 0  //Armazena Valor de abatimento do imposto
Local nAbtAC	:= 0  //Armazena Valor da AC para abatimento
Local dDataIRenov    := MV_PAR01 //Armazena data inicio para calculo da renova็ใo.
Local dDataFRenov    := MV_PAR02 //Armazena data fim para calculo da renova็ใo.
Local lProdCalc		:= .T. //Indica se efetua calculo para AC, Canal, Canal 2 e Remunera o dono do Produto.
Local cAcPropri		:= "" //Caso o produto seja especifico de uma AC, guarda entidade proprietแria.
Local cDescProd		:= ""
Local cPedGar		:= ""
Local lTemHard		:= .F.
Local nRecnoZ5		:= 0
Local lNaoPagou		:= .T.
Local nContador 	:= 0
Local cPedido		:= ""
Local nThread 		:= 0
Local aUsers		:= {}
Local aPedidos		:= {}
Local cVouAnt		:= ""
Local lCalcula		:= .T.
Private lLogErr		:= .F.
Private ltemFaixa   := .F.
Private cRemPer		:= GetMV("MV_REMMES")

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto gerado:                                บ
//ฬออออออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออน
//บCampo           ณ Inicio ณ Tamanho                               บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ ??_FILIAL     ณ 01     ณ 02                                    บ
//ศออออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออผ

FT_FUSE(cArqTxt)

nTotRec := FT_FLASTREC()
//BarGauge2Set( nTotRec )

FT_FGOTOP()

//Priscila Kuhn - 11/11/2015
//Grava arquivo utilizado na manutencao em lote
CpyT2S(cArqTxt,"\pedidosfaturados\GAR\LOG_MNT\",.F.)
//Informo quem fez e hora no arquivo
FRename("\pedidosfaturados\GAR\LOG_MNT\"+cArqcalc,"\pedidosfaturados\GAR\LOG_MNT\"+DtoS(dDatabase)+" "+StrTran(Time(),":","-")+"-"+AllTrim(cUserName)+".csv")

//IncprocG2( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
//ProcessMessage()
IncProc( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
ProcessMessage()

While !FT_FEOF()
	
	xBuff	:= alltrim(FT_FREADLN())
	aLin 	:= StrTokArr(xBuff,";")
	
	cPedido 	:= Iif(Len(aLin)>0,aLin[1],"ZZZZZZZZZZ")	   //aLin[1] = Pedido Gar
	nValSoft	:= Val(StrTran(Iif(Len(aLin)>1,aLin[2],"0"),",",".")) 	   //aLin[2] = Valor Software
	nValHard	:= Val(StrTran(Iif(Len(aLin)>2,aLin[3],"0"),",","."))  	           //aLin[3] = Valor Hardware
	//"G" = Pedido Gar e "S" Pedido Site
	cPedTipo	:= AllTrim(Iif(Len(aLin)>5,aLin[6],"")) 			   //aLin[6] = Atualiza Codigo Posto
	
	//Faz distribui็ใo e monitora a quantidade de thread em execu็ใo
	nThread := 0
	aUsers 	:= Getuserinfoarray()
	aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA020B",nThread++,nil )  })
	
	//Limita a quantidade de Threads.
	If nThread < 10
	 	
	 	nContador := 0
		aPedidos  := {}
		
		//Envio para processamento de 10 em 10 pedidos.
		While !FT_FEOF() .And. nContador <= 100
			
			//Leio a linha e gero array com os dados
			xBuff	:= alltrim(FT_FREADLN())
			aLin 	:= StrTokArr(xBuff,";")
			
			cPedido 	:= Iif(Len(aLin)>0,aLin[1],"ZZZZZZZZZZ")	   //aLin[1] = Pedido Gar
			nValSoft	:= Val(StrTran(Iif(Len(aLin)>1,aLin[2],"0"),",",".")) 	   //aLin[2] = Valor Software
			nValHard	:= Val(StrTran(Iif(Len(aLin)>2,aLin[3],"0"),",","."))  	           //aLin[3] = Valor Hardware
			//"G" = Pedido Gar e "S" Pedido Site
			cPedTipo	:= Iif(Len(aLin)>5,aLin[6],"") 			   //aLin[6] = Atualiza Codigo Posto
			lCalcula	:= .T.
			
			//Priscila Kuhn
			//Limita altera็ใo de valor para apenas alguns usuarios
			If !(Upper(AllTrim(cUserName)) $ GetMv("MV_XALTREM")) .And. (cPeriod >= "201508" .Or. Empty(cPeriod))
				nValSoft	:= 0
				nValHard	:= 0
			EndIf
			
			//Fa็o Tratamento para pedido site.
			If cPedTipo == "S"
				
				/*
				Ajustes de c๓digo para atender Migra็ใo versใo P12
				Uso de DbOrderNickName
				OTRS:2017103110001774
				*/
				DbSelectArea("SC5")
				DbOrderNickName("PEDSITE")
				
				If DbSeek( xFilial("SC5")+AllTrim(cPedido) )
					
					DbSelectArea("SZ5")
					DbSetOrder(3)
					If DbSeek(xFilial("SZ5") + SC5->C5_NUM)
					
						While AllTrim(SC5->C5_NUM) == AllTrim(SZ5->Z5_PEDIDO)
							Aadd(aPedidos,{SZ5->(RECNO())} )
							nContador += 1
							SZ5->(DbSkip())
						EndDo

					EndIf
					lCalcula := .F.
					
				EndIf
			
			ElseIf cPedTipo == "G"
				SZ5->(DbSetOrder(1))
				If !SZ5->( DbSeek( xFilial("SZ5") + PADR(AllTrim(StrTran( aLin[1] ,"-"," ")),10," ") ))
					lCalcula := .F.
				Else
					//Gravo dados do TXT para calculo
					If nValHard + nValSoft <> 0 .Or. lZero
						RecLock("SZ5",.F.)
						SZ5->Z5_VALORSW := nValSoft //Somente atualizaremos os valores com dados do sistema
						SZ5->Z5_VALORHW := nValHard //Somente atualizaremos os valores com dados do sistema
						SZ5->Z5_VALOR   := nValHard + nValSoft
						SZ5->(MsUnLock())
					EndIf	
				EndIf
			ElseIf Empty(cPedTipo)
				MsgInfo("Por favor revise o modelo de importacao, os tipos dos pedidos nใo estใo preenchidos!")
				Return
			Else
				lCalcula := .F.
			EndIf
			
			
			//Se nใo estiver vazio adiciono no array
			If lCalcula
				Aadd(aPedidos,{SZ5->(RECNO())} )
				nContador += 1
			EndIf
			
			//Pulo para a pr๓xima linha.
			//IncprocG2( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
			//ProcessMessage()
			IncProc( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
			ProcessMessage()
			
			FT_FSKIP()
		EndDo
		
		//Envio o conte๚do para Thread se o array for maior que um
		If Len(aPedidos) > 0
		    StartJob("U_CRPA020B",GetEnvServer(),.F.,'01','02',aPedidos,"CRPA024",cUserName,cPeriod,cTipMan)
			//U_CRPA020B('01','02',aPedidos,"CRPA024",cUserName,cPeriod,cTipMan)  //Fazer Debug no calculo
		EndIf
		
	EndIf 
	
	//Gerou erro ao fazer varias vezes a consulta da thread - Getuserinfoarray.
	If nThread >= 10
		Sleep( 20000 )	
	EndIf
	
Enddo

FT_FUSE()
fClose(nHdl)

MsgInfo("Os registros foram recalculados com sucesso")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CRPA024A(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.CSV")

Return(.T.)
