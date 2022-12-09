#include 'TopConn.ch'
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN011   º Autor ³Mauro Nagata        º Data ³  13/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio de acompanhamento financeiro da Obra.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFIN011()

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
	Private nomeprog     := "RFIN012" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "RFIN011"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFIN012" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private nLin         := 80
	Private nVlrImp      := 0         //valor dos impostos

	Private cObrRestr := GetMV('MV_XOBRRES')
	Private cUsuObra  := GetMV('MV_XUSROBR')
	Private cUsuMast  := GetMV('MV_XUSUMST')

	Private oExcel 	  := FWMSEXCEL():New()
	Private cObra     := ""
	Private aTotA     := {0,0,0,0,0,0,0,0,0,0,0,0}
	Private aTotB     := {0,0,0,0,0,0,0,0,0,0,0,0}
	Private aTotC     := {0,0,0,0,0,0,0,0,0,0,0,0}
	Private aTotD     := {0,0,0,0,0,0,0,0,0,0,0,0}
	Private aTotE     := {0,0,0,0,0,0,0,0,0,0,0,0}
	Private aTotF     := {0,0,0,0,0,0,0,0,0,0,0,0}
	Private aTotG     := {0,0,0,0,0,0,0,0,0,0,0,0}
	Private aTotDesAc := {0,0,0,0,0,0,0,0,0,0,0,0}

	AMESES := {}
	a_pdados := {}
	a_rdados := {}

//ValidPerg()
	pergunte(cPerg,.T.)

	If MV_PAR10 == 10 .AND. MV_PAR01 <> MV_PAR02
		MsgAlert("Para exportar de forma sintética para Excel, deve-se escolher apenas 1 obra!","Atenção")
		Return
	EndIf

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
		If val(Substr(dtos(dDataBase),5,2)) = n_x .and. Substr(dtos(dDataBase),1,4) = AllTrim(MV_PAR03)
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


	If MV_PAR10 == 1

		oExcel:AddworkSheet("Totais")
		oExcel:AddTable("Totais","Resumo")

	EndIf

	If MV_PAR04 == 1
		Cabec1  := "  OBRA                           DESCRIÇÂO                               VLR. VENDA      VLR. CUSTO    R. PREVISTO   DESP.ACUMULADA  SLD.A GASTAR    R. ATUAL    RES.PREV.xREAL   POS. FINANC. MES"
		//Cabec2  := "                                                                              1              2             3=1-2          4             5=2-4          6=1-4         7=4-2   "
		//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 06/03/2012]
		Cabec2  := "                                                                              1              2             3=1-2          4             5=2-4          6=1-4         7=2-4   "
		RptStatus({|| Run2Repor(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Else
		RptStatus({|| RunReport1(Cabec1,Cabec2,Titulo,nLin) },Titulo)

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

	While CTT->(!EOF()) .and. CTT->CTT_CUSTO <= MV_PAR02
		IncRegua()

		If !( AllTrim(PswRet()[1][1]) $ cUsuMast )
			if AllTrim(CTT->CTT_CUSTO) $ cObrRestr
				if !(AllTrim(PswRet()[1][1]) $ cUsuObra )
					CTT->(DbSkip())
					Loop
				EndIf
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
			//incluido linha abaixo conforme levantamento realizado com o Ney [Mauro Nagata, Actual Trend, 20141009]
			Do While !Eof().And.AF8->AF8_CODOBR = CTT->CTT_CUSTO
				DbSelectArea("AFA")
				DbSetOrder(2)
				If DbSeek(xFilial("AFA")+AF8->AF8_PROJET+'0001'+Space(15))
					Do While !Eof().And.AFA->AFA_PROJET=AF8->AF8_PROJET.And.AFA->AFA_REVISA='0001'.And.AFA->AFA_PRODUT = Space(15).And.!Empty(AFA->AFA_RECURS)
						nVCusMO += AFA->AFA_QUANT*AFA->AFA_CUSTD
						DbSkip()
					EndDo
				EndIf
				//inicio - incluido bloco abaixo, conforme levantamento realizado com o Ney [Mauro Nagata, Actual Trend, 20141009]
				DbSelectArea("AF8")
				DbSkip()
			EndDo
			//fim - incluido bloco acima, conforme levantamento realizado com o Ney [Mauro Nagata, Actual Trend, 20141009]
		EndIf
		RestArea(aAreaAF8)
		RestArea(aAreaAFA)
		//fim - rotina define o custo de mao-de-obra [Mauro Nagata, Actual Trend, 18/05/2012]



		nLin++
		@nLin,00          PSAY " *** OBRA *** " + CTT->CTT_CUSTO + " - " + CTT->CTT_DESC01
		@nLin,a_Cols[14] PSAY "Valor Total da Obra: " + TransForm(CTT->CTT_XVLR, "@RE 99,999,999.99")
		//@nLin,a_Cols[07] PSAY "Custo Estimado da Obra: " + TransForm(n_valcust, "@RE 99,999,999.99")
		@nLin,90 PSAY "Custo Estimado da Obra: " + TransForm(n_valcust, "@RE 99,999,999.99")
		nLin++
		@nLin,00         PSAY " Cliente.....: " + CTT->CTT_XCONT1+'/'+CTT->CTT_XLJCT1 + ' - ' + GetAdvFval('SA1', 'A1_NOME', xFilial('SA1')+CTT->CTT_XCONT1+CTT->CTT_XLJCT1, 1, '-')
		@nLin,a_Cols[14] PSAY "Limite Fat. Direto : " + TransForm(CTT->CTT_XFATD, "@RE 99,999,999.99")
		//@nLin,a_Cols[07] PSAY "Custo Material        : " + TransForm(n_ValCust - nVCusMO, "@RE 99,999,999.99")
		@nLin,90 PSAY "Custo Material        : " + TransForm(n_ValCust - nVCusMO, "@RE 99,999,999.99")
		nLin++
		@nLin,00 PSay " Data Projeto: "+cDtPrj        //solicitacao do Artur 09/05/2012
		//@nLin,a_Cols[07] PSAY "Custo Mao-de-Obra     : " + TransForm(nVCusMO, "@RE 99,999,999.99")
		@nLin,89 PSAY "Custo Mao-de-Obra     : " + TransForm(nVCusMO, "@RE 99,999,999.99")
		nLin++
		@nLin,00 PSAY Replicate('-', 220)
		nLin++

		If MV_PAR10 == 1

			cObra := MV_PAR01 + ' - ' + Posicione("CTT",1,xFilial("CTT")+MV_PAR01,"CTT_DESC01")

			oExcel:AddColumn("Totais","Resumo","Legenda",3,1)
			oExcel:AddColumn("Totais","Resumo"," ",3,1)
			oExcel:AddColumn("Totais","Resumo"," ",3,1)
			oExcel:AddColumn("Totais","Resumo"," ",3,1)
			oExcel:AddColumn("Totais","Resumo"," ",3,1)
			oExcel:AddColumn("Totais","Resumo"," ",3,1)


			oExcel:AddRow("Totais","Resumo",{"Obra"	                 ,cObra											," "," "," "," "})
			oExcel:AddRow("Totais","Resumo",{"Valor Total da Obra"   ,TransForm(CTT->CTT_XVLR, "@RE 99,999,999.99") ," "," "," "," "})
			oExcel:AddRow("Totais","Resumo",{"Custo Estimado da Obra",TransForm(n_valcust, "@RE 99,999,999.99")     ," "," "," "," "})
			oExcel:AddRow("Totais","Resumo",{"Limite Fat. Direto"    ,TransForm(CTT->CTT_XFATD, "@RE 99,999,999.99")," "," "," "," "})

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Acumulado no periodo                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, MV_PAR03,,"A")},"Processando informações da Obra "+CTT->CTT_CUSTO,"Preparando . . .",.F.)
		oProcess:Activate()

		DespObra(CTT->CTT_CUSTO)

		c_nat := ''
		DbSelectArea('TRAB')
		DbGotop()
		While TRAB->(!EOF())
			If Empty(TRAB->TRB_DESC)
				nLin++
				TRAB->(DbSkip())
				Loop
			EndIf
			If '----' $ TRAB->TRB_DESC .or. '****' $ TRAB->TRB_DESC
				@nLin,00 PSAY Replicate(substr(TRAB->TRB_DESC,1,1), 220)
				nLin++
				TRAB->(DbSkip())
				Loop
			EndIf

			lIpQRF  := .F.
			nVlrQRF := 0

			DbSelectArea("QRF")
			DbGoTop()
			Do While !Eof()
				If (SubStr(TRAB->TRB_NAT,1,4) = QRF->NATUREZ) .Or. (TRAB->TRB_GRPO = "022".And.QRF->NATUREZ = "MOU")
					nVlrQRF := Round(QRF->VLR_ORCA,0)
					lIpQRF := .T.
					Exit
				EndIf
				DbSkip()
			EndDo
			If Empty(nVlrQRF).And.!lIpQRF
				cTrbDesc := TRAB->TRB_DESC
			Else
				cTrbDesc := Substr(TRAB->TRB_DESC,1,25)+" Orc."+Transform(nVlrQRF,"@RE 999,999")
			EndIf
			@ nLin,00 PSAY cTrbDesc
			//@ nLin,00 PSAY TRAB->TRB_DESC
			@nLin,a_Cols[03] PSAY "|" + Transform( TRAB->TRB_ANT, "@RE 99,999,999")

			n_y := 4
			For n_x := 1 to 12
				If n_x = val(substr(dtos(ddatabase),5,2)) .and. Substr(dtos(dDataBase),1,4) = AllTrim(MV_PAR03)
					@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_REAL, "@RE 99,999,999")
					n_y++
					@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_ABER, "@RE 99,999,999")
				Else

					If TRAB->TRB_GRPO = "070" .Or. TRAB->TRB_GRPO = "071"
						If n_x >= val(substr(dtos(ddatabase),5,2))
							@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->&("TRB_M"+strzero(n_x,2)), "@RE 99,999,999")
						Else
							@nLin,a_Cols[n_y] PSAY "|" + Transform( 0, "@RE 99,999,999")
						EndIf
					Else
						@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->&("TRB_M"+strzero(n_x,2)), "@RE 99,999,999")
					EndIf
				EndIf
				n_y++
			Next
			@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_VENC, "@RE 99,999,999")
			n_y++
			@nLin,a_Cols[n_y] PSAY "|" + Transform( TRAB->TRB_TOT, "@RE 99,999,999")

			nLin++
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			TRAB->(DbSkip())
		EndDo

		CTT->(dbSkip()) // Avanca o ponteiro do registro no arquivo

	EndDo

	If MV_PAR10 == 1

	oExcel:AddRow("Totais","Resumo",{"Janeiro"      ,aTotA[1] ,aTotB[1]  ,aTotC[1]  ,aTotG[1]  ,aTotC[1]-aTotG[1]   })
	oExcel:AddRow("Totais","Resumo",{"Fevereiro"    ,aTotA[2] ,aTotB[2]  ,aTotC[2]  ,aTotG[2]  ,aTotC[2]-aTotG[2]   })
	oExcel:AddRow("Totais","Resumo",{"Março"        ,aTotA[3] ,aTotB[3]  ,aTotC[3]  ,aTotG[3]  ,aTotC[3]-aTotG[3]   })
	oExcel:AddRow("Totais","Resumo",{"Abril"        ,aTotA[4] ,aTotB[4]  ,aTotC[4]  ,aTotG[4]  ,aTotC[4]-aTotG[4]   })
	oExcel:AddRow("Totais","Resumo",{"Maio"         ,aTotA[5] ,aTotB[5]  ,aTotC[5]  ,aTotG[5]  ,aTotC[5]-aTotG[5]   })
	oExcel:AddRow("Totais","Resumo",{"Junho"        ,aTotA[6] ,aTotB[6]  ,aTotC[6]  ,aTotG[6]  ,aTotC[6]-aTotG[6]   })
	oExcel:AddRow("Totais","Resumo",{"Julho"        ,aTotA[7] ,aTotB[7]  ,aTotC[7]  ,aTotG[7]  ,aTotC[7]-aTotG[7]   })
	oExcel:AddRow("Totais","Resumo",{"Agosto"       ,aTotA[8] ,aTotB[8]  ,aTotC[8]  ,aTotG[8]  ,aTotC[8]-aTotG[8]   })
	oExcel:AddRow("Totais","Resumo",{"Setembro"     ,aTotA[9] ,aTotB[9]  ,aTotC[9]  ,aTotG[9]  ,aTotC[9]-aTotG[9]   })
	oExcel:AddRow("Totais","Resumo",{"Outubro"      ,aTotA[10],aTotB[10] ,aTotC[10] ,aTotG[10] ,aTotC[10]-aTotG[10] })
	oExcel:AddRow("Totais","Resumo",{"Novembro"     ,aTotA[11],aTotB[11] ,aTotC[11] ,aTotG[11] ,aTotC[11]-aTotG[11] })
	oExcel:AddRow("Totais","Resumo",{"Dezembro"     ,aTotA[12],aTotB[12] ,aTotC[12] ,aTotG[12] ,aTotC[12]-aTotG[12] })


		If !Empty(oExcel:aWorkSheet)

			oExcel:Activate()
			//oExcel:GetXMLFile(cArquivo)
			oExcel:GetXMLFile("C:\Temp\ResumoObra.xls")

			//CpyS2T("\SYSTEM\"+cArquivo, cPath)

			oExcel := MsExcel():New()
			oExcel:WorkBooks:Open("C:\Temp\ResumoObra.xls") // Abre a planilha
			oExcel:SetVisible(.T.)

		EndIf

	EndIf

	If MV_PAR10 == 2

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
	EndIf

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
	Do While CTT->(!EOF()) .and. CTT->CTT_CUSTO <= MV_PAR02
		IncRegua()
		n_atu++

		If !( AllTrim(PswRet()[1][1]) $ cUsuMast )
			if AllTrim(CTT->CTT_CUSTO) $ cObrRestr
				if !(AllTrim(PswRet()[1][1]) $ cUsuObra )
					CTT->(DbSkip())
					Loop
				EndIf
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
		oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, MV_PAR03,,"A")},"Processando Obra " +strzero(n_atu, 4)+ ' de '+strzero(n_count,4),"Preparando . . .",.F.)

		oProcess:Activate()

		DbSelectArea('TRAB')
		DbSeek('028')
		@nLin,a_2pos[06] PSAY TransForm(TRAB->TRB_TOT, "@RE 99,999,999.99")
		a_totais[04] += TRAB->TRB_TOT
		n_result	 := CTT->CTT_XVLR- TRAB->TRB_TOT
		n_salgast    := n_valcust - TRAB->TRB_TOT

		n_prvxreal	 := n_salgast
		n_salgast    := Iif(n_salgast < 0, 0, n_salgast)
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

