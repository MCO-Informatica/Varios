#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: VQCONSPRD| Autor: Celso Ferrone Martins   | Data: 01/04/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Consulta de saldo do PA selecionado e da  respectiva  MP   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | Revisado 12/08/2014 - Celso Martins                        |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function VQCONSPRD()

_bFiltraBrw	:= ''
_cFiltro  	:= ''

aCores      := {}

cTitulo:="Consulta Estoque de Produto"
cCadastro := "Consulta Estoque de Produto"

aRotina := {	{ "Pesquisa"   ,"AxPesqui"    , 0 , 1} ,;
{ "Visual"     ,"AxVisual"    , 0 , 2} ,;      //	      	{ "Prazo"     ,"U_VKVLDTC6()"    , 0 , 2} ,;
{ "Consulta"   ,"U_VQCONPROD(SB1->B1_COD)" , 0 , 3}}

mBrowse( 6, 1,22,75,"SB1",,,,,,aCores)

Return(.T.)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: VQCONPROD| Autor: Celso Ferrone Martins   | Data: 01/04/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Consulta de saldo do PA selecionado e da  respectiva  MP   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function VQCONPROD(cProduto)

Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local aAreaZ02	:= Z02->(GetArea())
Local aAreaZ03	:= Z03->(GetArea())
Local aViewB2	:= {}
Local aStruSB2  := {}
Local aNewSaldo := {}
Local oCursor	:= LoadBitMap(GetResources(),"LBNO")
Local nTotDisp	:= 0
Local nTotExecDisp:=0
Local nSaldo	:= 0
Local nQtPV		:= 0
Local nQemp		:= 0
Local nSalpedi	:= 0
Local nReserva	:= 0
Local nQtdEnd   := 0
Local nQempSA	:= 0
Local nSaldoSB2 :=0
Local nQtdTerc  :=0
Local nQtdNEmTerc:=0
Local nSldTerc  :=0
Local nQEmpN    :=0
Local nQAClass  :=0
Local nQEmpPrj  := 0
Local nQEmpPre  := 0
Local nX        := 0
Local nB2_QATU  := 0,nB2_QPEDVEN := 0,nB2_QEMP := 0,nB2_SALPEDI := 0,nB2_QEMPSA := 0,nB2_RESERVA :=0
Local nB2_QTNP  := 0,nB2_QNPT := 0,	nB2_QTER := 0,nB2_QEMPN := 0,nB2_QACLASS := 0,nB2_QPRJ := 0, nB2_QPRE := 0
Local nB2_PROD  := ""

Local cFilialSB2:= xFilial("SB2")
Local lViewSB2  := .T.
Local nAtIni    := 1
Local oListBox, oDlg, oBold
Local nHdl      := GetFocus()
Local cAlmox    := ""

Local nDolarDia := Posicione("SM2",1,DtoS(dDataBase), "M2_MOEDA2")
Local cCodOnu   := ""
Local cIteOnu   := ""

Local cEol      := CHR(13)+CHR(10)
Local lVersol   := .F.

nTotDisp 	:= 0
nSaldo	 	:= 0
nQtPV		:= 0
nQemp		:= 0
nSalpedi	:= 0
nReserva	:= 0
nQempSA		:= 0
nQtdTerc	:= 0
nQtdNEmTerc	:= 0
nSldTerc	:= 0
nQEmpN		:= 0
nQAClass	:= 0
nQEmpPrj    := 0
nQEmpPre    := 0

If Empty(cProduto)
	Return()
Endif

DbSelectArea("DY3") ; DbSetOrder(1)
DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("SB2") ; DbSetOrder(1)
DbSelectArea("SB5") ; DbSetOrder(1)
DbSelectArea("Z02") ; DbSetOrder(1)
DbSelectArea("Z03") ; DbSetOrder(2)
DbSelectArea("SA1") ; DbSetOrder(1)
DbSelectARea("SE4") ; DbSetOrder(1)

