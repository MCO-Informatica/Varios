#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � AF036POC � Autor � Geraldo Sabino        � Data � 14/02/2019 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada Grava os campos de Contabiliza��o = Branco   ��
���          * quando Rateio                                                ���
���������������������������������������������������������������������������Ĵ��
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

User Function AF036POC

_aAreaSN4 := SN4->(GetArea())

dBSelectarea("SN4")
dBSetOrder(4)      // filial + base + item + tipo + ocorrencia + data
IF dbSeek(xFilial("SN4")+SN4->N4_CBASE+SN4->N4_ITEM+"01"+"06"+DTOS(SN4->N4_DATA),.T.)     
    _cChave := xFilial("SN4")+SN4->N4_CBASE+SN4->N4_ITEM+"01"+"06"+DTOS(SN4->N4_DATA)
	WHILE N4_FILIAL + N4_CBASE + N4_ITEM + N4_TIPO + N4_OCORR + DTOS(N4_DATA) == _cChave
		
		IF  SN4->N4_MOTIVO$"01".AND.SN4->N4_TIPOCNT='4' .AND. EMPTY(SN4->N4_NOTA)
			SN4->(Reclock("SN4",.F.))
			SN4->N4_LA   := " "
			SN4->(MSUnlock())
			Exit
		ENDIF
		
		dBSelectarea("SN4")
		dBSkip()
	Enddo
Endif

RestArea(_aAreaSN4)
Return



