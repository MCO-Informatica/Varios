#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

/*
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? 
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? CtaAdGstq ? Autor ? S?rgio Santana       ? Data ?29/10/2014???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Importacao Base de Dados                                   ???
???          ? Tratamento dos lan?amentos referente ao recebimento anteci ???
???          ? pado e pagamento antecipado                                ???
?????????????????????????????????????????????????????????????????????????͹??
???ALTERACAO ?                                                            ??? 
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? ThermoGlass                                                ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
//U_CtaAdGstq( '20140901', '20141031' )

User Function CtaAdGstq( _cDtIni, _cDtFim )

DEFAULT _cDtIni := DtoS( dDataBase - 1 )
DEFAULT _cDtFim := DtoS( dDataBase - 1 )

PRIVATE _cFilSA2 := xFilial( 'SA2' )
PRIVATE _qAdt

If _cDtFim > '20170503'

   _cDtIni := '20171231'

EndIf

_qAdt := "SELECT "
_qAdt +=  " Case "
_qAdt +=      "When CtaOrig.ID_CONTA = 101 Then '9001' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 1 Then '0101' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 2 Then '0102' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 3 Then '0201' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 4 Then '0601' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 5 Then '0103' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 6 Then '0202' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 7 Then '0301' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 8 Then '0401' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 9 Then '0501' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 12 Then '0701' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 16 Then '0801' "
_qAdt +=      "When CtaOrig.ID_EMPRESA = 15 Then '0215' "
_qAdt +=      "Else '0000' "
_qAdt +=   "End E5_FILIAL, "
_qAdt +=  " Case "
_qAdt +=     "When CtaOrig.ID_CONTA = 101 Then '9001' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 1 Then '0101' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 2 Then '0102' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 3 Then '0201' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 4 Then '0601' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 5 Then '0103' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 6 Then '0202' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 7 Then '0301' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 8 Then '0401' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 9 Then '0501' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 12 Then '0701' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 16 Then '0801' "
_qAdt +=     "When CtaOrig.ID_EMPRESA = 15 Then '0215' "
_qAdt +=     "Else '0000' "
_qAdt +=  "End E5_FILORIG, "

_qAdt +=  "CASE "
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then 'PA '"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 THEN 'PA '"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then 'RA '"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then 'RA ' "
_qAdt +=  "END E5_TIPO, "
_qAdt +=  "CASE WHEN Adto.ID_CHEQUE IS NULL THEN CONVERT( CHAR(8), Adto.DATA, 112) ELSE CONVERT( CHAR(8), CHEQUE.DTCONCILIADO, 112) END E5_DATA,"
_qAdt +=  "'01' E5_MOEDA,Adto.VALOR E5_VALOR,"

_qAdt +=  "CASE "
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then ISNULL( SA2.A2_NATUREZ, ' ')"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then ISNULL( SA2.A2_NATUREZ, ' ')"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then ISNULL( SA1.A1_NATUREZ, ' ')"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then ISNULL( SA1.A1_NATUREZ, ' ') "
_qAdt +=  "END E5_NATUREZ,"
  
_qAdt +=  "ISNULL(SA6ORI.A6_COD, ' ') E5_BANCO,"
_qAdt +=  "ISNULL(SA6ORI.A6_AGENCIA, ' ') E5_AGENCIA,"
_qAdt +=  "ISNULL(SA6ORI.A6_NUMCON, ' ') E5_CONTA,"
_qAdt +=  "CAST( REPLICATE( '0', 6 - LEN( CAST(ISNULL(Adto.ID_CLIENTE,'000000') AS VARCHAR(6)))) + CAST(ISNULL(Adto.ID_CLIENTE,'000000') AS VARCHAR(6)) AS CHAR(6)) E5_CLIFOR,"
_qAdt +=  "ISNULL(ISNULL( SA1.A1_LOJA, SA2.A2_LOJA ),'01') E5_LOJA,"
_qAdt +=  "CASE" 
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then ' '"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 THEN ' '"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then ISNULL( SA1.A1_COD,  'XXXXXX')"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then ISNULL( SA1.A1_COD,  'XXXXXX') "
_qAdt +=  "END  E5_CLIENTE,"
  
_qAdt +=  "CASE"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then ISNULL( SA2.A2_COD,  'XXXXXX')"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then ISNULL( SA2.A2_COD,  'XXXXXX')"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then ' '"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then ' ' "
_qAdt +=  "END E5_FORNECE,"

_qAdt +=  "CAST( CASE WHEN Adto.ID_MOV_CONTA IS NOT NULL THEN Adto.ID_ADIANTAMENTO ELSE LEFT(REPLACE( SUBSTRING( BxaParc.OBS, 1, CHARINDEX( ' ', BxaParc.OBS)), '/', ''),LEN( REPLACE( SUBSTRING( BxaParc.OBS, 1, CHARINDEX( ' ', BxaParc.OBS)), '/', '') ) + -2) END AS VARCHAR(10)) E5_NUMERO,"
_qAdt +=  "CASE WHEN Adto.ID_MOV_CONTA IS NOT NULL THEN ' ' ELSE RIGHT( SUBSTRING( BxaParc.OBS, 1, CHARINDEX( ' ', BxaParc.OBS) -1), 1 ) END E5_PARCELA, "
  
_qAdt +=  "CASE"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then 'P'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 THEN 'P'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then 'R'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then 'R' "
_qAdt +=  "END E5_RECPAG,"
  
_qAdt +=  "CASE"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then SA2.A2_NOME"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 THEN SA2.A2_NOME"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then SA1.A1_NOME"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then SA1.A1_NOME "
_qAdt +=  "END E5_BENEF,"

_qAdt +=  "REPLACE(Adto.REFERENCIA, SUBSTRING( Adto.REFERENCIA, 1, CHARINDEX( ' ', Adto.REFERENCIA)), '' ) E5_HISTOR,"

_qAdt +=  "CASE"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then 'PA'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 THEN 'PA'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then 'RA'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then 'RA' "
_qAdt +=  "END E5_TIPODOC,"

_qAdt +=  "CASE"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then 'NOR'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 THEN 'CMP'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'C' And ISNULL( Adto.ID_MOV_CONTA,0 ) <> 0 Then 'NOR'"
_qAdt +=  " WHEN Adto.DEB_CRED = 'D' And ISNULL( Adto.ID_MOV_CONTA,0 ) =  0 Then 'CMP'"
_qAdt +=  " ELSE 'XX'"
_qAdt +=  "END E5_MOTBX, "
_qAdt +=  "CASE WHEN (BxaParc.VALOR IS NOT NULL) THEN 'BXA'  ELSE ' ' END E5_TPBAIXA,"
_qAdt +=  "ISNULL(BxaParc.OBS, ' ') OBS,"
_qAdt +=  "ISNULL(BxaParc.VALOR,0) VALOR, "
_qAdt +=  "ISNULL(Adto.ID_CHEQUE, 0) E5_CHEQUE, "
_qAdt +=  "ISNULL(BxaParc.ID_ADIANTAMENTO, 0) idAdto, "
_qAdt +=  "ISNULL(BxaParc.ID_ADIANTAMENTO_COMPENSACAO, 0) idComp, "
_qAdt +=  "'G' E5_ORIGBD "
_qAdt += "FROM [TPCP].[dbo].[ADIANTAMENTO] Adto "
_qAdt += "LEFT OUTER JOIN [TPCP].[dbo].[BAIXA_PARCIAL] BxaParc ON (BxaParc.ID_ADIANTAMENTO > 0) AND (BxaParc.ID_ADIANTAMENTO = Adto.ID_ADIANTAMENTO ) "
_qAdt += "LEFT OUTER JOIN [TPCP].[dbo].[MOV_CONTA] CtaMvt ON (CtaMvt.ID_MOV_CONTA = Adto.ID_MOV_CONTA) "
_qAdt += "LEFT OUTER JOIN [TPCP].[dbo].[CONTA] CtaOrig ON (CtaOrig.ID_CONTA = Adto.ID_CONTA) "
_qAdt += "LEFT OUTER JOIN [TPCP].[dbo].[BANCO] Bco ON (Bco.ID_BANCO = CtaOrig.ID_BANCO) "
_qAdt += 'LEFT OUTER JOIN [TPCP].[dbo].[CHEQUE] CHEQUE ON (CHEQUE.ID_CHEQUE = Adto.ID_CHEQUE) AND (CHEQUE.ID_CONTA = Adto.ID_CONTA) '

_qAdt += 'LEFT OUTER JOIN [TPCP].[dbo].[CLIENTE] CLIENTE ON (CLIENTE.ID_CLIENTE = Adto.ID_CLIENTE) '

_qAdt += "LEFT OUTER JOIN [TOTVSIPFSC].[dbo].[SA1010] SA1    ON (SA1.A1_COD = (REPLICATE( '0', 6 - LEN( CAST(ISNULL(Adto.ID_CLIENTE,'000000') AS VARCHAR(6))))) + CAST(ISNULL(Adto.ID_CLIENTE,'000000') AS VARCHAR(6))) AND (SA1.A1_LOJA = '01') AND (SA1.D_E_L_E_T_ <> '*' ) "
_qAdt += "LEFT OUTER JOIN [TOTVSIPFSC].[dbo].[SA2010] SA2    ON (SA2.A2_COD = (REPLICATE( '0', 6 - LEN( CAST(ISNULL(Adto.ID_CLIENTE,'000000') AS VARCHAR(6))))) + CAST(ISNULL(Adto.ID_CLIENTE,'000000') AS VARCHAR(6))) AND (SA2.A2_LOJA = '01') AND (SA2.D_E_L_E_T_ <> '*' ) "
_qAdt += "LEFT OUTER JOIN [TOTVSIPFSC].[dbo].[SED010] SED    ON (SED.ED_CODIGO = SA1.A1_NATUREZ) AND (SED.D_E_L_E_T_ <> '*' ) "
_qAdt += "LEFT OUTER JOIN [TOTVSIPFSC].[dbo].[SED010] SEDFOR ON (SEDFOR.ED_CODIGO = SA2.A2_NATUREZ) AND (SEDFOR.D_E_L_E_T_ <> '*' ) "
_qAdt += "LEFT OUTER JOIN [TOTVSIPFSC].[dbo].[SA6010] SA6ORI ON (SA6ORI.A6_COD = (REPLICATE( '0', 3 - LEN( CAST(ISNULL(CtaOrig.ID_CONTA,999) AS VARCHAR(6)))) + CAST(ISNULL(CtaOrig.ID_CONTA,999) AS VARCHAR(3)))) AND (SA6ORI.D_E_L_E_T_ <> '*') "
_qAdt += "WHERE "
_qAdt += "(((CONVERT(CHAR(8), Adto.DATA, 112 ) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') AND (Adto.ID_CHEQUE IS NULL)) OR "
_qAdt += "((CONVERT( CHAR(8), CHEQUE.DTCONCILIADO, 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') AND (Adto.ID_CHEQUE IS NOT NULL)))"

VerificaForn( _qAdt )
VerificaCli( _qAdt )

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qAdt),"ADT",.T.,.T.)

GrvAdtFin()           

Return( NIL )                       

Static Function GrvAdtFin()

ADT->( dbGoTop() )
SE5->( dbSetOrder( 2 ) )

While ! ADT->( Eof() )

   If ! ( SE5->( dbSeek( ADT->E5_FILIAL+ADT->E5_TIPODOC+'   '+StrZero( Val(ADT->E5_NUMERO), 9 )+ADT->E5_PARCELA+ADT->E5_TIPO+ADT->E5_DATA+ADT->E5_CLIFOR+ADT->E5_LOJA+'01', .F. ) ) )

      GravaAdt()

   EndIf
   
   ADT->( dbSkip() )
EndDo                                                      

ADT->( dbCloseArea() )
SE5->( dbSetOrder( 1 ) )

Return( NIL )

Static Function GeraRec()

  RecLock( 'SE1', .T. )
  SE1->E1_FILIAL  := ADT->E5_FILIAL
  SE1->E1_FILORIG := ADT->E5_FILORIG
  SE1->E1_MSFIL   := ADT->E5_FILIAL
  SE1->E1_TIPO    := ADT->E5_TIPO
  SE1->E1_MSEMP  := '01'
  SE1->E1_STATUS  := 'A'
  SE1->E1_CLIENTE := ADT->E5_CLIFOR
  SE1->E1_LOJA    := '01'
  SE1->E1_NOMCLI  := ADT->E5_BENEF
  SE1->E1_NUM     := StrZero( Val(ADT->E5_NUMERO), 9 )
  SE1->E1_PARCELA := ADT->E5_PARCELA
  SE1->E1_SERIE   := '   '
  SE1->E1_PREFIXO := '   '
  SE1->E1_VALOR   := ADT->E5_VALOR
  SE1->E1_VLCRUZ  := ADT->E5_VALOR
  SE1->E1_SALDO   := 0
  SE1->E1_EMISSAO := StoD( ADT->E5_DATA )
  SE1->E1_EMIS1   := StoD( ADT->E5_DATA )
  SE1->E1_VENCTO  := StoD( ADT->E5_DATA )
  SE1->E1_VENCREA := StoD( ADT->E5_DATA )
  SE1->E1_VENCORI := StoD( ADT->E5_DATA )
  SE1->E1_CONTA   := ADT->E5_CONTA
  SE1->E1_MULTNAT := '2'
  SE1->E1_NATUREZ := ADT->E5_NATUREZ
  SE1->E1_PORTADO := ADT->E5_BANCO
  SE1->E1_SITUACA := '0'
  SE1->E1_FLUXO   := 'S'
  SE1->E1_APLVLMN := '1'
  SE1->E1_PROJPMS := '2'
  SE1->E1_DESDOBR := '2'
  SE1->E1_MOEDA   := 1
  SE1->E1_FRETISS := '1'
  SE1->E1_IDBOLET := ADT->idAdto
  SE1->E1_ORIGEM  := 'CTMVADSTQ'
  SE1->E1_ORIGBD  := ADT->E5_ORIGBD
  If SE1->(FIELDPOS("E1_MSEXP")) > 0
     SE1->E1_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
  EndIf
  SE1->( dbUnLock() )
Return( NIL )


Static Function GeraPag()

   GravaFornec()

   RecLock( 'SE2', .T. )
   SE2->E2_FILIAL  := ADT->E5_FILIAL
   SE2->E2_FILORIG := ADT->E5_FILIAL
   SE2->E2_TIPO    := ADT->E5_TIPO
   SE2->E2_STATUS  := ' '
   SE2->E2_FORNECE := ADT->E5_CLIFOR
   SE2->E2_LOJA    := '01'
   SE2->E2_NOMFOR  := iif( ADT->E5_BENEF <> ' ', ADT->E5_BENEF, SA2->A2_NOME )
   SE2->E2_NUM     := StrZero( Val(ADT->E5_NUMERO), 9 )
   SE2->E2_PARCELA := ADT->E5_PARCELA
   SE2->E2_PREFIXO := '   '
   SE2->E2_VALOR   := ADT->E5_VALOR
   SE2->E2_VLCRUZ  := ADT->E5_VALOR
   SE2->E2_SALDO   := 0
   SE2->E2_ACRESC  := 0
   SE2->E2_JUROS   := 0
   SE2->E2_DESCONT := 0
   SE2->E2_EMISSAO := StoD( ADT->E5_DATA )
   SE2->E2_EMIS1   := StoD( ADT->E5_DATA )
   SE2->E2_VENCTO  := StoD( ADT->E5_DATA )
   SE2->E2_VENCREA := StoD( ADT->E5_DATA )
   SE2->E2_VENCORI := StoD( ADT->E5_DATA )
   SE2->E2_CONTAD  := ADT->E5_CONTA
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
   SE2->E2_HIST    := ADT->E5_HISTOR
   SE2->E2_MULTNAT := '2'
   SE2->E2_NATUREZ := ADT->E5_NATUREZ
   SE2->E2_IDMOV   := Str( ADT->idAdto, 10, 0 )
   SE2->E2_ORIGEM  := 'CTMVADSTQ'
   SE2->E2_LA      := ' '
   SE2->E2_ORIGBD  := ADT->E5_ORIGBD
   If SE2->(FIELDPOS("E2_MSEXP")) > 0
      SE2->E2_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
   EndIf
   SE2->( dbUnLock() )

Return( NIL )


Static Function GravaAdt()

   If ADT->E5_RECPAG = 'R'

      GeraRegAdt( ADT->E5_MOTBX, ADT->E5_NATUREZ, ADT->E5_TIPODOC )
 
      If ! ( SE1->( dbSeek( ADT->E5_FILIAL+'   '+StrZero( Val(ADT->E5_NUMERO), 9 )+ADT->E5_PARCELA+ADT->E5_TIPO, .F. ) ) ) .And.;
         (ADT->E5_MOTBX = 'NOR')

         GeraRec()

      EndIf

   ElseIf ADT->E5_RECPAG = 'P'

      GeraRegAdt( ADT->E5_MOTBX, ADT->E5_NATUREZ, ADT->E5_TIPODOC )

      If ! (SE2->( dbSeek( ADT->E5_FILIAL+'   '+StrZero( Val(ADT->E5_NUMERO), 9 )+ADT->E5_PARCELA+ADT->E5_TIPO+ADT->E5_CLIFOR+ADT->E5_LOJA, .F.  ) ) ) .And.;
         (ADT->E5_MOTBX = 'NOR')

         GeraPag()                             

      EndIf

   EndIf

   If ( ADT->E5_MOTBX = 'CMP' )

      _cUpd := 'UPDATE ' + RetSQLName( 'SE5' )  + ' '
      _cUpd += "SET E5_DOCUMEN = DOCUMENT, E5_KEY = CHAVE "
      _cUpd += 'FROM (SELECT E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_MOEDA AS DOCUMENT, E5_KEY CHAVE FROM ' +  RetSQLName( 'SE5' )  + ' '
      _cUpd += "WHERE "
      _cUpd += "(E5_CLIENTE = '" + SE5->E5_CLIENTE + "') AND "
      _cUpd += "(E5_NUMERO = '" + SE5->E5_NUMERO + "') AND "
      _cUpd += "(E5_PARCELA = '" + SE5->E5_PARCELA + "') AND "
      _cUpd += "(E5_VALOR = '" + lTrim(Str( SE5->E5_VALOR, 14, 2 )) + "') AND "
      _cUpd += "(E5_TIPO NOT IN ('RA','PA')) AND "
      _cUpd += "(D_E_L_E_T_ <> '*')"   
      _cUpd += ") SE5 "
      _cUpd += 'WHERE SE5010.R_E_C_N_O_ = ' + lTrim( Str( SE5->( RecNo() ), 10, 0 ) )

      _nRet := TCSqlExec( _cUpd )

      _cUpd := 'UPDATE ' + RetSQLName( 'SE5' )  + ' '
      _cUpd += "SET E5_MOTBX = 'CMP', E5_FORNADT = '" + ADT->E5_CLIENTE + "', E5_LOJAADT = '" + ADT->E5_LOJA + "', "
      _cUpd += " E5_DOCUMEN = '" + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_MOEDA + "', "
      _cUpd += " E5_HISTOR = 'Compens. Adiantamento',"
      _cUpd += " E5_TIPODOC = 'CP' "
      _cUpd += "WHERE "
      _cUpd += "(E5_CLIENTE = '" + SE5->E5_CLIENTE + "') AND "
      _cUpd += "(E5_NUMERO = '" + SE5->E5_NUMERO + "') AND "
      _cUpd += "(E5_PARCELA = '" + SE5->E5_PARCELA + "') AND "
      _cUpd += "(E5_VALOR = '" + lTrim(Str( SE5->E5_VALOR, 14, 2 )) + "') AND "
      _cUpd += "(E5_TIPO NOT IN ('RA','PA')) AND "
      _cUpd += "(D_E_L_E_T_ <> '*') "   
      _nRet := TCSqlExec( _cUpd )

   EndIf

Return( NIL )

Static Function GeraRegAdt( _cTipo, _cNaturez, _cTipoDoc )

  SE5->( dbSetOrder( 7 ) )

  If ! ( SE5->( dbSeek( ADT->E5_FILIAL+'   '+StrZero( Val(ADT->E5_NUMERO), 9 )+ADT->E5_PARCELA+ADT->E5_TIPO+ADT->E5_CLIFOR+'01'+'01' , .F. ) ) )

     RecLock( 'SE5', .T. )
     SE5->E5_FILIAL  := ADT->E5_FILIAL
     SE5->E5_FILORIG := ADT->E5_FILORIG
     SE5->E5_DATA    := StoD( ADT->E5_DATA )
     SE5->E5_MOEDA   := ADT->E5_MOEDA
     SE5->E5_VALOR   := ADT->E5_VALOR
     SE5->E5_NATUREZ := _cNaturez
     SE5->E5_BANCO   := ADT->E5_BANCO
     SE5->E5_AGENCIA := ADT->E5_AGENCIA
     SE5->E5_CONTA   := ADT->E5_CONTA
     SE5->E5_RECPAG  := ADT->E5_RECPAG
     SE5->E5_BENEF   := ADT->E5_BENEF
     SE5->E5_NUMCHEQ := if( ADT->E5_CHEQUE <> 0, lTrim( Str( ADT->E5_CHEQUE, 10 ) ), ' ')

     If ( ADT->E5_MOTBX = 'CMP' )
        SE5->E5_HISTOR  := 'Baixa por Compensacao'
     Else
        SE5->E5_HISTOR  := ADT->E5_HISTOR
     End

     SE5->E5_TIPODOC := _cTipoDoc
     SE5->E5_TIPO    := ADT->E5_TIPO
     SE5->E5_DTDISPO := SE5->E5_DATA
     SE5->E5_DTDIGIT := SE5->E5_DATA
     SE5->E5_SEQ     := '01'
     SE5->E5_MOTBX   := _cTipo
     SE5->E5_NUMERO  := StrZero( Val(ADT->E5_NUMERO), 9 )
     SE5->E5_PARCELA := ADT->E5_PARCELA

     SE5->E5_CLIFOR  := ADT->E5_CLIFOR
     SE5->E5_LOJA    := ADT->E5_LOJA
     SE5->E5_CLIENTE := ADT->E5_CLIENTE
     SE5->E5_FORNADT := ADT->E5_CLIFOR
     SE5->E5_LOJAADT := ADT->E5_LOJA 
     SE5->E5_IDMOVI  := Str( ADT->idComp, 10, 0 )
     
     If SE5->E5_RECPAG = 'R'

        SE5->E5_KEY := /*ADT->E5_PREFIXO*/ '   ' + ADT->E5_NUMERO + ADT->E5_TIPO + ADT->E5_CLIFOR + ADT->E5_LOJA

     Else

        SE5->E5_FORNECE := ADT->E5_FORNECE

     EndIf

     SE5->E5_ORIGEM  := 'CTMVADSTQ'
     SE5->E5_ORIGBD  := ADT->E5_ORIGBD
     If SE5->(FIELDPOS("E5_MSEXP")) > 0
        SE5->E5_MSEXP := DTOS(DATE()) //Montes - 06/05/2019
     EndIf
     SE5->( MSUnLock() )

  EndIf

  SE5->( dbSetOrder( 2 ) )

