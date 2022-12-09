#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 02/06/00
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A690GTRB � Autor � GERALDO SABIN         � Data � 13.07.15 ���
��������������a����������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para calculo da taxa de rendimento        ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/
USER FUNCTION A690GTRB()
IF !EMPTY(TRB->CTRAB)
	_aArea   :=GetArea()
	_aAreaSHB:=SHB->(GetArea())
	dBselectarea("SHB")
	dBsetOrder(1)
	IF dBseek(xFilial("SHB")+TRB->CTRAB)
		TRB->(Reclock("TRB",.F.))
		
		IF SHB->HB_REND > 0
		   TRB->TEMPAD := CONVTIME(NIL,(A690HoraCt(SG2->G2_TEMPAD * (1+(1-(SHB->HB_REND/100))))),NIL)    // BLAUECKE
		ENDIF
		
		TRB->(MsUnlock())
	ENDIF
	RestArea(_aAreaSHB)
	RestArea(_aArea)
ENDIF
Return
