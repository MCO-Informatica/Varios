User Function f240CCte( _cParm )

_nIni := At( '{', SE2->E2_HIST )
_nFim := At( '}', SE2->E2_HIST )

If _nIni <> 0 .And.;
   _nFim <> 0

   _nIni ++
   _nFim -= _nIni
   _cMat := Substr( SE2->E2_HIST, _nIni, _nFim )
   _nIni := At( ',', _cMat )
   _aMat := { Substr( _cMat, 1, (_nIni - 1) ),;
              Substr( _cMat, (_nIni + 1), _nFim - _nIni ) ;
            }
   
   _qSRA := "SELECT RA_BCDEPSA, RA_CTDEPSA, RA_CIC, RA_NOME FROM RH_ESOCIAL.dbo.SRA010 WHERE (RA_FILIAL = '" + _aMat[ 1 ]  + "') AND (RA_MAT = '" + _aMat[ 2 ] + "')"
   dbUseArea( .T. ,"TOPCONN",TcGenQry(,,_qSRA),"SRA", .T., .T.)
   
//   SRA->( dbSeek( _aMat[ 1 ] + _aMat[ 2 ], .F. ) )
   
   If _cParm = 'CC'

      _cRet := StrZero( Val( Substr( SRA->RA_BCDEPSA,1,3 ) ), 3, 0 )
      _cRet += '0'
      _cRet += StrZero( Val( SubStr( SRA->RA_BCDEPSA, 4, 4 ) ), 4, 0 )
      _cRet += ' '
      _cRet += StrZero( Val( SubStr( SRA->RA_CTDEPSA, 1, Len( AllTrim( SRA->RA_CTDEPSA ) ) - 1 ) ), 12, 0 )
      _cRet += ' '
      _cRet += SubStr( SRA->RA_CTDEPSA, Len( AllTrim( SRA->RA_CTDEPSA ) ), 1 )

   ElseIf _cParm = 'NM'

      _cRet := PADR( SRA->RA_NOME, 30 )

   Else

      _cRet := StrZero( Val( SRA->RA_CIC ), 14 )

   End
   
   SRA->( dbCloseArea() )

ElseIf _cParm = 'CC'

   _cRet := StrZero( Val( SE2->E2_FORBCO ), 3, 0 )
   _cRet += "0"
   _cRet += StrZero( Val( SE2->E2_FORAGE ), 4, 0 )
   _cRet += " "
   _cRet += StrZero( Val( SE2->E2_FORCTA ), 12, 0 )
   _cRet += " "
   _cRet += SE2->E2_FCTADV        

ElseIf _cParm = 'NM'

   _cRet := PADR( SA2->A2_NOME, 30 )

Else
  
   _cRet := StrZero( Val( SA2->A2_CGC ), 14 )     

End
                                  
Return( _cRet )
