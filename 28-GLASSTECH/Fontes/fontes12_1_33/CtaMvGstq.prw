#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtaMvGstq º Autor ³ Sérgio Santana       º Data ³19/10/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao Base de Dados                                   º±±
±±º          ³ Movimentação Bancaria                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºALTERACAO ³                                                            º±± 
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ThermoGlass                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//U_CtaMvGstq( '20140901', '20141031' )

User Function CtaMvGstq( _cDtIni, _cDtFim )

DEFAULT _cDtIni := DtoS( dDataBase - 1 )
DEFAULT _cDtFim := DtoS( dDataBase - 1 )

PRIVATE _cFilSE5 := xFilial( 'SE5' )
PRIVATE _qMvt

_nIdxSE5 := SE5->( IndexOrd() )
SE5->( dbSetOrder( 17 ) )

_qMvt := "SELECT "
_qMvt += "Case When CtaOrig.ID_CONTA = 101 Then '9001' When CtaOrig.ID_EMPRESA = 1 Then '0101' When CtaOrig.ID_EMPRESA = 2 Then '0102' When CtaOrig.ID_EMPRESA = 3 Then '0201' When CtaOrig.ID_EMPRESA = 4 Then '0601' When CtaOrig.ID_EMPRESA = 5 Then '0103' When CtaOrig.ID_EMPRESA = 6 Then '0202' When CtaOrig.ID_EMPRESA = 7 Then '0301' When CtaOrig.ID_EMPRESA = 8 Then '0401' When CtaOrig.ID_EMPRESA = 9 Then '0501' When CtaOrig.ID_EMPRESA = 12 Then '0701' When CtaOrig.ID_EMPRESA = 13 Then '9001' When CtaOrig.ID_EMPRESA = 15 Then '0215' When CtaOrig.ID_EMPRESA = 16 Then '0801' Else '0000' End E5_FILIAL,"
_qMvt += "Case When DstCta.ID_CONTA  = 101 Then '9001' When DstCta.ID_EMPRESA = 1 Then '0101' When DstCta.ID_EMPRESA = 2 Then '0102' When DstCta.ID_EMPRESA = 3 Then '0201' When DstCta.ID_EMPRESA = 4 Then '0601' When DstCta.ID_EMPRESA = 5 Then '0103' When DstCta.ID_EMPRESA = 6 Then '0202' When DstCta.ID_EMPRESA = 7 Then '0301' When DstCta.ID_EMPRESA = 8 Then '0401' When DstCta.ID_EMPRESA = 9 Then '0501' When DstCta.ID_EMPRESA = 9 Then '0501' When DstCta.ID_EMPRESA = 12 Then '0701' When DstCta.ID_EMPRESA = 13 Then '9001' When DstCta.ID_EMPRESA = 15 Then '0215' When DstCta.ID_EMPRESA = 16 Then '0801' Else '0000' End E5_FILORIG,"
_qMvt += "CONVERT( CHAR(8), MvtCta.DATA, 112) E5_DATA,"
_qMvt += "CONVERT( CHAR(8), MvtCta.DATA, 112) E5_DTCHQ,"
_qMvt += "CASE ISNULL( Transf.ID_CONTA_DESTINO, 0 ) WHEN 0 THEN 'M1' ELSE 'TB' END E5_MOEDA,"
_qMvt += "MvtCta.VALOR E5_VALOR,"
_qMvt += "ISNULL( Oper.NATUREZA, '     ' )  E5_NATUREZ,"
_qMvt += "ISNULL(SA6ORI.A6_COD, ' ') E5_BANCO,"
_qMvt += "ISNULL(SA6ORI.A6_AGENCIA, ' ') E5_AGENCIA,"
_qMvt += "ISNULL(SA6ORI.A6_NUMCON, ' ') E5_CONTA,"
_qMvt += "MvtCta.DOC E5_NUMCHEQ,"
_qMvt += "CASE DB_CR WHEN 'C' THEN 'R' ELSE 'P' END E5_RECPAG,"
_qMvt += "ISNULL( Emp.NOME, ' ') E5_BENEF,"
_qMvt += "MvtCta.REFERENCIA E5_HISTOR,"
_qMvt += "CASE ISNULL( Transf.ID_CONTA_DESTINO, 0 ) WHEN 0 THEN CASE WHEN Transf.ID_CHEQUE IS NULL THEN 'VL' ELSE 'CH' END ELSE 'TR' END E5_TIPODOC,"
_qMvt += "CASE DB_CR WHEN 'D' THEN ISNULL(SA6ORI.A6_CONTA, ' ') ELSE ' ' END E5_DEBITO,"
_qMvt += "CASE DB_CR WHEN 'C' THEN ISNULL(SA6DST.A6_CONTA, ' ') ELSE ' ' END E5_CREDITO, "
_qMvt += "'M' E5_MOV, "
_qMvt += "'G' E5_ORIGBD " //Montes - 06/05/2019
_qMvt += "FROM ["+cBDGSTQ+"].[dbo].[MOV_CONTA] MvtCta "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CONTA] CtaOrig ON CtaOrig.ID_CONTA = MvtCta.ID_CONTA "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[TP_MOV_CONTA] TpMvCta ON TpMvCta.ID_TP_MOV_CONTA = MvtCta.ID_TP_MOV_CONTA "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[OPERACIONAL] Oper ON Oper.ID_OPERACIONAL = TpMvCta.ID_OPERACIONAL "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[TRANSF_BANCARIA] Transf ON Transf.ID_TRANSF_BANCARIA = MvtCta.ID_TRANSF_BANCARIA "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CONTA] DstCta ON DstCta.ID_CONTA = Transf.ID_CONTA_DESTINO "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] Emp ON Emp.ID_EMPRESA = DstCta.ID_EMPRESA "
_qMvt += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA6010] SA6ORI ON SA6ORI.A6_COD = (REPLICATE( '0', 3 - LEN( CAST(ISNULL(CtaOrig.ID_CONTA,999) AS VARCHAR(3)))) + CAST(ISNULL(CtaOrig.ID_CONTA,999) AS VARCHAR(3))) AND SA6ORI.D_E_L_E_T_ <> '*' "
_qMvt += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA6010] SA6DST ON SA6DST.A6_COD = (REPLICATE( '0', 3 - LEN( CAST(ISNULL(DstCta.ID_CONTA,999) AS VARCHAR(3)))) + CAST(ISNULL(DstCta.ID_CONTA,999) AS VARCHAR(3))) AND SA6DST.D_E_L_E_T_ <> '*' "
_qMvt += "WHERE (CONVERT( CHAR(8), MvtCta.DATA, 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') AND (MvtCta.ID_TP_MOV_CONTA NOT IN (22,37,42,43,61,114)) "
_qMvt += "ORDER BY MvtCta.DOC, ISNULL( Transf.ID_CONTA_DESTINO, 0 )

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qMvt),"MVT",.T.,.T.)

