#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ RFATR105  ³ Autor ³ Marcos Floridi Leme    ³ Data ³ 02/02/2021 ³±±
±±³          ³          ³       ³ Fix System              ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Valores de Fretes           			          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR105()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Relação de NF x Fretes"
	Local cPict          := ""
	Local titulo         := "Relação de NF x Fretes"
	Local nLin         	 := 80
	Local Cabec1       	 := ""
	Local Cabec2       	 := ""
	Local imprime      	 := .T.

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "G"
	Private nomeprog     := "RFATR105"
	Private nTipo        := 18
	Private aOrd         := {}
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFATR105"
	Private cString 	 := "SF2"
	Private cPerg   	 := padr("RFATR104",len(sx1->x1_grupo))
	Private nOrdem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_aRegs := {}
/*
AAdd(_aRegs,{cPerg,"01","Data Inicial ?   ","Data Inicial ?   ","Data Inicial ?   ","mv_ch0","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"02","Data Final ?     ","Data Final ?     ","Data Final ?     ","mv_ch0","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"03","Do Grupo ?       ","Do Grupo ?     ? ","Do Grupo ?       ","mv_ch0","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","SBM","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"04","Ate o Grupo ?    ","Ate o Grupo ?    ","Ate o Grupo ?    ","mv_ch0","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","SBM","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"05","Do Produto ?     ","Do Produto ?     ","Do Produto ?     ","mv_ch0","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","SB1","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"06","Ate o Produto ?  ","Ate o Produto ?  ","Ate o Produto ?  ","mv_ch0","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","SB1","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"07","Do Estado ?      ","Do Estado ?      ","Do Estado ?      ","mv_ch0","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"08","Ate o Estado ?   ","Ate o Estado ?   ","Ate o Estado ?   ","mv_ch0","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"09","Do Vendedor ?    ","Do Vendedor ?    ","Do Vendedor ?    ","mv_ch0","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","SA3","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"10","Ate o Vendedor ? ","Ate o Vendedor ? ","Ate o Vendedor ? ","mv_ch0","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","SA3","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"11","Data Ref Meta (Objetivo) ?   ","Data Ref Meta (Objetivo)?","Data Ref Meta (Objetivo)?","mv_cha","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""}) */

