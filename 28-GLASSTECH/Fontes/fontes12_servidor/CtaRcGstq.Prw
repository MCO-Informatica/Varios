#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"                              
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
Static lAmbTst  := At("_TST", Upper(GetEnvServer())) > 0
Static cBDGSTQ	:= Iif(lAmbTst, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(lAmbTst, "BVTESTE"			, "BV"			)

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? CtaRcGstq ? Autor ? S?rgio Santana       ? Data ?25/08/2014???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Importacao Base de Dados                                   ???
???          ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???ALTERACAO ?                                                            ??? 
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? ThermoGlass                                                ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
//U_CtaRcGstq( '  ', '20160101', '20171231' , ' ', .T. )

User Function CtaRcGstq( _pTipo, _cDtIni, _cDtFim, _cPgt, _lInteg )

DEFAULT _pTipo  := '  '
DEFAULT _cPgt   := ' '
DEFAULT _cDtIni := DtoS( dDataBase )
DEFAULT _cDtFim := DtoS( dDataBase )
DEFAULT _lInteg := .F.

PRIVATE _cFilSA1 := xFilial( 'SA1' )

PutMV("MV_PCNFE",.F.)

If _pTipo <> 'BV'

   _qTit := 'WITH CTAREC ( '+CRLF
   _qTit += 'CNPJCLI,'+CRLF
   _qTit += 'cCgc,'+CRLF
   _qTit += 'E1_FILIAL,'+CRLF
   _qTit += 'E1_CLIENTE,'+CRLF
   _qTit += 'E1_NOMCLI,'+CRLF
   _qTit += 'E1_NUM,'+CRLF
   _qTit += 'E1_PARCELA,'+CRLF
   _qTit += 'E1_SERIE,'+CRLF
   _qTit += 'E1_VALOR,'+CRLF
   _qTit += 'E1_EMISSAO,'+CRLF
   _qTit += 'E1_VENCTO,'+CRLF
   _qTit += 'E1_CONTA,'+CRLF
   _qTit += 'E1_NATUREZ,'+CRLF
   _qTit += 'E1_BAIXA,'+CRLF
   _qTit += 'E1_DESCONT, '
   _qTit += 'E1_SALDO,'+CRLF
   _qTit += 'E1_PAGO,'+CRLF
   _qTit += 'E1_PORTADO,'+CRLF
   _qTit += 'ID_VENCTITULO, '+CRLF
   _qTit += 'E1_JUROS, '+CRLF
   _qTit += 'E5_FILIAL, '+CRLF
   _qTit += 'E1_TPLANC, '+CRLF
   _qTit += 'E1_CARTEIRA, '+CRLF
   _qTit += 'ID_NOTA, '+CRLF
   _qTit += 'ID_BAIXADOC, '+CRLF
   _qTit += 'ID_BAIXA_PARCIAL,'+CRLF
   _qTit += 'ID_PA, '+CRLF
   _qTit += 'E1_ORIGBD '  +CRLF
   _qTit += ')'+CRLF
   _qTit += ' AS '+CRLF
   _qTit += '('+CRLF
   _qTit += 'SELECT'+CRLF
   _qTit += "  CAST( REPLACE(REPLACE(REPLACE(CLIENTE.CPFCGC,'.',''),'/',''),'-','') AS VARCHAR(14) ) CNPJCLI,"+CRLF
   _qTit += "  CAST( REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') AS VARCHAR(14) ) cCgc,"+CRLF
   _qTit += '  TITULO.ID_EMPRESA E1_FILIAL,'+CRLF
   _qTit += '  TITULO.ID_CLIENTE E1_CLIENTE,'+CRLF
   _qTit += "  ISNULL(SA1.A1_NREDUZ,'') E1_NOMCLI,"+CRLF
//   _qTit += "  CAST(LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -2) AS VARCHAR(15)) E1_NUM,"
   _qTit += "  LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -2) E1_NUM,"+CRLF
   _qTit += '  CAST(RIGHT(VENCTIT.DOC, 3 ) AS CHAR(1)) E1_PARCELA,'+CRLF
   _qTit += "  CAST(CASE NOTA.SERIE WHEN '' THEN CASE NOTA.ID_EMPRESA WHEN 12 THEN '3' ELSE '' END ELSE NOTA.SERIE END AS CHAR(3)) E1_SERIE,"+CRLF
   _qTit += '  VENCTIT.VALOR E1_VALOR,'+CRLF
   _qTit += '  CONVERT(CHAR(8),VENCTIT.EMISSAO,112) E1_EMISSAO,'+CRLF
   _qTit += '  CONVERT(CHAR(8),VENCTIT.VENCIMENTO,112) E1_VENCTO,'+CRLF
   _qTit += "  CAST(REPLACE(PLANO.CODIGO,'.','') AS CHAR(12)) E1_CONTA,"+CRLF
   _qTit += "  CAST(ISNULL(OPER.NATUREZA,ISNULL(A1_NATUREZ,'99999')) AS CHAR(8)) E1_NATUREZ,"+CRLF
   _qTit += "  ISNULL(CONVERT( CHAR(8), BAIXA.DATA, 112), '        ') E1_BAIXA,"+CRLF
   _qTit += '  VENCTIT.DESCONTO E1_DESCONT,'
   _qTit += '  VENCTIT.SALDO E1_SALDO,'+CRLF
   _qTit += '  ISNULL(BAIXA.VALOR, 0) VALOR_PAGO,'+CRLF
   _qTit += " CASE WHEN EMP.CGC = '11.175.943/0001-71' THEN 101 ELSE ISNULL(CONTA.ID_CONTA,9999) END E1_PORTADO,"+CRLF
   _qTit += ' VENCTIT.ID_VENCTITULO, '+CRLF
   _qTit += ' ISNULL(BAIXA.JUROS,0) JUROS ,'+CRLF
   _qTit += " Case CONTA.ID_EMPRESA when 1 Then '0101' When 2 Then '0102' When 3 Then '0201' When 4 Then '0601' When 5 Then '0103' When 6 Then '0202' When 7 Then '0301' When 8 Then '0401' When 9 Then '0501' When 15 Then '0215' When 12 Then '0701' When 16 Then '0801' Else '0000' End E5_FILIAL, "+CRLF
   _qTit += " ISNULL(TITULO.TP_LANC, 0) E1_TPLANC, "+CRLF
   _qTit += " ISNULL(VENCTIT.ID_COBRANCA, 0) E1_CARTEIRA, "+CRLF
   _qTit += " CAST( ISNULL(NOTA.ID_NOTA, 0) AS VARCHAR( 15 ) ) ID_NOTA, "+CRLF
   _qTit += ' ISNULL(BAIXA.ID_BAIXADOC,0) ID_BAIXADOC, '+CRLF
   _qTit += ' ISNULL(BAIXA.ID_BAIXA_PARCIAL,0) ID_BAIXA_PARCIAL, '+CRLF
   _qTit += ' ISNULL(BAIXA.ID_ADIANTAMENTO_COMPENSACAO,0) ID_PA ,'+CRLF
   _qTit += " 'G' AS E1_ORIGBD "+CRLF
   _qTit += "FROM ["+cBDGSTQ+"].[dbo].[VENCTITULO] VENCTIT "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[TITULO] ON TITULO.ID_TITULO = VENCTIT.ID_TITULO "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[PLANO]  ON VENCTIT.ID_DEBITO = PLANO.ID_PLANO "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CLIENTE] ON CLIENTE.ID_CLIENTE = TITULO.ID_CLIENTE "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[OPERACIONAL] OPER ON OPER.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[BAIXA_PARCIAL] BAIXA ON BAIXA.ID_VENCTITULO = VENCTIT.ID_VENCTITULO "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CONTA] ON CONTA.ID_CONTA = BAIXA.ID_CONTA "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] EMP ON EMP.ID_EMPRESA = TITULO.ID_EMPRESA "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[NOTA] NOTA ON (NOTA.ID_TITULO = TITULO.ID_TITULO) AND (NOTA.ID_EMPRESA = TITULO.ID_EMPRESA) "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA1010] SA1 ON ( CAST( SA1.A1_COD AS INT)  = TITULO.ID_CLIENTE) "+CRLF
   _qTit += "WHERE ((CONVERT( CHAR(8), VENCTIT.EMISSAO, 112 ) = '" + _cDtIni + "') OR (ISNULL(CONVERT( CHAR(8), BAIXA.DATA, 112), '        ') BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "')) AND (TITULO.TIPOTITULO = 1) AND (VENCTIT.PAGO <> 'C')) "+CRLF
   _qTit += 'SELECT CTAREC.*, '+CRLF
   _qTit += "ISNULL(SUBSTRING(SA6.A6_NUMBCO,1,3),' ') A6_NUMBCO, "+CRLF
   _qTit += "ISNULL(SA6.A6_AGENCIA,' ') A6_AGENCIA, "+CRLF
   _qTit += "ISNULL(SA6.A6_NUMCON,' ') A6_NUMCON "+CRLF
   _qTit += 'FROM CTAREC '+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] EMP ON REPLACE(REPLACE(REPLACE(CASE ID_EMPRESA WHEN 14 THEN ' ' ELSE EMP.CGC END,'.',''),'/',''),'-','') = CTAREC.CNPJCLI "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA6010] SA6 ON (CTAREC.E1_PORTADO = SA6.A6_IDCONTA) AND (SA6.D_E_L_E_T_ <> '*') "+CRLF

   If ( _lInteg )

      _qTit += "where (EMP.CGC Is Null) AND (E1_EMISSAO = '" + _cDtFim + "') "+CRLF

   Else

      _qTit += "WHERE (EMP.CGC Is Null) AND (E1_CLIENTE <> 16496) AND"+CRLF // AND (E1_EMISSAO <= '" + _cDtFim + "')"
      _qTit += " ( NOT EXISTS (SELECT * FROM SE1010 SE1 WHERE (SE1.D_E_L_E_T_ <> '*') AND (SE1.E1_IDBOLET = CTAREC.ID_VENCTITULO)"+CRLF
      _qTit += " AND (CAST(SE1.E1_CLIENTE AS INT) = CTAREC.E1_CLIENTE) AND (SE1.E1_BAIXA = CTAREC.E1_BAIXA))"+CRLF
      _qTit +=  ")"+CRLF

   EndIf

