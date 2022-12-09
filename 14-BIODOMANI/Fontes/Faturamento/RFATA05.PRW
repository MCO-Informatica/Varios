#include "totvs.ch"
#include "rwmake.ch"
#Include "Protheus.Ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

User Function RFATA05()

	If SC5->C5_X_SEPAR$"S"
		//If MsgYesNo("O pedido "+SC5->C5_NUM+" já foi separado no dia "+DTOC(SC5->C5_X_DTSEP)+". Deseja separar novamente?","Separa Pedido Novamente?")
		//	cQuery := "UPDATE SC5010 SET C5_X_SEPAR = 'S', C5_X_DTSEP = '"+DTOS(dDataBase)+"' WHERE C5_NUM = '"+SC5->C5_NUM+"' "
		//	TCSQLExec(cQuery)
		//Else
		MsgStop("Separação já foi realizada para esse pedido!!!")
		//EndIf
	Else

		if empty(sc5->c5_nota)
			MsgAlert("Este pedido não foi faturado !!!")
		elseif sc5->c5_x_armaz != "01A1"
			//MsgAlert("Este pedido não pertence ao armazem 01A1 !!!")
			cQuery := "UPDATE SC5010 SET C5_X_SEPAR = 'S', C5_X_DTSEP = '"+DTOS(dDataBase)+"' WHERE C5_NUM = '"+SC5->C5_NUM+"' "
			TCSQLExec(cQuery)
			MsgAlert("Separação atualizada com sucesso!!!")
		else
			sf2->(dbsetorder(1))
			if sf2->(dbseek(xfilial()+sc5->c5_nota+sc5->c5_serie))
				if u_resta11a()
					cQuery := "UPDATE SC5010 SET C5_X_SEPAR = 'S', C5_X_DTSEP = '"+DTOS(dDataBase)+"' WHERE C5_NUM = '"+SC5->C5_NUM+"' "
					TCSQLExec(cQuery)
					MsgAlert("Separação atualizada com sucesso!!!")
				else
					MsgAlert("Finalização não será feita, pois separação ainda não foi completamente realizada!!!")
				endif
			else
				MsgAlert("Este pedido não foi faturado !!!")
			endif
		endif
	EndIf


Return nil
