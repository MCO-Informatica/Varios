#include 'TopConn.ch'
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN011   บ Autor ณAlexandre Sousa     บ Data ณ  01/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelatorio de acompanhamento financeiro da Obra.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico LISONDA.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFIN018()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Acompanhamento Financeiro da Obra"
	Local cPict          := ""
	Local titulo         := "Acompanhamento Financeiro da Obra"
	Local imprime     	 := .T.
	Local aOrd := {}
	//                                 10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
	//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Local Cabec1         := "Natureza                                |  2009    |  JANEIRO | FEVEREIRO|     MARวO|    ABRIL |      MAIO|     JUNHO|     JULHO|    AGOSTO|  SETEMBRO|   OUTUBRO|       NOVEMBRO      |  DEZEMBRO|  VENCIDOS |      TOTAL |"
	Local Cabec2         := "                                        |          |                                                                                                             | REALIZADO|    ABERTO|                                     "
	//                       9999 - xxxxxxxxxxxxxxxxxxxx   |999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|999,999.99|99,999,999.99|
	Private a_Cols		 := {1,                          29,       40,        51,        62,        73,        84,        95,       106,       117,       128,       139,       150,       161,       172,       183,       194,       206,         220  ,36,    46,49,       60,62,      72,74,        84,86,     96,98,      108 }
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RFIN018" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "RFIN011"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFIN018" // Coloque aqui o nome do arquivo usado para impressao em disco
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
	
	n_mesatu := MONTH(dDataBase)
	n_mesini := 1
	n_anoini := 1
	If n_mesatu <= 9
		n_mesini := 12 - (9-n_mesatu)
		n_anoini := year(dDataBase)-1
	Else
		n_mesini := n_mesatu-9
		n_anoini := year(dDataBase)
	EndIf
	n_mesatu := n_mesatu
	
	Cabec1	:= "Natureza                                |  <-"+strzero(val(MV_PAR03)-1,4)+"  " //|  JANEIRO | FEVEREIRO|     MARวO|    ABRIL |      MAIO|     JUNHO|     JULHO|    AGOSTO|  SETEMBRO|   OUTUBRO|       NOVEMBRO      |  DEZEMBRO|  VENCIDOS |        TOTAL|"
	Cabec2	:= "                                        |          " //|                                                                                                             | REALIZADO|    ABERTO|                                     "
	n_y := n_mesini
	For n_x := 1 to 12          	
		If n_mesatu = n_y .and. Substr(dtos(dDataBase),1,4) = MV_PAR03
			Cabec1 += "|"+space(8)+padr(AMESES[n_y],13)
			Cabec2 += "| REALIZADO|    ABERTO|"
		Else
			Cabec1 += "|"+padr(AMESES[n_y],10)
			Cabec2 += Space(11)
		EndIf
		If n_y = 12
			n_y := 1
		Else
			n_y++
		EndIf
	Next
	Cabec1 += "|  VENCIDOS |        TOTAL|"
	
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
	If MV_PAR04 == 1
		Cabec1  := "  OBRA                           DESCRIวยO                               VLR. VENDA      VLR. CUSTO    R. PREVISTO   DESP.ACUMULADA  SLD.A GASTAR    R. ATUAL    RES.PREV.xREAL   POS. FINANC. MES"
		Cabec2  := "                                                                              1              2             3=1-2          4             5=2-4          6=1-4         7=2-4   "
		RptStatus({|| Run2Repor(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Else
		if AllTrim(mv_par01) $ cObrRestr .Or. AllTrim(mv_par02) $ cObrRestr
			if AllTrim(PswRet()[1][1]) $ cUsuObra
				RptStatus({|| RunReport1(Cabec1,Cabec2,Titulo,nLin) },Titulo)
			else
				MsgInfo('Usuแrio sem permissใo para visualizar este Centro de Custo')
			EndIf
		else 
			RptStatus({|| RunReport1(Cabec1,Cabec2,Titulo,nLin) },Titulo)
		EndIf
	EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT1บ Autor ณ AP6 IDE            บ Data ณ  01/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport1(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local oProcess
	Local a_saldo := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}
	
	dbSelectArea("CTT")
	dbSetOrder(1) //CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_     
	DbSeek(xFilial('CTT')+MV_PAR01,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SetRegua(RecCount())
	
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
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณValida o filtro de FISCAL de obra de ate                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If MV_PAR08 > AF8->AF8_CODF1 .or. MV_PAR09 < AF8->AF8_CODF1
		   		CTT->(DbSkip())
		   		Loop
			EndIf
			                                          
			//inicio - incluido bloco abaixo [Mauro Nagata, Actual Trend, 18/05/2012]
			lIpAF8 := .T.                             
			cDtPrj := Ctod("")
			While AF8->AF8_CODOBR = CTT->CTT_CUSTO
				n_valcust += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
				If lIpAF8 
				   lIpAF8 := .F.
				   cDtPrj := Dtoc(AF8->AF8_DATA)
				EndIf
				AF8->(DbSkip())
			EndDo
			//fim bloco [Mauro Nagata, Actual Trend, 18/05/2012]
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAdicionado bloco abaixo para permitir que somente os usuแrios mastersณ
			//ณtenham acesso a obras de outras filiais [Bruno Parreira, 09/09/2011] ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
//		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
//		Endif    

        //inicio - rotina define o custo de mao-de-obra [Mauro Nagata, Actual Trend, 18/05/2012]                      	                                                  
	    nVCusMO := 0             
	    aAreaAF8 := AF8->(GetArea())
	    aAreaAFA := AFA->(GetArea())
		DbSelectArea("AF8")
		DbSetOrder(8)
		If DbSeek(xFilial("AF8")+CTT->CTT_CUSTO)
		   DbSelectArea("AFA")
		   DbSetOrder(2)
		   If DbSeek(xFilial("AFA")+AF8->AF8_PROJET+'0001'+Space(15))
		      Do While !Eof().And.AFA->AFA_PROJET=AF8->AF8_PROJET.And.AFA->AFA_REVISA='0001'.And.AFA->AFA_PRODUT = Space(15).And.!Empty(AFA->AFA_RECURS)
		         nVCusMO += AFA->AFA_QUANT*AFA->AFA_CUSTD
		         DbSkip()
		      EndDo
		   EndIf      	   
		EndIf   
		RestArea(aAreaAF8)
		RestArea(aAreaAFA)
		//fim - rotina define o custo de mao-de-obra [Mauro Nagata, Actual Trend, 18/05/2012]				
		
		nLin++
		@nLin,00 PSAY " *** OBRA *** " + CTT->CTT_CUSTO + " - " + CTT->CTT_DESC01
		@nLin,a_Cols[14] PSAY "Valor Total da Obra: " + TransForm(CTT->CTT_XVLR, "@RE 99,999,999.99")
		@nLin,a_Cols[07] PSAY "Custo Estimado da Obra: " + TransForm(n_valcust, "@RE 99,999,999.99")
		nLin++
		@nLin,00 PSAY " Cliente....: " + CTT->CTT_XCONT1+'/'+CTT->CTT_XLJCT1 + ' - ' + GetAdvFval('SA1', 'A1_NOME', xFilial('SA1')+CTT->CTT_XCONT1+CTT->CTT_XLJCT1, 1, '-')
		@nLin,a_Cols[14] PSAY "Limite Fat. Direto : " + TransForm(CTT->CTT_XFATD, "@RE 99,999,999.99")
		             
		//inicio - incluido o bloco abaixo [Mauro Nagata, Actual Trend, 18/05/2012]
		@nLin,84 PSAY "Custo Material        : " + TransForm(n_ValCust - nVCusMO, "@RE 99,999,999.99")
	    nLin++                                                                                      
	    @nLin,00 PSay " Data Projeto: "+cDtPrj        //solicitacao do Artur 09/05/2012
	    @nLin,83 PSAY "Custo Mao-de-Obra     : " + TransForm(nVCusMO, "@RE 99,999,999.99")
        //fim bloco [Mauro Nagata, Actual Trend, 18/05/2012]
        
		nLin++
		@nLin,00 PSAY Replicate('-', 220)
		nLin++
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAcumulado no periodo                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, STRZERO(n_anoini,4),,"9x3")},STRZERO(n_anoini,4)+"-Processando informa็๕es da Obra","Preparando . . .",.F.,"9x3")
		oProcess:Activate()

		c_nat := ''
		DbSelectArea('TRAB')	
		DbGotop()
		a_trab1 := {}
		While TRAB->(!EOF())
			aAdd(a_trab1,{	TRAB->&("TRB_M"+strzero(01,2)),;
							TRAB->&("TRB_M"+strzero(02,2)),;
					     	TRAB->&("TRB_M"+strzero(03,2)),;
						    TRAB->&("TRB_M"+strzero(04,2)),;
							TRAB->&("TRB_M"+strzero(05,2)),;
			    			TRAB->&("TRB_M"+strzero(06,2)),;
			     			TRAB->&("TRB_M"+strzero(07,2)),;
			     			TRAB->&("TRB_M"+strzero(08,2)),;
			     			TRAB->&("TRB_M"+strzero(09,2)),;
			     			TRAB->&("TRB_M"+strzero(10,2)),;
			     			TRAB->&("TRB_M"+strzero(11,2)),;
			     			TRAB->&("TRB_M"+strzero(12,2)),;
			     			TRAB->TRB_REAL,;
			     			TRAB->TRB_ABER,;
			     			TRAB->TRB_ANT,;
			     			TRAB->TRB_DESC,;
			     			TRAB->TRB_GRPO,;
			     			TRAB->TRB_NAT})
			TRAB->(DbSkip())
		EndDo
		
//		If n_mesini <> 1
		oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, STRZERO(n_anoini+1,4),,"9x3")},STRZERO(n_anoini+1,4)+"-Processando informa็๕es da Obra","Preparando . . .",.F.)
		oProcess:Activate()