Else

   _qTit := 'WITH CTAREC (CNPJCLI,cCgc,E1_FILIAL,E1_CLIENTE,E1_NOMCLI,E1_NUM,E1_PARCELA,E1_VALOR,E1_EMISSAO,E1_VENCTO,E1_CONTA,E1_NATUREZ,E1_BAIXA,E1_DESCONT,E1_SALDO,E1_PAGO,E1_PORTADO,ID_VENCTITULO,E1_JUROS,E1_TPSER, E5_FILIAL, E1_TPLANC, E1_CARTEIRA, ID_BAIXADOC, ID_BAIXA_PARCIAL, ID_PA, E1_ORIGBD ) AS '
   _qTit += '('
   _qTit += 'SELECT'
   _qTit += " CAST( REPLACE(REPLACE(REPLACE(CLIENTE.CPFCGC,'.',''),'/',''),'-','') AS VARCHAR(14) ) CNPJCLI,"
   _qTit += " CAST( REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') AS VARCHAR(14) ) cCgc,"
   _qTit += ' TITULO.ID_EMPRESA E1_FILIAL,'
   _qTit += ' TITULO.ID_CLIENTE E1_CLIENTE,
   _qTit += " ISNULL(SA1.A1_NREDUZ,'') E1_NOMCLI,"
   _qTit += " CAST(CASE WHEN SUBSTRING( VENCTIT.DOC,1,2) = '10' OR SUBSTRING( VENCTIT.DOC,1,2) = '20'"
   _qTit += "  THEN SUBSTRING( LTRIM(REPLACE(VENCTIT.DOC,'/','')), 3, LEN(LTRIM(REPLACE(VENCTIT.DOC,'/',''))) + -4)"
   _qTit += "  ELSE LEFT( LTRIM(REPLACE(VENCTIT.DOC,'/','')), LEN(LTRIM(REPLACE(VENCTIT.DOC,'/',''))) + -2)"
   _qTit += ' END AS VARCHAR(15) ) E1_NUM,'
   _qTit += ' CAST(RIGHT(VENCTIT.DOC, 3 ) AS CHAR(1)) E1_PARCELA,'
   _qTit += ' VENCTIT.VALOR E1_VALOR,'
   _qTit += ' CONVERT(CHAR(8),VENCTIT.EMISSAO,112) E1_EMISSAO,'
   _qTit += ' CONVERT(CHAR(8),VENCTIT.VENCIMENTO,112) E1_VENCTO,'
   _qTit += " CAST(REPLACE(ISNULL(PLANO.CODIGO,' '),'.','') AS CHAR(12)) E1_CONTA,"
   _qTit += " CAST(ISNULL(OPER.NATUREZA,'99999') AS CHAR(8)) E1_NATUREZ,"
   _qTit += " ISNULL(CONVERT( CHAR(8), BAIXA.DATA, 112), '        ') E1_BAIXA,"
   _qTit += ' VENCTIT.DESCONTO E1_DESCONT,'
   _qTit += ' VENCTIT.SALDO E1_SALDO,'+CRLF
   _qTit += ' ISNULL(BAIXA.VALOR, 0) VALOR_PAGO,'+CRLF
   _qTit += " CASE WHEN EMP.CGC = '11.175.943/0001-71' THEN 101 ELSE ISNULL(CONTA.ID_CONTA,999) END E1_PORTADO,"+CRLF
   _qTit += ' VENCTIT.ID_VENCTITULO, '+CRLF
   _qTit += ' ISNULL(BAIXA.JUROS,0) JUROS, '+CRLF               
   _qTit += ' SUBSTRING( VENCTIT.DOC,1,2) E1_TPSER, '+CRLF
   _qTit += " Case CONTA.ID_EMPRESA when 1 Then '0101' When 2 Then '0102' When 3 Then '0201' When 4 Then '0601' When 5 Then '0103' When 6 Then '0202' When 7 Then '0301' When 8 Then '0401' When 9 Then '0501' When 15 Then '0215' When 12 Then '0701' When 16 Then '0801' Else '0000' End E5_FILIAL, "+CRLF
   _qTit += " ISNULL(TITULO.TP_LANC, 0) E1_TPLANC, "+CRLF
   _qTit += " ISNULL(VENCTIT.ID_COBRANCA, 0) E1_CARTEIRA, "+CRLF   
   _qTit += ' ISNULL(BAIXA.ID_BAIXADOC,0) ID_BAIXADOC, '+CRLF
   _qTit += ' ISNULL(BAIXA.ID_BAIXA_PARCIAL,0) ID_BAIXA_PARCIAL, '+CRLF
   _qTit += ' ISNULL(BAIXA.ID_ADIANTAMENTO_COMPENSACAO,0) ID_PA, '+CRLF
   _qTit += " 'B' AS E1_ORIGBD "+CRLF

   _qTit += 'FROM [192.168.0.7].['+cBVGstq+'].[dbo].[VENCTITULO] VENCTIT '+CRLF
   _qTit += 'LEFT OUTER JOIN [192.168.0.7].['+cBVGstq+'].[dbo].[TITULO] TITULO ON TITULO.ID_TITULO = VENCTIT.ID_TITULO '+CRLF
   _qTit += 'LEFT OUTER JOIN [192.168.0.7].['+cBVGstq+'].[dbo].[PLANO] PLANO  ON VENCTIT.ID_DEBITO = PLANO.ID_PLANO '+CRLF
   _qTit += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CLIENTE] ON CLIENTE.ID_CLIENTE = TITULO.ID_CLIENTE '+CRLF
   _qTit += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OPER ON OPER.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '+CRLF
   _qTit += 'LEFT OUTER JOIN [192.168.0.7].['+cBVGstq+'].[dbo].[BAIXA_PARCIAL] BAIXA ON BAIXA.ID_VENCTITULO = VENCTIT.ID_VENCTITULO '+CRLF
   _qTit += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CONTA] ON CONTA.ID_CONTA = BAIXA.ID_CONTA '+CRLF
   _qTit += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[EMPRESA] EMP ON EMP.ID_EMPRESA = TITULO.ID_EMPRESA '+CRLF
   _qTit += 'LEFT OUTER JOIN ['+cBDPROT+'].[dbo].[SA1010] SA1 ON ( CAST( SA1.A1_COD AS INT)  = TITULO.ID_CLIENTE ) '+CRLF
   _qTit += "WHERE ((CONVERT( CHAR(8), VENCTIT.EMISSAO, 112 ) = '" + _cDtIni + "') OR (ISNULL(CONVERT( CHAR(8), BAIXA.DATA, 112), '        ') BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "')) AND (TITULO.TIPOTITULO = 1) AND (VENCTIT.PAGO <> 'C')) "+CRLF
   _qTit += "SELECT CTAREC.* , CASE ISNULL(NOTA.SERIE, ' ') WHEN ' ' THEN CASE CTAREC.E1_TPSER WHEN '10' THEN '1  ' ELSE CAST(ISNULL(PRENOT.SERIE,'3') AS CHAR(3)) END ELSE CAST(NOTA.SERIE AS CHAR(3)) END E1_SERIE,"+CRLF
   _qTit += "ISNULL(SUBSTRING(SA6.A6_NUMBCO,1,3),' ') A6_NUMBCO, "+CRLF
   _qTit += "ISNULL(SA6.A6_AGENCIA,' ') A6_AGENCIA, "+CRLF
   _qTit += "ISNULL(SA6.A6_NUMCON,' ') A6_NUMCON, "+CRLF
   _qTit += " CAST( ISNULL(NOTA.ID_NOTA, 0) AS VARCHAR( 15 ) ) ID_NOTA "+CRLF
   _qTit += 'FROM CTAREC '+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] EMP ON REPLACE(REPLACE(REPLACE(CASE ID_EMPRESA WHEN 14 THEN ' ' ELSE EMP.CGC END,'.',''),'/',''),'-','') = CTAREC.CNPJCLI "+CRLF
   _qTit += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[NOTA] NOTA ON (NOTA.NRO_NF = CTAREC.E1_NUM) AND (CONVERT(CHAR(8),NOTA.EMISSAO,112) = CTAREC.E1_EMISSAO) '+CRLF
   _qTit += "AND ((CTAREC.cCgc <> '11175943000171' AND NOTA.SERIE <> '1') OR (CTAREC.cCgc = '11175943000171' AND ((CTAREC.E1_TPSER = '20' AND NOTA.SERIE = '1') OR (CTAREC.E1_TPSER = '10' AND NOTA.SERIE = '3')))) "+CRLF
   _qTit += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PRE_NOTA] PRENOT ON (PRENOT.NRO_NF = CTAREC.E1_NUM) AND (CONVERT(CHAR(8),PRENOT.EMISSAO,112) = CTAREC.E1_EMISSAO) '+CRLF
   _qTit += "AND ((CTAREC.cCgc <> '11175943000171') OR (CTAREC.cCgc = '11175943000171' AND ((CTAREC.E1_TPSER = '20' AND PRENOT.SERIE = '1') OR (CTAREC.E1_TPSER = '20' AND PRENOT.SERIE = '3')))) "+CRLF
   _qTit += "LEFT OUTER JOIN ["+cBDPROT+"].[dbo].[SA6010] SA6 ON (CTAREC.E1_PORTADO = SA6.A6_IDCONTA) AND (SA6.D_E_L_E_T_ <> '*') "+CRLF

   If ( _lInteg )

      _qTit += "where (EMP.CGC Is Null) AND (E1_EMISSAO = '" + _cDtFim + "') "+CRLF

   Else

      _qTit += "WHERE (EMP.CGC Is Null) AND (E1_CLIENTE <> 16496) AND"+CRLF // AND (E1_EMISSAO <= '" + _cDtFim + "')"
      _qTit += " ( NOT EXISTS (SELECT * FROM SE1010 SE1 WHERE (SE1.D_E_L_E_T_ <> '*') AND (SE1.E1_IDBOLET = CTAREC.ID_VENCTITULO)"+CRLF
      _qTit += " AND (CAST(SE1.E1_CLIENTE AS INT) = CTAREC.E1_CLIENTE) AND (SE1.E1_BAIXA = CTAREC.E1_BAIXA))"+CRLF
      _qTit +=  ")"+CRLF

   EndIf