GrvMvtFin()

_qMvt := "SELECT "
_qMvt += "Case When CtaOrig.ID_CONTA = 101 Then '9001' When CtaOrig.ID_EMPRESA = 1 Then '0101' When CtaOrig.ID_EMPRESA = 2 Then '0102' When CtaOrig.ID_EMPRESA = 3 Then '0201' When CtaOrig.ID_EMPRESA = 4 Then '0601' When CtaOrig.ID_EMPRESA = 5 Then '0103' When CtaOrig.ID_EMPRESA = 6 Then '0202' When CtaOrig.ID_EMPRESA = 7 Then '0301' When CtaOrig.ID_EMPRESA = 8 Then '0401' When CtaOrig.ID_EMPRESA = 9 Then '0501' When CtaOrig.ID_EMPRESA = 9 Then '0501' When CtaOrig.ID_EMPRESA = 12 Then '0701' When CtaOrig.ID_EMPRESA = 13 Then '9001' When CtaOrig.ID_EMPRESA = 15 Then '0215' When CtaOrig.ID_EMPRESA = 16 Then '0801' Else '0000' End E5_FILIAL,"
_qMvt += "Case When DstCta.ID_CONTA  = 101 Then '9001' When DstCta.ID_EMPRESA = 1 Then '0101' When DstCta.ID_EMPRESA = 2 Then '0102' When DstCta.ID_EMPRESA = 3 Then '0201' When DstCta.ID_EMPRESA = 4 Then '0601' When DstCta.ID_EMPRESA = 5 Then '0103' When DstCta.ID_EMPRESA = 6 Then '0202' When DstCta.ID_EMPRESA = 7 Then '0301' When DstCta.ID_EMPRESA = 8 Then '0401' When DstCta.ID_EMPRESA = 9 Then '0501' When DstCta.ID_EMPRESA = 9 Then '0501' When DstCta.ID_EMPRESA = 12 Then '0701' When DstCta.ID_EMPRESA = 13 Then '9001' When DstCta.ID_EMPRESA = 15 Then '0215' When DstCta.ID_EMPRESA = 16 Then '0801' Else '0000' End E5_FILORIG,"
_qMvt += "CONVERT( CHAR(8), Chq.EMISSAO, 112) E5_DATA,"
_qMvt += "CONVERT( CHAR(8), Chq.DTCONCILIADO, 112) E5_DTCHQ,"
_qMvt += "'M1' E5_MOEDA,"
_qMvt += "Chq.VALOR E5_VALOR,"
_qMvt += "ISNULL( Oper.NATUREZA,ISNULL(SA2.A2_NATUREZ, '     ')) E5_NATUREZ,"
_qMvt += "ISNULL(SA6ORI.A6_COD, ' ') E5_BANCO,"
_qMvt += "ISNULL(SA6ORI.A6_AGENCIA, ' ') E5_AGENCIA,"
_qMvt += "ISNULL(SA6ORI.A6_NUMCON, ' ') E5_CONTA,"
_qMvt += "CAST( Chq.ID_CHEQUE AS VARCHAR(15)) E5_NUMCHEQ,"
_qMvt += "'P' E5_RECPAG,"
_qMvt += "ISNULL( Emp.NOME, ' ') E5_BENEF,"
_qMvt += "Chq.NOMINAL E5_HISTOR,"
_qMvt += "CASE WHEN ISNULL(Transf.ID_CONTA_DESTINO,0) IN ( 2, 12 ) THEN 'CX' ELSE 'CH' END E5_TIPODOC,"
_qMvt += "' ' E5_DEBITO,"
_qMvt += "' ' E5_CREDITO, "
_qMvt += "ISNULL( Titulo.ID_CLIENTE, 0 ) E5_CLIFOR, "
_qMvt += "CAST(CASE WHEN VctTit.DOC IS NULL THEN ' ' ELSE ISNULL(NOTA.SERIE,' ') END AS CHAR(3)) E5_SERIE,"
_qMvt +=   ' CASE '
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 4 ), 'IRRF' ) <> 0 THEN LEFT(REPLACE(VctTit.DOC,'/',''),LEN(REPLACE(VctTit.DOC,'/','')) + -4)"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 4 ), 'INSS' ) <> 0 THEN LEFT(REPLACE(VctTit.DOC,'/',''),LEN(REPLACE(VctTit.DOC,'/','')) + -4)"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'ISS' )  <> 0 THEN LEFT(REPLACE(VctTit.DOC,'/',''),LEN(REPLACE(VctTit.DOC,'/','')) + -3)"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'PCC' )  <> 0 THEN LEFT(REPLACE(VctTit.DOC,'/',''),LEN(REPLACE(VctTit.DOC,'/','')) + -3)"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'GNRE' ) <> 0 THEN LEFT(REPLACE(VctTit.DOC,'/',''),LEN(REPLACE(VctTit.DOC,'/','')) + -4)"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN LEFT(REPLACE(VctTit.DOC,'/',''),LEN(REPLACE(VctTit.DOC,'/','')) + -2)"
_qMvt +=     " ELSE ISNULL( VctTit.DOC, ' ') "
_qMvt +=   ' END E5_NUM,'
_qMvt +=   ' CASE '
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 4 ), 'IRRF' ) <> 0 THEN ' '"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 4 ), 'INSS' ) <> 0 THEN ' '"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'ISS' )  <> 0 THEN ' '"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'PCC' )  <> 0 THEN ' '"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'GNRE' ) <> 0 THEN ' '"
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN "
_qMvt +=     "   CASE WHEN ASCII(RIGHT(VctTit.DOC, 1)) - ASCII(SUBSTRING(RIGHT(VctTit.DOC, 2),1,1)) < 1 THEN RIGHT(VctTit.DOC, 1) ELSE SUBSTRING(RIGHT(VctTit.DOC, 2),1,1) END "
//_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN CAST(RIGHT(VctTit.DOC, 2 ) AS CHAR(1)) "
_qMvt +=     " ELSE ' ' "
_qMvt +=   ' END E5_PARCELA,'
_qMvt +=   ' CASE '
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 4 ), 'IRRF' ) <> 0 THEN 'IRF'
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 4 ), 'INSS' ) <> 0 THEN 'INS'
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'ISS' )  <> 0 THEN 'IS '
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'PCC' )  <> 0 THEN 'PCC'
_qMvt +=     " WHEN CHARINDEX(RIGHT(VctTit.DOC, 3 ), 'GNRE' ) <> 0 THEN 'GNR'
_qMvt +=     " ELSE CASE WHEN NOTA.SERIE IS NULL THEN '   ' ELSE 'NF ' END "
_qMvt +=    ' END'
_qMvt +=    ' E5_TIPO,'
_qMvt += "'C' E5_MOV, "
_qMvt += "'G' E5_ORIGBD " //Montes - 06/05/2019
_qMvt += "FROM ["+cBDGSTQ+"].[dbo].[CHEQUE] Chq "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[ADIANTAMENTO] Adto ON (Adto.ID_CHEQUE = Chq.ID_CHEQUE) AND (Adto.ID_CONTA = Chq.ID_CONTA) "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CONTA] CtaOrig ON (CtaOrig.ID_CONTA = Chq.ID_CONTA) "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[TRANSF_BANCARIA] Transf ON (Transf.ID_CHEQUE = Chq.ID_CHEQUE) AND (Transf.ID_EMPRESA = Chq.ID_EMPRESA) "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CONTA] DstCta ON (DstCta.ID_CONTA = Transf.ID_CONTA_DESTINO)  "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[BAIXA_PARCIAL] Bxa ON (Bxa.ID_CHEQUE = Chq.ID_CHEQUE) AND (Bxa.ID_CONTA = Chq.ID_CONTA)  AND (Bxa.VALOR = Chq.VALOR) "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[VENCTITULO] VctTit ON (VctTit.ID_VENCTITULO = Bxa.ID_VENCTITULO)  "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[TITULO] Titulo ON (Titulo.ID_TITULO = VctTit.ID_TITULO)  "
_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] Emp ON (Emp.ID_EMPRESA = DstCta.ID_EMPRESA) "

