#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
//Static cBDPROT	:= "Totvs12_Producao"
Static cBVGstq	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

/*                                             
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ CtaPgGstq ∫ Autor ≥ SÈrgio Santana       ∫ Data ≥03/10/2014∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Importacao Base de Dados                                   ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ALTERACAO ≥                                                            ∫±± 
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ ThermoGlass                                                ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
//U_CtaPgGstq( '  ', '20160801', '20161231' , ' ' )

User Function CtaPgGstq( _pTipo, _cDtIni, _cDtFim, _cPgt, _nConcil )
Local cDebug 	 := ""
DEFAULT _pTipo   := '  '
DEFAULT _cPgt    := ' '
DEFAULT _cDtIni  := DtoS( dDataBase - 50 )
DEFAULT _cDtFim  := DtoS( dDataBase + 180 )
DEFAULT _nConcil := 2

PRIVATE _cFilSA2 := xFilial( 'SA2' )

PutMV("MV_PCNFE",.F.)

If _pTipo <> 'BV'

   _qTit := 'WITH CTAPAG'+CRLF
   _qTit += '(ID_VENCTITULO, ID_NOTA, CNPJCLI,cCgc,E2_FILIAL,E2_FORNECE,E2_NOMFOR,E2_NUM,E2_PARCELA, E2_TIPO, E2_SERIE,E2_VALOR,E2_EMISSAO,E2_VENCTO,E2_CONTA,E2_NATUREZ,E2_PORTADO,E2_BAIXA,E2_SALDO,E2_HIST,E2_PAGO,E2_DESCONT,E2_ACRESC,E2_JUROS,E2_NUMCHEQ,E2_DTCONC,E2_CHQEMI,E2_TPLANC, ID_TITULO, ID_BAIXADOC, E2_ORIGBD) AS '+CRLF
   _qTit += '('+CRLF
   _qTit += ' SELECT  '+CRLF
   _qTit +=   ' VENCTIT.ID_VENCTITULO,'+CRLF
   _qTit +=   ' ISNULL(NOTA.ID_NOTA_COMPRA, ISNULL( NSRV.ID_NOTA_COMPRA, 0 ) ) ID_NOTA,'+CRLF
   _qTit +=   " CAST( REPLACE(REPLACE(REPLACE(CLIENTE.CPFCGC,'.',''),'/',''),'-','') AS VARCHAR(14) ) CNPJCLI, "+CRLF
   _qTit +=   " CAST( REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') AS VARCHAR(14) ) cCgc,"+CRLF
   _qTit +=   " Case TITULO.ID_EMPRESA when 1 Then '0101' When 2 Then '0102' When 3 Then '0201' When 4 Then '0601' When 5 Then '0103' When 6 Then '0202' When 7 Then '0301' When 8 Then '0401' When 9 Then '0501' When 15 Then '0215' When 12 Then '0701' When 13 Then '9001' When 16 Then '0801' Else '0000' End E2_FILIAL,"+CRLF
   _qTit +=   ' TITULO.ID_CLIENTE E2_FORNECE,  '+CRLF
   _qTit +=   " LEFT(CLIENTE.FANTASIA, CHARINDEX(' ',CLIENTE.FANTASIA)) E2_NOMFOR,"+CRLF

   _qTit +=   " CAST( CASE"+CRLF
   _qTit +=    " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4)"+CRLF
   _qTit +=    " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4)"+CRLF 
   _qTit +=    " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -3)" +CRLF
   _qTit +=    " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -3)" +CRLF
   _qTit +=    " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4)" +CRLF
   _qTit +=    " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -2) ELSE VENCTIT.DOC"+CRLF
   _qTit +=   " END AS VARCHAR(10)) E2_NUM,"+CRLF

   _qTit +=   ' CASE '+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN ' ' "+CRLF 
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN ' ' "+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN ' ' "+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN ' ' "+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN ' ' "+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN "+CRLF 
   _qTit +=     " CASE"+CRLF
   _qTit +=       " WHEN RIGHT(VENCTIT.DOC, 1) = 'A' THEN RIGHT(VENCTIT.DOC, 1)"+CRLF
   _qTit +=       " ELSE"+CRLF
   _qTit +=        " CASE ISNUMERIC( SUBSTRING(RIGHT(VENCTIT.DOC, 2),1,1) ) WHEN 0"+CRLF
   _qTit +=          " THEN "+CRLF
   _qTit +=            " CASE"+CRLF
   _qTit +=             " WHEN ISNULL(NOTA.ID_NOTA_COMPRA,0) <> 0 THEN RIGHT(VENCTIT.DOC, 1)"+CRLF
   _qTit +=             " WHEN CONVERT(CHAR(8),VENCTIT.CADASTRO,112) > '20160604' AND VENCTIT.ID_TITULO NOT IN (109070,109062,108822) THEN RIGHT(VENCTIT.DOC, 1)"+CRLF
   _qTit +=             " ELSE SUBSTRING(RIGHT(VENCTIT.DOC, 2),1,1) "+CRLF
   _qTit +=            " END "+CRLF
   _qTit +=          " ELSE RIGHT(VENCTIT.DOC, 1)"+CRLF
   _qTit +=        " END"+CRLF
   _qTit +=     " END"+CRLF
   _qTit +=     " ELSE ' '"+CRLF
   _qTit +=     " END E2_PARCELA,"+CRLF
   
   _qTit +=   ' CASE '+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN 'IRF'"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN 'INS'"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN 'ISS'"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN 'PCC'"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN 'GNR'"+CRLF
   _qTit +=     " ELSE 'NF'"+CRLF
   _qTit +=    ' END'+CRLF
   _qTit +=    ' E2_TIPO,'+CRLF
   _qTit +=    ' CAST(NOTA.SERIE AS CHAR(3)) E2_SERIE,'+CRLF  
   _qTit +=    ' VENCTIT.VALOR E2_VALOR,'+CRLF
   _qTit +=    ' CONVERT(CHAR(8),VENCTIT.EMISSAO,112) E2_EMISSAO,'+CRLF
   _qTit +=    ' CONVERT(CHAR(8),VENCTIT.VENCIMENTO,112) E2_VENCTO,'   +CRLF  
   _qTit +=    " CAST(REPLACE(PLANO.CODIGO,'.','') AS CHAR(12)) E2_CONTA,"+CRLF
   _qTit +=    " CAST(ISNULL(OPER.NATUREZA,'99999') AS CHAR(8)) E2_NATUREZ,"+CRLF
//   _qTit +=    " CAST(REPLICATE( '0', 3 - LEN( CAST(ISNULL(CONTA.ID_CONTA,999) AS VARCHAR(3)))) + CAST(ISNULL(CONTA.ID_CONTA,999) AS VARCHAR(3)) AS CHAR(3)) E2_PORTADO, "
   _qTit +=    " ISNULL(CONTA.ID_CONTA,999) E2_PORTADO, "+CRLF
   _qTit +=    " ISNULL(CONVERT( CHAR(8),BAIXA.DATA,112),'        ') E2_BAIXA, "+CRLF
   _qTit +=    " ISNULL(VENCTIT.SALDO,0) E2_SALDO, "+CRLF
   _qTit +=    " ISNULL(TITULO.referencia,' ') E2_HIST,"+CRLF
   _qTit +=    " ISNULL(BAIXA.VALOR,0) E2_PAGO, "+CRLF
   _qTit +=    " ISNULL(VENCTIT.DESCONTO,0) E2_DESCONT, "+CRLF
   _qTit +=    " ISNULL(VENCTIT.OUTRAS_DESP,0) E2_ACRESC, "+CRLF
   _qTit +=    " ISNULL(VENCTIT.JUROS,0) E2_JUROS, "+CRLF
   _qTit +=    " ISNULL(BAIXA.ID_CHEQUE, 0 ) E2_NUMCHEQ, "+CRLF
   _qTit +=    " ISNULL(CONVERT( CHAR(8), CHEQUE.DTCONCILIADO, 112), ' ' ) E2_DTCONC, "+CRLF
   _qTit +=    " ISNULL(CONVERT( CHAR(8), CHEQUE.EMISSAO     , 112), ' ' ) E2_CHQEMI, "+CRLF
   _qTit +=    " ISNULL(TITULO.TP_LANC, 0)  E2_TPLANC, "+CRLF
   _qTit +=    ' VENCTIT.ID_TITULO ID_TITULO, '+CRLF
   _qTit +=    ' ISNULL(BAIXA.ID_BAIXADOC,0) ID_BAIXADOC, '+CRLF
   _qTit +=    " 'G' E2_ORIGBD "+CRLF //Montes - 06/05/2019
   _qTit +=   'FROM ['+cBDGSTQ+'].[dbo].[VENCTITULO] VENCTIT '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[TITULO] ON (TITULO.ID_TITULO = VENCTIT.ID_TITULO) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PLANO]  ON (VENCTIT.ID_DEBITO = PLANO.ID_PLANO) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CLIENTE] ON (CLIENTE.ID_CLIENTE = TITULO.ID_CLIENTE) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OPER ON (OPER.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[BAIXA_PARCIAL] BAIXA ON (BAIXA.ID_VENCTITULO = VENCTIT.ID_VENCTITULO) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CHEQUE] CHEQUE ON (CHEQUE.ID_CHEQUE = BAIXA.ID_CHEQUE) AND (CHEQUE.ID_CONTA = BAIXA.ID_CONTA) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CONTA] ON (CONTA.ID_CONTA = BAIXA.ID_CONTA) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[EMPRESA] EMP ON (EMP.ID_EMPRESA = TITULO.ID_EMPRESA) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[NOTA_COMPRA] NOTA ON (NOTA.ID_TITULO = TITULO.ID_TITULO) AND (NOTA.ID_EMPRESA = TITULO.ID_EMPRESA) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[NOTA_COMPRA] NSRV ON (NSRV.ID_TITULO = TITULO.ID_TITULO_PAI) AND (NSRV.ID_EMPRESA = TITULO.ID_EMPRESA) '+CRLF
   //_qTit += "WHERE ISNULL(NOTA.CFO, NSRV.CFO) not like '%SERV%'  "+CRLF
   _qTit += "WHERE VENCTIT.DOC LIKE '%GNRE%' "+CRLF
   _qTit +=  " AND ((CONVERT( CHAR(8), VENCTIT.VENCIMENTO, 112 ) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') OR (ISNULL(CONVERT( CHAR(8),BAIXA.DATA,112),'        ') BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') "+CRLF
   _qTit +=  " OR (CHEQUE.ID_CHEQUE IS NOT NULL AND CONVERT(CHAR(8), CHEQUE.DTCONCILIADO, 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "')) "+CRLF
   _qTit +=  " AND (TITULO.TIPOTITULO = 0) AND (VENCTIT.PAGO <> 'C') AND (ISNULL(BAIXA.ID_ADIANTAMENTO_COMPENSACAO,0) = 0)) "+CRLF
   _qTit += 'SELECT '+CRLF
   _qTit +=   'CTAPAG.ID_VENCTITULO,'+CRLF
   _qTit +=   'CTAPAG.ID_NOTA,'+CRLF
   _qTit +=   'CTAPAG.CNPJCLI,'+CRLF
   _qTit +=   'CTAPAG.cCgc,'+CRLF
   _qTit +=   'CTAPAG.E2_FILIAL,'+CRLF
   _qTit +=   'CTAPAG.E2_FORNECE,'+CRLF
   _qTit +=   'CTAPAG.E2_NOMFOR,'+CRLF
   _qTit +=   'CAST( CASE WHEN LEN( CTAPAG.E2_NUM ) > 8 THEN SUBSTRING( CTAPAG.E2_NUM, 2, 9) ELSE CTAPAG.E2_NUM END AS VARCHAR(10))  E2_NUM,'+CRLF
   _qTit +=   'CTAPAG.E2_PARCELA,'+CRLF
   _qTit +=   'CASE '+CRLF
   _qTit +=    " WHEN CTAPAG.E2_TIPO IN ('IRF','ISS', 'INS', 'PCC') THEN CTAPAG.E2_TIPO "+CRLF
   _qTit +=    " WHEN CTAPAG.E2_TIPO = 'GNR' THEN 'TX '"+CRLF
   _qTit +=    " WHEN CTAPAG.E2_SERIE IS NULL THEN 'BOL'"+CRLF
   _qTit +=    ' ELSE CTAPAG.E2_TIPO '+CRLF
   _qTit +=   'END E2_TIPO,'+CRLF
   _qTit +=   "ISNULL(CTAPAG.E2_SERIE, ' ') E2_SERIE,"+CRLF
   _qTit +=   'CTAPAG.E2_VALOR,'+CRLF
   _qTit +=   'CTAPAG.E2_EMISSAO,'+CRLF
   _qTit +=   'CTAPAG.E2_VENCTO,'+CRLF
   _qTit +=   'CTAPAG.E2_CONTA,'+CRLF
   _qTit +=   'CTAPAG.E2_NATUREZ,'+CRLF
//   _qTit +=   'CTAPAG.E2_PORTADO,'
   _qTit +=   'SA6.A6_COD E2_PORTADO,'+CRLF
   _qTit +=   'SA6.A6_AGENCIA, '+CRLF
   _qTit +=   'SA6.A6_NUMCON, '+CRLF
   _qTit +=   'CTAPAG.E2_BAIXA,'   +CRLF
   _qTit +=   'CTAPAG.E2_SALDO,'+CRLF
   _qTit +=   'CTAPAG.E2_HIST, '+CRLF
   _qTit +=   'CTAPAG.E2_PAGO, '+CRLF                               
   _qTit +=   'CTAPAG.E2_DESCONT, '+CRLF   
   _qTit +=   'CTAPAG.E2_ACRESC, '+CRLF   
   _qTit +=   'CTAPAG.E2_JUROS, '+CRLF   
   _qTit +=   'CTAPAG.E2_NUMCHEQ, '+CRLF   
   _qTit +=   'CTAPAG.E2_DTCONC, '+CRLF
   _qTit +=   'CTAPAG.E2_CHQEMI, '+CRLF
   _qTit +=   'CTAPAG.E2_TPLANC, '   +CRLF
   _qTit +=   'CTAPAG.ID_TITULO, '+CRLF
   _qTit +=   'CTAPAG.ID_BAIXADOC, '+CRLF
   _qTit +=   'CTAPAG.E2_ORIGBD '   +CRLF
   _qTit += 'FROM CTAPAG '+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] EMP ON REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') = CTAPAG.CNPJCLI "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA6010] SA6 ON CTAPAG.E2_PORTADO = SA6.A6_IDCONTA "+CRLF
   _qTit += 'where EMP.CGC Is Null'+CRLF
   _qTit += " and not exists (select E2_IDMOV FROM SE2010 SE2 WHERE D_E_L_E_T_ = '' AND E2_IDMOV = REPLICATE('0', 10 - LEN(CAST(ID_VENCTITULO AS VARCHAR(10)))) + CAST(ID_VENCTITULO AS VARCHAR(10))"+CRLF
   _qTit += " AND SE2.E2_FORNECE <> 'UNIAO ' "+CRLF
   _qTit += " AND (SE2.E2_BAIXA = CTAPAG.E2_BAIXA) AND (CAST(SE2.E2_FORNECE AS INT) = E2_FORNECE) )"               	+CRLF

Else

   _qTit := 'WITH CTAPAG'+CRLF
   _qTit += '(ID_VENCTITULO, ID_NOTA, CNPJCLI,cCgc,E2_FILIAL,E2_FORNECE,E2_NOMFOR,E2_NUM,E2_PARCELA, E2_TIPO, E2_SERIE,E2_VALOR,E2_EMISSAO,E2_VENCTO,E2_CONTA,E2_NATUREZ,E2_PORTADO,E2_BAIXA,E2_SALDO,E2_HIST,E2_DESCONT, E2_ACRESC,E2_JUROS,E2_NUMCHEQ,E2_DTCONC,E2_CHQEMI,E2_TPLANC,ID_TITULO,E2_ORIGBD) AS '+CRLF
   _qTit += '('+CRLF
   _qTit += ' SELECT  '+CRLF
   _qTit +=   ' VENCTIT.ID_VENCTITULO,'+CRLF
   _qTit +=   ' ISNULL(NOTA.ID_NOTA_COMPRA, ISNULL( NSRV.ID_NOTA_COMPRA, 0 ) ) ID_NOTA,'+CRLF
   _qTit +=   " CAST( REPLACE(REPLACE(REPLACE(CLIENTE.CPFCGC,'.',''),'/',''),'-','') AS VARCHAR(14) ) CNPJCLI, "+CRLF
   _qTit +=   " CAST( REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') AS VARCHAR(14) ) cCgc,"+CRLF
   _qTit +=   " Case TITULO.ID_EMPRESA when 1 Then '0101' When 2 Then '0102' When 3 Then '0201' When 4 Then '0601' When 5 Then '0103' When 6 Then '0202' When 7 Then '0301' When 8 Then '0401' When 9 Then '0501' When 15 Then '0215' When 12 Then '0701' When 13 Then '9001' when 16 then '0801' Else '0000' End E2_FILIAL,"+CRLF
   _qTit +=   ' TITULO.ID_CLIENTE E2_FORNECE,  '+CRLF
   _qTit +=   " LEFT(CLIENTE.FANTASIA, CHARINDEX(' ',CLIENTE.FANTASIA)) E2_NOMFOR,"+CRLF
   _qTit +=   ' CAST( CASE '+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4)"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4)"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -3)"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -3)"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4)"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -2)"+CRLF
   _qTit +=     ' ELSE VENCTIT.DOC '+CRLF
   _qTit +=   ' END AS VARCHAR(10)) E2_NUM,'+CRLF

   _qTit +=   ' CASE '+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN ' '"+CRLF 
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN ' ' "+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN ' ' "+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN ' ' "+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN ' ' "+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN"+CRLF 
   _qTit +=     " CASE"+CRLF
   _qTit +=       " WHEN RIGHT(VENCTIT.DOC, 1) = 'A' THEN RIGHT(VENCTIT.DOC, 1)"+CRLF
   _qTit +=       " ELSE"+CRLF
   _qTit +=        " CASE ISNUMERIC( SUBSTRING(RIGHT(VENCTIT.DOC, 2),1,1) ) WHEN 0"+CRLF
   _qTit +=          " THEN "+CRLF
   _qTit +=            " CASE"+CRLF
   _qTit +=             " WHEN ISNULL(NOTA.ID_NOTA_COMPRA,0) <> 0 THEN RIGHT(VENCTIT.DOC, 1)"+CRLF
   _qTit +=             " WHEN CONVERT(CHAR(8),VENCTIT.CADASTRO,112) > '20160604' AND VENCTIT.ID_TITULO NOT IN (109070,109062,108822) THEN RIGHT(VENCTIT.DOC, 1)"+CRLF
   _qTit +=             " ELSE SUBSTRING(RIGHT(VENCTIT.DOC, 2),1,1) "+CRLF
   _qTit +=            " END "+CRLF
   _qTit +=          " ELSE RIGHT(VENCTIT.DOC, 1)"+CRLF
   _qTit +=        " END"+CRLF
   _qTit +=     " END"+CRLF
   _qTit +=     " ELSE ' '"+CRLF
   _qTit +=     " END E2_PARCELA,"+CRLF

   _qTit +=   ' CASE '+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN 'IRF'"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN 'INS'"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN 'ISS'"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN 'PCC'"+CRLF
   _qTit +=     " WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN 'GNR'"+CRLF
   _qTit +=     " ELSE 'NF'"+CRLF
   _qTit +=    ' END'+CRLF
   _qTit +=    ' E2_TIPO,'+CRLF
   _qTit +=    ' CAST(NOTA.SERIE AS CHAR(3)) E2_SERIE,'+CRLF  
   _qTit +=    ' VENCTIT.VALOR E2_VALOR,'+CRLF
   _qTit +=    ' CONVERT(CHAR(8),VENCTIT.EMISSAO,112) E2_EMISSAO,'+CRLF
   _qTit +=    ' CONVERT(CHAR(8),VENCTIT.VENCIMENTO,112) E2_VENCTO,'   +CRLF  
   _qTit +=    " CAST(REPLACE(PLANO.CODIGO,'.','') AS CHAR(12)) E2_CONTA,"+CRLF
   _qTit +=    " CAST(ISNULL(OPER.NATUREZA,'99999') AS CHAR(8)) E2_NATUREZ,"+CRLF
//   _qTit +=    " CAST(REPLICATE( '0', 3 - LEN( CAST(ISNULL(CONTA.ID_CONTA,999) AS VARCHAR(3)))) + CAST(ISNULL(CONTA.ID_CONTA,999) AS VARCHAR(3)) AS CHAR(3)) E2_PORTADO, "
    _qTit +=    " ISNULL(CONTA.ID_CONTA,999) E2_PORTADO, "+CRLF
   _qTit +=    " ISNULL(CONVERT( CHAR(8),BAIXA.DATA,112),'        ') E2_BAIXA, "+CRLF
   _qTit +=    " ISNULL(VENCTIT.SALDO,0) E2_SALDO, "+CRLF
   _qTit +=    " ISNULL(TITULO.referencia,' ') E2_HIST,"+CRLF
   _qTit +=    " ISNULL(BAIXA.VALOR,0) E2_PAGO,"+CRLF
   _qTit +=    " ISNULL(VENCTIT.DESCONTO,0) E2_DESCONT, "+CRLF
   _qTit +=    " ISNULL(VENCTIT.OUTRAS_DESP,0) E2_ACRESC, "+CRLF
   _qTit +=    " ISNULL(VENCTIT.JUROS,0) E2_JUROS, "+CRLF
   _qTit +=    " ISNULL(BAIXA.ID_CHEQUE, 0 ) E2_NUMCHEQ, "+CRLF
   _qTit +=    " ISNULL(CONVERT( CHAR(8), CHEQUE.DTCONCILIADO, 112), ' ' ) E2_DTCONC, "+CRLF
   _qTit +=    " ISNULL(CONVERT( CHAR(8), CHEQUE.EMISSAO     , 112), ' ' ) E2_CHQEMI, "+CRLF
   _qTit +=    " ISNULL(TITULO.TP_LANC, 0)  E2_TPLANC, "+CRLF
   _qTit +=   ' VENCTIT.ID_TITULO ID_TITULO '+CRLF
   _qTit +=   ' ISNULL(BAIXA.ID_BAIXADOC,0) ID_BAIXADOC, '+CRLF
   _qTit +=   " 'G' E2_ORIGBD " //Montes - 06/05/2019
   _qTit +=   'FROM ['+cBVGstq+'].[dbo].[VENCTITULO] VENCTIT '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBVGstq+'].[dbo].[TITULO] ON TITULO.ID_TITULO = VENCTIT.ID_TITULO '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PLANO]  ON VENCTIT.ID_DEBITO = PLANO.ID_PLANO '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CLIENTE] ON CLIENTE.ID_CLIENTE = TITULO.ID_CLIENTE '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OPER ON OPER.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[BAIXA_PARCIAL] BAIXA ON BAIXA.ID_VENCTITULO = VENCTIT.ID_VENCTITULO '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CHEQUE] CHEQUE ON (CHEQUE.ID_CHEQUE = BAIXA.ID_CHEQUE) AND (CHEQUE.ID_CONTA = BAIXA.ID_CONTA) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CONTA] ON CONTA.ID_CONTA = BAIXA.ID_CONTA '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[EMPRESA] EMP ON EMP.ID_EMPRESA = TITULO.ID_EMPRESA '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[NOTA_COMPRA] NOTA ON (NOTA.ID_TITULO = TITULO.ID_TITULO) AND (NOTA.ID_EMPRESA = TITULO.ID_EMPRESA) '+CRLF
   _qTit +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[NOTA_COMPRA] NSRV ON (NSRV.ID_TITULO = TITULO.ID_TITULO_PAI) AND (NSRV.ID_EMPRESA = TITULO.ID_EMPRESA) '+CRLF
   _qTit += "WHERE ISNULL(NOTA.CFO, NSRV.CFO) not like '%SERV%'  "+CRLF
   _qTit +=  " AND ((CONVERT( CHAR(8), VENCTIT.VENCIMENTO, 112 ) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') OR (ISNULL(CONVERT( CHAR(8),BAIXA.DATA,112),'        ') BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') "+CRLF
   _qTit +=  " OR (CHEQUE.ID_CHEQUE IS NOT NULL AND CONVERT(CHAR(8), CHEQUE.DTCONCILIADO, 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "')) "+CRLF
   _qTit +=  " AND (TITULO.TIPOTITULO = 0) AND (VENCTIT.PAGO <> 'C') AND (ISNULL(BAIXA.ID_ADIANTAMENTO_COMPENSACAO,0) = 0)) "+CRLF
   _qTit += 'SELECT '+CRLF
   _qTit +=   'CTAPAG.ID_VENCTITULO,'+CRLF
   _qTit +=   'CTAPAG.ID_NOTA,'+CRLF
   _qTit +=   'CTAPAG.CNPJCLI,'+CRLF
   _qTit +=   'CTAPAG.cCgc,'+CRLF
   _qTit +=   'CTAPAG.E2_FILIAL,'+CRLF
   _qTit +=   'CTAPAG.E2_FORNECE,'+CRLF
   _qTit +=   'CTAPAG.E2_NOMFOR,'+CRLF
   _qTit +=   'CAST( CASE WHEN LEN( CTAPAG.E2_NUM ) > 8 THEN SUBSTRING( CTAPAG.E2_NUM, 2, 9) ELSE CTAPAG.E2_NUM END AS VARCHAR(10)) E2_NUM,'+CRLF
   _qTit +=   'CTAPAG.E2_PARCELA,'+CRLF
   _qTit +=   'CASE '+CRLF
   _qTit +=    " WHEN CTAPAG.E2_TIPO IN ('IRF','ISS', 'INS', 'PCC') THEN CTAPAG.E2_TIPO "+CRLF
   _qTit +=    " WHEN CTAPAG.E2_TIPO = 'GNR' THEN 'TX '"+CRLF
   _qTit +=    " WHEN CTAPAG.E2_SERIE IS NULL THEN 'BOL'"+CRLF
   _qTit +=    ' ELSE CTAPAG.E2_TIPO '+CRLF
   _qTit +=   'END E2_TIPO,'+CRLF
   _qTit +=   "ISNULL(CTAPAG.E2_SERIE, ' ') E2_SERIE,"+CRLF
   _qTit +=   'CTAPAG.E2_VALOR,'+CRLF
   _qTit +=   'CTAPAG.E2_EMISSAO,'+CRLF
   _qTit +=   'CTAPAG.E2_VENCTO,'+CRLF
   _qTit +=   'CTAPAG.E2_CONTA,'+CRLF
   _qTit +=   'CTAPAG.E2_NATUREZ,'+CRLF
//   _qTit +=   'CTAPAG.E2_PORTADO, '
   _qTit +=   'SA6.A6_COD E2_PORTADO,'+CRLF
   _qTit +=   'SA6.A6_AGENCIA, '+CRLF
   _qTit +=   'SA6.A6_NUMCON, '+CRLF
   _qTit +=   'CTAPAG.E2_BAIXA,'   +CRLF
   _qTit +=   'CTAPAG.E2_SALDO,'+CRLF
   _qTit +=   'CTAPAG.E2_HIST,'+CRLF
   _qTit +=   'CTAPAG.E2_PAGO,'+CRLF
   _qTit +=   'CTAPAG.E2_DESCONT, ' +CRLF  
   _qTit +=   'CTAPAG.E2_ACRESC, '   +CRLF
   _qTit +=   'CTAPAG.E2_JUROS, '   +CRLF
   _qTit +=   'CTAPAG.E2_NUMCHEQ, '   +CRLF
   _qTit +=   'CTAPAG.E2_DTCONC, '+CRLF
   _qTit +=   'CTAPAG.E2_CHQEMI, '+CRLF
   _qTit +=   'CTAPAG.E2_TPLANC, '   +CRLF
   _qTit +=   'CTAPAG.ID_TITULO, '+CRLF
   _qTit +=   'CTAPAG.ID_BAIXADOC, '+CRLF
   _qTit +=   'CTAPAG.E2_ORIGBD '+CRLF
   _qTit += 'FROM CTAPAG '            +CRLF                                                                      
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] EMP ON REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') = CTAPAG.CNPJCLI "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA6010] SA6 ON CTAPAG.E2_PORTADO = SA6.A6_IDCONTA "+CRLF
   _qTit += 'where EMP.CGC Is Null'+CRLF
   _qTit += " and not exists (select E2_IDMOV FROM SE2010 WHERE D_E_L_E_T_ = '' AND E2_IDMOV = REPLICATE('0', 10 - LEN(CAST(ID_VENCTITULO AS VARCHAR(10)))) + CAST(ID_VENCTITULO AS VARCHAR(10))"+CRLF
   _qTit += " AND SE2.E2_FORNECE <> 'UNIAO ' "+CRLF
   _qTit += " AND (SE2.E2_BAIXA = CTAPAG.E2_BAIXA) AND (CAST(SE2.E2_FORNECE AS INT) = E2_FORNECE) )"+CRLF

End

_qTit += " AND ( CTAPAG.ID_NOTA > 0 OR RIGHT(E2_HIST,4) = 'GNRE' )"

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qTit),"TIT",.T.,.T.)

TIT->( dbGoTop() )
SE2->( dbSetOrder( 1 ) )
SA2->( dbSetOrder( 1 ) )

SE5->( dbSetOrder( 2 ) )
                           
While ! ( TIT->( Eof() ) )                                            
                              
    //se precisar debugar um registro especifico
    IF AllTrim(TIT->E2_NUM) $ cDebug .AND. !Empty(cDebug)
    	alert("teste")
    EndIf
    
    _cFilSE2 := U_GestqFil(TIT->cCgc,_pTipo)

/* []-----------------------------------------------------------------------------------------------------[]

         Baixas do Contas a Pagar seram processadas pelo Microsiga, inclus„o dos titulos provenientes do
         GESTOQ, baixas via Protheus n„o contemplar baixas orinundas do GESTOQ

   []-----------------------------------------------------------------------------------------------------[]*/

    If ! Empty( TIT->E2_BAIXA )

       TIT->( dbSkip() )       
       Loop
    
    EndIf
    
    cLojFor := IIF( TIT->E2_TIPO $ 'IRF;INS;ISS;PCC;GNR', '00', '01')

    If ! ( SA2->( dbSeek( _cFilSA2 + StrZero(TIT->E2_FORNECE,6)+cLojFor, .F. ) ) )

       _cQry := "SELECT ID_CLIENTE, NOME, ENDERECO, BAIRRO, REPLACE(REPLACE(REPLACE( CEP, '-', '' ), ' ', ''),'.','') CEP, REPLACE(REPLACE(REPLACE( CPFCGC, '-',''),'/',''),'.','') CPFCGC , RGINSC, CONTATO, CONVERT( CHAR(8), CADASTRO, 112) CADASTRO, ISNULL( OP.NATUREZA, '99999') NATUREZA, CID.DESCRICAO, CID.UF, CID.MUNICIPIO, "
       _cQry += "NUMERO, TELEFONE FROM ["+cBDGSTQ+"].[dbo].[CLIENTE] "
       _cQry += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL "
       _cQry += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CIDADE] CID ON CID.ID_CIDADE = CLIENTE.ID_CIDADE "
       _cQry += "WHERE ID_CLIENTE = '" + Alltrim( Str( TIT->E2_FORNECE, 6 ) ) + "'"

       dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), 'TMP' )

       _cCodFor := StrZero( TMP->ID_CLIENTE, 6 )
       _xNOME   := AllTrim(TMP->NOME)
       _IE      := AllTrim(TMP->RGINSC)
       _CEP     := AllTrim(TMP->CEP)
       _CMUN    := RIGHT(AllTrim(TMP->MUNICIPIO), 5)
       _CPAIS   := '1058'
       _FONE    := AllTrim(TMP->TELEFONE)
       _NRO     := AllTrim(TMP->NUMERO)
       _UF      := TMP->UF
       _XBAIRRO := AllTrim(TMP->BAIRRO)
       _XLGR    := AllTrim(TMP->ENDERECO)
       _XMUN    := AllTrim(TMP->DESCRICAO)
       cCgc     := Alltrim(TMP->CPFCGC)
          
       RecLock( 'SA2', .T. )
       SA2->A2_COD     := _cCodFor
       SA2->A2_LOJA    := cLojFor //'01'
       SA2->A2_NOME    := _xNOME
       SA2->A2_NREDUZ  := Substr( _xNome, 1, at( ' ', _xNome) )
       SA2->A2_INSCR   := _IE
       SA2->A2_CGC     := cCGC
       SA2->A2_CEP     := _CEP
       SA2->A2_MUN     := _XMUN
       SA2->A2_COD_MUN := _CMUN
       SA2->A2_PAIS    := SUBSTR( _CPAIS,1,3 )
       SA2->A2_CODPAIS := '0' + _CPAIS
       SA2->A2_TELRE   := _FONE
       SA2->A2_END     := _XLGR

       If at( ',', _XLGR ) = 0

          SA2->A2_END := rTrim( SA2->A2_END ) + ', ' + Alltrim( Str( Val( _NRO ), 5, 0) )
                                                                              
       EndIf

       SA2->A2_EST    := _UF
       SA2->A2_BAIRRO := _XBAIRRO
       SA2->A2_TIPO := if( Len(cCGC) <> 14, 'F', 'J' )
       SA2->( MsUnLock() )
       TMP->( dbCloseArea() )

    EndIf

    If ! ( SE2->( dbSeek( _cFilSE2 + ;
                          TIT->E2_SERIE+;
                          StrZero(Val(rTrim(TIT->E2_NUM)),9)+;
                          TIT->E2_PARCELA+;
                          TIT->E2_TIPO+;
                          StrZero(TIT->E2_FORNECE,6)+;
                          cLojFor;
                          , .F.;
         )      )       )

       _nIdxSE2 := SE2->( IndexOrd() )
       SE2->( DbOrderNickName("IDMOV     ") )
       SE2->( dbSeek( StrZero( TIT->ID_VENCTITULO  , 10, 0 ) ) )
       SE2->( dbSetOrder( _nIdxSE2 )  )

    EndIf

    If ! ( SE2->( Found() ) )

       RecLock( 'SE2', .T. )
       SE2->E2_FILIAL  := _cFilSE2
       SE2->E2_FILORIG := _cFilSE2
       SE2->E2_TIPO    := TIT->E2_TIPO
       SE2->E2_STATUS  := ' '
       SE2->E2_FORNECE := StrZero( TIT->E2_FORNECE, 6 )
       SE2->E2_LOJA    := cLojFor //IIF( TIT->E2_TIPO $ 'IRF;INS;ISS;PCC;GNR', '00', '01')
       SE2->E2_NOMFOR  := SA2->A2_NREDUZ
       SE2->E2_NUM     := iif( StrZero(Val(rTrim(TIT->E2_NUM)),9) <> '*********', StrZero(Val(rTrim(TIT->E2_NUM)),9), rTrim(TIT->E2_NUM) )
       SE2->E2_PARCELA := TIT->E2_PARCELA
       SE2->E2_PREFIXO := TIT->E2_SERIE
       SE2->E2_VALOR   := TIT->E2_VALOR
       SE2->E2_VLCRUZ  := TIT->E2_VALOR
       SE2->E2_SALDO   := ( TIT->E2_VALOR + TIT->E2_ACRESC ) - TIT->E2_DESCONT
       SE2->E2_ACRESC  := TIT->E2_ACRESC
       SE2->E2_JUROS   := TIT->E2_JUROS
       SE2->E2_DESCONT := TIT->E2_DESCONT
       SE2->E2_EMISSAO := StoD( TIT->E2_EMISSAO )
       SE2->E2_EMIS1   := StoD( TIT->E2_EMISSAO )
       SE2->E2_VENCTO  := StoD( TIT->E2_VENCTO )
       SE2->E2_VENCREA := DataValida( StoD( TIT->E2_VENCTO ) )
       SE2->E2_DATAAGE := DataValida( StoD( TIT->E2_VENCTO ) )
       SE2->E2_VENCORI := StoD( TIT->E2_VENCTO )
       SE2->E2_CONTAD  := TIT->E2_CONTA
       SE2->E2_FLUXO   := 'S'
       SE2->E2_PROJPMS := '2'
       SE2->E2_DESDOBR := 'N'
       SE2->E2_MOEDA   := 1
       SE2->E2_FRETISS := '1'
       SE2->E2_PRETINS := '1'
	   SE2->E2_MDRTISS := '1'
	   SE2->E2_OCORREN := '01'
	   SE2->E2_RATEIO  := 'N'
       SE2->E2_RATFIN  := '2'
       SE2->E2_APLVLMN := '1'
       SE2->E2_DIRF    := '2'
       SE2->E2_MODSPB  := '1'
	   SE2->E2_HIST    := TIT->E2_HIST
	   SE2->E2_IDMOV   := StrZero( TIT->ID_VENCTITULO, 10, 0 )

       If TIT->E2_TIPO = 'NF'
          /*SF1->( dbSeek( _cFilSE2+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+'01'+'N'+'N', .F. ) ) Usar no futuro quando mudarem de ideia, tratamento nf entrada   */

          _cOrigem        := 'MATA100'
          SE2->E2_ORIGEM  := 'FINA050' // Alterado para titulo manual para permitir a exclus„o de titulo quando NF cancelada -> Montes - 22/05/2019
          /*SE2->E2_LA      := 'S' ver coment·rio acima */
          _aNaturez := MultNat( lTrim( Str( TIT->ID_VENCTITULO, 12, 0 ) ) )

       Else

          _cOrigem        := 'FINA050'
          SE2->E2_ORIGEM  := 'FINA050'
          SE2->E2_LA      := ' '
          _aNaturez := MultNat( lTrim( Str( TIT->ID_TITULO, 12, 0 ) ) )

       EndIf

       SE2->E2_MULTNAT := _aNaturez[2]
       SE2->E2_NATUREZ := if( ! Empty( _aNaturez[1] ) .And. Substr(_aNaturez[1],1,5) <> '99999' , _aNaturez[1], SA2->A2_NATUREZ  )
       SE2->E2_ORIGBD  := TIT->E2_ORIGBD //Montes - 06/05/2019
       If SE2->(FIELDPOS("E2_MSEXP")) > 0
          SE2->E2_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
       EndIf
       SE2->( MSUnLock() )

     ElseIf TIT->E2_VENCTO <> DtoS( SE2->E2_VENCTO )

       RecLock( 'SE2', .F. )
       If TIT->E2_VENCTO <> DtoS( SE2->E2_VENCTO )
          SE2->E2_VENCTO  := StoD( TIT->E2_VENCTO )
          SE2->E2_VENCREA := DataValida( StoD( TIT->E2_VENCTO ) )
          SE2->E2_DATAAGE := DataValida( StoD( TIT->E2_VENCTO ) )
       EndIf
	   SE2->E2_IDMOV   := StrZero( TIT->ID_VENCTITULO, 10, 0 )
   	   if SE2->E2_SALDO <> TIT->E2_SALDO
	      SE2->E2_SALDO := TIT->E2_SALDO
	   EndIf
	   If SE2->(FIELDPOS("E2_MSEXP")) > 0
          SE2->E2_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
       EndIf
       SE2->( MSUnLock() )

