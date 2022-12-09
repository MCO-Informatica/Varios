/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fa040del �Autor  � S�rgio Santana     � Data �  04/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta rotina tem a finalidade de realizar a exclusao do ti  ���
���          � do contas a receber na base de dados GESTOQ, contempla re  ���
���          � cebimentos antecipados.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Glasstech                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Fa040DEL()

	LOCAL _aResult := {}

	If ( SE1->E1_TIPO = 'RA ' ) .Or. ( SE1->E1_TIPO = 'PRE' )

	   _aResult := TCSPExec('FA040Del', 'A', SE1->E1_FILIAL , SE1->E1_IDBOLET, SE1->E1_ORIGBD )
	   
	   If Type( '_aResult' ) = 'A'

	      If _aResult[1] <> ' '

             MsgInfo('N�o conformidade ao excluir o Titulo ' + rTrim( SE1->E1_NUM ) + '/' +SE1->E1_PARCELA + ' ' + rTrim( SE1->E1_NOMCLI ) + '.' + chr(13) + _aResult[1], 'Rotina fa040del' )

          EndIf
	   
	   EndIf
	
	EndIf

Return( NIL )