_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[OPERACIONAL] Oper ON Oper.ID_OPERACIONAL = Adto.ID_OPERACIONAL "

_qMvt += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[NOTA_COMPRA] NOTA ON (NOTA.ID_TITULO = Titulo.ID_TITULO) AND (NOTA.ID_EMPRESA = Titulo.ID_EMPRESA) "
_qMvt += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA2010] SA2 ON (SA2.A2_COD = (REPLICATE( '0', 6 - LEN( CAST(ISNULL(Titulo.ID_CLIENTE,0) AS VARCHAR(6)))) + CAST(ISNULL(Titulo.ID_CLIENTE,0) AS VARCHAR(6)))) AND (SA2.D_E_L_E_T_ <> '*') "

_qMvt += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA6010] SA6ORI ON (SA6ORI.A6_COD = (REPLICATE( '0', 3 - LEN( CAST(ISNULL(CtaOrig.ID_CONTA,999) AS VARCHAR(3)))) + CAST(ISNULL(CtaOrig.ID_CONTA,999) AS VARCHAR(3)))) AND (SA6ORI.D_E_L_E_T_ <> '*') "
_qMvt += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA6010] SA6DST ON (SA6DST.A6_COD = (REPLICATE( '0', 3 - LEN( CAST(ISNULL(DstCta.ID_CONTA,999) AS VARCHAR(3)))) + CAST(ISNULL(DstCta.ID_CONTA,999) AS VARCHAR(3)))) AND (SA6DST.D_E_L_E_T_ <> '*') "
//_qMvt += "WHERE (CONVERT( CHAR(8), Chq.EMISSAO , 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') " //--AND (Transf.ID_CHEQUE IS NOT NULL)

