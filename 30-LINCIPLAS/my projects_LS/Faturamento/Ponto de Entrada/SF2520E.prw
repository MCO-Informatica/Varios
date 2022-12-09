#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   ºAutor  ³lexandre Dalpiaz    º Data ³30/08/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na exclusão da nota fiscal de saida.       º±±
±±º          ³atualiza campos dos romaneios (PA6)                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LaSelva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2520E()

Local _aAlias := GetArea()

_cQuery := "UPDATE " + RetSqlName('PA6')
_cQuery += _cEnter + "SET PA6_STATUS = '02', PA6_NFS = '', PA6_SERIE = '', PA6_DESCST = 'Separacao OK'"
_cQuery += _cEnter + "FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
_cQuery += _cEnter + "WHERE PA6_NUMROM 		= D2_PEDIDO + D2_FILIAL"
_cQuery += _cEnter + "AND D2_FILIAL 		= '" + SF2->F2_FILIAL + "'"
_cQuery += _cEnter + "AND D2_DOC 			=  '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + "AND D2_SERIE 			= '" + SF2->F2_SERIE + "'"
_cQuery += _cEnter + "AND SD2.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND " + RetSqlName('PA6') + ".D_E_L_E_T_ = ''"
TcSqlExec(_cQuery)


_cQuery := "UPDATE SZ9"
_cQuery += _cEnter + " SET Z9_QUANT = Z9_QUANT + D2_QUANT"
_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SZ9') + " SZ9 (NOLOCK)"
_cQuery += _cEnter + " 										ON Z9_FILIAL 		= D2_FILIAL"
_cQuery += _cEnter + " 										AND Z9_PRODUTO 		= D2_COD"
_cQuery += _cEnter + " 										AND SZ9.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
_cQuery += _cEnter + " 										ON F4_CODIGO 		= D2_TES"
_cQuery += _cEnter + " 										AND F4_ESTOQUE 		= 'S'"
_cQuery += _cEnter + " 										AND SF4.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + " WHERE D2_DOC 		= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND D2_SERIE 		= '" + SF2->F2_SERIE + "'"
_cQuery += _cEnter + " AND D2_CF 			IN ('','','')
_cQuery += _cEnter + " AND SD2.D_E_L_E_T_ 	= ''"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If SF2->F2_CLIENTE < '000009'
	SD2->( DbSetOrder(3) )
	If SD2->( DbSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
		While !SD2->( EOF() ) .AND. SD2->D2_DOC=SF2->F2_DOC .AND. SD2->D2_SERIE=SF2->F2_SERIE .AND. SD2->D2_CLIENTE=SF2->F2_CLIENTE .AND. SD2->D2_LOJA=SF2->F2_LOJA
			_cQuery := "UPDATE " + RetSqlName('SB2')
			clocal:=POSICIONE("SC6", 1, xFilial("SC6") + SD2->D2_PEDIDO+SD2->D2_ITEMPV,"C6_LOCAL")
			nsaldo=POSICIONE("SB2", 1, SF2->F2_LOJA + SD2->D2_COD+clocal,"B2_XTRANSI")    - SD2->D2_QUANT
			nreser=POSICIONE("SB2", 1, SF2->F2_LOJA + SD2->D2_COD+clocal,"B2_XRESERV")    + SD2->D2_QUANT
			
			
			IF nsaldo<=0
				nsaldo:=0
			ELSE
				nsaldo:=nsaldo
			ENDIF
			
			_cQuery := "UPDATE " + RetSqlName('SB2')
			_cQuery += _cEnter + " SET B2_XTRANSI ="+CVALTOCHAR(nsaldo)  // TRANSITO
			_cQuery += _cEnter + " ,B2_XRESERV ="+CVALTOCHAR(nreser)  // TRANSITO
			_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
			_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
			_cQuery += _cEnter + " 										ON SF4.D_E_L_E_T_ 	= ''"
			_cQuery += _cEnter + " 										AND F4_CODIGO 		= D2_TES"
			_cQuery += _cEnter + " 										AND F4_ESTOQUE 		= 'S'"
			
			_cQuery += _cEnter + " WHERE SD2.D_E_L_E_T_ 	= ''"
			_cQuery += _cEnter + " AND D2_FILIAL 			= '" + SF2->F2_FILIAL + "'" // ORIGEM
			_cQuery += _cEnter + " AND D2_DOC 				= '" + SF2->F2_DOC + "'"
			_cQuery += _cEnter + " AND D2_CLIENTE 			= '" + SF2->F2_CLIENTE + "'"
			_cQuery += _cEnter + " AND D2_LOJA 				= '" + SF2->F2_LOJA + "'"
			_cQuery += _cEnter + " AND D2_CLIENTE 			< '000009'"
			_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ 	= ''"
			_cQuery += _cEnter + " AND B2_FILIAL 			= '" + SF2->F2_LOJA+ "'"
			_cQuery += _cEnter + " AND B2_COD 				= '" + SD2->D2_COD+ "'"
			_cQuery += _cEnter + " AND B2_LOCAL 			= '" + clocal+ "'"
			TcSqlExec(_cQuery)
			
			SD2->( DbSkip() )
		EndDo
	endif
EndIf



If SF2->F2_SERIE == 'ZZZ'
	_cQuery := "UPDATE " + RetSqlName('SF3')
	_cQuery += _cEnter + "SET D_E_L_E_T_ = '*'"
	_cQuery += _cEnter + "WHERE F3_FILIAL 	= '" + SF2->F2_FILIAL + "' AND "
	_cQuery += _cEnter + "F3_NFISCAL 		= '" + SF2->F2_DOC + "' AND "
	_cQuery += _cEnter + "F3_SERIE 			= 'ZZZ' AND "
	_cQuery += _cEnter + "F3_CLIEFOR 		= '" + SF2->F2_CLIENTE + "' AND "
	_cQuery += _cEnter + "F3_LOJA 			= '" + SF2->F2_LOJA + "'"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SFT')
	_cQuery += _cEnter + "SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
	_cQuery += _cEnter + "WHERE FT_FILIAL 	= '" + SF2->F2_FILIAL + "' AND "
	_cQuery += _cEnter + "FT_NFISCAL 		= '" + SF2->F2_DOC + "' AND "
	_cQuery += _cEnter + "FT_SERIE 			= 'ZZZ' AND "
	_cQuery += _cEnter + "FT_CLIEFOR 		= '" + SF2->F2_CLIENTE + "' AND "
	_cQuery += _cEnter + "FT_LOJA 			= '" + SF2->F2_LOJA + "'"
	TcSqlExec(_cQuery)
EndIf

Return()
