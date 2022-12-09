#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPQIE    ºAutor  ³Marcio Dias         º Data ³  28/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a importacao das especificacoes e ensaios do modulo º±±
±±º          ³QIE atraves de arquivo gerado pela HCI		 			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function ImpQIE()
Private _cEnsaio	:= ""
Private _cDesEns	:= ""

If MsgYesNo("Deseja realizar a importacao das tabelas HCI para o MP8.11? Esse processo levará alguns minutos.")
  	LjMsgRun( "Aguarde...Importando Especificações","Importação HCI X MP8", { || ImpQE1() } )
EndIf

If MsgYesNo("Deseja realizar a importacao das 12 regras HCI para o MP8.11? Esse processo levará alguns minutos.")
	LjMsgRun( "Aguarde...Importando Dados relativos as 12 Regras","Importação HCI X MP8", { || ImpQE2() } )
EndIf

If MsgYesNo("Deseja realizar a importacao do tratamento térmico HCI para o MP8.11? Esse processo levará alguns minutos.")
	LjMsgRun( "Aguarde...Importando Dados relativos ao tratamento térmico","Importação HCI X MP8", { || ImpQE3() } )
EndIf

If MsgYesNo("Deseja realizar a importacao do Material de Partida HCI para o MP8.11? Esse processo levará alguns minutos.")
	LjMsgRun( "Aguarde...Importando Dados relativos ao Material de Partida","Importação HCI X MP8", { || ImpQE4() } )
EndIf

If MsgYesNo("Deseja realizar a importacao do Corpo de Prova HCI para o MP8.11? Esse processo levará alguns minutos.")
	LjMsgRun( "Aguarde...Importando Dados relativos ao Corpo de Prova","Importação HCI X MP8", { || ImpQE5() } )
EndIf


Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPQE1    ºAutor  ³Marcio Dias         º Data ³  28/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a importacao das especificacoes e ensaios do modulo º±±
±±º          ³QIE atraves de arquivo gerado pela HCI        			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpQE1()

Local _nSeq		:= 01
Local _cProduto	:= ""
Local _cLab		:= ""
Local _lDim		:= .F.

DbUseArea(.T.,,"ESPECIF","ESPECIF",.F.,.F.)
DbSelectArea("ESPECIF")
DbCreateIndex("ESPECIF", "PROD+ENS+LAB", { || PROD+ENS+LAB },if( .F., .T., NIL ) )
DbSetIndex("ESPECIF")
DbGoTop()

DbSelectArea("QE1")
QE1->(DbSetOrder(1))	//QP1_FILIAL+QP1_ENSAIO
DbSelectArea("QE6")
QE6->(DbSetOrder(1))	//QP6_FILIAL+QP6_PRODUT+QP6_REVINV
DbSelectArea("QE7")
QE7->(DbSetOrder(3))	//QP7_FILIAL+QP7_ENSAIO+QP7_PRODUT+QP7_REVI
DbSelectArea("QE8")
QE8->(DbSetOrder(3))	//QP8_FILIAL+QP8_ENSAIO+QP8_PRODUT+QP8_REVI
DbSelectArea("SB1")
SB1->(DbSetOrder(1))	//B1_FILIAL+B1_COD