//LValidPerg( aRegs )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN011a  ºAutor  ³Alexandre Sousa     º Data ³  10/18/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o arquivo temporario para impressao do relatorio.      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFIN011a(oObj, c_Obra, c_anoref, l_competencia,c_periodo)

	Local c_query   := ''
	Local c_EOL		:= chr(13)+chr(10)

	Local a_separar := {}
	Local n_totCRA  := 0
	Local n_totDA	:= 0
	Local a_fatdir	:= {}
	Local nTotPrvRec := 0
	Local nTotPrvDep := 0


	Private cNomeArq

//DEFAULT c_periodo := "A"

	l_competencia := Iif(l_competencia = nil, .F., l_competencia)

//Definindo o periodo do processamento
	Do Case
	Case c_periodo = "A"  //periodo anual JAN/DEZ
		dPerIni := Ctod("01/01/"+c_anoref)
		dPerFin := Ctod("31/12/"+c_anoref)
		cMesIni := "01"
	Case c_periodo = "9x3" //periodo 9 x 3, 9 meses para tras e 3 para frente

		nDescAno := 0
		nMesIni := Month(dDataBase)-8
		If nMesIni <= 0
			nDescAno := 1  //descrescimo no ano
			nMesIni := 11 - nMesIni
		EndIf
		cMesIni := StrZero(nMesIni)
		cAnoIni := Str(Val(c_AnoRef)+ nDescAno,4)

		nAcrsAno := 0
		nMesFin := Month(dDataBase)+3
		If nMesFin >= 12
			nAcrsAno := 1
			nMesFin := nMesFin - 12
		EndIf
		cMesFin := StrZero(nMesFin)
		cAnoFin := Str(Val(c_AnoRef)+ nAcrsAno,4)

		dPerIni := Ctod("01/"+cMesIni+"/"+cAnoIni)
		dPerFin := Ctod("01/"+cMesFin+"/"+cAnoFin)-1
		cMesIni := StrZero(Month(dDataBase)-8,2)
	EndCase

//oObj:SetRegua1(13) lh 04032016
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o arquivo de trabalho temporario                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aStruct := {}
	AAdd( aStruct, { "TRB_GRPO", "C", 03, 0 } )
	AAdd( aStruct, { "TRB_NAT" , "C", 10, 0 } )
	AAdd( aStruct, { "TRB_DESC", "C", 40, 0 } )
	AAdd( aStruct, { "TRB_ANT" , "N", 14, 2 } )
	For n_x := 1 to 12
		//oObj:IncRegua1("Criando arquivo de trabalho")       lh 04032016
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
//oObj:IncRegua1("Criando indice de arquivo de trabalho") lh04032016
	index on TRB_GRPO+TRB_NAT to (cArqTrab)
	TRAB->(DbSetOrder(1))
	dbSelectArea("TRAB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query para buscar informaceos do contas a pagar                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	c_query := "select E2_XCC, E2_NATUREZ, E2_VALOR, E2_VENCREA, E2_SALDO, "
	c_query += "E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_DECRESC, E2_EMISSAO, IsNull(EZ_PERC,1) AS EZ_PERC, IsNull(EV_PERC,1) AS EV_PERC "
	c_query += "from (" + c_EOL
	c_query += "select E2_BAIXA, E2_VALOR as VALORI, E2_SALDO, E2_VENCREA, isnull(EV_NATUREZ, E2_NATUREZ) as E2_NATUREZ, isnull(EZ_CCUSTO, E2_XCC) as E2_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E2_VALOR)) as E2_VALOR, " + c_EOL
	c_query += "E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_DECRESC, E2_EMISSAO, IsNull(EZ_PERC,1) AS EZ_PERC, IsNull(EV_PERC,1) AS EV_PERC  "
	c_query += "from SE2010 " + c_EOL
	c_query += "left join SEV010" + c_EOL
	c_query += "     on EV_FILIAL   = E2_FILIAL" + c_EOL
	c_query += "        and       EV_PREFIXO  = E2_PREFIXO" + c_EOL
	c_query += "        and       EV_NUM      = E2_NUM" + c_EOL
	c_query += "        and       EV_PARCELA  = E2_PARCELA" + c_EOL
	c_query += "        and       EV_TIPO     = E2_TIPO" + c_EOL
	c_query += "        and       EV_CLIFOR   = E2_FORNECE" + c_EOL
	c_query += "        and       EV_LOJA     = E2_LOJA" + c_EOL
	c_query += "        and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "left join SEZ010" + c_EOL
	c_query += "     on EZ_FILIAL   = EV_FILIAL" + c_EOL
	c_query += "        and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
	c_query += "        and       EZ_NUM      = EV_NUM" + c_EOL
	c_query += "        and       EZ_PARCELA  = EV_PARCELA" + c_EOL
	c_query += "        and       EZ_TIPO     = EV_TIPO" + c_EOL
	c_query += "        and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
	c_query += "        and       EZ_LOJA     = EV_LOJA" + c_EOL
	c_query += "        and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
	c_query += "        and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "where     SE2010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "and       E2_SALDO  = 0	" + c_EOL
	c_query += "and       E2_DTFATUR = '' " + c_EOL        //somente titulos nao faturados [Mauro Nagata, Actual Trend, 10/01/2011]
//c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
//substituida a linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 30/11/2011]
//inicio bloco [Mauro Nagata, Actual Trend, 30/11/2011]
	If l_competencia
		c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
	Else
		//c_query += "and       SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160209]
		c_query += "         AND SUBSTRING(E2_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	EndIf
//fim bloco [Mauro Nagata, Actual Trend, 30/11/2011]

	c_query += ") A       where E2_XCC = '"+c_Obra+"'" + c_EOL
//c_query += "group by  E2_XCC, E2_NATUREZ, E2_VENCREA " + c_EOL
//c_query += "AND SUBSTRING(E2_NATUREZ,1,4)='2202'"    //[Mauro Nagata, Actual Trend, 20160208]

	c_query += "union all " + c_EOL

	c_query += "SELECT E2_XCC, E2_NATUREZ, E2_VALOR, E2_VENCREA, E2_SALDO, "
	c_query += "E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_DECRESC, E2_EMISSAO, IsNull(EZ_PERC,1) AS EZ_PERC, IsNull(EV_PERC,1) AS EV_PERC  "
	c_query += "FROM ( " + c_EOL
	c_query += "       SELECT E2_BAIXA, E2_VALOR as VALORI, isnull(EZ_VALOR,isnull(EV_VALOR, E2_SALDO)) as E2_SALDO, E2_VENCREA, isnull(EV_NATUREZ, E2_NATUREZ) as E2_NATUREZ, isnull(EZ_CCUSTO, E2_XCC) as E2_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E2_VALOR)) as E2_VALOR, " + c_EOL
	c_query += "              E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_DECRESC, E2_EMISSAO, IsNull(EZ_PERC,1) AS EZ_PERC, IsNull(EV_PERC,1) AS EV_PERC  "
	c_query += "       FROM SE2010 " + c_EOL
	c_query += "       LEFT JOIN SEV010" + c_EOL
	c_query += "            ON EV_FILIAL   = E2_FILIAL" + c_EOL
	c_query += "               AND EV_PREFIXO  = E2_PREFIXO" + c_EOL
	c_query += "               AND EV_NUM      = E2_NUM" + c_EOL
	c_query += "               AND EV_PARCELA  = E2_PARCELA" + c_EOL
	c_query += "               AND EV_TIPO     = E2_TIPO" + c_EOL
	c_query += "               AND EV_CLIFOR   = E2_FORNECE" + c_EOL
	c_query += "               AND EV_LOJA     = E2_LOJA" + c_EOL
	c_query += "               AND SEV010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "       LEFT JOIN SEZ010" + c_EOL
	c_query += "            ON EZ_FILIAL   = EV_FILIAL" + c_EOL
	c_query += "               AND EZ_PREFIXO  = EV_PREFIXO" + c_EOL
	c_query += "               AND EZ_NUM      = EV_NUM" + c_EOL
	c_query += "               AND EZ_PARCELA  = EV_PARCELA" + c_EOL
	c_query += "               AND EZ_TIPO     = EV_TIPO" + c_EOL
	c_query += "               AND EZ_CLIFOR   = EV_CLIFOR" + c_EOL
	c_query += "               AND EZ_LOJA     = EV_LOJA" + c_EOL
	c_query += "               AND EZ_NATUREZ  = EV_NATUREZ" + c_EOL
	c_query += "               AND SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "       WHERE SE2010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "             AND E2_SALDO  <> 0	" + c_EOL
	c_query += "             AND E2_DTFATUR = '' " + c_EOL
	If l_competencia
		c_query += "         AND SUBSTRING(E2_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	Else
		//c_query += "         AND SUBSTRING(E2_VENCREA,1,4) <= '"+c_anoref+"'" + c_EOL
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160209]
		c_query += "         AND SUBSTRING(E2_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	EndIf

	c_query += ") A       WHERE E2_XCC = '"+c_Obra+"'" + c_EOL
