#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VERQUICRED ºAutor  ³ Daniel Salese    º Data ³  16/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para analise de credito                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                               
±±ºUso       ³ Verquimica                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VERQUICRED(cCliente,cLoja,cPedido)

Local _aAreaVC	  := GetArea()
Local _lOkay	  := .T.
Local _cQuery	  := ""
Local _cFinLim    := Chr(13)+Chr(10)
Local _lTemMsg    := .F.
Local _lAleMsg    := .F.
Local _cMsg1   	  := ""
Local _cMsg2      := ""
Local _cMsg3      := ""
Local _cMsgCrd    := "BLOQUEIO REGRAS FINANCEIRAS - PEDIDO "+cPedido
Local _nValSE1	  := 0
Local _nValSC6	  := 0
Local _nValAtr	  := 0
Local _nLimite	  := 0

// Libera regra do pedido
lLibPed := SuperGetMv("VQ_LIBPED", ,.T.)
If lLibPed == .F.
	Return(.T.)
EndIf

// Vendedores Bloqueados com Pedido
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+cPedido,.f.)

cVend := POSICIONE("SC5",1,xFilial("SC5")+cPedido,"C5_VEND1")



If cVend $ GetMv("MV_VQ_BLVEN")
	
	_cMsg1 	+= "O vendedor ("+cVend+") está bloqueado para realizar atendimento."+_cFinLim+_cFinLim
	
	If FunName() $ 'TMKA271'
		_cCodMot+= "44E4|"
		
		If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
			If At("44E4|", SC5->C5_VQ_MOT)=0
				RecLock("SC5",.f.)
				SC5->C5_BLQ		:= "1"
				SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"44E4|"
				MsUnLock()
			EndIf
		EndIf
	Else
		If At("44E4|", SC5->C5_VQ_MOT)=0
			RecLock("SC5",.f.)
			SC5->C5_BLQ		:= "1"
			SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"44E4|"
			MsUnLock()
		EndIf
		
	EndIf
	_lTemMsg := .T.
	_lOkay	 :=	.F.
EndIf

// Verifica Data Limite Credito

dDtLimCred := POSICIONE("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_VENCLC")
If !Empty(dDtLimCred)
	If dDtLimCred < DATE()
		
		_cMsg1 	+= "Data do Limite Crédito ("+DTOC(dDtLimCred)+") do cliente expirou."+_cFinLim+_cFinLim
		If FunName() $ 'TMKA271'
			_cCodMot+= "44E3|"
			
			If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
				If At("44E3|", SC5->C5_VQ_MOT)=0
					RecLock("SC5",.f.)
					SC5->C5_BLQ		:= "1"
					SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"44E3|"
					MsUnLock()
				EndIf
			EndIf
		Else
			If At("44E3|", SC5->C5_VQ_MOT)=0
				RecLock("SC5",.f.)
				SC5->C5_BLQ		:= "1"
				SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"44E3|"
				MsUnLock()
			EndIf
			
		EndIf
		_lTemMsg := .T.
		_lOkay	 :=	.F.
	EndIf
EndIf

// Tem que validar titulos em Atraso
nDiasAtr := SuperGetMv("VQ_DIASATR", ,2) // Dias de atraso ref.
If Empty(nDiasAtr)
	nDiasAtr := 1
EndIf

