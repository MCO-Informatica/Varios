#Include 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M461SER   �Autor  �Sergio Santana      � Data �  07/09/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta rotina tem a finalidade de sincronizar a numera��o da ���
���          � da nota fiscal empresa FFM com GESTOQ                      ���
�������������������������������������������������������������������������͹��
���Uso       � GlassTech                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M461SER()

	Local cTpNrNfs   := SuperGetMV("MV_TPNRNFS")

	cNumero := NxtSX5Nota( cSerie,.T.,cTpNrNfs)
	
	If cFilAnt = '0701' .And. TCSPExist('GetNFFFM') //Incluido tratamento para verificar a existencia da procedure - Montes - 08/05/2019

       /*[]----------------------------------------------------------------------------------------------------[]
                        Obtem o n�mero da nota fiscal empresa FFM, liberando o proximo n�mero
         []----------------------------------------------------------------------------------------------------[]*/

    	_aResult := TCSPExec( 'GetNFFFM' ) 
    	cNumero  := StrZero( _aResult[1], 9, 0 )

	EndIf

Return( NIL )