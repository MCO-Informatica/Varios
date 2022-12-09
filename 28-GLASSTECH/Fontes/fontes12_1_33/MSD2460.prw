
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSD2460   �Autor  � S�rgio Santana     � Data �  25/08/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Finalidade atualizar a descri��o do produto constando no  ���
���          �  pedido referenciando a descri��o na nota fiscal           ���
�������������������������������������������������������������������������͹��
���Uso       � Glasstech                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MSD2460()

	SD2->D2_DESCR := SC6->C6_DESCRI  /*[] Atualiza descri��o do produdo no pedido de venda para item nota fiscal []*/

    /*[] Embalagem em branco, carrega sugest�o para "Pe�as" somando os itens utilizando a 1a unid. medida  []*/	
	If (Empty( SF2->F2_ESPECI1 )) .Or.;
       (Substr( SF2->F2_ESPECI1, 1, 7 ) = 'PECA(S)')
       
       SF2->F2_ESPECI1 := 'PECA(S)'
       SF2->F2_VOLUME1 += SD2->D2_QUANT
       
    End

Return( NIL )