//		EndIf
		TRAB->(DbGotop())
		While TRAB->(!EOF())
			n_posatrb := aScan(a_trab1,{|x| x[17]+x[18] == TRAB->TRB_GRPO+TRAB->TRB_NAT})
			If n_posatrb <= 0
				aAdd(a_trab1,{	0,;
								0,;
						     	0,;
							    0,;
								0,;
				    			0,;
				     			0,;
				     			0,;
				     			0,;
				     			0,;
				     			0,;
				     			0,;
				     			0,;
				     			0,;
				     			0,;
				     			TRAB->TRB_DESC,;
				     			TRAB->TRB_GRPO,;
				     			TRAB->TRB_NAT})
			EndIf
			TRAB->(DbSkip())
		EndDo

		aSort(a_trab1, , , {|x, y| x[17]+x[18] < y[17]+y[18]})


		For n_w := 1 to len(a_trab1)
			If Empty(a_trab1[n_w, 16])
				nLin++
				Loop
			EndIf
			If '----' $ a_trab1[n_w, 16] .or. '****' $ a_trab1[n_w, 16]
				@nLin,00 PSAY Replicate(substr(a_trab1[n_w, 16],1,1), 220)
				nLin++
				Loop
			EndIf
			
			If n_mesini <> 1
				n_totant := a_trab1[n_w, 15]
				For n_x := 1 to n_mesini
					n_totant += a_trab1[n_w, n_x]
				Next
				@nLin,00 PSAY a_trab1[n_w, 16]
				@nLin,a_Cols[03] PSAY "|" + Transform( n_totant, "@RE 99,999,999")                
			Else
				@nLin,00 PSAY a_trab1[n_w, 16]
				@nLin,a_Cols[03] PSAY "|" + Transform( a_trab1[n_w, 16], "@RE 99,999,999")                
			EndIf
			
			
			
			n_y := 4
			For n_x := n_mesini to 12
			
				If n_x = val(substr(dtos(ddatabase),5,2)) .and. Substr(dtos(dDataBase),1,4) = MV_PAR03
					@nLin,a_Cols[n_y] PSAY "|" + Transform( a_trab1[n_w, 13], "@RE 99,999,999")
					n_y++
					@nLin,a_Cols[n_y] PSAY "|" + Transform( a_trab1[n_w, 14], "@RE 99,999,999")
				Else                           
				   //@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->&("TRB_M"+strzero(n_x,2)), "@RE 99,999,999")
				   //substituida a linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 01/12/2011]
				   //inicio bloco [Mauro Nagata, Actual Trend, 01/12/2011]            
				   If a_trab1[n_w, 17] = "070" .Or. a_trab1[n_w, 17] = "071"
				      If n_x >= val(substr(dtos(ddatabase),5,2))
					     @nLin,a_Cols[n_y] PSAY "|" + Transform( a_trab1[n_w, n_x], "@RE 99,999,999")
				      Else
				   	     @nLin,a_Cols[n_y] PSAY "|" + Transform( 0, "@RE 99,999,999")
			   	      EndIf
				   Else	     
				      @nLin,a_Cols[n_y] PSAY "|" + Transform( a_trab1[n_w, n_x], "@RE 99,999,999")
				   EndIf	  
				   //fim bloco [Mauro Nagata, Actual Trend, 01/12/2011]
				EndIf
				n_y++
			Next

			//index on TRB_GRPO+TRB_NAT to (cArqTrab)
			DbSelectArea('TRAB')
			DbSeek(a_trab1[n_w, 17]+a_trab1[n_w, 18])

			For n_x := 1 to n_mesini-1
				If n_x = val(substr(dtos(ddatabase),5,2)) .and. Substr(dtos(dDataBase),1,4) = MV_PAR03
					@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_REAL, "@RE 99,999,999")
					n_y++
					@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_ABER, "@RE 99,999,999")
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
				EndIf
				n_y++
			Next
			@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_VENC, "@RE 99,999,999")
			n_y++
			@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_TOT, "@RE 99,999,999")
			
			nLin++
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. . .                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
		Next
	
		CTT->(dbSkip()) // Avanca o ponteiro do registro no arquivo

	EndDo

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

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRun2Repor บ Autor ณ AP6 IDE            บ Data ณ  01/11/10   บฑฑ
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

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณValida o filtro de FISCAL de obra de ate                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If MV_PAR08 > AF8->AF8_CODF1 .or. MV_PAR09 < AF8->AF8_CODF1
		   		CTT->(DbSkip())
		   		Loop
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAdicionado bloco abaixo para permitir que somente os usuแrios mastersณ
			//ณtenham acesso a obras de outras filiais [Bruno Parreira, 09/09/2011] ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		
