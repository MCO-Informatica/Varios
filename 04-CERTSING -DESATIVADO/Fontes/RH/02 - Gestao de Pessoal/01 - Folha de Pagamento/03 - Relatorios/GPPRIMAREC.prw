#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE ALIGN_H_LEFT   	0
#DEFINE ALIGN_H_RIGHT  	1
#DEFINE ALIGN_H_CENTER 	2
#DEFINE ALIGN_V_CENTER 	0
#DEFINE ALIGN_V_TOP	   	1
#DEFINE ALIGN_V_BOTTON 	2
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPPRIMARECºAutor  ³Marco Antonio-Prima º Data ³  21/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ recibo de pagamento grafico                                º±±
±±º          ³ Periodo de Pagamento de/Ate                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Clientes PrimaInfo                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GPPRIMAREC()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString:="SRA"
Local aOrd   := {"Matricula","Nome","C.Custo+Matricula","C.Custo+Nome"} //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"
Local cDesc1 := "Emiss„o de Recibos de Pagamento."		//"Emiss„o de Recibos de Pagamento."
Local cDesc2 := "Ser  impresso de acordo com os parametros solicitados pelo"		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "usu rio."		//"usu rio."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local n_ContMes1	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o numero da linha de impressão como 0                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetPrc(0,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {"Zebrado", 1,"Administra‡„o", 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private nomeprog := "GPPRIMAREC"
Private nLastKey := 0
Private cPerg    :=  "GPPRIMAREC"
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aLanca := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := _PROW()
Private Titulo := "EMISSO DE RECIBOS DE PAGAMENTOS"		//"EMISSO DE RECIBOS DE PAGAMENTOS"
SetPrvt("oPrint")
Private ArialN6      := TFont():New("Arial"	,,6	,,.F.,,,,,.F.)
Private ArialN6B     := TFont():New("Arial"	,,6	,,.T.,,,,,.F.)
Private ArialN8      := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
Private ArialN8B     := TFont():New("Arial"	,,8	,,.T.,,,,,.F.)
Private ArialN10     := TFont():New("Arial"	,,10	,,.F.,,,,,.F.)
Private ArialN10B    := TFont():New("Arial"	,,10	,,.T.,,,,,.F.)
Private ArialN12     := TFont():New("Arial"	,,12	,,.F.,,,,,.F.)
Private ArialN12B    := TFont():New("Arial"	,,12	,,.T.,,,,,.F.)
Private Times14      := TFont():New("Times New Roman",,14   ,,.T.,,,,,.F. )
Private Times20      := TFont():New("Times New Roman",,20   ,,.T.,,,,,.F. )
Private CourN08B     := TFont():New("Courier New",,08,,.T.,,,,.T.,.F.)
Private Tahoma08     := TFont():New("Tahoma",08,08,,.F.,,,,.T.,.F.)
Private Tahoma08B    := TFont():New("Tahoma",08,08,,.T.,,,,.T.,.F.)     //Negrito
Private Tahoma10B    := TFont():New("Tahoma",10,10,,.T.,,,,.T.,.F.)     //Negrito
Private Tahoma10     := TFont():New("Tahoma",10,10,,.F.,,,,.T.,.F.)
Private nlin		 := 50
Private aMesAnoRef   := {}
Private d_aux        := Ctod("  /  /  ")
Private n_ContMes	 := 0
Private cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Private cDescFunc		:= ""		//-- codigo da Funcao do funcionario
Private cPict3 		:= "@E 999,999.99"

//limpArqPdf() //Limpa arquivo se estiver no servidor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "GPPRIMAREC"           //Nome Default do relatorio em Disco

//Cria Perguntas
fMasperg()

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a Ordem do Relatorio                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataRef   := mv_par01
dDataRefa  := mv_par02
cRoteiro   := mv_par03
cSemana    := mv_par04  //Numero da Semana
cFilDe     := mv_par05	//Filial De
cFilAte    := mv_par06  //Filial Ate
cCcDe      := mv_par07  //Centro de Custo De
cCcAte     := mv_par08	//Centro de Custo Ate
cMatDe     := mv_par09	//Matricula Des
cMatAte    := mv_par10	//Matricula Ate
cNomDe     := mv_par11  //Nome De
cNomAte    := mv_par12  //Nome Ate
Mensag1    := mv_par13										 	//Mensagem 1
Mensag2    := mv_par14											//Mensagem 2
Mensag3    := mv_par15											//Mensagem 3
cSituacao  := mv_par16	//Situacoes a Imprimir
cCategoria := mv_par17	//Categorias a Imprimir
dDemDe     := mv_par18
dDemAte    := mv_par19

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consiste Parametros Ano e Mes de/Ate                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR02 < MV_PAR01
	MsgInfo( "Mes e ano final menor que mes e ano inicial","Atencao")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consiste Parametros Ano e Mes de/Ate                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Armazena os meses no Array aMesAnoRef
