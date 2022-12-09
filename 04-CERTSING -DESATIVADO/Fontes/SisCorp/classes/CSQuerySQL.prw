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
	data elapTime as numeric //Tempo total de execu��o da query
	
	method New() constructor   	//M�todo para iniciar a classe 
	method Consultar( cQuery ) 	//M�todo para consultar banco de dados
	method TotalRegistros()    	//M�todo para retornar o total de registros
	method GetAlias() 	       	//M�todo para retornar o total de registros
	method close()			   	//M�todo para fechar a �rea tempor�ria
	Method hasNext()		   	//M�todo para indicar se n�o � EOF
	Method getLineArray()		//Recupera a linha em um array
	Method getLineString(cSeparador)
	Method skip()
endClass

/*/{Protheus.doc} New
M�todo para inicializar a classe
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
M�todo para inicializar a classe
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
	Local nTimeIn 	:= 0	//Auxiliar para medi��o do tempo de execu��o
	Local nTimeOut 	:= 0	//Auxiliar para medi��o do tempo de execu��o

	default cQuery := ""  //Valor padr�o no caso vazio

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
		MsAguarde({|| dbUseArea( .T., 'TOPCONN', TCGENQRY(,, ::query), ::alias, .F., .T.), ::TotalRegistros()}, "Carregando dados", "Aguarde. Os dados est�o sendo carregados...")
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
M�todo que retorno total de registros da query executada
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
		cQueryTot := ChangeQuery( cQueryTot ) //Aplica a fun��o de melhorar a consulta para o banco Oracle

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
M�todo que retorna alias da tabela temporaria
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
M�todo que fecha a �rea tempor�ria
@type method 
@author Yuri Volpe
@since 15/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return logical - �rea fechada
/*/
Method close() Class CSQuerySQL as logical
Return (::alias)->(dbCloseArea())

/*/{Protheus.doc} hasNext
M�todo que retorna se h� outra linha para processar
@type method 
@author Yuri Volpe
@since 15/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return logical - existe pr�ximo registro
/*/
Method hasNext() Class CSQuerySQL as logical
Return (::alias)->(!EOF())

/*/{Protheus.doc} skip
M�todo que chama internamente o dbSkip usando o Alias da Classe
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
M�todo que retorna a linha do ponteiro para dentro de uma dimens�o de array.
Foi concebido desta forma para permitir que m�ltiplas linhas sejam capturadas
no retorno da fun��o dentro do mesmo array multidimensional. Ou seja, o retorno
� aLinha[1][n].

@type method 
@author Yuri Volpe
@since 15/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return array - array de 1 dimens�o com os dados dos campos resultantes da query
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

	// Vai para a pr�xima linha do resultado da query
	::skip()

Return aLinha

/*/{Protheus.doc} getLineString
M�todo que retorna a linha do ponteiro para uma string separada por caractere.
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

	DEFAULT cSeparador 	:= CHR(9)	// Separador padr�o TAB
	DEFAULT lQuebra		:= .T.		// Indica se deve quebrar a linha ao final da string

	// Para cada campo de retorno da query
	For Ni := 1 To (::alias)->(FCount())

		// Captura o dado temporariamente
		xDado := (::alias)->(FieldGet(Ni))

		// Trata convers�o do dado para Caractere
		If Valtype(xDado) != "C"
			xDado := cValToChar(xDado)
		Else
			xDado := AllTrim(xDado)
		EndIf

		// Separa o dado do pr�ximo pelo separador informado
		cLinha += xDado + cSeparador
	Next

	// Quebra a linha
	If lQuebra
		cLinha += CHR(13) + CHR(10)
	EndIf

	// Pula a linha j� processada
	::skip()

Return cLinha
