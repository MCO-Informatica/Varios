#include "TOTVS.CH"
#include "TOPCONN.CH"

//Define variavel para saltar de linha
#DEFINE ENTER		Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSCTB01   º Autor ³ Renato Ruy         º Data ³  04/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta através das Notas de Entrada e Saída lançamentos  º±±
±±º          ³ padrões gerados através das mesmas.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contábil                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSCTB01(cOrigem,CSPAR1,CSPAR2,CSPAR3,CSPAR4,CSPAR5)

Local cFilial  := ""
Local cNota    := ""
Local cSerie   := ""
Local cCliefor := ""
Local cLoja    := ""
Local cNome    := ""
Local cTitulo  := ""
Local cPrefixo := ""
Local cParcela := ""
Local dEmissao, dVencimento := CtoD("  /  /  ")

// Cria dialogo
Private oDlg := MSDialog():New(001,001,400,700,'Rastreio de Lançamento Contábil',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

Private cFiltro := ""
Private aHeader := {}
Private aCols   := {}
Private cMsgCC,cMsgCC2  := ""

//Cria cabecalho do aCols
Aadd(aHeader,{'Lote'		,"CTK_LOTE"	 ,"@!"				 ,6 ,0,"AllWaysTrue()","û","C","",,,,,,, } )
Aadd(aHeader,{'Data'		,"CTK_DATA"	 ,"@D"				 ,8 ,0,"AllWaysTrue()","û","C","",,,,,,, } )
Aadd(aHeader,{'Cta.Debito'	,"CTK_DEBITO","@!"				 ,9 ,0,"AllWaysTrue()","û","C","CT1",,,,,,, } )
Aadd(aHeader,{'Cta.Credito'	,"CTK_CREDIT","@!"				 ,9 ,0,"AllWaysTrue()","û","C","CT1",,,,,,, } )
Aadd(aHeader,{'Valor'		,"CTK_VLR01" ,"@E 999,999,999.99",15,2,"AllWaysTrue()","û","C","",,,,,,, } )
Aadd(aHeader,{'C.C.Debito'	,"CTK_CCD"	,"@!"				 ,8 ,0,"AllWaysTrue()","û","C","CTT",,,,,,, } )
Aadd(aHeader,{'C.C.Credito'	,"CTK_CCC"	,"@!"				 ,8 ,0,"AllWaysTrue()","û","C","CTT",,,,,,, } )
Aadd(aHeader,{'Lanc.Padrao'	,"CTK_LP"	,"@!"				 ,8 ,0,"AllWaysTrue()","û","C","CT5",,,,,,, } )
Aadd(aHeader,{'Seq.Lanc.Pad',"CTK_LPSEQ","@!"				 ,8 ,0,"AllWaysTrue()","û","C","",,,,,,, } )
Aadd(aHeader,{'Historico'	,"CTK_HIST"	,"@!"				 ,40,0,"AllWaysTrue()","û","C","",,,,,,, } )

aadd(aCols,Array(Len(aHeader)+1))
For i := 1 to Len(aHeader)
	aCols[Len(aCols),i] := Criavar(aHeader[i,2])
Next
acols[1,len(aheader)+1]:=.f.

//oGet := MSNewGetDados():New(060,010,160,340,GD_INSERT + GD_DELETE + GD_UPDATE,.T.,.T.,"",nil,,,,,.T.,oDlg,aHeader,aCols)
oGet := MSNewGetDados():New(090,010,160,340,,.T.,.T.,"",nil,,,,,.T.,oDlg,aHeader,aCols,{||ExeCC()})

@ 001,001 TO 073,350 of oDlg Pixel

@ 080,001 TO 165,350 of oDlg Pixel

If cOrigem == "SF1" //Consulta Nota Fiscal de Entrada
	
	If SF1->F1_DTLANC == CtoD("  /  /  ")
		MsgInfo("Não existe lançamento contábil para esta Nota de Entrada.")
		Return()
	EndIf
	
	//Busca Nome do Fornecedor.
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek( xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA )
	
	//Carrega dados dos titulos para ser usado nos lançamentos / na MsGet.
	
	cQuery := " SELECT "
	cQuery += "         E2_NUM, "
	cQuery += "         E2_PREFIXO, "
	cQuery += "         E2_PARCELA, "
	cQuery += "         E2_FORNECE, "
	cQuery += "         E2_LOJA,    "
	cQuery += "         E2_NOMFOR,  "
	cQuery += "         E2_EMISSAO, "
	cQuery += "         E2_VENCREA, "
	cQuery += "         E2_VALOR,   "
	cQuery += "         E2_BAIXA,   "
	cQuery += "         E5_DATA,    "
	cQuery += "         E5_HISTOR,  "
	cQuery += "         E5_VALOR,   "
	cQuery += "         SE5.R_E_C_N_O_ RECSE5, "
	cQuery += "         SE2.R_E_C_N_O_ RECSE2 "
	cQuery += "         FROM " + RetSqlName("SE2") + " SE2 "
	cQuery += " LEFT JOIN  " + RetSqlName("SE5") + " SE5 "
	cQuery += " ON E5_FILIAL = E2_FILIAL AND E5_NUMERO = E2_NUM AND E5_PREFIXO = E2_PREFIXO AND E5_CLIFOR = E2_FORNECE AND E5_LOJA = E2_LOJA AND SE5.D_E_L_E_T_ = ' '"
	cQuery += " WHERE "
	cQuery += " E2_FILIAL = '  ' AND "
	cQuery += " E2_NUM = '" + SF1->F1_DOC + "' AND "
	cQuery += " E2_PREFIXO = '" + SF1->F1_PREFIXO + "' AND  "
	cQuery += " E2_FORNECE = '" + SF1->F1_FORNECE + "' AND "
	cQuery += " E2_LOJA = '" + SF1->F1_LOJA + "' AND "
	cQuery += " SE2.D_E_L_E_T_ = ' ' "
	cQuery := CHANGEQUERY(cQuery)
	
	If Select("TITPA") > 0
		DbSelectArea("TITPA")
		TITPA->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TITPA"
	
	
	
	//Carrega campos para ser usado na MsGet.
	cFilial		:= SF1->F1_FILIAL
	cNota		:= SF1->F1_DOC
	cSerie		:= SF1->F1_SERIE
	cCliefor	:= SF1->F1_FORNECE
	cLoja		:= SF1->F1_LOJA
	cNome		:= SA2->A2_NOME
	cTitulo		:= TITPA->E2_NUM
	cPrefixo	:= TITPA->E2_PREFIXO
	cParcela	:= TITPA->E2_PARCELA
	dEmissao	:= StoD(TITPA->E2_EMISSAO)
	dVencimento	:= StoD(TITPA->E2_VENCREA)
	
	DbSelectArea("TITPA")
	DbGoTop()
	
	cFiltro := ""
	
	while !eof("TITPA")
		
		If Empty(cFiltro)
			cFiltro := " ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITPA->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITPA->RECSE5)) + "' AND D_E_L_E_T_ = ' ' ) OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITPA->E2_EMISSAO + "' AND CTK_RECORI = '" + AllTrim(Str(TITPA->RECSE2)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		Else
			cFiltro += " OR  ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITPA->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITPA->RECSE5)) + "' AND D_E_L_E_T_ = ' ' ) OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITPA->E2_EMISSAO + "' AND CTK_RECORI = '" + AllTrim(Str(TITPA->RECSE2)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		EndIf
		
		DbSelectArea("TITPA")
		DbSkip()
	EndDo
	
	
	//Chamo a Função para atualizar o aCols
	AtuLanc(cOrigem,CSPAR1,CSPAR2,CSPAR3,CSPAR4,CSPAR5,cFiltro)
	
ElseIf cOrigem == "SF2"  //Consulta Nota Fiscal de Saída
	
	If SF2->F2_DTLANC == CtoD("  /  /  ")
		MsgInfo("Não existe lançamento contábil para esta Nota de Entrada.")
		Return()
	EndIf
	
	//Busca Nome do Cliente.
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek( xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA )
	
	//Carrega dados dos titulos para ser usado nos lançamentos / na MsGet.
	
	cQuery := " SELECT "
	cQuery += "         E1_NUM, "
	cQuery += "         E1_PREFIXO, "
	cQuery += "         E1_PARCELA, "
	cQuery += "         E1_CLIENTE, "
	cQuery += "         E1_LOJA,    "
	cQuery += "         E1_NOMCLI,  "
	cQuery += "         E1_EMISSAO, "
	cQuery += "         E1_VENCREA, "
	cQuery += "         E1_VALOR,   "
	cQuery += "         E1_BAIXA,   "
	cQuery += "         E5_DATA,    "
	cQuery += "         E5_HISTOR,  "
	cQuery += "         E5_VALOR,   "
	cQuery += "         SE5.R_E_C_N_O_ RECSE5, "
	cQuery += "         SE1.R_E_C_N_O_ RECSE1 "
	cQuery += "         FROM " + RetSqlName("SE1") + " SE1 "
	cQuery += " LEFT JOIN  " + RetSqlName("SE5") + " SE5 "
	cQuery += " ON E5_FILIAL = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_CLIFOR = E1_CLIENTE AND E5_LOJA = E1_LOJA AND SE5.D_E_L_E_T_ = ' '"
	cQuery += " WHERE "
	cQuery += " E1_FILIAL = '  ' AND "
	cQuery += " E1_NUM = '" + SF2->F2_DOC + "' AND "
	cQuery += " E1_PREFIXO = '" + SF2->F2_PREFIXO + "' AND  "
	cQuery += " E1_CLIENTE = '" + SF2->F2_CLIENTE + "' AND "
	cQuery += " E1_LOJA = '" + SF2->F2_LOJA + "' AND "
	cQuery += " SE1.D_E_L_E_T_ = ' ' "
	cQuery := CHANGEQUERY(cQuery)
	
	If Select("TITRE") > 0
		DbSelectArea("TITRE")
		TITRE->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TITRE"
	
	//Carrega campos para ser usado na MsGet.
	cFilial		:= SF2->F2_FILIAL
	cNota		:= SF2->F2_DOC
	cSerie		:= SF2->F2_SERIE
	cCliefor	:= SF2->F2_CLIENTE
	cLoja		:= SF2->F2_LOJA
	cNome		:= SA1->A1_NOME
	cTitulo		:= TITRE->E1_NUM
	cPrefixo	:= TITRE->E1_PREFIXO
	cParcela	:= TITRE->E1_PARCELA
	dEmissao	:= StoD(TITRE->E1_EMISSAO)
	dVencimento	:= StoD(TITRE->E1_VENCREA)
	
	DbSelectArea("TITRE")
	DbGoTop()
	
	cFiltro := ""
	
	while !eof("TITRE")
		
		If Empty(cFiltro)
			cFiltro := " ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITRE->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITRE->RECSE5)) + "' AND D_E_L_E_T_ = ' ' )  OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITRE->E1_EMISSAO + "' AND CTK_RECORI = '" + AllTrim(Str(TITRE->RECSE1)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		Else
			cFiltro += " OR  ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITRE->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITRE->RECSE5)) + "' AND D_E_L_E_T_ = ' ' )  OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITRE->E1_EMISSAO + "' AND CTK_RECORI = '" + AllTrim(Str(TITRE->RECSE1)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		EndIf
		
		DbSelectArea("TITRE")
		DbSkip()
	EndDo
	
	//Chamo a Função para atualizar o aCols
	AtuLanc(cOrigem,CSPAR1,CSPAR2,CSPAR3,CSPAR4,CSPAR5,cFiltro)
	
ElseIf cOrigem == "SE2"  //Consulta Titulo a Receber
	
	//Busca Nome do Cliente.
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek( xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA )
	
	//Carrega dados dos titulos para ser usado nos lançamentos / na MsGet.
	
	cQuery := " SELECT "
	cQuery += "         E2_NUM, "
	cQuery += "         E2_PREFIXO, "
	cQuery += "         E2_PARCELA, "
	cQuery += "         E2_FORNECE, "
	cQuery += "         E2_LOJA,    "
	cQuery += "         E2_NOMFOR,  "
	cQuery += "         E2_EMISSAO, "
	cQuery += "         E2_VENCREA, "
	cQuery += "         E2_VALOR,   "
	cQuery += "         E2_BAIXA,   "
	cQuery += "         E5_DATA,    "
	cQuery += "         E5_HISTOR,  "
	cQuery += "         E5_VALOR,   "
	cQuery += "         SE5.R_E_C_N_O_ RECSE5, "
	cQuery += "         SE2.R_E_C_N_O_ RECSE2 "
	cQuery += "         FROM " + RetSqlName("SE2") + " SE2 "
	cQuery += " LEFT JOIN  " + RetSqlName("SE5") + " SE5 "
	cQuery += " ON E5_FILIAL = E2_FILIAL AND E5_NUMERO = E2_NUM AND E5_PREFIXO = E2_PREFIXO AND E5_CLIFOR = E2_FORNECE AND E5_LOJA = E2_LOJA AND SE5.D_E_L_E_T_ = ' '"
	cQuery += " WHERE "
	cQuery += " SE2.R_E_C_N_O_ = '" + AllTrim(Str(CSPAR5)) + "' AND "
	cQuery += " SE2.D_E_L_E_T_ = ' ' "
	cQuery := CHANGEQUERY(cQuery)
	
	If Select("TITSE2") > 0
		DbSelectArea("TITSE2")
		TITSE2->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TITSE2"
	
	//Busca Nome do Cliente.
	DbSelectArea("SF1")
	DbSetOrder(2)
	If DbSeek( xFilial("SF1") + CSPAR2 + CSPAR3 + CSPAR1 )
		
		//Carrega campos para ser usado na MsGet.
		cFilial		:= SF1->F1_FILIAL
		cNota		:= SF1->F1_DOC
		cSerie		:= SF1->F1_SERIE
		
	ELSE
		
		//Carrega campos para ser usado na MsGet.
		cFilial		:= "  "
		cNota		:= "         "
		cSerie		:= "   "
		
	EndIf
	
	cCliefor	:= SE2->E2_FORNECE
	cLoja		:= SE2->E2_LOJA
	cNome		:= SA2->A2_NOME
	cTitulo		:= TITSE2->E2_NUM
	cPrefixo	:= TITSE2->E2_PREFIXO
	cParcela	:= TITSE2->E2_PARCELA
	dEmissao	:= StoD(TITSE2->E2_EMISSAO)
	dVencimento	:= StoD(TITSE2->E2_VENCREA)
	
	DbSelectArea("TITSE2")
	DbGoTop()
	
	cFiltro := ""
	
	while !eof("TITSE2")
		
		If Empty(cFiltro)
			cFiltro := " ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE2->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE2->RECSE5)) + "' AND D_E_L_E_T_ = ' ' )  OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE2->E2_EMISSAO + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE2->RECSE2)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		Else
			cFiltro += " OR  ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE2->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE2->RECSE5)) + "' AND D_E_L_E_T_ = ' ' )  OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE2->E2_EMISSAO + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE2->RECSE2)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		EndIf
		
		DbSelectArea("TITSE2")
		DbSkip()
	EndDo
	
	//Chamo a Função para atualizar o aCols
	AtuLanc(cOrigem,CSPAR1,CSPAR2,CSPAR3,SF1->F1_DTLANC,SF1->(RECNO()),cFiltro)
	
ElseIf cOrigem == "SE1"  //Consulta Titulo a Receber
	
	//Busca Nome do Cliente.
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA )
	
	//Carrega dados dos titulos para ser usado nos lançamentos / na MsGet.
	
	cQuery := " SELECT "
	cQuery += "         E1_NUM, "
	cQuery += "         E1_PREFIXO, "
	cQuery += "         E1_PARCELA, "
	cQuery += "         E1_CLIENTE, "
	cQuery += "         E1_LOJA,    "
	cQuery += "         E1_NOMCLI,  "
	cQuery += "         E1_EMISSAO, "
	cQuery += "         E1_VENCREA, "
	cQuery += "         E1_VALOR,   "
	cQuery += "         E1_BAIXA,   "
	cQuery += "         E5_DATA,    "
	cQuery += "         E5_HISTOR,  "
	cQuery += "         E5_VALOR,   "
	cQuery += "         SE5.R_E_C_N_O_ RECSE5, "
	cQuery += "         SE1.R_E_C_N_O_ RECSE1 "
	cQuery += "         FROM " + RetSqlName("SE1") + " SE1 "
	cQuery += " LEFT JOIN  " + RetSqlName("SE5") + " SE5 "
	cQuery += " ON E5_FILIAL = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_CLIFOR = E1_CLIENTE AND E5_LOJA = E1_LOJA AND SE5.D_E_L_E_T_ = ' '"
	cQuery += " WHERE "
	cQuery += " SE1.R_E_C_N_O_ = '" + AllTrim(Str(CSPAR5)) + "' AND "
	cQuery += " SE1.D_E_L_E_T_ = ' ' "
	cQuery := CHANGEQUERY(cQuery)
	
	If Select("TITSE1") > 0
		DbSelectArea("TITSE1")
		TITSE1->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TITSE1"
	
	//Busca Nome do Cliente.
	DbSelectArea("SF2")
	DbSetOrder(2)
	If DbSeek( xFilial("SF2") + CSPAR2 + CSPAR3 + CSPAR1 )
		
		//Carrega campos para ser usado na MsGet.
		cFilial		:= SF2->F2_FILIAL
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
		
	ELSE
		
		//Carrega campos para ser usado na MsGet.
		cFilial		:= "  "
		cNota		:= "         "
		cSerie		:= "   "
		
	EndIf
	
	cCliefor	:= SE1->E1_CLIENTE
	cLoja		:= SE1->E1_LOJA
	cNome		:= SA1->A1_NOME
	cTitulo		:= TITSE1->E1_NUM
	cPrefixo	:= TITSE1->E1_PREFIXO
	cParcela	:= TITSE1->E1_PARCELA
	dEmissao	:= StoD(TITSE1->E1_EMISSAO)
	dVencimento	:= StoD(TITSE1->E1_VENCREA)
	
	DbSelectArea("TITSE1")
	DbGoTop()
	
	cFiltro := ""
	
	while !eof("TITSE1")
		
		If Empty(cFiltro)
			cFiltro := " ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE1->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE1->RECSE5)) + "' AND D_E_L_E_T_ = ' ' )  OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE1->E1_EMISSAO + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE1->RECSE1)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		Else
			cFiltro += " OR  ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE1->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE1->RECSE5)) + "' AND D_E_L_E_T_ = ' ' )  OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE1->E1_EMISSAO + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE1->RECSE1)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		EndIf
		
		DbSelectArea("TITSE1")
		DbSkip()
	EndDo
	
	//Chamo a Função para atualizar o aCols
	AtuLanc(cOrigem,CSPAR1,CSPAR2,CSPAR3,SF2->F2_DTLANC,SF2->(RECNO()),cFiltro)
	
