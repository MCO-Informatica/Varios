#INCLUDE "RwMake.CH"
#INCLUDE "Protheus.CH"
#INCLUDE "TopConn.CH"


////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//  Função:    F240TBOR 										Módulo: SIGAFIN   //
//                                                                                //
//  Autor:     Denis Guedes  							Data: 27/10/2013          //
//                                                                                //
//  Descrição: Pontos de Entrada na geração do Borderô a fim classificar o título //
//             no borderô de acordo com o segmento                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


User Function F240TBOR()

Private _cModelo    := Alltrim(SEA->EA_MODELO)
Private _cTipoPag   := Alltrim(SEA->EA_TIPOPAG)
Private _aArea      := GetArea()
Private _aAreaTMPSE2 := GetArea()
Private _nSavRec    := 0
Private _cBanco     := SEA->EA_PORTADO
Private _cPrefixo   := SEA->EA_PREFIXO
Private _cTitulo    := SEA->EA_NUM
Private _cParcela   := SEA->EA_PARCELA
Private _cTipo      := SEA->EA_TIPO
Private _cFornece   := SEA->EA_FORNECE
Private _cLoja      := SEA->EA_LOJA
Private _cPortador  := ""
Private _cCodBar    := ""
Private _lTributo   := .F.
Private _nVrTit     := 0.00
Private _nSaldo     := 0.00
Private _nAcres     := 0.00
Private _nDecres    := 0.00
Private _cCGCRen    := Alltrim(SM0->M0_CGC)
Private _cCGCFor    := ""
Private _dDataBor   := CTOD("  /  /    ")
Private _cNumBor    := Space(6)
Private _NumBorDel  := ""
Private _lGrava     := .F.
Private _nValMinTED := Val(GetNewPar("MV_X_TETO", "500"))
Private _cNatICMS   := Alltrim(GetNewPar("ZZ_NATICMS", "2411"))
Private _cNatICMS2  := Alltrim(GetNewPar("MV_ICMS", "ICMS"))
Private _cNatISS    := Alltrim(GetNewPar("ZZ_NATISS", "2406"))
Private _cNatISS2   := Alltrim(GetNewPar("MV_ISS", ""))
Private _cNatIPTU   := Alltrim(GetNewPar("ZZ_NATIPTU", "2328"))
Private _cNatCONC   := Alltrim(GetNewPar("ZZ_NATCONC", "2318/2319"))
Private _cFornUniao := Alltrim(GetNewPar("MV_UNIAO", "UNIAO"))
Private _cFornINSS  := Alltrim(GetNewPar("MV_FORINSS", "INPS"))
//Private _cFornICMS    := Alltrim(GetNewPar("MV_RECEST", "ESTADO"))
Private _lNatIPTU   := .F.
Private _lNatCONC   := .F.
Private _lNatISS    := .F.
Private _lNatISS2   := .F.
Private _lNatICMS   := .F.
Private _lNatICMS2  := .F.
Private _lFornUniao := If(Alltrim(SEA->EA_FORNECE) == _cFornUniao,.T.,.F.)
Private _lFornINSS  := If(Alltrim(SEA->EA_FORNECE) == _cFornINSS,.T.,.F.)
Private _cMotivo    := "Título não atende aos críterios para classificação automática"
Private _cNumBorSX6 := ''
Private _cPastaGrv  := GetTempPath(.T.)		// Pasta de arquivos temporarios, onde sera gravado as querys para debus. 	 // Resultado: "C:\Users\user01\AppData\Private\Temp\"

Private _cGrpEmp := "00"//FWGrpCompany()
Private _cFilMat := ""

Public _aLogF240
Public _aNumBor

If ValType(_aLogF240) = "U"
	_aLogF240 := {}
EndIf

If ValType(_aNumBor) = "U"
	_aNumBor := {}
EndIf

If !(Alltrim(_cModelo))$ "ZZ/ZU" 
	RestArea(_aArea)
	Return()
EndIf


_BorUnico()

RestArea(_aArea)
Return()


cQSE2 := GetNextAlias()


