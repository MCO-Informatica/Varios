#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MA410COR		�Autor  �Microsiga	     � Data �  14/02/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera��o da cor da legenda do pedido de venda			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410COR() 

	Local aCores	:= ParamIxb
	Local aRet		:= {}
	Local nY		:= 0

	Aadd(aRet,{ "Alltrim(C5_XBLQFIN) == 'B' "					,'BR_VIOLETA'	,'Blq. Financeiro'	})
	Aadd(aRet,{ "Alltrim(C5_XBLQMRG) == 'S' "					,'BR_PINK'		,'Blq. Margem'		})
	Aadd(aRet,{ "U_VerifyBlq(C5_NUM,'CRED') "					,'BR_PRETO'		,'Blq. de Cr�dito'	})
	Aadd(aRet,{ "U_VerifyBlq(C5_NUM,'EST') "					,'BR_MARROM'	,'Blq. de Estoque'	})
	// Aadd(aRet,{ "Alltrim(C5_XBLQMIN) == 'S' "					,'CLR_HCYAN'	,'Blq. Pre�o M�nimo'})

	For nY:=1 to Len(aCores)
		Aadd(aRet,aClone(aCores[nY]))
	Next nY	
Return aRet
