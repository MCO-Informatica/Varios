#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF
#Include "rwmake.ch"

User Function RptRank()
Private titulo      := "Relat๓rio Ranking Esp"
Private nLin        := 60
Private imprime     := .T.
Private aOrd        := {""}
Private cPerg       := "RPTRAN"
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RPTRAN" // Coloque aqui o nome do programa para impressao no cabecalho
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RELRAN" // Coloque aqui o nome do arquivo usado para impressao em disco
Private nOrdem      := 0
Private cString     := 'SF2'
Private nTipo       := 18

nOrdem   := 0
Alfa     := 0
titulo   := PADC("Ranking",75)
cDesc1   := PADC("",75)
cDesc2   := PADC("",75)
cDesc3   := PADC("                                                          ",75)
aReturn  := { "Especial" , 1, "Diretoria" , 2, 2, 1,"", 1 }
nLastKey := 0
         
Cabec1 := "                                                                                            Substituicao                 Med Real         Med        QTD          M2           M2        Media      Media"
Cabec2 := "Serie                               IPI            ICM              PIS        COFINS        Tributaria         NET        NET           Venda                   Venda        Real      Real Brt  Venda Brt       TOTAL"

// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999.999 999,999.999 999,999,999 9,999,999.99 9,999,999.99 999,999.99 999,999.99 999,999,999.99 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica a existencia do SX1 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AjustaSX1()
                                 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abastece variแveis de parametros ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica a Ordem do Relatorio ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nOrdem := aReturn[8]

If nLastKey == 27

	Return( NIL )

End

SetDefault(aReturn,cString)

If nLastKey == 27

   Return

Endif

RptStatus( { || RptDetail() } )  

Return( NIL )


Static Function RptDetail()

_aGrupo  := { 'Cliente', 'Serie' }
_aSerie  := { 'Laminado', 'Temperado' }
_nHandle := 0

If MV_PAR01 <> 1

   _cTipo := 'S้rie ' + _aGrupo[ MV_PAR01 ]

Else

   _cTipo := _aGrupo[ MV_PAR01 ]

End

titulo   := PADC("Ranking Esp " + if( MV_PAR02 <> 3, _aSerie[ MV_PAR02 ] + " ", "") + _cTipo + " periodo " + DtoC( MV_PAR03 ) + ' ate ' + DtoC( MV_PAR04 ),75 )

SetPrc( 0, 0 )
_cDtI    := DtoS( MV_PAR03 )
_cDtF    := DtoS( MV_PAR04 )

_aExcCli := SuperGetMV( 'MV_X_EC',,'{"000128","000129","004061","000301","002762","003916","000629"}' )
//_nLen    := Len( _aExcCli )

_cQry := 'SELECT '

If MV_PAR01 <> 2

   _cQry += ' A1_NREDUZ,'

Else

   _cQry += ' BM_DESC,'

End

_cQry += ' SUM(TOTAL) AS TOTAL, '
_cQry += ' SUM(QDE) AS QDE,'
_cQry += ' SUM(ICMS) AS ICMS,'
_cQry += ' SUM(IPI) AS IPI,'
_cQry += ' SUM(SUBTRIB) AS SUBTRIB,'
_cQry += ' SUM(COFINS) AS COFINS,'
_cQry += ' SUM(PIS) AS PIS,'
_cQry += ' SUM(AREABRUT) AS AREABRUT,'
_cQry += ' SUM(AREAREAL) AS AREAREAL'
_cQry += ' FROM ('
_cQry += ' SELECT'

If MV_PAR01 <> 2

   _cQry += ' A1_NREDUZ,'

Else

   _cQry += ' BM_DESC,'

End

_cQry += ' SUM((D1_TOTAL + D1_VALIPI + D1_ICMSRET) * -1) AS TOTAL,'
_cQry += " SUM(CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL = '2') THEN 0 ELSE D1_QUANT END * -1) AS QDE,"
_cQry += ' SUM(D1_VALICM * -1) AS ICMS,'
_cQry += ' SUM(D1_VALIPI * -1) AS IPI,'
_cQry += ' SUM(D1_ICMSRET * -1) AS SUBTRIB,'
_cQry += ' SUM(D1_VALIMP5 * -1) AS COFINS,'
_cQry += ' SUM(D1_VALIMP6 * -1) AS PIS,'
_cQry += " SUM( CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL = '2' OR F2_ZZNIVEL = '3') THEN 0 ELSE D1_QUANT * B1_ZZBRUTA END * -1) AS AREABRUT,"
_cQry += " SUM( CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL = '2' OR F2_ZZNIVEL = '3') THEN 0 ELSE D1_QUANT * B1_ZZREAL  END * -1) AS AREAREAL"
_cQry += ' FROM ' + RetSQLName( 'SD1' ) + " SD1"
_cQry += " LEFT OUTER JOIN " + RetSQLName( 'SB1' ) + " SB1 ON (B1_COD = D1_COD) AND (SB1.D_E_L_E_T_ <> '*')"

