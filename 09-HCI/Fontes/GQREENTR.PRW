#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GQREENTR ³ Autor ³ Geraldo Sabino        ³ Data ³ 18/09/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava os campos em Branco no CD2 (cod Produto)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Quando for Formulario Proprio Proprio = S e for Devolucao    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION GQREENTR()
_aArea    := GetArea()
_aAreaCD2 := CD2->(GetArea())
_aAreaSD1 := SD1->(GetArea())
                            

// DEVOLUCAO DE VENDA - FORMULARIO PROPRIO

IF SF1->F1_TIPO="D"  .AND. SF1->F1_FORMUL="S"
	_cQuery := "select * from "+retsqlname("CD2")+" WHERE D_E_L_E_T_<>'*'  AND CD2_TPMOV = 'E' AND  "
	_cQuery += " CD2_CODCLI = '"+SF1->F1_FORNECE+"' AND CD2_LOJCLI = '"+SF1->F1_LOJA+"'   AND CD2_DOC = '"+SF1->F1_DOC+"' AND "
	_cQuery += " CD2_SERIE  = '"+SF1->F1_SERIE+"'   AND CD2_FILIAL = '"+xFilial("CD2")+"' AND CD2_FORMU='S'  "
	
	
	IF SELECT("TMPP") <> 0
		dBSelectarea("TMPP")
		DBCLOSEAREA("TMPP")
	ENDIF
	
	tcquery (_cQuery) New Alias "TMPP"
	
	dBSelectarea("TMPP")
	dBgotop()
	While CD2_FILIAL + CD2_TPMOV + CD2_SERIE + CD2_DOC + CD2_CODCLI + CD2_LOJCLI == xFilial("CD2")+"E"+SF1->F1_SERIE + SF1->F1_DOC + SF1->F1_FORNECE+SF1->F1_LOJA
		RECNOCD2 := TMPP->R_E_C_N_O_
		
		IF EMPTY(TMPP->CD2_CODPRO)
			_cQuery := "select * from "+retsqlname("SD1")+" WHERE D_E_L_E_T_<>'*'                      AND  "
			_cQuery += " D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA    = '"+SF1->F1_LOJA+"'        AND D1_DOC  = '"+SF1->F1_DOC+"' AND "
			_cQuery += " D1_SERIE   = '"+SF1->F1_SERIE+"' AND D1_ITEM = '"+TMPP->CD2_ITEM+"'           AND D1_FILIAL  = '"+xFilial("SD1")+"'  "
			
			
			IF SELECT("TMPD") <> 0
				dBSelectarea("TMPD")
				DBCLOSEAREA("TMPD")
			ENDIF
			
			tcquery (_cQuery) New Alias "TMPD"
			
			dBSelectarea("TMPD")
			dBGotop()
			IF !TMPD->(Eof())
				dBselectarea("CD2")
				dBgoto(RECNOCD2)
				CD2->(Reclock("CD2",.F.))
				
				IF SUBSTR(TMPD->D1_CLASFIS,1,1)=" "
					IF SUBSTR(TMPD->D1_CF,1,1)="3"
						CD2->CD2_ORIGEM := "1"
					ELSE
						CD2->CD2_ORIGEM := "0"
					ENDIF
				ELSE
					CD2->CD2_ORIGEM := SUBSTR(TMPD->D1_CLASFIS,1,1)
				ENDIF
				
				CD2->CD2_CODPRO := TMPD->D1_COD
				CD2->(MSunlock())
			ENDIF
			dBCloseArea("TMPD")
		Endif
		
		dBSelectarea("TMPP")
		dBskip()
	Enddo
	dBCloseArea("TMPP")
ENDIF

// 03.12.2018 - Nunca teve este tratamento abaixo. (Tratava DEVOLUCAO, e NÃO IMPORTACAO)
// Nao estava tratando a correcao da nota de entrada de importacao (Campos Codigo Produto nao gravava na CD2)
IF SF1->F1_TIPO="N"  .AND. SF1->F1_FORMUL="S"  .AND. SF1->F1_EST = 'EX'
	_cQuery := "select * from "+retsqlname("CD2")+" WHERE D_E_L_E_T_<>'*'  AND CD2_TPMOV = 'E' AND  "
	_cQuery += " CD2_CODFOR = '"+SF1->F1_FORNECE+"' AND CD2_LOJFOR = '"+SF1->F1_LOJA+"'   AND CD2_DOC = '"+SF1->F1_DOC+"' AND "
	_cQuery += " CD2_SERIE  = '"+SF1->F1_SERIE+"'   AND CD2_FILIAL = '"+xFilial("CD2")+"' AND CD2_FORMU='S'   "
	
	
	IF SELECT("TMPP") <> 0
		dBSelectarea("TMPP")
		DBCLOSEAREA("TMPP")
	ENDIF
	
	tcquery (_cQuery) New Alias "TMPP"
	
	dBSelectarea("TMPP")
	dBgotop()
	While CD2_FILIAL + CD2_TPMOV + CD2_SERIE + CD2_DOC + CD2_CODFOR + CD2_LOJFOR == xFilial("CD2")+"E"+SF1->F1_SERIE + SF1->F1_DOC + SF1->F1_FORNECE+SF1->F1_LOJA
		RECNOCD2 := TMPP->R_E_C_N_O_
		
		IF EMPTY(TMPP->CD2_CODPRO)
			_cQuery := "select * from "+retsqlname("SD1")+" WHERE D_E_L_E_T_<>'*'                      AND  "
			_cQuery += " D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA    = '"+SF1->F1_LOJA+"'        AND D1_DOC  = '"+SF1->F1_DOC+"' AND "
			_cQuery += " D1_SERIE   = '"+SF1->F1_SERIE+"' AND D1_ITEM = '"+TMPP->CD2_ITEM+"'           AND D1_FILIAL  = '"+xFilial("SD1")+"'  "
			
			
			IF SELECT("TMPD") <> 0
				dBSelectarea("TMPD")
				DBCLOSEAREA("TMPD")
			ENDIF
			
			tcquery (_cQuery) New Alias "TMPD"
			
			dBSelectarea("TMPD")
			dBGotop()
			IF !TMPD->(Eof())
				dBselectarea("CD2")
				dBgoto(RECNOCD2)
				CD2->(Reclock("CD2",.F.))
				CD2->CD2_CODPRO := TMPD->D1_COD
				
				IF SUBSTR(TMPD->D1_CLASFIS,1,1)=" "
					IF SUBSTR(TMPD->D1_CF,1,1)="3"
						CD2->CD2_ORIGEM := "1"
					ELSE
						CD2->CD2_ORIGEM := "0"
					ENDIF
				ELSE
					CD2->CD2_ORIGEM := SUBSTR(TMPD->D1_CLASFIS,1,1)
				ENDIF
				
				CD2->(MSunlock())
			ENDIF
			dBCloseArea("TMPD")
		Endif
		
		dBSelectarea("TMPP")
		dBskip()
	Enddo
	dBCloseArea("TMPP")
ENDIF

RestArea(_aAreaSD1)
RestArea(_aAreaCD2)
RestArea(_aArea)
Return


