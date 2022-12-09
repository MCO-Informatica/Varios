#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR002   º Autor ³ Antonio Carlos     º Data ³  12/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Acerto de Consignacao.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATR002()
///////////////////////

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Acerto de Consignacao"  
Local cPict			:= ""
Local titulo		:= "Acerto de Consignacao"
Local nLin			:= 80
//"Codigo           Descricao                       NF      Emissao                    Preco        Qtde Cons.  Valor Cons.     Dev/Jur     Valor            Qtde          Valor"
Local Cabec1		:= "Codigo                Descricao                                           NF          Emissao          Preco             Consignacao                 Saldo Consig.                A Pagar      "
Local Cabec2		:= "                                                                                                                      Qtde        Valor           Qtde          Valor        Qtde         Valor"
Local imprime		:= .T.
Local aOrd			:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private CbTxt		:= ""
Private limite		:= 230
Private tamanho		:= "G"
Private nomeprog	:= "FATR002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo		:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 2, "", 1}
Private nLastKey	:= 0
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "FATR002" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		:= "FATR02    "
Private cString 	:= "SB6"

Private _nB2CM1		:= 0
Private _nQtdeCo	:= 0
Private _nVlrCo		:= 0
Private _nQtdeB6	:= 0
Private _nVlrB6		:= 0
Private _nQtdePg	:= 0
Private _nVlrPg		:= 0
Private _nQtdeB2	:= 0
Private _nVlrB2		:= 0
Private _nDiv		:= 0
Private _nDiverg	:= 0
Private _nCont		:= 0
Private _nPrUnit	:= 0

Private _nQtdeCoT	:= 0
Private _nVlrCoT	:= 0
Private _nQtdeB6T	:= 0
Private _nVlrB6T	:= 0
Private _nQtdeB2T	:= 0
Private _nVlrB2T	:= 0
Private _nQtdePgT	:= 0
Private _nVlrPgT	:= 0

Private _nVlrUnit	:= 0
Private _nQtdAux	:= 0
Private _nQtdBx		:= 0
Private _lFaz		:= .T.
Private _lInclui	:= .T.

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
fErase(__RelDir + wnrel + '.##r')

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
////////////////////////////////////////////////////
Local nOrdem
Local _cFornece	:= Space(6)

cQuery	:= " SELECT DISTINCT(B6_PRODUTO), B1_DESC, B1_CODBAR, B6_CLIFOR, B6_LOJA, B6_EMISSAO, B6_DOC, B6_SERIE, B6_QUANT, B6_SALDO, ZB_NUMFEC, "
// cQuery	+= " 'PRECO' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_CUSTO1/B6_QUANT,4) ELSE ROUND(B6_PRUNIT,4) END, "
//cQuery	+= " 'PRECO' = ROUND(B6_PRUNIT,2), "
cQuery	+= " 'PRECO' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_CUSTO1/B6_QUANT,2) ELSE ROUND(B6_PRUNIT,2) END, "
cQuery	+= " ZB_VENDAS, ZB_ESTOQUE, ZB_QTDPAG, "
// cQuery	+= " 'VLRQTDSB6' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_QUANT*(B6_CUSTO1/B6_QUANT),4) ELSE ROUND(B6_QUANT*B6_PRUNIT,4) END,
cQuery	+= " 'VLRQTDSB6' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_QUANT*(B6_CUSTO1/B6_QUANT),2) ELSE ROUND(B6_QUANT*B6_PRUNIT,2) END,
// cQuery	+= " 'VLRSLDSB6' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_SALDO*(B6_CUSTO1/B6_QUANT),4) ELSE ROUND(B6_SALDO*B6_PRUNIT,4) END
cQuery	+= " 'VLRSLDSB6' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_SALDO*(B6_CUSTO1/B6_QUANT),2) ELSE ROUND(B6_SALDO*B6_PRUNIT,2) END
cQuery	+= " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK)"
cQuery	+= " ON B6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQuery	+= " INNER JOIN "+RetSqlName("SZB")+" SZB (NOLOCK)"
cQuery	+= " ON B6_FILIAL+B6_PRODUTO = ZB_FILIAL+ZB_PRODUTO AND SZB.D_E_L_E_T_ = '' "
cQuery	+= " WHERE "
cQuery	+= " B6_FILIAL = '"+xFilial("SB6")+"' AND "
cQuery	+= " ZB_NUMFEC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
cQuery	+= " B6_CLIFOR = ZB_FORNECE AND "
cQuery	+= " B6_LOJA = ZB_LOJA AND "
cQuery	+= " B6_PODER3 = 'R' AND "
cQuery	+= " B6_ATEND <> 'S' AND "
cQuery	+= " ZB_QTDPAG > 0 AND "
cQuery	+= " SB6.D_E_L_E_T_ = '' "
cQuery	+= " ORDER BY B1_DESC, B6_EMISSAO "

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TRB", .F., .T.)
count to _nLastRec 
SetRegua(_nLastRec)

