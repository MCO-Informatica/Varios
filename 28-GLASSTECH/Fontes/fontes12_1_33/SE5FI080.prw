#Include 'protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SE5FI080 �Autor  � S�rgio Santana     � Data � 22/01/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta rotina tem por objectivo realizar as baixas dos titu- ���
���Desc.     � los no GESTOQ                                              ���
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Glastech                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SE5FI080()

LOCAL _cOrigem := 0
LOCAL _nResult := {}
Local cCamposE5 := Iif(GetRPORelease() > "12.1.016", PARAMIXB[1], PARAMIXB)

If ProcName( 5 ) = 'FINA080'
    _cData := DtoS( dBaixa )
    _cDta  := Substr( _cData, 1, 4 ) 
    _cDta  += '-'
    _cDta  += Substr( _cData, 5, 2 )
    _cDta  += '-'
    _cDta  += Substr( _cData, 7, 2 )
    
    _cData := DtoS( dDatabase )
    _cMvt  := Substr( _cData, 1, 4 ) 
    _cMvt  += '-'
    _cMvt  += Substr( _cData, 5, 2 )
    _cMvt  += '-'
    _cMvt  += Substr( _cData, 7, 2 )  

//  Titulo com tipo "FT" verificar composi��o e baixar automaticamento no gestoq      

	DBSelectArea('SA6')
	SA6->(DBSetOrder(1))
	SA6->(DBSeek(xFilial('SA6') + CBANCO + CAGENCIA + CCONTA))

	_nResult := TCSPExec("f300SE5",;
	                     Val( SE2->E2_IDMOV ),;
						 cValToChar(SA6->A6_IDCONTA),;
	                     _cDta,;
	                     Val( cCheque ),;
	                     rTrim( SE2->E2_NUM ) + '/' +SE2->E2_PARCELA + ' ' +rTrim( SE2->E2_NOMFOR ),;
	                     nJuros  ,;
	                     nValPgto,;
	                     _cMvt   ,;
	                     'P',;              
	                     'SE5FI080',;
	                     SE2->E2_ORIGBD;
	                    ) 

/*    If _nResult[1] <> 0
       RecLock('SE5',.F.)
       		SE5->E5_IDMOVI := Str( _nResult[1], 10, 0 )
       		SE5->E5_MSEXP  := DTOS(DATE())
       SE5->(MSUnlock())
    Else
    
       MsgInfo('N�o conformidade ao baixar o Titulo ' + rTrim( SE2->E2_NUM ) + '/' +SE2->E2_PARCELA + ' ' +rTrim( SE2->E2_NOMFOR ) + '.', 'Rotina SE5FI080' )

	EndIf
*/
EndIf

Return cCamposE5