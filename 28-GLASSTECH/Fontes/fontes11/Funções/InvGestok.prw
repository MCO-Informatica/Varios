User Function InvGestok()


Processa( { || GeraInv() } )


Return( NIL )


Static Function GeraInv()

ProcRegua( 4 )

_cQry := "DELETE FROM SB7010 WHERE B7_DOC = 'GSTOK'"
_lRet := TCSQlExec( _cQry )
            
IncProc()

_cQry := 'SELECT DISTINCT'
_cQry += " SB2.B2_FILIAL, ISNULL( INV.XFILIAL, ' ' ) XFILIAL,"
_cQry += " SB2.B2_COD, ISNULL( INV.CATALOGO, ' ') CATALOGO,"
_cQry += " SB1.B1_TIPO, SB1.B1_RASTRO, SB1.B1_LOCALIZ, "
_cQry += " SB2.B2_LOCAL, ISNULL( INV.ARMAZEM, ' ' ) ARMAZEM,"
_cQry += ' SB2.B2_QATU, ISNULL( INV.SALDO_CONTABIL, 0 ) Saldo,'
_cQry += ' ISNULL( INV.SALDO_INTERCAMBIO, 0 ) Intercambio,'
_cQry += ' ISNULL( INV.SALDO_REV, 0 ) Saldo '
_cQry += 'FROM ' + RetSQLName( 'SB2' ) + ' SB2 '
_cQry += 'LEFT OUTER JOIN ESTOQUE2 INV'
_cQry += ' ON INV.XFILIAL COLLATE Latin1_General_CI_AS = SB2.B2_FILIAL'
_cQry += ' AND INV.CATALOGO COLLATE Latin1_General_CI_AS = SB2.B2_COD'
_cQry += ' AND INV.ARMAZEM  COLLATE Latin1_General_CI_AS = SB2.B2_LOCAL '
_cQry += 'LEFT OUTER JOIN ' + RetSQLName( 'SB1' ) + ' SB1 '
_cQry += " ON SB2.B2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*' "
_cQry += " WHERE SB2.D_E_L_E_T_ <> '*' AND ISNULL( INV.SALDO_CONTABIL, 0 ) <> SB2.B2_QATU"
_cQry += ' ORDER BY B2_FILIAL, B2_COD'

dbUseArea( .T., "TOPCONN", TcGenQry(,, _cQry ), "TMP", .T., .T. )

_nRec := 0
TMP->( dbEval({ || _nRec++ },,{||!Eof()} ))
TMP->( dbGoTop() )

While ! TMP->( Eof() )

   RecLock( 'SB7', .T. )

   SB7->B7_FILIAL  := TMP->B2_FILIAL
   SB7->B7_COD     := TMP->B2_COD
   SB7->B7_LOCAL   := TMP->B2_LOCAL
   SB7->B7_TIPO    := TMP->B1_TIPO
   SB7->B7_DOC     := 'GSTOK'
   SB7->B7_DATA    := dDataBase
   SB7->B7_DTVALID := dDataBase
   SB7->B7_QUANT   := TMP->SALDO
   SB7->B7_ESCOLHA := 'S'

   If (TMP->B1_RASTRO = 'L') .Or.;
      (TMP->B1_RASTRO = 'S') 

      SB7->B7_LOTECTL := 'IPL'

   End

   If TMP->B1_LOCALIZ <> 'N'

      SB7->B7_LOCALIZ := 'PALLETS'

   End

   SB7->B7_STATUS  := '1'
   
   SB7->( MSUnLock() )

   TMP->( dbSkip() )

End

IncProc()
TMP->( dbCloseArea() )

_cQry := "SELECT SBF.*, SB1.B1_TIPO FROM SBF010 SBF, SB1010 SB1 WHERE (SBF.BF_PRODUTO = SB1.B1_COD) AND (SB1.D_E_L_E_T_ <> '*') AND (SBF.D_E_L_E_T_ <> '*') AND (((BF_LOTECTL <> 'IPL') AND (BF_LOTECTL <> ' ')) OR (BF_LOCAL = '00'))"

