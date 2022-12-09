
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf050CdBar บAutor  ณS้rgio Santana      บ Data ณ  22/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Converte c๓digo de barras para linha digitแvel             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Glasstech                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function f050CdBar( _cParm )

Local _cCodBar := ''
Local _nSoma   := 0
Local n        := 0
Local i        := 0
Local _cLinDig := ''
Local _aDig := {}

Private _cTipo := '' 

_cTipo := Substr( _cParm, 1, 1 )

If _cTipo = '8'

   _aDig := { Substr( _cParm, 12, 11 ),;
	 		  Substr( _cParm, 23, 11 ),;
			  Substr( _cParm, 34, 11 ) ;
		    }

Else

 _aDig := { Substr( _cParm, 1, 4 ) + Substr( _cParm, 20, 5 ),;
			Substr( _cParm, 25, 10 ),;
			Substr( _cParm, 35, 10 ) ;
		  }

End

For i := 1 To 3

  _cCodBar += _aDig[ i ]
  
  If Substr( _cParm, 1, 1 ) <> '8'

     _nMod := 4

  Else

     _nMod := 3

  End

  If (Substr( _cParm, _nMod, 1 ) $ '6;7') .Or.;
     (_cTipo <> '8')

     _cCodBar += fMod10( _aDig[ i ] )  // Calcula Digito base 10

  Else
  
     _cCodBar += fMod11( _aDig[ i ] )  // Calcula Digito base 11
  
  End

Next
            
If _cTipo = '8' // Concessionarias e Tributos
   

   If Substr( _cParm, 3, 1 ) $ '6;7' // Concessionarias e Tributos   

      _cDig := fMod10( Substr( _cParm, 1, 11 ) )

   Else

      _cDig := fMod11( Substr( _cParm, 1, 11 ) )

   End

Else

   _cDig := fMod11( Substr( _cParm, 1, 4 ) + Substr( _cParm, 6, 39 ) )

End

If _cTipo = '8' // Concessionarias e Tributos

   _cBlc    := Substr( _cParm, 1, 11 )
   _cBlc    += _cDig   // Digito Verificador 
   _cBlc    += _cCodBar
   _cCodBar := _cBlc

Else   

  _cCodBar += _cDig   // Digito Verificador 
  _cCodBar += Substr( _cParm, 6, 14 )

End

Return( _cCodBar )


Static Function fMod10( _pDig )

  Local _nPos  :=  Len( _pDig )
  Local _nDig  := 0
  Local _nSoma := 0 
  Local _nMult := 2
  Local n      := 0

  For n := _nPos To 1 Step -1
  
      _nDig  := Val(Substr( _pDig, n, 1 ) ) * _nMult
      _nDig  := if( _nDig > 9, (_nDig - 10) + 1, _nDig )
      _nSoma += _nDig
      _nMult := if( _nMult <> 2, 2, 1 )
  
  Next
  
  _nDig := 10 - ( _nSoma % 10 )
  _nDig := If( _nDig = 10, 0, _nDig )
  _nDig := StrZero( _nDig, 1, 0 )

Return( _nDig )


Static Function fMod11( _pDig )

  Local _nLen    := Len ( _pDig )
  Local _nSoma   := 0
  Local _nMult   := 2
  Local i        := 0
  Local _nDig    := 0
   
  For i := _nLen To 1 Step -1
 
      _nSoma += Val( Substr( _pDig, i, 1 ) ) * _nMult
      _nMult ++

      If _nMult > 9

          _nMult := 2

      End
   
   Next

   _nDig := 11 - ( _nSoma % 11 )
   
   If ( _nDig =  0 ) .Or.;
      ( _nDig = 10 ) .Or.;
      ( _nDig = 11 )
      
      If _cTipo <> '8'

         _nDig := 1

      Else

         _nDig := 0

      End

   End

   _nDig := StrZero( _nDig, 1, 0 )

Return( _nDig )