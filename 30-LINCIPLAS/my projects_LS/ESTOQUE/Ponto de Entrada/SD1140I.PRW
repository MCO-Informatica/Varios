#INCLUDE "Protheus.ch"	

/*
+================================================================+
|Programa: SD1140I |Autor: Antonio Carlos |Data: 03/02/09        |
+================================================================|
|Descricao: PE executado na gravação da Pré-Nota para "zerar"    |
o campo percentual de desconto nas NF's enviadas para Coligadas. |
+================================================================+
|Uso: Especifico Laselva                                         |
+================================================================+
*/                                                                

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SD1140I()
///////////////////////
      
Local aArea		:= GetArea()

If SM0->M0_CODFIL $ ("A0/A1/A2/A3/BH/C0/C1/C2/C3/C4/C5/C6/C7/C8/C9/CA/CB/CC/CD/CE/CF/G1/G2/G3/G4/G5/G6/G7/G8/GA/GB/GC/GD/GE/GF/GG/R0/R1/R2/R3/R4/R5/T1/T2/T3/T4/K0/K1/K2/K3/K4/K5/K6/K7/K8/K9/K0/KA")

	DbSelectArea("SA2")
	SA2->( DbSetOrder(1) )
	DbSeek( xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA )
	If Substr(SA2->A2_CGC,1,8) == "53928891"
		RecLock("SD1",.F.)	
		SD1->D1_DESC 	:= 0
		SD1->D1_VALDESC := 0
		MsUnLock()
	EndIf
                 	
ElseIf SM0->M0_CODFIL $ "01/55"
	
	DbSelectArea("SA2")
	SA2->( DbSetOrder(1) )
	DbSeek( xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA )
	If Substr(SA2->A2_CGC,1,8) $ GetMv("MV_CNPJCOL")
		RecLock("SD1",.F.)	
		SD1->D1_DESC 	:= 0
		SD1->D1_VALDESC := 0
		MsUnLock()	
	EndIf
	    	
EndIf	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////   ROTINA PARA RESERVA E TRANSFERENCIA DAS REVISTAS IMPORTADAS PARA O ESTOQUE DO SAC - FILIAL 20 QUANDO HOUVER RESERVA DE ASSINATURAS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//U_SZRReser()

Return()