/*    Else

       If rTrim( SE2->E2_ORIGEM ) = 'FINA050'  .Or.;
          rTrim( SE2->E2_ORIGEM ) = 'CTAPGSTQ'

          RecLock( 'SE2', .F. )
          _cOrigem := SE2->E2_ORIGEM
          _aNaturez := MultNat( lTrim( Str( TIT->ID_TITULO, 12, 0 ) ) )
          SE2->E2_MULTNAT := _aNaturez[2]
          SE2->E2_NATUREZ := if( ! Empty( _aNaturez[1] ) .And. Substr(_aNaturez[1],1,5) <> '99999' , _aNaturez[1], SA2->A2_NATUREZ  )
          SE2->( dbUnLock() )
       
       ElseIf  rTrim( SE2->E2_ORIGEM ) = 'MATA100'

          RecLock( 'SE2', .F. )
          _cOrigem := SE2->E2_ORIGEM
          _aNaturez := MultNat( lTrim( Str( TIT->ID_VENCTITULO, 12, 0 ) ) )
          SE2->E2_MULTNAT := _aNaturez[2]
          SE2->E2_NATUREZ := if( ! Empty( _aNaturez[1] ) .And. Substr(_aNaturez[1],1,5) <> '99999' , _aNaturez[1], SA2->A2_NATUREZ  )
          SE2->( dbUnLock() )
                               
       End*/

    End
 
    If ( _cFilSE2 + TIT->E2_SERIE+StrZero(Val(rTrim(TIT->E2_NUM)),9)+TIT->E2_PARCELA+TIT->E2_TIPO+StrZero(TIT->E2_FORNECE,6)+'01' =;
         _cFilSE2 + SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+'01';
       ) .And.;
       ( _cPgt = 'B' ) .And.;
       DtoS( SE2->E2_BAIXA ) <> TIT->E2_BAIXA

       If ( TIT->E2_NUMCHEQ = 0 ) .Or.;
          (_nConcil <> 1) .Or.;
          ( TIT->E2_DTCONC >= _cDtIni .And. TIT->E2_DTCONC <= _cDtFim )

          BxaTit( _cDtIni, _cDtFim )

       EndIf

    EndIf

    TIT->( dbSkip() )
