/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SACI008  ºAutor  ³ Sérgio Santana     º Data ³ 10/02/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada tem por finalidade realizar a baixa  º±±
±±º          ³ do titulo junto ao sistema GESTOQ, parametro referenciando º±±
±±º          ³ titulo E1_IDBOLET, Multa, Juros, Desconto e Total Recebido º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SACI008()

LOCAL _cData := ''
LOCAL _cDta  := ''
		    
_cData := DtoS( dBaixa )
_cDta  := Substr( _cData, 1, 4 ) 
_cDta  += '-'
_cDta  += Substr( _cData, 5, 2 )
_cDta  += '-'
_cDta  += Substr( _cData, 7, 2 )
    	
_aResult := TCSPExec( "f300SE5",;
	                  SE1->E1_IDBOLET,;
	                  SA6->A6_IDCONTA,;
	                  _cDta,;
	                  nDescont,;
	                  rTrim( SE1->E1_NUM ) + '/' +SE1->E1_PARCELA + ' ' +rTrim( SE1->E1_NOMCLI ),;
	                  (nJuros+nMulta),;
	                  nValRec,;
	                  _cDta, ;
	                  'R', ;
	                  'SACI008',;
	                  SE1->E1_ORIGBD,;
	                  0;
                    )
       
If ValType( _aResult ) = 'A'

   RecLock( 'SE5', .F. )
   SE5->E5_IDMOVI := Str( _aResult[1], 10, 0 )
   SE5->E5_MSEXP  := DTOS(DATE())
   SE5->( MSUnLock() )

Else
       
   MsgInfo('Não conformidade ao baixar o Titulo ' + rTrim( SE1->E1_NUM ) + '/' +SE1->E1_PARCELA + ' ' +rTrim( SE1->E1_NOMCLI ) + '.', 'Rotina SACI008' )

EndIf

Return( NIL )