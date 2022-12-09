#Include 'Protheus.ch'

User Function gcSVSZJ()
	Local _cRetorno 
	
	
	IF Alltrim(M->ZJ_TPSERV) == 'AD'
		_cRetorno := 'ADMINISTRACAO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'CE'
		_cRetorno := 'COORDENACAO DE ENGENHARIA'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'CP'
		_cRetorno := 'COORDENACAO DE CONTRATO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'CR'
		_cRetorno := 'COMPRAS'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'DC'
		_cRetorno := 'OUTROS DOCUMENTOS'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'DI'
		_cRetorno := 'DILIGENCIAMENTO / INSPECAO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'DT'
		_cRetorno := 'DETALHAMENTO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'EE'
		_cRetorno := 'ESTUDO DE ENGENHARIA'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'EX'
		_cRetorno := 'EXPEDICAO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'LB'
		_cRetorno := 'TESTE DE LABORATORIO / PILOTO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'MDB'
		_cRetorno := 'COMPRAS'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'CR'
		_cRetorno := 'MANUAL / DATABOOK'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'OP'
		_cRetorno := 'OPERACOES'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'PB'
		_cRetorno := 'PROJETO BASICO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'SC'
		_cRetorno := 'SERICO DE CAMPO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'TR'
		_cRetorno := 'TESTE DE LABORATORIO / PILOTO'
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'VA'
		_cRetorno := 'VERIFICACAO / APROVACAO'	
	ELSEIF  Alltrim(M->ZJ_TPSERV) == 'VD'
		_cRetorno := 'VENDAS'	
	ENDIF
		


Return _cRetorno
