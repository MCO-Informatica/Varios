#INCLUDE "RWMAKE.CH"                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFINR007  บAutor  ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de impressใo do laudo do produto conforme estrutura บฑฑ
ฑฑบ          ณ 																		     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - Especํfico para a empresa Diplomata.         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFINR007()

Local _cUser
Local _cData
Private _aSavArea := GetArea()
Private cPerg     := "RFINR007"
Private _cNomfor  :=""

ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

Processa( { || ImprPed() }, "Impressใo Relat๓rio de Bordero", "Aguarde, processando as informa็๕es solicitadas...",.T.)

RestArea(_aSavArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณImprPed           ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Sub-rotina de processamento e impressใo das informa็๕es do บฑฑ
ฑฑบ          ณpedido de vendas.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RFATR050                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImprPed()

Local _cAlias  := GetNextAlias()

Private _nLin    := 0			//Variแvel de controle das linhas para impressใo
Private oFont1   := TFont():New( "Arial",,14,.T.,,,,,,.F. )
Private oFont2   := TFont():New( "Arial",,07,,.F.,,,,,.F. )
Private oFont3   := TFont():New( "Arial",,10,.T.,.T.,,,,,.F. )
Private oFont4   := TFont():New( "Arial",,8,.T.,,,,,,.F. )
Private oFont5   := TFont():New( "Arial",,30,.T.,.T.,,,,,.F. )
Private oFont6   := TFont():New( "Arial",,11,.T.,.T.,,,,,.F. )
Private oPrn     := TMSPrinter():New("relatorio Bordero")
Private _cBord   := ""
Private _cBord2  := ""
Private _cDesc   := ""
Private _nVez    := 1
Private _cMoeda  := 0
Private _dData
Private _dData2
Private _cVTotal := 0
Private _nConv   := 0
Private _nDia
Private _nMes
Private _nAno
Private _cAgencia
Private _cConta
Private _cHist	:=""

//L๓gica do relat๓rio
oPrn:SetPaperSize(9)
//oPrn:Setup()
oPrn:SetPortrait()

cQuery2 := "SELECT * FROM  " + RetSQLName("SEF") + " SEF "
cQuery2 += "	WHERE SEF.EF_NUM      >= '" + mv_par01 + "'   	    	AND "
cQuery2 += "	      SEF.EF_NUM      <= '" + mv_par02 + "'   	    	AND "
cQuery2 += "	      SEF.EF_BANCO    = '" + mv_par03 + "'   	    	AND "
cQuery2 += "	      SEF.EF_AGENCIA  = '" + mv_par04 + "'   	    	AND "
cQuery2 += "	      SEF.EF_CONTA    = '" + mv_par05 + "'   	    	AND "
cQuery2 += "	      SEF.EF_SEQUENC  = '01' 				AND " 
cQuery2 += "	      SEF.EF_DATA BETWEEN " + dtos(mv_par06) + " AND " + dtos(mv_par07) + " AND "
cQuery2 += "	      SEF.D_E_L_E_T_  <> '*'                       	            "
cQuery2 += "         ORDER BY SEF.EF_DATA"
cQuery2 := ChangeQuery(cQuery2)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"TMPSEF",.F.,.T.)
DbSelectArea("TMPSEF")

//Imprime pagina com produtos que nใo foram gerados laudo
oPrn:StartPage()
_nLin := 0
While !eof()

	_cVTotal+=TMPSEF->EF_VALOR

	TMPSEF->(DbSkip())

EndDo


