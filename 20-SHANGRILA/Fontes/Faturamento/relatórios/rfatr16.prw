#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR14  ³ Autor ³ Genilson Moreira Lucas  ³ Data ³ 31/08/2010 ³±±
±±³          ³          ³       ³ MVG Consultoria Ltda    ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Faturamento por Grupo x Meta 			          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Quebra por Grupo						                          ³±±
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

User Function RFATR16()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação da Meta x Realizado por Grupo"
Local cPict          := ""
Local titulo         := "Relação da Meta x Vendido x Faturado por Grupo"
Local nLin         	 := 80
Local Cabec1       	 := ""
Local Cabec2       	 := ""
Local imprime      	 := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "RFATR16"
Private nTipo        := 18
Private aOrd         := {}
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR6"
Private cString 	 := "SF2"
Private cPerg   	 := padr("FATR16",len(sx1->x1_grupo))
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
AAdd(_aRegs,{cPerg,"11","Data Ref Meta (Objetivo) ?   ","Data Ref Meta (Objetivo)?","Data Ref Meta (Objetivo)?","mv_cha","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})

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


Cabec1       	 := "PRODUTO  DESC PRODUTO                             VALOR        QUANT        VALOR        QUANT          DIF     %           DIF     %         VALOR        QUANT"
Cabec2       	 := "                                                   META         META      VENDIDO      VENDIDO        VALOR   VALOR        QUANT	    QUANT     FATURADO     FATURADO"

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

lOCAL _nObjVal 	:= 0
Local _nObjQtd	:= 0
Local _vFatG 	:= 0
Local _vQtdG	:= 0
Local _mFatG  	:= 0
Local _mQtdG 	:= 0
Local _vFatT 	:= 0
Local _vQtdT	:= 0
Local _mFatT  	:= 0
Local _mQtdT 	:= 0
_TempGrup	:= ""
_TempCod	:= ""

nQtdreal 	:= 0
nVlrreal 	:= 0
nQtdrealT 	:= 0
nVlrrealT	:= 0

BuscaGrpALL()

DbSelectArea("SCT")  // META DE VENDAS
DbOrderNickName("RFATR16X")
DbSeek(xFilial("SCT") + dtos(Mv_Par11))
//While SCT->(!Eof()) .AND. SCT->CT_DATA = Mv_Par11
DbSelectArea("LISTGRP")
While LISTGRP->(!Eof())
	If lAbortPrint
		@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	
	_TempGrup := LISTGRP->CT_GRUPO
	
	@ nLin, 000			PSAY "----> GRUPO: " + _TempGrup
	@ nLin, pCol()+004	PSAY Posicione("SBM",1,xFilial("SBM")+_TempGrup,"BM_DESC")
	nLin+= 2
	
	BuscaProdutos(_TempGrup)
	While LISTPROD->(!Eof()) .and. _TempGrup == LISTPROD->CT_GRUPO
		
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		_TempCod	:= LISTPROD->CT_PRODUTO
		@ nLin, 000			PSAY ALLTRIM(_TempCod)
		@ nLin, 012			PSAY substr(Posicione("SB1",1,xFilial("SB1")+_TempCod,"B1_DESC"),1,30)
		
		_nObjVal	:= LISTPROD->CT_VALOR
		_nObjQtd	:= LISTPROD->CT_QUANT
		
		// -----> META
		@nLin, pCol()+001	PSAY _nObjVal					Picture "@E 9,999,999.99"
		@nLin, pCol()+001	PSAY _nObjQtd					Picture "@E 9,999,999.99"
		
		// -----> PREVISAO PEDIDO DE VENDA
		
		BuscaPdvGrupo()
		BuscaQPdv()
		
		@ nLin, pCol()+001	PSAY QUERYPDV->D2_TOTAL							Picture "@E 9,999,999.99"
		
		@ nLin, pCol()+001	PSAY QUANTPDV->D2_QUANT							Picture "@E 9,999,999.99"
		
		BuscaGrupo()
		BuscaQ()
		// -----> RESULTADO
		@ nLin, pCol()+001	PSAY QUERYPDV->D2_TOTAL - _nObjVal					Picture "@E 9,999,999.99"
		@ nLin, pCol()+001	PSAY (QUERYPDV->D2_TOTAL / _nObjVal) * 100			Picture "@E 999.99"
		@ nLin, pCol()+001	PSAY QUANTPDV->D2_QUANT - _nObjQtd					Picture "@E 9,999,999.99"
		@ nLin, pCol()+001	PSAY (QUANTPDV->D2_QUANT / _nObjQtd) * 100			Picture "@E 999.99"
		
		// -----> REAL
		//	BuscaGrupo()	//----> query para buscar dados de faturamento
		@ nLin, pCol()+001	PSAY QUERY->D2_TOTAL							Picture "@E 9,999,999.99"
		//	BuscaQ()
		@ nLin, pCol()+001	PSAY QUANT->D2_QUANT							Picture "@E 9,999,999.99"
		
		nLin++
		
		nQtdReal += QUANT->D2_QUANT
		nVlrReal += QUERY->D2_TOTAL
		nQtdRealT += QUANT->D2_QUANT
		nVlrRealT += QUERY->D2_TOTAL
		// TOTALIZADOR POR GRUPO
		_vFatG 	+= QUERYPDV->D2_TOTAL
		_vQtdG	+= QUANTPDV->D2_QUANT
		_mFatG  += _nObjVal
		_mQtdG  += _nObjQtd
		
		// TOTALIZADOR GERAL
		_vFatT 	+= QUERYPDV->D2_TOTAL
		_vQtdT	+= QUANTPDV->D2_QUANT
		_mFatT  += _nObjVal
		_mQtdT  += _nObjQtd
		
		_nObjVal	:= 0
		_nObjQtd	:= 0
		
		dbSelectArea("QUANT")
		dbCloseArea("QUANT")
		
		dbSelectArea("QUERY")
		dbCloseArea("QUERY")
		
		dbSelectArea("QUANTPDV")
		dbCloseArea("QUANTPDV")
		
		dbSelectArea("QUERYPDV")
		dbCloseArea("QUERYPDV")
		
		DbSelectArea("LISTPROD")
		DbSkip()
	Enddo
	
	@ nLin, 013			PSAY "Total Grupo: --------->"
	@ nLin, pCol()+007	PSAY _mFatG						Picture "@E 9,999,999.99"
	@ nLin, pCol()+001	PSAY _mQtdG						Picture "@E 9,999,999.99"
	@ nLin, pCol()+001	PSAY _vFatG						Picture "@E 9,999,999.99"
	@ nLin, pCol()+001	PSAY _vQtdG						Picture "@E 9,999,999.99"
	@ nLin, pCol()+001	PSAY _vFatG - _mFatG			Picture "@E 9,999,999.99"
	@ nLin, pCol()+001	PSAY (_vFatG / _mFatG) * 100	Picture "@E 999.99"
	@ nLin, pCol()+001	PSAY _vQtdG	- _mQtdG			Picture "@E 9,999,999.99"
	@ nLin, pCol()+001	PSAY (_vQtdG / _mQtdG) * 100	Picture "@E 999.99"
	
	@ nLin, pCol()+001	PSAY nVlrReal			Picture "@E 9,999,999.99"
	@ nLin, pCol()+001	PSAY nQtdReal	Picture "@E 9,999,999.99"
	
	
	_vFatG 	:= 0
	_vQtdG	:= 0
	_mFatG  := 0
	_mQtdG  := 0
	nVlrReal := 0
	nQtdReal := 0
	
	nLin++
	@ nLin, 000 PSAY __PrtThinLine()
	nLin++
	dbCloseArea("LISTPROD")
	LISTGRP->(DbSkip())
	
EndDo


dbCloseArea("LISTGRP")

nLin++
@ nLin, 000 PSAY __PrtThinLine()
nLin++

If nLin > 55
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@ nLin, 013 		PSAY "Total Geral: --------->"
@ nLin, pCol()+007	PSAY _mFatT						Picture "@E 9,999,999.99"
@ nLin, pCol()+001	PSAY _mQtdT						Picture "@E 9,999,999.99"
@ nLin, pCol()+001	PSAY _vFatT						Picture "@E 9,999,999.99"
@ nLin, pCol()+001	PSAY _vQtdT						Picture "@E 9,999,999.99"
@ nLin, pCol()+001	PSAY _vFatT - _mFatT			Picture "@E 9,999,999.99"
@ nLin, pCol()+001	PSAY (_vFatT / _mFatT) * 100	Picture "@E 999.99"
@ nLin, pCol()+001	PSAY _vQtdT	- _mQtdT			Picture "@E 9,999,999.99"
@ nLin, pCol()+001	PSAY (_vQtdT / _mQtdT) * 100	Picture "@E 999.99"

@ nLin, pCol()+001	PSAY nVlrRealT					Picture "@E 9,999,999.99"
@ nLin, pCol()+001	PSAY nQtdRealT		   			Picture "@E 9,999,999.99"

nLin+= 2
//@ nLin, 005			PSAY "OBS: Valor do Faturamento é somente para os produtos que tem meta cadastrada!"

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function BuscaGrupo()

Local _cQuery := ""

_cQuery += "SELECT DISTINCT SD2010.D2_COD, SUM(SD2010.D2_TOTAL) AS D2_TOTAL "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND SD2010.D2_COD = '"+_TempCod+"' "
_cQuery += "AND SB1010.B1_GRUPO = '"+_TempGrup+"' "
_cQuery += "AND (SF2010.F2_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "
_cQuery += "AND (SF2010.F2_VEND1 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "
_cQuery += "AND SF4010.F4_DUPLIC = 'S' AND SF2010.F2_TIPO = 'N' "
_cQuery += "GROUP BY SD2010.D2_COD "
_cQuery += "ORDER BY SD2010.D2_COD "

_cQuery	:=	ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])

