#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MT996CPCOF� Autor � Romay Oliveira     � Data �  06/2015     ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na apuracao de pis/cofins para carregar	  ���
���				campo no titulo SE2										  ���
���																		  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico Renova		                                      ���
�������������������������������������������������������������������������͹��
���Obs		 �Inova Solution											  ���
�������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������*/ 

User Function MT996CPCOF()

Local cAlias	:= PARAMIXB[1]   

(cAlias)->E2_E_APUR	:= mv_par23  // data da apuracao


Return .T.  

