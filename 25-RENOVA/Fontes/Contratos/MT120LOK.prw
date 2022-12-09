#include "rwmake.ch"
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥MT120LOK  ∫Autor  ≥Pedro Augusto       ∫ Data ≥  18/02/2012 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Ponto de Entrada na gravacao da solicitacao: no momento em   ±±
±±∫           que o item da solicitacao È informado                       ∫±±
±±∫Uso       ≥ Exclusivo RENOVA                                           ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function MT120LOK

// Danilo - 11/12/2015
Local nI
//	Local cTipo
//	Local nPosTip := Ascan(aHeader,{|x| x[2] == "C7_XTPCOM "})
// Fim - Danilo
Local aSC7Alias	:= GetArea('SC7')
Local aSF4Alias := GetArea('SF4')
//Local _nPosCON := aScan(aHeader,{|x| ALlTrim(x[2]) == "C7_CONTA"} )
//Local _nPosIMC := aScan(aHeader,{|x| ALlTrim(x[2]) == "C7_XIMCURS"} )
//Local _nPosPIC := aScan(aHeader,{|x| ALlTrim(x[2]) == "C7_XPROJIM"} )
//Local _nPosTES := aScan(aHeader,{|x| ALlTrim(x[2]) == "C7_TES"} )
////Fontes Renova - CompatibilizaÁ„o dos Fontes 23/10/2015
Local _nDif     := 0
Local _nElem    := 0
Local _cForn    := cA120forn
Local _cLoja    := cA120Loj
Local _lRet     := .t.
Local aArea		:= GetArea()
Local _cUnReqSC1:= ""
Local _cUnReqSCn:= ""
Local nPosSC 	:= Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_NUMSC'})
Local nPosSCItem:= Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_ITEMSC'})
Local nPosCTR 	:= Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_XCONTRA'})
Local nPosCTW 	:= Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_XCOM' })
//Local _nPOsPrec := Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_PRECO' })
Local _nPosxCd  := Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_XCOMPD'})
Local _nPosProd := Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_PRODUTO'})
Local _nPosQuant:= Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_QUANT'})
Local _nPosPreco:= Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_PRECO'})
Local _nPosTotal:= Ascan( aHeader, { |n| Alltrim( n[2] ) == 'C7_TOTAL'})
Local cNumRevisa:= ""
Private aValxCTR  := {}

////Final Fontes Renova

////Fontes Renova - CompatibilizaÁ„o dos Fontes 23/10/2015
For ni := 1 To Len(aCols)              // Numero de linhas de itens
	IF aCols[ni,len(aHeader)+1] <> .T.   // Descarta os deletados
		if !Empty(aCols[ni][_nPosxCd])
			_cTipoCtr := aCols[ni][_nPosxCd]
			IF _cTipoCtr = '1' .AND. EMPTY(aCols[ni][nPosCTR])
				Aviso("Pedido Compra Direta","Exige o preenchimento do Campo Cont CompDir ",{"OK"})
				_lRet := .F.
				return _lRet
			EndIf
		EndIf
		if !Empty(aCols[ni][nPosCTR])
			_cTipoCtr := aCols[ni][_nPosxCd]
			_cContr := aCols[ni][nPosCTR]
			_cProd  := aCols[ni][_nPosProd]
			_cQuant := aCols[ni][_nPosQuant]
			_cPreco := aCols[ni][_nPosPreco]
			_cTotal := aCols[ni][_nPosTotal]
			
			// Acumula por contratos
			_nElem := aScan(aValxCTR,{|ni| ni[1]==_cContr})
			If _nElem > 0
				_cTotal = _cTotal + aValxCTR[_nElem][8]
			EndIf
			
			Aadd(aValxCTR,{_cContr,_cForn,_cLoja,_cContr,_cProd,_cQuant,_cPreco,_cTotal})
			
			cNumRevisa:= GetNumRev( _cContr )
			
			DBSELECTAREA("CN9")
			DBSETORDER(1)
			DBSEEK(xFilial("CN9")+ _cContr + cNumRevisa )
			IF !EOF() .AND.  _cContr = CN9_NUMERO
				IF _cTotal > CN9_SALDO
					_nDif = _cTotal - CN9_SALDO
					Aviso(" Pedido de Compra Direta ","Valor do Pedido de Compra È maior que o Saldo do Contratro."+CHR(13)+CHR(10);
					+" Pedido de Compra: "+TRANSFORM(_cTotal,'@E 999,999,999.99')+CHR(13)+CHR(10);
					+" Contrato "+ALLTRIM(_cContr)+"  Saldo: "+TRANSFORM(CN9_SALDO,'@E 999,999,999.99')+CHR(13)+CHR(10);
					+" DiferenÁa: "+ALLTRIM(TRANSFORM(_nDif,'@E 9999,999,999.99')),{"Continuar"},3)
					_lRet := .F.
				ENDIF
			EndIf
		endif
	ENDIF
Next ni

