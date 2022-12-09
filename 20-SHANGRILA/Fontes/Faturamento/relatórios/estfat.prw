#INCLUDE "rwmake.ch"
//#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ESTFAT     º Autor ³ Marcos M. Neto	 º Data ³  18/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Estatisticas sobre Faturamento/Vendas         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Shangri-lá                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EstFat()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  := OemToAnsi("Este programa ira emitir a relacao das vendas efetuadas pelo Vendedor,")
Local cDesc2  := OemToAnsi("totalizando por produto e escolhendo a moeda forte para os Valores.")
Local cDesc3  := ""
Local cDesc4  := ""
Local nOpca
Local titulo  := OemToAnsi("Faturamento por Vendedor")
Local cString := "SC5"
Local nMoeda

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Cabec1  := OemToAnsi("Cod Vend           Nome Vendedor")
Private Cabec2  := OemToAnsi("Cliente   Razao Social                              Cod. Produto      Descricao                                           N.Fisc  Pedido  Emissao   Vencto    %ComItem    Qtde           Valor Total ")

Private cArqTR1
Private cArqTR2
Private cIndTR1, cIndTR2
Private aStruTR1      := {}
Private aStruTR2      := {}

Private cPict  := ""
Private nLin   := 220
Private nSomaTotNF  := 0

Private imprime      := .T.
Private FilSD2       := " "
Private FilSF2       := " "
Private FilSD1       := " "
Private nOrdem	   :=0

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nTipo      := 15
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "EstFat" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cAgeIni    := Space(06)
Private aLinha :={}
Private aReturn    := {OemToAnsi("Zebrado"),1,OemToAnsi("Administracao"),1,2,1,"",1}  //"Zebrado"###"Administracao"  ////Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private cPerg      := PadR("ESTFAT",Len(SX1->X1_GRUPO))
Private nomeprog   := "EstFat" // Coloque aqui o nome do programa para impressao no cabecalho
Private aOrd       := {OemToAnsi("Por Código                         "),OemToAnsi("Por Vendedor                       "),OemToAnsi("Por Vendido          (Base Emissão)"),OemToAnsi("Por Vendido          (Base Entrega)"),OemToAnsi("Por Faturado         (Base Emissão)"),OemToAnsi("Por Faturado Liquido (Base Emissão)") }  //"Por Codigo"###"Por Nome"