EndIf

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qTit),"TIT",.T.,.T.)

TIT->( dbGoTop() )
SE1->( dbSetOrder( 2 ) )
SE5->( dbSetOrder( 7 ) )
                           
While ! ( TIT->( Eof() ) )
	
    _cFilSE1 := U_GestqFil(TIT->cCgc,_pTipo)

    _aNaturez := MultNat( lTrim( Str( TIT->ID_VENCTITULO, 12, 0 ) ), _pTipo )
//                       E1_FILIAL          E1_CLIENTE+E1_LOJA       E1_PREFIXO            E1_NUM                     E1_PARCELA     E1_TIPO

    //Tratamento para ambiente de testes
    SE1->( dbSetOrder( 1 ) ) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
    If SE1->(DbSeek(_cFilSE1+TIT->E1_SERIE+StrZero(Val(rTrim(TIT->E1_NUM)),9)+TIT->E1_PARCELA+'NF ')) .AND. lAmbTst
    	Alert("Identificado registro com chave duplicada, ser? deletado por estar em ambiente de testes")
    	RecLock("SE1", .F.)
    		SE1->(DbDelete())
    	SE1->(MsUnLock())
    EndIf

    SE1->( dbSetOrder( 2 ) )


    If ! (SE1->( dbSeek( _cFilSE1 + StrZero(TIT->E1_CLIENTE,6)+'01'+TIT->E1_SERIE+StrZero(Val(rTrim(TIT->E1_NUM)),9)+TIT->E1_PARCELA+'NF ', .F. ) ))
       //Se n?o encontrou, faz uma consist?ncia para saber se o id do Gestoq j? existe na base protheus.
       _nIdxSE1 := SE1->( IndexOrd() )
       SE1->( dbSetOrder( 32 ) )
       If SE1->( dbSeek( Str( TIT->ID_VENCTITULO, 9, 0 )+TIT->E1_ORIGBD ) )
       		//Este tratamento ? SOMENTE para o ambiente de testes, para evitar conflitos de base.
       		If lAmbTst
       			MsgAlert("Id do Titulo Gestoq j? existente na base, ser? excluido devido ambiente de testes.", "Titulo existente")
       			RecLock("SE1", .F.)
       				SE1->(DbDelete())
       			SE1->(MsUnLock())
       			
       			SE1->( dbSeek( Str( TIT->ID_VENCTITULO, 9, 0 )+TIT->E1_ORIGBD ) )
       		EndIf 
       EndIf
       SE1->( dbSetOrder( _nIdxSE1 ) )

    EndIf

    If ! (SE1->( Found()))
  
       If Empty( TIT->E1_NOMCLI )

          IncCadCli( StrZero(TIT->E1_CLIENTE,6) )

       EndIf

       RecLock( 'SE1', .T. )
       SE1->E1_FILIAL  := _cFilSE1
       SE1->E1_FILORIG := _cFilSE1
       SE1->E1_MSFIL   := _cFilSE1
       SE1->E1_TIPO    := 'NF '
       SE1->E1_MSEMP  := '01'
       SE1->E1_STATUS  := 'A'
       SE1->E1_CLIENTE := StrZero( TIT->E1_CLIENTE, 6 )
       SE1->E1_LOJA    := '01'
       SE1->E1_NOMCLI := TIT->E1_NOMCLI
       SE1->E1_NUM     := StrZero(Val(rTrim(TIT->E1_NUM)),9)
       SE1->E1_PARCELA := TIT->E1_PARCELA
       SE1->E1_SERIE   := TIT->E1_SERIE
       SE1->E1_PREFIXO := TIT->E1_SERIE
       SE1->E1_VALOR   := TIT->E1_VALOR
       SE1->E1_VLCRUZ  := TIT->E1_VALOR
       SE1->E1_DECRESC := TIT->E1_DESCONT
       SE1->E1_SALDO   := TIT->E1_SALDO   //TIT->E1_VALOR
       SE1->E1_JUROS   := TIT->E1_JUROS
       SE1->E1_EMISSAO := StoD( TIT->E1_EMISSAO )
       SE1->E1_EMIS1   := StoD( TIT->E1_EMISSAO )
       SE1->E1_VENCTO  := StoD( TIT->E1_VENCTO )
       SE1->E1_VENCREA := StoD( TIT->E1_VENCTO )
       SE1->E1_VENCORI := StoD( TIT->E1_VENCTO )
       SE1->E1_MULTNAT := _aNaturez[2]
       SE1->E1_NATUREZ := if( ! Empty( _aNaturez[1] ) .And. Substr(_aNaturez[1],1,5) <> '99999' , _aNaturez[1], SA1->A1_NATUREZ  )
       
       //Teste para verificar erro questionado de natureza em branco.
       SE1->E1_NATUREZ := Iif(Empty(SE1->E1_NATUREZ), '99999', SE1->E1_NATUREZ)
       