EndDo

TIT->( dbCloseArea() )
SE5->( dbSetOrder( 1 ) )

Return( NIL )

Static Function BxaTit( _cDtIni, _cDtFim )

_lConc := .F.

If (TIT->E2_NUMCHEQ = 0) .Or.;
   ((TIT->E2_NUMCHEQ <> 0) .And. ( TIT->E2_DTCONC >= _cDtIni .And. TIT->E2_DTCONC <= _cDtFim ))
 
   RecLock( 'SE2', .F. )
   SE2->E2_BAIXA   := StoD( TIT->E2_BAIXA )
   SE2->E2_BCOPAG  := If( TIT->E2_PORTADO <> '999', TIT->E2_PORTADO, '   ' )
   SE2->E2_MOVIMEN := StoD( TIT->E2_BAIXA )
   SE2->E2_DATAAGE := StoD( TIT->E2_BAIXA )
   SE2->E2_SALDO   := if( SE2->E2_SALDO - TIT->E2_PAGO < 0, 0, SE2->E2_SALDO - TIT->E2_PAGO )
   SE2->E2_VALLIQ  += TIT->E2_PAGO
   If SE2->(FIELDPOS("E2_MSEXP")) > 0
      SE2->E2_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
   EndIf
   SE2->( MSUnLock() )
   _lConc := .T.