SF2->(dbsetorder(1))
SD2->(dbsetorder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Cliente                           ³
//³ mv_par02             // Ate Cliente                          ³
//³ mv_par03             // De Data                              ³
//³ mv_par04             // Ate a Data                           ³
//³ mv_par05             // De Produto                           ³
//³ mv_par06             // Ate o Produto                        ³
//³ mv_par07             // Do Vendedor                          ³
//³ mv_par08             // Ate Vendedor                         ³
//³ mv_par09             // Tipo de Relatorio Sintetico/A01/A02  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case mv_par09 == 1
		titulo := titulo + "( SINTETICO ) de " + DtoC(mv_par03) + " até " + DtoC(mv_par04)
		//		       0         0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2
		//	   	       0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
		//			   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//	          "Ranking Codigo Vendedor                                 Vendido Entr. Vendido Emis.    Devolvido        Frete      Faturado Faturado Liq. "
		//	          "                                                              A             B            C            D             E         F( E-C-D )  "
		//	 		   XXXXXX 1234567890123456789012345678901234567890 99,999,999.99 99,999,999.99 9,999,999.99 9,999,999.99 99,999,999.99 99,999,999.99
		Cabec1 	   := "Ranking Codigo Vendedor                                 Á Faturar     Vendido Emis.    Devolvido        Frete      Subs.Trib           IPI       Faturado       Fat Liquid "
		Cabec2     := "                                                              A             B              C              D            E                F            G          (G-C-D-E-F)"
		//  	    Cabec1 	   := "Ranking Codigo Vendedor                                 Vendido Entr. Vendido Emis.    Devolvido        Frete      Faturado Faturado Liq. "
		//	    Cabec2     := "                                                              A             B            C            D             E         F( E-C-D )  "
		limite     := 220
		tamanho    := "G"
	Case mv_par09 == 2
		titulo := titulo + "( ANALITICO 01 CLIENTE SEM PRODUTOS ) de " + DtoC(mv_par03) + " até " + DtoC(mv_par04)
		Cabec1 	   := "Cod Vend           Nome Vendedor                    Total Venda       Total Devol     Liq. Receb."
		Cabec2     := " "
		limite     := 220
		tamanho    := "G"
	Case mv_par09 == 3
		titulo := titulo + "( ANALITICO 02 CLIENTE COM PRODUTOS ) de " + DtoC(mv_par03) + " até " + DtoC(mv_par04)
		Cabec1 	   := "Cod Vend           Nome Vendedor"
		Cabec2     := "Cliente   Razao Social                              Cod. Produto      Descricao                                      N.Fisc  Pedido  Emissao   Qtde           Vlr Unit          Vlr Total"
EndCase

//            123456789012345 123456789012345678901234567890 123456/123 12/12/1234 123456789012 1234567890123456 1234567890123456 123456/123456/123456/123456/123456

If mv_par07 == Space(06)
	cAgeIni    :="0     "
Else
	cAgeIni    :=mv_par07
Endif

Private cString := "SF2"

dbSelectArea("SF2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

//wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
//wnrel:=SetPrint(cString,wnrel   ,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

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

RptStatus({|lEnd| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem        := aReturn[8]
Local aStruTR1      := {}
Local TempCod	 	:= "      "
Local TempTotal  	:= 0

If mv_par09 == 1  //// Sintetico 01 - Resumo de Vendas por Vendedor
	Print01(Cabec1,Cabec2,Titulo,nLin)
Endif

If mv_par09 == 2  //// Sintetico 02 - Resumo de Vendas por Região
	//	Print02(Cabec1,Cabec2,Titulo,nLin)
Endif

If mv_par09 == 3  //// Analitico 01 - Resumo de Vendas por Vendedor por Cliente
	//	Print02(Cabec1,Cabec2,Titulo,nLin)
Endif

If mv_par09 == 4  //// Analitico 02 - Resumo de Vendas por Vendedor por Cliente por Produto
	//	Print02(Cabec1,Cabec2,Titulo,nLin)
Endif

SET DEVICE TO SCREEN
//(cSF2)->(DbCloseArea())
//fErase(cArqTrabF2+OrdBagExt())
//#IFDEF TOP
//	fErase(cArqTrabF2+GetDbExtension())
//#ENDIF

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


//-----------------------------------------------------------------------------------------------------------------------------
//  Print01 - Realiza a impressão Sintetico 01 - Posicao de vendas por Vendedor
//-----------------------------------------------------------------------------------------------------------------------------
Static Function Print01(Cabec1,Cabec2,Titulo,nLin)

Local TR1_COD     := {}
Local TR1_SUPER   := {}
Local TR1_VEND    := {}
Local TR1_VENDID  := {}
Local TR1_VEEDID  := {}
Local TR1_DEVOLV  := {}
Local TR1_FRETE   := {}
Local TR1_FATURA  := {}
Local TR1_ICMRET  := {}
Local TR1_FATLIQ  := {}
Local TR1_VALIPI  := {}
Local Trab01	  := {}

//***** Carregando informacoes do arquivo de Vendedores ( SA3 ) ********* (Todos os vendedores)
DbSelectArea("SA3")
Dbsetorder(1)
Dbgotop()
Do While !SA3->(Eof())
	IncProc("Carregando...") // Atualiza barra de progresso
	aAdd(TR1_COD   ,SA3->A3_COD)
	aAdd(TR1_SUPER ,SA3->A3_SUPER)
	aAdd(TR1_VEND  ,SA3->A3_NOME)
	aAdd(TR1_VENDID,0)
	aAdd(TR1_VEEDID,0)
	aAdd(TR1_DEVOLV,0)
	aAdd(TR1_FRETE ,0)
	aAdd(TR1_FATURA,0)
	aAdd(TR1_FATLIQ,0)
	aAdd(TR1_ICMRET,0)
	aAdd(TR1_VALIPI,0)
	//    aAdd(Trab01, {SA3->A3_COD,SA3->A3_SUPER,SA3->A3_NOME,0,0,0,0,0,0} )
	SA3->(dbSkip())
Enddo
aAdd(TR1_COD   ,"000000")
aAdd(TR1_SUPER ,"")
aAdd(TR1_VEND  ,"Codigo Errado")
aAdd(TR1_VENDID,0)
aAdd(TR1_VEEDID,0)
aAdd(TR1_DEVOLV,0)
aAdd(TR1_FRETE ,0)
aAdd(TR1_FATURA,0)
aAdd(TR1_FATLIQ,0)
aAdd(TR1_ICMRET,0)
aAdd(TR1_VALIPI,0)
dbSelectArea("SA3")
dbCloseArea()
//-----------------------------------------------------------------------------------------------------------------------------
//Faturamento
//	cQuery := "SELECT SF2.F2_VEND1 AS COD, Sum(SD2.D2_TOTAL) AS TOTAL "
//	cQuery += "FROM " + RetSqlName("SF2") + " SF2 INNER JOIN " + RetSqlName("SD2") + " SD2 ON (SF2.F2_LOJA = SD2.D2_LOJA) AND (SF2.F2_CLIENTE = SD2.D2_CLIENTE) AND (SF2.F2_DOC = SD2.D2_DOC) "
//	cQuery += "WHERE SF2.F2_FILIAL = '" +xFilial("SF2")+"' AND "
//	cQuery += "SD2.D2_FILIAL = '" +xFilial("SD2")+"' AND "
//	cQuery += "SF2.F2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' And '"+DTOS(mv_par04)+"' AND "
//	cQuery += "SF2.F2_VEND1   BETWEEN '"+ mv_par05 +"' AND '"+mv_par06+"' AND "
//	cQuery += "SF2.F2_TIPO<>'B' And SF2.F2_TIPO<>'D' And SF2.F2_TIPO<>'C' And SF2.F2_TIPO<>'I' And SF2.F2_TIPO<>'P' And "
//	cQuery += "SF2.D_E_L_E_T_ <> '*' "
//	cQuery += "GROUP BY SF2.F2_VEND1 "
//	cQuery += "HAVING ((Not (SF2.F2_VEND1) Is Null) AND (Not (Sum(SD2.D2_TOTAL)) Is Null)) "
//	cQuery += "ORDER BY SF2.F2_VEND1"

cQuery := "SELECT SF2.F2_VEND1 AS COD, Sum(SF2.F2_FRETE) As FRETE, Sum(SF2.F2_VALFAT) AS TOTAL, Sum(SF2.F2_VALIPI) AS VALIPI "
cQuery += "FROM " + RetSqlName("SF2") + " SF2 "
cQuery += "WHERE SF2.F2_FILIAL = '" +xFilial("SF2")+"' AND "
cQuery += "SF2.F2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' And '"+DTOS(mv_par04)+"' AND "
cQuery += "SF2.F2_VEND1   BETWEEN '"+ mv_par05 +"' AND '"+mv_par06+"' AND "
cQuery += "SF2.F2_TIPO<>'B' And SF2.F2_TIPO<>'D' And SF2.F2_TIPO<>'C' And SF2.F2_TIPO<>'I' And SF2.F2_TIPO<>'P' And "
cQuery += "(SF2.D_E_L_E_T_ = '') AND " 
cQuery += "SF2.F2_VALFAT > 0  "
cQuery += "GROUP BY SF2.F2_VEND1 "
cQuery += "HAVING ((Not (SF2.F2_VEND1) Is Null) AND ((Not (SF2.F2_VEND1=''))) AND (Not (Sum(SF2.F2_VALFAT)) Is Null)) "
cQuery += "ORDER BY SF2.F2_VEND1"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'FATTRB', .F., .T.)},"Selecionado Faturados + Frete...")
DbSelectArea("FATTRB")
Dbgotop()                                         '
Do While !("FATTRB")->(Eof())
	PT=ASCAN(TR1_COD,FATTRB->COD)
	TR1_FRETE[PT]  = FATTRB->FRETE
	TR1_FATURA[PT] = FATTRB->TOTAL
	TR1_FATLIQ[PT] = (FATTRB->TOTAL)-(FATTRB->FRETE)-(FATTRB->VALIPI)
	TR1_VALIPI[PT] = FATTRB->VALIPI
	FATTRB->(dbSkip())
EndDo
dbSelectArea("FATTRB")
dbCloseArea()
//-----------------------------------------------------------------------------------------------------------------------------
cQuery := "SELECT SF2.F2_VEND1 AS COD, Sum(SF2.F2_ICMSRET) AS ICMSRET "
cQuery += "FROM " + RetSqlName("SF2") + " SF2 "
cQuery += "WHERE SF2.F2_FILIAL = '" +xFilial("SF2")+"' AND "
cQuery += "SF2.F2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' And '"+DTOS(mv_par04)+"' AND "
cQuery += "SF2.F2_VEND1   BETWEEN '"+ mv_par05 +"' AND '"+mv_par06+"' AND "
cQuery += "SF2.F2_TIPO<>'B' And SF2.F2_TIPO<>'D' And SF2.F2_TIPO<>'C' And SF2.F2_TIPO<>'I' And SF2.F2_TIPO<>'P' And "
cQuery += "SF2.D_E_L_E_T_ <> '*' AND (F2_SERIE = '1' OR F2_SERIE = 'NFE') And "
cQuery += "SF2.F2_VALFAT > 0  "
cQuery += "GROUP BY SF2.F2_VEND1 "
cQuery += "HAVING ((Not (SF2.F2_VEND1) Is Null) AND ((Not (SF2.F2_VEND1=''))) AND (Not (Sum(SF2.F2_VALFAT)) Is Null)) "
cQuery += "ORDER BY SF2.F2_VEND1"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'FATST', .F., .T.)},"Selecionado Faturados + Frete...")
DbSelectArea("FATST")
Dbgotop()
Do While !("FATST")->(Eof())
	PT=ASCAN(TR1_COD,FATST->COD)
	TR1_ICMRET[PT] = FATST->ICMSRET
	TR1_FATLIQ[PT]  = TR1_FATLIQ[PT]-(FATST->ICMSRET)
	FATST->(dbSkip())
