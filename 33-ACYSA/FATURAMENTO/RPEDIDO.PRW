#include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPEDIDO    												  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPEDIDO()

Private nLastKey     := 0
Private cPerguntas   := .F.
PRIVATE cPerg   :="RPEDIDO001"
nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.
lNew:=.F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefini็๕es das fontesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oFont08N:= TFont():New( "Times New Roman",,08,,.t.,,,,,.f. )
oFont08	:= TFont():New( "Times New Roman",,08,,.F.,,,,,.f. )
oFont10N:= TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont10	:= TFont():New( "Times New Roman",,11,,.F.,,,,,.f. )
oFont12N:= TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
oFont12	:= TFont():New( "Times New Roman",,12,,.F.,,,,,.f. )
oFont14N:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
oFont14	:= TFont():New( "Times New Roman",,14,,.F.,,,,,.f. )
oFont16N:= TFont():New( "Times New Roman",,16,,.t.,,,,,.f. )
oFont16	:= TFont():New( "Times New Roman",,16,,.F.,,,,,.f. )

AjustaSX1(cPerg)

if Pergunte(cPerg,.T.)
	RptStatus({|| ImpRel()},"Relat๓rio de Vendas...")
	
endif

MS_FLUSH()

Return

///////////////////////////////
***************************
Static Function ImpRel()
***************************
//////////////////////////////

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMV_PAR01...........DO PEDIDO      ณ
//ณMV_PAR02...........ATE PEDIDO     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//oPrn:=TMSPrinter():New()

IF MV_PAR03 == 1  // PEDIDO
	_cQuery := "Select C5_NUM AS NUM, C5_EMISSAO AS EMISSAO, C5_CLIENTE AS CLIENTE, C5_X_DESCA AS DESCARGA, Z1_DESCRI AS NOMCARGA, A1_END AS ENDERECO,  A1_BAIRRO AS BAIRRO, "
	_cQuery += " A1_MUN AS CIDADE, A1_NOME NOME, A1_TEL AS TELEFONE, A1_CGC AS CNPJ, A1_INSCR AS INSCR, E4_DESCRI AS CONDPAG, C5_TRANSP AS TRANSP, C5_MENNOTA AS MENS, "
	_cQuery += " C6_QTDVEN AS QTDVEN, C6_DESCRI AS DESCRI, C6_PRCVEN AS PRCVEN, C6_VALOR AS VALOR, C5_VEND1 AS VEND, C6_PRODUTO AS PRODUTO, C6_LOTECTL AS LOTE, C6_ENTREG AS ENTREGA " 
	_cQuery += " From "+RetSqlName("SC5")+" C5  "
	_cQuery += " INNER JOIN "+RetSqlName("SC6")+" C6 ON C6_NUM+C6_CLI = C5_NUM+C5_CLIENTE "
	_cQuery += " INNER JOIN SA1010 A1 ON A1_COD+A1_LOJA = C5_CLIENTE+C5_LOJACLI "
	_cQuery += " INNER JOIN SE4010 E4 ON C5_CONDPAG = E4_CODIGO "
	_cQuery += " INNER JOIN SZ1010 Z1 ON C5_X_DESCA = Z1_COD "
	_cQuery += " Where C5.C5_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	_cQuery += " AND   A1.D_E_L_E_T_ <> '*'"
	_cQuery += " AND   C5.D_E_L_E_T_ <> '*'"
	_cQuery += " AND   C6.D_E_L_E_T_ <> '*'"
	_cQuery += " AND   E4.D_E_L_E_T_ <> '*'"
	_cQuery += " AND   Z1.D_E_L_E_T_ <> '*'"
	_cQuery += " ORDER BY C5_NUM,C6_PRODUTO"
ELSE
	_cQuery := " Select CJ_NUM AS NUM, CJ_EMISSAO AS EMISSAO, CJ_CLIENTE AS CLIENTE, A1_END AS ENDERECO,  A1_BAIRRO AS BAIRRO, "
	_cQuery += "  A1_MUN AS CIDADE, A1_NOME NOME, A1_TEL AS TELEFONE, A1_CGC AS CNPJ, A1_INSCR AS INSCR, E4_DESCRI AS CONDPAG, "
	_cQuery += "   '' AS TRANSP, '' AS MENS,  CK_QTDVEN AS QTDVEN, CK_DESCRI AS DESCRI, CK_PRCVEN AS PRCVEN,  "
	_cQuery += "   CK_VALOR AS VALOR, '' AS VEND, CK_PRODUTO AS PRODUTO , '' AS LOTE  "
	_cQuery += "   From "+RetSqlName("SCJ")+" CJ    "
	_cQuery += "   INNER JOIN "+RetSqlName("SCK")+" CK ON CJ_NUM+CJ_CLIENTE = CK_NUM+CK_CLIENTE "  
	_cQuery += "   INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD+A1_LOJA = CJ_CLIENTE+CJ_LOJA "
	_cQuery += "   INNER JOIN "+RetSqlName("SE4")+" E4 ON CJ_CONDPAG = E4_CODIGO "
	_cQuery += "   Where CK.CK_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  AND   A1.D_E_L_E_T_ <> '*' AND   CK.D_E_L_E_T_ <> '*' "
	_cQuery += "    AND   CJ.D_E_L_E_T_ <> '*' "  
	_cQuery += "    AND   E4.D_E_L_E_T_ <> '*'"
	_cQuery += "    ORDER BY CK_NUM,CK_PRODUTO "
