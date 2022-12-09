#INCLUDE "PROTHEUS.CH"        

User Function BoletoItau()

LOCAL _cBco := '   '
LOCAL _cAge := '     '
LOCAL _cCta := '          '

If Substr( SE1->E1_FILIAL, 1, 2 ) = '02'

   _cBco := '341'
   _cAge := '0046 '
   _cCta := '88999     '

ElseIf Substr( SE1->E1_FILIAL, 1, 2 ) = '07'

   _cBco := '341'
   _cAge := '7646 '
   _cCta := '12641     '

ElseIf Substr( SE1->E1_FILIAL, 1, 2 ) = '90'

   _cBco := '341'
   _cAge := '0554 '
   _cCta := '55375     '

End

_nSE1 := SE1->( RecNo() )
_nSEE := SEE->( RecNo() )
SEE->( dbSeek( xFilial( 'SEE' ) + _cBco + _cAge + _cCta + '1  ', .F. ) )

_nSA1 := SA1->( RecNo() )

__cFileLog := 'C:\Itau\Cobranca\Remessa\'
__cFileLog += iif( SE1->E1_FILIAL <> '9001', 'C', 'B')
__cFileLog += Alltrim( StrZero( Val( iif( Empty(SE1->E1_NUMBOR), SE1->E1_NUM, SE1->E1_NUMBOR )), 6, 0 ) )
__cFileLog += Alltrim( iif( Empty(SE1->E1_NUMBOR), SE1->E1_PARCELA, '' ) )
__cFileLog += '.txt'

_nHdl2 := MSFCreate( __cFileLog,0 )

FSeek( _nHdl2,0,2 )

_cTxt := '0'
_cTxt += '1'
_cTxt += 'REMESSA'
_cTxt += '01'
_cTxt += 'COBRANCA       '
_cTxt += STRZERO(VAL(SUBS(SEE->EE_AGENCIA,1,4)),4)
_cTxt += '00'
_cTxt += STRZERO(VAL(SUBS(SEE->EE_CONTA,1,LEN(SEE->EE_CONTA)-2)),5)
_cTxt += SEE->EE_DVCTA
_cTxt += '        '
_cTxt += SUBSTR(SM0->M0_NOMECOM,1,30)
_cTxt += '341'
_cTxt += 'BANCO ITAU S.A.'                                             
_cTxt += GRAVADATA(DDATABASE,.F.)
_cTxt += Space(294)
_cTxt += '000001'                                                    

FWrite( _nHdl2,_cTxt + Chr(13) + Chr(10) )

_nLin     := 2
_cNumBor  := SE1->E1_NUMBOR
_cFilSA1  := xFilial( 'SA1' )
_aGetArea := SE1->( GetArea() )

_cOldFlt := SE1->( dbFilter() )
_cFltSE1 := "@ (E1_NUMBOR = '" + _cNumBor + "') AND (D_E_L_E_T_ <> '*')"
SE1->( dbSetFilter( {|| &_cFltSE1 }, _cFltSE1 ) )
SE1->( dbGoTop() )

While _cNumBor = SE1->E1_NUMBOR

   GravTit()
   SE1->( dbSkip() )

End
	
_cTxt := '9'
_cTxt += Space( 393 )
_cTxt += StrZero( _nLin, 6, 0 )

FWrite( _nHdl2,_cTxt + Chr(13) + Chr(10) )
fClose( _nHdl2 )

SE1->( dbClearFilter() )

SE1->( dbGoTo( _nSE1 ) )
SEE->( dbGoTo( _nSEE ) )
SA1->( dbGoTo( _nSA1 ) )
RestArea( _aGetArea )

Return( NIL )

Static Function GravTit()

	SA1->( dbSeek( _cFIlSA1 + SE1->E1_CLIENTE + SE1->E1_LOJA, .F. ) )
	_cTxt := '1'
	_cTxt += '02'
	_cTxt += SUBSTR(SM0->M0_CGC,1,14)
	_cTxt += STRZERO(VAL(SUBS(SEE->EE_AGENCIA,1,4)),4)
	_cTxt += '00'
	_cTxt += STRZERO(VAL(SUBS(SEE->EE_CONTA,1,LEN(SEE->EE_CONTA)-2)),5)
	_cTxt += SEE->EE_DVCTA
	_cTxt += '    '
	_cTxt += replicate('0',4)
	_cTxt += If( SE1->E1_IDBOLET = 0, SE1->E1_IDCNAB, Str( SE1->E1_IDBOLET, 6, 0 ) + Space( 4 ) ) + Space( 15 )
	_cNro := StrZero( Val( SE1->E1_NUMBCO ), 8, 0 )

	_cTxt += _cNro
	_cTxt += replicate('0',13)

	_cTxt += '109'
	_cTxt += Space(21)
	_cTxt += 'I'
	_cTxt += '01'
	_cTxt += AllTrim(iif( SE1->E1_FILIAL <> '9001', SE1->E1_NUM, '10' + Substr( SE1->E1_NUM, 3 )))+SE1->E1_PARCELA
	_cTxt += GravaData(SE1->E1_VENCTO,.F.)   //121 126
	_cTxt += STRZERO(SE1->(E1_SALDO-E1_COFINS-E1_PIS)*100,13)            //127 139
	_cTxt += '341'
	_cTxt += replicate('0',5)
	_cTxt += '01'
	_cTxt += 'N'                                                         
	_cTxt += GravaData(SE1->E1_EMISSAO,.F.)                              
	_cTxt += '94'                                                        
	_cTxt += '00'                                                        
	_cTxt += STRZERO(((SE1->(E1_VALOR-E1_COFINS-E1_PIS)*0.03)/30)*100,13)     //161173
	_cTxt += '000000'
	_cTxt += REPLICATE('0',13)
	_cTxt += REPLICATE('0',13)
	_cTxt += REPLICATE('0',13)
	_cTxt += IF(LEN(ALLTRIM(SA1->A1_CGC))==11,'01','02')
	_cTxt += STRZERO(VAL(SA1->A1_CGC),14)
	_cTxt += SubStr(SA1->A1_NOME,1,30)
	_cTxt += Space(10)
	_cTxt += SubStr(SA1->A1_END,1,40)
	_cTxt += Substr(SA1->A1_BAIRRO,1,12)
	_cTxt += SubStr(SA1->A1_CEP,1,8)
	_cTxt += Substr(SA1->A1_MUN,1,15)
	_cTxt += SA1->A1_EST
	_cTxt += Space( 34 )
	_cTxt += '000000'
	_cTxt += '00'
	_cTxt += ' '
	_cTxt += StrZero( _nLin, 6, 0 )
	
	_nLin ++
	FWrite( _nHdl2,_cTxt + Chr(13) + Chr(10) )
	
	_cTxt := '2'
	_cTxt += '1'
	_cTxt += GravaData( SE1->E1_VENCTO, .F., 5 ) 
	_cTxt += STRZERO((SE1->(E1_VALOR-E1_COFINS-E1_PIS)*.02)*100,13)
	_cTxt += Space( 371 )
	_cTxt += StrZero( _nLin, 6, 0 )
	
	_nLin ++
	FWrite( _nHdl2,_cTxt + Chr(13) + Chr(10) )

Return( NIL )