d_aux := dDataRef
oPrint:= TMSPrinter():New()
oPrint:SetPortrait()

While d_aux <= dDataRefa
	cMesAnoRef := StrZero(Month(d_aux),2) + StrZero(Year(d_aux),4)
	AADD(aMesAnoRef,{cMesAnoRef,d_aux})

	If Month(d_aux) = 12
		d_aux := Ctod( "01/01/" + StrZero( Year( d_aux ) + 1,4 ) )
	Else
		d_aux := Ctod( "01/" + StrZero( Month( d_aux ) + 1, 2) + "/" + StrZero( Year( d_aux ),4 ))
	Endif
Enddo

For n_ContMes1 := 1 To Len(aMesAnoRef)
	n_ContMes := n_ContMes1
	RptStatus({|lEnd| R030Imp(@lEnd,wnRel,cString,aMesAnoRef[n_ContMes,1],aMesAnoRef[n_ContMes,2])},Titulo)  // Chamada do Relatorio
Next

oPrint:Preview()

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030IMP  ³ Autor ³ Prima Informatica     ³ Data ³ 14.03.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef,dRef)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cAliasMov := ""
Private cPict1	  :=	"@E 999,999,999.99"
Private cPict2    :=    "@E 99,999,999.99"
Private cPict3    :=	"@E 999,999.99"
If MsDecimais(1) == 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

cMesArqRef := cMesAnoRef

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
If nOrdem == 1
	dbSetOrder(1)
ElseIf nOrdem == 2
	dbSetOrder(3)
ElseIf nOrdem == 3
	dbSetOrder(2)
ElseIf nOrdem == 4
	dbSetOrder(8)
Endif

dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	dbSeek(cFilDe + cMatDe,.T.)
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif

