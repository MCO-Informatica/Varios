
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fa080pe  �Autor  � S�rgio Santana     � Data � 22/01/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta rotina tem por objectivo realizar as baixas dos titu- ���
���Desc.     � los no GESTOQ (Contas a Pagar)                             ���
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Glastech                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA080PE()

LOCAL _cOrigem := 0 

If ProcName( 4 ) = 'FINA080'

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

	_nResult := TCSPExec("f300SE5",;
	                     Val( SE2->E2_IDMOV ),;
	                     SA6->A6_IDCONTA     ,;
	                     _cDta               ,;
	                     Val( cCheque )      ,;
	                     rTrim( SE2->E2_NUM ) + '/' +SE2->E2_PARCELA + ' ' +rTrim( SE2->E2_NOMFOR ),;
	                     nJuros  ,;
	                     nValPgto,;
	                     _cMvt   ,;
	                     'P',;
	                     'FA080PE',;
	                     SE2->E2_ORIGBD;
	                    )
       
    If ValType( _nResult ) <> 'U'

       If _nResult[1] <> 0 
       
           RecLock( 'SE5', .F. )
           SE5->E5_IDMOVI := Str( _nResult[1], 10, 0 ) 
           SE5->E5_MSEXP  := DTOS(DATE())
//           SE5->( dbUnLock() )
           SE5->( MsUnlock() )

       EndIf
       
    Else
    
       MsgInfo('N�o conformidade ao baixar o Titulo ' + rTrim( SE2->E2_NUM ) + '/' +SE2->E2_PARCELA + ' ' +rTrim( SE2->E2_NOMFOR ) + '.', 'Rotina FA080PE' )

	EndIf

EndIf

Return( NIL )