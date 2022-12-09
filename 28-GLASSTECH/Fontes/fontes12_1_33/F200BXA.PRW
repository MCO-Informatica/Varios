#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200TIT   ºAutor  ³Sérgio Santana      º Data ³  20/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina verifica o código do banco, se por ventura o usuárioº±±
±±º          ³ selecionar uma empresa/filial, onde não pertence ao banco  º±±
±±º          ³ troca a empresa automaticamente.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glastech                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F200BXA()

    Local _cData := ''
    Local _cDta  := ''
    
    RecLock( 'SE5', .F. )

	If SE5->E5_BANCO = '053'

       SE5->E5_FILIAL := '0201'
	
    ElseIf SE5->E5_BANCO = '078'

       SE5->E5_FILIAL := '0501'

    ElseIf SE5->E5_BANCO = '101'

       SE5->E5_FILIAL := '9001'
	
    ElseIf SE5->E5_BANCO = '014'

       SE5->E5_FILIAL := '0101'
	
    ElseIf SE5->E5_BANCO = '068'

       SE5->E5_FILIAL := '0401'

    ElseIf SE5->E5_BANCO = '084'

       SE5->E5_FILIAL := '0201'

    Else

       MsgInfo('Banco não configurado para gerar movimentação financeira.','F300SE5')

    EndIf
    
    SE5->E5_ARQCNAB	:=	Upper( rTrim( Substr( mv_par04, rAt( '\', mv_par04 ) + 1 ) ) )
    
    _cData := DtoS( SE5->E5_DATA )
    _cDta  := Substr( _cData, 1, 4 ) 
    _cDta  += '-'
    _cDta  += Substr( _cData, 5, 2 )
    _cDta  += '-'
    _cDta  += Substr( _cData, 7, 2 )
    
    _cData := DtoS( SE5->E5_DTDIGIT )
    _cMvt  := Substr( _cData, 1, 4 ) 
    _cMvt  += '-'
    _cMvt  += Substr( _cData, 5, 2 )
    _cMvt  += '-'
    _cMvt  += Substr( _cData, 7, 2 )  
    
    //  Titulo com tipo "FT" verificar composição e baixar automaticamento no gestoq
	_nResult := TCSPExec("f300SE5",;
	                     Val( SE1->E1_IDBOLET ),;
	                     Val( SE5->E5_BANCO ),;
	                     _cDta,;
	                     Val( SE5->E5_NUMCHEQ ),;
	                     rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ),;
	                     SE5->E5_VLJUROS,;
	                     SE5->E5_VALOR  ,;
	                     _cMvt ,;
	                     SE1->E1_ORIGBD ;
	                    )
       
    If _nResult[1] <> 0
       
       SE5->E5_IDMOVI := Str( _nResult[1], 10, 0 )
       
    Else
    
       MsgInfo('Não conformidade ao baixar o Titulo ' + rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ) + '.', 'Rotina FINA200' )

	EndIf
    
    SE5->E5_MSEXP := DTOS(DATE())
    SE5->( MSUnLock() )

Return()