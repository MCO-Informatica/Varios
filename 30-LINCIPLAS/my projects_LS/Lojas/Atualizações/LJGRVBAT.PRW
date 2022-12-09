#INCLUDE "FILEIO.CH"
#INCLUDE "rwmake.CH"
#include "FiveWin.ch"
#INCLUDE "TOPCONN.CH"//AWR - 16/01/2006
#include "tbiconn.ch"      
#include "easytec.ch"        
#include "average.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE _CRLF CHR(13)+CHR(10)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LjGrvBatch³ Autor ³ Vendas Clientes       ³ Data ³ 22/09/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava em processo batch o com base no SL1, SL2, SL4.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Front Loja / Siga Loja                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                     
Static __lNoErro // Variavel nao deve ser removida !!!
Static lxProxNum,lFProxNum
Static __lD1D2D3  := .F.
Static cMoeda330C := SuperGetMv('MV_MOEDACM',.F.,"2345") // Moedas para calculo do custo medio - Sempre processa moeda 1
 // Produtos a serem verificados no log de diferenca de saldo - Deve ser colocado "/" apos cada produto para separacao dos codigos
Static cProdutoLog:= SuperGetMv('MV_PRODLOG',.F.,"")    


User Function ljGrvBatch( cEmp, cFilTrab , cIntervalo )
Local nHandle							// Indica se o arquivo foi criado
Local aFiles							// Arquivos
Local nIntervalo := 0					// Intervalo para o Loop
Local nTimes	 := 0					// Numero de loop antes de entrar no while		
Local lRetValue  := .T.            		// Retorno da função 
Local aFiliais   := {}               	// Filiais
Local aBadRecno  := {}					// Recnos 
Local cFileName							// Nome do arquivo 
Local nCount := 1						// Contador
Local cTemp								// Temporario
Local lExProc := .T.					// Controla o while do Killapp 


While nCount <= Len( cFilTrab )
	
	cTemp := ""
	While Substr( cFilTrab, nCount, 1 ) <> "," .AND. nCount <= Len( cFilTrab )
		cTemp += SUBSTR( cFilTrab, nCount, 1 )
		nCount++
	End
	
	AADD( aFiliais, { cTemp } )
	nCount++
	
End

nCount := 1


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variavel lExProc inicializada como True³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !KillApp() .AND. lExProc
	cFileName := cEmp + aFiliais[ nCount ][1]
	If ( nHandle := MSFCreate("LJGR"+cFileName+".WRK") ) >= 0
		ConOut("LJGrvBatch: "+STR0075 + cEmp + STR0076 + aFiliais[ nCount ][1])  // "Empresa:" ### " Filial:"
		ConOut("            "+STR0021)  //"Iniciando processo de gravacao batch..."
		RPCSetType(3)  // Nao comer licensa
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL aFiliais[ nCount ][1] TABLES "MAL", "SLI", "SL1", "SL2", "SL4", "SA1", "SA2", "SA3", "SA6", "SAE",;
		"SB1", "SB2", "SB3", "SC7", "SE1", "SE3", "SE4", "SE5", "SE8", "SED", "SEF", "SES", "SD1", "SD2", "SF1", "SF2","SF3", "SF4", "SF7", "SFC", "SM2", "MAH"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Todos os arquivos devem ser abertos antes de entrar no Begin Transaction.    ³
		//³Caso exista customizacao, os arquivos devem ser abertos neste PE.            ³
		//³OBS: O ADSSERVER nao permite uso da ChkFile() dentro de um Begin Transaction.³
		//³Em outros ambientes, este problema nao ocorre.                               ³
		//³Retornar um array, por exemplo {"SZ1", "SZ2"}                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("LJGRVOPEN")
			aFiles := ExecBlock("LJGRVOPEN", .F., .F.)
			RPCOpenTables(aFiles)
		EndIf
		
		SL1->(DbSetOrder(9))
		
		While SL1->(DbSeek(xFilial("SL1")+"RX"))
			If ( nPos := ASCAN( aBadRecno, SL1->( Recno() ) ) ) > 0
				While SL1->L1_FILIAL == xFilial("SL1") .AND. SL1->L1_SITUA == "RX" .AND. ;
					( ASCAN( aBadRecno, SL1->( Recno() ) ) > 0 )
					SL1->( DbSkip() )
				End
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Protejo situação de todos os orcamentos "RX" estarem em aBadRecno, neste    ³
			//³ caso não devo processar o proximo (que eh eof), mas sim abandonar o Loop    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SL1->L1_SITUA <> 'RX'
				Exit
			EndIf
			If LjGrvTudo(.F.)
				FRTProcSZ()
				If ( nTimes > 30 ) .OR. ( nIntervalo == 30000 )
					
					If File("LJGR"+cFileName+".FIM")
						
						ConOut("            "+STR0023) 	//"Solicitacao para finalizar gravacao batch atendida..."					

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Somente apaga o arquivo quando existir³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						FErase("LJGR"+cFileName+".FIM")	
						lExProc := .F.
						Exit
					EndIf
					nTimes := 0
				EndIf
				
				nIntervalo := 0
				nTimes++
				
			Else
				ConOut("LJGrvBatch: "+ STR0079 + aFiliais[ nCount ][1] + ". "+STR0022) // "Filial " ### ". " "Ocorreu algum erro no processo de gravacao batch..."
				AADD(aBadRecno, SL1->(Recno()) )
			EndIf
			
			SL1->(DbSetOrder(9))
			
		End
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄa¿
		//³Checa se o arquivo existe fora so while do SL1 para apagar quando não existir RX no SL1 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄaÙ
			
		If ( nTimes > 30 ) .OR. ( nIntervalo == 30000 )
			If File("LJGR"+cFileName+".FIM")
				ConOut("            "+STR0023) //"Solicitacao para finalizar gravacao batch atendida..."
				FErase("LJGR"+cFileName+".FIM")
				Exit
			EndIf
			nTimes := 0
		EndIf
		
		nIntervalo := 0
		nTimes++
		aBadRecno  := {}
		
		RESET ENVIRONMENT
		
		nIntervalo := 30000
		
		If ( nIntervalo > 0 )
			Sleep(nIntervalo)
		EndIf
		
		FClose(nHandle)
		FErase("LJGR"+cFileName+".WRK")
		
		ConOut("            "+STR0075 + cEmp + STR0076 + aFiliais[ nCount ][1]+" - "+STR0024) //""Empresa:" ### " Filial: - Processo de gravacao batch finalizado..."
		
	Else
		ConOut(Repl("*",40)+Chr(10)+Chr(10))
		ConOut("LJGrvBatch: "+STR0075 + cEmp + STR0076 + aFiliais[ nCount ][1])  // "Empresa:" ### " Filial:"
		ConOut("            "+STR0018)  //"Processo de gravacao batch ja estava rodando"
		
		lRetValue := .F.
		Exit
	EndIf
	If nCount < LEN( aFiliais )
		nCount := nCount + 1
	Else
		nCount := 1
	EndIf
	
End
FClose(nHandle)
FErase("LJGR"+cFileName+".WRK")

Return ( lRetValue )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PegaCMAtu³ Autor ³ Eveli Morasco         ³ Data ³ 09/12/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Devolve array com os 05 custos medios atuais               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := PegaCMAtu(ExpC1,ExpC2)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 = Array com os 05 custos medios possiveis            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser pesquisado                 ³±±
±±³          ³ ExpC2 = Codigo do local a ser pesquisado                   ³±±
±±³          ³ ExpC3 = Tipo de Nota de Saida ( D = Devolucao de Compras)  ³±±
±±³          ³ ExpA2 = Array a ser enviado para ExpC3 = "D"               ³±±
±±³          ³ ExpL1 = Indica se a nota e uma devolucao de Compra         ³±±
±±³          ³ ExpL2 = Indica se deve retornar o custo de reposicao       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function PegaCMAtu(cCodProd,cLocal,cTipo,aCusRec,lDevComp,lCusRep)
LOCAL nX,aCM[05],aVatu[05],aAux
LOCAL nDec:=Set(3,8)

DEFAULT lCusRep := .F.      

cTipo := IF(cTipo==NIL," ",cTipo)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria registro quando nao existir                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB2")
If xFilial("SB2")+cCodProd+cLocal <> SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL
	dbSetOrder(1)
	If ( !MsSeek(xFilial("SB2")+cCodProd+cLocal) )
		CriaSB2(cCodProd,cLocal)
	EndIf
EndIf
IF cTipo == "D"
	aAux := { aCusrec }
	aAux := RetCusEnt( ,aAux , , lDevComp)
	aCM  := aAux[1]
