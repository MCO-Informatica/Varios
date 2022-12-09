#include 'Protheus.ch'
#include 'Parmtype.ch'
/* ARMAZENA O CODIGO CORRESPONDENTE EM _cRegiao DE ACORDO COM O ESTADO DIGITADO EM A1_EST. SERVE DE REGRA PARA O GATILHO DOMINIO É A1_EST E CONTRA-DOMINIO A1_REGIAO 
User Function RFATG03()

local _cRegiao := ""

//-> REGIAO NORTE
IF M->A1_EST$"'AC','AP','AM','PA','RO','RR','TO'"
	_cRegiao := "001"

//-> REGIAO NORDESTE
ElseIf M->A1_EST$"'AL','BA','CE',''MA','PB','PE','PI','RN','SE'"
	_cRegiao := "002"

//-> REGIAO CENTRO-OESTE
ElseIf M->A1_EST$"'GO','MT','MS'"
	_cRegiao := "003"

//-> REGIAO SUDESTE
ElseIf M->A1_EST$"'ES','MG,'SP,'RJ'"
	_cRegiao := "004"

//-> REGIAO CENTRO SUL
ElseIf M->A1_EST$"'PR','SC','RS'"
	_cRegiao := "005"

//-> REGIAO EXTERIOR
ElseIf M->A1_EST$"'EX'"
	_cRegiao := "006"

EndIf


Return(_cRegiao)
