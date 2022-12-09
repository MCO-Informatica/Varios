#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_RETENC()
/////////////////////////

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatório de Titulos Originais X Retençoes"
Local cPict         := ""
Local titulo        := "Relatório de Titulos Originais X Retençoes"
Local nLin          := 80
Local Cabec1        := "Codigo/Lj  Nome Fornecedor                           CNPJ                Prf  Numero  P  Tp   Natureza   Emissao          Baixa   Base Retencao                                    Impostos"
Local Cabec2        := "                                                                                                                                                   Vencimento         Pis      Cofins        CSLL       Total"
//                                                                                                                                                                         Vencimento         Pis      Cofins        CSLL       Total
//                      009113 01  1234567890123456789012345678901234567890  07.026.648/0001-86       000025  X  NF   1102140    02/05/2006  04/05/2006  999.999.999.99    11/11/1111  999.999.99  999.999.99  999.999.99  999.999.99
Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "FM_RETENC"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "LSRETENCAO"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FM_RETENC"

Private cString := "SE2"

dbSelectArea("SE2")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

fErase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
///////////////////////////////////////////////////////
Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

_nLast1 := 0
_nLast2 := 0
_nLast3 := 0

If mv_par03 == 2 .or. mv_par03 == 4	// pcc
	
	If mv_par05 == 1
		_cQuery1 := "SELECT A.A2_CGC, A.A2_NOME, A.E2_FORNECE, A.E2_VRETPIS, A.E2_BASEPIS + ISNULL(CASE WHEN B.E2_BASEPIS >=  " + alltrim(str(GetMv('MV_VL10925'))) + "  THEN 0 ELSE B.E2_BASEPIS END,0) E2_BASEPIS, "
		_cQuery1 += _cEnter + "A.E2_VRETCOF, A.E2_BASECOF + ISNULL(CASE WHEN B.E2_BASECOF >= " + alltrim(str(GetMv('MV_VL10925'))) + " THEN 0 ELSE B.E2_BASECOF END,0) E2_BASECOF, "
		_cQuery1 += _cEnter + "A.E2_VRETCSL, A.E2_BASECSL + ISNULL(CASE WHEN B.E2_BASECSL >= " + alltrim(str(GetMv('MV_VL10925'))) + " THEN 0 ELSE B.E2_BASECSL END,0) E2_BASECSL "
		_cQuery1 += _cEnter + "FROM "
		_cQuery1 += _cEnter + "( "
		
		_cQueryA := "SELECT SUBSTRING(A2_CGC,1,8) A2_CGC, MAX(A2_NOME) A2_NOME, E2_FORNECE, SUM(E2_VRETPIS) E2_VRETPIS, SUM(E2_BASEPIS) E2_BASEPIS, "
		_cQueryA += _cEnter + "SUM(E2_VRETCOF) E2_VRETCOF, SUM(E2_BASECOF) E2_BASECOF, "
		_cQueryA += _cEnter + "SUM(E2_VRETCSL) E2_VRETCSL, SUM(E2_BASECSL) E2_BASECSL "
		If mv_par07 == 1
			_cQueryA += ", SUBSTRING(E2_VENCREA,1,6) E2_DATA"
		EndIf
		_cQueryA += _cEnter + "FROM  " + RetSqlName('SE2')  + " E2 (nolock), " + RetSqlName('SA2')  + " A2 (nolock) "
		_cQueryA += _cEnter + "WHERE E2_VENCREA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' "
		If !empty(mv_par04)
			_cQueryA += _cEnter + "AND E2_FORNECE = '" + mv_par04 + "' "
		EndIf
			_cQueryA += _cEnter + "AND E2_MATRIZ = '" + mv_par09 + "'"
		_cQueryA += _cEnter + "AND E2.D_E_L_E_T_ = '' "
		_cQueryA += _cEnter + "AND A2.D_E_L_E_T_ = '' "
		_cQueryA += _cEnter + "AND A2_COD = E2_FORNECE "
		_cQueryA += _cEnter + "AND A2_LOJA = E2_LOJA "
		_cQueryA += _cEnter + "AND E2_VRETPIS + E2_PIS + E2_VRETCOF + E2_COFINS + E2_VRETCSL +  E2_CSLL > 0 "
		If mv_par07 == 1
			_cQueryA += _cEnter + "GROUP BY SUBSTRING(E2_VENCTO,1,6), SUBSTRING(A2_CGC,1,8), E2_FORNECE "
		Else
			_cQueryA += _cEnter + "GROUP BY SUBSTRING(A2_CGC,1,8), E2_FORNECE "
		EndIf
		_cQueryA += _cEnter + "HAVING SUM(E2_VRETPIS) + SUM(E2_VRETCSL) + SUM(E2_VRETCOF) > 0 "
		
		_cQuery2 := _cEnter + ")A, ( "
		
		_cQueryB := _cEnter + "SELECT SUBSTRING(A2_CGC,1,8) A2_CGC, MAX(A2_NOME) A2_NOME, E2_FORNECE, SUM(E2_VRETPIS) E2_VRETPIS, SUM(E2_BASEPIS) E2_BASEPIS, "
		_cQueryB += _cEnter + "SUM(E2_VRETCOF) E2_VRETCOF, SUM(E2_BASECOF) E2_BASECOF, "
		_cQueryB += _cEnter + "SUM(E2_VRETCSL) E2_VRETCSL, SUM(E2_BASECSL) E2_BASECSL "
		_cQueryB += _cEnter + "FROM " + RetSqlName('SE2')  + " E2 (nolock), " + RetSqlName('SA2')  + " A2 (nolock) "
		_cQueryB += _cEnter + "WHERE E2.E2_VENCREA BETWEEN '" + left(dtos(mv_par01),6) + "01' AND '" + left(dtos(mv_par02),6) + "15' "
		If !empty(mv_par04)
			_cQueryB += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "' "
		EndIf
		_cQueryB += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "
		_cQueryB += _cEnter + "AND E2.D_E_L_E_T_ = '' "
		_cQueryB += _cEnter + "AND A2.D_E_L_E_T_ = '' "
		_cQueryB += _cEnter + "AND A2_COD = E2_FORNECE "
		_cQueryB += _cEnter + "AND A2_LOJA = E2_LOJA "
		_cQueryB += _cEnter + "AND ((E2_VRETPIS > 0 OR E2_PIS > 0)"
		_cQueryB += _cEnter + "OR (E2_VRETCOF > 0 OR E2_COFINS > 0)"
		_cQueryB += _cEnter + "OR (E2_VRETCSL > 0 OR E2_CSLL > 0))"
		_cQueryB += _cEnter + "GROUP BY SUBSTRING(A2_CGC,1,8), E2_FORNECE "
		_cQueryB += _cEnter + "HAVING SUM(E2_VRETPIS) + SUM(E2_VRETCSL) + SUM(E2_VRETCOF) + SUM(E2_PIS) + SUM(E2_CSLL) + SUM(E2_COFINS) > 0 "
		_cQueryB += _cEnter + ") B"
		
		_cQuery3 := _cEnter + "WHERE A.A2_CGC *= B.A2_CGC"
		If mv_par07 == 1
			_cQuery3 += _cEnter + "ORDER BY  A.A2_CGC, SUBSTRING(A.E2_VENCTO,1,6)"
		Else
			_cQuery3 += _cEnter + "ORDER BY A.A2_CGC"
		EndIf
		
		If day(mv_par01) > 15
			_cQuery := _cQuery1 + _cQueryA + _cQuery2 + _cQueryB + _cQuery3
		Else
			_cQuery := _cQueryA
			If mv_par07 == 1
				_cQuery += _cEnter + "ORDER BY A2_CGC, SUBSTRING(E2_VENCTO,1,6)"
			Else
				_cQuery += _cEnter + "ORDER BY A2_CGC"
			EndIf
		EndIf
		
	Else
		
		_cQuery0 := "SELECT A2.A2_CGC, A2.A2_NOME, E2.E2_FORNECE, E2.E2_VRETPIS, E2.E2_BASEPIS, E2.E2_VRETCOF,"
		_cQuery0 += _cEnter + "E2.E2_BASECOF, E2.E2_VRETCSL, E2.E2_BASECSL, E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, "
		_cQuery0 += _cEnter + "E2.E2_TIPO, E2.E2_PARCPIS, E2.E2_PARCCOF, E2.E2_PARCSLL, E2.E2_NATUREZ,"
		_cQuery0 += _cEnter + "E2.E2_EMISSAO, E2.E2_VENCREA, E2.E2_EMIS1, E2.E2_VENCREA E2_DATA, E2.R_E_C_N_O_ E2_RECNO, E2.E2_MSFIL"
		_cQuery0 += _cEnter + "FROM " + RetSqlName('SE2')  + " E2 (nolock) , " + RetSqlName('SA2')  + " A2 (nolock), "
		_cQuery0 += _cEnter + "("
		
		_cQuery1 := "SELECT A.A2_CGC, A.A2_NOME, A.E2_FORNECE, A.E2_VRETPIS, A.E2_BASEPIS + ISNULL(CASE WHEN B.E2_BASEPIS >=  " + alltrim(str(GetMv('MV_VL10925'))) + "  THEN 0 ELSE B.E2_BASEPIS END,0) E2_BASEPIS,"
		_cQuery1 += _cEnter + "A.E2_VRETCOF, A.E2_BASECOF + ISNULL(CASE WHEN B.E2_BASECOF >= " + alltrim(str(GetMv('MV_VL10925'))) + " THEN 0 ELSE B.E2_BASECOF END,0) E2_BASECOF,"
		_cQuery1 += _cEnter + "A.E2_VRETCSL, A.E2_BASECSL + ISNULL(CASE WHEN B.E2_BASECSL >= " + alltrim(str(GetMv('MV_VL10925'))) + " THEN 0 ELSE B.E2_BASECSL END,0) E2_BASECSL"
		_cQuery1 += _cEnter + "FROM "
		_cQuery1 += _cEnter + "("
		
		_cQueryA := _cEnter + "SELECT SUBSTRING(A2_CGC,1,8) A2_CGC, MAX(A2_NOME) A2_NOME, E2_FORNECE, SUM(E2_VRETPIS) E2_VRETPIS, SUM(E2_BASEPIS) E2_BASEPIS, "
		_cQueryA += _cEnter + "SUM(E2_VRETCOF) E2_VRETCOF, SUM(E2_BASECOF) E2_BASECOF, "
		_cQueryA += _cEnter + "SUM(E2_VRETCSL) E2_VRETCSL, SUM(E2_BASECSL) E2_BASECSL "
		_cQueryA += _cEnter + "FROM " + RetSqlName('SE2')  + " E2 (nolock), " + RetSqlName('SA2')  + " A2 (nolock) "
		_cQueryA += _cEnter + "WHERE E2_VENCREA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' "
		If !empty(mv_par04)
			_cQueryA += _cEnter + "AND E2_FORNECE = '" + mv_par04 + "' "
		EndIf
		_cQueryA += _cEnter + "AND E2_MATRIZ = '" + mv_par09 + "' "
		_cQueryA += _cEnter + "AND E2.D_E_L_E_T_ = '' "
		_cQueryA += _cEnter + "AND A2.D_E_L_E_T_ = '' "
		_cQueryA += _cEnter + "AND A2_COD = E2_FORNECE "
		_cQueryA += _cEnter + "AND A2_LOJA = E2_LOJA "
		_cQueryA += _cEnter + "AND E2_VRETPIS + E2_PIS + E2_VRETCOF + E2_COFINS + E2_VRETCSL +  E2_CSLL > 0 "
		_cQueryA += _cEnter + "GROUP BY SUBSTRING(A2_CGC,1,8), E2_FORNECE "
		//_cQueryA += _cEnter + "HAVING SUM(E2_VRETPIS) + SUM(E2_VRETCSL) + SUM(E2_VRETCOF) > 0 "
		_cQueryA += _cEnter + "HAVING SUM(E2_VRETPIS) + SUM(E2_VRETCSL) + SUM(E2_VRETCOF) + SUM(E2_PIS) + SUM(E2_CSLL) + SUM(E2_COFINS) > 0 "
		
		_cQuery2 := _cEnter + ")A, ( "
		
		_cQueryB := _cEnter + "SELECT SUBSTRING(A2_CGC,1,8) A2_CGC, MAX(A2_NOME) A2_NOME, E2_FORNECE, SUM(E2_VRETPIS) E2_VRETPIS, SUM(E2_BASEPIS) E2_BASEPIS, "
		_cQueryB += _cEnter + "SUM(E2_VRETCOF) E2_VRETCOF, SUM(E2_BASECOF) E2_BASECOF, "
		_cQueryB += _cEnter + "SUM(E2_VRETCSL) E2_VRETCSL, SUM(E2_BASECSL) E2_BASECSL "
		_cQueryB += _cEnter + "FROM " + RetSqlName('SE2')  + " E2 (nolock), " + RetSqlName('SE2')  + " A2 (nolock) "
		_cQueryB += _cEnter + "WHERE E2.E2_VENCREA BETWEEN '" + left(dtos(mv_par01),6) + "01' AND '" + left(dtos(mv_par02),6) + "15' "
		If !empty(mv_par04)
			_cQueryB += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "' "
		EndIf
		_cQueryB += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "
		_cQueryB += _cEnter + "AND E2.D_E_L_E_T_ = '' "
		_cQueryB += _cEnter + "AND A2.D_E_L_E_T_ = '' "
		_cQueryB += _cEnter + "AND A2_COD = E2_FORNECE "
		_cQueryB += _cEnter + "AND A2_LOJA = E2_LOJA "
		_cQueryB += _cEnter + "AND ((E2_VRETPIS > 0 OR E2_PIS > 0)"
		_cQueryB += _cEnter + "OR (E2_VRETCOF > 0 OR E2_COFINS > 0)"
		_cQueryB += _cEnter + "OR (E2_VRETCSL > 0 OR E2_CSLL > 0))"
		_cQueryB += _cEnter + "GROUP BY SUBSTRING(A2_CGC,1,8), E2_FORNECE "
		
		If day(mv_par01) > 15
			_cQueryB += _cEnter + "HAVING SUM(E2_BASEPIS) < 5000 AND SUM(E2_BASECSL) < 5000 AND SUM(E2_BASECOF) < 5000"
		Else
			_cQueryB += _cEnter + "HAVING SUM(E2_VRETPIS) + SUM(E2_VRETCSL) + SUM(E2_VRETCOF) > 0 "
		EndIf
		//_cQueryB += _cEnter + "HAVING SUM(E2_VRETPIS) + SUM(E2_VRETCSL) + SUM(E2_VRETCOF) + SUM(E2_PIS) + SUM(E2_CSLL) + SUM(E2_COFINS) > 0 "
		_cQueryB += _cEnter + ") B"
		
		_cQuery3 := _cEnter + "WHERE A.A2_CGC *= B.A2_CGC"
		
		
		_cQuery01 := _cEnter + ") C"
		
		If day(mv_par01) > 15
			_cQuery01 += _cEnter + "WHERE ((E2.E2_VENCREA BETWEEN '" + left(dtos(mv_par01),6) + '01' + "' AND '" + left(dtos(mv_par01),6) + "15' "
			_cQuery01 += _cEnter + "AND E2.E2_PRETPIS = '1' AND E2.E2_PRETCOF = '1' AND E2.E2_PRETCSL = '1') OR "
			_cQuery01 += _cEnter + " E2.E2_VENCREA BETWEEN '" + left(dtos(mv_par01),6) + '16' + "' AND '" + dtos(mv_par02) + "') "
		Else
			_cQuery01 += _cEnter + "WHERE E2.E2_VENCREA BETWEEN '" + left(dtos(mv_par01),6) + '01' + "' AND '" + dtos(mv_par02) + "' "
		EndIf
		If !empty(mv_par04)
			_cQuery01 += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "' "
		EndIf
		_cQuery01 += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "
		_cQuery01 += _cEnter + "AND E2.D_E_L_E_T_ = '' AND A2.D_E_L_E_T_ = '' AND "
		_cQuery01 += _cEnter + "A2_COD = E2.E2_FORNECE AND A2_LOJA = E2_LOJA AND "
		//_cQuery01 += _cEnter + "A2.COD AND = C.A2_COD AND "
		_cQuery01 += _cEnter + "SUBSTRING(A2.A2_CGC,1,8) = SUBSTRING(C.A2_CGC,1,8) AND"
		_cQuery01 += _cEnter + "E2.E2_VRETPIS + E2.E2_PIS + E2.E2_VRETCOF + E2.E2_COFINS + E2.E2_VRETCSL + E2.E2_CSLL > 0 "
		
		If day(mv_par01) > 15
			_cQuery := _cQuery0 + _cQuery1 + _cQueryA + _cQuery2 + _cQueryB + _cQuery3 + _cQuery01
			If mv_par07 == 1
				_cQuery += _cEnter + "ORDER BY SUBSTRING(A2.A2_CGC,1,8), SUBSTRING(E2_VENCTO,1,6), E2_RECNO"
			Else
				_cQuery += _cEnter + "ORDER BY SUBSTRING(A2.A2_CGC,1,8), E2_RECNO"
			EndIf
		Else
			_cQuery := _cQuery0 + _cQueryA + _cQuery01
			If mv_par07 == 1
				_cQuery += _cEnter + "ORDER BY SUBSTRING(A2.A2_CGC,1,8), SUBSTRING(E2.E2_VENCTO,1,6), E2_RECNO"
			Else
				_cQuery += _cEnter + "ORDER BY SUBSTRING(A2.A2_CGC,1,8), E2_RECNO"
			EndIf
		EndIf
		
	EndIf
	
	U_GravaQuery('fm_pcc.sql',_cquery)
	
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'_E2',.f.,.f.)},'Buscando informações de títulos com retenção (PCC)')
	
	TcSetField('_E2','E2_EMISSAO','D')
	TcSetField('_E2','E2_EMIS1'	,'D')
	TcSetField('_E2','E2_VENCREA'	,'D')
	
	Count to _nLast1
	DbGoTop()
	