BeginSql Alias cQSE2
	SELECT
	
	SE2.E2_FILIAL,
	SE2.E2_PREFIXO,
	SE2.E2_NUM,
	SE2.E2_PARCELA,
	SE2.E2_TIPO,
	SE2.E2_FORNECE,
	SE2.E2_LOJA,
	SE2.E2_NATUREZ,
	SE2.E2_SALDO,
	SE2.E2_ACRESC,
	SE2.E2_DECRESC,
	SE2.E2_CODBAR,
	SE2.E2_XCODPGT,
	SA2.A2_CGC,
	SA2.A2_BANCO,
	SA2.A2_XTPCONT,
	SE2.E2_IDCNAB,
	SE2.E2_XCNPJC,
	SEA.EA_NUMBOR,
	SEA.EA_DATABOR
	
	FROM 	%Table:SE2% SE2
	
	INNER JOIN %Table:SEA% SEA
	ON
	
	
	SUBSTR(SEA.EA_FILIAL,1,5) = SUBSTR(%XFilial:SEA%,1,5)
	AND SE2.E2_PREFIXO      = SEA.EA_PREFIXO
	AND SE2.E2_NUM          = SEA.EA_NUM
	AND SE2.E2_PARCELA      = SEA.EA_PARCELA
	AND SE2.E2_TIPO         = SEA.EA_TIPO
	AND SE2.E2_FORNECE      = SEA.EA_FORNECE
	AND SE2.E2_LOJA         = SEA.EA_LOJA
	AND SEA.%NotDel%
	
	INNER JOIN %Table:SA2% SA2
	ON
	SUBSTR(SA2.A2_FILIAL,1,5) = SUBSTR(%XFilial:SA2%,1,5)
	AND SE2.E2_FORNECE  = SA2.A2_COD
	AND SE2.E2_LOJA     = SA2.A2_LOJA
	AND SA2.%NotDel%
	
	
	WHERE
	SUBSTR(SE2.E2_FILIAL,1,5) = SUBSTR(%XFilial:SE2%,1,5)
	AND SE2.E2_PREFIXO  = %Exp:_cPrefixo%
	AND SE2.E2_NUM      = %Exp:_cTitulo%
	AND SE2.E2_PARCELA  = %Exp:_cParcela%
	AND SE2.E2_TIPO     = %Exp:_cTipo%
	AND SE2.E2_FORNECE  = %Exp:_cFornece%
	AND SE2.E2_LOJA     = %Exp:_cLoja%
	AND SE2.%NotDel%
EndSql

_aQr1 := GetLastQuery()		// O elemento _aQr1[2] contem a query utilizada
_cQr1 := _aQr1[2]			// O elemento _aQr1[2] contem a query utilizada
MemoWrite(_cPastaGrv + "AAA_F240TBOR_QRY1.TXT",_cQr1)

DbSelectArea(cQSE2)
(cQSE2)->(DbGoTop())

_nVrTit    := (cQSE2)->(E2_SALDO+E2_ACRESC-E2_DECRESC)
_cCodBar   := Alltrim((cQSE2)->E2_CODBAR)
_cTipoTit  := Alltrim((cQSE2)->E2_TIPO)
_cCGCFor   := Alltrim((cQSE2)->A2_CGC)
_cPortador := Alltrim((cQSE2)->A2_BANCO)
_cTpConta  := Alltrim((cQSE2)->A2_XTPCONT)
_dDataBor  := Alltrim((cQSE2)->EA_DATABOR)
_cNaturez  :=  Alltrim((cQSE2)->EA_DATABOR)
_cE2TpPgto := Alltrim((cQSE2)->E2_XCODPGT)
_cXCNPJC   := Alltrim((cQSE2)->E2_XCNPJC)

//Alert("2-"+_cMarcaAtu)
dbSelectArea("SEA")
RecLock("SEA",.F.)
SEA->EA_XIDPROC := Alltrim(_cMarcaAtu)
MsUnlock()

//Alert("3-"+SEA->EA_XIDPROC)

If !Empty(_cCodBar) .and. (Substr(_cCodBar, 1, 1) == "8" )
	_lTributo := .T.
EndIf

_lNatIPTU  := If(Alltrim((cQSE2)->E2_NATUREZ)$ _cNatIPTU,.T.,.F.)
_lNatISS   := If(Alltrim((cQSE2)->E2_NATUREZ)$ _cNatISS,.T.,.F.)
_lNatISS2  := If(Alltrim((cQSE2)->E2_NATUREZ)$ _cNatISS2,.T.,.F.)
_lNatICMS  := If(Alltrim((cQSE2)->E2_NATUREZ)$ _cNatICMS,.T.,.F.)
_lNatICMS2 := If(Alltrim((cQSE2)->E2_NATUREZ)$ _cNatICMS2,.T.,.F.)
_lNatCONC  := If(Alltrim((cQSE2)->E2_NATUREZ)$ _cNatCONC,.T.,.F.)


//(cQSE2)->(DbCloseArea())


//If _cModelo = "ZZ"

If _cE2TpPgto == '3'
	_cModelo := '04' //Ordem de pagamento
	_cTipoPag := '20'
ElseIf _cE2TpPgto == '4'
	If _lTributo
		_cModelo := "13"  //Concessionária
		_cTipoPag := '20'
	ElseIf Empty(_cCodBar)
		_cModelo := "ZZ"
		_cMotivo := "Código de barras não informado"
	ElseIf !(_lTributo)
		_cModelo := "ZZ"
		_cMotivo := "Código de barras invalido para título de concessionária"
	EndIf
	