Else
	If lCusRep
		aCM[01] := B2_CMRP1
		aCM[02] := B2_CMRP2
		aCM[03] := B2_CMRP3
		aCM[04] := B2_CMRP4
		aCM[05] := B2_CMRP5
	Else
		aCM[01] := B2_CM1
		aCM[02] := B2_CM2
		aCM[03] := B2_CM3
		aCM[04] := B2_CM4
		aCM[05] := B2_CM5
		If !IsProdMod(cCodProd)
			aVatu[01] := B2_VATU1
			aVatu[02] := B2_VATU2
			aVatu[03] := B2_VATU3
			aVatu[04] := B2_VATU4
			aVatu[05] := B2_VATU5
			For nX := 1 to 5
				If B2_QATU > 0 .And. aVatu[nX] > 0
					aCM[nX] := aVatu[nX]/B2_QATU
				Else
					If SuperGetMV("MV_CUSZERO") == "S"
						aCM[nX] := 0
					EndIf
				EndIf
			Next nX
		EndIf
	EndIf	
EndIf
Set(3,nDec)
Return aCM

// _________________________________________________________


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³B2AtuComD1³ Autor ³ Eveli Morasco         ³ Data ³ 19/01/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o saldo atual do SB2 (VATU) baseado no SD1        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ B2AtuComD1(ExpN1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Expressao numerica indicando se movimentacao soma  ³±±
±±³          ³         ou subtrai                                         ³±±
±±³          ³ ExpC1 = Numero do Skip-Lote                                ³±±
±±³          ³ ExpC2 = Alias do SD1 (i.e.: quando usa QUERY)              ³±±
±±³          ³ ExpL1 = Inverte o Tipo de Entrada/Saida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION B2AtuComD1(nMultiplic, cSkipLote,  cAliasSD1, lInverte)
Static lMTAB2D1  := ExistBlock('MTAB2D1')
Static lMTAB2D1R := ExistBlock('MTAB2D1R')
Static lMTAATUD1 := ExistBlock("MTAATUD1")
Local nDec       := Set(3,8)
Local nX         := 0
Local aVAtu      := Array(5)
Local aCM        := Array(5)
Local cHelp      := ""
Local cValue     := ""
Local cChave     := SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD
Local cD1VTES    := ''
Local lSeekSB1   := .F.
Local nSALDOSB2  := 0
Local cLocCQ	 := SuperGetMV('MV_CQ',.F.,"98")
Local cLocaliz	 := Nil
Local cNumSerie	 := Nil
Local aSldAnt    := {}
Local aLogMov    := {}
Local dDtFabric  := dDataBase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel usada para identificar se usuario permite que o ³
//³ estoque fique negativo. Se permitir, a variavel vale .T. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lEstNeg:=IF(SuperGetMV("MV_ESTNEG")=="S",.T.,.F.)
Local oFactory	:= Nil
Local oAdapter	:= Nil

Default cAliasSD1  := 'SD1'
Default lInverte   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!") //"Atualizar SIGACUS.PRW !!!"
EndIf
If !(FindFunction("SIGACUSB_V") .And. SIGACUSB_V() >= 20070507)
	Final("Atualizar SIGACUSB.PRX !!!") //"Atualizar SIGACUSB.PRX !!!"
EndIf

cD1VTES := If(lInverte,"999",(cAliasSD1)->D1_TES)

If cD1VTES > "500"
	nMultiplic := -1
Else
	nMultiplic := IF(nMultiplic==NIL, 1, nMultiplic)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a existencia do campo D1_DFABRIC              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SD1->(FieldPos("D1_DFABRIC")) > 0
	dDtFabric := SD1->D1_DFABRIC
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no produto a ser atualizado                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
lSeekSB1:=MsSeek(xFilial("SB1")+SD1->D1_COD+SD1->D1_LOCAL)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada Executado ANTES da atualizacao do SB2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTAB2D1
	ExecBlock("MTAB2D1",.F.,.F.,{SD1->D1_COD, SD1->D1_LOCAL, nMultiplic})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da LogMov para verificar o saldo antes da     |
//| atualizacao das tabelas SB2/SBF/SB8                   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Rastro(SD1->D1_COD) .Or. Localiza(SD1->D1_COD)
	LogMov('SD1',,,,,,lInverte,cAliasSD1,,.T.,@aSldAnt)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no local a ser atualizado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB2")
dbSetOrder(1)
If !MsSeek(xFilial("SB2")+SD1->D1_COD+SD1->D1_LOCAL, .F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao existir , ele cria                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CriaSB2(SD1->D1_COD,SD1->D1_LOCAL)
	RecLock("SB2",.F.)
Else
	RecLock("SB2",.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o custo do campo e soma o custo da entrada       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVAtu[01] := B2_VATU1 + SD1->D1_CUSTO  * nMultiplic
aVAtu[02] := B2_VATU2 + SD1->D1_CUSTO2 * nMultiplic
aVAtu[03] := B2_VATU3 + SD1->D1_CUSTO3 * nMultiplic
aVAtu[04] := B2_VATU4 + SD1->D1_CUSTO4 * nMultiplic
aVAtu[05] := B2_VATU5 + SD1->D1_CUSTO5 * nMultiplic

If (B2_QATU+(SD1->D1_QUANT * nMultiplic)) < 0
	If !lEstNeg
		cValue:=Transform((B2_QATU+(SD1->D1_QUANT * nMultiplic)),PesqPictQt("B2_QATU",14))
		cHelp:=AllTrim(B2_COD)+"/"+B2_LOCAL+", Saldo: "+ALLTRIM(cValue)+")."	//", Saldo: "
		If ( Type("l103Auto") == "U" .Or. !l103Auto )
			Help ( " ", 1, "MVESTNEG",,cHelp,3,1)
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia e-mail ref. a SALDO NEGATIVO NO ESTOQUE - 002³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSeekSB1
		MEnviaMail("002",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD1->D1_QUANT * nMultiplic)),lEstNeg})
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se envia e-mail ref. PONTO DE PEDIDO - 001³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSeekSB1 .And. !(SB2->B2_LOCAL == cLocCQ) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_EMIN")) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	nSALDOSB2 := (SALDOSB2(.T.,,dDataBase))+SB2->B2_SALPEDI+SB2->B2_QACLASS     
if SB2->B2_XTRANSI < 0 
	SB2->B2_XTRANSI:=0 
ELSE 
	SB2->B2_XTRANSI:=SB2->B2_XTRANSI 
