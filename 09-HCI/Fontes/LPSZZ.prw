#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � LPSZZ    � Ponto de entrada para alimentar produtos pelo codigo antigo  ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 20.03.07 � Robson                                                       ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 20.03.07 � Robson Bueno                                                 ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � ??.??.?? - Nome - Descri��o                                             ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function LPSZZ(cCodigo)

Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.														// Inicializa o retorno
DbSelectArea("SZZ")
dbSetOrder(2)
  If MsSeek(xFilial("SZZ")+M->B1_COD)
    DO WHILE !BOF()
        IF SZZ->ZZ_STATUS!='X' 
          RecLock( "SZZ",.F. )
    	  SZZ->ZZ_STATUS:='X'
          MsUnLock()
        ENDIF
        DBSKIP(-1)
    ENDDO    
  ENDIF
// Restaura a integridade dos dados

RestArea(aAreaAtu)

Return(cCodigo)