If ! ( Empty( xFilial( 'SB1' ) ) )
 
   _cQry += ' AND (SB1.B1_FILIAL = SD2.D2_FILIAL)'

Else

   _cQry += " AND (SB1.B1_FILIAL = '" + xFilial( 'SB1' ) + "')" 

End

_cQry += " LEFT OUTER JOIN " + RetSQLName( 'ZZ5' ) + " ZZ5 ON (ZZ5_CODIGO = B1_ZZTVIDR) AND (ZZ5.D_E_L_E_T_ <> '*')"

If ! ( Empty( xFilial( 'ZZ5' ) ) )
 
   _cQry += ' AND (ZZ5.ZZ5_FILIAL = SD2.D2_FILIAL)'

Else

   _cQry += " AND (ZZ5.ZZ5_FILIAL = '" + xFilial( 'ZZ5' ) + "')"

End

_cQry += " LEFT OUTER JOIN " + RetSQLName( 'SBM' ) + " SBM ON (BM_GRUPO = B1_GRUPO) AND (SBM.D_E_L_E_T_ <> '*')"

If ! ( Empty( xFilial( 'SBM' ) ) )
 
   _cQry += ' AND (SBM.BM_FILIAL = SF2.F2_FILIAL)'

Else

   _cQry += " AND (SBM.BM_FILIAL = '" + xFilial( 'SBM' ) + "')"

End

_cQry += " LEFT OUTER JOIN " + RetSQLName( 'SF4' ) + " SF4 ON (F4_CODIGO = D1_TES) AND (SF4.D_E_L_E_T_ <> '*')"

If ! ( Empty( xFilial( 'SF4' ) ) )
 
   _cQry += ' AND (SF4.SF4_FILIAL = SD2.D2_FILIAL)'

Else

   _cQry += " AND (SF4.F4_FILIAL = '" + xFilial( 'SF4' ) + "')"

End

_cQry += " LEFT OUTER JOIN " + RetSQLName( 'SF2' ) + " SF2 ON (F2_FILIAL = D1_FILIAL) AND (F2_DOC = D1_NFORI) AND (F2_SERIE = D1_SERIORI) AND (F2_CLIENTE = D1_FORNECE) AND (F2_LOJA = D1_LOJA) AND (SF2.D_E_L_E_T_ <> '*')"

If MV_PAR01 <> 2

   _cQry += 'LEFT OUTER JOIN ' + RetSQLName( 'SA1' ) + " SA1 ON (A1_COD = F2_CLIENTE) AND (A1_LOJA = F2_LOJA) AND (SA1.D_E_L_E_T_ <> '*')"

   If ! ( Empty( xFilial( 'SA1' ) ) )
 
      _cQry += ' AND (SA1.A1_FILIAL = SD2.D2_FILIAL)'

   Else

      _cQry += " AND (SA1.A1_FILIAL = '" + xFilial( 'SA1' ) + "')"

   End

End

_cQry += ' WHERE '
_cQry += " (CHARINDEX(D1_FORNECE,'" + _aExcCli + "') = 0) AND (D1_TIPO = 'D') AND (D1_FORMUL = 'S') AND (SD1.D_E_L_E_T_ <> '*') AND (D1_SERIE = '3') AND (D1_NFORI <> ' ') "
_cQry += " AND (D1_DTDIGIT BETWEEN '" + _cDtI + "' AND '" + _cDtF + "') AND (F4_DUPLIC = 'S') AND "
_cQry += "Not (SF2.F2_FILIAL = '0701' AND SF2.F2_SERIE = '2') AND "
_cQry += "Not (SF2.F2_ZZNIVEL IN ('4', '6') AND SF2.F2_FILIAL = '0202') AND "
_cQry += "(F2_TIPO <> 'D' AND F2_TIPO <> 'B') "

If MV_PAR02 = 1

   _cQry += " AND (ZZ5_TIPO = '1')"

ElseIf MV_PAR02 = 2

   _cQry += " AND (ZZ5_TIPO = '2')"

