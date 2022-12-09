#Include 'Protheus.ch'

User Function gcOCSZI()
	Local _cRetorno 
	
	IF Alltrim(M->ZI_TIPO) == 'CTG'
		_cRetorno := 'CONTINGENCIAS'
	ELSEIF Alltrim(M->ZI_TIPO) == 'FNC'
		_cRetorno := 'FIANCAS'
	ELSEIF Alltrim(M->ZI_TIPO) == 'CFI'
		_cRetorno := 'CUSTO FINANCEIRO'
	ELSEIF Alltrim(M->ZI_TIPO) == 'PGT'
		_cRetorno := 'PROVISAO DE GARANTIA'
	ELSEIF Alltrim(M->ZI_TIPO) == 'RTY'
		_cRetorno := 'ROYALTY'
	ELSEIF Alltrim(M->ZI_TIPO) == 'COM'
		_cRetorno := 'COMISSAO DE VENDA'
	ELSEIF Alltrim(M->ZI_TIPO) == 'PIP'
		_cRetorno := 'PERDA DE IMPOSTOS'
	ENDIF
	
Return _cRetorno