//c_query += "AND SUBSTRING(E2_NATUREZ,1,4)='2202'"    //[Mauro Nagata, Actual Trend, 20160208]
	c_query += "ORDER BY E2_NATUREZ, E2_VENCREA " + c_EOL

	memoWrite('RFIN011a.sql', c_query)

//oObj:IncRegua1("Sel. Registros CP")                    lh 04032016
//oObj:IncRegua1("Sel. Registros CP")                     lh 04032016
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
//oObj:IncRegua1("Sel. Registros CR")
	c_query := ''
	c_query += "SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VALOR, E1_VENCREA, " + c_EOL
	c_query += "       Round(sum(E1_SALDO),2) as E1_SALDO, E1_EMISSAO, E1_BAIXA, E1_FILIAL, E1_DECRESC " + c_EOL
	c_query += "FROM (" + c_EOL
	c_query += "      SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_BAIXA, E1_EMISSAO, E1_VALOR as VALORI, " + c_EOL
	c_query += "             Round((E1_SALDO*isnull(EZ_PERC,1)*isnull(EV_PERC,1)),2) as E1_SALDO, E1_VENCREA, isnull(EV_NATUREZ, E1_NATUREZ) as E1_NATUREZ, EV_PERC, " + c_EOL
	c_query += "             E1_FILIAL, isnull(EZ_CCUSTO, E1_XCC) as E1_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E1_VALOR)) as E1_VALOR, EZ_PERC, " + c_EOL
	c_query += "             E1_DECRESC " + c_EOL
	c_query += "      FROM SE1010 " + c_EOL
	c_query += "      LEFT JOIN SEV010" + c_EOL
	c_query += "           ON EV_FILIAL   = E1_FILIAL" + c_EOL
	c_query += "              and       EV_PREFIXO  = E1_PREFIXO" + c_EOL
	c_query += "              and       EV_NUM      = E1_NUM" + c_EOL
	c_query += "              and       EV_PARCELA  = E1_PARCELA" + c_EOL
	c_query += "              and       EV_TIPO     = E1_TIPO" + c_EOL
	c_query += "              and       EV_CLIFOR   = E1_CLIENTE" + c_EOL
	c_query += "              and       EV_LOJA     = E1_LOJA" + c_EOL
	c_query += "              and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "      LEFT JOIN SEZ010" + c_EOL
	c_query += "           ON EZ_FILIAL   = EV_FILIAL" + c_EOL
	c_query += "              and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
	c_query += "              and       EZ_NUM      = EV_NUM" + c_EOL
	c_query += "              and       EZ_PARCELA  = EV_PARCELA" + c_EOL
	c_query += "              and       EZ_TIPO     = EV_TIPO" + c_EOL
	c_query += "              and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
	c_query += "              and       EZ_LOJA     = EV_LOJA" + c_EOL
	c_query += "              and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
	c_query += "              and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
//c_query += "      LEFT JOIN SE5010  " + c_EOL
//c_query += "           ON SUBSTRING(E5_DOCUMEN,1,17) = E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO " + c_EOL
//c_query += "              AND SE5010.D_E_L_E_T_<>'*' " + c_EOL
	c_query += "      WHERE SE1010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "              and       E1_SALDO  = 0	" + c_EOL
//c_query += "              and       E1_TIPO  <> 'RA'	" + c_EOL
	If l_competencia
		c_query += "          and       SUBSTRING(E1_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	EndIf
	c_query += "      ) A " + c_EOL
	c_query += "WHERE E1_XCC = '"+c_Obra+"'" + c_EOL
	c_query += "GROUP BY E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VENCREA, E1_EMISSAO, E1_BAIXA, E1_VALOR, E1_DECRESC " + c_EOL

	c_query += "UNION ALL " + c_EOL

	c_query += "SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VALOR, E1_VENCREA, " + c_EOL
	c_query += "       Round(SUM(E1_SALDO),2) as E1_SALDO, E1_EMISSAO, E1_BAIXA, E1_FILIAL, E1_DECRESC " + c_EOL
	c_query += "FROM (" + c_EOL
	c_query += "      SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_BAIXA, E1_VALOR as VALORI, " + c_EOL
	c_query += "             Round((E1_SALDO*isnull(EZ_PERC,1)*isnull(EV_PERC,1)),2) as E1_SALDO, E1_VENCREA, isnull(EV_NATUREZ, E1_NATUREZ) as E1_NATUREZ, EV_PERC, E1_FILIAL, " + c_EOL
	c_query += "             isnull(EZ_CCUSTO, E1_XCC) as E1_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E1_VALOR)) as E1_VALOR, EZ_PERC, " + c_EOL
	c_query += "             E1_DECRESC " + c_EOL
	c_query += "      FROM SE1010 " + c_EOL
	c_query += "      LEFT JOIN SEV010" + c_EOL
	c_query += "           ON EV_FILIAL   = E1_FILIAL" + c_EOL
	c_query += "              and       EV_PREFIXO  = E1_PREFIXO" + c_EOL
	c_query += "              and       EV_NUM      = E1_NUM" + c_EOL
	c_query += "              and       EV_PARCELA  = E1_PARCELA" + c_EOL
	c_query += "              and       EV_TIPO     = E1_TIPO" + c_EOL
	c_query += "              and       EV_CLIFOR   = E1_CLIENTE" + c_EOL
	c_query += "              and       EV_LOJA     = E1_LOJA" + c_EOL
	c_query += "              and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
	c_query += "      LEFT JOIN SEZ010" + c_EOL
	c_query += "           ON EZ_FILIAL   = EV_FILIAL" + c_EOL
	c_query += "              and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
	c_query += "              and       EZ_NUM      = EV_NUM" + c_EOL
	c_query += "              and       EZ_PARCELA  = EV_PARCELA" + c_EOL
	c_query += "              and       EZ_TIPO     = EV_TIPO" + c_EOL
	c_query += "              and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
	c_query += "              and       EZ_LOJA     = EV_LOJA" + c_EOL
	c_query += "              and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
	c_query += "              and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
//c_query += "      LEFT JOIN SE5010  " + c_EOL
//c_query += "           ON SUBSTRING(E5_DOCUMEN,1,17) = E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO " + c_EOL   
//c_query += "              AND SE5010.D_E_L_E_T_<>'*' " + c_EOL
	c_query += "      WHERE SE1010.D_E_L_E_T_ <> '*'" + c_EOL
//c_query += "            AND E1_TIPO  <> 'RA'	" + c_EOL
	c_query += "            AND E1_SALDO  <> 0	" + c_EOL
	If l_competencia
		c_query += "        AND SUBSTRING(E1_EMISSAO,1,4) <= '"+c_anoref+"'" + c_EOL
	EndIf
	c_query += "     ) A" + c_EOL
	c_query += "WHERE E1_XCC = '"+c_Obra+"'" + c_EOL
	c_query += "GROUP BY  E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VENCREA, E1_EMISSAO, E1_BAIXA, E1_VALOR, E1_DECRESC " + c_EOL
	c_query += "ORDER BY  E1_NATUREZ, E1_VENCREA " + c_EOL

	memoWrite('RFIN011b.sql', c_query)

	If Select("QRX") > 0
		DbSelectArea("QRX")
		DbCloseArea()
	EndIf

	TcQuery c_Query New Alias "QRX"

/*
n_tregcr := 0
QRX->(DbGotop())
While QRX->(!EOF())
	n_tregcr++
	QRX->(DbSkip())
EndDo
*/
	n_tregcr := 0
	DbEVal({|| n_tregcr++})

