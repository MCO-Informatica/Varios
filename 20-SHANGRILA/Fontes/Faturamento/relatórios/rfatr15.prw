#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR15  ³ Autor ³ Genilson Moreira Lucas  ³ Data ³ 29/07/2010 ³±±
±±³          ³          ³       ³ MVG Consultoria Ltda    ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Faturamento por Região					          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Quebra por Estado					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR15()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao de Faturamento por Região"
Local cPict          := ""
Local titulo         := "Relacao de Faturamento  por Região"
Local nLin         	 := 80
Local Cabec1       	 := ""
Local Cabec2       	 := ""
Local imprime      	 := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFATR15"
Private nTipo        := 18
Private aOrd         := {"Por Região"}
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR15"
Private cString 	 := "SF2"
Private cPerg   	 := PadR("FATR15",Len(SX1->X1_GRUPO))
Private nOrdem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs := {}

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
AAdd(_aRegs,{cPerg,"11","Moeda ?		  ","Moeda ? 		  ","Moeda ? 		  ","mv_ch0","N",01,0,0,"C","","mv_par11","Real","Real","Real","Dolar","Dolar","Dolar","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,cPerg)

Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

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


Cabec1       	 := "REPRESENTANTE                              VALOR            VALOR              VALOR            VALOR            VALOR            VALOR            MARGEM            OBJETIVO            %COB"
Cabec2       	 := "                                           BRUTO            DEVOL              LIQUI            FRETE            SUBST            IPI"
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

_tValBru := 0
_tValDev := 0
_tValLiq := 0   
_tValFre := 0   
_tValSt  := 0   
_tValIpi := 0   
_tObjetiv:= 0   
_nObjetivo	:= 0


Titulo += Iif(MV_PAR11 == 1," - Em Real"," - Em Dolar")
//----> POR ESTADO
BuscaRegiao()	//----> query para busca dos dados de faturamento

dbSelectArea("QUERY")
SetRegua(RecCount())
dbGoTop()

While !Eof()
	
	If lAbortPrint
		@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		dbSelectArea("QUERY")
		dbSkip()
		Loop
	EndIf
	
	@ nLin, 000		PSAY QUERY->A1_REGIAO
		
	SX5->(DbSeek(XFilial("SX5")+"A2"+QUERY->A1_REGIAO))
	@ nLin, pCol()+001	PSAY SUBSTR(SX5->X5_DESCRI,1,30)
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL,xMoeda(QUERY->D2_TOTAL,1,2))					Picture "@E 9,999,999.99"  
	
	BuscaDev()	//----> query para busca dos dados de Devolução
	dbSelectArea("DEVOL")
	@ nLin, pCol()+005	PSAY Iif(MV_PAR11 == 1,DEVOL->D1_TOTAL, xMoeda(DEVOL->D1_TOTAL,1,2))								Picture "@E 9,999,999.99"  
	@ nLin, pCol()+007	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL-DEVOL->D1_TOTAL,xMoeda(QUERY->D2_TOTAL-DEVOL->D1_TOTAL,1,2))	Picture "@E 9,999,999.99"   
    @ nLin, pCol()+005	PSAY Iif(MV_PAR11 == 1,QUERY->D2_VALFRETE,xMoeda(QUERY->D2_VALFRETE,1,2))							Picture "@E 9,999,999.99"  
    @ nLin, pCol()+005	PSAY Iif(MV_PAR11 == 1,QUERY->D2_ICMSRET,xMoeda(QUERY->D2_ICMSRET,1,2))								Picture "@E 9,999,999.99"  
    @ nLin, pCol()+005	PSAY Iif(MV_PAR11 == 1,QUERY->D2_VALIPI,xMoeda(QUERY->D2_VALIPI,1,2))								Picture "@E 9,999,999.99"  
    
    
    //OBJETIVO 
    DbSelectArea("SCT")  // Entradas
	DbOrderNickName("FATR15")
	DbSeek(xFilial("SCT") + dtos(Mv_Par01) + QUERY->A1_REGIAO )
                                                                                                      
	While SCT->(!Eof()) .AND. SCT->CT_REGIAO = QUERY->A1_REGIAO
	
		_nObjetivo	+= SCT->CT_VALOR
	

		DbSelectArea("SCT")
		DbSkip()
	Enddo 

	@nLin, pCol()+006	PSAY 0	   						Picture "@E 9,999,999.99"  
	@nLin, pCol()+008	PSAY Iif(MV_PAR11 == 1,_nObjetivo,xMoeda(_nObjetivo,1,2))					Picture "@E 9,999,999.99"  
	@nLin, pCol()+010	PSAY Iif(MV_PAR11 == 1,(((QUERY->D2_TOTAL-DEVOL->D1_TOTAL)/_nObjetivo)*100), xMoeda((((QUERY->D2_TOTAL-DEVOL->D1_TOTAL)/_nObjetivo)*100),1,2))					Picture "@E 999.99"
	
	_tValBru += QUERY->D2_TOTAL
	_tValDev += DEVOL->D1_TOTAL
	_tValLiq += QUERY->D2_TOTAL - DEVOL->D1_TOTAL
	_tValFre += QUERY->D2_VALFRETE
	_tValSt	 += QUERY->D2_ICMSRET
	_tValIpi += QUERY->D2_VALIPI
	_tObjetiv+= _nObjetivo
	_nObjetivo := 0
	
	nLin++
	dbSelectArea("DEVOL")
	dbCloseArea("DEVOL")
	
	dbSelectArea("QUERY")
	dbSkip() 