/*       SE1->E1_PORTADO := TIT->A6_NUMBCO //if( TIT->E1_PORTADO <> 0, StrZero( TIT->E1_PORTADO, 3 ), ' ' ) Excluida a atualiza??o da carteira em 16/05/2017
       SE1->E1_CONTA   := TIT->A6_NUMCON
       SE1->E1_AGEDEP  := TIT->A6_AGENCIA*/
       
       SE1->E1_FLUXO   := 'S'
       SE1->E1_APLVLMN := '1'
       SE1->E1_PROJPMS := '2'
       SE1->E1_DESDOBR := '2'
       SE1->E1_MOEDA   := 1
       SE1->E1_FRETISS := '1'
       SE1->E1_IDBOLET := TIT->ID_VENCTITULO
       SE1->E1_ORIGBD  := TIT->E1_ORIGBD

       /*
          0=Carteira
          1=Cob.Simples
          2=Descontada
          3=Caucionada
          4=Vinculada
          5=Advogado
          6=Judicial          
       */
       
/*       If (TIT->E1_CARTEIRA > 1) // Excluida a atualiza??o da carteira em 16/05/2017
       
          If ( TIT->E1_CARTEIRA = 152 ) .Or.;
             ( TIT->E1_CARTEIRA = 145 ) .Or.;
             ( TIT->E1_CARTEIRA =  35 ) .Or.;
             ( TIT->E1_CARTEIRA =  84 ) .Or.;
             ( TIT->E1_CARTEIRA =  93 ) .Or.;
             ( TIT->E1_CARTEIRA = 117 ) .Or.;
             ( TIT->E1_CARTEIRA = 124 ) .Or.;
             ( TIT->E1_CARTEIRA = 125 ) .Or.;
             ( TIT->E1_CARTEIRA = 136 ) .Or.;
             ( TIT->E1_CARTEIRA = 137 ) .Or.;
             ( TIT->E1_CARTEIRA = 144 )
             
             SE1->E1_SITUACA := '3'
             
          ElseIf ( TIT->E1_CARTEIRA = 135 ) .Or.;
             ( TIT->E1_CARTEIRA = 134 ) .Or.;
             ( TIT->E1_CARTEIRA = 120 ) .Or.;
             ( TIT->E1_CARTEIRA = 121 ) .Or.;
             ( TIT->E1_CARTEIRA = 130 ) .Or.;
             ( TIT->E1_CARTEIRA = 131 ) .Or.;
             ( TIT->E1_CARTEIRA = 132 ) .Or.;
             ( TIT->E1_CARTEIRA = 133 ) .Or.;
             ( TIT->E1_CARTEIRA = 154 ) .Or.;
             ( TIT->E1_CARTEIRA = 155 ) .Or.;
             ( TIT->E1_CARTEIRA = 156 ) .Or.;
             ( TIT->E1_CARTEIRA = 157 ) .Or.;
             ( TIT->E1_CARTEIRA = 159 ) .Or.;
             ( TIT->E1_CARTEIRA = 161 ) .Or.;
             ( TIT->E1_CARTEIRA =  84 )

             SE1->E1_SITUACA := '2'

          Else // 24,115

             SE1->E1_SITUACA := '1'

          End

       Else

          SE1->E1_SITUACA := '0'

       End*/

       If SF2->( dbSeek( _cFilSE1+StrZero(Val(rTrim(TIT->E1_NUM)),9)+TIT->E1_SERIE+StrZero( TIT->E1_CLIENTE, 6 )+'01'+'S'+'N', .F. ) )

          SE1->E1_ORIGEM  := 'MATA460'
          SE1->E1_LA      := 'S'

       Else

          SE1->E1_ORIGEM  := 'FINA040'

       EndIf
       If SE1->(FIELDPOS("E1_MSEXP")) >  0
          SE1->E1_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
       EndIf
       SE1->( dbUnLock() )