ElseIf cOrigem == "SE5"  //Consulta Titulo a Receber
	
	If SE5->E5_LA != "S"
		MsgInfo("Não existe lançamento contábil para este Movimento Financeiro.")
		Return()
	EndIf
	//Carrega dados dos titulos para ser usado nos lançamentos / na MsGet.
	
	cQuery := " SELECT "
	cQuery += "         E5_NUMERO,  "
	cQuery += "         E5_PREFIXO, "
	cQuery += "         E5_PARCELA, "
	cQuery += "         E5_CLIFOR , "
	cQuery += "         E5_RECPAG,  "
	cQuery += "         E5_CLIFOR,  "
	cQuery += "         E5_LOJA, 	"
	cQuery += "         E5_DATA, 	"
	cQuery += "         E5_VALOR,   "
	cQuery += "         E5_VENCTO,   "
	cQuery += "         E5_HISTOR,  "
	cQuery += "         SE5.R_E_C_N_O_ RECSE5, "
	cQuery += "         SE1.R_E_C_N_O_ RECSE1 "
	cQuery += "         FROM " + RetSqlName("SE5") + " SE5 "
	cQuery += " LEFT JOIN  " + RetSqlName("SE1") + " SE1 "
	cQuery += " ON E5_FILIAL = E1_FILIAL AND E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_CLIFOR = E1_CLIENTE AND E5_LOJA = E1_LOJA AND SE1.D_E_L_E_T_ = ' '"
	cQuery += " WHERE "
	cQuery += " SE5.R_E_C_N_O_ = '" + AllTrim(Str(CSPAR5)) + "' AND "
	cQuery += " SE5.E5_RECPAG  = 'R' AND "
	cQuery += " SE5.D_E_L_E_T_ = ' ' "
	cQuery += " UNION ALL "
	cQuery += " SELECT "
	cQuery += "         E5_NUMERO,  "
	cQuery += "         E5_PREFIXO, "
	cQuery += "         E5_PARCELA, "
	cQuery += "         E5_CLIFOR , "
	cQuery += "         E5_RECPAG,  "
	cQuery += "         E5_CLIFOR,  "
	cQuery += "         E5_LOJA, 	"
	cQuery += "         E5_DATA, 	"
	cQuery += "         E5_VALOR,   "
	cQuery += "         E5_VENCTO,   "
	cQuery += "         E5_HISTOR,  "
	cQuery += "         SE5.R_E_C_N_O_ RECSE5, "
	cQuery += "         SE1.R_E_C_N_O_ RECSE1 "
	cQuery += "         FROM " + RetSqlName("SE5") + " SE5 "
	cQuery += " LEFT JOIN  " + RetSqlName("SE2") + " SE1 "
	cQuery += " ON E5_FILIAL = E2_FILIAL AND E5_NUMERO = E2_NUM AND E5_PREFIXO = E2_PREFIXO AND E5_CLIFOR = E2_FORNECE AND E5_LOJA = E2_LOJA AND SE1.D_E_L_E_T_ = ' '"
	cQuery += " WHERE "
	cQuery += " SE5.R_E_C_N_O_ = '" + AllTrim(Str(CSPAR5)) + "' AND "
	cQuery += " SE5.E5_RECPAG  = 'P' AND "
	cQuery += " SE5.D_E_L_E_T_ = ' ' "
	cQuery := CHANGEQUERY(cQuery)
	
	If Select("TITSE5") > 0
		DbSelectArea("TITSE5")
		TITSE5->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TITSE5"
	
	DbSelectArea("TITSE5")
	
	If TITSE5->E5_RECPAG == "R" //Se o movimento for a receber
		
		//Se Posiciona no cliente
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek( xFilial("SA1") + TITSE5->E5_CLIFOR + TITSE5->E5_LOJA )
		
		//Busca Nome do Cliente.
		DbSelectArea("SF2")
		DbSetOrder(2)
		If DbSeek( xFilial("SF2") + TITSE5->E5_CLIFOR + TITSE5->E5_LOJA + TITSE5->E5_NUMERO )
			
			//Carrega campos para ser usado na MsGet.
			cFilial		:= SF2->F2_FILIAL
			cNota		:= SF2->F2_DOC
			cSerie		:= SF2->F2_SERIE
			
		ELSE
			
			//Carrega campos para ser usado na MsGet.
			cFilial		:= "  "
			cNota		:= "         "
			cSerie		:= "   "
			
		EndIf
		
		cCliefor	:= SA1->A1_COD
		cLoja		:= SA1->A1_LOJA
		cNome		:= SA1->A1_NOME
		cTitulo		:= TITSE5->E5_NUMERO
		cPrefixo	:= TITSE5->E5_PREFIXO
		cParcela	:= TITSE5->E5_PARCELA
		dEmissao	:= StoD(TITSE5->E5_DATA)
		dVencimento	:= StoD(TITSE5->E5_VENCTO)
	EndIf
	
	If TITSE5->E5_RECPAG == "P" //Se for movimento a pagar
		
		//Se Posiciona no cliente
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek( xFilial("SA2") + TITSE5->E5_CLIFOR + TITSE5->E5_LOJA )
		
		//Busca Nome do Cliente.
		DbSelectArea("SF1")
		DbSetOrder(2)
		If DbSeek( xFilial("SF1") + TITSE5->E5_CLIFOR + TITSE5->E5_LOJA + TITSE5->E5_NUMERO )
			
			//Carrega campos para ser usado na MsGet.
			cFilial		:= SF1->F1_FILIAL
			cNota		:= SF1->F1_DOC
			cSerie		:= SF1->F1_SERIE
			
		ELSE
			
			//Carrega campos para ser usado na MsGet.
			cFilial		:= "  "
			cNota		:= "         "
			cSerie		:= "   "
			
		EndIf
		
		cCliefor	:= SA2->A2_COD
		cLoja		:= SA2->A2_LOJA
		cNome		:= SA2->A2_NOME
		cTitulo		:= TITSE5->E5_NUMERO
		cPrefixo	:= TITSE5->E5_PREFIXO
		cParcela	:= TITSE5->E5_PARCELA
		dEmissao	:= StoD(TITSE5->E5_DATA)
		dVencimento	:= StoD(TITSE5->E5_VENCTO)
	EndIf
	
	DbSelectArea("TITSE5")
	DbGoTop()
	
	cFiltro := ""
	
	while !eof("TITSE5")
		
		If Empty(cFiltro)
			cFiltro := " ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE5->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE5->RECSE5) + "' AND CTK_TABORI = 'SE5' ") + " AND D_E_L_E_T_ = ' ' )  OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE5->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE5->RECSE1)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		Else
			cFiltro += " OR  ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE5->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE5->RECSE5) + "' AND CTK_TABORI = 'SE5' ") + " AND D_E_L_E_T_ = ' ' )  OR ( CTK_FILIAL = '  ' AND CTK_DATA = '" + TITSE5->E5_DATA + "' AND CTK_RECORI = '" + AllTrim(Str(TITSE5->RECSE1)) + "' AND D_E_L_E_T_ = ' ' ) " + ENTER
		EndIf
		
		DbSelectArea("TITSE5")
		DbSkip()
	EndDo
	
	//Chamo a Função para atualizar o aCols
	AtuLanc(cOrigem,CSPAR1,CSPAR2,CSPAR3,SF2->F2_DTLANC,SF2->(RECNO()),cFiltro)
	