EndIf

If SE2->E2_FILIAL $ [0102.0103]
   _cFilOriPgt := '0101'
ElseIf SE2->E2_FILIAL = '0202'
   _cFilOriPgt := '0201'
Else
   _cFilOriPgt := SE2->E2_FILIAL
EndIf

If (TIT->E2_PORTADO = '012') .Or.;
   (TIT->E2_PORTADO = '001' .And. TIT->A6_AGENCIA = '0001')

   cTipoDoc := 'BA'

ElseIf (TIT->E2_NUMCHEQ <> 0)

   cTipoDoc := 'BA'

Else

   cTipoDoc := 'VL'

EndIf

_dMvt := if( TIT->E2_NUMCHEQ <> 0, if( empty( TIT->E2_DTCONC ), TIT->E2_BAIXA, TIT->E2_DTCONC ), TIT->E2_BAIXA )

If ! ( SE5->( dbSeek( _cFilOriPgt + cTipoDoc + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + TIT->E2_BAIXA + SE2->E2_FORNECE + IF( TIT->E2_TIPO $ 'IRF;INS;ISS;PCC;GNR', '00', '01') + '01', .F. ) ) )
   _lSE5 := SE5->( dbSeek( _cFilOriPgt + cTipoDoc + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + _dMvt + SE2->E2_FORNECE + IF( TIT->E2_TIPO $ 'IRF;INS;ISS;PCC;GNR', '00', '01') + '01', .F. ) )