EndDo
dbSelectArea("FATST")
dbCloseArea()
//-----------------------------------------------------------------------------------------------------------------------------
cQuery := "SELECT SC5.C5_VEND1 COD, Sum(SC6.C6_VALOR) AS TOTAL "
cQuery += "FROM " + RetSqlName("SC5") + " SC5 LEFT JOIN " + RetSqlName("SC6") + " SC6 ON SC5.C5_NUM = SC6.C6_NUM "
cQuery += "WHERE SC5.C5_FILIAL = '" +xFilial("SC5")+"' AND "
cQuery += "SC6.C6_FILIAL = '" +xFilial("SC6")+"' AND "
cQuery += "SC5.C5_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' And '"+DTOS(mv_par04)+"' AND "
cQuery += "SC5.C5_VEND1  BETWEEN '"+ mv_par05 +"' AND '"+mv_par06+"' AND "
cQuery += "SC5.C5_TIPO<>'B' And SC5.C5_TIPO<>'D' And SC5.C5_TIPO<>'C' And SC5.C5_TIPO<>'I' And SC5.C5_TIPO<>'P' AND "
cQuery += "SC5.D_E_L_E_T_ <> '*' AND "
cQuery += "SC6.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY SC5.C5_VEND1 "
cQuery += "HAVING (((SC5.C5_VEND1) Is Not Null) AND ((Not (SC5.C5_VEND1=''))) AND ((Sum(SC6.C6_VALOR)) Is Not Null)) "
cQuery += "ORDER BY SC5.C5_VEND1"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'VEETRB', .F., .T.)},"Selecionado Vendido por Emissão...")
DbSelectArea("VEETRB")
Dbgotop()
Do While !("VEETRB")->(Eof())
	PT=ASCAN(TR1_COD,VEETRB->COD)
	TR1_VEEDID[PT]  = VEETRB->TOTAL
	VEETRB->(dbSkip())
