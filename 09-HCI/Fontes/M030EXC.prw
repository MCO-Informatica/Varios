
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M030EXC   �Autor  �Rogerio Nagy        � Data �  08/03/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exclui Amarracoes Socios x CLientes e Documentos x Clientes���
���          � se existirem, no momento da exclusao do cliente            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M030EXC()

//��������������������������������������������������������������Ŀ
//� Exclui a amarracao Socios x Clientes                         �
//����������������������������������������������������������������
SZ2->(DbSetOrder(1)) // Z2_FILIAL+Z2_XCLIENT+Z2_XLOJA+Z2_XCPF
      
If SZ2->(DbSeek(xFilial("SZ2") + SA1->A1_COD + SA1->A1_LOJA))
	While ! SZ2->(Eof()) .and. SZ2->Z2_FILIAL == xFilial("SZ2") .and. ;
		SZ2->Z2_XCLIENT == SA1->A1_COD .and. ;
		SZ2->Z2_XLOJA   == SA1->A1_LOJA
		Reclock("SZ2",.f.)
		dbDelete()
		MsUnlock()
		SZ2->(DbSkip())
	Enddo
Endif

//��������������������������������������������������������������Ŀ
//� Exclui a amarracao Documentos x Clientes                     �
//����������������������������������������������������������������
		
SZ4->(DbSetOrder(1)) // Z4_FILIAL+Z4_XCLIENT+Z4_XLOJA+Z4_XCODIGO
      
If SZ4->(DbSeek(xFilial("SZ4") + SA1->A1_COD + SA1->A1_LOJA))
	While ! SZ4->(Eof()) .and. SZ4->Z4_FILIAL == xFilial("SZ4") .and. ;
		SZ4->Z4_XCLIENT == SA1->A1_COD .and. ;
		SZ4->Z4_XLOJA   == SA1->A1_LOJA
		Reclock("SZ4",.f.)
		dbDelete()
		MsUnlock()
		SZ4->(DbSkip())
	Enddo
Endif

Return .T.