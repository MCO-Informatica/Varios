#Include "Protheus.ch"
User Function MA440COR()
    Local aCores := ParamIXB 
    Local aRet := {}
    Local nY as numeric

	Aadd(aRet,{ "Alltrim(C5_XBLQFIN) == 'B' "					,'BR_VIOLETA'	,'Blq. Financeiro'	})
	Aadd(aRet,{ "Alltrim(C5_XBLQMRG) == 'S' "					,'BR_PINK'		,'Blq. Margem'		})
	Aadd(aRet,{ "U_VerifyBlq(C5_NUM,'CRED') "					,'BR_PRETO'		,'Blq. de Crédito'	})
	Aadd(aRet,{ "U_VerifyBlq(C5_NUM,'EST') "					,'BR_MARROM'	,'Blq. de Estoque'	})
	// Aadd(aRet,{ "Alltrim(C5_XBLQMIN) == 'S' "					,'CLR_HCYAN'	,'Blq. Preço Mínimo'})
    
	For nY:=1 to Len(aCores)
		Aadd(aRet,aClone(aCores[nY]))
	Next nY

Return aRet