dbUseArea( .T., "TOPCONN", TcGenQry(,, _cQry ), "TMP", .T., .T. )
TMP->( dbGoTop() )

While ! TMP->( Eof() )

   RecLock( 'SB7', .T. )

   SB7->B7_FILIAL  := TMP->BF_FILIAL
   SB7->B7_COD     := TMP->BF_PRODUTO
   SB7->B7_LOCAL   := TMP->BF_LOCAL
   SB7->B7_TIPO    := TMP->B1_TIPO
   SB7->B7_DOC     := 'GSTOK'
   SB7->B7_DATA    := dDataBase
   SB7->B7_DTVALID := dDataBase
   SB7->B7_QUANT   := 0
   SB7->B7_ESCOLHA := 'S'
   SB7->B7_LOTECTL := TMP->BF_LOTECTL
   SB7->B7_STATUS  := '1'
   SB7->( MSUnLock() )
   TMP->( dbSkip() )

End

IncProc()
TMP->( dbCloseArea() )

_cQry := "SELECT DISTINCT MAT.*, B1_TIPO, ISNULL( SB2.B2_LOCAL, ' ' ) B2_LOCAL, ISNULL( SBF.BF_LOCAL, ' ' ) BF_LOCAL, ISNULL( SBF.BF_LOCALIZ, ' ') BF_LOCALIZ, ISNULL( SBF.BF_LOTECTL, ' ') BF_LOTECTL, ISNULL( SBF.BF_QUANT, 0 ) BF_QUANT FROM ESTOQUE_MATERIAIS MAT "
_cQry += 'LEFT OUTER JOIN ' + RetSqlName( 'SBF' ) + ' SBF ON '
_cQry += ' (BF_FILIAL = FILIAL COLLATE Latin1_General_CI_AS) AND '
_cQry += ' (BF_PRODUTO = COD COLLATE Latin1_General_CI_AS) AND '
_cQry += ' (SBF.BF_LOCAL = LOCPAD) AND '
_cQry += " (SBF.BF_LOCALIZ <> 'PALLETS') AND "
_cQry += " (SBF.BF_LOTECTL = ' ') AND "
_cQry += " (SBF.D_E_L_E_T_ <> '*') "
_cQry += 'LEFT OUTER JOIN ' + RetSqlName( 'SB2' ) + " SB2 ON (B2_FILIAL = FILIAL COLLATE Latin1_General_CI_AS) AND (B2_COD = COD COLLATE Latin1_General_CI_AS) AND (SB2.D_E_L_E_T_ <> '*') "
_cQry += 'LEFT OUTER JOIN ' + RetSqlName( 'SB1' ) + " SB1 ON (B1_COD = COD COLLATE Latin1_General_CI_AS) AND (SB1.D_E_L_E_T_ <> '*') "
_cQry += 'ORDER BY FILIAL, COD, LOCPAD'

dbUseArea( .T., "TOPCONN", TcGenQry(,, _cQry ), "TMP", .T., .T. )
TMP->( dbGoTop() )

While ! TMP->( Eof() )

   RecLock( 'SB7', .T. )

   SB7->B7_FILIAL  := TMP->FILIAL
   SB7->B7_COD     := TMP->COD
   SB7->B7_LOCAL   := TMP->LOCPAD
   SB7->B7_TIPO    := TMP->B1_TIPO
   SB7->B7_DOC     := 'GSTOK'
   SB7->B7_DATA    := dDataBase
   SB7->B7_DTVALID := dDataBase
   SB7->B7_QUANT   := TMP->QINI
   SB7->B7_ESCOLHA := 'S'
   SB7->B7_LOCALIZ := TMP->BF_LOCALIZ
   SB7->B7_STATUS  := '1'
   SB7->( MSUnLock() )
   TMP->( dbSkip() )

End

IncProc()
TMP->( dbCloseArea() )

Return( NIL )
