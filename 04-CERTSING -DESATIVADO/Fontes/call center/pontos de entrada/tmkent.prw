//------------------------------------------------------------------
// Rotina | TMKENT  | Autor | Robson Luiz - Rleg | Data | 07/08/2012
//------------------------------------------------------------------
// Descr. | Ponto de entrada acionado para adicionar entidades no 
//        | relacionamento.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function TmkEnt()
	Local cCpo := ""
	Local aParam := {}
	Local cEntidade := ""
	Local nOrdEnt := 0
	Local nTipo := 0
	
	If Type("ParamIXB")=="A"
		aParam := AClone( ParamIXB )
		If Len( aParam ) > 0
			cEntidade := aParam[ 1 ]
			nOrdEnt := aParam[ 2 ]
			nTipo := aParam[ 3 ]
		Endif
	Endif	
	//-----------------------------------------------------------
	// Rotina localizada no arquivo de programa fonte CSFA010.prw
	//-----------------------------------------------------------
	If cEntidade == "SZT"
		cCpo := U_FA10TMKENT( cEntidade )
	Elseif cEntidade == "SZX"
		cCpo := U_FA50TMKENT( cEntidade )
	Elseif cEntidade == 'PAB'
		cCpo := U_FA160TMKENT( cEntidade )
	ElseIf cEntidade == "SZ3"
		cCpo := U_SDKTMKENT( cEntidade, nTipo )
	Endif
Return(cCpo)