If SB1->(DbSeek(xFilial("SB1")+cProduto))
	
	cCodMp := ""
	
	If SB1->B1_TIPO == "MP"
		cCodMp := SB1->B1_COD
	Else
		cCodMp := SB1->B1_VQ_MP
	EndIf
	
	cProdMp := SB1->B1_VQ_MP
	lVersol := .F.
	If SB1->(DbSeek(xFilial("SB1")+cProdMp))
		lVersol := (SB1->B1_VQ_VERS == "S")
	EndIf
	
	SB1->(DbSeek(xFilial("SB1")+cProduto))
	cCursor  := "MAVIEWSB2"
	lQuery   := .T.
	aStruSB2 := SB2->(dbStruct())
	
	//Seleção dos PAs que são compostos pela MP
	/*
	If SB1->B1_TIPO == "MP"
	cQuery := "	SELECT * FROM "+RetSQLName("SB2")+" SB2 "
	cQuery += " WHERE "
	cQuery += "    SB2.D_E_L_E_T_ <> '*' "
	cQuery += "    AND B2_FILIAL = '"+xFilial("SB2")+"' "
	cQuery += "    AND B2_COD IN ( "
	cQuery += "       SELECT G1_COD FROM "+RetSQLName("SG1")+" SG1 "
	cQuery += "       WHERE "
	cQuery += "          SG1.D_E_L_E_T_ <> '*' "
	cQuery += "          AND G1_FILIAL = '"+xFilial("SG1")+"' "
	cQuery += "          AND G1_COMP = '"+cProduto+"' "
	cQuery += "       UNION ALL "
	cQuery += "       SELECT B1_COD FROM "+RetSQLName("SB1")+" SB1 "
	cQuery += "       WHERE "
	cQuery += "          SB1.D_E_L_E_T_ <> '*' "
	cQuery += "          AND B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += "          AND B1_COD = '"+cProduto+"' "
	cQuery += "    ) "
	
	Else
	
	cQuery := " SELECT                                                      " + cEol
	cQuery += "    SB2.*                                                    " + cEol
	cQuery += " FROM "+RetSQLName("SB2")+" SB2                              " + cEol
	cQuery += "    INNER JOIN "+RetSQLName("SG1")+" SG1 ON                  " + cEol
	cQuery += "       SG1.D_E_L_E_T_ <> '*'                                 " + cEol
	cQuery += "       AND SG1.G1_FILIAL = '"+xFilial("SG1")+"'              " + cEol
	cQuery += "       AND SG1.G1_COD    = SB2.B2_COD                        " + cEol
	cQuery += "       AND SG1.G1_COMP   = (                                 " + cEol
	cQuery += "             SELECT                                          " + cEol
	cQuery += "                SG1S.G1_COMP                                 " + cEol
	cQuery += "             FROM "+RetSQLName("SG1")+" SG1S                 " + cEol
	cQuery += "                INNER JOIN "+RetSQLName("SB1")+" SB1S ON     " + cEol
	cQuery += "                   SB1S.D_E_L_E_T_ <> '*'                    " + cEol
	cQuery += "                   AND SB1S.B1_FILIAL = '"+xFilial("SB1")+"' " + cEol
	cQuery += "                   AND SB1S.B1_COD    = SG1S.G1_COMP         " + cEol
	cQuery += "                   AND SB1S.B1_TIPO   = 'MP'                 " + cEol
	cQuery += "             WHERE                                           " + cEol
	cQuery += "                SG1S.D_E_L_E_T_ <> '*'                       " + cEol
	cQuery += "                AND SG1S.G1_FILIAL = '"+xFilial("SG1")+"'    " + cEol
	cQuery += "                AND SG1S.G1_COD    = '"+cProduto+"'          " + cEol
	cQuery += "       )                                                     " + cEol
	cQuery += "    INNER JOIN "+RetSQLName("SB1")+" SB1 ON                  " + cEol
	cQuery += "       SB1.D_E_L_E_T_ <> '*'                                 " + cEol
	cQuery += "       AND SB1.B1_FILIAL   = '"+xFilial("SB1")+"'            " + cEol
	cQuery += "       AND SB1.B1_COD      = SB2.B2_COD                      " + cEol
	If !lVersol
	cQuery += "       AND SB1.B1_VQ_VERS <> 'S'                             " + cEol
	EndIf
	cQuery += " WHERE                                                       " + cEol
	cQuery += "    SB2.D_E_L_E_T_ <> '*'                                    " + cEol
	cQuery += "    AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'                 " + cEol
	
	cQuery += " UNION                                                       " + cEol
	
	cQuery += " SELECT                                                      " + cEol
	cQuery += "    SB2.*                                                    " + cEol
	cQuery += " FROM "+RetSQLName("SB2")+" SB2                              " + cEol
	cQuery += " WHERE                                                       " + cEol
	cQuery += "    SB2.D_E_L_E_T_ <> '*'                                    " + cEol
	cQuery += "    AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'                 " + cEol
	cQuery += "    AND SB2.B2_COD = (                                       " + cEol
	cQuery += "          SELECT                                             " + cEol
	cQuery += "             SG1.G1_COMP                                     " + cEol
	cQuery += "          FROM "+RetSQLName("SG1")+" SG1                     " + cEol
	cQuery += "             INNER JOIN " +RetSQLName("SB1")+" SB1 ON        " + cEol
	cQuery += "                SB1.D_E_L_E_T_ <> '*'                        " + cEol
	cQuery += "                AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'     " + cEol
	cQuery += "                AND SG1.G1_COMP   = SB1.B1_COD               " + cEol
	cQuery += "                AND SB1.B1_TIPO   = 'MP'                     " + cEol
	cQuery += "          WHERE                                              " + cEol
	cQuery += "             SG1.D_E_L_E_T_ <> '*'                           " + cEol
	cQuery += "             AND SG1.G1_FILIAL = '"+xFilial("SG1")+"'        " + cEol
	cQuery += "             AND SG1.G1_COD    = '"+cProduto+"'              " + cEol
	cQuery += "    )                                                        " + cEol
	EndIf
	*/
	
	cQuery := " SELECT * FROM " +RetSQLName("SB2")+ " SB2                       " + cEol
	cQuery += " WHERE                                                           " + cEol
	cQuery += "    SB2.D_E_L_E_T_ <> '*'                                        " + cEol
	cQuery += "    AND SB2.B2_FILIAL = '"+xFilial("SB2")+"'                     " + cEol
	cQuery += "    AND B2_COD IN (                                              " + cEol
	cQuery += "       SELECT                                                    " + cEol
	cQuery += "          B1_COD                                                 " + cEol
	cQuery += "       FROM "+RetSQLName("SB1")+" SB1                            " + cEol
	cQuery += "       WHERE                                                     " + cEol
	cQuery += "          SB1.D_E_L_E_T_ <> '*'                                  " + cEol
	cQuery += "          AND (B1_COD = '"+cCodMp+"' OR B1_VQ_MP = '"+cCodMp+"') " + cEol
	cQuery += "       )                                                         " + cEol
	
	cQuery := ChangeQuery(cQuery)
	
	SB2->(dbCommit())
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
	
	For nX := 1 To Len(aStruSB2)
		If aStruSB2[nX][2]<>"C"
			TcSetField(cCursor,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
		EndIf
	Next nX
	
	dbSelectArea(cCursor)
	
	_xFil := (cCursor)->B2_FILIAL
	
	If EOF()
		aAdd(aViewB2,{TransForm("--",PesqPict("SB2","B2_FILIAL")),;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--",;
		"--"})
	EndIf
	
	While ( !Eof() )
		nSaldoSB2:=SaldoSB2(,,,,,cCursor)
		
		nB2_PROD    := (cCursor)->B2_COD
		nB2_QATU    := (cCursor)->B2_QATU
		nB2_QPEDVEN := (cCursor)->B2_QPEDVEN
		nB2_QEMP    := (cCursor)->B2_QEMP
		nB2_SALPEDI := (cCursor)->B2_SALPEDI
		nB2_QEMPSA  := (cCursor)->B2_QEMPSA
		nB2_RESERVA := (cCursor)->B2_RESERVA
		nB2_QTNP    := (cCursor)->B2_QTNP
		nB2_QNPT    := (cCursor)->B2_QNPT
		nB2_QTER    := (cCursor)->B2_QTER
		nB2_QEMPN   := (cCursor)->B2_QEMPN
		nB2_QACLASS := (cCursor)->B2_QACLASS
		nB2_QPRJ 	:= (cCursor)->B2_QEMPPRJ
		nB2_QPRE 	:= (cCursor)->B2_QEMPPRE
		
		//nTotDisp 	+= (cCursor)->B2_QATU
		nSaldo	 	+= (cCursor)->B2_QATU
		
		cQuery := " SELECT "
		cQuery += "    ISNULL(SUM(C6_QTDVEN-C6_QTDEMP ),0) AS QTD1, "
		cQuery += "    ISNULL(SUM(C6_UNSVEN-C6_QTDEMP2),0) AS QTD2  "
		cQuery += " FROM " + RetSqlName("SC6") + " SC6"
		cQuery += "    INNER JOIN " + RetSqlName("SF4") + " SF4 ON "
		cQuery += "       SF4.D_E_L_E_T_ <> '*' "
		cQuery += "       AND F4_FILIAL  = '"+xFilial("SF4")+"' "
		cQuery += "       AND F4_CODIGO  = C6_TES "
		cQuery += "       AND F4_ESTOQUE = 'S' "
		cQuery += " WHERE  "
		cQuery += "    SC6.D_E_L_E_T_ <> '*' "
		cQuery += "    AND C6_FILIAL   = '"+xFilial("SC6")+"' "
		cQuery += "    AND C6_PRODUTO  = '"+(cCursor)->B2_COD+"' "
		cQuery += "    AND C6_LOCAL    = '"+(cCursor)->B2_LOCAL+"' "
		cQuery += "    AND C6_NOTA     = ' ' "
		cQuery += "    AND C6_BLQ     <> 'R' "
		
		cQuery := ChangeQuery(cQuery)
		
		If Select("TRBSC6") > 0
			TRBSC6->(DbCloseArea())
		EndIf
		
		TcQuery cQuery New Alias "TRBSC6"
		
		nSaldoSB2 -= TRBSC6->QTD1
		//nTotDisp += nSaldoSB2
		nTotDisp += nSaldoSB2+nB2_QACLASS
		
		If Select("TRBSC6") > 0
			TRBSC6->(DbCloseArea())
		EndIf
		
		aNewSaldo := {}
		aAdd(aNewSaldo,{nSaldoSB2,nB2_PROD,nB2_QATU,nB2_QPEDVEN,nB2_QEMP,nB2_SALPEDI,nB2_QEMPSA,nB2_RESERVA,nB2_QTNP,;
		nB2_QNPT,nB2_QTER,nB2_QEMPN,nB2_QACLASS,nB2_QPRJ,nB2_QPRE})
		
		If _xFil <> (cCursor)->B2_FILIAL
			_xFil := (cCursor)->B2_FILIAL
			aAdd(aViewB2,{TransForm("--",PesqPict("SB2","B2_FILIAL")),;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--",;
			"--"})
		EndIf
		
		nSalPedi += nB2_SALPEDI
		nQtPv    += nB2_QPEDVEN
		nReserva += nB2_RESERVA
		nQtdEnd  += nB2_QACLASS
		
		aAdd(aViewB2,{;
		TransForm((cCursor)->B2_FILIAL,PesqPict("SB2","B2_FILIAL"  )),;
		TransForm(nB2_PROD            ,PesqPict("SB2","B2_COD"     )),;
		AllTrim(Posicione("SB1",1,xFilial("SB1")+nB2_PROD,"B1_DESC")),;
		TransForm((cCursor)->B2_LOCAL ,PesqPict("SB2","B2_LOCAL"   )),;
		AllTrim(Posicione("SB1",1,xFilial("SB1")+nB2_PROD,"B1_UM"  )),;
		TransForm(nSaldoSB2           ,PesqPict("SB2","B2_QATU"    )),;
		TransForm(nB2_QATU            ,PesqPict("SB2","B2_QATU"    )),;
		TransForm(nB2_QPEDVEN         ,PesqPict("SB2","B2_QPEDVEN" )),;
		TransForm(nB2_QEMP            ,PesqPict("SB2","B2_QEMP"    )),;
		TransForm(nB2_SALPEDI         ,PesqPict("SB2","B2_SALPEDI" )),;
		TransForm(nB2_QEMPSA          ,PesqPict("SB2","B2_QEMPSA"  )),;
		TransForm(nB2_RESERVA         ,PesqPict("SB2","B2_RESERVA" )),;
		TransForm(nB2_QTNP            ,PesqPict("SB2","B2_QTNP"    )),;
		TransForm(nB2_QNPT            ,PesqPict("SB2","B2_QNPT"    )),;
		TransForm(nB2_QTER            ,PesqPict("SB2","B2_QTER"    )),;
		TransForm(nB2_QEMPN           ,PesqPict("SB2","B2_QEMPN"   )),;
		TransForm(nB2_QACLASS         ,PesqPict("SB2","B2_QACLASS" )),;
		TransForm(nB2_QPRJ            ,PesqPict("SB2","B2_QEMPPRJ" )),;
		TransForm(nB2_QPRE            ,PesqPict("SB2","B2_QEMPPRE" ))})
		
		If !Empty(cAlmox) .And. cAlmox == (cCursor)->B2_LOCAL
			nAtIni := Len(aViewB2)
		EndIf
		
		dbSelectArea(cCursor)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cCursor)
		dbCloseArea()
		dbSelectArea("SB2")
	EndIf
	/*
	//Consulta de entrada prevista da matéria prima
	cQuery := " SELECT                                                          " + cEol
	cQuery += "    SUM(C7_QUANT-C7_QUJE) ENTRADA                                " + cEol
	cQuery += " FROM "+RetSQLName("SC7")+" SC7                                  " + cEol
	cQuery += " WHERE                                                           " + cEol
	cQuery += "    SC7.D_E_L_E_T_ <> '*'                                        " + cEol
	cQuery += "    AND C7_FILIAL   = '"+xFilial("SC7")+"'                       " + cEol
	cQuery += "    AND C7_ENCER   <> 'E'                                        " + cEol
	//	cQuery += "    AND C7_PRODUTO  = '"+cProduto+"'                             " + cEol
	cQuery += "    AND C7_PRODUTO IN (                                          " + cEol
	cQuery += "       SELECT                                                    " + cEol
	cQuery += "          B1_COD                                                 " + cEol
	cQuery += "       FROM "+RetSQLName("SB1")+" SB1                            " + cEol
	cQuery += "       WHERE                                                     " + cEol
	cQuery += "          SB1.D_E_L_E_T_ <> '*'                                  " + cEol
	cQuery += "          AND (B1_COD = '"+cCodMp+"' OR B1_VQ_MP = '"+cCodMp+"') " + cEol
	cQuery += "       )                                                         " + cEol
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TREP") > 0
	TREP->(DbCloseArea())
	EndIf
	
	TcQuery cQuery NEW ALIAS TREP
	
	Dbselectarea("TREP")
	If !TREP->(EOF())
	nSalPedi := TREP->ENTRADA
	Endif
	Dbclosearea("TREP")
	*/
	
	/*
	//Consulta de saldo em pedido de venda
	cQuery := " SELECT                                                          " + cEol
	cQuery += "    SUM(SC6.C6_QTDVEN) PEDIDO                                    " + cEol
	cQuery += " FROM "+RetSQLName("SC6")+" SC6                                  " + cEol
	cQuery += " WHERE                                                           " + cEol
	cQuery += "    SC6.D_E_L_E_T_ <> '*'                                        " + cEol
	cQuery += "    AND C6_FILIAL = '"+xFilial("SC6")+"'                         " + cEol
	cQuery += "    AND C6_QTDVEN > SC6.C6_QTDENT                                " + cEol
	//	cQuery += "    AND C6_PRODUTO = '"+cProduto+"'                              " + cEol
	cQuery += "    AND C6_PRODUTO IN (                                          " + cEol
	cQuery += "       SELECT                                                    " + cEol
	cQuery += "          B1_COD                                                 " + cEol
	cQuery += "       FROM "+RetSQLName("SB1")+" SB1                            " + cEol
	cQuery += "       WHERE                                                     " + cEol
	cQuery += "          SB1.D_E_L_E_T_ <> '*'                                  " + cEol
	cQuery += "          AND (B1_COD = '"+cCodMp+"' OR B1_VQ_MP = '"+cCodMp+"') " + cEol
	cQuery += "       )                                                         " + cEol
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TRPED") > 0
	TRPED->(DbCloseArea())
	EndIf
	
	TcQuery cQuery NEW ALIAS TRPED
	Dbselectarea("TRPED")
	
	If !TRPED->(EOF())
	nQtPv := TRPED->PEDIDO
	Endif
	Dbclosearea("TRPED")
	*/
	/*
	//Consulta de saldo reservado (liberado na SC9)
	cQuery := " SELECT                                                          " + cEol
	cQuery += "		SUM(C9_QTDLIB) RESERV                                       " + cEol
	cQuery += " FROM "+RetSQLName("SC9") + " SC9                                " + cEol
	cQuery += " WHERE                                                           " + cEol
	cQuery += "    SC9.D_E_L_E_T_ <> '*'                                        " + cEol
	cQuery += "    AND C9_BLEST  <> '10'                                        " + cEol
	cQuery += "    AND C9_FILIAL  = '"+xFilial("SC9")+"'                        " + cEol
	//	cQuery += "    AND C9_PRODUTO = '"+cProduto+"'                              " + cEol
	cQuery += "    AND C9_PRODUTO IN (                                          " + cEol
	cQuery += "       SELECT                                                    " + cEol
	cQuery += "          B1_COD                                                 " + cEol
	cQuery += "       FROM "+RetSQLName("SB1")+" SB1                            " + cEol
	cQuery += "       WHERE                                                     " + cEol
	cQuery += "          SB1.D_E_L_E_T_ <> '*'                                  " + cEol
	cQuery += "          AND (B1_COD = '"+cCodMp+"' OR B1_VQ_MP = '"+cCodMp+"') " + cEol
	cQuery += "       )                                                         " + cEol
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TRRES") > 0
	TRRES->(DbCloseArea())
	EndIf
	
	TcQuery cQuery NEW ALIAS TRRES
	Dbselectarea("TRRES")
	If !TRRES->(EOF())
	nReserva := TRRES->RESERV
	Endif
	Dbclosearea("TRRES")
	*/
	aTabela := {}
	If Z02->(DbSeek(xFilial("Z02")+cProduto))
		cTabela := "A"
		For nTabela := 1 To 5
			If Z03->(DbSeek(xFilial("Z03")+cProduto+Z02->Z02_REVISA+cTabela))
				nZ03ValCal := 0
				If AllTrim(Upper(FunName())) == "TMKA271"
					nSe4Indice := 1
					nSa1Indice := 0
					If SE4->(DbSeek(xFilial("SE4")+M->UA_CONDPG))
						If SE4->E4_VQ_INDI > 0
							nSe4Indice := SE4->E4_VQ_INDI
						EndIf
					EndIf
					If SA1->(DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA))
						If SA1->A1_VQ_CMAD > 0
							nSa1Indice := SA1->A1_VQ_CMAD
						EndIf
					EndIf
					If !GdDeleted(n,aHeader,aCols)
						nZ03ValCal := CfmValCal(cTabela,nSe4Indice,nSa1Indice)
						//						nZ03ValCal := nZ03ValCal*nSe4Indice
					EndIf
				ElseIf SubStr(AllTrim(Upper(FunName())),1,4) $ "MATA|FATA"
					nSe4Indice := 1
					nSa1Indice := 0
					If SE4->(DbSeek(xFilial("SE4")+M->C5_CONDPAG))
						If SE4->E4_VQ_INDI > 0
							nSe4Indice := SE4->E4_VQ_INDI
						EndIf
					EndIf
					If SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
						If SA1->A1_VQ_CMAD > 0
							nSa1Indice := SA1->A1_VQ_CMAD
						EndIf
					EndIf
					If !GdDeleted(n,aHeader,aCols)
						nZ03ValCal := CfmVal2Cal(cTabela,nSe4Indice,nSa1Indice)
						//						nZ03ValCal := nZ03ValCal*nSe4Indice
					EndIf
				Else
					nZ03ValCal := Z03->Z03_VALCAL
				EndIf
				AAdd(aTabela, nZ03ValCal)
			EndIf
			cTabela := Soma1(cTabela)
		Next
	EndIf
	
	SB2->(Dbseek(xFilial("SB2")+cProduto))
	
	SB1->(DbSeek(xFilial("SB1")+cProduto))
	SB5->(DbSeek(xFilial("SB5")+cProduto))  
	DY3->(DbSeek(xFilial("DY3")+SB5->(B5_ONU+B5_ITEM)))// ALVES 28/06/2016
	
	cQuery := " SELECT "
	cQuery += "    ISNULL(SUM(C6_QTDVEN-C6_QTDEMP ),0) AS QTD1, "
	cQuery += "    ISNULL(SUM(C6_UNSVEN-C6_QTDEMP2),0) AS QTD2  "
	cQuery += " FROM " + RetSqlName("SC6") + " SC6"
	cQuery += " WHERE  "
	cQuery += "    SC6.D_E_L_E_T_ <> '*' "
	cQuery += "    AND C6_FILIAL  = '"+xFilial("SC6")+"' "
	cQuery += "    AND C6_PRODUTO = '"+cProduto+"' "
	cQuery += "    AND C6_NOTA    = ' ' "
	cQuery += "    AND C6_BLQ    <> 'R' "
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TRBSC6") > 0
		TRBSC6->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TRBSC6"
	
	nQtdDisp := SaldoSB2()
	//nQtdDisp -= TRBSC6->QTD1
	nQtdDisp -= TRBSC6->QTD1+nB2_QACLASS
	
	If Select("TRBSC6") > 0
		TRBSC6->(DbCloseArea())
	EndIf
	
	//Montagem da exibição
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 000,000  TO 550,600 TITLE "Saldos em Estoque" Of oMainWnd PIXEL //
	@ 003,004 To 14,296 Label "" of oDlg PIXEL
	
	oListBox := TWBrowse():New( 65,2,296,050,,{"Filial",RetTitle("B2_COD"),"Nome","Local","UM","Qtd.Disponivel","Sld.Atual","Qtd.Pedido de Vendas","Qtd. Empenhada","Qtd. Prevista Entrada","Qtd.Empenhada S.A.","Qtd. Reservada",RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER"),RetTitle("B2_QEMPN"),RetTitle("B2_QACLASS"),RetTitle("B2_QEMPPRJ"),RetTitle("B2_QEMPPRE")},{17,55,55,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aViewB2)
	oListBox:bLine := { || aViewB2[oListBox:nAT]}
	oListBox:nAt   := Max(1,nAtIni)
	@ 004,010 SAY Alltrim(cProduto)+ " - "+SB1->B1_DESC Of oDlg PIXEL SIZE 245,009 FONT oBold
	
	@ 20,007 SAY "Quantidade Disponivel    " of oDlg PIXEL //
	//@ 19,075 MsGet SB2->B2_QATU Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
	@ 19,075 MsGet nQtdDisp Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 20,155 SAY "Saldo Atual   " of oDlg PIXEL //
	@ 19,223 MsGet SB2->B2_QATU Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 35,007 SAY "Qtd. Entrada Prevista" of oDlg PIXEL //
	@ 34,075 MsGet SB2->B2_SALPEDI Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 35,155 SAY "Qtd. Pedido de Vendas  " of oDlg PIXEL //
	@ 34,223 MsGet SB2->B2_QPEDVEN Picture PesqPict("SB2","B2_QPEDVEN") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 50,007 SAY "Qtd. Reservada  " of oDlg PIXEL //
	@ 49,075 MsGet SB2->B2_RESERVA Picture PesqPict("SB2","B2_RESERVA") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 50,155 SAY "Qtd. a Enderecar" of oDlg PIXEL //
	@ 49,223 MsGet SB2->B2_QACLASS Picture PesqPict("SB2","B2_QACLASS") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 124,007 SAY "TOTAL DA MATÉRIA-PRIMA" Of oDlg PIXEL SIZE 100 ,9 FONT oBold  //
	
	@ 135,007 SAY "Quantidade Disponivel    " of oDlg PIXEL //
	@ 134,075 MsGet nTotDisp Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 135,155 SAY "Saldo Atual   " of oDlg PIXEL //
	@ 134,223 MsGet nSaldo Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 150,007 SAY "Qtd. Entrada Prevista" of oDlg PIXEL //
	@ 149,075 MsGet nSalPedi Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 150,155 SAY "Qtd. Pedido de Vendas  " of oDlg PIXEL //
	@ 149,223 MsGet nQtPv Picture PesqPict("SB2","B2_QPEDVEN") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 165,007 SAY "Qtd. Reservada  " of oDlg PIXEL //
	@ 164,075 MsGet nReserva Picture PesqPict("SB2","B2_RESERVA") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 165,155 SAY "Qtd. a Enderecar" of oDlg PIXEL //
	@ 164,223 MsGet nQtdEnd Picture PesqPict("SB2","B2_QACLASS") of oDlg PIXEL SIZE 070,009 When .F.
	
	@ 180,007 SAY "Tabela A  " of oDlg PIXEL //
	@ 190,007 MsGet If(Empty(aTabela), 0, aTabela[1]) Picture PesqPict("Z03","Z03_VALCAL") of oDlg PIXEL SIZE 050,009 When .F.
	
	@ 180,066 SAY "Tabela B  " of oDlg PIXEL //
	@ 190,066 MsGet If(Empty(aTabela), 0, aTabela[2]) Picture PesqPict("Z03","Z03_VALCAL") of oDlg PIXEL SIZE 050,009 When .F.
	
	@ 180,125 SAY "Tabela C  " of oDlg PIXEL //
	@ 190,125 MsGet If(Empty(aTabela), 0, aTabela[3]) Picture PesqPict("Z03","Z03_VALCAL") of oDlg PIXEL SIZE 050,009 When .F.
	
	@ 180,184 SAY "Tabela D  " of oDlg PIXEL //
	@ 190,184 MsGet If(Empty(aTabela), 0, aTabela[4]) Picture PesqPict("Z03","Z03_VALCAL") of oDlg PIXEL SIZE 050,009 When .F.
	
	@ 180,243 SAY "Tabela E  " of oDlg PIXEL //
	@ 190,243 MsGet If(Empty(aTabela), 0, aTabela[5]) Picture PesqPict("Z03","Z03_VALCAL") of oDlg PIXEL SIZE 050,009 When .F.
	
	@ 205,007 SAY "Cotação US$" of oDlg PIXEL //
	@ 215,007 MsGet nDolarDia                         Picture PesqPict("SM2", "M2_MOEDA2") of oDlg PIXEL SIZE 050,009 When .F.
	
	@ 205,066 SAY "Codigo Onu + Item" of oDlg PIXEL //
	@ 215,066 MsGet SB5->(B5_ONU+B5_ITEM)             Picture "@!"                         of oDlg PIXEL SIZE 050,009 When .F.  
	
	@ 205,125 SAY "Classe" of oDlg PIXEL //
	@ 215,125 MsGet DY3->DY3_CLASSE  Picture "@!"                         of oDlg PIXEL SIZE 050,009 When .F.

	@ 205,184 SAY "Risco" of oDlg PIXEL //
	@ 215,184 MsGet DY3->DY3_NRISCO  Picture "@!"                         of oDlg PIXEL SIZE 050,009 When .F.		
   
 	@ 205,243 SAY "Grupo Embalagem" of oDlg PIXEL //
	@ 215,243 MsGet DY3->DY3_GRPEMB  Picture "@!"                         of oDlg PIXEL SIZE 050,009 When .F.			 
		 
 	@ 230,007 SAY "Controlado Pol. Civil" of oDlg PIXEL //
	@ 240,007 MsGet IF(SB5->B5_PRODPC="S", "Sim", "Nao")  Picture "@!"                         of oDlg PIXEL SIZE 050,009 When .F.   
	
	@ 230,066 SAY "Controlado Pol. Federal" of oDlg PIXEL //
	@ 240,066 MsGet IF(SB5->B5_PRODPF="S", "Sim", "Nao")  Picture "@!"                         of oDlg PIXEL SIZE 050,009 When .F.			
	 
	@ 230,125 SAY "Controlado Exercito" of oDlg PIXEL //
	@ 240,125 MsGet IF(SB5->B5_PRODEX="S", "Sim", "Nao")  Picture "@!"                         of oDlg PIXEL SIZE 050,009 When .F.						
	
	@ 235,243  BUTTON "Voltar" SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
EndIf

SM0->(RestArea(aAreaSM0))
SB2->(RestArea(aAreaSB2))
SB1->(RestArea(aAreaSB1))
Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))

