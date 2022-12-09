#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFINR006  บAutor  ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de impressใo do laudo do produto conforme estrutura บฑฑ
ฑฑบ          ณ 															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - Especํfico para a empresa Diplomata.         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFINR006()

Local _cUser
Local _cData
Private _aSavArea := GetArea()
Private cPerg     := "RFINR006"
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
Local _cAlias2 := GetNextAlias()
Local _cAliasE5 := GetNextAlias()
Local nAbat  	:= 0

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
Private nJuros := 0

//L๓gica do relat๓rio
oPrn:SetPaperSize(9)
//oPrn:Setup()
oPrn:SetPortrait()

cQuery2 := "SELECT E2_NUMBOR, E2_MOEDA FROM  " + RetSQLName("SE2") + " SE2 "
cQuery2 += "	WHERE SE2.E2_NUMBOR  between " + mv_par01 + " AND  " + mv_par02 +" " 
cQuery2 += " AND SE2.E2_SALDO > 0  "
cQuery2 += "	      AND SE2.D_E_L_E_T_  <> '*'                       	            "
cQuery2 += "         ORDER BY SE2.E2_NUMBOR "
cQuery2 := ChangeQuery(cQuery2)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"TMPSE2",.F.,.T.)
DbSelectArea("TMPSE2")


While !Eof()
	
	//Conta valor total enviado ao bordero
	cQuery := "SELECT * FROM " + RetSQLName("SE2") + " SE2 "
	cQuery += "	WHERE SE2.E2_NUMBOR  = '" + TMPSE2->E2_NUMBOR + "' "
	cQuery += " AND SE2.E2_SALDO > 0  "
	cQuery += "	AND SE2.D_E_L_E_T_  <> '*'   "
	cQuery += " ORDER BY SE2.E2_NUMBOR "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.F.,.T.)

Memowrite("Qry.txt",cQuery )
	
	DbSelectArea(_cAlias)
	While (_cAlias)->(!Eof())
		
		If MV_PAR03 == 1
			
			IF (_cAlias)->E2_MOEDA <> 1
				
				If empty((_cAlias)->E2_TXMOEDA)
					dbSelectArea("SM2")
					dbSetOrder(1)
					If dbSeek((_cAlias)->E2_VENCTO)
						If TMPSE2->E2_MOEDA == 2
							_cMoeda := SM2->M2_MOEDA2
						ElseIf TMPSE2->E2_MOEDA == 3
							_cMoeda := SM2->M2_MOEDA3
						ElseIf TMPSE2->E2_MOEDA == 4
							_cMoeda := SM2->M2_MOEDA4
						ElseIf TMPSE2->E2_MOEDA == 5
							_cMoeda := SM2->M2_MOEDA5
						Endif
					Endif
				Else
					_cMoeda:= (_cAlias)->E2_TXMOEDA

				EndIF
			Else
				_cMoeda := 1
			Endif
			
			
			If TMPSE2->E2_MOEDA <> 1
				If (_cAlias)->E2_VALLIQ <> 0
					_nConv := (_cAlias)->E2_VALLIQ
				Else
					//_nConv := ((_cAlias)->E2_VALOR * _cMoeda) + (_cAlias)->E2_JUROS + (_cAlias)->E2_VALJUR + (_cAlias)->E2_CORREC - ((_cAlias)->E2_DESCONT + (_cAlias)->E2_MULTA + (_cAlias)->E2_DECRESC)
					_nConv		:= (((_cAlias)->E2_SALDO * _cMoeda)+ (_cAlias)->E2_ACRESC) - (_cAlias)->E2_DECRESC
				Endif
			Else
				//_nConv := (_cAlias)->E2_VALOR + (_cAlias)->E2_JUROS + (_cAlias)->E2_VALJUR + (_cAlias)->E2_CORREC - ((_cAlias)->E2_DESCONT + (_cAlias)->E2_MULTA + (_cAlias)->E2_DECRESC)
				_nConv		:= ((_cAlias)->E2_SALDO + (_cAlias)->E2_ACRESC) - (_cAlias)->E2_DECRESC
			Endif
		Else
			//_nConv := (_cAlias)->E2_VALOR + (_cAlias)->E2_JUROS + (_cAlias)->E2_VALJUR + (_cAlias)->E2_CORREC - ((_cAlias)->E2_DESCONT + (_cAlias)->E2_MULTA + (_cAlias)->E2_DECRESC)
			_nConv		:= ((_cAlias)->E2_SALDO + (_cAlias)->E2_ACRESC) - (_cAlias)->E2_DECRESC
		Endif

			cQuery3 := "SELECT E5_VALOR FROM " + RetSQLName("SE5") + " SE5 "
			cQuery3 += "	WHERE E5_DOCUMEN  = '" + (_cAlias)->E2_NUMBOR + "'  AND "
			cQuery3 += "	E5_DATA  = '" + (_cAlias)->E2_VENCTO + "'  AND "
			cQuery3 += "	E5_TIPO  = '" + (_cAlias)->E2_TIPO + "'  AND "
			cQuery3 += "	E5_PARCELA  = '" + (_cAlias)->E2_PARCELA + "'  AND "
			cQuery3 += "	E5_TIPODOC  != 'CM'  AND "
			cQuery3 += "	E5_CLIFOR  = '" + (_cAlias)->E2_FORNECE + "'  AND "
			cQuery3 += "	E5_LOJA  = '" + (_cAlias)->E2_LOJA + "'  AND "
			cQuery3 += "	E5_NUMERO  = '" + (_cAlias)->E2_NUM + "'  AND "
			cQuery3 += " D_E_L_E_T_  <> '*' "
			cQuery3 := ChangeQuery(cQuery3)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"_cAliasE5",.F.,.T.)
			
