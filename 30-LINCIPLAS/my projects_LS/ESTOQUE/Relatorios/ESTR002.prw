#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTR002   บ Autor ณ Antonio Carlos     บ Data ณ  14/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Perdas - Revistas.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ESTR002()
///////////////////////


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3	:= "Relatorio de Perdas"
Local cPict		:= ""
Local titulo	:= "Relatorio de Perdas"
Local nLin		:= 80
//          10        20        30        40        50        60        70        80        90        100       110       120       130
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//Codigo           Descricao                        Consignada  Vendida      Devolvida    Perdida       Valor
Local Cabec1	:= "Codigo           Descricao                        Consignada      Vendida    Devolvida      Perdida        Valor"
Local Cabec2	:= ""
Local imprime	:= .T.
Local aOrd		:= {}
Private lEnd	:= .F.
Private lAbortPrint		:= .F.
Private CbTxt			:= ""
Private limite			:= 120
Private tamanho			:= "M"
Private nomeprog		:= "ESTR002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo			:= 18
Private aReturn			:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey		:= 0
Private cbtxt			:= Space(10)
Private cbcont			:= 00
Private CONTFL			:= 01
Private m_pag			:= 01
Private wnrel			:= "ESTR002" // Coloque aqui o nome do arquivo usado para impressao em disco

cPerg := 'ESTR002   '
ValidPerg()   
Pergunte(cPerg,.f.)

Private cString := "SD2"

dbSelectArea("SD2")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
////////////////////////////////////////////////////
Local nOrdem
LOcal _nTotPag	:= 0

dbSelectArea(cString)
dbSetOrder(1)

_cQuery := " SELECT A.D2_COD, A.D2_CLIENTE, A.D2_LOJA, H.B1_DESC, COALESCE(SUM(A.D2_QUANT),0) AS 'VENDIDA', F.D1_VUNIT AS 'UNITARIO', E.B2_QATU AS 'PERDIDA', "

_cQuery += _cEnter + " COALESCE((SELECT SUM(B.D2_QUANT) FROM "+RetSqlName("SD2")+" B WITH(NOLOCK) " 
_cQuery += _cEnter + " WHERE B.D2_FILIAL = '"+xFilial("SD2")+"' AND B.D2_COD = A.D2_COD AND B.D2_TES = '599' AND "
_cQuery += _cEnter + " B.D2_EMISSAO <= SUBSTRING(CONVERT(VARCHAR(8),dateadd(dd,-7,getdate()),112),1,8) AND B.D_E_L_E_T_ = ''),0) AS 'DEVOLVIDA', "

_cQuery += _cEnter + " COALESCE((SELECT SUM(G.D1_QUANT) FROM "+RetSqlName("SD1")+" G WITH(NOLOCK) "
_cQuery += _cEnter + " WHERE G.D1_FILIAL = '"+xFilial("SD1")+"' AND G.D1_COD = A.D2_COD AND G.D1_TES = '063' AND "
_cQuery += _cEnter + " G.D_E_L_E_T_ = ''),0) AS 'CONSIGNADA' "

_cQuery += _cEnter + " FROM "+RetSqlName("SD2")+" A WITH(NOLOCK) "
_cQuery += _cEnter + " INNER JOIN "+RetSqlName("SD1")+" F WITH(NOLOCK) "
_cQuery += _cEnter + " ON F.D1_FILIAL = A.D2_FILIAL AND F.D1_COD = A.D2_COD AND F.D_E_L_E_T_ = '' "
_cQuery += _cEnter + " INNER JOIN "+RetSqlName("SB2")+" E WITH(NOLOCK) "
_cQuery += _cEnter + " ON E.B2_FILIAL = A.D2_FILIAL AND E.B2_COD = A.D2_COD AND E.D_E_L_E_T_ = '' "
_cQuery += _cEnter + " INNER JOIN "+RetSqlName("SB1")+" H WITH(NOLOCK) "
_cQuery += _cEnter + " ON H.B1_COD = A.D2_COD AND H.D_E_L_E_T_ = '' "