//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes do CONTAS A RECEBER                                              ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Proc. Registros CR")
//oObj:SetRegua2(n_tregcr)
	c_grprec := '010' //Grupo de Receitas
	QRX->(DbGoTop())

	nVlrImpAA	:= 0
	nVlrImp		:= 0  //valores dos impostos
	a_rdados	:= {}

	Do While QRX->(!EOF())
		lIp			:= .F.
		c_vencrea	:= QRX->E1_VENCREA
		//oObj:IncRegua2("Processando CRec")

		c_natureza := Substr(QRX->E1_NATUREZ,1,6)       //
		DbSelectArea('SED')
		DbSetOrder(1) //ED_FILIAL, ED_CODIGO, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial('SED')+c_natureza)
			If !Empty(SED->ED_NATENTR)
				c_natureza := If(SED->ED_NATENTR!=SED->ED_CODIGO,Substr(SED->ED_NATENTR,1,4),SED->ED_NATENTR)
			EndIf
		EndIf

		DbSelectArea("QRX")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para situacoes de competencia.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l_competencia
			If TRAB->(DbSeek(c_grprec+c_natureza))
				RecLock('TRAB', .F.)
			Else
				DbSelectArea("TRAB")
				RecLock('TRAB', .T.)
				TRAB->TRB_GRPO	:= c_grprec
				TRAB->TRB_NAT	:= c_natureza
				TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,18)+" Orc."+Transform(cVlrQRF,"@RE 999,999.9")
				DbSelectArea("QRX")
			EndIf
			If MV_PAR02 = SubStr(QRX->E1_EMISSAO, 1,4)
				If !(ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF')
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

		cTipoAux := QRX->E1_TIPO

		If TRAB->(DbSeek(c_grprec+c_natureza))
			RecLock('TRAB', .F.)
		Else
			RecLock('TRAB', .T.)
			TRAB->TRB_GRPO	:= c_grprec
			TRAB->TRB_NAT	:= c_natureza
			TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
		EndIf

		Do Case
		Case QRX->E1_TIPO = "RA"
			Do Case
			Case QRX->E1_SALDO > 0
				Do Case
				Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_EMISSAO,1,6)
					TRAB->TRB_ANT += QRX->E1_SALDO
				Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_EMISSAO,1,6)
					TRAB->TRB_REAL += QRX->E1_SALDO
				Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_EMISSAO,1,6)
					//TRAB->&("TRB_M"+SubStr(QRX->E1_EMISSAO, 5,2)) += QRX->E1_SALDO
					//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 28/11/2012]
					If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_EMISSAO,1,4)
						TRAB->&("TRB_M"+SubStr(QRX->E1_EMISSAO, 5,2)) += QRX->E1_SALDO
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 28/11/2012]
				EndCase
			Case QRX->E1_SALDO = 0
				Do Case
				Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_EMISSAO,1,6)
					TRAB->TRB_ANT += QRX->E1_VALOR
				Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_EMISSAO,1,6)
					TRAB->TRB_REAL += QRX->E1_VALOR
				Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_EMISSAO,1,6)
					//TRAB->&("TRB_M"+SubStr(QRX->E1_EMISSAO, 5,2)) += QRX->E1_VALOR
					//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 28/11/2012]
					If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_EMISSAO,1,4)
						TRAB->&("TRB_M"+SubStr(QRX->E1_EMISSAO, 5,2)) += QRX->E1_VALOR
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 28/11/2012]
				EndCase
			EndCase
		Case ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF'    //qdo for um titulo de impostos
			dDtEmis := Stod(QRX->E1_EMISSAO)
			nMesImp := Month(dDtEmis)+1
			cMesImp := StrZero(If(nMesImp > 12,1,nMesImp),2)
			cAnoImp := StrZero(If(cMesImp ="01",Year(dDtEmis)+1,Year(dDtEmis)),4)
			cDtImp  := Dtos(Ctod("01/"+cMesImp+"/"+cAnoImp))
			cAnoAnt := Str(Val(c_AnoRef)-1,4)
			Do Case
			Case QRX->E1_SALDO = QRX->E1_VALOR .AND. QRX->E1_SALDO > 0
				nVlrImp += QRX->E1_SALDO  //valor dos impostos
				Do Case
					//Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_EMISSAO,1,6)
				Case Substr(Dtos(dPerIni),1,6) > Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= c_anoref+"02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
					TRAB->TRB_ANT -= QRX->E1_SALDO
					//Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_EMISSAO,1,6)
				Case Substr(Dtos(dDataBase),1,6) = Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= c_anoref+"02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
					TRAB->TRB_REAL -= QRX->E1_SALDO
					//Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_EMISSAO,1,6)
				Case Substr(Dtos(dDataBase),1,6) != Substr(cDtImp,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= "02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
					//TRAB->&("TRB_M"+SubStr(cDtImp, 5,2)) -= QRX->E1_SALDO
					//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 28/11/2012]
					If Substr(Dtos(dPerIni),1,4) = Substr(cDtImp,1,4)
						TRAB->&("TRB_M"+SubStr(cDtImp, 5,2)) -= QRX->E1_SALDO
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 28/11/2012]
				EndCase
			Case QRX->E1_SALDO = 0
				nVlrImp += QRX->E1_VALOR  //valor dos impostos
				Do Case
					//Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_EMISSAO,1,6)
				Case Substr(Dtos(dPerIni),1,6) > Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= c_anoref+"02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
					TRAB->TRB_ANT -= QRX->E1_VALOR
					//Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_EMISSAO,1,6)
				Case Substr(Dtos(dDataBase),1,6) = Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= c_anoref+"02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
					TRAB->TRB_REAL -= QRX->E1_VALOR
					//Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_EMISSAO,1,6)
				Case Substr(Dtos(dDataBase),1,6) != Substr(cDtImp,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cDtImp,1,6) .And. (((SubStr(cDtImp,1,6) >= "02" .Or. Substr(cDtImp,1,6) <= c_anoref+"12")) .Or. (Substr(cDtImp,1,6) = cAnoAnt+"01"))
					//TRAB->&("TRB_M"+SubStr(cDtImp, 5,2)) -= QRX->E1_VALOR
					//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 28/11/2012]
					If Substr(Dtos(dPerIni),1,4) = Substr(cDtImp,1,4)
						TRAB->&("TRB_M"+SubStr(cDtImp, 5,2)) -= QRX->E1_VALOR
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 28/11/2012]
				EndCase

			EndCase
		Case !(ALLTRIM(c_natureza) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF')  //qdo nao for um titulo de impostos
			Do Case
			Case QRX->E1_SALDO = QRX->E1_VALOR .AND. QRX->E1_SALDO > 0   //titulo com valor totalmente em aberto
				Do Case
					//Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_VENCREA,1,6)
				Case Substr(Dtos(dDataBase),1,6) > Substr(QRX->E1_VENCREA,1,6)
					TRAB->TRB_VENC += QRX->E1_VALOR - QRX->E1_DECRESC
				Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_VENCREA,1,6)
					If Dtos(dDataBase) <= QRX->E1_VENCREA
						TRAB->TRB_ABER += QRX->E1_VALOR  - QRX->E1_DECRESC
					Else
						TRAB->TRB_VENC += QRX->E1_VALOR  - QRX->E1_DECRESC
					EndIf
				Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_VENCREA,1,4)
			                  /*
			                  If Dtos(dDataBase) <= QRX->E1_VENCREA
		                         TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += QRX->E1_VALOR - QRX->E1_DECRESC 						
		                     Else
		                        TRAB->TRB_VENC += QRX->E1_VALOR - QRX->E1_DECRESC
		                     EndIf                                                
		                     */                                                                                  
					//substituida bloco acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 28/11/2012]
					If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_VENCREA,1,4)
						If Dtos(dDataBase) <= QRX->E1_VENCREA
							TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += QRX->E1_VALOR - QRX->E1_DECRESC
						Else
							TRAB->TRB_VENC += QRX->E1_VALOR - QRX->E1_DECRESC
						EndIf
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 28/11/2012]
				EndCase
			Case QRX->E1_SALDO < QRX->E1_VALOR .And. QRX->E1_SALDO > 0  //titulo com valor parcialmente em aberto
				Do Case
				Case Substr(Dtos(dDataBase),1,6) > Substr(QRX->E1_VENCREA,1,6)
					TRAB->TRB_VENC += QRX->E1_SALDO - QRX->E1_DECRESC
				Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_VENCREA,1,6)
					TRAB->TRB_ABER += QRX->E1_SALDO - QRX->E1_DECRESC  //MES ATUAL EM ABERTO
				Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_VENCREA,1,6)
					//TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += QRX->E1_SALDO - QRX->E1_DECRESC
					//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 28/11/2012]
					If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_VENCREA,1,4)  //dentro do ano de competencia
						TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += QRX->E1_SALDO - QRX->E1_DECRESC
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 28/11/2012]
				EndCase
			Case QRX->E1_SALDO = 0
				DbSelectArea("SE1")
				nAbatim	 := SomaAbat(QRX->E1_PREFIXO,QRX->E1_NUM,QRX->E1_PARCELA,"R",1,,QRX->E1_CLIENTE,QRX->E1_LOJA,QRX->E1_FILIAL)  //impostos

				DbSelectArea("QRX")
				Do Case
				Case Substr(Dtos(dPerIni),1,6) > Substr(QRX->E1_VENCREA,1,6)
					TRAB->TRB_ANT += nAbatim  - QRX->E1_DECRESC//QRX->IMPOSTOS
				Case Substr(Dtos(dDataBase),1,6) = Substr(QRX->E1_VENCREA,1,6)
					TRAB->TRB_REAL += nAbatim  - QRX->E1_DECRESC// QRX->IMPOSTOS  //MES ATUAL EM ABERTO
				Case Substr(Dtos(dDataBase),1,6) != Substr(QRX->E1_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRX->E1_VENCREA,1,6)
					//TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += nAbatim - QRX->E1_DECRESC // QRX->IMPOSTOS
					//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 28/11/2012]
					If Substr(Dtos(dPerIni),1,4) = Substr(QRX->E1_VENCREA,1,4)  //dentro do ano de competencia
						TRAB->&("TRB_M"+SubStr(QRX->E1_VENCREA, 5,2)) += nAbatim - QRX->E1_DECRESC // QRX->IMPOSTOS
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 28/11/2012]
				EndCase


			EndCase

			DbSelectArea("SE1")
			DbSeek(QRX->E1_FILIAL+QRX->E1_PREFIXO+QRX->E1_NUM+QRX->E1_PARCELA+QRX->E1_TIPO)
			U_FC040()

			cRetEmis := Ctod("")


			DbSelectArea("cNomeArq")
			DbGoTop()
			Do While !Eof()

				cRetEmis := Dtos(cNomeArq->DATAX)

				nSinal := If(cNomeArq->OK = 1.Or.(cNomeArq->OK = 2 .And.cNomeArq->MOTIVO = "NOR".And.cNomeArq->TIPODOC="VL"),1,If(cNomeArq->OK = 2,-1,0))

				If cNomeArq->MOTIVO = "CMP"
					aAreaCMP := GetArea()
					cChave := SubStr(cNomeArq->DOCUMENTO,1,3) // Prefixo
					cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO, 4,6), substr(cNomeArq->DOCUMENTO, 5,9))//Numero
					cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO,10,1), substr(cNomeArq->DOCUMENTO,15,2))//Parcela
					cChave += 'RA'

					DbSelectArea('SE1')
					DbSetOrder(1) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
					If DbSeek(cNomeArq->Filial+cChave)
						If SE1->E1_SALDO = 0
							DbSelectArea("cNomeArq")
							DbSkip()
							Loop
						EndIf
						cRetEmis := Dtos(SE1->E1_EMISSAO)
					EndIf
					c_natureza := Substr(SE1->E1_NATUREZ,1,6) //
					If TRAB->(DbSeek(c_grprec+c_natureza))
						RecLock('TRAB', .F.)
					Else
						RecLock('TRAB', .T.)
						TRAB->TRB_GRPO	:= c_grprec
						TRAB->TRB_NAT	:= c_natureza
						TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
					EndIf
					RestArea(aAreaCMP)
				Else
					c_natureza := Substr(cNomeArq->NATUREZ,1,6)   //
					If TRAB->(DbSeek(c_grprec+c_natureza))
						RecLock('TRAB', .F.)
					Else
						RecLock('TRAB', .T.)
						TRAB->TRB_GRPO	:= c_grprec
						TRAB->TRB_NAT	:= c_natureza
						TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
					EndIf

				EndIf

				nPercRat := 1
				DbSelectArea("SEV")
				DbSetOrder(1)
				If DbSeek(xFilial("SEV")+QRX->E1_PREFIXO+QRX->E1_NUM+QRX->E1_PARCELA+QRX->E1_TIPO+QRX->E1_CLIENTE+QRX->E1_LOJA+c_natureza)
					If SEV->EV_RATEICC = "1"
						DbSelectArea("SEZ")
						If DbSeek(xFilial("SEZ")+QRX->E1_PREFIXO+QRX->E1_NUM+QRX->E1_PARCELA+QRX->E1_TIPO+QRX->E1_CLIENTE+QRX->E1_LOJA+SEV->EV_NATUREZ+c_obra)
							nPercRat := SEV->EV_PERC*SEZ->EZ_PERC
						Else
							nPercRat := 0
						EndIf
					Else
						nPercRat := SEV->EV_PERC
					EndIf
				EndIf

				nVlrRec := cNomeArq->VALORRECEB
				Do Case
				Case cNomeArq->TIPODOC $ "MTüM2"
					nVlrRec := cNomeArq->MULTA*(-1)
				Case cNomeArq->TIPODOC$"CMüC2|VM|CX"
					nVlrRec := cNomeArq->CORRECAO*(-1)
				Case cNomeArq->TIPODOC $ "JRüJ2"
					nVlrRec := cNomeArq->JUROS*(-1)
				Case cNomeArq->TIPODOC $ "DCüD2"
					nVlrRec := cNomeArq->DESCONTOS
				EndCase

				Do Case
				Case Substr(Dtos(dPerIni),1,6) > Substr(cRetEmis,1,6)
					TRAB->TRB_ANT += Round(nVlrRec * nSinal*nPercRat,2)
				Case Substr(Dtos(dDataBase),1,6) = Substr(cRetEmis,1,6)
					TRAB->TRB_REAL += Round(nVlrRec * nSinal*nPercRat,2) //MES ATUAL EM ABERTO
				Case Substr(Dtos(dDataBase),1,6) != Substr(cRetEmis,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cRetEmis,1,6)
					//TRAB->&("TRB_M"+SubStr(cRetEmis, 5,2)) += Round((nVlrRec * nSinal)*nPercRat,2)
					//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 28/11/2012]
					If Substr(Dtos(dPerIni),1,4) = Substr(cRetEmis,1,4)   //dentro do ano de competencia
						TRAB->&("TRB_M"+SubStr(cRetEmis, 5,2)) += Round((nVlrRec * nSinal)*nPercRat,2)
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 28/11/2012]
				EndCase

				DbSelectArea("cNomeArq")
				DbSkip()
			EndDo
			If Select("cNomeArq") > 0
				DbSelectArea("cNomeArq")
				Use
				Ferase(cNomearq+GetDBExtension())
				Ferase(cNomeArq+OrdBagExt())
			EndIf
		EndCase

		TRAB->(MsUnLock())
		QRX->(DbSkip())
	EndDo

	If MV_PAR10 == 1

		oExcel:AddRow("Totais","Resumo",{" "," "," "," "," "," "})
		oExcel:AddRow("Totais","Resumo",{" "," "," "," "," "," "})
		oExcel:AddRow("Totais","Resumo",{" ","Tot Cts a Rec Mes(a):","Fatur Direto(b):","Tot Acumul Cts Rec(a+b=c):","Tot Desp Acumul(d+e-f=g):","Saldo Flx Cx Acumul(c-g):"})

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebra de linha                                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	DbSeek('010')  //receitas
	a_Totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	n_TotalN := 0
	Do While TRAB->(!EOF()) .And. TRAB->TRB_GRPO = '010'
		n_TotalN := 0
		For n_x := 1 to 12
			a_Totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
			n_TotalN      += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		a_Totais[13] += TRAB->TRB_ANT
		a_Totais[14] += TRAB->TRB_REAL
		a_Totais[15] += TRAB->TRB_ABER
		a_Totais[16] += TRAB->TRB_VENC

		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + TRAB->TRB_ABER + n_TotalN
		MsUnLock()

		a_Totais[17] += TRAB->TRB_TOT

		If !(AllTrim(TRAB->TRB_NAT) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF')
			nTotPrvRec += TRAB->TRB_TOT
		EndIf
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

	If MV_PAR10 == 1
	//	oExcel:AddRow("Totais","Resumo",{"Total Cts a Receber Mês (a):",Round(a_totais[1],0),Round(a_totais[2],0),Round(a_totais[3],0),Round(a_totais[4],0),Round(a_totais[5],0),Round(a_totais[6],0),;
	//		Round(a_totais[7],0),Round(a_totais[8],0),Round(a_totais[9],0),Round(a_totais[10],0),Round(a_totais[11],0),Round(a_totais[12],0)})

			aTotA[1]  := Round(a_totais[1],0)
			aTotA[2]  := Round(a_totais[2],0)
			aTotA[3]  := Round(a_totais[3],0)
			aTotA[4]  := Round(a_totais[4],0)
			aTotA[5]  := Round(a_totais[5],0)
			aTotA[6]  := Round(a_totais[6],0)
			aTotA[7]  := Round(a_totais[7],0)
			aTotA[8]  := Round(a_totais[8],0)
			aTotA[9]  := Round(a_totais[9],0)
			aTotA[10] := Round(a_totais[10],0)
			aTotA[11] := Round(a_totais[11],0)
			aTotA[12] := Round(a_totais[12],0)


	EndIf

	TRAB->TRB_ANT	:= a_totais[13]
	TRAB->TRB_REAL	:= a_totais[14]
	TRAB->TRB_ABER	:= a_totais[15]
	TRAB->TRB_VENC	:= a_totais[16]
	TRAB->TRB_TOT	:= a_totais[17]
	n_Atrasados     := TRAB->TRB_VENC
	nTotPrvRec      += n_Atrasados

	TRAB->(MsUnLock())


/*
nVlrAbe := (TRB->QTPED-TRB->QENTR)*TRB->PRPED + Round((((TRB->QTPED-C7_QUJE)/TRB->QTPED)*TRB->VALIPI),2)

TRB->QTPED    := (cAliasSC7)->C7_QUANT
TRB->PRODUTO  := (cAliasSC7)->C7_PRODUTO
TRB->OBRA     := (cAliasSC7)->C7_XCCFTD
TRB->TOTPED   := (cAliasSC7)->C7_TOTAL
TRB->QENTR    := (cAliasSC7)->C7_QUJE
//TRB->QENTR    := (cAliasSC7)->D1_QUANT
TRB->RESIDUO  := (cAliasSC7)->C7_RESIDUO
TRB->NECESS   := (cAliasSC7)->C7_DATPRF
TRB->EMISDOC  := (cAliasSC7)->D1_EMISSAO
TRB->DOC      := (cAliasSC7)->D1_DOC       //documento de entrada
TRB->SERIE    := (cAliasSC7)->D1_SERIE     //serie do documento de entrada
TRB->QTDOC    := (cAliasSC7)->D1_QUANT
//TRB->VALIPI   := (cAliasSC7)->D1_VALIPI
//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 15/07/2011]
TRB->VALIPI   := (cAliasSC7)->C7_VALIPI * ((cAliasSC7)->D1_QUANT/(cAliasSC7)->C7_QUANT)
TRB->DESCPRD  := (cAliasSC7)->B1_DESC
TRB->TOTDOC   := (cAliasSC7)->D1_TOTAL
TRB->QTDOC    := (cAliasSC7)->D1_QUANT
TRB->PRPED    := (cAliasSC7)->C7_PRECO
//Incluido Bloco abaixo para atribuir valor aos campos da TRB. [Bruno Parreira, Actual Trend, 25/05/2011]
TRB->DESCOBR  := (cAliasSC7)->CTT_DESC01
TRB->LIMFATDIR:= (cAliasSC7)->CTT_XFATD
TRB->FORNEC   := (cAliasSC7)->C7_FORNECE
*/


	Aadd(a_separar, {'012','-'})
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes do faturamento direto                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Faturamento Direto")
	c_grprec := '015' //Grupo de Receitas - Sub-Grupo FATURAMENTO DIRETO

//c_query := " SELECT sum(D1_TOTAL+(C7_VALIPI*(D1_QUANT/C7_QUANT))+C7_VALFRE+C7_DESPESA+C7_SEGURO-C7_VLDESC) as VALOR, C7_DATPRF, D1_TES"
	c_query := " SELECT Sum(D1_TOTAL+(C7_VALIPI*(D1_QUANT/C7_QUANT))+D1_VALFRE+D1_DESPESA+D1_SEGURO-D1_VALDESC) as VALOR, C7_DATPRF, D1_TES,"
//c_query += "        Sum((C7_QUANT-C7_QUJE)*C7_PRECO + (((C7_QUANT-C7_QUJE)/C7_QUANT)*D1_VALIPI * (D1_QUANT/C7_QUANT))) as VLRAB "
	c_query += "        0 as VLRAB "
	c_query += " FROM SC7010 C7 "
//c_query += "      LEFT OUTER JOIN SD1010 D1 "
//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160202]
	c_query += "      INNER JOIN SD1010 D1 "
	c_query += "           ON  D1.D_E_L_E_T_='' "
	c_query += "           AND D1_PEDIDO = C7_NUM "
	c_query += "           AND D1_ITEMPC = C7_ITEM "
	c_query += "           AND D1_COD    = C7_PRODUTO "
	c_query += "           AND D1_TES    <> '' "
	c_query += "      INNER JOIN SB1010 B1 "
	c_query += "            ON  B1.D_E_L_E_T_='' "
	c_query += "            AND B1.B1_FILIAL  ='"+xFilial("SB1")+"' "
	c_query += "            AND B1_COD = C7_PRODUTO "
	c_query += "      INNER JOIN CTT010 CTT "
	c_query += "            ON  CTT.D_E_L_E_T_='' "
	c_query += "            AND CTT_XLFATD = 'S' "
	c_query += "            AND CTT_CUSTO = C7_XCCFTD "
	c_query += " WHERE C7_XCCFTD = '"+c_Obra+"'"
	c_query += "       AND       SUBSTRING(C7_DATPRF,1,4) <= '"+c_anoref+"'" + c_EOL
	c_query += "       AND C7_XCCFTD <> '' "
	c_query += "       AND C7_XFATD = 'S' "
	c_query += "       AND C7.D_E_L_E_T_ = '' "
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
			//ElseIf SubStr(QRX->C7_DATPRF, 5,2) = SubStr(DtoS(dDataBase), 5, 2) .And. Substr(QRX->C7_DATPRF,1,4) == c_anoref
			//substituindo a linha acima pela abaixo [Mauro Nagata, Actual Trend, 20150430]
		ElseIf SubStr(QRX->C7_DATPRF, 5,2) = SubStr(DtoS(dDataBase), 5, 2) .And. Substr(QRX->C7_DATPRF,1,4) == c_anoref .And. SubStr(DtoS(dDataBase), 1,4) == c_anoref
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
	If DbSeek('015',.t.)  //faturamento direto
		n_TotalN := 0
		For n_x := 1 to 12
			n_TotalN += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + TRAB->TRB_ABER  + n_TotalN
		nTotPrvRec += TRAB->TRB_TOT
		MsUnLock()
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebra de linha                                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	DbSeek('011',.t.)
	a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '015'
		For n_x := 1 to 12
			a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
			aTotB[n_x]    := Round(TRAB->&("TRB_M"+StrZero(n_x,2)),0)
		Next

		a_totais[13] += TRAB->TRB_ANT
		a_totais[14] += TRAB->TRB_REAL
		a_totais[15] += TRAB->TRB_ABER
		a_totais[16] += TRAB->TRB_VENC
		a_totais[17] += TRAB->TRB_TOT
		TRAB->(DbSkip())
	EndDo

	If MV_PAR10 == 1
	//	oExcel:AddRow("Totais","Resumo",{"Faturamento Direto (b):",Round(a_totais[1],0),Round(a_totais[2],0),Round(a_totais[3],0),Round(a_totais[4],0),Round(a_totais[5],0),Round(a_totais[6],0),;
	//		Round(a_totais[7],0),Round(a_totais[8],0),Round(a_totais[9],0),Round(a_totais[10],0),Round(a_totais[11],0),Round(a_totais[12],0)})

			/*
			aTotB[1]  := Round(a_totais[1],0)
			aTotB[2]  := Round(a_totais[2],0)
			aTotB[3]  := Round(a_totais[3],0)
			aTotB[4]  := Round(a_totais[4],0)
			aTotB[5]  := Round(a_totais[5],0)
			aTotB[6]  := Round(a_totais[6],0)
			aTotB[7]  := Round(a_totais[7],0)
			aTotB[8]  := Round(a_totais[8],0)
			aTotB[9]  := Round(a_totais[9],0)
			aTotB[10] := Round(a_totais[10],0)
			aTotB[11] := Round(a_totais[11],0)
			aTotB[12] := Round(a_totais[12],0)
			*/

	EndIf

//nTotPrvRec := a_Totais[17]  + a_Totais[16] + nVlrImp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totaliza a linha                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(a_separar, {'016','-'})
	c_GrpRec := '018' //Grupo de Receitas - subgrupo total GERAL de receitas
	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= "TOTAL CTAS A RECEBER ACUMULADO [a+b]=[c]"
	n_TotAcm 		:= a_Totais[13]   //anterior ao periodo atual
	TRAB->TRB_ANT	:= n_TotAcm
	For n_x := 1 To 12
		If n_x = val(Substr(Dtos(ddatabase),5,2)).And.Substr(Dtos(ddatabase),1,4) = MV_PAR03
			n_TotAcm 		+= a_Totais[14]   //realizado
			TRAB->TRB_REAL	:= n_TotAcm

			n_TotAcm 		+= a_Totais[15]  //aberto
			TRAB->TRB_ABER	:= n_TotAcm
		EndIf
		n_TotAcm += a_Totais[n_x]
		TRAB->&("TRB_M"+StrZero(n_x,2)) := n_TotAcm
	Next

	If MV_PAR10 == 1
		/*
		oExcel:AddRow("Totais","Resumo",{"Total Acumulado Cts Receber (a+b=c):",;
			Round(a_totais[1],0),;
			Round(a_totais[1]+a_totais[2],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8]+a_totais[9],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8]+a_totais[9]+a_totais[10],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8]+a_totais[9]+a_totais[10]+a_totais[11],0),;
			Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8]+a_totais[9]+a_totais[10]+a_totais[11]+a_totais[12],0);
			})
		*/
			aTotC[1]  := Round(a_totais[1],0)
			aTotC[2]  := Round(a_totais[1]+a_totais[2],0)
			aTotC[3]  := Round(a_totais[1]+a_totais[2]+a_totais[3],0)
			aTotC[4]  := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4],0)
			aTotC[5]  := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5],0)
			aTotC[6]  := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6],0)
			aTotC[7]  := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7],0)
			aTotC[8]  := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8],0)
			aTotC[9]  := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8]+a_totais[9],0)
			aTotC[10] := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8]+a_totais[9]+a_totais[10],0)
			aTotC[11] := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8]+a_totais[9]+a_totais[10]+a_totais[11],0)
			aTotC[12] := Round(a_totais[1]+a_totais[2]+a_totais[3]+a_totais[4]+a_totais[5]+a_totais[6]+a_totais[7]+a_totais[8]+a_totais[9]+a_totais[10]+a_totais[11]+a_totais[12],0)
	EndIf

