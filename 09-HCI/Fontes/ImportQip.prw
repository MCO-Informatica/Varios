#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPORTQIP ºAutor  ³Marcio Dias         º Data ³  21/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a importacao das especificacoes e ensaios do modulo º±±
±±º          ³QIP atraves de arquivo gerado pela HCI        			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User function IMPQIP()


If MsgYesNo("Deseja realizar a importacao das tabelas da HCI para o MP8.11? Esse processo levará alguns minutos.")
	LjMsgRun( "Aguarde...Importando Especificações","Importação HCI X MP8", { || ImpQP1() } )
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPORTQIP ºAutor  ³Microsiga           º Data ³  06/28/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpQP1()

Local _nSeq		:= 01
Local _cProduto	:= ""
Local _lDim		:= .F.

DbUseArea(.T.,,"ESPECIF1","ESPECIF1",,.F.)
DbSelectArea("ESPECIF1")
//DbCreateIndex( "ESPECIF1", "PROD+ENS", { ||PROD+ENS })
DbSetIndex( "ESPECIF1" )
DbGoTop()

DbSelectArea("QP1")
QP1->(DbSetOrder(1))	//QP1_FILIAL+QP1_ENSAIO

DbSelectArea("QP6")
QP6->(DbSetOrder(1))	//QP6_FILIAL+QP6_PRODUT+QP6_REVINV

DbSelectArea("QP7")
QP7->(DbSetOrder(3))	//QP7_FILIAL+QP7_ENSAIO+QP7_PRODUT+QP7_REVI

DbSelectArea("QP8")
QP8->(DbSetOrder(3))	//QP8_FILIAL+QP8_ENSAIO+QP8_PRODUT+QP8_REVI

DbSelectArea("SB1")
DbSetOrder(1)