Return( NIL )
 
Static Function GravaFornec()
 
    If ! ( SA2->( dbSeek( _cFilSA2 + ADT->E5_CLIFOR + '01', .F. ) ) )

       _cQry := "SELECT ID_CLIENTE, NOME, ENDERECO, BAIRRO, REPLACE(REPLACE(REPLACE( CEP, '-', '' ), ' ', ''),'.','') CEP, REPLACE(REPLACE(REPLACE( CPFCGC, '-',''),'/',''),'.','') CPFCGC , RGINSC, CONTATO, CONVERT( CHAR(8), CADASTRO, 112) CADASTRO, ISNULL( OP.NATUREZA, '99999') NATUREZA, CID.DESCRICAO, CID.UF, CID.MUNICIPIO, "
       _cQry += "NUMERO, TELEFONE FROM [TPCP].[dbo].[CLIENTE] "
       _cQry += "LEFT OUTER JOIN [TPCP].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL "
       _cQry += "LEFT OUTER JOIN [TPCP].[dbo].[CIDADE] CID ON CID.ID_CIDADE = CLIENTE.ID_CIDADE "
       _cQry += "WHERE ID_CLIENTE = '" + ADT->E5_CLIFOR + "'"

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
       SA2->A2_LOJA    := '01'
       SA2->A2_COD     := _cCodFor
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
       SA2->( dbUnLock() )
       TMP->( dbCloseArea() )

    EndIf
  
 Return( NIL )
 
 
