#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF
#Include "rwmake.ch"

User Function RptFatur()
Private titulo      := "Faturmento Diแrio"
Private nLin        := 60
Private imprime     := .T.
Private aOrd        := {""}
Private cPerg       := "RPTFAT"
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RPTFAT" // Coloque aqui o nome do programa para impressao no cabecalho
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RELFAT" // Coloque aqui o nome do arquivo usado para impressao em disco
Private nOrdem      := 0
Private cString     := 'SF2'
Private nTipo       := 18

nOrdem   := 0
Alfa     := 0
titulo   := PADC("Faturamento Diแrio",75)
cDesc1   := PADC("",75)
cDesc2   := PADC("",75)
cDesc3   := PADC("                                                          ",75)
aReturn  := { "Especial" , 1, "Diretoria" , 2, 2, 1,"", 1 }
nLastKey := 0
         

Cabec1 := '                          Temperado                                                                         Laminado                                                             Consolidado'
Cabec2 := 'Dia      Valor          M2          M้dia      Vlr Acumulado M2 Acumulado     Valor           M2          M้dia     Vlr Acumulado  M2 Acumulado    Outros       Total diแrio    Total M2        M้dia       Acumulado'
Cabec3 := '                       Venda                                                                 Venda'

//Cabec2 := ' 99 999,999,999.99 999,999.999 999.999,999.99 999.999,999.99  999,999.999|999,999,999.99 999,999.999 999.999,999.99 999.999,999.99  999,999.999|999.999,999.99|999,999,999.99 999,999.999 999.999,999.99 999.999,999.99'
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica a existencia do SX1 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AjustaSX1()
                                 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abastece variแveis de parametros ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte( cPerg, .F. )

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

SetDefault( aReturn, cString )

If nLastKey == 27

   Return

End

RptStatus( { || RptDetail() } )  

Return( NIL )


Static Function RptDetail()
LOCAL _nMedTemp := 0
LOCAL _nDiaTemp := 0
LOCAL _nQdeTemp := 0
LOCAL _nMedLam  := 0
LOCAL _nDiaLam  := 0
LOCAL _nQdeLam  := 0
LOCAL _nConsDia := 0
LOCAL _nConsMts := 0
LOCAL _nConsMed := 0
LOCAL _nConsAcu := 0

LOCAL _tMedTemp  := 0
LOCAL _tDiaTemp  := 0
LOCAL _tQdeTemp  := 0
LOCAL _tMedLam   := 0
LOCAL _tDiaLam   := 0
LOCAL _tQdeLam   := 0
LOCAL _tConsDia  := 0
LOCAL _tConsMts  := 0
LOCAL _tConsMed  := 0
LOCAL _tConsAcu  := 0
LOCAL _tQdeBLam  := 0
LOCAL _tQdeBTemp := 0
LOCAL _tQdeRLam  := 0
LOCAL _tQdeRTemp := 0
LOCAL _nConsTot  := 0
LOCAL _nConsBrt  := 0
LOCAL _nConsReal := 0

Local _nOutAcu   := 0

Local _nHandle := 0

m_pag := 1
nLin  := 60

_aExcCli := ( SuperGetMV( 'MV_X_EC',,'{"000128","000129","000154","004061","000301","002762","003916", "000629"}') )
//_nLen    := Len( _aExcCli )

_cDtI := Dtos( MV_PAR03 )
_cDtF := Dtos( MV_PAR04 )