EndIf

//Campos para exibir os dados na MsDialog.

@ 006,035 Say " Nota: " of oDlg Pixel
@ 003,050 MSGET cNota SIZE 30,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 006,110 Say " Série: " of oDlg Pixel
@ 003,130 MSGET cSerie SIZE 05,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 022,005 Say " Cliente/Fornece: " of oDlg Pixel
@ 020,050 MSGET cCliefor SIZE 20,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 022,110 Say " Loja: " of oDlg Pixel
@ 020,130 MSGET cLoja SIZE 10,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 022,180 Say " Nome: " of oDlg Pixel
@ 020,200 MSGET cNome SIZE 140,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 040,030 Say " Titulo: " of oDlg Pixel
@ 038,050 MSGET cTitulo SIZE 30,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 040,105 Say " Prefixo: " of oDlg Pixel
@ 038,130 MSGET cPrefixo SIZE 30,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 040,175 Say " Parcela: " of oDlg Pixel
@ 038,200 MSGET cParcela SIZE 30,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 057,025 Say " Emissão: " of oDlg Pixel
@ 055,050 MSGET dEmissao SIZE 20,11 OF oDlg PIXEL PICTURE "@D" WHEN .F.

@ 057,095 Say " Vencimento: " of oDlg Pixel
@ 055,130 MSGET dVencimento SIZE 30,11 OF oDlg PIXEL PICTURE "@D" WHEN .F.

