/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��Programa  �NFECTSEV  �Autor  �S�rgio Santana      � Data �  11/01/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     �  Este ponto de entrada tem a finalidade de realizar lan�a- ���
���          �  mentos por multiplas naturezas                            ���
�������������������������������������������������������������������������͹��
���Uso       � Thecnoglass                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NFECTSEV()

LOCAL _aCabSEV   := ParamIXB[ 1 ]
LOCAL _nLen      := Len( aCols )   // Qde de itens lan�ado a nota
LOCAL _nDel      := Len( aHeader ) // Flag de item deletado, ser� incrementado porteriormente, qde header + 1
LOCAL _nPosCod   := aScan( aHeader, { |x| Alltrim( x[ 2 ] ) = "D1_COD" } ) // Posi��o do c�digo do produto no Array
LOCAL _nPosTot   := aScan( aHeader, { |x| Alltrim( x[ 2 ] ) = "D1_TOTAL" } ) // Posi��o do total no Array
LOCAL _nPosIPI   := aScan( aHeader, { |x| Alltrim( x[ 2 ] ) = "D1_VALIPI" } ) // Posi��o do Valor IPI no Array
LOCAL _nPosDct   := aScan( aHeader, { |x| Alltrim( x[ 2 ] ) = "D1_VALDESC" } ) // Posi��o do desconto no Array
LOCAL _nPosDsp   := aScan( aHeader, { |x| Alltrim( x[ 2 ] ) = "D1_DESPESA" } ) // Posi��o da despesa no Array
LOCAL _nPosImp   := aScan( aHeader, { |x| Alltrim( x[ 2 ] ) = "D1_II" } ) // Posi��o do Imp. Importa��o no Array
LOCAL _nPosSub   := aScan( aHeader, { |x| Alltrim( x[ 2 ] ) = "D1_ICMSRET" } ) // Posi��o do ICMS Retido Subst. Trib. no Array
LOCAL _nPosFrt   := aScan( aHeader, { |x| Alltrim( x[ 2 ] ) = "D1_FRETE" } ) // Posi��o do Frete no Array 
LOCAL _nPosNat   := aScan( _aCabSEV, { |x| Alltrim( x[ 2 ] ) = "EV_NATUREZ" } ) // Posi��o da Natureza no Array
LOCAL _nPosPer   := aScan( _aCabSEV, { |x| Alltrim( x[ 2 ] ) = "EV_PERC" } ) // Posi��o do Percentual para rateio no Array
LOCAL _aItensSEV := {}
LOCAL _aItensRec := {}
LOCAL _nTotal    := 0
LOCAL _nTotIt    := 0
LOCAL _cFilSB1   := xFilial( 'SB1' )
LOCAL _cFilSBM   := xFilial( 'SBM' )

_nDel ++

For i := 1 To _nLen

    If ! ( aCols[ i ][ _nDel ] ) .And.;
       ! Empty( aCols[ i ][ _nPosCod ] )

       SB1->( dbSeek( _cFilSB1 + aCols[ i ][ _nPosCod ], .F. ) )
       SBM->( dbSeek( _cFilSBM + SB1->B1_GRUPO, .F. ) )
       _nPosRec  := aScan( _aItensRec, { |x| x[ 1 ] = SBM->BM_ZZNATUR } )

       _nTotIt   := aCols[ i ][ _nPosTot ]
       _nTotIt   += aCols[ i ][ _nPosIPI ]
       _nTotIt   += aCols[ i ][ _nPosDsp ]
       _nTotIt   += aCols[ i ][ _nPosImp ]
       _nTotIt   += aCols[ i ][ _nPosSub ]

       If _nPosFrt <> 0

          _nToIt   += aCols[ i ][ _nPosFrt ]

       End

       _nTotIt   -= aCols[ i ][ _nPosDct ]
       _nTotal   += _nTotIt
       
       If _nPosRec <> 0
       
          _aItensRec[ _nPosRec ][ 2 ] += _nTotIt
       
       Else

          aAdd( _aItensRec, { SBM->BM_ZZNATUR, _nTotIt } )
       
       End

    End   

Next 

_nLen := Len( _aItensRec )
_lAtu := .T.

For i := 1 To _nLen

    _nPerc := _aItensRec[ i ][ 2 ] / _nTotal
    _nPerc *= 100

    If ( _nPerc = 100 ) .Or.;
       Empty( _aItensRec[ i ][ 1 ] )

       _lAtu := .F.
       Exit

    Else

       _aItensRec[ i ][ 2 ] := Round( _nPerc, 2 )

    End
                                     
Next

If _lAtu

   _nCnt := Len( _aCabSEV )
   
   For i := 1 To _nLen 

       aAdd( _aItensSEV, Array( _nCnt + 1 ) )

       For y := 1 To _nCnt

           If AllTrim( _aCabSEV[ y, 2 ] ) == "EV_ALI_WT"

              _aItensSEV[ i ][ y ] := "SEV"

           ElseIf AllTrim( _aCabSEV[ y, 2 ] ) == "EV_REC_WT"

              _aItensSEV[ i ][ y ] := 0

           Else

              _aItensSEV[ i ][ y ] := CriaVar( _aCabSEV[ y ][ 2 ] )

           End

       Next
       
       _aItensSEV[ i ][ _nPosNat  ] := _aItensRec[ i ][ 1 ]
       _aItensSEV[ i ][ _nPosPer  ] := _aItensRec[ i ][ 2 ]
       _aItensSEV[ i ][ _nCnt + 1 ] := .F.
   
   Next

Else

   _aItensSEV := ParamIXB[ 2 ]

End

Return( { ParamIXB[ 1 ], _aItensSEV } )


