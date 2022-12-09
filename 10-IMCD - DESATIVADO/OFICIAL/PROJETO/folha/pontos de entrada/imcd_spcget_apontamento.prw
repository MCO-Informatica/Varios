#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Fun��o	 � IMCD_SPCGET	� Autor� Totvs (SK)	        � Data � 19/08/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retonar o campo disponivel para get (Lan�amento Ponto)	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � U_IMCD_SPCGET()											  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � X3_WHEN dos campos PC_PDI e PC_ABONO                        ��
��������������������������������������������������������������������������ٱ�
�� Eventos do ponto que n�o poder�o sofrer manuten��o (PC_PDI e PC_ABONO   ��
�� C�d.          - Descri��o											   ��
�� 437 - *** HRS NAO TRABALHADAS										   ��
�� 101 - *** HORAS TRABALHADAS                                             ��
�� 																		   ��
�� 438 - **HRS NOTURN.NAO TRAB                                             ��
�� 107 - *** HORAS NOTURNAS TRAB.                                          ��
�� Para eventos 001/101/002/005 nao permitir get nos campos PC_PDI/PC_ABONO��
�����������������������������������������������������������������������������
*/
User Function IMCD_SPCGET()

	Local lRet 		:= .T.
	Local cVar		:= ReadVar()
	Local cAlias	:= "SPC"  
	Local cPrefix	:= ( PrefixoCpo( cAlias ) + "_" )

	//-- Numericos -- Posicionamento dos campos em aHeader
	Local nPosPD	:= GdFieldPos( cPrefix + "PD" 		)

	IF aCols[n, nPosPD] $ "101/107/437/438" // EVENTOS QUE O CAMPO NAO PODE TER GET

		If cVar == ("M->" + cPrefix + "PDI") .OR. cVar == ("M->" + cPrefix + "ABONO") 
			lRet 		:= .F.
		ENDIF

	ENDIF

RETURN(LRET)
