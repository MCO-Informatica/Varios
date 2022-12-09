#INCLUDE "PROTHEUS.CH"
/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                   DBM SYSTEM S/C LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �M520SF3 �Cancelamento de Nota Fiscal - Informa��o do motivo               ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Projeto/PL  �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Solicitante �05.03.08�Vanderleia                                                       ���
�����������������������������������������������������������������������������������������͹��
���Autor       �05.03.08�Almir Bandina                                                    ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �Nil                                                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
User Function TMK150VLD()
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis da rotina                                                           �
//�������������������������������������������������������������������������������������������
Local oDlgExc
Local aAreaAtu	:= GetArea()
Local aButtons	:= {}
Local nOpcA		:= 0
Local cDesMot	:= SPACE(250)

//�����������������������������������������������������������������������������������������Ŀ
//� Monta tela de interface com o usu�rio                                                   �
//�������������������������������������������������������������������������������������������
DEFINE FONT oFont NAME "Mono AS" SIZE 8,16 
DEFINE MSDIALOG oDlgExc FROM 000,000 TO 205,730 TITLE "Cancelamento de Orcamento"			PIXEL
@ 040,005 SAY "Motivo Cancel:"  OF oDlgExc 					PIXEL COLOR CLR_HBLUE
@ 040,050 MSGET cDesMot 	  	OF oDlgExc SIZE 250,006		PIXEL

ACTIVATE MSDIALOG oDlgExc CENTERED ON INIT EnchoiceBar( oDlgExc, { || nOpcA := 1, oDlgExc:End() }, { || nOpcA := 1, oDlgExc:End() },, aButtons )
//�����������������������������������������������������������������������������������������Ŀ
//� Grava os dados                                                                          �
//�������������������������������������������������������������������������������������������
If nOpcA == 1
	dbSelectArea( "SUA" )
	RecLock( "SUA", .F. )
		SUA->UA_X_MOT := CDESMOT
	MsUnLock("SUA")
EndIf

RestArea( aAreaAtu )
Return(.t.)
