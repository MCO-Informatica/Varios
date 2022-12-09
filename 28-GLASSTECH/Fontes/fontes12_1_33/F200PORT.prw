#INCLUDE "TOTVS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200PORT  �Autor  � S�rgio Santana     � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta rotina tem por finalidade pesquisar e posicionar o    ���
���          � banco durante a realiza��o das baixas                      ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Glasstech                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F200PORT()

	Local _lRet   := .F.

	//Retornos de Fidc n�o s�o validados neste PE.
	If (Type("lFIDC") <> "U" .AND. lFIDC) .OR. (Type("lFIDC") == "U" .AND. MsgYesNo("Arquivo de retorno se refere a uma FIDC?","FDIC"))
		If Type("lFDVldVl") == "U"
			Public lFDVldVl	:= MsgYesNo("Deseja validar valores para esta FIDC?","FDIC")
		EndIf
		
		Public lFIDC 	:= .T.
		Return .T.
	EndIf

	If ! ( File( MV_PAR04 ) )

		Help(" ",1,"NOARQPAR")
    
	Else

		_nHdl := fOpen(  MV_PAR04, 0 )
		fSeek( _nHdl, 0, 0 )
	
		_cBuffer := Space(85)
		fRead( _nHdl, @_cBuffer, 85 )	
	    fClose( _nHdl )

     	_cBco := Substr( _cBuffer, 77, 3 )
		_cAge   := StrZero( Val( Substr( _cBuffer, 27, 4 ) ), 4, 0 ) + ' '
		
	    If _cBco = '341'

           _cConta := StrZero( Val( Substr( _cBuffer, 31, 7 ) ), 5, 0 ) + Space( 5 )

	    ElseIf _cBco = '237'

   		   _cConta := StrZero( Val( Substr( _cBuffer, 39, 7 ) ), 5, 0 ) + Space( 5 )

	    End
	    
	    SEE->( dbSeek( xFilial( 'SEE' ) + _cBco + _cAge + _cConta, .T. ) )
	    
	    If (SEE->EE_CODIGO  = _cBco ) .And.;
	       (SEE->EE_AGENCIA = _cAge ) .And.;
	       (SEE->EE_CONTA   = _cConta)

	       If Empty( SEE->EE_CODOFI )

	          _cAge   := SEE->EE_AGENCIA
	          _cConta := SEE->EE_CONTA
	          _lRet   := .T.

           Else	       
	       
			  _cAge   := SEE->EE_AGEOFI 
			  _cConta := SEE->EE_CTAOFI
              SEE->( dbSeek( xFilial( 'SEE' ) + _cBco + _cAge + _cConta, .T. ) )

			  If (SEE->EE_CODIGO  = _cBco) .And.;
			     (SEE->EE_AGENCIA = _cAge) .And.;
			     (SEE->EE_CONTA   = _cConta)
			     
			     _lRet := .T.

              Else

				 _cBco := '   '
				 MsgInfo( 'Conta Corrente n�o configurada!', 'f200Port' )

			  End

           End

		Else

	       MsgInfo( 'Banco n�o configurado para a realiza��o das baixa', 'Aviso f200Port' )
	
        End

    End
    
Return( _lRet )
