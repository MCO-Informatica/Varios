#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
 ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ MTAGRSD4 ³ Autor ³ Adriano Leonardo    ³ Data ³ 11/11/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada após a gravação dos empenhos, utilizado   º±±
±±º          ³ para gravar dados complementares (tipo de balança).        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MTAGRSD4()

Local _aSavArea := GetArea()
Local _aSavSB1	:= SB1->(GetArea())
Local _cRotina	:= "MTAGRSD4"
Local _cBalanc	:= "N" //Nenhuma

dbSelectArea("SB1")
dbSetOrder(1)
If SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))
	If SB1->B1_UM=="KG"
		If SD4->D4_QUANT < 5
			_cBalanc := "1" //Balança 1
		ElseIf SD4->D4_QUANT < 15
			_cBalanc := "2" //Balança 2
		Else
			_cBalanc := "S" //Silo
		EndIf
	EndIf
EndIf

RecLock("SD4",.F.)
	SD4->D4_BALANCA := _cBalanc
SD4->(MsUnlock())
     
//----------------- Força o preenchimento do campo C2_BATCH para não excluir a OP quando o empenho for incluído manualmente.
//dbSelectArea("SC2")
//dbSetOrder(1)
//If SB1->(dbSeek(xFilial("SC2")+SD4->D4_OP))
//	RecLock("SC2",.F.)
//	SC2->C2_BATCH := "S"
//Endif

RestArea(_aSavSB1)
RestArea(_aSavArea)

Return()