_qMvt += "WHERE (CONVERT( CHAR(8), Chq.DTCONCILIADO, 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') " //--AND (Transf.ID_CHEQUE IS NOT NULL)
_qMvt += " AND (Chq.SITUACAO <> 9) AND (Adto.ID_CHEQUE IS NULL) "

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qMvt),"MVT",.T.,.T.)

GrvMvtFin()

SE5->( dbSetOrder( _nIdxSE5 ) )

Return( NIL )


Static Function GrvMvtFin()

MVT->( dbGoTop() )

_lProcTra := .F.

While ! MVT->( Eof() )

   _cSE5 := 'SELECT COUNT(*) QDE FROM ' + RetSQLName( 'SE5' ) + " WHERE (D_E_L_E_T_ <> '*') "
   _cSE5 += "AND (E5_FILIAL  = '" + MVT->E5_FILIAL + "') "
   _cSE5 += "AND (E5_FILORIG = '" + if( MVT->E5_FILORIG <> '0000', MVT->E5_FILORIG, MVT->E5_FILIAL ) + "') "
   _cSE5 += "AND (E5_DATA    = '" + MVT->E5_DATA + "') "
   _cSE5 += "AND (E5_MOEDA   = '" + MVT->E5_MOEDA + "') "
   _cSE5 += "AND (E5_VALOR   = '" + ltrim( Str( MVT->E5_VALOR, 15, 2 ) ) + "') "
   _cSE5 += "AND (E5_NATUREZ = '" + MVT->E5_NATUREZ + "') "
   _cSE5 += "AND (E5_BANCO   = '" + MVT->E5_BANCO + "') "
   _cSE5 += "AND (E5_AGENCIA = '" + MVT->E5_AGENCIA + "') "
   _cSE5 += "AND (E5_CONTA   = '" + MVT->E5_CONTA + "') "
   _cSE5 += "AND (E5_RECPAG  = '" + MVT->E5_RECPAG + "') "

   If MVT->E5_RECPAG <> 'P'

      _cSE5 += "AND (E5_DOCUMEN = '" + MVT->E5_NUMCHEQ + "') "

   Else

      _cSE5 += "AND (E5_NUMCHEQ = '" + MVT->E5_NUMCHEQ  + "') "

   EndIf

   _cSE5 += "AND (E5_ORIGEM  = 'CTMPGSTQ') "

   dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cSE5),"QSE5",.T.,.T.)
   _nQde := QSE5->QDE
   QSE5->( dbCloseArea() )

   If _nQde = 0

      _dMvt := StoD( MVT->E5_DATA )

      RecLock( 'SE5', .T. )
      SE5->E5_FILIAL  := MVT->E5_FILIAL
      SE5->E5_FILORIG := if( MVT->E5_FILORIG <> '0000', MVT->E5_FILORIG, MVT->E5_FILIAL )
      SE5->E5_DATA    := _dMvt
      SE5->E5_MOEDA   := MVT->E5_MOEDA
      SE5->E5_VALOR   := MVT->E5_VALOR
      SE5->E5_NATUREZ := MVT->E5_NATUREZ
      SE5->E5_BANCO   := MVT->E5_BANCO
      SE5->E5_AGENCIA := MVT->E5_AGENCIA
      SE5->E5_CONTA   := MVT->E5_CONTA
      SE5->E5_RECPAG  := MVT->E5_RECPAG
      SE5->E5_BENEF   := SE5->E5_BENEF
      SE5->E5_HISTOR  := MVT->E5_HISTOR
      SE5->E5_TIPODOC := MVT->E5_TIPODOC
      SE5->E5_DTDISPO := Iif( ! Empty( MVT->E5_NUMCHEQ ), StoD( MVT->E5_DTCHQ )  , _dMvt )
      SE5->E5_DTDIGIT := _dMvt
   
      SE5->E5_DEBITO  := MVT->E5_DEBITO
      SE5->E5_CREDITO := MVT->E5_CREDITO

      If MVT->E5_RECPAG <> 'P'

         SE5->E5_DOCUMEN := MVT->E5_NUMCHEQ

      Else

         SE5->E5_NUMCHEQ := MVT->E5_NUMCHEQ

      EndIf

      SE5->E5_ORIGEM  := 'CTMPGSTQ'

      If MVT->E5_TIPODOC = 'TR'

         If ! ( _lProcTra )

            _cProcTra := GetSXENum( 'SE5','E5_PROCTRA' )
            _lProcTra := .T.

         Else

            _lProcTra := .F.

         EndIf

         SE5->E5_PROCTRA := _cProcTra

      EndIf

      If MVT->E5_TIPODOC = 'CH'

         SE5->E5_MOTBX := '  '
         GeraCheq()

      ElseIf MVT->E5_TIPODOC = 'CX'  /* Tratamento para o caixinha */

         SE5->E5_TIPODOC := 'VL'
         SE5->E5_MOTBX   := 'CHQ'

      Else

         SE5->E5_MOTBX := 'NOR'

      EndIf

      SE5->E5_SEQ    := '01'
      SE5->E5_ORIGBD := MVT->E5_ORIGBD //Montes - 06/05/2019
      If SE5->(FIELDPOS("E5_MSEXP")) > 0
         SE5->E5_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
      EndIf
      SE5->( MSUnLock() )
   
      If ( MVT->E5_TIPODOC = 'TR' ) .And.;
         ( _lProcTra  )

         ConfirmSX8()

      EndIf

   End

   MVT->( dbSkip() )