//    Else


//       RecLock( 'SE1', .F. )

/*       If (TIT->E1_CARTEIRA <> 1)
       
          If ( TIT->E1_CARTEIRA = 152 ) .Or.;
             ( TIT->E1_CARTEIRA = 145 )
             
             SE1->E1_SITUACA := '3'
             
          ElseIf ( TIT->E1_CARTEIRA = 135 ) .Or.;
             ( TIT->E1_CARTEIRA = 134 ) .Or.;
             ( TIT->E1_CARTEIRA = 154 )

             SE1->E1_SITUACA := '2'

          Else // 24,115

             SE1->E1_SITUACA := '1'

          End

       Else

          SE1->E1_SITUACA := '0'

       End*/

/*       If (TIT->E1_CARTEIRA > 1) Excluida a atualiza??o da carteira em 16/05/2017
       
          If ( TIT->E1_CARTEIRA = 152 ) .Or.;
             ( TIT->E1_CARTEIRA = 145 ) .Or.;
             ( TIT->E1_CARTEIRA =  35 ) .Or.;
             ( TIT->E1_CARTEIRA =  84 ) .Or.;
             ( TIT->E1_CARTEIRA =  93 ) .Or.;
             ( TIT->E1_CARTEIRA = 117 ) .Or.;
             ( TIT->E1_CARTEIRA = 124 ) .Or.;
             ( TIT->E1_CARTEIRA = 125 ) .Or.;
             ( TIT->E1_CARTEIRA = 136 ) .Or.;
             ( TIT->E1_CARTEIRA = 137 ) .Or.;
             ( TIT->E1_CARTEIRA = 144 )
             
             SE1->E1_SITUACA := '3'
             
          ElseIf ( TIT->E1_CARTEIRA = 135 ) .Or.;
             ( TIT->E1_CARTEIRA = 134 ) .Or.;
             ( TIT->E1_CARTEIRA = 120 ) .Or.;
             ( TIT->E1_CARTEIRA = 121 ) .Or.;
             ( TIT->E1_CARTEIRA = 130 ) .Or.;
             ( TIT->E1_CARTEIRA = 131 ) .Or.;
             ( TIT->E1_CARTEIRA = 132 ) .Or.;
             ( TIT->E1_CARTEIRA = 133 ) .Or.;
             ( TIT->E1_CARTEIRA = 154 ) .Or.;
             ( TIT->E1_CARTEIRA = 155 ) .Or.;
             ( TIT->E1_CARTEIRA = 156 ) .Or.;
             ( TIT->E1_CARTEIRA = 157 )

             SE1->E1_SITUACA := '2'

          Else // 24,115

             SE1->E1_SITUACA := '1'

          End

       Else

          SE1->E1_SITUACA := '0'

       End

       SE1->E1_PORTADO := TIT->A6_NUMBCO //if( TIT->E1_PORTADO <> 0, StrZero( TIT->E1_PORTADO, 3 ), ' ' )
       SE1->E1_AGEDEP  := TIT->A6_AGENCIA
       SE1->E1_CONTA   := TIT->A6_NUMCON*/

