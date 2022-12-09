#INCLUDE "rwmake.ch"  
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP660    º Autor ³                    º Data ³  21/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ LP 660 -                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico MAKENI                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LP660(_cseq)

	Local _aArea  := GetArea()
	Local _nValor := 0  
	Local NNVL := 0 


	IF _cseq $'118'
		IF SF1->F1_TIPO$'N/C' .AND. SF4->F4_DUPLIC='S' .AND. SUBSTR(SD1->D1_CF,2,3)$'933'.AND. SD1->D1_RATEIO <> '1' .AND. SF4->F4_XCONT<>'N'
			cquery := "SELECT SUM(SE2.E2_IRRF) AS NVL, SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_TIPO, SE2.E2_EMISSAO " 
			cQuery += "FROM " + RetSqlName("SE2")+ " SE2 "
			cQuery += "WHERE SE2.E2_FORNECE='" + SF1->F1_FORNECE + "' AND " + "SE2.E2_LOJA='" + SF1->F1_LOJA + "' AND "    
			cQuery += "SE2.E2_EMISSAO='" + DTOS(SF1->F1_EMISSAO) + "' AND "				
			cQuery += "SE2.E2_NUM='" + SF1->F1_DOC + "' AND " + "SE2.E2_PREFIXO='" + SF1->F1_SERIE + "' AND " + "SE2.E2_TIPO='NF ' AND "
			cQuery += "SE2.E2_FILIAL= '" + SF1->F1_FILIAL + "' AND SE2.D_E_L_E_T_ = ' ' "                                        
			cQuery +=  "GROUP BY  SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_FORNECE, SE2.E2_LOJA , SE2.E2_TIPO ,SE2.E2_EMISSAO   		"
			cQuery:= ChangeQuery(cQuery)      

			//TcQuery ChangeQuery(cquery) NEW ALIAS "TRBSE2"        
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSE2",.T.,.F.)

			NNVL := trbse2->nvl

			_nValor := NNVL

			TRBSE2->(DbCloseArea())
			    
		ELSE
			_nValor := 0
		ENDIF

	ELSEIF _cseq == '122'

		IF SF1->F1_TIPO$'N/C' .AND. SF4->F4_DUPLIC='S' .AND. SUBSTR(SD1->D1_CF,2,3)$'933'.AND. SD1->D1_RATEIO <> '1' .AND. SF4->F4_XCONT<>'N' .AND. SA2->A2_TIPO <> 'X'

			cquery := "SELECT SUM(SE2.E2_IRRF) AS NVL, SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_TIPO,SE2.E2_EMISSAO " 
			cQuery += "FROM " + RetSqlName("SE2")+ " SE2 "
			cQuery += "WHERE SE2.E2_FORNECE='" + SF1->F1_FORNECE + "' AND " + "SE2.E2_LOJA='" + SF1->F1_LOJA + "' AND "
			cQuery += "SE2.E2_EMISSAO='" + DTOS(SF1->F1_EMISSAO) + "' AND "		
			cQuery += "SE2.E2_NUM='" + SF1->F1_DOC + "' AND " + "SE2.E2_PREFIXO='" + SF1->F1_SERIE + "' AND " + "SE2.E2_TIPO='NF ' AND "
			cQuery += "SE2.E2_FILIAL= '" + SF1->F1_FILIAL + "' AND SE2.D_E_L_E_T_ = ' ' "                                        
			cQuery +=  "GROUP BY  SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_FORNECE, SE2.E2_LOJA , SE2.E2_TIPO, SE2.E2_EMISSAO    		"
			cQuery:= ChangeQuery(cQuery)      

			//TcQuery ChangeQuery(cquery) NEW ALIAS "TRBSE2"        
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSE2",.T.,.F.)
			NNVL := trbse2->nvl
			_nValor := SF1->F1_VALBRUT- (NNVL+IIF(SF1->F1_RECISS<>'1',SF1->F1_ISS,0)+SF1->F1_INSS-SF1->F1_DESCONT)   
			TRBSE2->(DbCloseArea())

		ELSE
			_nValor := 0
		ENDIF
	ENDIF                                    


	RestArea(_aArea)

Return(_nValor)       
