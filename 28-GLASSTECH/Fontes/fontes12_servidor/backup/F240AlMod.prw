
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f240AlMod �Autor  �S�rgio Santana      � Data �  18/08/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Compatibiliza forma de pagamantos referente a tributos     ���
���          � para assumir o registro "O" concessionarias                ���
���          � para assumir o registro "O" concessionarias                ���
�������������������������������������������������������������������������͹��
���Uso       � Glasstech                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F240AlMod() 

	Local _cModelo := Paramixb[1]
	
	                        
	If (_cModelo $ '91;')
	
       If SE2->( MSSeek( SEA->EA_FILORIG+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA, .F. ) )

		  If ! Empty( SE2->E2_CODBAR )

		     _cModelo := '13'

          End

       End

	End

Return( _cModelo ) 