dbSelectArea("SRA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

TOTVENC:= TOTDESC:= 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Mensagens                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DESC_MSG1 := Mensag1
DESC_MSG2 := Mensag2
DESC_MSG3 := Mensag3

cFilialAnt := "  "
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
	IncRegua()  // Anda a regua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	(SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
		(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
		(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf

	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00

	Ordem_rel := 1     // Ordem dos Recibos

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste situacao e categoria dos funcionarios			     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( SRA->RA_SITFOLH $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRA->RA_SITFOLH == "D" 
		If SRA->RA_DEMISSA < dDemDe .Or. SRA->RA_DEMISSA > dDemAte   
			dbSkip()
			Loop
		Endif
	Endif

	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := Alltrim(aInfo[4]) + " - " +AllTrim(aInfo[5]) + " - " + aInfo[6]                // Dados da Filial
		Desc_CGC := aInfo[8]

		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif

	Totvenc := Totdesc := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Movimento Aberto - SRC                                       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	n_RetRCH := xValRCH(SRA->RA_PROCES,AnoMes(dRef),cSemana,cRoteiro)

	If n_RetRCH = 0
		c_Query := " SELECT RC_FILIAL,RC_MAT,RC_PD,RC_HORAS,RC_VALOR,RV_TIPOCOD"
		c_Query += " FROM " + RetSqlName("SRC") + " A, "+ RetSqlName("SRV") + " B"
		c_Query += " WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' '
		c_Query += " AND RC_PD = RV_COD"
		c_Query += " AND RC_PERIODO = '"+AnoMes(dRef)+"'"
		c_Query += " AND RC_ROTEIR = '"+cRoteiro+"'"
		c_Query += " AND RC_SEMANA = '"+cSemana+"'"
		c_Query += " AND RC_FILIAL = '" + SRA->RA_FILIAL + "'"
		c_Query += " AND RC_MAT = '"+ SRA->RA_MAT +"'"
		c_Query += " ORDER BY 3"
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Movimento Fechado - SRD                                       |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		c_Query := " SELECT RD_FILIAL RC_FILIAL,RD_MAT RC_MAT,RD_PD RC_PD,RD_HORAS RC_HORAS,RD_VALOR RC_VALOR,RV_TIPOCOD"
		c_Query += " FROM " + RetSqlName("SRD") + " A, "+ RetSqlName("SRV") + " B"
		c_Query += " WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' '
		c_Query += " AND RD_PD = RV_COD"
		c_Query += " AND RD_PERIODO = '"+AnoMes(dRef)+"'"
		c_Query += " AND RD_ROTEIR = '"+cRoteiro+"'"
		c_Query += " AND RD_SEMANA = '"+cSemana+"'"
		c_Query += " AND RD_FILIAL = '" + SRA->RA_FILIAL + "'"
		c_Query += " AND RD_MAT = '"+ SRA->RA_MAT +"'"
		c_Query += " ORDER BY 3"
	Endif

	TcQuery c_Query New Alias "WSRC"
	DbSelectArea("WSRC")
	While !WSRC->(Eof())
		If WSRC->RV_TIPOCOD == "1"
			fSomaPd("P",WSRC->RC_PD,WSRC->RC_HORAS,WSRC->RC_VALOR)
			TOTVENC += WSRC->RC_VALOR
		Elseif WSRC->RV_TIPOCOD == "2"
			fSomaPd("D",WSRC->RC_PD,WSRC->RC_HORAS,WSRC->RC_VALOR)
			TOTDESC += WSRC->RC_VALOR
		Elseif WSRC->RV_TIPOCOD == "3"
			fSomaPd("B",WSRC->RC_PD,WSRC->RC_HORAS,WSRC->RC_VALOR)
		Endif

		If cRoteiro == "ADI" .And. WSRC->RC_PD == aCodFol[10,1]
			nBaseIr := WSRC->RC_VALOR
		ElseIf WSRC->RC_PD == aCodFol[13,1]
			nAteLim += WSRC->RC_VALOR
		Elseif WSRC->RC_PD $ aCodFol[108,1]+'*'+aCodFol[17,1]
			nBaseFgts += WSRC->RC_VALOR
		Elseif WSRC->RC_PD $ aCodFol[109,1]+'*'+aCodFol[18,1]
			nFgts += WSRC->RC_VALOR
		Elseif WSRC->RC_PD == aCodFol[15,1]
			nBaseIr += WSRC->RC_VALOR
		Elseif WSRC->RC_PD == aCodFol[16,1]
			nBaseIrFe += WSRC->RC_VALOR
		Elseif WSRC->RC_PD == aCodFol[47,1]
			nLiquido := WSRC->RC_VALOR
		Endif

		WSRC->(dbSkip())
	Enddo

	WSRC->(dbCloseArea())


	dbSelectArea("SRA")

	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif

	fImpreGraf()

	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRA")
SET FILTER TO
RetIndex("SRA")

If !(Type("cArqNtx") == "U")
	fErase(cArqNtx + OrdBagExt())
Endif

Set Device To Screen

MS_FLUSH()

Return( )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpreGraf³ Autor ³ Primainfo             ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO FORMULARIO ZEBRADO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpreZebr()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpreGraf()

Local nConta    := nContr := nContrT:=0

If li >= 60
	li := 0
Endif

fCabecG()

fLancaG(nConta)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabecG   ³ Autor ³ Primainfo             ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabe‡alho Form ZEBRADO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabecG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCabecG()   // Cabecalho do Recibo Zebrado

Local  cStartPath	:= GetSrvProfString("Startpath","")

cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
cCodFunc		:= ""		//-- codigo da Funcao do funcionario

nLin := 50
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dbSelectArea('SR7')
dbSelectArea('SR3')
fBuscaFunc(aMesAnoRef[n_ContMes,2], @cCodFunc, @cDescFunc   )
oPrint:startpage()
oPrint:Box(nLin,120,3160,2200)
LinVer( @nlin, 40 )
oPrint:SayBitmap( 0070,0170,cStartPath+"lgrl"+FwCodEmp("SM0")+".bmp",200,100) // Tem que estar abaixo do RootPath
oPrint:Say(0080,0680,Desc_Fil , ArialN12B,,,,3)
oPrint:Say(0140,0680,Desc_End, ArialN12,,,,3)
oPrint:Say(0200,0680,"CNPJ  " + Transform(Desc_CGC,"@R 99.999.999/9999-99") , ArialN12,,,,3)
LinVer( @nlin, 225 )
oPrint:Box(nLin,120,3160,2200)
LinVer( @nlin, 30 )
oPrint:Say(nLin,0800,"RECIBO DE PAGAMENTO",TIMES20	,100)
LinVer( @nlin, 60 )
oPrint:Line(nlin,120, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Say(nlin,0130,"Empresa :" + DESC_Fil ,Tahoma10B	,100)
LinVer( @nlin, 40 )
oPrint:Line(nlin,120, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Say(nlin,0130,"Centro Custo :" + SRA->RA_CC + DescCc(SRA->RA_CC,SRA->RA_FILIAL)  + " Turno: "+ SRA->RA_TNOTRAB ,Tahoma10B	,100)
oPrint:Say(nlin,1450,IIF(cRoteiro="132","13 Salario",MesExtenso(MONTH(aMesAnoRef[n_ContMes,2])))+"/"+STR(YEAR(aMesAnoRef[n_ContMes,2]),4) ,Tahoma10B	,100)
LinVer( @nlin, 40 )
oPrint:Line(nlin,120, nLin, 2200)
LinVer( @nlin, 40 )
ORDEMZ ++
oPrint:Say(nlin,0130,"Matricula : " + SRA->RA_MAT + " Nome : " + SRA->RA_NOME  ,Tahoma10B	,100)
LinVer( @nlin, 40 )
oPrint:Line(nlin,120, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Say(nlin,0130,"Funcao    :  " +cCodFunc+" - "+cDescFunc ,Tahoma10B	,100)
LinVer( @nlin, 40 )
oPrint:Line(nlin,120, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Say(nlin,0150," P R O V E N T O S "  ,Tahoma10B	,100)
oPrint:Say(nlin,1350,"  D E S C O N T O S"  ,Tahoma10B	,100)
LinVer( @nlin, 40 )
oPrint:Line(nlin,120, nLin, 2200)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fLancaG   ³ Autor ³ Primainfo             ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) Grafico                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLancaG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLancaG(nConta)   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont     := 0

nTermina := Max(Max(Len(aProve),Len(aDesco)),0)

//Imprime os Proventos e Descontos
oPrint:Line(nLin,1120 ,2260,1120 )
For nCont := 1 To nTermina
	If nCont <= Len(aProve)
		oPrint:Say(nLin,0125,aProve[nCont,1],ArialN8	)
		oPrint:Say(nLin,0605,Transform(aProve[nCont,2],'@E 999.99'),ArialN8,,,,2	)
		oPrint:Say(nLin,0900,Transform(aProve[nCont,3],"@E 999,999,999.99"),ArialN8,,,,2	)
	EndIf
	IF nCont <= Len(aDesco)
		oPrint:Say(nLin,1125,aDesco[nCont,1],ArialN8)
		oPrint:Say(nLin,1685,TRANSFORM(aDesco[nCont,2],'@E 999.99'),ArialN8,,,,2)
		oPrint:Say(nLin,2000,TRANSFORM(aDesco[nCont,3],"@E 999,999,999.99"),ArialN8,,,,2)
	EndIf
	LinVer( @nlin, 40 )
Next
oPrint:Line(nLin,120, 2260, 2200)
nLin := 2260
LinVer( @nLin, 40 )
oPrint:Line(nLin,120, nLin, 2200)
LinVer( @nLin, 40 )

//Imprime Totais
oPrint:Say(nLin,0120,"TOTAL VENCIMENTOS",Tahoma10B	,100)
oPrint:Say(nLin,0855,Transform(TOTVENC,cPict1),Tahoma10	,100)
oPrint:Say(nLin,1105,"TOTAL DESCONTOS",Tahoma10B	,100)
oPrint:Say(nLin,1905,Transform(TOTDESC,cPict1),Tahoma10	,100)
LinVer( @nlin, 40 )
oPrint:Line(nLin,120, nLin, 2200)
LinVer( @nlin, 40 )

//Imprime Liquido
oPrint:Say(nLin,0120,"SALARIO BASE",Tahoma10B	,100)

nValSal := 0
nValSal := fBuscaSal(aMesAnoRef[n_ContMes,2])
If nValSal ==0
	nValSal := SRA->RA_SALARIO
EndIf

oPrint:Say(nLin,0855,Transform(nValSal,cPict1),Tahoma10	,100)///MARCO
oPrint:Say(nLin,1105,"LIQUIDO A RECEBER     ",Tahoma10B	,100)
oPrint:Say(nLin,1905,Transform((TOTVENC-TOTDESC),cPict1),Tahoma10	,100)
LinVer( @nlin, 40 )
oPrint:Line(nLin,120, nLin, 2200)
LinVer( @nlin, 30 )
//Imprime Bases
oPrint:Say(nLin,0120,"BASE LIMITE INSS: "+Transform(nAteLim,cPict1)+ "    BASE FGTS: "+Transform(nBaseFgts,cPict1)+"    FGTS DEPOSITADO: "+Transform(nFgts,cPict2)+ "     BASE IRRF: "+Transform(nBaseIr,cPict1),Tahoma08B	,100)
//oPrint:Say(nLin,0290,Transform(nAteLim,cPict1),Tahoma08	,100)
//oPrint:Say(nLin,0550,"BASE FGTS:",Tahoma08B	,100)
//oPrint:Say(nLin,0780,Transform(nBaseFgts,cPict1),Tahoma08	,100)
//oPrint:Say(nLin,1050,"FGTS DEPOSITADO:",Tahoma08B	,100)
//oPrint:Say(nLin,1350,Transform(nFgts,cPict2),Tahoma08	,100)
//oPrint:Say(nLin,1600,"BASE IRRF",Tahoma08b	,100)
//oPrint:Say(nLin,1750,Transform(nBaseIr,cPict1),Tahoma08	,100)
LinVer( @nlin, 30 )
oPrint:Line(nLin,120, nLin, 2200)
//Imprime Mensagens
LinVer( @nlin, 40 )
oPrint:Say(nLin,120,DESC_MSG1,Tahoma10,100)
LinVer( @nlin, 40 )
oPrint:Line(nLin,120, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Say(nLin,120,DESC_MSG2,Tahoma10	,100)
LinVer( @nlin, 40 )
oPrint:Line(nLin,120, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Say(nLin,120,DESC_MSG3,Tahoma10	,100)
LinVer( @nlin, 40 )
oPrint:Line(nLin,120, nLin, 2200)
LinVer( @nlin, 40 )
If Month(aMesAnoRef[n_ContMes,2]) = Month(SRA->RA_NASC)
	oPrint:Say(nLin,150,"F E L I Z   A N I V E R S A R I O  ! !",Tahoma10	,100)
	LinVer( @nlin, 40 )
Else
	oPrint:Line(nLin,120, nLin, 2200)
	LinVer( @nlin, 40 )
EndIf
oPrint:Line(nLin,120, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Say(nLin,130,"CREDITO: Banco: "+Subs(SRA->RA_BCDEPSAL,1,3) + "              Agencia: " +Subs(SRA->RA_BCDEPSAL,4,5) +"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+"           Conta:"+SRA->RA_CTDEPSAL,ArialN10B	,100)
LinVer( @nlin, 40 )
oPrint:Line(nLin,130, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Say(nLin,130,"Valido como Comprovante Mensal de Rendimentos - (Artigo 41 e 464 da CLT, Portaria MTPS/GM 3.626 de 13/11/1991)",ArialN10B	,100)
LinVer( @nlin, 40 )
oPrint:Line(nLin,120, nLin, 2200)
LinVer( @nlin, 40 )
oPrint:Endpage()
nLin := 0

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSomaPd   ³ Autor ³ Primainfo             ³ Data ³ 24.09.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSomaPd(Tipo,Verba,Horas,Valor)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSomaPd(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
	Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
Endif

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³LinVer    ³ Autor ³ Primainfo             ³ Data ³19.05.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Linhas e Quebras do Relatório                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LinVer(nLin,nSoma)

nLin+=nSoma
If nLin > 3160
	oPrint:Endpage()
	oPrint:Startpage()
	fCabecG()
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³fMasPerg  º Autor ³ AP6 IDE            º Data ³  17/03/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß /*/
Static Function fMasPerg

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//          Grupo/Ordem    /Pergunta/ /                                                        /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2          /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04    /Cnt04    /Var05  /Def05	/Cnt05  /XF3
Aadd(aRegs,{cPerg,"01","Data de Refer. De  ?","Data      ?","Data      ?","mv_ch1","D",08,0,0,"G" ,""               ,"mv_par01","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","   ",""})
Aadd(aRegs,{cPerg,"02","Data de Refer. Ate ?","Data      ?","Data      ?","mv_ch2","D",08,0,0,"G" ,""               ,"mv_par02","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","   ",""})
Aadd(aRegs,{cPerg,"03","Roteiro            ?","Roteiro   ?","Roteiro   ?","mv_ch3","C",03,0,0,"G" ,""               ,"mv_par03","","","","","","","","","","","","","","","","","","","","",""	,""	,"","","SRY",""})
Aadd(aRegs,{cPerg,"04","Numero Pagto       ?","Semana    ?","Semana    ?","mv_ch4","C",02,0,0,"G" ,""               ,"mv_par04","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","   ",""})
Aadd(aRegs,{cPerg,"05","Filial de          ?","Filial    ?","Filial    ?","mv_ch5","C",02,0,0,"G" ,""               ,"mv_par05","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","XM0",""})
Aadd(aRegs,{cPerg,"06","Filial Ate         ?","Filial    ?","Filial    ?","mv_ch6","C",02,0,0,"G" ,""               ,"mv_par06","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","XM0",""})
Aadd(aRegs,{cPerg,"07","C.Custo de         ?","C.Custo de?","C.Custo de?","mv_ch7","C",09,0,0,"G" ,""               ,"mv_par07","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","CTT",""})
Aadd(aRegs,{cPerg,"08","C.Custo Ate        ?","C.Custo At?","C.Custo At?","mv_ch8","C",09,0,0,"G" ,""               ,"mv_par08","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","CTT",""})
Aadd(aRegs,{cPerg,"09","Matricula de       ?","Matrcicula?","Matricula ?","mv_ch9","C",06,0,0,"G" ,""               ,"mv_par09","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SRA",""})
Aadd(aRegs,{cPerg,"10","Matricula Ate      ?","Matricula ?","Matricula ?","mv_cha","C",06,0,0,"G" ,""               ,"mv_par10","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SRA",""})
Aadd(aRegs,{cPerg,"11","Nome de            ?","Nome      ?","Nome      ?","mv_chb","C",30,0,0,"G" ,""               ,"mv_par11","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","   ",""})
Aadd(aRegs,{cPerg,"12","Nome Ate           ?","Nome      ?","Nome      ?","mv_chc","C",30,0,0,"G" ,""               ,"mv_par12","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","   ",""})
Aadd(aRegs,{cPerg,"13","Mensagem 1         ?","Mensagem  ?","Mensagem  ?","mv_chd","C",60,0,0,"G" ,""               ,"mv_par13","","","","","","","","","","","","","","","","","","","","",""	,""	,"","",""   ,""})
Aadd(aRegs,{cPerg,"14","Mensagem 2         ?","Mensagem  ?","Mensagem  ?","mv_che","C",60,0,0,"G" ,""               ,"mv_par14","","","","","","","","","","","","","","","","","","","","",""	,""	,"","",""   ,""})
Aadd(aRegs,{cPerg,"15","Mensagem 3         ?","Mensagem  ?","Mensagem  ?","mv_chf","C",60,0,0,"G" ,""               ,"mv_par15","","","","","","","","","","","","","","","","","","","","",""	,""	,"","",""   ,""})
Aadd(aRegs,{cPerg,"16","Sit.Folha          ?","Sit.Folha ?","Sit.Folha ?","mv_chg","C",05,0,0,"G" ,"fSituacao"      ,"mv_par16","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","",""   ,""})
Aadd(aRegs,{cPerg,"17","Categoria          ?","Categoria ?","Categoria ?","mv_chh","C",10,0,0,"G" ,"fCategoria"     ,"mv_par17","","","","","","","","","","","","","","","","","","","","",""	,""	,"","",""   ,""})
Aadd(aRegs,{cPerg,"18","Data Demissao De   ?","Data      ?","Data      ?","mv_chi","D",08,0,0,"G" ,""               ,"mv_par18","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","   ",""})
Aadd(aRegs,{cPerg,"19","Data Demissao Ate  ?","Data      ?","Data      ?","mv_chj","D",08,0,0,"G" ,""               ,"mv_par19","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","   ",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f_xValRCH ºAutor  ³ Primainfo          º Data ³  09/24/17 ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o Calendario, roteiro e Numero Pagamento            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xValRCH(c_xproc,c_xAnoMes,c_xNump,c_xRot)

Local a_Area 	:= GetArea()
Local n_Ret		:= 0 //0 - Periodo em Aberto;1-Periodo Fechado;3-Periodo nao encontrado
Local c_FilRCH	:= IIf(!Empty(xFilial("RCH")),SRA->RA_FILIAL,xFilial("RCH"))

dbSelectArea("RCH")
dbSetOrder(1)
If dbSeek(c_FilRCH + c_xproc + c_xAnoMes + c_xNump + c_xRot)
	If !Empty(RCH->RCH_DTFECH)
		n_Ret := 1
	Endif
Else
	n_Ret := 2
Endif

RestArea(a_Area)

Return(n_Ret)