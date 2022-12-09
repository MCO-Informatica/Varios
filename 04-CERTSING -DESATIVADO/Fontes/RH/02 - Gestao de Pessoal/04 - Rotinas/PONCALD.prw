#include 'rwmake.ch'
#include 'TopConn.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PONCALD   �Autor  �Microsiga           � Data �  01/04/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Muda verba XXX para YYY no calculo mensal do ponto          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Ponto De Entrada Calculo Mensal ponto                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PONCALD()

Local c_PDANT 	:= {"433","447","409"} //Verbas de desconto originais do calculo
Local a_Area	:= GetArea()
Local xz		:= 0
Local n_HorFalta := 0
Local n_HorAtras := 0

//����������������������������������������Ŀ
//�Somente Estagiarios Horistas/Mensalistas�
//������������������������������������������
If SRA->RA_CATFUNC $ "E/G"
	For xz := 1 to Len(c_PDANT)
		dbSelectArea("SPB")
		dbSetOrder(2)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + c_PDANT[xz] + Dtos(dDataFim))
			If SPB->PB_PD $ "433/447"
				n_HorAtras += SPB->PB_HORAS
			Else
				n_HorFalta += SPB->PB_HORAS
			EndIf
			//Deleta as verbas que o sistema calculou
			RecLock("SPB",.F.)
			dbDelete()
			SPB->(MsUnlock())
		Endif
	Next xz

	//����������������������������������������Ŀ
	//�Gera a nova Verba                       �
	//������������������������������������������
	If n_HorAtras > 0
		If !dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "903" + Dtos(dDataFim))
			RecLock("SPB",.T.)
			SPB->PB_FILIAL		:= SRA->RA_FILIAL
			SPB->PB_MAT			:= SRA->RA_MAT
			SPB->PB_PD			:= "903"
			SPB->PB_DATA		:= dDataFim
			SPB->PB_HORAS		:= n_HorAtras
			SPB->PB_CC			:= SRA->RA_CC
			SPB->PB_TIPO1		:= "H"
			SPB->PB_TIPO2		:= "G"
			SPB->(MsUnlock())
		Endif
	Endif

	If n_HorFalta > 0
		If !dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "902" + Dtos(dDataFim))
			RecLock("SPB",.T.)
			SPB->PB_FILIAL		:= SRA->RA_FILIAL
			SPB->PB_MAT			:= SRA->RA_MAT
			SPB->PB_PD			:= "902"
			SPB->PB_DATA		:= dDataFim
			SPB->PB_HORAS		:= n_HorFalta
			SPB->PB_CC			:= SRA->RA_CC
			SPB->PB_TIPO1		:= "H"
			SPB->PB_TIPO2		:= "G"
			SPB->(MsUnlock())
		Endif
	Endif
Endif

RestArea(a_Area)

Return
