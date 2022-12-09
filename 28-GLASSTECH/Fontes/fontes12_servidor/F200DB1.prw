
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F200DB1  �Autor  � S�rgio Santana     � Data � 24/07/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada tem finalidade de realizar altera��o da   ���
���          � conta corrente para lan�amentos de despesas contas descon- ���
���          � to, de acordo com a conta destino cadastro de banco        ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Glasstech                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function F200DB1()

If ! Empty( SA6->A6_CTADESP )

   RecLock( 'SE5', .F. )
   SE5->E5_AGENCIA := SA6->A6_AGEDESP
   SE5->E5_CONTA   := SA6->A6_CTADESP
   SE5->( dbUnLock() )

   RecLock( 'FK5', .F. )
   FK5->FK5_AGENCI := SA6->A6_AGEDESP
   FK5->FK5_CONTA  := SA6->A6_CTADESP
   FK5->( dbUnLock() )

End


Return( NIL )