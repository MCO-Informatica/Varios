#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA103BUT  �Autor  � Junior Carvalho    � Data � 12/06/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � INCLUSAO DE BOTOES NA ENTRADA DE NOTA FISCAL (MATA103)     ���
�������������������������������������������������������������������������͹��
���Uso       � Incluir botao na Entrada de Nota Fiscal para selecionar    ���
���          � romaneios em aberto                                        ���
�������������������������������������������������������������������������ͼ��

Alterado de MA103BUT para MX103BUT, pois a CentralXM, usa esse PE e na rotina 
deles ser� chamado esse fonte. 

�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MX103BUT()
LOCAL aBotao := {}

IF INCLUI .or. l103Class
	AAdd( aBotao , { "BUDGET", { || U_ERPRATFRT() } , "Rateio Frete" } )	
ENDIF

RETURN(aBotao)