Else
   _lSE5 := .T.
EndIf

If _lSE5

   If ( _lConc ) .And.;
      ( TIT->E2_NUMCHEQ <> 0 )

      _dMvt := StoD( _dMvt )
   
      RecLock( 'SE5', .F. )
      SE5->E5_DATA    := _dMvt
      SE5->E5_DTDIGIT := _dMvt
      SE5->E5_DTDISPO := _dMvt
      SE5->E5_RECONC  := 'x'
      SE5->( MSUnLock() )

   EndIf

Else 

   _dMvt := StoD( _dMvt )

   RecLock( 'SE5', .T. )
   SE5->E5_FILIAL  := _cFilOriPgt
   SE5->E5_DATA    := _dMvt
   SE5->E5_TIPO    := SE2->E2_TIPO
   SE5->E5_MOEDA   := '01'
   SE5->E5_VALOR   := TIT->E2_PAGO
   SE5->E5_VLDESCO := SE2->E2_DESCONT
   SE5->E5_VLACRES := SE2->E2_ACRESC
   SE5->E5_VLJUROS := SE2->E2_ACRESC
   SE5->E5_VLJUROS += SE2->E2_JUROS
   SE5->E5_VLMOED2 := SE5->E5_VALOR
   SE5->E5_NATUREZ := SE2->E2_NATUREZ
   SE5->E5_BANCO   := TIT->E2_PORTADO
   SE5->E5_AGENCIA := TIT->A6_AGENCIA
   SE5->E5_CONTA   := TIT->A6_NUMCON
   SE5->E5_RECPAG  := 'P'
   SE5->E5_BENEF   := SE2->E2_NOMFOR
   SE5->E5_DOCUMEN := if( TIT->ID_BAIXADOC <> 0, lTrim( Str( TIT->ID_BAIXADOC, 0 ) ), ' ' )

   If SE2->E2_TIPO <> 'NF '
      SE5->E5_HISTOR  := 'Valor pago s/Titulo'
   Else
      SE5->E5_HISTOR  := 'VLR PG NF' + if( ! Empty( SE2->E2_PREFIXO ), + ' ' + Alltrim(SE2->E2_PREFIXO) + '-', ' ') + ltrim(SE2->E2_NUM) + '/' + SE2->E2_PARCELA
   EndIf

   SE5->E5_PREFIXO := SE2->E2_PREFIXO
   SE5->E5_NUMERO  := SE2->E2_NUM
   SE5->E5_PARCELA := SE2->E2_PARCELA
   SE5->E5_CLIFOR  := SE2->E2_FORNECE
   SE5->E5_LOJA    := SE2->E2_LOJA
   SE5->E5_DTDIGIT := _dMvt
   SE5->E5_RECONC  := if( TIT->E2_NUMCHEQ <> 0 .And. ! Empty( TIT->E2_DTCONC ), 'x', ' ' )

   If (TIT->E2_PORTADO = '012') .Or.;
      (TIT->E2_PORTADO = '001' .And. TIT->A6_AGENCIA = '0001')

      SE5->E5_MOTBX   := 'CXA'   

   ElseIf (TIT->E2_TPLANC <> 2)

      SE5->E5_MOTBX   := 'NOR'

   Else

      SE5->E5_MOTBX   := 'FAT'   

   EndIf

   SE5->E5_SEQ     := '01'
   SE5->E5_DTDISPO := _dMvt
   SE5->E5_FILORIG := SE2->E2_FILIAL
   SE5->E5_FORNECE := SE2->E2_FORNECE
   SE5->E5_ORIGEM  := 'CTAPGSTQ'
   SE5->E5_TPDESC  := 'I'
   SE5->E5_IDMOVI  := StrZero( TIT->ID_BAIXADOC )

   If (TIT->E2_PORTADO = '012') .Or.;
      (TIT->E2_PORTADO = '001' .And. TIT->A6_AGENCIA = '0001')

      SE5->E5_NUMCHEQ := lTrim( Str( TIT->E2_NUMCHEQ, 10, 0 ) )
      SE5->E5_TIPODOC := 'BA'

   ElseIf (TIT->E2_NUMCHEQ <> 0)

      SE5->E5_NUMCHEQ := lTrim( Str( TIT->E2_NUMCHEQ, 10, 0 ) )
      SE5->E5_TIPODOC := 'BA'
      GeraCheq()

   Else

      SE5->E5_NUMCHEQ := ' '
      SE5->E5_TIPODOC := 'VL'

   EndIf
   SE5->E5_ORIGBD  := TIT->E2_ORIGBD //Montes - 06/05/2019   
   If SE5->(FIELDPOS("E5_MSEXP")) > 0
      SE5->E5_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
   EndIf
   SE5->( MSUnLock() )
