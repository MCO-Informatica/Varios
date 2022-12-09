Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
USER FUNCTION RateioDsp( _idTitulo )

_cRat := 'SELECT'
_cRat += ' ISNULL( RATEIO.ID_TITULO, 0 ) idTitulo,'
_cRat += ' ISNULL( RATEIO.ID_OPERACIONAL, 0 ) idOperacional, '
_cRat += " ISNULL( NATUREZA, 'S/C G') EV_NATUREZ,"
_cRat += ' ISNULL( RATEIO.VALOR, 0 ) EV_VALOR, '
_cRat += ' ISNULL( INDICE, 0 ) Indice,'
_cRat += ' SUM( VCTTIT.VALOR ) TotTit,'
_cRat += ' ROUND( ISNULL( RATEIO.VALOR, 0 ) / SUM( VCTTIT.VALOR ), 4) EV_PERC'
_cRat += 'FROM ['+cBDGSTQ+'].[dbo].[RATEIO_OPERACIONAL] RATEIO '
_cRat += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OPER ON OPER.ID_OPERACIONAL = RATEIO.ID_OPERACIONAL '
_cRat += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[VENCTITULO] VCTTIT ON VCTTIT.ID_TITULO = RATEIO.ID_TITULO '
_cRat += 'WHERE RATEIO.ID_TITULO = ' + idTitulo + ' '
_cRat += 'GROUP BY'
_cRat += ' ISNULL( RATEIO.ID_TITULO, 0 ),'
_cRat += ' ISNULL( RATEIO.ID_OPERACIONAL, 0 ),'
_cRat += " ISNULL( NATUREZA, 'S/C G'),"
_cRat += ' ISNULL( RATEIO.VALOR, 0 ),'
_cRat += ' ISNULL( INDICE, 0 )'

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cRat),"RAT",.T.,.T.)

_cNaturez := RAT->EV_NATUREZ
_nMultNat := 0

While ! ( RAT->( Eof() ) )

   If RAT->EV_PERC < 1

      If ! ( SEV->( dbSeek( SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+RAT->EV_NATUREZ, .F. ) ) )

         RecLock( 'SEV', .T. )
         SEV->EV_FILIAL  := SE1->E2_FILIAL
         SEV->EV_PREFIXO := SE1->E2_PREFIXO
         SEV->EV_NUM     := SE1->E2_NUM
         SEV->EV_PARCELA := SE1->E2_PARCELA
         SEV->EV_CLIFOR  := SE1->E2_CLIENTE
         SEV->EV_LOJA    := SE1->E2_LOJA
         SEV->EV_TIPO    := SE1->E2_TIPO
         SEV->EV_NATUREZ := RAT->EV_NATUREZ
         SEV->EV_RECPAG  := 'P'
         SEV->EV_IDENT   := '1'
   
      Else

         RecLock( 'SEV', .F. )

      End

      SEV->EV_VALOR   := NAT->EV_VALOR
      SEV->EV_PERC    := NAT->EV_PERC
      SEV->( MsUnLock() )
      _nMultNat ++
      
   End
   
   NAT->( dbSkip() )

End

If _nMultNat > 1
 
   _cMultNat := '1'

Else

   _cMultNat := '2'

End

RAT->( dbCloseArea() )

Return( NIL )