RestArea(aArea)
SetFocus(nHdl)

Return(.T.)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmValCal | Autor: Celso Ferrone Martins  | Data: 01/04/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmValCal(cTabela,nSe4Indice,nSa1Indice)

Local cRetValCl  := 0
Local aParamCst  := {}
Local aRetCusto  := {}
Local nZ01FTonel := 0
Local nValFrete  := 0
Local aValFrete  := {}
Local nFatorFret := 1
Local nZ03FreEnt := 0

Local nPosProd   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // Produto
Local nPosMP     := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MP"})   // Materia Prima
Local nPosEM     := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_EM"})   // Embalagem
Local nPosCapa   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"}) // Capacidade
Local nPosDens   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_DENS"}) // Densidade
Local nPosVal    := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VAL"})  // Valor tabela
Local nPosTabe   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TABE"}) // Tabela
Local nPosMoed   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MOED"}) // Moeda
Local nPosIpi    := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_IPI"})  // IPI
Local nPosMark   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MARK"}) // MarkUp
Local nPosVqUm   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_UM"})   // Unidade de Medida Verquimica
Local nPosTemt   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TEMT"}) // Tem Tabela ?

Local nPosVRTb   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRCTAB"})  // Tabela de Preço
Local nPUniUm1   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT"})  // Valor Unitário
Local nPQtdVer   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"}) // Quantidade
Local nPTotUm1   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"}) // Valor Total
Local nPosUm     := aScan(aHeader,{|x| AllTrim(x[2])=="UB_UM"})      // Unidade de Medida Padrao
Local nPosMoVq   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_MOVQ"}) // Moeda padrao