ElseIf !Empty(_cCodBar)  //Código de Barras
	
	If _lTributo .And. !(_lNatConc) //Tributos com código de barras
		_cTipoPag := '22'
		
		If _lFornUniao //.And. _cTipoTit == 'TX'
			_cModelo := '16'  //DARF
			
		ElseIf _lFornINSS //.And. _cTipoTit == 'INS'
			_cModelo := '17'  //GPS
			
		ElseIf _lNatIPTU .Or. _lNatISS .Or. _lNatISS2
			_cModelo := "19"  //Tributos municipais
			
		ElseIf _lNatICMS .Or. _lNatICMS2
			_cModelo := "22"  //ICMS
		Else
			_cMotivo := "Natureza invalida para codbar de tributo"
		EndIf
		
	ElseIf _lTributo .And. _lNatConc //Concessionária com código de barras
		_cModelo := "13"
		_cTipoPag := '20'
		
	ElseIf _lFornUniao .Or. _lFornINSS .Or. _lNatIPTU .Or._lNatISS .Or. _lNatISS2 .Or. _lNatICMS .Or. _lNatICMS2
		
		_cModelo := "ZZ"
		_cMotivo := "Codbar incorreto para Natureza de tributo/Concessionária"
		
	ElseIf Left(_cCodBar,3) = _cBanco
		_cModelo := "30"  //Mesmo banco
		_cTipoPag := '20'
		
	ElseIf Left(_cCodBar,3) <> _cBanco
		_cModelo := "31" //outros bancos
		_cTipoPag := '20'
		
	EndIf
	
ElseIf !Empty(_cXCNPJC) .And. (_lFornUniao .Or. _lFornINSS .Or. _lNatIPTU .Or. _lNatISS .Or. _lNatISS2 .Or. _lNatICMS .Or. _lNatICMS2)
	//Tributo sem código de barras
	
	_cTipoPag := '22'
	
	If _lFornUniao
		_cModelo := '16'  //DARF
		
	ElseIf _lFornINSS
		_cModelo := '17'  //GPS
		
	ElseIf _lNatIPTU .Or. _lNatISS .Or. _lNatISS2
		_cModelo := "19"  //Tributos municipais
		
	ElseIf _lNatICMS .Or. _lNatICMS2
		_cModelo := "22"  //ICMS
		
	EndIf
	
	//ElseIf _lFornUniao .Or. _lFornINSS .Or. _lNatIPTU .Or. _lNatISS .Or. _lNatISS2 .Or. _lNatICMS .Or. _lNatICMS2
	
	//	_cModelo := "ZZ"
	
ElseIf !Empty(_cPortador)
	_cTipoPag := '20'
	
	If _cCGCRen = _cCGCFor  //Mesma titularidade
		
		If _nVrTit >= _nValMinTED
			_cModelo := "43"  //TED Mesma titularidade
		Else
			_cModelo := "03" //DOC C
		EndIf
		
	Else
		
		If _cPortador = _cBanco  //Mesmo banco
			If _cTpConta = '3'
				_cModelo := "05"  //Transferência Poupança
			Else
				_cModelo := "01"  //Transferência C/C
			EndIf
			
		Else //Outros Bancos
			
			If _nVrTit >= _nValMinTED
				_cModelo := "41" //TED outra titularidade
			Else
				_cModelo := "03" //DOC
			EndIf
		EndIf
	EndIf
ElseIf Empty(_cPortador)
	_cMotivo := "Fornecedor sem banco cadastrado(A2_BANCO)"
EndIf
//EndIf


If Alltrim(_cModelo) = "ZZ"
	
	//MsgBox("O título "+_cPrefixo+"-"+_cTitulo+" não atende a nenhuma  das característica para geração do SISPAG! Verifique.","Atenção !!!", "ALERT")
	aAdd(_aLogF240,{(cQSE2)->E2_FILIAL,(cQSE2)->E2_PREFIXO,(cQSE2)->E2_NUM,(cQSE2)->E2_PARCELA,(cQSE2)->E2_FORNECE,(cQSE2)->E2_LOJA,_cMotivo})
	_lGrava := .F.
	
	RecLock("SE2",.F.)
	_NumBorDel	:= SE2->E2_NUMBOR
	SE2->E2_NUMBOR := ""
	MsUnLock()
	
	_cEA_FILIAL	:= SEA->EA_FILIAL		// Obtenho a filial do SEA para dar seek no SX6 e atualizar o numero do bordero, pois proximo registro pode ser de outra filial
	RecLock   ("SEA",.F.)
	dbDelete()
	MsUnLock()
	