AADD(_aRegs,{cPerg,"01","De Data                       ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{cPerg,"02","Ate Data                      ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{cPerg,"03","De Serie                      ","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(_aRegs,{cPerg,"04","Até Serie                     ","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(_aRegs,{cPerg,"05","De Cliente                    ","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""}) 
AADD(_aRegs,{cPerg,"06","Até Cliente                   ","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""}) 
AADD(_aRegs,{cPerg,"07","De Transportadora             ","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""}) 
AADD(_aRegs,{cPerg,"08","Até Transportadora            ","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""}) 
AADD(_aRegs,{cPerg,"09","De Redespacho                 ","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""}) 
AADD(_aRegs,{cPerg,"10","Até Redespacho                ","","","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""}) 
AADD(_aRegs,{cPerg,"11","De CTE                        ","","","mv_chb","C",09,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(_aRegs,{cPerg,"12","Até CTE                       ","","","mv_chc","C",09,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 

ValidPerg(_aRegs,cPerg)

Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

IF MV_PAR13 = 1
    titulo := "Relação de NF x Fretes - Padrao"
Elseif MV_PAR13 = 2
    titulo := "Relação de NF x Fretes - Fiscal"
Endif

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
	Return
	Endif

SetDefault(aReturn,cString)

	If nLastKey == 27
	Return
	Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]


If MV_PAR13 = 1 //Padrao
Cabec1       	 := "DATA        NF SERIE    CLIENTE               DESTINO     UF  VL_BRUTO    TRANSPORTADORA       TP_FRT  REDESPACHO              TP_REDESP  VL_REDESP   VALOR_CTE   PERC_FRT    VOLUME  PESO    FORN_CTE                 DACTE"
Cabec2       	 := "EMISSAO                "
Elseif MV_PAR13 = 2 //Fiscal
Cabec1       	 := "DATA        NF SERIE    CLIENTE               DESTINO     UF  CFOP            VL_BRUTO    TRANSPORTADORA         TP_TRANSP REDESP.     TP_REDESP         VL_REDESP   VALOR_CTE              FORN_CTE            DACTE"
Cabec2       	 := "EMISSAO                "
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

_VlBruto  := 0
_VlRedesp := 0
_VlCustCT := 0
_VlVolume := 0
_VlPeso   := 0

_cDoc       := ""
_cSerie     := ""
_cCliente   := ""

MOVNFE()


DbSelectArea("LISTFRT")
	While LISTFRT->(!Eof())
		If lAbortPrint
		@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
		Endif
	
		If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		Endif

_cDoc       := ""
_cSerie     := ""
_cDoc       := LISTFRT->NF
_cSerie     := LISTFRT->SERIE
_cCFOP      := ""
MOVCFOP()

DbSelectArea("LISTFRT")
While LISTCFOP->(!Eof())
    
    _cCFOP := LISTCFOP->D2_CF + _cCFOP
    LISTCFOP->(DbSkip())
	
EndDo
	dbSelectArea("LISTCFOP")
	dbCloseArea("LISTCFOP")

TOTNF()
DbSelectArea("TOTNF")
_VlBruto  := TOTNF->VLBRUTO
_VlRedesp := TOTNF->VLREDESP
_VlVolume := TOTNF->VVOLUME
_VlPeso   := TOTNF->VPESO

	dbSelectArea("TOTNF")
	dbCloseArea("TOTNF")

//_cCliente   := ""

If MV_PAR13 = 1 //Padrao


@ nLin, 000			PSAY LISTFRT->DTEMISSAO //DTOC(CTOD(LISTFRT->DTEMI
@ nLin, 013			PSAY LISTFRT->NF
@ nLin, 020 		PSAY LISTFRT->SERIE
@ nLin, 023			PSAY LISTFRT->COD_CLI + " " + SUBSTR(LISTFRT->CLIENTE,1,15)
@ nLin, 047			PSAY SUBSTR(LISTFRT->DESTINO,1,13) + " " + LISTFRT->UF
@ nLin, 060			PSAY LISTFRT->VL_BRUTO      Picture "@E 9,999,999.99"  
@ nLin, 075			PSAY LISTFRT->COD_TRANSP + " " + SUBSTR(LISTFRT->TRANSP,1,15)
@ nLin, 100			PSAY LISTFRT->TP_FRT
@ nLin, 105			PSAY LISTFRT->REDESP + " " + SUBSTR(LISTFRT->NOM_REDESP,1,15)
@ nLin, 130			PSAY LISTFRT->TP_REDESP
@ nLin, 135			PSAY LISTFRT->VL_REDESP      Picture "@E 9,999,999.99"
@ nLin, 145			PSAY LISTFRT->CUSTO_CTE      Picture "@E 9,999,999.99"
@ nLin, 155			PSAY LISTFRT->PERC_FRT       Picture "@E 9,999,999.99"
@ nLin, 165			PSAY LISTFRT->VOLUME         Picture "@E 9,999,999.99"
@ nLin, 175			PSAY LISTFRT->PESO           Picture "@E 9,999,999.99"
@ nLin, 188			PSAY LISTFRT->COD_FOR_CTE + " " + SUBSTR(LISTFRT->FORN_CTE,1,15)
@ nLin, 213			PSAY LISTFRT->NUM_CTE

Elseif MV_PAR13 = 2

@ nLin, 000			PSAY LISTFRT->DTEMISSAO //DTOC(CTOD(LISTFRT->DTEMI
@ nLin, 013			PSAY LISTFRT->NF
@ nLin, 020 		PSAY LISTFRT->SERIE
@ nLin, 023			PSAY LISTFRT->COD_CLI + " " + SUBSTR(LISTFRT->CLIENTE,1,15)
@ nLin, 047			PSAY SUBSTR(LISTFRT->DESTINO,1,13) + " " + LISTFRT->UF
@ nLin, 065			PSAY _cCFOP
@ nLin, 085			PSAY LISTFRT->VL_BRUTO      Picture "@E 9,999,999.99"  
@ nLin, 100			PSAY LISTFRT->COD_TRANSP + " " + SUBSTR(LISTFRT->TRANSP,1,15)
@ nLin, 125			PSAY LISTFRT->TP_FRT
@ nLin, 130			PSAY LISTFRT->REDESP + " " + SUBSTR(LISTFRT->NOM_REDESP,1,15)
@ nLin, 150			PSAY LISTFRT->VL_REDESP      Picture "@E 9,999,999.99"
@ nLin, 160			PSAY LISTFRT->CUSTO_CTE      Picture "@E 9,999,999.99"
//@ nLin, 145			PSAY LISTFRT->PERC_FRT       Picture "@E 9,999,999.99"
//@ nLin, 155			PSAY LISTFRT->VOLUME         Picture "@E 9,999,999.99"
//@ nLin, 165			PSAY LISTFRT->PESO           Picture "@E 9,999,999.99"
@ nLin, 180			PSAY LISTFRT->COD_FOR_CTE + " " + SUBSTR(LISTFRT->FORN_CTE,1,15)
@ nLin, 205			PSAY LISTFRT->NUM_CTE

Endif
		
nLin++

//_VlBruto    += LISTFRT->VL_BRUTO
//_VlRedesp   += LISTFRT->VL_REDESP
_VlCustCT   += LISTFRT->CUSTO_CTE
//_VlVolume   += LISTFRT->VOLUME
//_VlPeso     += LISTFRT->PESO



	LISTFRT->(DbSkip())
	
	EndDo
dbCloseArea("LISTFRT")
dbCloseArea("TOTNF")

nLin++
@ nLin, 000 PSAY __PrtThinLine()
nLin++

	If nLin > 65
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
	Endif

@ nLin, 013 		PSAY "Total Geral: --------->"
If MV_PAR13 = 1
@ nLin, 060			PSAY _VlBruto       Picture "@E 9,999,999.99"  
@ nLin, 134			PSAY _VlRedesp      Picture "@E 9,999,999.99"  
@ nLin, 147			PSAY _VlCustCT      Picture "@E 9,999,999.99"  
@ nLin, 156			PSAY ((_VlCustCT/_VlBruto)*100)      Picture "@E 9,999,999.99"  
@ nLin, 167			PSAY _VlVolume      Picture "@E 9,999,999.99"  
@ nLin, 178			PSAY _VlPeso        Picture "@E 9,999,999.99"  

Elseif MV_PAR13 = 2
@ nLin, 085			PSAY _VlBruto       Picture "@E 9,999,999.99"  
@ nLin, 150			PSAY _VlRedesp      Picture "@E 9,999,999.99"  
@ nLin, 160			PSAY _VlCustCT      Picture "@E 9,999,999.99"  
//@ nLin, 146			PSAY ((_VlCustCT/_VlBruto)*100)      Picture "@E 9,999,999.99"  
//@ nLin, 157			PSAY _VlVolume      Picture "@E 9,999,999.99"  
//@ nLin, 168			PSAY _VlPeso        Picture "@E 9,999,999.99"  
Endif

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return



Static Function MOVNFE()

	Local cQry2 := ""

	cQry2:= " SELECT "
	cQry2+= " CONVERT(varchar, CONVERT(datetime, F2_EMISSAO), 103) DTEMISSAO, "
	cQry2+= " F2_DOC NF, "
	cQry2+= " F2_SERIE SERIE, "
	cQry2+= " F2_CLIENTE COD_CLI, "
	cQry2+= " A1_NOME CLIENTE, "
	cQry2+= " A1_MUN DESTINO, "
	cQry2+= " A1_EST UF, "
	cQry2+= " F2_VALBRUT VL_BRUTO, F2_TRANSP COD_TRANSP,A4_NOME TRANSP, F2_TPFRETE TP_FRT,F2_REDESP REDESP, F2_X_NOMRD NOM_REDESP, F2_XVALFRR VL_REDESP, ISNULL(D1_TOTAL,0) CUSTO_CTE, "
	cQry2+= " ISNULL((D1_TOTAL/F2_VALBRUT)*100,0) PERC_FRT,F2_VOLUME1 VOLUME ,F2_PBRUTO PESO, "
	cQry2+= " ISNULL(D1_FORNECE,'') COD_FOR_CTE, ISNULL(A2_NOME,'') FORN_CTE, ISNULL(D1_DOC,'') NUM_CTE, ISNULL(D1_NFORI,'') NF_ORIG,ISNULL(D1_SERIORI,'') SERIE_ORIG, "
	cQry2+= " F2_XTPREDE TP_REDESP, F2_XTEMRED TEM_REDESP "
    cQry2+= " FROM SF2010 "
	cQry2+= " LEFT JOIN SA1010 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SA1010.D_E_L_E_T_ = '' "
	cQry2+= " LEFT JOIN SA4010 ON A4_COD = F2_TRANSP AND SA4010.D_E_L_E_T_ = '' "
	cQry2+= " LEFT JOIN SD1010 ON D1_FILIAL = F2_FILIAL AND SUBSTRING(D1_NFORI,4,6) = F2_DOC  AND SD1010.D_E_L_E_T_ = '' "
	cQry2+= " LEFT JOIN SA2010 ON A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND SA2010.D_E_L_E_T_ = '' "
	cQry2+= " WHERE SF2010.D_E_L_E_T_ = '' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND F2_TIPO = 'N' AND F2_SERIE BETWEEN'"+MV_PAR03+"' AND '"+MV_PAR04+"' AND F2_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQry2+= " F2_TRANSP BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND F2_REDESP BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND D1_DOC BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
	cQry2+= " ORDER BY F2_EMISSAO, F2_DOC "

	cQry2	:=	ChangeQuery(cQry2)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry2),"LISTFRT",.T.,.T.)

Return

Static Function MOVCFOP()

	Local cQry3 := ""

    cQry3:= "SELECT D2_DOC, D2_SERIE, D2_CLIENTE, D2_CF "
    cQry3+= "FROM SD2010 "
    cQry3+= "WHERE SD2010.D_E_L_E_T_ = '' AND D2_TIPO = 'N' AND D2_DOC = '"+_cDoc+"' AND D2_SERIE = '"+_cSerie+"' "
    cQry3+= "GROUP BY D2_DOC, D2_SERIE, D2_CLIENTE, D2_CF "

	cQry3	:=	ChangeQuery(cQry3)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry3),"LISTCFOP",.T.,.T.)

Return

Static Function TOTNF()

	Local cQry4 := ""

    cQry4:= " SELECT SUM(F2_VALBRUT) VLBRUTO, SUM(F2_XVALFRR) VLREDESP, SUM(F2_VOLUME1)VVOLUME ,SUM(F2_PBRUTO) VPESO "
    cQry4+= " FROM SF2010 "
    cQry4+= " WHERE SF2010.D_E_L_E_T_ = '' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND F2_TIPO = 'N' AND F2_SERIE = '0' AND F2_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQry4+= " F2_TRANSP BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND F2_REDESP BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
	cQry4:=	ChangeQuery(cQry4)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry4),"TOTNF",.T.,.T.)

Return
