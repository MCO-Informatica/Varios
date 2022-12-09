#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CSQuerySQL
Classe para facilitar a consulta SQL no banco de dados
@type class 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
class CSQuerySQL
	data query as string  //String com query para executar no banco de dados
	data alias as string  //Alias para navegar na consulta SQL
	data total as numeric //Total de registro na query consultada
	
	method New() constructor 	  //Metodo para iniciar a classe 
	method Consultar( cQuery ) //Método para consultar banco de dados
	method TotalRegistros() 	  //Método para retornar o total de registros
	method GetAlias() 	  //Método para retornar o total de registros
endClass

/*/{Protheus.doc} New
Método para inicializar a classe
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return class - classe CSQuerySQL
/*/
method New() class CSQuerySQL as object
	//Inicializa variaveis
	::query := "" 
	::alias := ""
	::total := 0
return self

/*/{Protheus.doc} Consultar
Método para inicializar a classe
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@param cQuery [ string, Query para consultar banco de dados]
@return logic - Se verdadeiro, a consulta realizada com sucesso
/*/
method Consultar( cQuery ) class CSQuerySQL as logical
	local lSQL := .F. //Variavel se verdadeira informa que a consulta deu certo

	default cQuery := ""  //Valor padrão no caso vazio

	//Se parametro for vazio sai da rotina
	if empty(cQuery)
		return .F.
	endif
	
	//Carrega dados para a classe
	::query := cQuery //Carrega string de query
	::alias := getNextAlias() //Pega proximo alias liberado
	::query := ChangeQuery( ::query ) //Executa query de ajuste da query para o banco Oracle

	//Consulta banco de dados e monta tabela temporaria
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, ::query), ::alias, .F., .T.)

	//Verifica se ha dados na tabela temporaria
	if select( ::alias ) > 0
		//Se a tabela temporaria existir retorna que a consulta foi feita com sucesso 
		if ( ::alias )->( !EoF() )
			lSQL := .T. 
		else
			( ::alias )->( dbCloseArea() )
			::alias := ""
		endif
	endif
return( lSQL )

/*/{Protheus.doc} TotalRegistros
Método que retorno total de registros da query executada
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return numeric - total de registros
/*/
method TotalRegistros() class CSQuerySQL as numeric
	local cQueryTot := "" //Query para pegar total de registros
 	local cAliasTot := getNextAlias() //Alias da tabela temporaria do total registros

 	//Reinicia o valor de registros
	::total := 0

	//Verifica se ha dados na tabela temporaria
	if select( ::alias ) > 0 .and. !empty( ::alias )
		cQueryTot := " SELECT COUNT(*) COUNT FROM ( " + ::query + " ) QUERY " //Pega a query e prepara outra query fazendo o total
		cQueryTot := ChangeQuery( cQueryTot ) //Aplica a função de melhorar a consulta para o banco Oracle

		//Monta tabela temporaria
		dbUseArea( .T., "TOPCONN", TCGENQRY( , ,cQueryTot ), cAliasTot, .F., .T.)
		
		//Se a tabela existir, pega o total de registros
		if select( ::alias ) > 0
			::total := ( cAliasTot )->COUNT
			( cAliasTot )->( dbCloseArea() )
		endif
	endif
return ::total

/*/{Protheus.doc} TotalRegistros
Método que retorna alias da tabela temporaria
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return numeric - total de registros
/*/
method GetAlias() class CSQuerySQL as string
return ::alias