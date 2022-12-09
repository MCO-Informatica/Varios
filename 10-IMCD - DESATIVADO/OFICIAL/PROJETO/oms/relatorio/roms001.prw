#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROMS001   º Autor ³ Giane              º Data ³  04/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Lista Mestra de Fornecedores                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ROMS001

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "LISTA MESTRA DE FORNECEDORES"
	Local cPict          := ""
	//Local nLin         := 80
	Local Cabec1       := "                                              Q U A L I F I C A Ç Õ E S    E    V A L I D A D E S                              V A L I D A D E     D A S     L I C E N Ç A S                                 "
	Local Cabec2       := "FORNECEDOR                                 ISO-9001  ISO-14001 OHSAS-18001  PRODIR    SA8000   TS 16949   SASSMAQ AVALIACAO   Pol.Federal Pol.Civil M.Exercito   Mapa    Visa LF   Anvisa AFE  Anvisa AE  OBSERVAÇÕES"
	//123456789012345678901234567890             99/99/99   99/99/99   99/99/99  99/99/99  99/99/99  99/99/99  99/99/99  99/99/99     99/99/99  99/99/99   99/99/99  99/99/99  99/99/99   99/99/99   99/99/99
	//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//           1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	Local imprime      := .T.
	Local aOrd := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "ROMS001" , __cUserID )

	Private titulo       := "LISTA MESTRA DE FORNECEDORES"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 220
	Private tamanho          := "G"
	Private nomeprog         := "ROMS001" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 15
	Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "ROMS001" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private nLin       := 80
	Private cAlias := GetNextAlias() // "XSA2"

	cQuery := "SELECT SA2.A2_COD,SA2.A2_LOJA,SA2.A2_NOME, SA2.A2_ISO9001, SA2.A2_ISO1400, SA2.A2_OHSAS18, SA2.A2_PRODIR, A2_SA8000, "
	cQuery += " A2_TS16949, SA2.A2_SASSMAQ, SA2.A2_AVALIA, SA2.A2_PFVALID, SA2.A2_PCVALID, A2_MEVALID, "
	cQuery += " A2_MAPAVLD, SA2.A2_VLFVLD, SA2.A2_AFEVLD, SA2.A2_AEVLD, SA2.A2_XOBSISO "
	cQuery += "FROM " + RetSqlName("SA2") + " SA2 "
	cQuery += " WHERE A2_FILIAL  = '"+ xFilial("SA2")+"' AND "
	cQuery += " A2_LISTAM = 'S'  "
	cQuery += "AND D_E_L_E_T_ = ' '  "
	cQuery += "ORDER BY SA2.A2_NOME "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	dbSelectArea(cAlias)
	DbGotop()

	wnrel := SetPrint(cAlias,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cAlias)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)

	(cAlias)->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  04/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo)

	Local aDados := {}
	Local nOrdem

	dbSelectArea(cAlias)
	SetRegua(RecCount())

	dbGoTop()
	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
		Endif

		cCOD 		:= (cAlias)->A2_COD
		cLOJA 		:= (cAlias)->A2_LOJA
		cFORN 		:=  LEFT(A2_NOME,30)
		cISO900 	:= IIF(!EMPTY((cAlias)->A2_ISO9001),STOD((cAlias)->A2_ISO9001),SPACE(08))
		cISO1400 	:= IIF(!EMPTY((cAlias)->A2_ISO1400),STOD((cAlias)->A2_ISO1400),SPACE(08))
		cOHSA 		:= IIF(!EMPTY((cAlias)->A2_OHSAS18),STOD((cAlias)->A2_OHSAS18),SPACE(08))
		cPRODIR 	:= IIF(!EMPTY((cAlias)->A2_PRODIR),STOD((cAlias)->A2_PRODIR),SPACE(08))
		cSA8000 	:= IIF(!EMPTY((cAlias)->A2_SA8000),STOD((cAlias)->A2_SA8000),SPACE(08))
		cTS16949 	:= IIF(!EMPTY((cAlias)->A2_TS16949),STOD((cAlias)->A2_TS16949),SPACE(08))
		cSASSMAQ 	:= IIF(!EMPTY((cAlias)->A2_SASSMAQ),STOD((cAlias)->A2_SASSMAQ),SPACE(08))
		cAVALIA 	:= IIF(!EMPTY((cAlias)->A2_AVALIA),STOD((cAlias)->A2_AVALIA),SPACE(08))

		cPFVALID 	:= IIF(!EMPTY((cAlias)->A2_PFVALID),STOD((cAlias)->A2_PFVALID),SPACE(08))
		cPCVALID 	:= IIF(!EMPTY((cAlias)->A2_PCVALID),STOD((cAlias)->A2_PCVALID),SPACE(08))
		cMEVALID 	:= IIF(!EMPTY((cAlias)->A2_MEVALID),STOD((cAlias)->A2_MEVALID),SPACE(08))
		cMAPAVLD 	:= IIF(!EMPTY((cAlias)->A2_MAPAVLD),STOD((cAlias)->A2_MAPAVLD),SPACE(08))
		cVLFVLD 	:= IIF(!EMPTY((cAlias)->A2_VLFVLD),STOD((cAlias)->A2_VLFVLD),SPACE(08))
		cAFEVLD 	:= IIF(!EMPTY((cAlias)->A2_AFEVLD),STOD((cAlias)->A2_AFEVLD),SPACE(08))
		cAEVLD 		:= IIF(!EMPTY((cAlias)->A2_AEVLD),STOD((cAlias)->A2_AEVLD),SPACE(08))
		cXOBSISO	:= AllTrim((cAlias)->A2_XOBSISO)

		@nLin,000 PSAY cCOD+"-"+cLOJA+" "+cFORN
		@nLin,044 PSAY cISO900
		@nLin,055 PSAY cISO1400
		@nLin,065 PSAY cOHSA
		@nLin,075 PSAY cPRODIR
		@nLin,085 PSAY cSA8000
		@nLin,095 PSAY cTS16949
		@nLin,105 PSAY cSASSMAQ
		@nLin,115 PSAY cAVALIA

		@nLin,128 PSAY cPFVALID
		@nLin,138 PSAY cPCVALID
		@nLin,149 PSAY cMEVALID
		@nLin,159 PSAY cMAPAVLD
		@nLin,169 PSAY cVLFVLD
		@nLin,180 PSAY cAFEVLD
		@nLin,191 PSAY cAEVLD

		nLin ++
		@nLin,005 PSAY "Obs: " + cXOBSISO
		nLin ++
		@nLin,000 PSAY replicate('-',219)
		nLin ++

		Aadd(aDados,{CHR(160)+cCOD,CHR(160)+cLOJA,cFORN,cISO900,cISO1400,cOHSA,cPRODIR,cSA8000,cTS16949,cSASSMAQ,cAVALIA,;
		cPFVALID,cPCVALID,cMEVALID,cMAPAVLD,cVLFVLD,cAFEVLD,cAEVLD,cXOBSISO," "})


		dbSkip()
	EndDo

	IF Len(aDados) > 0
		IF MsgYesNo( "Deseja Gerar Excel?" )
			aCabExcel :={}

			aCabExcel := {"Codigo","Loja","Fornecedor","ISO-9001","ISO-14001","OHSAS-18001","PRODIR","SA8000","TS 16949",;
			"SASSMAQ","Avaliacao","Pol.Federal","Pol.Civil","M.Exercito","Mapa","Visa LF","Anvisa AFE","Anvisa AE","Observações",""}


			DlgToExcel({ {"ARRAY", titulo, aCabExcel, aDados} })

		ENDIF
	ENDIF

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return()