Else
	
	
	cQSEA := GetNextAlias()
	
	BeginSql Alias cQSEA
		SELECT
		
		SEA.EA_NUMBOR,
		SEA.EA_MODELO,
		SEA.EA_DATABOR,
		SE2.E2_IDCNAB
		
		FROM 	%Table:SEA% SEA
		
		INNER JOIN %Table:SE2% SE2
		ON
		//			SE2.E2_FILIAL 	 = SE2.E2_FILIAL	 AND
		SUBSTR(SEA.EA_FILIAL,1,5) = SUBSTR(SE2.E2_FILIAL,1,5) AND  //ESTAVA DESPOSICIONANDO     ADD POR WELLINGTON
		SEA.EA_PREFIXO            = SE2.E2_PREFIXO AND
		SEA.EA_NUM                = SE2.E2_NUM	 AND
		SEA.EA_PARCELA            = SE2.E2_PARCELA AND
		SEA.EA_TIPO               = SE2.E2_TIPO	 AND
		SEA.EA_FORNECE            = SE2.E2_FORNECE AND
		SEA.EA_LOJA               = SE2.E2_LOJA	 AND
		SE2.D_E_L_E_T_ <> '*' AND
		SEA.D_E_L_E_T_ <> '*'
		
		WHERE
		
		SUBSTR(SEA.EA_FILIAL,1,5) = SUBSTR(%XFilial:SEA%,1,5) AND
		SEA.EA_MODELO   = %Exp:_cModelo%  AND
		SEA.EA_DATABOR  = %Exp:_dDataBor% AND
		SEA.EA_XIDPROC   = %Exp:_cMarcaAtu% AND
		SE2.E2_IDCNAB   = ' '
		
	EndSql
	
	_aQr2 := GetLastQuery()		// O elemento _aQr2[2] contem a query utilizada
	_cQr2 := _aQr2[2]			// O elemento _aQr2[2] contem a query utilizada
	MemoWrite(_cPastaGrv + "AAA_F240TBOR_QRY2.TXT",_cQr1)
	
	DbSelectArea(cQSEA)
	(cQSEA)->(DbGoTop())
	
	
	If (cQSEA)->(!Eof())  //Verifica se já existe borderô para o modelo de pagamento
		
		_cNumBor := (cQSEA)->EA_NUMBOR
		
	Else
		
		//_cNumBor := Soma1(Pad(GetMV("MV_NUMBORP"),Len((cQSEA)->EA_NUMBOR)),Len((cQSEA)->EA_NUMBOR))
		// Devido a rotina de multipla empresas, ao inves de usar o getmv que pegra o parametro da empresa/filial atualmente em uso posiciono no parametro da filial do SEA (que pode ser diferente)
		SX6-> (DbSeek( SEA->EA_FILIAL + "MV_NUMBORP") )
		_cNumBor	:=SX6->X6_CONTEUDO
		_cNumBor	:= Soma1(Pad( _cNumBor ,Len((cQSEA)->EA_NUMBOR)),Len((cQSEA)->EA_NUMBOR))
		
		While !MayIUseCode( "EA_NUMBOR"+xFilial("SEA")+_cNumBor)  //verifica se esta na memoria, sendo usado
			_cNumBor := Soma1(_cNumBor)										// busca o proximo numero disponivel
		EndDo
		
		//freeusedCode()
		
	EndIf
	
	If _lGrava
		RecLock   ("SEA",.F.)
		SEA->EA_NUMBOR  := _cNumBor
		SEA->EA_MODELO  := _cModelo
		SEA->EA_TIPOPAG := _cTipoPag
		MsUnLock()
		
		RecLock   ("SE2",.F.)
		SE2->E2_NUMBOR := _cNumBor
		MsUnLock()
		
		//_cNumBor := Soma1(_cNumBor)
		
		//dbSelectArea("SX6")
		//_cNumBorSX6 := GetMv("MV_NUMBORP")
		SX6-> (DbSeek( SEA->EA_FILIAL + "MV_NUMBORP") )
		_cNumBorSX6	:=SX6->X6_CONTEUDO
		
		// Garante que o numero do bordero seja sempre superior ao numero anterior
		If _cNumBorSX6 < _cNumbor
			
			RecLock("SX6",.F.)
			SX6->X6_CONTEUDO	:= _cNumbor
			//PUTMV("MV_NUMBORP",_cNumbor)
			MsUnlock()
			
		Endif
	EndIf
	
EndIf

(cQSE2)->(DbCloseArea())

If _lGrava
	(cQSEA)->(DbCloseArea())
EndIf


//_cMarcaAtu  := GetMark()