If FunName() == "MATA121"
	If !( GdDeleted( n, aHeader, aCols ) )
		If Empty(aCols[n,nPosCTR]) // Inserido por Solicitacao do Wilson liberar compra direta
			//If Empty(aCols[n,nPosCTW])
			If Empty(aCols[n,nPosSC]) .AND. Empty(aCols[n,nPosCTW])
				Aviso( "Atencao", "SolicitaÁ„o de compra n„o pode estar em branco.", { "Ok" }, 1, "SolicitaÁ„o de compra requerida." )
				_lRet := .f.
				return _lRet
			Else
				_cVrUnitSC1 := Posicione("SC1",1,xFilial("SC1")+aCols[n,nPosSC]+aCols[n,nPosSCItem],"SC1->C1_VLESTIM")
				//If SC7->C7_PRECO > _cVrUnitSC1 //ESTAVA DESPOSICONANDO
				// Tirar essa validaÁ„o (Solicitado pelo Stefano no chamado:001983 )
				//If !Empty(aCols[n,nPosSC]) .AND. aCols[n,_nPOsPrec] > _cVrUnitSC1
				//	Aviso( "Atencao", "Valor total do pedido nao pode ser maior que o estimado na solicitacao de Compras.", { "Ok" }, 1, "Valores divergentes." )
				//	_lRet := .f.
				//	return _lRet
				//Endif
				If n > 1
					_cUnReqSC1 := Posicione("SC1",1,xFilial("SC1")+aCols[1,nPosSC]+aCols[1,nPosSCItem],"SC1->C1_UNIDREQ")
					_cGrAprov1 := Posicione("SY3",1,xFilial("SY3")+_cUnReqSC1,"SY3->Y3_GRAPROV")
					_cUnReqSCn := Posicione("SC1",1,xFilial("SC1")+aCols[n,nPosSC]+aCols[n,nPosSCItem],"SC1->C1_UNIDREQ")
					_cGrAprovn := Posicione("SY3",1,xFilial("SY3")+_cUnReqSCn,"SY3->Y3_GRAPROV")
				Endif
				_lRet := If( n = 1, .T., _cGrAprov1 == _cGrAprovn )
				If !_lRet
					Aviso( "Atencao", "Usar apenas um Grupo de aprovaÁ„o por Pedido de Compra! Item "+StrZero(n,4)+" associado a grupo de aprovaÁ„o ("+_cGrAprovn+") diferente do grupo de aprovaÁ„o ("+_cGrAprov1+") definido para o 1o. item.", { "Ok" }, 1, "Grupos de aprovaÁ„o divergentes!" )
				EndIf
			Endif
			//Endif
		EndIf
	Endif
Endif
////Final Fontes Renova

If	aCols[ n,(Len(aHeader)+1) ] // Se for deletado
	RestArea( aSC7Alias )
	RestArea( aAlias )
	Return (_lRet)
EndIf
/*
If FunName() <> "CNTA120" // Inserido para n„o revalidar, pois no contrato j· existe a validaÁ„o do projeto.
	If SUBSTR( aCols[n,_nPosCON],1,7 ) = '1232103' .AND. Alltrim(aCols[n,_nPosIMC]) = 'N'
		MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" … de Imobilizado em Cursos. Campo Proj. Curso? Deve ser igual a S-SIM!")
		_lRet := .F.
	EndIf

	If Substr( aCols[n,_nPosCON],1,7 ) = '1232103' .AND. Empty(aCols[n,_nPosPIC])
		MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" … de Imobilizado em Cursos. Campo Cod. Proj. C. N„o pode ser em branco! Por favor, escolha o codigo do projeto de imobilizado em curso.")
		_lRet := .F.
	EndIf

	If SUBSTR( aCols[n,_nPosCON],1,7 ) <> '1232103' .AND. Alltrim(aCols[n,_nPosIMC]) = 'S'
		MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" N„o È de Imobilizado em Cursos. Campo Proj. Curso? Deve ser igual a N-N√O!")
		_lRet := .F.
	EndIf

	If Substr( aCols[n,_nPosCON],1,7 ) <> '1232103' .AND. !Empty(aCols[n,_nPosPIC])
		MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" N„o È de Imobilizado em Cursos. Campo Cod. Proj. C. deve ser deixado em branco!")
		_lRet := .F.
	EndIf

	If Substr( aCols[n,_nPosCON],1,7 ) = '1232103' .AND. !Empty(aCols[n,_nPosTES])
		
		_cTesAtf := Posicione("SF4",1,xFilial("SF4")+aCols[n,_nPosTES],"F4_ATUATF")
		
		If Alltrim(_cTesAtf) = 'N'
			MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" … de Imobilizado em Cursos. A TES que deve ser utilizada È de atualiza Ativo Fixo igual S-SIM!")
			_lRet := .F.
		EndIf
	EndIf
EndIf	
*/

RestArea( aSF4Alias )
RestArea( aSC7Alias )
RestArea( aArea )

Return(_lRet)

Static Function GetNumRev( _cContr )
Local cNumRev	:= ''
Local aAreaAtu	:= GetArea()

DBSELECTAREA("CN9")
DBSETORDER(1)
If DBSEEK(xFilial("CN9")+ _cContr)
	While CN9->(!Eof()) .And. CN9->CN9_FILIAL == xFilial('CN9') .And. CN9->CN9_NUMERO == _cContr
		cNumRev := CN9->CN9_REVISA
		CN9->(DbSkip())
	EndDo
EndIf

RestArea(aAreaAtu)

Return( cNumRev )
