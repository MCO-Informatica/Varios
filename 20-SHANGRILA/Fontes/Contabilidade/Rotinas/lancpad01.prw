#include "rwmake.ch"

/*
|---------------------------------------------------------------------------------------------------|
|   Programa  | lancpad01  | Autor | Andre da Silva Rodrigues                      | Data |09/11/05 |
|---------------------------------------------------------------------------------------------------|
|  Descrição  | Apresenta lancamentos contabeis do Faturamento da Zona franca  de Manaus referente  |
|             | Pis Cofins                                                                                    |
|---------------------------------------------------------------------------------------------------|
|---------------------------------------------------------------------------------------------------|
*/

//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LANCAMENTO PADRAO D0 FATURAMENTO 610-005 COFINS         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//

User Function FAT01001()
LOCAL _nRetorno
LOCAL _aArea

_aArea :=GetArea( _aArea)
_nRetorno := 0
_cEst:= alltrim(SF2->F2_EST)

// IF _cEst <> "AM"
if ALLTRIM(SD2->D2_CF)$"5101/6101/5401/5403/6401/6403/5102/6102/5107/6107/5108/6108/6118" .AND. SD2->D2_SERIE$"NFE"
	_nRetorno := (SD2->D2_TOTAL+SD2->D2_VALIPI+SD2->D2_DESPESA+SD2->D2_VALFRE+SD2->D2_ICMSRET) *0.03
endif
// ENDIF
RestArea(_aArea)
Return(_nRetorno)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LANCAMENTO PADRAO D0 FATURAMENTO 610-005 PIS            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//

User Function FAT01002()
LOCAL _nRetorno
LOCAL _aArea

_aArea :=GetArea( _aArea)
_nRetorno := 0
_cEst:= alltrim(SF2->F2_EST)

// IF _cEst <> "AM"
if ALLTRIM(SD2->D2_CF)$"5101/6101/5401/5403/6401/6403/5102/6102/5107/6107/5108/6108/6118" .AND. SD2->D2_SERIE$"NFE"
	_nRetorno := (SD2->D2_TOTAL+SD2->D2_VALIPI+SD2->D2_DESPESA+SD2->D2_VALFRE+SD2->D2_ICMSRET) *0.0065
endif
// ENDIF
RestArea(_aArea)
Return(_nRetorno)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LANCAMENTO PADRAO D0 FATURAMENTO 610-001 VENDA NORMAL    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
/*
User Function FAT01003()
LOCAL _nRetorno
LOCAL _aArea

_aArea :=GetArea( _aArea)
_nRetorno := 0

IF ALLTRIM(SD2->D2_CF)$"5101/6101/5401/5403/6401/6403/5102/6102/5107/6107/5108/6108/6109/6110/6118"
	if SD2->D2_SERIE$"NFE"
		_nRetorno  := SD2->(D2_TOTAL+D2_VALIPI+D2_DESPESA+D2_VALFRE+D2_ICMSRET)
else
	  	_nRetorno := SD2->(D2_TOTAL+D2_VALFRE)
	endif
ENDIF
RestArea(_aArea)

Return(_nRetorno)

*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LANCAMENTO PADRAO D0 FATURAMENTO 640-001 DEVOLUCAO VENDA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
/*
User Function FAT01004()
LOCAL _nRetorno
LOCAL _aArea

_aArea :=GetArea( _aArea)
_nRetorno := 0


IF ALLTRIM(SD1->D1_CF)$"1201/1202/2201/2202/1410/2410/1411/1412/2411/2412/"
	if SD1->D1_SERIE$"NFE"
		_nRetorno  := SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_DESPESA+SD1->D1_VALFRE+SD1->D1_ICMSRET
	else
		_nRetorno := SD1->(D1_TOTAL+D1_VALFRE)
	endif
ENDIF
RestArea(_aArea)
Return(_nRetorno)

*/

//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LANCAMENTO PADRAO D0 COMPRAS 650-004 FORNECEDOR         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//

User Function COM01001()

LOCAL _nRetorno	:=	0
LOCAL _aArea 	:=	GetArea()