EndIf

Return( NIL )      

Static Function MultNat( _idTitulo )

If _cOrigem = 'FINA050'

   _cQry := 'SELECT'
   _cQry += ' ISNULL( RATEIO.ID_TITULO, 0 ) idTitulo,'
   _cQry += ' ISNULL( RATEIO.ID_OPERACIONAL, 0 ) idOperacional, '
   _cQry += " ISNULL( NATUREZA, '99999') EV_NATUREZ,"
   _cQry += ' ISNULL( RATEIO.VALOR, 0 ) EV_VALOR, '
   _cQry += ' ISNULL( INDICE, 0 ) Indice,'
   _cQry += ' SUM( VCTTIT.VALOR ) TotTit,'
   _cQry += ' ROUND( ISNULL( RATEIO.VALOR, 0 ) / SUM( VCTTIT.VALOR ), 4) EV_PERC '
   _cQry += 'FROM ['+cBDGSTQ+'].[dbo].[RATEIO_OPERACIONAL] RATEIO '
   _cQry += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OPER ON OPER.ID_OPERACIONAL = RATEIO.ID_OPERACIONAL '
   _cQry += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[VENCTITULO] VCTTIT ON VCTTIT.ID_TITULO = RATEIO.ID_TITULO '
   _cQry += 'WHERE RATEIO.ID_TITULO = ' + _idTitulo + ' '
   _cQry += 'GROUP BY'
   _cQry += ' ISNULL( RATEIO.ID_TITULO, 0 ),'
   _cQry += ' ISNULL( RATEIO.ID_OPERACIONAL, 0 ),'
   _cQry += " ISNULL( NATUREZA, '99999'),"
   _cQry += ' ISNULL( RATEIO.VALOR, 0 ),'
   _cQry += ' ISNULL( INDICE, 0 ) '
   _cQry += 'ORDER BY'
   _cQry += ' ISNULL( RATEIO.ID_TITULO, 0 ),'
   _cQry += ' ISNULL( RATEIO.ID_OPERACIONAL, 0 ),'
   _cQry += " ISNULL( NATUREZA, '99999'),"
   _cQry += ' ISNULL( RATEIO.VALOR, 0 ),'
   _cQry += ' ISNULL( INDICE, 0 ),'
   _cQry += ' ROUND( ISNULL( RATEIO.VALOR, 0 ) / SUM( VCTTIT.VALOR ), 4) DESC'

