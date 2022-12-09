#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

/*/{Protheus.doc} VNDA020

Fonte criado para quando for feita uma inclusao/alteracao de combos, e como eh feita uma atualizacao 
na tabela de precos esta atualizacao deve ser passada ao HUB para o mesmo enviar as atualizacoes ao site

@author Totvs SM - Darcio Sporl
@since 10/11/2011
@version P11

/*/
User Function VNDA020(cCodTab)
	Local aArea		:= GetArea()
	Local cXml		:= ""
	Local cCodAnt	:= ""
	Local cAntGar	:= ""
	Local cCodTbA	:= ""
	Local nQtdDe	:= 0
	Local nQtdAt	:= 0
	Local cQryDA	:= ""
	Local lRet		:= .T.
	Local lPrcRen	:= DA1->(FieldPos("DA1_XPRCRE"))>0

	cQryDA := " SELECT DA0.DA0_XORITB, DA1.DA1_CODPRO, DA1.DA1_QTDLOT, DA1.DA1_PRCVEN, DA1.DA1_CODTAB, " 
	cQryDA += " DA1.DA1_CODCOB, DA1.DA1_CODGAR, MAX(DA1.R_E_C_N_O_) RECDA1, DA1.DA1_DATVIG, "
	cQryDA += " SB1.B1_DESC, SB1.B1_PRV1, SB1.B1_PESBRU, DA1.DA1_NUMPAR, DA1.DA1_TXMANU, DA1.DA1_TXPARC  "
	If lPrcRen
		cQryDA += " ,DA1_XPRCRE "
	EndIf
	cQryDA += " FROM " + RetSqlName("DA1") + " DA1 "
	cQryDA += " LEFT JOIN " + RetSqlName("DA0") + " DA0 ON DA0.DA0_FILIAL = '" + xFilial("DA0") + "' AND DA0.D_E_L_E_T_ = ' ' AND DA0.DA0_CODTAB = DA1.DA1_CODTAB "
	cQryDA += " LEFT JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '02' AND SB1.B1_COD = DA1.DA1_CODPRO AND SB1.D_E_L_E_T_ = ' ' "
	cQryDA += " WHERE DA1.DA1_FILIAL = '" + xFilial("DA1") + "' "
	cQryDA += "   AND DA1.DA1_CODTAB = '" + cCodTab + "' "
	cQryDA += "   AND DA1.DA1_ATIVO = '1' "
	cQryDA += "   AND DA1.D_E_L_E_T_ = ' ' "
	cQryDA += " GROUP BY DA0_XORITB,DA1_CODPRO, DA1_QTDLOT, DA1_PRCVEN, DA1_CODTAB, DA1_CODCOB, DA1_CODGAR, DA1.DA1_DATVIG, SB1.B1_DESC, SB1.B1_PRV1, SB1.B1_PESBRU, DA1.DA1_NUMPAR, DA1.DA1_TXMANU, DA1.DA1_TXPARC  "
	If lPrcRen
		cQryDA += " ,DA1_XPRCRE "
	EndIf
	cQryDA += " ORDER BY DA1_CODPRO, DA1_CODGAR ,DA1_CODTAB, DA1_QTDLOT "
	
	cQryDA := ChangeQuery(cQryDA)

	If Select("QRYDA") > 0
		DbSelectArea("QRYDA")
		QRYDA->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDA),"QRYDA",.F.,.T.)
	DbSelectArea("QRYDA")
 
	QRYDA->(DbGoTop())
	//If QRYDA->(!Eof())

		cXml := XML_VERSION + CRLF
		cXml += '<TabelaPrecoType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF
		cXml += '   <code>1</code>' + CRLF //1=sucesso na operação; 0=erro
		cXml += '   <msg>Solicitacao das informacoes do(s) produto(s) ok.</msg>' + CRLF
		cXml += '   <exception></exception>' + CRLF
		cXml += '	<codigo>' + cCodTab + '</codigo>' + CRLF
		cXml += '	<usuarioprotheus>' + __cUserID + '</usuarioprotheus>' + CRLF
		cXml += '	<nomeusuario>' + cUserName + '</nomeusuario>' + CRLF 
		
		While QRYDA->(!Eof())
			cCodPro := QRYDA->DA1_CODPRO
			cCodGar	:= QRYDA->DA1_CODGAR
			
			If cCodAnt <> QRYDA->DA1_CODPRO .Or. cCodGar <> cAntGar
				nQtdDe := 0
				cCodAnt:= QRYDA->DA1_CODPRO
				cAntGar:= QRYDA->DA1_CODGAR
			EndIf
			
			If QRYDA->DA1_QTDLOT == 999999.99 
				nQtdDe  := 1 
				nQtdAt	:= 999999
			Else
				nQtdDe++
				nQtdAt := IIF(QRYDA->DA1_QTDLOT >= nQtdDe,QRYDA->DA1_QTDLOT,nQtdDe++  )
			EndIf
			
			cXml += '	<item>' + CRLF
			cXml += '		<codProd>' + AllTrim(QRYDA->DA1_CODPRO) + '</codProd>' + CRLF
			cXml += '		<minimo>' + AllTrim(Transform(nQtdDe,"999999999")) + '</minimo>' + CRLF
			cXml += '		<maximo>' + AllTrim(Transform(nQtdAt,"999999999")) + '</maximo>' + CRLF
			cXml += '		<valor>' + AllTrim(Transform(QRYDA->DA1_PRCVEN,"999999.99")) + '</valor>' + CRLF
			If lPrcRen .and. QRYDA->DA1_XPRCRE > 0
				cXml += '		<valorRenovacao>' + AllTrim(Transform(QRYDA->DA1_XPRCRE,"999999.99")) + '</valorRenovacao>' + CRLF
			EndIf
			cXml += '		<origemTabela>' + AllTrim(QRYDA->DA0_XORITB) + '</origemTabela>' + CRLF
			cXml += '		<codFaixa>' + AllTrim(Str(QRYDA->RECDA1)) + '</codFaixa>' + CRLF
			cXml += '		<codProdGAR>' + AllTrim(QRYDA->DA1_CODGAR) + '</codProdGAR>' + CRLF
			cXml += '		<codCombo>' + AllTrim(QRYDA->DA1_CODCOB) + '</codCombo>' + CRLF
			If !Empty(QRYDA->DA1_DATVIG)
				cData	:= StoD(QRYDA->DA1_DATVIG)
				cAno	:= StrZero(Year(cData),4)
				cMes	:= StrZero(Month(cData),2)
				cDia	:= StrZero(Day(cData),2)
				cData	:= cDia + "/" + cMes + "/" + cAno
				cXml += '		<vigencia>' + cData + " 00:00:00"  + '</vigencia>' + CRLF
			Endif
			cXml += '		<qtdParcelas>' + AllTrim(Transform(QRYDA->DA1_NUMPAR,"99")) + '</qtdParcelas>' + CRLF
			//Renato Ruy - 10/01/2018 - Solicitante: Giovanni
			//Parametrizar na tabela de preco o valor da taxa de manutencao e prazo de pagamento
			//Projeto - Sage
			If QRYDA->DA1_TXMANU > 0
				cXml += '		<taxaManut>' + AllTrim(Transform(QRYDA->DA1_TXMANU,"@9999.99")) + '</taxaManut>' + CRLF
				cXml += '		<prazoManut>' + AllTrim(Transform(QRYDA->DA1_TXPARC,"99")) + '</prazoManut>' + CRLF
			Endif
			cXml += '	</item>' + CRLF
	
			nQtdDe 	:= nQtdAt
			
			QRYDA->(DbSkip())
			
		Enddo
		cXml += '</TabelaPrecoType>' + CRLF
	
		MsAguarde({|| lRet := U_VNDA030(cXml,cCodTab)},"Comunicando com o HUB")
	
		DbSelectArea("QRYDA")
		QRYDA->(DbCloseArea())
	//EndIf

	RestArea(aArea)
Return(lRet)