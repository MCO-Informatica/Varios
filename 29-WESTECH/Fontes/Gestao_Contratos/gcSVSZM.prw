#Include 'Protheus.ch'

User Function gcSVSZM()
Local _cRetorno 
	
	
	IF Alltrim(M->ZM_TPSERV) == 'AD'
		_cRetorno := 'ADMINISTRACAO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'CE'
		_cRetorno := 'COORDENACAO DE ENGENHARIA'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'CP'
		_cRetorno := 'COORDENACAO DE CONTRATO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'CR'
		_cRetorno := 'COMPRAS'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'DC'
		_cRetorno := 'OUTROS DOCUMENTOS'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'DI'
		_cRetorno := 'DILIGENCIAMENTO / INSPECAO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'DT'
		_cRetorno := 'DETALHAMENTO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'EE'
		_cRetorno := 'ESTUDO DE ENGENHARIA'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'EX'
		_cRetorno := 'EXPEDICAO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'LB'
		_cRetorno := 'TESTE DE LABORATORIO / PILOTO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'MDB'
		_cRetorno := 'COMPRAS'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'CR'
		_cRetorno := 'MANUAL / DATABOOK'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'OP'
		_cRetorno := 'OPERACOES'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'PB'
		_cRetorno := 'PROJETO BASICO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'SC'
		_cRetorno := 'SERICO DE CAMPO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'TR'
		_cRetorno := 'TESTE DE LABORATORIO / PILOTO'
	ELSEIF Alltrim(M->ZM_TPSERV) == 'VA'
		_cRetorno := 'VERIFICACAO / APROVACAO'	
	ELSEIF Alltrim(M->ZM_TPSERV) == 'VD'
		_cRetorno := 'VENDAS'	
	ENDIF
		


Return _cRetorno