Return


Static Function BuscaQ()

Local _cQuery := ""

_cQuery += "SELECT SUM(SD2010.D2_QUANT) AS D2_QUANT "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND SD2010.D2_COD = '"+_TempCod+"' "
_cQuery += "AND SB1010.B1_GRUPO = '"+_TempGrup+"' "
_cQuery += "AND (SF2010.F2_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "
_cQuery += "AND (SF2010.F2_VEND1 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "
_cQuery += "AND SF4010.F4_DUPLIC = 'S' AND SF4010.F4_ESTOQUE = 'S' "
_cQuery += "GROUP BY SB1010.B1_GRUPO, SD2010.D2_COD "
_cQuery += "ORDER BY SB1010.B1_GRUPO, SD2010.D2_COD "

_cQuery	:=	ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUANT",.T.,.T.)

Return

Static Function BuscaPdvGrupo()

Local _cQuery := ""

_cQuery := " SELECT C6_PRODUTO, SUM(D2_TOTAL) D2_TOTAL FROM ( "

_cQuery += " SELECT DISTINCT C6_PRODUTO,  SUM(C6_VALOR) D2_TOTAL "
_cQuery += " FROM " + RetSqlTab('SC6')
_cQuery += " INNER JOIN " + RetSqlTab('SB1')
_cQuery += " ON B1_FILIAL = '" + xFilial('SB1') + "' AND C6_PRODUTO = B1_COD AND B1_GRUPO BETWEEN '" + MV_PAR03  + "' AND '" + MV_PAR04 + "' AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SF4')
_cQuery += " ON F4_FILIAL = '" + xFilial('SF4') + "' AND C6_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SC5')
_cQuery += " ON C5_FILIAL = '" + xFilial('SC5') + "' AND C5_NUM = C6_NUM AND C5_TIPO = 'N' AND C5_VEND1 BETWEEN '" + MV_PAR09  + "' AND '" + MV_PAR10 + "' AND SC5.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SA1')
_cQuery += " ON A1_FILIAL = '" + xFilial('SA1') + "' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1_EST BETWEEN '" + MV_PAR07  + "' AND '" + MV_PAR08 + "' AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += " LEFT JOIN " + RetSqlTab('SC4')
_cQuery += " ON C4_FILIAL = '" + xFilial('SC4') + "' AND C6_PRODUTO = C4_PRODUTO AND C4_DATA = '" + DTOS(Mv_Par11) + "' AND SC4.D_E_L_E_T_ = ' '  "
//_cQuery += " LEFT JOIN " + RetSqlTab('SM2')
//_cQuery += " ON  C5_EMISSAO = M2_DATA AND SM2.D_E_L_E_T_ = ' '  "
_cQuery += " WHERE "
_cQuery += " C6_FILIAL = '" + xFilial('SC6') + "' AND "
_cQuery += " C6_PRODUTO BETWEEN '" + _TempCod + "' AND '" + _TempCod + "' AND "
_cQuery += " C6_ENTREG BETWEEN '" + DTOS(Mv_Par01) + "' AND '" + DTOS(Mv_Par02) + "' AND "
_cQuery += " SC6.D_E_L_E_T_ = '' AND A1_EST <> 'EX' "
//_cQuery += "GROUP BY C6_PRODUTO, A1_EST "
_cQuery += " GROUP BY C6_PRODUTO "