Else

   _cQry := 'SELECT '
   _cQry += 'ID_VENCTITULO, EV_NUM, EV_PARCELA, ID_CLIENTE EV_CLIFOR, EV_NATUREZ, ROUND(NOTA.VLR_TOT_NOTA * round(RATEIO.TotalNat / NOTA.VLR_TOT_NOTA, 4), 2 ) EV_VALOR, round(RATEIO.TotalNat / NOTA.VLR_TOT_NOTA, 4) EV_PERC '
   _cQry += 'FROM ['+cBDGSTQ+'].[dbo].[NOTA_COMPRA] NOTA,'
   _cQry += '('
   _cQry += 'SELECT '
   _cQry +=   ' NOTA.ID_NOTA_COMPRA,'
   _cQry +=   ' VCTIT.ID_VENCTITULO,'
   _cQry +=   ' CASE 
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -4)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -4)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -3)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -3)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -4)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -2)"
   _cQry +=      ' ELSE VCTIT.DOC'
   _cQry +=   ' END EV_NUM,'

   _cQry +=   ' CASE '
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN 
   _cQry +=     " CASE"
   _cQry +=       " WHEN RIGHT(VCTIT.DOC, 1) = 'A' THEN RIGHT(VCTIT.DOC, 1)"
   _cQry +=       " ELSE"
   _cQry +=        " CASE ISNUMERIC( SUBSTRING(RIGHT(VCTIT.DOC, 2),1,1) ) WHEN 0"
   _cQry +=          " THEN"
   _cQry +=            " CASE"
   _cQry +=              " WHEN ISNULL(NOTA.ID_NOTA_COMPRA,0) = 0 AND CONVERT(CHAR(8),VCTIT.CADASTRO,112) > '20160605'"
   _cQry +=              " THEN RIGHT(VCTIT.DOC, 1)"
   _cQry +=              " ELSE SUBSTRING(RIGHT(VCTIT.DOC, 2),1,1)"
   _cQry +=            " END"
   _cQry +=          " ELSE RIGHT(VCTIT.DOC, 1)"
   _cQry +=        " END"
   _cQry +=     " END"
   _cQry +=     " ELSE ' '"
   _cQry +=     " END EV_PARCELA,"

   _cQry +=   " ISNULL( OP.NATUREZA, '99999') EV_NATUREZ,"
   _cQry +=   ' SUM( ROUND(ITEM.QTD * ITEM.VLR_UNT, 2) + ITEM.VlrSubTrib + ROUND( (ITEM.QTD * ITEM.VLR_UNT) * (ITEM.IPI / 100), 2) ) TotalNat '
   _cQry += 'FROM ['+cBDGSTQ+'].[dbo].[NOTA_COMPRA] NOTA WITH (NOLOCK) '
   _cQry += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ITEM_NOTA_COMPRA] ITEM WITH (NOLOCK) ON NOTA.ID_NOTA_COMPRA = ITEM.ID_NOTA_COMPRA '
   _cQry += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ITEM_PED_COMPRA] PEDIDO WITH (NOLOCK) ON PEDIDO.ID_PED_COMPRA = ITEM.ID_PEDIDO AND PEDIDO.ITEM = ITEM.PEDIDO_ITEM '
   _cQry += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ITEM_SC] SC WITH (NOLOCK) ON ITEM.ID_ITEM_SC = SC.ID_ITEM_SC '
   _cQry += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OP WITH (NOLOCK) ON OP.ID_OPERACIONAL = SC.ID_OPERACIONAL '
   _cQry += 'LEFT OUTER JOIN ['+cBDPROT+'].[dbo].[SED010] SED WITH (NOLOCK) ON OP.NATUREZA = ED_CODIGO COLLATE Latin1_General_100_BIN '
   _cQry += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[VENCTITULO] VCTIT WITH (NOLOCK) ON VCTIT.ID_TITULO = NOTA.ID_TITULO '
   _cQry += 'WHERE'
