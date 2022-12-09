#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESPVEND  ºAutor  ³Leandro Duarte      º Data ³  03/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de rateio de contas para a geracao de titulos a pagarº±±
±±º          ³para o reembolso de despesas de vendedores                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11 e p12                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DespVend(cDesp)
	Local cQuery	:= ""
	Local nValor	:= 0

	cQuery += " SELECT B.AD6_CODPRO, SUM(B.AD6_TOTAL) AS TOTAL "+CRLF
	cQuery += "   FROM "+retsqlname("SE2")+" A, "+retsqlname("AD6")+" B "+CRLF
	cQuery += "  WHERE A.E2_EMISSAO = '"+DTOS(SE2->E2_EMISSAO)+"' "+CRLF
	cQuery += "    AND A.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "    AND A.E2_FILIAL = '"+XFILIAL("SE2")+"' "+CRLF
	cQuery += "    AND A.E2_PREFIXO = '"+SE2->E2_PREFIXO+"' "+CRLF
	cQuery += "    AND A.E2_NUM = '"+SE2->E2_NUM+"' "+CRLF
	cQuery += "    AND A.E2_PARCELA = '"+SE2->E2_PARCELA+"' "+CRLF
	cQuery += "    AND A.E2_TIPO = '"+SE2->E2_TIPO+"' "+CRLF
	cQuery += "    AND B.AD6_FILIAL = '"+XFILIAL("AD6")+"' "+CRLF
	cQuery += "    AND B.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "    AND B.AD6_PREFIX = A.E2_PREFIXO "+CRLF
	cQuery += "    AND B.AD6_NUMERO = A.E2_NUM "+CRLF
	cQuery += "    AND B.AD6_PARCEL = A.E2_PARCELA "+CRLF
	cQuery += "    AND B.AD6_TIPO = A.E2_TIPO "+CRLF
	cQuery += "    AND B.AD6_CODFOR = A.E2_FORNECE "+CRLF
	cQuery += "    AND B.AD6_LOJFOR = A.E2_LOJA "+CRLF
	cQuery += "    AND B.AD6_CODPRO = '"+cDesp+"' "+CRLF
	cQuery += " GROUP BY B.AD6_CODPRO "+CRLF
	cQuery := ChangeQuery(cQuery) 
	iIf(Select("TRBSE2") > 0,TRBSE2->(DbCloseArea()),NIL)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSE2",.T.,.T.)
	if TRBSE2->(!eof())
		nValor := TRBSE2->TOTAL
	endif
return(nValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCVend    ºAutor  ³Leandro Duarte      º Data ³  03/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ funcao para buscar o centro de custo do vendedor para apre º±±
±±º          ³sentar nos lancamento padrao                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CCVend()
	Local xCC	:= ""

	cQuery := " SELECT DISTINCT B.AD6_VEND "+CRLF
	cQuery += "   FROM "+retsqlname("SE2")+" A, "+retsqlname("AD6")+" B "+CRLF
	cQuery += "  WHERE A.E2_EMISSAO = '"+DTOS(SE2->E2_EMISSAO)+"' "+CRLF
	cQuery += "    AND A.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "    AND A.E2_FILIAL = '"+XFILIAL("SE2")+"' "+CRLF
	cQuery += "    AND A.E2_PREFIXO = '"+SE2->E2_PREFIXO+"' "+CRLF
	cQuery += "    AND A.E2_NUM = '"+SE2->E2_NUM+"' "+CRLF
	cQuery += "    AND A.E2_PARCELA = '"+SE2->E2_PARCELA+"' "+CRLF
	cQuery += "    AND A.E2_TIPO = '"+SE2->E2_TIPO+"' "+CRLF
	cQuery += "    AND B.AD6_FILIAL = '"+XFILIAL("AD6")+"' "+CRLF
	cQuery += "    AND B.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "    AND B.AD6_PREFIX = A.E2_PREFIXO "+CRLF
	cQuery += "    AND B.AD6_NUMERO = A.E2_NUM "+CRLF
	cQuery += "    AND B.AD6_PARCEL = A.E2_PARCELA "+CRLF
	cQuery += "    AND B.AD6_TIPO = A.E2_TIPO "+CRLF

	cQuery := ChangeQuery(cQuery) 
	iIf(Select("TRBSE2") > 0,TRBSE2->(DbCloseArea()),NIL)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSE2",.T.,.T.)
	if TRBSE2->(!eof())
		SA3->(DBSETORDER(1))
		IF SA3->(DBSEEK(XFILIAL("SA3")+TRBSE2->AD6_VEND))
			xCC	:= SA3->A3_CC
		ENDIF
	endif

Return(xCC)