_cQuery += _cEnter + " WHERE "
_cQuery += _cEnter + " A.D2_FILIAL = '"+xFilial("SD2")+"' AND "
_cQuery += _cEnter + " A.D2_CLIENTE = '999999' AND "
_cQuery += _cEnter + " A.D2_COD IN ( "
_cQuery += _cEnter + " 	SELECT C.D2_COD "
_cQuery += _cEnter + "	FROM "+RetSqlName("SD2")+" C (NOLOCK) "
_cQuery += _cEnter + "	INNER JOIN "+RetSqlName("SB2")+" D (NOLOCK)"
_cQuery += _cEnter + "	ON C.D2_FILIAL = D.B2_FILIAL AND C.D2_COD = D.B2_COD AND D.D_E_L_E_T_ = '' "
_cQuery += _cEnter + "	WHERE "
_cQuery += _cEnter + "   C.D2_FILIAL = '"+xFilial("SD2")+"' AND "
_cQuery += _cEnter + "	C.D2_EMISSAO <= SUBSTRING(CONVERT(VARCHAR(8),dateadd(dd,-7,getdate()),112),1,8) AND "
_cQuery += _cEnter + "   C.D2_GRUPO = '0004' AND "
_cQuery += _cEnter + "	C.D2_TES = '600' AND "
_cQuery += _cEnter + "	D.B2_LOCAL = '01' AND "
_cQuery += _cEnter + "	D.B2_QATU > 0 AND "
_cQuery += _cEnter + "	C.D_E_L_E_T_ = '' "
_cQuery += _cEnter + "	) "
_cQuery += _cEnter + " AND "
_cQuery += _cEnter + " F.D1_TES = '063' AND "
_cQuery += _cEnter + " E.B2_LOCAL = '01' AND "
_cQuery += _cEnter + " E.B2_QATU > 0 AND "
_cQuery += _cEnter + " A.D_E_L_E_T_ = '' "

_cQuery += _cEnter + " GROUP BY A.D2_COD, A.D2_CLIENTE, A.D2_LOJA, H.B1_DESC, F.D1_VUNIT, E.B2_QATU "
_cQuery += _cEnter + " ORDER BY A.D2_CLIENTE, A.D2_LOJA, H.B1_DESC "

U_GravaQuery('ESTR002.SQL',_cQuery)

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'QRY', .F., .T.)

count to _nLastRec
SetRegua(_nLastRec)

DbSelectArea("QRY")
QRY->( DbGoTop() )
If QRY->( !Eof() )

	Do While QRY->( !Eof() )
		
		cFornece	:= QRY->D2_CLIENTE	
		cLoja		:= QRY->D2_LOJA		
		_nTotPag	:= 0
		
		While QRY->( !Eof() ) .And. QRY->D2_CLIENTE+QRY->D2_LOJA == cFornece+cLoja

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			@nLin,00 PSAY QRY->D2_COD
			@nLin,17 PSAY Substr(QRY->B1_DESC,1,30)
			@nLin,49 PSAY QRY->CONSIGNADA	Picture "@E 99999999.99"
			@nLin,62 PSAY QRY->VENDIDA		Picture "@E 99999999.99"
			@nLin,75 PSAY QRY->DEVOLVIDA	Picture "@E 99999999.99"
			@nLin,88 PSAY QRY->PERDIDA		Picture "@E 99999999.99"
			@nLin,101 PSAY QRY->PERDIDA*QRY->UNITARIO	Picture "@E 99999999.99"			
			
			_nTotPag += QRY->PERDIDA*QRY->UNITARIO

			nLin := nLin + 1 // Avanca a linha de impressao

			QRY->( DbSkip() )
	
		EndDo		
		
		nLin := nLin+1
		
		@nLin,00 PSAY "Total de Perdas: "
		@nLin,20 PSAY _nTotPag Picture "@E 99999999.99"
		
		nLin := nLin+1
		@nLin,000 PSAY __PrtThinLine()
		nLin := nLin+2
	
	EndDo

EndIf	

DbCloseArea()

If aReturn[5]==1
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Nro NF Compra                 ?","","", "mv_ch1", "C", 09 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","" ,""})
aAdd( aPerg , { cPerg, "02", "S้rie NF Compra               ?","","", "mv_ch2", "C", 03 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "03", "Fornecedor                    ?","","", "mv_ch3", "C", 06 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Loja                          ?","","", "mv_ch4", "C", 02 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
	For j := 1 to (FCount())
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j, aPerg[i, j])
		Endif
	Next
	MsUnlock()
Next

RestArea(_aAlias)

Return