//excluida a linha abaixo [Mauro Nagata, Actual Trend, 20/04/2012]
//TRAB->TRB_VENC	:= 0                 

	TRAB->TRB_TOT := n_TotAcm + n_Atrasados
	n_TotCRA	  := n_TotAcm + n_Atrasados
	TRAB->(MsUnLock())

	Aadd(a_separar, {'019','-'})

//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes do contas a pagar                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Proc. Registros CP")
//oObj:SetRegua2(n_tregcp)
	c_grprec := '020' //Grupo de Despesas
	If QRY->(!EOF())
		Do While QRY->(!EOF())
			//oObj:IncRegua2("Processando CP")
			If TRAB->(DbSeek(c_grprec+Substr(QRY->E2_NATUREZ,1,6))) //
				RecLock('TRAB', .F.)
			Else
				RecLock('TRAB', .T.)
				TRAB->TRB_GRPO	:= c_grprec
				TRAB->TRB_NAT	:= QRY->E2_NATUREZ
				TRAB->TRB_DESC	:= substr(QRY->E2_NATUREZ,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+QRY->E2_NATUREZ, 1, 'X'), 1,32)
			EndIf

			nPercNat := QRY->EV_PERC*QRY->EZ_PERC

			Do Case
			Case QRY->E2_TIPO = "PA"
				Do Case
				Case QRY->E2_SALDO > 0
					Do Case
					Case Substr(Dtos(dPerIni),1,6) > Substr(QRY->E2_EMISSAO,1,6)
						TRAB->TRB_ANT += QRY->E2_SALDO*nPercNat
						//Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_EMISSAO,1,6)
						//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160310]
					Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_EMISSAO,1,6).And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_EMISSAO,1,4)
						TRAB->TRB_REAL += QRY->E2_SALDO*nPercNat
						//Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_EMISSAO,1,6)
						//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160210]
					Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_EMISSAO,1,4)
						TRAB->&("TRB_M"+SubStr(QRY->E2_EMISSAO, 5,2)) += QRY->E2_SALDO*nPercNat
					EndCase
				Case QRY->E2_SALDO = 0
					Do Case
					Case Substr(Dtos(dPerIni),1,6) > Substr(QRY->E2_EMISSAO,1,6)
						TRAB->TRB_ANT += QRY->E2_VALOR*nPercNat
						//Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_EMISSAO,1,6)
						//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160310]
					Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_EMISSAO,1,4)
						TRAB->TRB_REAL += QRY->E2_VALOR*nPercNat
						//Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_EMISSAO,1,6)
						//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160210]
					Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_EMISSAO,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_EMISSAO,1,4)
						TRAB->&("TRB_M"+SubStr(QRY->E2_EMISSAO, 5,2)) += QRY->E2_VALOR*nPercNat
					EndCase
				EndCase
			Case QRY->E2_SALDO = QRY->E2_VALOR .AND. QRY->E2_SALDO > 0   //titulo com valor totalmente em aberto
				Do Case
				Case Substr(Dtos(dDataBase),1,6) > Substr(QRY->E2_VENCREA,1,6)
					TRAB->TRB_VENC += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
				Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_VENCREA,1,6)
		                /*
		                If Dtos(dDataBase) <= QRY->E2_VENCREA                                                                
		                   TRAB->TRB_ABER += QRY->E2_VALOR*nPercNat  - QRY->E2_DECRESC*nPercNat
		                Else
		                   TRAB->TRB_VENC += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
		                EndIf                                                     
		                */
					//substituida bloco acima pelo abaixo [Mauro Nagata, Actual Trend, 20160310]
					If Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_VENCREA,1,4)
						If Dtos(dDataBase) <= QRY->E2_VENCREA
							TRAB->TRB_ABER += QRY->E2_VALOR*nPercNat  - QRY->E2_DECRESC*nPercNat
						Else
							TRAB->TRB_VENC += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
						EndIf
					EndIf
					//fim bloco [Mauro Nagata, Actual Trend, 20160310]

					//Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6)
					//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160210]
				Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_VENCREA,1,4)
					If Dtos(dDataBase) <= QRY->E2_VENCREA
						TRAB->&("TRB_M"+SubStr(QRY->E2_VENCREA, 5,2)) += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
					Else
						TRAB->TRB_VENC += QRY->E2_VALOR*nPercNat - QRY->E2_DECRESC*nPercNat
					EndIf
				EndCase
			Case QRY->E2_SALDO < QRY->E2_VALOR .And. QRY->E2_SALDO > 0  //titulo com valor parcialmente em aberto
				Do Case
				Case Substr(Dtos(dDataBase),1,6) > Substr(QRY->E2_VENCREA,1,6)
					TRAB->TRB_VENC += QRY->E2_SALDO*nPercNat - QRY->E2_DECRESC*nPercNat
					//Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_VENCREA,1,6)
					//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160310]
				Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_VENCREA,1,6)  .And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_VENCREA,1,4)
					TRAB->TRB_ABER += QRY->E2_SALDO*nPercNat - QRY->E2_DECRESC*nPercNat  //MES ATUAL EM ABERTO
					//Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6)
					//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160210]
				Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_VENCREA,1,4)
					TRAB->&("TRB_M"+SubStr(QRY->E2_VENCREA, 5,2)) += QRY->E2_SALDO*nPercNat - QRY->E2_DECRESC*(nPercNat)
				EndCase
			Case QRY->E2_SALDO = 0
				DbSelectArea("SE2")
				nAbatim	 := SomaAbat(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE,SE2->E2_LOJA)

				DbSelectArea("QRX")
				Do Case
				Case Substr(Dtos(dPerIni),1,6) > Substr(QRY->E2_VENCREA,1,6)
					TRAB->TRB_ANT += nAbatim*nPercNat  - QRY->E2_DECRESC*nPercNat//QRX->IMPOSTOS
					//Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_VENCREA,1,6)
					//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160310]
				Case Substr(Dtos(dDataBase),1,6) = Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_VENCREA,1,4)
					TRAB->TRB_REAL += nAbatim*nPercNat  - QRY->E2_DECRESC*nPercNat// QRX->IMPOSTOS  //MES ATUAL EM ABERTO
					//Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6)
					//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160210]
				Case Substr(Dtos(dDataBase),1,6) != Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(QRY->E2_VENCREA,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(QRY->E2_VENCREA,1,4)
					TRAB->&("TRB_M"+SubStr(QRY->E2_VENCREA, 5,2)) += nAbatim*nPercNat - QRY->E2_DECRESC*nPercNat // QRX->IMPOSTOS
				EndCase

			EndCase

			DbSelectArea("SE2")
			DbSeek(QRY->E2_FILIAL+QRY->E2_PREFIXO+QRY->E2_NUM+QRY->E2_PARCELA+QRY->E2_TIPO+QRY->E2_FORNECE+QRY->E2_LOJA)
			U_FC050()

			cRetEmis := Ctod("")

			DbSelectArea("cNomeArq")
			DbGoTop()
			Do While !Eof()
				DbSelectArea("cNomeArq")
				DbGoTop()
				Do While !Eof()

					cRetEmis := Dtos(cNomeArq->DATAX)

					nSinal   := If(cNomeArq->OK = 1.Or.(cNomeArq->OK = 2 .And.cNomeArq->MOTIVO = "NOR".And.cNomeArq->TIPODOC="VL"),1,If(cNomeArq->OK = 2,-1,0))

					If cNomeArq->MOTIVO = "CMP"
						//incluida as duas linhas abaixo [Mauro Nagata, Actual Trend, 20160310]
						DbSkip()
						Loop
						aAreaCMP := GetArea()
						cChave := SubStr(cNomeArq->DOCUMENTO,1,3) // Prefixo
						cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO, 4,6), substr(cNomeArq->DOCUMENTO, 5,9))//Numero
						cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO,10,1), substr(cNomeArq->DOCUMENTO,15,2))//Parcela
						cChave += substr(cNomeArq->DOCUMENTO,18,3)
						//cChave += Substr(cNomeArq->DOCUMENTO,22,8)

						DbSelectArea('SE2')
						DbSetOrder(1) //E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO,E2_FORNEC, E2_LOJA R_E_C_N_O_, D_E_L_E_T_
						If DbSeek(cNomeArq->Filial+cChave)
							If SE2->E2_SALDO = 0
								DbSelectArea("cNomeArq")
								DbSkip()
								Loop
							EndIf
							cRetEmis := Dtos(SE2->E2_EMISSAO)
						EndIf
						c_natureza := Substr(SE2->E2_NATUREZ,1,6)     //
						If TRAB->(DbSeek(c_grprec+c_natureza))
							RecLock('TRAB', .F.)
						Else
							RecLock('TRAB', .T.)
							TRAB->TRB_GRPO	:= c_grprec
							TRAB->TRB_NAT	:= c_natureza
							TRAB->TRB_DESC	:= substr(c_natureza,1,4) + " - " + SubStr(GetAdvFval('SED', "ED_DESCRIC", xFilial('SED')+c_natureza, 1, 'X'), 1,32)
						EndIf
						RestArea(aAreaCMP)

					EndIf

					nVlrRec := cNomeArq->VALORPAGO*nPercNat
					Do Case
					Case cNomeArq->TIPODOC $ "MTüM2"
						nVlrRec := (cNomeArq->MULTA*(-1))*nPercNat
					Case cNomeArq->TIPODOC$"CMüC2|VM|CX"
						nVlrRec := (cNomeArq->CORRECAO*(-1))*nPercNat
					Case cNomeArq->TIPODOC $ "JRüJ2"
						nVlrRec := (cNomeArq->JUROS*(-1))*nPercNat
					Case cNomeArq->TIPODOC $ "DCüD2"
						nVlrRec := (cNomeArq->DESCONTOS)*nPercNat
					EndCase

					Do Case
					Case Substr(Dtos(dPerIni),1,6) > Substr(cRetEmis,1,6)
						TRAB->TRB_ANT += (nVlrRec * nSinal)
						//Case Substr(Dtos(dDataBase),1,6) = Substr(cRetEmis,1,6)
						//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160310]
					Case Substr(Dtos(dDataBase),1,6) = Substr(cRetEmis,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(cRetEmis,1,4)
						TRAB->TRB_REAL += (nVlrRec * nSinal) //MES ATUAL EM ABERTO
						//Case Substr(Dtos(dDataBase),1,6) != Substr(cRetEmis,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cRetEmis,1,6)
						//Substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160210]
					Case Substr(Dtos(dDataBase),1,6) != Substr(cRetEmis,1,6) .And. Substr(Dtos(dPerIni),1,6) <= Substr(cRetEmis,1,6) .And. Substr(Dtos(dPerIni),1,4) = Substr(cRetEmis,1,4)
						TRAB->&("TRB_M"+SubStr(cRetEmis, 5,2)) += (nVlrRec * nSinal)
					EndCase

					DbSelectArea("cNomeArq")
					DbSkip()
				EndDo
			EndDo

			If Select("cNomeArq") > 0
				DbSelectArea("cNomeArq")
				Use
				Ferase(cNomearq+GetDBExtension())
				Ferase(cNomeArq+OrdBagExt())
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
	c_GrpRec := '021' //Grupo de Despesas - subgrupo Fat. Direto
	If Len(a_FatDir) > 0
		RecLock('TRAB', .T.)
		TRAB->TRB_GRPO	:= c_grprec
		TRAB->TRB_DESC	:= "9999 - Faturamento Direto               "
		TRAB->TRB_ANT 	+= a_FatDir[13]
		TRAB->TRB_REAL  += a_FatDir[14]
		TRAB->TRB_ABER  += a_FatDir[15]
		For n_y := 1 to 12
			TRAB->&("TRB_M"+StrZero(n_y, 2)) := a_FatDir[n_y]
		Next
		TRAB->(MsUnLock())
	EndIf
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes de utilizacao de MAO DE OBRA                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Mao de Obra")
//oObj:IncRegua2("Processando mao de obra")

	c_GrpRec := '022' //Grupo de Despesas - subgrupo MAO DE OBRA

	RecLock('TRAB', .T.)
	TRAB->TRB_GRPO	:= c_grprec
	TRAB->TRB_DESC	:= " MÃO DE OBRA UTILIZADA                  "
	TRAB->TRB_ANT	:= fBusMod(StrZero(VAL(c_anoref)-1,4),"A")
	For n_y := 1 to 12
		If strzero(n_y,2) = SubStr(DtoS(dDataBase), 5, 2)
			//			TRAB->TRB_ANT := fBusMod(StrZero(VAL(c_anoref)-1,4))
			TRAB->TRB_REAL := fBusMod(c_anoref+StrZero(n_y,2),"M")
		Else //c_anoref+StrZero(n_y,2) < SubStr(DtoS(dDataBase), 1, 6)
			TRAB->&("TRB_M"+StrZero(n_y, 2)) := fBusMod(c_anoref+StrZero(n_y,2),"M")
		EndIf
	Next
	TRAB->(MsUnLock())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebra de linha                                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbselectArea('TRAB')
	DbSeek('020',.t.)
	a_totais := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	n_totaln := 0
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO <= '022'
		n_totaln := 0
		For n_x := 1 to 12
			a_totais[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
			n_totaln      += TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		a_totais[13] += TRAB->TRB_ANT
		a_totais[14] += TRAB->TRB_REAL
		a_totais[15] += TRAB->TRB_ABER
		a_totais[16] += TRAB->TRB_VENC
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln + TRAB->TRB_ABER
		MsUnLock()
		a_totais[17] += TRAB->TRB_TOT
		nTotPrvDep += TRAB->TRB_TOT
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
		aTotDesAc[n_x] := a_totais[n_x]
		aTotD[n_x] := a_totais[n_x]
	Next
	TRAB->TRB_ANT	:= a_totais[13]
	TRAB->TRB_REAL	:= a_totais[14]
	TRAB->TRB_ABER	:= a_totais[15]
	TRAB->TRB_VENC	:= a_totais[16]
	TRAB->TRB_TOT	:= a_totais[17]
	n_Atrasados     := TRAB->TRB_VENC
	nTotPrvDep      += n_Atrasados
	TRAB->(MsUnLock())

	Aadd(a_separar, {'024','-'})

//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³ NOTAS FISCAIS DE REMESSA                                                                ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Notas de Remessa")
//oObj:IncRegua2("Processando notas de remessa")
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

	memoWrite('RFIN011ab.sql', c_query)
//Incluso a linha acima, Thiago Rufino, Actual Trend, 2017/11/22

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
			aTotDesAc[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
			aTotE[n_x] := TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln
		nTotPrvDep += TRAB->TRB_TOT
		MsUnLock()
	EndIf
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³ NOTAS FISCAIS DE RETORNO DE REMESSA                                                     ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Retorno de Remessa")
//oObj:IncRegua2("Processando retorno de remessa")
	c_grprec := '026' //Grupo Notas de remessa - sub grupo retorno

	c_query := "SELECT SUM(D1_TOTAL) AS VALOR, D1_EMISSAO "
	c_query += "FROM SD1010 D1 "
	c_query += "LEFT JOIN SF4010 F4 "
	c_query += "     ON F4.D_E_L_E_T_ = '' "
	c_query += "        AND F4_CODIGO = D1_TES "
	c_query += "        AND F4_DUPLIC <> 'S' "
	c_query += "inner JOIN SB1010 B1 "
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
			aTotDesAc[n_x] -= TRAB->&("TRB_M"+StrZero(n_x,2))
			aTotF[n_x] := TRAB->&("TRB_M"+StrZero(n_x,2))
		Next
		RecLock('TRAB', .F.)
		TRAB->TRB_TOT := TRAB->TRB_ANT + TRAB->TRB_REAL + n_totaln
		nTotPrvDep    += TRAB->TRB_TOT + TRAB->TRB_VENC
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
			//aTotDesAc[n_x] += TRAB->&("TRB_M"+StrZero(n_x,2))
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
	n_totacm 		:= a_totais[13]   //anterior ao periodo atual
	TRAB->TRB_ANT	:= n_totacm
	For n_x := 1 to 12
		If n_x = val(substr(dtos(ddatabase),5,2))
			//a_totais[14]    += n_atrasados
			n_totacm 		+= a_totais[14]   //realizado
			//			If SubStr(DtoS(dDataBase), 1, 4) = c_anoref
			TRAB->TRB_REAL	:= n_totacm
			//			endIf
			n_totacm 		+= a_totais[15]  //aberto
			//			If SubStr(DtoS(dDataBase), 1, 4) = c_anoref
			TRAB->TRB_ABER	:= n_totacm
			//			EndIf
		EndIf
		n_totacm += a_totais[n_x]
		TRAB->&("TRB_M"+StrZero(n_x,2)) := n_totacm
	Next

//excluida a linha abaixo [Mauro Nagata, Actual Trend, 23/04/2012]
//TRAB->TRB_VENC	:= 0
	TRAB->TRB_TOT	:= n_totacm + n_atrasados
	n_totDA			:= n_totacm + n_atrasados
	TRAB->(MsUnLock())

	If MV_PAR10 == 1

		aTotG[1]  := Round(aTotD[1]+aTotE[1]-aTotF[1],0)
		aTotG[2]  := Round(aTotD[2]+aTotE[2]-aTotF[2],0) + aTotG[1]
		aTotG[3]  := Round(aTotD[3]+aTotE[3]-aTotF[3],0) + aTotG[2]
		aTotG[4]  := Round(aTotD[4]+aTotE[4]-aTotF[4],0) + aTotG[3]
		aTotG[5]  := Round(aTotD[5]+aTotE[5]-aTotF[5],0) + aTotG[4]
		aTotG[6]  := Round(aTotD[6]+aTotE[6]-aTotF[6],0) + aTotG[5]
		aTotG[7]  := Round(aTotD[7]+aTotE[7]-aTotF[7],0) + aTotG[6]
		aTotG[8]  := Round(aTotD[8]+aTotE[8]-aTotF[8],0) + aTotG[7]
		aTotG[9]  := Round(aTotD[9]+aTotE[9]-aTotF[9],0) + aTotG[8]
		aTotG[10] := Round(aTotD[10]+aTotE[10]-aTotF[10],0) + aTotG[9]
		aTotG[11] := Round(aTotD[11]+aTotE[11]-aTotF[11],0) + aTotG[10]
		aTotG[12] := Round(aTotD[12]+aTotE[12]-aTotF[12],0) + aTotG[11]

	//	oExcel:AddRow("Totais","Resumo",{"Total Despesas Acumuladas (d+e-f=g):",;
	//		aTotG[1],aTotG[2],aTotG[3],aTotG[4],aTotG[5],aTotG[6],;
	//		aTotG[7],aTotG[8],aTotG[9],aTotG[10],aTotG[11],aTotG[12]})

			
	EndIf

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
	n_totacm 		:= a_totais[13]  //anterior ao periodo atual
	TRAB->TRB_ANT	:= n_totacm
	For n_x := 1 to 12
		If n_x = val(substr(dtos(ddatabase),5,2))
			n_totacm 		+= a_totais[14]  //realizado
			TRAB->TRB_REAL	:= n_totacm
			n_totacm 		+= a_totais[15]  //aberto
			TRAB->TRB_ABER	:= n_totacm
		EndIf
		n_totacm += a_totais[n_x]
		TRAB->&("TRB_M"+StrZero(n_x,2)) := n_totacm
	Next
	TRAB->TRB_VENC	:= 0
	TRAB->TRB_TOT	:= n_totacm
	TRAB->(MsUnLock())

	//If MV_PAR10 == 1
	//	oExcel:AddRow("Totais","Resumo",{"Saldo Fluxo Caixa Acumulado (c-g):",;
	//	Round(aTotC[1]-aTotG[1],0),Round(aTotC[2]-aTotG[2],0),Round(aTotC[3]-aTotG[3],0),Round(aTotC[4]-aTotG[4],0),Round(aTotC[5]-aTotG[5],0),Round(aTotC[6]-aTotG[6],0),;
	//	Round(aTotC[7]-aTotG[7],0),Round(aTotC[8]-aTotG[8],0),Round(aTotC[9]-aTotG[9],0),Round(aTotC[10]-aTotG[10],0),Round(aTotC[11]-aTotG[11],0),Round(aTotC[12]-aTotG[12],0)})
	//EndIf

	Aadd(a_separar, {'052','*'})
	Aadd(a_separar, {'053',' '})
	Aadd(a_separar, {'054','-'})

//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³PEDIDOS DE COMPRAS EM ABERTO                                                             ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Pedidos de compras")
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
//oObj:IncRegua1("Previsoes")
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
	n_prevmd := CTT->CTT_XVLR - n_TotCRA - nVlrImp
	n_prevmd := Iif(n_prevmd < 0, 0, n_prevmd)
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
		//TRAB->TRB_DESC	:= "PREVISAO MEDICAO          [h]|" + Transform(n_prevmd,"@E 99,999,999")

		TRAB->TRB_DESC	:= "PREVISAO MEDICAO          [h]|" + Transform(CTT->CTT_XVLR - nTotPrvRec,"@E 99,999,999")
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
		TRAB->TRB_DESC	:= "PREVISAO DESPESA          [i]|" + Transform(n_ValCust - nTotPrvDep,"@E 99,999,999")
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
			a_totais[13] += TRAB->TRB_ANT * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)  //periodo anterior
			a_totais[14] += TRAB->TRB_REAL * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)  //realizado
			a_totais[15] += TRAB->TRB_ABER * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)  //aberto
			a_totais[16] += TRAB->TRB_VENC * Iif(TRAB->TRB_NAT	= '2DESPESA', -1, 1)  //vencido
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN011   ºAutor  ³Alexandre Sousa     º Data ³  09/26/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os valores de mao de obra utilizadas no mes         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fBusMod(c_datalike,pTipo)

	n_Ret := 0
	c_query := ''

	c_query := " select     ZC_DATA, ZC_OBRA, ZC_RECURSO, AE8_CUSTOM, AE8_CUSTOM/22 as CUSTO_DIA"
	c_query += " from       "+RetSqlName('SZC')+" as SZC"
	c_query += " inner join "+RetSqlName('AE8')+" as AE8"
	c_query += " on         ZC_RECURSO = AE8_RECURS"
	c_query += " and        AE8.D_E_L_E_T_ <> '*'"
	c_query += " where      ZC_OBRA = '"+CTT->CTT_CUSTO+"'"
