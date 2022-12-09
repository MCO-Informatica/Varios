#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA080TIT º Autor ³ A.Carlos           º Data ³  26/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Confirmacao da baixa manual a pagar antes da gravacao dos  º±±
±±º          ³ dados                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA080TIT()
Local aArea     := GetArea()
Local aAreaSE2  := SE2->(GetArea())
Local aAreaCNX  := CNX->(GetArea())
Local aAreaCN9  := CN9->(GetArea())
Local _lRet     := .T.
Local _cContr   := SE2->E2_MDCONTR 	//Numero Contrato
Local _cRevisa	:= SE2->E2_MDREVIS	//Numero da revisao
Local _nSaldTit := SE2->E2_SALDO 	//Saldo do titulo
Local nVlrContra:= 0
Local nVlrPAs	:= 0
Local nTotParc	:= SE2->E2_VALOR-SE2->E2_SALDO
Local cTxtAdi	:= ""
Local _TipoTit  := SE2->E2_TIPO



If !Empty(_cContr) .AND. !ALLTRIM(_TipoTit)=='PA' 	//Titulo original de contrato (SIGAGCT) e não for baixa de PA
	dbSelectArea("CN9")
	dbSetOrder(1)	//CN9_FILIAL+CN9_NUMERO+CN9_REVISA
	If dbSeek(xFilial("CN9")+ _cContr + _cRevisa )
		//		nVlrContra	:= CN9->CN9_VLATU + CN9->CN9_VLADIT
		nVlrContra	:= CN9->CN9_VLATU
		nVlrPAs 	:= TotalPAs( _cContr )
		If nVlrPAs > 0 //Só continua se existir somatória de adiantamentos para o contrato.
			IF ( nValPgto > (nVlrContra - nVlrPAs) ) .Or. ( nTotParc == (nVlrContra - nVlrPAs) )
				If ( nTotParc == (nVlrContra - nVlrPAs) )
					cTxtAdi	:= "Favor compensar o valor de R$ " + Transform(SE2->E2_SALDO,"@e 999,999,999,999.99")+"."
				Else
					cTxtAdi	:= ""
				EndIf
				Aviso("Atenção", "Este tiulo não pode ser baixado, pois o saldo do titulo mais os adiantamentos vinculados ao contrato "+_cContr+" é maior que o valor do contrato!!! " +CRLF+"Valor de baixa permitido R$ "+Transform((nVlrContra - nVlrPAs),"@e 999,999,999,999.99")+"." +CRLF+cTxtAdi, {"Ok"})
				_lRet := .F.
			EndIf
		Endif
	EndIf
EndIf

RestArea(aAreaCN9)
RestArea(aAreaCNX)
RestArea(aAreaSE2)
RestArea(aArea)
Return _lRet


Static Function TotalPAs( cContrato )
Local aAreaAtu	:= GetArea()
Local cAliasQry	:= GetNextAlias()
Local nSoma		:= 0

cQuery := "SELECT E2_VALOR "
cQuery += "FROM "+RetSqlName("SE2")
cQuery += " WHERE E2_FILIAL  = '"+xFilial("SE2")+"'"
cQuery += "   AND E2_MDCONTR = '"+cContrato+"' AND E2_TIPO = 'PA '"
cQuery += "   AND D_E_L_E_T_  = ' ' "
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. )
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())

While (cAliasQry)->(!Eof())
	nSoma += (cAliasQry)->E2_VALOR
	(cAliasQry)->(DbSkip())
EndDo

(cAliasQry)->(DbCloseArea())

RestArea( aAreaAtu )
Return(nSoma)       