@ 170,010 Say " Descrição Conta Débito: " OF oDlg Pixel

@ 185,010 Say " Descrição Conta Crédito: " OF oDlg Pixel

// Ativa diálogo centralizado
//oDlg:Activate(,,,.T.,{||msgstop('validou!'),.T.},,{||msgstop('iniciando…')} )
@ 170,290 BUTTON "Fechar"  SIZE 40,20 PIXEL OF oDlg ACTION (oDlg:End())
oDlg:Activate(,,,.T.,,, )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSCTB01   º Autor ³ Renato Ruy         º Data ³  04/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função para retornar dados no aCols usado na função 		  º±±
±±º          ³ principal.							                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contábil                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function AtuLanc(cOrigem,CSPAR1,CSPAR2,CSPAR3,CSPAR4,CSPAR5)

//Retorna informações da posição de cada campo no aHeader.
Local _nPosLot:=ascan( aHeader , {|x| x[2] = "CTK_LOTE"})
Local _nPosDat:=ascan( aHeader , {|x| x[2] = "CTK_DATA"})
Local _nPosDeb:=ascan( aHeader , {|x| x[2] = "CTK_DEBITO"})
Local _nPosCre:=ascan( aHeader , {|x| x[2] = "CTK_CREDIT"})
Local _nPosVal:=ascan( aHeader , {|x| x[2] = "CTK_VLR01"})
Local _nPosCcd:=ascan( aHeader , {|x| x[2] = "CTK_CCD"})
Local _nPosCcc:=ascan( aHeader , {|x| x[2] = "CTK_CCC"})
Local _nPosLpd:=ascan( aHeader , {|x| x[2] = "CTK_LP"})
Local _nPosSlp:=ascan( aHeader , {|x| x[2] = "CTK_LPSEQ"})
Local _nPosHst:=ascan( aHeader , {|x| x[2] = "CTK_HIST"})
Local N := 0

