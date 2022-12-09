USER FUNCTION F390VCH()

LOCAL cAlias:= Alias( )
LOCAL lRet  := .t.
LOCAL nReg  := Recno()

If Empty( cCheque390 )
	Return(  .F. )
End

cCheque390 := StrZero( Val( cCheque390 ), 6, 0 ) + Space( Len( cCheque390 ) - 6 )

SEF->( dbSetOrder(1) )

If SEF->( dbSeek( cFilial + cBanco390 + cAgencia390 + cConta390 + cCheque390 ) )
   Help( " ",1,"fa390Cheq" )
   lRet := .F.
End

SEF->( dbGoto( nReg ) )

Return( lRet )