ENDIF	

TCQUERY _cQuery NEW ALIAS "QTRB"

///////////////Inicio da Impressใo///////////////////////////
oPrn:= tAvPrinter():New("PEDIDO")      
oPrn:SetPortrait()
oPrn:Setup()


nPag  := 0  
_nLin := 0
lImpTot := .F.

dbSelectArea("QTRB")
dbgotop()
SetRegua(RecCount())

While !QTRB->(EOF())
	
	IncRegua()
	
	
	If lAbortPrint
		oPrn:Say ( 050, 900, "Cancelado pelo operador",oFont08)
		Exit
	Endif
	
		
	oPrn:StartPage()
	
	If cEmpAnt$"01"
		cBitMap	   := "lgrl01.bmp"
	ElseIf cEmpAnt$"03"
		cBitMap	   := "lgrl03.bmp"
	Else
		cBitMap	   := "acysa.bmp"
	EndIf
	nPag ++                                   
	
	oPrn:SayBitmap( 20, 30,cBitMap,300,150 )

	IF MV_PAR03 == 1  // PEDIDO
		oPrn:Say ( 040,1050  , "PEDIDO DE VENDA",oFont16n)
	ELSE
		oPrn:Say ( 040,1100  , "ORวAMENTO",oFont16n)
	ENDIF

	oPrn:line(170, 020,170, 2500)//horizontal
	oPrn:Say (200,060 ,"PEDIDO:",oFont12n)
	oPrn:Say (200,270 ,QTRB->NUM,oFont12)
	oPrn:Say (200,2000 ,"EMISSAO:",oFont12n)
	oPrn:Say (200,2230 ,DTOC(STOD(QTRB->EMISSAO)),oFont12)
	oPrn:Say (250,060 ,"CLIENTE:",oFont12n)
	oPrn:Say (250,305 ,QTRB->NOME,oFont12)
	oPrn:Say (300,060 ,"ENDEREวO:",oFont12n)
	oPrn:Say (300,340 ,QTRB->ENDERECO,oFont12)
	oPrn:Say (350,060 ,"BAIRRO:",oFont12n)
	oPrn:Say (350,290 ,QTRB->BAIRRO,oFont12)
	oPrn:Say (350,1060 ,"CIDADE:",oFont12n)
	oPrn:Say (350,1280 ,QTRB->CIDADE,oFont12)
	oPrn:Say (350,2060 ,"TEL:",oFont12n)
	oPrn:Say (350,2180 ,QTRB->TELEFONE,oFont12)
	oPrn:Say (400,060 ,"CNPJ:",oFont12n)
	oPrn:Say (400,240 ,QTRB->CNPJ,oFont12)
	oPrn:Say (400,1260 ,"INSC. ESTADUAL:",oFont12n)
	oPrn:Say (400,1670 ,QTRB->INSCR,oFont12)
	oPrn:Say (450,060 ,"COND. PAGAMENTO:",oFont12n)
	oPrn:Say (450,540 ,QTRB->CONDPAG,oFont12)
	oPrn:Say (450,1360 ,"TRANSPORTE:",oFont12n)
	oPrn:Say (450,1680 ,Posicione("SA4",1,xFilial("SA4")+QTRB->TRANSP,"A4_NOME"),oFont12)
	oPrn:Say (500,060 ,"OBS:",oFont12n)
	oPrn:Say (500,200 ,QTRB->MENS,oFont12)

	oPrn:line(0600,0020,0600,2500)//horizontal
	oPrn:Say (0620,0060 ,"QUANT. V",oFont12n)
	oPrn:Say (0620,0300 ,"QUANT. E",oFont12n)
	oPrn:Say (0620,0650,'DESCRICAO',oFont12n)
	oPrn:Say (0620,1700,'ENTREGA',oFont12n)
	oPrn:Say (0620,2000,'PRC. UNIT.',oFont12n)
	oPrn:Say (0620,2300,'TOTAL',oFont12n)
	oPrn:line(0670,0020,0670,2500)//horizontal
	_nLin := 700

	_cPedido := QTRB->NUM          
	_cVend   := QTRB->VEND
	_nTotal  := 0
	lImpTot := .F.		
	xObsComl:= Posicione("SC5",1,xFilial("SC5")+QTRB->NUM,"C5_XMENS")

	_cDescarga:= "**** TIPO DE DESCARGA NAO INFORMADO ****"
	
	If !Empty(QTRB->DESCARGA)
		_cDescarga := QTRB->NOMCARGA
	EndIf	


		While !Eof() .And. _cPedido == QTRB->NUM

		oPrn:Say ( _nLin,0050  , TRANSFORM(QTRB->QTDVEN,"@E 9,999,999.99") ,oFont10)
		oPrn:Say ( _nLin,0600  , QTRB->DESCRI,oFont10)
		oPrn:Say ( _nLin,1700  , DTOC(STOD(QTRB->ENTREGA)),oFont10)
		oPrn:Say ( _nLin,2020  , TRANSFORM(QTRB->PRCVEN,"@E 999,999.99"),oFont10)
		
		iF !Empty(QTRB->LOTE)
			oPrn:Say ( _nLin,2280  ,TRANSFORM(QTRB->VALOR,"@E 999,999.99"),oFont10)
			lImpTot := .T.
		ENDIF
		_nLin := _nLin + 50
		oPrn:line(_nLin, 020,_nLin, 2500)//horizontal
		_nLin := _nLin + 10
		_nTotal  += QTRB->VALOR

		dbSelectArea("QTRB")
		dbSkip()

