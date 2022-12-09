
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT100GE2 �Autor  � S�rgio Santana     � Data �  20/04/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclus�o dos titulos referente ao contas a pagar base de   ���
���          � GESTOQ a partir da inclus�o da nota fiscal de entrada      ���
�������������������������������������������������������������������������͹��
���Uso       � Glastech                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100GE2()

	LOCAL _aGetArea := GetArea()

    If Len( ParamIxb[ 3 ] ) > 0

       If ! Empty( SE2->E2_TITPAI )

          SE2->( dbSetOrder( 1 ) )    
          SE2->( dbSeek( xFilial( 'SE2' ) + rTrim( SE2->E2_TITPAI ), .F. ) )
                                                                         
       EndIf
	
	   U_FA050FIN( 'MATA103' ) // Chama ponto de entrada Contas a Pagar
	
	   RestArea( _aGetArea )

	EndIf
	
Return( NIL )