Local nPosVolum  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VOLU"}) // VOLUME

Local nPosPICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PICM"}) // Percentual de ICMS
Local nPosPPis   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PPIS"}) // Percentual de Pis
Local nPosPCof   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PCOF"}) // Percentual de Cof

Local nPosSICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_SICM"}) // ICMS Substituicao Triburaria
Local nPosVIPI   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VIPI"}) // Valor do IPI

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // Pis Cofins
Local nIcmsCliVq := 18   // Icms Padrao da Tabela
Local _nPisCliVq := 0
Local _nCofCliVq := 0

Local nFatorDens  := 1
Local lDensidade  := .F.
Local lMoeda      := .F.

Local aAreaZ02   := Z01->(GetArea())
Local aAreaZ03   := Z03->(GetArea())
Local aAreaSb1   := SB1->(GetArea())

Local nPesoTot   := 0
Local nQtdEmb    := 0

DbSelectArea("Z02") ; DbSetOrder(1)
DbSelectArea("Z03") ; DbSetOrder(2)

For nX := 1 To Len(aCols)
	If !GdDeleted(nX,aHeader,aCols)
		If !Empty(aCols[nX][nPosProd])
			If aCols[nX][nPosVqUm] == "KG"
				nPesoTot += aCols[nX][nPQtdVer]
			Else
				nPesoTot += aCols[nX][nPQtdVer] * aCols[nX][nPosDens]
			EndIf
			If AllTrim(aCols[nx][nPosEM]) != "03000"
				nQtdEmb              += aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
				aCols[nx][nPosVolum] := aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
				
			EndIf
		EndIf
	EndIf
