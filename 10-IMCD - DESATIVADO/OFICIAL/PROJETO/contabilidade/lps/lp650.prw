#INCLUDE "rwmake.ch"  
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP650    º Autor ³                    º Data ³  21/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ LP 650 -                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico MAKENI                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LP650(_cseq)

	Local _aArea  := GetArea()
	Local _nValor := 0  
	Local nvl := 0 

	IF _cseq == '001'
		//	IF SF1->F1_TIPO$'N/C' .AND. SF4->F4_DUPLIC='S' .AND. SUBSTR(SD1->D1_CF,1,3)$'000' .AND. ALLTRIM(SF1->F1_ESPECIE)$'REC/GG/NFS' .AND.;
		//		SD1->D1_RATEIO<>'1' .AND.  SF4->F4_XCONT<>'N'
		// alterado em 12.02.16 --- excluido o rateio.
		IF SF1->F1_TIPO$'N/C' .AND. SF4->F4_DUPLIC='S' .AND. SUBSTR(SD1->D1_CF,1,3)$'000' .AND. ALLTRIM(SF1->F1_ESPECIE)$'REC/GG/NFS/RPS' .AND.;
		SF4->F4_XCONT<>'N'

			IF !ALLTRIM(SF1->F1_FORNECE)$'UNIAO/ESTADO'
				// ALTERADO EM 19.01.16 -- RETIRADO POR AREA CONTABIL --
				//_nValor := SD1->D1_TOTAL-(SD1->D1_VALIRR+SD1->D1_VALISS+SD1->D1_VALINS-SD1->D1_VALDESC+SD1->D1_VALIMP6+SD1->D1_VALIMP5) 
				_nValor := SD1->D1_TOTAL-(SD1->D1_VALIMP6+SD1->D1_VALIMP5)
			ENDIF
		ELSE
			_nValor := 0
		ENDIF
	Endif

	IF _cseq == '002'
		//   IF SF1->F1_TIPO$'N/C' .AND. SF4->F4_DUPLIC='S' .AND. SUBSTR(SD1->D1_CF,1,3)$'000' .AND. ALLTRIM(SF1->F1_ESPECIE)$'REC/GG/NFS' .AND. ;
		//      SD1->D1_RATEIO<>'1' .AND. SF4->F4_XCONT<>'N'
		// alterado em 12.02.16 - retirado o rateio
		IF SF1->F1_TIPO$'N/C' .AND. SF4->F4_DUPLIC='S' .AND. SUBSTR(SD1->D1_CF,1,3)$'000' .AND. ALLTRIM(SF1->F1_ESPECIE)$'REC/GG/NFS/RPS' .AND. ;
		SF4->F4_XCONT<>'N'

			IF !ALLTRIM(SF1->F1_FORNECE)$'UNIAO/ESTADO'
//				_nValor := SD1->D1_TOTAL- (SD1->D1_VALIRR+SD1->D1_VALISS+SD1->D1_VALINS-SD1->D1_VALDESC)
				_nValor := SD1->D1_TOTAL- (SD1->D1_VALIRR+SD1->D1_VALISS+SD1->D1_VALINS+SD1->D1_VALDESC)  //alterado por Nádia em 19/08/19
		

			ENDIF
		ELSE 
			_nValor := 0
		ENDIF  
	ENDIF 

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

			DbCloseArea("TRBSE2")        
		ELSE
			_nValor := 0
		ENDIF
	ENDIF                                  


	IF _cseq == '122'

		IF SF1->F1_TIPO$'N/C' .AND. SF4->F4_DUPLIC='S' .AND. SUBSTR(SD1->D1_CF,2,3)$'933'.AND. SD1->D1_RATEIO <> '1' .AND. SF4->F4_XCONT<>'N'

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
			_nValor := SD1->D1_TOTAL - (NNVL+IIF(SF1->F1_RECISS<>'1',SD1->D1_VALISS,0)+SD1->D1_VALINS-SD1->D1_VALDESC)   
			DbCloseArea("TRBSE2")                

		ELSE
			_nValor := 0
		ENDIF
	ENDIF                                  


	RestArea(_aArea)

Return(_nValor)       