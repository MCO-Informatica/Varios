USER FUNCTION FLTSB1()

SAJ->( dbSetOrder( 2 ) )
SAJ->( dbSeek( xFilial( 'SAJ' ) + __cUserId, .F. ) )
_cUsr := ''

While __cUserId = SAJ->AJ_USER
   
   _cUsr += SAJ->AJ_GRCOM
   _cUsr += ';'
   SAJ->( dbSkip() )

End

If (__cUserId = '000009') .Or.;
   (__cUserId = '000012') .Or.;
   (__cUserId = '000000')

   _cFiltro := NIL

ElseIf ! Empty( _cUsr )

   _cFiltro := "@ (B1_FILIAL = '" + xFilial( 'SB1' ) + "') AND (CHARINDEX( B1_GRUPCOM, '" + _cUsr + "' ) <> 0) AND (D_E_L_E_T_ <> '*')"

Else

  _cFiltro  := NIL

End

SAJ->( dbSetOrder( 1 ) )

Return( _cFiltro )