_cQuery := " SELECT	SA1.A1_COD AS CLIENTE, SA1.A1_LOJA AS LOJA, SA1.A1_LC LIMITE, SUM(ISNULL(DAD.C5_VALOR,0)) VALOR, DAD.C5_OBS IDENTIF " + _cFinLim
_cQuery += " FROM	"+RetSqlName("SA1")+" SA1 " + _cFinLim
_cQuery += " LEFT	JOIN	(	SELECT	SC5.C5_FILIAL, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SUM((((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN)* CASE WHEN SC5.C5_MOEDA > 1 THEN SC5.C5_VQ_TXMO ELSE 1 END )) C5_VALOR, '03 - PEDIDO EM ABERTO' C5_OBS " + _cFinLim
_cQuery += " FROM	"+RetSqlName("SC5")+" SC5 " + _cFinLim
_cQuery += " INNER	JOIN "+RetSqlName("SC6")+" SC6 ON " + _cFinLim
_cQuery += " SC5.C5_FILIAL = SC6.C6_FILIAL AND " + _cFinLim
_cQuery += " SC5.C5_CLIENTE = SC6.C6_CLI AND " + _cFinLim
_cQuery += " SC5.C5_LOJACLI = SC6.C6_LOJA AND " + _cFinLim
_cQuery += " SC5.C5_NUM = SC6.C6_NUM AND " + _cFinLim
_cQuery += " SC6.C6_BLQ <> 'R' AND " + _cFinLim
_cQuery += " SC6.D_E_L_E_T_ = ' ' " + _cFinLim
_cQuery += " WHERE	SC5.C5_NOTA = ' ' AND " + _cFinLim
_cQuery += " SC5.D_E_L_E_T_ = ' ' " + _cFinLim
_cQuery += " GROUP	BY SC5.C5_FILIAL, SC5.C5_CLIENTE, SC5.C5_LOJACLI " + _cFinLim
_cQuery += " UNION ALL" + _cFinLim
_cQuery += " SELECT	SE1.E1_FILIAL,SE1.E1_CLIENTE,SE1.E1_LOJA, SUM(SE1.E1_SALDO) E1_VALOR, " + _cFinLim
_cQuery += " CASE WHEN SE1.E1_VENCREA < '"+dtos(dDatabase-nDiasAtr)+"' THEN '01 - TITULOS EM ATRASO' ELSE '02 - TITULOS EM ABERTO' END E1_OBS " + _cFinLim
_cQuery += " FROM	"+RetSqlName("SE1")+" SE1 " + _cFinLim
_cQuery += " WHERE	SE1.E1_SALDO > 0 " + _cFinLim
_cQuery += " AND SE1.D_E_L_E_T_ = ' ' " + _cFinLim   
_cQuery += " AND SE1.E1_TIPO NOT IN ('RA','NCC') " + _cFinLim   
_cQuery += " GROUP	BY SE1.E1_FILIAL,SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_VENCREA ) DAD ON " + _cFinLim
_cQuery += " SA1.A1_COD = DAD.C5_CLIENTE AND " + _cFinLim
_cQuery += " SA1.A1_LOJA = DAD.C5_LOJACLI " + _cFinLim
_cQuery += " WHERE	SA1.A1_COD = '"+cCliente+"' AND " + _cFinLim
_cQuery += " SA1.A1_LOJA = '"+cLoja+"' AND " + _cFinLim
_cQuery += " SA1.D_E_L_E_T_ = ' ' " + _cFinLim
_cQuery += " GROUP	BY SA1.A1_COD,SA1.A1_LOJA,SA1.A1_LC,DAD.C5_OBS " + _cFinLim
_cQuery += " ORDER	BY DAD.C5_OBS " + _cFinLim

_cQuery := ChangeQuery(_cQuery)

If Select("TMPSE1") > 0
	TMPSE1->(DbCloseArea())
EndIf

TcQuery _cQuery New Alias "TMPSE1"

While !TMPSE1->(Eof())
	If TMPSE1->VALOR >= 0
		
		_nLimite	:=	TMPSE1->LIMITE
		
		If SUBSTR(TMPSE1->IDENTIF,1,2) == '01'
			_nValAtr := _nValAtr + TMPSE1->VALOR
		ElseIf SUBSTR(TMPSE1->IDENTIF,1,2) == '02'
			_nValSE1 := _nValSE1 + TMPSE1->VALOR
		ElseIf SUBSTR(TMPSE1->IDENTIF,1,2) == '03'
			_nValSC6 := _nValSC6 + TMPSE1->VALOR
		EndIf
	EndIf
	
	DbSelectArea("TMPSE1")
	DbSkip()