endif

	nSALDOSB2 := (SALDOSB2(.T.,,dDataBase))+SB2->B2_XTRANSI+SB2->B2_QACLASS
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para validar saldo em TODOS os armazens³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMTAATUD1
		nSALDOSB2 := ExecBlock('MTAATUD1',.F.,.F.)
		nSALDOSB2 := IIf(Valtype(nSALDOSB2) <> "N", 0, nSALDOSB2)					
	EndIf
	
	If (nSALDOSB2 + (SD1->D1_QUANT * nMultiplic)) <= RetFldProd(SB1->B1_COD,"B1_EMIN")
		MEnviaMail("001",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(nSALDOSB2 + (SD1->D1_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_EMIN")})
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se envia e-mail ref. ESTOQUE MAXIMO  - 029³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_EMAX"))
	If (B2_QATU + (SD1->D1_QUANT * nMultiplic)) >= RetFldProd(SB1->B1_COD,"B1_EMAX")
		MEnviaMail("029",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD1->D1_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_EMAX")})
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se envia e-mail ref. LOTE MINIMO/QTDE EMBALAGEM  - 045³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SG1->(DbSetOrder(1))
If SG1->(DbSeek(xFilial('SG1')+SB1->B1_COD))
	If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_LM"))
		If (B2_QATU + (SD1->D1_QUANT * nMultiplic)) <= RetFldProd(SB1->B1_COD,"B1_LM")
			MEnviaMail("045",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD1->D1_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_LM")})
		EndIf
	EndIf
Else 
	If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_QE"))
		If (B2_QATU + (SD1->D1_QUANT * nMultiplic)) <= RetFldProd(SB1->B1_COD,"B1_QE")
			MEnviaMail("045",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD1->D1_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_QE")})
		EndIf
	Endif
EndIf

REPLACE	B2_QATU WITH B2_QATU + (SD1->D1_QUANT * nMultiplic)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Movimenta Lotes/Sub-Lotes/Localizacao Fisica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Rastro(SD1->D1_COD) .Or. Localiza(SD1->D1_COD)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca detalhes da localizacao e do numero de serie quando³
	//³trata-se de uma devolucao                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IsInCallStack("LOJA720") .AND. FindFunction("Lj720RecD2")
		RetLocaliz(@cLocaliz,@cNumSerie)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SD1 na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SD1->(FkCommit())
	MovLote("SD1",;				//1
			SD1->D1_COD,;		//2
			SD1->D1_LOCAL,;		//3
			If((cPaisLoc<>"BRA") .And. (SD1->(fieldpos("D1_LOCALIZ")))>0,SD1->D1_LOCALIZ,cLocaliz ),;	//4
			If((cPaisLoc<>"BRA") .And. (SD1->(fieldpos("D1_NUMSERI")))>0,SD1->D1_NUMSERI,cNumSerie),;	//5
			SD1->D1_LOTECTL,;	//6
			SD1->D1_NUMLOTE,;	//7
			SD1->D1_NUMSEQ,;	//8
			cD1VTES,;         	//9
			SD1->D1_FORNECE,;	//10
			SD1->D1_LOJA,;		//11
			SD1->D1_LOTEFOR,;	//12
			"NF",;				//13
			cChave,;			//14
			SD1->D1_DOC,;		//15
			SD1->D1_SERIE,;		//16
			SD1->D1_OP,;		//17
			NIL,;				//18
			NIL,;				//19
			NIL,;				//20
			NIL,;				//21
			SD1->D1_QUANT,;		//22
			SD1->D1_QTSEGUM,;	//23
			SD1->D1_DTDIGIT,;	//24
			SD1->D1_DTVALID,;	//25
			NIL,;				//26
			NIL,;				//27
			cD1VTES>"500",;   	//28
			.T.,;				//29
			cD1VTES<="500",; 	//30
			NIL,;				//31
			NIL,;				//32
			NIL,;				//33
			NIL,;				//34
			NIL,;				//35
			NIL,;				//36
			NIL,;				//37
			NIL,;				//38
			NIL,;				//39
			NIL,;				//40
			NIL,;				//41
			NIL,;				//42
			NIL,;				//43
			NIL,;				//44
			NIL,;				//45
			NIL,;				//46
			NIL,;				//47
			NIL,;				//48
			NIL,;				//49
			SD1->D1_POTENCI,; 	//50
			NIL,;				//51
			NIL,;				//52
			NIL,;				//53
			NIL,;				//54
			NIL,;				//55
			@aLogMov,;         	//56
			dDtFabric)			//57
	LogMov('SD1',,,,,,lInverte,cAliasSD1,,,aClone(aSldAnt),aClone(aLogMov),,0,SD1->D1_QUANT)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava campo referente a 2a. Unidade de Medida          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SB2",.F.)
If Empty(SB1->B1_CONV) .And. !Empty(SD1->D1_QTSEGUM)
	REPLACE	B2_QTSEGUM WITH B2_QTSEGUM + SD1->D1_QTSEGUM * nMultiplic
ElseIf !Empty(SB1->B1_CONV)
	REPLACE B2_QTSEGUM WITH B2_QTSEGUM + SB1->(ConvUm(SB1->B1_COD,SD1->D1_QUANT,SD1->D1_QTSEGUM,2)* nMultiplic)
EndIf

// Verifica as divergencias entre a quantidade da primeira e da segunda UM
MatQtdZero(.T.,.F.,.T.)

REPLACE	B2_VATU1 WITH aVAtu[01]
REPLACE B2_VATU2 WITH aVAtu[02]
REPLACE	B2_VATU3 WITH aVAtu[03]
REPLACE B2_VATU4 WITH aVAtu[04]
REPLACE	B2_VATU5 WITH aVAtu[05]

aCM[01] := B2_CM1
aCM[02] := B2_CM2
aCM[03] := B2_CM3
aCM[04] := B2_CM4
aCM[05] := B2_CM5

For nX := 1 to 5
	If B2_QATU > 0 .And. aVAtu[nX] > 0
		aCM[nX] := aVAtu[nX]/B2_QATU
	EndIf
Next nX

REPLACE	B2_CM1 WITH aCM[01]
REPLACE B2_CM2 WITH aCM[02]
REPLACE	B2_CM3 WITH aCM[03]
REPLACE B2_CM4 WITH aCM[04]
REPLACE	B2_CM5 WITH aCM[05]
Set(3,nDec)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o custo unificado ON-LINE                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
B2AtuUnif(SB2->B2_COD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o custo FIFO ON-LINE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction("B2AtuFIFO")
	B2AtuFIFO("SD1",nMultiplic)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se houver integração com outros softwares (Framework do SIGALOJA).³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction("LOJA2164") .And. SuperGetMv("MV_LJGRINT",.F., .F.) == .T. .And. AliasInDic("MD0")
	oFactory := LJCAdapXmlEnvFactory():New( )	// Cria a fabrica de Adaptadores de envio
	oAdapter := oFactory:Create( "SB2" )

    oAdapter:Inserir( "SB2", xFilial( "SB2" ) + SB2->B2_COD + SB2->B2_LOCAL, "1", "4" )
    oAdapter:Gerar()
	oAdapter:Finalizar()
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MTAB2DIR - Ponto de entrada APOS execucao da funcao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTAB2D1R
	ExecBlock("MTAB2D1R",.F.,.F.,{SD1->D1_COD, SD1->D1_LOCAL, nMultiplic})
EndIf

Return
//________________________________________________________




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³B2AtuComD2³ Autor ³ Eveli Morasco         ³ Data ³ 28/12/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o saldo final (VATU) com os dados do SD2          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ B2AtuComD2(ExpA1,ExpN1,ExpA2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os custos gravados no SD2                ³±±
±±³          ³ ExpN1 = Expressao numerica indicando se movimentacao soma  ³±±
±±³          ³         ou subtrai                                         ³±±
±±³          ³ ExpA2 = Array para atualizar SDC a partir do SC9           ³±±
±±³          ³         Array aArraySC9                                    ³±±
±±³          ³         1 Pedido                                           ³±±
±±³          ³         2 Item do Pedido                                   ³±±
±±³          ³         3 Seq. Liberacao                                   ³±±
±±³          ³         4 Quantidade                                       ³±±
±±³          ³ ExpL1 = Expressao que indica se baixa empenho/reserva      ³±±
±±³          ³ ExpN2 = Forca a acao para tomar quando se apaga uma saida  ³±±
±±³          ³         com localizacao fisica (Sobrepoe o parametro       ³±±
±±³          ³         MV_PDEVLOC)                                        ³±±
±±³          ³ ExpC1 = Alias utilizado na baixa do empenho (MovLote)      ³±±
±±³          ³ ExpL2 = Inverte o Tipo de Entrada/Saida                    ³±±
±±³          ³ ExpL3 = Indica se a rotina e' chamada pelo modulo SIGALOJA ³±±
±±³          ³ ExpC2 = Numero do pedido - reserva                         ³±±
±±³          ³ ExpC3 = Numero do item                                     ³±±
±±³          ³ ExpC4 = Numero da sequqencia                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static FUNCTION B2AtuComD2(aCusto	, nMultiplic , aArraySC9, lBaixaEmp	,;
					nPdevLoc, cAliasBaixa, lInverte , lLoja		,;
					cParmPed, cParmItem	 , cParmSeq)
					
Static lMTAB2D2  := ExistBlock('MTAB2D2')  
Static lMTAB2D2R := ExistBlock('MTAB2D2R') 
Static lMTAATUD2 := ExistBlock("MTAATUD2")  

Local nDec      := Set(3,8)
Local cChave    := SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD
Local lSeekSB1  := .F.
Local nSALDOSB2 := 0
Local nQtdeSC9  := 0
Local nX,aVAtu[05],aCM[05]
Local cD2VTes
Local cLocCQ	:= SuperGetMV('MV_CQ')
Local cPedido	:= ""					//Numero do pedido gerado pelo SIGALOJA (código da reserva)
Local cItem		:= ""					//Codigo do item
Local cSeq		:= ""					//Codigo da sequencia	
Local aSldAnt   := {}
Local aLogMov   := {}
Local lUsaD2DIG    := IIF(FindFunction("UsaD2DTDIG"), UsaD2DTDIG(), .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel usada para identificar se usuario permite que o ³
//³ estoque fique negativo. Se permitir, a variavel vale .T. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lEstNeg   := IF(GETMV("MV_ESTNEG")=="S",.T.,.F.)
Local oFactory	:= Nil
Local oAdapter	:= Nil

DEFAULT lInverte    := .F.
DEFAULT cAliasBaixa := "SC6"
DEFAULT lLoja		:= .F.
DEFAULT cParmPed	:= ""
DEFAULT cParmItem	:= ""
DEFAULT cParmSeq	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V")	.And. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!") //"Atualizar SIGACUS.PRW !!!"
EndIf
If !(FindFunction("SIGACUSB_V")	.And. SIGACUSB_V() >= 20060927)
	Final("Atualizar SIGACUSB.PRX !!!") //"Atualizar SIGACUSB.PRX !!!"
EndIf

cD2VTes := IIF(lInverte,"1"+Subs(SD2->D2_TES,2), SD2->D2_TES)

lBaixaEmp:=If(ValType(lBaixaEmp) == "L",lBaixaEmp,.T.)

If cD2VTes > "500"
	nMultiplic := IF(nMultiplic==NIL, -1, nMultiplic)
Else
	nMultiplic := 1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no produto a ser atualizado                 ³
//³ e atualiza a data de consumo inicial                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
lSeekSB1:=MsSeek(xFilial("SB1")+SD2->D2_COD+SD2->D2_LOCAL)
If lSeekSB1
	B2AtuConIn(nMultiplic,SD2->D2_EMISSAO)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada Executado ANTES da atualizacao do SB2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTAB2D2
	ExecBlock("MTAB2D2",.F.,.F.,{SD2->D2_COD, SD2->D2_LOCAL, nMultiplic})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da LogMov para verificar o saldo antes da     |
//| atualizacao das tabelas SB2/SBF/SB8                   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Rastro(SD2->D2_COD) .Or. Localiza(SD2->D2_COD)
	LogMov('SD2',,,,,,lInverte,,,.T.,@aSldAnt)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no local a ser atualizado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB2")
If xFilial("SB2")+SD2->D2_COD+SD2->D2_LOCAL <> SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL
	dbSetOrder(1)
	If !MsSeek(xFilial("SB2")+SD2->D2_COD+SD2->D2_LOCAL)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao existir , ele cria                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CriaSB2(SD2->D2_COD,SD2->D2_LOCAL)
	EndIf
EndIf
RecLock("SB2",.F.)
aVAtu[01] := B2_VATU1 + aCusto[01] * nMultiplic
aVAtu[02] := B2_VATU2 + aCusto[02] * nMultiplic
aVAtu[03] := B2_VATU3 + aCusto[03] * nMultiplic
aVAtu[04] := B2_VATU4 + aCusto[04] * nMultiplic
aVAtu[05] := B2_VATU5 + aCusto[05] * nMultiplic

If (B2_QATU+(SD2->D2_QUANT * nMultiplic)) < 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia e-mail ref. a SALDO NEGATIVO NO ESTOQUE - 002³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSeekSB1
		MEnviaMail("002",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD2->D2_QUANT * nMultiplic)),lEstNeg})
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se envia e-mail ref. PONTO DE PEDIDO - 001³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSeekSB1 .And. !(SB2->B2_LOCAL == cLocCQ) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_EMIN"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   //	nSALDOSB2 := (SALDOSB2(,!lBaixaEmp,dDataBase))+SB2->B2_SALPEDI    
   if SB2->B2_XTRANSI < 0 
	SB2->B2_XTRANSI:=0 
ELSE 
	SB2->B2_XTRANSI:=SB2->B2_XTRANSI 
endif
	nSALDOSB2 := (SALDOSB2(,!lBaixaEmp,dDataBase))+SB2->B2_XTRANSI
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para validar saldo em TODOS os armazens³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMTAATUD2
		nSALDOSB2 := ExecBlock('MTAATUD2',.F.,.F.)
		nSALDOSB2 := IIf(Valtype(nSALDOSB2) <> "N", 0, nSALDOSB2)					
	EndIf
	
	If nSALDOSB2 <= RetFldProd(SB1->B1_COD,"B1_EMIN")
		MEnviaMail("001",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,nSALDOSB2,RetFldProd(SB1->B1_COD,"B1_EMIN")})
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se envia e-mail ref. ESTOQUE MAXIMO  - 029³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_EMAX"))
	If (B2_QATU + (SD2->D2_QUANT * nMultiplic)) >= RetFldProd(SB1->B1_COD,"B1_EMAX")
		MEnviaMail("029",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD2->D2_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_EMAX")})
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se envia e-mail ref. LOTE MINIMO/QTDE EMBALAGEM  - 045³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SG1->(DbSetOrder(1))
If SG1->(DbSeek(xFilial('SG1')+SB1->B1_COD))
	If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_LM"))
		If (B2_QATU + (SD2->D2_QUANT * nMultiplic)) <= RetFldProd(SB1->B1_COD,"B1_LM")
			MEnviaMail("045",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD2->D2_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_LM")})
		EndIf
	EndIf
Else 
	If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_QE"))
		If (B2_QATU + (SD2->D2_QUANT * nMultiplic)) <= RetFldProd(SB1->B1_COD,"B1_QE")
			MEnviaMail("045",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD2->D2_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_QE")})
		EndIf
	Endif
EndIf

Replace B2_QATU With B2_QATU + (SD2->D2_QUANT * nMultiplic)
Replace B2_USAI With dDataBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Movimenta Lotes/Sub-Lotes/Localizacao Fisica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Rastro(SD2->D2_COD) .Or. Localiza(SD2->D2_COD)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SD1 na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(aArraySC9) == "A"
		nQtdeSC9 := 0
		For nx:=1 to Len(aArraySC9)
			MovLote("SD2",;					//1
					SD2->D2_COD,;			//2
					SD2->D2_LOCAL,;			//3
					NIL,;					//4
					NIL,;					//5
					SD2->D2_LOTECTL,;		//6
					SD2->D2_NUMLOTE,;		//7
					SD2->D2_NUMSEQ,;		//8
					If(lInverte,"499",cD2VTes),;	//9
					SD2->D2_CLIENTE,;		//10
					SD2->D2_LOJA,;			//11
					NIL,;					//12
					"NF",;					//13
					cChave,;				//14
					SD2->D2_DOC,;			//15
					SD2->D2_SERIE,;			//16
					NIL,;					//17
					NIL,;					//18
					aArraySC9[nx,1],;		//19
					aArraySC9[nx,2],;		//20
					aArraySC9[nx,3],;		//21
					aArraySC9[nx,4],;		//22
					ConvUm(SD2->D2_COD,aArraySC9[nx,4],aArraySC9[nx,5],2),;	//23
					IIf(lUsaD2DIG, SD2->D2_DTDIGIT, SD2->D2_EMISSAO),;		//24
					SD2->D2_DTVALID,;		//25
					lBaixaEmp,;				//26
					NIL,;					//27
					cD2VTes<="500",;		//28
					NIL,;					//29
					NIL,;					//30
					cAliasBaixa,;			//31
					.T.,;					//32
					NIL,;					//33
					NIL,;					//34
					NIL,;					//35
					NIL,;					//36
					NIL,;					//37
					NIL,;					//38
					NIL,;					//39
					NIL,;					//40
					NIL,;					//41
					NIL,;					//42
					NIL,;					//43
					NIL,;					//44
					NIL,;					//45
					NIL,;					//46
					NIL,;					//47
					NIL,;					//48
					NIL,;					//49
					NIL,;					//50
					nPDevLoc,;				//51
					NIL,;					//52
					NIL,;					//53
					NIL,;					//54
					NIL,;					//55
					aLogMov)				//56
					nQtdeSC9 += aArraySC9[nx,4]
		Next nx
		LogMov('SD2',,,,,,lInverte,,,,aClone(aSldAnt),aClone(aLogMov),.T.,nQtdeSC9,SD2->D2_QUANT)
	Else
	
		If lLoja
			cPedido := cParmPed
			cItem	:= cParmItem
			cSeq	:= cParmSeq
		Else
			cPedido := NIL
			cItem	:= NIL
			cSeq	:= NIL
		endif
				
		MovLote("SD2",;					//1
				SD2->D2_COD,;			//2
				SD2->D2_LOCAL,;			//3
				If(cPaisloc<>"BRA" .And. SD2->(Fieldpos("D2_LOCALIZ"))>0,SD2->D2_LOCALIZ,If(SD2->(Fieldpos("D2_LOCALIZ"))>0 .And. !Empty(SD2->D2_LOCALIZ),SD2->D2_LOCALIZ,NIL)),;	//4
				If(cPaisloc<>"BRA" .And. SD2->(Fieldpos("D2_NUMSERI"))>0,SD2->D2_NUMSERI,If(SD2->(Fieldpos("D2_NUMSERI"))>0 .And. !Empty(SD2->D2_NUMSERI),SD2->D2_NUMSERI,NIL)),;	//5
				SD2->D2_LOTECTL,;		//6
				SD2->D2_NUMLOTE,;		//7
				SD2->D2_NUMSEQ,;		//8
				If(lInverte,"499",cD2VTes),;	//9
				SD2->D2_CLIENTE,;		//10
				SD2->D2_LOJA,;			//11
				NIL,;					//12
				"NF",;					//13
				cChave,;				//14
				SD2->D2_DOC,;			//15
				SD2->D2_SERIE,;			//16
				NIL,;					//17
				NIL,;					//18
				cPedido,;				//19
				cItem,;					//20
				cSeq,;					//21
				SD2->D2_QUANT,;			//22
				SD2->D2_QTSEGUM,;		//23
				IIf(lUsaD2DIG, SD2->D2_DTDIGIT, SD2->D2_EMISSAO),;		//24
				SD2->D2_DTVALID,;		//25
				lBaixaEmp,;				//26
				NIL,;					//27
				cD2VTes<="500",;		//28
				NIL,;					//29
				NIL,;					//30
				cAliasBaixa,;			//31
				.T.,;					//32
				NIL,;					//33
				NIL,;					//34
				NIL,;					//35
				NIL,;					//36
				NIL,;					//37
				NIL,;					//38
				NIL,;					//39
				NIL,;					//40
				NIL,;					//41
				NIL,;					//42
				NIL,;					//43
				NIL,;					//44
				NIL,;					//45
				NIL,;					//46
				NIL,;					//47
				NIL,;					//48
				NIL,;					//49
				NIL,;					//50
				nPDevLoc,;				//51
				NIL,;					//52
				NIL,;					//53
				NIL,;					//54
				NIL,;					//55
				aLogMov)				//56
		LogMov('SD2',,,,,,lInverte,,,,aClone(aSldAnt),aClone(aLogMov),,0,SD2->D2_QUANT)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Baixa reserva                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else
	If nMultiplic == -1 .And. lBaixaEmp
		GravaB2Emp("-",Min(SB2->B2_RESERVA,SD2->D2_QUANT),,.T., If( Empty( SD2->D2_QTSEGUM ),NIL,Min(SB2->B2_RESERV2,SD2->D2_QTSEGUM ) ) )		
	EndIf
EndIf

RecLock("SB2",.F.)
If Empty(SB1->B1_CONV) .And. !Empty(SD2->D2_QTSEGUM)
	Replace	B2_QTSEGUM With B2_QTSEGUM + SD2->D2_QTSEGUM * nMultiplic
ElseIf !Empty(SB1->B1_CONV)
	Replace  B2_QTSEGUM With B2_QTSEGUM + (ConvUm(SB1->B1_COD,SD2->D2_QUANT,SD2->D2_QTSEGUM,2)* nMultiplic)
EndIf

// Verifica as divergencias entre a quantidade da primeira e da segunda UM
MatQtdZero(.T.,.F.,.T.)

Replace B2_VATU1   With aVAtu[01],B2_VATU2 With aVAtu[02],;
		B2_VATU3   With aVAtu[03],B2_VATU4 With aVAtu[04],;
		B2_VATU5   With aVAtu[05]

aCM[01] := B2_CM1
aCM[02] := B2_CM2
aCM[03] := B2_CM3
aCM[04] := B2_CM4
aCM[05] := B2_CM5

For nX := 1 to 5
	If B2_QATU > 0 .And. aVAtu[nX] > 0
		aCM[nX] := aVAtu[nX]/B2_QATU
	EndIf
Next nX

Replace	B2_CM1 With aCM[01],B2_CM2 With aCM[02],B2_CM3 With aCM[03],;
	B2_CM4 With aCM[04],B2_CM5 With aCM[05]
Set(3,nDec)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o custo unificado ON-LINE                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
B2AtuUnif(SB2->B2_COD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o custo FIFO ON-LINE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction("B2AtuFIFO")
	B2AtuFIFO("SD2",nMultiplic)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se houver integração com outros softwares (Framework do SIGALOJA).³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction("LOJA2164") .And. SuperGetMv("MV_LJGRINT",.F., .F.) == .T. .And. AliasInDic("MD0")
	oFactory := LJCAdapXmlEnvFactory():New( )	// Cria a fabrica de Adaptadores de envio
	oAdapter := oFactory:Create( "SB2" )

    oAdapter:Inserir( "SB2", xFilial( "SB2" ) + SB2->B2_COD + SB2->B2_LOCAL, "1", "4" )
    oAdapter:Gerar()
	oAdapter:Finalizar()
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MTAB2D2R - Ponto de entrada APOS execucao da funcao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTAB2D2R
	ExecBlock("MTAB2D2R",.F.,.F.,{SD2->D2_COD, SD2->D2_LOCAL, nMultiplic})
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³B2AtuComD3³ Autor ³ Eveli Morasco         ³ Data ³ 19/10/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o SB2 baseado no SD3                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ B2AtuComD3(ExpA1,ExpC1,ExpL1,ExpL2)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os custos gravados no sd3                ³±±
±±³          ³ ExpC1 = Codigo do local padrao do processo , quando este   ³±±
±±³          ³         parametro nao for passado significa que ele deve   ³±±
±±³          ³         atualizar o local corrente.                        ³±±
±±³          ³ ExpL1 = Flag que indica se deve ser mostrado help ou nao   ³±±
±±³          ³ ExpL2 = Flag que indica se baixa empenho ou nao            ³±±
±±³          ³ ExpL3 = Flag que indica se gera devolucao ou nao           ³±±
±±³          ³ ExpL4 = Flag que indica se considera lotes vencidos        ³±±
±±³          ³ ExpC2 = cEstFis    - Estrutura Fisica          (APDL)      ³±±
±±³          ³ ExpC3 = cServico   - Servico                   (APDL)      ³±±
±±³          ³ ExpC4 = cTarefa    - Tarefa                    (APDL)      ³±±
±±³          ³ ExpC5 = cAtividade - Atividade                 (APDL)      ³±±
±±³          ³ ExpC6 = cAnomalia  - Houve Anomalia? (S/N)     (APDL)      ³±±
±±³          ³ ExpC7 = cEstDest   - Estrututa Fisica Destino  (APDL)      ³±±
±±³          ³ ExpC8 = cEndDest   - Endereco Destino          (APDL)      ³±±
±±³          ³ ExpC9 = cHrInicio  - Hora Inicio               (APDL)      ³±±
±±³          ³ ExpC10= cAtuEst    - Atualiza Estoque? (S/N)   (APDL)      ³±±
±±³          ³ ExpL5 = lPosSB8 - Restaura a Posicao do SB8 na chamada da  ³±±
±±³          ³         da funcao MovLote()                                ³±±
±±³          ³ ExpC11= cCarga     - Numero da Carga           (APDL)      ³±±
±±³          ³ ExpC12= cUnitiza   - Numero do Unitizador      (APDL)      ³±±
±±³          ³ ExpC13= cOrdTar    - Ordem da Tarefa           (APDL)      ³±±
±±³          ³ ExpC14= cOrdAti    - Ordem da Atividade        (APDL)      ³±±
±±³          ³ ExpC15= cRHumano   - Recurso Humano            (APDL)      ³±±
±±³          ³ ExpC16= cRFisico   - Recurso Fisico            (APDL)      ³±±
±±³          ³ ExpL6 = Indica se confere saldo em estoque novamente       ³±±
±±³          ³ ExpC17= cLotePrd   - Lote do Produto                       ³±±
±±³          ³ ExpC18= cSubLotePrd- Sublote do Produto                    ³±±
±±³          ³ ExpC20= cLoteFor- Lote do Fornecedor                   (29)³±±
±±³          ³ ExpC32= lConsSB2- Verifica esta consultando a Funcao    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Pim.³29/12/97³01966A³Ajuste na validacao,qdo produto == "MOD"  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION B2AtuComD3(aCusto,cLocProc,lShowHelp,lBaixaEmp,lGeraDev,lConsVenc,lBxEmpB8,cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,lPosSB8,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,lConfEst,cLotePrd,cSubLotePrd,cPerdaOP,aCustoFF,cLoteFor,cNumDesp,cOriLanc,lConsSB2)
Static lMTAB2D3  := ExistBlock('MTAB2D3')  
Static lMTAB2D3R := ExistBlock('MTAB2D3R')
Static lMTAATUD3 := ExistBlock("MTAATUD3")   

Local nX,aVatu[05],aCm[05],cLocal
Local cIndNeg 	:= GetMV("MV_INDNEG")
Local nDec		:= Set(3,8)
Local cHelp		:="" 
Local cValue    :=""
Local lApropri  :=.F.
Local lSeekSB1	:=.F.
Local lCriaNew  :=.T.
Local lDistribui:=.T.
Local aTravas	:={}
Local aRet      :={}
Local aAreaSDA  :={}
Local aAreaSF5  :={}
Local nSaldo    :=0
Local Z 		:=0
Local nSALDOSB2 :=0
Local nMultiplic:=1
Local cLocCQ    :=SuperGetMV('MV_CQ')
Local lMVPerdInf:=If(Type('lPerdInf')#"L",SuperGetMV('MV_PERDINF',.F.,.F.),lPerdInf)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel usada para identificar se usuario permite que o ³
//³ estoque fique negativo. Se permitir, a variavel vale .T. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lEstNeg:=IF(GETMV("MV_ESTNEG")=="S",.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel utilizada quando nao mostra o HELP e gera Log	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lLog		:=.F.
Local aSavSD4	:= {SD4->(IndexOrd()), SD4->(RecNo())}
Local nBxSD4  	:= 0
Local nBxSD42UM := 0
Local aSldAnt   :={}
Local aLogMov   :={}
Local cSeek		:= ""
Local oFactory	:= Nil
Local oAdapter	:= Nil
Local lVer116	:= (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)  
Local nRecSB2   := 0  
Local lCusUNIF2	:= AllTrim(SuperGetMv("MV_CUSMED",.F.,"M"))=="O" .AND. (AllTrim(SuperGetMv('MV_CUSFIL',.F.,"A")) == "E" .or. AllTrim(SuperGetMv('MV_CUSFIL',.F.,"A")) == "F")

Default lConfEst   := .T.
Default cLoteFor   := ""
Default cLotePrd   := ""
Default cSubLotePrd:= ""
Default aCustoFF   := {0,0,0,0,0}
Default cNumDesp   := ""
Default cOriLanc   := ""
Default lConsSB2   := .T.  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V")	.And. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!") //"Atualizar SIGACUS.PRW !!!"
EndIf
If !(FindFunction("SIGACUSB_V")	.And. SIGACUSB_V() >= 20060927)
	Final("Atualizar SIGACUSB.PRX !!!") //"Atualizar SIGACUSB.PRX !!!"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche parametros nao recebidos pela funcao         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lShowHelp	:=If(lShowHelp==NIL,.T.,lShowHelp)
lBaixaEmp	:=If(lBaixaEmp==NIL,.F.,lBaixaEmp)
lBxEmpB8 	:=If(lBxEmpB8== NIL,lBaixaEmp,lBxEmpB8)
lGeraDev 	:=If(lGeraDev==NIL,.F.,lGeraDev)
lConsVenc	:=If(lConsVenc== NIL,GETMV("MV_LOTVENC") == "S",lConsVenc)
cEstFis   	:=If(cEstFis==Nil,SD3->D3_TPESTR,cEstFis)
cServico  	:=If(cServico==Nil,'',cServico)
cTarefa   	:=If(cTarefa==Nil,'',cTarefa)
cAtividade	:=If(cAtividade==Nil,'',cAtividade)
cAnomalia 	:=If(cAnomalia==Nil,'',cAnomalia)
cEstDest  	:=If(cEstDest==Nil,'',cEstDest)
cEndDest  	:=If(cEndDest==Nil,'',cEndDest)
cHrInicio 	:=If(cHrInicio==Nil,'',cHrInicio)
cAtuEst   	:=If(cAtuEst==Nil,'',cAtuEst)
lPosSB8   	:=If(Valtype(lPosSB8)=="L",lPosSB8,.T.)
cCarga    	:=If(cCarga==Nil,'',cCarga)
cUnitiza  	:=If(cUnitiza==Nil,'',cUnitiza)
cOrdTar   	:=If(cOrdTar==Nil,'',cOrdTar)
cOrdAti   	:=If(cOrdAti==Nil,'',cOrdAti)
cRHumano  	:=If(cRHumano==Nil,'',cRHumano)
cRFisico  	:=If(cRFisico==Nil,'',cRFisico)
l185        :=If(Type("l185") == "L",l185,.F.)

If (SD3->D3_TM > "500" .And. cLocProc == NIL) .Or. (SD3->D3_TM <= "500" .And. cLocProc != NIL)
	nMultiplic := -1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se for movimento de material indireto ele deve atualizar ³
//³ o local padrao do processo passado como parametro        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cLocProc == NIL
	cLocal := SD3->D3_LOCAL
Else
	cLocal := cLocProc
	lApropri:=.T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada Executado ANTES da atualizacao do SB2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTAB2D3
	ExecBlock("MTAB2D3",.F.,.F.,{SD3->D3_COD, cLocal, nMultiplic})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da LogMov para verificar o saldo antes da     |
//| atualizacao das tabelas SB2/SBF/SB8                   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Rastro(SD3->D3_COD) .Or. Localiza(SD3->D3_COD)
	LogMov('SD3',,,,,,,,,.T.,@aSldAnt)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no local a ser atualizado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB2")
dbSetOrder(1)
If ( !MsSeek(xFilial("SB2")+SD3->D3_COD+cLocal) )
	CriaSB2(SD3->D3_COD,cLocal)
EndIf
lLog:=!(RecLock("SB2",.F.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida saldo qdo movimento for de requisicao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lLog .And. lConfEst .And. nMultiplic == -1 .And. !(SD3->D3_CF $ "RE1/ER0") .And. ;
	((Rastro(SD3->D3_COD  ) .And. !Empty(SD3->D3_LOTECTL+SD3->D3_NUMLOTE))     .Or.  ;
	 (Localiza(SD3->D3_COD) .And. !Empty(SD3->D3_LOCALIZ+SD3->D3_NUMSERI))     .Or.  ;    
	 (!lEstNeg .And. !IsProdMod(SD3->D3_COD)))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Obtem saldo por lote e /ou localizacao                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (Rastro(SD3->D3_COD) .And. !Empty(SD3->D3_LOTECTL+SD3->D3_NUMLOTE)) .Or. (Localiza(SD3->D3_COD) .And. !Empty(SD3->D3_LOCALIZ+SD3->D3_NUMSERI))
		nSaldo:=0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa saldo a distribuir pendente                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Localiza(SD3->D3_COD)
			aAreaSDA:=SDA->(GetArea())
			SDA->(dbSetOrder(1))
			If SDA->(dbSeek(xFilial("SDA")+SD3->D3_COD+cLocal+SD3->D3_NUMSEQ+SD3->D3_DOC))
				nSaldo+=SDA->DA_SALDO
			EndIf
			Restarea(aAreaSDA)
		EndIf
		aRet:=SldPorLote(SD3->D3_COD,cLocal,SD3->D3_QUANT,SD3->D3_QTSEGUM,SD3->D3_LOTECTL,SD3->D3_NUMLOTE,SD3->D3_LOCALIZ,SD3->D3_NUMSERI,@aTravas,lBxEmpb8,NIL,lConsVenc,NIL,NIL,If(SD3->D3_ESTORNO == "S", Nil,SD3->D3_EMISSAO),,IIf(lMVPerdInf,cPerdaOP,Nil))
		For nx:=1 to Len(aRet)
			If Rastro(SD3->D3_COD)
				If Len(aRet[nx,10]) > 0
					For z:=1 to Len(aRet[nx,10])
						nSaldo+=aRet[nx,10,z,2]
					Next z
				Else
					Exit
				EndIf
			Else
				nSaldo+=aRet[nx,5]
			EndIf
		Next i
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem saldo em estoque                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no local a ser pesquisado                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB2")
		dbSetOrder(1)
		If (!MsSeek(xFilial("SB2")+SD3->D3_COD+cLocal))
			CriaSB2(SD3->D3_COD,cLocal)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para considerar o saldo do movimento já incluído quanto utilizada função CalcEst para cálculo do saldo em estoque³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	If SuperGetMV("MV_TPSALDO") == "C"
			nSaldo := CalcEst(SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_EMISSAO+1)[1] 
			nSaldo += IIf(SD3->D3_TM > "499",SD3->D3_QUANT,( - SD3->D3_QUANT * nMultiplic) )
	  	Else
			nSaldo := SB2->B2_QATU
	  	EndIf
	EndIf

	SB1->(dbSeek(xFilial("SB1")+SB2->B2_COD))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se devera validar qtde. disponivel em Estoque  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QtdComp(nSaldo) < QtdComp(SD3->D3_QUANT) .And.((cIndNeg == "N" .And. SB1->B1_APROPRI == "I").Or. (cIndNeg == "E" .And. !lEstNeg .And. SB1->B1_APROPRI == "I") .Or. ((!lEstNeg .or. Rastro(SD3->D3_COD) .or. Localiza(SD3->D3_COD)).And. SB1->B1_APROPRI == "D"))
		If Rastro(SD3->D3_COD)  .And. !(A185VldNG(SD3->D3_OP))
			Help(" ",1,"A240LOTENE")
		ElseIf Localiza(SD3->D3_COD) .And. !(A185VldNG(SD3->D3_OP))
			Help(" ",1,"SALDOLOCLZ")
		ElseIf lShowHelp .And. !(A185VldNG(SD3->D3_OP))
			cValue:=Transform((SB2->B2_QATU+(SD3->D3_QUANT * nMultiplic)),PesqPictQt("B2_QATU",14))
			cHelp:=AllTrim(SB2->B2_COD)+"/"+SB2->B2_LOCAL+", Saldo: "+ALLTRIM(cValue)+")."	//", Saldo: "
			If ( Type("l103Auto") == "U" .Or. !l103Auto ) 
	  			Help ( " ", 1, "MVESTNEG",,cHelp,3,1)
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Remove travas dos registros utilizados                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaDesTrava(aTravas)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga registro no SD3 para invalidar movimento          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reclock("SD3",.F.)
		dbDelete()
		MsUnlock()
		lLog:=.T.
		dbSelectArea("SB2")
		MsUnlock()
	EndIf
ElseIf lLog
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga registro no SD3 para invalidar movimento          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Reclock("SD3",.F.)
	dbDelete()
	MsUnlock()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se tem saldo disponivel                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lLog
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto a ser atualizado                 ³
	//³ e atualiza a data de consumo inicial                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	lSeekSB1:=dbSeek(xFilial("SB1")+SD3->D3_COD+cLocal)
	If lSeekSB1 .And. !(SD3->D3_ESTORNO == "S")
		B2AtuConIn(nMultiplic,SD3->D3_EMISSAO)
	EndIf
	dbSelectArea("SB2") 
	if lCusUNIF2		// Custo unificado não deverá tratar seção abaixo qdo zerar o saldo de um deposito apenas.
		nRecSB2 := SB2->(Recno())
		nQtdeAtu := 0
		dbSeek(xFilial("SB2")+SD3->D3_COD) 
		while !SB2->(EOF()) .And. SB2->B2_COD == SD3->D3_COD
		  nQtdeAtu += SB2->B2_QATU 
		  SB2->(dbSkip())
		EndDO
		lZeraSLD := Iif(nQtdeAtu = 0,.T.,.F.)    
		SB2->(Dbgoto(nRecSB2))
	Else
		lZeraSLD := QtdComp(B2_QATU+(SD3->D3_QUANT * nMultiplic)) == QtdComp(0)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aqui e' acertado o Saldo do Custo do Produto, quando  ³
	//³ a movimentacao do SD3 zerar o Saldo em Estoque do Prd.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QtdComp(SD3->D3_QUANT) > QtdComp(0) .And. lZeraSLD .And. ( !(SD3->D3_CF$"DE4|RE4|DE5|RE5|DE6|RE6|RE7|DE7|RE8|DE8|PR0|PR1|ER0|ER1") .Or. (cOriLanc $ 'CP|TR' .and. SD3->D3_CF $ 'RE6'))
		aCusto[1] := Abs(B2_VATU1)
		aCusto[2] := Abs(B2_VATU2)
		aCusto[3] := Abs(B2_VATU3)
		aCusto[4] := Abs(B2_VATU4)
		aCusto[5] := Abs(B2_VATU5)
		RecLock("SD3")
		SD3->D3_CUSTO1 := aCusto[1]
		SD3->D3_CUSTO2 := aCusto[2]
		SD3->D3_CUSTO3 := aCusto[3]
		SD3->D3_CUSTO4 := aCusto[4]
		SD3->D3_CUSTO5 := aCusto[5]
		MsUnLock()
		dbSelectArea("SB2")
	EndIf

	aVAtu[01] := B2_VATU1 + aCusto[01] * nMultiplic
	aVAtu[02] := B2_VATU2 + aCusto[02] * nMultiplic
	aVAtu[03] := B2_VATU3 + aCusto[03] * nMultiplic
	aVAtu[04] := B2_VATU4 + aCusto[04] * nMultiplic
	aVAtu[05] := B2_VATU5 + aCusto[05] * nMultiplic

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento para considerar o saldo do movimento já incluído quanto utilizada função CalcEst para cálculo do saldo em estoque³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	If SuperGetMV("MV_TPSALDO") == "C"
		nSaldo := CalcEst(SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_EMISSAO)[1]
		nSaldo += IIf(SD3->D3_TM > "499",SD3->D3_QUANT,( - SD3->D3_QUANT * nMultiplic) )
  	Else
		nSaldo := SB2->B2_QATU
  	EndIf

	If (nSaldo+(SD3->D3_QUANT * nMultiplic)) < 0
		If (!lEstNeg .And. SB1->B1_APROPRI=="D" .And. !IsProdMod(SD3->D3_COD)).Or. ((cIndNeg == "N" .And. SB1->B1_APROPRI == "I") .Or. (cIndNeg == "E" .And. SB1->B1_APROPRI == "I" .And. !lEstNeg))
			If lShowHelp  .And. !(A185VldNG(SD3->D3_OP))
				cValue:=Transform((B2_QATU+(SD3->D3_QUANT * nMultiplic)),PesqPictQt("B2_QATU",14))
				cHelp:=AllTrim(B2_COD)+"/"+B2_LOCAL+", Saldo: "+ALLTRIM(cValue)+")."	//", Saldo: "
				If ( Type("l103Auto") == "U" .Or. !l103Auto )
					Help ( " ", 1, "MVESTNEG",,cHelp,3,1)
				EndIf				
			EndIf
			lLog:=.T.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia e-mail ref. a SALDO NEGATIVO NO ESTOQUE - 002³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSeekSB1 .And. !(A185VldNG(SD3->D3_OP))
			MEnviaMail("002",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD3->D3_QUANT * nMultiplic)),lEstNeg})
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se envia e-mail ref. PONTO DE PEDIDO - 001³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSeekSB1 .And. !(SB2->B2_LOCAL == cLocCQ) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_EMIN"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//		nSALDOSB2 := (SALDOSB2(.T.,!lBaixaEmp,dDataBase))+SB2->B2_SALPEDI+SB2->B2_QACLASS   

   if SB2->B2_XTRANSI < 0 
	SB2->B2_XTRANSI:=0 
ELSE 
	SB2->B2_XTRANSI:=SB2->B2_XTRANSI 
endif

		nSALDOSB2 := (SALDOSB2(.T.,!lBaixaEmp,dDataBase))+SB2->B2_XTRANSI+SB2->B2_QACLASS
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para validar saldo em TODOS os armazens³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMTAATUD3
			nSALDOSB2 := ExecBlock('MTAATUD3',.F.,.F.)
			nSALDOSB2 := IIf(Valtype(nSALDOSB2) <> "N", 0, nSALDOSB2)					
		EndIf
		
		If (nSALDOSB2 + IIF(!l185,(SD3->D3_QUANT * nMultiplic),0)) <= RetFldProd(SB1->B1_COD,"B1_EMIN")
			MEnviaMail("001",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(nSALDOSB2 + IIF(!l185,(SD3->D3_QUANT * nMultiplic),0)),RetFldProd(SB1->B1_COD,"B1_EMIN")})
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se envia e-mail ref. ESTOQUE MAXIMO  - 029³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_EMAX"))
		If (B2_QATU + (SD3->D3_QUANT * nMultiplic)) >= RetFldProd(SB1->B1_COD,"B1_EMAX")
			MEnviaMail("029",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD3->D3_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_EMAX")})
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se envia e-mail ref. LOTE MINIMO/QTDE EMBALAGEM  - 045³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SG1->(DbSetOrder(1))
	If SG1->(DbSeek(xFilial('SG1')+SB1->B1_COD))
		If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_LM"))
			If (B2_QATU + (SD3->D3_QUANT * nMultiplic)) <= RetFldProd(SB1->B1_COD,"B1_LM")
				MEnviaMail("045",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD3->D3_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_LM")})
			EndIf
		EndIf
	Else 
		If lSeekSB1 .And. !Empty(RetFldProd(SB1->B1_COD,"B1_QE"))
			If (B2_QATU + (SD3->D3_QUANT * nMultiplic)) <= RetFldProd(SB1->B1_COD,"B1_QE")
				MEnviaMail("045",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(B2_QATU + (SD3->D3_QUANT * nMultiplic)),RetFldProd(SB1->B1_COD,"B1_QE")})
			EndIf
		Endif
	EndIf

	Replace  B2_QATU    With B2_QATU    + (SD3->D3_QUANT   * nMultiplic)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Lotes/Sub-Lotes/Localizacao Fisica³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Rastro(SD3->D3_COD) .Or. Localiza(SD3->D3_COD)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento da gravacao do SD1 na Integridade Referencial            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SD3->(FkCommit())
		lCriaNew:=lGeraDev .Or. nMultiplic == 1
		lDistribui:=Substr(SD3->D3_CF,1,1) $ "DP"
		aAreaSF5:=SF5->(GetArea())
		SF5->(dbSetOrder(1))
		If SF5->(dbSeek(xFilial("SF5")+SD3->D3_TM))
			lCriaNew:=lGeraDev .Or. nMultiplic == 1
			If nMultiplic == 1 .And. SF5->F5_TIPO == "P" .And. SD3->D3_CF=="PR1"
				lDistribui:=.F.
			EndIf
		EndIf
		SF5->(Restarea(aAreaSF5))
		MovLote("SD3",;				//1
				SD3->D3_COD,;		//2
				cLocal,;			//3
				If(SD3->D3_CF == "DE3" .And. SD3->D3_ESTORNO # "S" .And. lConsSB2,"",SD3->D3_LOCALIZ),;	//4
				If(SD3->D3_CF == "DE3" .And. SD3->D3_ESTORNO # "S","",SD3->D3_NUMSERI),;	//5
				SD3->D3_LOTECTL,;	//6
				SD3->D3_NUMLOTE,;	//7
				SD3->D3_NUMSEQ,;	//8
				SD3->D3_TM,;		//9
				NIL,;				//10
				NIL,;				//11
				cLoteFor,;			//12
				"MI",;				//13
				NIL,;				//14
				SD3->D3_DOC,;		//15
				NIL,;				//16
				SD3->D3_OP,;		//17
				If(lBaixaEmp,If(!Empty(SD3->D3_TRT),SD3->D3_TRT,SD4->D4_TRT),NIL),;//18
				NIL,;				//19
				NIL,;				//20
				NIL,;				//21
				SD3->D3_QUANT,;		//22
				SD3->D3_QTSEGUM,;	//23
				SD3->D3_EMISSAO,;	//24
				SD3->D3_DTVALID,;	//25
				lBaixaEmp,;			//26
				lApropri,;			//27
				SD3->D3_ESTORNO == "S",;//28
				lCriaNew,;			//29
				lDistribui,;      	//30
				NIL,;				//31
				lConsVenc,;			//32
				lBxEmpB8,;			//33
				cEstFis,;			//34
				cServico,;			//35
				cTarefa,;			//36
				cAtividade,;		//37
				cAnomalia,;			//38
				cEstDest,;			//39
				cEndDest,;			//40
				cHrInicio,;			//41
				cAtuEst,; 			//42
				lPosSB8,;			//43
				cCarga,;			//44
				cUnitiza,;			//45
				cOrdTar,;			//46
				cOrdAti,;			//47
				cRHumano,;			//48
				cRFisico,;			//49
				SD3->D3_POTENCI,;	//50
				Nil,;				//51
				lGeraDev,; 			//52
				cLotePrd,; 			//53
				cSubLotePrd,; 		//54
				cPerdaOP,;			//55
				aLogMov,;           //56
				Iif(SB8->(FieldPos("B8_DFABRIC")) >0 .and. !Empty(DTOS(SB8->B8_DFABRIC)) .and. SD3->D3_CF # "PR0", SB8->B8_DFABRIC, Nil),; //57
				cNumDesp) 			//58
		LogMov('SD3',,,,,,,,,,aClone(aSldAnt),aClone(aLogMov),,0,SD3->D3_QUANT)
	Else
		If lBaixaEmp
			If !(Substr(SD3->D3_CF,3,1) $ "129" )
				SD4->(dbSetOrder(1))  // D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE
				SD4->(dbSeek(cSeek := xFilial("SD4") + SD3->D3_COD + SD3->D3_OP + SD3->D3_TRT + SD3->D3_LOTECTL + SD3->D3_NUMLOTE))
				While ! SD4->(Eof()) .And. cSeek == SD4->(D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE)
					If lGeraDev
						nBxSD4 += If(nMultiplic == 1, ABS(SD4->D4_QUANT) , ABS(SD4->D4_QTDEORI - SD4->D4_QUANT))
					Else
						nBxSD4 += If(nMultiplic == 1, SD4->D4_QTDEORI - SD4->D4_QUANT, SD4->D4_QUANT)
					EndIf
					SD4->(dbSkip())
				Enddo 
				nBxSD4 := Min(SD3->D3_QUANT,If(nBxSD4<0,0,nBxSD4))
				nBxSD42UM := Min(SD3->D3_QTSEGUM, If(nBxSD42UM<0,0,ConvUM(SD3->D3_COD,nBxSD4,SD3->D3_QTSEGUM,2)))
				SD4->(dbSetOrder(aSavSD4[1]))
				SD4->(dbGoto(aSavSD4[2]))
			Else
				nBxSD4    := SD3->D3_QUANT
				nBxSD42UM := SD3->D3_QTSEGUM
			EndIf			
			If !Empty(nBxSD4)
				If lVer116 .And. SD3->D3_QTMAIOR > 0
					nBxSD4 := Max(nBxSD4 - SD3->D3_QTMAIOR,0)
				EndIf
				If lGeradev
					If nMultiplic == -1
						GravaB2Pre("+",nBxSD4,"F",,nBxSD42UM)   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							
	//				ElseIf nMultiplic == 1 .And. SB2->B2_SALPEDI > 0
//						GravaB2Pre("-",Min(SB2->B2_SALPEDI,nBxSD4),"F",,Min(SB2->B2_QEMP2,nBxSD42UM))
				ElseIf nMultiplic == 1 .And. SB2->B2_XTRANSI > 0	
						GravaB2Pre("-",Min(SB2->B2_XTRANSI,nBxSD4),"F",,Min(SB2->B2_QEMP2,nBxSD42UM))
					EndIf
				Else
					If nMultiplic == -1  .And. SB2->B2_QEMP > 0
						GravaB2Emp("-",Min(SB2->B2_QEMP,nBxSD4),"F",,Min(SB2->B2_QEMP2,nBxSD42UM))
					ElseIf nMultiplic == 1
						GravaB2Emp("+",nBxSD4,"F",,nBxSD42UM)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	RecLock("SB2",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava campo referente a 2a. Unidade de Medida          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(SB1->B1_CONV) .And. !Empty(SD3->D3_QTSEGUM)
		Replace	B2_QTSEGUM With B2_QTSEGUM + SD3->D3_QTSEGUM * nMultiplic
	ElseIf !Empty(SB1->B1_CONV)
		Replace  B2_QTSEGUM With B2_QTSEGUM + (ConvUm(SB1->B1_COD,SD3->D3_QUANT,SD3->D3_QTSEGUM,2)* nMultiplic)
	EndIf

	// Verifica as divergencias entre a quantidade da primeira e da segunda UM
	MatQtdZero(.T.,.F.,.T.)

	Replace	B2_VATU1   With aVatu[01],B2_VATU2 With aVatu[02],;
			B2_VATU3   With aVatu[03],B2_VATU4 With aVatu[04],;
			B2_VATU5   With aVatu[05]

	If nMultiplic == -1
		Replace B2_USAI With SD3->D3_EMISSAO
	EndIf

	aCM[01] := B2_CM1
	aCM[02] := B2_CM2
	aCM[03] := B2_CM3
	aCM[04] := B2_CM4
	aCM[05] := B2_CM5

	For nX := 1 to 5
		If B2_QATU > 0 .And. aVatu[nX] > 0
			aCM[nX] := aVatu[nX]/B2_QATU
		EndIf
	Next nX

	//-- Realiza a Distribuicao Automatica atravez do parametro MV_DISTAUT para apropriacao indireta
	If SD3->D3_ESTORNO # "S" .And. cLocProc != NIL .And. nMultiplic == 1 .And. Localiza(SD3->D3_COD) .And. !Empty(GetMV("MV_DISTAUT"))
		A100Distri(SD3->D3_COD, cLocProc, SD3->D3_NUMSEQ, SD3->D3_DOC, Nil, Nil, Nil, Nil, Nil, SD3->D3_QUANT, SD3->D3_LOTECTL, SD3->D3_NUMLOTE, Nil, Nil, Nil, Nil, SD3->D3_QUANT)
	EndIf

	If !IsProdMod(B2_COD)
		Replace	B2_CM1 With aCM[01],B2_CM2 With aCM[02],B2_CM3 With aCM[03],;
			B2_CM4 With aCM[04],B2_CM5 With aCM[05]
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se ele atualizou o local do processo , ele deve voltar ³
	//³ ao local original da movimentacao                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cLocProc != NIL
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2")+SD3->D3_COD+SD3->D3_LOCAL)
	EndIf
EndIf
Set(3,nDec)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o custo unificado ON-LINE                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
B2AtuUnif(SB2->B2_COD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o custo FIFO ON-LINE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction("B2AtuFIFO")
	B2AtuFIFO("SD3",nMultiplic,@aCustoFF)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se houver integração com outros softwares (Framework do SIGALOJA).³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction("LOJA2164") .And. SuperGetMv("MV_LJGRINT",.F., .F.) == .T. .And. AliasInDic("MD0")
	oFactory := LJCAdapXmlEnvFactory():New( )	// Cria a fabrica de Adaptadores de envio
	oAdapter := oFactory:Create( "SB2" )

    oAdapter:Inserir( "SB2", xFilial( "SB2" ) + SB2->B2_COD + SB2->B2_LOCAL, "1", "4" )
    oAdapter:Gerar()
	oAdapter:Finalizar()
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MTAB2D2R - Ponto de entrada APOS execucao da funcao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTAB2D3R
	ExecBlock("MTAB2D3R",.F.,.F.,{SD3->D3_COD, SD3->D3_LOCAL, nMultiplic})
EndIf

Return lLog

/// ______________________________________________