_cQry := 'SELECT DIA, '
_cQry += 'SUM( CONSOLIDADO ) CONSOLIDADO, '
_cQry += 'SUM( LAMINADO    ) LAMINADO, '
_cQry += 'SUM( TEMPERADO   ) TEMPERADO, '
_cQry += 'SUM( OUTROS      ) OUTROS, '
_cQry += 'SUM( QDEREALAM   ) QDEREALAM, '
_cQry += 'SUM( QDELAM      ) QDELAM, '
_cQry += 'SUM( QDETEMP     ) QDETEMP, '
_cQry += 'SUM( QDEREATMP   ) QDEREATMP '
_cQry += 'FROM '
_cQry += '('
_cQry += 'SELECT '
_cQry += 'SUBSTRING( F2_EMISSAO, 7, 2 ) DIA, '
_cQry += "SUM( CASE WHEN (D2_TIPO  = 'I') THEN 0 ELSE D2_VALBRUT END) AS CONSOLIDADO, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '1') THEN CASE WHEN (D2_TIPO = 'I') THEN 0 ELSE D2_VALBRUT END ELSE 0 END) AS LAMINADO, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '2') THEN CASE WHEN (D2_TIPO = 'I') THEN 0 ELSE D2_VALBRUT END ELSE 0 END) AS TEMPERADO, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '1' OR ZZ5_TIPO = '2') THEN 0 ELSE CASE WHEN (D2_TIPO = 'I') THEN 0 ELSE D2_VALBRUT END END) AS OUTROS, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '1') THEN CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL IN ('2','3')) THEN 0 ELSE (D2_QUANT * B1_ZZREAL) END ELSE 0 END) AS QDEREALAM, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '1') THEN CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL IN ('2','3')) THEN 0 ELSE (D2_QUANT * B1_ZZBRUTA) END ELSE 0 END) AS QDELAM, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '2') THEN CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL IN ('2','3')) THEN 0 ELSE (D2_QUANT * B1_ZZBRUTA) END ELSE 0 END) AS QDETEMP, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '2') THEN CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL IN ('2','3')) THEN 0 ELSE (D2_QUANT * B1_ZZREAL) END ELSE 0 END) AS QDEREATMP "
_cQry += "FROM  " + RetSQLName( 'SF2' ) + " SF2 "
_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SD2' ) + " SD2 ON (D2_FILIAL = F2_FILIAL) AND (D2_DOC = F2_DOC) AND (D2_SERIE = F2_SERIE) AND (D2_CLIENTE = F2_CLIENTE) AND (D2_LOJA = F2_LOJA) AND (SD2.D_E_L_E_T_ <> '*') "
_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SB1' ) + " SB1 ON (B1_COD = D2_COD) AND (SB1.D_E_L_E_T_ <> '*') "

If ! ( Empty( xFilial( 'SB1' ) ) )
 
   _cQry += 'AND (SB1.B1_FILIAL = SF2.F2_FILIAL) '

Else

   _cQry += "AND (SB1.B1_FILIAL = ' ') "

End

_cQry += "LEFT OUTER JOIN " + RetSQLName( 'ZZ5' ) + " ZZ5 ON (ZZ5_CODIGO = B1_ZZTVIDR) AND (ZZ5.D_E_L_E_T_ <> '*') "

If ! ( Empty( xFilial( 'ZZ5' ) ) )
 
   _cQry += 'AND (ZZ5.ZZ5_FILIAL = SF2.F2_FILIAL) '

Else

   _cQry += "AND (ZZ5.ZZ5_FILIAL = ' ') "

End

_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SF4' ) + " SF4 ON (F4_CODIGO = D2_TES) AND (SF4.D_E_L_E_T_ <> '*') "

If ! ( Empty( xFilial( 'SF4' ) ) )
 
   _cQry += 'AND (SF4.F4_FILIAL = SF2.F2_FILIAL) '

Else

   _cQry += "AND (SF4.F4_FILIAL = ' ') "

End

_cQry += 'WHERE '
_cQry += "(SF2.D_E_L_E_T_ <> '*') AND "
_cQry += "(F2_EMISSAO BETWEEN '" + _cDtI + "' AND '" + _cDtF + "') AND "
_cQry += "(F4_DUPLIC = 'S') AND "
_cQry += " (F2_TIPO <> 'D' AND F2_TIPO <> 'B') AND "
_cQry += "Not (SF2.F2_Filial = '0701' AND SF2.F2_SERIE = '2') AND "
_cQry += "Not (SF2.F2_ZZNIVEL IN ('4', '6') AND SF2.F2_FILIAL = '0202') AND "
_cQry += "(CHARINDEX(F2_CLIENTE,'" + _aExcCli + "') = 0) "
_cQry += "GROUP BY SUBSTRING( F2_EMISSAO, 7, 2 ) "

/*[]---------------------------------------------------------------------------------------------------------------------------------------------------------[]


                                                Descontos devolu็๕es 


  []--------------------------------admin-------------------------------------------------------------------------------------------------------------------------[]*/
