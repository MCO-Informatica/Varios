#include 'protheus.ch'
#include 'parmtype.ch'

user function zGrCustAH()
	
	Local _cRetorno 
	
	if !alltrim(M->Z4_ITEMCTA)  $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")
		
		if alltrim(M->Z4_TAREFA) == "CE"
			_cRetorno := "Engenharia BR"
		elseif alltrim(M->Z4_TAREFA) == "EE"
			_cRetorno := "Engenharia BR"
		elseif alltrim(M->Z4_TAREFA) == "LB"
			_cRetorno := "Laboratorio" 
		elseif alltrim(M->Z4_TAREFA) == "PB"
			_cRetorno := "Engenharia BR" 
		elseif alltrim(M->Z4_TAREFA) == "DT"
			_cRetorno := "Engenharia BR"		
		elseif alltrim(M->Z4_TAREFA) == "DC"
			_cRetorno := "Engenharia BR"
		elseif alltrim(M->Z4_TAREFA) == "OU"
			_cRetorno := "Engenharia BR"
		elseif alltrim(M->Z4_TAREFA) == "DI"
			_cRetorno := "Inspecao / Diligenc."
		elseif alltrim(M->Z4_TAREFA) == "SC"
			_cRetorno := "Inspecao / Diligenc."
		else
			_cRetorno := "Contratos"
		endif
	else
		_cRetorno	:= SPACE(10)
	endif
	
Return _cRetorno