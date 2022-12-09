
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fa080OWN �Autor  �S�rgio Santana      � Data � 27/12/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada que tem a finalidade de validar o cancela ���
���          � mento da baixa, ser� permitida a baixa para titulos com o  ���
���          � motivo de baixa diferente de DEB via SISAPG.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Glasstech                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function fa080OWN()
                        
LOCAL _lRet := .T.

If SE5->E5_MOTBX = 'DEB' .And.;
  ! Empty( SE5->(E5_ARQCNAB)) .And. ! Empty( SE5->(E5_IDMOVI) )

  MsgInfo('Exclus�o/Cancelamento da baixa do t�tulo n�o permitido, baixa realizada via SISPAG!','SISPAG')
  _lRet := .F. // Caso motivo de baixa for igual a 'DEB', IDMOVI identificador movimento GESTOQ (Baixa_Parcial) 
               // diferente de branco e arquivo CNAB diferente de branco n�o permite o cancelamento.
  
EndIf  

Return( _lRet )