_cQuery += " UNION ALL "

//_cQuery += " SELECT C6_PRODUTO, D2_TOTAL * M2_MOEDA2 D2_TOTAL FROM ( "
_cQuery += " SELECT DISTINCT C6_PRODUTO,  SUM(C6_VALOR * M2_MOEDA2) D2_TOTAL "
_cQuery += " FROM " + RetSqlTab('SC6')
_cQuery += " INNER JOIN " + RetSqlTab('SB1')
_cQuery += " ON B1_FILIAL = '" + xFilial('SB1') + "' AND C6_PRODUTO = B1_COD AND B1_GRUPO BETWEEN '" + MV_PAR03  + "' AND '" + MV_PAR04 + "' AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SF4')
_cQuery += " ON F4_FILIAL = '" + xFilial('SF4') + "' AND C6_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SC5')
_cQuery += " ON C5_FILIAL = '" + xFilial('SC5') + "' AND C5_NUM = C6_NUM AND C5_TIPO = 'N' AND C5_VEND1 BETWEEN '" + MV_PAR09  + "' AND '" + MV_PAR10 + "' AND SC5.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SA1')
_cQuery += " ON A1_FILIAL = '" + xFilial('SA1') + "' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1_EST BETWEEN '" + MV_PAR07  + "' AND '" + MV_PAR08 + "' AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += " LEFT JOIN " + RetSqlTab('SC4')
_cQuery += " ON C4_FILIAL = '" + xFilial('SC4') + "' AND C6_PRODUTO = C4_PRODUTO AND C4_DATA = '" + DTOS(Mv_Par11) + "' AND SC4.D_E_L_E_T_ = ' '  "
_cQuery += " LEFT JOIN " + RetSqlTab('SM2')
_cQuery += " ON  C5_EMISSAO = M2_DATA AND SM2.D_E_L_E_T_ = ' '  "
_cQuery += " WHERE "
_cQuery += " C6_FILIAL = '" + xFilial('SC6') + "' AND "
_cQuery += " C6_PRODUTO BETWEEN '" + _TempCod + "' AND '" + _TempCod + "' AND "
_cQuery += " C6_ENTREG BETWEEN '" + DTOS(Mv_Par01) + "' AND '" + DTOS(Mv_Par02) + "' AND "
_cQuery += " SC6.D_E_L_E_T_ = '' AND A1_EST = 'EX' "
//_cQuery += "GROUP BY C6_PRODUTO, A1_EST "
_cQuery += " GROUP BY C6_PRODUTO) T "
_cQuery += " GROUP BY C6_PRODUTO "



