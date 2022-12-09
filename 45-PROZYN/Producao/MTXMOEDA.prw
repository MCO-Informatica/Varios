#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTXMOEDA  �Autor  �Leonardo Ibelli    � Data �  28/06/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �  ponto de entrada na taxa da moeda para convers�o	      ���
�������������������������������������������������������������������������͹��
���Uso       � AP12 -Prozyn                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
  
 User Function MTXMOEDA()
 
 Local _nVlrConv
 
 If FUNNAME() == "MATA460A" .OR. FUNNAME() == "MATA461" //.And. (Procname(3)=="MA410LBNFS" .Or. Procname(3)=="A460ACUMIT")

 	dbselectArea("SC5")
 	If SC5->C5_TXREF>0 .And. PARAMIXB[2]==SC5->C5_MOEDA// .And. PARAMIXB[3]==1 .And. Procname(3)<>"MANFS2FIN"
 		_nVlrConv := PARAMIXB[1]*SC5->C5_TXREF
 	ElseIf SC5->C5_TXREF>0 .And. PARAMIXB[2]==1 .And. PARAMIXB[3]==SC5->C5_MOEDA //.And. Procname(3)=="MANFS2FIN"
 		_nVlrConv := PARAMIXB[8]*SC5->C5_TXREF
 	EndIf
 	
  EndIf

 Return (_nVlrConv)