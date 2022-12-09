USER FUNCTION FISFILNFE()

If AllTrim( UPPER( GetEnvServer() ) ) = 'COMPRAS'

   U_NFSDAGSTD( dTos( dDataBase ), dTos( dDataBase ), .F. )
   U_CtaRcGstq( '  ', dTos( dDataBase ), dTos( dDataBase ) , ' ', .T. )
   U_CtaRcGstq( 'BV', dTos( dDataBase ), dTos( dDataBase ) , ' ', .T. )

End

RETURN( cCondicao )