EndIf

If mv_par03 == 1 .or. mv_par03 == 4		// IRRF
	
	_cQuery := "SELECT DISTINCT E2.E2_FORNECE FORNECE, E2.E2_LOJA LOJA"
	_cQuery += _cEnter + "FROM " + RetSqlName('SA2')  + " A2 (NOLOCK), " + RetSqlName('SE2')  + " E2 (NOLOCK)"
	_cQuery += _cEnter + "WHERE A2_COD = E2_FORNECE"
	_cQuery += _cEnter + "AND A2_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND A2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2_FORNECE <> '000008'"
	_cQuery += _cEnter + "AND ((A2_TIPO = 'F' AND E2.E2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "') OR (A2_TIPO <> 'F' AND E2.E2_EMIS1 BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'))"
	_cQuery += _cEnter + "AND E2.E2_PARCIR <> ''"
	_cQuery += _cEnter + "AND E2.E2_TIPO <> 'TX'"
	If !empty(mv_par04)
		_cQuery += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "'"
	EndIf
	_cQuery += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "
	
	_xyQuery := '(' + _cQuery + ') X '
	
	_cQuery := "SELECT DISTINCT CASE WHEN A2_TIPO = 'F' THEN '0588' ELSE CASE WHEN A2_NOME LIKE '%COOPERATIVA%' THEN '3280' ELSE CASE WHEN B1_DESC LIKE '%COMISSOES%' THEN '8045' ELSE '1708' END END END CODIGO, "
	_cQuery += _cEnter + "A2_CGC, SUBSTRING(E2.E2_EMISSAO,1,6) XEMISSAO, E2.E2_INSS, A2_TIPO, E2.E2_VENCREA, E2.E2_FORNECE, E2.E2_LOJA, "
	_cQuery += _cEnter + "E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_TIPO, E2.E2_VALOR, E2.E2_SALDO, E2.E2_NATUREZ, E2.R_E_C_N_O_, E2.E2_PARCIR, E2.E2_PARCINS, "
	_cQuery += _cEnter + "E2.E2_EMISSAO, E2.E2_EMIS1, E2.E2_VENCTO, E2.E2_BAIXA, E2.E2_MSFIL, F1_VALBRUT "

	_cQuery += _cEnter + "FROM " + RetSqlName('SA2')  + " A2 (NOLOCK), " + RetSqlName('SE2')  + " E2 (NOLOCK), " + RetSqlName('SF1')  + " F1 (NOLOCK), " + RetSqlName('SD1')  + " D1 (NOLOCK), " + RetSqlName('SB1')  + " B1 (NOLOCK), " + _XYQuery
	_cQuery += _cEnter + "WHERE FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND A2_COD = E2_FORNECE"
	_cQuery += _cEnter + "AND A2_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND B1_COD = D1_COD"
	_cQuery += _cEnter + "AND A2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND B1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND D1_FILIAL = F1_FILIAL"
	_cQuery += _cEnter + "AND D1_DOC = F1_DOC"
	_cQuery += _cEnter + "AND D1_SERIE = F1_SERIE"
	_cQuery += _cEnter + "AND D1_FORNECE = F1_FORNECE"
	_cQuery += _cEnter + "AND D1_LOJA = F1_LOJA"
	_cQuery += _cEnter + "AND ((A2_TIPO = 'J' AND D1_BASEIRR > 0) OR A2_TIPO = 'F')"		////////?????????????????????????????????
	_cQuery += _cEnter + "AND D1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND F1_DOC = E2_NUM"
	_cQuery += _cEnter + "AND F1_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + "AND F1_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND F1_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND F1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2_FORNECE <> '000008'"
	_cQuery += _cEnter + "AND ((A2_TIPO = 'F' AND E2.E2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "') OR (A2_TIPO <> 'F' AND E2.E2_EMIS1 BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'))"
	_cQuery += _cEnter + "AND E2.E2_TIPO <> 'TX'"
	_cQuery += _cEnter + "AND F1_FORMUL <> 'S'"
	//_cQuery += _cEnter + "AND (E2.E2_PARCIR <> '' OR (A2_TIPO = 'F' AND E2.E2_PARCINS <> ''))"
	If !empty(mv_par04)
		_cQuery += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "'"
	EndIf
	_cQuery += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "

	_cQuery += _cEnter + "UNION"
	_cQuery += _cEnter + "SELECT DISTINCT CODIGO, A2_CGC, SUBSTRING(E2.E2_EMISSAO,1,6) XEMISSAO, E2.E2_INSS, A2_TIPO, E2.E2_VENCREA, E2.E2_FORNECE, E2.E2_LOJA, "
	_cQuery += _cEnter + "E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_TIPO, E2.E2_VALOR, E2.E2_SALDO, E2.E2_NATUREZ, E2.R_E_C_N_O_, E2.E2_PARCIR, E2.E2_PARCINS, E2.E2_EMISSAO, E2.E2_EMIS1, E2.E2_VENCTO, E2.E2_BAIXA, E2.E2_MSFIL,"
	_cQuery += _cEnter + "F1_VALBRUT"
	_cQuery += _cEnter + "FROM " + RetSqlName('SE2')  + " E2 (NOLOCK), "
	_cQuery += _cEnter + "("
	_cQuery += _cEnter + "SELECT DISTINCT E2.E2_INSS, A2_TIPO, A2_CGC, E2.E2_VENCREA, E2.E2_FORNECE, E2.E2_LOJA, CASE WHEN A2_TIPO = 'F' THEN '0588' ELSE CASE WHEN A2_NOME LIKE '%COOPERATIVA%' THEN '3280' ELSE CASE WHEN B1_DESC LIKE '%COMISSOES%' THEN '8045' ELSE '1708' END END END CODIGO,"
	_cQuery += _cEnter + "E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_TIPO, E2.E2_VALOR, E2.E2_SALDO, E2.E2_NATUREZ, E2.R_E_C_N_O_, E2.E2_PARCIR, E2.E2_PARCINS, E2.E2_EMISSAO, E2.E2_EMIS1, E2.E2_VENCTO, E2.E2_BAIXA, "
	_cQuery += _cEnter + "F1_VALBRUT"

	_cQuery += _cEnter + "FROM " + RetSqlName('SA2')  + " A2 (NOLOCK), " + RetSqlName('SE2')  + " E2 (NOLOCK), " + RetSqlName('SF1')  + " F1 (NOLOCK), " + RetSqlName('SD1')  + " D1 (NOLOCK), " + RetSqlName('SB1')  + " B1 (NOLOCK), " + _XYQuery

	_cQuery += _cEnter + "WHERE FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND A2_COD = E2_FORNECE"
	_cQuery += _cEnter + "AND A2_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND B1_COD = D1_COD"
	_cQuery += _cEnter + "AND A2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND B1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND D1_FILIAL = F1_FILIAL"
	_cQuery += _cEnter + "AND ((A2_TIPO = 'J' AND D1_BASEIRR > 0) OR A2_TIPO = 'F')"		////////?????????????????????????????????
	_cQuery += _cEnter + "AND D1_DOC = F1_DOC"
	_cQuery += _cEnter + "AND D1_SERIE = F1_SERIE"
	_cQuery += _cEnter + "AND D1_FORNECE = F1_FORNECE"
	_cQuery += _cEnter + "AND D1_LOJA = F1_LOJA"
	_cQuery += _cEnter + "AND D1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND F1_DOC = E2_NUM"
	_cQuery += _cEnter + "AND F1_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + "AND F1_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND F1_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND F1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2_FORNECE <> '000008'"
	_cQuery += _cEnter + "AND E2_MATRIZ = '" + mv_par09 + "'"
	_cQuery += _cEnter + "AND ((A2_TIPO = 'F' AND E2.E2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "') OR (A2_TIPO <> 'F' AND E2.E2_EMIS1 BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'))"
	_cQuery += _cEnter + "AND E2.E2_TIPO <> 'TX'"
	If !empty(mv_par04)
		_cQuery += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "'"
	EndIf
	_cQuery += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "

	_cQuery += _cEnter + ") A"
	_cQuery += _cEnter + "WHERE E2.E2_PREFIXO = A.E2_PREFIXO"
	_cQuery += _cEnter + "AND E2.E2_NUM = A.E2_NUM"
	_cQuery += _cEnter + "AND ((E2.E2_TIPO = 'TX' AND E2.E2_PARCELA = A.E2_PARCIR AND E2.E2_FORNECE = '000008') OR "
	_cQuery += _cEnter + "(E2.E2_TIPO = 'INS' AND E2.E2_PARCELA = A.E2_PARCINS AND E2.E2_FORNECE = '000007'))"
	_cQuery += _cEnter + "AND E2.D_E_L_E_T_ = ''
	If mv_par07 == 1
		_cQuery += _cEnter + "ORDER BY CODIGO, A2_CGC, XEMISSAO, E2_NUM, E2_PREFIXO, E2.R_E_C_N_O_"
	Else
		_cQuery += _cEnter + "ORDER BY CODIGO, A2_CGC, E2_NUM, E2_PREFIXO, E2.R_E_C_N_O_"
	EndIf
	
	U_GravaQuery('RETENCIR.sql',_cquery)
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'XE2',.f.,.f.)},'Buscando informações de títulos com retenção (IRRF)')
	TcSetField('xE2' , 'E2_EMISSAO'	, 'D' )
	TcSetField('xE2' , 'E2_EMIS1'	, 'D' )
	TcSetField('xE2' , 'E2_VENCREA'	, 'D' )
	TcSetField('xE2' , 'E2_BAIXA'	, 'D' )
	Count to _nLast2
	DbGoTop()
	
