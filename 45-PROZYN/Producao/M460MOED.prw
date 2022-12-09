#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460MOED    �Autor  �Isaque O. da Silva� Data �  10/02/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para manipular a moeda do t�tulo quando   ���
���          � exporta��o, gerando em moedas 2                         	  ���
���          �                                                       	  ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������͹��
���Uso       � Protheus 12                          	                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M460MOED

Local cMoedaTit := PARAMIXB    // Array passado pela fun��o chamadora do PE {cFilial,Codigo do chamado associado}
                                                                               
 If FUNNAME() == "MATA460A" .OR. FUNNAME() == "MATA461" //.And. (Procname(3)=="MA410LBNFS" .Or. Procname(3)=="A460ACUMIT")
 
 	dbselectArea("SC5")
 	If SC5->C5_TIPOCLI='X'
 		cMoedaTit := "S" 
 	Else
 		cMoedaTit := "N" 
 	EndIf
  EndIf	   

Return(cMoedaTit)