Memowrite("Qry3.txt",cQuery3)			
			
			DbSelectArea("_cAliasE5")
			_nConvM2 := ("_cAliasE5")->E5_VALOR
			("_cAliasE5")->(DBCLOSEAREA())    
			
		If _nConvM2 > 0
		_cVTotal := _cVTotal + _nConvM2
		Else
		_cVTotal := _cVTotal + _nConv
		EndIf
		
		_cMoeda := 1
		(_cAlias)->(DbSkip())
	EndDo
	//(_cAlias)->(DBCLOSEAREA())
	
	TMPSE2->(DbSkip())
	
	//Endif
	
EndDo

TMPSE2->(DBCLOSEAREA())
//Imprime pagina com produtos que nใo foram gerados laudo
oPrn:StartPage()
_nLin := 0

cQuery2 := "SELECT * FROM  " + RetSQLName("SE2") + " SE2 "  
cQuery2 += " INNER JOIN " + RetSQLName("SA2") + " A2 ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND A2.D_E_L_E_T_ = '' "
cQuery2 += "	WHERE SE2.E2_NUMBOR      between '" + mv_par01 + "' AND  '" + mv_par02 + "' "
cQuery2 += " AND SE2.E2_SALDO > 0  "
cQuery2 += " AND SE2.D_E_L_E_T_  <> '*'                       	       "
cQuery2 += "         ORDER BY SE2.E2_NUMBOR,A2.A2_NOME "
cQuery2 := ChangeQuery(cQuery2)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"TMPSE2",.F.,.T.)
DbSelectArea("TMPSE2")
While ("TMPSE2")->(!Eof())
	_dData := DTOC(STOD(TMPSE2->E2_VENCTO))  
	_cNomfor:= SUBSTR(ALLTRIM(TMPSE2->A2_NOME),1,30)
	//_dData2 := DTOC(STOD(dDatabase))
	
	cEatipo := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_TIPO")
	lAbatimento := cEatipo $ MV_CPNEG .or. cEatipo $ MVABATIM
		If lAbatimento
			nAbat 	:= SE2->E2_SALDO
		Else
			nAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA, SE2->E2_FILIAL)
		EndIf
		
	If MV_PAR03 == 1
		
		IF TMPSE2->E2_MOEDA <> 1
			
			If Empty(TMPSE2->E2_TXMOEDA) 
				dbSelectArea("SM2")
				dbSetOrder(1)
				If dbSeek(TMPSE2->E2_VENCTO)
					If TMPSE2->E2_MOEDA == 2
						_cMoeda := SM2->M2_MOEDA2
					ElseIf TMPSE2->E2_MOEDA == 3
						_cMoeda := SM2->M2_MOEDA3
					ElseIf TMPSE2->E2_MOEDA == 4
						_cMoeda := SM2->M2_MOEDA4
					ElseIf TMPSE2->E2_MOEDA == 5
						_cMoeda := SM2->M2_MOEDA5
					Endif
				Endif
			Else
				_cMoeda := TMPSE2->E2_TXMOEDA
			EndIF
		Endif
		
	Endif
	
	If !Empty(TMPSE2->E2_HIST2)
		_cDesc := alltrim(TMPSE2->E2_HIST2)
		//	_cDesc := SUBSTR(TMPSE2->E2_HIST2,1,25)
		
	Else
		_cDesc := SUBSTR(_cNomfor,1,30)
	Endif
	
	If _nVez == 1
		_cBord := TMPSE2->E2_NUMBOR
		_nVez++
		_nLin := 0
		_nLin := _nLin +0100
		//oPrn:Say(_nLin,0810,"Ordem de pagamento N๚mero: " + TMPSE2->E2_NUMBOR,oFont1,100,,,3)
		//_nLin := _nLin + 0120
		oPrn:Box(_nLin,0100,_nLin,2330)
		_nLin := _nLin + 0080
		oPrn:Say(_nLin,0100,"Border๔: " + TMPSE2->E2_NUMBOR,oFont1,100,,,3)
		//oPrn:Say(_nLin,0900,"Favorecido: " ,oFont1,100,,,3)
		
		_nLin := _nLin + 0080
		
		_cAgencia := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_AGEDEP")
		cConta := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_NUMCON")
		
		oPrn:Say(_nLin,0100,"Conta Bancแria: " + AllTrim(POSICIONE("SA6",1,xFILIAL("SA6")+TMPSE2->E2_PORTADO+_cAgencia+cConta,"A6_NREDUZ")) + "/" + cConta,oFont1,100,,,3)
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
	
	If TMPSE2->E2_NUMBOR <> _cBord
	
	_cVTotal := 0
	
	//Conta valor total enviado ao bordero
	cQuery := "SELECT * FROM " + RetSQLName("SE2") + " SE2 "
	cQuery += "	WHERE SE2.E2_NUMBOR  = '" + TMPSE2->E2_NUMBOR + "' "
	cQuery += " AND SE2.E2_SALDO > 0 "
	cQuery += "	AND SE2.D_E_L_E_T_  <> '*'   "
	cQuery += "       ORDER BY SE2.E2_NUMBOR,E2_NOMFOR "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias2,.F.,.T.)
	
	DbSelectArea(_cAlias2)
	While !Eof()
		
		If MV_PAR03 == 1
			
			IF (_cAlias2)->E2_MOEDA <> 1
				
				If empty((_cAlias2)->E2_TXMOEDA)
					dbSelectArea("SM2")
					dbSetOrder(1)
					If dbSeek((_cAlias2)->E2_VENCTO)
						If TMPSE2->E2_MOEDA == 2
							_cMoeda := SM2->M2_MOEDA2
						ElseIf TMPSE2->E2_MOEDA == 3
							_cMoeda := SM2->M2_MOEDA3
						ElseIf TMPSE2->E2_MOEDA == 4
							_cMoeda := SM2->M2_MOEDA4
						ElseIf TMPSE2->E2_MOEDA == 5
							_cMoeda := SM2->M2_MOEDA5
						Endif
					Endif
				Else
					_cMoeda:= (_cAlias2)->E2_TXMOEDA

				EndIF
			Else
				_cMoeda := 1
			Endif

			cQuery3 := "SELECT E5_VALOR FROM " + RetSQLName("SE5") + " SE5 "
			cQuery3 += "	WHERE E5_DOCUMEN  = '" + _cAlias2->E2_NUMBOR + "'  AND "
			cQuery3 += "	E5_DATA  = '" + _cAlias2->E2_VENCTO + "'  AND "
			cQuery3 += "	E5_TIPO  = '" + _cAlias2->E2_TIPO + "'  AND "
			cQuery3 += "	E5_PARCELA  = '" + _cAlias2->E2_PARCELA + "'  AND "
			cQuery3 += "	E5_TIPODOC  != 'CM'  AND "
			cQuery3 += "	E5_CLIFOR  = '" + _cAlias2->E2_FORNECE + "'  AND "
			cQuery3 += "	E5_LOJA  = '" + _cAlias2->E2_LOJA + "'  AND "
			cQuery3 += "	E5_NUMERO  = '" + _cAlias2->E2_NUM + "'  AND "
			cQuery3 += " D_E_L_E_T_  <> '*' "
			cQuery3 := ChangeQuery(cQuery3)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"_cAliasE5",.F.,.T.)
			
