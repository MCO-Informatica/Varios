////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Atualiza o TRANSITO de acordo com os fornecedores contidos no array aFornece ***************************************************** //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User FUnction LS_AJTRANS()


MsAguarde({|lEnd| RunProc()},"Aguarde...","Atualizando Transito...",.T.)
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ********************************************************************************************************************************** //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
_cQuery :=""

_cQuery +=" update  SB2010  SET B2_XTRANSI= TRANSITO FROM ( "

_cQuery +="  SELECT FILIAL,PROD,SUM(QUANT)AS TRANSITO ,LOC FROM ( "
_cQuery +=" select D2_COD AS PROD,CASE "
_cQuery +="     WHEN B2_FILIAL IN ('01','55')THEN "
_cQuery +=" SUM(D2_QUANT) ELSE SUM(D2_QUANT) END   AS QUANT,SUM(B2_XTRANSI) AS TRANS,  "
_cQuery +=" D2_LOCAL AS LOC,B2_FILIAL AS FILIAL   "
_cQuery +=" FROM SD2010 D2  (NOLOCK) "
_cQuery +=" INNER JOIN SF2010 F2 (NOLOCK) "
_cQuery +=" 	ON D2.D2_DOC=F2.F2_DOC AND D2.D2_CLIENTE=F2.F2_CLIENTE AND D2.D2_LOJA=F2.F2_LOJA "
_cQuery +=" 	AND D2.D2_FILIAL=F2.F2_FILIAL AND F2_TIPO='N'ANd F2.D_E_L_E_T_ 	= '' "
_cQuery +=" INNER JOIN SB2010 B2  (NOLOCK) "
_cQuery +=" 	ON D2.D2_COD=B2.B2_COD AND D2.D2_LOJA=B2.B2_FILIAL AND D2.D2_LOCAL=B2.B2_LOCAL and B2.D_E_L_E_T_ 	= '' "
_cQuery +=" INNER JOIN SF4010 SF4 (NOLOCK) "
_cQuery +=" 	ON SF4.D_E_L_E_T_ 	= '' AND F4_CODIGO 		= D2_TES "

_cQuery +=" WHERE D2.D2_EMISSAO>='20151201' AND D2.D2_CLIENTE< '000009' and D2.D_E_L_E_T_ 	= '' "
_cQuery +=" GROUP BY D2_COD  ,D2_LOCAL,B2_FILIAL "


_cQuery +=" UNION ALL "
_cQuery +=" select D1_COD AS PROD, "

_cQuery +=" CASE "
_cQuery +="     WHEN B2_FILIAL IN ('01','55') THEN "
_cQuery +=" +SUM(D1_QUANT) ELSE -SUM(D1_QUANT) END   AS QUANT,SUM(B2_XTRANSI) AS TRANS, "
_cQuery +=" D1_LOCAL AS LOC,B2_FILIAL AS FILIAL "
_cQuery +=" FROM SD1010 D1 "
_cQuery +=" INNER JOIN SF1010 F1 (NOLOCK) "
_cQuery +=" 	ON D1.D1_DOC=F1.F1_DOC AND D1.D1_FORNECE=F1.F1_FORNECE AND D1.D1_LOJA=F1.F1_LOJA "
_cQuery +=" 	AND D1.D1_FILIAL=F1.F1_FILIAL AND F1.F1_TIPO='N'ANd F1.D_E_L_E_T_ 	= '' "
_cQuery +=" INNER JOIN SB2010 B2 "
_cQuery +=" 	ON D1.D1_COD=B2.B2_COD AND D1.D1_LOJA=B2.B2_FILIAL AND D1.D1_LOCAL=B2.B2_LOCAL and B2.D_E_L_E_T_ 	= '' "
_cQuery +=" INNER JOIN SF4010 SF4 (NOLOCK) "
_cQuery +=" 	ON SF4.D_E_L_E_T_ 	= '' AND F4_CODIGO 		= D1_TES "

_cQuery +=" WHERE D1.D1_EMISSAO>='20160101' AND D1.D1_FORNECE< '000009'  and D1.D_E_L_E_T_ 	= '' "
_cQuery +=" GROUP BY  D1_COD  ,D1_LOCAL,B2_FILIAL "
_cQuery +=" )TRANS1 WHERE QUANT>0 "
_cQuery +=" GROUP BY FILIAL,PROD,LOC )TRANS "
_cQuery +=" WHERE B2_FILIAL=TRANS.FILIAL AND B2_COD=TRANS.PROD AND B2_LOCAL=TRANS.LOC "

TcSqlExec(_cQuery)   

_cQuery:=""
_cQuery +=" update  SB2010  SET B2_SALPEDI=0,B2_XTRANSI=0 WHERE B2_SALPEDI<0 "

TcSqlExec(_cQuery) 

_cQuery:=""

_cQuery +=" update  SB2010  SET B2_XRESERV= RESERVA FROM (  "

_cQuery +="  SELECT FILIAL,PROD,SUM(QUANT)AS RESERVA ,LOC FROM (  "
_cQuery +=" select C6.C6_PRODUTO AS PROD,
_cQuery +="    SUM(C6.C6_QTDVEN)  AS QUANT,SUM(B2.B2_XRESERV) AS RESERVA,   "
_cQuery +=" C6.C6_LOCAL AS LOC,C6.C6_LOJA AS FILIAL    "
_cQuery +=" FROM SC6010 C6  (NOLOCK)  "
_cQuery +=" INNER JOIN SC5010 C5 (NOLOCK)  "
_cQuery +=" 	ON C5.C5_FILIAL=C6.C6_FILIAL AND C5.C5_CLIENTE=C6.C6_CLI AND C5.C5_LOJACLI=C6.C6_LOJA AND C5_NUM=C6.C6_NUM "
_cQuery +=" INNER JOIN SB2010 B2  (NOLOCK)  "
_cQuery +=" 	ON C6.C6_PRODUTO=B2.B2_COD AND C6.C6_LOJA=B2.B2_FILIAL AND C6.C6_LOCAL=B2.B2_LOCAL and B2.D_E_L_E_T_ 	= ''  "
_cQuery +=" INNER JOIN SF4010 SF4 (NOLOCK)  "
_cQuery +=" 	ON SF4.D_E_L_E_T_ 	= '' AND F4_CODIGO = C6.C6_TES and F4_ESTOQUE='S' "

_cQuery +=" WHERE C6.C6_NOTA='' AND C6.C6_CLI< '000009' and C6.D_E_L_E_T_ = '' AND C5_TIPO='N' and C5_EMISSAO>='20160219' "
_cQuery +=" GROUP BY C6.C6_PRODUTO  ,C6.C6_LOCAL,C6.C6_LOJA )TRANS1  "
_cQuery +=" GROUP BY FILIAL,PROD,LOC )TRANS  "
_cQuery +=" WHERE B2_FILIAL=TRANS.FILIAL AND B2_COD=TRANS.PROD AND B2_LOCAL=TRANS.LOC   "

TcSqlExec(_cQuery) 


 MsProcTxt("Lendo ......")

Return()