//c_query += " and        ZC_DATA like '"+c_datalike+"%'"   
//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 20160202]
	If pTipo = "M"
		c_query += " and        ZC_DATA like '"+c_datalike+"%'"
	Else
		c_query += " and        SUBSTRING(ZC_DATA,1,4) <= '"+c_datalike+"'"
	EndIf
//fim bloco [Mauro Nagata, Actual Trend, 20160202]
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TrataSE5  ºAutor  ³Alexandre Sousa     º Data ³  12/15/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza o tratamento do se5 para titulos com baixa parcial  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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



Static Function DespObra(c_Obra)

	cHOSPED     = '000203         '  //hospedagem
	cFRETE      = '000201         '  //frete
	cTRASLADO   = '000200         '  //traslado
	cREFEICAO   = '000202         '  //refeicao
	cNATHOSP    = '2616'
	cNATFRETE   = '2224'
	cNATKMROD   = '2620'
	cNATPEDAG   = '2612'
	cNATPASSA   = '2614'
	cNATPASST   = '2622'
	cNATREFEI   = '2618'
	cNATSVEMP   = '2202'
	cNATSRVPF   = '2302'
	cNATSRVTE   = '2304'
	cNATTRASL   = 'TRAS'
	cNATMOUTIL  = 'MOU'
	cDESCFRETE  = 'FRETE'
	cDESCHOSP   = 'HOSPEDAGEM'
	cDESCREFEI  = 'REFEICAO'
	cDESCKMROD  = 'KM RODADO'
	cDESCPEDAG  = 'PEDAGIO'
	cDESCPASSA  = 'PASSAGEM AEREA'
	cDESCPASST  = 'PASSAGEM TERRESTRE'
	cDESCTRASL  = 'TRASLADO'  //traslado eh composto pelas naturezas pedagio, km rodado, passagem aerea, passagem terrestre
	cDESCMOUTI  = 'MAO DE OBRA UTILIZADA'
	cDESCSVEMP  = 'SERVICO SUB EMPREITEIRO'
	cDESCSRVPF  = 'SERVICO PROFIS.PES.FISICA'
	cDESCSRVTE  = 'SERVICO PROFIS.TEMPORARIO'


	cQuery := "SELECT OBRA, CTT_DESC01 AS DESCR, NATUREZ, " + Chr(13)+Chr(10)
	cQuery += "       (CASE WHEN NATUREZ = '"+cNATSVEMP+"' AND DESCRNAT = '' " + Chr(13)+Chr(10)
	cQuery += "             THEN '"+cDESCSVEMP+"' " + Chr(13)+Chr(10)
	cQuery += "             ELSE  " + Chr(13)+Chr(10)
	cQuery += "             (CASE WHEN NATUREZ = '"+cNATSRVPF+"'  AND DESCRNAT = '' " + Chr(13)+Chr(10)
	cQuery += "                   THEN '"+cDESCSRVPF+"' " + Chr(13)+Chr(10)
	cQuery += "                   ELSE " + Chr(13)+Chr(10)
	cQuery += "                   (CASE WHEN NATUREZ = '"+cNATSRVTE+"'  AND DESCRNAT = '' " + Chr(13)+Chr(10)
	cQuery += "                         THEN '"+cDESCSRVTE+"' " + Chr(13)+Chr(10)
	cQuery += "                         ELSE  " + Chr(13)+Chr(10)
	cQuery += "                         (CASE WHEN NATUREZ = '"+cNATPEDAG+"' AND DESCRNAT = '' " + Chr(13)+Chr(10)
	cQuery += "                               THEN '"+cDESCPEDAG+"' " + Chr(13)+Chr(10)
	cQuery += "                               ELSE DESCRNAT " + Chr(13)+Chr(10)
	cQuery += "                         END)       " + Chr(13)+Chr(10)
	cQuery += "                   END) " + Chr(13)+Chr(10)
	cQuery += "              END)            " + Chr(13)+Chr(10)
	cQuery += "        END) DESCRNAT, ROUND(SUM(VLR_ORCA),2) AS VLR_ORCA " + Chr(13)+Chr(10)
	cQuery += "FROM ( " + Chr(13)+Chr(10)
	cQuery += "		SELECT OBRA, NATUREZ,  " + Chr(13)+Chr(10)
	cQuery += "			   CASE WHEN NATUREZ = '"+cNATHOSP+"' " + Chr(13)+Chr(10)
	cQuery += "					THEN '"+cDESCHOSP+"' " + Chr(13)+Chr(10)
	cQuery += "					ELSE " + Chr(13)+Chr(10)
	cQuery += "					(CASE WHEN NATUREZ = '"+cNATREFEI+"' " + Chr(13)+Chr(10)
	cQuery += "						  THEN '"+cDESCREFEI+"' " + Chr(13)+Chr(10)
	cQuery += "						  ELSE  " + Chr(13)+Chr(10)
	cQuery += "						  (CASE WHEN NATUREZ = '"+cNATFRETE+"' " + Chr(13)+Chr(10)
	cQuery += "								THEN '"+cDESCFRETE+"' " + Chr(13)+Chr(10)
	cQuery += "								ELSE " + Chr(13)+Chr(10)
	cQuery += "								(CASE WHEN NATUREZ = '"+cNATKMROD+"' " + Chr(13)+Chr(10)
	cQuery += "									  THEN '"+cDESCKMROD+"' " + Chr(13)+Chr(10)
	cQuery += "									  ELSE " + Chr(13)+Chr(10)
	cQuery += "									  (CASE WHEN NATUREZ = '"+cNATPASSA+"' " + Chr(13)+Chr(10)
	cQuery += "											THEN '"+cDESCPASSA+"' " + Chr(13)+Chr(10)
	cQuery += "											ELSE " + Chr(13)+Chr(10)
	cQuery += "											(CASE WHEN NATUREZ = '"+cNATPASST+"' " + Chr(13)+Chr(10)
	cQuery += "												  THEN '"+cDESCPASST+"' " + Chr(13)+Chr(10)
	cQuery += "												  ELSE  " + Chr(13)+Chr(10)
	cQuery += "												  (CASE WHEN NATUREZ = '"+cNATTRASL+"' " + Chr(13)+Chr(10)
	cQuery += "														THEN '"+cDESCTRASL+"' " + Chr(13)+Chr(10)
	cQuery += "														ELSE  " + Chr(13)+Chr(10)
	cQuery += "														(CASE WHEN NATUREZ = '"+cNATMOUTIL+"' " + Chr(13)+Chr(10)
	cQuery += "															  THEN '"+cDESCMOUTI+"' " + Chr(13)+Chr(10)
	cQuery += "															  ELSE '' " + Chr(13)+Chr(10)
	cQuery += "														END) " + Chr(13)+Chr(10)
	cQuery += "												  END) " + Chr(13)+Chr(10)
	cQuery += "											END) " + Chr(13)+Chr(10)
	cQuery += "									  END) " + Chr(13)+Chr(10)
	cQuery += "								END) " + Chr(13)+Chr(10)
	cQuery += "						  END) " + Chr(13)+Chr(10)
	cQuery += "					END) " + Chr(13)+Chr(10)
	cQuery += "			  END AS DESCRNAT, " + Chr(13)+Chr(10)
	cQuery += "			  VLR_ORCA " + Chr(13)+Chr(10)
	cQuery += "		FROM ( " + Chr(13)+Chr(10)
	cQuery += "				SELECT AF8_CODOBR AS OBRA,  " + Chr(13)+Chr(10)
	cQuery += "					   CASE WHEN AFA_PRODUT = '"+cFRETE+"' " + Chr(13)+Chr(10)
	cQuery += "							THEN '"+cNATFRETE+"' " + Chr(13)+Chr(10)
	cQuery += "							ELSE " + Chr(13)+Chr(10)
	cQuery += "							    (CASE WHEN AFA_PRODUT = '"+cHOSPED+"' " + Chr(13)+Chr(10)
	cQuery += "								      THEN '"+cNATHOSP+"' " + Chr(13)+Chr(10)
	cQuery += "								      ELSE " + Chr(13)+Chr(10)
	cQuery += "								          (CASE WHEN AFA_PRODUT = '"+cTRASLADO+"' " + Chr(13)+Chr(10)
	cQuery += "										        THEN '"+cNATTRASL+"' " + Chr(13)+Chr(10)
	cQuery += "									    	    ELSE  " + Chr(13)+Chr(10)
	cQuery += "										            (CASE WHEN AFA_PRODUT = '' AND AFA_RECURS <> '' " + Chr(13)+Chr(10)
	cQuery += "											              THEN '"+cNATMOUTIL+"' " + Chr(13)+Chr(10)
	cQuery += "											              ELSE '"+cNATREFEI+"' " + Chr(13)+Chr(10)
	cQuery += "											        END) " + Chr(13)+Chr(10)
	cQuery += "										  END) " + Chr(13)+Chr(10)
	cQuery += "								END) " + Chr(13)+Chr(10)
	cQuery += "					   END AS NATUREZ, " + Chr(13)+Chr(10)
	cQuery += "					   AFA_QUANT*AFA_CUSTD AS VLR_ORCA " + Chr(13)+Chr(10)
	cQuery += "				FROM AFA010 AFA " + Chr(13)+Chr(10)
	cQuery += "				INNER JOIN AF8010 AF8 " + Chr(13)+Chr(10)
	cQuery += "					  ON AF8_PROJET =  AFA_PROJET  " + Chr(13)+Chr(10)
