User Function M410FSQL()

_fSB1 := xFilial( 'SB1' )
_fSC5 := xFilial( 'SC5' )
_fSA3 := xFilial( 'SA3' )

_cCod  := RetCodUsr()

If cNivel <  6

   _cFiltro := dbFilter()

   If Empty( _cFiltro )

      _aSql := ''
      _cVnd := ''
      _lExt := ''
      FiltroVend( @_cCod, @_aSql, @_cVnd, @_lExt )

      SA1->( dbSetFilter( { || &_aSql }, _aSql ) )
      
      _vFlt := "@ ((A3_SUPER IN (" + _cCod + ")) OR (A3_COD = '" + _cVnd + "')) AND (D_E_L_E_T_ = '')"
      SA3->( dbSetFilter( { || &_vFlt }, _vFlt ) )

      _pFlt := "( C5_FILIAL = '"
      _pFlt += _fSC5
      _pFlt += "') AND "
      _pFlt := "(C5_VEND1 IN (" + _cCod + ")) "
//      _pFlt += "AND (D_E_L_E_T_ = '' )"

      SC5->( dbSetFilter( { || &_pFlt }, _pFlt ) )

      _bFlt := "@ (B1_TIPO = 'PA') AND (D_E_L_E_T_ = '' )"
      SB1->( dbSetFilter( { || &_bFlt }, _bFlt ) )

   End

End

Return( _pFlt )


/*

  Esta função tem por finalidade filtrar os pedidos pelos seus respectivos vendedores/supervisores

*/

Static Function FiltroVend( _cCod, _aSql, _cVnd, _lExt )

_lExt := .F.
_cSup := Space( 6 )

_nIdx := SA3->( IndexOrd() )
SA3->( dbSetOrder( 7 ) )

If ! ( SA3->( dbSeek( _fSA3 + _cCod, .F. ) ) )

   _cCod := "'000000"

Else                          

   _cCod := "'" 
   _cCod += SA3->A3_COD
   _aSup := {}
   SA3->( dbSetOrder( 5 ) )

   If SA3->A3_TIPO <> 'I'
      _lExt := .T.
   End

   If SA3->A3_GEREN <> Space( 6 )

      _cGer := SA3->A3_COD
      _aSup := { SA3->A3_COD }

      If ( SA3->( dbSeek( _fSA3 + _cGer, .F. ) ) )

         While _cGer = SA3->A3_SUPER

               _nPos := aScan( _aSup, { |x| x = SA3->A3_COD } )
  
               If _nPos = 0

                  aAdd( _aSup, SA3->A3_COD )
        
               End

               _cCod += "','"
               _cCod += SA3->A3_COD
               SA3->( dbSkip() )
            
         End

      End

  ElseIf SA3->A3_SUPER <> '      '

         _aSup := { SA3->A3_COD }
         _cCod += "','"
         _cCod += SA3->A3_COD
 
  End
                                                                                                             
End

_cCod += "'"
_cUsr := RetCodUsr()
_cVnd := Substr( _cCod, 2, 6 )

_aSql := "@ ( (A1_VEND IN (" + _cCod + ")) OR (A1_SUPER IN (" + _cCod + ")) OR (A1_VEND2 IN (" + _cCod + ")) ) AND (D_E_L_E_T_ = '') "

SA3->( dbSetOrder( _nIdx ) )

Return( _cCod, _aSql, _cVnd, _lExt )