Else

   _cQry += " AND ((ZZ5_TIPO = '1') OR (ZZ5_TIPO = '2'))"

End

_cQry += ' GROUP BY '

If MV_PAR01 <> 2

   _cQry += ' A1_NREDUZ'

Else

   _cQry += ' BM_DESC'

End

_cQry += ' UNION ALL '
_cQry += ' SELECT '

If MV_PAR01 <> 2

   _cQry += ' A1_NREDUZ,'

Else

   _cQry += ' BM_DESC,'

End

_cQry += " SUM(CASE WHEN (D2_TIPO  = 'I') THEN 0 ELSE D2_VALBRUT END) AS TOTAL, "
_cQry += " SUM(CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL = '2') THEN 0 ELSE D2_QUANT END) AS QDE, "
_cQry += ' SUM(D2_VALICM) AS ICMS, '
_cQry += ' SUM(D2_VALIPI) AS IPI, '
_cQry += ' SUM(D2_ICMSRET) AS SUBTRIB, '
_cQry += ' SUM(D2_VALIMP5) AS COFINS, '
_cQry += ' SUM(D2_VALIMP6) AS PIS, '
_cQry += " SUM( CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL = '2' OR F2_ZZNIVEL = '3') THEN 0 ELSE D2_QUANT * B1_ZZBRUTA END) AS AREABRUT, "
_cQry += " SUM( CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL = '2' OR F2_ZZNIVEL = '3') THEN 0 ELSE D2_QUANT * B1_ZZREAL  END) AS AREAREAL  "
_cQry += " FROM " + RetSQLName( 'SF2' ) + " SF2 "
_cQry += ' LEFT OUTER JOIN ' + RetSQLName( 'SD2' ) + "  SD2 ON (F2_FILIAL = D2_FILIAL) AND (F2_DOC = D2_DOC) AND (F2_SERIE = D2_SERIE) AND (F2_CLIENTE = D2_CLIENTE) AND (F2_LOJA = D2_LOJA) AND (SD2.D_E_L_E_T_ <> '*') "
_cQry += ' LEFT OUTER JOIN ' + RetSQLName( 'SB1' ) + "  SB1 ON (B1_COD = D2_COD) AND (SB1.D_E_L_E_T_ <> '*')"

If ! ( Empty( xFilial( 'SB1' ) ) )
 
   _cQry += ' AND (SB1.B1_FILIAL = SF2.F2_FILIAL)'

Else

   _cQry += " AND (SB1.B1_FILIAL = '" + xFilial( 'SB1' ) + "')"

End

_cQry += ' LEFT OUTER JOIN ' + RetSQLName( 'ZZ5' ) + "  ZZ5 ON (ZZ5_CODIGO = B1_ZZTVIDR) AND (ZZ5.D_E_L_E_T_ <> '*')"

If ! ( Empty( xFilial( 'ZZ5' ) ) )
 
   _cQry += ' AND (ZZ5.ZZ5_FILIAL = SF2.F2_FILIAL)'

Else

   _cQry += " AND (ZZ5.ZZ5_FILIAL = '" + xFilial( 'SB1' ) + "')"

End

_cQry += ' LEFT OUTER JOIN ' + RetSQLName( 'SBM' ) + "  SBM ON (BM_GRUPO = B1_GRUPO) AND (SBM.D_E_L_E_T_ <> '*')"

If ! ( Empty( xFilial( 'SBM' ) ) )
 
   _cQry += ' AND (SBM.BM_FILIAL = SF2.F2_FILIAL)'

Else

   _cQry += " AND (SBM.BM_FILIAL = '" + xFilial( 'SBM' ) + "')"

End

_cQry += ' LEFT OUTER JOIN ' + RetSQLName( 'SF4' ) + "  SF4 ON (F4_CODIGO = D2_TES) AND (SF4.D_E_L_E_T_ <> '*')"

If ! ( Empty( xFilial( 'SF4' ) ) )
 
   _cQry += ' AND (SF4.F4_FILIAL = SF2.F2_FILIAL)'

Else

   _cQry += " AND (SF4.F4_FILIAL = '" + xFilial( 'SF4' ) + "')"

End

