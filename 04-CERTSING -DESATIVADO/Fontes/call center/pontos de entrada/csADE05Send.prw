#include "PROTHEUS.CH"
#include "TOPCONN.CH"

static cADE_KPROD := ""

//-----------------------------------------------------------------------
/*/{Protheus.doc} csADE05Send()
Este fonte tem por objetivo exibir uma Tela para o usuario selecionar  
o Grupo, Produto, Cod. Prod. Protheus, Cod.Prod. GAR, AR.

Tela do campo PRODUTO (ADE_KPROD), para ser exibido os dados da tabela ZZR.

@author	Douglas Parreja
@since	19/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csADE05Send()

	local cQuery, cRetQuery := ""
	private aRetTela := {}
	  
	//----------------------	
	// Valida Upd/Ambiente
	//----------------------
	lOk := u_csCheckUpd()
	
	if lOk	
		cQuery 		:= csQuery()
		cRetQuery 	:= u_csADE03xFun( 1, cQuery )
		csProcess( cRetQuery )	
	endif

return .T.

//-----------------------------------------------------------------------
/*/{Protheus.doc} csProcess()
Funcao responsavel por realizar o processamento dos dados da Query 
passado como parametro e chamar funcao de exibicao da Tela.

@param	cRetQuery	Retorno da Query realizada.

@author	Douglas Parreja
@since	13/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csProcess( cRetQuery )

	local cCabecalho 	:= "Dados Produto x Grupo"
	local aDados		:= {} 
	
	default cRetQuery	:= "" 
	
	if !empty( cRetQuery )
	
		while !(cRetQuery)->( eof() )
			(cRetQuery)->( aAdd(aDados, { ;
											alltrim(ZZR_ITEM)	,;	//1-Item
											alltrim(ZZR_CDGAR)	,;	//2-Cod. GAR
											alltrim(ZZR_DESC)	,;	//3-Descricao
											alltrim(ZZR_GRUPO)	,;	//4-Grupo
											alltrim(ZZR_CDPROD)	,; 	//5-Cod. Produto
											alltrim(ZZR_AR)		,;	//7-AR
											alltrim(ZZR_AC)		,;	//8-AC
											alltrim(ZZR_CODTAB) }))	//9-Cod. Tabela Produto X SZ3(Z3_CODTAB)
			(cRetQuery)->( dbSkip() )
		end
		(cRetQuery)->(dbCloseArea())		
	
		//----------------------------------------
		// Montagem da Tela
		//----------------------------------------
		if len( aDados ) > 0
			u_csADE03xFun( 4, cCabecalho, aDados )						
		endif
				
	else
		MsgInfo('Não foi possível encontrar registros de produtos e/ou Não foi preenchido o campo Grupo.', cCabecalho)
	endif


return

//---------------------------------------------------------------
/*/{Protheus.doc} csQuery
Funcao responsavel para realizar a Query na tabela ZZR.
						  			  
@return	cQuery		Retorna a String da Query a ser processada.						

@author	Douglas Parreja
@since	19/07/2016
@version 11.8
/*/
//---------------------------------------------------------------
static function csQuery()

	local cQuery := ""
	
	cQuery := " SELECT 
	cQuery += " ZZR_ITEM,						"
	cQuery += " ZZR_CDPROD,						"
	cQuery += " ZZR_DESC,   					"
	cQuery += " ZZR_GRUPO, 						"
	cQuery += " ZZR_CDGAR,						"
//	cQuery += " ZZR_VALOR,						"
	cQuery += " ZZR_AR,							"
	cQuery += " ZZR_AC,							"
	cQuery += " ZZR_CODTAB						"
	cQuery += " FROM " +RetSqlName("ZZR")+" ZZR	"
	cQuery += " WHERE "
	cQuery += " ZZR.D_E_L_E_T_= ' '				" 
	//cQuery += " ORDER BY ZZR_ITEM ASC 			"
	cQuery += " ORDER BY ZZR_GRUPO, ZZR_DESC ASC 			"
	
return (cQuery)

//---------------------------------------------------------------
/*/{Protheus.doc} csADE05Receive
Funcao responsavel para retornar no padrao SXB.
						  			  
@return	cQuery		Retorna caracter do campo a ser exibido.						

@author	Douglas Parreja
@since	19/07/2016
@version 11.8
/*/
//---------------------------------------------------------------
user function csADE05Receive()
return (cADE_KPROD)

//Renato Ruy - 28/10/2017
//Atualiza dados do campo
User Function csADEKPROD(cDado)
	cADE_KPROD := cDado
Return