IF ALLTRIM(SD1->D1_CF)$"1101/2101/3101/1102/2102/3102/1653/2653/1401/2401" .AND. !SD1->D1_TES$"033/034"
	_nRetorno := (SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_DESPESA + SD1->D1_SEGURO + SD1->D1_VALFRE) - IIF(ALLTRIM(SD1->D1_CF)$"3101/3102",0+SD1->D1_VALIPI,SD1->D1_VALICM+SD1->D1_VALIPI)
EndIf

RestArea(_aArea)

Return(_nRetorno)


//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LANCAMENTO PADRAO D0 COMPRAS 650-001 COMPRAS/AMOSTRA    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//

User Function COM01002()

LOCAL _nRetorno	:=	0
LOCAL _aArea 	:=	GetArea()

IF ALLTRIM(SD1->D1_CF)$"1101/2101/3101/1102/2102/3102/1653/2653/1401/2401" .AND. !SD1->D1_TES$"033/034"
	_nRetorno := SD1->D1_TOTAL + (SD1->D1_VALIPI + SD1->D1_DESPESA + SD1->D1_VALFRE + IIF(ALLTRIM(SD1->D1_CF)$"3101/3102",SD1->D1_VALICM,0))
EndIf

RestArea(_aArea)

Return(_nRetorno)



User Function FIN01001()	//CONTA DEBITO

Local _nRetorno := 0
Local _aArea	:=	GetArea()

//----> VERIFICA SE O TITULO FOI ORIGINADO PELA FOLHA DE PAGAMENTO
If SUBS(SE2->E2_ORIGEM,1,3)$"GPE"
	dbSelectArea("RC1")
	dbSetOrder(3)
	If dbSeek(xFilial("RC1")+Space(6)+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA,.F.)
		dbSelectArea("SED")
		dbSetOrder(1)
		If dbSeek(xFilial("SED")+Posicione("RC0",1,xFilial("RC0")+RC1->RC1_CODTIT,"RC0_NATURE"),.F.)
			_nRetorno	:=	Iif(!Empty(SED->ED_DEBITO),SED->ED_DEBITO,"212010001")
		Else
			_nRetorno	:=	"212010001"
		EndIf
	Else
		_nRetorno	:=	"212010001"
	EndIf
Else
	_nRetorno	:=	SA2->A2_CONTA
EndIf

RestArea(_aArea)

Return(_nRetorno)



User Function FIN01002()	//HISTORICO

Local _nRetorno := SUBS("PAGTO "+ALLTRIM(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA)+" - "+ALLTRIM(SE2->E2_NOMFOR),1,40)
Local _aArea	:=	GetArea()

//----> VERIFICA SE O TITULO FOI ORIGINADO PELA FOLHA DE PAGAMENTO
If SUBS(SE2->E2_ORIGEM,1,3)$"GPE"
	dbSelectArea("RC1")
	dbSetOrder(3)
	If dbSeek(xFilial("RC1")+Space(6)+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA,.F.)
		_nRetorno	:=	"PAGTO " + SUBS(ALLTRIM(RC1->RC1_DESCRI)+" "+ALLTRIM(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA),1,40)
	Else
		_nRetorno	:=	SUBS("PAGTO "+ALLTRIM(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA)+" - "+ALLTRIM(SE2->E2_NOMFOR),1,40)
	EndIf
Else
	_nRetorno	:=	SUBS("PAGTO "+ALLTRIM(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA)+" - "+ALLTRIM(SE2->E2_NOMFOR),1,40)
EndIf

RestArea(_aArea)

Return(_nRetorno)                               


/*User Function FIN59004()	//TESTE ROGERIO
dbSelectArea("SA6")
//----> VERIFICA SE O TITULO FOI ORIGINADO PELA FOLHA DE PAGAMENTO
If SE5->E5_DATA==SE5->E5_DTDISPO
	dbSelectArea("SA6")
	dbSetOrder(1)
	If dbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA,.F.)
			_nRetorno	:=	SA6->A6_CONTA
	Else
			_nRetorno	:=	SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
	EndIf
	
Else
	_nRetorno	:=	"211010002"
EndIf

RestArea(_aArea)

Return(_nRetorno) */