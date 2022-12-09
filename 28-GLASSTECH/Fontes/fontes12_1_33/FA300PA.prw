#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA300PA   ºAutor  ³Sérgio Santana      º Data ³  11/02/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina verifica o código do banco, se por ventura o usuárioº±±
±±º          ³ selecionar uma empresa/filial, onde não pertence ao banco  º±±
±±º          ³ troca a empresa automaticamente.                           º±±
±±º          ³ Pagamento Antecipado - Transferencia GESTOQ                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glastech                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA300PA()

  /*  Local _cData := ''
    Local _cDta  := ''*/

    If( SE5->E5_RECPAG = 'P' ) 

      If ( SE5->E5_TABORI$"FK5" )

      
          If FK5->( dbSeek(SE5->E5_FILIAL+SE5->E5_IDORIG),.F.)
          
            FK5->( RecLock( 'FK5', .F. ) )
            FK5->( dbDelete() )
            FK5->( MsUnlock() )

          EndIf

      EndIF

    EndIf
    
    RecLock( 'SE5', .F. )
    
    If( SE5->E5_RECPAG = 'P' )

      SE5->E5_FILIAL   := SE2->E2_FILIAL
      SE5->E5_FILORIG  := SE2->E2_FILIAL //SA6->A6_ZFILORI
      SE5->E5_MOVFKS   := 'N'
      SE5->E5_IDORIG   := ' '
      SE5->E5_TABORI   := ' '

    EndIF

    SE5->E5_ARQCNAB	:=	Upper( rTrim( Substr( mv_par04, rAt( '\', mv_par04 ) + 1 ) ) )
    
    _nResult := TCSPExec("f300SE5Adt"        ,;
	                     SA6->A6_IDCONTA     ,;
	                     Val(SE2->E2_FORNECE),;
	                     SE5->E5_DTDISPO     ,;
	                     SE5->E5_VALOR       ,;
	                     rTrim( SE2->E2_NUM ) + '/' +SE2->E2_PARCELA + ' ' + rTrim( SE2->E2_NOMFOR ),;
	                     cUserName           ,;
	                     SE5->E5_NUMERO + SE5->E5_PARCELA,;
	                     'D'            ,;
	                     SE5->E5_FILORIG,;
	                     'A'            ,;
	                     0              ,;
	                     0			    ,;
				         SE2->E2_ORIGBD;
                        )


    If ValType( _nResult ) = 'A'

       SE5->E5_IDMOVI := Str( _nResult[ 1 ], 10, 0 )
       RecLock( 'SE2', .F. )
       SE2->E2_IDMOV := StrZero(_nResult[ 2 ], 10, 0 )
       SE2->( MsUnlock() )

    EndIf

    SE5->( MsUnlock() )

Return()