WHILE !ESPECIF1->(Eof())
	If SB1->(DbSeek(xFilial("SB1")+AllTrim(ESPECIF1->PROD)))
		_cEnsaio:= Padr(AllTrim(ESPECIF1->ENS),8)
		//If ESPECIF1->TIPOBR != "MP"
		If !QP1->(DbSeek(xFilial("QP1")+_cEnsaio))
			RecLock("QP1",.T.)
			QP1->QP1_FILIAL	:= xFilial("QP1")
			QP1->QP1_ENSAIO	:= _cEnsaio
			QP1->QP1_DESCPO	:= "ENSAIO NAO ENCONTRADO"		 // QP1->QP1_DESCIN	:= _cDesEns
			QP1->QP1_DTCAD	:= Date()
			QP1->QP1_CARTA	:= "IND"
			QP1->QP1_QTDE	:= 2
			QP1->QP1_TPCART	:= "D"
			QP1->QP1_TIPO	:= "2" //'D'
			QP1->(MsUnLock())
		EndIf
		
		If !QP6->(DbSeek(xFilial("QP6")+AllTrim(ESPECIF1->PROD)))
			RecLock("QP6",.T.)
			QP6->QP6_FILIAL	:= xFilial("QP6")
			QP6->QP6_PRODUT	:= AllTrim(ESPECIF1->PROD)
			QP6->QP6_REVI  	:= "00"
			QP6->QP6_REVINV	:= Inverte("00")
			QP6->QP6_DESCPO	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF1->PROD),"B1_DESC")
			QP6->QP6_DESCIN	:= ""
			QP6->QP6_DESCES	:= ""
			QP6->QP6_TIPO	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF1->PROD),"B1_TIPO")
			QP6->QP6_DTCAD 	:= DATE()
			QP6->QP6_DTINI 	:= DATE()
			QP6->QP6_PTOLER	:= 0
			QP6->QP6_CODREC	:= '01'
			QP6->QP6_DOCOBR	:= "S"
			QP6->QP6_SITPRD	:= "C"
			QP6->QP6_DESSTP	:= "PRE-QUALIFICADO"
			QP6->QP6_TMPLIM	:= 99
			QP6->QP6_SHLF  	:= 0
			QP6->QP6_UNMED1	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF1->PROD),"B1_UM")
			QP6->QP6_UNAMO1	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF1->PROD),"B1_UM")
			QP6->QP6_SITREV	:= "0"
			QP6->(MsUnlock())
			
			RecLock("QQK",.T.)
			QQK->QQK_FILIAL		:= xFilial("QQK")
			QQK->QQK_CODIGO		:= '01'
			QQK->QQK_OPERAC		:= "10"
			QQK->QQK_PRODUTO	:= AllTrim(ESPECIF1->PROD)
			QQK->QQK_DESCRI 	:= "AUTO CONTROLE"
			QQK->QQK_TEMPAD	 	:= 1.00
			QQK->QQK_TPOPER	 	:= "1"
			QQK->QQK_OPE_OB	 	:= 'S'
			QQK->QQK_SEQ_OB	 	:= 'S'
			QQK->QQK_LAU_OBR 	:= 'S'
			QQK->QQK_RECURSO 	:= '000001'
			QQK->QQK_REVIPRD	:= "00"
			QQK->(MsUnlock())
		Endif
		If _cProduto<>AllTrim(ESPECIF1->PROD)
			_nSeq:=01
		EndIF
		//If AllTrim(ESPECIF1->CHARACT) = "X"
		If !QP7->(DbSeek(xFilial("QP7")+_cEnsaio+AllTrim(ESPECIF1->PROD)))
			IF Empty(ESPECIF1->MIN)
				_MinMax	:= "3"
			ElseIf Empty(ESPECIF1->MAX)
				_MinMax	:= "2"
			Else
				_MinMax	:= "1"
			EndIf
			Reclock("QP7",.T.)
			QP7->QP7_FILIAL	:= xFilial("QP7")
			QP7->QP7_PRODUT	:= AllTrim(ESPECIF1->PROD)
			QP7->QP7_REVI  	:= "00"
			QP7->QP7_ENSAIO	:= _cEnsaio
			QP7->QP7_LABOR 	:= "LABFIS"
			QP7->QP7_SEQLAB	:= StrZero(_nSeq,2)
			QP7->QP7_CODREC	:= '01'
			QP7->QP7_OPERAC	:= "10"
			QP7->QP7_ENSOBR	:= "S"
			QP7->QP7_CERTIF	:= 'S'
			QP7->QP7_UNIMED	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF1->PROD),"B1_UM")
			QP7->QP7_MINMAX	:= _MinMax
			If _MinMax = "3"		// CONTROLA MAXIMO
				QP7->QP7_NOMINA	:= StrTran(AllTrim(Transform(SuperVal(StrTran("0",'.',',')),"@E 999,999,999.999")),'.','')
				QP7->QP7_LSE   	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF1->MAX),'.',',')),"@E 999,999,999.999")),'.','')
				QP7->QP7_LIE	:= StrTran(AllTrim(Transform(SuperVal(StrTran("0",'.',',')),"@E 999,999,999.999")),'.','')
			ElseIf _MinMax = "2"	// CONTROLA MINIMO
				QP7->QP7_NOMINA	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF1->MIN),'.',',')),"@E 999,999,999.999")),'.','')
				QP7->QP7_LSE   	:= StrTran(AllTrim(Transform(SuperVal(StrTran("0",'.',',')),"@E 999,999,999.999")),'.','')
				QP7->QP7_LIE	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF1->MIN),'.',',')),"@E 999,999,999.999")),'.','')
			Else					// CONTROLA MINIMO E MAXIMO
				QP7->QP7_NOMINA	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(Str(((SuperVal(AllTrim(ESPECIF1->MIN))+SuperVal(AllTrim(ESPECIF1->MAX)))/2))),'.',',')),"@E 999,999,999.999")),'.','')
				QP7->QP7_LSE   	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF1->MAX),'.',',')),"@E 999,999,999.999")),'.','')
				QP7->QP7_LIE	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF1->MIN),'.',',')),"@E 999,999,999.999")),'.','')
			EndIf
			QP7->QP7_NIVEL 	:= "  "
			QP7->(MsUnLock())
			_nSeq := _nSeq+1
		EndIf
		If !QP8->(DbSeek(xFilial("QP8")+"100     "+AllTrim(ESPECIF1->PROD)))
			RecLock("QP8",.T.)
			QP8->QP8_FILIAL	:= xFilial("QP8")
			QP8->QP8_PRODUT	:= AllTrim(ESPECIF1->PROD)
			QP8->QP8_REVI  	:= "00"
			QP8->QP8_ENSAIO	:= "100     "
			QP8->QP8_LABOR 	:= "LABFIS"
			QP8->QP8_SEQLAB	:= Strzero(_nSeq,2)
			QP8->QP8_TEXTO 	:= "CONFORME ESPECIFICACAO"
			QP8->QP8_NIVEL 	:= "  "
			QP8->QP8_AM_INS	:= '2'
			QP8->QP8_CODREC	:= '01'
			QP8->QP8_OPERAC	:= "10"
			QP8->QP8_ENSOBR	:= 'S'
			QP8->QP8_CERTIF	:= 'S'
			MsUnLock()
			_nSeq := _nSeq+1
		EndIf
		If !QP8->(DbSeek(xFilial("QP8")+"101     "+AllTrim(ESPECIF1->PROD)))
			RecLock("QP8",.T.)
			QP8->QP8_FILIAL	:= xFilial("QP8")
			QP8->QP8_PRODUT	:= AllTrim(ESPECIF1->PROD)
			QP8->QP8_REVI  	:= "00"
			QP8->QP8_ENSAIO	:= "101     "
			QP8->QP8_LABOR 	:= "LABFIS"
			QP8->QP8_SEQLAB	:= Strzero(_nSeq,2)
			QP8->QP8_TEXTO 	:= "CONFORME ESPECIFICACAO"
			QP8->QP8_NIVEL 	:= "  "
			QP8->QP8_AM_INS	:= '2'
			QP8->QP8_CODREC	:= '01'
			QP8->QP8_OPERAC	:= "10"
			QP8->QP8_ENSOBR	:= 'S'
			QP8->QP8_CERTIF	:= 'S'
			QP8->(MsUnLock())
			_nSeq := _nSeq+1
		EndIf
		If !QP8->(DbSeek(xFilial("QP8")+"102     "+AllTrim(ESPECIF1->PROD)))
			RecLock("QP8",.T.)
			QP8->QP8_FILIAL	:= xFilial("QP8")
			QP8->QP8_PRODUT	:= AllTrim(ESPECIF1->PROD)
			QP8->QP8_REVI  	:= "00"
			QP8->QP8_ENSAIO	:= "102     "
			QP8->QP8_LABOR 	:= "LABFIS"
			QP8->QP8_SEQLAB	:= Strzero(_nSeq,2)
			QP8->QP8_TEXTO 	:= "CONFORME NORMA"
			QP8->QP8_NIVEL 	:= "  "
			QP8->QP8_AM_INS	:= '2'
			QP8->QP8_CODREC	:= '01'
			QP8->QP8_OPERAC	:= "10"
			QP8->QP8_ENSOBR	:= 'S'
			QP8->QP8_CERTIF	:= 'S'
			QP8->(MsUnLock())
			_nSeq := _nSeq+1
		EndIf
	EndIf
	_cProduto:=AllTrim(ESPECIF1->PROD)
	ESPECIF1->(DbSkip())
Enddo

DbSelectArea("ESPECIF1")
dbCloseArea("ESPECIF1")
Ferase("ESPECIF1"+OrdBagExt())
Return .T.