//cQuery += "					     AND AF8_CODOBR BETWEEN '"+cDAOBRA+"' AND '"+cATEOBRA+"' " + Chr(13)+Chr(10)
	cQuery += "					     AND AF8_CODOBR = '"+c_Obra+"' " + Chr(13)+Chr(10)
	cQuery += "						 AND AF8.D_E_L_E_T_<>'*'     " + Chr(13)+Chr(10)
	cQuery += "				WHERE AFA.D_E_L_E_T_<>'*' " + Chr(13)+Chr(10)
	cQuery += "					  AND (AFA_PRODUT IN ('"+cHOSPED+"','"+cFRETE+"','"+cTRASLADO+"','"+cREFEICAO+"') OR (AFA_PRODUT = '' AND AFA_RECURS <> '') ) " + Chr(13)+Chr(10)
	cQuery += "					  AND AFA_REVISA = '0001'							   " + Chr(13)+Chr(10)
	cQuery += "				 ) B				 " + Chr(13)+Chr(10)
	cQuery += "			     ) C			   		 " + Chr(13)+Chr(10)
	cQuery += " INNER JOIN CTT010 CTT " + Chr(13)+Chr(10)
	cQuery += "	  ON CTT.D_E_L_E_T_<>'*' " + Chr(13)+Chr(10)
	cQuery += "		 AND CTT_CUSTO =  '"+ c_obra+"' "  + Chr(13)+Chr(10)
	cQuery += "		 AND CTT_FILIAL = '  ' " + Chr(13)+Chr(10)
	cQuery += "		 AND CTT_CUSTO NOT IN ('000       ','100       ','200       ','300       ', '400       ', " + Chr(13)+Chr(10)
	cQuery += "							   '500       ','600       ','700       ','800       ','900       ')   " + Chr(13)+Chr(10)
//cQuery += "		 AND ((CTT_MSBLQL <> '1' AND '"+cCONSBLOQ+"' = 'NAO') OR '"+cCONSBLOQ+"' = 'SIM') "  + Chr(13)+Chr(10)
	cQuery += "GROUP BY OBRA, CTT_DESC01,NATUREZ,DESCRNAT  " + Chr(13)+Chr(10)
	cQuery += "ORDER BY OBRA, NATUREZ " + Chr(13)+Chr(10)

	memoWrite('RFIN011f.sql', cQuery)

	If Select("QRF") > 0
		DbSelectArea("QRF")
		DbCloseArea()
	EndIf
	TcQuery cQuery New Alias "QRF"

	cArqInd := CriaTrab(Nil,.F.)
	IndRegua("QRF",cArqInd,"NATUREZ",,,"Preparando Registros . . .")