Static Function VerificaForn( _qAdt )
 
_cInc := 'SELECT DISTINCT E5_CLIFOR E2_FORNECE FROM (' + _qAdt + ") Adto WHERE (E5_FORNECE = 'XXXXXX')"

U_CadForn( _cInc )

Return( NIL ) 

Static Function VerificaCli( _qAdt )
 
_cInc := 'SELECT DISTINCT E5_CLIFOR E2_CLIENTE FROM (' + _qAdt + ") Adto WHERE (E5_CLIENTE = 'XXXXXX')"
_cFilSA1 := xFilial( 'SA1' )

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cInc ), 'CAD' )
                                                      
While ! ( CAD->( Eof() ) )

   _qCli := "SELECT ID_CLIENTE, NOME, FANTASIA, ENDERECO, COMPL_END, REPLACE(REPLACE(CEP,'.',''),'-','') CEP, BAIRRO, ATIV.SUBST_TRIB SUBTRIB, "
   _qCli += "RGINSC, INTERNET eMail, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-','') TELEFONE, CONTATO, CONVERT(CHAR(8),CADASTRO,112) CADASTRO, CONVERT( CHAR(8), ULT_COMPRA,112) ULT_COMPRA, CLIENTE.SUFRAMA,"
   _qCli += "REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') CPFCGC, CIDADE.DESCRICAO, UF, COD_UF, MUNICIPIO , PAIS, REPLACE(ISNULL(PLANO.CODIGO,'112010001'),'.','') CONTA"
   _qCli += ' FROM [TPCP].[dbo].[CLIENTE] '
   _qCli += 'LEFT OUTER JOIN [TPCP].[dbo].[CIDADE] ON CIDADE.ID_CIDADE = CLIENTE.ID_CIDADE '
   _qCli += 'LEFT OUTER JOIN [TPCP].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '
   _qCli += 'LEFT OUTER JOIN [TPCP].[dbo].[ATIVIDADE] ATIV ON ATIV.ID_ATIVIDADE = CLIENTE.ID_ATIVIDADE '
   _qCli += 'LEFT OUTER JOIN [TPCP].[dbo].[PLANO] ON PLANO.ID_PLANO = OP.ID_PLANO_CR '
   _qCli += "WHERE (CLIENTE.ID_CLIENTE = " + Alltrim( Str( Val( CAD->E2_CLIENTE ), 6 ) ) + ")"

   dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qCli),"CLI",.T.,.T.)

   If ! ( SA1->( dbSeek( _cFilSA1 + StrZero( CLI->ID_CLIENTE, 6 ) + '01', .F. ) ) )

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
      SA1->A1_CONTA   := CLI->CONTA
      SA1->A1_NATUREZ := '10101' 
      SA1->( dbUnLock() )
       
      CLI->( dbCloseArea() )
    

   EndIf

   CAD->( dbSkip() )
EndDo

CAD->( dbCloseArea())

Return( NIL )