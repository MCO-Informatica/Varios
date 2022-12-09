#include 'TopConn.ch'
#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN017   ºAutor  ³Alexandre Sousa     º Data ³  01/24/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio sintetico de totais de obras.                     º±±
±±º          ³Resumo financeiro total de obras.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFIN017()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Acompanhamento Financeiro da Obra"
	Local cPict          := ""
	Local titulo         := "Acompanhamento Financeiro da Obra"
	Local imprime     	 := .T.
	Local aOrd := {}
	//                                 10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
	//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Local Cabec1         := "Natureza                                |  2009    |  JANEIRO | FEVEREIRO|     MARÇO|    ABRIL |      MAIO|     JUNHO|     JULHO|    AGOSTO|  SETEMBRO|   OUTUBRO|       NOVEMBRO      |  DEZEMBRO|  VENCIDOS |      TOTAL |"
	Local Cabec2         := "                                        |          |                                                                                                             | REALIZADO|    ABERTO|                                     "
	//                       9999 - xxxxxxxxxxxxxxxxxxxx   |999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|99,999,999.99|
	Private a_Cols		 := {1,                          29,       40,        51,        62,        73,        84,        95,       106,       117,       128,       139,       150,       161,       172,       183,       194,       206,         220  ,36,    46,49,       60,62,      72,74,        84,86,     96,98,      108 }
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RFIN017" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "RFIN017"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFIN017" // Coloque aqui o nome do arquivo usado para impressao em disco
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

	AMESES := ARRAY(12)
	AMESES := {"JANEIRO","FEVEREIRO","MARCO","ABRIL",;
	"MAIO","JUNHO","JULHO","AGOSTO",;
	"SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
	If Day(dDataBase + 1) == 1
		if MONTH(dDataBase) == 12
			Mes1 := 1
		else
			Mes1:= MONTH(dDataBase) + 1
		Endif                                                                                   
	else
		Mes1:= MONTH(dDataBase)
	Endif
	if Mes1 == 12
		Mes2 := 1
	else
		Mes2:= Mes1 + 1
	endif
	
	if Mes2 == 12
		Mes3 := 1
	else
		Mes3:= Mes2 + 1
	endif
	
	Cabec1	:= "Natureza                                |  <-"+strzero(val(MV_PAR03)-1,4)+"  " //|  JANEIRO | FEVEREIRO|     MARÇO|    ABRIL |      MAIO|     JUNHO|     JULHO|    AGOSTO|  SETEMBRO|   OUTUBRO|       NOVEMBRO      |  DEZEMBRO|  VENCIDOS |        TOTAL|"
	Cabec2	:= "                                        |          " //|                                                                                                             | REALIZADO|    ABERTO|                                     "
	For n_x := 1 to 12          	
		If val(Substr(dtos(dDataBase),5,2)) = n_x .and. Substr(dtos(dDataBase),1,4) = MV_PAR03
			Cabec1 += "|"+space(8)+padr(AMESES[n_x],13)
			Cabec2 += "| REALIZADO|    ABERTO|"
		Else
			Cabec1 += "|"+padr(AMESES[n_x],10)
			Cabec2 += Space(11)
		EndIf
	Next
	Cabec1 += "|  VENCIDOS |        TOTAL|"
	
	Private cString := "CTT"
	dbSelectArea("CTT")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	If nLastKey == 27
		Return
	Endif
	SetDefault(aReturn,cString)
	If nLastKey == 27
		Return
	Endif
	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR04 == 1
//		Cabec1  := "  OBRA                           DESCRIÇÂO                               VLR. VENDA      VLR. CUSTO    R. PREVISTO   DESP.ACUMULADA  SLD.A GASTAR    R. ATUAL    RES.PREV.xREAL   POS. FINANC. MES"
//		Cabec2  := "                                                                              1              2             3=1-2          4             5=2-4          6=1-4         7=4-2   "
//		RptStatus({|| Run2Repor(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Else
		if AllTrim(mv_par01) $ cObrRestr .Or. AllTrim(mv_par02) $ cObrRestr
			if AllTrim(PswRet()[1][1]) $ cUsuObra
				RptStatus({|| RunReport1(Cabec1,Cabec2,Titulo,nLin) },Titulo)
			else
				MsgInfo('Usuário sem permissão para visualizar este Centro de Custo')
			EndIf
		else 
			RptStatus({|| RunReport1(Cabec1,Cabec2,Titulo,nLin) },Titulo)
		EndIf
	EndIf      
	
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT1º Autor ³ AP6 IDE            º Data ³  01/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport1(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local oProcess
	Local a_saldo := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}
	
	dbSelectArea("CTT")
	dbSetOrder(1) //CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_     
	DbSeek(xFilial('CTT')+MV_PAR01,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())
	
	If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 10
	Endif                       
	
	aSldMes := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

	While CTT->(!EOF()) .and. CTT->CTT_CUSTO <= MV_PAR02
		
	   	if AllTrim(CTT->CTT_CUSTO) $ cObrRestr
			if AllTrim(PswRet()[1][1]) # cUsuObra	
	 	    	CTT->(DbSkip())
	 	    	Loop
	 		EndIf
	 	EndIf  
	 		   
		If mv_par05 = 2
			If CTT->CTT_MSBLQL <> '2'
				CTT->(DbSkip())
				Loop
			EndIf
		EndIf
		
		DbSelectArea('AF8')
		DbSetOrder(8) //AF8_FILIAL, AF8_CODOBR, R_E_C_N_O_, D_E_L_E_T_
		n_valcust := 0
		
		If DbSeek(xFilial('AF8')+CTT->CTT_CUSTO)  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida o filtro de FISCAL de obra de ate                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If MV_PAR08 > AF8->AF8_CODF1 .or. MV_PAR09 < AF8->AF8_CODF1
		   		CTT->(DbSkip())
		   		Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adicionado bloco abaixo para permitir que somente os usuários masters³
			//³tenham acesso a obras de outras filiais [Bruno Parreira, 09/09/2011] ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if AllTrim(PswRet()[1][1]) # cUsuMast  
				DbSelectArea('CTT')
				if cFilAnt <> AF8->AF8_MSFIL
	 	    		CTT->(DbSkip())
	 	    		Loop
	 			EndIf
	 		EndIf  
	 		//Fim Bloco
			While AF8->AF8_CODOBR = CTT->CTT_CUSTO
				n_valcust += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
				AF8->(DbSkip())
			EndDo
		EndIf  

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
//			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
//			nLin := 9
//		Endif 
		
		nLin++
		@nLin,00 PSAY Alltrim(CTT->CTT_CUSTO) + " - " + SubStr(CTT->CTT_DESC01,1,30)
//		@nLin,a_Cols[14] PSAY "Valor Total da Obra: " + TransForm(CTT->CTT_XVLR, "@RE 99,999,999.99")
//		@nLin,a_Cols[07] PSAY "Custo Estimado da Obra: " + TransForm(n_valcust, "@RE 99,999,999.99")
//		nLin++
//		@nLin,00 PSAY " Cliente....: " + CTT->CTT_XCONT1+'/'+CTT->CTT_XLJCT1 + ' - ' + GetAdvFval('SA1', 'A1_NOME', xFilial('SA1')+CTT->CTT_XCONT1+CTT->CTT_XLJCT1, 1, '-')
//		@nLin,a_Cols[14] PSAY "Limite Fat. Direto : " + TransForm(CTT->CTT_XFATD, "@RE 99,999,999.99")
//		nLin++
//		nLin++
//		@nLin,00 PSAY Replicate('-', 220)
//		nLin++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Acumulado no periodo                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//oProcess := MsNewProcess():New({|lEnd| U_RFIN017a(oProcess,CTT->CTT_CUSTO, MV_PAR03)},"Processando informações da Obra","Preparando . . .",.F.)
		oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, MV_PAR03,,"A")},"Processando informações da Obra","Preparando . . .",.F.)
		oProcess:Activate()                              

		c_nat := ''
		DbSelectArea('TRAB')	
		DbGotop()
		DbSeek('050')

		n_y := 4                
		
		For n_x := 1 to 12
			If n_x = Val(substr(dtos(ddatabase),5,2)) .and. Substr(dtos(dDataBase),1,4) = MV_PAR03
				@nLin,a_Cols[n_y]   PSAY "|" + Transform( TRAB->TRB_REAL, "@RE 99,999,999")				
				@nLin,a_Cols[n_y+1] PSAY "|" + Transform( TRAB->TRB_ABER, "@RE 99,999,999")
				           
				aSldMes[n_y]   += TRAB->TRB_REAL
				aSldMes[n_y+1] += TRAB->TRB_ABER                                         
				n_y++
				
			Else
			   //@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->&("TRB_M"+strzero(n_x,2)), "@RE 99,999,999")
			   //substituida a linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 01/12/2011]
			   //inicio bloco [Mauro Nagata, Actual Trend, 01/12/2011]            
			   If TRAB->TRB_GRPO = "070" .Or. TRAB->TRB_GRPO = "071"
			      If n_x >= val(substr(dtos(ddatabase),5,2))
				     @nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->&("TRB_M"+strzero(n_x,2)), "@RE 99,999,999")
			      Else
			   	     @nLin,a_Cols[n_y] PSAY "|" + Transform( 0, "@RE 99,999,999")
		   	      EndIf
			   Else	     
			      @nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->&("TRB_M"+strzero(n_x,2)), "@RE 99,999,999")
			   EndIf	  
			   //fim bloco [Mauro Nagata, Actual Trend, 01/12/2011]  
			   
			   aSldMes[n_y] += TRAB->&("TRB_M"+strzero(n_x,2))
			EndIf
			n_y++
		Next
		@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_VENC, "@RE 99,999,999")
		aSldMes[n_y] += TRAB->TRB_VENC
		n_y++
		@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_TOT, "@RE 99,999,999")
		aSldMes[n_y] += TRAB->TRB_TOT
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		CTT->(dbSkip()) // Avanca o ponteiro do registro no arquivo

	EndDo
	
	aSldAcu := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}                         
	nSoma   := 0
	nLin++                       
	@ nLin,a_Cols[2] PSay Replicate("-",188)
	nLin++
	@ nLin,a_Cols[2] PSay "| SALDO MÊS"
	For nI := 1 To 15
	    @nLin,a_Cols[nI+3] PSAY "|" + Transform( aSldMes[nI+3], "@RE 99,999,999")
	    nSoma        += aSldMes[nI+3]
	    aSldAcu[nI] := nSoma
	Next
	nLin++                                
	@ nLin,a_Cols[2] PSay Replicate("-",188)
	nLin++
	@ nLin,a_Cols[2] PSay "| SALDO ACUMULADO"
	For nI := 1 To 14                            
	    If Month(dDataBase)+1 >= nI                           
	       @nLin,a_Cols[nI+3] PSAY "|" + Transform( aSldAcu[nI], "@RE 99,999,999")   
	    EndIf   
	Next
	nLin++
	@ nLin,a_Cols[2] PSay Replicate("-",188)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³Run2Repor º Autor ³ AP6 IDE            º Data ³  01/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Run2Repor(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local oProcess
	Local a_saldo		:= {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}
	Local n_countctt	:= 0
	Local a_totais		:= {0,0,0,0,0,0,0,0}
	
	dbSelectArea("CTT")
	dbSetOrder(1) //CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_     
	DbSeek(xFilial('CTT')+MV_PAR01,.T.)
	n_atu   := 0
	n_count := 0
	While CTT->(!EOF()) .and. CTT->CTT_CUSTO <= MV_PAR02
		n_count++
		CTT->(Dbskip())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(n_count)
	
	DbSeek('  '+MV_PAR01,.T.)
	While CTT->(!EOF()) .and. CTT->CTT_CUSTO <= MV_PAR02
		n_atu++
	   	if AllTrim(CTT->CTT_CUSTO) $ cObrRestr
			if AllTrim(PswRet()[1][1]) # cUsuObra	
	 	    	CTT->(DbSkip())
	 	    	Loop
	 		EndIf
	 	EndIf  
	 		   
		If mv_par05 = 2
			If CTT->CTT_MSBLQL <> '2'
				CTT->(DbSkip())
				Loop
			EndIf
		EndIf

		
		DbSelectArea('AF8')
		DbSetOrder(8) //AF8_FILIAL, AF8_CODOBR, R_E_C_N_O_, D_E_L_E_T_
		n_valcust := 0
		If DbSeek(xFilial('AF8')+CTT->CTT_CUSTO)  

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida o filtro de FISCAL de obra de ate                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If MV_PAR08 > AF8->AF8_CODF1 .or. MV_PAR09 < AF8->AF8_CODF1
		   		CTT->(DbSkip())
		   		Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adicionado bloco abaixo para permitir que somente os usuários masters³
			//³tenham acesso a obras de outras filiais [Bruno Parreira, 09/09/2011] ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if AllTrim(PswRet()[1][1]) # cUsuMast  
				DbSelectArea('CTT')
				if cFilAnt <> AF8->AF8_MSFIL	
	 	    		CTT->(DbSkip())
	 	    		Loop
	 			EndIf
	 		EndIf  
	 		//Fim Bloco
			While AF8->AF8_CODOBR = CTT->CTT_CUSTO
				n_valcust += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
				AF8->(DbSkip())
			EndDo
		EndIf  
		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif 
		
//                            10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//		Cabec1  := "  OBRA                           DESCRIÇÂO                               VLR. VENDA      VLR. CUSTO    R. PREVISTO   DESP.ACUMULADA  SLD.A GASTAR     RESULTADO   RES.PREV.xREAL   POS. FINANC. MES"
//		Cabec2  := "                                                                              1              2             3=1-2          4             5=2-4           6=3+5         7=6-3   "
//                   xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx             99,999,999.99  99,999,999.99  99,999,999.99    99,999,999.99 99,999,999.99 99,999,999.99    99,999,999.99      99,999,999.99
		a_2pos := { 1,              17,                                                  70,            85,            100,             117,          131,           145,             162,               181}
		@nLin,a_2pos[01] PSAY CTT->CTT_CUSTO
		@nLin,a_2pos[02] PSAY CTT->CTT_DESC01
		@nLin,a_2pos[03] PSAY TransForm(CTT->CTT_XVLR	, "@RE 99,999,999.99")
		a_totais[01] += CTT->CTT_XVLR
		@nLin,a_2pos[04] PSAY TransForm(n_valcust		, "@RE 99,999,999.99")
		a_totais[02] += n_valcust
		@nLin,a_2pos[05] PSAY TransForm(CTT->CTT_XVLR-n_valcust, "@RE 99,999,999.99")
		a_totais[03] += CTT->CTT_XVLR-n_valcust
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Acumulado no periodo                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oProcess := MsNewProcess():New({|lEnd| U_RFIN017a(oProcess,CTT->CTT_CUSTO, MV_PAR03)},"Processando Obra " +strzero(n_atu, 4)+ ' de '+strzero(n_count,4),"Preparando . . .",.F.)
		
		oProcess:Activate()

		DbSelectArea('TRAB')
		DbSeek('028')
		@nLin,a_2pos[06] PSAY TransForm(TRAB->TRB_TOT, "@RE 99,999,999.99")
		a_totais[04]	+= TRAB->TRB_TOT
		n_result		:= CTT->CTT_XVLR- TRAB->TRB_TOT //(CTT->CTT_XVLR-n_valcust) + (n_valcust - TRAB->TRB_TOT)
		n_prvxreal		:= TRAB->TRB_TOT - n_valcust//n_result - (CTT->CTT_XVLR-n_valcust)
		n_salgast := n_valcust - TRAB->TRB_TOT
		n_salgast := Iif(n_salgast < 0, 0, n_salgast)
		@nLin,a_2pos[07] PSAY TransForm(n_salgast, "@RE 99,999,999.99")
		a_totais[05] += n_salgast
		@nLin,a_2pos[08] PSAY TransForm(n_result, "@RE 99,999,999.99")
		a_totais[06] += n_result
		@nLin,a_2pos[09] PSAY TransForm(n_prvxreal, "@RE 99,999,999.99")
		a_totais[07] += n_prvxreal
		DbSelectArea('TRAB')
		DbSeek('050')
		@nLin,a_2pos[10] PSAY TransForm(TRAB->TRB_REAL, "@RE 99,999,999.99")
		a_totais[08] += TRAB->TRB_REAL
		n_countctt++

		nLin++

		CTT->(dbSkip()) // Avanca o ponteiro do registro no arquivo

	EndDo

	If n_countctt > 0
		@nLin,000 PSAY Replicate('*',220)
		nLin++
		@nLin,a_2pos[01] PSAY ' TOTAL DE OBRAS: ' + strzero(n_countctt, 4)
		@nLin,a_2pos[03] PSAY TransForm(a_totais[01], "@RE 99,999,999.99")
		@nLin,a_2pos[04] PSAY TransForm(a_totais[02], "@RE 99,999,999.99")
		@nLin,a_2pos[05] PSAY TransForm(a_totais[03], "@RE 99,999,999.99")
		@nLin,a_2pos[06] PSAY TransForm(a_totais[04], "@RE 99,999,999.99")
		@nLin,a_2pos[07] PSAY TransForm(a_totais[05], "@RE 99,999,999.99")
		@nLin,a_2pos[08] PSAY TransForm(a_totais[06], "@RE 99,999,999.99")
		@nLin,a_2pos[09] PSAY TransForm(a_totais[07], "@RE 99,999,999.99")
		@nLin,a_2pos[10] PSAY TransForm(a_totais[08], "@RE 99,999,999.99")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ValidPerg ºAutor  ³Cosme da Silva NunesºData  ³13.11.2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                              							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local aRegs   := {}

cPerg := PADR(cPerg,10)
//			Grupo 	/Ordem	/Pergunta				/Pergunta Espanhol	/Pergunta Ingles	/Variavel	/Tipo	/Tamanho	/Decimal/Presel	/GSC	/Valid	/Var01		/Def01	    /DefSpa1/DefEng1/Cnt01	/Var02	/Def02	      /DefSpa2/DefEng2/Cnt02	/Var03	/Def03	/DefSpa3/DefEng3/Cnt03	/Var04	/Def04	/DefSpa4/DefEng4/Cnt04	/Var05	/Def05	/DefSpa5/DefEng5/Cnt05	/F3		/GRPSX6
Aadd(aRegs,{cPerg	,"01"	,"Obra de          ?"	,""					,""					,"mv_ch1"	,"C"	,09			,00		,0		,"G"	,""		,"mv_par01"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"CTT"	,""		})
Aadd(aRegs,{cPerg	,"02"	,"Obra Até         ?"	,""					,""					,"mv_ch2"	,"C"	,09			,00		,0		,"G"	,""		,"mv_par02"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"CTT"	,""		})
Aadd(aRegs,{cPerg	,"03"	,"Ano Referencia   ?"	,""					,""					,"mv_ch3"	,"C"	,04			,00		,0		,"G"	,""		,"mv_par03"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})
Aadd(aRegs,{cPerg	,"04"	,"Tipo             ?"	,""					,""					,"mv_ch4"	,"C"	,01			,00		,0		,"C"	,""		,"mv_par04"	,"Sintetico",""		,""		,""		,""		,"Analitico" ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""	    ,""		})    
Aadd(aRegs,{cPerg	,"05"	,"Impr. Bloqueadas ?"	,""					,""					,"mv_ch5"	,"C"	,01			,00		,0		,"C"	,""		,"mv_par05"	,"Sim"      ,""		,""		,""		,""		,"Nao"       ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""	    ,""		})    
Aadd(aRegs,{cPerg	,"06"	,"Filial de        ?"	,""					,""					,"mv_ch6"	,"C"	,02			,00		,0		,"G"	,""		,"mv_par06"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})
Aadd(aRegs,{cPerg	,"07"	,"Filial Até       ?"	,""					,""					,"mv_ch7"	,"C"	,02			,00		,0		,"G"	,""		,"mv_par07"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})
Aadd(aRegs,{cPerg	,"08"	,"Fiscal de        ?"	,""					,""					,"mv_ch8"	,"C"	,02			,00		,0		,"G"	,""		,"mv_par08"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"ZZ"	,""		})
Aadd(aRegs,{cPerg	,"09"	,"Fiscal Até       ?"	,""					,""					,"mv_ch9"	,"C"	,02			,00		,0		,"G"	,""		,"mv_par09"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"ZZ"	,""		})

LValidPerg( aRegs )

Return   





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN017a  ºAutor  ³Alexandre Sousa     º Data ³  10/18/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o arquivo temporario para impressao do relatorio.      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/* excluido bloco abaixo [Mauro Nagata, Actual Trend, 11/06/2012]
User Function RFIN017a(oObj, c_Obra, c_anoref, l_competencia)
  
	Local c_query   := ''
	Local c_EOL		:= chr(13)+chr(10)
	Local a_separar := {}
	Local n_totCRA  := 0
	Local n_totDA	:= 0
	Local a_fatdir	:= {}

	l_competencia := Iif(l_competencia = nil, .F., l_competencia)

	oObj:SetRegua1(12)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o arquivo de trabalho temporario                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oObj:IncRegua1("Criando arquivo de trabalho")
	aStruct := {}
	AAdd( aStruct, { "TRB_GRPO", "C", 03, 0 } )
	AAdd( aStruct, { "TRB_NAT" , "C", 10, 0 } )
	AAdd( aStruct, { "TRB_DESC", "C", 40, 0 } )
	AAdd( aStruct, { "TRB_ANT" , "N", 14, 2 } )
	For n_x := 1 to 12
		AAdd( aStruct, { "TRB_M"+strzero(n_x,2), "N", 14, 2 } )
	Next
	AAdd( aStruct, { "TRB_VENC", "N", 14, 2 } )
	AAdd( aStruct, { "TRB_TOT" , "N", 14, 2 } )
	AAdd( aStruct, { "TRB_REAL", "N", 14, 2 } )
	AAdd( aStruct, { "TRB_ABER", "N", 14, 2 } )

	If Select("TRAB") > 0
		DbSelectArea("TRAB")
		DbCloseArea()
	EndIf
	cArqTrab := CriaTrab( aStruct, .T. )
	dbUseArea(.T.,,cArqTrab,"TRAB",.F.,.F.)
	index on TRB_GRPO+TRB_NAT to (cArqTrab)
	TRAB->(DbSetOrder(1))
	dbSelectArea("TRAB")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query para buscar informaceos do contas a pagar                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oObj:IncRegua1("Sel. Registros CP")
	c_query := "select E2_XCC, E2_NATUREZ, SUM(E2_VALOR) as E2_VALOR, E2_VENCREA, sum(E2_SALDO) as E2_SALDO from (" + c_EOL
	c_query += "select E2_BAIXA, E2_VALOR as VALORI, E2_SALDO, E2_VENCREA, isnull(EV_NATUREZ, E2_NATUREZ) as E2_NATUREZ, EV_PERC, isnull(EZ_CCUSTO, E2_XCC) as E2_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E2_VALOR)) as E2_VALOR, EZ_PERC" + c_EOL
	c_query += "from SE2010 " + c_EOL
	c_query += "left join SEV010" + c_EOL
	c_query += "on        EV_FILIAL   = E2_FILIAL" + c_EOL
	c_query += "and       EV_PREFIXO  = E2_PREFIXO" + c_EOL
	c_query += "and       EV_NUM      = E2_NUM" + c_EOL
	c_query += "and       EV_PARCELA  = E2_PARCELA" + c_EOL
	c_query += "and       EV_TIPO     = E2_TIPO" + c_EOL
	c_query += "and       EV_CLIFOR   = E2_FORNECE" + c_EOL
	c_query += "and       EV_LOJA     = E2_LOJA" + c_EOL
	c_query += "and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "left join SEZ010" + c_EOL
	c_query += "on        EZ_FILIAL   = EV_FILIAL" + c_EOL
	c_query += "and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
	c_query += "and       EZ_NUM      = EV_NUM" + c_EOL
	c_query += "and       EZ_PARCELA  = EV_PARCELA" + c_EOL
	c_query += "and       EZ_TIPO     = EV_TIPO" + c_EOL
	c_query += "and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
	c_query += "and       EZ_LOJA     = EV_LOJA" + c_EOL
	c_query += "and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
	c_query += "and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "where     SE2010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "and       E2_SALDO  = 0	" + c_EOL
	c_query += "and       E2_DTFATUR = '' " + c_EOL        //somente titulos nao faturados [Mauro Nagata, Actual Trend, 10/01/2011]
	//c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
	//substituida a linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 30/11/2011]
	//inicio bloco [Mauro Nagata, Actual Trend, 30/11/2011]	
	If l_competencia 
	   c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
	Else   
	   c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
	EndIf   
	//fim bloco [Mauro Nagata, Actual Trend, 30/11/2011]	
	
	c_query += ") A       where E2_XCC = '"+c_Obra+"'" + c_EOL
	c_query += "group by  E2_XCC, E2_NATUREZ, E2_VENCREA " + c_EOL
	
	c_query += "union all " + c_EOL
	
	c_query += "select E2_XCC, E2_NATUREZ, SUM(E2_VALOR) as E2_VALOR, E2_VENCREA, sum(E2_SALDO) as E2_SALDO from (" + c_EOL
	c_query += "select E2_BAIXA, E2_VALOR as VALORI, isnull(EZ_VALOR,isnull(EV_VALOR, E2_SALDO)) as E2_SALDO, E2_VENCREA, isnull(EV_NATUREZ, E2_NATUREZ) as E2_NATUREZ, EV_PERC, isnull(EZ_CCUSTO, E2_XCC) as E2_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E2_VALOR)) as E2_VALOR, EZ_PERC" + c_EOL
	c_query += "from SE2010 " + c_EOL
	c_query += "left join SEV010" + c_EOL
	c_query += "on        EV_FILIAL   = E2_FILIAL" + c_EOL
	c_query += "and       EV_PREFIXO  = E2_PREFIXO" + c_EOL
	c_query += "and       EV_NUM      = E2_NUM" + c_EOL
	c_query += "and       EV_PARCELA  = E2_PARCELA" + c_EOL
	c_query += "and       EV_TIPO     = E2_TIPO" + c_EOL
	c_query += "and       EV_CLIFOR   = E2_FORNECE" + c_EOL
	c_query += "and       EV_LOJA     = E2_LOJA" + c_EOL
	c_query += "and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "left join SEZ010" + c_EOL
	c_query += "on        EZ_FILIAL   = EV_FILIAL" + c_EOL
	c_query += "and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
	c_query += "and       EZ_NUM      = EV_NUM" + c_EOL
	c_query += "and       EZ_PARCELA  = EV_PARCELA" + c_EOL
	c_query += "and       EZ_TIPO     = EV_TIPO" + c_EOL
	c_query += "and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
	c_query += "and       EZ_LOJA     = EV_LOJA" + c_EOL
	c_query += "and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
	c_query += "and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "where     SE2010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "and       E2_SALDO  <> 0	" + c_EOL
	c_query += "and       E2_DTFATUR = '' " + c_EOL        //somente titulos nao faturados [Mauro Nagata, Actual Trend, 10/01/2011]
	
	//c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
	//substituida a linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 30/11/2011]
	//inicio bloco [Mauro Nagata, Actual Trend, 30/11/2011]	
	If l_competencia                                        
	   c_query += "and       SUBSTRING(E2_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	Else
	   c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
	EndIf                                                   
	//fim bloco [Mauro Nagata, Actual Trend, 30/11/2011]	
	
	c_query += ") A       where E2_XCC = '"+c_Obra+"'" + c_EOL
	c_query += "group by  E2_XCC, E2_NATUREZ, E2_VENCREA " + c_EOL
	c_query += "order by  E2_NATUREZ, E2_VENCREA " + c_EOL
	
	memoWrite('RFIN017a.sql', c_query)
	
	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	TcQuery c_Query New Alias "QRY"

	n_tregcp := 0
	QRY->(DbGotop())
	While QRY->(!EOF())
		n_tregcp++
		QRY->(DbSkip())
	EndDo
	QRY->(DbGotop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query para buscar informaceos do contas a receber                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oObj:IncRegua1("Sel. Registros CR")
	c_query := ''
	c_query += "select E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, SUM(E1_VALOR) as E1_VALOR, E1_VENCREA, sum(E1_SALDO) as E1_SALDO, E1_EMISSAO, E1_BAIXA" + c_EOL
	c_query += "from (" + c_EOL
	c_query += "      select E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_BAIXA, E1_EMISSAO, E1_VALOR as VALORI, E1_SALDO, E1_VENCREA, isnull(EV_NATUREZ, E1_NATUREZ) as E1_NATUREZ, EV_PERC, isnull(EZ_CCUSTO, E1_XCC) as E1_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E1_VALOR)) as E1_VALOR, EZ_PERC" + c_EOL
	c_query += "      from SE1010 " + c_EOL
	c_query += "      left join SEV010" + c_EOL
	c_query += "           on EV_FILIAL   = E1_FILIAL" + c_EOL
	c_query += "              and       EV_PREFIXO  = E1_PREFIXO" + c_EOL
	c_query += "              and       EV_NUM      = E1_NUM" + c_EOL
	c_query += "              and       EV_PARCELA  = E1_PARCELA" + c_EOL
	c_query += "              and       EV_TIPO     = E1_TIPO" + c_EOL
	c_query += "              and       EV_CLIFOR   = E1_CLIENTE" + c_EOL
	c_query += "              and       EV_LOJA     = E1_LOJA" + c_EOL
	c_query += "              and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "      left join SEZ010" + c_EOL
	c_query += "           on EZ_FILIAL   = EV_FILIAL" + c_EOL
	c_query += "              and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
	c_query += "              and       EZ_NUM      = EV_NUM" + c_EOL
	c_query += "              and       EZ_PARCELA  = EV_PARCELA" + c_EOL
	c_query += "              and       EZ_TIPO     = EV_TIPO" + c_EOL
	c_query += "              and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
	c_query += "              and       EZ_LOJA     = EV_LOJA" + c_EOL
	c_query += "              and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
	c_query += "              and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "      where SE1010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "              and       E1_SALDO  = 0	" + c_EOL
	c_query += "              and       E1_TIPO  <> 'RA'	" + c_EOL
	If l_competencia                                                                          
	   c_query += "              and       SUBSTRING(E1_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	EndIf      
	c_query += "      ) A " + c_EOL
	c_query += "where E1_XCC = '"+c_Obra+"'" + c_EOL
	c_query += "group by  E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VENCREA, E1_EMISSAO, E1_BAIXA" + c_EOL
	
	c_query += "union all " + c_EOL
	
	c_query += "select E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, SUM(E1_VALOR) as E1_VALOR, E1_VENCREA, sum(E1_SALDO) as E1_SALDO, E1_EMISSAO, E1_BAIXA" + c_EOL
	c_query += "from (" + c_EOL
	c_query += "      select E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_BAIXA, E1_VALOR as VALORI, E1_SALDO, E1_VENCREA, isnull(EV_NATUREZ, E1_NATUREZ) as E1_NATUREZ, EV_PERC, isnull(EZ_CCUSTO, E1_XCC) as E1_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E1_VALOR)) as E1_VALOR, EZ_PERC" + c_EOL
	c_query += "      from SE1010 " + c_EOL
	c_query += "      left join SEV010" + c_EOL
	c_query += "           on EV_FILIAL   = E1_FILIAL" + c_EOL
	c_query += "              and       EV_PREFIXO  = E1_PREFIXO" + c_EOL
	c_query += "              and       EV_NUM      = E1_NUM" + c_EOL
	c_query += "              and       EV_PARCELA  = E1_PARCELA" + c_EOL
	c_query += "              and       EV_TIPO     = E1_TIPO" + c_EOL
	c_query += "              and       EV_CLIFOR   = E1_CLIENTE" + c_EOL
	c_query += "              and       EV_LOJA     = E1_LOJA" + c_EOL
	c_query += "              and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "      left join SEZ010" + c_EOL
	c_query += "           on EZ_FILIAL   = EV_FILIAL" + c_EOL
	c_query += "              and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
	c_query += "              and       EZ_NUM      = EV_NUM" + c_EOL
	c_query += "              and       EZ_PARCELA  = EV_PARCELA" + c_EOL
	c_query += "              and       EZ_TIPO     = EV_TIPO" + c_EOL
	c_query += "              and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
	c_query += "              and       EZ_LOJA     = EV_LOJA" + c_EOL
	c_query += "              and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
	c_query += "              and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "      where SE1010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "            and       E1_SALDO  <> 0	" + c_EOL                            
	If l_competencia
	   c_query += "            and       SUBSTRING(E1_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL  
	EndIf      
	c_query += "     ) A" + c_EOL
	c_query += "where E1_XCC = '"+c_Obra+"'" + c_EOL
	c_query += "group by  E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VENCREA, E1_EMISSAO, E1_BAIXA " + c_EOL
	c_query += "order by  E1_NATUREZ, E1_VENCREA " + c_EOL
	
	memoWrite('RFIN011b.sql', c_query)

	If Select("QRX") > 0
		DbSelectArea("QRX")
		DbCloseArea()
	EndIf
	
	TcQuery c_Query New Alias "QRX"
	
	n_tregcr := 0
	QRX->(DbGotop())
	While QRX->(!EOF())
		n_tregcr++
		QRX->(DbSkip())
	EndDo

	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³Processa as informacoes do CONTAS A RECEBER                                              ³*
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	oObj:IncRegua1("Proc. Registros CR")
	oObj:SetRegua2(n_tregcr)
	c_grprec := '010' //Grupo de Receitas
	QRX->(DbGoTop())    
                        
	nVlrImpAA	:= 0
	nVlrImp		:= 0  //valores dos impostos
	a_rdados	:= {}

	While QRX->(!EOF())
		lIp			:= .F.
		c_vencrea	:= QRX->E1_VENCREA
		oObj:IncRegua2("Processando CR")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para situacoes de competencia.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l_competencia
			If TRAB->(DbSeek(c_grprec+QRX->E1_NATUREZ))
				RecLock('TRAB', .F.)
			Else
				RecLock('TRAB', .T.)
				TRAB->TRB_GRPO	:= c_grprec
				TRAB->TRB_NAT	:= QRX->E1_NATUREZ
				TRAB->TRB_DESC	:= substr(QRX->E1_NATUREZ,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+QRX->E1_NATUREZ, 1, 'X'), 1,32)
			EndIf
			If MV_PAR02 = SubStr(QRX->E1_EMISSAO, 1,4)
				If !(ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF')
					TRAB->&("TRB_M"+SubStr(QRX->E1_EMISSAO, 5,2)) += (QRX->E1_VALOR)
				EndIf
			EndIf
			
			TRAB->(MsUnLock())
			QRX->(DbSkip())
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para situacoes futuras...                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SubStr(c_vencrea, 1,4) > c_anoref .and. (Empty(QRX->E1_BAIXA) .or. SubStr(QRX->E1_BAIXA, 1,4) > c_anoref)
			QRX->(DbSkip())
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para RA's                                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea('SE5')
		DbSetOrder(7) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		If DbSeek(xFilial('SE5')+QRX->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))
			While SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == xFilial('SE5')+QRX->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
				c_vencrea := QRX->E1_BAIXA
				If QRX->E1_TIPO = 'RA'// $ SE5->E5_DOCUMENT
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Localiza o RA  e retorna a data de emissao                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					c_vencrea := QRX->E1_EMISSAO //fRetdtRA(QRX->E1_VENCREA)
					lIp := .T.
					Exit
				EndIf
				SE5->(DbSkip())
			EndDo                                            
		EndIf 
		
		If TRAB->(DbSeek(c_grprec+QRX->E1_NATUREZ))
			RecLock('TRAB', .F.)
		Else
			RecLock('TRAB', .T.)
			TRAB->TRB_GRPO	:= c_grprec
			TRAB->TRB_NAT	:= QRX->E1_NATUREZ
			TRAB->TRB_DESC	:= substr(QRX->E1_NATUREZ,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+QRX->E1_NATUREZ, 1, 'X'), 1,32)
		EndIf

		If SubStr(DtoS(dDataBase), 1, 4) = c_anoref
			//:::::::::: TITULOS VENCIDOS NO ANO ANTERIOR ::::::::::
			If SubStr(c_vencrea, 1,4) < c_anoref
				If QRX->E1_SALDO = 0 .or. QRX->E1_TIPO = 'RA'
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_ANT -= QRX->E1_VALOR //ANO ANTERIOR
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->TRB_ANT += QRX->E1_VALOR//ANO ANTERIOR
					EndIf
				Else
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_ANT -= (QRX->E1_VALOR - QRX->E1_SALDO) //ANO ANTERIOR
						TRAB->TRB_VENC  -= QRX->E1_SALDO //VENCIDOS
						nVlrImpAA += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->TRB_ANT += (QRX->E1_VALOR - QRX->E1_SALDO)//ANO ANTERIOR
						TRAB->TRB_VENC += QRX->E1_SALDO //VENCIDOS
					EndIf
				EndIf
			//:::::::::::::::::::::::::::::: MESES ANTERIORES DO ANO ATUAL ::::::::::::::::::::::::::::::
			ElseIf SubStr(c_vencrea, 5,2) < SubStr(DtoS(dDataBase), 5, 2) .and. SubStr(c_vencrea, 1,4) = c_anoref
				If QRX->E1_SALDO = 0
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_VALOR
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_VALOR
					EndIf
				Else
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= (QRX->E1_VALOR-QRX->E1_SALDO)
						TRAB->TRB_VENC  -= QRX->E1_SALDO //VENCIDOS
						nVlrImp += QRX->E1_VALOR
					Else
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += (QRX->E1_VALOR-QRX->E1_SALDO)
						TRAB->TRB_VENC += QRX->E1_SALDO //VENCIDOS
					EndIf
				EndIf
			//:::::::::: MESE ATUAL DO ANO ATUAL ::::::::::
			ElseIf SubStr(c_vencrea, 1,6) = SubStr(DtoS(dDataBase), 1, 6) 
				If QRX->E1_SALDO = 0
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_REAL -= QRX->E1_VALOR  //MES ATUAL REALIZADO
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->TRB_REAL += QRX->E1_VALOR  //MES ATUAL REALIZADO
					EndIf
				Else
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_REAL -= (QRX->E1_VALOR-QRX->E1_SALDO)
						TRAB->TRB_ABER -= QRX->E1_SALDO  //MES ATUAL EM ABERTO
						nVlrImp += QRX->E1_VALOR
					Else
						TRAB->TRB_REAL += (QRX->E1_VALOR-QRX->E1_SALDO)
						TRAB->TRB_ABER += QRX->E1_SALDO  //MES ATUAL EM ABERTO
					EndIf
				EndIf
			//:::::::::::::::::::::::::::::: MESES FUTUROS DO ANO ATUAL ::::::::::::::::::::::::::::::
			ElseIf  SubStr(c_vencrea, 5,2) > SubStr(DtoS(dDataBase), 5, 2) .and. SubStr(c_vencrea, 1,4) = c_anoref 
				If Empty(QRX->E1_BAIXA) // TITULOS TOTALMENTE EM ABERTO
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_VALOR
						nVlrImp += QRX->E1_VALOR
					Else
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_VALOR
					EndIf
				Else // SE HOUVE BAIXA PARCIAL COM VENCIMENTO EM MESES FUTUROS NO ANO ATUAL
					If SubStr(QRX->E1_BAIXA, 1,6) = SubStr(DtoS(dDataBase), 1, 6)
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->TRB_REAL -= (QRX->E1_VALOR-QRX->E1_SALDO)
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_SALDO
							nVlrImp += QRX->E1_VALOR
						Else
							TRAB->TRB_REAL += (QRX->E1_VALOR-QRX->E1_SALDO)
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_SALDO
						EndIf
					ElseIf SubStr(QRX->E1_BAIXA, 1,4) = c_anoref
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) -= (QRX->E1_VALOR-QRX->E1_SALDO)
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_SALDO
							nVlrImp += QRX->E1_VALOR
						Else
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) += (QRX->E1_VALOR-QRX->E1_SALDO)
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_SALDO
						EndIf
					ElseIf SubStr(QRX->E1_BAIXA, 1,4) < c_anoref
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->TRB_ANT -= (QRX->E1_VALOR - QRX->E1_SALDO) //ANO ANTERIOR
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_SALDO
							nVlrImpAA += QRX->E1_VALOR  //valor dos impostos
						Else
							TRAB->TRB_ANT += (QRX->E1_VALOR - QRX->E1_SALDO)//ANO ANTERIOR
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_SALDO //VENCIDOS
						EndIf
					EndIf
				EndIf
			ElseIf SubStr(QRX->E1_BAIXA, 1,4) = c_anoref //:::::::::: MESES DE ANOS FUTUROS COM BAIXA PARCIAL NO ANO ATUAL ::::::::::
				If QRX->E1_SALDO = 0 // BAIXA TOTAL ANTECIPADA
					If SubStr(QRX->E1_BAIXA, 1,6) = SubStr(DtoS(dDataBase), 1, 6)
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->TRB_REAL -= QRX->E1_VALOR
							nVlrImp += QRX->E1_VALOR
						Else
							TRAB->TRB_REAL += QRX->E1_VALOR
						EndIf
					Else 
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) -= QRX->E1_VALOR  //MES ATUAL EM ABERTO
							nVlrImp += QRX->E1_VALOR  //valor dos impostos
						Else
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) += QRX->E1_VALOR  //MES ATUAL EM ABERTO
						EndIf
					EndIf
				Else //BAIXA PARCIAL
					If SubStr(QRX->E1_BAIXA, 1,6) = SubStr(DtoS(dDataBase), 1, 6)
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->TRB_REAL -= (QRX->E1_VALOR-QRX->E1_SALDO)
							nVlrImp += (QRX->E1_VALOR-QRX->E1_SALDO)
						Else
							TRAB->TRB_REAL += (QRX->E1_VALOR-QRX->E1_SALDO)
						EndIf
					Else
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) -= (QRX->E1_VALOR-QRX->E1_SALDO)
							nVlrImp += QRX->E1_VALOR
						Else
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) += (QRX->E1_VALOR-QRX->E1_SALDO)
						EndIf
					EndIf
				EndIf
			//::::::::::::::::::::::::::::::TITULOS COM BAIXA NO ANO PASSADO::::::::::::::::::::::::::::::
			ElseIf SubStr(QRX->E1_BAIXA, 1,4) < c_anoref  .and. !Empty(QRX->E1_BAIXA)
				If QRX->E1_SALDO = 0
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_ANT -= QRX->E1_VALOR //ANO ANTERIOR
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->TRB_ANT += QRX->E1_VALOR//ANO ANTERIOR
					EndIf
				Else
					If SubStr(QRX->E1_BAIXA, 1,6) = SubStr(DtoS(dDataBase), 1, 6)
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->TRB_REAL -= (QRX->E1_VALOR-QRX->E1_SALDO)
							nVlrImp += (QRX->E1_VALOR-QRX->E1_SALDO)
						Else
							TRAB->TRB_REAL += (QRX->E1_VALOR-QRX->E1_SALDO)
						EndIf
					Else
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) -= (QRX->E1_VALOR-QRX->E1_SALDO)
							nVlrImp += QRX->E1_VALOR
						Else
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) += (QRX->E1_VALOR-QRX->E1_SALDO)
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf SubStr(DtoS(dDataBase), 1, 4) < c_anoref // RELATORIO DE ANOS FUTUROS 
			//:::::::::: TITULOS VENCIDOS NO ANO ANTERIOR ::::::::::
			If SubStr(c_vencrea, 1,4) < c_anoref
				If QRX->E1_SALDO = 0
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_ANT -= QRX->E1_VALOR //ANO ANTERIOR
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->TRB_ANT += QRX->E1_VALOR//ANO ANTERIOR
					EndIf
				Else
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_ANT -= (QRX->E1_VALOR - QRX->E1_SALDO) //ANO ANTERIOR
						If DtoS(dDataBase) > c_vencrea // APENAS MOSTRA COMO VENCIDO OS QUE REALMENTE ESTAO VENCIDOS
							TRAB->TRB_VENC  -= QRX->E1_SALDO //VENCIDOS
							nVlrImpAA += QRX->E1_VALOR  //valor dos impostos
						EndIf
					Else
						TRAB->TRB_ANT += (QRX->E1_VALOR - QRX->E1_SALDO)//ANO ANTERIOR
						If DtoS(dDataBase) > c_vencrea // APENAS MOSTRA COMO VENCIDO OS QUE REALMENTE ESTAO VENCIDOS
							TRAB->TRB_VENC += QRX->E1_SALDO //VENCIDOS
						EndIf
					EndIf
				EndIf
			//:::::::::::::::::::::::::::::: MESES FUTUROS DO ANO ATUAL ::::::::::::::::::::::::::::::
			ElseIf  SubStr(c_vencrea, 5,2) > SubStr(DtoS(dDataBase), 5, 2) .and. SubStr(c_vencrea, 1,4) = c_anoref 
				If Empty(QRX->E1_BAIXA) // TITULOS TOTALMENTE EM ABERTO
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_VALOR
						nVlrImp += QRX->E1_VALOR
					Else
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_VALOR
					EndIf
				Else // SE HOUVE BAIXA PARCIAL COM VENCIMENTO EM MESES FUTUROS NO ANO ATUAL
					If SubStr(QRX->E1_BAIXA, 1,4) < c_anoref  .and. !Empty(QRX->E1_BAIXA)
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->TRB_ANT -= (QRX->E1_VALOR-QRX->E1_SALDO)
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_SALDO
							nVlrImp += QRX->E1_VALOR
						Else
							TRAB->TRB_ANT += (QRX->E1_VALOR-QRX->E1_SALDO)
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_SALDO
						EndIf
					ElseIf SubStr(QRX->E1_BAIXA, 1,4) = c_anoref
						If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) -= (QRX->E1_VALOR-QRX->E1_SALDO)
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_SALDO
							nVlrImp += QRX->E1_VALOR
						Else
							TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) += (QRX->E1_VALOR-QRX->E1_SALDO)
							TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_SALDO
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf SubStr(DtoS(dDataBase), 1, 4) > c_anoref // RELATORIO DO ANO PASSADO
			//:::::::::: TITULOS VENCIDOS NO ANO ANTERIOR ::::::::::
			If SubStr(c_vencrea, 1,4) < c_anoref 
				If QRX->E1_SALDO = 0
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_ANT -= QRX->E1_VALOR //ANO ANTERIOR
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->TRB_ANT += QRX->E1_VALOR//ANO ANTERIOR
					EndIf
				Else
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_ANT -= (QRX->E1_VALOR - QRX->E1_SALDO) //ANO ANTERIOR
						TRAB->TRB_VENC  -= QRX->E1_SALDO //VENCIDOS
						nVlrImpAA += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->TRB_ANT += (QRX->E1_VALOR - QRX->E1_SALDO)//ANO ANTERIOR
						TRAB->TRB_VENC += QRX->E1_SALDO //VENCIDOS
					EndIf
				EndIf
			//:::::::::::::::::::::::::::::: MESES DO ANO DE REFERENCIA ::::::::::::::::::::::::::::::
			ElseIf SubStr(c_vencrea, 1,4) = c_anoref  // SubStr(c_vencrea, 5,2) < SubStr(DtoS(dDataBase), 5, 2) .and. SubStr(c_vencrea, 1,4) = c_anoref
				If QRX->E1_SALDO = 0 .or. QRX->E1_TIPO = 'RA'
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRX->E1_VALOR
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRX->E1_VALOR
					EndIf
				Else
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= (QRX->E1_VALOR-QRX->E1_SALDO)
						TRAB->TRB_VENC  -= QRX->E1_SALDO //VENCIDOS
						nVlrImp += QRX->E1_VALOR
					Else
						TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += (QRX->E1_VALOR-QRX->E1_SALDO)
						TRAB->TRB_VENC += QRX->E1_SALDO //VENCIDOS
					EndIf
				EndIf
			ElseIf SubStr(QRX->E1_BAIXA, 1,4) = c_anoref //:::::::::: MESES DE ANOS FUTUROS COM BAIXA PARCIAL NO ANO ATUAL ::::::::::
				If QRX->E1_SALDO = 0 // BAIXA TOTAL ANTECIPADA
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) -= QRX->E1_VALOR  //MES ATUAL EM ABERTO
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) += QRX->E1_VALOR  //MES ATUAL EM ABERTO
					EndIf
				Else //BAIXA PARCIAL
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) -= (QRX->E1_VALOR-QRX->E1_SALDO)
						nVlrImp += QRX->E1_VALOR
					Else
						TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) += (QRX->E1_VALOR-QRX->E1_SALDO)
					EndIf
				EndIf
			//::::::::::::::::::::::::::::::TITULOS COM BAIXA NO ANO PASSADO::::::::::::::::::::::::::::::
			ElseIf SubStr(QRX->E1_BAIXA, 1,4) < c_anoref .and. !Empty(QRX->E1_BAIXA)
				If QRX->E1_SALDO = 0
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->TRB_ANT -= QRX->E1_VALOR //ANO ANTERIOR
						nVlrImp += QRX->E1_VALOR  //valor dos impostos
					Else
						TRAB->TRB_ANT += QRX->E1_VALOR//ANO ANTERIOR
					EndIf
				Else
					If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
						TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) -= (QRX->E1_VALOR-QRX->E1_SALDO)
						nVlrImp += QRX->E1_VALOR
					Else
						TRAB->&("TRB_M"+SubStr(QRX->E1_BAIXA, 5,2)) += (QRX->E1_VALOR-QRX->E1_SALDO)
					EndIf
				EndIf
			EndIf
		EndIf
		TRAB->(MsUnLock())
		QRX->(DbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra de linha                                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	DbSeek('010')
	a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	n_totaln := 0
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO = '010'
		n_totaln := 0
		For n_x := 1 to 12
			a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
			n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		a_totais[13] += TRAB->TRB_ANT
		a_totais[14] += TRAB->TRB_REAL
		a_totais[15] += TRAB->TRB_ABER
		a_totais[16] += TRAB->TRB_VENC
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + TRAB->TRB_ABER + n_totaln
		MsUnLock()
		a_totais[17] += TRAB->TRB_TOT
		TRAB->(DbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	c_grprec := '011' //Grupo de Receitas - subgrupo total de receitas
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "TOTAL CONTAS A RECEBER NO MES        [a]"
	For n_x := 1 to 12
		TRAB->&("TRB_M"+StrZero(n_x,2)) := a_totais[n_x]
	Next
	TRAB->TRB_ANT	:= a_totais[13]
	TRAB->TRB_REAL	:= a_totais[14]
	TRAB->TRB_ABER	:= a_totais[15]
	TRAB->TRB_VENC	:= a_totais[16]
	TRAB->TRB_TOT	:= a_totais[17]
	TRAB->(MsUnLock())

	Aadd(a_separar, {'012','-'})
	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³Processa as informacoes do faturamento direto                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	oObj:IncRegua1("Faturamento Direto")
	c_grprec := '015' //Grupo de Receitas - Sub-Grupo FATURAMENTO DIRETO

	//c_query := " SELECT sum(D1_TOTAL+(C7_VALIPI*(D1_QUANT/C7_QUANT))+C7_VALFRE+C7_DESPESA+C7_SEGURO-C7_VLDESC) as VALOR, C7_DATPRF, D1_TES"
	c_query := " SELECT sum(D1_TOTAL+(C7_VALIPI*(D1_QUANT/C7_QUANT))+D1_VALFRE+D1_DESPESA+D1_SEGURO-D1_VALDESC) as VALOR, C7_DATPRF, D1_TES,"
	
	c_query += "sum((C7_QUANT-C7_QUJE)*C7_PRECO + (((C7_QUANT-C7_QUJE)/C7_QUANT)*D1_VALIPI * (D1_QUANT/C7_QUANT))) as VLRAB "



	c_query += " FROM SC7010 C7 "
	c_query += " LEFT OUTER JOIN SD1010 D1 "
	c_query += " ON D1.D_E_L_E_T_='' "
	c_query += " AND D1_PEDIDO = C7_NUM "
	c_query += " AND D1_ITEMPC = C7_ITEM "
	c_query += " AND D1_COD    = C7_PRODUTO "
	c_query += " AND D1_TES    <> '' "
	c_query += " INNER JOIN SB1010 B1 "
	c_query += " ON B1.D_E_L_E_T_='' "
	c_query += " AND B1_COD = C7_PRODUTO "
	c_query += " INNER JOIN CTT010 CTT "
	c_query += " ON CTT.D_E_L_E_T_='' "
	c_query += " AND CTT_XLFATD = 'S' "
	c_query += " AND CTT_CUSTO = C7_XCCFTD "
	c_query += " WHERE C7_XCCFTD = '"+c_Obra+"'"
	c_query += " and       SUBSTRING(C7_DATPRF,1,4) <= '"+c_anoref+"'" + c_EOL
	c_query += " AND C7_XCCFTD <> '' "
	c_query += " AND C7_XFATD = 'S' "
	c_query += " AND C7.D_E_L_E_T_ = '' "
	c_query += " GROUP BY C7_DATPRF, D1_TES"
	
	MemoWrite("RFIN011_FATD",c_query)
	
	If Select("QRX") > 0
		DbSelectArea("QRX")
		DbCloseArea()
	EndIf
	TcQuery c_Query New Alias "QRX"

	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "FATURAMENTO DIRETO                   [b]"
	

	While QRX->(!EOF())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o material foi direto para obra, nesse caso acumula array para atualizar despesas      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If QRX->D1_TES = '330' .and. len(a_fatdir)=0
			a_fatdir := {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
		EndIf
		
		If SubStr(QRX->C7_DATPRF, 1,4) < c_anoref
			TRAB->TRB_ANT += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)   //ANO ANTERIOR
			If QRX->D1_TES = '330'
				a_fatdir[13] += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)    //ANO ANTERIOR
			EndIf
		ElseIf SubStr(QRX->C7_DATPRF, 5,2) = SubStr(DtoS(dDataBase), 5, 2) .And. Substr(QRX->C7_DATPRF,1,4) = c_anoref
			If Stod(QRX->C7_DATPRF) > dDataBase
				TRAB->TRB_ABER += Round(QRX->VALOR,2) + Round(QRX->VLRAB,2)     //MES ATUAL EM ABERTO
				If QRX->D1_TES = '330'
					a_fatdir[15] += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)   
				EndIf
			Else
				TRAB->TRB_REAL += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)     //MES ATUAL REALIZADO
				If QRX->D1_TES = '330'
					a_fatdir[14] += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)    
				EndIf
			EndIf
		Else
			TRAB->&("TRB_M"+SubStr(QRX->C7_DATPRF, 5,2)) += Round(QRX->VALOR,2) //Outros meses normais
			If QRX->D1_TES = '330'
				a_fatdir[val(SubStr(QRX->C7_DATPRF, 5,2))] += ROUND(QRX->VALOR,2) + Round(QRX->VLRAB,2)   
			EndIf
		EndIf
		QRX->(DbSkip())
	EndDo
	TRAB->(MsUnLock())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	If DbSeek('015')
		n_totaln := 0
		For n_x := 1 to 12
			n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln
		MsUnLock()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra de linha                                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	DbSeek('011')
	a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '015'
		For n_x := 1 to 12
			a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		a_totais[13] += TRAB->TRB_ANT
		a_totais[14] += TRAB->TRB_REAL
		a_totais[15] += TRAB->TRB_ABER
		a_totais[16] += TRAB->TRB_VENC
		a_totais[17] += TRAB->TRB_TOT
		TRAB->(DbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(a_separar, {'016','-'})
	c_grprec := '018' //Grupo de Receitas - subgrupo total GERAL de receitas
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "TOTAL CTAS A RECEBER ACUMULADO [a+b]=[c]"
	n_totacm 		:= a_totais[13]
	TRAB->TRB_ANT	:= n_totacm
	For n_x := 1 to 12
		If n_x = val(substr(dtos(ddatabase),5,2))
			n_totacm 		+= a_totais[14]
			TRAB->TRB_REAL	:= n_totacm
			n_totacm 		+= a_totais[15]
			TRAB->TRB_ABER	:= n_totacm
		EndIf
		n_totacm += a_totais[n_x]
		TRAB->&("TRB_M"+StrZero(n_x,2)) := n_totacm
	Next
	TRAB->TRB_VENC	:= 0
	TRAB->TRB_TOT	:= n_totacm
	n_totCRA		:= n_totacm
	TRAB->(MsUnLock())
	Aadd(a_separar, {'019','-'})

	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³Processa as informacoes do contas a pagar                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	oObj:IncRegua1("Proc. Registros CP")
	oObj:SetRegua2(n_tregcp)
	c_grprec := '020' //Grupo de Despesas
	If QRY->(!EOF())  
		While QRY->(!EOF())
			oObj:IncRegua2("Processando CP")
			If TRAB->(DbSeek(c_grprec+QRY->E2_NATUREZ))
				RecLock('TRAB', .F.)
			Else
				RecLock('TRAB', .T.)
				TRAB->TRB_GRPO	:= c_grprec
				TRAB->TRB_NAT	:= QRY->E2_NATUREZ
				TRAB->TRB_DESC	:= substr(QRY->E2_NATUREZ,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+QRY->E2_NATUREZ, 1, 'X'), 1,32)
			EndIf
	
			If StoD(QRY->E2_VENCREA) < dDataBase .and. QRY->E2_SALDO > 0 .And. SubStr(QRY->E2_VENCREA, 1,4) = c_anoref
				TRAB->TRB_VENC += QRY->E2_SALDO
				TRAB->&("TRB_M"+SubStr(QRY->E2_VENCREA, 5,2)) += (QRY->E2_VALOR-QRY->E2_SALDO)
			ElseIf SubStr(QRY->E2_VENCREA, 1,4) < c_anoref
				If QRY->E2_SALDO = 0                                            //[mauro nagata, Actual Trend, 02/02/2011]
					TRAB->TRB_ANT += QRY->E2_VALOR
				Else
					TRAB->TRB_ANT += (QRY->E2_VALOR - QRY->E2_SALDO)
					TRAB->TRB_VENC += QRY->E2_SALDO
				EndIf
			ElseIf SubStr(QRY->E2_VENCREA, 5,2) = SubStr(DtoS(dDataBase), 5, 2) .and. QRY->E2_SALDO = 0 .And.SubStr(QRY->E2_VENCREA, 1,4) = c_anoref
				TRAB->TRB_REAL += QRY->E2_VALOR  //MES ATUAL REALIZADO
			ElseIf SubStr(QRY->E2_VENCREA, 5,2) = SubStr(DtoS(dDataBase), 5, 2) .and. QRY->E2_SALDO <> 0 .And.SubStr(QRY->E2_VENCREA, 1,4) = c_anoref
				TRAB->TRB_ABER += QRY->E2_SALDO  //MES ATUAL EM ABERTO
			Else
				TRAB->&("TRB_M"+SubStr(QRY->E2_VENCREA, 5,2)) += QRY->E2_VALOR
			EndIf
			TRAB->(MsUnLock())
			
			QRY->(DbSkip())
		EndDo
	EndIf
	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³Adiciona linha de faturamento direto que nao entrou na LISONDA, se houver                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	c_grprec := '021' //Grupo de Despesas - subgrupo Fat. Direto
	If len(a_fatdir) > 0
		RecLock('TRAB', .T.)
		TRAB->TRB_GRPO	:= c_grprec
		TRAB->TRB_DESC	:= "9999 - Faturamento Direto               "
		TRAB->TRB_ANT 	+= a_fatdir[13]
		TRAB->TRB_REAL  += a_fatdir[14]
		TRAB->TRB_ABER  += a_fatdir[15]
		For n_y := 1 to 12
			TRAB->&("TRB_M"+StrZero(n_y, 2)) := a_fatdir[n_y]
		Next
		TRAB->(MsUnLock())
	EndIf
	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³Processa as informacoes de utilizacao de MAO DE OBRA                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	oObj:IncRegua1("Mao de Obra")
	oObj:IncRegua2("Processando mao de obra")
	c_grprec := '022' //Grupo de Despesas - subgrupo MAO DE OBRA
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= " MÃO DE OBRA UTILIZADA                  "
	For n_y := 1 to 12
		If n_y = 2
			TRAB->TRB_ANT := fBusMod(StrZero(VAL(c_anoref)-1,4))
		Else //c_anoref+StrZero(n_y,2) < SubStr(DtoS(dDataBase), 1, 6)
			TRAB->&("TRB_M"+StrZero(n_y, 2)) := fBusMod(c_anoref+StrZero(n_y,2))
		EndIf
	Next
	TRAB->(MsUnLock())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra de linha                                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	DbSeek('020')
	a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	n_totaln := 0
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '022'
		n_totaln := 0
		For n_x := 1 to 12
			a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
			n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		a_totais[13] += TRAB->TRB_ANT
		a_totais[14] += TRAB->TRB_REAL
		a_totais[15] += TRAB->TRB_ABER
		a_totais[16] += TRAB->TRB_VENC
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln
		MsUnLock()
		a_totais[17] += TRAB->TRB_TOT
		TRAB->(DbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	c_grprec := '023' //Grupo de Despesas - subgrupo total de despesas
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "TOTAL CONTAS A PAGAR NO MÊS          [d]"
	For n_x := 1 to 12
		TRAB->&("TRB_M"+StrZero(n_x,2)) := a_totais[n_x]
	Next
	TRAB->TRB_ANT	:= a_totais[13]
	TRAB->TRB_REAL	:= a_totais[14]
	TRAB->TRB_ABER	:= a_totais[15]
	TRAB->TRB_VENC	:= a_totais[16]
	TRAB->TRB_TOT	:= a_totais[17] + TRAB->TRB_VENC
	n_atrasados := TRAB->TRB_VENC
	TRAB->(MsUnLock())

	Aadd(a_separar, {'024','-'})

	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³ NOTAS FISCAIS DE REMESSA                                                                ³*
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	oObj:IncRegua1("Notas de Remessa")
	oObj:IncRegua2("Processando notas de remessa")
	c_grprec := '025' //Grupo Notas de remessa
	
	c_query := " SELECT SUM(D2_TOTAL) AS VALOR, SUM(B1_CUSTD)as CUTSD, D2_EMISSAO AS C7_DATPRF"
	c_query += " FROM SD2010 "
	c_query += " INNER JOIN SF4010 "
	c_query += "       ON F4_CODIGO = D2_TES "
	c_query += "          AND F4_DUPLIC <> 'S' "
	c_query += "          AND SF4010.D_E_L_E_T_ <> '*' "
	c_query += " INNER JOIN SB1010 "
	c_query += "       ON B1_COD = D2_COD "
	c_query += "          AND B1_TIPO NOT IN  ('AT','MQ') "
	c_query += "          ANd SB1010.D_E_L_E_T_ = ' ' "
	c_query += " WHERE D2_CCUSTO = '"+c_Obra+"'  "
	c_query += "       AND D2_COD NOT LIKE 'AT%' "
	c_query += "       AND SD2010.D_E_L_E_T_ <> '*' "
	c_query += "       AND SUBSTRING(D2_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	c_query += " GROUP BY D2_EMISSAO "
	
	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	TcQuery c_Query New Alias "QRY"
	
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "NOTAS FISCAIS DE REMESSA (CUSTO)     [e]"

	Do While QRY->(!EOF())
		If SubStr(QRY->C7_DATPRF, 1,4) < c_anoref
			TRAB->TRB_ANT += QRY->VALOR //ANO ANTERIOR
		Else
			If SubStr(QRY->C7_DATPRF, 5,2) = SubStr(DtoS(dDataBase), 5, 2)
				TRAB->TRB_REAL += QRY->VALOR  //MES ATUAL REALIZADO
			Else
				TRAB->&("TRB_M"+SubStr(QRY->C7_DATPRF, 5,2)) += QRY->VALOR
			EndIf
		EndIf
		
		QRY->(DbSkip())
	EndDo
	TRAB->(MsUnLock())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	If DbSeek('025')
		n_totaln := 0
		For n_x := 1 to 12
			n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln
		MsUnLock()
	EndIf
	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³ NOTAS FISCAIS DE RETORNO DE REMESSA                                                     ³*
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	oObj:IncRegua1("Retorno de Remessa")
	oObj:IncRegua2("Processando retorno de remessa")
	c_grprec := '026' //Grupo Notas de remessa - sub grupo retorno                               
	
	c_query := "SELECT SUM(D1_TOTAL) AS VALOR, D1_EMISSAO "
	c_query += "FROM SD1010 D1 "
	c_query += "LEFT JOIN SF4010 F4 "
	c_query += "     ON F4.D_E_L_E_T_ = '' "
	c_query += "        AND F4_CODIGO = D1_TES "
	c_query += "        AND F4_DUPLIC <> 'S' "
	c_query += "LEFT JOIN SB1010 B1 "
	c_query += "     ON B1.D_E_L_E_T_='' "
	c_query += "        AND B1.B1_COD = D1_COD "
	c_query += "        AND B1_TIPO NOT IN  ('AT','MQ') "
	c_query += "WHERE D1.D_E_L_E_T_ = '' "
	c_query += "      AND D1_CC = '"+c_Obra+"' "
	c_query += "      AND D1_TIPO = 'D' "
	c_query += "      AND SUBSTRING(D1_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	c_query += "GROUP BY D1_EMISSAO "
	
	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	
	TcQuery c_Query New Alias "QRY"

	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "RETORNO DE REMESSA (CUSTO)           [f]" 	

	Do While QRY->(!EOF())
		If SubStr(QRY->D1_EMISSAO, 1,4) < c_anoref
			TRAB->TRB_ANT += QRY->VALOR //ANO ANTERIOR
		Else
			If SubStr(QRY->D1_EMISSAO, 5,2) = SubStr(DtoS(dDataBase), 5, 2)
				TRAB->TRB_REAL += QRY->VALOR  //MES ATUAL REALIZADO
			Else
				TRAB->&("TRB_M"+SubStr(QRY->D1_EMISSAO, 5,2)) += QRY->VALOR
			EndIf
		EndIf	
		QRY->(DbSkip())
	EndDo    
	TRAB->(MsUnLock())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	DbselectArea('TRAB')
	If DbSeek('026')
		n_totaln := 0
		For n_x := 1 to 12
			n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
			a_totais[n_x] -= TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln
		a_totais[13] -= TRAB->TRB_ANT
		a_totais[14] -= TRAB->TRB_REAL
		a_totais[15] -= TRAB->TRB_ABER
		a_totais[16] -= TRAB->TRB_VENC
		a_totais[17] -= TRAB->TRB_TOT
		MsUnLock()
	EndIf
	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³ TOTAIS E SALDOS                                                                         ³*
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	DbselectArea('TRAB')
	DbSeek('023')
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '025'
		For n_x := 1 to 12
			a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		a_totais[13] += TRAB->TRB_ANT
		a_totais[14] += TRAB->TRB_REAL
		a_totais[15] += TRAB->TRB_ABER
		a_totais[16] += TRAB->TRB_VENC
		a_totais[17] += TRAB->TRB_TOT
		TRAB->(DbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha TOTAL DE DESPESAS ACUMULADAS                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(a_separar, {'027','-'})
	c_grprec := '028' //Grupo de Despesas - subgrupo total acumulado de despesas
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "TOTAL DE DESPESAS ACUMULADAS [d+e-f]=[g]"
	n_totacm 		:= a_totais[13]
	TRAB->TRB_ANT	:= n_totacm
	For n_x := 1 to 12
		If n_x = val(substr(dtos(ddatabase),5,2))       
			a_totais[14]    += n_atrasados
			n_totacm 		+= a_totais[14]
			TRAB->TRB_REAL	:= n_totacm
			n_totacm 		+= a_totais[15]
			TRAB->TRB_ABER	:= n_totacm
		EndIf
		n_totacm += a_totais[n_x]
		TRAB->&("TRB_M"+StrZero(n_x,2)) := n_totacm
	Next
	TRAB->TRB_VENC	:= 0
	TRAB->TRB_TOT	:= n_totacm
	n_totDA			:= n_totacm
	TRAB->(MsUnLock())
	Aadd(a_separar, {'029','-'})
	Aadd(a_separar, {'030',' '})
	Aadd(a_separar, {'031','*'})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra de linha SALDO FLUXO DE CAIXA MÊS     [a+b-d-e+f]                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For n_x := 1 to 17
		a_totais[n_x] := a_totais[n_x]*(-1)
	Next
	DbselectArea('TRAB')
	DbSeek('011')
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '015'
		For n_x := 1 to 12
			a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		a_totais[13] += TRAB->TRB_ANT
		a_totais[14] += TRAB->TRB_REAL
		a_totais[15] += TRAB->TRB_ABER
		a_totais[16] += TRAB->TRB_VENC
		a_totais[17] += TRAB->TRB_TOT
		TRAB->(DbSkip())
	EndDo

	c_grprec := '040' //saldos
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "SALDO FLUXO DE CAIXA MÊS     [a+b-d-e+f]"
	For n_x := 1 to 12
		TRAB->&("TRB_M"+StrZero(n_x,2)) := a_totais[n_x]
	Next
	TRAB->TRB_ANT	:= a_totais[13]
	TRAB->TRB_REAL	:= a_totais[14]
	TRAB->TRB_ABER	:= a_totais[15]
	TRAB->TRB_TOT	:= a_totais[17]
	TRAB->(MsUnLock())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra de linha SALDO FLUXO DE CAIXA MÊS     [a+b-d-e+f]                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(a_separar, {'042','*'})
	c_grprec := '050' //Grupo de Receitas - subgrupo total de despesas
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "SALDO FLUXO DE CAIXA ACUMULADO     [c-g]"
	n_totacm 		:= a_totais[13]
	TRAB->TRB_ANT	:= n_totacm
	For n_x := 1 to 12
		If n_x = val(substr(dtos(ddatabase),5,2))
			n_totacm 		+= a_totais[14]
			TRAB->TRB_REAL	:= n_totacm
			n_totacm 		+= a_totais[15]
			TRAB->TRB_ABER	:= n_totacm
		EndIf
		n_totacm += a_totais[n_x]
		TRAB->&("TRB_M"+StrZero(n_x,2)) := n_totacm
	Next
	TRAB->TRB_VENC	:= 0
	TRAB->TRB_TOT	:= n_totacm
	TRAB->(MsUnLock())

	Aadd(a_separar, {'052','*'})
	Aadd(a_separar, {'053',' '})
	Aadd(a_separar, {'054','-'})

	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³PEDIDOS DE COMPRAS EM ABERTO                                                             ³*
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	oObj:IncRegua1("Pedidos de compras")
	c_grprec := '060' //Pedidos de compras

	c_query := "SELECT SUM(C7_TOTAL) as VALOR, C7_DATPRF, C7_CC, C7_COND "
	c_query += "FROM SC7010 "
	c_query += "WHERE C7_QUANT <> C7_QUJE"
	c_query += "      AND SC7010.D_E_L_E_T_ <> '*'"
	c_query += "      AND C7_RESIDUO <> 'S'"
	c_query += "      AND C7_XFATD <> 'S'"
	c_query += "      AND C7_CC = '"+c_Obra+"'"
	c_query += "      AND SUBSTRING(C7_DATPRF,1,4) <= '"+c_anoref+"'" + c_EOL
	c_query += "GROUP BY   C7_DATPRF, C7_CC, C7_COND"
	
	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	
	TcQuery c_Query New Alias "QRY"
	
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "PEDIDOS DE COMPRA (EM ABERTO)"

	a_cond	:= {}
	Do While QRY->(!EOF())
		
		aDupl := Condicao(QRY->VALOR,QRY->C7_COND,,stod(QRY->C7_DATPRF))
		For n_x1 := 1 to len(aDupl)
			c_dtvenc := dtoS(aDupl[n_x1, 1])
			Do Case
				Case SubStr(c_dtvenc, 1,4) < c_anoref  //ano anterior
					TRAB->TRB_ANT += aDupl[n_x1, 2]
				Case SubStr(c_dtvenc, 1,4) = c_anoref
					If SubStr(c_dtvenc, 5,2) = SubStr(DtoS(dDataBase), 5, 2)
						If c_dtvenc < DtoS(dDataBase)
							TRAB->TRB_REAL += aDupl[n_x1, 2]
						Else
							TRAB->TRB_ABER += aDupl[n_x1, 2]
						EndIf
					Else
						TRAB->&("TRB_M"+SubStr(c_dtvenc, 5,2)) += aDupl[n_x1, 2]
					EndIf
			EndCase
		Next
		QRY->(DbSkip())
	EndDo
	TRAB->(MsUnLock())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	If DbSeek('060')
		n_totaln := 0
		For n_x := 1 to 12
			n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln
		MsUnLock()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra de linha                                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(a_separar, {'063','-'})
	Aadd(a_separar, {'064',' '})
	Aadd(a_separar, {'065','*'})
	//********************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
	//³PREVISAO DE MEDICAO                                                                      ³*
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
	//********************************************************************************************
	oObj:IncRegua1("Previsoes")
	c_grprec := '070' //PREVISAO DE MEDICAO

	cQuery := "SELECT ISNULL(SUM(Z9_RECEITA),0) AS RECEITA, ISNULL(SUM(Z9_DESPESA),0) AS DESPESA, '00' AS MES, '    ' AS ANO "
	cQuery += "FROM SZ9010 Z9 "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "      AND Z9_OBRA = '"+c_Obra+"' "
	cQuery += "      AND Z9_ANO < '"+c_anoref+"' "
	cQuery += "UNION ALL "
	cQuery += "SELECT Z9_RECEITA AS RECEITA, Z9_DESPESA AS DESPESA, Z9_MES AS MES, Z9_ANO AS ANO "
	cQuery += "FROM SZ9010 Z9 "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "      AND Z9_OBRA = '"+c_Obra+"' "
	cQuery += "      AND Z9_ANO = '"+c_anoref+"' "   
	//excluida a linha abaixo [Nauro Nagata, Actual Trend, 01/12/2011]
	//cQuery += "      AND Z9_MES >= '"+SubStr(dtos(dDataBase),5,2)+"' "
	
	MemoWrite("RFIN011_PRV.sql",cQuery)
	
	If Select("PRV") > 0
		DbSelectArea("PRV")
		DbCloseArea()
	EndIf
	
	TcQuery cQuery New Alias "PRV"
	
	DbSelectArea("PRV")
	DbGoTop()

	DbSelectArea('CTT')
	DbSetOrder(1)
	DbSeek(xFilial('CTT')+c_Obra)
	DbSelectArea('AF8')
	DbSetOrder(8) //AF8_FILIAL, AF8_CODOBR, R_E_C_N_O_, D_E_L_E_T_
	n_valcust := 0
	If DbSeek(xFilial('AF8')+CTT->CTT_CUSTO)  
		While AF8->AF8_CODOBR = CTT->CTT_CUSTO
			n_valcust += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
			AF8->(DbSkip())
		EndDo
	EndIf  

	nVlrPrvM := 0
	nVlrPrvD := 0
	Do While PRV->(!Eof())
		nVlrPrvM += PRV->RECEITA
		nVlrPrvD += PRV->DESPESA                                       
		   
		If TRAB->(DbSeek(c_grprec+'1RECEITA'))
			RecLock('TRAB', .F.)
		Else
			RecLock('TRAB', .T.)
		EndIf
		TRAB->TRB_GRPO	:= c_grprec
		TRAB->TRB_NAT	:= '1RECEITA'
		n_prevmd := CTT->CTT_XVLR - n_totCRA - nVlrImp
		n_prevmd := Iif(n_prevmd < 0, 0, n_prevmd)
		TRAB->TRB_DESC	:= "PREVISAO MEDICAO          [h]|" + Transform(n_prevmd,"@E 99,999,999")
		Do Case
			Case PRV->MES = SubStr(DtoS(dDataBase),5,2)
				TRAB->TRB_ABER += PRV->RECEITA
			Case PRV->MES = "00"
				TRAB->TRB_ANT += PRV->RECEITA
			Case PRV->ANO = c_anoref
				TRAB->&("TRB_M"+PRV->MES) += PRV->RECEITA
		EndCase
		
		If TRAB->(DbSeek(c_grprec+'2DESPESA'))
			RecLock('TRAB', .F.)
		Else
			RecLock('TRAB', .T.)
		EndIf
		TRAB->TRB_GRPO	:= c_grprec
		TRAB->TRB_NAT	:= '2DESPESA'
		n_prevmd 		:= n_valcust - n_TotDA
		n_prevmd		:= Iif(n_prevmd < 0, 0, n_prevmd)
		TRAB->TRB_DESC	:= "PREVISAO DESPESA          [i]|" + Transform(n_prevmd,"@E 99,999,999")
		Do Case
			Case PRV->MES = SubStr(DtoS(dDataBase),5,2)
				TRAB->TRB_ABER += PRV->DESPESA
			Case PRV->MES = "00"
				TRAB->TRB_ANT += PRV->DESPESA
			Case PRV->ANO = c_anoref
				TRAB->&("TRB_M"+PRV->MES) += PRV->DESPESA
		EndCase
		PRV->(DbSkip())
	EndDo
	TRAB->(MsUnLock())
	DbSelectArea("PRV")
	DbCloseArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra de linha                                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	DbSeek('070')
	a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	n_totaln := 0
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO = '070'
		n_totaln := 0
		For n_x := 1 to 12
			//a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2)) * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
			//n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))
			//substituida o bloco acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 01/12/2011]
			//inicio bloco [Mauro Nagata, Actual Trend, 01/12/2011]
			If n_x >= Val(SubStr(DtoS(dDataBase),5,2))
 			   a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2)) * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
			   n_totaln += TRAB->&("TRB_M"+StrZero(n_x,2))          
			EndIf   
			//inicio bloco [Mauro Nagata, Actual Trend, 01/12/2011]
		Next
		//a_totais[13] += TRAB->TRB_ANT * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
		//a_totais[14] += TRAB->TRB_REAL * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
		//a_totais[15] += TRAB->TRB_ABER * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
		//a_totais[16] += TRAB->TRB_VENC * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
		//substituida o bloco acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 01/12/2011]
		//inicio bloco [Mauro Nagata, Actual Trend, 01/12/2011]
		If n_x >= Val(SubStr(DtoS(dDataBase),5,2))
			a_totais[13] += TRAB->TRB_ANT * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
			a_totais[14] += TRAB->TRB_REAL * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
			a_totais[15] += TRAB->TRB_ABER * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
			a_totais[16] += TRAB->TRB_VENC * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
		EndIf
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + TRAB->TRB_ABER + n_totaln
		MsUnLock()
		a_totais[17] += TRAB->TRB_TOT * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)
		TRAB->(DbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza a linha                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(a_separar, {'071','-'})
	c_grprec := '072' //Grupo de Receitas - subgrupo total de despesas
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "SALDO PREVISAO           [h+i]|"
	For n_x := 1 to 12
		TRAB->&("TRB_M"+StrZero(n_x,2)) := a_totais[n_x]
	Next
	TRAB->TRB_ANT	:= a_totais[13]
	TRAB->TRB_REAL	:= a_totais[14]
	TRAB->TRB_ABER	:= a_totais[15]
	TRAB->TRB_VENC	:= a_totais[16]
	TRAB->TRB_TOT	:= a_totais[17]
	TRAB->(MsUnLock())

	Aadd(a_separar, {'073','*'})
	For n_x := 1 to len(a_separar)
		c_grprec := a_separar[n_x,1] //separador
		RecLock('TRAB', .T.)
		TRAB->TRB_GRPO	:= c_grprec
		TRAB->TRB_DESC	:= replicate(a_separar[n_x,2], 40)
		TRAB->(MsUnLock())
	Next

Return  
// fim bloco [Mauro Nagata, Actual Trend, 11/06/2012]
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRetCusto ºAutor  ³Alexandre Sousa     º Data ³  11/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o custo do orcamento.                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN011   ºAutor  ³Microsiga           º Data ³  10/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a data de emsissao do RA para compor o titulo.      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      
/*
//excluido bloco abaixo [Mauro Nagata, Actual Trend, 11/06/2012]
Static Function fRetdtRA(c_vencrea)

	Local a_Area := GetArea()
	Local c_Ret := c_vencrea

	c_chave := SubStr(SE5->E5_DOCUMEN,1,3) // Prefixo
	c_chave += Iif(len(alltrim(SE5->E5_DOCUMEN))<= 15, substr(SE5->E5_DOCUMEN, 4,6), substr(SE5->E5_DOCUMEN, 4,9))//Numero
	c_chave += Iif(len(alltrim(SE5->E5_DOCUMEN))<= 15, substr(SE5->E5_DOCUMEN,10,1), substr(SE5->E5_DOCUMEN,13,1))//Parcela
	c_chave += 'RA'
	
	DbSelectArea('SE1')
	DbSetOrder(1) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	If DbSeek(xFilial('SE1')+c_chave)
		c_Ret := dtos(SE1->E1_EMISSAO)
	EndIf
	
	RestArea(a_Area)

Return c_Ret
//fim bloco [Mauro Nagata, Actual Trend, 11/06/2012]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN011   ºAutor  ³Alexandre Sousa     º Data ³  09/26/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os valores de mao de obra utilizadas no mes         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                              
/*
//excluido bloco abaixo [Mauro Nagata, Actual Trend, 11/06/2012]
Static Function fBusMod(c_datalike)
	
	n_Ret := 0
	c_query := ''

	c_query := " select     ZC_DATA, ZC_OBRA, ZC_RECURSO, AE8_CUSTOM, AE8_CUSTOM/22 as CUSTO_DIA"
	c_query += " from       "+RetSqlName('SZC')+" as SZC"
	c_query += " inner join "+RetSqlName('AE8')+" as AE8"
	c_query += " on         ZC_RECURSO = AE8_RECURS"
	c_query += " and        AE8.D_E_L_E_T_ <> '*'"
	c_query += " where      ZC_OBRA = '"+CTT->CTT_CUSTO+"'"
	c_query += " and        ZC_DATA like '"+c_datalike+"%'"
	c_query += " and        SZC.D_E_L_E_T_ <> '*'"

	If Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf
	
	TcQuery c_Query New Alias "TMP"

	While TMP->(!EOF())
		n_Ret += TMP->CUSTO_DIA
		TMP->(DbSkip())
	EndDo

Return n_Ret
//fim bloco [Mauro Nagata, Actual Trend, 11/06/2012]
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TrataSE5  ºAutor  ³Alexandre Sousa     º Data ³  12/15/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza o tratamento do se5 para titulos com baixa parcial  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      
/*
//excluido bloco abaixo [Mauro Nagata, Actual Trend, 11/06/2012]
Static Function TrataSE5(c_anoref)

	Local c_EOL		:= chr(13)+chr(10)
	
	c_query := " select * " + c_EOL
	c_query += " from SE5010 " + c_EOL
	c_query += " where     E5_FILIAL  = '"+xFilial('SE5')+"'" + c_EOL
	c_query += " and       E5_PREFIXO = '" + QRX->E1_PREFIXO + "'" + c_EOL
	c_query += " and       E5_NUMERO  = '" + QRX->E1_NUM + "'" + c_EOL
	c_query += " and       E5_PARCELA = '" + QRX->E1_PARCELA + "'" + c_EOL
	c_query += " and       E5_TIPO    = '" + QRX->E1_TIPO + "'" + c_EOL
	c_query += " and       E5_CLIFOR  = '" + QRX->E1_CLIENTE + "'" + c_EOL
	c_query += " and       E5_LOJA    = '" + QRX->E1_LOJA + "'" + c_EOL
//	c_query += " and       E5_RECONC  = 'x' " + c_EOL
	c_query += " and       D_E_L_E_T_ <> '*' " + c_EOL
	
	If Select("QRW") > 0
		DbSelectArea("QRW")
		DbCloseArea()
	EndIf
	
	TcQuery c_Query New Alias "QRW"

	While QRW->(!EOF())

		c_vencrea := QRW->E5_DATA

		If TRAB->(DbSeek(c_grprec+QRX->E1_NATUREZ))
			RecLock('TRAB', .F.)
		Else
			RecLock('TRAB', .T.)
			TRAB->TRB_GRPO	:= c_grprec
			TRAB->TRB_NAT	:= QRX->E1_NATUREZ
			TRAB->TRB_DESC	:= substr(QRX->E1_NATUREZ,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+QRX->E1_NATUREZ, 1, 'X'), 1,32)
		EndIf

		If SubStr(c_vencrea, 5,2) <> SubStr(DtoS(dDataBase), 5, 2)
			If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
				TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRW->E5_VALOR
				nVlrImp += QRW->E5_VALOR
			Else
				If QRW->E5_TIPODOC = 'MT'
					TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) -= QRW->E5_VALOR
				Else
					TRAB->&("TRB_M"+SubStr(c_vencrea, 5,2)) += QRW->E5_VALOR
				EndIf
			EndIf
		ElseIf SubStr(c_vencrea, 5,2) = SubStr(DtoS(dDataBase), 5, 2) .And.SubStr(c_vencrea, 1,4) = c_anoref
			If ALLTRIM(QRX->E1_NATUREZ) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
				TRAB->TRB_REAL -= QRW->E5_VALOR  //MES ATUAL REALIZADO
				nVlrImp += QRW->E5_VALOR  //valor dos impostos
			Else
				If QRW->E5_TIPODOC = 'MT'
					TRAB->TRB_REAL -= QRW->E5_VALOR  //MES ATUAL REALIZADO
				Else
					TRAB->TRB_REAL += QRW->E5_VALOR  //MES ATUAL REALIZADO
				EndIf
			EndIf
		EndIf
		
		TRAB->(MsUnLock())
		
		QRW->(DbSkip())
	EndDo

Return
//fim bloco [Mauro Nagata, Actual Trend, 11/06/2012]
*/            
