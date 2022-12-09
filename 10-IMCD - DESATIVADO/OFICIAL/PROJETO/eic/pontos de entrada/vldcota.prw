#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VLDCOTA  º Autor ³ Junior Gardel      º Data ³ 02/12/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validar se o Produtto tem anuencia e a LI não está         º±±
±±º          ³ preenchida                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEIC                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VLDCOTA(cTab)
Local lRet := .T.
Local cVar		:= ReadVar()
Private cQuery    := ""
Private cRetAlias := GetNextAlias()
Default cTab :=  ''


if cTab=='SW3'
	
elseif cTab=='SW6'.AND. 'W6_DT_EMB' $ cVar
	
	cPOBase := M->W6_PO_NUM
	cAliasTRB := BscDados(cPOBase)
	
	dbSelectArea(cAliasTRB)
	(cAliasTRB)->(dbGoTop())
	
	While (cAliasTRB)->( !Eof() )
		if (cAliasTRB)->W3_FLUXO =='1'
			IF (cAliasTRB)->B1_XF_LI == '1' .AND. EMPTY((cAliasTRB)->WP_REGIST)
				Aviso("Anuência", "Li não foi informada para o Produto "+(cAliasTRB)->B1_COD+"  que está com Etapa Anuencia PRE." ,{"Ok"})
				lRet := .F.
			endif
		endif
		
		(cAliasTRB)->(DBSKIP() )
	ENDDO
	
elseif cTab=='SW6'.AND. 'W6_DT_DESE' $ cVar
	
	cPOBase := M->W6_PO_NUM
	cAliasTRB := BscDados(cPOBase)
	
	dbSelectArea(cAliasTRB)
	(cAliasTRB)->(dbGoTop())
	
	While (cAliasTRB)->( !Eof() )
		if (cAliasTRB)->W3_FLUXO =='1'
			IF (cAliasTRB)->B1_XF_LI == '2' .AND. EMPTY((cAliasTRB)->WP_REGIST)
				Aviso("Anuência", "Li não foi informada para o Produto "+(cAliasTRB)->B1_COD+"  que está com Etapa Anuencie POS." ,{"Ok"})
				lRet := .F.
			endif
		endif
		
		(cAliasTRB)->(DBSKIP() )
	ENDDO
	
elseif cTab=='SW4'.AND. 'W4_XNUMAI' $ cVar
	
ENDIF

Return lRet


Static Function BscDados(cPOBase)

Local cQuery    := ""
Local cRetAlias := GetNextAlias()


cQuery := "SELECT W3_FLUXO,B1_COD,B1_XF_LI,WP_REGIST FROM "+RetSqlName("SW7") + " SW7 "
cQuery += " LEFT JOIN  "+RetSqlName("SW3") + " SW3 ON "
cQuery += " W7_FILIAL|| W7_PO_NUM|| W7_POSICAO|| W7_PGI_NUM = W3_FILIAL|| W3_PO_NUM|| W3_POSICAO|| W3_PGI_NUM "
cQuery += " AND W3_SEQ = '1' AND SW3.D_E_L_E_T_ <> '*'  "
cQuery += " LEFT JOIN  "+RetSqlName("SWP") + " SWP ON "
cQuery += " SWP.WP_FILIAL = W7_FILIAL AND W7_PGI_NUM = SWP.WP_PGI_NUM "
cQuery += " AND WP_SEQ_LI = W7_SEQ_LI  AND SWP.D_E_L_E_T_ <> '*' "
cQuery += " LEFT JOIN  "+RetSqlName("SB1") + " SB1 ON "
cQuery += " B1_COD = W3_COD_I AND SB1.D_E_L_E_T_ <> '*'  "
cQuery += " WHERE  W7_FILIAL = '"+XFILIAL("SW7") +"' AND  "
cQuery += " W7_PO_NUM = '"+ cPOBase +"' AND SW7.D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cRetAlias, .T., .F.)
dbSelectArea(cRetAlias)
Return cRetAlias
