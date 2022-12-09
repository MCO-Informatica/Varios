/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA050B01 ºAutor  ³ Sérgio Santana     º Data ³  22/01/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada é utilizado para excluir os titulos  º±±
±±º          ³ gerados via interagração no sistema GESTOQ, parametro pas- º±±
±±º          ³ sado E2_IDMOV que refere-se ao ID_TITULO.                  º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glasstech                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA050B01()

LOCAL _nRecNo  := SE2->( RecNo() )
LOCAL _aResult := {}
LOCAL _cFornec := SE2->E2_FORNECE
LOCAL _cNumero := SE2->E2_NUM
LOCAL _cTipo   := SE2->E2_TIPO
LOCAL _cFilial := SE2->E2_FILIAL
LOCAL _nIdx    := SE2->( IndexOrd() )
LOCAL _cTitPai := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA

_cTitPai += Space( Len( SE2->E2_TITPAI ) - Len( _cTitPai ) )

While ( _cFornec = SE2->E2_FORNECE ) .And.;
      ( _cNumero = SE2->E2_NUM )     .And.;
      ( _cTipo   = SE2->E2_TIPO )    .And.;
      ( _cFilial = SE2->E2_FILIAL )  .And.;
      ( ! Empty( SE2->E2_IDMOV ) )   .And.;
      ( ! SE2->( Eof() ) )

   _aResult := TCSPExec( "ExcCPgGSTQ", Val( SE2->E2_IDMOV ), SE2->E2_ORIGBD )

   SE2->( dbSkip() )
EndDo

_nIdx := SE2->( IndexOrd() )
SE2->( dbSetOrder( 17 ) )

SE2->( dbSeek( _cFilial + _cTitPai, .F. ) )

While ( _cFilial = SE2->E2_FILIAL ) .And.;
      ( _cTitPai = SE2->E2_TITPAI ) .And.;
      ( ! SE2->( Eof() ) )
                          
   _aResult := TCSPExec( "ExcCPgGSTQ", Val( SE2->E2_IDMOV ), SE2->E2_ORIGBD )

   SE2->( dbSkip() )
EndDo

SE2->( dbSetOrder( _nIdx ) )
SE2->( dbGoTo( _nRecNo ) )

Return( NIL )