End

MVT->( dbCloseArea() )

Return( NIL )


Static Function GeraCheq()

RecLock( 'SEF', .T. )
SEF->EF_FILIAL  := MVT->E5_FILIAL
SEF->EF_FILORIG := MVT->E5_FILIAL
SEF->EF_BANCO   := MVT->E5_BANCO
SEF->EF_AGENCIA := MVT->E5_AGENCIA
SEF->EF_CONTA   := MVT->E5_CONTA
SEF->EF_NUM     := MVT->E5_NUMCHEQ
SEF->EF_VALOR   := MVT->E5_VALOR
SEF->EF_VALORBX := MVT->E5_VALOR
SEF->EF_DATA    := StoD( MVT->E5_DATA )
SEF->EF_IMPRESS := 'S'
SEF->EF_LIBER   := 'S'
SEF->EF_TERCEIR := .F.
SEF->EF_ORIGEM  := 'CTMPGSTQ' //'CTMPGST'
SEF->EF_BENEF   := MVT->E5_BENEF
SEF->EF_HIST    := MVT->E5_HISTOR
SEF->( MsUnLock() )

If MVT->E5_MOV <> 'M' .And.;
   ! Empty( MVT->E5_NUM )

   If ! ( SE5->( dbSeek( MVT->E5_FILIAL+MVT->E5_BANCO+MVT->E5_AGENCIA+MVT->E5_CONTA+MVT->E5_NUMCHEQ+'BA01', .F. ) ) )

      BxaTit()

   EndIf

