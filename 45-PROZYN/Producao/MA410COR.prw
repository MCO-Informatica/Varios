#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMA410COR		บAutor  ณMicrosiga	     บ Data ณ  14/02/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera็ใo da cor da legenda do pedido de venda			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA410COR() 

	Local aCores	:= ParamIxb
	Local aRet		:= {}
	Local nY		:= 0

	Aadd(aRet,{ "Alltrim(C5_XBLQFIN) == 'B' "					,'BR_VIOLETA'	,'Blq. Financeiro'	})
	Aadd(aRet,{ "Alltrim(C5_XBLQMRG) == 'S' "					,'BR_PINK'		,'Blq. Margem'		})
	Aadd(aRet,{ "U_VerifyBlq(C5_NUM,'CRED') "					,'BR_PRETO'		,'Blq. de Cr้dito'	})
	Aadd(aRet,{ "U_VerifyBlq(C5_NUM,'EST') "					,'BR_MARROM'	,'Blq. de Estoque'	})
	// Aadd(aRet,{ "Alltrim(C5_XBLQMIN) == 'S' "					,'CLR_HCYAN'	,'Blq. Pre็o Mํnimo'})

	For nY:=1 to Len(aCores)
		Aadd(aRet,aClone(aCores[nY]))
	Next nY	
Return aRet