EndDo
dbSelectArea("VEETRB")
dbCloseArea()
_dInicial := DDATABASE - 180
//-----------------------------------------------------------------------------------------------------------------------------
cQuery := "SELECT SC5.C5_VEND1 COD, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRCVEN) AS TOTAL "
cQuery += "FROM " + RetSqlName("SC6") + " SC6 LEFT JOIN " + RetSqlName("SC5") + " SC5 ON SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SF4.F4_CODIGO = SC6.C6_TES AND SF4.D_E_L_E_T_ = ''  "
cQuery += "WHERE SC5.C5_FILIAL = '" +xFilial("SC5")+"' AND "
cQuery += "SC6.C6_FILIAL = '" +xFilial("SC6")+"' AND "
cQuery += "SC6.C6_QTDENT < SC6.C6_QTDVEN AND (SC6.C6_BLQ NOT IN ('R','S')) AND "
cQuery += "SC5.C5_DTENTR BETWEEN  '"+DTOS(_dInicial)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "SC5.C5_VEND1  BETWEEN '"+ mv_par05 +"' AND '"+mv_par06+"' AND "
cQuery += "SC5.C5_TIPO='N'  AND "
cQuery += "SC6.D_E_L_E_T_ = '' AND "
cQuery += "(SF4.F4_DUPLIC IN ('S')) "
cQuery += "GROUP BY SC5.C5_VEND1 "
cQuery += "HAVING (((SC5.C5_VEND1) Is Not Null) AND ((Not (SC5.C5_VEND1=''))) AND ((Sum(SC6.C6_VALOR)) Is Not Null)) "
cQuery += "ORDER BY SC5.C5_VEND1"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'VEDTRB', .F., .T.)},"Selecionado Vendido por Entrega...")
DbSelectArea("VEDTRB")
Dbgotop()
Do While !("VEDTRB")->(Eof())
	PT=ASCAN(TR1_COD,VEDTRB->COD)
	TR1_VENDID[PT]  = VEDTRB->TOTAL
	VEDTRB->(dbSkip())
EndDo
dbSelectArea("VEDTRB")
dbCloseArea()
//-----------------------------------------------------------------------------------------------------------------------------
/*cQuery := "SELECT SF2.F2_VEND1 AS COD, Sum(SD1.D1_TOTAL-SD1.D1_VALDESC+SD1.D1_VALIPI+SD1.D1_VALFRE) AS TOTAL, Sum(SD1.D1_VALDESC) AS DESCONTO "
cQuery += "FROM " + RetSqlName("SF2") + " SF2 INNER JOIN " + RetSqlName("SD1") + " SD1 ON (SF2.F2_DOC = SD1.D1_NFORI) AND (SF2.F2_SERIE = SD1.D1_SERIORI) "
cQuery += "WHERE SF2.F2_FILIAL = '" +xFilial("SF2")+"' AND "
cQuery += "SD1.D1_FILIAL = '" +xFilial("SD1")+"' AND "
cQuery += "SD1.D1_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' And '"+DTOS(mv_par04)+"' AND "
cQuery += "SF2.F2_TIPO<>'B' And SF2.F2_TIPO<>'D' And SF2.F2_TIPO<>'C' And SF2.F2_TIPO<>'I' And SF2.F2_TIPO<>'P' AND SD1.D1_TIPO='D' AND "
cQuery += "SF2.D_E_L_E_T_ <> '*' AND "
cQuery += "SD1.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY SF2.F2_VEND1 "
cQuery += "HAVING (((SF2.F2_VEND1) Is Not Null)) AND ((Not (SF2.F2_VEND1='')))"
cQuery += "ORDER BY SF2.F2_VEND1"*/
&&	cQuery := "SELECT DISTINCT SF2.F2_VEND1 AS COD, SUM(SD1.D1_TOTAL-SD1.D1_VALDESC+SD1.D1_ICMSRET+SD1.D1_VALIPI+SD1.D1_VALFRE) AS TOTAL "
cQuery := "SELECT DISTINCT SF2.F2_VEND1 AS COD, SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) AS TOTAL "
cQuery += "FROM " + RetSqlName("SF2") + " SF2 INNER JOIN " + RetSqlName("SD1") + " SD1 ON (SF2.F2_DOC = SD1.D1_NFORI) AND (SF2.F2_SERIE = SD1.D1_SERIORI) "
cQuery += "INNER JOIN SF1010 SF1 ON (SD1.D1_DOC = SF1.F1_DOC) AND (SD1.D1_SERIE = SF1.F1_SERIE) AND (SD1.D1_FORNECE = SF1.F1_FORNECE) AND (SD1.D1_LOJA = SF1.F1_LOJA)"
cQuery += "WHERE SF2.F2_FILIAL = '" +xFilial("SF2")+"' AND "
cQuery += "SD1.D1_FILIAL = '" +xFilial("SD1")+"' AND "
cQuery += "SD1.D1_DTDIGIT BETWEEN '"+DTOS(mv_par03)+"' And '"+DTOS(mv_par04)+"' AND "
cQuery += "SF2.F2_TIPO<>'B' And SF2.F2_TIPO<>'D' And SF2.F2_TIPO<>'C' And SF2.F2_TIPO<>'I' And SF2.F2_TIPO<>'P' AND SD1.D1_TIPO='D' AND "
cQuery += "SF2.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND SF1.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY SF2.F2_VEND1"

cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'DEVTRB', .F., .T.)},"Selecionado Devolvido...")
DbSelectArea("DEVTRB")
Dbgotop()
Do While !("DEVTRB")->(Eof())
	PT=ASCAN(TR1_COD,DEVTRB->COD)
	TR1_DEVOLV[PT]  = DEVTRB->TOTAL
	TR1_FATLIQ[PT]  = TR1_FATLIQ[PT]-DEVTRB->TOTAL
	DEVTRB->(dbSkip())
EndDo
dbSelectArea("DEVTRB")
dbCloseArea()
//-----------------------------------------------------------------------------------------------------------------------------
For Th=1 to Len(TR1_COD)
	aAdd(Trab01, {TR1_COD[Th],TR1_SUPER[Th],TR1_VEND[Th],TR1_VENDID[Th],TR1_VEEDID[Th],TR1_DEVOLV[Th],TR1_FRETE[Th],TR1_FATURA[Th],TR1_FATLIQ[Th],TR1_ICMRET[Th],TR1_VALIPI[Th]} )
Next Th
if nOrdem == 1
	Asort(Trab01,,,{|X,Y| X[1]<Y[1]})
elseif nOrdem == 2
	Asort(Trab01,,,{|X,Y| X[3]<Y[3]})
elseif nOrdem == 3
	Asort(Trab01,,,{|X,Y| X[4]>Y[4]})
elseif nOrdem == 4
	Asort(Trab01,,,{|X,Y| X[5]>Y[5]})
elseif nOrdem == 5
	Asort(Trab01,,,{|X,Y| X[8]>Y[8]})
else
	Asort(Trab01,,,{|X,Y| X[9]>Y[9]})
endif

nTipo := If(aReturn[4]==1,15,18)

nTotGerFat = 0
nTotGerDev = 0
nTotGerVed = 0
nTotGerVee = 0
nTotGerFre = 0
nTotGerIST = 0
nTotIPI    = 0
nMaxLin = 68
//nLin = Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin = 72
Rank = 1

For th=1 to Len(TR1_COD)
	if nLin > nMaxLin
		//Roda(,,Tamanho)
		@ nLin,000 PSAY __PrtFatLine()
		nLin = Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin = 9
	endif
	if ((Trab01[th,8]<>0) .or. (Trab01[th,4]<>0) .or. (Trab01[Th,6]<>0) .or. (Trab01[th,7]<>0) .or. (Trab01[th,5]<>0))
		@ nLin,000 Psay Transform(Rank,"@E 9999999")
		@ nLin,008 Psay Trab01[th,1]   								//Codigo
		@ nLin,015 Psay Trab01[th,3]   								//Nome
		@ nLin,056 Psay Transform(Trab01[th,4],"@E 99,999,999.99")  //Vend.Entr
		@ nLin,070 Psay Transform(Trab01[th,5],"@E 99,999,999.99") 	//Vend.Emissao
		@ nLin,084 Psay Transform(Trab01[th,6],"@E 9,999,999.99")	//Devolvido
		@ nLin,097 Psay Transform(Trab01[th,7],"@E 9,999,999.99")   //Frete
		@ nLin,110 Psay Transform(Trab01[th,10],"@E 99,999,999.99") //Subs.Trib
		@ nLin,125 Psay Transform(Trab01[th,11],"@E 99,999,999.99") //IPI
		@ nLin,140 Psay Transform(Trab01[th,8],"@E 99,999,999.99")  //Faturado
		@ nLin,155 Psay Transform(Trab01[th,9],"@E 99,999,999.99")  //Faturado Liquido
		nTotGerFat = nTotGerFat + Trab01[th,8]
		nTotGerVed = nTotGerVed + Trab01[th,4]
		nTotGerVee = nTotGerVee + Trab01[th,5]
		nTotGerDev = nTotGerDev + Trab01[th,6]
		nTotGerFre = nTotGerFre + Trab01[th,7]
		nTotGerIST = nTotGerIST + Trab01[th,10]
		nTotIPI    = nTotIPI    + Trab01[th,11]
		nLin = nLin + 1
		Rank = Rank + 1
	Endif
Next th

//@ nLin,000 Psay Repli('=',220)
@ nLin,000 PSAY __PrtThinLine()
nLin := nLin + 1
@ nLin,030 Psay "Total Geral ---->"
@ nLin,056 Psay Transform(nTotGerVed,"@E 99,999,999.99")
@ nLin,070 Psay Transform(nTotGerVee,"@E 99,999,999.99")
@ nLin,084 Psay Transform(nTotGerDev,"@E 9,999,999.99")
@ nLin,097 Psay Transform(nTotGerFre,"@E 9,999,999.99")
@ nLin,110 Psay Transform(nTotGerIST,"@E 99,999,999.99")
@ nLin,125 Psay Transform(nTotIPI,"@E 99,999,999.99")
@ nLin,140 Psay Transform(nTotGerFat,"@E 99,999,999.99")
@ nLin,155 Psay Transform((nTotGerFat-nTotGerDev-nTotGerFre-nTotGerIST-nTotIPI),"@E 99,999,999.99")
nLin := nLin + 2
nLin := nLin + 1
@ nLin,000 PSAY __PrtFatLine()
//    Roda(,,Tamanho)
Return
//-----------------------------------------------------------------------------------------------------------------------------







