Next nX

//M->UA_VQ_QEMB := nQtdEmb

//StaticCall(fGFrete,AjustaSx6)

//U_FGFRETE()

aIcmsAli := &(StrTran(StrTran(FormatIn(AllTrim(GetMv("VQ_ICMSALI")),"|"),"(","{"),")","}"))
aIcmsOri := &("{{'"+StrTran(StrTran(AllTrim(GetMv("VQ_ICMSORI")),"-","',"),"|","},{'")+"}}")

For Nx := 1 To Len(aIcmsAli)
	If SubStr(aIcmsAli[nX],1,2) == SA1->A1_EST
		nIcmsCliVq := Val(SubStr(aIcmsAli[nX],3,2))
	EndIf
Next Nx


If !Empty(aCols[n][nPosProd])
	
	Z02->(DbSeek(xFilial("Z02")+aCols[n][nPosProd]))
	Z03->(DbSeek(xFilial("Z03")+aCols[n][nPosProd]+Z02->Z02_REVISA+cTabela))
	
	If Z02->Z02_UM == aCols[n][nPosVqUm] .And. Z02->Z02_MOEDA == aCols[n][nPosMoed]
		nZ03FreEnt := Z03->Z03_FREENT
	Else
		nZ03FreEnt := Z03->Z03_FREENT
	EndIf