WHILE !ESPECIF->(Eof())
	If SB1->(DbSeek(xFilial("SB1")+ESPECIF->PROD))
		_cEnsaio:= Padr(AllTrim(ESPECIF->ENS),8)

		If !QE1->(DbSeek(xFilial("QE1")+_cEnsaio))
			RecLock("QE1",.T.)
			QE1->QE1_FILIAL	:= xFilial("QE1")
			QE1->QE1_ENSAIO	:= _cEnsaio
			QE1->QE1_DESCPO	:= "ENSAIO NAO ENCONTRADO"
			QE1->QE1_DTCAD	:= Date()
			QE1->QE1_CARTA	:= "IND"
			QE1->QE1_QTDE	:= 2
			QE1->QE1_TIPO	:= "2"
			MsUnLock()
		EndIf
		If !QE6->(DbSeek(xFilial("QE6")+AllTrim(ESPECIF->PROD)))
			RecLock("QE6",.T.)
			QE6->QE6_FILIAL	:= xFilial("QE6")
			QE6->QE6_PRODUT	:= AllTrim(ESPECIF->PROD)
			QE6->QE6_REVI  	:= "00"
			QE6->QE6_REVINV	:= Inverte("00")
			QE6->QE6_DESCPO	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF->PROD),"B1_DESC")
			QE6->QE6_DESCIN	:= ""
			QE6->QE6_DESCES	:= ""
			QE6->QE6_TIPO	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF->PROD),"B1_TIPO")
			QE6->QE6_DTCAD 	:= DATE()
			QE6->QE6_DTINI 	:= DATE()
			QE6->QE6_PTOLER	:= 0
			QE6->QE6_DOCOBR	:= "S"
			QE6->QE6_SHLF  	:= 0
			QE6->QE6_UNMED1	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF->PROD),"B1_UM")
			QE6->QE6_UNAMO1	:= Posicione("SB1",1,xFilial("SB1")+AllTrim(ESPECIF->PROD),"B1_UM")
			QE6->QE6_SITREV	:= "0"
			MsUnlock()
		Endif
		If _cProduto<>AllTrim(ESPECIF->PROD) .or. _cLab<>AllTrim(ESPECIF->LAB)
			_nSeq:=01
		EndIF
		//If AllTrim(ESPECIF->CHARACT) = "X"
		If !QE7->(DbSeek(xFilial("QE7")+_cEnsaio+AllTrim(ESPECIF->PROD)))
			Reclock("QE7",.T.)
			QE7->QE7_FILIAL	:= xFilial("QE7")
			QE7->QE7_PRODUT	:= AllTrim(ESPECIF->PROD)
			QE7->QE7_REVI  	:= "00"
			QE7->QE7_ENSAIO	:= _cEnsaio
			QE7->QE7_ENSDES	:= "2"
			QE7->QE7_LABOR 	:= AllTrim(ESPECIF->LAB)
			QE7->QE7_SEQLAB	:= StrZero(_nSeq,2)
			QE7->QE7_UNIMED	:= AllTrim(ESPECIF->UNID)
			IF Empty(ESPECIF->MIN)
				_MinMax	:= "3"
			ElseIf Empty(ESPECIF->MAX)
				_MinMax	:= "2"
			Else
				_MinMax	:= "1"
			EndIf
			QE7->QE7_MINMAX	:= _MinMax
			If _MinMax = "3"		// CONTROLA MAXIMO
				QE7->QE7_NOMINA	:= StrTran(AllTrim(Transform(SuperVal(StrTran("0",'.',',')),"@E 999,999,999.999")),'.','')
				QE7->QE7_LSE   	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF->MAX),'.',',')),"@E 999,999,999.999")),'.','')
				QE7->QE7_LIE	:= StrTran(AllTrim(Transform(SuperVal(StrTran("0",'.',',')),"@E 999,999,999.999")),'.','')
			ElseIf _MinMax = "2"	// CONTROLA MINIMO
				QE7->QE7_NOMINA	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF->MIN),'.',',')),"@E 999,999,999.999")),'.','')
				QE7->QE7_LSE   	:= StrTran(AllTrim(Transform(SuperVal(StrTran("0",'.',',')),"@E 999,999,999.999")),'.','')
				QE7->QE7_LIE	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF->MIN),'.',',')),"@E 999,999,999.999")),'.','')
			Else					// CONTROLA MINIMO E MAXIMO
				QE7->QE7_NOMINA	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(Str(((SuperVal(AllTrim(ESPECIF->MIN))+SuperVal(AllTrim(ESPECIF->MAX)))/2))),'.',',')),"@E 999,999,999.999")),'.','')
				QE7->QE7_LSE   	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF->MAX),'.',',')),"@E 999,999,999.999")),'.','')
				QE7->QE7_LIE	:= StrTran(AllTrim(Transform(SuperVal(StrTran(AllTrim(ESPECIF->MIN),'.',',')),"@E 999,999,999.999")),'.','')
			EndIf
			QE7->QE7_NIVEL 	:= "  "
			QE7->QE7_AM_INS	:= "2" 
			MsUnLock()
			_nSeq := _nSeq+1
		EndIf
		If !QE8->(DbSeek(xFilial("QE8")+"100     "+AllTrim(ESPECIF->PROD)))
			RecLock("QE8",.T.)
			QE8->QE8_FILIAL	:= xFilial("QE8")
			QE8->QE8_PRODUT	:= AllTrim(ESPECIF->PROD)
			QE8->QE8_REVI  	:= "00"
			QE8->QE8_ENSAIO	:= "100     " 
			QE8->QE8_ENSDES	:= "2"
			QE8->QE8_LABOR 	:= "LABFIS"
			QE8->QE8_SEQLAB	:= "01"
			QE8->QE8_TEXTO 	:= "CONFORME ESPECIFICACAO" //UPPER(ANSITOOEM((AllTrim(ESPECIF->SHORTC_P))))
			QE8->QE8_NIVEL 	:= "  "
			QE8->QE8_AM_INS	:= "2" //If(ESPECIF->RA="0","1","2")
			MsUnLock()
		EndIf
		If !QE8->(DbSeek(xFilial("QE8")+"101     "+AllTrim(ESPECIF->PROD)))
			RecLock("QE8",.T.)
			QE8->QE8_FILIAL	:= xFilial("QE8")
			QE8->QE8_PRODUT	:= AllTrim(ESPECIF->PROD)
			QE8->QE8_REVI  	:= "00"
			QE8->QE8_ENSAIO	:= "101     "
			QE8->QE8_ENSDES	:= "2"
			QE8->QE8_LABOR 	:= "LABFIS"
			QE8->QE8_SEQLAB	:= "02"
			QE8->QE8_TEXTO 	:= "CONFORME ESPECIFICACAO" //UPPER(ANSITOOEM((AllTrim(ESPECIF->SHORTC_P))))
			QE8->QE8_NIVEL 	:= "  "
			QE8->QE8_AM_INS	:= "2" //If(ESPECIF->RA="0","1","2")
			MsUnLock()
		EndIf
		If !QE8->(DbSeek(xFilial("QE8")+"102     "+AllTrim(ESPECIF->PROD)))
			RecLock("QE8",.T.)
			QE8->QE8_FILIAL	:= xFilial("QE8")
			QE8->QE8_PRODUT	:= AllTrim(ESPECIF->PROD)
			QE8->QE8_REVI  	:= "00"
			QE8->QE8_ENSAIO	:= "102     "
			QE8->QE8_ENSDES	:= "2"
			QE8->QE8_LABOR 	:= "LABFIS"
			QE8->QE8_SEQLAB	:= "03"
			QE8->QE8_TEXTO 	:= "CONFORME NORMA" //UPPER(ANSITOOEM((AllTrim(ESPECIF->SHORTC_P))))
			QE8->QE8_NIVEL 	:= "  "
			QE8->QE8_AM_INS	:= "2" //If(ESPECIF->RA="0","1","2")
			MsUnLock()
		EndIf
		_cProduto:= AllTrim(ESPECIF->PROD)
		_cLab	 := AllTrim(ESPECIF->LAB)
	EndIf
	ESPECIF->(DbSkip())