//Monta query para buscar todas informações relacionadas a nota na CTK.
cQuery := " SELECT 	CTK_LOTE, " 							+ ENTER
cQuery += "         CTK_DATA, " 							+ ENTER
cQuery += "         CTK_DEBITO, " 							+ ENTER
cQuery += "         CTK_CREDIT, " 							+ ENTER
cQuery += "         CTK_VLR01,  " 							+ ENTER
cQuery += "         CTK_HIST,   " 							+ ENTER
cQuery += "         CTK_CCD,    " 							+ ENTER
cQuery += "         CTK_CCC,    " 							+ ENTER
cQuery += "         CTK_LP,     " 							+ ENTER
cQuery += "         CTK_LPSEQ   " 							+ ENTER
cQuery += " FROM PROTHEUS.CTK010 " 							+ ENTER
cQuery += " WHERE " 										+ ENTER
cQuery += " D_E_L_E_T_ = ' ' AND " 				 			+ ENTER
cQuery += " CTK_FILIAL = '  ' AND " 						+ ENTER
cQuery += " CTK_DATA = '" + DtoS(CSPAR4) + "' AND " 		+ ENTER
cQuery += " CTK_RECORI = '" + AllTrim(Str(CSPAR5)) + "' "  	+ ENTER

If cOrigem == "SE5"
	cQuery += " AND CTK_TABORI = 'SE5' "						  	+ ENTER