If MV_PAR01 <> 2

   _cQry += ' LEFT OUTER JOIN ' + RetSQLName( 'SA1' ) + " SA1 ON (A1_COD = F2_CLIENTE) AND (A1_LOJA = F2_LOJA) AND (SA1.D_E_L_E_T_ <> '*') "

   If ! ( Empty( xFilial( 'SA1' ) ) )
 
      _cQry += 'AND (SA1.A1_FILIAL = SF2.F2_FILIAL) '

   Else

      _cQry += "AND (SA1.A1_FILIAL = '" + xFilial( 'SA1' ) + "') "

   End

End

_cQry += ' WHERE '
_cQry += " (SF2.D_E_L_E_T_ <> '*') AND "
_cQry += " (SF2.F2_EMISSAO BETWEEN '" + _cDtI + "' AND '" + _cDtF + "') AND "
_cQry += " (SF4.F4_DUPLIC = 'S') AND "
_cQry += " (F2_TIPO <> 'D' AND F2_TIPO <> 'B') AND "
_cQry += "Not (SF2.F2_Filial = '0701' AND SF2.F2_SERIE = '2') AND "
_cQry += "Not (SF2.F2_ZZNIVEL IN ('4', '6') AND SF2.F2_FILIAL = '0202') AND "
_cQry += " (CHARINDEX(F2_CLIENTE,'" + _aExcCli + "') = 0 )"

If MV_PAR02 = 1

   _cQry += " AND (ZZ5_TIPO = '1')"

ElseIf MV_PAR02 = 2

   _cQry += " AND (ZZ5_TIPO = '2')"

Else

   _cQry += " AND ((ZZ5_TIPO = '1') OR (ZZ5_TIPO = '2'))"

End

_cQry += ' GROUP BY '

If MV_PAR01 <> 2

   _cQry += ' A1_NREDUZ'

Else

   _cQry += ' BM_DESC'

End

_cQry += ') DLVTBL'

_cQry += ' GROUP BY'

If MV_PAR01 <> 2

   _cQry += ' A1_NREDUZ'

Else

   _cQry += ' BM_DESC'

End


_cQry += ' ORDER BY TOTAL DESC'

	_nHandle := fCreate("C:\XML\Sql.txt")
	fWrite(_nHandle, _cQry)
	fclose()

_nRec := 0
dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cQry),"TMP",.T.,.T.)

TMP->(dbEval({ || _nRec++ },,{||!Eof()} ))
TMP->( dbGoTop() )
SetRegua( _nRec )
m_pag := 1                 

nLin  := 60
_nTotIpi   := 0
_nTotICMS  := 0
_nTotPIS   := 0
_nTotCOF   := 0
_nTotSub   := 0
_nTotNet   := 0
_nTotReal  := 0
_nTotMVda  := 0
_nTotQde   := 0
_nTotABrut := 0
_nTotAReal := 0
_nTotReal  := 0
_nTotVda   := 0
_nTotTot   := 0
_nItem     := 0

While ! TMP->( Eof() )

   If nLin > 59

      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 10

   End

   If MV_PAR01 <> 1

      @ nLin, 00 PSAY TMP->BM_DESC

   Else

      @ nLin, 00 PSAY TMP->A1_NREDUZ

   End

   _nNet := TMP->TOTAL
   _nNet -= TMP->IPI 
   _nNet -= TMP->PIS   
   _nNet -= TMP->ICMS
   _nNet -= TMP->COFINS
   _nNet -= TMP->SUBTRIB 
   
   _nMedReal :=  _nNet
   _nMedReal /= TMP->AREAREAL
   _nMedVda  := _nNet
   _nMedVda  /= TMP->AREABRUT
   
   _nReal  := TMP->TOTAL
   _nReal  /= TMP->AREAREAL
   _nVenda := TMP->TOTAL
   _nVenda /= TMP->AREABRUT
   
   @ nLin, 30 PSAY TMP->IPI      PICTURE '@E 999,999,999.99'
   @ nLin, 46 PSAY TMP->ICMS     PICTURE '@E  999,999,999.99'
   @ nLin, 61 PSAY TMP->PIS      PICTURE '@E  999,999,999.99'
   @ nLin, 76 PSAY TMP->COFINS   PICTURE '@E  999,999,999.99'
   @ nLin, 91 PSAY TMP->SUBTRIB  PICTURE '@E  999,999,999.99'
   @ nLin,106 PSAY _nNet         PICTURE '@E 999,999,999.99'
   @ nLin,121 PSAY _nMedReal     PICTURE '@E 999,999.999' 
   @ nLin,133 PSAY _nMedVda      PICTURE '@E 999,999.999'
   @ nLin,145 PSAY TMP->QDE      PICTURE '@E 999,999,999'
   @ nLin,157 PSAY TMP->AREABRUT PICTURE '@E 9999,999.999'
   @ nLin,170 PSAY TMP->AREAREAL PICTURE '@E 9999,999.999'
   @ nLin,183 PSAY _nReal        PICTURE '@E 999,999.99'
   @ nLin,194 PSAY _nVenda       PICTURE '@E 999,999.99'
   @ nLin,205 PSAY TMP->TOTAL    PICTURE '@E 999,999,999.99'

   _nTotIpi   += TMP->IPI
   _nTotICMS  += TMP->ICMS
   _nTotPIS   += TMP->PIS
   _nTotCOF   += TMP->COFINS
   _nTotSub   += TMP->SUBTRIB
   _nTotNet   += _nNet
   _nTotReal  += _nMedReal
   _nTotMVda  += _nMedVda
   _nTotQde   += TMP->QDE
   _nTotABrut += TMP->AREABRUT
   _nTotAReal += TMP->AREAREAL
   _nTotReal  += _nReal
   _nTotVda   += _nVenda
   _nTotTot   += TMP->TOTAL
   
   nLin ++
   _nItem ++
   IncRegua()

   TMP->( dbSkip() )

