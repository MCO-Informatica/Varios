User Function MT110GET()
local i := 0
         
lCopia := If( ValType( lCopia ) = 'L', lCopia, .F. )

If lCopia

   _nPosDtP := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_DATPRF'})
   _nPosLT  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_LAMTEMP'})
   _nPosCta := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_CONTA'})   
   _nPosCC  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_CC'}) 
   _nPosFor := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_FORNECE'})
   _nPosLoj := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_LOJA'})   
   _nPosLoc := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_LOCAL'})   
   _nPosRat := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_RATEIO'})   

   _nLen := Len( aCols )
   
   For i := 1 To _nLen
   
      aCols[ i ][ _nPosDtP ] := dDataBase
      aCols[ i ][ _nPosLT  ] := ' '
      aCols[ i ][ _nPosCta ] := Space( Len( aCols[ i ][ _nPosCta ] ) )
      aCols[ i ][ _nPosCC  ] := Space( Len( aCols[ i ][ _nPosCC  ] ) )
      aCols[ i ][ _nPosFor ] := Space( 6 )
      aCols[ i ][ _nPosLoj ] := Space( 2 )
      aCols[ i ][ _nPosLoc ] := '01'
      aCols[ i ][ _nPosRat ] := '2'
   
   Next   

Else

   _nLen    := Len( aCols )
   _nPosCmp := aScan(aHeader,{|x| AllTrim(x[2]) = 'C1_CODCOMP'})   

   For i := 1 To _nLen
   
      If aCols[ i ][ _nPosCmp ] <> cCodCompr
      
         cCodCompr := '   '

      End
   
   Next   

End

Return( nil )