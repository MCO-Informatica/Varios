#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    �Matatec   � Entrada para alimentar automaticamente os valores t�cnicos   ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 20.04.07 � Robson                                                       ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 20.04.07 � Robson Bueno                                                 ���
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
User Function MatAtec(cCodigo)

Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
LOCAL cDesComp :=Space(255)
LOCAL cNor1
LOCAL cNor2
LOCAL cNor3
												// Inicializa o retorno
DbSelectArea("SB1")
dbSetOrder(1)
If MsSeek(xfilial("SB1")+cCodigo) .and. SB1->B1_XDETEV=""   
   
    cNor1:=SB1->B1_XMATCOP
    cNor2:=SB1->B1_XDIMENS
    cNor3:=SB1->B1_XACBFAC
      
    DbSelectArea("SX5")
    dbSetOrder(1)
    If MsSeek(xFilial("SX5")+"Z4"+cNor1)      
        cDesComp:=RTRIM(cDesComp) + "" + SX5->X5_DESCRI
    ENDIF    
    If MsSeek(xFilial("SX5")+"ZE"+cNor2)      
        cDesComp:=RTRIM(cDesComp) + " - " + SX5->X5_DESCRI
    ENDIF
    If MsSeek(xFilial("SX5")+"ZC"+cNor3)      
        cDesComp:=RTRIM(cDesComp) + " - " + SX5->X5_DESCRI
    ENDIF        
    
    

ELSE
   cDesComp:= SB1->B1_XDETEV
ENDIF
cDesComp:=SUBSTR(cDesComp,1,254)
RestArea(aAreaAtu)
Return(cDesComp)