//If _cMarcaAtu = _cMarca
&(__cuserid) := &(__cuserid)+1
//EndIf

If (&(__cuserid) == _nTotSelec) .And. Len(_aLogF240)>0
	
	//Cabecalho do Log de processamento:
	AutoGRLog(Replicate("=",64))
	AutoGRLog("                  A T E N Ç Ã O                ")
	AutoGRLog("            TITULOS NÃO CLASSIFICADOS          ")
	
	//Detalhes do Log de processamento:
	//	AutoGRLog(Replicate("=",75))
	//	AutoGRLog("I T E N S :")
	//	AutoGRLog(Replicate("=",75))
	
	
	For xx:=1 to len(_aLogF240)
		AutoGRLog(Replicate("-",96))
		AutoGRLog("Empresa: " + _aLogF240[xx,1] + " - Prefixo: " + _aLogF240[xx,2] + " - Número: " + _aLogF240[xx,3] + " - Parcela: " + _aLogF240[xx,4] + " - Fornecedor: " + _aLogF240[xx,5] + " - Loja: " + _aLogF240[xx,6] + " Motivo: " + _aLogF240[xx,7])
	Next
	
	_aLogF240 := {}
	MostraErro()
EndIf

RestArea(_aArea)

Return()

/////////////////////////////////////////////////
// _BorUnico
//
/////////////////////////////////////////////////

Static Function _BorUnico()

_nVrTit    := SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC)
_cCodBar   := Alltrim(SE2->E2_CODBAR)
_cTipoTit  := Alltrim(SE2->E2_TIPO)
_cCGCFor   := Alltrim(SA2->A2_CGC)
_cPortador := Alltrim(SA2->A2_BANCO)
_cTpConta  := Alltrim(SA2->A2_XTPCONT)
_dDataBor  := Alltrim(SEA->EA_DATABOR)
_cNaturez  :=  Alltrim(SE2->E2_NATUREZ)
_cE2TpPgto := Alltrim(SE2->E2_XCODPGT)
_cXCNPJC   := Alltrim(SE2->E2_XCNPJC)
_cFilOri  := Alltrim(SEA->EA_FILORIG)

dbSelectArea("SEA")
RecLock("SEA",.F.)
SEA->EA_XIDPROC := Alltrim(_cMarcaAtu)
MsUnlock()

Z03->(dbsetorder(1))
Z03->(DBSeek( xfilial("Z03") +_cGrpEmp+_cFilori ))
_cFilCon := Z03->Z03_FILCON

_cFilMat  := Substr(SEA->EA_FILORIG,1,5)+_cFilCon