Memowrite("Qry4.txt",cQuery3)				
			
			DbSelectArea("_cAliasE5")
			_nConvM2 := ("_cAliasE5")->E5_VALOR
			("_cAliasE5")->(DBCLOSEAREA())
			
			If TMPSE2->E2_MOEDA <> 1
				If (_cAlias)->E2_VALLIQ <> 0
					_nConv := (_cAlias)->E2_VALLIQ
				Else
					_nConv := _nConvM2
				Endif
			Else
				//_nConv := (_cAlias2)->E2_VALOR + (_cAlias2)->E2_E2_ACRESC + (_cAlias2)->E2_CORREC - ((_cAlias2)->E2_DESCONT + (_cAlias2)->E2_MULTA + (_cAlias2)->E2_JUROS)
				_nConv		:= ((_cAlias)->E2_SALDO + (_cAlias)->E2_ACRESC) - (_cAlias)->E2_DECRESC
			Endif
		Else
			//_nConv := (_cAlias2)->E2_VALOR + (_cAlias2)->E2_E2_ACRESC + (_cAlias2)->E2_CORREC - ((_cAlias2)->E2_DESCONT + (_cAlias2)->E2_MULTA + (_cAlias2)->E2_JUROS)
			_nConv		:= ((_cAlias)->E2_SALDO + (_cAlias)->E2_ACRESC) - (_cAlias)->E2_DECRESC
		Endif
			
		If _nConvM2 > 0
		_cVTotal := _cVTotal + _nConvM2
		Else
		_cVTotal := _cVTotal + _nConv
		EndIf
		_cMoeda := 1
		(_cAlias2)->(DbSkip())
	EndDo
	//(_cAlias)->(DBCLOSEAREA())
		
		_nLin := _nLin +0300
		oPrn:Box(_nLin,0100,_nLin+80,0657)
		oPrn:Say(_nLin+0018,0110,"Emitente",oFont6,100,,,3)
		oPrn:Box(_nLin,0657,_nLin+80,1214)
		oPrn:Say(_nLin+0018,0677,"Aprovador 1",oFont6,100,,,3)
		oPrn:Box(_nLin,1214,_nLin+80,1771)
		oPrn:Say(_nLin+0018,1224,"Aprovador 2",oFont6,100,,,3)
		oPrn:Box(_nLin,1771,_nLin+80,2330)
		oPrn:Say(_nLin+0018,1781,"Diretor Fin.",oFont6,100,,,3)
		_nLin := _nLin +0080
		oPrn:Box(_nLin,0100,_nLin+160,0657)
		oPrn:Box(_nLin,0657,_nLin+160,1214)
		oPrn:Box(_nLin,1214,_nLin+160,1771)
		oPrn:Box(_nLin,1771,_nLin+160,2330)
		
		oPrn:Box(3120,0100,3120,2330)
		//_nLin := _nLin +0080
		//oPrn:Say(3200,0550,"55.11.3732-0000 | www.prozyn.com.br | info@prozyn.com.br",oFont1,100,,,3)
		oPrn:EndPage()
		oPrn:StartPage()
		_nLin := 0
		_nLin := _nLin +0100
		/////////////////
		oPrn:Box(_nLin,0100,_nLin,2330)
		_nLin := _nLin + 0080
		oPrn:Say(_nLin,0100,"Border๔: " + TMPSE2->E2_NUMBOR,oFont1,100,,,3)
		//oPrn:Say(_nLin,0900,"Favorecido: " ,oFont1,100,,,3)
		
		_nLin := _nLin + 0080
		
		_cAgencia := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_AGEDEP")
		cConta := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_NUMCON")
		
		oPrn:Say(_nLin,0100,"Conta Bancแria: " + AllTrim(POSICIONE("SA6",1,xFILIAL("SA6")+TMPSE2->E2_PORTADO+_cAgencia+cConta,"A6_NREDUZ")) + "/" + cConta,oFont1,100,,,3)
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
		
		
		_cBord := TMPSE2->E2_NUMBOR
		
	Endif
	
	_nLin := _nLin +0080
	
	If len (_cDesc) > 35 .AND. len (_cDesc) <= 70
		
		oPrn:Box(_nLin,0100,_nLin+160,0600)
		oPrn:Box(_nLin,0600,_nLin+160,1200)
		oPrn:Box(_nLin,1200,_nLin+160,1500)
		oPrn:Box(_nLin,1500,_nLin+160,1780)
		oPrn:Box(_nLin,1780,_nLin+160,2100)
		oPrn:Box(_nLin,2100,_nLin+160,2330)
		
		oPrn:Say(_nLin+0018,0110,SUBSTR(_cNomfor,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,0610,substr(_cDesc,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,1230,DTOC(STOD(TMPSE2->E2_VENCTO)),oFont2,100,,,3)

			cQuery3 := "SELECT E5_VALOR FROM " + RetSQLName("SE5") + " SE5 "
			cQuery3 += "	WHERE E5_DOCUMEN  = '" + TMPSE2->E2_NUMBOR + "'  AND "
			cQuery3 += "	E5_DATA  = '" + TMPSE2->E2_VENCTO + "'  AND "
			cQuery3 += "	E5_TIPO  = '" + TMPSE2->E2_TIPO + "'  AND "
			cQuery3 += "	E5_PARCELA  = '" + TMPSE2->E2_PARCELA + "'  AND "
			cQuery3 += "	E5_TIPODOC  != 'CM'  AND "
			cQuery3 += "	E5_CLIFOR  = '" + TMPSE2->E2_FORNECE + "'  AND "
			cQuery3 += "	E5_LOJA  = '" + TMPSE2->E2_LOJA + "'  AND "
			cQuery3 += "	E5_NUMERO  = '" + TMPSE2->E2_NUM + "'  AND "
			cQuery3 += " D_E_L_E_T_  <> '*' "
			cQuery3 := ChangeQuery(cQuery3)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"_cAliasE5",.F.,.T.)

Memowrite("Qry5.txt",cQuery3)
			
			DbSelectArea("_cAliasE5")
			_nConvM2 := ("_cAliasE5")->E5_VALOR
			("_cAliasE5")->(DBCLOSEAREA())
			
		If _nConvM2 == 0
		_nConvM2 := TMPSE2->E2_VLCRUZ + TMPSE2->E2_VALJUR
		EndIf
			
		If MV_PAR03 == 1
		
			If TMPSE2->E2_MOEDA == 1
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
			Else
				If TMPSE2->E2_VALLIQ <> 0
				oPrn:Say(_nLin+0014,1510,transform(TMPSE2->E2_VALLIQ,"@E 9,999,999.99"),oFont2,100,,,3)
				Else
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
				Endif
			Endif
		Else
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
		Endif
		oPrn:Say(_nLin+0014,1790,TMPSE2->E2_CTAINFO,oFont2,100,,,3)
		oPrn:Say(_nLin+0014,2110,TMPSE2->E2_CCUSTO,oFont2,100,,,3)
		
		_nLin := _nLin +0080
		oPrn:Say(_nLin+0036,0610,substr(_cDesc,36,35),oFont2,100,,,3)
		
	ElseIf len (_cDesc) > 70
		
		oPrn:Box(_nLin,0100,_nLin+240,0600)
		oPrn:Box(_nLin,0600,_nLin+240,1200)
		oPrn:Box(_nLin,1200,_nLin+240,1500)
		oPrn:Box(_nLin,1500,_nLin+240,1780)
		oPrn:Box(_nLin,1780,_nLin+240,2100)
		oPrn:Box(_nLin,2100,_nLin+240,2330)
		
		oPrn:Say(_nLin+0018,0110,SUBSTR(_cNomfor,1,25),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,0610,substr(_cDesc,1,35),oFont2,100,,,3)
		oPrn:Say(_nLin+0018,1230,DTOC(STOD(TMPSE2->E2_VENCTO)),oFont2,100,,,3)

			cQuery3 := "SELECT E5_VALOR FROM " + RetSQLName("SE5") + " SE5 "
			cQuery3 += "	WHERE E5_DOCUMEN  = '" + TMPSE2->E2_NUMBOR + "'  AND "
			cQuery3 += "	E5_DATA  = '" + TMPSE2->E2_VENCTO + "'  AND "
			cQuery3 += "	E5_TIPO  = '" + TMPSE2->E2_TIPO + "'  AND "
			cQuery3 += "	E5_PARCELA  = '" + TMPSE2->E2_PARCELA + "'  AND "
			cQuery3 += "	E5_TIPODOC  != 'CM'  AND "
			cQuery3 += "	E5_CLIFOR  = '" + TMPSE2->E2_FORNECE + "'  AND "
			cQuery3 += "	E5_LOJA  = '" + TMPSE2->E2_LOJA + "'  AND "
			cQuery3 += "	E5_NUMERO  = '" + TMPSE2->E2_NUM + "'  AND "
			cQuery3 += " D_E_L_E_T_  <> '*' "
			cQuery3 := ChangeQuery(cQuery3)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"_cAliasE5",.F.,.T.)