/*	
	If Empty(aCols[n][nPosProd])
		
		SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
		If SA1->A1_EST != "SP"
			For nY := 1 To Len(aIcmsOri)
				If aIcmsOri[nY][1] == SB1->B1_ORIGEM
					nIcmsCliVq := aIcmsOri[nY][2]
					Exit
				EndIf
			Next nY
		EndIf
		
		If !Empty(SB1->B1_GRTRIB)
			If SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB))
				While !SF7->(Eof()) .And. SF7->(F7_FILIAL+F7_GRTRIB) == xFilial("SF7")+SB1->B1_GRTRIB
					If SF7->F7_EST == SA1->A1_EST  .And. SF7->F7_TIPOCLI $ M->UA_TIPOCLI+"|*"
						If AllTrim(SB1->B1_GRTRIB) == "001"
							nIcmsCliVq := SF7->F7_ALIQINT // VERIFICAR - CELSO MARTINS 05/01/2015
						Else
							nIcmsCliVq := SF7->F7_ALIQEXT // VERIFICAR - CELSO MARTINS 05/01/2015
						EndIf
						Exit
					EndIf
					SF7->(DbSkip())
				EndDo
			EndIf
		EndIf
	Else
		nIcmsCliVq := aCols[n][nPosPICM]
	EndIf
*/
	nIcmsCliVq := aCols[n][nPosPICM]
	_nPisCliVq := aCols[n][nPosPPis]
	_nCofCliVq := aCols[n][nPosPCof]

	SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
	
	nFatorFret := iIf(M->UA_VQ_QEMB<=1.And.SB1->B1_VQ_FRT2=="S",2,1)
	
	/*
	||||||||||||||||||||||||||||||||||||||||||||||
	||| V=Verquimica - N=Normal                |||
	||||||||||||||||||||||||||||||||||||||||||||||
	*/
	If      M->UA_VQ_FRET == "V" .And. M->UA_VQ_FVER == "N"
		nValFrete := nZ03FreEnt * nFatorFret
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| V=Verquimica - N=Negociada Retira      |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->UA_VQ_FRET == "V" .And. M->UA_VQ_FVER == "R"
		nValFrete := (M->UA_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * aCols[n][nPosDens]
		EndIf
		If Z02->Z02_MOEDA == "2"
			nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
			nValFrete := nValFrete / nVqTaxaM2
		EndIf
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| V=Verquimica - D=Negociada Redespacho  |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->UA_VQ_FRET == "V" .And. M->UA_VQ_FVER == "D"
		nValFrete := (M->UA_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * aCols[n][nPosDens]
		EndIf
		If Z02->Z02_MOEDA == "2"
			nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
			nValFrete := nValFrete / nVqTaxaM2
		EndIf
		nValFrete += (nZ03FreEnt * nFatorFret)
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| C=Cliente - R=Retira                   |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf M->UA_VQ_FRET == "C" .And. M->UA_VQ_FCLI == "R"
		nValFrete := 0
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| C=Cliente - D= Redespacho              |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->UA_VQ_FRET == "C" .And. M->UA_VQ_FCLI == "D"
		nValFrete := nZ03FreEnt * nFatorFret
	EndIf
	
	If aCols[n][nPosUm] == aCols[n][nPosVqUm]
		lTrocaUm := .F.
	Else
		lTrocaUm := .T.
	EndIf
	
	If aCols[n][nPosMoVq] == aCols[n][nPosMoed]
		lTrocaMo := .F.
	Else
		lTrocaMo := .T.
		aCols[n][nPosMoVq] := aCols[n][nPosMoed]
	EndIf
	
	//	If aCols[n][nPosMoed] == "2" .And. Z02->Z02_MOEDA == "2"
	//		nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
	//		nValFrete := nValFrete / nVqTaxaM2
	//	EndIf
	
	aParamCst := {}
	Aadd(aParamCst,aCols[n][nPosProd])	// Produto
	Aadd(aParamCst,aCols[n][nPosMoed])	// Moeda
	Aadd(aParamCst,aCols[n][nPosVqUm])	// Unidade de Medida
	Aadd(aParamCst,cTabela)				// Tabela de Preco
	Aadd(aParamCst,nValFrete)			// Valor do Frete
	Aadd(aParamCst,aCols[n][nPQtdVer])	// Quantidade - Calc.
	Aadd(aParamCst,aCols[n][nPUniUm1])	// Valor Unitario Digitado
	Aadd(aParamCst,lTrocaUm)			// Troca UM
	Aadd(aParamCst,lTrocaMo)            // Troca Mo
	Aadd(aParamCst,nIcmsCliVq)			// Icms Cliente
	Aadd(aParamCst,nSe4Indice)			// Indice Cond. Pagamento
	Aadd(aParamCst,nSa1Indice)			// Indice Cliente

	Aadd(aParamCst,_nPisCliVq)			// Pis
	Aadd(aParamCst,_nCofCliVq)			// Cofins
		
	aRetCusto := U_fCfmCusto(aParamCst)
	
	cRetValCl  := aRetCusto[1] // Valor Tabela
	
EndIf

Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))
SB1->(RestArea(aAreaSb1))