//_cQuery += "LEFT JOIN " + RetSqlTab('SM2') ON  C5_EMISSAO = M2_DATA AND SM2.D_E_L_E_T_ = ' '  "
//=======----------Clientes EX
/*_cQuery += " UNION ALL "
_cQuery += " SELECT DISTINCT C6_PRODUTO, SUM(C6_VALOR * M2_MOEDA2) D2_TOTAL "
//_cQuery += " SELECT DISTINCT C6_PRODUTO, SUM(C6_VALOR) D2_TOTAL "
_cQuery += " FROM " + RetSqlTab('SC6')
_cQuery += " INNER JOIN " + RetSqlTab('SB1')
_cQuery += " ON B1_FILIAL = '" + xFilial('SB1') + "' AND C6_PRODUTO = B1_COD AND B1_GRUPO BETWEEN '" + MV_PAR03  + "' AND '" + MV_PAR04 + "' AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SF4')
_cQuery += " ON F4_FILIAL = '" + xFilial('SF4') + "' AND C6_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SC5')
_cQuery += " ON C5_FILIAL = '" + xFilial('SC5') + "' AND C5_NUM = C6_NUM AND C5_TIPO = 'N' AND C5_VEND1 BETWEEN '" + MV_PAR09  + "' AND '" + MV_PAR10 + "' AND SC5.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SA1')
_cQuery += " ON A1_FILIAL = '" + xFilial('SA1') + "' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1_EST BETWEEN '" + MV_PAR07  + "' AND '" + MV_PAR08 + "' AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += " LEFT JOIN " + RetSqlTab('SC4')
_cQuery += " ON C4_FILIAL = '" + xFilial('SC4') + "' AND C6_PRODUTO = C4_PRODUTO AND C4_DATA = '" + DTOS(Mv_Par11) + "' AND SC4.D_E_L_E_T_ = ' '  "
_cQuery += " LEFT JOIN " + RetSqlTab('SM2')
_cQuery += " ON  C5_EMISSAO = M2_DATA AND SM2.D_E_L_E_T_ = ' '  "
_cQuery += " WHERE "
_cQuery += " C6_FILIAL = '" + xFilial('SC6') + "' AND "
_cQuery += " C6_PRODUTO BETWEEN '" + _TempCod + "' AND '" + _TempCod + "' AND "
_cQuery += " C6_ENTREG BETWEEN '" + DTOS(Mv_Par01) + "' AND '" + DTOS(Mv_Par02) + "' AND "
_cQuery += " SC6.D_E_L_E_T_ = ' ' AND A1_EST = 'EX' "
_cQuery += "GROUP BY C6_PRODUTO, A1_EST "*/



