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
	data elapTime as numeric //Tempo total de execução da query
	
	method New() constructor   	//Método para iniciar a classe 
	method Consultar( cQuery ) 	//Método para consultar banco de dados
	method TotalRegistros()    	//Método para retornar o total de registros
	method GetAlias() 	       	//Método para retornar o total de registros
	method close()			   	//Método para fechar a área temporária
	Method hasNext()		   	//Método para indicar se não é EOF
	Method getLineArray()		//Recupera a linha em um array
	Method getLineString(cSeparador)
	Method skip()
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
	local lSQL 		:= .F. //Variavel se verdadeira informa que a consulta deu certo
	Local nTimeIn 	:= 0	//Auxiliar para medição do tempo de execução
	Local nTimeOut 	:= 0	//Auxiliar para medição do tempo de execução

	default cQuery := ""  //Valor padrão no caso vazio

	//Se parametro for vazio sai da rotina
	if empty(cQuery)
		return lSQL
	endif
	
	//Carrega dados para a classe
	::query := cQuery //Carrega string de query
	::alias := getNextAlias() //Pega proximo alias liberado
	::query := ChangeQuery( ::query ) //Executa query de ajuste da query para o banco Oracle

	//Consulta banco de dados e monta tabela temporaria
	nTimeIn := Time()
	If !isBlind()
		MsAguarde({|| dbUseArea( .T., 'TOPCONN', TCGENQRY(,, ::query), ::alias, .F., .T.), ::TotalRegistros()}, "Carregando dados", "Aguarde. Os dados estão sendo carregados...")
	Else
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, ::query), ::alias, .F., .T.)
	EndIf
	nTimeOut := Time()

	//Grava o tempo decorrido, em segundos
	::elapTime := nTimeOut - nTimeIn

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

/*/{Protheus.doc} GetAlias
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

/*/{Protheus.doc} close
Método que fecha a área temporária
@type method 
@author Yuri Volpe
@since 15/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return logical - área fechada
/*/
Method close() Class CSQuerySQL as logical
Return (::alias)->(dbCloseArea())

/*/{Protheus.doc} hasNext
Método que retorna se há outra linha para processar
@type method 
@author Yuri Volpe
@since 15/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return logical - existe próximo registro
/*/
Method hasNext() Class CSQuerySQL as logical
Return (::alias)->(!EOF())

/*/{Protheus.doc} skip
Método que chama internamente o dbSkip usando o Alias da Classe
@type method 
@author Yuri Volpe
@since 15/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return logical - conseguiu pular a linha
/*/
Method skip() Class CSQuerySQL as logical
Return (::alias)->(dbSkip())

/*/{Protheus.doc} getLineArray
Método que retorna a linha do ponteiro para dentro de uma dimensão de array.
Foi concebido desta forma para permitir que múltiplas linhas sejam capturadas
no retorno da função dentro do mesmo array multidimensional. Ou seja, o retorno
é aLinha[1][n].

@type method 
@author Yuri Volpe
@since 15/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return array - array de 1 dimensão com os dados dos campos resultantes da query
/*/
Method getLineArray() Class CSQuerySQL as array

	Local aLinha 	:= {}
	//Local aTmp 		:= {}
	Local Ni 		:= 0

	// Alimenta um array para cada campo da query
	For Ni := 1 To (::alias)->(FCount())
		aAdd(aLinha, (::alias)->(FieldGet(Ni)))
	Next

	// Devolve um array estruturado
	//aAdd(aLinha, aTmp)

	// Vai para a próxima linha do resultado da query
	::skip()

Return aLinha

/*/{Protheus.doc} getLineString
Método que retorna a linha do ponteiro para uma string separada por caractere.
@type method 
@author Yuri Volpe
@since 15/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return string - dados concatenados da linha processada
/*/
Method getLineString(cSeparador, lQuebra) Class CSQuerySQL as string

	Local cLinha		:= ""
	Local Ni			:= 0
	Local xDado			:= Nil

	DEFAULT cSeparador 	:= CHR(9)	// Separador padrão TAB
	DEFAULT lQuebra		:= .T.		// Indica se deve quebrar a linha ao final da string

	// Para cada campo de retorno da query
	For Ni := 1 To (::alias)->(FCount())

		// Captura o dado temporariamente
		xDado := (::alias)->(FieldGet(Ni))

		// Trata conversão do dado para Caractere
		If Valtype(xDado) != "C"
			xDado := cValToChar(xDado)
		Else
			xDado := AllTrim(xDado)
		EndIf

		// Separa o dado do próximo pelo separador informado
		cLinha += xDado + cSeparador
	Next

	// Quebra a linha
	If lQuebra
		cLinha += CHR(13) + CHR(10)
	EndIf

	// Pula a linha já processada
	::skip()

Return cLinha
