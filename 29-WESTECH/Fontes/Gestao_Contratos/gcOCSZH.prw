#Include 'Protheus.ch'

User Function gcOCSZH()

	Local _cRetorno 
	
	
	IF Alltrim(M->ZH_TIPO) == 'CTG'
		_cRetorno := 'CONTINGENCIAS'
	ELSEIF Alltrim(M->ZH_TIPO) == 'FNC'
		_cRetorno := 'FIANCAS'
	ELSEIF Alltrim(M->ZH_TIPO) == 'CFI'
		_cRetorno := 'CUSTO FINANCEIRO'
	ELSEIF Alltrim(M->ZH_TIPO) == 'PGT'
		_cRetorno := 'PROVISAO DE GARANTIA'
	ELSEIF Alltrim(M->ZH_TIPO) == 'RTY'
		_cRetorno := 'ROYALTY'
	ELSEIF Alltrim(M->ZH_TIPO) == 'CVD'
		_cRetorno := 'COMISSAO DE VENDA'
	ELSEIF Alltrim(M->ZH_TIPO) == 'PIP'
		_cRetorno := 'PERDA DE IMPOSTOS'
	ENDIF
	
Return _cRetorno