_cQuery	:=	ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERYPDV",.T.,.T.)

TcSetField("QUERYPDV","C6_VALOR"  ,"N",TamSX3("C6_VALOR"  )[1],TamSX3("C6_VALOR"  )[2])

Return


Static Function BuscaQPdv()

Local _cQuery := ""

_cQuery += " SELECT SUM(C6_QTDVEN) D2_QUANT "
_cQuery += " FROM " + RetSqlTab('SC6')
_cQuery += " INNER JOIN " + RetSqlTab('SB1')
_cQuery += " ON B1_FILIAL = '" + xFilial('SB1') + "' AND C6_PRODUTO = B1_COD AND B1_GRUPO BETWEEN '" + MV_PAR03  + "' AND '" + MV_PAR04 + "' AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SF4')
_cQuery += " ON F4_FILIAL = '" + xFilial('SF4') + "' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SC5')
_cQuery += " ON C5_FILIAL = '" + xFilial('SC5') + "' AND C5_NUM = C6_NUM AND C5_VEND1 BETWEEN '" + MV_PAR09  + "' AND '" + MV_PAR10 + "' AND SC5.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlTab('SA1')
_cQuery += " ON A1_FILIAL = '" + xFilial('SA1') + "' AND A1_COD = C5_CLIENTE AND C5_TIPO = 'N' AND A1_LOJA = C5_LOJACLI AND A1_EST BETWEEN '" + MV_PAR07  + "' AND '" + MV_PAR08 + "' AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += " LEFT JOIN " + RetSqlTab('SC4')
_cQuery += " ON C4_FILIAL = '" + xFilial('SC4') + "' AND C6_PRODUTO = C4_PRODUTO AND C4_DATA = '" + DTOS(Mv_Par11) + "' AND SC4.D_E_L_E_T_ = ' '  "
_cQuery += " WHERE "
_cQuery += " C6_FILIAL = '" + xFilial('SC6') + "' AND "
_cQuery += " C6_PRODUTO BETWEEN '" + _TempCod + "' AND '" + _TempCod + "' AND "
_cQuery += " C6_ENTREG BETWEEN '" + DTOS(Mv_Par01) + "' AND '" + DTOS(Mv_Par02) + "' AND "
_cQuery += " F4_DUPLIC = 'S' AND "
_cQuery += " F4_ESTOQUE = 'S' AND "
_cQuery += " SC6.D_E_L_E_T_ = ' ' "


_cQuery	:=	ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUANTPDV",.T.,.T.)

Return


Static Function BuscaProdutos(cGrupo)

Local _cQuery := ""