Return(cRetValCl)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmVal2Cal| Autor: Celso Ferrone Martins  | Data: 15/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmVal2Cal(cTabela,nSe4Indice,nSa1Indice)

Local cRetValCl  := 0
Local aParamCst  := {}
Local aRetCusto  := {}
Local nZ01FTonel := 0
Local nValFrete  := 0
Local aValFrete  := {}
Local nFatorFret := 1
Local nZ03FreEnt := 0

Local nPosProd   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_PRODUTO"}) // Produto
Local nPosMP     := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_MP"})   // Materia Prima
Local nPosEM     := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_EM"})   // Embalagem
Local nPosCapa   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_CAPA"}) // Capacidade
Local nPosDens   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_DENS"}) // Densidade
Local nPosVal    := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_VAL"})  // Valor tabela
Local nPosTabe   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_TABE"}) // Tabela
Local nPosMoed   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_MOED"}) // Moeda
Local nPosIpi    := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_IPI"})  // IPI
Local nPosMark   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_MARK"}) // MarkUp
Local nPosVqUm   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_UM"})   // Unidade de Medida Verquimica
Local nPosTemt   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_TEMT"}) // Tem Tabela ?

Local nPUniUm1   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_PRCVEN"})  // Valor Unitário
Local nPQtdVer   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_QTDE"}) // Quantidade
Local nPosUm     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"})      // Unidade de Medida Padrao
//Local nPosMoVq   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VQ_MOVQ"}) // Moeda padrao

//Local nPosVolum  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VOLU"}) // VOLUME

Local nPosPICM   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_PICM"}) // Percentual de ICMS
Local nPosPPis   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_PPIS"}) // Percentual de Pis
Local nPosPCof   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_PCOF"}) // Percentual de Cof

Local nPosSICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_SICM"}) // ICMS Substituicao Triburaria
Local nPosVIPI   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VIPI"}) // Valor do IPI

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // Pis Cofins
Local nIcmsCliVq := 18   // Icms Padrao da Tabela

Local _nPisCliVq := 0
Local _nCofCliVq := 0

Local nFatorDens  := 1
Local lDensidade  := .F.
Local lMoeda      := .F.

Local aAreaZ02   := Z01->(GetArea())
Local aAreaZ03   := Z03->(GetArea())
Local aAreaSb1   := SB1->(GetArea())

Local nPesoTot   := 0
Local nQtdEmb    := 0

DbSelectArea("Z02") ; DbSetOrder(1)
DbSelectArea("Z03") ; DbSetOrder(2)

For nX := 1 To Len(aCols)
	If !GdDeleted(nX,aHeader,aCols)
		If !Empty(aCols[nX][nPosProd])
			If aCols[nX][nPosVqUm] == "KG"
				nPesoTot += aCols[nX][nPQtdVer]
			Else
				nPesoTot += aCols[nX][nPQtdVer] * aCols[nX][nPosDens]
			EndIf
			If AllTrim(aCols[nx][nPosEM]) != "03000"
				nQtdEmb              += aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
				//				aCols[nx][nPosVolum] := aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
			EndIf
		EndIf
	EndIf