Memowrite("Qry6.txt",cQuery3) 
				
			DbSelectArea("_cAliasE5")
			_nConvM2 := ("_cAliasE5")->E5_VALOR
			("_cAliasE5")->(DBCLOSEAREA())
			
		If _nConvM2 == 0
			//_nConvM2 := TMPSE2->E2_VLCRUZ + TMPSE2->E2_VALJUR
			_nConvM2 := (TMPSE2->E2_SALDO + TMPSE2->E2_ACRESC)-TMPSE2->E2_DECRESC
		EndIf
		
		If MV_PAR03 = 1
			If TMPSE2->E2_MOEDA == 1
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
			Else
				If TMPSE2->E2_VALLIQ != 0
				oPrn:Say(_nLin+0014,1510,transform(TMPSE2->E2_VALLIQ,"@E 9,999,999.99"),oFont2,100,,,3)
				Else
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
				Endif
			Endif
		Else
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
		Endif
		oPrn:Say(_nLin+0014,1790,TMPSE2->E2_CTAINFO,oFont2,100,,,3)
		oPrn:Say(_nLin+0014,2110,TMPSE2->E2_CCUSTO,oFont2,100,,,3)
		
		_nLin := _nLin +0080
		oPrn:Say(_nLin+0036,0610,substr(_cDesc,36,35),oFont2,100,,,3)
		
		_nLin := _nLin +0080
		oPrn:Say(_nLin+0036,0610,substr(_cDesc,71),oFont2,100,,,3)
		
	Else
		
		oPrn:Box(_nLin,0100,_nLin+80,0600)
		oPrn:Say(_nLin+0018,0110,SUBSTR(_cNomfor,1,25),oFont2,100,,,3)
		oPrn:Box(_nLin,0600,_nLin+80,1200)
		oPrn:Say(_nLin+0018,0610,substr(_cDesc,1,30),oFont2,100,,,3)
		oPrn:Box(_nLin,1200,_nLin+80,1500)
		
		oPrn:Say(_nLin+0018,1230,DTOC(STOD(TMPSE2->E2_VENCTO)),oFont2,100,,,3)
		oPrn:Box(_nLin,1500,_nLin+80,1780)

			cQuery3 := "SELECT E5_VALOR FROM " + RetSQLName("SE5") + " SE5 "
			cQuery3 += "	WHERE E5_DOCUMEN  = '" + TMPSE2->E2_NUMBOR + "'  AND "
			cQuery3 += "	E5_DATA  = '" + TMPSE2->E2_VENCTO + "'  AND "
			cQuery3 += "	E5_TIPO  = '" + TMPSE2->E2_TIPO + "'  AND "
			cQuery3 += "	E5_PARCELA  = '" + TMPSE2->E2_PARCELA + "'  AND "
			cQuery3 += "	E5_TIPODOC  != 'CM'  AND "
			cQuery3 += "	E5_CLIFOR  = '" + TMPSE2->E2_FORNECE + "'  AND "
			cQuery3 += "	E5_LOJA  = '" + TMPSE2->E2_LOJA + "'  AND "
			cQuery3 += "	E5_NUMERO  = '" + TMPSE2->E2_NUM + "'  AND "
			cQuery3 += " D_E_L_E_T_  <> '*' "
			cQuery3 := ChangeQuery(cQuery3)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"_cAliasE5",.F.,.T.)