EndDo

nLin++

If nLin > 70
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@ nLin, 000			PSAY "Total Geral: "
@ nLin, pCol()+023	PSAY Iif(MV_PAR11 == 1,_tValBru,xMoeda(_tValBru,1,2))			Picture "@E 9,999,999.99"  
@ nLin, pCol()+005	PSAY Iif(MV_PAR11 == 1,_tValDev,xMoeda(_tValDev,1,2))			Picture "@E 9,999,999.99"  
@ nLin, pCol()+007	PSAY Iif(MV_PAR11 == 1,_tValLiq,xMoeda(_tValLiq,1,2))			Picture "@E 9,999,999.99"  
@ nLin, pCol()+005	PSAY Iif(MV_PAR11 == 1,_tValFre,xMoeda(_tValFre,1,2))			Picture "@E 9,999,999.99"  
@ nLin, pCol()+005	PSAY Iif(MV_PAR11 == 1,_tValSt, xMoeda(_tValSt,1,2))			Picture "@E 9,999,999.99"  
@ nLin, pCol()+005	PSAY Iif(MV_PAR11 == 1,_tValIpi,xMoeda(_tValIpi,1,2))			Picture "@E 9,999,999.99"  
@ nLin, pCol()+006	PSAY 0					Picture "@E 9,999,999.99"  
@ nLin, pCol()+008	PSAY Iif(MV_PAR11 == 1,_tObjetiv,xMoeda(_tObjetiv,1,2))			Picture "@E 9,999,999.99"  
@ nLin, pCol()+010	PSAY Iif(MV_PAR11 == 1,(((_tValLiq)/_tObjetiv)*100),xMoeda((((_tValLiq)/_tObjetiv)*100),1,2))		Picture "@E 999.99"

dbSelectArea("QUERY")
dbCloseArea("QUERY")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function BuscaRegiao()

Local _cQuery := ""

_cQuery += "SELECT DISTINCT SA1010.A1_REGIAO, SUM(SD2010.D2_TOTAL) AS D2_TOTAL, SUM(SD2010.D2_VALFRE) AS D2_VALFRETE, "
_cQuery += "SUM(SD2010.D2_ICMSRET) AS D2_ICMSRET, SUM(SD2010.D2_VALIPI) AS D2_VALIPI "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA1010 ON SA1010.A1_COD = SD2010.D2_CLIENTE AND SA1010.A1_LOJA = SD2010.D2_LOJA "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA1010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND (SD2010.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') "
_cQuery += "AND (SB1010.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') "
_cQuery += "AND (SF2010.F2_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "    
_cQuery += "AND (SF2010.F2_VEND1 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "  
_cQuery += "AND SF4010.F4_DUPLIC = 'S' AND SF2010.F2_TIPO = 'N' "
_cQuery += "GROUP BY SA1010.A1_REGIAO "
_cQuery += "ORDER BY SA1010.A1_REGIAO "



_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])

Return


Static Function BuscaDev()

Local _cQuery := ""

_cQuery += "SELECT SA1010.A1_REGIAO, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC) AS D1_TOTAL "
_cQuery += "FROM SD1010 INNER JOIN "
_cQuery += "SD2010 ON SD1010.D1_NFORI = SD2010.D2_DOC AND SD1010.D1_SERIORI = SD2010.D2_SERIE AND " 
_cQuery += "SD1010.D1_FILIAL = SD2010.D2_FILIAL AND SD1010.D1_FORNECE = SD2010.D2_CLIENTE AND " 
_cQuery += "SD1010.D1_LOJA = SD2010.D2_LOJA AND "
_cQuery += "SD1010.D1_ITEMORI = SD2010.D2_ITEM INNER JOIN "

_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "

_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN " 

_cQuery += "SB1010 ON SD1010.D1_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SA1010 ON SA1010.A1_COD = SD1010.D1_FORNECE AND SA1010.A1_LOJA = SD1010.D1_LOJA "
_cQuery += "WHERE (SD1010.D_E_L_E_T_ = '') AND (SD1010.D1_TIPO IN ('B', 'D')) AND (SD2010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA1010.D_E_L_E_T_ = '') AND (SD1010.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
_cQuery += "SA1010.A1_REGIAO = '"+QUERY->A1_REGIAO+"' "
//_cQuery += "AND SF4010.F4_ESTOQUE = 'S'
_cQuery += "GROUP BY SA1010.A1_REGIAO, SD1010.D1_DTDIGIT "
_cQuery += "ORDER BY SA1010.A1_REGIAO "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOL",.T.,.T.)

TcSetField("DEVOL","D1_TOTAL"  ,"N",TamSX3("D1_TOTAL"  )[1],TamSX3("D1_TOTAL"  )[2])
MemoWrite("RFATR15.TXT",_cQuery)

Return