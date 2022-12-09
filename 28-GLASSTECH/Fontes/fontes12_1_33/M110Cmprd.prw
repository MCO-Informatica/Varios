
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M110Cmprd �Autor  �S�rgio Santana      � Data �  11/03/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o c�digo do comprador a partir do grupo de compra- ���
���          � dores                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Thermoglass                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function M110Cmprd( _cGrupoCom )


   SAJ->( dbSeek( xFilial( 'SAJ' ) + _cGrupoCom, .T. ) )
   _cCodUser := SAJ->AJ_USER
   _cCodCmprd := '   '   

   If SAJ->AJ_GRCOM = _cGrupoCom

      _nIdxOrd := SY1->( IndexOrd() )  
      SY1->( dbSetOrder( 3 ) )

	  If ( SY1->( dbSeek( xFilial( 'SY1' ) + SAJ->AJ_USER, .F. ) ) )

         _cCodCmprd := SY1->Y1_COD
	  
	  End
	  
	  SY1->( dbSetOrder( _nIdxOrd ) )
   
   End


Return( _cCodCmprd )