#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MSE3440 Autor   ³ Luiz Alberto          ³ Data ³ 03/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Ponto de Entrada responsável por Ajustes na Base de Calculo
				   das comissões dos vendedores
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                                  ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function MSE3440()
Local aArea := GetArea()

/*If !Empty(SE1->E1_VEND1) .And. SE1->E1_VEND1 == SA3->A3_COD	// Processando Comissão do Primeiro Vendedor
	If SE3->E3_BASE <> SE1->E1_BASCOM1
		SE3->E3_BASE	:=	SE1->E1_BASCOM1
		SE3->E3_COMIS 	:=	ROUND((SE1->E1_BASCOM1 * SE1->E1_COMIS1)/100,2)
		SE3->E3_PORC	:=	SE1->E1_COMIS1
	Endif
ElseIf !Empty(SE1->E1_VEND2) .And. SE1->E1_VEND2 == SA3->A3_COD	// Processando Comissão do Segundo Vendedor
	If SE3->E3_BASE <> SE1->E1_BASCOM2
		SE3->E3_BASE	:=	SE1->E1_BASCOM2
		SE3->E3_COMIS 	:=	ROUND((SE1->E1_BASCOM2 * SE1->E1_COMIS2)/100,2)
		SE3->E3_PORC	:=	SE1->E1_COMIS2
	Endif
ElseIf !Empty(SE1->E1_VEND3) .And. SE1->E1_VEND3 == SA3->A3_COD	// Processando Comissão do Terceiro Vendedor
	If SE3->E3_BASE <> SE1->E1_BASCOM3
		SE3->E3_BASE	:=	SE1->E1_BASCOM3
		SE3->E3_COMIS 	:=	ROUND((SE1->E1_BASCOM3 * SE1->E1_COMIS3)/100,2)
		SE3->E3_PORC	:=	SE1->E1_COMIS3
	Endif
Endif */
RestArea(aArea)
Return .t.