Memowrite("Qry7.txt",cQuery3) 
			
			DbSelectArea("_cAliasE5")
			_nConvM2 := ("_cAliasE5")->E5_VALOR
			("_cAliasE5")->(DBCLOSEAREA())
			
		If _nConvM2 == 0
			_nConvM2 := (TMPSE2->E2_SALDO + TMPSE2->E2_ACRESC ) - TMPSE2->E2_DECRESC //TMPSE2->E2_VLCRUZ + TMPSE2->E2_VALJUR
		EndIf
		
		If MV_PAR03 = 1
			If TMPSE2->E2_MOEDA == 1
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
			Else
				If TMPSE2->E2_VALLIQ != 0
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
				Else
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
				Endif
			Endif
		Else
				oPrn:Say(_nLin+0014,1510,transform(_nConvM2,"@E 9,999,999.99"),oFont2,100,,,3)
		Endif
		
		oPrn:Box(_nLin,1780,_nLin+80,2100)
		oPrn:Say(_nLin+0014,1790,TMPSE2->E2_CTAINFO,oFont2,100,,,3)
		oPrn:Box(_nLin,2100,_nLin+80,2330)
		oPrn:Say(_nLin+0014,2110,TMPSE2->E2_CCUSTO,oFont2,100,,,3)
		
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
		oPrn:Say(_nLin,0100,"Border๔: " + TMPSE2->E2_NUMBOR,oFont1,100,,,3)
		//oPrn:Say(_nLin,0900,"Favorecido: " ,oFont1,100,,,3)
		
		_nLin := _nLin + 0080
		
		_cAgencia := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_AGEDEP")
		cConta := POSICIONE("SEA",1,xFILIAL("SEA")+ TMPSE2->E2_NUMBOR + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECEDOR + TMPSE2->E2_LOJA,"EA_NUMCON")
		
		oPrn:Say(_nLin,0100,"Conta Bancแria: " + AllTrim(POSICIONE("SA6",1,xFILIAL("SA6")+TMPSE2->E2_PORTADO+_cAgencia+cConta,"A6_NREDUZ")) + "/" + cConta,oFont1,100,,,3)
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
	
	TMPSE2->(DbSkip())
	
	//Endif
	