//_cQry +=   " (CONVERT( CHAR(8), VCTIT.DATA_PAG , 112 ) > '" + _cDtIni + "') OR (CONVERT( CHAR(8), VCTIT.VENCIMENTO , 112 ) > '" + _cDtIni + "') AND "
   _cQry +=   " (VCTIT.ID_VENCTITULO = " + _idTitulo + ") "
   _cQry += 'GROUP BY '
   _cQry +=    'NOTA.ID_NOTA_COMPRA,'
   _cQry +=    'OP.NATUREZA,'
   _cQry +=    'VCTIT.ID_VENCTITULO, '
   _cQry +=    'CASE '
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -4)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -4)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -3)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -3)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -4)"
   _cQry +=      " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -2)"
   _cQry +=      ' ELSE VCTIT.DOC '
   _cQry +=    'END,'

   _cQry +=    ' CASE '
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN ' ' 
   _cQry +=     " WHEN CHARINDEX(RIGHT(VCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN 
   _cQry +=     " CASE"
   _cQry +=       " WHEN RIGHT(VCTIT.DOC, 1) = 'A' THEN RIGHT(VCTIT.DOC, 1)"
   _cQry +=       " ELSE"
   _cQry +=        " CASE ISNUMERIC( SUBSTRING(RIGHT(VCTIT.DOC, 2),1,1) ) WHEN 0"
   _cQry +=          " THEN"
   _cQry +=            " CASE"
   _cQry +=              " WHEN ISNULL(NOTA.ID_NOTA_COMPRA,0) = 0 AND CONVERT(CHAR(8),VCTIT.CADASTRO,112) > '20160605'"
   _cQry +=              " THEN RIGHT(VCTIT.DOC, 1)"
   _cQry +=              " ELSE SUBSTRING(RIGHT(VCTIT.DOC, 2),1,1)"
   _cQry +=            " END"
   _cQry +=          " ELSE RIGHT(VCTIT.DOC, 1)"
   _cQry +=        " END"
   _cQry +=     " END"
   _cQry +=     " ELSE ' '"
   _cQry +=     " END "

   _cQry += ') RATEIO '
   _cQry += 'WHERE RATEIO.ID_NOTA_COMPRA = NOTA.ID_NOTA_COMPRA AND RATEIO.TotalNat <> 0 '
   _cQry += 'ORDER BY EV_NUM, EV_PARCELA, EV_CLIFOR, ROUND(RATEIO.TotalNat / NOTA.VLR_TOT_NOTA, 4) DESC'

End

dbUseArea( .T., "TOPCONN" , TcGenQry(,, _cQry), "NAT" , .T. , .T. )

If lTrim( NAT->EV_NATUREZ ) = '99999'
   
   _cNaturez := SA2->A2_NATUREZ

Else

   _cNaturez := NAT->EV_NATUREZ

EndIf

_nMultNat := 0

If (NAT->EV_NATUREZ = TIT->E2_NATUREZ .Or. NAT->EV_NATUREZ = SE2->E2_NATUREZ) .And.;
   (NAT->EV_PERC = 1)

   NAT->( dbCloseArea() )
   Return( { _cNaturez, '2' } )
                         
EndIf

While ! ( NAT->( Eof() ) )

   If ! ( SEV->( dbSeek( SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+NAT->EV_NATUREZ, .F. ) ) )

      RecLock( 'SEV', .T. )
      SEV->EV_FILIAL  := SE2->E2_FILIAL
      SEV->EV_PREFIXO := SE2->E2_PREFIXO
      SEV->EV_NUM     := SE2->E2_NUM
      SEV->EV_PARCELA := SE2->E2_PARCELA
      SEV->EV_CLIFOR  := SE2->E2_FORNECE
      SEV->EV_LOJA    := SE2->E2_LOJA
      SEV->EV_TIPO    := SE2->E2_TIPO
      SEV->EV_RECPAG  := 'P'
      SEV->EV_IDENT   := '1'
      SEV->EV_NATUREZ := NAT->EV_NATUREZ

      If NAT->EV_PERC <> 1

         SEV->EV_VALOR := NAT->EV_VALOR - iif( _cOrigem <> 'FINA050', ( SE2->E2_DESCONT * NAT->EV_PERC ), 0 )

      Else

         SEV->EV_VALOR := TIT->E2_VALOR

      EndIf

      SEV->EV_PERC    := NAT->EV_PERC
         
      SEV->( MsUnLock() )
      _nMultNat ++
      
   EndIf
   
   NAT->( dbSkip() )
EndDo

If _nMultNat > 1
 
   _cMultNat := '1'

Else

   _cMultNat := '2'

EndIf

NAT->( dbCloseArea() )

Return( { _cNaturez, _cMultNat } )

Static Function GeraCheq()

RecLock( 'SEF', .T. )
SEF->EF_FILIAL  := _cFilOriPgt
SEF->EF_FILORIG := SE2->E2_FILIAL
SEF->EF_BANCO   := TIT->E2_PORTADO
SEF->EF_AGENCIA := TIT->A6_AGENCIA
SEF->EF_CONTA   := TIT->A6_NUMCON
SEF->EF_NUM     := lTrim( Str( TIT->E2_NUMCHEQ, 15, 0 ) )
SEF->EF_VALOR   := TIT->E2_PAGO
SEF->EF_VALORBX := TIT->E2_PAGO
SEF->EF_DATA    := StoD( TIT->E2_CHQEMI )
SEF->EF_PREFIXO := SE2->E2_PREFIXO
SEF->EF_TITULO  := SE2->E2_NUM
SEF->EF_PARCELA := SE2->E2_PARCELA
SEF->EF_TIPO    := SE2->E2_TIPO
SEF->EF_FORNECE := SE2->E2_FORNECE
SEF->EF_LOJA    := SE2->E2_LOJA
SEF->EF_SEQUENC := '01'
SEF->EF_IMPRESS := 'A'
SEF->EF_LIBER   := ' '
SEF->EF_TERCEIR := .F.
SEF->EF_ORIGEM  := 'CTAPGSTQ'
SEF->EF_BENEF   := SE2->E2_NOMFOR
SEF->EF_HIST    := 'Cheque por Bx. Automatica'
SEF->( MsUnLock() )

Return( NIL )

User function CtaPgG2()
RpcSetType(3)
RpcSetEnv("01", "0101")

u_CtaPgGstq()

Return
