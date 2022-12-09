#Include "Rwmake.ch"

/*
+-----------+----------+-------+----------------------+------+-------------+
| Função:   | VAEMG01  | Autor | Jorge Henrique Alves | Data | Abril/2010  |          
+-----------+----------+-------+----------------------+------+-------------+
| Descrição | Gatilho para determinar o preço de venda                     |    
+-----------+--------------------------------------------------------------+
| Uso       | Verion Oleo Hidraulica                                       |
+-----------+--------------------------------------------------------------+
*/

User Function VAEMG01()
Local _aArea := GetArea(), _cEst := "", _nPrc := nx := _nAlq := _nTxMoeda := 0
Local nPPrd  := aScan(aHeader,{|x| x[2] == "C6_PRODUTO"})
Local nPDsc  := aScan(aHeader,{|x| x[2] == "C6_VRDESC "})
Local nPPrc  := aScan(aHeader,{|x| x[2] == "C6_PRCVEN "})
Local nPTes  := aScan(aHeader,{|x| x[2] == "C6_TES    "})

//Verifica UF do cliente
If Posicione("SA1",1,xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_EST") == "EX"
	RestArea(_aArea)
	Return (aCols[n][nPPrc])
EndIf
	
//Verifica se possui preço de venda cadastrado
If Posicione("SB1",1,xFilial("SB1") + aCols[n][nPPrd],"B1_VERVEN") <= 0
	MsgStop("Preco de venda nao cadastrado para o produto, nao sera possivel calcular o preco unitário","Atencao")
	RestArea(_aArea)
	Return (aCols[n][nPPrc])	
EndIf

//Verifica se possui moeda cadastrada
DbSelectArea("SM2")
DbSetOrder(1)
If !DbSeek(dDatabase)
	MsgStop("Taxa da moeda nao cadastrada, nao sera possivel calcular o preco unitário","Atencao")
	RestArea(_aArea)
	Return (aCols[n][nPPrc])
	
ElseIf SB1->B1_TPMOEDA == "E" .And. SM2->M2_MOEDA4 == 0	
	MsgStop("Taxa da moeda nao cadastrada, nao sera possivel calcular o preco unitário","Atencao")
	RestArea(_aArea)
	Return (aCols[n][nPPrc])
	
ElseIf SM2->M2_MOEDA2 == 0 	
	MsgStop("Taxa da moeda nao cadastrada, nao sera possivel calcular o preco unitário","Atencao")
	RestArea(_aArea)
	Return (aCols[n][nPPrc])	
	
EndIf

_nTxMoeda := IIF(SB1->B1_TPMOEDA == "E",SM2->M2_MOEDA4,SM2->M2_MOEDA2)

_cEst := IIF(Empty(SA1->A1_INSCR) .Or. "ISEN" $ SA1->A1_INSCR,"SP",SA1->A1_EST) 

If _cEst == "SP" 

   If SB1->B1_UM == "KT" .and. SA1->A1__MASTER == "1"
      _nAlq := 12
   Else   
		_nAlq := 18
	EndIf

ElseIf _cEst $ "MG/PR/RJ/RS/SC"
	_nAlq := 12
Else
	_nAlq := 7
EndIf			

//_nAlq := IIF(SA1->A1_TIPO $ "L/F" .Or. SB1->B1_PICM > 0,SB1->B1_PICM,_nAlq)
_nAlq := IIF(SB1->B1_PICM > 0 .And. SB1->B1_PICM < _nAlq,SB1->B1_PICM,_nAlq)

If Posicione("SF4", 1, xFilial("SF4") + aCols[n][nPTes],"F4_BASEICM") > 0
 _nAlq := _nAlq * (SF4->F4_BASEICM / 100)
EndIf
	
If SB1->B1_UM == "PC"
	_nPrc := (SB1->B1_VERVEN * _nTxMoeda)
	_nPrc -= (_nPrc * (aCols[n][nPDsc]/100))
   _nPrc := (_nPrc / ((100-_nAlq)/100))  //(_nPrc * (_nAlq/100))
	_nPrc += (_nPrc * (GetMv("MV__VAEMG1")/100))
ElseIf SB1->B1_UM == "KT"
	_nPrc := IIF(SA1->A1__MASTER == "1",(SB1->B1_VERVEN - SB1->B1__VALMO) * _nTxMoeda,(SB1->B1_VERVEN * _nTxMoeda))
	_nPrc -= (_nPrc * (aCols[n][nPDsc]/100))
	_nPrc := (_nPrc / ((100-_nAlq)/100))
	_nPrc += (_nPrc * (GetMv("MV__VAEMG1")/100))
Else
	RestArea(_aArea)
	Return (aCols[n][nPPrc])
EndIf

Return _nPrc