//       SE1->( dbUnLock() )

    EndIf

    If ( _cFilSE1 + TIT->E1_SERIE+StrZero(Val(rTrim(TIT->E1_NUM)),9)+TIT->E1_PARCELA+'NF '+StrZero(TIT->E1_CLIENTE,6)+'01' =;
         _cFilSE1 + SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+'01';
       ) .And.;
       ( _cPgt = 'B' ) .And.;
       ! Empty( TIT->E1_BAIXA ) .And.;
       (TIT->ID_PA = 0) .And.;
       (TIT->ID_BAIXADOC > -1 )
       
       _lFound := ( SE5->( dbSeek( _cFilSE1+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+'01' , .F. ) ) )

       If ! ( _lFound ) .Or.;
          ( ( _lFound ) .And. ( SE5->E5_IDMOVI <> Str( TIT->ID_BAIXA_PARCIAL, 10, 0 ) ) )

          BxaTit()

       ElseIf ( SE5->E5_TIPODOC = 'D2' )

          BxaTit()
    
       EndIf

    EndIf

    TIT->( dbSkip() )

EndDo

TIT->( dbCloseArea() )
SE1->( dbSetOrder( 1 ) )
SE5->( dbSetOrder( 1 ) )

Return( NIL )

Static Function BxaTit()
Local _cSeq := SE5->E5_SEQ

RecLock( 'SE1', .F. )
SE1->E1_BAIXA   := StoD( TIT->E1_BAIXA )
SE1->E1_PORTADO := TIT->A6_NUMBCO    //If( TIT->E1_PORTADO <> 0, StrZero( TIT->E1_PORTADO, 3 ), '   ' )
SE1->E1_MOVIMEN := StoD( TIT->E1_BAIXA )
SE1->E1_SALDO   := TIT->E1_SALDO
SE1->E1_VALLIQ  := SE1->E1_VALOR - TIT->E1_SALDO
SE1->E1_STATUS  := 'B'
If SE1->(FIELDPOS("E1_MSEXP")) >  0
   SE1->E1_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
EndIf
SE1->( MSUnLock() )

RecLock( 'SE5', .T. )
SE5->E5_FILIAL  := if( TIT->E5_FILIAL <> '0000', if( TIT->E1_PORTADO <> 101,TIT->E5_FILIAL,TIT->E5_FILIAL), SE1->E1_FILIAL ) //ver banco 101 recebimento
SE5->E5_DATA    := SE1->E1_BAIXA
SE5->E5_TIPO    := SE1->E1_TIPO
SE5->E5_MOEDA   := '01'
SE5->E5_VALOR   := TIT->E1_PAGO
SE5->E5_VLMOED2 := TIT->E1_PAGO
SE5->E5_NATUREZ := SE1->E1_NATUREZ
SE5->E5_BANCO   := TIT->A6_NUMBCO  //SE1->E1_PORTADO
SE5->E5_AGENCIA := TIT->A6_AGENCIA
SE5->E5_CONTA   := TIT->A6_NUMCON
SE5->E5_BENEF   := SE1->E1_NOMCLI
SE5->E5_VLJUROS := TIT->E1_JUROS
SE5->E5_DOCUMEN := if( TIT->ID_VENCTITUTO <> 0, lTrim( Str( TIT->ID_VENCTITUTO, 0 ) ), ' ' )

If SE5->E5_BANCO <> '066'
   SE5->E5_RECPAG  := 'R'
   SE5->E5_HISTOR  := 'Valor recebido s/ Titulo'
   SE5->E5_TIPODOC := 'VL'
Else
   SE5->E5_RECPAG  := 'P'
   SE5->E5_HISTOR  := 'Descont s/Pgto de Titulo'
   SE5->E5_TIPODOC := 'D2'
End

SE5->E5_PREFIXO := SE1->E1_PREFIXO
SE5->E5_NUMERO  := SE1->E1_NUM
SE5->E5_PARCELA := SE1->E1_PARCELA
SE5->E5_CLIFOR  := SE1->E1_CLIENTE
SE5->E5_LOJA    := SE1->E1_LOJA
SE5->E5_DTDIGIT := SE1->E1_BAIXA

If TIT->E1_TPLANC <> 2

   SE5->E5_MOTBX   := 'NOR'

Else

   SE5->E5_MOTBX   := 'FAT'   

End

_cSeq := Soma1( _cSeq, 2 )

SE5->E5_SEQ     := _cSeq
SE5->E5_DTDISPO := SE1->E1_BAIXA
SE5->E5_FILORIG := SE1->E1_FILIAL
SE5->E5_CLIENTE := SE1->E1_CLIENTE
SE5->E5_ORIGEM  := 'CTARGSTQ'
SE5->E5_TPDESC  := 'I'
SE5->E5_IDMOVI  := Str( TIT->ID_BAIXA_PARCIAL, 10, 0 )
SE5->E5_ORIGBD  := SE1->E1_ORIGBD
If SE5->(FIELDPOS("E5_MSEXP")) >  0
   SE5->E5_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
EndIf
SE5->( MSUnLock() )

If TIT->E1_JUROS <> 0
                       
   LctJur()

End


Return( NIL )      

Static Function MultNat( _idTitulo, _pTipo )