EndDo
If Select(_cAlias)>0
	(_cAlias)->(DBCLOSEAREA())
EndIf
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
//_nLin := _nLin +0080
//	oPrn:Say(3200,0550,"55.11.3732-0000 | www.prozyn.com.br | info@prozyn.com.br",oFont1,100,,,3)

oPrn:EndPage()
SM2->(DBCLOSEAREA())
TMPSE2->(DBCLOSEAREA())

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
oPrn:Box(_nLin,1200,_nLin+80,1500)
oPrn:Say(_nLin+0010,1210,"Vencimento",oFont6,100,,,3)
oPrn:Box(_nLin,1500,_nLin+80,1780)
oPrn:Say(_nLin+0010,1510,"Valor",oFont6,100,,,3)
oPrn:Box(_nLin,1780,_nLin+80,2100)
oPrn:Say(_nLin+0010,1790,"C. Contabil",oFont6,100,,,3)
oPrn:Box(_nLin,2100,_nLin+80,2330)
oPrn:Say(_nLin+0010,2110,"C. Custo",oFont6,100,,,3)
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

AADD(aRegs,{cPerg,"01","Do Bordero                 ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SEA",""})
AADD(aRegs,{cPerg,"02","Ate o Bordero              ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SEA",""})
AADD(aRegs,{cPerg,"03","Converte moeda (S/N):      ?","","","mv_ch3","N",01,0,0,"C","","MV_PAR03","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})

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