dbgotop()
While !Eof()
	_dData := DTOC(STOD(TMPSEF->EF_DATA))  
	_cNomfor:= TMPSEF->EF_BENEF	
	_cHist := ALLTRIM(POSICIONE("SE2",1,xFILIAL("SE2")+TMPSEF->EF_PREFIXO+TMPSEF->EF_TITULO+TMPSEF->EF_PARCELA+TMPSEF->EF_TIPO+TMPSEF->EF_FORNECE,"E2_HIST2"))

	_cContabil :=POSICIONE("SE2",1,xFILIAL("SE2")+TMPSEF->EF_PREFIXO+TMPSEF->EF_TITULO+TMPSEF->EF_PARCELA+TMPSEF->EF_TIPO+TMPSEF->EF_FORNECE,"E2_CTAINFO")
	_cCCusto	:=POSICIONE("SE2",1,xFILIAL("SE2")+TMPSEF->EF_PREFIXO+TMPSEF->EF_TITULO+TMPSEF->EF_PARCELA+TMPSEF->EF_TIPO+TMPSEF->EF_FORNECE,"E2_CCUSTO")
	If !Empty(_cHist)
		_cDesc := SUBSTR(_cHist,1,30)
		//	_cDesc := SUBSTR(TMPSE2->E2_HIST2,1,25)
		
	Else
		_cDesc := SUBSTR(TMPSEF->EF_HIST,1,30)
	Endif
	
	If _nVez == 1
		_cBord := MV_PAR08
		_nVez++
		_nLin := 0
		_nLin := _nLin +0100
		//oPrn:Say(_nLin,0810,"Ordem de pagamento N๚mero: " + TMPSE2->E2_NUMBOR,oFont1,100,,,3)
		//_nLin := _nLin + 0120
		oPrn:Box(_nLin,0100,_nLin,2330)
		_nLin := _nLin + 0080
		oPrn:Say(_nLin,0100,"Bordero Cheques: " + _cBord,oFont1,100,,,3)
		//oPrn:Say(_nLin,0900,"Favorecido: " ,oFont1,100,,,3)
		
		_nLin := _nLin + 0080
		
		_cAgencia := TMPSEF->EF_AGENCIA
		cConta 	  := TMPSEF->EF_CONTA
		
		oPrn:Say(_nLin,0100,"Conta Bancแria: " + AllTrim(POSICIONE("SA6",1,xFILIAL("SA6")+TMPSEF->EF_BANCO+_cAgencia+cConta,"A6_NREDUZ")) + "/" + cConta,oFont1,100,,,3)
		//oPrn:Say(_nLin,1200,"Pagto via.: Boleto",oFont1,100,,,3)
		_nLin := _nLin + 0080
		oPrn:Say(_nLin,0100,"Valor total: " + transform(_cVTotal,"@E 9,999,999.99"),oFont1,100,,,3)
		//oPrn:SayBitmap( _nLin,0100,cBitMap,2300,530 )  //Logo da empresa
		//oPrn:Say(0440,0810,"Impressใo de Border๔",oFont2,100,,,3)
		_nLin := _nLin +0080
		
		_nAno := SUBSTR(DTOS(DATE()),1,4)
		_nMes := SUBSTR(DTOS(DATE()),5,2)
		_nDia := SUBSTR(DTOS(DATE()),7,2)
		
		oPrn:Say(_nLin,0100,"Dt. Emissใo: " + _nDiA + "/" + _nMes + "/" + _nAno,oFont1,100,,,3)
		_nLin := _nLin +0080
		CabecRel()
	Endif
	
		
		_nLin := _nLin +0080
	
	If len (_cDesc) > 35 .AND. len (_cDesc) <= 70
		
		oPrn:Box(_nLin,0100,_nLin+160,0600)
		oPrn:Box(_nLin,0600,_nLin+160,1200)
		oPrn:Box(_nLin,1200,_nLin+160,1400)
		oPrn:Box(_nLin,1400,_nLin+160,1600)
		oPrn:Box(_nLin,1600,_nLin+160,1800)
		oPrn:Box(_nLin,1800,_nLin+160,2130)
		oPrn:Box(_nLin,2130,_nLin+160,2330)
		
		oPrn:Say(_nLin+0018,0110,SUBSTR(_cNomfor,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,0610,substr(_cDesc,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,1210,TMPSEF->EF_NUM,oFont2,100,,,3)
		oPrn:Say(_nLin+0018,1410,DTOC(STOD(TMPSEF->EF_DATA)),oFont2,100,,,3)

		oPrn:Say(_nLin+0014,1610,transform(TMPSEF->EF_VALOR,"@E 9,999,999.99"),oFont2,100,,,3)

		oPrn:Say(_nLin+0014,1810,_cContabil,oFont2,100,,,3)
		oPrn:Say(_nLin+0014,2140,_cCCusto,oFont2,100,,,3)
		
		_nLin := _nLin +0080
		oPrn:Say(_nLin+0036,0610,substr(_cDesc,36,35),oFont2,100,,,3)
		
	ElseIf len (_cDesc) > 70
		
		oPrn:Box(_nLin,0100,_nLin+240,0600)
		oPrn:Box(_nLin,0600,_nLin+240,1200)
		oPrn:Box(_nLin,1200,_nLin+240,1400)
		oPrn:Box(_nLin,1400,_nLin+240,1600)
		oPrn:Box(_nLin,1600,_nLin+240,1800)
		oPrn:Box(_nLin,1800,_nLin+240,2130)
		oPrn:Box(_nLin,2130,_nLin+240,2330)
		
		oPrn:Say(_nLin+0018,0110,SUBSTR(_cNomfor,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,0610,substr(_cDesc,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,1210,TMPSEF->EF_NUM,oFont2,100,,,3)
		oPrn:Say(_nLin+0018,1410,DTOC(STOD(TMPSEF->EF_DATA)),oFont2,100,,,3)

		oPrn:Say(_nLin+0014,1610,transform(TMPSEF->EF_VALOR,"@E 9,999,999.99"),oFont2,100,,,3)

		oPrn:Say(_nLin+0014,1810,_cContabil,oFont2,100,,,3)
		oPrn:Say(_nLin+0014,2140,_cCCusto,oFont2,100,,,3)
		
		_nLin := _nLin +0080
		oPrn:Say(_nLin+0036,0610,substr(_cDesc,36,35),oFont2,100,,,3)
		
		_nLin := _nLin +0080
		oPrn:Say(_nLin+0036,0610,substr(_cDesc,71),oFont2,100,,,3)
		
	Else
		
		oPrn:Box(_nLin,0100,_nLin+80,0600)
		oPrn:Box(_nLin,0600,_nLin+80,1200)
		oPrn:Box(_nLin,1200,_nLin+80,1400)
		oPrn:Box(_nLin,1400,_nLin+80,1600)
		oPrn:Box(_nLin,1600,_nLin+80,1800)
		oPrn:Box(_nLin,1800,_nLin+80,2130)
		oPrn:Box(_nLin,2130,_nLin+80,2330)
		
		oPrn:Say(_nLin+0018,0110,SUBSTR(_cNomfor,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,0610,substr(_cDesc,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,1210,TMPSEF->EF_NUM,oFont2,100,,,3)
		oPrn:Say(_nLin+0018,1410,DTOC(STOD(TMPSEF->EF_DATA)),oFont2,100,,,3)

		oPrn:Say(_nLin+0014,1610,transform(TMPSEF->EF_VALOR,"@E 9,999,999.99"),oFont2,100,,,3)

		oPrn:Say(_nLin+0014,1810,_cContabil,oFont2,100,,,3)
		oPrn:Say(_nLin+0014,2140,_cCCusto,oFont2,100,,,3)
		
	EndIf
	
	If _nLin > 2800
		
		
		//_nLin := _nLin +0150
		oPrn:Box(3120,0100,3120,2330)
		//_nLin := _nLin +0080
		//oPrn:Say(3200,0550,"55.11.3732-0000 | www.prozyn.com.br | info@prozyn.com.br",oFont1,100,,,3)
		oPrn:EndPage()
		oPrn:StartPage()
		_nLin := 0
		_nLin := _nLin +0100
		/////
		oPrn:Box(_nLin,0100,_nLin,2330)
		_nLin := _nLin + 0080
		oPrn:Say(_nLin,0100,"Border๔: " + _cBord,oFont1,100,,,3)
		//oPrn:Say(_nLin,0900,"Favorecido: " ,oFont1,100,,,3)
		
		_nLin := _nLin + 0080
		
//		_cAgencia := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_AGEDEP")
//		cConta := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_NUMCON")
		
		oPrn:Say(_nLin,0100,"Conta Bancแria: " + AllTrim(POSICIONE("SA6",1,xFILIAL("SA6")+TMPSEF->EF_BANCO+_cAgencia+cConta,"A6_NREDUZ")) + "/" + cConta,oFont1,100,,,3)
		_nLin := _nLin + 0080
		oPrn:Say(_nLin,0100,"Valor total: " + transform(_cVTotal,"@E 9,999,999.99"),oFont1,100,,,3)
		
		_nLin := _nLin +0080
		
		_nAno := SUBSTR(DTOS(DATE()),1,4)
		_nMes := SUBSTR(DTOS(DATE()),5,2)
		_nDia := SUBSTR(DTOS(DATE()),7,2)
		
		oPrn:Say(_nLin,0100,"Dt. Emissใo: " + _nDiA + "/" + _nMes + "/" + _nAno,oFont1,100,,,3)
		_nLin := _nLin +0080
		CabecRel()
	Endif
	//Endif
	
	TMPSEF->(DbSkip())
	
	//Endif
	
EndDo

//_nLin := _nLin +0300

		_nLin := _nLin +0300
		oPrn:Box(_nLin,0100,_nLin+80,0657)
		oPrn:Say(_nLin+0018,0110,"Emitente",oFont6,100,,,3)
		oPrn:Box(_nLin,0657,_nLin+80,1214)
		oPrn:Say(_nLin+0018,0677,"Aprovador 1",oFont6,100,,,3)
		oPrn:Box(_nLin,1214,_nLin+80,1771)
		oPrn:Say(_nLin+0018,1224,"Aprovador 2",oFont6,100,,,3)
		oPrn:Box(_nLin,1771,_nLin+80,2330)
		oPrn:Say(_nLin+0018,1781,"Diretor Financeiro",oFont6,100,,,3)
		_nLin := _nLin +0080
		oPrn:Box(_nLin,0100,_nLin+160,0657)
		oPrn:Box(_nLin,0657,_nLin+160,1214)
		oPrn:Box(_nLin,1214,_nLin+160,1771)
		oPrn:Box(_nLin,1771,_nLin+160,2330)

oPrn:EndPage()
TMPSEF->(DBCLOSEAREA())

oPrn:Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabecRel  บAutor  ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Sub-rotina para impressใo do cabe็alho do impresso.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RFATR050                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CabecRel()

//oPrn:StartPage()

//Empresa

_nLin := _nLin +0150
oPrn:Box(_nLin,0100,_nLin+80,0600)
oPrn:Say(_nLin+0010,0110,"Fornecedor",oFont6,100,,,3)
oPrn:Box(_nLin,0600,_nLin+80,1200)
oPrn:Say(_nLin+0010,0610,"Descri็ใo",oFont6,100,,,3)
oPrn:Box(_nLin,1200,_nLin+80,1400)
oPrn:Say(_nLin+0010,1210,"Cheque",oFont6,100,,,3)
oPrn:Box(_nLin,1400,_nLin+80,1600)
oPrn:Say(_nLin+0010,1410,"Vencimento",oFont6,100,,,3)
oPrn:Box(_nLin,1600,_nLin+80,1800)
oPrn:Say(_nLin+0010,1610,"Valor",oFont6,100,,,3)
oPrn:Box(_nLin,1800,_nLin+80,2130)
oPrn:Say(_nLin+0010,1810,"C. Contabil",oFont6,100,,,3)
oPrn:Box(_nLin,2130,_nLin+80,2330)
oPrn:Say(_nLin+0010,2140,"C. Custo",oFont6,100,,,3)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se as perguntas existem na SX1. Caso nใo existam,  บฑฑ
ฑฑบ          ณas cria.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 (RFATR050)                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()
Local j
Local i
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := PADR(cPerg,10)
aRegs   :={}

AADD(aRegs,{cPerg,"01","Do Cheque               ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SEF",""})
AADD(aRegs,{cPerg,"02","Ate Cheque              ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SEF",""})
AADD(aRegs,{cPerg,"03","Banco      				?","","","mv_ch3","c",03,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
AADD(aRegs,{cPerg,"04","Agencia      			?","","","mv_ch4","c",05,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Conta      				?","","","mv_ch5","c",10,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Data Inicial			?","","","mv_ch6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Data Final 				?","","","mv_ch7","D",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Border๔ de Cheques		?","","","mv_ch8","c",10,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 To FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				Exit
			EndIf
		Next
		MsUnlock()
	EndIf
Next

dbSelectArea(_sAlias)
Return