EndDo

If _nValAtr > 0
	_cMsg1	+= "Títulos em Atraso: R$ " +Alltrim(Transform(_nValAtr,"@E 999,999,999.99"))+_cFinLim+_cFinLim
	If FunName() $ 'TMKA271'
		_cCodMot+= "44E1|"
		
		If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
			If At("44E1|", SC5->C5_VQ_MOT)=0
				RecLock("SC5",.f.)
				SC5->C5_BLQ		:= "1"
				SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"44E1|"
				MsUnLock()
			EndIf
		EndIf
	Else
		If At("44E1|", SC5->C5_VQ_MOT)=0
			RecLock("SC5",.f.)
			SC5->C5_BLQ		:= "1"
			SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"44E1|"
			MsUnLock()
		EndIf
		
	EndIf
	_lTemMsg := .T.
	
EndIf

If (_nValSE1 + _nValSC6 + Iif(FunName()$'TMKA271',_nTotAtend,0)) > _nLimite
	_cMsg1 	+= "Valores (A + B + C) Ultrapassam o Limite de Crédito."+_cFinLim+_cFinLim
	_cMsg1 	+= "Limite de Crédito: R$ " +Alltrim(Transform(_nLimite,"@E 999,999,999.99"))+_cFinLim
	_cMsg1 	+= "(A) Atendimento em Aberto: R$ " +Alltrim(Transform(Iif(FunName()$'TMKA271',_nTotAtend,0),"@E 999,999,999.99"))+_cFinLim
	_cMsg1 	+= "(B) Pedidos em Aberto: R$ " +Alltrim(Transform(_nValSC6,"@E 999,999,999.99"))+_cFinLim
	_cMsg1 	+= "(C) Titulo em Aberto: R$ " +Alltrim(Transform(_nValSE1,"@E 999,999,999.99"))+_cFinLim
	_cMsg1 	+= "Total A + B + C: R$ " +Alltrim(Transform(Iif(FunName()$'TMKA271',_nTotAtend,0)+_nValSC6+_nValSE1,"@E 999,999,999.99"))+_cFinLim
	If FunName() $ 'TMKA271'
		_cCodMot+= "44E2|"
		
		If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
			If At("44E2|", SC5->C5_VQ_MOT)=0
				RecLock("SC5",.f.)
				SC5->C5_BLQ		:= "1"
				SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"44E2|"
				MsUnLock()
			EndIf
		EndIf
	Else
		If At("44E2|", SC5->C5_VQ_MOT)=0
			RecLock("SC5",.f.)
			SC5->C5_BLQ		:= "1"
			SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"44E2|"
			MsUnLock()
		EndIf
		
	EndIf
	_lTemMsg := .T.
	
EndIf

TMPSE1->(DbCloseArea())

If _lTemMsg
	_cMsgCrd  += _cFinLim+_cFinLim+_cMsg1+_cMsg3+_cFinLim
	_lAleMsg   := .T.
	_lOkay     := .F.
	_cMsg1 := ""
EndIf

If _lAleMsg .and. !Empty(Alltrim(_cMsgCrd)) .And. AllTrim(FunName()) <> "MATA460A"

	Define Font oFont Name "Mono AS" Size 0, 15
	Define MsDialog oDlg Title "Atenção" From 3, 0 to 440, 417 Pixel
		@ 5, 5 Get oMemo Var _cMsgCrd Memo Size 200, 195 Of oDlg Pixel
		oMemo:bRClicked := { || AllwaysTrue() }
		oMemo:oFont     := oFont
		Define SButton From 205, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
	Activate MsDialog oDlg Center
	//MsgAlert(_cMsgCrd,"Atencao!!!")
EndIf

RestArea(_aAreaVC)

Return(_lOkay)
