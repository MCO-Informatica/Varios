#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA650POK  �Autor  � Daniel Salese    � Data �  16/03/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para validar Gera��o da OP - Pedido Venda ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Verquimica                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA650POK()

Local cMark	    := PARAMIXB[2]
Local aPV		:= {}
Local nX		:= 0
Local lOkay	    := .T.

dbSelectArea( "SC5" )
SC5->( dbSetOrder(1) )

While SC6->( !Eof() .And. SC6->C6_OK == cMark )
	If SC5->( MsSeek( xFilial( "SC5" ) + SC6->C6_NUM ) )
		If Ascan( aPV, SC6->C6_NUM  ) == 0
			If SC5->C5_VQ_LIBF$"S"
				lOkay := .T.
			Else
				lOkay := U_VERQUICRED(SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_NUM)
			EndIf
			
			Aadd( aPV, SC6->C6_NUM )

			If !lOkay
				Exit
			EndIf
		EndIf
	EndIf
	SC6->( dbSkip() )
Enddo

Return( lOkay )