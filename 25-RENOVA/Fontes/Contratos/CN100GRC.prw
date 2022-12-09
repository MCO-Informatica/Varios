#Include 'Rwmake.ch'
#Include 'Protheus.ch'
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Define DEF_TRANS "001" // Transação de controle total do contrato

/*
Programa.: CN100GRC
Autor....: Pedro Augusto
Data.....: 05/10/2015
Descricao: Ponto de entrada apos a gravacao do contrato.

Pedro: Grava __cUserID no CN9_XUSER, se medicao manual ou grava o M->CN9_XUSER informado, se medicao automatica

Danilo: Regra compra centralizada.

Uso......: RENOVA
*/
User Function CN100GRC()

Local aCN9  := GetArea("CN9")
Local aCN1  := GetArea("CN1")
Local _nOpc := ParamIXB[1]  // nOpc: 5 = Exclusao

// Início regra compra centralizada.

Local nI
Local _nTotCentr   := 0
Local nValLimC := GetMv("MV_XVLCDEC")  // Valor limite para compras decentralizadas
Local aAreaCNB := CNB->(GetArea())
Local lRegraGrExc := .F.
Local _cOrigem := ''
Local _cCompCen := ''

Local ExpN1 := PARAMIXB[1] //Opcao selecionada pelo usuario. 2 - Visualizar, 3 - Incluir, 4 - Alterar, 5- Excluir
Local ExpA1 := PARAMIXB[2]
Local ExpA2 := PARAMIXB[3]
Local ExpA3 := PARAMIXB[4]
Local ExpA4 := PARAMIXB[5]


// Fim regra compra centralizada.

If _nOpc <> 5
	
	CN1->(dbSetOrder(1))
	CN1->(DbSeek(xfilial("CN1") + M->CN9_TPCTO))
	
	If !CN1->(Eof())
		If CN1->CN1_MEDAUT == "2"
			RecLock("CN9",.F.)
			CN9->CN9_XUSER  := UsrFullName(__cUserID)   // ALTERADO PARA GRAVAR O NOME DO USUARIO
			CN9->CN9_XCODUS := __cUserID
			MsUnlock()
		EndIf
	EndIf
	
	RestArea(aCN1)
	RestArea(aCN9)
	
Endif

// Início regra compra centralizada.

DbSelectArea("CNB")
CNB->(DbSetOrder(01))

if !CNB->(DbSeek(xFilial("CNB")+CN9->CN9_NUMERO))
	If RecLock("CN9",.F.)
		CN9->CN9_TPCONT := "2"
		CN9->(MsUnlock())
	EndIf
else
	while CNB->CNB_FILIAL+CNB->CNB_CONTRA == CN9->CN9_FILIAL+CN9->CN9_NUMERO .and. CNB->(!Eof())
		
		_nTotCentr += CNB->CNB_VLTOT
		
		// Aplica a regra apenas para o primeiro item
		// Compara a origem, regras para produto importado
		_cOrigem := Posicione("SB1",1,xFilial("SB1")+CNB->CNB_PRODUT,"B1_ORIGEM")
		If _cOrigem $ "1/6"
			lRegraGrExc := .T.
		Endif
		
		// Compara se o item deve ser centralizado independente do valor
		_cCompCen := Posicione("SB1",1,xFilial("SB1")+CNB->CNB_PRODUT,"B1_XITEMC")// ITEM CENTRALIZADO
		If _cCompCen = '1'
			lRegraGrExc := .T.
		Endif
		
		CNB->(DbSkip())
		
	enddo
	
	// Atualiza o tipo de contrato - centralizado ou não
	_CTipoCen := iif(_nTotCentr >= nValLimC .or. lRegraGrExc ,'1','2') // 1-Centralizada - 2 - Descentralizada
	
	If RecLock("CN9",.F.)
		CN9->CN9_TPCONT := _CTipoCen
		CN9->(MsUnlock())
	EndIf
	
endif

if ExpN1 == 3 //INCLUSAO
	dbSelectArea("CNN")
	dbSetOrder(2) //CNN_FILIAL+CNN_GRPCOD+CNN_CONTRA+CNN_TRACOD
	IF !dbSeek(XFILIAL("CNN")+"000067"+CN9->CN9_NUMERO)
		RecLock("CNN",.T.)
		CNN->CNN_FILIAL := XFILIAL("CNN")
		CNN->CNN_CONTRA := CN9->CN9_NUMERO
		CNN->CNN_GRPCOD := "000067"
		CNN->CNN_TRACOD := DEF_TRANS
		MsUnlock()
	Endif
elseif ExpN1 == 5 //EXCLUSAO
	dbSelectArea("CNN")
	dbSetOrder(2) //CNN_FILIAL+CNN_GRPCOD+CNN_CONTRA+CNN_TRACOD
	IF dbSeek(XFILIAL("CNN")+"000067"+CN9->CN9_NUMERO)
		RecLock("CNN",.F.)
		CNN->(DbDelete())
		CNN->(MsUnlock())
	ENDIF
Endif


RestArea(aAreaCNB)

// Fim regra compra centralizada.

Return Nil
