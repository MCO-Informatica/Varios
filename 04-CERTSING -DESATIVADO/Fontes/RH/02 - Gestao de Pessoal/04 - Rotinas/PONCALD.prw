#include 'rwmake.ch'
#include 'TopConn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PONCALD   ºAutor  ³Microsiga           º Data ³  01/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Muda verba XXX para YYY no calculo mensal do ponto          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Ponto De Entrada Calculo Mensal ponto                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PONCALD()

Local c_PDANT 	:= {"433","447","409"} //Verbas de desconto originais do calculo
Local a_Area	:= GetArea()
Local xz		:= 0
Local n_HorFalta := 0
Local n_HorAtras := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente Estagiarios Horistas/Mensalistas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera a nova Verba                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