_cQry := 'SELECT '
_cQry +=    'ID_VENCTITULO,'
_cQry +=    'EV_NUM,'
_cQry +=    'EV_PARCELA,'
_cQry +=    'ID_CLIENTE EV_CLIFOR,'
_cQry +=    'CASE EV_NATUREZ '
_cQry +=        "WHEN 'L' THEN '10101' " // VENDAS LAMINADOS
_cQry +=        "WHEN 'T' THEN '10102' " // VENDAS TEMPERADOS
_cQry +=        "WHEN 'O' THEN '10105' " // VENDAS DE SUCATAS
_cQry +=        "WHEN 'K' THEN '10109' " // VENDAS DE KIT
_cQry +=        "WHEN 'P' THEN '10110' " // VENDAS DE SUCATA PVB
_cQry +=    'END EV_NATUREZ,'
_cQry +=    'ROUND(NOTA.VLR_TOT_NOTA * round(RATEIO.TotalNat / NOTA.VLR_TOT_NOTA, 4), 2 ) EV_VALOR,'
_cQry +=    'ROUND(RATEIO.TotalNat / NOTA.VLR_TOT_NOTA, 4) EV_PERC '
_cQry += 'FROM ['+cBDGSTQ+'].[dbo].[NOTA] NOTA,'
_cQry += '('
_cQry +=   'SELECT '
_cQry +=      'NOTA.ID_NOTA,'
_cQry +=      'VCTIT.ID_VENCTITULO,'
_cQry +=      "LEFT(REPLACE(VCTIT.DOC,'/',''),LEN(REPLACE(VCTIT.DOC,'/','')) + -2) EV_NUM,"
_cQry +=      'CAST(RIGHT(VCTIT.DOC, 3 ) AS CHAR(1)) EV_PARCELA,'
_cQry +=      'CASE PRD.TIPO '
_cQry +=        " WHEN 'T' THEN 'T'"
_cQry +=        " WHEN 'L' THEN 'L'"
_cQry +=        " WHEN 'V' THEN 'V'"
_cQry +=        ' ELSE '
_cQry +=           'CASE '
_cQry +=             " WHEN PRD.ID_SERIE = 82 THEN 'P' "
_cQry +=             " WHEN SUBSTRING( PRD.CATALOGO, 1, 4) = 'KIT-' THEN 'K' "
_cQry +=             " ELSE 'O' "
_cQry +=           ' END '
_cQry +=     'END EV_NATUREZ, '
_cQry +=   'SUM( (ISNULL(ITEM.TOTAL_ITEM,0) + ISNULL(ITEM.VlrSubTrib,0) + ISNULL(ITEM.VLR_IPI,0)) - ISNULL(ITEM.Desconto,0) ) TotalNat '

If _pTipo <> 'BV'

   _cQry +=   'FROM ['+cBDGSTQ+'].[dbo].[NOTA] NOTA WITH (NOLOCK) '
   _cQry +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ITEM_NOTA] ITEM WITH (NOLOCK) ON NOTA.ID_NOTA = ITEM.ID_NOTA '
   _cQry +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PRODUTO] PRD WITH (NOLOCK) ON PRD.ID_PRODUTO = ITEM.ID_PRODUTO '
   _cQry +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[VENCTITULO] VCTIT WITH (NOLOCK) ON VCTIT.ID_TITULO = NOTA.ID_TITULO '

Else

   _cQry +=   'FROM ['+cBDGSTQ+'].[dbo].[NOTA] NOTA WITH (NOLOCK) '
   _cQry +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ITEM_NOTA] ITEM WITH (NOLOCK) ON NOTA.ID_NOTA = ITEM.ID_NOTA '
   _cQry +=   'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PRODUTO] PRD WITH (NOLOCK) ON PRD.ID_PRODUTO = ITEM.ID_PRODUTO '
   _cQry +=   "LEFT OUTER JOIN [192.168.0.7].["+cBVGstq+"].[dbo].[VENCTITULO] VCTIT WITH (NOLOCK) ON (VCTIT.ID_VENCTITULO = " + _idTitulo + ") "

End

_cQry +=   'WHERE '
_cQry +=   " (NOTA.ID_NOTA = " + TIT->ID_NOTA + ") "
_cQry +=   'GROUP BY '
_cQry +=   'NOTA.ID_NOTA,'
_cQry +=      'CASE PRD.TIPO '
_cQry +=        " WHEN 'T' THEN 'T'"
_cQry +=        " WHEN 'L' THEN 'L'"
_cQry +=        " WHEN 'V' THEN 'V'"
_cQry +=        ' ELSE '
_cQry +=           'CASE '
_cQry +=             " WHEN PRD.ID_SERIE = 82 THEN 'P' "
_cQry +=             " WHEN SUBSTRING( PRD.CATALOGO, 1, 4) = 'KIT-' THEN 'K' "
_cQry +=             " ELSE 'O' "
_cQry +=           ' END '
_cQry +=     'END , '
_cQry +=   'VCTIT.ID_VENCTITULO, '
_cQry +=   'VCTIT.DOC, CAST(RIGHT(VCTIT.DOC, 3 ) AS CHAR(1))'
_cQry +=   ') RATEIO '
_cQry +=   "WHERE (RATEIO.ID_NOTA = NOTA.ID_NOTA) AND (NOTA.POS <> 'C') AND (RATEIO.TotalNat <> 0)"
_cQry +=   'ORDER BY EV_NUM, EV_PARCELA, EV_CLIFOR, ROUND(RATEIO.TotalNat / NOTA.VLR_TOT_NOTA, 4)'

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cQry),"NAT",.T.,.T.)

_cNaturez := NAT->EV_NATUREZ
_nMultNat := 0

While ! ( NAT->( Eof() ) )

   If NAT->EV_PERC < 1

      If ! ( SEV->( dbSeek( _cFilSE1+TIT->E1_SERIE+StrZero(Val(rTrim(TIT->E1_NUM)),9)+TIT->E1_PARCELA+'NF '+StrZero(TIT->E1_CLIENTE,6)+'01'+NAT->EV_NATUREZ, .F. ) ) )

         RecLock( 'SEV', .T. )
         SEV->EV_FILIAL  := _cFilSE1
         SEV->EV_PREFIXO := TIT->E1_SERIE
         SEV->EV_NUM     := StrZero(Val(rTrim(TIT->E1_NUM)),9)
         SEV->EV_PARCELA := TIT->E1_PARCELA
         SEV->EV_CLIFOR  := StrZero(TIT->E1_CLIENTE,6)
         SEV->EV_LOJA    := '01'
         SEV->EV_TIPO    := 'NF '
         SEV->EV_NATUREZ := NAT->EV_NATUREZ
         SEV->EV_RECPAG  := 'R'
         SEV->EV_IDENT   := '1'
   
      Else

         RecLock( 'SEV', .F. )

      End

      SEV->EV_VALOR   := TIT->E1_VALOR * NAT->EV_PERC
      SEV->EV_PERC    := NAT->EV_PERC
      SEV->( MsUnLock() )
      _nMultNat ++
      
   End
   
   NAT->( dbSkip() )

