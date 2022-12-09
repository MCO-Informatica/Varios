//#INCLUDE "MATA300.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA300  ³ Autor ³ Eveli Morasco         ³ Data ³ 05/03/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula os saldos atuais de estoque e atualiza o arquivo   ³±±
±±³          ³ SB2 quando houver diferenca.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Patricia Sal.³01/03/00³XXXXXX³Util.os campos B8_DOC,B8_SERIE,B8_CLIFOR³±±
±±³              ³        ³      ³B8_LOJA ao inves do B8_CHAVE.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATA300TST(lBat)

Local aSays      :={}
Local aButtons   :={}
Local aListaFil  :={}
aadd(aListaFil,{.T.,"90","GRU/ TPS 2-90","53928891002584","336647674115",""})

// #IFDEF TOP
// 	TCInternal(5,"*OFF")   // Desliga Refresh no Lock do Top
// #ENDIF

Default lBat := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao do fonte        ³
//³ SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
    Final(" Atualizar SIGACUSA.PRX " + " SIGACUSA.PRX !!!") //Atualizar SIGACUSA.PRX 
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta o grupo de pergunta MTA300                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Almoxarifado De   ?                                  ³
//³ mv_par02 - Almoxarifado Ate  ?                                  ³
//³ mv_par03 - Do produto                                           ³
//³ mv_par04 - Ate o produto                                        ³
//³ mv_par05 - Zera o Saldo da MOD?  Sim/Nao/Recalcula              ³
//³ mv_par06 - Zera o CM da MOD?  Sim/Nao/Recalcula                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Colocado o Return porque se o usuario clicasse no botao de    ³
//³ cancelar ele nao retornava ao menu, ele continuava o processo.|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Pergunte("MTA300",If(lBat .Or. IsBlind(),.F.,.T.)) .And. !( lBat .Or. IsBlind() )
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Inicializa o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni(aButtons)

AADD(aSays,"Este programa tem o objetivo de recalcular o saldo atual de todos os itens do Estoque") // "Este programa tem o objetivo de recalcular o saldo atual de todos os itens do Estoque"
AADD(aSays,"(em Quantidade e Valor). Ele partirá do saldo inicial do período e considerará todas as") // "(em Quantidade e Valor). Ele partirá do saldo inicial do período e considerará todas as"
AADD(aSays,"Notas Fiscais de Entrada, Notas Fiscaisde Saída, Requisiçöes,Devoluçöes e Produçöes") // "Notas Fiscais de Entrada, Notas Fiscaisde Saída, Requisiçöes,Devoluçöes e Produçöes"
AADD(aSays,"feitas até o momento.") // "feitas até o momento."

AADD(aButtons, { 5,.T.,{|o| nOpcA:= 0 ,Pergunte("MTA300",.T.)} } )
AADD(aButtons, { 1,.T.,{ || Processa({|lEnd| If(u_MA300ProcXX(lBat,@lEnd,aListaFil),FechaBatch(),.F.)},OemToAnsi("ERRO1"),OemToAnsi("ERRO1"),.F.)} } )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

If FtVldJobFt()
	If !lBat 
		If !IsBlind()
			If Getmv("MV_CUSTEXC") == "N"
				cMens := OemToAnsi("Esta rotina ser  executada em modo")+chr(13) //"Esta rotina ser  executada em modo"
				cMens += OemToAnsi("compartilhado , conforme indicado")+chr(13) //"compartilhado , conforme indicado"
				cMens += OemToAnsi("pelo parƒmetro MV_CUSTEXC.")+chr(13) //"pelo parƒmetro MV_CUSTEXC."
				cMens += OemToAnsi("As movimenta‡”es que ocorrerem durante")+chr(13) //"As movimenta‡”es que ocorrerem durante"
				cMens += OemToAnsi("o processo podem influir no c lculo.")+chr(13) //"o processo podem influir no c lculo."
				If !MsgYesNo(cMens,OemToAnsi("ATEN€O"))    //"ATEN€O"
					Return
				EndIf
			Else
				cMens := OemToAnsi("Esta  rotina  exige  que  os   arquivos")+chr(13) //"Esta  rotina  exige  que  os   arquivos"
				cMens += OemToAnsi("associados a ela n†o estejam em uso por")+chr(13) //"associados a ela n†o estejam em uso por"
				cMens += OemToAnsi("outras esta‡”es.")+chr(13) //"outras esta‡”es."
				cMens += OemToAnsi("Fa‡a com que os outros usu rios saiam do")+chr(13) //"Fa‡a com que os outros usu rios saiam do"
				cMens += OemToAnsi("sistema.")+chr(13) //"sistema."
				If !MsgYesNo(cMens,OemToAnsi("ATEN€O")) //"ATEN€O"
					Return
				EndIf
			EndIf
		EndIf
		FormBatch("ATEN€O X3",aSays,aButtons,,220,560)
	Else	
		If MTA300TOk()
			u_MA300ProcXX(lBat,,aListaFil)
		EndIf	
	EndIf