If Alltrim(_cModelo)$"ZZ/ZU"
	
	If !Empty(_cCodBar) .and. (Substr(_cCodBar, 1, 1) == "8" )
		_lTributo := .T.
	EndIf
	
	
	_lNatIPTU  := If(Alltrim(SE2->E2_NATUREZ)$ _cNatIPTU,.T.,.F.)
	_lNatISS   := If(Alltrim(SE2->E2_NATUREZ)$ _cNatISS,.T.,.F.)
	_lNatISS2  := If(Alltrim(SE2->E2_NATUREZ)$ _cNatISS2,.T.,.F.)
	_lNatICMS  := If(Alltrim(SE2->E2_NATUREZ)$ _cNatICMS,.T.,.F.)
	_lNatICMS2 := If(Alltrim(SE2->E2_NATUREZ)$ _cNatICMS2,.T.,.F.)
	_lNatCONC  := If(Alltrim(SE2->E2_NATUREZ)$ _cNatCONC,.T.,.F.)
	
	If _cE2TpPgto == '3'
		_cModelo := '04' //Ordem de pagamento
		_cTipoPag := '20'
	ElseIf _cE2TpPgto == '4'
		If _lTributo
			_cModelo := "13"  //Concessionária
			_cTipoPag := '20'
		ElseIf Empty(_cCodBar)
			_cModelo := "ZZ"
			_cMotivo := "Código de barras não informado"
		ElseIf !(_lTributo)
			_cModelo := "ZZ"
			_cMotivo := "Código de barras invalido para título de concessionária"
		EndIf
		
	ElseIf !Empty(_cCodBar)  //Código de Barras
		
		If _lTributo .And. !(_lNatConc) //Tributos com código de barras
			_cTipoPag := '22'
			
			If _lFornUniao //.And. _cTipoTit == 'TX'
				_cModelo := '16'  //DARF
				
			ElseIf _lFornINSS //.And. _cTipoTit == 'INS'
				_cModelo := '17'  //GPS
				
			ElseIf _lNatIPTU .Or. _lNatISS .Or. _lNatISS2
				_cModelo := "19"  //Tributos municipais
				
			ElseIf _lNatICMS .Or. _lNatICMS2
				_cModelo := "22"  //ICMS
			Else
				_cMotivo := "Natureza invalida para codbar de tributo"
			EndIf
			
		ElseIf _lTributo .And. _lNatConc //Concessionária com código de barras
			_cModelo := "13"
			_cTipoPag := '20'
			
		ElseIf _lFornUniao .Or. _lFornINSS .Or. _lNatIPTU .Or._lNatISS .Or. _lNatISS2 .Or. _lNatICMS .Or. _lNatICMS2
			
			_cModelo := "ZZ"
			_cMotivo := "Codbar incorreto para Natureza de tributo/Concessionária"
			
		ElseIf Left(_cCodBar,3) = _cBanco
			_cModelo := "30"  //Mesmo banco
			_cTipoPag := '20'
			
		ElseIf Left(_cCodBar,3) <> _cBanco
			_cModelo := "31" //outros bancos
			_cTipoPag := '20'
			
		EndIf
		
	ElseIf !Empty(_cXCNPJC) .And. (_lFornUniao .Or. _lFornINSS .Or. _lNatIPTU .Or. _lNatISS .Or. _lNatISS2 .Or. _lNatICMS .Or. _lNatICMS2)
		//Tributo sem código de barras
		
		_cTipoPag := '22'
		
		If _lFornUniao
			_cModelo := '16'  //DARF
			
		ElseIf _lFornINSS
			_cModelo := '17'  //GPS
			
		ElseIf _lNatIPTU .Or. _lNatISS .Or. _lNatISS2
			_cModelo := "19"  //Tributos municipais
			
		ElseIf _lNatICMS .Or. _lNatICMS2
			_cModelo := "22"  //ICMS
			
		EndIf
				
	ElseIf !Empty(_cPortador)
		_cTipoPag := '20'
		
				
		//SM0->(DBSEEK( SEA->EA_FILORIG )) //Denis - Verificar
		SM0->(DBSEEK( _cFilMat )) //Denis - Verificar
		_cCGCRen := Alltrim(SM0->M0_CGC) 
		
		If _cCGCRen = _cCGCFor  //Mesma titularidade
			
			If _nVrTit >= _nValMinTED
				_cModelo := "43"  //TED Mesma titularidade
			Else
				_cModelo := "03" //DOC C
			EndIf
			
		Else
			
			If _cPortador = _cBanco  //Mesmo banco
				If _cTpConta = '3'
					_cModelo := "05"  //Transferência Poupança
				Else
					_cModelo := "01"  //Transferência C/C
				EndIf
				
			Else //Outros Bancos
				
				If _nVrTit >= _nValMinTED
					_cModelo := "41" //TED outra titularidade
				Else
					_cModelo := "03" //DOC
				EndIf
			EndIf
		EndIf
	ElseIf Empty(_cPortador)
		_cMotivo := "Fornecedor sem banco cadastrado(A2_BANCO)"
	EndIf
	
	If Alltrim(_cModelo)$"ZZ/ZU"
		
		aAdd(_aLogF240,{SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_LOJA,_cMotivo})
		_lGrava := .F.
		
		RecLock("SE2",.F.)
		_NumBorDel	:= SE2->E2_NUMBOR
		SE2->E2_NUMBOR := ""
		MsUnLock()
		
		//_cEA_FILIAL	:= SEA->EA_FILIAL		// Obtenho a filial do SEA para dar seek no SX6 e atualizar o numero do bordero, pois proximo registro pode ser de outra filial
		RecLock   ("SEA",.F.)
		dbDelete()
		MsUnLock()
	EndIf
EndIf

_lGrava := .T.  //CONFIRMAR

Z03->(dbsetorder(1))
Z03->(DBSeek( xfilial("Z03") +_cGrpEmp+_cFilori ))
_cFilCon := Z03->Z03_FILCON

//Denis Ini
_cFilMat  := Substr(SEA->EA_FILORIG,1,5)+_cFilCon
//_cNumBor := (SEA)->EA_NUMBOR
//Denis Fim