End

If _nMultNat > 1
 
   _cMultNat := '1'

Else

   _cMultNat := '2'

End

NAT->( dbCloseArea() )

Return( { _cNaturez, _cMultNat } )

Static Function LctJur()

RecLock( 'SE5', .T. )
SE5->E5_FILIAL  := SE1->E1_FILIAL
SE5->E5_DATA    := SE1->E1_BAIXA
SE5->E5_TIPO    := SE1->E1_TIPO
SE5->E5_MOEDA   := '01'
SE5->E5_VALOR   := SE1->E1_JUROS
SE5->E5_VLMOED2 := SE1->E1_JUROS
SE5->E5_NATUREZ := SE1->E1_NATUREZ
SE5->E5_BANCO   := TIT->A6_NUMBCO //SE1->E1_PORTADO
SE5->E5_AGENCIA := TIT->A6_AGENCIA
SE5->E5_CONTA   := TIT->A6_NUMCON
SE5->E5_BENEF   := SE1->E1_NOMCLI
SE5->E5_DOCUMEN := if( TIT->ID_VENCTITULO <> 0, lTrim( Str( TIT->ID_VENCTITULO, 0 ) ), ' ' )
SE5->E5_RECPAG  := 'R'
SE5->E5_HISTOR  := 'Juros s/Receb.Titulo'
SE5->E5_TIPODOC := 'JR'

SE5->E5_PREFIXO := SE1->E1_PREFIXO
SE5->E5_NUMERO  := SE1->E1_NUM
SE5->E5_PARCELA := SE1->E1_PARCELA
SE5->E5_CLIFOR  := SE1->E1_CLIENTE
SE5->E5_LOJA    := SE1->E1_LOJA
SE5->E5_DTDIGIT := SE1->E1_BAIXA
SE5->E5_MOTBX   := 'NOR'
SE5->E5_SEQ     := '01'
SE5->E5_DTDISPO := SE1->E1_BAIXA
SE5->E5_FILORIG := SE1->E1_FILIAL
SE5->E5_CLIENTE := SE1->E1_CLIENTE
SE5->E5_ORIGEM  := 'CTARGSTQ'
SE5->E5_TPDESC  := 'I'
SE5->E5_IDMOVI  := Str( TIT->ID_BAIXA_PARCIAL, 10, 0 )
SE5->E5_ORIGBD  := SE1->E1_ORIGBD
If SE5->(FIELDPOS("E5_MSEXP")) > 0
   SE5->E5_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
EndIf
SE5->( MSUnLock() )

Return( NIL )

/*
  
  Inclui cadastro de cliente com origem do GESTOQ
       
*/
Static Function IncCadCli( cCod )

    If ! SA1->( dbSeek( _cFilSA1 + cCod + '01', .F. ) )

       _qCli := "SELECT ID_CLIENTE, NOME, FANTASIA, ENDERECO, COMPL_END, REPLACE(REPLACE(CEP,'.',''),'-','') CEP, BAIRRO, ATIV.SUBST_TRIB SUBTRIB, "
       _qCli += "RGINSC, INTERNET eMail, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-','') TELEFONE, CONTATO, CONVERT(CHAR(8),CADASTRO,112) CADASTRO, CONVERT( CHAR(8), ULT_COMPRA,112) ULT_COMPRA, CLIENTE.SUFRAMA,"
       _qCli += "REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') CPFCGC, CIDADE.DESCRICAO, UF, COD_UF, MUNICIPIO , PAIS, REPLACE(ISNULL(PLANO.CODIGO,'112010001'),'.','') CONTA"
       _qCli += ' FROM ['+cBDGSTQ+'].[dbo].[CLIENTE] '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CIDADE] ON CIDADE.ID_CIDADE = CLIENTE.ID_CIDADE '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ATIVIDADE] ATIV ON ATIV.ID_ATIVIDADE = CLIENTE.ID_ATIVIDADE '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PLANO] ON PLANO.ID_PLANO = OP.ID_PLANO_CR '
       _qCli += "WHERE (CLIENTE.ID_CLIENTE = " + cCod + ")"

       dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qCli),"CLI",.T.,.T.)
       
       RecLock( 'SA1', .T. )
       SA1->A1_COD     := StrZero( CLI->ID_CLIENTE, 6 )
       SA1->A1_LOJA    := '01'
       SA1->A1_NOME    := CLI->NOME
       SA1->A1_NREDUZ  := CLI->FANTASIA
       SA1->A1_INSCR   := UPPER(CLI->RGINSC)
       SA1->A1_CGC     := CLI->CPFCGC
       SA1->A1_CEP     := CLI->CEP
       SA1->A1_MUN     := CLI->DESCRICAO
       SA1->A1_COD_MUN := CLI->MUNICIPIO
       SA1->A1_PAIS    := SUBSTR( CLI->PAIS,1,3 )
       SA1->A1_CODPAIS := '0' + SUBSTR( CLI->PAIS,1, 4 )	
       SA1->A1_TEL     := CLI->TELEFONE
       SA1->A1_END     := CLI->ENDERECO
       SA1->A1_EST     := CLI->UF
       SA1->A1_BAIRRO  := CLI->BAIRRO
       SA1->A1_PESSOA  := if( Len(RTRIM(CLI->CPFCGC)) <> 14, 'F', 'J' )
       SA1->A1_TIPO    := iif( CLI->SUBTRIB <> 'S', 'R', 'S' )
       SA1->A1_PRICOM  := STOD( CLI->CADASTRO ) 
       SA1->A1_ULTCOM  := STOD( TIT->E1_EMISSAO )
       SA1->A1_CONTA   := CLI->CONTA
       SA1->A1_NATUREZ := '10101'
       SA1->( dbUnLock() )
       
       CLI->( dbCloseArea() )

    EndIf

Return( NIL )