//                            10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//		Cabec1  := "  OBRA                           DESCRIวยO                               VLR. VENDA      VLR. CUSTO    R. PREVISTO   DESP.ACUMULADA  SLD.A GASTAR     RESULTADO   RES.PREV.xREAL   POS. FINANC. MES"
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
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAcumulado no periodo                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, MV_PAR03),,"9x3"},"Processando Obra " +strzero(n_atu, 4)+ ' de '+strzero(n_count,4),"Preparando . . .",.F.)
		
		oProcess:Activate()

		DbSelectArea('TRAB')
		DbSeek('028')
		@nLin,a_2pos[06] PSAY TransForm(TRAB->TRB_TOT, "@RE 99,999,999.99")
		a_totais[04]	+= TRAB->TRB_TOT
		n_result		:= CTT->CTT_XVLR- TRAB->TRB_TOT //(CTT->CTT_XVLR-n_valcust) + (n_valcust - TRAB->TRB_TOT)
		n_prvxreal		:= n_valcust - TRAB->TRB_TOT//n_result - (CTT->CTT_XVLR-n_valcust)
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

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณValidPerg บAutor  ณCosme da Silva NunesบData  ณ13.11.2007   บฑฑ
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
Aadd(aRegs,{cPerg	,"01"	,"Obra de          ?"	,""					,""					,"mv_ch1"	,"C"	,09			,00		,0		,"G"	,""		,"mv_par01"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"CTT"	,""		})
Aadd(aRegs,{cPerg	,"02"	,"Obra At้         ?"	,""					,""					,"mv_ch2"	,"C"	,09			,00		,0		,"G"	,""		,"mv_par02"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"CTT"	,""		})
Aadd(aRegs,{cPerg	,"03"	,"Ano Referencia   ?"	,""					,""					,"mv_ch3"	,"C"	,04			,00		,0		,"G"	,""		,"mv_par03"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})
Aadd(aRegs,{cPerg	,"04"	,"Tipo             ?"	,""					,""					,"mv_ch4"	,"C"	,01			,00		,0		,"C"	,""		,"mv_par04"	,"Sintetico",""		,""		,""		,""		,"Analitico" ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""	    ,""		})    
Aadd(aRegs,{cPerg	,"05"	,"Impr. Bloqueadas ?"	,""					,""					,"mv_ch5"	,"C"	,01			,00		,0		,"C"	,""		,"mv_par05"	,"Sim"      ,""		,""		,""		,""		,"Nao"       ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""	    ,""		})    
Aadd(aRegs,{cPerg	,"06"	,"Filial de        ?"	,""					,""					,"mv_ch6"	,"C"	,02			,00		,0		,"G"	,""		,"mv_par06"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})
Aadd(aRegs,{cPerg	,"07"	,"Filial At้       ?"	,""					,""					,"mv_ch7"	,"C"	,02			,00		,0		,"G"	,""		,"mv_par07"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})
Aadd(aRegs,{cPerg	,"08"	,"Fiscal de        ?"	,""					,""					,"mv_ch8"	,"C"	,02			,00		,0		,"G"	,""		,"mv_par08"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"ZZ"	,""		})
Aadd(aRegs,{cPerg	,"09"	,"Fiscal At้       ?"	,""					,""					,"mv_ch9"	,"C"	,02			,00		,0		,"G"	,""		,"mv_par09"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"ZZ"	,""		})

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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN011   บAutor  ณMicrosiga           บ Data ณ  10/20/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a data de emsissao do RA para compor o titulo.      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN011   บAutor  ณAlexandre Sousa     บ Data ณ  09/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna os valores de mao de obra utilizadas no mes         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrataSE5  บAutor  ณAlexandre Sousa     บ Data ณ  12/15/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza o tratamento do se5 para titulos com baixa parcial  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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

		If TRAB->(DbSeek(c_grprec+c_natureza))
			RecLock('TRAB', .F.)
		Else
			RecLock('TRAB', .T.)
			TRAB->TRB_GRPO	:= c_grprec
			TRAB->TRB_NAT	:= c_natureza
			TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
		EndIf

		If SubStr(c_vencrea, 5,2) <> SubStr(DtoS(dDataBase), 5, 2)
			If ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
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
			If ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'
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
