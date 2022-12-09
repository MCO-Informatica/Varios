#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � RPCPR006  �Autor  � Derik Santos      � Data �  18/10/2016  ���
��������������������������������������������������������������������������͹��
���Desc.     � Rotina para cria��o do lote automatico na SC2               ���
��������������������������������������������������������������������������͹��
���Uso       � Protheus 12 - Prozyn                                        ���
��������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������͹��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function RPCPE006()

Local _aSavSC2		:= SC2->(GetArea())
Local _cProd	 	:= RTRIM(SC2->C2_PRODUTO)
Local _cRastro 		:= Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_RASTRO")
Local _cLote  		:= ""
Local _cLotepa 		:= ""
Local _cLoteok 		:= ""

If _cRastro == "L"
	dbSelectArea("SX6")
	dBSetOrder(1)
		If dBSeek(xfilial("SX6") +"MV_LOTEOP")
			_cLote:= alltrim(SX6->X6_CONTEUD)     //resultado do par�metro
			_cLotepa := SOMA1(_cLote)
			_cLoteok := SUBSTR(_cLotepa,1,10)
                                                     
			Reclock("SX6",.F.)
			SX6->X6_CONTEUD := _cLoteok
			msUnLock()
		Endif

		dbSelectArea("SC2")
		
		If SC2->C2_NUM==M->C2_NUM
			Reclock("SC2",.F.)
				SC2->C2_LOTECTL := _cLotepa
			SC2->(MsUnlock())
		EndIf		
Endif

Return(_cLotepa)
