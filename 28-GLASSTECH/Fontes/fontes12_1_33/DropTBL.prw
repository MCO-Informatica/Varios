
User Function DropTBL()

TCLink( "MSSQL/TOTVSRH", "192.168.0.7", 7890 )

Use SX2010 Alias "SX2" New Shared
//dbselectArea("SX2")
dbGotop()

While ! ( SX2->(Eof() ) )               

   _cAlias := AllTrim(SX2->X2_CHAVE)
   cArqSQL := AllTrim(SX2->X2_ARQUIVO)

   // Testa existencia do arquivo no SQL

   If TCCANOPEN(cArqSQL)
         
      If Select( _cAlias ) = 0

         Use &(cArqSQL) Alias (_cAlias) New Shared Via "TOPCONN"

      End

      nRec  := ( _cAlias )->( RecCount() )

//      MsgInfo( cArqSQL + ' ' + alltrim(Str( nRec, 9 )) )

      ( _cAlias )->( dbCloseArea() )

      If nRec = 0

         _lRet := TCDelFile ( cArqSQL )

      End

   End

   SX2->( dbSkip() )

End
MsgInfo( 'fim' )
Return( NIL )