TRB->(DbGoTop())
Do While !TRB->(Eof())

	_cFornece	:= TRB->B6_CLIFOR
	_cLoja		:= TRB->B6_LOJA
	_cProduto	:= TRB->B6_PRODUTO
	_cNumFec	:= TRB->ZB_NUMFEC
	
	Do While !TRB->(Eof()) .And. TRB->ZB_NUMFEC == _cNumFec
		
		Do While !TRB->(Eof()) .And. _cProduto == TRB->B6_PRODUTO .And. _cNumFec == TRB->ZB_NUMFEC
			
			_nCont++
			
			If lAbortPrint
				@ nLin,00 pSay "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			If nLin > 55 
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
				@ nLin,00 pSay "Acerto: "+TRB->ZB_NUMFEC +" - "+"Fornecedor: "+_cFornece +"-"+ _cLoja+" - "+Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,"A2_NOME")
				nLin := nLin+2
			Endif
			
			@ nLin,00 pSay TRB->B1_CODBAR
			@ nLin,21 pSay Substr(TRB->B1_DESC,1,50)
			@ nLin,74 pSay TRB->B6_DOC
			@ nLin,84 pSay Substr(TRB->B6_EMISSAO,7,2)+"/"+Substr(TRB->B6_EMISSAO,5,2)+"/"+Substr(TRB->B6_EMISSAO,1,4)
			@ nLin,94 pSay TRB->PRECO   	Picture "@E 999,999,999.99"
			@ nLin,108 pSay TRB->B6_QUANT  	Picture "@E 999,999,999.99"
			@ nLin,122 pSay TRB->VLRQTDSB6 	Picture "@E 999,999,999.99"
			@ nLin,136 pSay TRB->B6_SALDO   	Picture "@E 999,999,999.99"
			@ nLin,150 pSay TRB->VLRSLDSB6	Picture "@E 999,999,999.99"
			
			_nQtdeCo	:= _nQtdeCo + TRB->B6_QUANT
			_nVlrCo		:= _nVlrCo + TRB->VLRQTDSB6
			_nQtdeB6	:= _nQtdeB6 + TRB->B6_SALDO
			_nVlrB6		:= _nVlrB6 + TRB->VLRSLDSB6
			_nPrUnit	:= TRB->PRECO
			
			_nQtdePg	:= TRB->ZB_QTDPAG
			
			_nDiverg	+= _nDiv
			_nDiv := 0
			
			nLin++
			
			TRB->(DbSkip())
			
		EndDo
		
		_nCont := 0
		++nLin
		
		If Select("TMPSB6") > 0
			DbSelectArea("TMPSB6")
			DbCloseArea()
		EndIf
		
	//	cQuery1	:= " SELECT B6_DOC, B6_SERIE, B6_IDENT, 'PRECO' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_CUSTO1/B6_QUANT,4) ELSE ROUND(B6_PRUNIT,4) END, B6_SALDO "
	  	cQuery1	:= " SELECT B6_DOC, B6_SERIE, B6_IDENT, 'PRECO' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_CUSTO1/B6_QUANT,2) ELSE ROUND(B6_PRUNIT,2) END, B6_SALDO "
		cQuery1 += " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK) "
		cQuery1 += " WHERE "
		cQuery1 += " B6_FILIAL = '"+xFilial("SB6")+"' AND "
		cQuery1 += " B6_PRODUTO = '"+_cProduto+"' AND "
		cQuery1 += " B6_CLIFOR = '"+_cFornece+"' AND "
		cQuery1 += " B6_LOJA = '"+_cLoja+"' AND "
		cQuery1 += " B6_PODER3 = 'R' AND B6_SALDO > 0 AND "
		cQuery1 += " SB6.D_E_L_E_T_ = '' "
		cQuery1 += " ORDER BY B6_EMISSAO "
		
		dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery1), "TMPSB6", .F., .T.)
		
		DbSelectArea("TMPSB6")
		TMPSB6->(DbGoTop())
		If TMPSB6->(!Eof())
			_nQtdAux := _nQtdePg
			Do While !TMPSB6->(Eof()) .And. _lFaz
				
				If _nQtdAux <= TMPSB6->B6_SALDO
					_nQtdBx	:= _nQtdAux
					_lFaz	:= .F.
					_lInclui := .T.
				Else
					_nQtdBx := TMPSB6->B6_SALDO
					_nQtdAux -= _nQtdBx
				EndIf
				
			   //	_nVlrUnit	:= Round(TMPSB6->PRECO,4)  
				_nVlrUnit	:= Round(TMPSB6->PRECO,2)
			   //	_nVlrPg	+=	Round((_nQtdBx * _nVlrUnit),4)
			   _nVlrPg	+=	Round((_nQtdBx * _nVlrUnit),2)
				
				TMPSB6->(DbSkip())
				
			EndDo
			
			_lFaz := .T.
			
		EndIf
		
		@ nLin,00 pSay "Total: "
		
		@ nLin,108 pSay _nQtdeCo  	Picture "@E 999,999,999.99"
		@ nLin,122 pSay _nVlrCo 	Picture "@E 999,999,999.99"
		
		@ nLin,136 pSay _nQtdeB6    Picture "@E 999,999,999.99"
		@ nLin,150 pSay _nVlrB6    	Picture "@E 999,999,999.99"
		
		@ nLin,164 pSay _nQtdePg   	Picture "@E 999,999,999.99"
		@ nLin,178 pSay _nVlrPg  	Picture "@E 999,999,999.99"
		
		@++nLin,000 pSay __PrtThinLine()
		
		_nQtdeCoT	+= _nQtdeCo
		_nVlrCoT	+= _nVlrCo
		_nQtdeB6T	+= _nQtdeB6
		_nVlrB6T	+= _nVlrB6
		_nQtdeB2T	+= _nQtdeB2
		_nVlrB2T	+= _nVlrB2
		_nQtdePgT	+= _nQtdePg
		_nVlrPgT	+= _nVlrPg
		
		_nQtdeCo	:= 0
		_nVlrCo		:= 0
		_nQtdeB6	:= 0
		_nVlrB6		:= 0
		_nQtdeB2	:= 0
		_nVlrB2		:= 0
		_nQtdePg	:= 0
		_nVlrPg		:= 0
		_nDiverg	:= 0
		_nPrUnit	:= 0
		_nVlrUnit	:= 0
		
		_cProduto := TRB->B6_PRODUTO
		
		nLin++
		
	EndDo
	
	@ nLin++,000 pSay __PrtThinLine()
	
	@ nLin,00 pSay "Total Geral: "
	@ nLin,108 pSay _nQtdeCoT  	Picture "@E 999,999,999.99"
	@ nLin,122 pSay _nVlrCoT 	Picture "@E 999,999,999.99"
	
	@ nLin,136 pSay _nQtdeB6T   Picture "@E 999,999,999.99"
	@ nLin,150 pSay _nVlrB6T    Picture "@E 999,999,999.99"
	
	@ nLin,164 pSay _nQtdePgT  	Picture "@E 999,999,999.99"
	@ nLin,178 pSay _nVlrPgT  	Picture "@E 999,999,999.99"
	
	_nQtdeCoT	:= 0
	_nVlrCoT	:= 0
	_nQtdeB6T	:= 0
	_nVlrB6T	:= 0
	_nQtdeB2T	:= 0
	_nVlrB2T	:= 0
	_nQtdePgT	:= 0
	_nVlrPgT	:= 0
	
	nLin := 80
	
EndDo

DbSelectArea("TRB")
DbCloseArea("TRB")

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
