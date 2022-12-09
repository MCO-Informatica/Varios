#include 'TopConn.ch'
#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN025   บAutor  ณ Mauro Nagata       บ Data ณ  20/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio Margem de Contr.Direta de Obras                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico LISONDA                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFIN025()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Margem de Contr.Direta de Obras"
	Local cPict          := ""
	Local titulo         := "Margem de Contr.Direta de Obras"
	Local imprime     	 := .T.
	Local aOrd := {}
	//                                 10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
	//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Local Cabec1         := ""
	Local Cabec2         := ""
	//                       9999 - xxxxxxxxxxxxxxxxxxxx   |999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|99,999,999.99|
	Private a_Cols		 := {1, 29,40,51,62,73,84,95,106,117,128,139,150,161,172,183,194,206,220,36,46,49,60,62,72,74,84,86,96,98,108 }
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RFIN025" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "RFIN025"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFIN025" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private nLin         := 80
	Private nVlrImp      := 0         //valor dos impostos   

	Private cObrRestr := GetMV('MV_XOBRRES')
	Private cUsuObra  := GetMV('MV_XUSROBR') 
	Private cUsuMast  := GetMV('MV_XUSUMST')
	
	AMESES := {}
	a_pdados := {}
	a_rdados := {}

	ValidPerg()
	pergunte(cPerg,.T.)		

	Private cString := "CTT"
	dbSelectArea("CTT")
	dbSetOrder(1)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	If nLastKey == 27
		Return
	Endif
	SetDefault(aReturn,cString)
	If nLastKey == 27
		Return
	Endif
	nTipo := If(aReturn[4]==1,15,18)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    
   Cabec1  := "  OBRA    DESCRIวยO                                    CLIENTE               VLR. VENDA      VLR. CUSTO    R. PREVISTO   CUSTO REAL      RESULT.REAL    FISCAL    MARGEM DIRETA %"
	Cabec2  := "                                                                                  1                2           3=1-2          4             5=1-4                      6=5/1     "
	aCabec  := {"OBRA ","DESCRIวยO","CLIENTE","VLR. VENDA (1)","VLR. CUSTO (2)","R. PREVISTO (3=1-2)","CUSTO REAL (4)","RESULT.REAL (5=1-4)","FISCAL","MARGEM DIRETA %(6=5/1)"}
	
	RptStatus({|| Run2Repor(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRun2Repor บ Autor ณ Mauro Nagata       บ Data ณ 20/08/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Run2Repor(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local oProcess
	Local a_saldo		:= {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}
	Local n_countctt	:= 0
	Local a_totais		:= {0,0,0,0,0,0,0,0}
	Local aDados      := {}
	
	dbSelectArea("CTT")
	dbSetOrder(1) //CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_     
	DbSeek(xFilial('CTT')+MV_PAR01,.T.)
	n_atu   := 0
	n_count := 0
	While CTT->(!EOF()) .and. CTT->CTT_CUSTO <= MV_PAR02
		n_count++
		CTT->(Dbskip())
	EndDo
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SetRegua(n_count)
	
	DbSeek('  '+MV_PAR01,.T.)
	Do While CTT->(!EOF()) .and. CTT->CTT_CUSTO <= MV_PAR02
		n_atu++
	   	if AllTrim(CTT->CTT_CUSTO) $ cObrRestr
			if AllTrim(PswRet()[1][1]) # cUsuObra	
	 	    	CTT->(DbSkip())
	 	    	Loop
	 		EndIf
	 	EndIf  
	 		   
		If MV_PAR04 = 1
    		If CTT->CTT_MSBLQL <> '1'
				CTT->(DbSkip())
				Loop
			EndIf
		ElseIf MV_PAR04 = 2   //1=bloqueada, 2=Nao bloqueada, 3=Todas (bloqueada e nao bloqueada
			If CTT->CTT_MSBLQL = '1'
				CTT->(DbSkip())
				Loop
			EndIf
		EndIf
		
		DbSelectArea('AF8')
		DbSetOrder(8) //AF8_FILIAL, AF8_CODOBR, R_E_C_N_O_, D_E_L_E_T_
		n_valcust := 0
		If DbSeek(xFilial('AF8')+CTT->CTT_CUSTO)  

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAdicionado bloco abaixo para permitir que somente os usuแrios mastersณ
			//ณtenham acesso a obras de outras filiais [Bruno Parreira, 09/09/2011] ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If AllTrim(PswRet()[1][1]) # cUsuMast  
				DbSelectArea('CTT')
				If cFilAnt <> AF8->AF8_MSFIL	
	 	    		CTT->(DbSkip())
	 	    		Loop
	 			EndIf
	 		EndIf  
	 		//Fim Bloco               
	 		//incluida linha abaixo [Mauro Nagata, Actual Trend, 03/09/2013]
	 		cCliAF8 := AF8->AF8_CLIENT
			Do While !Eof().And.AF8->AF8_CODOBR = CTT->CTT_CUSTO
				n_ValCust += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
				AF8->(DbSkip())
			EndDo
		EndIf  
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif 
		
		cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCliAF8,"A1_NREDUZ")
		a_2pos   := { 1,10,53,75, 90, 105, 120,135,152,168}     
		
		@nLin,a_2pos[01] PSAY CTT->CTT_CUSTO
		@nLin,a_2pos[02] PSAY CTT->CTT_DESC01           
		@nLin,a_2pos[03] PSay cNomeCli
		@nLin,a_2pos[04] PSAY TransForm(CTT->CTT_XVLR	, "@RE 99,999,999.99")
		a_Totais[01] += CTT->CTT_XVLR           
		
		@nLin,a_2pos[05] PSAY TransForm(n_ValCust		, "@RE 99,999,999.99")
		a_Totais[02] += n_ValCust
		
		@nLin,a_2pos[06] PSAY TransForm(CTT->CTT_XVLR-n_ValCust, "@RE 99,999,999.99")
		a_Totais[03] += CTT->CTT_XVLR-n_ValCust
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAcumulado no periodo                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, MV_PAR03,,"A")},"Processando informa็๕es da Obra","Preparando . . .",.F.)
		
		oProcess:Activate()

		DbSelectArea('TRAB')
		DbSeek('028')

		a_Totais[04] += TRAB->TRB_TOT
		n_Result  	 := TRAB->TRB_TOT 		
		//n_PrvxReal	 := TRAB->TRB_TOT - n_ValCust
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 03/09/2013]
		n_PrvxReal	 := CTT->CTT_XVLR - n_Result
		//n_SalGast    := n_ValCust - TRAB->TRB_TOT
		//n_SalGast    := Iif(n_SalGast < 0, 0, n_SalGast)

		//a_Totais[05] += n_SalGast
		cNomeFisc := Posicione("SX5",1,xFilial("SX5")+"ZZ"+AF8->AF8_CODF1,"X5_DESCRI")
		@nLin,a_2pos[07] PSAY TransForm(n_Result, "@RE 99,999,999.99")
		a_Totais[06] += n_Result
		@nLin,a_2pos[08] PSAY TransForm(n_PrvxReal, "@RE 99,999,999.99")
		a_Totais[07] += n_PrvxReal
		@nLin,a_2pos[09] PSay cNomeFisc
		@nLin,a_2pos[10] PSay Round((n_PrvxReal/CTT->CTT_XVLR)*100,2)
		
		n_CountCtt++

		nLin++
		        
		aAdd(aDados,{CTT->CTT_CUSTO,CTT->CTT_DESC01,cNomeCli,CTT->CTT_XVLR,n_ValCust,CTT->CTT_XVLR-n_ValCust,n_Result,n_PrvxReal,cNomeFisc,Round((n_PrvxReal/CTT->CTT_XVLR)*100,2)})
		
		DbSelectArea("CTT")
		DbSkip()

	EndDo

	If n_CountCtt > 0
		@nLin,000 PSAY Replicate('*',220)
		nLin++
		@nLin,a_2pos[01] PSAY ' TOTAL DE OBRAS: ' + strzero(n_countctt, 4)
		@nLin,a_2pos[04] PSAY TransForm(a_totais[01], "@RE 99,999,999.99")
		@nLin,a_2pos[05] PSAY TransForm(a_totais[02], "@RE 99,999,999.99")
		@nLin,a_2pos[06] PSAY TransForm(a_totais[03], "@RE 99,999,999.99")
		@nLin,a_2pos[07] PSAY TransForm(a_totais[06], "@RE 99,999,999.99")
		@nLin,a_2pos[08] PSAY TransForm(a_totais[07], "@RE 99,999,999.99")

	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()   
	
	If MsgYesNo(OemToAnsi("Deseja gerar planilha Excel?"),"Gera็ใo da Planilha")
		If !ApOleClient( 'MsExcel' )
			MsgAlert("MsExcel nao instalado")
		Else
			If Len(aDados) <> 0
				MsgRun("Gerando Planilha Excel", "Rela็ao de baixa", {|| DlgToExcel ({ {"ARRAY", titulo+", emitido em "+Dtoc(dDataBase), aCabec, aDados } }) })
			EndIf
		EndIf
	EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณValidPerg บAutor  ณ Mauro Nagata       บData  ณ 20/08/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ                              							  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