Next nX

//M->C5_VOLUME1 := nQtdEmb

//StaticCall(fGFrete,AjustaSx6)
//U_FGFRETE()

aIcmsAli := &(StrTran(StrTran(FormatIn(AllTrim(GetMv("VQ_ICMSALI")),"|"),"(","{"),")","}"))
aIcmsOri := &("{{'"+StrTran(StrTran(AllTrim(GetMv("VQ_ICMSORI")),"-","',"),"|","},{'")+"}}")

For Nx := 1 To Len(aIcmsAli)
	If SubStr(aIcmsAli[nX],1,2) == SA1->A1_EST
		nIcmsCliVq := Val(SubStr(aIcmsAli[nX],3,2))
	EndIf
Next Nx


If !Empty(aCols[n][nPosProd])
	
	Z02->(DbSeek(xFilial("Z02")+aCols[n][nPosProd]))
	Z03->(DbSeek(xFilial("Z03")+aCols[n][nPosProd]+Z02->Z02_REVISA+cTabela))
	
	If Z02->Z02_UM == aCols[n][nPosVqUm] .And. Z02->Z02_MOEDA == aCols[n][nPosMoed]
		nZ03FreEnt := Z03->Z03_FREENT
	Else
		nZ03FreEnt := Z03->Z03_FREENT
	EndIf
/*	
	If Empty(aCols[n][nPosProd])
		
		SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
		If SA1->A1_EST != "SP"
			For nY := 1 To Len(aIcmsOri)
				If aIcmsOri[nY][1] == SB1->B1_ORIGEM
					nIcmsCliVq := aIcmsOri[nY][2]
					Exit
				EndIf
			Next nY
		EndIf
		
		If !Empty(SB1->B1_GRTRIB)
			If SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB))
				While !SF7->(Eof()) .And. SF7->(F7_FILIAL+F7_GRTRIB) == xFilial("SF7")+SB1->B1_GRTRIB
					If SF7->F7_EST == SA1->A1_EST
						If AllTrim(SB1->B1_GRTRIB) == "001"
							nIcmsCliVq := SF7->F7_ALIQINT // VERIFICAR - CELSO MARTINS 05/01/2015
						Else
							nIcmsCliVq := SF7->F7_ALIQEXT // VERIFICAR - CELSO MARTINS 05/01/2015
						EndIf
						Exit
					EndIf
					SF7->(DbSkip())
				EndDo
			EndIf
		EndIf
	Else
		nIcmsCliVq := aCols[n][nPosPICM]
	EndIf
*/		

	nIcmsCliVq := aCols[n][nPosPICM]
	_nPisCliVq := aCols[n][nPosPPis]
	_nCofCliVq := aCols[n][nPosPCof]

	SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
	
	nFatorFret := iIf(M->C5_VOLUME1<=1.And.SB1->B1_VQ_FRT2=="S",2,1)
	
	/*
	||||||||||||||||||||||||||||||||||||||||||||||
	||| V=Verquimica - N=Normal                |||
	||||||||||||||||||||||||||||||||||||||||||||||
	*/
	If      M->C5_VQ_FRET == "V" .And. M->C5_VQ_FVER == "N"
		nValFrete := nZ03FreEnt * nFatorFret
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| V=Verquimica - N=Negociada Retira      |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->C5_VQ_FRET == "V" .And. M->C5_VQ_FVER == "R"
		nValFrete := (M->C5_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * aCols[n][nPosDens]
		EndIf
		If Z02->Z02_MOEDA == "2"
			nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
			nValFrete := nValFrete / nVqTaxaM2
		EndIf
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| V=Verquimica - D=Negociada Redespacho  |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->C5_VQ_FRET == "V" .And. M->C5_VQ_FVER == "D"
		nValFrete := (M->C5_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * aCols[n][nPosDens]
		EndIf
		If Z02->Z02_MOEDA == "2"
			nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
			nValFrete := nValFrete / nVqTaxaM2
		EndIf
		nValFrete += (nZ03FreEnt * nFatorFret)
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| C=Cliente - R=Retira                   |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf M->C5_VQ_FRET == "C" .And. M->C5_VQ_FCLI == "R"
		nValFrete := 0
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| C=Cliente - D= Redespacho              |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->C5_VQ_FRET == "C" .And. M->C5_VQ_FCLI == "D"
		nValFrete := nZ03FreEnt * nFatorFret
	EndIf
	
	If aCols[n][nPosUm] == aCols[n][nPosVqUm]
		lTrocaUm := .F.
	Else
		lTrocaUm := .T.
	EndIf
	
	//	If aCols[n][nPosMoVq] == aCols[n][nPosMoed]
	lTrocaMo := .F.
	//	Else
	//		lTrocaMo := .T.
	//		aCols[n][nPosMoVq] := aCols[n][nPosMoed]
	//	EndIf
	
	//	If aCols[n][nPosMoed] == "2" .And. Z02->Z02_MOEDA == "2"
	//		nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
	//		nValFrete := nValFrete / nVqTaxaM2
	//	EndIf
	
	aParamCst := {}
	Aadd(aParamCst,aCols[n][nPosProd])	// Produto
	Aadd(aParamCst,aCols[n][nPosMoed])	// Moeda
	Aadd(aParamCst,aCols[n][nPosVqUm])	// Unidade de Medida
	Aadd(aParamCst,cTabela)				// Tabela de Preco
	Aadd(aParamCst,nValFrete)			// Valor do Frete
	Aadd(aParamCst,aCols[n][nPQtdVer])	// Quantidade - Calc.
	Aadd(aParamCst,aCols[n][nPUniUm1])	// Valor Unitario Digitado
	Aadd(aParamCst,lTrocaUm)			// Troca UM
	Aadd(aParamCst,lTrocaMo)            // Troca Mo
	Aadd(aParamCst,nIcmsCliVq)			// Icms Cliente
	Aadd(aParamCst,nSe4Indice)			// Indice Cond. Pagamento
	Aadd(aParamCst,nSa1Indice)			// Indice Cliente
	
	Aadd(aParamCst,_nPisCliVq)			// Pis
	Aadd(aParamCst,_nCofCliVq)			// Cofins

	aRetCusto := U_fCfmCusto(aParamCst)
	
	cRetValCl  := aRetCusto[1] // Valor Tabela
	
EndIf

Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))
SB1->(RestArea(aAreaSb1))


Return(cRetValCl)