_cQuery += " SELECT CT_GRUPO, CT_PRODUTO, SUM(CT_QUANT) CT_QUANT, SUM(CT_VALOR) CT_VALOR FROM (

_cQuery += " SELECT B1_GRUPO CT_GRUPO,C6_PRODUTO CT_PRODUTO, 0 CT_QUANT, 0 CT_VALOR "
_cQuery += " FROM " + RetSqlTab('SC6')
_cQuery += " INNER JOIN " + RetSqlTab('SB1')
_cQuery += " ON B1_FILIAL = '" + xFilial('SB1') + "' AND C6_PRODUTO = B1_COD AND B1_GRUPO BETWEEN '" + cGrupo  + "' AND '" + cGrupo + "' AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE "
_cQuery += " C6_FILIAL = '" + xFilial('SC6') + "' AND "
_cQuery += " C6_ENTREG BETWEEN '" + DTOS(Mv_Par01) + "' AND '" + DTOS(Mv_Par02) + "' AND "
_cQuery += " C6_PRODUTO BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND "
_cQuery += " SC6.D_E_L_E_T_ = ' ' "

_cQuery += " UNION ALL "

_cQuery += " SELECT B1_GRUPO CT_GRUPO, C4_PRODUTO CT_PRODUTO, C4_QUANT CT_QUANT, C4_VALOR CT_VALOR "
_cQuery += " FROM " + RetSqlTab('SC4')
_cQuery += " INNER JOIN " + RetSqlTab('SB1')
_cQuery += " ON B1_FILIAL = '" + xFilial('SB1') + "' AND C4_PRODUTO = B1_COD AND B1_GRUPO BETWEEN '" + cGrupo  + "' AND '" + cGrupo + "' AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE "
_cQuery += " C4_FILIAL = '" + xFilial('SC6') + "' AND "
_cQuery += " C4_DATA = '" + DTOS(Mv_Par11) + "' AND "
_cQuery += " C4_PRODUTO BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND "
_cQuery += " SC4.D_E_L_E_T_ = ' ' "

_cQuery += " ) TMP "

_cQuery += " GROUP BY CT_GRUPO, CT_PRODUTO "
_cQuery += " ORDER BY CT_GRUPO, CT_PRODUTO "

_cQuery	:=	ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"LISTPROD",.T.,.T.)

Return

Static Function BuscaGrpALL()

Local _cQuery := ""

_cQuery += " SELECT CT_GRUPO FROM (

_cQuery += " SELECT B1_GRUPO CT_GRUPO "
_cQuery += " FROM " + RetSqlTab('SC6')
_cQuery += " INNER JOIN " + RetSqlTab('SB1')
_cQuery += " ON B1_FILIAL = '" + xFilial('SB1') + "' AND C6_PRODUTO = B1_COD AND B1_GRUPO BETWEEN '" + MV_PAR03  + "' AND '" + MV_PAR04 + "' AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE "
_cQuery += " C6_FILIAL = '" + xFilial('SC6') + "' AND "
_cQuery += " C6_ENTREG BETWEEN '" + DTOS(Mv_Par01) + "' AND '" + DTOS(Mv_Par02) + "' AND "
_cQuery += " C6_PRODUTO BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND "
_cQuery += " SC6.D_E_L_E_T_ = ' ' "

_cQuery += " UNION ALL "

_cQuery += " SELECT B1_GRUPO CT_GRUPO "
_cQuery += " FROM " + RetSqlTab('SC4')
_cQuery += " INNER JOIN " + RetSqlTab('SB1')
_cQuery += " ON B1_FILIAL = '" + xFilial('SB1') + "' AND C4_PRODUTO = B1_COD AND B1_GRUPO BETWEEN '" + MV_PAR03  + "' AND '" + MV_PAR04 + "' AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE "
_cQuery += " C4_FILIAL = '" + xFilial('SC6') + "' AND "
_cQuery += " C4_DATA = '" + DTOS(Mv_Par11) + "' AND "
_cQuery += " C4_PRODUTO BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND "
_cQuery += " SC4.D_E_L_E_T_ = ' ' "

_cQuery += " ) TMP "

_cQuery += " GROUP BY CT_GRUPO "
_cQuery += " ORDER BY CT_GRUPO "

_cQuery	:=	ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"LISTGRP",.T.,.T.)

Return

