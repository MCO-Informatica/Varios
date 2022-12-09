/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f240CdBar ºAutor  ³Sérgio Santana      º Data ³  21/07/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna registro J posições 018 - 061 de acordo com o tipo º±±
±±º          ³ do campo Codigo de Barras ou Linha Digitavel               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GlassTech                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function f240CdBar( _cParm )
 
Local _nLen    := 0
Local _cLinDig := ''
Local _nDiv    := 0
Local _nSoma   := 0
Local _nMult   := 2
Local i        := 0

_cParm := Alltrim( _cParm )
_nLen := Len( _cParm )

If _nLen = 47

   _cRet := Substr( _cParm,  1, 3 )  // Banco Favorecido
   _cRet += Substr( _cParm,  4, 1 )  // Moeda
   _cRet += Substr( _cParm, 33, 1 )  // Digito Verificador 
   _cRet += Substr( _cParm, 34, 4 )  // Fator de Vencimento
   _cRet += StrZero( Val( Subst( _cParm, 38,10 ) ), 10, 0 ) // Valor
   _cRet += Substr( _cParm,  5, 5 )  // Campo Livre
   _cRet += Substr( _cParm, 11, 10 ) // Campo Livre
   _cRet += Substr( _cParm, 22, 10 ) // Campo Livre


ElseIf _nLen = 44

   _cRet := Substr( _cParm,  1, 3 )  // Banco Favorecido
   _cRet += Substr( _cParm,  4, 1 )  // Moeda
   
   _cLinDig := Substr( _cParm, 1, 4 ) + Substr( _cParm, 6, 39 )
   _nLen    := Len ( _cLinDig )
   
   For i := _nLen To 1 Step -1
   
      _nSoma += Val( Substr( _cLinDig, i, 1 ) ) * _nMult
      _nMult ++

      if _nMult > 9

         _nMult := 2

      End
   
   Next
   
   _nDiv := 11 - ( _nSoma % 11 )
   
   If ( _nDiv =  0 ) .Or.;
      ( _nDiv = 10 ) .Or.;
      ( _nDiv = 11 )
      
      _nDiv := 1

   End
   
   If Substr( _cRet, 1, 2 ) $ '85'  // Concessionárias e Tributos

      _cRet += Substr( _cRet, 5, 7 )
      _cRet += StrZero( _nDiv, 1, 0 )   // Digito Verificador 
      _cRet += Substr( _cRet, 12, 11 )
         // Incluir Digito
      _cRet += Substr( _cRet, 23, 11 )

         // Incluir Digito
      _cRet += Substr( _cRet, 34, 11 )   

    Else
   
      _cRet += StrZero( _nDiv, 1, 0 )   // Digito Verificador 
      _cRet += Substr( _cParm,  6, 4 )  // Fator de Vencimento
      _cRet += StrZero( Val( Subst( _cParm, 10,10 ) ), 15, 0 ) // Valor
      _cRet += Substr( _cParm, 20,25 ) // Campo Livre

   End

Else

  _cRet := Space( 49 )

End


Return( _cRet )