EndIf

If mv_par03 == 3 .or. mv_par03 == 4	/// INSS
	
	_cQuery := "SELECT DISTINCT E2.E2_FORNECE FORNECE, E2.E2_LOJA LOJA"
	_cQuery += _cEnter + "FROM " + RetSqlName('SA2')  + " A2 (NOLOCK), " + RetSqlName('SE2')  + " E2 (NOLOCK)"
	_cQuery += _cEnter + "WHERE A2_COD = E2_FORNECE"
	_cQuery += _cEnter + "AND A2_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND A2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2_FORNECE <> '000007'"
	_cQuery += _cEnter + "AND E2.E2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
	_cQuery += _cEnter + "AND E2.E2_TIPO <> 'TX'"
	If !empty(mv_par04)
		_cQuery += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "'"
	EndIf
	_cQuery += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "
	
	_xyQuery := '(' + _cQuery + ') X '
	
	_cQuery := "SELECT DISTINCT D1_SERIE, A2_NOME, A2_TIPO CODIGO, "
	_cQuery += _cEnter + "A2_CGC, SUBSTRING(E2.E2_EMISSAO,1,6) XEMISSAO, E2.E2_INSS, A2_TIPO, E2.E2_VENCREA, E2.E2_FORNECE, E2.E2_LOJA, "
	_cQuery += _cEnter + "E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_TIPO, E2.E2_VALOR, E2.E2_SALDO, E2.E2_NATUREZ, E2.R_E_C_N_O_, E2.E2_PARCINS, "
	_cQuery += _cEnter + "E2.E2_EMISSAO, E2.E2_EMIS1, E2.E2_VENCTO, "
	_cQuery += _cEnter + "CASE WHEN (F1_BASEINS = 0 AND A2_TIPO = 'F') THEN F1_VALBRUT ELSE F1_BASEINS END F1_BASEINS, E2.E2_MSFIL, F1_VALBRUT "
	
	_cQuery += _cEnter + "FROM " + RetSqlName('SA2')  + " A2 (NOLOCK), " + RetSqlName('SE2')  + " E2 (NOLOCK), " + RetSqlName('SF1')  + " F1 (NOLOCK), " + RetSqlName('SD1')  + " D1 (NOLOCK), " + RetSqlName('SB1')  + " B1 (NOLOCK), " + _XYQuery
	_cQuery += _cEnter + "WHERE FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND A2_COD = E2_FORNECE"
	_cQuery += _cEnter + "AND A2_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND B1_COD = D1_COD"
	_cQuery += _cEnter + "AND B1_TIPO IN ('SV','GG')"
	_cQuery += _cEnter + "AND A2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND B1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND D1_FILIAL = F1_FILIAL"
	_cQuery += _cEnter + "AND D1_DOC = F1_DOC"
	_cQuery += _cEnter + "AND D1_SERIE = F1_SERIE"
	_cQuery += _cEnter + "AND D1_FORNECE = F1_FORNECE"
	_cQuery += _cEnter + "AND D1_LOJA = F1_LOJA"
	_cQuery += _cEnter + "AND D1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND F1_DOC = E2_NUM"
	_cQuery += _cEnter + "AND F1_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + "AND F1_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND F1_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND F1_ESPECIE <> 'PC'"
	_cQuery += _cEnter + "AND (F1_BASEINS > 0 OR A2_TIPO = 'F')"
	_cQuery += _cEnter + "AND F1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2_FORNECE <> '000007'"
	_cQuery += _cEnter + "AND E2.E2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
	_cQuery += _cEnter + "AND E2.E2_TIPO <> 'TX'"
	_cQuery += _cEnter + "AND F1_FORMUL <> 'S'"
	If !empty(mv_par04)
		_cQuery += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "'"
	EndIf
	_cQuery += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "
	
	_cQuery += _cEnter + "UNION"
	_cQuery += _cEnter + "SELECT DISTINCT D1_SERIE, A2_NOME, CODIGO, A2_CGC, SUBSTRING(E2.E2_EMISSAO,1,6) XEMISSAO, E2.E2_INSS, A2_TIPO, E2.E2_VENCREA, E2.E2_FORNECE, E2.E2_LOJA, "
	_cQuery += _cEnter + "E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_TIPO, E2.E2_VALOR, E2.E2_SALDO, E2.E2_NATUREZ, E2.R_E_C_N_O_,  E2.E2_PARCINS, E2.E2_EMISSAO, E2.E2_EMIS1, E2.E2_VENCTO, "
	_cQuery += _cEnter + "F1_BASEINS, E2.E2_MSFIL, F1_VALBRUT "
	_cQuery += _cEnter + "FROM " + RetSqlName('SE2')  + " E2 (NOLOCK), "
	_cQuery += _cEnter + "("
	_cQuery += _cEnter + "SELECT DISTINCT D1_SERIE, A2_NOME, E2.E2_INSS, A2_TIPO, A2_CGC, E2.E2_VENCREA, E2.E2_FORNECE, E2.E2_LOJA, A2_TIPO CODIGO,"
	_cQuery += _cEnter + "E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_TIPO, E2.E2_VALOR, E2.E2_SALDO, E2.E2_NATUREZ, E2.R_E_C_N_O_, E2.E2_PARCINS, E2.E2_EMISSAO, E2.E2_EMIS1, E2.E2_VENCTO, E2.E2_BAIXA, "
	_cQuery += _cEnter + "CASE WHEN (F1_BASEINS = 0 AND A2_TIPO = 'F') THEN F1_VALBRUT ELSE F1_BASEINS END F1_BASEINS, E2.E2_MSFIL, F1_VALBRUT"
	_cQuery += _cEnter + "FROM " + RetSqlName('SA2')  + " A2 (NOLOCK), " + RetSqlName('SE2')  + " E2 (NOLOCK), " + RetSqlName('SF1')  + " F1 (NOLOCK), " + RetSqlName('SD1')  + " D1 (NOLOCK), " + RetSqlName('SB1')  + " B1 (NOLOCK), " + _XYQuery
	
	_cQuery += _cEnter + "WHERE FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND A2_COD = E2_FORNECE"
	_cQuery += _cEnter + "AND A2_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND B1_COD = D1_COD"
	_cQuery += _cEnter + "AND B1_TIPO IN ('SV','GG')"
	_cQuery += _cEnter + "AND A2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND B1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND D1_FILIAL = F1_FILIAL"
	_cQuery += _cEnter + "AND D1_DOC = F1_DOC"
	_cQuery += _cEnter + "AND D1_SERIE = F1_SERIE"
	_cQuery += _cEnter + "AND D1_FORNECE = F1_FORNECE"
	_cQuery += _cEnter + "AND D1_LOJA = F1_LOJA"
	_cQuery += _cEnter + "AND D1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND F1_DOC = E2_NUM"
	_cQuery += _cEnter + "AND F1_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + "AND F1_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND F1_LOJA = E2_LOJA"
	_cQuery += _cEnter + "AND F1_ESPECIE <> 'PC'"
	_cQuery += _cEnter + "AND (F1_BASEINS > 0 OR A2_TIPO = 'F')"
	_cQuery += _cEnter + "AND F1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E2_FORNECE <> '000007'"
	_cQuery += _cEnter + "AND E2.E2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
	_cQuery += _cEnter + "AND E2.E2_TIPO <> 'TX'"
	If !empty(mv_par04)
		_cQuery += _cEnter + "AND E2.E2_FORNECE = '" + mv_par04 + "'"
	EndIf
	_cQuery += _cEnter + "AND E2.E2_MATRIZ = '" + mv_par09 + "' "
	
	_cQuery += _cEnter + ") A"
	_cQuery += _cEnter + "WHERE E2.E2_PREFIXO = A.E2_PREFIXO"
	_cQuery += _cEnter + "AND E2.E2_NUM = A.E2_NUM"
	_cQuery += _cEnter + "AND ((E2.E2_TIPO = 'TX' AND E2.E2_PARCELA = A.E2_PARCINS AND E2.E2_FORNECE = '000007') OR "
	_cQuery += _cEnter + "(E2.E2_TIPO = 'INS' AND E2.E2_PARCELA = A.E2_PARCINS AND E2.E2_FORNECE = '000007'))"
	_cQuery += _cEnter + "AND E2.D_E_L_E_T_ = ''
	
	If mv_par07 == 1
		_cQuery += _cEnter + "ORDER BY CODIGO, E2_MSFIL, A2_NOME, XEMISSAO, E2_NUM, E2_PREFIXO, E2.R_E_C_N_O_"
	Else
		_cQuery += _cEnter + "ORDER BY CODIGO, E2_MSFIL, A2_NOME, E2_NUM, E2_PREFIXO, E2.R_E_C_N_O_"
	EndIf
	
	U_GravaQuery('RETENCINS.sql',_cquery)
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'XE3',.f.,.f.)},'Buscando informações de títulos com retenção (INSS)')
	TcSetField('xE3' , 'E2_EMISSAO'	, 'D' )
	TcSetField('xE3' , 'E2_EMIS1'	, 'D' )
	TcSetField('xE3' , 'E2_VENCREA'	, 'D' )
	TcSetField('xE3' , 'E2_BAIXA'	, 'D' )
	Count to _nLast3
	DbGoTop()
	