End

@ nLin, 30 PSAY  '--------------'
@ nLin, 46 PSAY  '--------------'
@ nLin, 61 PSAY  '--------------'
@ nLin, 76 PSAY  '--------------'
@ nLin, 91 PSAY  '--------------'
@ nLin,106 PSAY  '--------------'
@ nLin,121 PSAY  '-----------' 
@ nLin,133 PSAY  '-----------'
@ nLin,145 PSAY  '-----------'
@ nLin,157 PSAY  '------------'
@ nLin,170 PSAY  '------------'
@ nLin,183 PSAY  '----------'
@ nLin,194 PSAY  '----------'
@ nLin,205 PSAY  '--------------'

nLin ++

@ nLin, 00 PSAY 'TOTAIS'
@ nLin, 30 PSAY _nTotIPI   PICTURE '@E 999,999,999.99'
@ nLin, 46 PSAY _nTotICMS  PICTURE '@E  999,999,999.99'
@ nLin, 61 PSAY _nTotPIS   PICTURE '@E  999,999,999.99'
@ nLin, 76 PSAY _nTotCOF   PICTURE '@E  999,999,999.99'
@ nLin, 91 PSAY _nTotSub   PICTURE '@E  999,999,999.99'
@ nLin,106 PSAY _nTotNet   PICTURE '@E 999,999,999.99'
@ nLin,121 PSAY _nTotNet / _nTotAReal PICTURE '@E 999,999.999' 
@ nLin,133 PSAY _nTotNet / _nTotABrut PICTURE '@E 999,999.999'
@ nLin,145 PSAY _nTotQde   PICTURE '@E 999,999,999'
@ nLin,157 PSAY _nTotABrut PICTURE '@E 9999,999.999'
@ nLin,170 PSAY _nTotAReal PICTURE '@E 9999,999.999'
@ nLin,183 PSAY _nTotTot / _nTotAReal PICTURE '@E 999,999.99'
@ nLin,194 PSAY _nTotTot / _nTotABrut PICTURE '@E 999,999.99'
@ nLin,205 PSAY _nTotTot   PICTURE '@E 999,999,999.99'

Set Device To Screen
Set Printer To

If aReturn[5] == 1

   dbcommitAll()
   OurSpool( wnrel )

End

MS_FLUSH()
TMP->( dbCloseArea() )

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณSergio Santana      บ Data ณ 09/11/2012  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RPTPOSNCM                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1()

PutSx1("RPTRAN","01","Tipo ?","Tipo ?","Tipo ?","mv_ch1","N",1,0,1,"C","","","","","mv_par01","Clientes","Clientes","Clientes","Grupo de Produto","Grupo de Produto","Grupo de Produto","","","","","","","","","","")
PutSx1("RPTRAN","02","S้rie ?","S้rie ?","S้rie ?","mv_ch2","N",1,0,1,"C","","","","","mv_par02","Laminados","Laminados","Laminados",,"Temperados","Temperados","Temperados",,"Ambos","Ambos","Ambos","","","","","")
PutSx1("RPTRAN","03","Data Inicial ?","Data Inicial ?","Data Inicial ?","mv_ch3","D",8,0,1,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1("RPTRAN","04","Data Final ?","Data Final ?","Data Final ?","mv_ch4","D",8,0,1,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")

Return( NIL )