EndIf
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA300Process³ Autor ³ Rodrigo de A. Sartorio³ Data ³28/11/95³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa os saldos atuais de estoque e atualiza o arquivo  ³±±
±±³          ³ SB2 quando houver diferenca.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA300                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA300ProcXX(lBat,lEnd,aListaFil)
Local cDoc       := ''
Local cLoja      := ''
Local cSeek      := ''
Local cSeek1     := ''
Local cAlmox     := ''
Local cSerie     := ''
Local cCliFor    := ''
Local cLoteCtl   := ''
Local cNumLote   := ''
Local cLoteFor   := ''
Local cOrigLan   := ''
Local cTempo     := ''
Local cLocProc   := ''
Local cDepTran   := ''
Local cLocal     := ''
Local cXFilial   := ''
Local cProcNam   := ''
Local cJobFile   := ''
Local cTexto     := ''
Local nQuant     := 0
Local nQuant2    := 0
Local nAchou     := 0
Local nTempoIni  := 0
Local nTempoFim  := 0
Local nVAtu      := 0
Local nVFF       := 0
Local nX         := 0
Local nY         := 0
Local nRecnoSBK  := 0
Local nThreads   := 0
Local nRetry_0   := 0
Local nRetry_1   := 0
Local nPos       := 0
Local nTotRegs   := 0
Local lContinua  := .T.
Local lProcessa  := .F.
Local lSaldoIni  := .F.
Local lLockSB    := .F.
Local l300SalNeg := .T.
Local lTranSB2   := .F.
Local lCustNeg   := .F.
Local lThrSeq    := .F.
Local lProcesProc:= .F.
Local lD3Servico := .F.
Local aProcsOk   := {}
Local aJobAux    := {}
Local aDeleSBF   := {{}}
Local aPriori    := {{}}
Local dData      := CTOD('  /  /  ')
Local dDtValid   := CTOD('  /  /  ')
Local dUsai      := CTOD("01/01/80","ddmmyy")
Local lM300SBF   := ExistBlock('M300SBF')
Local nTamLocal  := TamSX3("B2_LOCAL")[1]
Local lSD1,lSD2,lSD3,lSB2
Local aVini[05],lSB9,aSaldo,xLocal
Local nSaldo,nSalvRec,ni
Local nRegSB2,cChaveSB2
Local oDlgOcorr, oOcorr
Local oDlg, dUlMes
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel codeblock                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local bBloco     := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ lFFOnLine - Verifica se utiliza Custo FIFO On-Line     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lFFonLine  := FindFunction("IsFifoOnLine") .And. IsFifoOnLine()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abertura de tabelas em modo exclusivo ou compartilhado. |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lArqExcl   := IIf(GetMV("MV_CUSTEXC")!="N",.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Diretorio do servidor protheus                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cStartPath := GetSrvProfString("Startpath","")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza contabilizacao On-Line             |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lCstOnLine := (AllTrim(SuperGetMv("MV_CUSMED",.F.,"M")) == "O" .Or. SuperGetMV("MV_AGCUSTO",.F.,.F.)) 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo por Filial                   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL',.F.,"A")) == "F"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo por Empresa                  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL',.F.,"A")) == "E"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza processamento nas 5 moedas         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMoeda300C := SuperGetMv('MV_MOEDACM',.F.,"2345") 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve travar os registros do SB2            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lLockSB2   := mv_par07 == 1 .And. !lArqExcl
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para processamento de Filiais     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aFilsCalc  := {}
Local cFilBack   := cFilAnt
Local nForFilial := 0
Local cSPMAT040  := IIF(FindFunction("GetSPName"), GetSPName("MAT040","18"), "MAT040")
Local cSPMAT044  := IIF(FindFunction("GetSPName"), GetSPName("MAT044","18"), "MAT044")
Local cSPMAT053  := IIF(FindFunction("GetSPName"), GetSPName("MAT053","18"), "MAT053")
Local cSPMAT055  := IIF(FindFunction("GetSPName"), GetSPName("MAT055","18"), "MAT055")
Local lUsaD2DIG  := IIF(FindFunction("UsaD2DTDIG"), UsaD2DTDIG(), .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as filiais a serem processadas                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCstOnLine .And. lCusEmp
	aFilsCalc := MatFilCalc( .F. )
ElseIf lBat .Or. IsBlind()
	If Empty(aListaFil)
		aFilsCalc := MatFilCalc( .F. )
	Else
		aFilsCalc := aListaFil
	EndIf	
Else
    aFilsCalc := MatFilCalc( mv_par08 == 1 )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atraves do parametro MV_CUSTEXC, verifica se a abertura de   ³
//³ arquivos e' exclusiva ou compartilhada.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lArqExcl
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre todos os arquivos de forma exclusiva                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! (MA280FLock("SB1") .And. MA280FLock("SB2") .And. MA280FLock("SD1") .And. MA280FLock("SD2") .And.;
		  MA280FLock("SD3") .And. MA280FLock("SF4") .And. MA280FLock("SB8") .And. MA280FLock("SB9") .And.;
		  MA280FLock("SD5") .And. MA280FLock("SBF") .And. MA280FLock("SDB"))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha todos os arquivos e reabre-os de forma compartilhada   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbCloseAll()
		OpenFile(SubStr(cNumEmp,1,2))
		Return .T.
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre indices dos arquivos que foram abertos de forma exclusivo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OpenIndx("SF4")
	OpenIndx("SD1")
	OpenIndx("SD2")
	OpenIndx("SD3")
	OpenIndx("SB1")
	OpenIndx("SB2")
	OpenIndx("SB8")
	OpenIndx("SB9")
	OpenIndx("SD5")
	OpenIndx("SBF")
	OpenIndx("SDB")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha o cursor e o salva para poder movimenta'-lo          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTempoIni:=Seconds()
dbSelectArea("SB1")
nTotRegs := nTotRegs + LastRec()
If !lBat	
	ProcRegua(nTotRegs,21,05)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a data do Recalculo do custo medio , vinda do SX1       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataIni := GETMV("MV_ULMES")
dDataFim := CTOD("31/12/49","ddmmyy")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Custo por Empresa OnLine - Processar todas as Filiais        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusEmp .And. lCstOnLine .And. FindFunction("B2AtuUnif")
	Help(" ",1,"A300EMP")	
	For nForFilial := 1 to Len(aFilsCalc)
		aFilsCalc[nForFilial,1] :=.T.
	Next nForFilial
	mv_par01 := Space(nTamLocal)
	mv_par02 := Replicate('z',nTamLocal)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Custo por Filial OnLine - Processar todos armazens           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusFil .And. lCstOnLine .And. FindFunction("B2AtuUnif")
	Help(" ",1,"A300FIL")
	mv_par01 := Space(nTamLocal)
	mv_par02 := Replicate('z',nTamLocal)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("INICIO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("MENSAGEM","Iniciando recalculo do saldo atual","Iniciando recalculo do saldo atual") //"Iniciando recalculo do saldo atual"

#IFDEF TOP

	If ExistProc( cSPMAT040,VerIDProc(),lBat ) .And. ExistProc( cSPMAT044, VerIDProc(),lBat ) .And. ExistProc( cSPMAT053, VerIDProc(),lBat )
			    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Habilita processamento de thread em sequencia          |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lThrSeq    := SuperGetMV("MV_THRSEQ",.F.,.F.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ MV_A300THR parametro utilizado para informar o numero  |
		//| de threads para o processamento.                       |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nThreads   := SuperGetMv('MV_A300THR',.F.,1)
	
		dbSelectArea("SB2")
		dbSetOrder(1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PROCESSAMENTO PADRAO                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SQL2000 - Quando utilizado banco de dados SQL2000 ou versoes |
		//|           anteriores nao sera possivel utilizar a execucao   |
		//|           em mult-threads, somente processamento padrao.     |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nThreads == 1 .Or. lArqExcl .Or. ( GetSQLVersion() == "2000" )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ aFilsCalc - Array com filiais a serem processadas            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(aFilsCalc)
			
				For nForFilial := 1 To Len( aFilsCalc )
				
					If aFilsCalc[ nForFilial, 1 ]
						cFilAnt    := aFilsCalc[ nForFilial, 2 ]
						lD3Servico := GetMV('MV_D3SERVI', .F., 'N')=='S'
						l300SalNeg := GetMV("MV_MT300NG",.F.,.T.)
						cTexto     := "   " +cFilAnt+" - "
						aResult:= TCSPExec(	xProcedures(cSPMAT040)		,;  // Chamada da procedure MAT040
											cFilAnt						,;	// 01. Codigo da filial corrente
											mv_par01					,;	// 02. Almoxarifado de
											mv_par02					,;	// 03. Almoxarifado ate
											GetMV( "MV_LOCPROC" )		,;	// 04. Armazem de processo
				      			 			dtos( GetMV( "MV_ULMES" ))	,;	// 05. Data do ultimo fechamento
				      			 			GetMV( "MV_RASTRO" )		,;	// 06. Verifica se utiliza rastreabilidade
				      			 			mv_par03					,;	// 07. Do produto
				      			 			mv_par04					,;	// 08. Ate o produto
				      			 			mv_par05					,;	// 09. Zera saldo da MOD
				      			 			mv_par06					,;	// 10. Zera CM da MOD
				      			 			If( l300SalNeg, '1', '0' )  ,;	// 11. Permite saldo negativo
				      			 			If( lCstOnLine, '1', '0' )  ,;	// 12. Verifica se devera utilizar o custo ON-LINE.
				      			 			If( lCusFil   , '1', '0' )  ,;	// 13. Verifica se o sistema utiliza o custo unificado por Filial
				      			 			If( lCusEmp   , '1', '0' )	,;	// 14. Verifica se o sistema utiliza o custo unificado por Empresa
				      			 			cMoeda300C					,;	// 15. Parametro MV_MOEDACM
											If(lD3Servico,'1','0')		,;	// 16. Considera o parametro MV_D3SERVI
											If(IntDL(),'1','0')			,;  // 17. Verifica a integracao com WMS
											GetMv("MV_CQ"))					// 18. Codigo do Armazem de CQ
				      			 			
						If !lBat
							If Empty(aResult)
								lProcessa := .F.
								aAdd(aProcsOk,cTexto+'Erro na chamada do processo: Refaz saldos em estoque.') // 'Erro na chamada do processo: Refaz saldos em estoque.'
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza o log de processamento			    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								ProcLogAtu("MENSAGEM",cTexto+'Erro na chamada do processo: Refaz saldos em estoque.',cTexto+'Erro na chamada do processo: Refaz saldos em estoque.') // 'Erro na chamada do processo: Refaz saldos em estoque.'
							ElseIf aResult[1] == "01" .Or. aResult[1] == "1"
								lProcessa := .T.
								aAdd(aProcsOk,cTexto+"Processamento Refaz Saldos em Estoque - Ok") //"Processamento Refaz Saldos em Estoque - Ok"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza o log de processamento			    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								ProcLogAtu("MENSAGEM",cTexto+"Processamento Refaz saldos em Estoque - Ok",cTexto+"Processamento Refaz saldos em Estoque - Ok") //"Processamento Refaz saldos em Estoque - Ok"
							Else
								lProcessa := .F.
								aAdd(aProcsOk,cTexto+'Refaz saldos em estoque com Erro') //'Refaz saldos em estoque com Erro'
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza o log de processamento			    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								ProcLogAtu("MENSAGEM",cTexto+'Refaz saldos em estoque com Erro',cTexto+'Refaz saldos em estoque com Erro') //'Refaz saldos em estoque com Erro'
							EndIf
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ MAT053 - Executa o acerto do campo BE_STATUS                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lProcessa .And. IntDL()
				
							aResult:= TCSPExec(	xProcedures(cSPMAT053)		,;  // Chamada da procedure MAT053
												cFilAnt						,;	// 01. Codigo da filial corrente
												mv_par01					,;	// 02. Almoxarifado de
												mv_par02					,;	// 03. Almoxarifado ate
					      			 			mv_par03					,;	// 07. Do produto
					     			 			mv_par04					,;  // 08. Ate o produto
					     			 			If( l300SalNeg, '1', '0' ) ) 	// 09. Permite saldo negativo
				
							If !lBat
								If Empty(aResult)
									aAdd(aProcsOk,cTexto+"Erro na chamada do processo: Acerto no status dos enderecos") // "Erro na chamada do processo: Acerto no status dos enderecos"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Atualiza o log de processamento			    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									ProcLogAtu("MENSAGEM",cTexto+"Erro na chamada do processo: Acerto no status dos enderecos",cTexto+"Erro na chamada do processo: Acerto no status dos enderecos") // "Erro na chamada do processo: Acerto no status dos enderecos"
								ElseIf aResult[1] == "01" .Or. aResult[1] == "1"
									aAdd(aProcsOk,cTexto+"Processamento Acerto no Status dos Enderecos - Ok") //"Processamento Acerto no Status dos Enderecos - Ok"
									aAdd(aProcsOk,cTexto+"Processamento Ok") //"Processamento Ok"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Atualiza o log de processamento			    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									ProcLogAtu("MENSAGEM",cTexto+"Processamento do Acerto no Status dos Enderecos - Ok",cTexto+"Processamento do Acerto no Status dos Enderecos - Ok") //"Processamento do Acerto no Status dos Enderecos - Ok"
								Else
									aAdd(aProcsOk,cTexto+"Acerto no status dos endereco com Erro") //"Acerto no status dos endereco com Erro"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Atualiza o log de processamento			    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									ProcLogAtu("MENSAGEM",cTexto+"Acerto no status dos endereco com Erro",cTexto+"Acerto no status dos endereco com Erro") //"Acerto no status dos endereco com Erro"
								EndIf
							EndIf
				
				        EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ DeletaSBF - Executa a limpeza da tabela SBF                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If lProcessa
	                        DeletaSBF()
						EndIf

                    EndIf

				Next nForFilial

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ MAT055 - Atualiza o custo unificado on-line por Empresa      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lProcessa .And. lCusEmp .And. lCstOnLine
		
					aResult:= TCSPExec(	xProcedures(cSPMAT055)		,;  // Chamada da procedure MAT055
										cFilAnt						,;	// 01. Codigo da filial corrente
										mv_par03					,;	// 02. Do produto
										mv_par04					,;	// 03. Ate o Produto
			      			 			If( lCstOnLine, '1', '0' )  ,;	// 04. Verifica se devera utilizar o custo ON-LINE.
			      			 			If( lCusFil   , '1', '0' )  ,;	// 05. Verifica se o sistema utiliza o custo unificado por Filial
			      			 			If( lCusEmp   , '1', '0' )	,;	// 06. Verifica se o sistema utiliza o custo unificado por Empresa
			     			 			cMoeda300C ) 					// 07. Parametro MV_MOEDACM

					If !lBat
						If Empty(aResult)
							lProcessa := .F.
							aAdd(aProcsOk,cTexto+"Erro na chamada do processo: Custo Unificado On-Line por Empresa") // "Erro na chamada do processo: Custo Unificado On-Line por Empresa"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","Erro na chamada do processo: Custo Unificado On-Line por Empresa","Erro na chamada do processo: Custo Unificado On-Line por Empresa") // "Erro na chamada do processo: Custo Unificado On-Line por Empresa"
						ElseIf aResult[1] == "01" .Or. aResult[1] == "1"
							lProcessa := .T.
							aAdd(aProcsOk,"Processamento do Custo Unificado On-Line por Empresa - Ok") //"Processamento do Custo Unificado On-Line por Empresa - Ok"
							aAdd(aProcsOk,"Processamento Ok") //"Processamento Ok"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","Processamento do Custo Unificado On-Line por Empresa - Ok","Processamento do Custo Unificado On-Line por Empresa - Ok") //"Processamento do Custo Unificado On-Line por Empresa - Ok"
						Else
							lProcessa := .F.
							aAdd(aProcsOk,"Custo Unificado On-Line por Empresa com Erro") //"Custo Unificado On-Line por Empresa com Erro"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","Custo Unificado On-Line por Empresa com Erro","Custo Unificado On-Line por Empresa com Erro") //"Custo Unificado On-Line por Empresa com Erro"
						EndIf
					EndIf
		        EndIf
				//-- Restaura Filial Original
				cFilAnt := cFilBack
			EndIf						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PROCESSAMENTO MULT-THREAD                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ aFilsCalc - Array com filiais a serem processadas            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(aFilsCalc)
			
				For nForFilial := 1 To Len( aFilsCalc )
				
					If aFilsCalc[ nForFilial, 1 ]
					
						cFilAnt    := aFilsCalc[ nForFilial, 2 ]
						cTexto     := ""+cFilAnt+" - "
						lD3Servico := GetMV('MV_D3SERVI', .F., 'N')=='S'
						l300SalNeg := GetMV("MV_MT300NG",.F.,.T.)
						//-- Calcula a quantidade de Threads
						aThreads := A300QtdThread(mv_par03,mv_par04)
					
						For nX :=1 to Len(aThreads)
			
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM",cTexto+"Procedures: Iniciando Thread: ### " + StrZero(nX,3),cTexto+"Procedures: Iniciando Thread: ### " + StrZero(nX,3)) //"Procedures: Iniciando Thread: ### "
									
							// Informacoes do semaforo
							cJobFile:= cStartPath + CriaTrab(Nil,.F.)+".job"
							
							// Adiciona o nome do arquivo de Job no array aJobAux
							aAdd(aJobAux,{StrZero(nX,2),cJobFile})
					
							// Inicializa variavel global de controle de thread
							cJobAux:="c300P"+cEmpAnt+cFilAnt+StrZero(nX,2)
							PutGlbValue(cJobAux,"0")
							GlbUnLock()
					
							aDataProc := {	cFilAnt						,;	// 01. Codigo da filial corrente
											mv_par01					,;	// 02. Almoxarifado de
											mv_par02					,;	// 03. Almoxarifado ate
											GetMV( "MV_LOCPROC" )		,;	// 04. Armazem de processo
					      			 		dtos( GetMV( "MV_ULMES" ))	,;	// 05. Data do ultimo fechamento
					      			 		GetMV( "MV_RASTRO" )		,;	// 06. Verifica se utiliza rastreabilidade
					      			 		aThreads[nX,1]				,;	// 07. Do produto
					      			 		aThreads[nX,2]				,;	// 08. Ate o produto
					      			 		mv_par05					,;	// 09. Zera saldo da MOD
					      			 		mv_par06					,;	// 10. Zera CM da MOD
					      			 		If( l300SalNeg, '1', '0' )  ,;	// 11. Permite saldo negativo
					      			 		If( lCstOnLine, '1', '0' )  ,;	// 12. Verifica se devera utilizar o custo ON-LINE.
					      			 		If( lCusFil   , '1', '0' )  ,;	// 13. Verifica se o sistema utiliza o custo unificado por Filial
					      			 		If( lCusEmp   , '1', '0' )	,;	// 14. Verifica se o sistema utiliza o custo unificado por Empresa
					      			 		cMoeda300C 					,;	// 15. Parametro MV_MOEDACM
											If(lD3Servico,'1','0')		,;	// 16. Considera o parametro MV_D3SERVI
											If(IntDL(),'1','0')			,;  // 17. Verifica a integracao com WMS
											GetMv("MV_CQ")}					// 18. Codigo do Armazem de CQ
					      			 			
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Dispara thread para Stored Procedure        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                          
							StartJob("A300JOB",GetEnvServer(),lThrSeq,cEmpAnt,cFilAnt,cSPMAT040,aDataProc,cJobFile,StrZero(nX,2))
						
				        Next nX
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Controle de Seguranca para MULTI-THREAD                                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For nX :=1 to Len(aThreads)
				
							nPos := ASCAN(aJobAux,{|x| x[1] == StrZero(nX,2)})
								
							// Informacoes do semaforo
							cJobFile:= aJobAux[nPos,2]
				
				   			// Inicializa variavel global de controle de thread
							cJobAux:="c300P"+cEmpAnt+cFilAnt+StrZero(nX,2)
				    	
							aDataProc := {	cFilAnt						,;	// 01. Codigo da filial corrente
											mv_par01					,;	// 02. Almoxarifado de
											mv_par02					,;	// 03. Almoxarifado ate
											GetMV( "MV_LOCPROC" )		,;	// 04. Armazem de processo
				      			 			dtos( GetMV( "MV_ULMES" ))	,;	// 05. Data do ultimo fechamento
					      			 		GetMV( "MV_RASTRO" )		,;	// 06. Verifica se utiliza rastreabilidade
					      			 		aThreads[nX,1]				,;	// 07. Do produto
				    	  			 		aThreads[nX,2]				,;	// 08. Ate o produto
				      				 		mv_par05					,;	// 09. Zera saldo da MOD
				      				 		mv_par06					,;	// 10. Zera CM da MOD
				      				 		If( l300SalNeg, '1', '0' )  ,;	// 11. Permite saldo negativo
				      			 			If( lCstOnLine, '1', '0' )  ,;	// 12. Verifica se devera utilizar o custo ON-LINE.
				      			 			If( lCusFil   , '1', '0' )  ,;	// 13. Verifica se o sistema utiliza o custo unificado por Filial
					      			 		If( lCusEmp   , '1', '0' )	,;	// 14. Verifica se o sistema utiliza o custo unificado por Empresa
					      			 		cMoeda300C 					,;	// 15. Parametro MV_MOEDACM
											If(lD3Servico,'1','0')		,;	// 16. Considera o parametro MV_D3SERVI
											If(IntDL(),'1','0')			,;  // 17. Verifica a integracao com WMS
											GetMv("MV_CQ")}					// 18. Codigo do Armazem de CQ
				
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Analise das Threads em Execucao                              ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								While .T.
									Do Case
										// TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
										Case GetGlbValue(cJobAux) == '0'
					                        If nRetry_0 > 50
												Conout(Replicate("-",65))							 	//"-----------------------------------------------------"
												Conout("MATA300: "+ "MATA300: Não foi possivel realizar a subida da thread" + " " + StrZero(nX,3) )	//"MATA300: Não foi possivel realizar a subida da thread"
												Conout(Replicate("-",65))  								//"-----------------------------------------------------"
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Atualiza o log de processamento			    ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												ProcLogAtu("MENSAGEM","Não foi possivel realizar a subida da thread","Não foi possivel realizar a subida da thread")	//"Não foi possivel realizar a subida da thread"
												Final("Não foi possivel realizar a subida da thread") 							//"Não foi possivel realizar a subida da thread"
					                        Else
					                        	nRetry_0 ++
					                        EndIf
										// TRATAMENTO PARA ERRO DE CONEXAO
										Case GetGlbValue(cJobAux) == '1'
											If FCreate(cJobFile) # -1
												If nRetry_1 > 5
													Conout(Replicate("-",65))  //"------------------------------------------------"
													Conout("MATA300: Erro de conexao na thread de procedures") 			//"MATA300: Erro de conexao na thread de procedures"
													Conout("Thread numero : " + cJobAux )	//"Thread numero : "
													Conout("Numero de tentativas excedidas")				//"Numero de tentativas excedidas"
													Conout(Replicate("-",65))  //"------------------------------------------------"
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³ Atualiza o log de processamento			    ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													ProcLogAtu("MENSAGEM","MATA300: Erro de conexao na thread de procedures","MATA300: Erro de conexao na thread de procedures")	//"MATA300: Erro de conexao na thread de procedures"
													Final("MATA300: Erro de conexao na thread de procedures")				   			//"MATA300: Erro de conexao na thread de procedures"
												Else
									    			// Inicializa variavel global de controle de Job
													PutGlbValue(cJobAux, "0" )
													GlbUnLock()
													// Reiniciar thread de contabilizacao
													Conout(Replicate("-",65))					//"------------------------------------------------"
													Conout("MATA300: Erro de conexao na thread de procedures") 							//"MATA300: Erro de conexao na thread de procedures"
													Conout("Tentativa numero: "+StrZero(nRetry_1,2))			//"Tentativa numero: "
													Conout("Reiniciando a thread : "+cJobAux )					//"Reiniciando a thread : "
													Conout(Replicate("-",65))                  //"------------------------------------------------"	
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³ Atualiza o log de processamento			    ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													ProcLogAtu("MENSAGEM","Reiniciando a thread : "+cJobAux,"Reiniciando a thread : "+cJobAux)	//"Reiniciando a thread : "
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³ Dispara thread para Stored Procedure        ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													StartJob("A300JOB",GetEnvServer(),lThrSeq,cEmpAnt,cFilAnt,cSPMAT040,aDataProc,cJobFile,StrZero(nX,2))
												EndIf
												nRetry_1 ++ 
											EndIf
										// TRATAMENTO PARA ERRO DE APLICACAO
										Case GetGlbValue(cJobAux) == '2'
											If FCreate(cJobFile) # -1
												Conout(Replicate("-",65))	//"-------------------------------------------------"	
												Conout("MATA300: Erro de aplicacao na thread de procedures")				//"MATA300: Erro de aplicacao na thread de procedures"
												Conout("Thread numero : "+cJobAux)		//"Thread numero : "
												Conout(Replicate("-",65))  //"--------------------------------------------------"	
												lProcessa := .F.
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Atualiza o log de processamento			    ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												ProcLogAtu("MENSAGEM","MATA300: Erro de aplicacao na thread de procedures","MATA300: Erro de aplicacao na thread de procedures")	//"MATA300: Erro de aplicacao na thread de procedures"
												Final("MATA300: Erro de aplicacao na thread de procedures") 							//"MATA300: Erro de aplicacao na thread de procedures"
											EndIf
										// THREAD PROCESSADA CORRETAMENTE
										Case GetGlbValue(cJobAux) == '3'
											lProcessa := .T.
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Atualiza o log de processamento			    ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											ProcLogAtu("MENSAGEM","Processamento Thread : #### - Ok " + cJobAux + " - Ok ","Processamento Thread : #### - Ok " + cJobAux + " - Ok ")	//"Processamento Thread : #### - Ok "
											aAdd(aProcsOk,"Processamento Thread : #### - Ok " + cJobAux + " - Ok ") 										//"Processamento Thread : #### - Ok "
											Exit
										// THREAD PROCESSADA COM ERRO NA CHAMADA DO PROCESSO
										Case GetGlbValue(cJobAux) == '4'
											lProcessa := .F.
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Atualiza o log de processamento			    ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											ProcLogAtu("MENSAGEM",cTexto+"Erro na chamada do processo",cTexto+"Erro na chamada do processo")	//"Erro na chamada do processo"
											Final(cTexto+"Erro na chamada do processo") 									//"Erro na chamada do processo"
										// THREAD PROCESSADA POREM REPROCESSAMENTO COM ERRO
										Case GetGlbValue(cJobAux) == '5'
											lProcessa := .F.
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Atualiza o log de processamento			    ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											ProcLogAtu("MENSAGEM",cTexto+"Reprocessamento com Erro",cTexto+"Reprocessamento com Erro")	//"Reprocessamento com Erro"
											Final(cTexto+"Reprocessamento com Erro")									//"Reprocessamento com Erro"
									EndCase
									Sleep(2500)
								End
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM",cTexto+"Termino do recalculo do saldo atual - Thread: " + StrZero(nX,3),cTexto+"Termino do recalculo do saldo atual - Thread: " + StrZero(nX,3)) //"Termino do recalculo do saldo atual - Thread: "
						Next nX

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ MAT053 - Executa o acerto do campo BE_STATUS                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lProcessa .And. IntDL()
							aResult:= TCSPExec(	xProcedures(cSPMAT053)		,;  // Chamada da procedure MAT053
												cFilAnt						,;	// 01. Codigo da filial corrente
												mv_par01					,;	// 02. Almoxarifado de
												mv_par02					,;	// 03. Almoxarifado ate
					      			 			mv_par03					,;	// 07. Do produto
					     			 			mv_par04					,;  // 08. Ate o produto
					     			 			If( l300SalNeg, '1', '0' ) ) 	// 09. Permite saldo negativo
				
							If !lBat
								If Empty(aResult)
									aAdd(aProcsOk,cTexto+"Erro na chamada do processo: Acerto no status dos enderecos") // "Erro na chamada do processo: Acerto no status dos enderecos"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Atualiza o log de processamento			    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									ProcLogAtu("MENSAGEM",cTexto+"Erro na chamada do processo: Acerto no status dos enderecos",cTexto+"Erro na chamada do processo: Acerto no status dos enderecos") // "Erro na chamada do processo: Acerto no status dos enderecos"
								ElseIf aResult[1] == "01" .Or. aResult[1] == "1"
									aAdd(aProcsOk,cTexto+"Erro na chamada do processo: Acerto no status dos enderecos") //"Processamento Acerto no Status dos Enderecos - Ok"
									aAdd(aProcsOk,cTexto+"Processamento Ok") //"Processamento Ok"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Atualiza o log de processamento			    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									ProcLogAtu("MENSAGEM",cTexto+"Processamento do Acerto no Status dos Enderecos - Ok",cTexto+"Processamento do Acerto no Status dos Enderecos - Ok") //"Processamento do Acerto no Status dos Enderecos - Ok"
								Else
									aAdd(aProcsOk,cTexto+"Acerto no status dos endereco com Erro") //"Acerto no status dos endereco com Erro"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Atualiza o log de processamento			    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									ProcLogAtu("MENSAGEM",cTexto+"Acerto no status dos endereco com Erro",cTexto+"Acerto no status dos endereco com Erro") //"Acerto no status dos endereco com Erro"
								EndIf
							EndIf
				        EndIf

   						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ DeletaSBF - Executa a limpeza da tabela SBF                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If lProcessa
	                        DeletaSBF()
						EndIf

			        EndIf
				Next nForFilial			        

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ MAT055 - Atualiza o custo unificado on-line por Empresa      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lProcessa .And. lCusEmp .And. lCstOnLine
		
					aResult:= TCSPExec(	xProcedures(cSPMAT055)		,;  // Chamada da procedure MAT055
										cFilAnt						,;	// 01. Codigo da filial corrente
										mv_par03					,;	// 02. Do produto
										mv_par04					,;	// 03. Ate o Produto
			      			 			If( lCstOnLine, '1', '0' )  ,;	// 04. Verifica se devera utilizar o custo ON-LINE.
			      			 			If( lCusFil   , '1', '0' )  ,;	// 05. Verifica se o sistema utiliza o custo unificado por Filial
			      			 			If( lCusEmp   , '1', '0' )	,;	// 06. Verifica se o sistema utiliza o custo unificado por Empresa
			     			 			cMoeda300C ) 					// 07. Parametro MV_MOEDACM

					If !lBat
						If Empty(aResult)
							lProcessa := .F.
							aAdd(aProcsOk,cTexto+"Erro na chamada do processo: Custo Unificado On-Line por Empresa") // "Erro na chamada do processo: Custo Unificado On-Line por Empresa"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","Erro na chamada do processo: Custo Unificado On-Line por Empresa","Erro na chamada do processo: Custo Unificado On-Line por Empresa") // "Erro na chamada do processo: Custo Unificado On-Line por Empresa"
						ElseIf aResult[1] == "01" .Or. aResult[1] == "1"
							lProcessa := .T.
							aAdd(aProcsOk,"Processamento do Custo Unificado On-Line por Empresa - Ok") //"Processamento do Custo Unificado On-Line por Empresa - Ok"
							aAdd(aProcsOk,"Processamento Ok") //"Processamento Ok"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","Processamento do Custo Unificado On-Line por Empresa - Ok","Processamento do Custo Unificado On-Line por Empresa - Ok") //"Processamento do Custo Unificado On-Line por Empresa - Ok"
						Else
							lProcessa := .F.
							aAdd(aProcsOk,"Custo Unificado On-Line por Empresa com Erro") //"Custo Unificado On-Line por Empresa com Erro"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","Custo Unificado On-Line por Empresa com Erro","Custo Unificado On-Line por Empresa com Erro") //"Custo Unificado On-Line por Empresa com Erro"
						EndIf
					EndIf
		        EndIf
				//-- Restaura Filial Original
				cFilAnt := cFilBack
			EndIf
        EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Refresh executado no TopConnect             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SX2")
		Set Filter to
		DbSetOrder(1)
		DbSeek("SB2")
		TcRefresh(RetArq("TOPCONN",Alltrim(X2_PATH)+Alltrim(X2_ARQUIVO),.T.))
		dbSelectArea("SB2")

	Else
#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ aFilsCalc - Array com filiais a serem processadas            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aFilsCalc)
	
		For nForFilial := 1 To Len( aFilsCalc )
		
			If aFilsCalc[ nForFilial, 1 ]
			
				cFilAnt := aFilsCalc[ nForFilial, 2 ]
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a ultima data de fechamento                   |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dUlMes     := GetMV('MV_ULMES')
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica qual o armazem de processo                    |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cLocProc   := GetMV( "MV_LOCPROC" )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Indica se permite saldo negativo                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				l300SalNeg := GetMV("MV_MT300NG",.F.,.T.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Codigo do Deposito de Transito                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cDepTran   := SuperGetMv("MV_DEPTRANS",.F.,"95") 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Indica se atualiza saldos atual do armazem de transito ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lTranSB2   := SuperGetMv("MV_TRANSB2",.F.,.F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Parametro que impede a gravacao do "Valor Atual" e dos | 
				//| "Custos" com valores negativos (Default="Sim")         |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lCustNeg   := (SuperGetMV('MV_CUSTNEG', .F., 'S')=='S') 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Seta os indices para chaves correspondentes                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB8")
				dbSetOrder(3)
				dbSelectArea("SB9")
				dbSetOrder(1)
				dbSelectArea("SB2")
				dbSetOrder(1)
				dbSelectArea("SD1")
				dbSetOrder(5)
				dbSelectArea("SD2")
				dbSetOrder(1)
				dbSelectArea("SD3")
				dbSetOrder(3)
				dbSelectArea("SD5")
				dbSetOrder(2)
				dbSelectArea("SBF")
				dbSetOrder(1)
				dbSelectArea("SDB")
				dbSetOrder(2)
				
				dbSelectArea("SB1")
				dbSeek(xFilial()+mv_par03,.T.)
				While !Eof() .And. B1_FILIAL == xFilial() .And. B1_COD <= mv_par04
					If !lBat	
						IncProc()
					EndIf	
					If IsProdMod(SB1->B1_COD) .And. (mv_par05 == 2 .And. mv_par06 == 2)
						//-- Verifica se devera recalcular o custo da MOD
						If !(mv_par05==3 .And. mv_par06 == 3)
							dbSkip()
							Loop
						EndIf	
					EndIf
					cLocal := Replicate("z",nTamLocal+1)  // Pega o Menor Local
					dUsai  := ""
					lFim   :=.F.
					
					dbSelectArea("SB2")
					dbSeek(xFilial()+SB1->B1_COD)
					lSb2:=!EOF()
					nSb2:=Recno()
					If lSb2
						cLocal:= IIF(SB2->B2_LOCAL< cLocal,SB2->B2_LOCAL,cLocal)
					EndIf
					dbSelectArea("SD1")
					dbSeek(xFilial()+SB1->B1_COD)
					lSd1:=!EOF()
					If lSd1
						cLocal:= IIF(SD1->D1_LOCAL< cLocal,SD1->D1_LOCAL,cLocal)
					EndIf
					
					dbSelectArea("SD2")
					dbSeek(xFilial()+SB1->B1_COD)
					lSd2:=!EOF()
					If lSd2
						cLocal:= IIF(SD2->D2_LOCAL< cLocal,SD2->D2_LOCAL,cLocal)
					EndIf
					
					dbSelectArea("SD3")
					dbSeek(xFilial()+SB1->B1_COD)
					lSd3:=!EOF()
					If lSd3
						cLocal:= IIF(SD3->D3_LOCAL< cLocal,SD3->D3_LOCAL,cLocal)
					EndIf
					
					dbSelectArea("SB9")
					dbSeek(xFilial()+SB1->B1_COD)
					lSb9:=!EOF()
					If lSb9
						cLocal:= IIF(SB9->B9_LOCAL< cLocal,SB9->B9_LOCAL,cLocal)
					EndIf
					
					lProcesProc	:=.F.
					nRegSB2 	:= 0
			
					Do While  lSb2 .Or. lSb9 .Or. lSd1 .Or. lSd2 .Or. lSd3
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se devera atualizar o saldo atual do armazem de  |
						//| transito ("MV_DEPTRAN")                                   | 
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If cPaisLoc <> "BRA"
							lContinua := IIf(cDepTran==cLocal,lTranSB2,.T.)
						EndIf	
						
						If lContinua .And. cLocal >= mv_par01 .And. cLocal <= mv_par02
							If cLocal == cLocProc
								lProcesProc:=.T.
							EndIf	
							aSaldo  := CalcEst(SB1->B1_COD,cLocal,dDataFim)
							If lFFonLine
								aSaldoFF:= CalcEstFF(SB1->B1_COD,cLocal,dDataFim)
							EndIf	
							dbSelectArea("SB9")
							dbSetOrder(1)
							dbSelectArea("SB2")
							dbSetOrder(1)
							dbSelectArea("SD1")
							dbSetOrder(5)
							dbSelectArea("SD2")
							dbSetOrder(1)
							dbSelectArea("SD3")
							dbSetOrder(3)
							dbSelectArea("SB2")
							dbSeek(xFilial()+SB1->B1_COD+cLocal)
							
							If !Eof()   // Apaga SB2 Duplicado
								nRegSB2   := Recno()
								cChaveSB2 := SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL
								dbSkip()
								While !Eof() .And. B2_FILIAL+B2_COD+B2_LOCAL == cChaveSB2
									RecLock("SB2",.F.)
									dbDelete()
									MsUnlock()
									dbSkip()
								End
								dbGoto(nRegSB2)
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Cria Almoxarifado no SB2                                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Else
								CriaSB2(SB1->B1_COD,cLocal)
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Trava o registro do SB2 para evitar divergencia de saldos	 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lLockSB2
								nRegSB2 := SB2->(Recno())
								RecLock("SB2",.F.)
							EndIf	
			
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Pesquisa £ltima saida no SD3                                 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dUsai := CtoD('01/01/80',"ddmmyy")
							dbSelectArea('SD3')
							dbSetOrder(7)
							dbSeek(xFilial('SD3')+SB1->B1_COD+cLocal+'zz', .T.)
							dbSkip(-1)
							Do While !Bof() .And. xFilial('SD3')+SB1->B1_COD+cLocal == D3_FILIAL+D3_COD+D3_LOCAL
								If D3_TM > '500' .And. D3_EMISSAO > dUsai
									dUsai := D3_EMISSAO
									Exit
								EndIf
								dbSkip(-1)
							EndDo
							dbSetOrder(3)
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Pesquisa £ltima saida no SD2                                 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dbSelectArea('SD2')
							dbSetOrder(6)
							dbSeek(xFilial('SD2')+SB1->B1_COD+cLocal+'zz', .T.)
							dbSkip(-1)
							Do While !Bof() .And. xFilial('SD2')+SB1->B1_COD+cLocal == D2_FILIAL+D2_COD+D2_LOCAL
								If SF4->(dbSeek(xFilial('SF4')+SD2->D2_TES, .F.))
									If SF4->F4_ESTOQUE == 'S' .And. IIf(lUsaD2DIG, D2_DTDIGIT, D2_EMISSAO) > dUsai
										dUsai := IIf(lUsaD2DIG, D2_DTDIGIT, D2_EMISSAO)
										Exit
									EndIf
								EndIf
								dbSkip(-1)
							EndDo
							dbSetOrder(1)
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Efetua a Grava‡ao da Data da ultima Saida                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If dUsai > Ctod('01/01/80',"ddmmyy")
								RecLock('SB2', .F.)
								Replace B2_USAI With dUsai
								If !lLockSB2	
									MsUnlock()
								EndIf	
							Else
								dbSelectArea('SB2')
							EndIf
			
							// Verifica se o local tem que ser considerado
							RecLock("SB2",.F.)
							If IsProdMod(SB1->B1_COD) .And. !(mv_par05==3 .And. mv_par06 == 3)
								// Zera o saldo da MOD (mv_par05 == 1 (Sim))				
								If mv_par05 == 1
									Replace B2_QATU With 0, B2_QTSEGUM With 0
									For ni := 1 to 5
										Fieldput(FieldPos(Eval(bBloco,"B2_VATU",ni)),0)
									Next ni	
								EndIf
								// Zera o CM da MOD (mv_par06 == 1 (Sim))				
								If mv_par06 == 1
									For ni := 1 to 5
										FieldPut(FieldPos(Eval(bBloco,"B2_CM",ni)),0)
									Next ni					
								EndIf	
							Else	
								Replace B2_QATU With aSaldo[1] , B2_QTSEGUM With aSaldo[7]
								If !Empty(SB1->B1_CONV) .And. QtdComp(ConvUm(SB1->B1_COD,B2_QATU,B2_QTSEGUM,2)) # QtdComp(B2_QTSEGUM)
									Replace B2_QTSEGUM With ConvUm(SB1->B1_COD,B2_QATU,B2_QTSEGUM,2)
								EndIf
								If lFFonLine
									Replace B2_QFIMFF  With aSaldoFF[1]
								EndIf
								
								// Verifica as divergencias entre a quantidade da primeira e da segunda UM
								MatQtdZero(.T.,.F.,.T.)
								For ni := 1 to 5
									//-- Parametro que impede a gravacao do "Valor Atual" e dos "Custos" com valores negativos (Default="Sim")
									If lCustNeg
										nVAtu := aSaldo[ni+1]
									Else
										nVAtu := If(QtdComp(aSaldo[ni+1])>0, aSaldo[ni+1], 0)
									EndIf		
									Fieldput(FieldPos(Eval(bBloco,"B2_VATU",ni)),nVAtu)
									If B2_QATU > 0.000001
										FieldPut(FieldPos(Eval(bBloco,"B2_CM",ni)),nVAtu / B2_QATU)
									EndIf
									If lFFOnLine
										//-- Parametro que impede a gravacao do "Valor Atual" e dos "Custos" com valores negativos (Default="Sim")
										If lCustNeg
											nVFF := aSaldo[ni+1]
										Else
											nVFF := If(QtdComp(aSaldoFF[ni+1])>0, aSaldoFF[ni+1], 0)
										EndIf		
										Fieldput(FieldPos(Eval(bBloco,"B2_VFIMFF",ni)),nVFF)
										If B2_QFIMFF > 0.000001
											FieldPut(FieldPos(Eval(bBloco,"B2_CMFF",ni)),nVFF / B2_QFIMFF)
										EndIf
									EndIf
								Next ni
								If !lLockSB2
									MsUnlock()
								EndIf	
							EndIf	
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Procura o proximo local nos 5 arquivos ( o menor e' que vale)³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nByte := ASC(Subs(cLocal,nTamLocal,1))+1      // Correcao do ADSLOCAL
						If nByte >= 58 .and. nByte <= 64
							nByte := 65
						EndIf          
						xLocal:= Subs(cLocal,1,nTamLocal-1)+Chr(nByte)
			
						cLocal:="zzz"
						dbSelectArea("SB2")
						dbSeek(xFilial()+SB1->B1_COD+xLocal,.T.)
						lSb2:=IIF(Eof(),.F.,SB2->B2_FILIAL+SB2->B2_COD == xFilial("SB2")+SB1->B1_COD)
						If lSb2
							cLocal:= IIF(SB2->B2_LOCAL< cLocal,SB2->B2_LOCAL,cLocal)
						EndIf
						
						dbSelectArea("SD1")
						dbSeek(xFilial()+SB1->B1_COD+xLocal,.T.)
						lSd1:=IIF(Eof(),.F.,SD1->D1_FILIAL+SD1->D1_COD == xFilial("SD1")+SB1->B1_COD)
						If lSd1
							cLocal:= IIF(SD1->D1_LOCAL< cLocal,SD1->D1_LOCAL,cLocal)
						EndIf
						dbSelectArea("SD2")
						dbSeek(xFilial()+SB1->B1_COD+xLocal,.T.)
						lSd2:=IIF(Eof(),.F.,SD2->D2_FILIAL+SD2->D2_COD == xFilial("SD2")+SB1->B1_COD)
						If lSd2
							cLocal:= IIF(SD2->D2_LOCAL< cLocal,SD2->D2_LOCAL,cLocal)
						EndIf
						
						dbSelectArea("SD3")
						dbSeek(xFilial()+SB1->B1_COD+xLocal,.T.)
						lSd3:=IIF(Eof(),.F.,SD3->D3_FILIAL+SD3->D3_COD == xFilial("SD3")+SB1->B1_COD)
						If lSd3
							cLocal:= IIF(SD3->D3_LOCAL< cLocal,SD3->D3_LOCAL,cLocal)
						EndIf
						
						dbSelectArea("SB9")
						dbSeek(xFilial()+SB1->B1_COD+xLocal,.T.)
						lSb9:=IIF(Eof(),.F.,SB9->B9_FILIAL+SB9->B9_COD == xFilial("SB9")+SB1->B1_COD)
						If lSb9
							cLocal:= IIF(SB9->B9_LOCAL< cLocal,SB9->B9_LOCAL,cLocal)
						EndIf
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Recompoe saldo do almoxarifado de processo caso necessario.  ³
						//³ (se o usuario apagar o SB2 e nao houverem requisicoes nao    ³
						//³ existem registros que se referenciem a este almoxarido).     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lSb2 .And. !lSb9 .And. !lSd1 .And. !lSd2 .And. !lSd3 .And. !lProcesProc .And. cLocProc >= mv_par01 .And. cLocProc <= mv_par02
							aSaldo:= CalcEst(SB1->B1_COD,cLocProc,dDataFim)
							If lFFOnLine
								aSaldoFF:= CalcEstFF(SB1->B1_COD,cLocProc,dDataFim)
							EndIf
							If QtdComp(aSaldo[1]) > QtdComp(0)
								dbSelectArea("SB2")
								If !dbSeek(xFilial()+SB1->B1_COD+cLocProc)
									CriaSB2(SB1->B1_COD,cLocProc)
								EndIf
								RecLock("SB2",.F.)
								Replace B2_QATU With aSaldo[1] , B2_QTSEGUM With aSaldo[7]
								If !Empty(SB1->B1_CONV) .And. QtdComp(ConvUm(SB1->B1_COD,B2_QATU,B2_QTSEGUM,2)) # QtdComp(B2_QTSEGUM)
									Replace B2_QTSEGUM With ConvUm(SB1->B1_COD,B2_QATU,B2_QTSEGUM,2)
								EndIf
								If lFFOnLine
									Replace B2_QFIMFF With aSaldoFF[1]
								EndIf
								// Verifica as divergencias entre a quantidade da primeira e da segunda UM
								MatQtdZero(.T.,.F.,.T.)
								For ni := 1 to 5
									//-- Parametro que impede a gravacao do "Valor Atual" e dos "Custos" com valores negativos (Default="Sim")
									If lCustNeg
										nVAtu := aSaldo[ni+1]
									Else
										nVAtu := If(QtdComp(aSaldo[ni+1])>0, aSaldo[ni+1], 0)
									EndIf		
									Fieldput(FieldPos(Eval(bBloco,"B2_VATU",ni)),nVAtu)
									If B2_QATU > 0.000001
										FieldPut(FieldPos(Eval(bBloco,"B2_CM",ni)),nVAtu / B2_QATU)
									EndIf
									If lFFOnLine
										//-- Parametro que impede a gravacao do "Valor Atual" e dos "Custos" com valores negativos (Default="Sim")
										If lCustNeg
											nVFF := aSaldoFF[ni+1]
										Else
											nVFF := If(QtdComp(aSaldoFF[ni+1])>0, aSaldoFF[ni+1], 0)
										EndIf		
										Fieldput(FieldPos(Eval(bBloco,"B2_VFIMFF",ni)),nVFF)
										If B2_QFIMFF > 0.000001
											FieldPut(FieldPos(Eval(bBloco,"B2_CMFF",ni)),nVFF / B2_QFIMFF)
										EndIf
									EndIf
								Next ni
								If !lLockSB2
									MsUnlock()
								EndIf	
							EndIf
			            EndIf
					EndDo
			
					If lLockSB2 .And. nRegSB2 > 0
						dbSelectArea("SB2")
						dbGoTo(nRegSB2)
						MsUnLock()
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza o custo unificado ON-LINE por Filial          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lCstOnLine .And. lCusFil .And. FindFunction("B2AtuUnif")
						B2AtuUnif(SB1->B1_COD)
					EndIf	
			
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³>>>Recompoe Saldo Atual da Rastreabilidade (SB8)<<<³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Rastro(SB1->B1_COD)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Zera os Valores do Produto no SB8³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea('SB8')
						dbSetOrder(3)
						If dbSeek(cSeek:=xFilial('SB8')+SB1->B1_COD,.F.)
							Do While !Eof() .And. cSeek == B8_FILIAL+B8_PRODUTO
								If B8_LOCAL<mv_par01 .Or. B8_LOCAL>mv_par02
									dbSkip()
									Loop
								EndIf
								RecLock('SB8', .F.)
								Replace B8_SALDO   With 0
								Replace B8_SALDO2  With 0
								MsUnlock()
								dbSkip()
							EndDo
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Pega Saldo Inicial de Rastreabilidade no SBJ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lSaldoIni := .F.
						dbSelectArea('SBJ')
						dbSetOrder(1)
						If dbSeek(cSeek:=xFilial('SBJ')+SB1->B1_COD, .F.)
							cAlmox    := ''
							cLoteCtl  := ''
							cNumLote  := ''
							dData     := CtoD('  /  /  ')
							dDtValid  := CtoD('  /  /  ')
							nQuant    := 0
							nQuant2   := 0
							Do While !Eof() .And. cSeek == BJ_FILIAL+BJ_COD
								dbSelectArea('SBJ')
								If BJ_LOCAL<mv_par01 .Or. BJ_LOCAL>mv_par02
									dbSkip()
									Loop
								EndIf
								cSeek1 := cSeek+BJ_LOCAL+BJ_LOTECTL+BJ_NUMLOTE
								Do While !Eof() .And. cSeek1 == BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL+BJ_NUMLOTE
									cAlmox    := BJ_LOCAL
									cLoteCtl  := BJ_LOTECTL
									cNumLote  := BJ_NUMLOTE
									dData     := BJ_DATA
									dDtValid  := BJ_DTVALID
									nQuant    := BJ_QINI
									nQuant2   := BJ_QISEGUM
									dbSkip()
								EndDo
								If dData == dUlMes
									lSaldoIni := .T.
									dbSelectArea('SB8')
									dbSetOrder(3)
									If !dbSeek(xFilial('SB8')+SB1->B1_COD+cAlmox+cLoteCtl+cNumLote, .F.)
										RecLock('SB8', .T.)
										Replace  B8_FILIAL  With xFilial('SB8')
										Replace  B8_PRODUTO With SB1->B1_COD
										Replace  B8_LOCAL   With cAlmox
										Replace  B8_LOTECTL With cLoteCtl
										Replace  B8_NUMLOTE With cNumLote
										Replace  B8_DATA    With dData
										If Empty(dDtValid)
											dDtValid:=dDataBase
										EndIf
										Replace B8_DTVALID With dDtValid
									Else
										RecLock('SB8', .F.)
									EndIf
									Replace B8_ORIGLAN with ''
									Replace B8_SALDO   With nQuant
									Replace B8_SALDO2  With nQuant2
									Replace B8_QTDORI  With Max(nQuant,B8_QTDORI)
									Replace B8_QTDORI2 With Max(nQuant2,B8_QTDORI2)
									If !Empty(SB1->B1_CONV)
										If QtdComp(ConvUm(SB1->B1_COD,B8_SALDO,B8_SALDO2,2)) # QtdComp(B8_SALDO2)
									 		Replace B8_SALDO2 With ConvUm(SB1->B1_COD,B8_SALDO,B8_SALDO2,2)
									 	Endif
										If QtdComp(ConvUm(SB1->B1_COD,B8_QTDORI,B8_QTDORI2,2)) # QtdComp(B8_QTDORI2)
									 		Replace B8_QTDORI2 With ConvUm(SB1->B1_COD,B8_QTDORI,B8_QTDORI2,2)
									 	Endif
									EndIf
									MsUnlock()
								EndIf
							EndDo
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Pega Movimentacoes de Rastreabilidade no SD5³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea('SD5')
						dbSetOrder(2)
						If dbSeek(cSeek:=xFilial('SD5')+SB1->B1_COD, .F.)
							cDoc     := ''
							cLoja    := ''
							cAlmox   := ''
							cSerie   := ''
							cCliFor  := ''
							cCampos  := ''
							cCompara := ''
							cOrigLan := ''
							cLoteCtl := ''
							cNumLote := ''
							cLoteFor := ''
							dData    := CtoD('  /  /  ')
							dDtValid := CtoD('  /  /  ')
							nQuant   := 0
							nQuant2  := 0
							Do While !Eof() .And. cSeek == SD5->D5_FILIAL+SD5->D5_PRODUTO
								dbSelectArea('SD5')
								If D5_LOCAL<mv_par01 .Or. D5_LOCAL>mv_par02 .Or. D5_ESTORNO == "S"
									dbSkip()
									Loop
								EndIf
								If lSaldoIni .And. D5_DATA<=dUlMes
									dbSkip()
									Loop
								EndIf
								nQuant   := 0
								nQuant2  := 0
								cCompara := D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
								cCampos  := 'D5_FILIAL+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE'
								Do While !Eof() .And. &cCampos == xFilial('SD5')+cCompara
									If D5_LOCAL<mv_par01 .Or. D5_LOCAL>mv_par02 .Or. D5_ESTORNO == "S"
										dbSkip()
										Loop
									EndIf
									If lSaldoIni .And. D5_DATA<=dUlMes
										dbSkip()
										Loop
									EndIf
									cAlmox      := D5_LOCAL
									cLoteCtl    := D5_LOTECTL
									cNumLote    := D5_NUMLOTE
									cLoteFor    := D5_LOTEFOR
									dData       := IIf(Empty(dData),D5_DATA,Min(D5_DATA,dData))
									dDtValid    := D5_DTVALID
									If !(Substr(D5_ORIGLAN,1,1)$'DúR')
										cOrigLan := If(Val(D5_ORIGLAN)>500,'DV','CP')
										cDoc     := D5_DOC
										cSerie   := D5_SERIE
										cCliFor  := D5_CLIFOR
										cLoja    := D5_LOJA
									Else
										cOrigLan := ''
										cDoc     := CriaVar('B8_DOC')
										cSerie   := CriaVar('B8_SERIE')
										cCliFor  := CriaVar('B8_CLIFOR')
										cLoja    := CriaVar('B8_LOJA')
									EndIf
									If D5_ORIGLAN<='500' .Or. D5_ORIGLAN $ 'DE·PR·MAN'
										nQuant   += D5_QUANT
										nQuant2  += D5_QTSEGUM
									Else
										nQuant   -= D5_QUANT
										nQuant2  -= D5_QTSEGUM
									EndIf
									dbSkip()
								EndDo
								dbSelectArea('SB8')
								dbSetOrder(3)
								If !dbSeek(xFilial('SB8')+cCompara, .F.)
									RecLock('SB8', .T.)
									Replace B8_FILIAL  With xFilial('SB8')
									Replace B8_PRODUTO With SB1->B1_COD
									Replace B8_LOCAL   With cAlmox
									Replace B8_LOTECTL With cLoteCtl
									Replace B8_NUMLOTE With cNumLote
									Replace B8_DATA    With dData
									Replace B8_ORIGLAN With cOrigLan
									Replace B8_LOTEFOR With cLoteFor
									Replace B8_DOC     With cDoc
									Replace B8_SERIE   With cSerie
									Replace B8_CLIFOR  With cCliFor
									Replace B8_LOJA    With cLoja
									Replace B8_DTVALID With dDtValid
								Else
									RecLock('SB8', .F.)
								EndIf
								Replace B8_SALDO   With If(QtdComp(B8_SALDO +nQuant )>QtdComp(0).Or.l300SalNeg,(B8_SALDO +nQuant ),0)
								Replace B8_SALDO2  With If(QtdComp(B8_SALDO2+nQuant2)>Qtdcomp(0).Or.l300SalNeg,(B8_SALDO2+nQuant2),0)
								Replace B8_QTDORI  With If(QtdComp(Max(B8_SALDO,B8_QTDORI))>QtdComp(0).Or.l300SalNeg,Max(B8_SALDO ,B8_QTDORI ),0)
								Replace B8_QTDORI2 With If(QtdComp(Max(B8_SALDO2,B8_QTDORI2))>QtdComp(0).Or.l300SalNeg,Max(B8_SALDO2,B8_QTDORI2),0)
								If !Empty(SB1->B1_CONV)
									If QtdComp(ConvUm(SB1->B1_COD,B8_SALDO,B8_SALDO2,2)) # QtdComp(B8_SALDO2)
								 		Replace B8_SALDO2 With ConvUm(SB1->B1_COD,B8_SALDO,B8_SALDO2,2)
								 	Endif
									If QtdComp(ConvUm(SB1->B1_COD,B8_QTDORI,B8_QTDORI2,2)) # QtdComp(B8_QTDORI2)
								 		Replace B8_QTDORI2 With ConvUm(SB1->B1_COD,B8_QTDORI,B8_QTDORI2,2)
								 	EndIf
								Endif
								MsUnlock()
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Utilizar ExeBlock para grava campos especificos em SB8.³
								//³Lucas 01/09/99 Argentina                               ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If ExistBlock('M300SB8')
									ExecBlock('M300SB8',.F.,.F.)
								EndIf
							EndDo
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³>>>Recompoe Saldo Atual das Localizacoes (SBF)<<<³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Localiza(SB1->B1_COD)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Zera o Saldo deste Produto no SBF³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aDeleSBF := {{}}
						dbSelectArea('SBF')
						dbSetOrder(2)
						If MsSeek(cSeek:=xFilial('SBF')+SB1->B1_COD, .F.)
							Do While !Eof() .And. cSeek == BF_FILIAL+BF_PRODUTO
								If BF_LOCAL < mv_par01 .Or. ;
									BF_LOCAL > mv_par02
									dbSkip()
									Loop
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Adiciona registro em array de prioridade. ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								For ni:=1 to Len(aPriori)
									If (nAchou:=aScan(aPriori[ni],{|x| x[1] == SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL+SBF->BF_NUMLOTE+SBF->BF_LOCALIZ+SBF->BF_NUMSERI })) > 0
										Exit
									EndIf
								Next ni
								If nAchou == 0
									If Len(aPriori[Len(aPriori)]) > 4095
										aAdd(aPriori,{})
									EndIf	
									aAdd(aPriori[Len(aPriori)], {SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL+SBF->BF_NUMLOTE+SBF->BF_LOCALIZ+SBF->BF_NUMSERI,SBF->BF_PRIOR,SBF->BF_EMPENHO })
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Adiciona registro em array para Exclusao Posterior ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If Len(aDeleSBF) > 4095
									aAdd(aDeleSBF, {})
								EndIf	
								aAdd(aDeleSBF[Len(aDeleSBF)], Recno())
								dbSkip()
							EndDo
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Exclui os registros do SBF ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For nX := 1 to Len(aDeleSBF)
							For nY := 1 to Len(aDeleSBF[nX])
								dbGoto(aDeleSBF[nX, nY])
								RecLock('SBF', .F.)
								Replace BF_QUANT   With 0
								Replace BF_QTSEGUM With 0
								MsUnlock()
								GravaSBF('SBF') //-- Exclui o Registro do SBF quando BF_QUANT MENOR OU IGUAL A ZERO
							Next nY	
						Next nX
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³M300SBF - Ponto de Entrada utilizado antes de iniciar  ³
						//³a reconstrucao do arquivo SBF.                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lM300SBF
							ExecBlock('M300SBF',.F.,.F.)
						EndIf
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Pega Saldo Inicial da Localizacao no SBK ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lSaldoIni := .F.
						dData     := CtoD('  /  /  ')
						nRecnoSBK := 0
						dbSelectArea('SBK')
						dbSetorder(1)
						If MsSeek(cSeek:=xFilial('SBK')+SB1->B1_COD, .F.)
							Do While !Eof() .And. cSeek == BK_FILIAL+BK_COD
								dbSelectArea('SBK')
								If BK_LOCAL < mv_par01 .Or. ;
									BK_LOCAL > mv_par02
									dbSkip()
									Loop
								EndIf
								cSeek1 := cSeek+BK_LOCAL+BK_LOTECTL+BK_NUMLOTE+BK_LOCALIZ+BK_NUMSERI
								Do While !Eof() .And. cSeek1 == BK_FILIAL+BK_COD+BK_LOCAL+BK_LOTECTL+BK_NUMLOTE+BK_LOCALIZ+BK_NUMSERI
									If BK_LOCAL < mv_par01 .Or. ;
										BK_LOCAL > mv_par02
										dbSkip()
										Loop
									EndIf
									dData     := BK_DATA
									nRecnoSBK := Recno()
									dbSkip()
								EndDo
								If nRecnoSBK > 0 .And. !Empty(dData) .And. dData == dUlMes
									dbGoto(nRecnoSBK)
									GravaSBF('SBK') //-- Efetua a inclusao dos Saldos com base no SBK atual
									If SBF->BF_QUANT > 0 .And. !Empty(SB1->B1_CONV)
										If QtdComp(ConvUm(SB1->B1_COD,SBF->BF_QUANT,SBF->BF_QTSEGUM,2)) # QtdComp(SBF->BF_QTSEGUM)
											Reclock('SBF', .F.)
											Replace BF_QTSEGUM With ConvUm(SB1->B1_COD,SBF->BF_QUANT,SBF->BF_QTSEGUM,2)
											MsUnlock()
										EndIf	
									EndIf	
									//-- Grava a Prioridade anteriormente atribuida no SBF
									For ni:=1 to Len(aPriori)
										If (nAchou:=aScan(aPriori[ni],{|x|x[1]==SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL+SBF->BF_NUMLOTE+SBF->BF_LOCALIZ+SBF->BF_NUMSERI})) > 0
											If !(SBF->BF_PRIOR==aPriori[ni, nAchou, 2]) .Or. !(SBF->BF_EMPENHO==aPriori[ni, nAchou, 3])
												Reclock('SBF', .F.)
												Replace BF_PRIOR   With aPriori[ni, nAchou, 2]
												Replace BF_EMPENHO With Min(BF_QUANT,aPriori[ni, nAchou, 3])									
												MsUnlock()
											EndIf	
											Exit
										EndIf
									Next ni
									lSaldoIni := .T.
									dData     := CtoD('  /  /  ')
									nRecnoSBK := 0
									dbSelectArea('SBK')
									dbSkip()
								EndIf
							EndDo
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Pega Movimentacoes de Localizacao no SDB³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea('SDB')
						dbSetOrder(2)
						If dbSeek(cSeek:=xFilial('SDB')+SB1->B1_COD, .F.)
							cCampos   := ''
							cCompara  := ''
							Do While !Eof() .And. cSeek == SDB->DB_FILIAL+SDB->DB_PRODUTO
								dbSelectArea('SDB')
								If DB_LOCAL < mv_par01 .Or. ;
									DB_LOCAL > mv_par02 .Or. ;
									DB_ESTORNO == 'S' .Or. ;
									DB_ATUEST == 'N' .Or. ;
									(lSaldoIni .And. DB_DATA <= dUlMes)
									dbSkip()
									Loop
								EndIf
								cCompara := DB_PRODUTO+DB_LOCAL+DB_LOTECTL+DB_NUMLOTE+DB_NUMSERI+DB_LOCALIZ
								cCampos  := 'DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_LOTECTL+DB_NUMLOTE+DB_NUMSERI+DB_LOCALIZ'
								Do While !Eof() .And. &cCampos == xFilial('SDB')+cCompara
									If DB_LOCAL < mv_par01 .Or. ;
										DB_LOCAL > mv_par02 .Or. ;
										DB_ESTORNO == 'S' .Or. ;
										DB_ATUEST == 'N' .Or. ;
										(lSaldoIni .And. DB_DATA <= dUlMes)
										dbSkip()
										Loop
									EndIf
									GravaSBF('SDB',, .F.)  //-- Efetua a inclusao dos Saldos com base no SBB atual SEM DELETAR OS REG. ZERADOS
									//-- Grava a Prioridade anteriormente atribuida no SBF
									If SBF->BF_QUANT > 0 .And. !Empty(SB1->B1_CONV)
										If QtdComp(ConvUm(SB1->B1_COD,SBF->BF_QUANT,SBF->BF_QTSEGUM,2)) # QtdComp(SBF->BF_QTSEGUM)
											Reclock('SBF', .F.)
											Replace BF_QTSEGUM With ConvUm(SB1->B1_COD,SBF->BF_QUANT,SBF->BF_QTSEGUM,2)
											MsUnlock()
										Endif	
									Endif	
									For ni:=1 to Len(aPriori)
										If (nAchou:=aScan(aPriori[ni],{|x|x[1]==SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL+SBF->BF_NUMLOTE+SBF->BF_LOCALIZ+SBF->BF_NUMSERI})) > 0
											If !(SBF->BF_PRIOR==aPriori[ni, nAchou, 2]) .Or. !(SBF->BF_EMPENHO==aPriori[ni, nAchou, 3])
												Reclock('SBF', .F.)
												Replace BF_PRIOR With aPriori[ni, nAchou, 2]
												Replace BF_EMPENHO With Min(BF_QUANT,aPriori[ni, nAchou, 3])
												MsUnlock()
											EndIf	
											Exit
										EndIf
									Next ni
									dbSelectArea('SDB')
									dbSkip()
								EndDo
							EndDo
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Vare o SBF e Deleta Saldos Zerados ou negativos ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aDeleSBF := {{}}
					dbSelectArea('SBF')
					dbSetOrder(2)
					If MsSeek(cSeek:=xFilial('SBF')+SB1->B1_COD, .F.)
						Do While !Eof() .And. cSeek == BF_FILIAL+BF_PRODUTO
							If BF_LOCAL < mv_par01 .Or. ;
								BF_LOCAL > mv_par02
								dbSkip()
								Loop
							EndIf
							If (QtdComp(BF_QUANT) < QtdComp(0) .And. !l300SalNeg) .Or. (QtdComp(BF_QUANT) == QtdComp(0))
								If Len(aDeleSBF) > 4095
									aAdd(aDeleSBF, {})
								EndIf	
								aAdd(aDeleSBF[Len(aDeleSBF)], Recno())
							EndIf
							dbSkip()
						EndDo
					EndIf
					For nX := 1 to Len(aDeleSBF)
						For nY := 1 to Len(aDeleSBF[nX])
							dbGoto(aDeleSBF[nX, nY])
							If QtdComp(BF_QUANT) < QtdComp(0)
								RecLock('SBF', .F.)
								Replace BF_QUANT   With 0
								Replace BF_QTSEGUM With 0
								MsUnlock()
							EndIf
							GravaSBF('SBF') //-- Exclui o Registro do SBF quando BF_QUANT MENOR OU IGUAL A ZERO
						Next nY	
					Next nX
			
					dbSelectArea('SB1')
					dbSkip()
				EndDo
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Restaura indices para ordem original                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbSelectArea("SD2")
				dbSetOrder(1)
				dbSelectArea("SD3")
				dbSetOrder(1)
				dbSelectArea("SB9")
				dbSetOrder(1)
			EndIf
		Next nForFilial
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o custo unificado ON-LINE por Empresa         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCstOnLine .And. lCusEmp .And. FindFunction("B2AtuUnif")
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			Do While !Eof() 
				If SB1->B1_COD >= mv_par03 .And. SB1->B1_COD <= mv_par04
					If !IsProdMod(SB1->B1_COD) 
						B2AtuUnif(SB1->B1_COD)
					EndIf	
				EndIf	
				dbSkip()
				Loop
			EndDo	
		EndIf	
	EndIf

#IFDEF TOP
EndIf
#ENDIF

//-- Restaura Filial Original
cFilAnt := cFilBack

MsUnlockAll()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha todos os arquivos e reabre-os de forma compartilhada   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTempoFim:=Seconds()
If lArqExcl
	DbCloseAll()
	OpenFile(SubStr(cNumEmp,1,2))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia mensagem de aviso apos termino da rotina               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTempo:=StrZero((nTempoFim-nTempoIni)/60,5,0)
MEnviaMail("022",{Substr(cUsuario,7,15),SubStr(cNumEmp,1,2),SubStr(cNumEmp,3,2),cTempo})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("MENSAGEM","Termino do recalculo do saldo atual","Termino do recalculo do saldo atual") //"Termino do recalculo do saldo atual"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("FIM")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apresenta mensagens relacionas a execucao das procedures.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aProcsOk) > 0 .And. !lBat .And. !IsBlind()
	DEFINE MSDIALOG oDlgOcorr TITLE OemToAnsi("Log de processamento das STORED PROCEDURES") From 8,05 To 20,65 OF oMainWnd	//"Log de processamento das STORED PROCEDURES"
	@ 1,001 LISTBOX oOcorr Fields HEADER Space(63) SIZE 190,70
	oOcorr:SetArray(aProcsOk)
	oOcorr:bLine := { || {aProcsOk[oOcorr:nAT]} }
	DEFINE SBUTTON FROM 18,202 TYPE 1 ACTION oDlgOcorr:End() ENABLE OF oDlgOcorr
	ACTIVATE MSDIALOG oDlgOcorr
EndIf

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTA300TOK ³ Autor ³Lucas                  ³ Data ³ 12/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida se pode efetuar o recalculo dos saldos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA300                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA300TOk()
Local lRet:=.T.
If ExistBlock("MA300OK")
	lRet:=ExecBlock("MA300OK",.F.,.F.)
	If ValType(lRet) # "L"
		lRet:=.T.	
	EndIf
EndIf
RETURN lRet 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Marcos V. Ferreira    ³ Data ³22.12.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necessarias para o programa               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local aArea := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local nTamSX1  := Len(SX1->X1_GRUPO)
     
//--------------------- MV_PAR07 -----------------------------------------------------
Aadd(aHelpPor,"Utilizada para travar registros do SB2")
Aadd(aHelpPor,"quando utilizado o MV_CUSTEXC=N para  ")
Aadd(aHelpPor,"evitar divergencias de saldo.		 ")
Aadd(aHelpPor,"Obs:Quando utilizado Stored Procedure ")
Aadd(aHelpPor,"e MV_CUSTEXC=N nao sera travado o SB2 ")
Aadd(aHelpPor,"por isso e recomendado MV_CUSTEXC=S   ")
Aadd(aHelpEng,"Used to lock SB2 records              ")
Aadd(aHelpEng,"when using  MV_CUSTEXC=N				 ")
Aadd(aHelpEng,"in order to avoid balance divergencies.")
Aadd(aHelpEng,"Note: When using Stored Procedure	 ")
Aadd(aHelpEng,"and MV_CUSTEXC=N, SB2, SB2 will not be locked")
Aadd(aHelpEng,"so MV_CUSTEXC=S is recommended		 ")
Aadd(aHelpSpa,"Se utiliza para trabar los registros del")
Aadd(aHelpSpa,"SB2 cuando se utiliza el MV_CUSTEXC=N ")
Aadd(aHelpSpa,"para evitar divergencias de saldo.	 ")
Aadd(aHelpSpa,"Obs.:Cuando se utiliza el Stored Procedure")
Aadd(aHelpSpa,"y el MV_CUSTEXC=N, no se trabara el SB2")
Aadd(aHelpSpa,"por esto se recomienda el MV_CUSTEXC=S")

PutSx1("MTA300","07","Travar Registros SB2 ?","¿Trabar los registros SB2? ","Lock SB2 Records ?","mv_ch7","N",1,0,2,"C","","","","","mv_par07","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//-- Adicionar o item Recalcular na pergunta 05 -------------------------------------------------
If SX1->(DbSeek (PADR("MTA300",nTamSX1)+"05"))
	RecLock("SX1",.F.)
	Replace SX1->X1_DEF03   	With "Recalcular"
	Replace SX1->X1_DEFSPA3		With "Recalcular"
    Replace SX1->X1_DEFENG3		With "Recalculating"
	MsUnLock()
EndIf

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

Aadd(aHelpPor,"Identifica se o programa deve zerar " )
Aadd(aHelpPor,"saldos de produto MOD ou nao, ja que " )
Aadd(aHelpPor,"estes produtos acumulam saldo negativo " )
Aadd(aHelpPor,"mes a mes.")
Aadd(aHelpPor,"Opções Disponiveis:")
Aadd(aHelpPor,"Sim - Zera os saldos dos produtos MOD" )
Aadd(aHelpPor,"Nao - Mantem os saldos dos produtos MOD" )
Aadd(aHelpPor,"Recalcular - Recompoe o saldo da MOD" )

Aadd(aHelpEng,"It identifies if the program must zero" )
Aadd(aHelpEng,"the product balances MOD or not, " )
Aadd(aHelpEng,"considering that these products keep an" )
Aadd(aHelpEng,"overdraw balance month by month  ")
Aadd(aHelpEng,"Opções Disponiveis:")
Aadd(aHelpEng,"Yes - Zero balances the product MOD" )
Aadd(aHelpEng,"No - Mantem the balances the product MOD" )
Aadd(aHelpEng,"Recalculating - Recompoe the balances MOD" )

Aadd(aHelpSpa,"Identifica si el programa debe dejar " )
Aadd(aHelpSpa,"en cero los saldos del producto MOD" )
Aadd(aHelpSpa,"o no, ya que estos productos acumulan" )
Aadd(aHelpSpa,"saldo negativo mes a mes.")
Aadd(aHelpSpa,"Opciones Disponiveis:")
Aadd(aHelpSpa,"Si - Zera los saldos del producto MOD" )
Aadd(aHelpSpa,"No - Mantiene los saldos del productos MOD" )
Aadd(aHelpSpa,"Recalcular - Recompoe los saldos MOD" )  

PutHelp("P.MTA30005.", aHelpPor, aHelpEng, aHelpSpa,.T.)

//-- Adicionar o item Recalcular na pergunta 06 -------------------------------------------------
If SX1->(DbSeek (PADR("MTA300",nTamSX1)+"06"))
	RecLock("SX1",.F.)
	Replace SX1->X1_DEF03   	With "Recalcular"
	Replace SX1->X1_DEFSPA3		With "Recalcular"
    Replace SX1->X1_DEFENG3		With "Recalculating"
	MsUnLock()
EndIf

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

Aadd(aHelpPor,"Identifica se o programa deve zerar " )
Aadd(aHelpPor,"o custo medio de produto MOD ou nao," )
Aadd(aHelpPor,"ja que estes produtos acumulam saldo" )
Aadd(aHelpPor,"negativo mes a mes e sofrem variacao")
Aadd(aHelpPor,"de custo a cada processamento.")
Aadd(aHelpPor,"Opções Disponiveis:")
Aadd(aHelpPor,"Sim - Zera o CM dos produtos MOD" )
Aadd(aHelpPor,"Nao - Mantem o CM dos produtos MOD" )
Aadd(aHelpPor,"Recalcular - Recompoe o CM da MOD" )

Aadd(aHelpEng,"It identifies whether or not the program" )
Aadd(aHelpEng,"must zero the MOD product average cost," )
Aadd(aHelpEng,"as these products accumulate a negative" )
Aadd(aHelpEng,"balance monthly, being subjected to a")
Aadd(aHelpEng,"cost variation every processing.")
Aadd(aHelpEng,"Opções Disponiveis:")
Aadd(aHelpEng,"Yes - Zero average cost the product MOD" )
Aadd(aHelpEng,"No - Mantem the average cost the product MOD" )
Aadd(aHelpEng,"Recalculating - Recompoe the average cost the product MOD" )

Aadd(aHelpSpa,"Identifica si el programa debe dejar" )
Aadd(aHelpSpa,"en cero el costo promedio del producto" )
Aadd(aHelpSpa,"MOD o no, pues estos productos acumulan" )
Aadd(aHelpSpa,"saldo negativo mes a mes y tienen variacion")
Aadd(aHelpSpa,"en el costo a cada procesamiento.")
Aadd(aHelpSpa,"Opções Disponiveis:")
Aadd(aHelpSpa,"Si - Cero el Costo promedio del producto MOD" )
Aadd(aHelpSpa,"No - Mantem el Costo promedio del producto MOD" )
Aadd(aHelpSpa,"Recalcular - Recompoe el Costo Promedio del producto MOD" )

PutHelp("P.MTA30006.", aHelpPor, aHelpEng, aHelpSpa,.T.)
                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona o Help da nova pergunta 08                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHelpPor:={};aHelpSpa:={};aHelpEng:={}
Aadd(aHelpPor,'Seleciona as filiais desejadas. Se NAO')
Aadd(aHelpPor,'apenas a filial corrente sera afetada.')
Aadd(aHelpPor,''                                      )
Aadd(aHelpSpa,'Selecciona las sucursales deseadas. Si')
Aadd(aHelpSpa,'NO solamente la sucursal actual es'    )
Aadd(aHelpSpa,'afectado.'                             )
Aadd(aHelpEng,'Select desired branch offices. If NO'  )
Aadd(aHelpEng,'only current branch office will be'    )
Aadd(aHelpEng,'affected.'                             )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona no grupo a nova pergunta 08                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1('MTA300',;                //-- 01 - X1_GRUPO
    '08',;                       //-- 02 - X1_ORDEM
    'Seleciona Filiais?',;       //-- 03 - X1_PERGUNT
    '¿Selecciona Sucursales?',;  //-- 04 - X1_PERSPA
    'Select Branch Offices?',;   //-- 05 - X1_PERENG
    'mv_ch8',;                   //-- 06 - X1_VARIAVL
    'N',;                        //-- 07 - X1_TIPO
    1,;                          //-- 08 - X1_TAMANHO
    0,;                          //-- 09 - X1_DECIMAL
    2,;                          //-- 10 - X1_PRESEL
    'C',;                        //-- 11 - X1_GSC
    '',;                         //-- 12 - X1_VALID
    '',;                         //-- 13 - X1_F3
    '',;                         //-- 14 - X1_GRPSXG
    '',;                         //-- 15 - X1_PYME
    'mv_par08',;                 //-- 16 - X1_VAR01
    'Sim',;                      //-- 17 - X1_DEF01
    'Si',;                       //-- 18 - X1_DEFSPA1
    'Yes',;                      //-- 19 - X1_DEFENG1
    '',;                         //-- 20 - X1_CNT01
    'Nao',;                      //-- 21 - X1_DEF02
    'No',;                       //-- 22 - X1_DEFSPA2
    'No',;                       //-- 23 - X1_DEFENG2
    '',;                         //-- 24 - X1_DEF03
    '',;                         //-- 25 - X1_DEFSPA3
    '',;                         //-- 26 - X1_DEFENG3
    '',;                         //-- 27 - X1_DEF04
    '',;                         //-- 28 - X1_DEFSPA4
    '',;                         //-- 29 - X1_DEFENG4
    '',;                         //-- 30 - X1_DEF05
    '',;                         //-- 31 - X1_DEFSPA5
    '',;                         //-- 32 - X1_DEFENG5
    aHelpPor,;                   //-- 33 - HelpPor
    aHelpSpa,;                   //-- 34 - HelpSpa
    aHelpEng,;                   //-- 35 - HelpEng
    '')                          //-- 36 - X1_HELP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona o Help A300EMP                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHelpPor := {};aHelpEng := {};aHelpSpa := {}
Aadd(aHelpPor,"Quanto utilizado o custo medio on-line"  )
Aadd(aHelpPor,"unificado por empresa, todas as filiais" )
Aadd(aHelpPor,"e todos os armazens serão processados."  )
Aadd(aHelpPor,"Independente da seleção efetuada nas "  )
Aadd(aHelpPor,"perguntas da rotina."  )
Aadd(aHelpEng,"" )
Aadd(aHelpSpa,"" )
PutHelp("PA300EMP", aHelpPor, aHelpEng, aHelpSpa,.T.)
aHelpPor := {};aHelpEng := {};aHelpSpa := {}
Aadd(aHelpPor,"Caso não esteja utilizando custo médio"  )
Aadd(aHelpPor,"on-line unificado por empresa, verifique" )
Aadd(aHelpPor,"a configuração dos parametros:          ")
Aadd(aHelpPor,"MV_CUSFIL e MV_CUSMED."                  )
Aadd(aHelpEng,"" )
Aadd(aHelpSpa,"" )
PutHelp("SA300EMP", aHelpPor, aHelpEng, aHelpSpa,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona o Help A300FIL                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHelpPor := {};aHelpEng := {};aHelpSpa := {}
Aadd(aHelpPor,"Quanto utilizado o custo medio on-line"  )
Aadd(aHelpPor,"unificado por filial, todos os armazens" )
Aadd(aHelpPor,"serão processados. Independente da "     )
Aadd(aHelpPor,"seleção efetuada nas perguntas da "      )
Aadd(aHelpPor,"rotina."                                 )
Aadd(aHelpEng,"" )
Aadd(aHelpSpa,"" )
PutHelp("PA300FIL", aHelpPor, aHelpEng, aHelpSpa,.T.)
aHelpPor := {};aHelpEng := {};aHelpSpa := {}
Aadd(aHelpPor,"Caso não esteja utilizando custo médio"  )
Aadd(aHelpPor,"on-line unificado por filial, verifique" )
Aadd(aHelpPor,"a configuração dos parametros:          ")
Aadd(aHelpPor,"MV_CUSFIL e MV_CUSMED."                  )
Aadd(aHelpEng,"" )
Aadd(aHelpSpa,"" )
PutHelp("SA300FIL", aHelpPor, aHelpEng, aHelpSpa,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta o conteudo do parametro MV_MT300NG                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX6")
If !GetMV("MV_MT300NG",.F.,.F.) .And. !(AllTrim(SX6->X6_DESC1)=='*')
	RecLock( "SX6",.F. )
	SX6->X6_DESC1   := '*'
	SX6->X6_CONTEUD := '.T.'
	SX6->X6_CONTSPA := '.T.'
	SX6->X6_CONTENG := '.T.'
	MsUnLock()
EndIf

RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VerIDProc ³ Autor ³ Marcelo Pimentel      ³ Data ³24.07.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Identifica a sequencia de controle do fonte ADVPL com a     ³±±
±±³          ³stored procedure, qualquer alteracao que envolva diretamente³±±
±±³          ³a stored procedure a variavel sera incrementada.            ³±±
±±³          ³Procedure MAT040                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
Static Function VerIDProc()
Return '010'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A300JOB   ³ Autor ³ Marcos V. Ferreira    ³ Data ³13.02.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para executar a procedure MAT040 em        ³±±
±±³          ³mult-thread.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp         - Empresa                                      ³±±
±±³          ³cFil         - Filial                                       ³±±
±±³          ³cProcNam     - Nome da procedure a ser executada            ³±±
±±³          ³aDataProc    - Dados enviados para chamada da procedure     ³±±
±±³          ³cJobFile     - Nome do arquivo para controle do JOB         ³±±
±±³          ³cThread      - Numero da Thread em execucao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA300                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
Static Function A300JOB(cEmp,cFil,cProcNam,aDataProc,cJobFile,cThread)
Local nHd1	    :=	0
Local aResult   

// Apaga arquivo ja existente
If File(cJobFile)
	fErase(cJobFile)
EndIf

// Criacao do arquivo de controle de jobs
nHd1 := MSFCreate(cJobFile)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("c300P"+cEmp+cFil+cThread, "1" )
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'EST')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("c300P"+cEmp+cFil+cThread, "2" )
GlbUnLock()

ConOut(dtoc(Date())+" "+Time()+" "+" Inicio do job de geração do saldo atual do MATA300 "+" "+cJobFile) //" Inicio do job de geração do saldo atual do MATA300 "

aResult:= TCSPExec(	xProcedures(cProcNam)		,;  // Chamada da procedure MAT040
					aDataProc[01]				,;	// 01. Codigo da filial corrente
					aDataProc[02]				,;	// 02. Almoxarifado de
					aDataProc[03]				,;	// 03. Almoxarifado ate
					aDataProc[04]				,;	// 04. Armazem de processo
		 			aDataProc[05]				,;	// 05. Data do ultimo fechamento
		 			aDataProc[06]				,;	// 06. Verifica se utiliza rastreabilidade
		 			aDataProc[07]				,;	// 07. Do produto
		 			aDataProc[08]				,;	// 08. Ate o produto
		 			aDataProc[09]				,;	// 09. Zera saldo da MOD
		 			aDataProc[10]				,;	// 10. Zera CM da MOD
		 			aDataProc[11]				,;	// 11. Permite saldo negativo
		 			aDataProc[12]			    ,;	// 12. Verifica se devera utilizar o custo ON-LINE.
		 			aDataProc[13]				,;	// 13. Verifica se o sistema utiliza o custo unificado por Filial
		 			aDataProc[14]				,;	// 14. Verifica se o sistema utiliza o custo unificado por Empresa
		 			aDataProc[15]				,;	// 15. Parametro MV_MOEDACM
		 			aDataProc[16]				,;	// 15. Parametro MV_MOEDACM
		 			aDataProc[17]				,;	// 15. Parametro MV_MOEDACM
		 			aDataProc[18])					// 15. Parametro MV_MOEDACM
      			 			
ConOut(dtoc(Date())+" "+Time()+" "+" Final do job de geração do saldo atual do MATA300 "+" "+cJobFile) //" Final do job de geração do saldo atual do MATA300 "

If Empty(aResult)
	// STATUS 4 - 'Erro na chamada do processo'
	PutGlbValue("c300P"+cEmp+cFil+cThread,"4")
	GlbUnLock()
ElseIf aResult[1] == "0"
	// STATUS 5 - 'Reprocessamento com Erro'
	PutGlbValue("c300P"+cEmp+cFil+cThread,"5")
	GlbUnLock()
ElseIf aResult[1] == "1"
	// STATUS 3 - Processamento efetuado com sucesso
	PutGlbValue("c300P"+cEmp+cFil+cThread,"3")
	GlbUnLock()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A300QtdThread ³ Autor ³ Marcos V. Ferreira ³ Data ³13.02.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para calcular a quantidade de threads a    ³±±
±±³          ³serem executadas em paralelo.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA300                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A300QtdThread(cProdIni,cProdFim)
Local aAreaAnt  := GetArea()
Local aProdutos := {}
Local aThreads  := {}
Local cQuery    := ''
Local nX        := 0
Local nInicio   := 0
Local nRegProc  := 0
Local cAliasSB1 := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_A300THR parametro utilizado para informar o numero |
//| de threads para o processamento.                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nThreads  := SuperGetMv('MV_A300THR',.F.,1)

Default cProdIni := ''
Default cProdFim := ''

//-- Define a string da query a ser processada
cQuery := "SELECT SB1.B1_COD "
cQuery += "FROM "
cQuery += RetSqlName("SB1") + " SB1 "
cQuery += "WHERE "
cQuery += "B1_FILIAL = '" + xFilial("SB1") + "' AND "
cQuery += "B1_COD >= '" + cProdIni + "' AND "
cquery += "B1_COD <= '" + cProdFim + "' AND "
cQuery += "D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY "
cQuery += "B1_FILIAL, B1_COD "
cQuery := ChangeQuery(cQuery)

//-- Verifica se o alias esta em uso
If Select( cAliasSB1 ) > 0
	dbSelectArea( cAliasSB1 )
	dbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.F.,.T.)

//-- Carrega Array aProdutos
Do While (cAliasSB1)->(!Eof())
	aAdd(aProdutos,(cAliasSB1)->B1_COD)
	(cAliasSB1)->(dbSkip())
EndDo

//-- Verifica Limite Maximo de 20 Threads
If nThreads > 20
	nThreads := 20
EndIf

//-- Analisa a quantidade de Threads X nRegistros
If Len(aProdutos) == 0
	aThreads := {}
ElseIf Len(aProdutos) < nThreads
	aThreads := ARRAY(1)			// Processa somente em uma thread
Else
	aThreads := ARRAY(nThreads)		// Processa com o numero de threads informada
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o registro original de cada thread e     ³
//³ aciona thread gerando arquivo de fila.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX:=1 to Len(aThreads)

	aThreads[nX]:={"","",1}
    
	// Registro inicial para processamento
	nInicio  := IIf( nX == 1 , 1 , aThreads[nX-1,3]+1 )

	// Quantidade de registros a processar
	nRegProc += IIf( nX == Len(aThreads) , Len(aProdutos) - nRegProc, Int(Len(aProdutos)/Len(aThreads)) )
	
	aThreads[nX,1] := aProdutos[nInicio]
	aThreads[nX,2] := aProdutos[nRegProc]
	aThreads[nX,3] := nRegProc

Next nX

//-- Encerra cAliasSB1
dbSelectArea(cAliasSB1)
dbCloseArea()

RestArea(aAreaAnt)
Return aThreads

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³GetSQLVersion ³ Autor ³ Marcos V. Ferreira ³ Data ³31.02.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para verificar a versao do SQL Server      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetSQLVersion()
Local cVersao  := ''
Local cDataBase := TcGetDb()
Local cAlias    := GetNextAlias()

If cDataBase == "MSSQL"
	cQuery   := "select substring(@@version,charindex('200',@@version),4) VER"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cAlias )
	cVersao  := AllTrim((cAlias)->VER)
	If Select( cAlias ) > 0
		(cAlias)->(dbCloseArea())
	EndIf	
EndIf
Return cVersao

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³DeletaSBF     ³ Autor ³ Microsiga S/A      ³ Data ³09.12.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para limpar SBF Zerados (Stored Procedures)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA300                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#IFDEF TOP
	Static Function DeletaSBF()
	Local aAreaAnt   := GetArea()
	Local aAreaSBF   := SBF->(GetArea())
	Local cAliasSBF  := GetNextAlias()
	Local cQuery     := ""
	Local lIntDl     := IntDl()
	Local l300SalNeg := GetMV("MV_MT300NG",.F.,.T.)
	If !l300SalNeg
		cQuery := "SELECT BF_QUANT, BF_EMPENHO, R_E_C_N_O_ RECNOSBF "
		cQuery +=   "FROM " + RetSqlName("SBF")+" SBF " 
		cQuery +=  "WHERE SBF.BF_FILIAL ='" + xFilial("SBF") + "' "
		cQuery +=    "AND SBF.BF_PRODUTO >='" + mv_par03 + "' "
		cQuery +=    "AND SBF.BF_PRODUTO <='" + mv_par04 + "' "
		cQuery +=    "AND SBF.BF_LOCAL   >='" + mv_par01 + "' "
		cQuery +=    "AND SBF.BF_LOCAL   <='" + mv_par02 + "' "
		cQuery +=    "AND D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSBF,.T.,.T.)
		aEval(SBF->(dbStruct()), {|x| If(x[2] <> "C" .And. (cAliasSBF)->(FieldPos(x[1]) > 0 ), TcSetField(cAliasSBF,x[1],x[2],x[3],x[4]),Nil)})
		Do While !Eof()
			If QtdComp((cAliasSBF)->BF_QUANT) <= QtdComp(0) .And. IIf(lIntDl,.T.,QtdComp((cAliasSBF)->BF_EMPENHO) <= QtdComp(0))
				dbSelectArea("SBF")
				dbGoto((cAliasSBF)->RECNOSBF)
				RecLock("SBF",.F.)
				dbDelete()
				MsUnLock()
			EndIf
			dbSelectArea(cAliasSBF)
			dbSkip()
		EndDo
		(cAliasSBF)->(dbCloseArea())
	EndIf
	RestArea(aAreaSBF)
	RestArea(aAreaAnt)
	Return
#ENDIF