EndIf

SetRegua(_nLast1 + _nLast2 + _nLast3)

_nPis := 0
_nCof := 0
_nCsl := 0
_nTb1 := 0

If mv_par03 == 2 .or. mv_par03 == 4
	
	_nPis := 0
	_nCof := 0
	_nCsl := 0
	_nTb1 := 0
	
	Cabec1        := "Codigo  Nome Fornecedor                           CNPJ                Prf  Numero  P  Tp   Natureza   Emissao     Vencimento   Base Retencao                                Impostos                       Filial"
	Cabec2        := "                                                                                                                                               Vencimento         Pis      Cofins        CSLL       Total"
	//                009113  1234567890123456789012345678901234567890  07.026.648/0001-86       000025  X  NF   1102140    02/05/2006  04/05/2006  999.999.999.99   11/11/1111  999.999.99  999.999.99  999.999.99  999.999.99
	DbSelectArea('_E2')
	
	Do While !EOF()
		
		_cFornece := left(_E2->A2_CGC,8)
		_nTBase   := 0
		_nTPis    := 0
		_nTCof    := 0
		_nTCsl    := 0
		_xDATA    := iif(mv_par07 == 1,_E2->E2_DATA,'')
		Do While !eof() .and. _cFornece == left(_E2->A2_CGC,8)
			IncRegua()
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			If nLin > 55
				Cabec(Titulo + ' PIS/COFINS/CSLL ('+ dtoc(mv_par01) + ' a ' + dtoc(mv_par02) + ')',Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			_nBase  := max(_E2->E2_BASEPIS,_E2->E2_BASECOF)
			_nBase  := max(_nBase, _E2->E2_BASECSL)
			_nTBase += _nBase
			//Local Cabec1        := "Codigo  Nome Fornecedor                           CNPJ                Prf  Numero  P  Tp   Natureza   Emissao     Vencimento   Base Retencao    Impostos"
			//                        009113  1234567890123456789012345678901234567890  07.026.648/0001-86       000025  X  NF   1102140    02/05/2006  04/05/2006  999.999.999.99
			
			_cLinha  := _E2->E2_FORNECE + '  ' + _E2->A2_NOME + '  ' + tran(Posicione('SA2',3,xFilial('SA2') + _E2->A2_CGC,'A2_CGC'),'@R 99.999.999/9999-99') + '  '
			_cTLinha := _cLinha
			If mv_par05 == 1
				If mv_par07 == 1
					_cLinha += '   Periodo: ' + right(_E2->E2_DATA,2) + '/' + left(_E2->E2_DATA,4) + space(37)
				Else
					_cLinha += space(56)
				EndIf
				_cLinha += tran(_nBase,'@E 999,999,999.99') + '               '
			Else
				_cLinha += _E2->E2_PREFIXO + '  ' + _E2->E2_NUM + '  ' + _E2->E2_PARCELA + '  ' + _E2->E2_TIPO + '  '
				_cLinha += _E2->E2_NATUREZ + ' ' + dtoc(_E2->E2_EMIS1) + '  ' + dtoc(_E2->E2_VENCREA) + '  ' + tran(_nBase,'@E 999,999,999.99') + '   '
				If !empty(_E2->E2_PARCPIS)
					_cLinha += dtoc(Posicione('SE2',1,xFilial('SE2') + _E2->E2_PREFIXO + _E2->E2_NUM + _E2->E2_PARCPIS + 'TX','E2_VENCTO')) + '  '
				ElseIf !empty(_E2->E2_PARCCOF)
					_cLinha += dtoc(Posicione('SE2',1,xFilial('SE2') + _E2->E2_PREFIXO + _E2->E2_NUM + _E2->E2_PARCCOF + 'TX','E2_VENCTO')) + '  '
				ElseIf !empty(_E2->E2_PARCCOF)
					_cLinha += dtoc(Posicione('SE2',1,xFilial('SE2') + _E2->E2_PREFIXO + _E2->E2_NUM + _E2->E2_PARCSLL + 'TX','E2_VENCTO')) + '  '
				Else
					_cLinha += space(12)
				EndIf
			EndIf
			
			_nRet  := 0
			_xPis  := 0
			_xCof  := 0
			_xCsl  := 0
			
			_nTB1  += _nBase
			
			_nTCSL += _E2->E2_VRETCSL
			_nCSL  += _E2->E2_VRETCSL
			_xCsl  := _E2->E2_VRETCSL
			_nRet  += _E2->E2_VRETCSL
			
			_nTCof += _E2->E2_VRETCOF
			_nCof  += _E2->E2_VRETCOF
			_xCof  := _E2->E2_VRETCOF
			_nRet  += _E2->E2_VRETCOF
			
			_nTPis += _E2->E2_VRETPIS
			_nPis  += _E2->E2_VRETPIS
			_xPis  := _E2->E2_VRETPIS
			_nRet  += _E2->E2_VRETPIS
			
			If mv_par05 == 1
				_cLinha += tran(_xPis,'@E 999,999.99') + '  ' + tran(_xCof,'@E 999,999.99') + '  ' + tran(_xCsl,'@E 999,999.99') + '  '
				@ ++nLin,00 pSay _cLinha + tran(_nRet,'@E 999,999.99')
			Else
				_cLinha += tran(_E2->E2_VRETPIS,'@E 999,999.99') + '  ' + tran(_E2->E2_VRETCOF,'@E 999,999.99') + '  ' + tran(_E2->E2_VRETCSL,'@E 999,999.99') + '  ' + tran(_E2->E2_VRETPIS+_E2->E2_VRETCOF+_E2->E2_VRETCSL,'@E 999,999.99')
				@ ++nLin,00 pSay _cLinha + '  ' + _E2->E2_MSFIL
			EndIf
			DbSkip()
		EndDo
		
		If mv_par07 == 1
			_cLinha := 'Total do Periodo: ' + space(108)
			_cLinha += tran(_nTBase,'@E 999,999,999.99')+ '               ' + tran(_nTPis,'@E 999,999.99') + '  ' + tran(_nTCof,'@E 999,999.99') + '  ' + tran(_nTCsl,'@E 999,999.99') + '  ' + tran(_nTCsl+_nTPis+_nTCof,'@E 999,999.99')
			@ ++nLin,00 pSay _cLinha
			@ ++nLin,00 pSay __PrtThinLine()
		EndIf
		
	EndDo
	@ ++nLin,000 pSay __PrtThinLine()
	// 999,999.000,00                999.999.99 ,00          240,00           80,00        0,00
	_cLinha := tran(_nTB1,'@E 999,999,999.99') + '               ' + tran(_nPis,'@E 999,999.99') + '  ' + tran(_nCof,'@E 999,999.99') + '  ' + tran(_nCsl,'@E 999,999.99') + '  ' + tran(_nCsl+_nPis+_nCof,'@E 999,999.99')
	@ ++nLin,000 pSay 'Total Geral'
	@   nLin,126 pSay _cLinha
	@ ++nLin,000 pSay __PrtThinLine()
	
	DbCloseArea()
EndIf                        

nLin := 100

_cCodReten := ''
If mv_par06 == 1
	_cCodReten := '0588'
ElseIf mv_par06 == 2
	_cCodReten := '8045'
ElseIf mv_par06 == 3
	_cCodReten := '1708'
ElseIf mv_par06 == 4
	_cCodReten := '3280'
EndIf

If mv_par03 == 1 .or. mv_par03 == 4
	
	Cabec1        := "Codigo/Lj  Nome Fornecedor                           CNPJ                Prf  Numero  P  Tp   Natureza   Emissao     Vencimento       Base IRRF         Impostos                        Filial"
	Cabec2        := "                                                                                                                                                    Vencimento        IRRF        INSS"
	//                009113 01  1234567890123456789012345678901234567890  07.026.648/0001-86       000025  X  NF   1102140    02/05/2006  04/05/2006  999.999.999.99     11/11/1111  999.999.99  999.999.99
	DbSelectArea('XE2')
	DbGoTop()
	_nTGIrrf := 0
	_nTGInss := 0
	Do While !EOF()
		
		If (mv_par06 <> 5 .and. !(XE2->CODIGO $ _cCodReten)) 
			Do While !(XE2->CODIGO $ _cCodReten) .and. !eof()
				IncRegua()
				DbSkip()
			EndDo
			loop
		EndIf
		
		If nLin == 100
			Cabec(Titulo + ' IRRF ('+ dtoc(mv_par01) + ' a ' + dtoc(mv_par02) + ')',Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8         
		EndIf
		
		_cCodigo := XE2->CODIGO
		@ ++nLin,000 pSay 'Codigo da retencao ' + _cCodigo
		@ ++nLin,000 pSay __PrtThinLine()
		_nTotCod  := 0
		_nTotBas  := 0
		_nTotInss := 0   
		_nBaseAno := 0
		_nIrrfAno := 0
		_nInssAno := 0  
		Do While !EOF() .and. _cCodigo == XE2->CODIGO
			
			If XE2->CODIGO <> '0588' .and. empty(XE2->E2_PARCIR)
				IncRegua()
				DbSkip()
				loop
			EndIf
			
			_cLinha   := ''
			_cFornece := left(XE2->A2_CGC,8)
			_nTBase   := 0
			_nTIrrf   := 0
			_nTInss   := 0
			_nBaseMes := 0
			_nIrrfMes := 0
			_nInssMes := 0
			_cMes     := XE2->XEMISSAO
			_aLinhas := {}
			Do While !eof() .and. _cFornece == left(XE2->A2_CGC,8) .and. ((mv_par07 == 1 .and. _cMes == XE2->XEMISSAO) .or. mv_par07 == 2)
			
				IncRegua()

				If XE2->CODIGO <> '0588' .and. empty(XE2->E2_PARCIR)
					DbSkip()
					loop
				EndIf
			
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
				
				If nLin > 55
					Cabec(Titulo + ' IRRF/INSS ('+ dtoc(mv_par01) + ' a ' + dtoc(mv_par02) + ')',Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				/*
				If mv_par07 == 1 .and. _cMes <> XE2->XEMISSAO
					
					@ ++nLin,000 pSay __PrtThinLine()
					_cLinha := tran(_nBaseMes,'@E 999,999,999.99') + '                ' + tran(_nIrrfMes,'@E 999,999.99') + '  ' + tran(_nInssMes,'@E@Z 999,999.99')
					@ ++nLin,000 pSay 'Total do Mes ' + _cMes
					@   nLin,130 pSay _cLinha
					@ ++nLin,000 pSay __PrtThinLine()
					_nBaseMes := 0
					_nIrrfMes := 0
					_nInssMes := 0
					_cMes     := XE2->XEMISSAO
				EndIf				
				*/
				//Local Cabec1        := "Codigo/Lj  Nome Fornecedor                           CNPJ                Prf  Numero  P  Tp   Natureza   Emissao     Vencimento     Valor Bruto    Impostos"
				//                        009113 01  1234567890123456789012345678901234567890  07.026.648/0001-86       000025  X  NF   1102140    02/05/2006  04/05/2006  999.999.999.99
				
				_cLinha  := XE2->E2_FORNECE + ' ' + XE2->E2_LOJA + '  ' + Posicione('SA2',1,xFilial('SA2') + XE2->E2_FORNECE + XE2->E2_LOJA,'A2_NOME') + '  ' + tran(SA2->A2_CGC,iif(SA2->A2_TIPO=='F','@R 999.999.999-999999','@R 99.999.999/9999-99')) + '  '
				_xLinha  := _cLinha + space(57)
				_xLinMes := _cLinha + space(10) + tran(_cMes,'@R 9999/99') + space(40)
				_xLinAno := _cLinha + space(10) + tran(_cMes,'@R 9999') + space(43)
				_cLinha  += XE2->E2_PREFIXO + '  ' + XE2->E2_NUM + '  ' + XE2->E2_PARCELA + '  ' + XE2->E2_TIPO + '  '
				_cLinha  += XE2->E2_NATUREZ + '  ' + dtoc(XE2->E2_EMISSAO) + '  ' + dtoc(XE2->E2_VENCREA) + ' '
				_cLinha  += tran(XE2->F1_VALBRUT,'@E 999,999,999.99') + '     '
				
				_nTotBas  += XE2->F1_VALBRUT
				_nTb1     += XE2->F1_VALBRUT
				_cParcela := XE2->E2_PARCIR
				_nTBase   += XE2->F1_VALBRUT
				_nINSS    := iif(_cCodigo == '0588', XE2->E2_INSS,0)
				_nTINSS   += _nINSS
				_nTGInss  += _nINSS
				_nTotInss += _nINSS
				_nBaseMes += XE2->F1_VALBRUT
				_nINSSMes += _nINSS
				_cMsFil   := XE2->E2_MSFIL
				DbSkip()
				_cLinha += dtoc(XE2->E2_VENCREA) + '  '
				
				_xIRRF := 0
				If alltrim(XE2->E2_TIPO) == 'TX' .and. _cParcela == XE2->E2_PARCELA .and. alltrim(XE2->E2_NATUREZ) == '1102073'
					
					_nTotCod  += XE2->E2_VALOR
					_nTGIrrf  += XE2->E2_VALOR
					_xIRRF    := XE2->E2_VALOR
					_nTIRRF   += XE2->E2_VALOR
					_nIRRFMes += XE2->E2_VALOR
					DbSkip()
					
				EndIf
				
				If alltrim(XE2->E2_TIPO) == 'INS'
					DbSkip()  
				EndIf
				
				If mv_par05 == 2
					_cLinha += tran(_xIRRF,'@E 999,999.99') + '  ' + tran(_nInss,'@E 999,999.99')
					@ ++nLin,00 pSay _cLinha   + '      ' + _cMsFil
				Else
					_cLinha := _xLinha
					_cLinha += tran(_nTBase,'@E 999,999,999.99') + space(16)
					_cLinha += tran(_nTIRRF,'@E 999,999.99') + '  ' + tran(_nTInss,'@E 999,999.99')
				EndIf
				
			EndDo

			If mv_par07 == 1
					
				_cLinha := _xLinMes + tran(_nBaseMes,'@E 999,999,999.99') + '                ' + tran(_nIrrfMes,'@E 999,999.99') + '  ' + tran(_nInssMes,'@E 999,999.99')
				@ ++nLin,000 pSay _cLinha	//'Total do Mes ' + _cMes
				//@   nLin,130 pSay _cLinha
				_nBaseAno += _nBaseMes 
				_nIrrfAno += _nIrrfMes 
				_nInssAno += _nInssMes 
				_nBaseMes := 0
				_nIrrfMes := 0
				_nInssMes := 0  
				_cLinha   := ''
			
				If _cFornece <> left(XE2->A2_CGC,8)
					_cLinha := _xLinAno + tran(_nBaseAno,'@E 999,999,999.99') + '                ' + tran(_nIrrfAno,'@E 999,999.99') + '  ' + tran(_nInssAno,'@E 999,999.99')
					@ ++nLin,000 pSay _cLinha	//'Total do Mes ' + _cMes
					@ ++nLin,000 pSay __PrtThinLine()
					_nBaseAno := 0
					_nIrrfAno := 0
					_nInssAno := 0  
					_cLinha   := ''
				EndIf 
			
			EndIf	  						
	
			If mv_par05 == 1 .and. !empty(_cLinha)
				@ ++nLin,000 pSay _cLinha
			EndIF
			
		EndDo
		
		@ ++nLin,000 pSay __PrtThinLine()
		_cLinha := tran(_nTotBas,'@E 999,999,999.99') + '                ' + tran(_nTotCod,'@E 999,999.99') + '  ' + tran(_nTotInss,'@E 999,999.99')
		@ ++nLin,000 pSay 'Total do Codigo ' + _cCodigo
		@   nLin,130 pSay _cLinha
		@ ++nLin,000 pSay __PrtThinLine()
		
	EndDo
	
	@ ++nLin,000 pSay __PrtThinLine()
	_cLinha := tran(_nTB1,'@E 999,999,999.99') + '                ' + tran(_nTGIrrf,'@E 999,999.99') + '  ' + tran(_nTGInss,'@E 999,999.99')
	@ ++nLin,000 pSay 'Total Geral'
	@   nLin,130 pSay _cLinha
	@ ++nLin,000 pSay __PrtThinLine()
	
	DbCloseArea()
EndIf

nLin := 100

If mv_par03 == 3 .or. mv_par03 == 4	// INSS
	
	Cabec1        := "Codigo/Lj  Nome Fornecedor                           CNPJ/PIS            Prf  Numero  P  Tp   Cto Custo        Emissao     Vencimento       Base INSS         Impostos      Filial  Servico"
	Cabec2        := "                                                                                                                                                        Vencimento        INSS"
	//                009113 01  1234567890123456789012345678901234567890  07.026.648/0001-86       000025  X  NF   1102140    02/05/2006  04/05/2006  999.999.999.99     11/11/1111  999.999.99
	DbSelectArea('XE3')
	DbGoTop()
	_nTGInss := 0
	Do While !EOF()
		
		If nLin == 100
			Cabec(Titulo + ' INSS ('+ dtoc(mv_par01) + ' a ' + dtoc(mv_par02) + ')',Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIf
		
		_cCodigo := XE3->CODIGO
		@ ++nLin,000 pSay 'Pessoas ' + iif(_cCodigo == 'F', 'Fisicas','Juridicas')
		@ ++nLin,000 pSay __PrtThinLine()
		_nTotCod  := 0
		_nTotBas  := 0
		_nTotInss := 0
		_nBaseAno := 0
		_nInssAno := 0
		Do While !EOF() .and. _cCodigo == XE3->CODIGO
			
			_cLinha   := ''
			_cFornece := left(XE3->A2_CGC,iif(_cCodigo == 'F',11,8))
			_nTBase   := 0
			_nTInss   := 0
			_nBaseMes := 0
			_nInssMes := 0
			_cMes     := XE3->XEMISSAO
			_aLinhas  := {}
			_nTIFil   := 0
			_nTbFil   := 0
			Do While !eof()  .and. _cCodigo == XE3->CODIGO//.and. _cFornece == left(XE3->A2_CGC,8) .and. ((mv_par07 == 1 .and. _cMes == XE3->XEMISSAO) .or. mv_par07 == 2)
				
				IncRegua()
				
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
				
				If nLin > 55
					Cabec(Titulo + ' INSS ('+ dtoc(mv_par01) + ' a ' + dtoc(mv_par02) + ')',Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				_cLinha  := XE3->E2_FORNECE + ' ' + XE3->E2_LOJA + '  ' + Posicione('SA2',1,xFilial('SA2') + XE3->E2_FORNECE + XE3->E2_LOJA,'A2_NOME') + '  ' + tran(SA2->A2_CGC,'@R 99.999.999/9999-99') + '  '
				_xLinha  := _cLinha + space(57)
				_xLinMes := _cLinha + space(10) + tran(_cMes,'@R 9999/99') + space(40)
				_xLinAno := _cLinha + space(10) + tran(_cMes,'@R 9999') + space(43)
				_cLinha  += XE3->E2_PREFIXO + '  ' + XE3->E2_NUM + '  ' + XE3->E2_PARCELA + '  ' + XE3->E2_TIPO + '  '
				_D1_CC := Posicione('SD1',1, XE3->E2_MSFIL + XE3->E2_NUM + XE3->D1_SERIE + XE3->E2_FORNECE + XE3->E2_LOJA,'D1_CC')
				If empty(_D1_CC)
					_D1_CC := left(Posicione('SDE',1, XE3->E2_MSFIL + XE3->E2_NUM + XE3->D1_SERIE + XE3->E2_FORNECE + XE3->E2_LOJA,'DE_CC'),5) + space(10)
				EndIf
				_cLinha  += iif(XE3->CODIGO == 'J',space(14), _D1_CC) + '  '
				_cLinha  += dtoc(XE3->E2_EMISSAO) + '  ' + dtoc(XE3->E2_VENCREA) + ' '
				_cLinha  += tran(XE3->F1_BASEINS,'@E 999,999,999.99') + '     '
				
				_nTotBas  += XE3->F1_BASEINS
				_nTb1     += XE3->F1_BASEINS
				_cParcela := XE3->E2_PARCINS
				_nTBase   += XE3->E2_INSS
				_nINSS    := XE3->E2_INSS
				_nTINSS   += _nINSS
				_nTGInss  += _nINSS
				_nTotInss += _nINSS
				_nBaseMes += XE3->F1_BASEINS
				_nINSSMes += _nINSS
				
				
				_nTbFil  += XE3->F1_BASEINS
				_nTIFil  += XE3->E2_INSS
				_cFil    := XE3->E2_MSFIL
				_cNotaFis := XE3->E2_MSFIL + XE3->E2_NUM + XE3->D1_SERIE + XE3->E2_FORNECE + XE3->E2_LOJA
				
				DbSkip()
				_cLinha += dtoc(XE3->E2_VENCREA) + '  '
				
				If alltrim(XE3->E2_TIPO) == 'INS' .and. _cParcela == XE3->E2_PARCELA .and. alltrim(XE3->E2_NATUREZ) == '1102076'
					
					_nTotCod  += XE3->E2_VALOR
					DbSkip()
					
				EndIf
				
				If alltrim(XE3->E2_TIPO) == 'TX'
					DbSkip()
				EndIf
				
				If mv_par05 == 2
					_cLinha += tran(_nInss,'@E 999,999.99')                          
					
					_xQuery := "SELECT B1_DESC"
					_xQuery += " FROM " + RetSqlName('SB1')  + " SB1 (NOLOCK), " + RetSqlName('SD1')  + " SD1 (NOLOCK)"
					_xQuery += " WHERE B1_COD = D1_COD"
					_xQuery += " AND D1_DOC = '" 	 + SD1->D1_DOC     + "'"
					_xQuery += " AND D1_SERIE = '" 	 + SD1->D1_SERIE   + "'"
					_xQuery += " AND D1_FORNECE = '" + SD1->D1_FORNECE + "'"
					_xQuery += " AND D1_LOJA = '" 	 + SD1->D1_LOJA    + "'"
					_xQuery += " AND D1_FILIAL = '"  + SD1->D1_FILIAL   + "'"
					_xQuery += " AND B1_TIPO IN ('SV','GG')"
					
					_cAlias := Alias()
					DbUseArea(.t.,'TOPCONN',TcGenQry(,,_xQuery),'_SB1',.f.,.f.)					
					_cDesc := _SB1->B1_DESC					                                        
					DbCloseArea()     
					DbSelectArea(_cAlias)     
					
					_cDesc := iif(empty(_cDesc), Posicione('SB1',1,xFilial('SB1') + Posicione('SD1',1,_cNotaFis,'D1_COD'),'B1_DESC'), _cDesc)
					@ ++nLin,00 pSay _cLinha  + '  ' + _cFil + '  ' + left(_cDesc,40) 
					If XE3->E2_MSFIL <> _cFil
						@ ++nLin,00 pSay __PrtThinLine()
						_cLinha := 'Totais - Filial: ' + _cFil + space(114) + tran(_nTBFil,'@E 999,999,999.99') + space(13) +  tran(_nTIFil,'@E 999,999,999.99')
						@ ++nLin,00 pSay _cLinha
						@ ++nLin,00 pSay __PrtThinLine()
						_nTIFil   := 0
						_nTbFil   := 0
					EndIf
					
				Else
					_cLinha := _xLinha
					_cLinha += tran(_nTBase,'@E 999,999,999.99') + space(16)
					_cLinha += '  ' + tran(_nTInss,'@E 999,999.99')
				EndIf
				
			EndDo
			
			If mv_par07 == 1
				
				_cLinha := _xLinMes + tran(_nBaseMes,'@E 999,999,999.99') + '                  ' + tran(_nInssMes,'@E 999,999.99')
				@ ++nLin,000 pSay _cLinha
				_nBaseAno += _nBaseMes
				_nInssAno += _nInssMes
				_nBaseMes := 0
				_nInssMes := 0
				_cLinha   := ''
				
				If _cFornece <> left(XE3->A2_CGC,iif(_cCodigo == 'F',11,8))
					_cLinha := _xLinAno + tran(_nBaseAno,'@E 999,999,999.99') + '                  ' + tran(_nInssAno,'@E 999,999.99')
					@ ++nLin,000 pSay _cLinha	//'Total do Mes ' + _cMes
					@ ++nLin,000 pSay __PrtThinLine()
					_nBaseAno := 0
					_nInssAno := 0
					_cLinha   := ''
				EndIf
				
			EndIf
			
			If mv_par05 == 1 .and. !empty(_cLinha)
				@ ++nLin,000 pSay _cLinha
			EndIF
			
		EndDo
		
		@ ++nLin,000 pSay __PrtThinLine()
		_cLinha := tran(_nTotBas,'@E 999,999,999.99') + '                      ' + tran(_nTotInss,'@E 999,999.99')
		@ ++nLin,000 pSay 'Total das Pessoas ' + iif(_cCodigo == 'F', 'Fisicas','Juridicas')
		@   nLin,130 pSay _cLinha
		@ ++nLin,000 pSay __PrtThinLine()
		
	EndDo
	
	@ ++nLin,000 pSay __PrtThinLine()
	_cLinha := tran(_nTB1,'@E 999,999,999.99') + '                      ' + tran(_nTGInss,'@E 999,999.99')
	@ ++nLin,000 pSay 'Total Geral'
	@   nLin,130 pSay _cLinha
	@ ++nLin,000 pSay __PrtThinLine()
	
	DbCloseArea()
EndIf

If aReturn[5]==1
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
///////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Data de         ","","", "mv_ch1", "D",  8 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "02", "Data ate        ","","", "mv_ch2", "D",  8 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "03", "Retenções       ","","", "mv_ch3", "N",  1 , 0, 0, "C", "", "mv_par03", "IRRF", "", "", "", "", "PIS/Cofins/CSLL", "", "", "", "", "INSS", "", "", "", "", "Ambos", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Fornecedor      ","","", "mv_ch4", "C",  6 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "SA2",""})
aAdd( aPerg , { cPerg, "05", "Forma Relatório ","","", "mv_ch5", "N",  1 , 0, 0, "C", "", "mv_par05", "Sintético", "", "", "", "", "Analítico", "", "", "", "", "Ambas", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "06", "Código do IRRF  ","","", "mv_ch6", "N",  1 , 0, 0, "C", "", "mv_par06", "0588", "", "", "", "", "8045", "", "", "", "", "1708", "", "", "", "", "3280", "", "", "", "", "Todos", "", "",""})
aAdd( aPerg , { cPerg, "07", "Total por mês?  ","","", "mv_ch7", "N",  1 , 0, 0, "C", "", "mv_par07", "Sim", "", "", "", "", "Não", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "08", "Tipo da data ?  ","","", "mv_ch8", "N",  1 , 0, 0, "C", "", "mv_par08", "Vencimento", "", "", "", "", "Baixa", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "09", "Filial          ","","", "mv_ch9", "C",  2 , 0, 0, "G", "", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "SM0"})

DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
	For j := 1 to (FCount())
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j, aPerg[i, j])
		Endif
	Next
	MsUnlock()
Next

RestArea(_aAlias)

Return

/*

*1-	Deve aparecer o valor do INSS no Cód 0588 IRRF
*2-	Deve imprimir separadamente os Cód 0588, 1708 e 8045
*3-	Não pode aparecer o titulo união
*4-	O n° do CPF deve aparecer em formato CPF
5-	Deve puxar todos os valores dos títulos do fornecedor dentro do mês,
e apresentar como base do imposto no cód 0588
*6-	Deve permitir a impressão do fornecedor anual mas separa por 12 meses

Vazio().Or.
(Cgc(M->A2_CGC).And. IIF(__CUSERID == '000487',.T.,(Existchav("SA2",M->A2_CGC,3,"A2_CGC"))))

Vazio().Or.IIF(__CUSERID == '000487',.T.,(Cgc(M->A2_CGC).And.(Existchav("SA2",M->A2_CGC,3,"A2_CGC"))))



