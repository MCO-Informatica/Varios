#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���P.Entrada �MTA120G2  �Autor  �Vitor Raspa                �Data  � 20.Jun.08���
�����������������������������������������������������������������������������Ĵ��
���Descri�ao � Ponto de Entrada executado apos a gravacao de cada item do     ���
���          � pedido de compra                                               ���
�����������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                         ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function MTA120G2()
Local lExecute := IsInCallStack( "MATA177" ) .And. IsInCallStack( "A177GrvDist" )
Local aArea    := GetArea()
Local aAreaSC5 := SC5->( GetArea() )
Local aAreaSC6 := SC6->( GetArea() )
                                                 
//--Tratamento para inclusao do pedido de compra:
//--Quando a inclus�o do pedido de compra estiver sendo
//--realizada atraves da CENTRAL DE COMPRAS, verIfica se trata-se
//--de um "Documento de Previsao de Entrada".
//--Caso seja um documento de previsao de entrada, vincula o pedido
//--de compra ao pedido de venda que originou este documento.
If lExecute
	If SC6->( FieldPos('C6_PEDCOM') ) > 0 .And. SC6->( FieldPos('C6_ITPC') ) > 0
		SC6->( DbSetOrder(2) ) //--C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM
		If SC6->( DbSeek( SC5->C5_FILIAL + SC7->C7_PRODUTO + SC5->C5_NUM ) )
			RecLock( 'SC6', .F. )
			SC6->C6_PEDCOM := SC7->C7_NUM
			SC6->C6_ITPC   := SC7->C7_ITEM
			SC6->( MsUnLock() )
		EndIf
	EndIf
EndIf

//--Restaura o ambiente
RestArea( aArea )
RestArea( aAreaSC5 )
RestArea( aAreaSC6 )
Return