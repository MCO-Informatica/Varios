#Include "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMSB101 º Autor ³ Ricardo Felipelli      º Data ³  02/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Trigger para criar codigo de barras quando grupo = artesanato  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                              	      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COMSB1010()

Local cAlias	:= GetArea()
Local lRet 	   	:= .T.

if m->B1_GRUPO == '0017'
	
	dbselectarea("SB1")
	dbsetorder(01)
	_preencod  := 13 - len(alltrim(m->B1_COD))
	_codbarnew := alltrim(m->B1_COD) + replicate("0",_preencod)
	while .t.
		cQuery	:= " SELECT B1_CODBAR FROM " +RetSqlName("SB1") + " (NOLOCK)"
		cQuery	+= " WHERE "
		cQuery	+= " B1_CODBAR = '"+_codbarnew+"' AND D_E_L_E_T_ = '' "

		dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TMPSB1", .F., .T.)
		
		DbSelectArea("TMPSB1")
		if TMPSB1->B1_CODBAR <> _codbarnew    
			TMPSB1->(dbclosearea())
			exit
		else
			_preencod++
		endif
		
		
		TMPSB6->(DbGoTop())
		If TMPSB6->(!Eof())
			nQtdPT += TMPSB6->QTD
		EndIf
	enddo
	
	RestArea(cAlias)
	Return(_codbarnew)
endif