***** Filtrando Informacoes no arquivo Principal ( Cabec NF Saida ) *********
DbSelectArea("SD1")
cArqTrabD1 := CriaTrab( "" , .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para SQL                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSD1   := "SD1TMP"
aStru  := dbStruct()
cQuery := "SELECT * FROM "          + RetSqlName("SD1") + " SD1 "
cQuery += "WHERE SD1.D1_FILIAL = '" +xFilial("SD1")+"' AND "
cQuery += "SD1.D1_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "  // <---------
cQuery += "SD1.D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SD1.D1_COD     BETWEEN '"+ mv_par05 +"' AND '"+mv_par06+"' AND "
cQuery += "SD1.D1_NFORI <> '      ' AND "
cQuery += "SD1.D_E_L_E_T_ = '' "

cQuery += "ORDER BY SD1.D1_FILIAL,SD1.D1_NFORI,SD1.D1_COD"
//cQuery += "ORDER BY SD1.D1_FILIAL,SD1.D1_NFORI,SD1.D1_COD"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD1TRB', .F., .T.)},"Seleccionado Inf.Devolucao (SD1)")
For nj := 1 to Len(aStru)
	If aStru[nj,2] != 'C'
		TCSetField('SD1TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
	EndIf
Next nj

AEstVenCriaTmp(cArqTrabD1, aStru, cSD1, "SD1TRB")
IndRegua(cSD1,cArqTrabD1,"D1_FILIAL+D1_NFORI+D1_COD",,".T.","Indexando Devol.")
//IndRegua(cSD1,cArqTrabD1,"D1_FILIAL+D1_NFORI+D1_COD",,".T.","Indexando Devol.")
dbSetIndex(cArqTrabD1+ordBagExt())
*****************************************************************************
FilSD1 := SD1->D1_FILIAL

***** Filtrando Informacoes no arquivo Principal ( Cabec NF Saida ) *********
DbSelectArea("SF2")
cArqTrabF2 := CriaTrab( "" , .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para SQL                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSF2   := "SF2TMP"
aStru  := dbStruct()
cQuery := "SELECT * FROM "          + RetSqlName("SF2") + " SF2 "
cQuery += "WHERE SF2.F2_FILIAL = '" +xFilial("SF2")+"' AND "
cQuery += "SF2.F2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SF2.F2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "SF2.F2_VEND1   BETWEEN '"+ cAgeIni +"' AND '"+mv_par08+"' AND "
cQuery += "SF2.F2_TIPO <> 'B' AND SF2.F2_TIPO <> 'D' AND "
cQuery += "SF2.F2_TIPO <> 'C' AND SF2.F2_TIPO <> 'I' AND SF2.F2_TIPO <> 'P' AND "
cQuery += "SF2.D_E_L_E_T_ <> '*' "

cQuery += "ORDER BY SF2.F2_FILIAL,SF2.F2_VEND1,SF2.F2_CLIENTE,SF2.F2_LOJA"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SF2TRB', .F., .T.)},"Seleccionado Inf.Vendas Capa (SF2)")
For nj := 1 to Len(aStru)
	If aStru[nj,2] != 'C'
		TCSetField('SF2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
	EndIf
Next nj

AEstVenCriaTmp(cArqTrabF2, aStru, cSF2, "SF2TRB")
IndRegua(cSF2,cArqTrabF2,"F2_FILIAL+F2_VEND1+F2_CLIENTE+F2_LOJA",,".T.","Indexando Vendas")
dbSetIndex(cArqTrabF2+ordBagExt())
*****************************************************************************
FilSF2 := SF2->F2_FILIAL


***** Filtrando Informacoes no arquivo Secundario ( Itens NF Saida ) *********
DbSelectArea("SD2")
cArqTrab2  := CriaTrab( "" , .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para SQL                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSD2   := "SD2TMP"
aStru  := dbStruct()
cQuery := "SELECT * FROM "          + RetSqlName("SD2") + " SD2 "
cQuery += "WHERE SD2.D2_FILIAL = '" +xFilial("SD2")+"' AND "
cQuery += "SD2.D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "SD2.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"' AND "
cQuery += "SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND "
cQuery += "SD2.D2_TIPO <> 'C' AND SD2.D2_TIPO <> 'I' AND SD2.D2_TIPO <> 'P' AND "
// cQuery += " NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "
cQuery += "SD2.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_DOC,SD2.D2_COD,SD2.D2_ITEM"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD2TRB', .F., .T.)},"Seleccionado Itens Venda (SD2)") //"Seleccionado registros"
For nj := 1 to Len(aStru)
	If aStru[nj,2] != 'C'
		TCSetField('SD2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
	EndIf
Next nj

AEstVenCriaTmp(cArqTrab2, aStru, cSD2, "SD2TRB")
IndRegua(cSD2,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_DOC+D2_COD+D2_ITEM",,,"Indexando Itens Vendas")		//"Selecionando Registros..."
dbSetIndex(cArqTrab2+ordBagExt())
*****************************************************************************
FilSD2 := SD2->D2_FILIAL

DbSelectArea(cSF2)

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea(cSD2)
dbGoTop()

DbSelectArea(cSD1)
dbGoTop()

DbSelectArea(cSF2)
dbGoTop()

cVend1   := (cSF2)->F2_VEND1
nTotFat  := 0
nTotComis:= 0
nTotDev  := 0

nTotGerFat  := 0
nTotGerDev  := 0
nSomaTotNF  := 0

nTotFatCli := 0
nTotDevCli := 0


While !Eof() .AND. ((FilSF2+(cSF2)->F2_VEND1) == (FilSF2+cVend1))
	
	If !Empty(mv_par05) .and. Upper(mv_par06) != "ZZZZZZZZZZZZZZZ"
		cClieAnt := (cSF2)->F2_CLIENTE
		DbSelectArea(cSD2)
		If !DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			DbSelectArea(cSF2)
			DbSkip()
			cClieAnt := (cSF2)->F2_CLIENTE
			cVend1   := (cSF2)->F2_VEND1
			Loop
		Endif
	Endif
	
	IncRegua()
	
	cClieAnt := (cSF2)->F2_CLIENTE
	cLojaAnt := (cSF2)->F2_LOJA
	cNf      := (cSF2)->F2_DOC
	cSerie   := (cSF2)->F2_SERIE
	
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
	
	If nLin > 61 // Salto de Página. Neste caso o formulario tem 61 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		If mv_par09 == 3  //// Analiticos 02
			nLin := 8
		Else
			nLin := 8
		Endif
		@ nLin,000 Psay "  "
		nLin := nLin + 1
		cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
		@ nLin,000 Psay "Vend.--> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
	Endif
	
	If mv_par09 != 1
		nLin := nLin + 1 // Avanca a linha de impressao
	Endif
	
	If mv_par09 == 3  //// Analiticos 02
		
		DbSelectArea(cSD2)
		If DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			If nSomaTotNF != 0
				nLin := nLin - 1
				@ nLin,148 Psay "Total Nota Fiscal --->"
				@ nLin,171 Psay Transform(nSomaTotNF ,"@E 999,999,999.99")
				nSomaTotNF := 0
				nLin := nLin + 1
			Endif
			@ nLin,000 Psay Repli('-',220)
			nLin := nLin + 1
			
			@ nLin,000 PSay cClieAnt
			@ nLin,010 PSay Substr(Posicione( "SA1" , 1 , xFilial("SA1")+cClieAnt+cLojaAnt , "A1_NOME" ),1,40)
			
			DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			While (cSD2)->D2_CLIENTE == cClieAnt .and. (cSD2)->D2_DOC == (cSF2)->F2_DOC .and. !Eof()
				@ nLin,052 Psay (cSD2)->D2_COD
				@ nLin,070 Psay Substr(Posicione( "SB1" , 1 , xFilial("SB1")+(cSD2)->D2_COD , "B1_DESC" ),1,45)
				@ nLin,117 Psay (cSD2)->D2_DOC
				@ nLin,125 Psay (cSD2)->D2_PEDIDO
				@ nLin,133 Psay (cSD2)->D2_EMISSAO
				@ nLin,143 Psay Transform((cSD2)->D2_QUANT,"@E 9999.999")
				@ nLin,152 Psay Transform((cSD2)->D2_PRCVEN,"@E 999,999,999.99")
				@ nLin,171 Psay Transform((cSD2)->D2_TOTAL ,"@E 999,999,999.99")
				**** Totalizando Valores
				nTotGerFat:= nTotGerFat + (cSD2)->D2_TOTAL
				nSomaTotNF:= nSomaTotNF + (cSD2)->D2_TOTAL
				DbSelectArea(cSD1)
				If DbSeek(FilSD1+(cSF2)->F2_DOC+(cSD2)->D2_COD)
					@ nLin,191 Psay "("+Transform((cSD1)->D1_QUANT,"@E 9999.999")+") Devolucao"
					nTotGerDev := nTotGerDev + (cSD1)->D1_TOTAL
				Endif
				
				DbSelectArea(cSD2)
				
				
				DbSkip()
				
				nLin := nLin + 1
				
				If nLin > 61
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
					@ nLin,000 Psay "  "
					nLin := nLin + 1
					cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
					@ nLin,000 Psay "Vend.--> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
					nLin := nLin + 1
					@ nLin,000 Psay Repli('-',220)
					nLin := nLin + 1
				Endif
				
			Enddo
			
		Endif
		
	Endif
	
	If mv_par09 == 2  //// Analiticos 01
		
		DbSelectArea(cSD2)
		If DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			
			@ nLin,000 Psay Repli('-',130)
			nLin := nLin + 1
			
			@ nLin,000 PSay cClieAnt
			@ nLin,010 PSay Substr(Posicione( "SA1" , 1 , xFilial("SA1")+cClieAnt+cLojaAnt , "A1_NOME" ),1,35)
			
			DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			While (cSD2)->D2_CLIENTE == cClieAnt .and. (cSD2)->D2_DOC == (cSF2)->F2_DOC .and. !Eof()
				
				**** Totalizando Valores
				nTotFatCli:= nTotFatCli + (cSD2)->D2_TOTAL
				
				DbSelectArea(cSD1)
				If DbSeek(FilSD1+(cSF2)->F2_DOC+(cSD2)->D2_COD)
					nTotDevCli := nTotDevCli + (cSD1)->D1_TOTAL
				Endif
				
				DbSelectArea(cSD2)
				
				DbSkip()
				
			Enddo
			
			@ nLin,050 Psay Transform(nTotFatCli,"@E 999,999,999.99")
			@ nLin,066 Psay "("+Transform(nTotDevCli,"@E 999,999,999.99")+")"
			@ nLin,082 Psay Transform((nTotFatCli - nTotDevCli),"@E 999,999,999.99")
			
			//nLin := nLin + 1
			
			If nLin > 61
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 7
				@ nLin,000 Psay "  "
				nLin := nLin + 1
				cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
				@ nLin,000 Psay "Vend.--> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			Endif
			
			nTotFat := nTotFat + nTotFatCli
			nTotDev := nTotDev + nTotDevCli
			nTotFatCli := 0
			nTotDevCli := 0
			
		Endif
		
	Endif
	
	If mv_par09 == 1 /// Sintético
		
		DbSelectArea(cSD2)
		
		If DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			
			While (cSD2)->D2_CLIENTE == cClieAnt .and. (cSD2)->D2_DOC == (cSF2)->F2_DOC .and. !Eof()
				
				**** Totalizando Valores
				nTotFat:= nTotFat + (cSD2)->D2_TOTAL
				
				DbSelectArea(cSD1)
				If DbSeek(FilSD1+(cSD2)->D2_DOC+(cSD2)->D2_COD)
					nTotDev := nTotDev + (cSD1)->D1_TOTAL
				Endif
				
				DbSelectArea(cSD2)
				DbSkip()
			Enddo
			
			
		Endif
		
	Endif
	
	DbSelectArea(cSF2)
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	cClieAnt := (cSF2)->F2_CLIENTE
	cLojaAnt := (cSF2)->F2_LOJA
	
	If mv_par09 == 1
		
		If (cSF2)->F2_VEND1 != cVend1
			***** Imprime o Total da Venda do Vendedor
			@ nLin,050 Psay Transform(nTotFat,"@E 999,999,999.99")
			@ nLin,066 Psay "("+Transform(nTotDev,"@E 999,999,999.99")+")"
			@ nLin,082 Psay Transform((nTotFat - nTotDev),"@E 999,999,999.99")
			nLin := nLin + 1
			
			nTotGerFat:= nTotGerFat + nTotFat
			nTotGerDev:= nTotGerDev + nTotDev
			
			nTotFat:= 0
			nTotDev:= 0
			
			***** Incrementou o Vendedor
			cVend1   := (cSF2)->F2_VEND1
			cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
			If !Empty(cVend1)
				@ nLin,000 Psay "Vend --> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			Endif
		Endif
		
	Endif
	
	If mv_par09 == 2 // Sintetico e Analitico 01
		
		If (cSF2)->F2_VEND1 != cVend1
			***** Imprime o Total da Venda do Vendedor
			nLin := nLin + 1
			@ nLin,000 Psay Repli('-',130)
			nLin := nLin + 1
			@ nLin,000 Psay "Total Vend. --> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			@ nLin,051 Psay Transform(nTotFat,"@E 999,999,999.99")
			@ nLin,067 Psay "("+Transform(nTotDev,"@E 999,999,999.99")+")"
			@ nLin,083 Psay Transform((nTotFat - nTotDev),"@E 999,999,999.99")
			nLin := nLin + 1
			@ nLin,000 Psay Repli('-',130)
			nLin := nLin + 2
			
			nTotGerFat:= nTotGerFat + nTotFat
			nTotGerDev:= nTotGerDev + nTotDev
			
			nTotFat:= 0
			nTotDev:= 0
			
			***** Incrementou o Vendedor
			cVend1   := (cSF2)->F2_VEND1
			cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
			If !Empty(cVend1)
				@ nLin,000 Psay "Vend --> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			Endif
		Endif
	Endif
	
	
	If mv_par09 == 3 // Sintetico e Analitico 02
		If (cSF2)->F2_VEND1 != cVend1
			***** Imprime o Total da Venda do Vendedor
			nLin := nLin + 1
			
			***** Incrementou o Vendedor
			cVend1   := (cSF2)->F2_VEND1
			cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
			If !Empty(cVend1)
				@ nLin,000 Psay "Vend --> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			Endif
		Endif
	Endif
	
	cVend1   := (cSF2)->F2_VEND1
	
EndDo

nLin := nLin + 1
@ nLin,000 Psay Repli('=',220)
nLin := nLin + 1
@ nLin,030 Psay "Total Geral ---->"
@ nLin,050 Psay Transform(nTotGerFat,"@E 999,999,999.99")
@ nLin,066 Psay "("+Transform(nTotGerDev,"@E 999,999,999.99")+")"
@ nLin,082 Psay Transform((nTotGerFat - nTotGerDev),"@E 999,999,999.99")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

(cSF2)->(DbCloseArea())
(cSD2)->(DbCloseArea())
(cSD1)->(DbCloseArea())
fErase(cArqTrabF2+OrdBagExt())
fErase(cArqTrab2+OrdBagExt())
fErase(cArqTrabD1+OrdBagExt())
#IFDEF TOP
	fErase(cArqTrabF2+GetDbExtension())
	fErase(cArqTrab2+GetDbExtension())
	fErase(cArqTrabD1+GetDbExtension())
#ENDIF

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AEstFatCriaTmp³ Autor ³ Microsiga          ³ Data ³ 04/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria temporario a partir da consulta corrente (TOP)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATR780 (TOPCONNECT)                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP6 IDE em 21/03/07 ==> Function A780CriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)
Static Function AEstFatCriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)
Local nI, nF, nPos
Local cFieldName := ""
nF := (cAlias)->(Fcount())
dbCreate(cArqTmp,aStruTmp)
DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
(cAlias)->(DbGoTop())
While ! (cAlias)->(Eof())
	(cAliasTmp)->(DbAppend())
	For nI := 1 To nF
		cFieldName := (cAlias)->( FieldName( ni ))
		If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
			(cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
		EndIf
	Next
	(cAlias)->(DbSkip())
End
(cAlias)->(dbCloseArea())
DbSelectArea(cAliasTmp)
Return Nil