_cQry += "UNION "
_cQry += "SELECT "
_cQry += "SUBSTRING( D1_DTDIGIT, 7, 2 ) DIA, "
_cQry += "SUM( D1_TOTAL + D1_VALIPI + D1_ICMSRET ) * -1 AS CONSOLIDADO, "
_cQry += "SUM( CASE WHEN ZZ5_TIPO = '1' THEN (D1_TOTAL + D1_VALIPI + D1_ICMSRET)*-1 ELSE 0 END) AS LAMINADO, "
_cQry += "SUM( CASE WHEN ZZ5_TIPO = '2' THEN (D1_TOTAL + D1_VALIPI + D1_ICMSRET)*-1 ELSE 0 END) AS TEMPERADO, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '1' OR  ZZ5_TIPO = '2') THEN 0 ELSE ( D1_TOTAL + D1_VALIPI + D1_ICMSRET ) * -1 END) AS OUTROS, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '1') THEN CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL IN ('2','3')) THEN 0 ELSE (D1_QUANT * B1_ZZREAL) * -1 END ELSE 0 END) AS QDEREALAM, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '1') THEN CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL IN ('2','3')) THEN 0 ELSE (D1_QUANT * B1_ZZBRUTA) * -1 END ELSE 0 END) AS QDELAM, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '2') THEN CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL IN ('2','3')) THEN 0 ELSE (D1_QUANT * B1_ZZBRUTA) * -1 END ELSE 0 END) AS QDETEMP, "
_cQry += "SUM( CASE WHEN (ZZ5_TIPO = '2') THEN CASE WHEN (F2_SERIE = 'X') AND (F2_ZZNIVEL IN ('2','3')) THEN 0 ELSE (D1_QUANT * B1_ZZREAL) * -1 END ELSE 0 END) AS QDEREATMP "
_cQry += "FROM " + RetSQLName( 'SD1' ) + " SD1 "
_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SF2' ) + " SF2 ON (F2_FILIAL = D1_FILIAL) AND (F2_DOC = D1_NFORI) AND (F2_SERIE = D1_SERIORI) AND (F2_CLIENTE = D1_FORNECE) AND (F2_LOJA = D1_LOJA) AND (SF2.D_E_L_E_T_ <> '*') "
_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SB1' ) + " SB1 ON (B1_FILIAL= ' ') AND (B1_COD = D1_COD) AND (SB1.D_E_L_E_T_ <> '*') "
_cQry += "LEFT OUTER JOIN " + RetSQLName( 'ZZ5' ) + " ZZ5 ON (ZZ5_FILIAL = ' ') AND (ZZ5_CODIGO = B1_ZZTVIDR) AND (ZZ5.D_E_L_E_T_ <> '*') "
_cQry += "LEFT OUTER JOIN " + RetSQLName( 'SF4' ) + " SF4 ON (F4_FILIAL = ' ') AND (F4_CODIGO = D1_TES) AND (SF4.D_E_L_E_T_ <> '*') "
_cQry += 'WHERE '
_cQry += "(CHARINDEX(D1_FORNECE,'" + _aExcCli + "') = 0) AND (D1_TIPO = 'D') AND (D1_FORMUL = 'S') AND (SD1.D_E_L_E_T_ <> '*') AND (D1_SERIE = '3') AND (D1_NFORI <> ' ') "
_cQry += "AND (D1_DTDIGIT BETWEEN '" + _cDtI + "' AND '" + _cDtF + "') AND (F4_DUPLIC = 'S') AND "
_cQry += "Not (SF2.F2_Filial = '0701' AND SF2.F2_SERIE = '2') AND "
_cQry += "Not (SF2.F2_ZZNIVEL IN ('4', '6') AND SF2.F2_FILIAL = '0202') AND "
_cQry += "(F2_TIPO <> 'D' AND F2_TIPO <> 'B') "
_cQry += "GROUP BY SUBSTRING( D1_DTDIGIT, 7, 2 ) "
_cQry += ") DRVLTBL "
_cQry += "GROUP BY DIA "
_cQry += "ORDER BY DIA"

	_nHandle := fCreate("C:\Temp\Sql.txt")
	fWrite(_nHandle, _cQry)
	fclose()

_nRec := 0
dbUseArea( .T.,"TOPCONN",TcGenQry(,, _cQry ),"TMP", .T., .T. )

TMP->( dbEval({ || _nRec++ },,{|| ! Eof() } ))
TMP->( dbGoTop() )
SetRegua( _nRec )
 