//Denis Ini
If SUBSTR(SEA->EA_FILIAL,1,5) <> SUBSTR(SEA->EA_FILORIG,1,5) //Verifica se a empresa logada é diferente da empresa do título
	
	If Len(_aNumbor) > 0
		nPos := ascan( _aNumbor , {|X| X[1]+X[3]+X[4] = LEFT(SEA->EA_FILORIG,5)+SEA->EA_XIDPROC+_cModelo })
		
		If nPos > 0
			_lGrava := .T.
			_cNumBor := _aNumBor[nPos][2]
			
		Else
			_cNumBor := fNumBor()
			/*
			_lGrava := .T.
			SX6->(DbSeek( _cFilMat + "MV_NUMBORP") )
			_cNumBor	:= SX6->X6_CONTEUDO
			_cNumBor	:= Soma1(Pad(_cNumBor ,Len(SEA->EA_NUMBOR)),Len(SEA->EA_NUMBOR))
			
			While !MayIUseCode( "EA_NUMBOR"+_cFilMat+_cNumBor)  //Denis - verificar se esta correto
				_cNumBor := Soma1(_cNumBor)										// busca o proximo numero disponivel
			EndDo
			
			Aadd( _aNumBor, { LEFT(SEA->EA_FILORIG,5),_cNumBor, SEA->EA_XIDPROC, _cModelo } )
			
			RecLock("SX6",.F.)
			SX6->X6_CONTEUDO := _cNumbor
			MsUnlock()
			*/
		EndIf
	Else
		_cNumBor := fNumBor()
		/*
		_lGrava := .T.
		SX6->(DbSeek( _cFilMat + "MV_NUMBORP") )
		_cNumBor	:= SX6->X6_CONTEUDO
		_cNumBor	:= Soma1(Pad( _cNumBor ,Len(SEA->EA_NUMBOR)),Len(SEA->EA_NUMBOR))
		
		While !MayIUseCode( "EA_NUMBOR"+_cFilMat+_cNumBor)  //Denis - verificar se esta correto
			_cNumBor := Soma1(_cNumBor)										// busca o proximo numero disponivel
		EndDo
		
		Aadd( _aNumBor, { LEFT(SEA->EA_FILORIG,5),_cNumBor, SEA->EA_XIDPROC, _cModelo } )
		
		RecLock("SX6",.F.)
		SX6->X6_CONTEUDO := _cNumbor
		MsUnlock()
		*/
		
	Endif
	
Else
	If Len(_aNumbor) > 0
		
		nPos := ascan( _aNumbor , {|X| X[1]+X[3]+X[4] = LEFT(SEA->EA_FILORIG,5)+SEA->EA_XIDPROC+_cModelo })
		
		If nPos > 0 //Borderô para o modelo já existe
			_lGrava := .T.
			_cNumBor := _aNumBor[nPos][2]
			
		Else
			_cNumBor := fNumBor()
		/*
			_lGrava := .T.
			SX6->(DbSeek( _cFilMat + "MV_NUMBORP") )
			_cNumBor	:= SX6->X6_CONTEUDO
			_cNumBor	:= Soma1(Pad(_cNumBor ,Len(SEA->EA_NUMBOR)),Len(SEA->EA_NUMBOR))
			
			While !MayIUseCode( "EA_NUMBOR"+_cFilMat+_cNumBor)  //Denis - verificar se esta correto
				_cNumBor := Soma1(_cNumBor)										// busca o proximo numero disponivel
			EndDo
			
			Aadd( _aNumBor, { LEFT(SEA->EA_FILORIG,5),_cNumBor, SEA->EA_XIDPROC, _cModelo } )
			
			RecLock("SX6",.F.)
			SX6->X6_CONTEUDO := _cNumbor
			MsUnlock()
			
		*/
		EndIf
		
		
	Else //Primeiro título da empresa logada por isso aproveito a numeração do borderô
		_lGrava := .T.
		_cNumBor := fNumbor()
		Aadd( _aNumBor, { LEFT(SEA->EA_FILORIG,5),_cNumBor, SEA->EA_XIDPROC,_cModelo } )
		_cNumBor := SEA->EA_NUMBOR
		

	EndIf
	
EndIf

If _lGrava
	
	//Z03->(dbsetorder(1))
	//Z03->(DBSeek( xfilial("Z03") +_cGrpEmp+_cFilMat ))
	
	RecLock   ("SEA",.F.)
	SEA->EA_NUMBOR  := _cNumBor
	//Denis Ini
	SEA->EA_MODELO  := _cModelo
	SEA->EA_TIPOPAG := _cTipoPag
	SEA->EA_FILIAL    := _cFilMat
	SEA->EA_PORTADO   := Z03->Z03_BANCO
	SEA->EA_AGEDEP    := Z03->Z03_AGENC
	SEA->EA_NUMCON	  := Z03->Z03_NUMCON
	//Denis Fim
	MsUnLock()
	
	RecLock   ("SE2",.F.)
	SE2->E2_NUMBOR := _cNumBor
	//Denis Ini
	SE2->E2_PORTADO := Z03->Z03_BANCO
	//Denis Fim
	MsUnLock()
	
EndIf

//As variáveis __cuserid e _nTotSelec são criadas/manipuladas no ponto de entrada F240TDOK

&(__cuserid) := &(__cuserid)+1

