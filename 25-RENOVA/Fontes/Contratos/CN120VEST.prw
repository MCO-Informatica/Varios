#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120VEST ºAutor  ³Gileno Pereira        Data ³  Fev/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Não permite exclusão de medição de arrendamento se o tituloº±±
±±º          ³ a pagar estiver em recuperação Judicial                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120VEST()

Local _lRet  := := IIF(FunName() == 'CNTA120',PARAMIXB[1],.T.)//PARAMIXB[1] subsitituido pro andre
Local _aArea := GetArea()
Local cData  

If _lRet .And. !Empty(CND->CND_XTITPG) //Pego numero do titulo do cabeçalho da medição
	dbSelectArea("SE2")
	dbSetOrder(1)
	If dbSeek(xFilial("SE2") + CND->CND_XTITPG)
		While (xFilial("SE2") + CND->CND_XTITPG == SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA))
			cData:= dtos(SE2->E2_DATALIB)
			If !Empty(SE2->E2_DATALIB)   
				_lRet := .T.  //Data preenchida
			Else
				_lRet := .F.  //Data em Branco
			EndIF
					
			If !_lRet //se não foi liberado
				Aviso("Atenção!!!","Esse título encontra-se em Recuperação Judicial, portanto a medição não poderá ser estornada.",{"Ok"})
				Exit
			EndIf
			SE2->(dbSkip())
		EndDo
	EndIf
EndIf

RestArea(_aArea)
Return(_lRet)