Local aRegs   := {}

cPerg := PADR(cPerg,10)
//			Grupo 	/Ordem	/Pergunta				/Pergunta Espanhol	/Pergunta Ingles	/Variavel	/Tipo	/Tamanho	/Decimal/Presel	/GSC	/Valid	/Var01		/Def01	    /DefSpa1/DefEng1/Cnt01	/Var02	/Def02	      /DefSpa2/DefEng2/Cnt02	/Var03	/Def03	/DefSpa3/DefEng3/Cnt03	/Var04	/Def04	/DefSpa4/DefEng4/Cnt04	/Var05	/Def05	/DefSpa5/DefEng5/Cnt05	/F3		/GRPSX6
Aadd(aRegs,{cPerg	,"01"	,"Obra de  ?"	,""					,""					,"mv_ch1"	,"C"	,09			,00		,0		,"G"	,""		,"mv_par01"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"CTT"	,""		})
Aadd(aRegs,{cPerg	,"02"	,"Obra At้ ?"	,""					,""					,"mv_ch2"	,"C"	,09			,00		,0		,"G"	,""		,"mv_par02"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"CTT"	,""		})
Aadd(aRegs,{cPerg	,"03"	,"Ano Referencia   ?",""			,""					,"mv_ch3"	,"C"	,04			,00		,0		,"G"	,""		,"mv_par03"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})
Aadd(aRegs,{cPerg	,"04"	,"Obra     ?"	,""					,""					,"mv_ch4"	,"C"	,01			,00		,0		,"C"	,""		,"mv_par04"	,"Bloqueada"      ,""		,""		,""		,""		,"Nao Bloqueada" ,""		,""		,""		,""		,"Todas"		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""	    ,""		})    

LValidPerg( aRegs )

Return   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetCusto บAutor  ณAlexandre Sousa     บ Data ณ  11/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o custo do orcamento.                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRetCusto(c_prj, c_rev)

Local n_Ret := 0

c_query := " select * from "+RetSqlName('AFC')+" "
c_query += " where AFC_PROJET = '"+c_prj+"' "
c_query += " and   AFC_REVISA = '0001'"
c_query += " and   D_E_L_E_T_ <> '*' "
c_query += " and   AFC_NIVEL = '001' "
c_query += " and   AFC_FILIAL = '"+xFilial('AFC')+"' "

MemoWrite("RFIN011_CST",c_query)

If Select("TRP") > 0
	DbSelectArea("TRP")
	DbCloseArea()
EndIf

TcQuery c_Query New Alias "TRP"

If TRP->(!EOF())
	n_Ret := TRP->AFC_CUSTO
EndIf


Return n_Ret