If (&(__cuserid) == _nTotSelec) .And. Len(_aLogF240)>0
	
	//Cabecalho do Log de processamento:
	AutoGRLog(Replicate("=",64))
	AutoGRLog("                  A T E N Ç Ã O                ")
	AutoGRLog("            TITULOS NÃO CLASSIFICADOS          ")
	
	//Detalhes do Log de processamento:
	//	AutoGRLog(Replicate("=",75))
	//	AutoGRLog("I T E N S :")
	//	AutoGRLog(Replicate("=",75))
	
	
	For xx:=1 to len(_aLogF240)
		AutoGRLog(Replicate("-",96))
		AutoGRLog("Empresa: " + _aLogF240[xx,1] + " - Prefixo: " + _aLogF240[xx,2] + " - Número: " + _aLogF240[xx,3] + " - Parcela: " + _aLogF240[xx,4] + " - Fornecedor: " + _aLogF240[xx,5] + " - Loja: " + _aLogF240[xx,6] + " Motivo: " + _aLogF240[xx,7])
	Next
	
	_aLogF240 := {}
	MostraErro()
EndIf

RestArea(_aArea)

Return


//Jairo//
/*
Private cFilAtu_		:= ""

CFILANT := CFILATU_ := ""

Z03->(dbsetorder(1))
Z03->(DBSeek( xfilial("Z03") + cEmpAnt + SE2->E2_FILIAL ))

//if SUBSTR(SE2->E2_FILIAL,1,5) + Z03->(Z03_BANCO+Z03_AGENC+Z03_NUMCOM)  <> cFilATU_ //jj
if SUBSTR(SE2->E2_FILIAL,1,5) <> cFilATU_ //jj

IF !EMPTY(CNUMBOR)
dbSelectArea("SX6")
//GetMv("MV_NUMBORP")
SX6-> (DbSeek( SE2->E2_FILIAL + "MV_NUMBORP") )
// Garante que o numero do bordero seja sempre superior ao numero anterior
If SX6->X6_CONTEUD < cNumbor
RecLock("SX6",.F.)
SX6->X6_CONTEUD := cNumbor
msUnlock()
Endif
DBSELECTAREA(cAliasSE2)
ENDIF

CFILATU_ := SUBSTR(SE2->E2_FILIAL,1,5) //+ Z03->(Z03_BANCO+Z03_AGENC+Z03_NUMCOM)

nPos := ascan( aSelEmp , {|X| X[1] = SUBSTR( SE2->E2_FILIAL, 1,5 ) })

IF NPOS = 0
(CALIASSE2)->(DBSKIP())
LOOP
ENDIF

cPort240  := Z03->Z03_BANCO
cAgen240  := Z03->Z03_AGENC
cConta240 := Z03->Z03_NUMCON

cFilAnt	:= ASELEMP[NPOS,3]
SM0->(DBSEEK( cEMPANT + CFILANT ))

FreeUsedCode()
//cNumBor := Soma1(Pad(GetMV("MV_NUMBORP"),Len(SE2->E2_NUMBOR)),Len(SE2->E2_NUMBOR))
// Devido a rotina de multipla empresas, ao inves de usar o getmv que pegra o parametro da empresa/filial atualmente em uso posiciono no parametro da filial do SEA (que pode ser diferente)
SX6-> (DbSeek( SE2->E2_FILIAL + "MV_NUMBORP") )
cNumBor	:=SX6->X6_CONTEUDO
cNumBor	:= Soma1(Pad( cNumBor ,Len( SEA->EA_NUMBOR)),Len( SEA->EA_NUMBOR))

While !MayIUseCode( "E2_NUMBOR"+xFilial("SE2")+cNumBor)  //verifica se esta na memoria, sendo usado
cNumBor := Soma1(cNumBor)										// busca o proximo numero disponivel
EndDo
aselemp[npos,4] := cnumbor

EndIf



*/


Static Function fNumbor()

_lGrava := .T.
SX6->(DbSeek( _cFilMat + "MV_NUMBORP") )
_cNumBor	:= SX6->X6_CONTEUDO
_cNumBor	:= Soma1(Pad(_cNumBor ,Len(SEA->EA_NUMBOR)),Len(SEA->EA_NUMBOR))

While !MayIUseCode( "EA_NUMBOR"+_cFilMat+_cNumBor)  //Denis - verificar se esta correto
	_cNumBor := Soma1(_cNumBor)										// busca o proximo numero disponivel
EndDo

Aadd( _aNumBor, { LEFT(SEA->EA_FILORIG,5),_cNumBor, SEA->EA_XIDPROC, _cModelo } )

RecLock("SX6",.F.)
SX6->X6_CONTEUDO := _cNumbor
MsUnlock()
Return(_cNumBor)

