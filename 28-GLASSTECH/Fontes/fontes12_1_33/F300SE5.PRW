#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F300SE5   ºAutor  ³Sérgio Santana      º Data ³  21/08/2016 º±±
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
User Function F300SE5()

    Local _cData := ''
    Local _cDta  := ''
    
    RecLock( 'SE5', .F. )
    SE5->E5_FILIAL  := SA6->A6_ZFILORI
    If( SE5->E5_RECPAG = 'P' )
      SE5->E5_FILORIG := SE2->E2_FILIAL
    Else
      SE5->E5_FILORIG := SE1->E1_FILIAL
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
	                     Val( SE2->E2_IDMOV )  ,;
	                     SA6->A6_IDCONTA       ,;
	                     _cDta                 ,;
	                     Val( SE5->E5_NUMCHEQ ),;
	                     rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ),;
	                     SE5->E5_VLJUROS       ,;
	                     SE5->E5_VALOR         ,;
	                     _cMvt                 ,;
	                     'P'				   ,;
	                     SE5->E5_ARQCNAB       ,;
	                     SE2->E2_ORIGBD         ;
	                    )
   
    If ValType( _nResult ) = 'A'
       
       SE5->E5_IDMOVI := Str( _nResult[1], 10, 0 )
       SE5->E5_MSEXP  := DTOS(DATE())
       
    Else
    
       MsgInfo('Não conformidade ao baixar o Titulo ' + rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ) + '.', 'Rotina f300SE5' )

	EndIf

    If Type( '_oHtml' ) = 'O'
       
       _oHtml:aListTables[ 1 ][  9 ][ 2 ][ _nLenList ] := TRANSFORM( SE2->E2_SALDO  ,'@E 99,999,999.99' )
       _oHtml:aListTables[ 1 ][ 11 ][ 2 ][ _nLenList ] := iif( _nResult[1] = 0, ' ', Alltrim( Str( _nResult[1], 10, 0 ) ) )

       If Val( SE5->E5_IDMOVI ) <> 0

		  _nValPagto += SE5->E5_VALOR

       EndIf

    EndIf

	If ( Substr( xBuffer, 9, 5 ) = '00001' ) .And.;
	   ( TRB->TOTAL <> SE2->E2_VALLIQ )      .And.;
	   ( SE5->E5_RECPAG = 'P' )
   
	   _aArea   := GetArea()
	   _cFILMOV := TRB->FILMOV
	   _dData   := TRB->DATAD
	   _cNatur  := TRB->NATURE
	   _cMoeda  := TRB->MOEDA
	   _nTotal  := TRB->TOTAL - SE2->E2_VALLIQ
	
	   RecLock( 'TRB', .F. )
	   TRB->TOTAL := SE2->E2_VALLIQ
	   TRB->( MSUnLock() )
	   _nRecNo := TRB->( RecNo() )
	
	   RecLock( 'TRB', .T. )
	   TRB->FILMOV := SA6->A6_ZFILORI
	   TRB->DATAD  := _dData
	   TRB->NATURE := _cNatur
	   TRB->MOEDA  := _cMoeda
	   TRB->TOTAL  := _nTotal
	   TRB->( MSUnLock() )
	   TRB->( dbGoTo( _nRecNo  ) )
	   RestArea( _aArea )

	EndIf

Return()