//		If _nLin >= 2200 .Or. _cPedido <> QTRB->NUM
//			oPrn:EndPage()
//			_nLin := 10
//			Exit
//		EndIf

	EndDo			


	nTamObs := 200
	
	_nLin+=50
	
	For J := 1 To MlCount(xObsComl,nTamObs)
		cTexto := Alltrim(MemoLine(xObsComl,nTamObs,J))
		oPrn:Say(_nLin,050,cTexto,oFont12,100,,,0)
		_nLin+=50
	Next
	
	_nLin+=50

	oPrn:Say ( _nLin,0050  ,"TOTAL : ",oFont12n)
	
	If lImpTot
		oPrn:Say ( _nLin,2280  ,TRANSFORM(_nTotal,"@E 999,999.99"),oFont12n)
	EndIf
	
	_nLin := _nLin + 50
	oPrn:line(_nLin, 020,_nLin, 2500)//horizontal
	_nLin := _nLin + 70
	oPrn:Say ( _nLin,0050  ,"VENDEDOR: ",oFont12)           
	oPrn:Say ( _nLin,0320  ,Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME"),oFont12)
	oPrn:Say ( _nLin,2000  ,"DATA: _____/_____/_____ ",oFont12)
	_nLin := _nLin + 70
	oPrn:Say ( _nLin,0050  ,"DESCARGA: ",oFont12)           
	oPrn:Say ( _nLin,0320  ,_cDescarga ,oFont12)
	
	oPrn:EndPage()
	

EndDo

oPrn:Preview()
oPrn:End()

dbSelectArea("QTRB")
dbCloseArea()


Return()

*****************************
////////////////////////////////
Static Function AjustaSX1(cPerg)
////////////////////////////////
*****************************

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMV_PAR01...........Da PEDIDO     ณ
//ณMV_PAR02...........Ate PEDIDO    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local	aRegistros   := {}
//                01    02    03                    04 05   06      07 08 0910 11  12     13     14 15 16 17  18 19 20 21 22 23 24 25  26 27 28 29 30 31 32 33 34  35 36 37 38 39 40 41
AADD(aRegistros,{cPerg,"01","Do Numero          ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","SC5","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"02","Ate Numero         ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","SC5","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"03","Imprimir           ?","","","mv_ch3","C",01,0,0,"C","","mv_par03","Pedido","Or็amento","","","","","","","","","","","","","","","","","","","","","","","","","",""})

DbSelectArea('SX1')
SX1->(DbSetOrder(1))

For nX:=1 to Len(aRegistros)
	If	RecLock('SX1',Iif(!SX1->(DbSeek(aRegistros[nx][01]+aRegistros[nx][02])),.t.,.f.))
		Replace SX1->X1_GRUPO		With aRegistros[nx][01]
		Replace SX1->X1_ORDEM   	With aRegistros[nx][02]
		Replace SX1->X1_PERGUNTE	With aRegistros[nx][03]
		Replace SX1->X1_PERSPA		With aRegistros[nx][03]  // Preenche com a pergunta em portugues
		Replace SX1->X1_PERENG		With aRegistros[nx][03]  // Preenche com a pergunta em portugues
		Replace SX1->X1_VARIAVL		With aRegistros[nx][06]
		Replace SX1->X1_TIPO		With aRegistros[nx][07]
		Replace SX1->X1_TAMANHO		With aRegistros[nx][08]
		Replace SX1->X1_DECIMAL		With aRegistros[nx][09]
		//		Replace SX1->X1_PRESEL		With aRegistros[nx][10]
		Replace SX1->X1_GSC			With aRegistros[nx][11]
		Replace SX1->X1_VALID		With aRegistros[nx][12]
		Replace SX1->X1_VAR01		With aRegistros[nx][13]
		Replace SX1->X1_DEF01		With aRegistros[nx][14]
		Replace SX1->X1_DEF02		With aRegistros[nx][15]
		Replace SX1->X1_DEF03		With aRegistros[nx][16]
		Replace SX1->X1_DEF04		With aRegistros[nx][17]
		Replace SX1->X1_F3   		With aRegistros[nx][18]
		MsUnlock('SX1')
	Else
		Help('',1,'REGNOIS')
	Endif
Next nX

Return() // AjustaSX1()