EndIf

Return( NIL )


Static Function BxaTit()

   _dMvt := StoD( MVT->E5_DTCHQ )

   RecLock( 'SE5', .T. )
   SE5->E5_FILIAL  := MVT->E5_FILIAL
   SE5->E5_FILORIG := if( MVT->E5_FILORIG <> '0000', MVT->E5_FILORIG, MVT->E5_FILIAL )
   SE5->E5_DATA    := _dMvt
   SE5->E5_MOEDA   := '01'
   SE5->E5_VALOR   := MVT->E5_VALOR
   SE5->E5_NATUREZ := MVT->E5_NATUREZ
   SE5->E5_BANCO   := MVT->E5_BANCO
   SE5->E5_AGENCIA := MVT->E5_AGENCIA
   SE5->E5_CONTA   := MVT->E5_CONTA
   SE5->E5_RECPAG  := MVT->E5_RECPAG
   SE5->E5_BENEF   := SE5->E5_BENEF
   SE5->E5_HISTOR  := MVT->E5_HISTOR
   SE5->E5_TIPODOC := 'BA'
   SE5->E5_DTDISPO := _dMvt
   SE5->E5_DTDIGIT := _dMvt

   SE5->E5_PREFIXO := MVT->E5_SERIE
   SE5->E5_NUMERO  := if( Alltrim(MVT->E5_NUM) <> '0', StrZero( Val( MVT->E5_NUM ), 9 ), ' ')
   SE5->E5_PARCELA := MVT->E5_PARCELA
   SE5->E5_CLIFOR  := if( MVT->E5_CLIFOR <> 0, StrZero( MVT->E5_CLIFOR , 6 ), ' ')
   SE5->E5_LOJA    := if( MVT->E5_CLIFOR <> 0, '01', ' ')
   
   SE5->E5_DEBITO  := MVT->E5_DEBITO
   SE5->E5_CREDITO := MVT->E5_CREDITO

   If MVT->E5_RECPAG <> 'P'

      SE5->E5_DOCUMEN := MVT->E5_NUMCHEQ

   Else

      SE5->E5_NUMCHEQ := MVT->E5_NUMCHEQ

   EndIf

   SE5->E5_ORIGEM := 'CTMPGSTQ'
   SE5->E5_MOTBX  := 'NOR'
   SE5->E5_SEQ    := '01'
   SE5->E5_ORIGBD := MVT->E5_ORIGBD //Montes - 06/05/2019
   If SE5->(FIELDPOS("E5_MSEXP")) > 0
      SE5->E5_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
   EndIf
   SE5->( MSUnLock() )

Return( NIL )
