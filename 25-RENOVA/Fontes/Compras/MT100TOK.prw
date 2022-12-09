#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MT100TOK  ºAutor  ³                				16/10/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para validar os totais da nota de acordo   º±±
±±           ³com as regras de tolerância			                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100TOK

Local _lRet := .T.
Local _cPedido := ''
Local nMVTOLENT := GetMv("MV_XTOLERA") // Valor máximo de tolerância de recebimento
Local cTESExec :=  GetMv("MV_TESPCNF") // TES que devem ser desconsiderados
//Local _nPosBICM := aScan(aHeader,{|x| AllTrim(x[2])=="D1_BASEICM"})
Local _nPosBICM := aScan(aHeader,{|x| AllTrim(x[2])=="D1_BASEICM"})
Local _nPosPedC := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local _nPosTES := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local _nItemD1 := 0
Local _nTotNota := 0
Local _nTotPed := 0
Local _nDifEnt := 0
LOcal _nItens 
local _nPed
Local _nPed2

IF CMODULO = "COM"  .OR. CMODULO = "GCT" .OR. CMODULO = "EST"
	
	//_cPedido := aCols[1,_nPosPedC] //
	_cTESNF  := aCols[1,_nPosTES]  // TES do primeiro item
	_cAreaSC7 := GetArea("SC7")
	_cAreaSD1 := GetArea("SD1")
	_cAreaSE4 := GetArea("SE4")
	
	// Busca por todos os pedidos da nota
	_nItens := 0
	nPosPed := 0
	aPedidos := {}
	For _nItens := 1 to len(aCols)
		_cPedAcol := aCols[_nItens,_nPosPedC]
		nPosPed := aScan(aPedidos,{|x|x == _cPedAcol}) 		//CC - Verifica se o campo ja existe no array
		if nPosPed = 0
			aAdd(aPedidos,_cPedAcol)				//Inclui o campo
		endif
	Next _nItens
	
	// Verifica se a TES não é Execeção
	if ! _cTESNF $ cTESExec
		// Apura o total da nota
		For _nItemD1 := 1 to len(aCols)
			If !aCols[_nItemD1][Len(aHeader)+1] //Ignora Linha deletada na tela - Wellington Mendes
				_nTotNota +=  aCols[_nItemD1,_nPosBICM] // Base de ICMS
			Endif
			
		Next _nItemD1
		
		// Apura total do pedido
		_nPed := 0
		For _nPed := 1 to len(aPedidos)
			_cPedido := aPedidos[_nPed]
			DbSelectArea("SC7")
			DbGotop()
			IF SC7->(DbSeek(xFilial("SC7")+_cPedido))
				While ! SC7->(EOF()) .AND. SC7->C7_NUM = _cPedido
					If Empty(SC7->C7_ENCER) //- incluido tratamento para ignorar item do pc ja atendido na soma  - Wellington mendes.
						_nTotPed += SC7->C7_BASEICM
					Endif
					SC7->(DbSkip())
				Enddo
			Endif
		Next
		
		// Apura diferença
		_nDifEnt := _nTotNota - _nTotPed
		//		if _nDifEnt > nMVTOLENT .or. _nDifEnt < 0 tirar negativo
		if _nDifEnt > nMVTOLENT
			ShowHelpDlg("CMA20BLQ",{"A diferença de R$:"+alltrim(str(_nDifEnt))+" é superior a estabelecida pelas regras de Tolerância de Recebimento",""},3,;
			{"Diferença deve ser igual ou inferior a R$:"+alltrim(str(nMVTOLENT))+", Conforme parâmetro MV_XTOLERA",""},3)
			_lRet := .F.
		Endif
	Endif
	
	// Verifica se há adiantamento vinculado ao pedido para não permitir utilizar a condição de pagamento
	DbSelectArea("SE4")
	DbGotop()
	IF SE4->(DbSeek(xFilial("SE4")+ALLTRIM(CCONDICAO)))
		_GeraAdt:= SE4->E4_CTRADT // Busca o conteudo do campo controle adt
	ENDIF
	
	_nPed2 := 0

	For _nPed2 := 1 to len(aPedidos)
		_cPedido2 := aPedidos[_nPed2]
		DbSelectArea("FIE")
		DbGotop()
		IF FIE->(DbSeek(xFilial("FIE")+"P"+_cPedido2))
			IF _GeraAdt == "2"   //Valida se tem controle de adiantamento 2 = "não"
				MsgAlert("O Pedido de compra: "+_cPedido2+" possui adiantamento vinculado, favor manter a condição de pagameto original ou informar outra que possui controle de adiantamento")
				_lRet:= .F.
			Endif
		ENDIF
	Next
	
	RestArea(_cAreaSC7)
	RestArea(_cAreaSD1)
	RestArea(_cAreaSE4)
EndIF
Return(_lRet)