While ! ( TMP->( Eof() ) )

   If nLin > 59

      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 10

   End

   _tQdeBLam  += TMP->QDELAM
   _tQdeBTemp += TMP->QDETEMP

   _tQdeRLam  += TMP->QDEREALAM
   _tQdeRTemp += TMP->QDEREATMP

   @ nLin,   1 PSAY TMP->DIA       PICTURE '@K 99'
   @ nLin,   4 PSAY TMP->TEMPERADO PICTURE '@E 999,999,999.99'
   @ nLin,  19 PSAY TMP->QDETEMP   PICTURE '@E 999,999.999'

   _nMedTemp := TMP->TEMPERADO    //real temperado comercial
   _nMedTemp /= TMP->QDETEMP
   
   @ nLin,  31 PSAY _nMedTemp PICTURE '@E 999,999,999.99'

   _nDiaTemp += TMP->TEMPERADO
   _nQdeTemp += TMP->QDETEMP
   
   @ nLin,  46 PSAY _nDiaTemp  PICTURE '@E 999,999,999.99'
   @ nLin,  61 PSAY _nQdeTemp  PICTURE '@E 999,999.999'

   @ nLin,  74 PSAY TMP->LAMINADO PICTURE '@E 999,999,999.99'
   @ nLin,  89 PSAY TMP->QDELAM   PICTURE '@E 999,999.999'

   _nMedLam := TMP->LAMINADO    //real   laminado comercial
   _nMedLam /= TMP->QDELAM
                                   
   @ nLin, 101 PSAY _nMedLam PICTURE '@E 999,999,999.99'

   _nDiaLam += TMP->LAMINADO
   _nQdeLam += TMP->QDELAM

   @ nLin, 116 PSAY _nDiaLam PICTURE '@E 999,999,999.99'
   @ nLin, 132 PSAY _nQdeLam PICTURE '@E 999,999.999'

   @ nLin, 144 PSAY TMP->OUTROS PICTURE '@E 999,999,999.99'

   _nConsDia := TMP->TEMPERADO
   _nConsDia += TMP->LAMINADO                                         
   
   _nConsTot += _nConsDia
   _nOutAcu  += TMP->OUTROS

   _nConsMts := TMP->QDETEMP
   _nConsMts += TMP->QDELAM
   
   _nConsBrt  += TMP->QDETEMP
   _nConsBrt  += TMP->QDELAM

   _nConsReal += TMP->QDEREATMP
   _nConsReal += TMP->QDEREALAM

   _nConsMed := _nConsDia
   _nConsMed /= _nConsMts

   _nConsAcu += _nConsDia
   _nConsAcu += TMP->OUTROS

   @ nLin, 159 PSAY _nConsDia PICTURE '@E 999,999,999.99'
   @ nLin, 174 PSAY _nConsMts PICTURE '@E 999,999.999'
   @ nLin, 186 PSAY _nConsMed PICTURE '@E 999,999,999.99'
   @ nLin, 201 PSAY _nConsAcu PICTURE '@E 999,999,999.99'

   TMP->( dbSkip() )
   nLin ++
                                                                
End

nLin += 2

@ nLin,  19 PSAY _tQdeBTemp PICTURE '@E 999,999.999'
@ nLin,  31 PSAY (_nDiaTemp / _tQdeBTemp)  PICTURE '@E 999,999,999.99'
@ nLin,  46 PSAY 'COMERCIAL'
                                   
@ nLin,  89 PSAY _tQdeBLam PICTURE '@E 999,999.999'
@ nLin, 101 PSAY (_nDiaLam  / _tQdeBLam)  PICTURE '@E 999,999,999.99'
@ nLin, 116 PSAY 'COMERCIAL'

//@ nLin, 159 PSAY 'TOTAL'
//@ nLin, 174 PSAY _nConsBrt PICTURE '@E 999,999.999'
//@ nLin, 186 PSAY ( _nConsTot / _nConsBrt ) PICTURE '@E 999,999,999.99'
//@ nLin, 201 PSAY 'COMERCIAL'

nLin ++

@ nLin,  19 PSAY _tQdeRTemp PICTURE '@E 999,999.999'
@ nLin,  31 PSAY (_nDiaTemp / _tQdeRTemp)  PICTURE '@E 999,999,999.99'
@ nLin,  46 PSAY 'REAL'
                                   
@ nLin,  89 PSAY _tQdeRLam PICTURE '@E 999,999.999'
@ nLin, 101 PSAY (_nDiaLam  / _tQdeRLam)  PICTURE '@E 999,999,999.99'
@ nLin, 116 PSAY 'REAL'

//@ nLin, 174 PSAY _nConsReal PICTURE '@E 999,999.999'
//@ nLin, 186 PSAY ( _nConsTot / _nConsReal ) PICTURE '@E 999,999,999.99'
//@ nLin, 201 PSAY 'REAL'

@ nLin, 144 PSAY _nOutAcu PICTURE '@E 999,999,999.99'
@ nLin, 159 PSAY 'OUTROS'

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
ฑฑบPrograma  ณAjustaSX1 บAutor  ณSergio Santana      บ Data ณ 12/02/2013  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RPTFATUR                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1()

PutSx1("RPTFAT","01","Tipo ?","Tipo ?","Tipo ?","mv_ch1","N",1,0,1,"C","","","","","mv_par01","Clientes","Clientes","Clientes","Grupo de Produto","Grupo de Produto","Grupo de Produto","","","","","","","","","","")
PutSx1("RPTFAT","02","S้rie ?","S้rie ?","S้rie ?","mv_ch2","N",1,0,1,"C","","","","","mv_par02","Laminados","Laminados","Laminados",,"Temperados","Temperados","Temperados",,"Ambos","Ambos","Ambos","","","","","")
PutSx1("RPTFAT","03","Data Inicial ?","Data Inicial ?","Data Inicial ?","mv_ch3","D",8,0,1,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1("RPTFAT","04","Data Final ?","Data Final ?","Data Final ?","mv_ch4","D",8,0,1,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")

Return( NIL )