EndIf

//Concatena query caso exista titulo para nota.
If !Empty(cFiltro)
	cQuery += " UNION ALL "
	cQuery += " SELECT 	CTK_LOTE, " 							+ ENTER
	cQuery += "         CTK_DATA, " 							+ ENTER
	cQuery += "         CTK_DEBITO, " 							+ ENTER
	cQuery += "         CTK_CREDIT, " 							+ ENTER
	cQuery += "         CTK_VLR01,  " 							+ ENTER
	cQuery += "         CTK_HIST,   " 							+ ENTER
	cQuery += "         CTK_CCD,    " 							+ ENTER
	cQuery += "         CTK_CCC,    " 							+ ENTER
	cQuery += "         CTK_LP,     " 							+ ENTER
	cQuery += "         CTK_LPSEQ   " 							+ ENTER
	cQuery += " FROM PROTHEUS.CTK010 " 							+ ENTER
	cQuery += " WHERE " 										+ ENTER
	cQuery += cFiltro
	
EndIf

cQuery := CHANGEQUERY(cQuery)

If Select("NFENT") > 0
	DbSelectArea("NFENT")
	NFENT->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "NFENT"

dbSelectArea("NFENT")
dbGoTop()

N:=oGet:nAt

ncont := 0

while !eof("NFENT")
	
	// preenche o acols
	acols[N,_nPosLot] := NFENT->CTK_LOTE
	acols[N,_nPosDat] := StoD(NFENT->CTK_DATA)
	acols[N,_nPosDeb] := NFENT->CTK_DEBITO
	acols[N,_nPosCre] := NFENT->CTK_CREDIT
	acols[N,_nPosVal] := NFENT->CTK_VLR01
	acols[N,_nPosCcd] := NFENT->CTK_CCD
	acols[N,_nPosCcc] := NFENT->CTK_CCC
	acols[N,_nPosLpd] := NFENT->CTK_LP
	acols[N,_nPosSlp] := NFENT->CTK_LPSEQ
	acols[N,_nPosHst] := NFENT->CTK_HIST
	acols[len(acols),len(aheader)+1] := .F.
	oGet:nAt:=N+1
	
	N += 1
	DbSelectArea("NFENT")
	dbskip()
	if !eof()
		
		//alimenta acols com linha vazia
		aadd(aCols,Array(Len(aHeader)+1))
		
		For _ni:=1 to Len(aHeader)
			aCols[N,_ni] := CriaVar(aHeader[_ni,2])
		Next
		aCols[N,Len(aHeader)+1]:=.F.
	endif
	oGet:obrowse:refresh()
enddo
oGet:aCols:=aCols
oGet:oBrowse:refresh()
oGet:Refresh()
Return

Static Function ExeCC()

Local cContaCtb  := aCols[oGet:nAt][3]
Local cContaCtb2 := aCols[oGet:nAt][4]
//Busca descrição da conta para exibir na Tela.
cMsgCC  := Posicione("CT1",1,xFilial("CT1")+cContaCtb ,"CT1_DESC01")
cMsgCC2 := Posicione("CT1",1,xFilial("CT1")+cContaCtb2,"CT1_DESC01")

@ 168,070 MSGET cMsgCC  SIZE 150,10 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 183,070 MSGET cMsgCC2 SIZE 150,10 OF oDlg PIXEL PICTURE "@!" WHEN .F.

Return