Enddo

DbSelectArea("ESPECIF")
dbCloseArea("ESPECIF")

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPQIE2   ºAutor  ³Cayo Souza          º Data ³  01/18/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa dados relativos as 12 Regras                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpQe2()

DbUseArea(.T.,,"LISTA3","LISTA3",.F.,.F.)
DbSelectArea("LISTA3")
DbCreateIndex("LISTA3", "B1_COD", { || B1_COD },if( .F., .T., NIL ) )
DbSetIndex("LISTA3")
DbGoTop()

DbSelectArea("QE6")
DbSetOrder(1)
DbGoTop()

While !QE6->(Eof())
	If LISTA3->(DbSeek(QE6->QE6_PRODUT))
		While !LISTA3->(Eof()) .and. (LISTA3->B1_COD == QE6->QE6_PRODUT)
			//Verifica tratativa da Regra 01
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "REDUCAO" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG01	:= "S"
				QE6->(MsUnlock())
			EndIf
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "MGNORMAX" .and. !Empty(UPPER(ALLTRIM(LISTA3->MIN)))
				Reclock("QE6",.F.)
				QE6->QE6_XVLR01	:= SuperVal(StrTran(AllTrim(LISTA3->MIN),'.',',')) 
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 02
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CUNICRMO" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG02	:= "S"
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 03
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CRMO" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG03	:= "S"
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 04
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CE" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG04	:= "S"
				QE6->(MsUnlock())
			EndIf
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CENORMAX" .and. !Empty(UPPER(ALLTRIM(LISTA3->MIN)))
				Reclock("QE6",.F.)
				QE6->QE6_XVLR04	:= SuperVal(StrTran(AllTrim(LISTA3->MIN),'.',',')) 
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 05
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CUNICRVNO" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG05	:= "S"
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 06
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "MPCHAPA" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG06	:= "S"
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 07
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "MPBARRA" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG07	:= "S"
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 08
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "MPBRMG" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG08	:= "S"
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 09
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CPCI" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG09	:= "S"
				QE6->(MsUnlock())
			EndIf
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "ALOMIN" .and. !Empty(UPPER(ALLTRIM(LISTA3->MIN)))
				Reclock("QE6",.F.)
				QE6->QE6_XVLR09	:= SuperVal(StrTran(AllTrim(LISTA3->MIN),'.',','))  
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 10
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CPTR" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG09	:= "S"
				QE6->(MsUnlock())
			EndIf
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "ALOMIN2" .and. !Empty(UPPER(ALLTRIM(LISTA3->MIN)))
				Reclock("QE6",.F.)
				QE6->QE6_XVLR09	:= SuperVal(StrTran(AllTrim(LISTA3->MIN),'.',',')) 
				QE6->(MsUnlock())
			EndIf
			//Verifica tratativa da Regra 11
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CPRT" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG09	:= "S"
				QE6->(MsUnlock())
			EndIf
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "ALOMIN4" .and. !Empty(UPPER(ALLTRIM(LISTA3->MIN)))
				Reclock("QE6",.F.)
				QE6->QE6_XVLR09	:= SuperVal(StrTran(AllTrim(LISTA3->MIN),'.',',')) 
				QE6->(MsUnlock())
			EndIf			
			//Verifica tratativa da Regra 12
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "CPRL" .and. UPPER(ALLTRIM(LISTA3->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XREG09	:= "S"
				QE6->(MsUnlock())
			EndIf
			If UPPER(AllTRIM(LISTA3->ENSAIO)) == "ALOMIN3" .and. !Empty(UPPER(ALLTRIM(LISTA3->MIN)))
				Reclock("QE6",.F.)
				QE6->QE6_XVLR09	:= SuperVal(StrTran(AllTrim(LISTA3->MIN),'.',',')) 
				QE6->(MsUnlock())
			EndIf
        LISTA3->(DbSkip())
        EndDo
	EndIf
	QE6->(DbSkip())
EndDo

Return .t.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPQE3    ºAutor  ³Cayo Souza          º Data ³  01/18/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa dados relativos ao tratamento termico               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpQE3()

DbUseArea(.T.,,"LISTA4","LISTA4",.F.,.F.)
DbSelectArea("LISTA4")
DbCreateIndex("LISTA4", "B1_COD", { || B1_COD },if( .F., .T., NIL ) )
DbSetIndex("LISTA4")
DbGoTop()

DbSelectArea("QE6")
DbSetOrder(1)
DbGoTop()

While !QE6->(Eof())
	If LISTA4->(DbSeek(QE6->QE6_PRODUT))
		While !LISTA4->(Eof()) .and. (LISTA4->B1_COD == QE6->QE6_PRODUT)

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_ST" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT01	:= "S"
				QE6->(MsUnlock())
			EndIf
			
			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_NO" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT02	:= "S"
				QE6->(MsUnlock())
			EndIf
	
			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_RE" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT03	:= "S"
				QE6->(MsUnlock())
			EndIf
			
			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_TR" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT04	:= "S"
				QE6->(MsUnlock())
			EndIf

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_NT" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT05	:= "S"
				QE6->(MsUnlock())
			EndIf			

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_SO" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT06	:= "S"
				QE6->(MsUnlock())
			EndIf			

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_AT" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT07	:= "S"
				QE6->(MsUnlock())
			EndIf			

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_RV" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT08	:= "S"
				QE6->(MsUnlock())
			EndIf			

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_RI" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT09	:= "S"
				QE6->(MsUnlock())
			EndIf			

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_NR" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT10	:= "S"
				QE6->(MsUnlock())
			EndIf			

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_ED" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT11	:= "S"
				QE6->(MsUnlock())
			EndIf

			If UPPER(AllTRIM(LISTA4->ENSAIO)) == "TT_TBRANCO" .and. UPPER(ALLTRIM(LISTA4->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XTT12	:= "S"
				QE6->(MsUnlock())
			EndIf						
        LISTA4->(DbSkip())
        EndDo
	EndIf
	QE6->(DbSkip())
EndDo

Return .t.
			
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPQE4    ºAutor  ³Cayo Souza          º Data ³  01/18/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa dados relativos ao material de partida.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpQE4()

DbUseArea(.T.,,"LISTA5","LISTA5",.F.,.F.)
DbSelectArea("LISTA5")
DbCreateIndex("LISTA5", "B1_COD", { || B1_COD },if( .F., .T., NIL ) )
DbSetIndex("LISTA5")
DbGoTop()

DbSelectArea("QE6")
DbSetOrder(1)
DbGoTop()

While !QE6->(Eof())
	If LISTA5->(DbSeek(QE6->QE6_PRODUT))
		While !LISTA5->(Eof()) .and. (LISTA5->B1_COD == QE6->QE6_PRODUT)

			If UPPER(AllTRIM(LISTA5->ENSAIO)) == "MP_BARRA" .and. UPPER(ALLTRIM(LISTA5->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XMP01	:= "S"
				QE6->(MsUnlock())
			EndIf
	
			If UPPER(AllTRIM(LISTA5->ENSAIO)) == "MP_CHAPA" .and. UPPER(ALLTRIM(LISTA5->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XMP02	:= "S"
				QE6->(MsUnlock())
			EndIf
			
			If UPPER(AllTRIM(LISTA5->ENSAIO)) == "MP_TUBO" .and. UPPER(ALLTRIM(LISTA5->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XMP03	:= "S"
				QE6->(MsUnlock())
			EndIf			

			If UPPER(AllTRIM(LISTA5->ENSAIO)) == "MP_TUBOCS" .and. UPPER(ALLTRIM(LISTA5->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XMP04	:= "S"
				QE6->(MsUnlock())
			EndIf			
			
			If UPPER(AllTRIM(LISTA5->ENSAIO)) == "MP_TUBOCCC" .and. UPPER(ALLTRIM(LISTA5->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XMP05	:= "S"
				QE6->(MsUnlock())
			EndIf
			
			If UPPER(AllTRIM(LISTA5->ENSAIO)) == "MP_TUBOCCS" .and. UPPER(ALLTRIM(LISTA5->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XMP06	:= "S"
				QE6->(MsUnlock())
			EndIf
			
			If UPPER(AllTRIM(LISTA5->ENSAIO)) == "MP_MPBRANCO" .and. UPPER(ALLTRIM(LISTA5->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XMP07	:= "S"
				QE6->(MsUnlock())
			EndIf
		LISTA5->(DbSkip())
        EndDo
	EndIf
	QE6->(DbSkip())
EndDo

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPQE5    ºAutor  ³Cayo Souza          º Data ³  01/18/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa dados relativos ao material de partida.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpQE5()

DbUseArea(.T.,,"LISTA6","LISTA6",.F.,.F.)
DbSelectArea("LISTA6")
DbCreateIndex("LISTA6", "B1_COD", { || B1_COD },if( .F., .T., NIL ) )
DbSetIndex("LISTA6")
DbGoTop()

DbSelectArea("QE6")
DbSetOrder(1)
DbGoTop()

While !QE6->(Eof())
	If LISTA6->(DbSeek(QE6->QE6_PRODUT))
		While !LISTA6->(Eof()) .and. (LISTA6->B1_COD == QE6->QE6_PRODUT)

			If UPPER(AllTRIM(LISTA6->ENSAIO)) == "TI_TCP_CIRCULAR" .and. UPPER(ALLTRIM(LISTA6->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XCP01	:= "S"
				QE6->(MsUnlock())
			EndIf

			If UPPER(AllTRIM(LISTA6->ENSAIO)) == "TI_TCP_RETANGULAR" .and. UPPER(ALLTRIM(LISTA6->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XCP02	:= "S"
				QE6->(MsUnlock())
			EndIf			
			
			If UPPER(AllTRIM(LISTA6->ENSAIO)) == "TI_SCP_CORPOPA" .and. UPPER(ALLTRIM(LISTA6->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XCP03	:= "S"
				QE6->(MsUnlock())
			EndIf

			If UPPER(AllTRIM(LISTA6->ENSAIO)) == "TI_SCP_CORPOPL" .and. UPPER(ALLTRIM(LISTA6->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XCP04	:= "S"
				QE6->(MsUnlock())
			EndIf			
						
			If UPPER(AllTRIM(LISTA6->ENSAIO)) == "TI_SCP_CORPOPR" .and. UPPER(ALLTRIM(LISTA6->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XCP05	:= "S"
				QE6->(MsUnlock())
			EndIf
			
			If UPPER(AllTRIM(LISTA6->ENSAIO)) == "TI_SCP_CORPOPT" .and. UPPER(ALLTRIM(LISTA6->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XCP06	:= "S"
				QE6->(MsUnlock())
			EndIf			

			If UPPER(AllTRIM(LISTA6->ENSAIO)) == "TI_CORPOBRANCO" .and. UPPER(ALLTRIM(LISTA6->MIN)) = "SIM"
				Reclock("QE6",.F.)
				QE6->QE6_XCP07	:= "S"
				QE6->(MsUnlock())
			EndIf			
		LISTA6->(DbSkip())
        EndDo
	EndIf
	QE6->(DbSkip())
EndDo

Return .t.			